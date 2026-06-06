---
--- Created by zhouzhipeng.
--- DateTime: 2024/8/21 下午1:45
---

EquipMaster = {}
local this = {}

EquipMasterType = {
    -- cfg_equip_master表type字段
    STRENGTHEN_LV = 1, -- 强化等级
    APPEND_LV = 2, -- 追加等级

    -- cfg_equip_master表count字段
    TOTAL_LEVEL = 0, -- 0：计算部位总和等级
    POS_LEVEL = 1, --1：计算每个部位等级

}

--- 装备锻造大师变量
EquipMasterVariable = {
    EQUIP_MASTER_CACHE = "G$strength_master_cache", -- 装备大师缓存
    STRENGTH_MASTER_ATTR = "strengthMasterAttr", -- 强化大师属性
    APPEND_MASTER_ATTR = "appendMasterAttr", -- 追加大师属性
    EQUIP_MASTER_DATA = "T$大师数据",
}

-- 脱穿需要重新计算强化和追加   转移  也需要
-- 强化与追加 分别触发强化大师与追加大师

-- 脱穿触发锻造大师
function EquipMaster.triggerEquipMaster(actor)
    EquipMaster.strengthMaster(actor)
    EquipMaster.appendMaster(actor)
end

-- 装备转移触发锻造大师
function EquipMaster.transferTrigger(actor, equip1, equip2, ts, ta)
    local equipindex1 = equip1.equipindex
    local equipindex2 = equip2.equipindex

    if tonumber(equipindex1) == 0 or tonumber(equipindex2) == 0 then
        return
    end

    if ts and ta then
        -- 转移强化触发强化大师
        EquipMaster.strengthMaster(actor)
        -- 转移追加触发追加大师
        EquipMaster.appendMaster(actor)
    elseif ts then
        -- 转移强化触发强化大师
        EquipMaster.strengthMaster(actor)
    elseif ta then
        -- 转移追加触发追加大师
        EquipMaster.appendMaster(actor)
    end
end

--- 触发强化触发大师
function EquipMaster.strengthMaster(actor)
    EquipMaster.print("strengthMaster actor:" .. actor:toString() .. "触发强化大师开始")
    local equips = getputonequipinfo(actor)
    if next(equips) == nil then
        return
    end
    local masterCache = getsysvar(actor, EquipMasterVariable.EQUIP_MASTER_CACHE)
    local strengthCache = masterCache[EquipMasterType.STRENGTHEN_LV]
    --EquipMaster.print("strengthMaster actor:" .. actor:toString() .. "强化大师缓存数据", strengthCache)
    if table.isNullOrEmpty(strengthCache) then
        error("strengthMaster actor:" .. actor:toString() .. "强化大师缓存为空")
        --EquipMaster.print("strengthMaster actor:" .. actor:toString() .. "强化大师缓存为空")
        return
    end
    --EquipMaster.print("strengthMaster actor:" .. actor:toString() .. "穿戴的装备数据", equips)
    local strengthData = {}
    for _, equip in pairs(equips) do
        local id = equip.id
        local equipData = EquipAndAppear.getItemExtData(actor, id)
        if table.notEmpty(equipData) then
            local idxOfEquip = gameequip.wearBar(equip.equipindex)
            if idxOfEquip == 1 then
                local strengthlv = equipData.strengthlv or 0
                local pos = gameequip.pos(equip.equipindex)
                if pos == 3 then
                    strengthData[1] = strengthlv
                    strengthData[2] = strengthlv
                else
                    strengthData[pos] = strengthlv
                end
                --local equipName = ConfigDataManager.getTableValue("cfg_item", "name", "id", equip.cfgid)
                --strengthData1[pos] = {pos = pos, strengthlv = strengthlv, cfgId = equip.cfgid, equipName = equipName}
            end
        end
    end
    if next(strengthData) == nil then
        --EquipMaster.print("strengthMaster actor:" .. actor:toString() .. "没有强化数据", {})
        return
    end
    EquipMaster.print("strengthMaster actor:" .. actor:toString() .. ", 强化table数据\n", strengthData)
    local config
    for group, cfgs in pairs(strengthCache) do
        -- group 遍历
        local isSuccess = false
        for _, cfg in ipairs(cfgs) do
            local lv = tonumber(cfg.lv)
            local str = cfg.strpartid
            local posTab = string.split(str, "#")
            local count = tonumber(cfg.count)
            if count == EquipMasterType.TOTAL_LEVEL then
                -- 0：计算部位总和等级
                local total = 0
                for _, pos in pairs(posTab) do
                    local strengthLv = strengthData[tonumber(pos)]
                    if strengthLv ~= nil then
                        total = total + strengthLv
                    end
                end
                -- EquipMaster.print("strengthMaster actor:" .. actor:toString() .. ", total:" .. tostring(total) .. ", lv:" .. tostring(lv))
                if total < lv then
                    break
                end
                config = cfg
                --EquipMaster.print("strengthMaster actor:" .. actor:toString() .. " count == 0 满足的配置添加 group:\n" .. tostring(group), cfg)
            elseif count == EquipMasterType.POS_LEVEL then
                -- 1：计算每个部位等级
                for _, pos in pairs(posTab) do
                    local strengthLv = strengthData[tonumber(pos)]
                    if strengthLv == nil or strengthLv < lv then
                        isSuccess = true
                        break
                    end
                end
                if isSuccess then
                    break
                end
                config = cfg
                --EquipMaster.print("strengthMaster actor:" .. actor:toString() .. " count == 1 满足的配置添加 group:" .. tostring(group), cfg)
            else
                error("strengthMaster actor:" .. actor:toString() .. "暂时不支持改类型计算：" .. tostring(count))
                EquipMaster.print("strengthMaster actor:" .. actor:toString() .. "暂时不支持改类型计算：" .. tostring(count), {})
            end
        end
    end


    if config == nil then
        -- 清空属性
        addrolekmlattributes(actor, EquipMasterVariable.STRENGTH_MASTER_ATTR , {})
        --EquipMaster.print("strengthMaster actor:" .. actor:toString() .. "没有符合的强化大师配置：")
        return
    end

    local career = getbaseinfo(actor, "getbasecareer")
    local attStr = config.att
    local attrAddRate = string.toIntIntMap4Career(career, attStr, "#", "|")
    addrolekmlattributes(actor, EquipMasterVariable.STRENGTH_MASTER_ATTR , attrAddRate)
    --ZzpTest.print("测试查看属性","玩家", actor:toString(), getbaseinfo(actor, "rolename"), "config.id", config.id,"大师属性attrAddRate", attrAddRate)
    --EquipMaster.print("strengthMaster actor:" .. actor:toString() .. "符合的强化大师配置：\n", config)
end

--- 触发追加大师
function EquipMaster.appendMaster(actor)
--[[
    EquipMaster.print("appendMaster actor:" .. actor:toString() .. "触发追加大师开始")
    local equips = getputonequipinfo(actor)
    if next(equips) == nil then
        return
    end
    local masterCache = getsysvar(actor, EquipMasterVariable.EQUIP_MASTER_CACHE)
    local appendCache = masterCache[EquipMasterType.APPEND_LV]
    EquipMaster.print("appendMaster actor:" .. actor:toString() .. "追加缓存数据", appendCache)
    if table.isNullOrEmpty(appendCache) then
        error("appendMaster actor:" .. actor:toString() .. "追加大师缓存为空")
        EquipMaster.print("appendMaster actor:" .. actor:toString() .. "追加大师缓存为空")
        return
    end
    --EquipMaster.print("appendMaster actor:" .. actor:toString() .. "穿戴的装备数据", equips)
    local allLuaItemExtData = EquipAndAppear.getLuaItemExtData(actor)
    if next(allLuaItemExtData) == nil then
        EquipMaster.print("appendMaster actor:" .. actor:toString() .. "没有强化追加数据")
        return
    end
    --EquipMaster.print("appendMaster actor:" .. actor:toString() .. "强化追加lua存的数据数据\n", itemExtData)
    local appendData = {}
    local baseEquips = {}
    for _, equip in pairs(equips) do
        local id = equip.id
        local equipData = allLuaItemExtData[id]
        if equipData ~= nil then
            local idxOfEquip = gameequip.wearBar(equip.equipindex)
            if idxOfEquip == 1 then
                local appendlv = equipData.appendlv or 0
                local pos = gameequip.pos(equip.equipindex)
                appendData[pos] = appendlv
                table.insert(baseEquips, equip)
            end
        end
    end
    if next(appendData) == nil then
        -- 清空属性
        for _, equip in pairs(baseEquips) do
            local itemId = equip.id
            local itemExtData = allLuaItemExtData[itemId] or {}
            itemExtData.masterAppendAttr = {}
            allLuaItemExtData[itemId] = itemExtData
            EquipAndAppear.SetItemExtData(actor, itemId, itemExtData)
        end
        EquipAndAppear.setLuaItemExtData(actor, allLuaItemExtData)
        return
    end
    EquipMaster.print("appendMaster actor:" .. actor:toString() .. "追加数据:\n", appendData)
    local config
    for group, cfgs in pairs(appendCache) do
        -- group 遍历
        local isSuccess = false
        for _, cfg in ipairs(cfgs) do
            local lv = tonumber(cfg.lv)
            local str = cfg.strpartid
            local posTab = string.split(str, "#")
            local count = tonumber(cfg.count)
            if count == EquipMasterType.TOTAL_LEVEL then
                -- 0：计算部位总和等级
                local total = 0
                for _, pos in pairs(posTab) do
                    local appendLv = appendData[tonumber(pos)]
                    if appendLv ~= nil then
                        total = total + appendLv
                    end
                end
                --EquipMaster.print("appendMaster actor:" .. actor:toString() .. ", total:" .. tostring(total) .. ", lv:" .. tostring(lv))
                if total < lv then
                    break
                end
                config = cfg
                --EquipMaster.print("appendMaster actor:" .. " count == 0 满足的配置添加 group:" .. tostring(group), cfg)
            elseif count == EquipMasterType.POS_LEVEL then
                -- 1：计算每个部位等级
                for _, pos in pairs(posTab) do
                    local appendLv = appendData[tonumber(pos)]
                    if appendLv == nil or appendLv < lv then
                        isSuccess = true
                        break
                    end
                end
                if isSuccess then
                    break
                end
                config = cfg
                --EquipMaster.print("appendMaster actor:" .. " count == 1 满足的配置添加 group:" .. tostring(group), cfg)
            else
                error("appendMaster actor:" .. actor:toString() .. "暂时不支持改类型计算：" .. tostring(count))
                EquipMaster.print("appendMaster actor:" .. actor:toString() .. " 暂时不支持改类型计算：" .. tostring(count))
            end
        end
    end

    if config == nil then
        -- 清空属性
        for _, equip in pairs(baseEquips) do
            local itemId = equip.id
            local itemExtData = allLuaItemExtData[itemId] or {}
            itemExtData.masterAppendAttr = {}
            allLuaItemExtData[itemId] = itemExtData
            EquipAndAppear.SetItemExtData(actor, itemId, itemExtData)
        end
        EquipAndAppear.setLuaItemExtData(actor, allLuaItemExtData)
        EquipMaster.print("appendMaster actor:" .. actor:toString() .. " 没有符合的追加大师配置")
        return
    end

    local career = getbaseinfo(actor, "getbasecareer")
    local attStr = config.att
    local attrAddRate = string.toIntIntMap4Career(career, attStr, "#", "|")
    for _, equip in pairs(baseEquips) do
        local itemId = equip.id
        local attr_map = {}
        local itemExtData = allLuaItemExtData[itemId] or {}
        local remainAttr = itemExtData.remainAttr or {}
        if table.notEmpty(remainAttr) then
            for attrId, value in pairs(attrAddRate) do
                local val = remainAttr[attrId] or 0
                if val > 0 then
                    local addValue = val * value / 10000
                    attr_map[attrId] = (attr_map[attrId] or 0) + addValue
                end
            end
        end

        itemExtData.masterAppendAttr = attr_map
        allLuaItemExtData[itemId] = itemExtData
        EquipAndAppear.SetItemExtData(actor, itemId, itemExtData)
    end
    EquipAndAppear.setLuaItemExtData(actor, allLuaItemExtData)
    ]]
    --EquipMaster.print("appendMaster actor:" .. actor:toString() .. " 触发追加大师 结束添加的属性如下：\n", attr_map)
end

--- 缓存装备锻造大师数据
function EquipMaster.cacheEquipMasterData()
    -- 强化
    local strength = EquipMasterType.STRENGTHEN_LV
    local append = EquipMasterType.APPEND_LV
    local strengthTable = this.getMasterData(strength)
    -- 追加
    local appendTable = this.getMasterData(append)
    local cacheTable = {}
    cacheTable[strength] = strengthTable
    cacheTable[append] = appendTable
    setsysvar(EquipMasterVariable.EQUIP_MASTER_CACHE, cacheTable)
    info("cacheEquipMasterData 启动缓存装备锻造大师数据成功")
    EquipMaster.print("cacheEquipMasterData 缓存装备锻造大师数据：\n", cacheTable)
    return cacheTable
end

--- 获取装备锻造大师数据
function this.getMasterData (type)
    local masterList = ConfigDataManager.getTable("cfg_equip_master", "type", type)
    if masterList == nil then
        error("getMasterData cfg_equip_master锻造大师配置为空 type:" .. type)
        EquipMaster.print("getMasterData cfg_equip_master锻造大师配置为空 type:" .. type)
        return
    end

    local masterTable = {}
    for _, cfg in pairs(masterList) do
        local group = cfg.group
        local cfgs = masterTable[group] or {}
        table.insert(cfgs, cfg)
        masterTable[group] = cfgs
    end
    for _, cfgs in pairs(masterTable) do
        table.sort(cfgs, this.sortByLevel)
    end
    return masterTable
end

--- 计算大师加成属性
function this.calculateMasterAttr(attr_map, allAttr, number)
    local addition = number / 10000
    for attrId, value in pairs(allAttr) do
        local newValue = math.ceil(value * addition)
        attr_map[attrId] = newValue
    end
end

--- 根据类型获取穿戴的全部强化或追加属性
function this.getPropertiesByType(actor, type)
    local equiplist = getputonequipinfo(actor)
    local allattr = {}
    for _, equipinfo in pairs(equiplist) do
        local itemId = equipinfo.id
        local data = EquipAndAppear.getItemExtData(actor, itemId)
        if table.notEmpty(data) then
            if type == 1 then
                --将该装备的属性加到角色身上
                if data.strengthlv ~= nil then
                    local strengthattr = data.strengthattr
                    table.mergeAdd(allattr, strengthattr)
                end
            elseif type == 2 then
                if data.appendlv ~= nil then
                    local appendattr = data.appendattr
                    table.mergeAdd(allattr, appendattr)
                end
            end
        end
    end
    return allattr
end

--- 根据lv字段排序  自定义排序函数，根据lv字段排序
function this.sortByLevel(a, b)
    return tonumber(a.lv) < tonumber(b.lv)-- 升序排序
    -- 如果需要降序排序，则返回 a.lv > b.lv
end

--- 打印数据
function EquipMaster.printDetails(t, indent)
    if type(t) ~= 'table' then
        jprint(indent .. tostring(t))
        return
    end
    jprint(indent .. '{')
    indent = indent .. '  '
    for k, v in pairs(t) do
        if type(v) == 'table' then
            jprint(indent .. '[' .. tostring(k) .. '] =')
            EquipMaster.printDetails(v, indent)
        else
            jprint(indent .. '[' .. tostring(k) .. '] = ' .. tostring(v))
        end
    end
    jprint(indent:sub(1, string.len(indent) - 2) .. '}')
end

--- 打印日志
function EquipMaster.print(...)
    local isPrintLog = true
    if isPrintLog then
        return
    end
    jprint(...)
    local args = { ... }
    -- local var = table.cancat(args, ',')
    --local msg = string.format(...)
    --local count = select('#', ...)  -- 获取参数的数量
    --local first_arg = select(1, ...)  -- 获取第一个参数

    --if next(table) == nil then
    --    return
    --end
    --EquipMaster.printDetails(table, "")
end


-----------------------------------------------------------测试方法-------------------------------------------------------------

--- 测试方法
function equipmastertest(actor)
    jprint("equipmastertest actor:" .. actor:toString() .. "equipmastertest开始")
    --EquipMaster.cacheEquipMasterData()
    -- 打印缓存
    --EquipMaster.printDetails(getsysvar("G$strength_master_cache"), "")
    EquipMaster.strengthMaster(actor)
    EquipMaster.appendMaster(actor)
    --local masterCache = getsysvar(EquipMasterVariable.EQUIP_MASTER_CACHE)
    --local strengthCache = masterCache[1]
    --EquipMaster.printDetails(strengthCache, "")
    --jprint("equipmastertest actor:" .. actor:toString() .. "lua 存的强化数据")
    --local itemExtData = EquipAndAppear.getLuaItemExtData(actor)
    --EquipMaster.printDetails(itemExtData, "")
    --jprint("equipmastertest actor:" .. actor:toString() .. "已穿戴的装备数据")
    --local equips = getputonequipinfo(actor)
    --EquipMaster.printDetails(equips, "")

    local idx = 65538
    local aa = gameequip.wearBar(idx)
    local bb = gameequip.pos(idx)
    jprint("equipmastertest actor:" .. actor:toString() .. "equipmastertest结束 aa:" .. tostring(aa) .. " bb:" .. tostring(bb))

end

--- 测试方法
function cacheequipmasterdatatest(actor)
    jprint("cacheequipmasterdatatest actor:" .. actor:toString() .. "测试事件重新缓存")
    local cacheTable = EquipMaster.cacheEquipMasterData()
    EquipMaster.print("cacheequipmasterdatatest actor:", actor, "测试事件重新缓存数据:\n", cacheTable)
    -- EquipMaster.printDetails(strengthTable, "")
    jprint("cacheequipmasterdatatest actor:" .. actor:toString() .. "测试事件重新缓存成功")
end





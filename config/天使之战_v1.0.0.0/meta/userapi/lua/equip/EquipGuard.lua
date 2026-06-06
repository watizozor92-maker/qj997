---
--- Created by zhouzhipeng.
--- DateTime: 2024/8/15 上午9:18
---

EquipGuard = {}
local this = {}

--- 守护装备变量
EquipGuardVariable = {
    EQUIP_GUARD_HP = "T$守护装备血量",
    EQUIP_GUARD_SKILL = "T$守护装备添加的技能ID",-- 后续可以删除
    EQUIP_GUARD_DATA = "T$守护装备添加的数据",
    EQUIP_ACCUMULATOR = "T$accumulatedHp_%s",
    GUARD_ATTR = "guardAttr" -- 守护装备添加的属性
}

--- 守护特殊属性常量
GuardAbilityConst = {
    AUTO_PICK = 1, --  自动拾取
    EQUIP_SKILL = 2, -- 装备技能
}

--- 守护特殊属性常量
EquipGuardConst = {
    ITEM_CFG_ID = "itemCfgId",
    SKILL = "skill",
    ATT = "att",
}

---  穿戴触发守护装备
function EquipGuard.putGuardEquip (actor, itemCfgId)
    if this.isguardequip(itemCfgId) then
        return
    end
    -- jprint("putguardequip actor:" .. actor:toString() .. "，穿装触发 itemCfgId：" .. itemCfgId)

    -- 先清理在重新添加
    this.clearguarddata(actor)

    local guardEquip = this.getEquipGuardEG(actor);
    if guardEquip == nil then
        return
    end
    -- 获得已经穿戴的守护
    local guardList = ConfigDataManager.getTable("cfg_equip_guard", "id", itemCfgId)
    if guardList == nil or next(guardList) == nil then
        error("putguardequip actor:" ..actor:toString() .. " cfg_equip_guard配置为空 guardList等于nil或next(guardList) == nil itemCfgId:" .. itemCfgId)
        return
    end
    local guardCfg = guardList[1]

    local saveTable = {}
    saveTable[EquipGuardConst.ITEM_CFG_ID] = itemCfgId

    --  添加技能处理
    local ability = guardCfg["ability"]
    local abilityParameter = guardCfg["abilityparameter"]
    if tonumber(ability) == GuardAbilityConst.EQUIP_SKILL then
        if abilityParameter ~= nil and abilityParameter ~= "" then
            -- 添加技能
            local skillIds = string.split(abilityParameter, "#")
            -- jprint("putguardequip actor:" .. actor:toString() .. "，ability：" .. tostring(ability) .. "，abilityParameter：" .. tostring(abilityParameter))
            for _, skillId in pairs(skillIds) do
                -- jprint("putguardequip actor:" .. actor:toString() .. " 添加技能 skillId:" .. skillId)
                levelupskill(actor, skillId, 1)
            end
            --setplaydef(actor, EquipGuardVariable.EQUIP_GUARD_SKILL, skillIds)
            saveTable[EquipGuardConst.SKILL] = skillIds
        end
    end

    -- 加属性处理
    local attr_map = {}
    local stage = guardCfg["stage"]
    if stage ~= nil and stage ~= "" then
        local stageCfg = string.split(stage, "&")
        for _, value in pairs(stageCfg) do
            local str = string.split(value, "#")
            attr_map[str[1]] = str[2]
        end
        addrolekmlattributes(actor, EquipGuardVariable.GUARD_ATTR, attr_map)
        saveTable[EquipGuardConst.ATT] = attr_map
        -- this.printEG(actor, attr_map)
    end
    setplaydef(actor, EquipGuardVariable.EQUIP_GUARD_DATA, saveTable)
    -- jprint("putguardequip actor:" .. actor:toString() .. "，穿装触发 itemCfgId：" .. itemCfgId .. " 穿戴触发守护装备成功 stage:" .. stage .. "，abilityParameter：" .. abilityParameter)
end

--- 脱装触发守护装备
function EquipGuard.takeOffGuardEquip (actor, itemCfgId)
    -- jprint("takeoffguardequip actor:" .. actor:toString() .. "，脱装触发 itemCfgId：" .. itemCfgId)

    if this.isguardequip(itemCfgId) then
        return
    end
    -- 先清理在重新添加
    this.clearguarddata(actor)
    -- jprint("takeoffguardequip actor:" .. actor:toString() .. "，脱装触发 触发守护装备结束 itemCfgId：" .. itemCfgId)
end

--- 守护处理 初始化守护血量
function EquipGuard.initGuardEquip (actor, ids, cfgId, oldCount, newCount)
    local cfg_item = ConfigDataManager.getById("cfg_item", cfgId)
    if table.isNullOrEmpty(cfg_item) then
        error("initguardequip actor:" .. actor:toString() .. " ，cfg_item is null itemCfgId:" .. cfgId)
        return
    end
    if tonumber(cfg_item.subtype) ~= EquipSubType.GUARD or tonumber(cfg_item.type) ~= ItemType.EQUIP then
        -- 只处理守护装备
        return
    end

    -- this.printEG(ids)
   --[[
    for k, v in pairs(ids) do
        jprint("initguardequip 背包变化 变化的唯一id k:" .. tostring(k) .. " ，id:" .. tostring(v))
    end
    ]]

    -- 给道具绑定生命值
    if tonumber(newCount) < tonumber(oldCount) then
        -- todo 考虑丢弃、销毁
        -- this.removeguardhp(actor, ids)
        jprint("initguardequip actor:" .. actor:toString() .. " 背包变化 移除道具生命值 cfgId:" .. cfgId .. ",oldCount:" .. oldCount .. ",newCount:" .. newCount)
        return
    end
    local cfgHp = ConfigDataManager.getTableValue("cfg_equip_guard", "hp", "id", cfgId)
    if string.isNullOrEmpty(cfgHp) then
        error("initguardequip actor:" .. actor:toString() .. " ，cfg_equip_guard表配置 hp==nil itemCfgId:" .. cfgId)
        return
    end
    local tableHp = getplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP) or {}
    for _, id in pairs(ids) do
        local isAdd = true
        for _, value in pairs(tableHp) do
            local currId = value["id"]
            if currId == id then
                isAdd = false
            end
        end
        if isAdd then
            -- 新的唯一id，添加守护生命值
            local hp = { id = id, hp = cfgHp }
            table.insert(tableHp, hp)
            setplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP, tableHp)
            sendluamsg(actor, LuaMessageIdToClient.EQUIP_GUARD_RES, hp)
            -- jprint("initguardequip actor:" .. actor:toString() .. " 给道具添加守护血量 ，id:" .. tostring(id) .. ",cfgId:" .. cfgId .. ",设置血量hp:" .. cfgHp)
--[[
            for k, v in pairs(tableHp) do
                jprint("initguardequip actor:" .. actor:toString() .. " 打印个人存的全部守护血量信息 k:" .. tostring(k) .. " ，id:" .. tostring(v["id"]) .. ",hp:" .. tostring(v["hp"]))
            end
            ]]
        end
    end
    -- dayingtablehp(actor)

    -- jprint("initguardequip actor:" .. actor:toString() .. "背包变化 守护血量处理 cfgId:" .. cfgId .. ",subType:" .. subType .. ",oldCount:" .. oldCount .. ",newCount:" .. newCount)
end

--- 守护血量变化
function EquipGuard.guardHpChange (actor, targetHurt)
    -- jprint("guardhpchange actor：" .. actor:toString() .. " 守护血量变化 开始" .. "，玩家受到伤害：" .. targetHurt)

    -- if targetHurt == nil or targetHurt < 1 then
    --     return
    -- end
    local guardEquip = this.getEquipGuardEG(actor)
    if guardEquip == nil then
        return
    end
    local itemCfgId = guardEquip["cfgid"]
    local cfgHp = ConfigDataManager.getTableValue("cfg_equip_guard", "hp", "id", itemCfgId)
    if string.isNullOrEmpty(cfgHp) then
        cfgHp = "0"
    end
    if cfgHp == "0" then
        -- 无限血量无需扣血
        return
    end
    local tableHp = getplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP)
    if tableHp == nil then
        return
    end
    -- this.printEG(tableHp)
    local coefficient = ConfigDataManager.getTableValue("cfg_equip_guard", "coefficient", "id", itemCfgId)
    if coefficient == nil or coefficient == "" then
        coefficient = 10000
        -- error("guardhpchange actor:" .. actor:toString() .. "，守护生命值计算公式系数 coefficient==nil itemCfgId:" .. itemCfgId)
        -- jprint("guardhpchange actor:" .. actor:toString() .. "，守护生命值计算公式系数 coefficient==nil itemCfgId:" .. itemCfgId)
        -- return
    end
    -- local changeHp = tonumber(targetHurt) * (tonumber(coefficient) / 10000)
    local attackSpeed = getattrinfo(actor,"attackSpeedBonus")
    local originalHp = 1 / attackSpeed * (tonumber(coefficient) / 10000)
    local accumulatedHp = getplaydef(actor,string.format(EquipGuardVariable.EQUIP_ACCUMULATOR,guardEquip["id"])) or 0
    local newHp = accumulatedHp + originalHp
    if newHp < 1 then
        setplaydef(actor,string.format(EquipGuardVariable.EQUIP_ACCUMULATOR,guardEquip["id"]),newHp)
        return
    end
    local changeHp = math.floor(newHp)
    newHp = newHp - changeHp
    setplaydef(actor,string.format(EquipGuardVariable.EQUIP_ACCUMULATOR,guardEquip["id"]),newHp)
    -- jprint("guardhpchange actor:" .. actor:toString() .. "，扣血量:" .. changeHp .. "，守护生命值计算公式系数:" .. coefficient .. "，targetHurt:" .. targetHurt)
    local lid = guardEquip["id"]
    local toremove = {}
    local currHp = 0;-- 用于打印 销毁为0 扣血才显示当前血量
    for i, value in pairs(tableHp) do
        local id = value["id"]
        if id == lid then
            local hp = value["hp"]
            local results = hp - changeHp
            currHp = results
            if results > 0 then
                value["hp"] = results
                sendluamsg(actor, LuaMessageIdToClient.EQUIP_GUARD_RES, { id = id, hp = results })
                -- jprint("guardhpchange actor:" .. actor:toString() .. ",道具唯一id" .. tostring(lid) .. ",当前血量：" .. hp .. " ，剩余血量" .. results .. "，扣血量:" .. changeHp)
            else
                -- 销毁该装备
                -- 脱装  传穿戴拦索引
                -- this.printEG(actor, guardEquip)
                takeofftheequip(actor, guardEquip["equipindex"])
                -- 根据唯一id找背包索引
                local bagIdx = gainbagidxbyitemid(actor, lid)
                -- 通过背包索引删除该道具
                removeitembyidxlist(actor, { bagIdx }, 9999, '守护血量为0移除')
                info(actor, "玩家", actor, "守护血量为移除 守护id", itemCfgId, "cfgHp", cfgHp, "扣血量", changeHp, "当前血量", hp)
                -- 移除记录的道具
                table.insert(toremove, i)
                -- 累加器计数置为零
                setplaydef(actor,string.format(EquipGuardVariable.EQUIP_ACCUMULATOR,lid),0)
                -- jprint("guardhpchange actor:" .. actor:toString() .. ",道具唯一id" .. tostring(lid) .. ",当前血量：" .. hp .. " ，剩余血量" .. results .. "，扣血量:" .. changeHp)
            end
        end
    end
    for _, v in pairs(toremove) do
        table.remove(tableHp, v)
    end
    setplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP, tableHp)
    -- jprint("guardhpchange actor:" .. actor:toString() .. ", 剩余血量：" .. currHp .. "，执行完成 扣血量:" .. changeHp .. "，守护生命值计算公式系数:" .. coefficient .. "，targetHurt:" .. targetHurt)
    --this.printEG(tableHp)
end

--- 登录发送所有守护信息
function EquipGuard.login (actor)
    local tableHp = getplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP) or ""
    sendluamsg(actor, LuaMessageIdToClient.EQUIP_GUARD_ALL_RES, tableHp)
end



-- ===================================this分隔线==========================================================

--- 获取守护装备
function this.getEquipGuardEG (actor)
    local equips = getputonequipinfo(actor)
    if equips == nil then
        return
    end
    for _, equip in pairs(equips) do
        if tonumber(equip["subtype"]) == EquipSubType.GUARD then
            -- jprint("getEquipGuardEG 找到守护装备 ,cfgId:" .. tostring(cfgId) .. ",subType:" .. tostring(subType))
            return equip
        end
    end
    return nil;
end

--- 道具移除或丢弃 守护血量信息删除
function this.removeguardhp (actor, ids)
    local tableHp = getplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP) or {}
    local toremove = {}
    for _, id in pairs(ids) do
        for i, value in pairs(tableHp) do
            local currId = value["id"]
            if id == currId then
                -- 累加器计数置为零
                setplaydef(actor,string.format(EquipGuardVariable.EQUIP_ACCUMULATOR,currId),0)
                table.insert(toremove, i)
            end
        end
    end
    for _, v in pairs(toremove) do
        table.remove(tableHp, v)
    end
    setplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP, tableHp)
    -- jprint("removeguardhp actor:" .. actor:toString() .. " 移除血量信息成功 ,ids:" .. tostring(ids))
end

--- 清理守护数据
function this.clearguarddata(actor)
    -- 新存的数据
    local equipGuardData = getplaydef(actor, EquipGuardVariable.EQUIP_GUARD_DATA)
    if equipGuardData ~= nil and next(equipGuardData) ~= nil then
        local skills = equipGuardData[EquipGuardConst.SKILL]
        if skills ~= nil and next(skills) ~= nil then
            removeskill(actor, skills)
            -- jprint("clearguarddata 移除技能成功 actor:" .. actor:toString() .. " ,移除技能成功 skills:" .. tostring(skills))
        end

    end

    addrolekmlattributes(actor, EquipGuardVariable.GUARD_ATTR, {})
    setplaydef(actor, EquipGuardVariable.EQUIP_GUARD_DATA, {})
    -- jprint("clearguarddata 清理成功 属性清空 actor:" .. actor:toString() .. " ,移除技能成功 skills:" .. tostring(skills))
end

function this.isguardequip(itemCfgId)
    local subType = ConfigDataManager.getTableValue("cfg_item", "subType", "id", itemCfgId)
    if subType == nil then
        error("isguardequip ，subType==nil itemCfgId:" .. itemCfgId)
        return true
    end
    local subType = tonumber(subType)
    if subType ~= EquipSubType.GUARD then
        -- jprint("isguardequip 不是守护装备 subType:" .. subType)
        return true
    end
    return false
end

-- ===================================测试函数分隔线==========================================================


--- 测试方法
function equipguardtest(actor)
    -- 设置当前穿戴的装备血量为1
    local guardEquip = this.getEquipGuardEG(actor)
    if guardEquip then
        local id = guardEquip["id"]
        local tableHp = getplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP)
        if tableHp then
            for k, v in pairs(tableHp) do
                if id == v["id"] then
                    v["hp"] = 1
                    break
                end
            end
            setplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP, tableHp)
        end
    end
    -- setplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP, {})
    jprint("测试守护 equipguardtest actor:" .. actor:toString() .. "  处理成功 结束")
end

--- 测试方法 打印守护血量
function dayingtablehptest(actor)
    local tableHp = getplaydef(actor, EquipGuardVariable.EQUIP_GUARD_HP)
    if tableHp == nil then
        jprint("dayingtablehp actor:" .. actor:toString() .. " 打印守护血量 tableHp等于nil:")
        return
    end
    if tableHp then
        for k, v in pairs(tableHp) do
            jprint("dayingtablehp actor:" .. actor:toString() .. " 打印守护血量 k:" .. tostring(k) .. " ，id:" .. tostring(v["id"]) .. ",hp:" .. tostring(v["hp"]))
        end
    end
end
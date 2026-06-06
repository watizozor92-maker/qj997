EquipAndAppear = {}
local this = {}

---玩家装备信息记录
local ROLE_EQUIP_INFO_RECORDE = "T$role_equip_info_recorde"
local ROLE_EQUIP_STRENGTH_TIMES = "T$role_equip_strength_times"

EquipAndAppear.RecordeType = {
    ---全身最大强化等级
    MAX_STRENGTH_LEVEL = 1,
    ---全身最大追加等级
    MAX_APPEND_LEVEL = 2,
    ---全身最大卓越词条数量
    MAX_ENTRY_COUNT = 3,
    ---全身最大首饰等级
    MAX_JEWELRY_LEVEL = 4
}

---装备信息记录数据结构
function this.GetNewEquipInfoRecorde()
    local recorde = {
        ---全身最大强化等级
        max_strength_level = 0,
        ---全身最大追加等级
        max_append_level = 0,
        ---全身最大卓越词条数量
        max_entry_count = 0,
        ---全身最大首饰等级
        max_jewelry_level = 0
    }
    return recorde
end

function EquipAndAppear.login(actor)

end

function this.checkEquipData(actor, allData, itemId)
    local equipData = allData[tonumber(itemId)]
    if not equipData then
        return false
    end
    if equipData.strengthlv ~= 0 then
        return true
    end
    if equipData.appendlv ~= 0 then
        return true
    end
    local equip = getequipinfo(actor, itemId, 1)

    if table.count(equip.entries) > 2 then
        return true
    end
    return false
end

function EquipAndAppear.GetEquipInfoRecorde(actor)
    local equipInfoRecorde = getplaydef(actor, ROLE_EQUIP_INFO_RECORDE)
    if equipInfoRecorde == nil then
        equipInfoRecorde = this.GetNewEquipInfoRecorde()
    end
    return equipInfoRecorde
end

function this.SaveEquipInfoRecorde(actor, equipInfoRecorde)
    setplaydef(actor, ROLE_EQUIP_INFO_RECORDE, equipInfoRecorde)
end

-- 保存角色外观(幻化也走这个方法)
function EquipAndAppear.settingequipappear(actor, msgData)
    local equipappear = msgData["equipindex"]
    local isUpdateView = msgData["isUpdateView"]
    local data = {}
    for _, value in pairs(equipappear) do
        local pos = tonumber(value["slot"])
        local cfgId = tonumber(value["cfgId"])
        if pos ~= nil then
            data[pos] = cfgId
        end
    end
    setitemappeardata(actor, data)
    sendluamsg(actor, LuaMessageIdToClient.RES_SETTING_EQUIP_APPEAR, data)

    if isUpdateView then
        local alldata = this.buildPlayerEquipView(actor)
        sendrefluamsg(actor, LuaMessageIdToClient.OTHER_ROLE_APPEAR, alldata)
    end
end

-- 初始化角色外观
function initequipppear(actor)
    local equipappear = {}
    setplaydef(actor, "T$equipappear", equipappear)
end

--获取角色外观
function EquipAndAppear.getequipappear(actor, msgId)
    local data = getrolefield(actor, "role.roleappear.appear")
    if data == nil then
        return
    end
    local result = {}
    for key, value in pairs(data) do
        local appear = {}
        appear["slot"] = key
        appear["cfgId"] = value
        table.insert(result, appear)
    end
    --发送lua消息到客户端
    if LuaMessageIdToSever.GET_EQUIP_APPEAR == msgId then
        sendluamsg(actor, LuaMessageIdToClient.GET_EQUIP_APPEAR, result)
    end
    return result
end

-- 外观幻化激活
function EquipAndAppear.equipfashion(actor, msgData)
    local cfgIds = msgData["cfgIds"]
    local equipFashion = getplaydef(actor, "T$equipfashion")
    if equipFashion == nil then
        equipFashion = {}
    end
    for _, cfgId in pairs(cfgIds) do
        local isExist = table.contains(equipFashion, cfgId)
        if isExist then
            --存在已激活的
            return
        end
    end
    --计算所有消耗
    local allData = getAllEquipAppearCost(cfgIds, 4)
    if allData == nil then
        return
    end
    --检查背包是否道具充足
    local enough = Bag.checkItemEnough(actor, allData)
    if enough == false then
        return
    end
    --扣材料
    for _, v in ipairs(allData) do
        local cId = v["cfgid"]
        local count = v["count"]
        removeitemfrombag(actor, cId, count, 0, 9999, "装备外观")
    end
    --保存幻化
    for _, v in pairs(cfgIds) do
        table.insert(equipFashion, v)
    end
    setplaydef(actor, "T$equipfashion", equipFashion)
    sendluamsg(actor, LuaMessageIdToClient.RES_ACT_EQUIP_FASHION, equipFashion)
end

--获取已激活外观
function EquipAndAppear.getallequipfashion(actor)
    local equipFashion = getplaydef(actor, "T$equipfashion")
    sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_FASHION, equipFashion)
end

--激活染色
function EquipAndAppear.actquipcolor(actor, msgData)
    local cfgIds = msgData["cfgIds"]
    local color = msgData["color"]
    --计算消耗材料
    local allCost = getAllEquipAppearCost(cfgIds, 5)
    if allCost == nil then
        return
    end
    --检查背包是否道具充足
    local enough = Bag.checkItemEnough(actor, allCost)
    if enough == false then
        return
    end
    --扣材料
    for _, v in ipairs(allCost) do
        local cId = v["cfgid"]
        local count = v["count"]
        removeitemfrombag(actor, cId, count, 0, 9999, "装备外观")
    end
    --染色
    local equipcolor = EquipAndAppear.getequipcolor(actor, 0)
    for i, v in ipairs(cfgIds) do
        local num = 0
        for _, val in pairs(equipcolor) do
            if val["cfgid"] == v then
                table.insert(val["color"], color)
                num = num + 1
                break
            end
        end
        if num == 0 then
            local dt = {}
            dt["cfgid"] = v
            dt["color"] = {}
            table.insert(dt["color"], color)
            table.insert(equipcolor, dt)
        end
    end
    setplaydef(actor, "actequipcolor", equipcolor)
end

-- 保存染色
function EquipAndAppear.settingequipcolor(actor, msgData)
    local cfgId = msgData["cfgid"]
    local color = msgData["color"]
    --先校验是否激活该颜色
    local actequipcolor = getplaydef(actor, "T$actequipcolor")
    local bool = false
    for _, v in pairs(actequipcolor) do
        local cId = v["cfgid"]
        if cId == cfgId then
            bool = table.contains(v["color"], color)
            break
        end
    end
    if bool ~= true then
        return
    end
    local equipcolor = EquipAndAppear.getequipcolor(actor, 0)
    for _, v in ipairs(equipcolor) do
        if v["cfgid"] == cfgId then
            v["color"] = color
            break
        end
    end
    setplaydef(actor, "T$equipcolor", equipcolor)
end

--获取角色染色数据
function EquipAndAppear.getequipcolor(actor, msgId)
    local equipcolor = getplaydef(actor, "T$equipcolor")
    if equipcolor == nil then
        equipcolor = {}
        setplaydef(actor, "T$equipcolor", equipcolor)
    end
    local data = getplaydef(actor, "T$equipcolor")
    --发送lua消息到客户端
    if msgId == LuaMessageIdToClient.GET_EQUIP_COLOR then
        sendluamsg(actor, msgId, data)
    end
    return data
end

--计算所有消耗
function getAllEquipAppearCost(cfgIds, type)
    local allData = {}
    for _, cfgId in pairs(cfgIds) do
        local cost = ConfigDataManager.getTableValue("cfg_fashion", "deplete", "id", cfgId, "type", type)
        if cost == nil then
            return nil
        end
        local data = splitbyshuxianandjinghao(cost)
        for _1, v in pairs(data) do
            local id = v["cfgid"]
            local count = v["count"]
            local num = 0
            for _2, val in pairs(allData) do
                if val["cfgid"] == id then
                    val["count"] = val["count"] + count
                    num = num + 1
                    break
                end
            end
            if num == 0 then
                local element = {}
                element["cfgid"] = id
                element["count"] = count
                table.insert(allData, element)
            end
        end
    end
    return allData
end

function EquipAndAppear.playerequipview(actor, otherActor)
    if otherActor == nil then
        return
    end
    local alldata = this.buildPlayerEquipView(otherActor)
    sendluamsg(actor, LuaMessageIdToClient.OTHER_ROLE_APPEAR, alldata)
end

function this.buildPlayerEquipView(otherActor)
    --发送幻化染色数据
    local appear = EquipAndAppear.getequipappear(otherActor, 0)
    local title = EquipAndAppear.gettitleinfo(otherActor, 0)
    local alldata = {}
    alldata["appear"] = appear
    alldata["ring"] = EquipAndAppear.getnowwearshapering(otherActor)
    local curTitle = 0
    if not title.hidden then
        curTitle = title.curEquipTitle
    end
    alldata["title"] = curTitle
    local rid = getbaseinfo(otherActor, "rid")
    alldata["rid"] = rid
    return alldata
end

--检查表是否包含某个元素
-- function table.contains(table, element)
--     for _, value in pairs(table) do
--         if value == element then
--             return true
--         end
--     end
--     return false
-- end

-- 分割字符串
function splitbyshuxianandjinghao(str)
    local dt = {}
    local data = string.split(str, "|")
    for _, v in ipairs(data) do
        local data2 = string.split(v, "#")
        local v2 = {}
        v2["cfgid"] = data2[1]
        v2["count"] = data2[2]
        table.insert(dt, v2)
    end
    return dt
end

--称号入包
function EquipAndAppear.titleenterbag(actor, configId)
    local itemList = ConfigDataManager.getTable("cfg_item", "id", configId)
    if itemList == nil then
        return
    end
    local item = itemList[1]
    if tonumber(item.type) ~= 2 or tonumber(item.subtype) ~= 15 then
        return
    end
    --计算时间
    local fashionList = ConfigDataManager.getTable("cfg_fashion", "id", configId)
    if fashionList == nil then
        return
    end
    if table.count(fashionList) == 0 then
        return
    end
    local fashion = fashionList[1]
    local titledata = EquipAndAppear.gettitleinfo(actor, 0)
    local titles = titledata.title
    --不限时
    local flag = true
    local time = 0
    local type = 0
    local timeType = tonumber(fashion.timetype)
    local nowTime = math.ceil(getbaseinfo("now") / 1000)
    if timeType == 1 then
        type = 1
        for _, value in pairs(titles) do
            if value.confId == configId then
                value.obtainTime = nowTime --获得时间
                value.expiresTime = -1     --到期时间
                flag = false
            end
        end
        time = -1
    end
    --限时
    if timeType == 2 then
        type = 2
        --获取称号的有效期
        local times = fashion.time
        local timestr = string.split(times, "#")
        --总时间
        time = tonumber(timestr[1]) * 60 * 60 + tonumber(timestr[2]) * 60 + tonumber(timestr[3])
        for _, value in pairs(titles) do
            if value.confId == configId then
                value.obtainTime = nowTime                  --获得时间
                value.expiresTime = value.obtainTime + time --到期时间
                flag = false
            end
        end
    end
    --活动限时
    if timeType == 3 then
        type = 3
        --todo 获取称号的有效期
        local actId = fashion.time
        local actdata = getactivityinfo(actor, actId)
        time = math.ceil(actdata.nextopentime / 1000)
        for _, value in pairs(titles) do
            if value.confId == configId then
                value.obtainTime = nowTime --获得时间
                value.expiresTime = time   --到期时间
                flag = false
            end
        end
    end
    if flag then
        local tt = {}
        tt.obtainTime = math.ceil(getbaseinfo("now") / 1000)
        if type == 1 or type == 3 then
            tt.expiresTime = time
        else
            tt.expiresTime = tt.obtainTime + time
        end
        tt.confId = configId
        table.insert(titles, tt)
    end
    setplaydef(actor, "T$titledata", titledata)
    --更新称号属性
    EquipAndAppear.updatetitleattr(actor)
    EquipAndAppear.gettitleinfo(actor, LuaMessageIdToSever.GET_TITLE)
end

--更新称号属性信息
function EquipAndAppear.updatetitleattr(actor)
    local data = getplaydef(actor, "T$titledata")
    local titles = data.title
    local titleattr = {}
    local nowTime = math.ceil(getbaseinfo("now") / 1000)
    for _, value in pairs(titles) do
        --先校验是否过期
        if value.expiresTime == -1 or value.expiresTime > nowTime then
            --计算属性
            local fashion = ConfigDataManager.getTable("cfg_fashion", "id", value.confId)
            local attr = fashion[1].att
            local str = string.split(attr, "|")
            for _, value in pairs(str) do
                local str2 = string.split(value, "#")
                local num = titleattr[str2[1]]
                local nowNum = str2[2]
                if num == nil then
                    titleattr[str2[1]] = tonumber(nowNum)
                else
                    titleattr[str2[1]] = tonumber(nowNum) + tonumber(num)
                end
            end
        end
    end
    --更新称号属性
    addrolekmlattributes(actor, "titleattr", titleattr)
end

--获取称号详细信息
function EquipAndAppear.gettitleinfo(actor, msgId)
    local data = getplaydef(actor, "T$titledata")
    if data == nil then
        data = EquipAndAppear.inittitledata(actor)
    end

    if msgId == LuaMessageIdToSever.GET_TITLE then
        sendluamsg(actor, LuaMessageIdToClient.GET_TITLE, data)
    end
    return data
end

--保存称号外观
function EquipAndAppear.settingtitleappear(actor, msgId, msgData)
    local data = getplaydef(actor, "T$titledata")
    local titleappear = msgData["title"]
    data.curEquipTitle = titleappear
    setplaydef(actor, "T$titledata", data)
    if msgId == LuaMessageIdToSever.SET_TITLE then
        sendluamsg(actor, LuaMessageIdToClient.SETTING_TITLE_APPEAR, titleappear)
        local result = {}
        result.rid = getbaseinfo(actor, "rid")
        result.curEquipTitle = titleappear
        sendrefluamsg(actor, LuaMessageIdToClient.RES_TITLE_CHANGE_UPDATE, result)
    end
end

--初始化数据
function EquipAndAppear.inittitledata(actor)
    local data = {}
    data.title = {}
    data.hidden = false
    data.curEquipTitle = 0
    setplaydef(actor, "T$titledata", data)
    return data
end

--校验称号的过期时间
function EquipAndAppear.checktitleovertime(actor)
    local data = getplaydef(actor, "T$titledata")
    if table.count(data) == 0 then
        data = EquipAndAppear.inittitledata(actor)
    end
    local titles = data.title
    if table.count(titles) == 0 then
        return
    end
    local curTitle = data.curEquipTitle
    local flag = false
    local nowTime = math.ceil(getbaseinfo("now") / 1000)
    for key, value in pairs(titles) do
        --先校验是否过期
        --jprint("检查称号过期0",value.expiresTime > nowTime, value.expiresTime, nowTime)
        if value.expiresTime ~= -1 and value.expiresTime < nowTime then
            table.remove(titles, key)
            flag = true
            if curTitle == value.confId then
                data.curEquipTitle = 0
            end
        end
    end
    if flag then
        data.title = titles
        setplaydef(actor, "T$titledata", data)
        EquipAndAppear.updatetitleattr(actor)
        --发送消息
        sendluamsg(actor, LuaMessageIdToClient.SETTING_TITLE_APPEAR, 0)
    end
end

--获取守护外观
function EquipAndAppear.getguardappear(actor, msgId)
    local data = getrolefield(actor, "role.roleEquip.guardAppear")
    if data == nil then
        sendluamsg(actor, LuaMessageIdToClient.RES_GUARD_APPEAR, {})
        return {}
    end
    local result = {}
    for key, value in pairs(data) do
        local mm = {}
        mm.att = value.attr
        mm.getTime = math.floor(value.getTime / 1000)
        mm.itemId = key
        if value.time ~= -1 then
            mm.time = mm.getTime + math.floor(value.time / 1000)
        else
            mm.time = -1
        end
        table.insert(result, mm)
    end
    if msgId == LuaMessageIdToSever.GET_GUARD_APPEAR then
        sendluamsg(actor, LuaMessageIdToClient.RES_GUARD_APPEAR, result)
    end
    return data
end

function EquipAndAppear.useItem(actor, itemInfo)
    if tonumber(itemInfo.type) == 6 and tonumber(itemInfo.subtype) == 14 then
        EquipAndAppear.getshapering(actor, LuaMessageIdToSever.GET_SHAPE_RING)
    end
end

--获取变身戒指数据
function EquipAndAppear.getshapering(actor, msgId)
    local data = getrolefield(actor, "role.roleEquip.shapeRing")
    if data == nil then
        return {}
    end
    local nowwear = EquipAndAppear.getnowwearshapering(actor)
    local rd = {}
    local result = {}
    rd.curWearRing = nowwear
    for key, value in pairs(data) do
        local mm = {}
        mm.monsterId = tonumber(key)
        mm.ringAttr = value.ringAttr
        mm.getTime = math.floor(value.getTime / 1000)
        mm.itemId = value.itemId
        if value.time ~= -1 then
            mm.time = math.floor(value.time / 1000)
        else
            mm.time = -1
        end
        table.insert(result, mm)
    end
    rd.title = result
    if msgId == LuaMessageIdToSever.GET_SHAPE_RING then
        sendluamsg(actor, LuaMessageIdToClient.GET_SHAPE_RING, rd)
    end
    return data
end

--穿戴变身戒指
function EquipAndAppear.wearshapering(actor, msgData)
    local monsterId = msgData["monsterId"]
    setplaydef(actor, "T$wearshapering", monsterId)
    setshaperingdata(actor, monsterId)
    sendluamsg(actor, LuaMessageIdToClient.RES_PUTOON_RING, monsterId)
    local result = {}
    result.rid = getbaseinfo(actor, "rid")
    result.curEquipRing = monsterId
    sendrefluamsg(actor, LuaMessageIdToClient.RES_RING_CHANGE_UPDATE, result)
end

--获取当前穿戴的变身戒指
function EquipAndAppear.getnowwearshapering(actor)
    local data = getplaydef(actor, "T$wearshapering")
    if data == nil then
        return 0
    end
    return data
end

--校验变身戒指过期时间
function EquipAndAppear.checkringovertime(actor)
    local data = EquipAndAppear.getshapering(actor)
    local ringId = EquipAndAppear.getnowwearshapering(actor)
    if ringId == 0 then
        return
    end
    local monsterId = ConfigDataManager.getTableValue("cfg_item", "useParam", "id", ringId)
    if not monsterId then
        return
    end
    if not data[tostring(monsterId)] then
        setplaydef(actor, "T$wearshapering", 0)
        sendluamsg(actor, LuaMessageIdToClient.RES_PUTOON_RING, 0)
        local result = {}
        result.rid = getbaseinfo(actor, "rid")
        result.curEquipRing = 0
        sendrefluamsg(actor, LuaMessageIdToClient.RES_RING_CHANGE_UPDATE, result)
    end
    -- local nowTime = math.ceil(getbaseinfo("now") / 1000)
    -- for index, ring in pairs(data) do
    --     if ring ~= -1 then
    --         --检查
    --         if nowTime > math.floor(ring.time / 1000) then
    --             --删除穿戴外观
    --             local ringId = EquipAndAppear.getnowwearshapering(actor)
    --             if ringId == ring then
    --                 setplaydef(actor, "T$wearshapering", 0)
    --                 sendluamsg(actor, LuaMessageIdToClient.RES_PUTOON_RING, 0)
    --                 local result = {}
    --                 result.rid = getbaseinfo(actor, "rid")
    --                 result.curEquipRing = 0
    --                 sendrefluamsg(actor, LuaMessageIdToClient.RES_RING_CHANGE_UPDATE, result)
    --             end
    --             table.remove(data, index)
    --         end
    --     end
    -- end
end

--装备强化
function EquipAndAppear.luastrengthequip(actor, msgData)
    local itemid = msgData.itemId
    local successItems = msgData.successItems
    local protectIds = msgData.protectIds
    local putCost = msgData.putCost
    local equip = getequipinfo(actor, itemid, 1)
    if equip == nil then
        return
    end
    local cfg_synthesis = ConfigDataManager.getById("cfg_synthesis", 10001)
    if table.isEmpty(cfg_synthesis) then
        tipinfo(actor, "合成配置不存在")
        return
    end

    local equipdata = EquipAndAppear.getItemExtData(actor, itemid)
    if equipdata.strengthlv == nil then
        equipdata.strengthlv = 0
        equipdata.strengthattr = {}
        equipdata.originalStrengthattr = {}
    end
    local oldLv = equipdata.strengthlv
    local lv = oldLv + 1
    local cfgId = equip.cfgid
    local cfg_equip_strengthen = ConfigDataManager.getById("cfg_equip_strengthen", cfgId)

    --首饰的强化等级特殊处理
    local group = ConfigDataManager.getTableValue("cfg_equip_ornamentsMain", "ornamentsGroup", "id", cfgId)
    if group ~= nil and group ~= "" then
        local strengthenmaxLevel =
            ConfigDataManager.getTableValue(
                "cfg_equip_ornaments",
                "strengthenmaxLevel",
                "ornamentsGroup",
                group,
                "lv",
                equipdata.ssuplv or 0
            )
        if tonumber(strengthenmaxLevel) < lv then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "该装备已强化到最大等级")
            return
        end
    else
        local maxLevel = cfg_equip_strengthen.maxlevel
        if tonumber(maxLevel) < lv then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "该装备已强化到最大等级")
            return
        end
    end
    local costId = cfg_equip_strengthen.costid
    local groupId = cfg_equip_strengthen.groupid
    local strengthenCostCfg = ConfigDataManager.getTableFirst("cfg_equip_strengthenCost", "costGroupId", costId, "level", lv)
    local muneType = strengthenCostCfg.munetype

    if muneType == "1" then
        local costCfgId = msgData.costCfgId
        local strengthenCost = string.split(strengthenCostCfg.strengthencost, "#")
        if not table.contains(strengthenCost, tostring(costCfgId)) then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "消耗错误")
            error(actor, "玩家", actor, "强化 传入的消耗与配置对不上 消耗错误 道具配置id：", cfgId, "itemid:", itemid, "传入的消耗配置:", costCfgId
            , "cfg_equip_strengthenCost.strengthencost:", strengthenCostCfg.appendcost, "cfg_equip_strengthenCost.costGroupId:", costId, "cfg_equip_strengthenCost.level:", lv)
            return
        end
        local strengthenCostCfgV2 = ConfigDataManager.getById("cfg_equip_strengthenCost_v2", costCfgId)
        if equipdata.strengthlv < tonumber(strengthenCostCfgV2.level) then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "宝石未达到等级限制")
            error(actor, "玩家", actor, "强化 宝石未达到等级限制 道具配置id：", cfgId, "itemid:", itemid, "传入的消耗配置:", costCfgId, "当前强化等级", equipdata.strengthlv, "配置等级", strengthenCostCfgV2.level)
            return
        end
        local costTag = string.toIntIntMap(strengthenCostCfgV2.costtag, "#", "|")
        if not Bag.checkCostMap(actor, costTag) then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
            return
        end
        Bag.costMap(actor, costTag, "类型1强化消耗")
        local successLevel = tonumber(strengthenCostCfgV2.successlevel)
        lv = equipdata.strengthlv + successLevel

        local rate = getattrinfo(actor, "soulGemSuccessRate") or 0
        local addRate = Equip_XingYun.getRate(cfgId, equipdata.IsLuck or 0, costTag)
        local totalRate = rate + tonumber(strengthenCostCfgV2.rate) + addRate
        if not RandomUtil.isLuck(totalRate) then
            -- 失败
            local failLevel = tonumber(strengthenCostCfgV2.faillevel)
            if failLevel ~= equipdata.strengthlv then
                local att = ConfigDataManager.getTableValue("cfg_equip_strengthenGroup", "att", "group", groupId, "lv", failLevel)
                local attr = string.toIntIntMap(att, "#", "|")
                equipdata.strengthlv = failLevel
                equipdata.strengthattr = attr
                equipdata.originalStrengthattr = attr
                local maxDurability = EquipDurability.getMaxDurability(cfgId, failLevel)
                if (equipdata.durabilityNum or 0) > maxDurability then
                    equipdata.durabilityNum = maxDurability
                end
                --local reduceRate = EquipDurability.getReduceRate(cfgId, equipdata.strengthlv or 0, equipdata.durabilityNum or 0)
                --if equipdata.durabilityNum < 1 then
                --    EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId, 10000)
                --end
                EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId)


                EquipAndAppear.SetItemExtData(actor, itemid, equipdata)
                --更新强化追加等属性
                EquipMaster.strengthMaster(actor)
                EquipAndAppear.updateluaextattr(actor)
                Master.refreshMasterTalentAttr(actor)
                info(actor, "玩家", actor, "1强化装备至" .. lv .. "级失败,失败后等级" .. failLevel, "道具id" .. itemid, "cfgId:" .. cfgId)
                --装备强化之后发送装备强化信息
                EquipAndAppear.updateequipgmext(actor, itemid, failLevel)
            end
            --给客户端发强化结果
            local dddd = {}
            dddd.itemId = itemid
            dddd.strengthlv = tonumber(failLevel)
            dddd.issuccess = false
            sendluamsg(actor, LuaMessageIdToClient.STRENGTH_EQUIP_RESULT, dddd)
            return
        end
        if not equip.isbind and EquipAndAppear.isBindCost(costTag) then
            EquipAndAppear.updateBindState(actor, itemid, cfgId)
        end
        --获取属性加成
        local att = ConfigDataManager.getTableValue("cfg_equip_strengthenGroup", "att", "group", groupId, "lv", lv)
        local attr = string.toIntIntMap(att, "#", "|")
        equipdata.strengthattr = attr
        equipdata.originalStrengthattr = attr
    else
        if equip.bagindex == nil or equip.bagindex < 1 then
            tipinfo(actor, "请放入背包装备强化")
            return
        end
        --获取消耗
        local coststr = strengthenCostCfg.cost
        if string.isNullOrEmpty(coststr) then
            return
        end
        local coinCost = string.toIntIntMap(strengthenCostCfg.coincost)
        local cfgCost = string.toIntIntMap(coststr)
        local allCost = {}
        table.mergeAdd(allCost, coinCost)

        local cost = this.getStrengthenCost(actor, cfgCost, putCost)
        if table.isEmpty(cost) then
            tipinfo(actor, "消耗不足1")
            return
        end
        table.mergeAdd(allCost, cost)

        local isProtect = table.notEmpty(protectIds)
        if isProtect then
            local protect = string.splitInt(cfg_synthesis.protect, "#")
            for i = 1, #protectIds do
                local itemCfgId = tonumber(protectIds[i])
                local bindEqualItem = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "bindEqualItem", "id", itemCfgId))
                if not table.contains(protect, itemCfgId) and not table.contains(protect, bindEqualItem) then
                    tipinfo(actor, "保护道具错误")
                    return
                end
                local oldCount = allCost[itemCfgId] or 0
                allCost[itemCfgId] = oldCount + 1
            end
        end
        --校验道具是否足够
        if not Bag.checkCostMap(actor, allCost) then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
            return
        end
        --扣材料
        Bag.costMap(actor, allCost, "强化消耗")
        --获取成功率
        local successRateReal = 0
        if table.notEmpty(successItems) then
            successRateReal = ItemSynthesis.getSuccessRate(actor, cfg_synthesis, successItems)
        end

        local rate = getattrinfo(actor, "soulGemSuccessRate") or 0
        local addRate = Equip_XingYun.getRate(cfgId, equipdata.IsLuck or 0, allCost)
        local totalRate = rate + tonumber(strengthenCostCfg.rate) + addRate + successRateReal
        local randomNumber = math.random(1, 10000)
        if totalRate < randomNumber then
            --失败，校验是否等级回退
            local failLevel = strengthenCostCfg.faillevel
            failLevel = tonumber(failLevel)

            local zeroLevel = 0
            if not isProtect then
                -- 没有保护道具，删除装备
                removeitembyidxlist(actor, { [equip.bagindex] = 1 }, 9999, '强化失败，删除装备')
                info(actor, "玩家", actor, "强化装备至" .. lv .. "级失败, 没有保护道具，删除装备", "道具id" .. itemid, "cfgId:" .. cfgId)
            else
                --local att = ConfigDataManager.getTableValue("cfg_equip_strengthenGroup", "att", "group", groupId, "lv", failLevel)
                --local attr = string.toIntIntMap(att, "#", "|")
                --local part = tonumber(ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", cfgId))
                --local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.FORGE_EQUIP_ATTR_LIMIT)
                --local limit = string.toIntIntMap(cfg_str)
                --local parts = table.keys(limit)
                --
                --local newAttr = {}
                --for attrId, value in pairs(attr) do
                --    if table.contains(parts, part) and limit[part] == attrId then
                --        newAttr[attrId] = value
                --    else
                --        local newValue = value + (failLevel - 9) * (failLevel - 8) / 2
                --        newAttr[attrId] = newValue
                --    end
                --end
                --equipdata.strengthlv = failLevel
                --equipdata.strengthattr = newAttr
                --equipdata.originalStrengthattr = newAttr

                -- 有保护道具，将强化等级归0，保留装备
                equipdata.strengthlv = zeroLevel
                equipdata.strengthattr = {}
                equipdata.originalStrengthattr = {}
                local maxDurability = EquipDurability.getMaxDurability(cfgId, zeroLevel)
                if (equipdata.durabilityNum or 0) > maxDurability then
                    equipdata.durabilityNum = maxDurability
                end
                --local reduceRate = EquipDurability.getReduceRate(cfgId, equipdata.strengthlv or 0, equipdata.durabilityNum or 0)
                --if equipdata.durabilityNum < 1 then
                --    EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId, 10000)
                --end
                EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId)

                EquipAndAppear.SetItemExtData(actor, itemid, equipdata)
                --更新强化追加等属性
                EquipMaster.strengthMaster(actor)
                EquipAndAppear.updateluaextattr(actor)
                Master.refreshMasterTalentAttr(actor)
                info(actor, "玩家", actor, "强化装备至" .. lv .. "级失败, 有保护道具，强化等级归0", "道具id" .. itemid, "cfgId:" .. cfgId)
                --装备强化之后发送装备强化信息
                EquipAndAppear.updateequipgmext(actor, itemid, zeroLevel)
            end
            --给客户端发强化结果
            local dddd = {}
            dddd.itemId = itemid
            dddd.strengthlv = zeroLevel
            dddd.issuccess = false
            sendluamsg(actor, LuaMessageIdToClient.STRENGTH_EQUIP_RESULT, dddd)
            local strPart = ConfigDataManager.getTableValue("cfg_item", "strpart", "id", cfgId)
            TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_STRENGTHEN, { success = false, part = strPart })
            return
        end
        if not equip.isbind and EquipAndAppear.isBindCost(cost) then
            EquipAndAppear.updateBindState(actor, itemid, cfgId)
        end
        --获取属性加成
        local att = ConfigDataManager.getTableValue("cfg_equip_strengthenGroup", "att", "group", groupId, "lv", lv)
        local attr = string.toIntIntMap(att, "#", "|")

        local part = tonumber(ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", cfgId))
        local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.FORGE_EQUIP_ATTR_LIMIT)
        local limit = string.toIntIntMap(cfg_str)
        local parts = table.keys(limit)

        local newAttr = {}
        for attrId, value in pairs(attr) do
            if table.contains(parts, part) and limit[part] == attrId then
                newAttr[attrId] = value
            else
                local newValue = value + (lv - 9) * (lv - 8) / 2
                newAttr[attrId] = newValue
            end
        end

        equipdata.strengthattr = newAttr
        equipdata.originalStrengthattr = newAttr
    end

    equipdata.strengthlv = lv
    local addDurability = EquipDurability.getChangeDurability(oldLv, lv)
    equipdata.durabilityNum = math.min((equipdata.durabilityNum or 0) + addDurability, EquipDurability.getMaxDurability(cfgId, lv))
    --local reduceRate = EquipDurability.getReduceRate(cfgId, equipdata.strengthlv or 0, equipdata.durabilityNum or 0)
    --if equipdata.durabilityNum < 1 then
    --    EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId)
    --end
    EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId)

    EquipAndAppear.SetItemExtData(actor, itemid, equipdata)

    --记录强化次数
    local oldCount = EquipAndAppear.GetEquipStrengthCount(actor)
    setplaydef(actor, ROLE_EQUIP_STRENGTH_TIMES, oldCount + 1)
    ---触发装备强化任务
    local strPart = ConfigDataManager.getTableValue("cfg_item", "strpart", "id", cfgId)
    local taskParam = {
        part = strPart,
        level = lv
    }
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.PARTS_STRENGTHEN_LV, taskParam)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_STRENGTHEN_TIMES, lv)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_STRENGTHEN, { success = true, part = strPart })
    this.TryUpdateEquipInfoRecorde(actor, EquipAndAppear.RecordeType.MAX_STRENGTH_LEVEL)

    -- 大于0需要提示
    local isTip = equip.equipindex > 0 and true or false
    if not EquipAndAppear.filterTakeOneEquip(actor, equip, false, isTip) then
        --tipinfo(actor,"未满足穿戴要求")
        takeofftheequip(actor, equip.equipindex, true, 3)

        -- 检查背包是否可以放下物品
        --local full = isbagfullorhasspace(actor,{[cfgId] = 1})
        --if not full then
        --    -- 发邮件
        --    --sendconfigmailbyrid(actor, actor:toString(), MailConfig.BAG_FULL, itemMap, name)
        --    takeofftheequip(actor, equip.equipindex, true, 3)
        --else
        --    -- 脱装
        --    takeofftheequip(actor, equip.equipindex)
        --end
    else
        -- 脱装会触发属性计算，这里就不计算了
        --更新强化追加等属性
        EquipMaster.strengthMaster(actor)
        EquipAndAppear.updateluaextattr(actor)
        Master.refreshMasterTalentAttr(actor)
    end
    --装备强化之后发送装备强化信息
    EquipAndAppear.updateequipgmext(actor, itemid, tonumber(lv))
    local cfgLv = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.STRENGTH_PERSON_BROADCAST))
    local itemName = ConfigDataManager.getTableValue("cfg_item", "name", "id", cfgId)
    if lv >= cfgLv then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT43001, getbaseinfo(actor, "rolename"), itemName, lv)
    end
    local cfgLv1 = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.STRENGTH_SYSTEM_BROADCAST))
    if lv >= cfgLv1 then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT43002, getbaseinfo(actor, "rolename"), itemName, lv)
    end
    --给客户端发强化结果
    local dddd = {}
    dddd.itemId = itemid
    dddd.strengthlv = tonumber(lv)
    dddd.issuccess = true
    sendluamsg(actor, LuaMessageIdToClient.STRENGTH_EQUIP_RESULT, dddd)
    info(actor, "玩家", actor, "强化装备至" .. lv .. "级成功", "道具id" .. itemid, "cfgId:" .. cfgId, "addDurability", addDurability)
end

function this.getStrengthenCost(actor, cfgCost, putCost)
    local cost = {}
    local usedCountMap = {}  -- 记录 putCost 中每个物品已被使用的数量，防重复消耗

    for configId, count in pairs(cfgCost) do
        local needCount = count  -- 配置需要的数量
        local have_count = 0     -- 已收集的总数

        for _, info in pairs(putCost) do
            if have_count >= needCount then
                break  -- 已达到配置数量，停止收集
            end

            local itemConfigId = tonumber(info.itemConfigId)
            local itemCount = tonumber(info.itemCount)

            if not API.ItemEqulas(configId, itemConfigId) then
                goto continue
            end

            -- 计算该物品在 putCost 中剩余可用的数量
            local usedCount = usedCountMap[itemConfigId] or 0
            local remainAvailable = math.max(0, itemCount - usedCount)

            if remainAvailable <= 0 then
                goto continue  -- 该物品已全部被使用，跳过
            end

            -- 计算本次实际使用的数量 (不超过剩余需求，也不超过该物品剩余可用数量)
            local remainNeed = needCount - have_count
            local useCount = math.min(remainNeed, remainAvailable)

            have_count = have_count + useCount
            local oldCount = cost[itemConfigId] or 0
            cost[itemConfigId] = oldCount + useCount

            -- 更新已使用数量
            usedCountMap[itemConfigId] = usedCount + useCount

            ::continue::
        end

        if have_count < needCount then
            info(actor, "玩家", actor, "强化消耗不足", "have_count", have_count, "needCount", needCount, "configId", configId)
            tipinfo(actor, "消耗不足")
            return nil
        end
    end
    return cost
end

function EquipAndAppear.isBindCost(tab)
    for cfgId, _ in pairs(tab) do
        local lockItem = ConfigDataManager.getTableValue("cfg_item", "lockitem", "id", cfgId)
        if lockItem ~= "" and lockItem == "2" then
            return true
        end
    end
    return false
end

---获取玩家装备累计强化次数
function EquipAndAppear.GetEquipStrengthCount(actor)
    local totalCount = getplaydef(actor, ROLE_EQUIP_STRENGTH_TIMES)
    if totalCount == nil then
        totalCount = 0
    end
    return totalCount
end

function EquipAndAppear.updateequipgmext(actor, itemid, strengthlv)
    -- local gmext = getequipgmext(actor,itemid)
    -- if gmext == nil or gmext == "null" then
    --     gmext = {}
    -- end
    local gmext = {}
    gmext.strengthlv = strengthlv
    setequipgmext(actor, itemid, gmext)
end

function splitbyshuxianandjinghao2(str)
    local dt = {}
    local data = string.split(str, "|")
    for _, v in ipairs(data) do
        local data2 = string.split(v, "#")
        dt[data2[1]] = data2[2]
    end
    return dt
end

--装备追加
function EquipAndAppear.luaappendequip(actor, msgData)
    local itemid = msgData.itemId
    local equip = getequipinfo(actor, itemid, 1)
    if equip == nil then
        return
    end
    local equipdata = EquipAndAppear.getItemExtData(actor, itemid)

    if equipdata.appendlv == nil then
        equipdata.appendlv = 0
        equipdata.appendattr = {}
        equipdata.originalAppendattr = {}
    end
    local lv = equipdata.appendlv + 1
    local cfgId = equip.cfgid
    local cfg_equip_appends = ConfigDataManager.getById("cfg_equip_appends", cfgId)

    --首饰的强化等级特殊处理
    local group = ConfigDataManager.getTableValue("cfg_equip_ornamentsMain", "ornamentsGroup", "id", cfgId)
    if group ~= nil and group ~= "" then
        local appendsmaxLevel =
            ConfigDataManager.getTableValue(
                "cfg_equip_ornaments",
                "appendsmaxLevel",
                "ornamentsGroup",
                group,
                "lv",
                equipdata.ssuplv or 0
            )
        if tonumber(appendsmaxLevel) < lv then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "该装备已追加到最大等级")
            return
        end
    else
        local maxLevel = cfg_equip_appends.maxlevel
        if tonumber(maxLevel) < lv then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "该装备已追加到最大等级")
            return
        end
    end
    local costId = cfg_equip_appends.costid
    local groupId = cfg_equip_appends.groupid
    local appendsCostCfg = ConfigDataManager.getTableFirst("cfg_equip_appendsCost", "costGroupId", costId, "level", lv)
    local muneType = appendsCostCfg.munetype

    if muneType == "1" then
        local costCfgId = msgData.costCfgId
        local appendCost = string.split(appendsCostCfg.appendcost, "#")
        if not table.contains(appendCost, tostring(costCfgId)) then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "消耗错误")
            error(actor, "玩家", actor, "追加 传入的消耗与配置对不上 消耗错误 道具配置id：", cfgId, "itemid:", itemid, "传入的消耗配置:", costCfgId
            , "cfg_equip_appendsCost.appendcost:", appendsCostCfg.appendcost, "cfg_equip_appendsCost.costGroupId:", costId, "cfg_equip_appendsCost.level:", lv)
            return
        end
        local appendsCostCfgV2 = ConfigDataManager.getById("cfg_equip_appendsCost_v2", costCfgId)
        if equipdata.appendlv < tonumber(appendsCostCfgV2.level) then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "宝石未达到等级限制")
            error(actor, "玩家", actor, "追加 宝石未达到等级限制 道具配置id：", cfgId, "itemid:", itemid, "传入的消耗配置:", costCfgId, "当前追加等级", equipdata.appendlv, "配置等级", appendsCostCfgV2.level)
            return
        end
        local costTag = string.toIntIntMap(appendsCostCfgV2.costtag, "#", "|")
        if not Bag.checkCostMap(actor, costTag) then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
            return
        end
        Bag.costMap(actor, costTag, "类型1追加消耗")
        local successLevel = tonumber(appendsCostCfgV2.successlevel)
        lv = equipdata.appendlv + successLevel
        local rate = getattrinfo(actor, "soulGemSuccessRate") or 0
        local totalRate = rate + tonumber(appendsCostCfgV2.rate)
        if not RandomUtil.isLuck(totalRate) then
            -- 失败
            local failLevel = tonumber(appendsCostCfgV2.faillevel)
            if failLevel ~= equipdata.appendlv then
                local attr = EquipAndAppear.getZhuiJiaAttrs(failLevel, groupId)
                equipdata.appendlv = failLevel
                equipdata.appendattr = attr
                equipdata.originalAppendattr = attr
                --local reduceRate = EquipDurability.getReduceRate(cfgId, equipdata.strengthlv or 0, equipdata.durabilityNum or 0)
                --if equipdata.durabilityNum < 1 then
                --    EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId)
                --end
                EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId)

                EquipAndAppear.SetItemExtData(actor, itemid, equipdata)
                --更新强化追加等属性
                EquipAndAppear.updateluaextattr(actor)
                info(actor, "玩家", actor, "1追加装备至" .. lv .. "级失败,失败后等级" .. failLevel, "道具id" .. itemid, "cfgId:" .. cfgId)
                EquipMaster.appendMaster(actor)
            end
            --给客户端发追加结果
            local dddd = {}
            dddd.itemId = itemid
            dddd.appendlv = tonumber(failLevel)
            dddd.issuccess = false
            sendluamsg(actor, LuaMessageIdToClient.APPEND_EQUIP_RESULT, dddd)
            return
        end
        if not equip.isbind and EquipAndAppear.isBindCost(costTag) then
            EquipAndAppear.updateBindState(actor, itemid, cfgId)
        end
        --获取属性加成
        local attr = EquipAndAppear.getZhuiJiaAttrs(lv, groupId)
        equipdata.appendattr = attr
        equipdata.originalAppendattr = attr
    else
        --获取消耗
        local coststr = appendsCostCfg.cost
        if string.isNullOrEmpty(coststr) then
            return
        end
        local coinCost = string.toIntIntMap(appendsCostCfg.coincost)
        local cost = string.toIntIntMap(coststr)
        table.mergeTable(cost, coinCost)
        --校验道具是否足够
        if not Bag.checkCostMap(actor, cost) then
            sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
            return
        end
        --扣材料
        Bag.costMap(actor, cost, "追加消耗")
        --获取成功率
        local randomNumber = math.random(1, 10000)
        local rate = getattrinfo(actor, "soulGemSuccessRate") or 0
        local totalRate = rate + tonumber(appendsCostCfg.rate)
        if totalRate < randomNumber then
            --失败，校验是否等级回退
            local failLevel = appendsCostCfg.faillevel
            failLevel = tonumber(failLevel)
            if failLevel ~= equipdata.appendlv then
                local attr = EquipAndAppear.getZhuiJiaAttrs(failLevel, groupId)

                local part = tonumber(ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", cfgId))
                local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.FORGE_EQUIP_ATTR_LIMIT)
                local limit = string.toIntIntMap(cfg_str)
                local parts = table.keys(limit)

                local newAttr = {}
                for attrId, value in pairs(attr) do
                    if table.contains(parts, part) and limit[part] == attrId then
                        newAttr[attrId] = value
                    else
                        local newValue = value + (lv - 9) * (lv - 8) / 2
                        newAttr[attrId] = newValue
                    end
                end

                equipdata.appendlv = failLevel
                equipdata.appendattr = newAttr
                equipdata.originalAppendattr = newAttr
                --local reduceRate = EquipDurability.getReduceRate(cfgId, equipdata.strengthlv or 0, equipdata.durabilityNum or 0)
                --if equipdata.durabilityNum < 1 then
                --    EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId, 10000)
                --end
                EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId)
                EquipAndAppear.SetItemExtData(actor, itemid, equipdata)
                EquipAndAppear.updateluaextattr(actor)
                info(actor, "玩家", actor, "追加装备至" .. lv .. "级失败,失败后等级" .. failLevel, "道具id" .. itemid, "cfgId:" .. cfgId)
                EquipMaster.appendMaster(actor)
            end
            --给客户端发追加结果
            local dddd = {}
            dddd.itemId = itemid
            dddd.appendlv = tonumber(failLevel)
            dddd.issuccess = false
            sendluamsg(actor, LuaMessageIdToClient.APPEND_EQUIP_RESULT, dddd)
            return
        end
        if not equip.isbind and EquipAndAppear.isBindCost(cost) then
            EquipAndAppear.updateBindState(actor, itemid, cfgId)
        end
        --获取属性加成
        local attr = EquipAndAppear.getZhuiJiaAttrs(lv, groupId)

        local part = tonumber(ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", cfgId))
        local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.FORGE_EQUIP_ATTR_LIMIT)
        local limit = string.toIntIntMap(cfg_str)
        local parts = table.keys(limit)

        local newAttr = {}
        for attrId, value in pairs(attr) do
            if table.contains(parts, part) and limit[part] == attrId then
                newAttr[attrId] = value
            else
                local newValue = value + (lv - 9) * (lv - 8) / 2
                newAttr[attrId] = newValue
            end
        end

        equipdata.appendattr = newAttr
        equipdata.originalAppendattr = newAttr
    end

    --error(actor, "玩家", actor, "追加装备成功", "groupId" , groupId, "lv" , lv , "data.strengthlv" , equipdata.strengthlv, "type:" , type(equipdata.strengthlv), "cfgId:" , cfgId,"equipdata.appendattr：", equipdata.appendattr,"equipdata.originalAppendattr：", equipdata.originalAppendattr,"attr：",EquipAndAppear.getZhuiJiaAttrs(lv, groupId))

    equipdata.appendlv = lv
    --local reduceRate = EquipDurability.getReduceRate(cfgId, equipdata.strengthlv or 0, equipdata.durabilityNum or 0)
    --if equipdata.durabilityNum < 1 then
    --    EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId)
    --end
    EquipDurability.updateDurabilityAttr(actor, equipdata, cfgId)
    EquipAndAppear.SetItemExtData(actor, itemid, equipdata)
    --更新强化追加等属性
    EquipAndAppear.updateluaextattr(actor)
    local cfgLv = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.APPEAR_SYSTEM_BROADCAST))
    if lv >= cfgLv then
        local showLv = AppendLvShow[lv]
        local equipName = ConfigDataManager.getTableValue("cfg_item", "name", "id", cfgId)
        noticeTip.noticeinfo(actor, StringIdConst.TEXT43003, getbaseinfo(actor, "rolename"), equipName, showLv)
    end
    --给客户端发追加结果
    local dddd = {}
    dddd.itemId = itemid
    dddd.appendlv = tonumber(lv)
    dddd.issuccess = true
    sendluamsg(actor, LuaMessageIdToClient.APPEND_EQUIP_RESULT, dddd)
    info(actor, "玩家", actor, "追加装备至" .. lv .. "级成功", "道具id" .. itemid, "cfgId:" .. cfgId)

    EquipMaster.appendMaster(actor)

    -- 刷新任务进度
    local strPart = ConfigDataManager.getTableValue("cfg_item", "strpart", "id", cfgId)
    local taskParam = {
        part = strPart,
        level = lv
    }
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_APPEND, taskParam)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_APPEND_TOTAL_LV)
    this.TryUpdateEquipInfoRecorde(actor, EquipAndAppear.RecordeType.MAX_APPEND_LEVEL)
end

function EquipAndAppear.getZhuiJiaAttrs(lv, groupId)
    local groupIdArr = string.split(groupId, "#")
    local tab = {}
    for _, v in ipairs(groupIdArr) do
        local att = ConfigDataManager.getTableValue("cfg_equip_appendsGroup", "att", "group", v, "lv", lv)
        local tempTAttr = string.toIntIntMap(att, "#", "|")
        table.mergeTable(tab, tempTAttr)
    end
    return tab
end

--装备属性转移
function EquipAndAppear.luatransferequip(actor, msgData)
    local firstId = msgData.firstItem
    local secId = msgData.secondItem
    local equip1 = getequipinfo(actor, firstId, 1)
    if equip1 == nil then
        return
    end
    local equip2 = getequipinfo(actor, secId, 1)
    if equip2 == nil then
        return
    end
    local id1 = equip1.cfgid
    local id2 = equip2.cfgid
    local data1 = ConfigDataManager.getTable("cfg_equip_transfer", "id", id1)
    local data2 = ConfigDataManager.getTable("cfg_equip_transfer", "id", id2)
    if
        (data1 == nil) or (data2 == nil) or (data1.transferGroup ~= data2.transferGroup) or
        (data1.transfer ~= data2.transfer)
    then
        return
    end
    local ts = msgData.transferStrength -- bool类型
    local ta = msgData.transferAppend
    local tr = msgData.transferRegeneration
    if not ts and not ta and not tr then
        return
    end
    --扩展数据
    local ext1 = EquipAndAppear.getItemExtData(actor, firstId)
    local ext2 = EquipAndAppear.getItemExtData(actor, secId)
    if table.isEmpty(ext2) then
        ext2 = {}
        ext2.appendattr = {}
        ext2.strengthattr = {}
        ext2.appendlv = 0
        ext2.strengthlv = 0
    end
    --转移前强化追加
    info(
        actor,
        "转移前强化追加等级,rid:",
        actor,
        "强化等级:",
        ext1.strengthlv,
        ext2.strengthlv,
        "追加等级:",
        ext1.appendlv,
        ext2.appendlv,
        "主装备id:" .. firstId .. "主装备cfgId:" .. id1,
        "副装备id:" .. secId .. "副装备cfgId:" .. id2
    )
    local allCost = {}
    --强化消耗
    if ts then
        local lv1 = ext1.strengthlv
        local lv2 = ext2.strengthlv
        if lv2 ~= 0 then
            return
        end
        local costItem = data1[1].strengthencost
        local cost = splittransfercoststr(costItem)
        local realLv = 0
        local realCost = {}
        for key, value in pairs(cost) do
            if key > realLv and key <= lv1 then
                realLv = key
                realCost = value
            end
        end
        table.insert(allCost, realCost)
    end
    if table.count(allCost[1]) == 0 then
        allCost[1] = {}
    end
    --追加消耗
    if ta then
        local lv1 = ext1.appendlv
        local lv2 = ext2.appendlv
        if lv2 ~= 0 then
            return
        end
        local costItem = data1[1].appendscost
        local cost = splittransfercoststr(costItem)
        local realLv = 0
        local realCost = {}
        for key, value in pairs(cost) do
            if key > realLv and key <= lv1 then
                realLv = key
                realCost = value
            end
        end
        for _, value in pairs(realCost) do
            local cId = value["cfgid"]
            local num = value["count"]
            local n = 0
            for _1, v in pairs(allCost[1]) do
                if v["cfgid"] == cId then
                    v["count"] = v["count"] + num
                    n = n + 1
                end
            end
            if n == 0 then
                table.insert(allCost[1], value)
            end
        end
    end
    --再生消耗
    if tr then
        local lv1 = ext1.regenerationlv
        local lv2 = ext2.regenerationlv
        if lv2 == nil then
            ext2.regenerationlv = 0
            lv2 = 0
        end
        if lv2 ~= 0 then
            return
        end
        local costItem = data1[1].regenerationcost
        local cost = splittransfercoststr(costItem)
        local realLv = 0
        local realCost = {}
        for key, value in pairs(cost) do
            if key > realLv and key <= lv1 then
                realLv = key
                realCost = value
            end
        end
        for _, value in pairs(realCost) do
            local cId = value["cfgid"]
            local num = value["count"]
            local n = 0
            for _1, v in pairs(allCost[1]) do
                if v["cfgid"] == cId then
                    v["count"] = v["count"] + num
                    n = n + 1
                end
            end
            if n == 0 then
                table.insert(allCost[1], value)
            end
        end
    end
    --检查道具是否足够
    local enough = Bag.checkItemEnough(actor, allCost[1])
    if not enough then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
        return
    end
    --扣道具
    for _, v in ipairs(allCost[1]) do
        local cId = v["cfgid"]
        local count = v["count"]
        removeitemfrombag(actor, cId, count, 0, 9999, "装备外观")
    end
    --转移强化
    if ts then
        local slv1 = ext1.strengthlv
        ext2.strengthlv = slv1
        ext1.strengthlv = 0
        ext1.strengthattr = {}
        --赋值属性
        local maxLv = ConfigDataManager.getTableValue("cfg_equip_strengthen", "maxLevel", "id", equip2.cfgid)
        local groupId = ConfigDataManager.getTableValue("cfg_equip_strengthen", "groupId", "id", equip2.cfgid)
        if ext2.strengthlv > tonumber(maxLv) then
            ext2.strengthlv = tonumber(maxLv)
        end
        local att =
            ConfigDataManager.getTableValue("cfg_equip_strengthenGroup", "att", "group", groupId, "lv", ext2.strengthlv)
        local attr = string.toIntIntMap(att, "#", "|")
        ext2.strengthattr = attr
        EquipAndAppear.updateequipgmext(actor, firstId, 0)
        EquipAndAppear.updateequipgmext(actor, secId, ext2.strengthlv)
    end
    --转移追加
    if ta then
        local slv1 = ext1.appendlv
        ext2.appendlv = slv1
        ext1.appendlv = 0
        ext1.appendattr = {}
        --赋值属性
        local maxLv = ConfigDataManager.getTableValue("cfg_equip_appends", "maxLevel", "id", equip2.cfgid)
        local groupId = ConfigDataManager.getTableValue("cfg_equip_appends", "groupId", "id", equip2.cfgid)
        if ext2.appendlv > tonumber(maxLv) then
            ext2.appendlv = tonumber(maxLv)
        end
        local att =
            ConfigDataManager.getTableValue("cfg_equip_appendsGroup", "att", "group", groupId, "lv", ext2.appendlv)
        local attr = string.toIntIntMap(att, "#", "|")
        ext2.appendattr = attr
    end
    --转移再生
    if tr then
        local relv = ext1.regenerationlv
        ext2.regenerationlv = relv
        ext1.regenerationlv = 0
        ext2.regenerationattr = {}
        --赋值属性
        local maxLv = ConfigDataManager.getTableValue("cfg_equip_regeneration", "levelMax", "id", equip2.cfgid)
        local groupId = ConfigDataManager.getTableValue("cfg_equip_regeneration", "Group", "id", equip2.cfgid)
        if ext2.regenerationlv > tonumber(maxLv) then
            ext2.regenerationlv = tonumber(maxLv)
        end
        local regeattr = ext1.regenerationattr
        for _, value in pairs(regeattr) do
            local id = value.id
            local regenerationgroup = ConfigDataManager.getTable("cfg_equip_regenerationGroup", "id", id)
            if table.count(regenerationgroup) ~= 0 then
                local sequence = regenerationgroup[1].sequence
                --找对应的表
                local nexttable =
                    ConfigDataManager.getTable(
                        "cfg_equip_regenerationGroup",
                        "group",
                        groupId,
                        "sequence",
                        sequence,
                        "level",
                        ext2.regenerationlv
                    )
                if table.count(nexttable) ~= 0 then
                    local att = nexttable[1].att
                    local str = string.split(att, "#")
                    local dd = {}
                    dd[str[1]] = tonumber(str[2])
                    dd.id = tonumber(nexttable[1].id)
                    ext2.regenerationattr[tostring(table.count(ext2.regenerationattr) + 1)] = dd
                end
            end
        end
        ext1.regenerationattr = {}
    end
    --更新数据
    EquipAndAppear.SetItemExtData(actor, firstId, ext1)
    EquipAndAppear.SetItemExtData(actor, secId, ext2)
    EquipMaster.transferTrigger(actor, equip1, equip2, ts, ta)
    EquipAndAppear.updateluaextattr(actor)
    --转移后强化追加
    info(
        actor,
        "转移后强化追加等级,rid:",
        actor,
        "强化等级:",
        ext1.strengthlv,
        ext2.strengthlv,
        "追加等级:",
        ext1.appendlv,
        ext2.appendlv,
        "主装备id:" .. firstId .. "主装备cfgId:" .. id1,
        "副装备id:" .. secId .. "副装备cfgId:" .. id2
    )
    if not equip2.isbind then
        changeitembindstate(actor, secId, 1)
        local res = { itemId = secId, bindId = true }
        sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_BIND_DATA_CHANGE, res)
    end
    --检查主装备是否还有强化追加属性
    if this.checkEquipStrengthAndAppend(actor, firstId) then
        --变为非绑定
        changeitembindstate(actor, firstId, 0)
        local res = { itemId = firstId, bindId = false }
        sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_BIND_DATA_CHANGE, res)
    end
    --发送lua消息到客户端
    local data = {}
    data.oldItem = firstId
    data.newItem = secId
    data.issuccess = true
    sendluamsg(actor, LuaMessageIdToClient.RES_TRANSFER_EQUIP, data)
end

function this.checkEquipStrengthAndAppend(actor, itemId)
    local equipData = EquipAndAppear.getItemExtData(actor, tonumber(itemId))
    if not equipData then
        return true
    end
    local strengthlv = equipData.strengthlv
    local appendlv = equipData.appendlv
    if (strengthlv == 0) and (appendlv == 0) then
        return true
    end
    return false
end

function EquipAndAppear.checkCanTransfer(actor, firstId, secId)
    if firstId == 0 then
        return
    end
    local data = {}
    data.oldItem = firstId
    data.newItem = secId
    sendluamsg(actor, LuaMessageIdToClient.RES_CAN_TRANSFER, data)
end

function splittransfercoststr(str)
    local s = string.split(str, "|")
    local data = {}
    for _, value in pairs(s) do
        local x = string.split(value, "#")
        local len = #x
        local itemList = {}
        if len == 3 then
            local item = {}
            item["cfgid"] = x[2]
            item["count"] = x[3]
            table.insert(itemList, item)
        else
            if len > 3 then
                for i = 1, len do
                    local item = {}
                    if i == 1 then
                        item["cfgid"] = x[i + 1]
                        item["count"] = x[i + 2]
                        i = i + 3
                    else
                        item["cfgid"] = x[i]
                        item["count"] = x[i + 1]
                        i = i + 2
                    end
                    table.insert(itemList, item)
                end
            end
        end
        data[tonumber(x[1])] = itemList
    end
    return data
end

function EquipAndAppear.updateluaextattr(actor)
    local equiplist = getputonequipinfo(actor)
    local allattr = {}
    local specialEntryAttr = {} -- 特殊词条属性
    for _, equipinfo in pairs(equiplist) do
        local strengthLv = 0
        local itemId = equipinfo.id
        local data = EquipAndAppear.getItemExtData(actor, itemId)
        if table.notEmpty(data) then
            --将该装备的属性加到角色身上
            if data.strengthlv ~= nil then
                strengthLv = data.strengthlv
                local strengthattr = data.strengthattr or {}
                --table.mergeAdd(allattr, strengthattr)
                AttributeManager.merge(allattr, strengthattr)
            end
            if data.appendlv ~= nil then
                local appendattr = data.appendattr or {}
                --table.mergeAdd(allattr, appendattr)
                AttributeManager.merge(allattr, appendattr)
            end
            if data.ssuplv ~= nil then
                local ssupattr = data.ssupattr
                local ssactattr = data.ssactattr
                --table.mergeAdd(allattr, ssupattr)
                --table.mergeAdd(allattr, ssactattr)
                AttributeManager.merge(allattr, ssupattr)
                AttributeManager.merge(allattr, ssactattr)
            end
            if data.regenerationlv ~= nil then
                local reattr = data.regenerationattr
                local regenerationattr = {}
                for _, att in pairs(reattr) do
                    for key, value in pairs(att) do
                        if key ~= "id" then
                            local num = regenerationattr[key]
                            if num == nil then
                                num = 0
                            end
                            regenerationattr[key] = num + value
                        end
                    end
                end
                --table.mergeAdd(allattr, regenerationattr)
                AttributeManager.merge(allattr, regenerationattr)
            end
            if table.notNullOrEmpty(data.tTaoZhuangEWai) then
                local tab = {}
                for _, v in pairs(data.tTaoZhuangEWai) do
                    local att = string.split(v, "#")
                    local attId = tonumber(att[1])
                    local val = tonumber(att[2])
                    if tab[attId] then
                        tab[attId] = tab[attId] + val
                    else
                        tab[attId] = val
                    end
                end
                --table.mergeAdd(allattr, tab)
                AttributeManager.merge(allattr, tab)
            end
            if data.IsLuck == 1 and table.notEmpty(data.luckAttr) then
                local luckAttr = data.luckAttr
                --table.mergeAdd(allattr, luckAttr)
                AttributeManager.merge(allattr, luckAttr)
            end
            ---- 耐久度变化，需要减少的属性
            --if table.notEmpty(data.reduceAttr) then
            --    --table.mergeAdd(allattr, data.reduceAttr)
            --    AttributeManager.merge(allattr, data.reduceAttr)
            --end
            --local attribute = string.toIntIntMap(ConfigDataManager.getTableValue("cfg_equip_entryLib", "attribute", "id", equipinfo.cfgid))
            --jprint("测试查看属性","玩家", actor:toString(), getbaseinfo(actor, "rolename"), "道具id", itemId, "道具cfgid", equipinfo.cfgid, "基础属性:", attribute
            --, "强化", data.strengthattr, "追加:", data.appendattr, "首饰:", data.ssupattr, "再生:", data.regenerationattr, "套装:", data.tTaoZhuangEWai, "幸运属性:", data.luckAttr, "词条属性", equipinfo.entries)
        end

        for _, entry in pairs(equipinfo.entries) do
            if entry.attrid == 1230 then
                --生命值增加 固定值+(强化等级)*5
                local hpAddValue = entry.value + strengthLv * 5
                table.mergeAdd(specialEntryAttr, { [207011] = hpAddValue })
            elseif entry.attrid == 1229 then
                --魔法值增加 固定值+(强化等级)*5
                local mpAddValue = entry.value + strengthLv * 5
                table.mergeAdd(specialEntryAttr, { [208011] = mpAddValue })
            end
        end
    end

    --table.merge(allattr, specialEntryAttr)
    AttributeManager.merge(allattr, specialEntryAttr)

    --更新装备记录
    this.TryUpdateEquipInfoRecorde(actor, EquipAndAppear.RecordeType.MAX_ENTRY_COUNT)
    --记录强化追加等属性
    if table.count(allattr) == 0 then
        addrolekmlattributes(actor, "luaextdataforever", {})
        return
    end
    addrolekmlattributes(actor, "luaextdataforever", allattr)
    --jprint("测试查看属性","玩家", actor:toString(), getbaseinfo(actor, "rolename"),"luaextdataforever总属性:", allattr)
end

--首饰升级
function EquipAndAppear.ssupdate(actor, msgData)
    local itemId = msgData["itemId"]
    local equipext = EquipAndAppear.getItemExtData(actor, itemId)
    if equipext.ssuplv == nil then
        equipext.ssupattr = {}
        equipext.ssuplv = 0
        equipext.ssactlv = {}
        equipext.ssactattr = {}
    end
    local equip = getequipinfo(actor, itemId, 1)
    local cfgId = equip.cfgid
    local group = ConfigDataManager.getTableValue("cfg_equip_ornamentsMain", "ornamentsGroup", "id", cfgId)
    if group == nil then
        return
    end
    local ornaments = ConfigDataManager.getTable("cfg_equip_ornaments", "ornamentsGroup", group, "lv", equipext.ssuplv)
    if ornaments == nil or table.count(ornaments) == 0 then
        return
    end
    local ornaments2 = ConfigDataManager.getTable("cfg_equip_ornaments", "ornamentsGroup", group, "lv", (equipext.ssuplv or 0) + 1)
    if ornaments2 == nil or table.count(ornaments2) == 0 then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "已经是最大等级！")
        return
    end
    local data = ornaments2[1]
    local cost = ornaments[1].lvdeplete
    local costItem = splitbyshuxianandjinghao(cost)
    --检查背包是否道具充足
    local enough = Bag.checkItemEnough(actor, costItem)
    if enough == false then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
        return
    end
    --扣材料
    for _, v in ipairs(costItem) do
        local cId = v["cfgid"]
        local count = v["count"]
        removeitemfrombag(actor, cId, count, 0, 9999, "装备外观")
    end
    --升级，加属性
    equipext.ssuplv = tonumber(data.lv)
    local att = data.basicatt
    local attr = string.toIntIntMap(att, "#", "|")
    equipext.ssupattr = attr
    EquipAndAppear.SetItemExtData(actor, itemId, equipext)
    --升级成功 回包给客户端
    local result = {}
    result.ssupattr = equipext.ssupattr
    result.ssuplv = tostring(equipext.ssuplv)
    result.ssactlv = equipext.ssactlv
    result.ssactattr = equipext.ssactattr
    result.itemId = itemId
    sendluamsg(actor, LuaMessageIdToClient.RES_UPDATE_EQUIP_ORNAMENTS, result)
    --更新属性
    EquipAndAppear.updateluaextattr(actor)
    --更新等级记录
    this.TryUpdateEquipInfoRecorde(actor, EquipAndAppear.RecordeType.MAX_JEWELRY_LEVEL)
    -- 刷新任务进度
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.JEWELRY_LV_UP)
end

--首饰等级属性激活
function EquipAndAppear.actssattr(actor, msgData)
    local itemId = msgData["itemId"]
    local lv = msgData["lv"]
    local equipext = EquipAndAppear.getItemExtData(actor, itemId)
    if equipext.ssuplv == nil then
        return
    end
    local equip = getequipinfo(actor, itemId, 1)
    local cfgId = equip.cfgid
    local group = ConfigDataManager.getTableValue("cfg_equip_ornamentsMain", "ornamentsGroup", "id", cfgId)
    local ssuplv = equipext.ssuplv
    if ssuplv < lv then
        return
    end
    if table.contains(equipext.ssactlv, lv) then
        return
    end
    local ornaments = ConfigDataManager.getTable("cfg_equip_ornaments", "ornamentsGroup", group, "lv", lv)
    if table.count(ornaments) == 0 then
        return
    end
    if ornaments[1].unlockdeplete == nil then
        return
    end
    local unlockDeplete = ornaments[1].unlockdeplete
    if unlockDeplete == nil then
        return
    end
    local costItem = splitbyshuxianandjinghao(unlockDeplete)
    --检查背包是否道具充足
    local enough = Bag.checkItemEnough(actor, costItem)
    if enough == false then
        return
    end
    --扣材料
    for _, v in ipairs(costItem) do
        local cId = v["cfgid"]
        local count = v["count"]
        removeitemfrombag(actor, cId, count, 0, 9999, "装备外观")
    end
    equipext.ssactlv[tostring(lv)] = lv
    local att = ornaments[1].excellenceatt
    local attr = string.toIntIntMap(att, "#", "|")
    table.mergeAdd(equipext.ssactattr, attr)
    EquipAndAppear.SetItemExtData(actor, itemId, equipext)
    --发送回包给客户端
    local result = {}
    result.ssupattr = equipext.ssupattr
    result.ssuplv = equipext.ssuplv
    result.ssactlv = equipext.ssactlv
    result.ssactattr = equipext.ssactattr
    result.itemId = itemId
    sendluamsg(actor, LuaMessageIdToClient.RES_ACT_EQUIP_ORNAMENTS, result)
    --更新属性
    EquipAndAppear.updateluaextattr(actor)
end

function EquipAndAppear.allequipstrengthlv(actor)
    local equiplist = getputonequipinfo(actor)
    local allequipstrengthlv = 0
    for _, equipinfo in pairs(equiplist) do
        local itemId = equipinfo.id
        local data = EquipAndAppear.getItemExtData(actor, itemId)
        if table.notEmpty(data) then
            if data.strengthlv ~= nil then
                allequipstrengthlv = allequipstrengthlv + data.strengthlv
            end
        end
    end
    return allequipstrengthlv
end

function EquipAndAppear.allequipappendlv(actor)
    local equiplist = getputonequipinfo(actor)
    local allequipstrengthlv = 0
    for _, equipinfo in pairs(equiplist) do
        local itemId = equipinfo.id
        local data = EquipAndAppear.getItemExtData(actor, itemId)
        if table.notEmpty(data) then
            if data.appendlv ~= nil then
                allequipstrengthlv = allequipstrengthlv + data.appendlv
            end
        end
    end
    return allequipstrengthlv
end

--再生
function EquipAndAppear.regeneration(actor, msgData)
    local itemId = msgData["itemId"]
    local equip = getequipinfo(actor, itemId, 1)
    local ext = EquipAndAppear.getItemExtData(actor, itemId)
    if ext.regenerationlv == nil then
        ext.regenerationlv = 0
        ext.regenerationattr = {}
    end
    local lv = ext.regenerationlv or 0
    local tabledata = ConfigDataManager.getTable("cfg_equip_regeneration", "id", equip.cfgid)
    if table.count(tabledata) == 0 then
        return
    end
    local group = tabledata[1].group
    --获取消耗
    local lockattr = msgData["lockattrpos"]
    local startcost = {}
    local type = 0
    if table.count(ext.regenerationattr) == 0 then
        startcost = tabledata[1].start
        type = 1
    else
        if table.count(lockattr) == 0 then
            startcost = tabledata[1].again
            type = 2
        else
            startcost = tabledata[1].lock
            type = 3
        end
    end
    local cost = getlockcost(startcost, lockattr)
    --校验道具是否足够
    local enough = Bag.checkItemEnough(actor, cost)
    if enough == false then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
        return
    end
    --扣道具
    for _, v in ipairs(cost) do
        local cId = v["cfgid"]
        local count = v["count"]
        removeitemfrombag(actor, cId, count, 0, 9999, "装备外观")
    end
    --随机词条数量
    local attrNum = {}
    if type == 1 then
        attrNum = tabledata[1].startnum
    else
        if type == 2 then
            attrNum = tabledata[1].againnum
        else
            if type == 3 then
                attrNum = tabledata[1].locknum
            end
        end
    end
    local result = random_weighted(attrNum, 1)
    if lv == 0 then
        lv = 1
    end
    --校验词条数是否超过最大值
    local maxAttrNum = tabledata[1].count
    local realNum = result[1] + table.count(lockattr)
    if realNum >= tonumber(maxAttrNum) then
        realNum = tonumber(maxAttrNum) - table.count(lockattr)
    else
        realNum = result[1]
    end
    local attdata = ConfigDataManager.getTable("cfg_equip_regenerationGroup", "group", group, "level", lv)
    local entrytable = build_weight_attr(attdata, ext.regenerationattr, lockattr)
    local entryattr = random_weighted(entrytable, realNum)
    --把这次结果临时存一下
    local xilianattr = {}
    for _, key in pairs(lockattr) do
        xilianattr[tostring(table.count(xilianattr) + 1)] = tonumber(key)
    end
    for _, key in pairs(entryattr) do
        xilianattr[tostring(table.count(xilianattr) + 1)] = tonumber(key)
    end
    local allequiprecord = getplaydef(actor, "T$regeneration")
    if allequiprecord == nil then
        allequiprecord = {}
    end
    local regenerationresult = {}
    regenerationresult.entryAttr = xilianattr
    regenerationresult.itemId = itemId
    allequiprecord[itemId] = regenerationresult
    setplaydef(actor, "T$regeneration", allequiprecord)
    EquipAndAppear.SetItemExtData(actor, itemId, ext)
    --告诉客户端本次洗练结果
    sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_REGENERATION, xilianattr)
end

function EquipAndAppear.getupregenerationattr(actor, msgData)
    local itemId = msgData.itemId
    local data = getplaydef(actor, "T$regeneration")
    if data == nil then
        sendluamsg(actor, LuaMessageIdToClient.RES_UP_REGENERATION_ATTR, {})
        return
    end
    local result = data[itemId]
    if result == nil then
        result = {}
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_UP_REGENERATION_ATTR, result)
end

--确认替换词条
function EquipAndAppear.confirmreplaceentry(actor, msgData)
    -- local lockattr = msgData.lockattrpos
    local itemId = msgData.itemId
    local alldata = getplaydef(actor, "T$regeneration")
    if alldata == nil then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "洗练后再进行替换！")
        return
    end
    local data = alldata[itemId]
    if data == nil then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "洗练后再进行替换！")
        return
    end
    if data.itemId ~= itemId then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "两次itemId不一致！")
        return
    end
    local ext = EquipAndAppear.getItemExtData(actor, itemId)
    ext.regenerationattr = {}
    for _, id in pairs(data.entryAttr) do
        local td = ConfigDataManager.getTable("cfg_equip_regenerationGroup", "id", id)
        if table.count(td) ~= 0 then
            local attr = td[1].att
            local str = string.split(attr, "#")
            local dd = {}
            dd[str[1]] = tonumber(str[2])
            dd.id = id
            ext.regenerationattr[tostring(table.count(ext.regenerationattr) + 1)] = dd
            ext.regenerationlv = tonumber(td[1].level)
        end
    end
    EquipAndAppear.SetItemExtData(actor, itemId, ext)
    alldata[itemId] = {}
    setplaydef(actor, "T$regeneration", alldata)
    --给客户端发替换结果
    sendluamsg(actor, LuaMessageIdToClient.RES_REPLACE_REGENERATION_ATTR, true)
    --更新强化追加等属性
    EquipAndAppear.updateluaextattr(actor)
end

--词条强化
function EquipAndAppear.strengthregenerationattr(actor, msgData)
    local itemId = msgData.itemId
    local ext = EquipAndAppear.getItemExtData(actor, itemId)
    local equip = getequipinfo(actor, itemId, 1)
    local group = ConfigDataManager.getTableValue("cfg_equip_regeneration", "group", "id", equip.cfgid)
    local lv = ext.regenerationlv
    local data = ConfigDataManager.getTable("cfg_equip_regenerationCost", "group", group, "level", lv)
    if table.count(data) == 0 then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "当前装备词条不能强化！")
        return
    end
    local maxLevel = ConfigDataManager.getTableValue("cfg_equip_regeneration", "levelMax", "id", equip.cfgid)
    if tonumber(maxLevel) < lv + 1 then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "该装备已再生到最大等级")
        return
    end
    local str = data[1].cost
    local cost = splitbyshuxianandjinghao(str)
    --检查材料
    local enough = Bag.checkItemEnough(actor, cost)
    if enough == false then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
        return
    end
    --扣道具
    for _, v in ipairs(cost) do
        local cId = v["cfgid"]
        local count = v["count"]
        removeitemfrombag(actor, cId, count, 0, 9999, "装备外观")
    end
    --计算成功率
    local rate = data[1].rate
    local randomNum = math.random(1, 10000)
    if randomNum > tonumber(rate) then
        --强化失败
        sendluamsg(actor, LuaMessageIdToClient.RES_STRENGTH_REGENERATION_ATTR, false)
        return
    end
    --强化成功增加属性
    local regenerationattr = ext.regenerationattr
    for i, value in pairs(regenerationattr) do
        local key = value.id
        local data = ConfigDataManager.getTable("cfg_equip_regenerationGroup", "id", key)
        if table.count(data) ~= 0 then
            local sequence = data[1].sequence
            --查找下一级属性
            local nextdata =
                ConfigDataManager.getTable(
                    "cfg_equip_regenerationGroup",
                    "group",
                    group,
                    "sequence",
                    sequence,
                    "level",
                    lv + 1
                )
            if table.count(nextdata) ~= 0 then
                local att = nextdata[1].att
                local attr = string.split(att, "#")
                local dd = {}
                dd[attr[1]] = tonumber(attr[2])
                dd.id = tonumber(nextdata[1].id)
                ext.regenerationattr[i] = dd
                -- table.remove(ext.regenerationattr,key)
            end
        end
    end
    ext.regenerationlv = lv + 1
    EquipAndAppear.SetItemExtData(actor, itemId, ext)
    --给客户端发消息
    sendluamsg(actor, LuaMessageIdToClient.RES_STRENGTH_REGENERATION_ATTR, true)
    --更新强化追加等属性
    EquipAndAppear.updateluaextattr(actor)
    --更新洗练未替换的数据
    updateregenoreplaceattr(actor, itemId, ext.regenerationlv, group)
end

function updateregenoreplaceattr(actor, itemId, lv, group)
    local alldata = getplaydef(actor, "T$regeneration")
    if alldata == nil then
        return
    end
    local data = alldata[itemId]
    if data == nil then
        return
    end
    local attrs = data.entryAttr
    if attrs == nil then
        return
    end
    for i, id in pairs(data.entryAttr) do
        local td = ConfigDataManager.getTable("cfg_equip_regenerationGroup", "id", id)
        if table.count(td) ~= 0 then
            local sequence = td[1].sequence
            --查找对应等级属性
            local nextdata =
                ConfigDataManager.getTable(
                    "cfg_equip_regenerationGroup",
                    "group",
                    group,
                    "sequence",
                    sequence,
                    "level",
                    lv
                )
            if table.count(nextdata) ~= 0 then
                attrs[i] = tonumber(nextdata[1].id)
            end
        end
    end
    data.entryAttr = attrs
    alldata[itemId] = data
    setplaydef(actor, "T$regeneration", alldata)
end

function mergeitemcost(cost, lockcost)
    for _, item in pairs(lockcost) do
        local flag = true
        for _, value in pairs(cost) do
            if item.cfgid == value.cfgid then
                value.count = value.count + item.count
                flag = false
            end
        end
        if flag then
            table.insert(cost, item)
        end
    end
    return cost
end

function getlockcost(cost, lockattr)
    local result = {}
    local locknum = table.count(lockattr)
    local lc = string.split(cost, "|")
    local str = {}
    if locknum ~= 0 then
        str = string.split(lc[locknum], "&")
        for _, value in pairs(str) do
            local item = string.split(value, "#")
            local i = {}
            i.cfgid = item[1]
            i.count = item[2]
            table.insert(result, i)
        end
    else
        result = splitbyshuxianandjinghao(cost)
    end
    return result
end

--根据权重随机词条数量
function random_weighted(weight_str, count)
    local result = {}
    if count <= 0 then
        return result
    end
    local num = string.split(weight_str, "&")
    local weight_total = 0
    for _, value in pairs(num) do
        local sum = string.split(value, "#")
        weight_total = weight_total + tonumber(sum[2])
    end
    local random_weight = math.random(1, weight_total)
    local cumulative_weight = 0
    for _, value in pairs(num) do
        local sum = string.split(value, "#")
        local weight = tonumber(sum[2])
        cumulative_weight = cumulative_weight + weight
        if cumulative_weight >= random_weight then
            table.insert(result, tonumber(sum[1]))
            if table.count(result) == count then
                return result
            end
        end
    end
end

--构造随机词条权重库
function build_weight_attr(attdata, regenenrationattr, lockattr)
    local entrystr = ""
    for i, value in pairs(attdata) do
        local len = #entrystr
        local id = value.id
        local flag = true
        for _, k in pairs(lockattr) do
            if k == id then
                table.remove(attdata, i)
                flag = false
            end
        end
        if flag then
            local weight = 0
            for key, v in pairs(regenenrationattr) do
                if key == id then
                    weight = value.weightdown
                end
            end
            if weight == 0 then
                weight = value.weight
            end
            if len == 0 then
                entrystr = id .. "#" .. weight
            else
                entrystr = entrystr .. "&" .. id .. "#" .. weight
            end
        end
    end
    return entrystr
end

function getequipssumstrengthlvtest(actor)
    this.GetSumJewelryLv(actor)
end

---获取角色全身装备强化等级
function EquipAndAppear.GetEquipsSumStrengthLv(actor)
    return this.GetSumLvByType(actor, EquipAndAppear.RecordeType.MAX_STRENGTH_LEVEL)
end

---获取角色全身装备追加等级
function EquipAndAppear.GetEquipsSumAppendLv(actor)
    return this.GetSumLvByType(actor, EquipAndAppear.RecordeType.MAX_APPEND_LEVEL)
end

---获取角色全身装备卓越词条数量（不包含再生词条）
function EquipAndAppear.GetEquipsSumExcellentEntryCount(actor)
    return this.GetEquipsSumExcellentEntryCount(actor)
end

---获取角色全身装备卓越词条数量（不包含再生词条）
function this.GetEquipsSumExcellentEntryCount(actor)
    local allEquip = getputonequipinfo(actor)
    if table.isNullOrEmpty(allEquip) then
        return 0
    end
    local sumCount = 0
    for _, equip in pairs(allEquip) do
        local entryAttrMap = equip.entries
        if not table.isNullOrEmpty(entryAttrMap) then
            sumCount = sumCount + table.count(entryAttrMap)
        end
    end
    return sumCount
end

---获取全身首饰等级
function this.GetSumJewelryLv(actor)
    return this.GetSumLvByType(actor, EquipAndAppear.RecordeType.MAX_JEWELRY_LEVEL)
end

function this.GetSumLvByType(actor, lvType)
    local equipList = getputonequipinfo(actor)
    if table.isNullOrEmpty(equipList) then
        return 0
    end
    local sumLv = 0
    for _, equipInfo in pairs(equipList) do
        local itemId = equipInfo.id
        local equip = EquipAndAppear.getItemExtData(actor, itemId)
        local lv = this.GetEquipLvByType(equip, lvType)
        if lv ~= 0 then
            sumLv = sumLv + lv
        end
    end
    return sumLv
end

function this.GetEquipLvByType(equip, lvType)
    if table.isNullOrEmpty(equip) then
        return 0
    end
    local lv = 0
    if lvType == EquipAndAppear.RecordeType.MAX_STRENGTH_LEVEL then
        lv = equip.strengthlv
    elseif lvType == EquipAndAppear.RecordeType.MAX_APPEND_LEVEL then
        lv = equip.appendlv
    elseif lvType == EquipAndAppear.RecordeType.MAX_JEWELRY_LEVEL then
        lv = equip.ssuplv
    end
    if lv == nil then
        return 0
    end
    return tonumber(lv)
end

---更新装备信息记录
function EquipAndAppear.TryUpdateEquipInfoRecorde(actor, recordeType)
    this.TryUpdateEquipInfoRecorde(actor, recordeType)
end

---更新装备信息记录
function this.TryUpdateEquipInfoRecorde(actor, recordeType)
    local equipInfoRecorde = EquipAndAppear.GetEquipInfoRecorde(actor)
    if recordeType == EquipAndAppear.RecordeType.MAX_STRENGTH_LEVEL then
        local oldLv = equipInfoRecorde.max_strength_level
        local newLv = EquipAndAppear.GetEquipsSumStrengthLv(actor)
        if newLv > oldLv then
            equipInfoRecorde.max_strength_level = newLv
            this.SaveEquipInfoRecorde(actor, equipInfoRecorde)
        end
    elseif recordeType == EquipAndAppear.RecordeType.MAX_APPEND_LEVEL then
        local oldLv = equipInfoRecorde.max_append_level
        local newLv = EquipAndAppear.GetEquipsSumAppendLv(actor)
        if newLv > oldLv then
            equipInfoRecorde.max_append_level = newLv
            this.SaveEquipInfoRecorde(actor, equipInfoRecorde)
        end
    elseif recordeType == EquipAndAppear.RecordeType.MAX_ENTRY_COUNT then
        local oldCount = equipInfoRecorde.max_entry_count
        local newCount = this.GetEquipsSumExcellentEntryCount(actor)
        if newCount > oldCount then
            equipInfoRecorde.max_entry_count = newCount
            this.SaveEquipInfoRecorde(actor, equipInfoRecorde)
        end
    elseif recordeType == EquipAndAppear.RecordeType.MAX_JEWELRY_LEVEL then
        local oldLv = equipInfoRecorde.max_jewelry_level
        local newLv = this.GetSumJewelryLv(actor)
        if newLv > oldLv then
            equipInfoRecorde.max_jewelry_level = newLv
            this.SaveEquipInfoRecorde(actor, equipInfoRecorde)
        end
    end
end

function EquipAndAppear.GetEquipInfoRecordeValue(actor, recordeType)
    local equipInfoRecorde = EquipAndAppear.GetEquipInfoRecorde(actor)
    if recordeType == EquipAndAppear.RecordeType.MAX_STRENGTH_LEVEL then
        return equipInfoRecorde.max_strength_level
    elseif recordeType == EquipAndAppear.RecordeType.MAX_APPEND_LEVEL then
        return equipInfoRecorde.max_append_level
    elseif recordeType == EquipAndAppear.RecordeType.MAX_ENTRY_COUNT then
        return equipInfoRecorde.max_entry_count
    elseif recordeType == EquipAndAppear.RecordeType.MAX_JEWELRY_LEVEL then
        return equipInfoRecorde.max_jewelry_level
    end
    return 0
end

function EquipAndAppear.CheckPartEquipStrengthLv(actor, part, goalLv)
    local equipList = getputonequipinfo(actor)
    if table.isNullOrEmpty(equipList) then
        return false
    end
    for _, equipInfo in pairs(equipList) do
        local itemId = equipInfo.id
        local cfgId = equipInfo.cfgid
        local equipData = EquipAndAppear.getItemExtData(actor, itemId)
        if not table.isNullOrEmpty(equipData) then
            local strengthLv = equipData.strengthlv or 0
            if part == nil and strengthLv >= goalLv then
                return true
            end
            if part ~= nil then
                local strPart = ConfigDataManager.getTableValue("cfg_item", "strpart", "id", cfgId)
                if tonumber(strPart) == part and strengthLv >= goalLv then
                    return true
                end
            end
        end
    end
    return false
end

function checkspecificstageequipcounttest(actor)
    EquipAndAppear.CheckSpecificStageEquipCount(actor, stageLimit, equipType)
end

---检查阶段装备数量
function EquipAndAppear.CheckSpecificStageEquipCount(actor, stageLimit, ratingLimit)
    local allEquip = getputonequipinfo(actor)
    if table.isNullOrEmpty(allEquip) then
        return 0
    end
    local sumCount = 0
    for _, equip in pairs(allEquip) do
        local cfgId = equip.cfgid
        local armor = this.IsArmor(cfgId)
        if armor then
            local stage = tonumber(ConfigDataManager.getTableValue("cfg_item", "rank", "id", cfgId))
            if stage ~= nil and (stageLimit == nil or stage >= stageLimit) then
                local rating = EquipAndAppear.GetEquipRating(cfgId)
                if table.isNullOrEmpty(ratingLimit) or ratingLimit == rating or table.contains(ratingLimit, rating) then
                    sumCount = sumCount + 1
                end
            end
        end
    end
    return sumCount
end

---获取装备评级
function EquipAndAppear.GetEquipRating(itemCfgId)
    local ratingScore =
        tonumber(ConfigDataManager.getTableValue("cfg_equip_entrylib", "initialrating", "id", itemCfgId))
    if ratingScore == nil then
        return 0
    end
    local equipQualityCfgList = ConfigDataManager.getTable("cfg_equip_quality")
    if table.isNullOrEmpty(equipQualityCfgList) then
        return 0
    end
    for rating, equipQualityCfg in pairs(equipQualityCfgList) do
        local stageParam = string.split(equipQualityCfg["stage"], "#")
        if ratingScore >= tonumber(stageParam[1]) and ratingScore <= tonumber(stageParam[2]) then
            return tonumber(rating)
        end
    end
    return 0
end

---是否防具
function this.IsArmor(cfgId)
    --策划要求代码写死
    local strPart = tonumber(ConfigDataManager.getTableValue("cfg_item", "strpart", "id", cfgId))
    if strPart == nil then
        return false
    end
    if strPart == 4 or strPart == 5 or strPart == 6 or strPart == 7 or strPart == 8 then
        return true
    end
    return false
end

function EquipAndAppear.SetItemExtData(actor, itemId, equipData)
    local result = setitemextdata(actor, itemId, equipData)
    if result == nil or result == false then
        gameDebug.assertPrintTrace(false, actor, "setitemextdata失败！", itemId, equipData)
    end
end

function EquipAndAppear.getItemExtData(actor, itemId)
    return getitemextdata(actor, itemId) or {}
end

--
--
--function EquipAndAppear.CheckPartEquipStrengthLv(actor, part,goalLv)
--    EquipAndAppear.CheckPartEquipInfo(actor, part, goalLv, "strengthlv")
--end
--
--function EquipAndAppear.CheckPartEquipAppendLv(actor, part, goalLv)
--
--end
--
--function EquipAndAppear.CheckPartEquipInfo(actor, part, goalLv, param)
--    jprint("--------------1", part, goalLv, param)
--    local allData = EquipAndAppear.getLuaItemExtData(actor)
--    if table.isNullOrEmpty(allData) then
--        return false
--    end
--    for itemId, equipData in pairs(allData) do
--        gameDebug.print("---- equip ----", itemId, equipData)
--        local strengthLv = equipData[param]
--        if part == nil and strengthLv >= goalLv then
--            return true
--        end
--        if part ~= nil then
--            local equip = getequipinfo(actor, itemId,1)
--            if not table.isNullOrEmpty(equip) then
--                local cfgId = equip.cfgid
--                local strPart = ConfigDataManager.getTableValue("cfg_item", "strpart", "id", cfgId)
--                if tonumber(strPart) == part and strengthLv >= goalLv then
--                    return true
--                end
--            end
--        end
--    end
--    return false
--end


function EquipAndAppear.init(actor, itemId, itemCfgId)
    local cfg_item = ConfigDataManager.getById("cfg_item", itemCfgId)
    if table.isNullOrEmpty(cfg_item) then
        return
    end
    local overlying = string.tonumber(cfg_item.overlying)
    local notEnterPack = string.tonumber(cfg_item.notenterpack)
    local itemType = tonumber(cfg_item.type)
    if itemType == ItemType.COIN or overlying > 1 or notEnterPack == 1 then
        -- 货币类型与可叠加道具不处理与不入包 不处理
        return
    end

    local itemExtData = EquipAndAppear.getItemExtData(actor, itemId)
    local isInit = itemExtData.isInit or false
    if isInit then
        return
    end

    local endTime = this.getItemDestoryTime(actor, itemId, itemCfgId)
    if endTime then
        itemExtData.endTime = endTime
    end

    itemExtData.isInit = true

    if itemType == ItemType.EQUIP then
        local attribute = string.toIntIntMap(ConfigDataManager.getTableValue("cfg_equip_entryLib", "attribute", "id", itemCfgId))
        itemExtData.baseAttr = attribute
        local durability = string.tonumber(cfg_item.durability)
        local durabilityNum = itemExtData.durabilityNum or 0
        if durability > 0 and durabilityNum < 1 then
            -- 初始化耐久度
            itemExtData.durabilityNum = durability
            --ZzpTest.print("初始化装备耐久度", itemId, itemCfgId, durability)
        end
        if not itemExtData.isDropTrigger then
            local extData = Equip_PuTong.qzEquipAtt(itemCfgId, {}, 1)
            --info(actor, "玩家", actor, "触发掉落随机相关 进背包触发 cfgId：", itemCfgId ,"内容：", extData)
            table.merge(itemExtData, extData)
        end
    end
    EquipAndAppear.SetItemExtData(actor, itemId, itemExtData)
end

function this.getItemDestoryTime(actor, id, cfgId)
    local cfg_item = ConfigDataManager.getTableFirst("cfg_item", "id", cfgId)
    local cfgTime = string.tonumber(cfg_item.useparam3)
    if cfgTime < 1 then
        return nil
    end
    local now = getbaseinfo("nowsec")
    local time = now + cfgTime
    --- 设置道具销毁时间, 不进背包与资源类 、不占格子无法生效
    setitemtimeout(actor, id, time * 1000)
    return time
end

-- 更新装备调整的属性
function EquipAndAppear.updateAdjustEquipAttr(actor)
     local diffAttr = {}
    
    local baseCareer = getbaseinfo(actor, "getbasecareer")
    local allEquip = getputonequipinfo(actor)
    local zhuShouEquip, fuShouEquip
    for _, equipInfo in pairs(allEquip) do
        local equipIndex = equipInfo.equipindex
        if equipIndex == 65537 then
            zhuShouEquip = equipInfo
        elseif equipIndex == 65538 then
            fuShouEquip = equipInfo
        end
        if zhuShouEquip ~= nil and fuShouEquip ~= nil then
            break
        end
    end

    -- 双持武器攻击力
    if fuShouEquip ~= nil and zhuShouEquip ~= nil then
        if baseCareer == CareerType.JIAN_SHI or baseCareer == CareerType.MO_JIAN_SHI then
            -- 先算当前加了多少攻击力
            local fuShouItemCfgId = fuShouEquip.cfgid
            local fuShouItemCfg = ConfigDataManager.getTableFirst("cfg_item", "id", fuShouItemCfgId)
            if not (table.count(string.split(fuShouItemCfg.strpart, "#")) < 2) then
                local zhuMinDC, zhuMaxDC = this.getEquipBasicAndStrengthDC(actor, zhuShouEquip)
                local fuMinDC, fuMaxDC = this.getEquipBasicAndStrengthDC(actor, fuShouEquip)
                local originMinDC = zhuMinDC + fuMinDC
                local originMaxDC = zhuMaxDC + fuMaxDC
                if zhuMinDC <= 0 or zhuMaxDC <= 0 or fuMinDC <= 0 or fuMaxDC <= 0 then
                    error("获取武器攻击力小于等于0，请检查", actor, zhuShouEquip, fuShouEquip)
                end
                
                -- 再算本来应该加多少攻击力
                local converMinDC, converMaxDC = 0, 0
                if baseCareer == CareerType.JIAN_SHI then
                    local jianMinDCConversionCfg = ConfigDataManager.getById("cfg_att_conversion", 101)
                    local jianMaxDCConversionCfg = ConfigDataManager.getById("cfg_att_conversion", 102)
                    converMinDC = this.getConversionAttr(actor, jianMinDCConversionCfg) * 0.1
                    converMaxDC = this.getConversionAttr(actor, jianMaxDCConversionCfg) * 0.1
                elseif baseCareer == CareerType.MO_JIAN_SHI then
                    local jianMinDCConversionCfg = ConfigDataManager.getById("cfg_att_conversion", 401)
                    local jianMaxDCConversionCfg = ConfigDataManager.getById("cfg_att_conversion", 402)
                    converMinDC = this.getConversionAttr(actor, jianMinDCConversionCfg) * 0.1
                    converMaxDC = this.getConversionAttr(actor, jianMaxDCConversionCfg) * 0.1
                end
                local nowMinDC = math.floor(converMinDC + (zhuMinDC + fuMinDC) * 0.55)
                local nowMaxDC = math.floor(converMaxDC + (zhuMaxDC + fuMaxDC) * 0.55)

                -- 减掉差值或者增加差值
                local diffMinDC = nowMinDC - originMinDC
                local diffMaxDC = nowMaxDC - originMaxDC

                if diffMinDC ~= 0 then
                    diffAttr[201021] = diffMinDC
                end
                if diffMaxDC ~= 0 then
                    diffAttr[201011] = diffMaxDC
                end
            end
        end


        -- 双持武器攻速
        -- 攻速调整，双持武器，攻速为平均值
        if baseCareer ~= CareerType.GONG_JIAN_SHOU then
            local zhuMoFaAtkSpeed, zhuWuLiAtkSpeed, zhuAtkSpeedAdd = this.getAtkSpeed(actor, zhuShouEquip)
            local fuMoFaAtkSpeed, fuWuLiAtkSpeed, fuAtkSpeedAdd = this.getAtkSpeed(actor, fuShouEquip)
            if zhuMoFaAtkSpeed > 0 and fuMoFaAtkSpeed > 0 then
                diffAttr[500125] = math.round(((zhuMoFaAtkSpeed + fuMoFaAtkSpeed) / 2) - (zhuMoFaAtkSpeed + fuMoFaAtkSpeed))
            end

            if zhuWuLiAtkSpeed > 0 and fuWuLiAtkSpeed > 0 then
                diffAttr[500126] = math.round(((zhuWuLiAtkSpeed + fuWuLiAtkSpeed) / 2) - (zhuWuLiAtkSpeed + fuWuLiAtkSpeed))
            end

            if zhuAtkSpeedAdd > 0 and fuAtkSpeedAdd > 0 then
                diffAttr[213021] = math.round(((zhuAtkSpeedAdd + fuAtkSpeedAdd) / 2) - (zhuAtkSpeedAdd + fuAtkSpeedAdd))
            end
        end
    end


    addrolekmlattributes(actor, RoleAttrKey.ADJUST_DUALWIELD_ATTR, diffAttr)
end







function EquipAndAppear.EquipAndAppearByTakeOff(actor, pos, wearBar)
    --必须是基础穿戴栏的副手武器。剑士默认单件单手武器会穿到主手上
    if wearBar ~= 1 or (pos ~= 2 and pos ~= 1) then
        return
    end
    local baseCareer = getbaseinfo(actor, "getbasecareer")
    -- 必须是剑士或魔剑士
    if baseCareer ~= CareerType.JIAN_SHI and baseCareer ~= CareerType.MO_JIAN_SHI then
        return
    end
    addrolekmlattributes(actor, RoleAttrKey.ADJUST_DUALWIELD_ATTR, {})
end

function EquipAndAppear.adjustDualWieldAttrByPuton(actor, pos, wearBar, itemCfgId)
    local baseCareer = getbaseinfo(actor, "getbasecareer")
    if pos == 3 then
        --双手武器则还原属性
        if baseCareer == CareerType.JIAN_SHI or baseCareer == CareerType.MO_JIAN_SHI then
            addrolekmlattributes(actor, RoleAttrKey.ADJUST_DUALWIELD_ATTR, {})
            return
        end
    end
    --必须是基础穿戴栏的副手武器。剑士默认单件单手武器会穿到主手上. 弓箭手不需要调整攻速属性
     if wearBar ~= 1 or pos ~= 2 or baseCareer == CareerType.GONG_JIAN_SHOU then
        return
    end
    local zhuShouEquip, fuShouEquip
    local allEquip = getputonequipinfo(actor)
    for _, equipInfo in pairs(allEquip) do
        local equipIndex = equipInfo.equipindex
        if equipIndex == 65537 then
            zhuShouEquip = equipInfo
        elseif equipIndex == 65538 then
            fuShouEquip = equipInfo
        end
        if zhuShouEquip ~= nil and fuShouEquip ~= nil then
            break
        end
    end

    if fuShouEquip == nil or zhuShouEquip == nil then
        return
    end


    local diffAttr = {}
    if baseCareer == CareerType.JIAN_SHI or baseCareer == CareerType.MO_JIAN_SHI then
        -- 先算当前加了多少攻击力
        local fuShouItemCfgId = fuShouEquip.cfgid
        local fuShouItemCfg = ConfigDataManager.getTableFirst("cfg_item", "id", fuShouItemCfgId)
        if not (table.count(string.split(fuShouItemCfg.strpart, "#")) < 2) then
            local zhuMinDC, zhuMaxDC = this.getEquipBasicAndStrengthDC(actor, zhuShouEquip)
            local fuMinDC, fuMaxDC = this.getEquipBasicAndStrengthDC(actor, fuShouEquip)
            local originMinDC = zhuMinDC + fuMinDC
            local originMaxDC = zhuMaxDC + fuMaxDC
            -- 再算本来应该加多少攻击力
            local converMinDC, converMaxDC = 0, 0
            if baseCareer == CareerType.JIAN_SHI then
                local jianMinDCConversionCfg = ConfigDataManager.getById("cfg_att_conversion", 101)
                local jianMaxDCConversionCfg = ConfigDataManager.getById("cfg_att_conversion", 102)
                converMinDC = this.getConversionAttr(actor, jianMinDCConversionCfg) * 0.1
                converMaxDC = this.getConversionAttr(actor, jianMaxDCConversionCfg) * 0.1
            elseif baseCareer == CareerType.MO_JIAN_SHI then
                local jianMinDCConversionCfg = ConfigDataManager.getById("cfg_att_conversion", 401)
                local jianMaxDCConversionCfg = ConfigDataManager.getById("cfg_att_conversion", 402)
                converMinDC = this.getConversionAttr(actor, jianMinDCConversionCfg) * 0.1
                converMaxDC = this.getConversionAttr(actor, jianMaxDCConversionCfg) * 0.1
            end
            local nowMinDC = math.floor(converMinDC + (zhuMinDC + fuMinDC) * 0.55)
            local nowMaxDC = math.floor(converMaxDC + (zhuMaxDC + fuMaxDC) * 0.55)

            -- 减掉差值或者增加差值
            local diffMinDC = nowMinDC - originMinDC
            local diffMaxDC = nowMaxDC - originMaxDC

            if diffMinDC ~= 0 then
                diffAttr[201021] = diffMinDC
            end
            if diffMaxDC ~= 0 then
                diffAttr[201011] = diffMaxDC
            end
        end
    end

    -- 攻速调整，双持武器，攻速为平均值
    local zhuMoFaAtkSpeed, zhuWuLiAtkSpeed, zhuAtkSpeedAdd = this.getAtkSpeed(actor, zhuShouEquip)
    local fuMoFaAtkSpeed, fuWuLiAtkSpeed, fuAtkSpeedAdd = this.getAtkSpeed(actor, fuShouEquip)
    if zhuMoFaAtkSpeed > 0 and fuMoFaAtkSpeed > 0 then
        diffAttr[500125] = math.round(((zhuMoFaAtkSpeed + fuMoFaAtkSpeed) / 2) - (zhuMoFaAtkSpeed + fuMoFaAtkSpeed))
    end

    if zhuWuLiAtkSpeed > 0 and fuWuLiAtkSpeed > 0 then
        diffAttr[500126] = math.round(((zhuWuLiAtkSpeed + fuWuLiAtkSpeed) / 2) - (zhuWuLiAtkSpeed + fuWuLiAtkSpeed))
    end

    if zhuAtkSpeedAdd > 0 and fuAtkSpeedAdd > 0 then
        diffAttr[213021] = math.round(((zhuAtkSpeedAdd + fuAtkSpeedAdd) / 2) - (zhuAtkSpeedAdd + fuAtkSpeedAdd))
    end

    addrolekmlattributes(actor, RoleAttrKey.ADJUST_DUALWIELD_ATTR, diffAttr)
end

function this.getAtkSpeed(actor, equipInfo)
    local wuLiAtkSpeed, moFaAtkSpeed, atkSpeedAdd = 0, 0, 0
    --基础属性 和 卓越词条 才会投放攻速
    local extData                                 = EquipAndAppear.getItemExtData(actor, equipInfo.id)
    if not table.isNullOrEmpty(extData) then
        local baseAttr = extData.baseAttr
        if table.notEmpty(baseAttr) then
            for attrId, value in pairs(baseAttr) do
                if attrId == 500126 then
                    wuLiAtkSpeed = wuLiAtkSpeed + tonumber(value)
                elseif attrId == 500125 then
                    moFaAtkSpeed = moFaAtkSpeed + tonumber(value)
                elseif attrId == 213021 then
                    atkSpeedAdd = atkSpeedAdd + tonumber(value)
                end
            end
        end
    end

    for _, entry in pairs(equipInfo.entries) do
        if entry.attrid == 213021 then
            atkSpeedAdd = atkSpeedAdd + tonumber(entry.value)
        end
    end

    return moFaAtkSpeed, wuLiAtkSpeed, atkSpeedAdd
end

function this.getConversionAttr(actor, config)
    local attr = 0
    local function convert(a, percent)
        return a * percent / 10000
    end
    local strength = getattrinfo(actor, "strength")
    local agility = getattrinfo(actor, "agility")
    local intelligence = getattrinfo(actor, "intelligence")
    local stamina = getattrinfo(actor, "stamina")
    local command = getattrinfo(actor, "command")
    attr = attr + convert(strength, string.tonumber(config.strength))
    attr = attr + convert(agility, string.tonumber(config.agility))
    attr = attr + convert(intelligence, string.tonumber(config.intelligence))
    attr = attr + convert(stamina, string.tonumber(config.stamina))
    attr = attr + convert(command, string.tonumber(config.command))
    return math.floor(attr)
end

-- 武器基础+强化攻击力
function this.getEquipBasicAndStrengthDC(actor, equipInfo)
    local minDC, maxDC = 0, 0
    -- 基础属性
    --for _, v in pairs(equipInfo.basicattr) do
    --    if v.attrid == 201021 then
    --        minDC = minDC + v.value
    --    elseif v.attrid == 201011 then
    --        maxDC = maxDC + v.value
    --    end
    --end
    -- 强化属性
    local extData = EquipAndAppear.getItemExtData(actor, equipInfo.id)
    if not table.isNullOrEmpty(extData) then
        if extData.strengthlv ~= nil and extData.strengthlv ~= 0 then
            local strengthattr = extData.strengthattr
            for attrId, value in pairs(strengthattr) do
                if attrId == 201021 then
                    minDC = minDC + tonumber(value)
                elseif attrId == 201011 then
                    maxDC = maxDC + tonumber(value)
                end
            end
        end

        local baseAttr = extData.baseAttr
        if table.notEmpty(baseAttr) then
            for attrId, value in pairs(baseAttr) do
                if attrId == 201021 then
                    minDC = minDC + tonumber(value)
                elseif attrId == 201011 then
                    maxDC = maxDC + tonumber(value)
                end
            end
        end
    end
    return minDC, maxDC
end

--- 是否是卓越装备
function EquipAndAppear.isExcellent(cfgId)
    return ConfigDataManager.getTableValue("cfg_item", "Outstanding", "id", cfgId) == "1"
end

function EquipAndAppear.filterTakeOneEquip(actor, iteminfo, isAddPoint, isTip)
    if iteminfo == nil then
        return false
    end
    local putAttr = this.getPutAtr(actor, iteminfo)
    if table.isEmpty(putAttr) then
        return true
    end
    local attrs = this.getEquipAttr(iteminfo)
    local attrSpecial = EquipAndAppear.getAttrSpecial()

    if isAddPoint then
        local needPoint = 0
        local addAttrs = {}
        for attrId, value in pairs(putAttr) do
            local attrsIds = attrSpecial[attrId]
            local newValue = this.calculateReduceNeedValue(value, attrsIds, attrs)
            local attrName = attrid2name(actor, attrId)
            local currAttrVal = getattrinfo(actor, attrName)
            if newValue > currAttrVal then
                local val = newValue - currAttrVal
                needPoint = needPoint + val
                addAttrs[attrId] = val
            end
        end
        local data = getdropdata(actor)
        local remainattrs = data.remainattrs

        if needPoint > 0 then
            if remainattrs < needPoint then
                tipinfo(actor, "可分配点数不足")
                return false
            else
                deployattrpoint(actor, addAttrs, 1)
            end
        end
    end

    -- 可能接口没拿到最新的，道具，上面添加够了，下边没校验通过 可能属性延迟导致
    --for attrId, value in pairs(putAttr) do
    --    local attrsIds = attrSpecial[attrId]
    --    local newValue = this.calculateReduceNeedValue(value, attrsIds, attrs)
    --    local attrName = attrid2name(actor, attrId)
    --    local currAttrVal = getattrinfo(actor, attrName)
    --    if newValue > currAttrVal then
    --        -- 穿戴要提示
    --        if isTip then
    --            tipinfo(actor, "未满足穿戴要求")
    --        end
    --        return false
    --    end
    --end
    return true
end

function this.getEquipAttr(iteminfo)
    local attrs = {}
    for _, v in pairs(iteminfo.basicattr) do
        local attrid = v.attrid
        local value = v.value
        attrs[attrid] = value
    end

    for _, v in pairs(iteminfo.entries) do
        local attrid = v.attrid
        local value = v.value
        attrs[attrid] = (attrs[attrid] or 0) + value
    end
    return attrs
end

function this.QiangHuaLV(actor, itemId)
    local lv = API.GetItemData(actor, itemId, "strengthlv") or "0"
    return tonumber(lv)
end

--- 获取穿戴需要达到的属性
function this.getPutAtr(actor, iteminfo)
    local cfgId = iteminfo.cfgid
    local cfg_item = ConfigDataManager.getById("cfg_item", cfgId)

    local level = string.tonumber(cfg_item.calculatelevel)
    local strengthlv = this.QiangHuaLV(actor, iteminfo.id)

    local putAttr = {}
    if strengthlv == 0 then
        -- 0级走内置cfg_equip_entryLib表useAttLimit校验
        --putAttr[10001] = qianghuall
        --putAttr[10002] = qianghuamj
        --putAttr[10003] = qianghuazl
        --putAttr[10004] = qianghuatl
        --putAttr[10005] = qianghuallts
        return putAttr
    end
    local qianghuall = string.tonumber(cfg_item.qianghuall)
    local qianghuamj = string.tonumber(cfg_item.qianghuamj)
    local qianghuazl = string.tonumber(cfg_item.qianghuazl)
    local qianghuatl = string.tonumber(cfg_item.qianghuatl)
    local qianghuallts = string.tonumber(cfg_item.qianghuallts)
    if EquipAndAppear.isExcellent(cfgId) then
        -- 穿戴属性需求:卓越装备穿戴需求属性=3×(3×强化等级+物品等级+25)x(对应需求值÷100)+20
        -- 力量
        if qianghuall > 0 then
            local llAttr = 3 * (3 * strengthlv + level + 25) * (qianghuall / 100) + 20
            putAttr[10001] = math.floor(llAttr)
        end
        -- 敏捷
        if qianghuamj > 0 then
            local mjAttr = 3 * (3 * strengthlv + level + 25) * (qianghuamj / 100) + 20
            putAttr[10002] = math.floor(mjAttr)
        end
        -- 智力
        if qianghuazl > 0 then
            local zlAttr = 3 * (3 * strengthlv + level + 25) * (qianghuazl / 100) + 20
            putAttr[10003] = math.floor(zlAttr)
        end
        -- 体力
        if qianghuatl > 0 then
            local tlAttr = 3 * (3 * strengthlv + level + 25) * (qianghuatl / 100) + 20
            putAttr[10004] = math.floor(tlAttr)
        end
        -- 统帅
        if qianghuallts > 0 then
            local tsAttr = 3 * (3 * strengthlv + level + 25) * (qianghuallts / 100) + 20
            putAttr[10005] = math.floor(tsAttr)
        end
    else
        -- 穿戴需求属性:普通装备穿戴需求属性=3×(3×强化等级+物品等级)x(配置的对应需求值÷100)+20
        -- 力量
        if qianghuall > 0 then
            local llAttr = 3 * (3 * strengthlv + level) * (qianghuall / 100) + 20
            putAttr[10001] = math.floor(llAttr)
        end
        -- 敏捷
        if qianghuamj > 0 then
            local mjAttr = 3 * (3 * strengthlv + level) * (qianghuamj / 100) + 20
            putAttr[10002] = math.floor(mjAttr)
        end
        -- 智力
        if qianghuazl > 0 then
            local zlAttr = 3 * (3 * strengthlv + level) * (qianghuazl / 100) + 20
            putAttr[10003] = math.floor(zlAttr)
        end
        -- 体力
        if qianghuatl > 0 then
            local tlAttr = 3 * (3 * strengthlv + level) * (qianghuatl / 100) + 20
            putAttr[10004] = math.floor(tlAttr)
        end
        -- 统帅
        if qianghuallts > 0 then
            local tsAttr = 3 * (3 * strengthlv + level) * (qianghuallts / 100) + 20
            putAttr[10005] = math.floor(tsAttr)
        end
    end
    return putAttr
end

function this.calculateReduceNeedValue(value, attrsIds, attrs)
    if table.isEmpty(attrs) or table.isEmpty(attrsIds) then
        return value
    end
    for _, attrId in pairs(attrsIds) do
        local attrValue = attrs[attrId] or 0
        value = value - attrValue
    end
    return math.max(value, 0)
end

local EQUIP_REDUCE_MAP = {}

-- 启动初始化数据
function EquipAndAppear.getAttrSpecial()
    if table.isEmpty(EQUIP_REDUCE_MAP) then
        local tableList = ConfigDataManager.getTable("cfg_att_special", "type", 21)
        for _, cfg in pairs(tableList) do
            local attrIds = string.split(cfg.param, "#")
            for _, attrId in pairs(attrIds) do
                attrId = tonumber(attrId)
                local cfgIds = EQUIP_REDUCE_MAP[attrId] or {}
                table.insert(cfgIds, cfg.id)
                EQUIP_REDUCE_MAP[attrId] = cfgIds
            end
        end
    end
    return EQUIP_REDUCE_MAP
end

function EquipAndAppear.updateBindState(actor, itemid, cfgId)
    changeitembindstate(actor, itemid, 1)
    local bindEqualItem = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "bindequalitem", "id", cfgId))
    if bindEqualItem > 0 then
        changeitemcfgid(actor, itemid, bindEqualItem)
    else
        error(actor, "玩家", actor, "未找到对应的绑定道具 配置错误 配置id：", cfgId)
    end
    local res = { itemId = itemid, bindId = true, cfgId = bindEqualItem }
    sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_BIND_DATA_CHANGE, res)
end

-- 防具、武器特殊属性更新
function EquipAndAppear.specialAttrUpdate(actor)
    local armorBaseDefenseBonus = getattrinfo(actor, "armorBaseDefenseBonus")
    local weaponBaseAttackBonus = getattrinfo(actor, "weaponBaseAttackBonus")
    local allEquip = getputonequipinfo(actor)
    local attackAttr = {}
    local defenseAttr = {}
    for _, equipInfo in pairs(allEquip) do
        local equipIndex = equipInfo.equipindex
        local wearBar = gameequip.wearBar(equipIndex)
        if wearBar == 1 then
            local configId = equipInfo.cfgid
            local strPartString = ConfigDataManager.getTableValue("cfg_item", "strpart", "id", configId)
            local strPart = tonumber(string.split(strPartString, "#")[1])
            local itemExtData = EquipAndAppear.getItemExtData(actor, equipInfo.id)
            local basicAttr = itemExtData.baseAttr
            if basicAttr ~= nil then
                if table.contains({ 1, 2, 3 }, strPart) then
                    --武器
                    for attId, attValue in pairs(basicAttr) do
                        if RoleAttr.isAttackAttr(attId) then
                            local changeValue = math.floor((weaponBaseAttackBonus) * attValue)
                            table.mergeAdd(attackAttr, { [attId] = changeValue })
                        end
                    end
                elseif table.contains({ 4, 5, 6, 7, 8 }, strPart) then
                    --防具
                    for attId, attValue in pairs(basicAttr) do
                        if attId == 206011 then
                            local changeValue = math.floor((armorBaseDefenseBonus) * attValue)
                            table.mergeAdd(defenseAttr, { [attId] = changeValue })
                        end
                    end
                end
            end
        end
    end
    local allChangeAttr = {}
    table.mergeAdd(allChangeAttr, attackAttr)
    table.mergeAdd(allChangeAttr, defenseAttr)
    addrolekmlattributes(actor, RoleAttrKey.EQUIP_SPECIAL_ATTR, allChangeAttr)
    setplaydef(actor, PlayerDefKey.LAST_EQUIP_SPECIAL_ATTR, { armorBaseDefenseBonus, weaponBaseAttackBonus })
end

function EquipAndAppear.equipChange(actor)
    this.checkTwoHandWeapen(actor)
end

function this.checkTwoHandWeapen(actor)
	local _specialType = 40
	local cfgAttSpecial = ConfigDataManager.getTable("cfg_att_special", "type", _specialType)
	if table.isEmpty(cfgAttSpecial) then
		return
	end

    local att_key = RoleAttrKey.EQUIP_PART_SPECIAL_ATTR
    local attMap = {}
    local allEquip = getputonequipinfo(actor)

	for _, config in pairs(cfgAttSpecial) do
		local _part = config.param
		local _attId = config.attid
		local _attribute = config.attribute

		local attribute = getattrinfo(actor, _attribute)
		if string.tonumber(attribute) == 0 then
			goto continue
		end

        local hasPart = false
        for _, equipInfo in pairs(allEquip) do
            local strPart = ConfigDataManager.getTableValue("cfg_item", "strpart", "id", equipInfo.cfgid)
            if strPart == _part then
                hasPart = true
                break
            end
        end

        -- 统计属性
        if hasPart then
            local remarks = ConfigDataManager.getTableValue("cfg_att_info", "remarks", "id", _attId)
            if string.tonumber(remarks) == 1 then
                attMap[_attId] = attribute
            else
                attMap[_attId] = attribute * 10000
            end
        end

		::continue::
	end
    addrolekmlattributes(actor, att_key, attMap)
end

--------------------------------- 文件注解 ---------------------------
---@class LuaItemExtData
---@field luaitemextdata LuaItemExt[]

---@class LuaItemExt
---@field baseAttr table 基础属性  只用于显示，耐久度会对属性值进行修改，基础属性在内置，这个用于替代，内置基础属性的真实属性值，
---@field strengthlv number 强化等级
---@field strengthattr table 强化属性
---@field originalStrengthattr table 原始强化属性
---@field ssuplv number 首饰等级
---@field ssupattr table 首饰基础属性
---@field ssactlv number 首饰等级属性激活
---@field ssactattr table 卓越属性
---@field appendlv number 追加等级
---@field appendattr table 追加属性
---@field originalAppendattr table 原始追加属性
---@field regenerationlv number 再生等级
---@field regenerationattr table 再生属性
---@field durabilityNum number 当前耐久度
---@field reduceAttr table 耐久度变化减少的属性
---@field endTime number 限时道具结束时间
---@field isInit boolean 道具是否初始化
---@field dropTip number 用于掉落提示

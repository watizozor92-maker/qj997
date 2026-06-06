EquipGem = {}
function gemtest(actor, msgData)
    -- local a = {}
    -- a.schemepos = 1
    -- a.idxOfBag = 10102
    -- a.idxOfEquip = 65538
    -- EquipGem.schemeInfo(actor,msgData)
    -- EquipGem.putOnGemOrSlabstone(actor,a)
    -- EquipGem.takeOffGemOrSlabstone(actor,a)
    -- EquipGem.schemeSwitch(actor,a)
end

---@itemId 道具唯一id
---@cfgId 道具cfgId
function EquipGem.EquipToBag(actor,itemId,cfgId)
    --判断是否是装备
    local item = ConfigDataManager.getById("cfg_item",cfgId)
    local type1 = item.type
    if tonumber(type1) ~= 2 then
       return 
    end
    local luaExtData = EquipAndAppear.getItemExtData(actor,itemId)
    local gemHoleNum = luaExtData.gemHoleNum
    if gemHoleNum then
       return 
    end
    --首次入包随机孔位数
    local holeStr = item.yingshi
    if #holeStr == 0 then
        return
    end
    local hole = string.split(holeStr,"#")
    if #hole ~= 2 then
       return 
    end
    local num1 = tonumber(hole[1])
    local num2 = tonumber(hole[2])
    if num1 == 0 then
       return 
    end
    local randomNum = math.random(num1,num2)
    luaExtData.gemHoleNum = randomNum
    EquipAndAppear.SetItemExtData(actor,itemId,luaExtData)
end

function EquipGem.GenerateGemEntries(actor, itemId, cfgId)
    local item = ConfigDataManager.getById("cfg_item", cfgId)
    local type = tonumber(item.type)
    local subType = tonumber(item.subtype)
    if type ~= 5 or subType ~= 4 then
        return
    end
    local luaExtData = EquipAndAppear.getItemExtData(actor, itemId)
    local gemAttrData = luaExtData.gemAttr or {}
    if table.notNullOrEmpty(gemAttrData) then
        return
    end
    local gemCfg = ConfigDataManager.getById("cfg_equip_gem", cfgId)
    if table.isNullOrEmpty(gemCfg) then
        return
    end
    local gemAtt = string.toStringIntMap(gemCfg.gematt)
    if table.isNullOrEmpty(gemAtt) then
        return
    end

    local attId =  RandomUtil.randomKey(gemCfg.gematt)
    if not gemAtt[attId] then
        return
    end
    gemAttrData[attId] = gemAtt[attId]
    luaExtData.gemAttr = gemAttrData
    EquipAndAppear.SetItemExtData(actor, itemId, luaExtData)
end

-- 萤石方案详情
function EquipGem.schemeInfo(actor, msgData)
    local gemScheme = getGemscheme(actor)
    -- sendluamsg(actor, LuaMessageIdToClient.RES_GEM_SCHEME, gemScheme)
end

-- 萤石方案镶嵌宝石或者石板
function EquipGem.putOnGemOrSlabstone(actor, msgData)
    local id = msgData.itemid
    local itemId = msgData.equipid
    local gemItem = getbagiteminfo(actor,id,1)
    if not gemItem then
       return
    end
    local gemId = gemItem.cfgid
    --校验宝石是否镶嵌
    if not cellVerify(actor, itemId, gemId) then
        return
    end
    --检查镶嵌消耗
    local gemTbl = ConfigDataManager.getTableFirst("synhtesis_yingshi","synthesisType",3)
    if not gemTbl then
       return
    end
    local inlayCost = gemTbl.consumeitem
    local cost =  EquipGem.splitGemCost({},inlayCost,"#","|")
    if not Bag.checkCostMap(actor,cost) then
        tipinfo(actor, "消耗不足")
        return 
    end
    --获取装备信息
    local luaExtData = EquipAndAppear.getItemExtData(actor,tonumber(itemId))
    local gemScheme = luaExtData.gemScheme or {}
    --检验装备是否镶嵌已满
    local hole = luaExtData.gemHoleNum or 0
    if table.count(gemScheme) >= hole then
        tipinfo(actor, "装备孔位已经镶嵌满了")
        return 
    end
    -- Bag.cost(actor,gemId,1,"萤石镶嵌")
    local bagIndex = gemItem.bagindex
    local luaExtData2 = EquipAndAppear.getItemExtData(actor,tonumber(id))
    local gemAttr = luaExtData2.gemAttr
    removeitembyidxlist(actor,{bagIndex},9999,"萤石镶嵌")
    Bag.costMap(actor,cost,"萤石镶嵌")
    --获取宝石信息
    local map = {cfgId = gemId,attr = gemAttr}
    table.insert(gemScheme,map)
    luaExtData.gemScheme = gemScheme
    EquipAndAppear.SetItemExtData(actor,tonumber(itemId),luaExtData)
    sendluamsg(actor, LuaMessageIdToClient.RES_GEM_CURRENT_SCHEME, {itemId = itemId})
    updateAttr(actor, {})
    -- 刷新任务进度
    -- EquipGem.flushGemTask(actor)
end

function EquipGem.splitGemCost(map, str, sep1, sep2)
    sep1 = sep1 or "#"
    sep2 = sep2 or "|"
    if not string.isNullOrEmpty(str) then
        local data = string.split(str, sep2)
        for _, v in ipairs(data) do
            local data2 = string.split(v, sep1)
            map[data2[2]] = (map[data2[2]] or 0) + tonumber(data2[3])
        end
    end
    return map
end

-- 萤石卸载
function EquipGem.takeOffGemOrSlabstone(actor, msgData)
    local itemId = msgData.itemid
    --检查卸载消耗
    local gemTbl = ConfigDataManager.getTableFirst("synhtesis_yingshi","synthesisType",4)
    if not gemTbl then
       return
    end
    local inlayCost = gemTbl.consumeitem
    local cost =  EquipGem.splitGemCost({},inlayCost,"#","|")
    if not Bag.checkCostMap(actor,cost) then
        tipinfo(actor, "消耗不足")
        return 
    end
    --获取装备信息
    local luaExtData = EquipAndAppear.getItemExtData(actor,tonumber(itemId))
    local gemList = luaExtData.gemScheme
    if table.count(gemList) == 0 then
        --该装备没有镶嵌萤石
       return 
    end
    local checkList = {}
    for _, gemInfo in pairs(gemList) do
        local gemCfgId = gemInfo["cfgId"]
        checkList[gemCfgId] = 1
    end
    local full = isbagfullorhasspace(actor,checkList)
    if not full then
        tipinfo(actor, "背包空间不足")
        return
    end
    Bag.costMap(actor,cost,"萤石卸载")
    for _, gemInfo in pairs(gemList) do
        local gemCfgId = gemInfo["cfgId"]
        local gemAttr = gemInfo["attr"]
        local id = additemtobag(actor, tonumber(gemCfgId), 1,0,9999,"萤石卸载")
        --这里要处理一种卸载后道具不能入包的情况
        if id and id ~= 0 then
           --正常入包
           local luaExtData2 = EquipAndAppear.getItemExtData(actor,tonumber(id))
           luaExtData2.gemAttr = gemAttr
           EquipAndAppear.SetItemExtData(actor,tonumber(id),luaExtData2)
        end
    end
    luaExtData.gemScheme = {}
    EquipAndAppear.SetItemExtData(actor,tonumber(itemId),luaExtData)
    sendluamsg(actor, LuaMessageIdToClient.RES_GEM_CURRENT_SCHEME, {itemId = itemId})
    updateAttr(actor, {})
    -- EquipGem.flushGemTask(actor)
end

-- 萤石方案切换
function EquipGem.schemeSwitch(actor, msgData)
    local schemepos = msgData.schemepos
    local gemScheme = getGemscheme(actor)
    local scheme = gemScheme.data[schemepos]
    if scheme == nil then
        tipinfo(actor, "找不到方案")
        return
    end

    local oldpos = gemScheme.cur
    local oldscheme = gemScheme.data[oldpos]
    if oldscheme == nil then
        tipinfo(actor, "找不到方案")
        return
    end

    if gemScheme.cur == schemepos then
        tipinfo(actor, "方案已激活")
        return
    end

    oldscheme.active = false
    scheme.active = true
    gemScheme.cur = schemepos

    setplaydef(actor, "T$gemscheme", gemScheme)
    updateAttr(actor, gemScheme)

    sendluamsg(actor, LuaMessageIdToClient.RES_GEM_CURRENT_SCHEME, scheme)
    EquipGem.flushGemTask(actor)
end

-- 刷新镶嵌宝石任务进度
function EquipGem.flushGemTask(actor)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.INLAID_GEMSTONES)
end

function EquipGem.getAllGemCount(actor)
    local final_count = 0
    local gem_info = getGemscheme(actor)
    local scheme_info = gem_info.data[gem_info.cur].scheme
    if table.isEmpty(scheme_info) then
        return final_count
    end

    for _, info in pairs(scheme_info) do
        if info.active then
            local value = table.isEmpty(info.gems) and 0 or #info.gems
            final_count = final_count + value
        end
    end
    return final_count
end

-- 装备是否生效影响 萤石方案属性 是否失效
function EquipGem.schemeEffectByBoolean(actor, map, effect)
    local gemScheme = getGemscheme(actor)
    local cur = gemScheme.cur
    -- local scheme = gemScheme.data[gemScheme.cur]
    for schemeIndex, scheme in pairs(gemScheme.data) do
        
        local update = false
        for _, pos in pairs(map) do
            local data = scheme.scheme[pos]
            if data and data.active ~= effect then
                data.active = effect
                update = true
            end
        end
        -- 当前方案某装备激活,更新对应属性
        local isCur = (cur == schemeIndex)
        if update and isCur then
            updateAttr(actor, gemScheme)
        end
        setplaydef(actor, "T$gemscheme", gemScheme)
        -- 测试看数据 sendluamsg(actor,LuaMessageIdToClient.RES_GEM_SCHEME,gemScheme)
    end
end

function EquipGem.getOtherGemScheme(actor, msgData)
    local rid = msgData.rid
    if not rid then
        return
    end
    local player = getactor(actor, rid)
    if not player then
        return
    end
    local gemScheme = getGemscheme(player)
    if actor:toString() ~= player:toString() then
        gemScheme.rid = rid
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_GEM_SCHEME, gemScheme)
end
function EquipGem.updateGemAttr(actor)
    updateAttr(actor, {})
end

-- 更新萤石方案属性
function updateAttr(actor, gemScheme)
    local allattr = {}
    local suit = {}
    --根据玩家当前装备信息获取当前生效的萤石属性
    local allEquipInfo = getputonequipinfo(actor)
    for _, equip in pairs(allEquipInfo) do
        local itemId = equip.id
        local luaExtData = EquipAndAppear.getItemExtData(actor,tonumber(itemId))
        gemScheme = luaExtData.gemScheme or {}
        if table.count(gemScheme) > 0 then
            local partId = gameequip.pos(tonumber(equip.equipindex))
            for _, gemInfo in pairs(gemScheme) do
                --存在即生效
                local attr = gemInfo.attr or {}
                table.mergeAdd(allattr,attr)
            end
            suit[partId] = gemScheme
        end
    end
    -- 萤石套装属性
    local suitConfigs = ConfigDataManager.getList("cfg_equip_gemSuit")
    for _, tbl in pairs(suitConfigs) do
        local attType = tbl.atttype
        if tonumber(attType) == 1 then
           --只适用于单个部位
           local gemTypeList = EquipGem.splitGemCondition(tbl.gemcondition)
           local length = table.count(gemTypeList)
            for _, partGem in pairs(suit) do
                local flag = true
                for i=1,length do
                    local gemInfo = partGem[i]
                    if gemInfo then
                        if tonumber(gemInfo.cfgId) ~= tonumber(gemTypeList[i]) then
                            flag = false
                        end
                    else
                        flag = false
                    end
                    
                end
                if flag then
                    --当前部件套装属性生效 符合条件 计算套装属性
                    local suitAtt = string.putStringIntMap({},tbl.suitatt,"#","|")
                    table.mergeAdd(allattr,suitAtt)
                end
            end
        end
        if tonumber(attType) == 2 then
            local gemList = {}
            for _, partGem in pairs(suit) do
                for _, gemInfo in ipairs(partGem) do
                    table.insert(gemList,gemInfo.cfgId)
                end
            end
            local gemTypeList = string.putStringIntMap({},tbl.gemcondition,"#","|")
            --判断是否符合当前套装条件
            local flag = true
            for type, count in pairs(gemTypeList) do
                local num = 0
                for _, gemId in pairs(gemList) do
                    local gemType = EquipGem.getGemType(gemId)
                    if tonumber(type) == gemType then
                    num = num + 1
                    end
                end
                if count > num then
                    flag = false
                    break
                end
            end
            if flag then
                --符合条件 计算套装属性
                local suitAtt = string.putStringIntMap({},tbl.suitatt,"#","|")
                table.mergeAdd(allattr,suitAtt)
            end
        end
    end
    -- 测试看数据 sendluamsg(actor,LuaMessageIdToClient.RES_GEM_SCHEME,{["总属性"]= allattr})
    addrolekmlattributes(actor, "gemscheme", allattr)
end

function EquipGem.splitGemCondition(str)
    if not str then
       return {} 
    end
    if #str == 0 then
       return {} 
    end
    local result = {}
    local a = string.split(str,"|")
    for i = 1,#a do
        local b = string.split(a[i],"#")
        result[i] = b[1]
    end
    return result
end

--根据萤石cfgId获取萤石类型
function EquipGem.getGemType(gemId)
    local gemTbl = ConfigDataManager.getById("cfg_equip_gem",gemId)
    local gemBelong = string.split(gemTbl.gembelong,"#")[1]
    return tonumber(gemBelong)
end

function attrUpByPc(attr_map, attr_up)
    attr = {}
    for key, value in pairs(attr_map) do
        attr[key] = math.ceil(value * (1 + attr_up / 10000.0))
    end
    return attr
end

function cellVerify(actor, itemId, cfgId)
    -- 判断是否能镶嵌
    local info = getequipinfo(actor, itemId, 1)
    local equipCfgId = info.cfgid
    local strPart = ConfigDataManager.getTableValue("cfg_item","strPart","id",equipCfgId)
    local pos = string.split(strPart,"#")[1]
    local configPos = ConfigDataManager.getTableValue("cfg_equip_gem", "wearbarPos", "id", cfgId)
    if not string.contains(configPos, pos) then
        tipinfo(actor, "该位置无法镶嵌")
        return false
    end
    --判断当前装备镶嵌萤石是否满了
    local luaExtData = EquipAndAppear.getItemExtData(actor,tonumber(itemId))
    local gemScheme = luaExtData.gemScheme or {}
    --检验装备是否镶嵌已满
    local hole = luaExtData.gemHoleNum or 0
    if table.count(gemScheme) >= hole then
        tipinfo(actor, "装备孔位已经镶嵌满了")
        return 
    end
    local configWearbar = ConfigDataManager.getTableValue("cfg_equip_gem", "wearbar", "id", cfgId)
    local num = tostring(table.count(gemScheme) + 1)
    if not string.contains(configWearbar, num) then
        tipinfo(actor, "该萤石无法镶嵌到该装备上")
        return false
    end
    return true
end

function getGemscheme(actor)
    local playData = getplaydef(actor, "T$gemscheme")
    if playData == nil then
        playData = gemschemeInit(actor)
    end
    return playData;
end

function EquipGem.GetGemScheme(actor,itemId)
    local luaExtData = EquipAndAppear.getItemExtData(actor,itemId)
    return luaExtData.gemScheme or {}
end

function gemschemeInit(actor)
    local gemScheme = {}
    setplaydef(actor, "T$gemscheme", gemScheme)
    return gemScheme
end

-- =======套装属性相关=======


function EquipGem.getConfigByAttr(configs, attrName)
    for _, cfg in pairs(configs) do
        local value = cfg[string.lower(attrName)]
        if value and value ~= "" then
            -- lg(value)
            return cfg
        end
    end
    return nil
end

function EquipGem.getConfigByIdAndAttr(activeIds, attrName)
    if not activeIds then
        return nil
    end
    for _, id in ipairs(activeIds) do
        local config = ConfigDataManager.getById("cfg_equip_gemsuit", id)
        if not config then
            return nil
        end
        local value = config[string.lower(attrName)]
        if value ~= "" and value ~= nil then
            return config
        end
    end
    return nil
end

function EquipGem.dataAndType(actor, attrName)
    local data = getplaydef(actor, "T$gemSuitConfig") or {}
    if table.isNullOrEmpty(data) then
        return nil
    end
    local dataType = 0
    for _, v in pairs(data) do
        if type(v) == "string" then
            dataType = 2
            break
        elseif type(v) == "table" then
            dataType = 1
            break
        end
    end

    if dataType == 0 then
        return nil
    elseif dataType == 1 then
        data = EquipGem.getConfigByAttr(data, attrName)
        return data
    else
        data = EquipGem.getConfigByIdAndAttr(data, attrName)
        return data
    end
end

function EquipGem.updateAttrGroup(actor, groupName, attrName, value)
    updateattrgroup(actor, groupName, attrName, value)
end

function EquipGem.sendHpChangeMessage(actor, recovery, target)
    sendluamsg(actor, LuaMessageIdToClient.RES_GEM_RECOVERY_HP_INFO,
        { text = recovery, hurtType = 118, targetId = target:toString() })
end

function EquipGem.selectRate(probability)
    local randomNum = math.random()
    return randomNum <= probability
end

function EquipGem.parseConfigValue(valueStr)
    local valueArr = string.splitByAll(valueStr, "#")
    local probability = tonumber(valueArr[1]) / 10000
    local ratio = tonumber(valueArr[2]) / 10000
    return probability, ratio
end

-- 检查时间
function EquipGem.checkSpeedTime(actor, config)
    local timeInfo = getplaydef(actor, "@gemSpeedTimeInfo")
    if not timeInfo then
        return 0
    end
    local speedBonus = config["anispeedbonus"]
    local lastingtime = tonumber(string.splitByAll(speedBonus, "#")[3])
    local cd = tonumber(string.splitByAll(speedBonus, "#")[4])
    local nowSec = getbaseinfo(actor, "nowsec")
    local useTime = timeInfo["useTime"] or 0
    if nowSec - useTime <= lastingtime then
        return 1
    elseif nowSec - useTime > lastingtime and nowSec - useTime < lastingtime + cd then
        return 2
    else
        return 3
    end
end

function EquipGem.checkRecoveryHpTime(actor, config)
    local useTime = getplaydef(actor, "@gemHpRecoveryTime")
    if not useTime then
        return true
    end
    local beAttackRecover = config["beattackrecover"]
    local cd = tonumber(string.splitByAll(beAttackRecover, "#")[3])
    if not cd or cd == "" then
        return true
    end
    local nowSec = getbaseinfo(actor, "nowsec")
    if nowSec - useTime <= cd then
        return false
    end
    return true
end

function EquipGem.handleGemAttrs(caster, target, targetHurt, casterType, targetType)
    local hurt = EquipGem.setGemAttrs(caster, "damageRate", targetHurt)
    if casterType == MapObjectType.PLAYER and targetType == MapObjectType.PLAYER then
        hurt = EquipGem.setGemAttrs(target, "damageAbsorb", hurt)
    end
    return hurt
end

-- 设置宝石伤害增减
function EquipGem.setGemAttrs(actor, attrName, hurt)
    local config = EquipGem.dataAndType(actor,attrName)
    -- lg("伤害增减:",attrName, config)
    if not config then
        return hurt
    end
    local probability, ratio = EquipGem.parseConfigValue(config[string.lower(attrName)])
    if EquipGem.selectRate(probability) then
        if attrName == "damageRate" then
            hurt = hurt * (1 + ratio)
        elseif attrName == "damageAbsorb" then
            hurt = hurt * (1 - ratio)
        end
    end
    return hurt
end

-- 设置宝石恢复
function EquipGem.setGemRecovery(actor, fightParam)
    local hurt = fightParam["targethurt"]
    local casterType = fightParam["castertype"]
    local targetType = fightParam["targettype"]
    if casterType == MapObjectType.PLAYER and targetType == MapObjectType.PLAYER then
        local config = EquipGem.dataAndType(actor,"beattackrecover")
        -- lg("恢复:", config)
        if not config then
            return
        end
        if not EquipGem.checkRecoveryHpTime(actor, config) then
            return
        end
        local probability, ratio = EquipGem.parseConfigValue(config["beattackrecover"])
        if EquipGem.selectRate(probability) then
            local recovery = math.ceil(hurt * ratio)
            local currHp = getbaseinfo(actor, "hp")
            local fixHp = recovery + currHp
            sethp(actor, fixHp)
            -- local caster = fightParam["caster"]
            EquipGem.sendHpChangeMessage(actor, recovery, actor)

            -- local nearPlayers = getnarplayer(actor)
            -- for _, playInfo in ipairs(nearPlayers) do
            --     local play = playInfo["luaplayer"]
            --     if play:toString() ~= actor:toString() then
            --         EquipGem.sendHpChangeMessage(play, recovery, actor)
            --     end
            -- end
            setplaydef(actor, "@gemHpRecoveryTime", getbaseinfo(actor, "nowsec"))
        end
    end
end

-- 设置速度加成
function EquipGem.setSpeedBonus(actor)
    local config = EquipGem.dataAndType(actor,"anispeedbonus")
    -- lg("速度:", config)
    local timeInfo = getplaydef(actor, "@gemSpeedTimeInfo")
    if not config and not timeInfo then
        return
    elseif not config and timeInfo then
        local configId = timeInfo["cfgId"]
        config = ConfigDataManager.getById("cfg_equip_gemSuit", configId)
    end
    if not config then
        return
    end
    local nowSec = getbaseinfo(actor, "nowsec")
    local configId = tonumber(config["id"])
    local probability, ratio = EquipGem.parseConfigValue(config["anispeedbonus"])
    local value = getattrinfo(actor, "AniSpeedBonus")
    local id = attrname2id("AniSpeedBonus")
    local remarks = tonumber(ConfigDataManager.getTableValue("cfg_att_info", "remarks", "id", id))
    -- lg(value)
    if timeInfo then
        local preCfgId = timeInfo["cfgId"]
        local preConfig = ConfigDataManager.getById("cfg_equip_gemSuit", preCfgId)
        local stage = EquipGem.checkSpeedTime(actor, preConfig)
        if stage == 1 then
            -- lg(1)
            return
        elseif stage == 2 then
            -- lg(2)
            EquipGem.updateAttrGroup(actor, "gemSuitAttr", "AniSpeedBonus", 0)
        elseif stage == 3 then
            -- lg(3)
            if EquipGem.selectRate(probability) then
                local num = value * ratio
                if remarks == 2 then
                    num = num * 10000 < 0 and 0 or num * 10000
                end
                -- lg("攻击速度选中:", num)
                EquipGem.updateAttrGroup(actor, "gemSuitAttr", "AniSpeedBonus", num)
                setplaydef(actor, "@gemSpeedTimeInfo", { useTime = nowSec, cfgId = configId })
            end
        end
    else
        if EquipGem.selectRate(probability) then
            -- lg(0)
            local num = value * ratio
            if remarks == 2 then
                num = num * 10000 < 0 and 0 or num * 10000
            end
            EquipGem.updateAttrGroup(actor, "gemSuitAttr", "AniSpeedBonus", num)
            setplaydef(actor, "@gemSpeedTimeInfo", { useTime = nowSec, cfgId = configId })
        end
    end
    -- lg(getattrinfo(actor, "AniSpeedBonus"))
    -- lg("====================================")
end

function testgem(actor, hurt)
    hurt = EquipGem.setGemAttrs(actor, "damageRate", hurt)
    hurt = EquipGem.setGemAttrs(actor, "damageAbsorb", hurt)
    lg(hurt)
end

-- ==============================脚本内全局变量========================================
local scriptConst = {
    -- 一级属等级配置
    FIRST_LEVEL_ATTR_CONFIG = 1,
    -- 一级属性最大值配置id
    FIRST_LEVEL_ATTR_MAX_VALUE_CONFIG = 3001,
    -- 重置果实配置
    RESET_FIRST_LEVEL_ATTR_CONDITION = 3002,
    -- 使用成功提示
    FRUIT_SUCCESS = 200,
    -- 使用失败提示
    FRUIT_FAIL = 201,
}

---玩家累计使用果实数量
local USE_FRUIT_COUNT = "T$use_fruit_count"
-- =====================================存储上次的果实使用信息实体===================================
local LastUsageInfo = {}
LastUsageInfo.__index = LastUsageInfo

function LastUsageInfo:new()
    local obj = { lastUsageTime = 0, usageCount = 0 }
    setmetatable(obj, LastUsageInfo)
    return obj
end

-- ====================================使用cd检验工具======================================
local ItemCanUseTool = {}
ItemCanUseTool.__index = ItemCanUseTool

function ItemCanUseTool:new(maxUsageCount, cooldownSeconds, useageInfos)
    local self = setmetatable({
        maxUsageCount = maxUsageCount,
        cooldownMilSeconds = cooldownSeconds * 1000,
        usageInfos = useageInfos or {}
    }, ItemCanUseTool)
    return self
end

function ItemCanUseTool:canUseItem(actor, itemId)
    if self.maxUsageCount == -1 or self.cooldownMilSeconds == -1 then
        -- 不限制
        return true
    end
    local oneInfo = self.usageInfos[itemId]
    if not oneInfo then
        return true
    end
    local lastTime = oneInfo.lastUsageTime

    local curTime = getbaseinfo(actor, "now")
    local timeSinceLastUse = curTime - lastTime
    if timeSinceLastUse >= self.cooldownMilSeconds then
        oneInfo.usageCount = 0
        return true
    end

    return oneInfo.usageCount < self.maxUsageCount
end

function ItemCanUseTool:useItem(actor, itemId, count)
    local oneInfo = self.usageInfos[itemId] or LastUsageInfo:new()
    self.usageInfos[itemId] = oneInfo
    local curTime = getbaseinfo(actor, "now")
    oneInfo.lastUsageTime = curTime
    oneInfo.usageCount = oneInfo.usageCount + count
end

-- ================================================果实逻辑脚本模板==========================================================
FruitScript = {}
FruitScript.__index = FruitScript
function FruitScript:new()
    local obj = setmetatable({}, FruitScript)
    return obj
end

local fruitScript = FruitScript:new()

function FruitScript.handleUseFruit(actor, cfgId, count)

    local config = ConfigDataManager.getById("cfg_fruit", cfgId)
    if table.isEmpty(config) then
        return
    end
    local useCfgId = cfgId
    local useCount = count
    local realUseCount, currAttrAddValue = fruitScript:useFruit(actor, useCfgId, useCount);
    local recoveryCount = 0
    if realUseCount == 0 then
        recoveryCount = count
    end

    if realUseCount ~= count and realUseCount > 0 then
        recoveryCount = count - realUseCount
    end

    if recoveryCount ~= 0 then
        additemtobag(actor, cfgId, recoveryCount, 0, 9999, ItemActionProxy.FRUIT)
    end
    local msg = currAttrAddValue > 0 and true or false
    sendluamsg(actor, LuaMessageIdToClient.USE_FRUIT_RESULT, msg)

    if realUseCount ~= nil and realUseCount > 0 then
        --记录使用数量
        local oldCount = FruitScript.GetUseFruitCount(actor)
        setplaydef(actor, USE_FRUIT_COUNT, oldCount + realUseCount)
        ---使用果实任务
        TaskHandler.TriggerTaskGoal(actor, TaskTargetType.USE_FRUIT_ITEM)
    end
end

---获取玩家累计使用果实数量
function FruitScript.GetUseFruitCount(actor)
    local totalCount = getplaydef(actor, USE_FRUIT_COUNT)
    if totalCount == nil then
        totalCount = 0
    end
    return totalCount
end

function FruitScript.toGetAlreadyUsePoints(actor)
    fruitScript:getAlreadyUsePoints(actor)
end

function FruitScript.resetFruit(actor, msgData)
    fruitScript:resetFruitAttr(actor, msgData)
end

function FruitScript.toGetResetCount(actor)
    fruitScript:getResetCount(actor)
end

-- ===================================使用果实============================================
function FruitScript:useFruit(actor, cfgId, count)
    if count <= 0 then
        return 0, 0
    end
    local config = ConfigDataManager.getById("cfg_fruit", cfgId)
    if config == nil or next(config) == nil then
        return 0, 0
    end
    local hasCount = getbagitemcountbyid(actor, cfgId)

    -- 这里加上count是因为判断的逻辑在消耗了果实之后,要判断消耗之前的
    if hasCount == nil or tonumber(hasCount) + count <= 0 then
        return 0, 0
    end
    if count > tonumber(hasCount) + count then
        return 0, 0
    end

    local canUse = self:canUseFruit(actor, cfgId)
    if not canUse then
        return 0, 0
    end

    local fruitData = getplaydef(actor, "T$fruit_data") or {}
    local lastUsageInfos = fruitData["lastUsageInfo"] or {}
    fruitData["lastUsageInfo"] = lastUsageInfos

    -- 单个使用cd检查
    local coolingTime = ConfigDataManager.getTableValue("cfg_item", "coolingTime", "id", cfgId)
    if coolingTime ~= nil and coolingTime ~= "" then
        local curTime = getbaseinfo(actor, "now")
        local lastUsageInfo = lastUsageInfos[cfgId] or LastUsageInfo:new()
        local lastUsageTime = lastUsageInfo["lastUsageTime"] or 0
        if lastUsageTime ~= 0 then
            local timeSinceLastUse = curTime - lastUsageTime
            if timeSinceLastUse < tonumber(coolingTime) then
                return 0, 0
            end
        end
    end

    -- 使用多个后cd检查
    local canUseManager = nil
    local countAndTimeLimit = ConfigDataManager.getTableValue("cfg_item", "useLimit", "id", cfgId)
    if countAndTimeLimit ~= nil and countAndTimeLimit ~= "" then
        local splits = string.split(countAndTimeLimit, "#")
        local countLimit = tonumber(splits[1])
        if count > countLimit then
            return 0, 0
        end
        local timeLimit = tonumber(splits[2])
        canUseManager = ItemCanUseTool:new(countLimit, timeLimit, lastUsageInfos)
        local canUseItem = canUseManager:canUseItem(actor, cfgId)
        if not canUseItem then
            local tipTime = timeLimit / 60
            -- lg('使用数量达到上限' .. countLimit .. ',请等待' .. tipTime .. '分钟再使用!')
            return 0, 0
        end
    end

    local realUseCount, currAttrAddValue = self:addFruitAttrPoint(actor, count, cfgId, fruitData)
    if realUseCount == 0 then
        -- 使用失败或者添加值为零
        return 0, 0
    end

    if canUseManager == nil then
        -- 不限制使用,在这里初始化
        canUseManager = ItemCanUseTool:new(-1, -1, lastUsageInfos)
    end
    canUseManager:useItem(actor, cfgId, realUseCount)

    -- 更新果实的使用信息
    setplaydef(actor, "T$fruit_data", fruitData)
    gameDebug.print(actor, "使用果实成功", realUseCount, currAttrAddValue)
    self:getAlreadyUsePoints(actor)
    return realUseCount, currAttrAddValue
end

-- 添加属性点
function FruitScript:addFruitAttrPoint(actor, count, cfgId, fruitData)
    local fruitAttrId = ConfigDataManager.getTableValue("cfg_fruit", "attribute", "id", cfgId)
    if fruitAttrId == "" or tonumber(fruitAttrId) <= 0 then
        return 0, 0
    end

    local attributeGroup = ConfigDataManager.getTableValue("cfg_fruit", "group", "id", cfgId)
    if attributeGroup == "" or tonumber(attributeGroup) <= 0 then
        return 0, 0
    end
    local realUseFruitCount = 0
    local currAttrAddValue = 0
    if self:isFirstLevelAttribute(fruitAttrId) then
        realUseFruitCount, currAttrAddValue = self:firstLevelAttrLogic(actor, cfgId, fruitAttrId, count,
            attributeGroup, fruitData)
    else
        realUseFruitCount, currAttrAddValue = self:notFirstLevelAttrLogic(actor, cfgId, fruitAttrId, count,
            attributeGroup, fruitData)
    end
    if realUseFruitCount == 0 then
        return 0, 0
    end
    if realUseFruitCount > 0 and currAttrAddValue > 0 then
        local attrName = ConfigDataManager.getTableValue("cfg_att_info", "attribute", "id", fruitAttrId)
        if attrName == nil or attrName == nil then
            return false
        end
        local newFruitData = getplaydef(actor, "T$fruit_data") or {}
        local newFruitAttrPoints = newFruitData["fruitAttrPoints"] or {}
        addrolekmlattributes(actor, "fruitAttrs", newFruitAttrPoints)
    end
    return realUseFruitCount, currAttrAddValue
end

-- 第一级属性点添加逻辑
function FruitScript:firstLevelAttrLogic(actor, cfgId, fruitAttrId, count, attributeGroup, fruitData)
    local realUseFruitCount = 0
    local maxFirstPoint = ConfigDataManager.getTableValue("cfg_global", "value", "id", scriptConst
        .FIRST_LEVEL_ATTR_MAX_VALUE_CONFIG)
    if maxFirstPoint == "" or maxFirstPoint == nil then
        return 0, 0
    end
    maxFirstPoint = tonumber(maxFirstPoint)
    local fruitAttrPoints = fruitData["fruitAttrPoints"] or {}
    fruitData["fruitAttrPoints"] = fruitAttrPoints

    local totalAddValue = 0
    while count > 0 do
        local nowTotal = self:getFruitPointsByLevel(actor)
        local oldFruitAttr = fruitAttrPoints[tonumber(fruitAttrId)] or 0
        local probability = ConfigDataManager.getTableValue("cfg_fruitgroup", "probability", "acquired", nowTotal,
            "group", attributeGroup)
        local probabilityArr = string.splitByAll(probability, "#")
        local index = self:selectIndexByWeight(probabilityArr)
        local values = ConfigDataManager.getTableValue("cfg_fruitgroup", "number", "acquired", nowTotal, "group",
            attributeGroup)
        local realAddAttrValue = tonumber(string.splitByAll(values, "#")[index])

        if nowTotal >= maxFirstPoint then
            break
        end

        if nowTotal + realAddAttrValue >= maxFirstPoint then
            realUseFruitCount = realUseFruitCount + 1
            local realAddThisTime = maxFirstPoint - nowTotal
            totalAddValue = totalAddValue + realAddThisTime
            fruitAttrPoints[tonumber(fruitAttrId)] = oldFruitAttr + realAddThisTime
            break
        end

        if nowTotal + realAddAttrValue < maxFirstPoint then
            realUseFruitCount = realUseFruitCount + 1
            totalAddValue = totalAddValue + realAddAttrValue
            fruitAttrPoints[tonumber(fruitAttrId)] = oldFruitAttr + realAddAttrValue
        end
        count = count - 1
        if realAddAttrValue > 0 then
            local attrTipName = ConfigDataManager.getTableValue("cfg_att_info", "name", "id", fruitAttrId)
            local tipInfo = realAddAttrValue
            noticeTip.noticeinfo(actor, scriptConst.FRUIT_SUCCESS, attrTipName, tipInfo)
        else
            noticeTip.noticeinfo(actor, scriptConst.FRUIT_FAIL)
        end
        -- 更新果实属性值
        setplaydef(actor, "T$fruit_data", fruitData)
    end

    return realUseFruitCount, totalAddValue
end

-- 非属性点第一级添加逻辑
function FruitScript:notFirstLevelAttrLogic(actor, cfgId, fruitAttrId, count, attributeGroup, fruitData)
    local realUseFruitCount = 0
    local fruitAttrPoints = fruitData["fruitAttrPoints"] or {}
    fruitData["fruitAttrPoints"] = fruitAttrPoints

    -- 一级属性之外的属性不设上限
    local totalAddValue = 0
    while count > 0 do
        local oldFruitAttr = fruitAttrPoints[tonumber(fruitAttrId)] or 0
        local nowTotal = self:getFruitPointsByLevel(actor, attributeGroup)
        local probability = ConfigDataManager.getTableValue("cfg_fruitgroup", "probability", "acquired", nowTotal,
            "group", attributeGroup)
        local probabilityArr = string.splitByAll(probability, "#")
        local index = self:selectIndexByWeight(probabilityArr)
        local values = ConfigDataManager.getTableValue("cfg_fruitgroup", "number", "acquired", nowTotal,
            "group", attributeGroup)
        local realAddAttrValue = tonumber(string.splitByAll(values, "#")[index])

        totalAddValue = totalAddValue + realAddAttrValue
        fruitAttrPoints[tonumber(fruitAttrId)] = oldFruitAttr + realAddAttrValue
        realUseFruitCount = realUseFruitCount + 1
        count = count - 1
        if realAddAttrValue > 0 then
            local attrTipName = ConfigDataManager.getTableValue("cfg_att_info", "name", "id", fruitAttrId)
            local tipInfo = realAddAttrValue
            noticeTip.noticeinfo(actor, scriptConst.FRUIT_SUCCESS, attrTipName, tipInfo)
        else
            noticeTip.noticeinfo(actor, scriptConst.FRUIT_FAIL)
        end
    end
    setplaydef(actor, "T$fruit_data", fruitData)

    return realUseFruitCount, totalAddValue
end

-- 获取属性点第一级属性点总和
function FruitScript:getFruitPointsByLevel(actor, attLevel)
    attLevel = attLevel or scriptConst.FIRST_LEVEL_ATTR_CONFIG
    local total = 0
    local configIds = self:getConfigIdsByLevel(attLevel)
    local fruitData = getplaydef(actor, "T$fruit_data") or {}
    local fruitAttrPoints = fruitData["fruitAttrPoints"] or {}
    for i, attrId in ipairs(configIds) do
        local currPoint = fruitAttrPoints[tonumber(attrId)] or 0
        total = total + currPoint
    end
    return total
end

-- 校验是否可以使用
function FruitScript:canUseFruit(actor, cfgId)
    local itemConfig = ConfigDataManager.getById("cfg_item", cfgId)
    local fruitConfig = ConfigDataManager.getById("cfg_fruit", cfgId)
    if itemConfig == nil or fruitConfig == nil then
        return false
    end

    local fruitAttrIdStr = ConfigDataManager.getTableValue("cfg_fruit", "attribute", "id", cfgId)
    if fruitAttrIdStr == nil or fruitAttrIdStr == "" then
        return false
    end
    local fruitAttrId = tonumber(fruitAttrIdStr)
    if fruitAttrId <= 0 then
        return false
    end

    local attInfoConfig = ConfigDataManager.getById("cfg_att_info", fruitAttrId)
    if attInfoConfig == nil or next(attInfoConfig) == nil then
        return false
    end

    if self:isFirstLevelAttribute(fruitAttrId) then
        local total = self:getFruitPointsByLevel(actor)
        local maxFirstAtt = ConfigDataManager.getTableValue("cfg_global", "value", "id",
            scriptConst.FIRST_LEVEL_ATTR_MAX_VALUE_CONFIG)
        maxFirstAtt = tonumber(maxFirstAtt)
        if total >= maxFirstAtt then
            return false
        end
    end
    return true
end

-- 判断是否是属性点第一级
function FruitScript:isFirstLevelAttribute(fruitAttrId)
    local configIds = self:getConfigIdsByLevel()
    return array.simpleContains(configIds, fruitAttrId)
end

-- ===========================================重置果实属性请求==========================================
-- 重置果实属性请求
function FruitScript:resetFruitAttr(actor, attrIdAndValue)
    local fruitData = getplaydef(actor, "T$fruit_data") or {}
    local resetFruitAttrCount = fruitData["resetFruitAttrCount"] or 0
    local resetCondition = ConfigDataManager.getTableValue("cfg_global", "value", "id",
        scriptConst.RESET_FIRST_LEVEL_ATTR_CONDITION)

    -- 根据重置条件,扣除道具
    local tobeResetCount = resetFruitAttrCount + 1

    local index = tobeResetCount
    if tobeResetCount > 4 then
        index = 4
    end
    local resetConditions = string.splitByAll(resetCondition, "|")
    local resetCost = string.splitByAll(resetConditions[index], "#")
    local itemCount = getbagitemcountbyid(actor, tonumber(resetCost[2]))
    if tonumber(itemCount) < tonumber(resetCost[3]) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT348)
        return
    end

    -- 校验一级属性值总数是否一致
    local totalAttrPoints = self:getFruitPointsByLevel(actor)
    local receivePoints = 0
    for k, v in pairs(attrIdAndValue) do
        if tonumber(v) >= 0 and tonumber(v) <= totalAttrPoints then
            receivePoints = receivePoints + tonumber(v)
        end
    end
    if tonumber(totalAttrPoints) ~= tonumber(receivePoints) then
        return
    end

    local configIds = self:getConfigIdsByLevel()
    -- 客户端清除一级果实属性 (非一级属性不清除)
    local fruitAttrPoints = fruitData["fruitAttrPoints"] or {}

    for _, attrId in ipairs(configIds) do
        local newValue = attrIdAndValue[attrId]
        fruitAttrPoints[tonumber(attrId)] = newValue
    end
    addrolekmlattributes(actor, "fruitAttrs", fruitAttrPoints)

    removeitemfrombag(actor, tonumber(resetCost[2]), tonumber(resetCost[3]), 0, 9999, '果实')

    fruitData["resetFruitAttrCount"] = tobeResetCount
    fruitData["fruitAttrPoints"] = fruitAttrPoints
    setplaydef(actor, "T$fruit_data", fruitData)
    self:getAlreadyUsePoints(actor)
    gameDebug.print(actor, "重置果实属性成功", fruitData)
end

-- 获取果实属性重置次数
function FruitScript:getResetCount(actor)
    local fruitData = getplaydef(actor, "T$fruit_data") or {}
    local resetFruitAttrCount = fruitData["resetFruitAttrCount"] or 0
    sendluamsg(actor, LuaMessageIdToClient.C_RESET_FRUIT_COUNT, resetFruitAttrCount)
end

-- 获取果实当前已经使用的点数
function FruitScript:getAlreadyUsePoints(actor)
    local data = getplaydef(actor, "T$fruit_data") or {}
    local attrPoints = data["fruitAttrPoints"]
    if attrPoints == nil then
        sendluamsg(actor, LuaMessageIdToClient.C_USE_FRUIT_RESULT,
            { totalFirstLevelAttrs = 0, attrPoints = {} })
        return
    end
    local total = self:getFruitPointsByLevel(actor)
    for k, v in pairs(attrPoints) do
        attrPoints[k] = tostring(v)
    end
    sendluamsg(actor, LuaMessageIdToClient.C_USE_FRUIT_RESULT,
        { totalFirstLevelAttrs = total, attrPoints = attrPoints })
end

function FruitScript:getConfigIdsByLevel(level)
    level = level or scriptConst.FIRST_LEVEL_ATTR_CONFIG
    local firstLevelAttrConfigs = ConfigDataManager.getTable("cfg_att_info", "base", level)
    if table.isNullOrEmpty(firstLevelAttrConfigs) then
        return
    end
    local configIds = {}
    for i, attInfoConfig in ipairs(firstLevelAttrConfigs) do
        local attrId = attInfoConfig["id"]
        table.insert(configIds, attrId)
    end
    return configIds
end

-- 根据权重随机选位置索引
function FruitScript:selectIndexByWeight(weights)
    local totalWeight = 0
    for _, weight in ipairs(weights) do
        weight = tonumber(weight)
        totalWeight = totalWeight + weight
    end

    local randomValue = math.random(1, totalWeight)

    -- 遍历权重数组，找到对应的下标
    local accumulatedWeight = 0
    for i, weight in ipairs(weights) do
        accumulatedWeight = accumulatedWeight + weight
        if randomValue <= accumulatedWeight then
            return i
        end
    end

    -- 如果没有找到合适的下标（理论上不会发生），返回最后一个下标
    return #weights
end

function clearfruit(actor)
    setplaydef(actor, "T$fruit_data", {})
end

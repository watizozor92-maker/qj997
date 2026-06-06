-- ==================== 领域层 (Domain Layer) ====================
local PkRepository = {}

local PKConst = {
    PK_STAGE = {         --PK阶段
        WHITE_NAME = 1,  --白名
        YELLOW_NAME = 2, --黄名
        RED_NAME = 3,    --红名
    },
}


-- PK值
local PKPoints = {}
PKPoints.__index = PKPoints

function PKPoints.new()
    local self = setmetatable({}, PKPoints)
    self.points = 0
    return self
end

function PKPoints:getPoints()
    return self.points
end

function PKPoints:addPoints(points)
    self.points = self.points + points
end

function PKPoints:reducePoints(points)
    self.points = math.max(0, self.points - points)
end

function PKPoints:isRedName()
    return self.points >= PkRepository.getRedNameValue()
end

function PKPoints:getNameStage()
    local redNameValue = PkRepository.getRedNameValue()
    local yellowNameValue = PkRepository.getYellowNameValue()
    if self.points >= redNameValue then
        return PKConst.PK_STAGE.RED_NAME
    elseif self.points >= yellowNameValue and self.points < redNameValue then
        return PKConst.PK_STAGE.YELLOW_NAME
    else
        return PKConst.PK_STAGE.WHITE_NAME
    end
end

function PKPoints:clear()
    self.points = 0
end

function PKPoints:save(actor)
    setplaydef(actor, "T$_player_pk_point", {
        points = self.points,
    })
end

function PKPoints.get(actor)
    local data = getplaydef(actor, "T$_player_pk_point") or {}
    local instance = PKPoints.new()
    instance.points = data.points or 0
    return instance
end

-- PK值计时器
local PKTimer = {}
PKTimer.__index = PKTimer

function PKTimer.new()
    local self = setmetatable({}, PKTimer)
    self.cumulativeTime = 0 --累积时间（秒）
    return self
end

function PKTimer:getCumulativeTime()
    return self.cumulativeTime
end

function PKTimer:add(sec)
    self.cumulativeTime = self.cumulativeTime + sec
end

function PKTimer:save(actor)
    setplaydef(actor, "T$_player_pk_cumulative_time", {
        cumulativeTime = self.cumulativeTime,
    })
end

function PKTimer.get(actor)
    local data = getplaydef(actor, "T$_player_pk_cumulative_time") or {}
    local instance = PKTimer.new()
    instance.cumulativeTime = data.cumulativeTime or 0
    return instance
end

-- PK阶段规则
local PKStageRule = {}
PKStageRule.__index = PKStageRule
function PKStageRule.new(points)
    local self = setmetatable({}, PKStageRule)
    self.points = points
    self.config = PkRepository.getConfigByPoints(points)
    if self.config == nil then
        -- 为nil说明不在范围内
        local min, max = PkRepository.getPKPointsRange()
        local pkCountTable = ConfigDataManager.getList("cfg_pk_count")
        if self.points < min then
            self.configOutRange = pkCountTable[1]
        end

        if self.points > max then
            self.configOutRange = pkCountTable[#pkCountTable]
        end
    else
        self.configOutRange = self.config
    end

    return self
end

function PKStageRule:getKillPoints()
    if self.config ~= nil then
        return tonumber(self.config.addbykill)
    end
    -- 为nil说明不在范围内
    local min, max = PkRepository.getPKPointsRange()
    local pkCountTable = ConfigDataManager.getList("cfg_pk_count")
    if self.points < min then
        return tonumber(pkCountTable[1].addbykill)
    end

    if self.points > max then
        return tonumber(pkCountTable[#pkCountTable].addbykill)
    end
end


function PKStageRule:needAddPKPoint()
    local config = self:getConfigOutRange()
    return string.tonumber(config.addbekilled) == 1
end


function PKStageRule:getKillMonReducePoints(monsterLevel)
    local config = self:getConfigOutRange()
    local rate = string.tonumber(config.reducebymonsterparam) / 10000
    return math.floor(monsterLevel * rate)
end

function PKStageRule:getTimeRuduceSecAndPoints()
    local config = self:getConfigOutRange()
    local split = string.splitInt(config.reducebytime)
    return split[1], split[2]
end

function PKStageRule:deathPenalty(actor, killer) -- 死亡惩罚
    local config = self:getConfig()
    if config == nil then
        return
    end
    local killerType = getbaseinfo(killer, "mapobjecttype")
    self:dropGem(actor, killer, killerType)
    self:dropGold(actor, killer, killerType)
    self:dropEquip(actor, killer, killerType)
end

function PKStageRule:dropEquip(actor, killer, killerType)
    local config = self:getConfig()
    -- 掉落概率|执行次数|穿戴栏装备比重#背包装备比重
    local dropEquipStr = nil
    if killerType == MapObjectType.MONSTER then
        dropEquipStr = config.dropequippve
    else
        dropEquipStr = config.dropequippvp
    end
    if string.isNullOrEmpty(dropEquipStr) then
        return
    end
    local equipCfgs = string.split(dropEquipStr, "|")
    local dropRate = tonumber(equipCfgs[1])             -- 掉落概率
    local executeTimes = tonumber(equipCfgs[2])         -- 执行次数
    local equipRatios = string.split(equipCfgs[3], "#") -- 装备比重配置
    local wearEquipRatio = tonumber(equipRatios[1])     -- 穿戴栏装备比重
    local bagEquipRatio = tonumber(equipRatios[2])      -- 背包装备比重

    local filterSubtypeStr = ConfigDataManager.getTableValue("cfg_global", "value", "id", 680002)
    local filterSubtypeList = string.splitInt(filterSubtypeStr, "#")
    for i = 1, executeTimes do
        local rand = math.random(1, 10000)
        if rand <= dropRate then
            -- 根据比重随机判定掉落穿戴栏装备还是背包内的装备
            local totalRatio = wearEquipRatio + bagEquipRatio
            local equipTypeRand = math.random(1, totalRatio)
            local dropWearEquip = equipTypeRand <= wearEquipRatio

            if dropWearEquip then
                -- 尝试掉落穿戴栏装备
                local allEquip = getputonequipinfo(actor)
                math.shuffleTable(allEquip)
                for _, oneEquip in pairs(allEquip) do
                    local wearBar = gameequip.wearBar(oneEquip.equipindex)
                    if wearBar == 1 and table.contains(filterSubtypeList, oneEquip.subtype) then
                        local equipColor = EquipColorService.getColorByEquipInfo(actor, oneEquip)
                        if oneEquip.isbind then
                            -- 绑定装备直接销毁
                            dropequip(actor, oneEquip.id, 0, 0, { destroy = 1 })
                        else
                            if killerType == MapObjectType.MONSTER then
                                -- PVE掉落
                                dropequip(actor, oneEquip.id, 0, 0, { pickuptype = 1 })
                            else
                                -- PVP掉落
                                local needBelong = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 760001))
                                if needBelong == 0 then
                                    dropequip(actor, oneEquip.id, 0, 10, { pickuptype = 2 })
                                else
                                    dropequip(actor, oneEquip.id, killer:toString(), 1000000, { pickuptype = 2 })
                                end
                            end
                        end
                        info("红名惩罚：玩家死亡掉落装备。", actor:toString(), oneEquip)
                        -- 发邮件
                        local equipName = ConfigDataManager.getTableValue("cfg_item", "name", "id", oneEquip.cfgid)
                        local itemNameWithColor = "<color=" .. equipColor .. ">" .. equipName .. " </color>"
                        sendconfigmailbyrid(actor, actor:toString(), PkRepository.getDropEquipMailIDByNameStage(self.points), {}, getbaseinfo(killer, "rolename") .. "|" .. itemNameWithColor)
                        break -- 只掉落一件装备
                    end
                end
            else
                -- 尝试掉落背包内装备
                local allBagItems = getbagdata(actor)
                math.shuffleTable(allBagItems.items)
                for _, itemInfo in pairs(allBagItems.items) do
                    local itemConfig = ConfigDataManager.getById("cfg_item", itemInfo.cfgid)
                    if tonumber(itemConfig.type) == 2 and table.contains(filterSubtypeList, tonumber(itemConfig.subtype)) then -- 装备类型
                        local equipColor = EquipColorService.getColorById(actor, itemInfo.id)
                        if itemInfo.isbind then
                            -- 绑定装备直接销毁
                            destroyitemafter(actor, itemInfo.index, "红名惩罚")
                        else
                            if killerType == MapObjectType.MONSTER then
                                -- PVE掉落
                                dropequip(actor, itemInfo.id, 0, 0)
                            else
                                -- PVP掉落
                                local needBelong = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 760001))
                                if needBelong == 0 then
                                    dropequip(actor, itemInfo.id, 0, 10, { pickuptype = 2 })
                                else
                                    dropequip(actor, itemInfo.id, killer:toString(), 1000000, { pickuptype = 2 })
                                end
                            end
                        end
                        info("红名惩罚：玩家死亡掉落背包装备。", actor:toString(), itemInfo.cfgid, 1)
                        -- 发邮件
                        local itemNameWithColor = "<color=" .. equipColor .. ">" .. itemConfig.name .. " </color>"
                        sendconfigmailbyrid(actor, actor:toString(), PkRepository.getDropEquipMailIDByNameStage(self.points), {}, getbaseinfo(killer, "rolename") .. "|" .. itemNameWithColor)
                        break -- 只掉落一件装备
                    end
                end
            end
        end
    end
end

function PKStageRule:dropGold(actor, killer, killerType)
    local config = self:getConfig()
    -- 优先非绑金币id#固定值#总值万分比|优先绑定金币id#固定值#总值万分比
    local dropCoinStr = nil
    if killerType == MapObjectType.MONSTER then
        dropCoinStr = config.dropcoinpve
    else
        dropCoinStr = config.dropcoinpvp
    end
    if string.isNullOrEmpty(dropCoinStr) then
        return
    end
    local coinCfgs = string.split(dropCoinStr, "|")
    local unbindCoinCfg = string.split(coinCfgs[1], "#") -- 非绑金币配置: {金币id, 固定值, 总值万分比}
    local bindCoinCfg = string.split(coinCfgs[2], "#")   -- 绑定金币配置: {金币id, 固定值, 总值万分比}

    local unbindCoinId = tonumber(unbindCoinCfg[1])      -- 非绑金币ID
    local unbindFixedValue = tonumber(unbindCoinCfg[2])  -- 非绑固定值
    local unbindRate = tonumber(unbindCoinCfg[3])        -- 非绑总值万分比

    local bindCoinId = tonumber(bindCoinCfg[1])          -- 绑定金币ID
    local bindFixedValue = tonumber(bindCoinCfg[2])      -- 绑定固定值
    local bindRate = tonumber(bindCoinCfg[3])            -- 绑定总值万分比

    local unbindCoinCount = getbagitemcountbyid(actor, unbindCoinId, -1, 0)
    local bindCoinCount = getbagitemcountbyid(actor, bindCoinId, -1, 0)

    local allCoinCount = unbindCoinCount + bindCoinCount

    local needcostUnbindCoinCount = math.round(allCoinCount * (unbindRate / 10000) + unbindFixedValue)
    local needcostBindCoinCount = math.round(allCoinCount * (bindRate / 10000) + bindFixedValue)

    -- 先扣非绑货币，非绑不足扣绑定，非绑掉地上
    local costUnbindCoinCount = math.round(math.min(needcostUnbindCoinCount, unbindCoinCount))
    local remainUnbindNeed = needcostUnbindCoinCount - costUnbindCoinCount
    local costBindCoinCount = math.round(math.min(remainUnbindNeed, bindCoinCount))

    local allCostUnbindCoinCount = 0
    local allCostBindCoinCount = 0
    -- 扣除非绑金币
    if costUnbindCoinCount > 0 then
        local x = getbaseinfo(actor, "x")
        local y = getbaseinfo(actor, "y")
        local mapId = getbaseinfo(actor, "unimapid")
        allCostUnbindCoinCount = allCostUnbindCoinCount + costUnbindCoinCount
        removeitemfrombag(actor, unbindCoinId, costUnbindCoinCount, 0, 9999, RemoveItemAction.RED_NAME_PENALTY)
        local totalCoins = costUnbindCoinCount
        local perDropAmount = math.ceil(totalCoins / 4)
        local remainingCoins = totalCoins
        -- 非绑金币掉地上
        if killerType == MapObjectType.MONSTER then
            -- PVE掉落
            while remainingCoins > 0 do
                local currentDropAmount = math.min(perDropAmount, remainingCoins)
                if currentDropAmount <= 0 then
                    break
                end
                throwitem(actor, mapId, x, y, 0, unbindCoinId, currentDropAmount, 1000000, 1, 0, {}, "")
                remainingCoins = remainingCoins - currentDropAmount
            end
        else
            -- PVP掉落
            while remainingCoins > 0 do
                local currentDropAmount = math.min(perDropAmount, remainingCoins)
                if currentDropAmount <= 0 then
                    break
                end
                local needBelong = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 760001))
                if needBelong == 0 then
                    throwitem(actor, mapId, x, y, 0, unbindCoinId, currentDropAmount, 1000000, 1, 0, {}, "")
                else
                    throwitem(killer, mapId, x, y, 0, unbindCoinId, currentDropAmount, 1000000, 2, 0, {}, "")
                end
                remainingCoins = remainingCoins - currentDropAmount
            end
        end
    end

    -- 扣除绑定金币
    if costBindCoinCount > 0 then
        allCostBindCoinCount = allCostBindCoinCount + costBindCoinCount
        removeitemfrombag(actor, bindCoinId, costBindCoinCount, 0, 9999, RemoveItemAction.RED_NAME_PENALTY)
    end

    -- 先扣绑定货币，绑定货币不足扣非绑，全部直接扣
    local remainBind = bindCoinCount - costBindCoinCount
    local remainUnBind = unbindCoinCount - costUnbindCoinCount
    local costMoreBindCoinCount = math.round(math.min(remainBind, needcostBindCoinCount))
    local costFromUnbindCoinCount = math.round(math.min(remainUnBind, needcostBindCoinCount - remainBind))
    -- 扣除额外的绑定金币
    if costMoreBindCoinCount > 0 then
        allCostBindCoinCount = allCostBindCoinCount + costMoreBindCoinCount
        removeitemfrombag(actor, bindCoinId, costMoreBindCoinCount, 0, 9999, RemoveItemAction.RED_NAME_PENALTY)
    end

    -- 从非绑定金币中扣除剩余部分
    if costFromUnbindCoinCount > 0 then
        allCostUnbindCoinCount = allCostUnbindCoinCount + costFromUnbindCoinCount
        removeitemfrombag(actor, unbindCoinId, costFromUnbindCoinCount, 0, 9999, RemoveItemAction.RED_NAME_PENALTY)
    end

    if allCostUnbindCoinCount > 0 or allCostBindCoinCount > 0 then
        -- 发邮件
        local mailParams = {}
        if allCostUnbindCoinCount > 0 then
            table.insert(mailParams, allCostUnbindCoinCount .. "个<color=#E8D04B>金币</color>")
        end
        if allCostBindCoinCount > 0 then
            table.insert(mailParams, allCostBindCoinCount .. "个<color=#E8D04B>绑定金币</color>")
        end

        if #mailParams > 0 then
            local mailText = table.concat(mailParams, "和")
            sendconfigmailbyrid(actor, actor:toString(), PkRepository.getDropCoinMailIDByNameStage(self.points), {}, getbaseinfo(killer, "rolename") .. "|" .. mailText)
        end
    end
end

function PKStageRule:dropGem(actor, killer, killerType)
    local config = self:getConfig()
    -- 掉落道具概率|道具id#道具id|执行次数
    local dropGemCfgStr = nil
    if killerType == MapObjectType.MONSTER then
        dropGemCfgStr = config.dropgempve
    else
        dropGemCfgStr = config.dropgempvp
    end
    if string.isNullOrEmpty(dropGemCfgStr) then
        return
    end

    local dropGemCfg = string.split(dropGemCfgStr, "|")
    local dropRate = tonumber(dropGemCfg[1]) or 0
    local dropItemsStr = dropGemCfg[2]
    local executeTimes = tonumber(dropGemCfg[3]) or 0

    if dropRate <= 0 or string.isNullOrEmpty(dropItemsStr) or executeTimes <= 0 then
        return
    end

    local allBagItems = getbagdata(actor)
    local dropItems = string.splitInt(dropItemsStr, "#")
    -- 遍历背包，并记录背包里有哪些可以掉落的道具
    local availableItems = {}
    for _, itemInfo in pairs(allBagItems.items) do
        if table.contains(dropItems, itemInfo.cfgid) then
            table.insert(availableItems, { id = itemInfo.cfgid, count = itemInfo.count })
        end
    end

    if not next(availableItems) then
        return
    end
    -- 在玩家位置掉落道具
    local x = getbaseinfo(actor, "x")
    local y = getbaseinfo(actor, "y")
    local mapId = getbaseinfo(actor, "unimapid")
    for i = 1, executeTimes do
        local rand = math.random(1, 10000)
        if rand <= dropRate then
            -- 随机选择一个道具ID
            local randomIndex = math.random(1, #availableItems)
            local itemInfo = availableItems[randomIndex]
            local itemCfgId = itemInfo.id
            -- 检查背包中是否有这个道具
            local itemCountInBag = getbagitemcountbyid(actor, itemCfgId)
            if itemCountInBag > 0 then
                local itemConfig = ConfigDataManager.getById("cfg_item", itemCfgId)
                local isBind = string.tonumber(itemConfig.lockitem)
                -- 从背包中移除道具
                removeitemfrombag(actor, itemCfgId, 1, 0, 9999, RemoveItemAction.RED_NAME_PENALTY)
                itemInfo.count = itemInfo.count - 1
                if itemInfo.count <= 0 then
                    table.remove(availableItems, randomIndex)
                end
                if isBind == 1 then
                    if killerType == MapObjectType.MONSTER then
                        -- PVE掉落
                        throwitem(actor, mapId, x, y, 0, itemCfgId, 1, 1000000, 1, 0, {}, "")
                    else
                        local needBelong = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 760001))
                        if needBelong == 0 then
                            throwitem(actor, mapId, x, y, 0, itemCfgId, 1, 1000000, 1, 0, {}, "")
                        else
                            -- PVP掉落
                            throwitem(killer, mapId, x, y, 0, itemCfgId, 1, 1000000, 2, 0, {}, "")
                        end
                    end
                end
                -- 发送邮件通知
                sendconfigmailbyrid(actor, actor:toString(), PkRepository.getDropItemMailIDByNameStage(self.points), {}, getbaseinfo(killer, "rolename") .. "#" .. 1 .. "#" .. itemConfig.name)
            end
        end
    end
end

function PKStageRule:dropNormerItems(actor, killer, killerType) -- 掉落指定道具
    local config = self:getConfig()
    if string.isNullOrEmpty(config.dropitem) then
        return
    end
    local itemSplit = string.splitInt(config.dropitem, "#")
    local itemCfgId = itemSplit[1]
    local itemCount = itemSplit[2]
    local itemConfig = ConfigDataManager.getById("cfg_item", itemCfgId)
    local isBind = string.tonumber(itemConfig.lockitem)
    local realCount = math.min(getbagitemcountbyid(actor, itemCfgId), itemCount)
    removeitemfrombag(actor, itemCfgId, realCount, 0, 9999, RemoveItemAction.RED_NAME_PENALTY)
    info("红名惩罚：玩家死亡掉落固定道具。", actor:toString(), itemCfgId, realCount)
    sendconfigmailbyrid(actor, actor:toString(), PkRepository.getDropItemMailIDByNameStage(self.points), {}, getbaseinfo(killer, "rolename") .. "#" .. realCount .. "#" .. itemConfig.name)
    if not isBind then
        local x = getbaseinfo(actor, "x")
        local y = getbaseinfo(actor, "y")
        local mapId = getbaseinfo(actor, "unimapid")
        if killerType == MapObjectType.MONSTER then
            -- PVE掉落
            throwitem(actor, mapId, x, y, 0, itemCfgId, realCount, 1000000, 1, 0, {}, "")
        else
            local needBelong = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 760001))
            if needBelong == 0 then
                throwitem(actor, mapId, x, y, 0, itemCfgId, 1, 1000000, 1, 0, {}, "")
            else
                -- PVP掉落
                throwitem(killer, mapId, x, y, 0, itemCfgId, 1, 1000000, 2, 0, {}, "")
            end
        end
    end
end

function PKStageRule:dropRandomItems(actor, killer, killerType) -- 掉落随机道具
    local config = self:getConfig()
    if string.isNullOrEmpty(config.droprandomitem) then
        return
    end
    local randomSplit = string.splitInt(config.droprandomitem, "#")
    local randomTimes = randomSplit[1]
    local itemCount = randomSplit[2]
    local allBagItems = getbagdata(actor)
    math.shuffleTable(allBagItems.items)
    for i = 1, randomTimes do
        local itemInfo = allBagItems.items[i]
        if itemInfo then
            local itemCfgId = itemInfo.cfgid
            local itemConfig = ConfigDataManager.getById("cfg_item", itemCfgId)
            if tonumber(itemConfig.type) == 2 then
                if itemInfo.isbind then
                    -- 绑定道具直接销毁
                    destroyitemafter(actor, itemInfo.index, "红名惩罚")
                else
                    if killerType == MapObjectType.MONSTER then
                        -- 非绑掉落
                        dropequip(actor, itemInfo.id, 0, 0)
                    else
                        -- 非绑掉落
                        dropequip(actor, itemInfo.id, killer:toString(), 10000)
                    end
                end
                info("红名惩罚：玩家死亡掉落随机道具。", actor:toString(), itemCfgId, 1)
                --todo 生成邮件
                -- 由于您当前处于红名状态，在被<color=#E93732>%s</color>击败后，您不幸掉落了<color=#9b39cc>%s</color>个<color=#9b39cc>%s</color>。您可以前往奇迹币商店购买免罪符消除红名，以减少损失。
                sendconfigmailbyrid(actor, actor:toString(), PkRepository.getDropItemMailIDByNameStage(self.points), {}, getbaseinfo(killer, "rolename") .. "#" .. 1 .. "#" .. itemConfig.name)
            else
                --todo 非装备扣除数量然后地上生成
                local realCount = math.min(getbagitemcountbyid(actor, itemCfgId), itemCount)
                removeitemfrombag(actor, itemCfgId, realCount, 0, 9999, RemoveItemAction.RED_NAME_PENALTY)
                sendconfigmailbyrid(actor, actor:toString(), PkRepository.getDropItemMailIDByNameStage(self.points), {}, getbaseinfo(killer, "rolename") .. "#" .. realCount .. "#" .. itemConfig.name)
                info("红名惩罚：玩家死亡掉落随机道具。", actor:toString(), itemCfgId, realCount)
                if itemInfo.isbind then
                    -- 绑定道具直接销毁
                else
                    local x = getbaseinfo(actor, "x")
                    local y = getbaseinfo(actor, "y")
                    local mapId = getbaseinfo(actor, "unimapid")
                    if killerType == MapObjectType.MONSTER then
                        -- PVE掉落
                        throwitem(actor, mapId, x, y, 0, itemCfgId, realCount, 1000000, 1, 0, {}, "")
                    else
                        local needBelong = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 760001))
                        if needBelong == 0 then
                            throwitem(actor, mapId, x, y, 0, itemCfgId, 1, 1000000, 1, 0, {}, "")
                        else
                            -- PVP掉落
                            throwitem(killer, mapId, x, y, 0, itemCfgId, 1, 1000000, 2, 0, {}, "")
                        end
                    end
                end
            end
        end
    end
end

function PKStageRule:dropPutOnEquip(actor, killer, killerType) --掉落身上的装备
    local config = self:getConfig()
    local dropRate = string.tonumber(config.dropequip)
    local r = math.random(1, 10000)
    if r > dropRate then
        return
    end
    local allEquip = getputonequipinfo(actor)
    math.shuffleTable(allEquip)
    for _, oneEquip in pairs(allEquip) do
        local wearBar = gameequip.wearBar(oneEquip.equipindex)
        if wearBar == 1 then
            if table.contains({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, oneEquip.subtype) then
                if oneEquip.isbind then
                    --  直接移除
                    dropequip(actor, oneEquip.id, 0, 0, { destroy = 1 })
                else
                    if killerType == MapObjectType.MONSTER then
                        -- 非绑掉落
                        dropequip(actor, oneEquip.id, 0, 0, { pickuptype = 1 })
                    else
                        -- 非绑掉落
                        dropequip(actor, oneEquip.id, killer:toString(), 10000, { pickuptype = 2 })
                    end
                end
                info("红名惩罚：玩家死亡掉落装备。", actor:toString(), oneEquip)
                -- 发邮件
                local equipName = ConfigDataManager.getTableValue("cfg_item", "name", "id", oneEquip.cfgid)
                sendconfigmailbyrid(actor, actor:toString(), PkRepository.getDropEquipMailIDByNameStage(self.points), {}, getbaseinfo(killer, "rolename") .. "#" .. equipName)
                return
            end
        end
    end
end

function PKStageRule:canTeleport(targetMap, targetLine) -- 是否可以传送
    local config = self:getConfig()
    if config == nil then
        return true
    end
    local type = string.tonumber(config.maptransmission)
    if type == 1 then
        return false
    end
    local peaceLines = ConfigDataManager.getTableValue("cfg_map_line", "peaceline", "id", targetMap)

    if type == 2 then
        if not string.isNullOrEmpty(peaceLines) then
            local peaceLineList = string.split(peaceLines, "#")
            for _, peaceLine in pairs(peaceLineList) do
                if tonumber(targetLine) == tonumber(peaceLine) then
                    return false
                end
            end
        end
    end

    return true
end

function PKStageRule:getTransmitCostMultiplier()
    local config = self:getConfigOutRange()
    return tonumber(config.maptransmissioncost)
end

function PKStageRule:canTrade()
    local config = self:getConfigOutRange()
    return string.tonumber(config.tradelimit) == 0
end

function PKStageRule:canHurtPlayer()
    local v = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", "680001"))
    return self.points <= v
end

function PKStageRule:cantBuyItem(itemId) -- 是否可以购买某个道具
    local config = self:getConfig()
    if config == nil then
        return false
    end
    local shopPurchaseSplit = string.splitInt(config.shoppurchase, "#")
    if #shopPurchaseSplit <= 0 then
        return false
    end
    return table.contains(shopPurchaseSplit, tonumber(itemId))
end

function PKStageRule:getConfig()
    return self.config
end

function PKStageRule:getConfigOutRange()
    return self.configOutRange
end

-- ==================== 用户接口层 (API Layer) ====================
PKSystem = {}
local this = {}

function PKSystem.getPKPoint(actor)
    return PKPoints.get(actor)
end

function PKSystem.getPKStageRule(points)
    return PKStageRule.new(points)
end

-- 击杀玩家事件
function PKSystem.onPlayerKilled(actor, target)
    -- PK线路不加PK值
    local mapCfgId = getbaseinfo(actor, "mapid")
    local line = getbaseinfo(actor, "line")
    if PkRepository.isPKLine(mapCfgId, line) then
        return
    end

    if BingFengBao.IsPlayerInRoland(actor) and BingFengBao.isOpen() then
        return
    end

    -- 击杀非白名才加PK值
    local targetPKPoint = PKPoints.get(target)
    local targetPKStage = PKSystem.getPKStageRule(targetPKPoint:getPoints())
    if not targetPKStage:needAddPKPoint() then
        return
    end

    local selfPKPoint = PKPoints.get(actor)
    local pkStageRule = PKSystem.getPKStageRule(selfPKPoint:getPoints())
    local addPoints = pkStageRule:getKillPoints()
    selfPKPoint:addPoints(addPoints)
    selfPKPoint:save(actor)
    -- 发视野包
    PKSystem.sendRoundMsg(actor, selfPKPoint:getPoints())
end

function PKSystem.onPlayerDie(actor, dieInfo, killerInfo)
    -- 处理掉落逻辑
    local selfPKPoint = PKPoints.get(actor)
    if selfPKPoint:isRedName() then
        -- 跑马灯
        noticeTip.noticeinfo(actor, StringIdConst.TEXT48001, getbaseinfo(actor, "rolename"))
    end
    local pkStageRule = PKSystem.getPKStageRule(selfPKPoint:getPoints())
    local deathPenalty = string.tonumber(ConfigDataManager.getTableValue("cfg_map_info", "deathpunishment", "id", getbaseinfo(actor, "mapid")))
    
    if deathPenalty ~= 1 and (not BingFengBao.IsPlayerInRoland(actor)) then
        local killer = getactor(actor, killerInfo.id)
        if killerInfo.callerid and killerInfo.callerid > 0 then
            killer = getactor(actor, killerInfo.callerid)
        end
        pkStageRule:deathPenalty(actor, killer)
    end
end

-- 限制传送
function PKSystem.checkTransmit(actor, targetMap, targetLine)
    local selfPKPoint = PKPoints.get(actor)
    local pkStageRule = PKSystem.getPKStageRule(selfPKPoint:getPoints())
    return pkStageRule:canTeleport(targetMap, targetLine)
end

-- 传送消耗倍率
function PKSystem.getTransmitCostMultiplier(actor)
    local selfPKPoint = PKPoints.get(actor)
    local pkStageRule = PKSystem.getPKStageRule(selfPKPoint:getPoints())
    return pkStageRule:getTransmitCostMultiplier()
end

-- 限制交易
function PKSystem.canTrade(actor)
    local selfPKPoint = PKPoints.get(actor)
    local pkStageRule = PKSystem.getPKStageRule(selfPKPoint:getPoints())
    return pkStageRule:canTrade()
end

-- 击杀怪物事件
function PKSystem.onMonsterKilled(actor, monsterCfgId, monsterLevel)
    local pkPoints = PKPoints.get(actor)
    local points = pkPoints:getPoints()
    if points <= 0 then
        return
    end
    local pkStageRule = PKSystem.getPKStageRule(points)
    local reducePoints = pkStageRule:getKillMonReducePoints(monsterLevel)
    if reducePoints <= 0 then
        return
    end
    pkPoints:reducePoints(reducePoints)
    pkPoints:save(actor)
    -- 发视野包
    PKSystem.sendRoundMsg(actor, pkPoints:getPoints())
end

-- 玩家五秒钟心跳
function PKSystem.on5SecondsHeart(actor, nowSec)
    local pkPoints = PKPoints.get(actor)
    local points = pkPoints:getPoints()
    if points <= 0 then
        return
    end

    -- 检查并处理PK值随时间减少
    this.checkAndReducePKByTime(actor, pkPoints)
end

-- 检查并减少PK值（按时间间隔）
function this.checkAndReducePKByTime(actor, pkPoints)
    local points = pkPoints:getPoints()
    local pkStageRule = PKSystem.getPKStageRule(points)
    local interval, reducePoints = pkStageRule:getTimeRuduceSecAndPoints()

    local pkTimer = PKTimer.get(actor)
    pkTimer:add(5)
    local cumulativeTime = pkTimer:getCumulativeTime()
    if cumulativeTime >= interval then
        pkTimer:add(-interval)
        pkPoints:reducePoints(reducePoints)
        pkPoints:save(actor)
        -- 发视野包
        PKSystem.sendRoundMsg(actor, pkPoints:getPoints())
    end
    pkTimer:save(actor)
end

-- 道具使用后
function PKSystem.onItemUsed(actor, itemConfigId)
    local itemConfig = ConfigDataManager.getById("cfg_item", itemConfigId)
    if tonumber(itemConfig.type) ~= 99 or tonumber(itemConfig.subtype) ~= 5 then
        return
    end
    -- 使用免罪符
    local pkPoints = PKPoints.get(actor)
    pkPoints:clear()
    pkPoints:save(actor)
    PKSystem.sendRoundMsg(actor, 0)
end

-- 视野消息
function PKSystem.playerEnterView(actor, targetActor)
    local targetPKPoints = PKPoints.get(targetActor)
    sendluamsg(actor, LuaMessageIdToClient.PK_VALUE_CHANGE, { rid = targetActor, pkValue = targetPKPoints:getPoints() })
end

function PKSystem.sendRoundMsg(actor, points)
    local msg = { rid = actor, pkValue = points }
    sendrefluamsg(actor, LuaMessageIdToClient.PK_VALUE_CHANGE, msg)
end

-- ==================== 基础设施层 (Infrastructure Layer) ====================
local PKPointsRangeCache = nil


-- 根据当前PK值获取配置
function PkRepository.getConfigByPoints(points)
    local pkCountTable = ConfigDataManager.getList("cfg_pk_count")

    -- 二分查找优化
    local left, right = 1, #pkCountTable

    while left <= right do
        local mid = math.floor((left + right) / 2)
        local nameColor = pkCountTable[mid].namecolor
        local rangeParts = string.split(nameColor, "#")
        local minPkValue = tonumber(rangeParts[1])
        local maxPkValue = tonumber(rangeParts[2])

        if points >= minPkValue and points <= maxPkValue then
            return pkCountTable[mid]
        elseif points < minPkValue then
            right = mid - 1
        else
            left = mid + 1
        end
    end
    return nil
end

-- 获取红名值。
function PkRepository.getRedNameValue()
    return tonumber(ConfigDataManager.getTableValue("cfg_pk_count", "redNameNeed", "id", 1))
end

-- 获取黄名值。
function PkRepository.getYellowNameValue()
    return tonumber(ConfigDataManager.getTableValue("cfg_pk_count", "yellowNameNeed", "id", 1))
end

function PkRepository.getNameStage(points)
    local redNameValue = PkRepository.getRedNameValue()
    local yellowNameValue = PkRepository.getYellowNameValue()
    if points >= redNameValue then
        return PKConst.PK_STAGE.RED_NAME
    elseif points >= yellowNameValue and points < redNameValue then
        return PKConst.PK_STAGE.YELLOW_NAME
    else
        return PKConst.PK_STAGE.WHITE_NAME
    end
end

function PkRepository.getDropItemMailIDByNameStage(points)
    local nameStage = PkRepository.getNameStage(points)
    if nameStage == PKConst.PK_STAGE.WHITE_NAME then
        return MailConfig.PK_WHITE_NAME_DROP_ITEM
    elseif nameStage == PKConst.PK_STAGE.YELLOW_NAME then
        return MailConfig.PK_YELLOW_NAME_DROP_ITEM
    else
        return MailConfig.PK_RED_NAME_DROP_ITEM
    end
end

function PkRepository.getDropCoinMailIDByNameStage(points)
    local nameStage = PkRepository.getNameStage(points)
    if nameStage == PKConst.PK_STAGE.WHITE_NAME then
        return MailConfig.PK_WHITE_NAME_DROP_COIN
    elseif nameStage == PKConst.PK_STAGE.YELLOW_NAME then
        return MailConfig.PK_YELLOW_NAME_DROP_COIN
    else
        return MailConfig.PK_RED_NAME_DROP_COIN
    end
end

function PkRepository.getDropEquipMailIDByNameStage(points)
    local nameStage = PkRepository.getNameStage(points)
    if nameStage == PKConst.PK_STAGE.WHITE_NAME then
        return MailConfig.PK_WHITE_NAME_DROP_EQUIP
    elseif nameStage == PKConst.PK_STAGE.YELLOW_NAME then
        return MailConfig.PK_YELLOW_NAME_DROP_EQUIP
    else
        return MailConfig.PK_RED_NAME_DROP_EQUIP
    end
end

function PkRepository.getPKPointsRange()
    if PKPointsRangeCache ~= nil then
        return PKPointsRangeCache.min, PKPointsRangeCache.max
    end
    PKPointsRangeCache = {}
    local pkCountTable = ConfigDataManager.getList("cfg_pk_count")
    PKPointsRangeCache.min = tonumber(string.split(pkCountTable[1].namecolor, "#")[1])
    PKPointsRangeCache.max = tonumber(string.split(pkCountTable[#pkCountTable].namecolor, "#")[2])
    return PKPointsRangeCache.min, PKPointsRangeCache.max
end

-- 是否是PK线路
function PkRepository.isPKLine(mapCfgId, line)
    if mapCfgId and line then
        local pkLine = ConfigDataManager.getTableValue("cfg_map_line", "pkline", "id", mapCfgId)
        if not string.isNullOrEmpty(pkLine) then
            local pkLines = string.split(pkLine, "|")
            for _, pkLineValue in pairs(pkLines) do
                if tonumber(line) == tonumber(pkLineValue) then
                    return true
                end
            end
        end
    end
    return false
end

function test_view_pk(actor)
    local pkPoints = PKPoints.get(actor)
    tipinfo(actor, "PK值" .. pkPoints:getPoints())
end

function test_add_pk(actor, p)
    local pkPoints = PKPoints.get(actor)
    pkPoints:addPoints(tonumber(p))
    pkPoints:save(actor)
    PKSystem.sendRoundMsg(actor, pkPoints:getPoints())
end

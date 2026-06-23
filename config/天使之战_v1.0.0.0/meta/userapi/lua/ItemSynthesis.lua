ItemSynthesis = {}
local this = {}

local SYNTHESIS_DATA = "T$synthesis_data"
local YINGSHI_GEM_ATTR_DATA = "T$yingshi_gem_attr_data"

-- 掉落过程日志
local isDebug = nil
local SynthesisLog = {}

function SynthesisLog.new()
    isDebug = isDebug or getenv("debug")
    if isDebug then
        synthesisLog = {} --用全局变量
    end
end

function SynthesisLog.addLog(text)
    isDebug = isDebug or getenv("debug")
    if isDebug then
        table.insert(synthesisLog, text .. "  ")
    end
end

function SynthesisLog.send(actor)
    isDebug = isDebug or getenv("debug")
    if isDebug then
        sendluamsg(actor, LuaMessageIdToClient.RES_SYNTHESIS_FLOW, table.toString(table.values(synthesisLog)))
    end
end

-- 道具合成
function ItemSynthesis.synthesis(actor, msgData)
    local cfgId = msgData[1]
    local putInItems = msgData[2]      -- 刚需道具
    local successItems = msgData[3]    -- 辅助道具
    local dingxiangItem = msgData[4][1]
    local protectIds = msgData[5]
    local luckyItem = msgData[6]        -- 幸运道具 {id=道具cfgId, count=数量}

    --SynthesisLog.new()
    --SynthesisLog.addLog(string.format("1.合成开始，合成配置id:[%d]，         放入的刚需道具（consumeItem字段）：%s  ，          放入的公式额外消耗道具 成功率增加道具（consumeItem2字段）：[%s]，         放入的定向道具（productid字段）：[%s]，          放入的保护道具（protect字段）：[%s]"
    --, cfgId, table.toString(putInItems, true), table.toString(successItems, true), table.toString(dingxiangItem, true), table.toString(protectIds, true)))
    -- SynthesisLog.addLog("★★★★★★★★★★★★★★★★★★★★")

    -- info("synthesis msgData",msgData)
    local cfg_synthesis = ConfigDataManager.getById("cfg_synthesis", cfgId)
    if table.isEmpty(cfg_synthesis) then
        tipinfo(actor, "合成配置不存在：" .. cfgId)
        return
    end

    local currentLevel = getbaseinfo(actor, "level")
    if tonumber(cfg_synthesis.level) > tonumber(currentLevel) then
        tipinfo(actor, "合成条件不满足")
        return nil
    end

    -- 1. 验证刚需道具并计算成功率（只验证，不扣除）
    local needCost, needBagIndexCost, bind, specialCost, type3SuccessRate = this.getCostNew(actor, cfg_synthesis.consumeitem, putInItems)
    if table.isEmpty(needCost) and table.isEmpty(needBagIndexCost) and not string.isNullOrEmpty(cfg_synthesis.consumeitem) then
        error(actor, "玩家", actor, "合成 合成条件不满足 配置id", cfgId, "放入主要道具", putInItems, "合成配置", cfg_synthesis, "合成消耗", needCost)
        tipinfo(actor, "刚需材料不满足")
        return
    end
    -- 2. 计算总成功率 = 基础成功率 + 类型 3 成功率 + 辅助成功率
    local successRateReal = string.tonumber(cfg_synthesis.successratereal)
    local baseRate = successRateReal + type3SuccessRate --基础总成功率
    local maxSuccessRate = tonumber(cfg_synthesis.successratemax) or 10000 --总的最大成功率
    local successItemMaxRate = maxSuccessRate - baseRate
    local extMaxRate = string.tonumber(cfg_synthesis.specialconsumeratemax) --辅助材料最大成功率

    if successItemMaxRate > 0 then
        if extMaxRate > 0 then
            extMaxRate = math.min(extMaxRate, successItemMaxRate)
        else
            extMaxRate = successItemMaxRate
        end
    else
        extMaxRate = 0
    end


    local successRateFromExtra = 0
    local extraCost, extraBagIndexCost = {}, {}
    -- 3. 验证辅助道具并计算成功率（只验证，不扣除）
    if table.notEmpty(successItems) and extMaxRate > 0 then
        -- 计算辅助道具的成功率（包含类型 1/2/3）
        successRateFromExtra, extraCost, extraBagIndexCost = this.getSuccessCostRateNew(actor, cfg_synthesis, successItems, false, extMaxRate)
    end
    local totalRate = baseRate + successRateFromExtra
    local finalRate = math.min(totalRate, maxSuccessRate)

    -- ========== 幸运道具加成 ==========
    local luckyAddRate = 0  -- 幸运道具额外加的成功率
    local luckyCostMap = {} -- 要扣除的幸运道具 {cfgId=count}

    if luckyItem and luckyItem.id then
        local luckyItemId = tonumber(luckyItem.id)
        local luckyItemCount = tonumber(luckyItem.count) or 0

        -- 第1步：从配置中解析 luckyItem 字段，格式: id#rate|id#rate
        -- 比如 "1001#1000|1002#2000" 解析成 { [1001]=1000, [1002]=2000 }
        local luckyItemCfg = cfg_synthesis.luckyitem or ""
        local luckyRateMap = {}  -- {道具id = 加成成功率}

        if not string.isNullOrEmpty(luckyItemCfg) then
            local pairs = string.split(luckyItemCfg, "|")
            for _, p in ipairs(pairs) do
                local parts = string.split(p, "#")
                if #parts >= 2 then
                    local itemId = tonumber(parts[1])
                    local rate = tonumber(parts[2]) or 0
                    if itemId then
                        luckyRateMap[itemId] = rate
                    end
                end
            end
        end

        -- 第2步：检查玩家用的道具ID在不在配置里
        if not luckyRateMap[luckyItemId] then
            tipinfo(actor, "该道具不是幸运道具")
            return
        end

        -- 第3步：检查背包里道具够不够
        if luckyItemCount <= 0 then
            tipinfo(actor, "幸运道具数量不正确")
            return
        end

        local haveCount = Bag.countItem(actor, luckyItemId) or 0
        if haveCount < luckyItemCount then
            tipinfo(actor, "幸运道具数量不足")
            return
        end

        -- 第4步：计算加成成功率 = 每个道具的加成 × 数量
        local perRate = luckyRateMap[luckyItemId]  -- 从配置读取每个道具的加成率
        luckyAddRate = perRate * luckyItemCount
        luckyCostMap[luckyItemId] = luckyItemCount
    end

    -- 第5步：把幸运道具加成加上去（可以超过maxSuccessRate上限！）
    finalRate = finalRate + luckyAddRate
    -- ================================

    -- 4. 随机判定
    local result = RandomUtil.isLuck(finalRate)

    -- 5. 扣除材料（无论成功失败都扣除，有保护符的装备除外）

    local coin = string.toIntIntMap(cfg_synthesis.coin, "#", "|")
    table.mergeAdd(coin, needCost)
    table.mergeAdd(coin, extraCost)
    table.mergeAdd(needBagIndexCost, extraBagIndexCost)
    -- 扣除幸运道具
    if next(luckyCostMap) then
        table.mergeAdd(coin, luckyCostMap)
    end
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
            local oldCount = coin[itemCfgId] or 0
            coin[itemCfgId] = oldCount + 1
        end
    end

    if not Bag.checkCostMap(actor, coin) then
        tipinfo(actor, "消耗不足")
        return
    end
    for bagindex, count in pairs(needBagIndexCost) do
        local item = getbagiteminfo(actor, bagindex)
        if count > item.count then
            tipinfo(actor, "消耗不足")
            return
        end
    end
    Bag.costMap(actor, coin, '物品合成消耗')
    if table.notEmpty(needBagIndexCost) then
        removeitembyidxlist(actor, needBagIndexCost, 9999, '物品合成消耗')
    end

    -- 6. 处理失败降阶
    local ids = {}
    if not result and table.notEmpty(specialCost) then
        local failStr = cfg_synthesis.fail
        if not string.isNullOrEmpty(failStr) and isProtect then
            local fail = string.splitInt(failStr, "#")
            local strengthLv = fail[1] or 0
            local appendLv = fail[2] or 0
            this.equipDemotion(actor, needBagIndexCost, specialCost, strengthLv, appendLv, ids)
        end
    end

    -- 7. 发送结果
    if not result then
        local equipInfos = this.getEquipInfos(actor, ids)
        sendluamsg(actor, LuaMessageIdToClient.RES_ITEM_SYNTHESIS, { res = equipInfos, result = false })
        return
    end

    -- 8. 发放奖励
    local productItem, productCount = this.getProductItem(cfg_synthesis, dingxiangItem, actor) --获得生成物
    if bind == 1 then
        productItem = API.GetBindItemCfgId(productItem)
    else
        productItem = API.GetNotBindItemCfgId(productItem)
    end

    local itemIds = additemmaptobag(actor, { [productItem] = productCount }, 0, 9999, ItemActionProxy.ITEM_SYNTHESIS)
    sendluamsg(actor, LuaMessageIdToClient.RES_ITEM_SYNTHESIS, { result = true })
    info(actor, "玩家", actor, "合成成功 合成配置", cfg_synthesis.id, "放入道具", putInItems, "合成消耗", needCost, "合成的道具", productItem, "数量", productCount, "绑定", bind)

    -- 9. 触发合成任务
    local taskParam = { synthesisid = cfg_synthesis.id, num = 1 }
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.SYNTHESIS, taskParam)
end

-- ====================================公共验证方法========================================

-- 检查装备是否匹配（类型 2）
function this.checkEquipMatch(actor, itemInfo, params)
    local cfgId = itemInfo.itemConfigId
    local id = itemInfo.id
    if not cfgId then
        return false
    end

    local needCfgId = params.cfgId or 0
    local needStrengthLv = params.strengthLv or 0
    local needAppendLv = params.appendLv or 0
    local needPz = params.pz or 0
    local needItemType = params.itemType or 0

    -- 1. 检查指定道具 cfgId
    if needCfgId > 0 and not API.ItemEqulas(needCfgId, cfgId) then
        return false
    end

    local itemExtData = EquipAndAppear.getItemExtData(actor, id)

    -- 2. 检查强化等级
    local actualStrengthLv = itemExtData.strengthlv or 0
    if needStrengthLv > 0 and actualStrengthLv < needStrengthLv then
        return false
    end

    -- 3. 检查追加等级
    local actualAppendLv = itemExtData.appendlv or 0
    if needAppendLv > 0 and actualAppendLv < needAppendLv then
        return false
    end

    -- 4. 检查品质需求
    if needPz > 0 and needPz ~= 99 then
        local outstanding = ConfigDataManager.getTableValue("cfg_item", "Outstanding", "id", cfgId)
        outstanding = tonumber(outstanding) or 0
        if needPz ~= outstanding then
            return false
        end
    end

    -- 5. 检查类别需求
    if needItemType ~= 0 then
        if needItemType == 5 then
            -- 首饰
            local subType = ConfigDataManager.getTableValue("cfg_item", "subType", "id", cfgId)
            subType = tonumber(subType) or 0
            local selectType = ConfigDataManager.getTableValue("cfg_item", "type", "id", cfgId)
            selectType = tonumber(selectType) or 0
            if selectType ~= ItemType.EQUIP or (subType ~= 10 and subType ~= 11 and subType ~= 12) then
                return false
            end
        else
            local mixtype = ConfigDataManager.getTableValue("cfg_item", "Mixtype", "id", cfgId)
            mixtype = tonumber(mixtype) or 0
            if needItemType ~= mixtype then
                return false
            end
        end
    end
    return true
end



-- ====================================刚需材料验证========================================
-- 验证刚需材料并记录消耗（不扣除），同时计算类型 3 的成功率
-- @param actor 玩家对象
-- @param costCfg 刚需材料配置字符串
-- @param putInItems 玩家放入的物品列表
-- @return cost, bagIndexCost, bind, specialCost, type3SuccessRate (类型 3 的成功率加成)
function this.getCostNew(actor, costCfg, putInItems)
    local bind = 0
    local cost = {}
    local bagIndexCost = {}
    local specialCost = {}
    local type3SuccessRate = 0  -- 类型 3 的成功率加成
    local tConsumeItem = ItemSynthesis.string2table(costCfg)

    -- 初始化配置需求
    local configNeeds = {}
    for i, v in ipairs(tConsumeItem) do
        local type = tonumber(v[1])
        local cfgCount = 0
        if type == 1 then
            cfgCount = tonumber(v[3]) or 0
        elseif type == 2 then
            cfgCount = tonumber(v[7]) or 1
        elseif type == 3 then
            cfgCount = tonumber(v[8]) or 1
        end
        configNeeds[i] = {
            data = v,
            type = type,
            needed = cfgCount,
            filled = 0
        }
    end

    -- 遍历玩家放入的每个物品（外层循环）
    for _, value in pairs(putInItems) do
        local id = value.id
        local itemConfigId = value.itemConfigId
        local remainingCount = value.itemCount  -- 该物品还剩多少可用

        if remainingCount > 0 then
            -- 尝试匹配每个配置需求（内层循环）
            for i, config in ipairs(configNeeds) do
                if remainingCount <= 0 then
                    break  -- 该物品已全部分配完
                end

                local type = config.type
                local v = config.data
                local neededCount = config.needed - config.filled  -- 该配置还缺多少

                if neededCount > 0 then
                    local canMatch = false
                    local params = nil

                    if type == 1 then
                        -- 类型 1: 1#道具 id#数量
                        local cfgId = tonumber(v[2])
                        canMatch = API.ItemEqulas(cfgId, itemConfigId)

                    elseif type == 2 then
                        -- 类型 2: 2#强化#追加#品质#类别#cfgId#数量
                        params = {
                            strengthLv = tonumber(v[2]) or 0,
                            appendLv = tonumber(v[3]) or 0,
                            pz = tonumber(v[4]) or 0,
                            itemType = tonumber(v[5]) or 0,
                            cfgId = tonumber(v[6]) or 0
                        }
                        canMatch = this.checkEquipMatch(actor, value, params)

                    elseif type == 3 then
                        -- 类型 3: 3#品质#类别#成功率组 id#cfgId#数量
                        params = {
                            strengthLv = tonumber(v[2]) or 0,
                            appendLv = tonumber(v[3]) or 0,
                            pz = tonumber(v[4]) or 0,
                            itemType = tonumber(v[5]) or 0,
                            successRateGroupId = tonumber(v[6]) or 0,
                            cfgId = tonumber(v[7]) or 0
                        }
                        canMatch = this.checkEquipMatch(actor, value, params)
                    end

                    if canMatch then
                        -- 计算实际使用数量
                        local useCount = math.min(remainingCount, neededCount)

                        -- 更新剩余数量和已填充数量
                        remainingCount = remainingCount - useCount
                        config.filled = config.filled + useCount

                        -- 记录消耗
                        local selectType = tonumber(ConfigDataManager.getTableValue("cfg_item", "type", "id", itemConfigId))

                        if selectType == ItemType.EQUIP then
                            -- 装备：按背包索引记录
                            local bagIndex = value.itemIndex
                            local oldCount = bagIndexCost[bagIndex] or 0
                            bagIndexCost[bagIndex] = oldCount + useCount
                            
                            -- 类型 2/3 的装备需要记录到 specialCost
                            if type == 2 or type == 3 then
                                table.insert(specialCost, { bagIndex, useCount, id, itemConfigId })

                                -- 类型 3 需要计算成功率
                                if type == 3 then
                                    for j = 1, useCount do
                                        type3SuccessRate = type3SuccessRate + this.calculateType3Rate(value, params, actor)
                                    end
                                end
                            end
                        else
                            -- 普通道具：按配置 ID 记录
                            local oldCount = cost[itemConfigId] or 0
                            cost[itemConfigId] = oldCount + useCount
                        end

                        -- 计算 bind
                        bind = this.checkBind(bind, actor, id, itemConfigId, selectType)
                    end
                end
            end
        end
    end

    -- 验证所有配置是否都满足
    for _, config in ipairs(configNeeds) do
        if config.filled ~= config.needed then
            info("刚需消耗不足", config.filled, config.needed, config.data)
            return nil, nil, nil, nil, 0
        end
    end

    return cost, bagIndexCost, bind, specialCost, type3SuccessRate
end

function this.checkBind(bind, actor, id, itemConfigId, itemType)
    if bind == 0 then
        if itemType == ItemType.EQUIP then
            local iteminfo = getbagiteminfo(actor, id, 1)
            if iteminfo.isbind then
                return 1
            end
        else
            local lockItem = ConfigDataManager.getTableValue("cfg_item", "lockitem", "id", itemConfigId)
            if lockItem ~= "" and lockItem == "2" then
                return 1
            end
        end
    end
    return bind
end

function ItemSynthesis.getSuccessRate(actor, cfg_synthesis, successItems)
    local finalExtraRate, cost, bagIndexCost = this.getSuccessCostRateNew(actor, cfg_synthesis, successItems, true, 0)
    return finalExtraRate
end

function this.getSuccessCostRateNew(actor, cfg_synthesis, successItems, shouldDeduct, extMaxRate)
    if table.isEmpty(successItems) then
        return 0, {}, {}
    end

    local consumeitem2 = cfg_synthesis.consumeitem2
    if string.isNullOrEmpty(consumeitem2) then
        return 0, {}, {}
    end

    local maxExtraRate = extMaxRate
    local currentExtraRate = 0
    local cost = {}
    local bagIndexCost = {}
    local tConsumeItem2 = ItemSynthesis.string2table(consumeitem2)

    -- 初始化配置需求跟踪表
    local configNeeds = {}
    for i, v in ipairs(tConsumeItem2) do
        local type = tonumber(v[1])
        local params = nil
        local successRate = 0

        if type == 1 then
            -- 类型 1: 1#道具 id#辅助材料增加成功率
            successRate = tonumber(v[3]) or 0
        elseif type == 2 then
            -- 类型 2: 2#强化等级#追加等级#品质需求#类别需求#指定道具 cfgId#辅助材料增加成功率
            params = {
                strengthLv = tonumber(v[2]) or 0,
                appendLv = tonumber(v[3]) or 0,
                pz = tonumber(v[4]) or 0,
                itemType = tonumber(v[5]) or 0,
                cfgId = tonumber(v[6]) or 0,
                successRate = tonumber(v[7]) or 0
            }
            successRate = params.successRate
        elseif type == 3 then
            -- 类型 3: 3#品质需求#类别需求#成功率组 id#指定道具 id#数量
            params = {
                strengthLv = tonumber(v[2]) or 0,
                appendLv = tonumber(v[3]) or 0,
                pz = tonumber(v[4]) or 0,
                itemType = tonumber(v[5]) or 0,
                successRateGroupId = tonumber(v[6]) or 0,
                cfgId = tonumber(v[7]) or 0
            }
            successRate = tonumber(v[8]) or 0
        end

        configNeeds[i] = {
            data = v,
            type = type,
            params = params,
            successRate = successRate,
        }
    end

    -- ====================================
    -- 第一阶段：计算每个物品的成功率并排序
    -- ====================================
    local itemRates = {}  -- 存储每个物品的成功率信息

    for _, itemInfo in ipairs(successItems) do
        local id = itemInfo.id
        local itemConfigId = itemInfo.itemConfigId
        local remainingCount = itemInfo.itemCount

        if remainingCount > 0 then
            local bestConfig = nil
            local bestRateToAdd = 0

            -- 找出该物品能匹配的所有配置中成功率最高的
            for i, config in ipairs(configNeeds) do
                local type = config.type
                local canMatch = false

                if type == 1 then
                    -- 类型 1: 检查道具 ID 是否匹配
                    local cfgId = tonumber(config.data[2])
                    canMatch = (itemConfigId == cfgId)

                elseif type == 2 then
                    -- 类型 2: 检查装备是否匹配
                    local tempItemInfo = { itemConfigId = itemConfigId, id = id }
                    canMatch = this.checkEquipMatch(actor, tempItemInfo, config.params)

                elseif type == 3 then
                    -- 类型 3: 检查装备是否匹配
                    local tempItemInfo = { itemConfigId = itemConfigId, id = id }
                    canMatch = this.checkEquipMatch(actor, tempItemInfo, config.params)
                end

                if canMatch then
                    -- 计算该配置的实际成功率
                    local rateToAdd = config.successRate
                    if type == 3 then
                        -- 类型 3 需要从配置表读取成功率
                        local tempItemInfo = { itemConfigId = itemConfigId, id = id, itemCount = 1 }
                        rateToAdd = this.calculateType3Rate(tempItemInfo, config.params, actor) + config.successRate
                    end

                    -- 选择成功率最高的配置
                    if rateToAdd > bestRateToAdd then
                        bestConfig = config
                        bestRateToAdd = rateToAdd
                    end
                end
            end

            -- 记录该物品的最佳配置和成功率
            if bestConfig and bestRateToAdd > 0 then
                table.insert(itemRates, {
                    itemInfo = itemInfo,
                    bestConfig = bestConfig,
                    ratePerItem = bestRateToAdd,
                    remainingCount = remainingCount
                })
            end
        end
    end

    -- 按成功率从高到低排序
    table.sort(itemRates, function(a, b)
        return a.ratePerItem > b.ratePerItem
    end)

    -- ====================================
    -- 第二阶段：按成功率顺序依次消耗物品
    -- ====================================
    for _, itemData in ipairs(itemRates) do
        if maxExtraRate ~= 0 and currentExtraRate >= maxExtraRate then
            break
        end

        local itemInfo = itemData.itemInfo
        local bestConfig = itemData.bestConfig
        local ratePerItem = itemData.ratePerItem
        local remainingCount = itemData.remainingCount

        local itemConfigId = itemInfo.itemConfigId

        -- 尽可能多地消耗这个物品，直到达到上限或物品用完
        local useCount = 0
        while useCount < remainingCount and (maxExtraRate == 0 or currentExtraRate < maxExtraRate) do
            useCount = useCount + 1

            -- 记录消耗
            local type = bestConfig.type
            if type == 1 then
                local cfgId = tonumber(bestConfig.data[2])
                cost[cfgId] = (cost[cfgId] or 0) + 1
            elseif type == 2 or type == 3 then
                local selectType = tonumber(ConfigDataManager.getTableValue("cfg_item", "type", "id", itemConfigId))
                if selectType == ItemType.EQUIP then
                    local bagIndex = itemInfo.itemIndex
                    bagIndexCost[bagIndex] = (bagIndexCost[bagIndex] or 0) + 1
                else
                    cost[itemConfigId] = (cost[itemConfigId] or 0) + 1
                end
            end

            -- 累加成功率
            currentExtraRate = currentExtraRate + ratePerItem
        end
    end

    -- 限制最大成功率
    local finalExtraRate = maxExtraRate == 0 and currentExtraRate or math.min(currentExtraRate, maxExtraRate)

    -- 如果需要扣除，则扣除材料
    if shouldDeduct then
        if next(bagIndexCost) then
            for bagindex, count in pairs(bagIndexCost) do
                local item = getbagiteminfo(actor, bagindex)
                if count > item.count then
                    tipinfo(actor, "额外消耗道具数量不足")
                    return 0
                end
            end
            removeitembyidxlist(actor, bagIndexCost, 9999, '物品合成额外消耗')
        end
        if next(cost) then
            if not Bag.checkCostMap(actor, cost) then
                tipinfo(actor, "额外消耗道具数量不足")
                return 0
            end
            Bag.costMap(actor, cost, '物品合成额外消耗')
        end
    end

    return finalExtraRate, cost, bagIndexCost
end


-- 计算类型 3 的成功率
function this.calculateType3Rate(itemInfo, params, actor)
    if not params.successRateGroupId or params.successRateGroupId <= 0 then
        return 0
    end

    local rateGroupCfg = ConfigDataManager.getById("cfg_synthesisRateGroup", params.successRateGroupId)
    if table.isEmpty(rateGroupCfg) then
        return 0
    end

    local successRate = 0
    local itemExtData = getitemextdata(actor, itemInfo.id) or {}
    local strengthLv = itemExtData.strengthlv or 0
    local appendLv = itemExtData.appendlv or 0

    -- 根据强化等级区间计算成功率
    if rateGroupCfg.strengthenrate then
        local strengthenRates = ItemSynthesis.string2table(rateGroupCfg.strengthenrate)
        for _, rateInfo in pairs(strengthenRates) do
            local minLv = tonumber(rateInfo[1])
            local maxLv = tonumber(rateInfo[2])
            local rate = tonumber(rateInfo[3])
            if strengthLv >= minLv and strengthLv <= maxLv then
                successRate = successRate + rate
                break
            end
        end
    end

    -- 根据追加等级区间计算成功率
    if rateGroupCfg.appendsrate then
        local appendsRates = ItemSynthesis.string2table(rateGroupCfg.appendsrate)
        for _, rateInfo in pairs(appendsRates) do
            local minLv = tonumber(rateInfo[1])
            local maxLv = tonumber(rateInfo[2])
            local rate = tonumber(rateInfo[3])
            if appendLv >= minLv and appendLv <= maxLv then
                successRate = successRate + rate
                break
            end
        end
    end

    if rateGroupCfg.attrate then
        local itemAttInfo = getitemattinfo(actor, 1, tonumber(itemInfo.itemConfigId), itemInfo.id)
        local itemAtt = itemAttInfo.baseatt or {}
        if table.isNullOrEmpty(itemAtt) then
            return successRate
        end
        local itemRates = ItemSynthesis.string2table(rateGroupCfg.attrate)
        for _, rateInfo in pairs(itemRates) do
            local attrId = rateInfo[1]
            local minAttValue = tonumber(rateInfo[2])
            local maxAttValue = tonumber(rateInfo[3])
            local rate = tonumber(rateInfo[4])
            local attrValue = tonumber(itemAtt[attrId]) or 0
            if attrValue >= minAttValue and attrValue <= maxAttValue then
                successRate = successRate + rate
                break
            end
        end
    end
    return successRate
end


-- ====================================失败降阶处理========================================
function this.equipDemotion(actor, cost, specialCost, strengthLv, appendLv, ids)
    if table.isNullOrEmpty(specialCost) then
        return
    end
    for _, v in pairs(specialCost) do
        local bagIndex = v[1]
        local count = v[2]
        local itemid = v[3]
        local itemCfgId = v[4]
        local oldCount = cost[bagIndex] - count
        if oldCount < 1 then
            cost[bagIndex] = nil
        else
            cost[bagIndex] = oldCount
        end

        local equipdata = EquipAndAppear.getItemExtData(actor, itemid)
        if equipdata then
            equipdata.strengthlv = strengthLv

            local strengthattr = this.getAttrByStrengthLv(itemCfgId, strengthLv)
            equipdata.strengthattr = strengthattr
            equipdata.originalStrengthattr = strengthattr

            local appendattr = this.getAttrByAppendLv(itemCfgId, appendLv)
            equipdata.appendlv = appendLv
            equipdata.appendattr = appendattr
            equipdata.originalAppendattr = appendattr

            local maxDurability = EquipDurability.getMaxDurability(itemCfgId, strengthLv)
            if (equipdata.durabilityNum or 0) > maxDurability then
                equipdata.durabilityNum = maxDurability
            end
            EquipDurability.updateDurabilityAttr(actor, equipdata, itemCfgId)
            EquipAndAppear.SetItemExtData(actor, itemid, equipdata)
        end
        table.insert(ids, itemid)
    end
end

function this.getAttrByStrengthLv(cfgId, strengthLv)
    local strengthattr
    local cfg_equip_strengthen = ConfigDataManager.getById("cfg_equip_strengthen", cfgId)
    local costId = cfg_equip_strengthen.costid
    local groupId = cfg_equip_strengthen.groupid
    local strengthenCostCfg = ConfigDataManager.getTableFirst("cfg_equip_strengthenCost", "costGroupId", costId, "level",
            strengthLv)
    if table.isEmpty(strengthenCostCfg) then
        return {}
    end
    local muneType = strengthenCostCfg.munetype
    if muneType == "1" then
        local att = ConfigDataManager.getTableValue("cfg_equip_strengthenGroup", "att", "group", groupId, "lv",
                strengthLv)
        strengthattr = string.toIntIntMap(att, "#", "|")
    else
        local att = ConfigDataManager.getTableValue("cfg_equip_strengthenGroup", "att", "group", groupId, "lv",
                strengthLv)
        local attr = string.toIntIntMap(att, "#", "|")
        local part = tonumber(ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", cfgId))
        local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id",
                GlobalConfigId.FORGE_EQUIP_ATTR_LIMIT)
        local limit = string.toIntIntMap(cfg_str)
        local parts = table.keys(limit)

        local newAttr = {}
        for attrId, value in pairs(attr) do
            if table.contains(parts, part) and limit[part] == attrId then
                newAttr[attrId] = value
            else
                local newValue = value + (strengthLv - 9) * (strengthLv - 8) / 2
                newAttr[attrId] = newValue
            end
        end
        strengthattr = newAttr
    end
    return strengthattr
end

function this.getAttrByAppendLv(cfgId, appendLv)
    local appendattr
    local cfg_equip_appends = ConfigDataManager.getById("cfg_equip_appends", cfgId)
    local costId = cfg_equip_appends.costid
    local groupId = cfg_equip_appends.groupid
    local appendsCostCfg = ConfigDataManager.getTableFirst("cfg_equip_appendsCost", "costGroupId", costId, "level",
            appendLv)
    if table.isEmpty(appendsCostCfg) then
        return {}
    end
    local muneType = appendsCostCfg.munetype
    if muneType == "1" then
        appendattr = EquipAndAppear.getZhuiJiaAttrs(appendLv, groupId)
    else
        local attr = EquipAndAppear.getZhuiJiaAttrs(appendLv, groupId)

        local part = tonumber(ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", cfgId))
        local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id",
                GlobalConfigId.FORGE_EQUIP_ATTR_LIMIT)
        local limit = string.toIntIntMap(cfg_str)
        local parts = table.keys(limit)

        local newAttr = {}
        for attrId, value in pairs(attr) do
            if table.contains(parts, part) and limit[part] == attrId then
                newAttr[attrId] = value
            else
                local newValue = value + (appendLv - 9) * (appendLv - 8) / 2
                newAttr[attrId] = newValue
            end
        end
        appendattr = newAttr
    end
    return appendattr
end

-- ====================================工具方法========================================
function ItemSynthesis.string2table(str)
    local result = {}
    local pairs = string.split(str, "|")
    for _, pairStr in ipairs(pairs) do
        local values = string.split(pairStr, "#")
        table.insert(result, values)
    end
    return result
end

function this.getEquipInfos(actor, ids)
    if table.isEmpty(ids) then
        return {}
    end
    local equipInfos = {}
    for _, id in pairs(ids) do
        local itemInfo = getbagiteminfo(actor, id, 1)
        local item = ItemFactory.build(itemInfo)
        table.insert(equipInfos, item)
    end
    return equipInfos
end

function this.getProductItem(cfg_synthesis, dingxiangItem, actor)
    local productItem = nil
    local productCount = 0
    local productList = ItemSynthesis.string2table(cfg_synthesis.productid)

    if table.notEmpty(dingxiangItem) then
        for _, value in pairs(productList) do
            local dingxiangCfgId = tonumber(value[4])
            if API.ItemEqulas(dingxiangCfgId, tonumber(dingxiangItem.itemConfigId)) then
                productItem = tonumber(value[1])
                productCount = tonumber(value[2])
                break
            end
        end
        if not productItem then
            local weightMap = {}
            for _, value in pairs(productList) do
                table.insert(weightMap, { itemCfgId = tonumber(value[1]), count = tonumber(value[2]), qz = tonumber(value[3]) })
            end
            local idx = API.GetQZ(weightMap)
            if idx < 1 then
                tipinfo(actor, "配置异常")
                error(actor, "玩家", actor, "合成物 权重错误 配置异常 配置 id：", cfg_synthesis.id, " 配置内容：", cfg_synthesis.productid)
            end
            local info = weightMap[idx]
            productItem = info.itemCfgId
            productCount = info.count
        else
            Bag.cost(actor, dingxiangItem.itemConfigId, 1, '物品合成定向消耗')
        end
    else
        local weightMap = {}
        for _, value in pairs(productList) do
            table.insert(weightMap, { itemCfgId = tonumber(value[1]), count = tonumber(value[2]), qz = string.tonumber(value[3]) })
        end
        local idx = API.GetQZ(weightMap)
        if idx < 1 then
            tipinfo(actor, "配置异常")
            error(actor, "玩家", actor, "合成物 权重错误 配置异常 配置 id：", cfg_synthesis.id, " 配置内容：", cfg_synthesis.productid)
        end
        local info = weightMap[idx]
        productItem = info.itemCfgId
        productCount = info.count
    end

    return productItem, productCount
end


---  荧石合成--------------

function ItemSynthesis.synthesisYingShi(actor, msgData)
    local cfgId = msgData[1]
    local putInItems = msgData[2]      -- 刚需道具
    local mainItemId = msgData[3]
    local cfg_yingShi = ConfigDataManager.getById("synhtesis_yingshi", cfgId)
    if table.isEmpty(cfg_yingShi) then
        tipinfo(actor, "荧石合成配置不存在：" .. cfgId)
        return
    end
    local mainAttrId = 0
    local mainItemInfo = EquipAndAppear.getItemExtData(actor, mainItemId)
    if table.notNullOrEmpty(mainItemInfo) and table.notNullOrEmpty(mainItemInfo.gemAttr) then
        -- 获取 gemAttr 中的第一个 key（属性 ID）
        for attrId, _ in pairs(mainItemInfo.gemAttr) do
            mainAttrId = attrId
            break
        end
    end
    local currentLevel = getbaseinfo(actor, "level")
    if string.tonumber(cfg_yingShi.level) > tonumber(currentLevel) then
        tipinfo(actor, "荧石合成条件不满足")
        return nil
    end

    -- 1. 验证刚需道具并计算成功率（只验证，不扣除）
    local needCost, needBagIndexCost, bind = this.getYingShiCost(actor, cfg_yingShi, putInItems)
    if table.isEmpty(needCost) and table.isEmpty(needBagIndexCost) and not string.isNullOrEmpty(cfg_yingShi.consumeitemmain) then
        error(actor, "玩家", actor, "合成 合成条件不满足 配置id", cfgId, "放入主要道具", putInItems, "合成配置", cfg_yingShi, "合成消耗", needCost)
        tipinfo(actor, "刚需材料不满足")
        return
    end
    local coin = string.toIntIntMap(cfg_yingShi.coin, "#", "|")
    table.mergeAdd(coin, needCost)

    if not Bag.checkCostMap(actor, coin) then
        tipinfo(actor, "消耗不足")
        return
    end
    for bagindex, count in pairs(needBagIndexCost) do
        local item = getbagiteminfo(actor, bagindex)
        if count > item.count then
            tipinfo(actor, "消耗不足")
            return
        end
    end
    -- 3. 计算总成功率 = 基础成功率 + 类型 3 成功率 + 辅助成功率
    local successRateReal = string.tonumber(cfg_yingShi.successratereal)

    local maxSuccessRate = tonumber(cfg_yingShi.successratemax) or 10000
    local finalRate = math.min(successRateReal, maxSuccessRate)

    -- 4. 随机判定
    local result = RandomUtil.isLuck(finalRate)

    -- 5. 扣除材料（无论成功失败都扣除，有保护符的装备除外）
    Bag.costMap(actor, coin, '物品合成消耗')
    if table.notEmpty(needBagIndexCost) then
        removeitembyidxlist(actor, needBagIndexCost, 9999, '物品合成消耗')
    end
    -- 7. 发送结果
    if not result then
        sendluamsg(actor, LuaMessageIdToClient.RES_ITEM_SYNTHESIS, { result = false })
        return
    end

    -- 8. 发放奖励
    local productItem, productCount = this.getProductItem(cfg_yingShi, { }, actor) --获得生成物
    if bind == 1 then
        productItem = API.GetBindItemCfgId(productItem)
    else
        productItem = API.GetNotBindItemCfgId(productItem)
    end

    --[[    SynthesisLog.addLog(string.format("5.刚需放入的是绑定道具，获得的道具为绑定道具，刚需放入的是非绑定道具，获得的道具为非绑定道具 修正后获得的道具id，合成结果获得的道具id：[%d]， 数量：[%d]， 刚需放入的是否绑定道具，绑定：1，非绑：0"
        , productItem, productCount, bind))
        SynthesisLog.send(actor)]]

    --  local itemIds = additemmaptobag(actor, { [productItem] = productCount }, 0, 9999, "物品合成奖励")

    local bagToShellParam = {
        itemcfgid = tostring(productItem),
        count = tostring(productCount),
        bagindex = tostring(-1),
        ignorebind = tostring(1),
        desc = "荧石合成奖励"
    }
    local data = bagtoshell(actor, bagToShellParam, 1)
    local reason = data["reason"]
    if reason ~= 0 then
        tipinfo(actor, "合成异常", reason);
        return
    end
    mainAttrId = this.initProductItemGemAttr(productItem, mainAttrId)
    local product = {
        itemId = data.itemid,
        itemCfgId = productItem,
        count = productCount,
        attrId = mainAttrId
    }
    -- 移动到货架暂存
    local res = {}
    local synthesisData = this.getSynthesisData(actor)
    table.insert(res, product)
    table.insert(synthesisData, product)
    this.setSynthesisData(actor, synthesisData)

    local yingshiData = ItemSynthesis.getYingShiGemAttrData(actor)
    yingshiData[data.itemid] = mainAttrId
    ItemSynthesis.setYingShiGemAttrData(actor, yingshiData)

    local tab = { res = res, result = true }
    sendluamsg(actor, LuaMessageIdToClient.RES_ITEM_SYNTHESIS, tab)

    info(actor, "玩家", actor, "合成成功 合成配置", cfg_yingShi.id, "放入道具", putInItems, "合成消耗", needCost, "合成的道具", productItem, "数量", productCount, "绑定", bind)

    --[[    -- 9. 触发合成任务  ---目前没有这个需求 需要新增类型或额外处理 表不一样
        local taskParam = { synthesisid = cfg_yingShi.id, num = 1 }
        TaskHandler.TriggerTaskGoal(actor, TaskTargetType.SYNTHESIS, taskParam)]]
end

function this.initProductItemGemAttr(productItem, mainAttrId)
    if mainAttrId ~= 0 and mainAttrId ~= "0" then
        return mainAttrId
    end
    local itemCfg = ConfigDataManager.getById("cfg_item", productItem)
    local type = tonumber(itemCfg.type)
    local subType = tonumber(itemCfg.subtype)
    local gemCfg = ConfigDataManager.getById("cfg_equip_gem", productItem)
    if table.isNullOrEmpty(gemCfg) then
        return mainAttrId
    end
    if type == 5 and subType == 4 then
        mainAttrId = RandomUtil.randomKey(gemCfg.gematt)
    end
    return mainAttrId
end
function this.getYingShiCost(actor, costCfg, putInItems)
    local bind = 0
    local cost = {}
    local bagIndexCost = {}
    local tConsumeItemMain = ItemSynthesis.string2table(costCfg.consumeitemmain)
    local tConsumeItem = ItemSynthesis.string2table(costCfg.consumeitem)
    local allConsumeItem = {}
    allConsumeItem = table.AddRanage(allConsumeItem, tConsumeItemMain)
    allConsumeItem = table.AddRanage(allConsumeItem, tConsumeItem)

    -- 初始化配置需求
    local configNeeds = {}
    for i, v in ipairs(allConsumeItem) do
        local type = tonumber(v[1])
        local cfgCount = 0
        local params = nil

        if type == 1 then
            -- 类型 1: 1#道具 id#数量
            cfgCount = tonumber(v[3]) or 0
        elseif type == 2 then
            -- 类型 2: 2#强化#追加#品质#类别#cfgId#数量
            cfgCount = tonumber(v[6]) or 1
            params = {
                strengthLv = tonumber(v[2]) or 0,
                appendLv = tonumber(v[3]) or 0,
                pz = tonumber(v[4]) or 0,
                itemType = tonumber(v[5]) or 0,
                cfgId = 0  -- 类型 2 不指定具体 ID
            }
        end

        configNeeds[i] = {
            data = v,
            type = type,
            params = params,
            needed = cfgCount,
            filled = 0
        }
    end

    -- 遍历玩家放入的每个物品（外层循环）
    for _, value in pairs(putInItems) do
        local id = value.id
        local itemConfigId = value.itemConfigId
        local remainingCount = value.itemCount  -- 该物品还剩多少可用

        if remainingCount > 0 then
            -- 尝试匹配每个配置需求（内层循环）
            for i, config in ipairs(configNeeds) do
                if remainingCount <= 0 then
                    break  -- 该物品已全部分配完
                end

                local type = config.type
                local neededCount = config.needed - config.filled  -- 该配置还缺多少

                if neededCount > 0 then
                    local canMatch = false

                    if type == 1 then
                        -- 类型 1: 检查道具 ID 是否匹配
                        local cfgId = tonumber(config.data[2])
                        canMatch = API.ItemEqulas(cfgId, itemConfigId)

                    elseif type == 2 then
                        -- 类型 2: 检查装备是否匹配
                        canMatch = this.checkEquipMatch(actor, value, config.params)
                    end

                    if canMatch then
                        -- 计算实际使用数量
                        local useCount = math.min(remainingCount, neededCount)

                        -- 更新剩余数量和已填充数量
                        remainingCount = remainingCount - useCount
                        config.filled = config.filled + useCount

                        -- 记录消耗
                        local selectType = tonumber(ConfigDataManager.getTableValue("cfg_item", "type", "id", itemConfigId))

                        if selectType == ItemType.EQUIP then
                            -- 装备：按背包索引记录
                            local bagIndex = value.itemIndex
                            local oldCount = bagIndexCost[bagIndex] or 0
                            bagIndexCost[bagIndex] = oldCount + useCount
                        else
                            -- 普通道具：按配置 ID 记录
                            local oldCount = cost[itemConfigId] or 0
                            cost[itemConfigId] = oldCount + useCount
                        end

                        -- 计算 bind
                        bind = this.checkBind(bind, actor, id, itemConfigId, selectType)
                    end
                end
            end
        end
    end

    -- 验证所有配置是否都满足
    for _, config in ipairs(configNeeds) do
        if config.filled ~= config.needed then
            info("刚需消耗不足", config.filled, config.needed, config.data)
            return nil, nil, nil
        end
    end

    return cost, bagIndexCost, bind
end

function this.getSynthesisData(actor)
    return getplaydef(actor, SYNTHESIS_DATA) or {}
end

function this.setSynthesisData(actor, data)
    setplaydef(actor, SYNTHESIS_DATA, data)
end

function ItemSynthesis.getYingShiGemAttrData(actor)
    return getplaydef(actor, YINGSHI_GEM_ATTR_DATA) or {}
end
function ItemSynthesis.setYingShiGemAttrData(actor, data)
    setplaydef(actor, YINGSHI_GEM_ATTR_DATA, data)
end

function ItemSynthesis.reqSynthesisPutBag(actor, clientId)
    clientId = tonumber(clientId)
    if not clientId then
        return
    end
    local synthesisData = this.getSynthesisData(actor)
    if table.isEmpty(synthesisData) then
        return
    end
    local data = table.copy(synthesisData)
    for i, value in pairs(synthesisData) do
        local itemId = value.itemId
        if tonumber(clientId) == tonumber(itemId) then
            local productCount = value.count
            table.remove(data, i)
            shelltobag(actor, actor:toString(), itemId, productCount, actor:toString(), 0, nil, "initgemitemattr", ItemActionProxy.ITEM_SYNTHESIS)
            sendluamsg(actor, LuaMessageIdToClient.RES_SYNTHESIS_PUT_BAG, clientId)
            break
        end
    end
    this.setSynthesisData(actor, data)
end

function initgemitemattr(actor, data)
    local oldItemId = data.itemid
    local newItemId = data.bagitemid[1]
    local cfgId = data.itemcfgid
    local yingshiData = ItemSynthesis.getYingShiGemAttrData(actor)
    local attId = 0
    if yingshiData[oldItemId] then
        attId = yingshiData[oldItemId]
        yingshiData[oldItemId] = nil
        ItemSynthesis.setYingShiGemAttrData(actor, yingshiData)
    end
    if attId == 0 or attId == "0" then
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
    if not gemAtt[attId] then
        error("gemAtt[attId] is nil attId-->" .. attId .. "--cfg_equip_gem id ->" .. cfgId)
        return
    end
    local luaExtData = EquipAndAppear.getItemExtData(actor, newItemId)
    local gemAttrData = {}
    gemAttrData[attId] = gemAtt[attId]
    luaExtData.gemAttr = gemAttrData
    EquipAndAppear.SetItemExtData(actor, newItemId, luaExtData)
end

-- 登录所有未进包的放入背包
function this.login(actor)
    local synthesisData = this.getSynthesisData(actor)
    if table.isEmpty(synthesisData) then
        return
    end
    for i, value in pairs(synthesisData) do
        local itemId = value.itemId
        local productCount = value.count
        shelltobag(actor, actor:toString(), itemId, productCount, actor:toString(), 0, nil, "initgemitemattr", ItemActionProxy.ITEM_SYNTHESIS)
    end
    this.setSynthesisData(actor, {})
    -- sendluamsg(actor, LuaMessageIdToClient.RES_SYNTHESIS_PUT_BAG, {})
end

MessageRouter:register(LuaMessageIdToSever.REQ_SYNTHESIS_YING_SHI, ItemSynthesis.synthesisYingShi)
MessageRouter:register(LuaMessageIdToSever.REQ_SYNTHESIS_PUT_BAG, ItemSynthesis.reqSynthesisPutBag)
LoginEventListerTable:eventLister("0", "道具合成", this.login)
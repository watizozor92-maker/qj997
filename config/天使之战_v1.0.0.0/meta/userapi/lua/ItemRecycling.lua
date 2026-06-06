ItemRecycling = {}
local this = {}

local ItemRecyclingType = {
    PIN_JIE = 1,
    ZHUO_YUE = 2,
    ZHI_YE = 3
}

local ITEM_RECYCLING_TYPE = "T$itemRecyclingTYPE"

-- 分解
function ItemRecycling.decompositionlua(actor, msgID, msgData)
    local decompositionItemList = msgData[1]
    local allItemInfo = getallbagiteminfo(actor)
    if table.isEmpty(allItemInfo) then
        return
    end
    if table.isEmpty(decompositionItemList) then
        return
    end

    local allNeedMaterial = {}
    local allObtainList = {}
    for bagIndex, count in pairs(decompositionItemList) do
        for _, itemInfo in pairs(allItemInfo) do
            if itemInfo.bagindex == tonumber(bagIndex) then
                local itemCfgId = itemInfo.cfgid
                local decomposeGroup = ConfigDataManager.getTableValue("cfg_item", "decomposeGroup", "id", itemCfgId)
                if string.isNullOrEmpty(decomposeGroup) then
                    tipinfo(actor, "选择的道具中拥有不能分解的道具，请重新选择")
                    return
                end
                local decomposeTable = ConfigDataManager.getTable("cfg_recovery_out", "id", decomposeGroup)
                if table.isEmpty(decomposeTable) then
                    -- error(actor,"分解类型配置错误")
                    return
                end
                local equipext = EquipAndAppear.getItemExtData(actor, tonumber(itemInfo.id))
                if not table.isNullOrEmpty(equipext) then
                    EquipAndAppear.SetItemExtData(actor, tonumber(itemInfo.id), {})
                end

                local decomposeInfo = decomposeTable[1]
                -- 计算分解需要的东西
                local needMaterial = decomposeInfo.needmaterial
                if not string.isNullOrEmpty(needMaterial) then
                    local needMaterialInfo = string.split(needMaterial, "#")
                    local needMaterialCount = allNeedMaterial[needMaterialInfo[1]]
                    if not needMaterialCount then
                        needMaterialCount = 0
                    end
                    allNeedMaterial[needMaterialInfo[1]] = needMaterialCount + (tonumber(needMaterialInfo[2]) * count)
                end
                -- 计算分解获得的东西
                local material = decomposeInfo.material
                local group = decomposeInfo.group
                if tonumber(group) == 2 then
                    if not string.isNullOrEmpty(material) then
                        local allObtainTable = string.split(material, "|")
                        if not table.isEmpty(allObtainTable) then
                            if table.count(allObtainTable) == 1 then
                                -- 分解只会获得一种物品
                                local obtainInfo = string.split(allObtainTable[1], "#")
                                local obtainCount = allObtainList[obtainInfo[1]]
                                if obtainCount == nil then
                                    obtainCount = 0
                                end
                                local total = obtainCount + (tonumber(obtainInfo[2]) * count)
                                allObtainList[obtainInfo[1]] = total
                            else
                                -- 分解获得物品配置权重
                                local allWeight = 0
                                local newAllObtainTable = {}
                                for _, obtainInfo in pairs(allObtainTable) do
                                    local obtainWeight = string.split(obtainInfo, "#")
                                    allWeight = allWeight + tonumber(obtainWeight[3])
                                    obtainWeight[3] = allWeight
                                    table.insert(newAllObtainTable, obtainWeight)
                                end
                                for i = 1, count do
                                    local successIndex = math.random(1, allWeight)
                                    local lastWeight = 0
                                    for _, newObtainInfo in pairs(newAllObtainTable) do
                                        if lastWeight < successIndex and newObtainInfo[3] >= successIndex then
                                            local obtainCount = allObtainList[newObtainInfo[1]]
                                            if obtainCount == nil then
                                                obtainCount = 0
                                            end
                                            allObtainList[newObtainInfo[1]] = obtainCount + (tonumber(newObtainInfo[2]))
                                        end
                                        lastWeight = newObtainInfo[3]
                                    end
                                end
                            end
                        end
                    end
                else
                    if not string.isNullOrEmpty(material) then
                        local allObtainTable = string.split(material, "|")
                        for _, obtainInfo in pairs(allObtainTable) do
                            local obtainItemInfo = string.split(obtainInfo, "#")
                            local obtainCount = allObtainList[obtainItemInfo[1]]
                            if obtainCount == nil then
                                obtainCount = 0
                            end
                            local total = obtainCount + (tonumber(obtainItemInfo[2]) * count)
                            allObtainList[obtainItemInfo[1]] = total
                        end
                    end
                end
            end
        end
    end
    itemdecomposition(actor, decompositionItemList, allObtainList, allNeedMaterial)
    sendluamsg(actor, LuaMessageIdToClient.RES_ITEM_DECOMPOSITION, allObtainList)
end

function ItemRecycling.recyclingRateReward(actor, reward)
    this.recyclingRateReward(actor, reward)
end

function this.recyclingRateReward(actor, reward)
    local rate = 0
    -- 月卡特权
    local is_open, count = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.RECYCLING_INCOME_UP)
    if is_open then
        rate = rate + count;
    end

    -- VIP特权
    local vip_open, vip_rate = VipGiftPack.hasPrivilege(actor, VipPrivilege.Type.recycle)
    if vip_open and string.tonumber(vip_rate) > 0 then
        rate = rate + tonumber(vip_rate)
    end

    if rate < 1 then
        this.tipScore(actor, reward)
        return
    end

    for key, value in pairs(reward) do
        local final_value = value * rate / 100
        if final_value >= 1 then
            reward[key] = final_value
        end
    end
    additemmaptobag(actor, reward, 0, 9999, ItemActionProxy.ITEMRECYCLING)
    GameTips.sendGetRewardMsg(actor, reward)
    this.tipScore(actor, reward)
    this.debug("加成过的回收奖励", reward)
end

function this.tipScore(actor, reward)
    if table.hasKey(reward, ItemConfigId.SCORE) then
        local roleName = getbaseinfo(actor, "rolename")
        local count = reward[ItemConfigId.SCORE]
        noticeTip.noticeinfo(actor, StringIdConst.TEXT44001, roleName, count)
    end
end

-- 回收
function ItemRecycling.recovery(actor, msgData)
    local allItemInfo = getallbagiteminfo(actor)
    if table.isEmpty(allItemInfo) then
        return
    end
    if table.isEmpty(msgData) then
        return
    end
    local allObtainList = {}
    for bagIndex, count in pairs(msgData) do
        for _, itemInfo in pairs(allItemInfo) do
            if itemInfo.bagindex == tonumber(bagIndex) then
                local itemCfgId = itemInfo.cfgid
                local recoveryGroup = ConfigDataManager.getTableValue("cfg_item", "recoveryGroup", "id", itemCfgId)
                local recoveryUp = ConfigDataManager.getTableValue("cfg_item", "recoveryUp", "id", itemCfgId)
                if string.isNullOrEmpty(recoveryGroup) then
                    tipinfo(actor, "选择的道具中拥有不能分解的道具，请重新选择")
                    return
                end
                local recoveryTable = ConfigDataManager.getTable("cfg_recovery", "id", recoveryGroup)
                if table.isEmpty(recoveryTable) then
                    -- error(actor,"回收类型配置错误")
                    return
                end
                local equipext = EquipAndAppear.getItemExtData(actor, tonumber(itemInfo.id))
                if not table.isNullOrEmpty(equipext) then
                    EquipAndAppear.SetItemExtData(actor, tonumber(itemInfo.id), {})
                end

                local recoveryInfo = recoveryTable[1]
                local materialString = recoveryInfo.material
                materialString = string.split(materialString, "|")
                for k, materialStr in pairs(materialString) do
                    local material = string.splitInt(materialStr, "#")
                    local len = table.count(material)
                    if len == 3 then
                        local addCount = math.random(material[2], material[3])
                        addCount = addCount * count
                        if not string.isNullOrEmpty(recoveryUp) then
                            addCount = addCount * (1 + math.floor(tonumber(recoveryUp) / 100))
                        end
                        local obtainCount = allObtainList[tostring(material[1])]
                        if obtainCount == nil then
                            obtainCount = 0
                        end
                        allObtainList[tostring(material[1])] = obtainCount + addCount
                    elseif len == 4 then
                        local bind = material[1]
                        local lockItem = ConfigDataManager.getTableValue("cfg_item", "lockitem", "id", itemCfgId)
                        if bind == string.tonumber(lockItem) then
                            local addCount = math.random(material[3], material[4])
                            addCount = addCount * count
                            if not string.isNullOrEmpty(recoveryUp) then
                                addCount = addCount * (1 + math.floor(tonumber(recoveryUp) / 100))
                            end
                            local obtainCount = allObtainList[tostring(material[2])]
                            if obtainCount == nil then
                                obtainCount = 0
                            end
                            allObtainList[tostring(material[2])] = obtainCount + addCount
                        end
                    end
                end
            end
        end
    end
    itemrecovery(actor, msgData, allObtainList)
    sendluamsg(actor, LuaMessageIdToClient.RES_RECOVERY_REWARD, allObtainList)
    sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, allObtainList)
    -- sendluamsg(actor,LuaMessageIdToClient.RES_ITEM_RECOVERY,allObtainList)
end

-- 设置玩家回收类型
function ItemRecycling.setItemRecyclingType(actor, msgData)
    setplaydef(actor, ITEM_RECYCLING_TYPE, msgData)
    sendluamsg(actor, LuaMessageIdToClient.RES_GET_RECYCLING_TYPE, msgData)
end

-- 获取当前玩家回收设置信息
function ItemRecycling.getItemRecyclingType(actor)
    local itemRecoveryType = getplaydef(actor, ITEM_RECYCLING_TYPE)
    sendluamsg(actor, LuaMessageIdToClient.RES_GET_RECYCLING_TYPE, itemRecoveryType)
end

-- 自动回收道具
function ItemRecycling.autoRecycling(actor)
    local data = getplaydef(actor, ITEM_RECYCLING_TYPE) or {}
    local itemRecoveryType = data.subType or {}
    local groupIds = data.groupId or {}
    return ItemRecyclingFilter.getCanRecycleIndexs(actor, itemRecoveryType, groupIds)
end

---------------------------- 日志打印 -----------------------------
this.log_open = false
function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(...)
end

function this.jprint(param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(param)
end

function this.loginfo(actor, param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 日志输出内容为空. nil"
    end
    jprint(param)
    info(actor, param)
end

-- ====================================测试========================================
function testitemrecycling(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        ItemRecycling.autoRecycling(actor)
    end
end

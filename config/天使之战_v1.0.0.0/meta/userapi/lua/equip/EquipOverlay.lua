---
--- Created by zhouzhipeng.
--- DateTime: 2024/8/26 上午11:13
---

EquipOverlay = {}
local this = {}

--- 请求装备叠加
function EquipOverlay.reqEquipOverlay(actor, msgData)
    EquipOverlay.print("reqEquipOverlay actor:" .. actor:toString() .. "装备叠加开始：\n", msgData)
    local firstItemId = msgData["firstItemId"]
    local secondItemId = msgData["secondItemId"]
    local costItem = msgData["costItem"]
    local lockEntryIds = msgData["lockEntryIds"]

    local firstEquip = getequipinfo(actor, firstItemId, 1)
    if table.isNullOrEmpty(firstEquip) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT394)
        return
    end

    local secondEquip = getequipinfo(actor, secondItemId, 1)
    if table.isNullOrEmpty(secondEquip) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT395)
        return
    end

    local firstItemCfgId = firstEquip.cfgid
    if firstItemCfgId ~= secondEquip.cfgid then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT396)
        return
    end

    local firstEntries = firstEquip.entries
    local secondEntries = secondEquip.entries
    local firstCount = table.count(firstEntries)
    if firstCount == 0 or table.count(secondEntries) == 0 then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT397)
        return
    end

    -- 主装备词条 用于遍历
    local firstEntryIds = {}
    for _, v in pairs(firstEntries) do
        table.insert(firstEntryIds, v.entryid)
    end

    -- 副装备中需要有与主装备不同词条才能进行叠加
    -- 主装备未拥有的词条
    local entryTable = {}
    for _, v in pairs(secondEntries) do
        if not table.contains(firstEntryIds, v.entryid) then
            table.insert(entryTable, v)
        end
    end
    if table.isNullOrEmpty(entryTable) then
        EquipOverlay.print("reqEquipOverlay actor:" .. actor:toString() .. "副装备的词条主装备都已拥有：\n", "主装备词条", firstEntries, "副装备词条", secondEntries, "主词条", firstEntryIds, "主装备未拥有的词条", entryTable)
        noticeTip.noticeinfo(actor, StringIdConst.TEXT398)
        return
    end

    local overlayList = ConfigDataManager.getTable("cfg_equip_overlay", "id", firstItemCfgId)
    if table.isNullOrEmpty(overlayList) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT399)
        return
    end
    local grade = firstEquip.grade
    local maxEntry = ConfigDataManager.getTableValue("cfg_equip_quality", "maximums", "id", grade)
    if string.isNullOrEmpty(maxEntry) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT400)
        return
    end
    local lockEntryCount = table.count(lockEntryIds)
    if lockEntryCount >= tonumber(maxEntry) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT401)
        return
    end

    local overlayCfg = overlayList[1]
    EquipOverlay.print("reqEquipOverlay actor:" .. actor:toString() .. "装备叠加cfg_equip_overlay表配置：\n", overlayCfg)
    -- 校验消耗  cost
    local cost = overlayCfg.cost
    local costTable = string.toIntIntMap(cost, "#", "|")
    if table.isNullOrEmpty(costTable) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT402)
        return
    end
    for k, v in pairs(costTable) do
        local itemId = tonumber(k)
        local count = tonumber(v)
        if this.checkCost(actor, itemId, count) then
            return
        end
    end

    -- 计算额外成功率
    local costItemCfg = overlayCfg.costitem
    local costItemTable = string.toIntIntMap(costItemCfg, "#", "|")
    if table.count(costItem) > 0 then
        for _, value in pairs(costItem) do
            local itemCfgId = value.itemCfgId
            local count = value.count
            for k, _ in pairs(costItemTable) do
                if itemCfgId ~= tonumber(k) then
                    --EquipOverlay.print("reqEquipOverlay actor:" .. actor:toString() .. ",itemCfgId：" .. type(itemCfgId) .. itemCfgId .. ",count:" .. count .. ",配置表的itemCfgId:" .. type(k) .. k .. ",配置表的count:" .. type(count) .. count .. ",装备叠加cfg_equip_overlay表配置：\n", costItemTable)
                    noticeTip.noticeinfo(actor, StringIdConst.TEXT403)
                    return
                end
            end
            if this.checkCost(actor, itemCfgId, count) then
                return
            end
        end
    end

    -- 校验锁定词条消耗
    if lockEntryCount > 0 then
        local lockCost = overlayCfg.lockcost
        local lockCostShuXian = string.split(lockCost, "|")
        if table.count(lockCostShuXian) < lockEntryCount then
            noticeTip.noticeinfo(actor, StringIdConst.TEXT404)
            return
        end
        local value = lockCostShuXian[lockEntryCount]
        local lockCostJinHao = string.split(value, "#")
        local itemId = tonumber(lockCostJinHao[1])
        local count = tonumber(lockCostJinHao[2])
        if this.checkCost(actor, itemId, count) then
            return
        end
    end
    -- 扣除消耗
    for itemCfgId, count in pairs(costTable) do
        removeitemfrombag(actor, itemCfgId, count,0,9999,'装备叠加')
    end

    -- 额外成功率
    local extraRate = 0
    for _, value in pairs(costItem) do
        local itemCfgId = value.itemCfgId
        local count = value.count
        local rate = costItemTable[tonumber(itemCfgId)]
        --EquipOverlay.print("reqEquipOverlay actor:" .. actor:toString() .. ",itemCfgId：" .. type(itemCfgId) .. itemCfgId .. ",count:" .. count .. ",rate:" .. tostring(rate) .. ",装备叠加cfg_equip_overlay表配置：\n", costItemTable)
        local addRate = rate * count
        extraRate = extraRate + addRate
        removeitemfrombag(actor, itemCfgId, count,0,9999,'装备叠加')
    end

    if lockEntryCount > 0 then
        local lockCost = overlayCfg.lockcost
        local lockCostShuXian = string.split(lockCost, "|")
        -- local lockCostTable = strtomap(lockCost, "#", "|")
        local value = lockCostShuXian[lockEntryCount]
        local lockCostJinHao = string.split(value, "#")
        local itemId = tonumber(lockCostJinHao[1])
        local count = tonumber(lockCostJinHao[2])
        removeitemfrombag(actor, itemId, count, 0, 9999, '装备叠加')
    end

    -- 销毁副装备
    local equipindex = secondEquip.equipindex
    if equipindex ~= 0 then
        -- todo 脱装要触发属性计算
        -- 脱装  传穿戴拦索引
        takeofftheequip(actor, equipindex)
        -- 根据唯一id找背包索引
        local bagIdx = gainbagidxbyitemid(actor, secondEquip.id)
        -- 通过背包索引删除该道具
        removeitembyidxlist(actor, { bagIdx },9999,'装备叠加')
        EquipOverlay.print("reqEquipOverlay actor:" .. actor:toString() .. "装备叠加 从穿戴拦装备删除：\n")

    else
        -- 通过背包索引删除该道具
        local bagIdx = gainbagidxbyitemid(actor, secondEquip.id)
        removeitembyidxlist(actor, { bagIdx },9999,'装备叠加')
        EquipOverlay.print("reqEquipOverlay actor:" .. actor:toString() .. "装备叠加 从背包删除：\n")

    end

    -- 叠加成功率成功率
    local minRate = tonumber(overlayCfg.minrate)
    local maxRate = tonumber(overlayCfg.maxrate)
    local rate = math.min(minRate + extraRate, maxRate)
    local randomNumber = math.random(1, 10000)
    if rate < randomNumber then
        -- 失败
        tipinfo(actor, "叠加失败")
        sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_OVERLAY, { result = 0 })
        if not firstEquip.isbind then
            changeitembindstate(actor,firstItemId,1)
            local res = {itemId = firstItemId,bindId = true}
            sendluamsg(actor,LuaMessageIdToClient.RES_EQUIP_BIND_DATA_CHANGE,res)
        end
        return
    end
    -- 成功  进行叠加
    -- 随机副装备差异词条
    local entry = table.count(entryTable)
    local number = math.random(1, entry)
    local newEntry = entryTable[number]

    local currEntrys = {}
    local newRate = overlayCfg.rate
    local newEntryRate = 0
    if table.count(firstEntryIds) < tonumber(maxEntry) then
        -- 主装备存在空词条位，从消耗装备的卓越属性中和主装备词条不同的随机一条卓越属性，填充至主装备的空词条
        -- 新增词条概率
        newEntryRate = math.random(1, 10000)
        if tonumber(newRate) < newEntryRate then
            -- 替换词条  重置词条
            this.resetEntry(actor, firstEquip.id, firstEntries, lockEntryIds, newEntry, currEntrys)
        else
            -- 添加词条
            addequipentry(actor, firstEquip.id, newEntry)
            for _, entryInfo in ipairs(firstEntries) do
                this.buildEntry(currEntrys, entryInfo)
            end
            this.buildEntry(currEntrys, newEntry)
        end
    else
        -- 主装备不存在空词条位，从消耗装备的卓越属性中和主装备词条不同的随机一条卓越属性，随机替换主词条的一条未锁定的词条
        -- 重置词条
        this.resetEntry(actor, firstEquip.id, firstEntries, lockEntryIds, newEntry, currEntrys)
        --local max = firstCount - lockEntryCount
        --local number = math.random(1, max)
        --
        --local entrys = {}
        --local num = 1
        --for i, entry in ipairs(firstEntries) do
        --    if table.contains(lockEntryIds, entry.entryid) then
        --        table.insert(entrys, entry)
        --    else
        --        if num == number then
        --            table.insert(entrys, newEntry)
        --        else
        --            table.insert(entrys, entry)
        --        end
        --        num = num + 1
        --    end
        --end
        --for _, entry in ipairs(entrys) do
        --    this.buildEntry(currEntrys, entry)
        --end
        --resetequipentry(actor, firstEquip.id, entrys)
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_OVERLAY, { result = 1, firstEntries = currEntrys })
    EquipOverlay.print("reqEquipOverlay actor:" .. actor:toString() .. "装备叠加结束信息：\n", "主装备词条数据：", firstEntries, "副装备词条数据：", secondEntries, "主装备未拥有的词条："
    , entryTable, "主装备拥有的词条", firstEntryIds, "额外成功率：", extraRate, "总成功率", tostring(rate), "成功率随机结果：", randomNumber, "随机到的未拥有的第几条", number
    , "主装备最大配置词条", maxEntry, "当前词条数据：", currEntrys, "，新增词条概率：", newRate, "，新增词条随机结果（为0未词条没有空位）：",newEntryRate)
    ---更新最大词条记录
    EquipAndAppear.TryUpdateEquipInfoRecorde(actor, EquipAndAppear.RecordeType.MAX_ENTRY_COUNT)
    if not firstEquip.isbind then
        changeitembindstate(actor,firstItemId,1)
        local res = {itemId = firstItemId,bindId = true}
        sendluamsg(actor,LuaMessageIdToClient.RES_EQUIP_BIND_DATA_CHANGE,res)
    end
    -- 更新任务进度
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_SUPERPOSITION, firstItemCfgId)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType. EXCELLENCE_ATTR)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_EXCELLENCE_ATTR_COUNT)
end

function this.buildEntry(currEntrys, entry)
    local entry1 = {}
    entry1.entryId = entry.entryid
    entry1.type = entry.attrid
    entry1.num = entry.value
    table.insert(currEntrys, entry1)
end

function this.checkCost(actor, itemId, count)
    local bagCount = getbagitemcountbyid(actor, itemId)
    if bagCount < count then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT253)
        return true
    end
    return false
end

function this.resetEntry(actor, firstEquipId, firstEntries, lockEntryIds, newEntry, currEntrys)
    local firstCount = table.count(firstEntries)
    local lockEntryCount = table.count(lockEntryIds)
    local max = firstCount - lockEntryCount
    local number = math.random(1, max)

    local entrys = {}
    local num = 1
    for i, entry in ipairs(firstEntries) do
        if table.contains(lockEntryIds, entry.entryid) then
            table.insert(entrys, entry)
        else
            if num == number then
                table.insert(entrys, newEntry)
            else
                table.insert(entrys, entry)
            end
            num = num + 1
        end
    end
    for _, entry in ipairs(entrys) do
        this.buildEntry(currEntrys, entry)
    end
    resetequipentry(actor, firstEquipId, entrys)
end


-----------------------------------------------------------测试方法-------------------------------------------------------------

--- 打印日志
function EquipOverlay.print(...)
    local isPrintLog = true
    if isPrintLog then
        return
    end
    jprint(...)
end


--- 测试方法
function equipoverlaytest(actor)
    jprint("equipoverlaytest actor:" ..actor:toString() .. ", equipoverlaytest 开始")
    local bebaoshuju = getallequipinfo(actor)
    sendluamsg(actor, 999999, { bebaoshuju = bebaoshuju })
    --local overlayList1 = ConfigDataManager.getTable("cfg_equip_overlay", "id", 99)
    --jprint(overlayList1)
    --if string.isNullOrEmpty(overlayList1) then
    --    jprint(tostring(overlayList1))
    --    jprint("nil")
    --end
    --local overlayList2 = ConfigDataManager.getTable("cfg_equip_overlay", "id", 20100003)
    --jprint(overlayList2)
    --print("hello")
    --jprint(getputonequipinfo(actor))

    jprint("equipoverlaytest actor:" .. actor:toString() .. ", equipoverlaytest 结束 ")

end
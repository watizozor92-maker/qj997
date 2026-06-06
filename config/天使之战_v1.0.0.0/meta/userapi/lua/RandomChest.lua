--- 宝箱读表随机生成道具
RandomChest = {}

local this = {}

chestReward = "T$chestReward"


-- 宝箱掉落的道具
BoxDropItem = {}
function BoxDropItem.new(itemId, itemCfgId, count, luaExtData)
    local instance = {}
    instance.id = itemId
    instance.cfgId = itemCfgId
    instance.count = count
    instance.luaExtData = luaExtData
    instance.fromBox = luaExtData.fromBox
    instance.dropId = luaExtData.dropId
    instance.timeStamp = luaExtData.timeStamp
    return instance
end

-- 玩家宝箱掉落物品记录（用于补发）
PlayerBoxDropRecord = {}
PlayerBoxDropRecord.__index = PlayerBoxDropRecord

function PlayerBoxDropRecord.new()
    local self = setmetatable({}, PlayerBoxDropRecord)
    self.records = {}
    return self
end

function PlayerBoxDropRecord.get(actor)
    local data = getplaydef(actor, "T$_player_box_drop_record") or {}
    local instance = PlayerBoxDropRecord.new()
    instance.records = data.records or {}
    return instance
end

function PlayerBoxDropRecord:save(actor)
    setplaydef(actor, "T$_player_box_drop_record", {
        records = self.records,
    })
end

function PlayerBoxDropRecord:clear()
    self.records = {}
end


function PlayerBoxDropRecord:addDropRecord(boxDropItem)
    table.insert(self.records, boxDropItem)
end

function PlayerBoxDropRecord:removeDropRecord(index)
    table.remove(self.records, index)
end

function PlayerBoxDropRecord:removeDropItem(itemId, dropId)
    for i = #self.records, 1, -1 do
        local boxDropItem = self.records[i]
        if boxDropItem.id == itemId and boxDropItem.dropId == dropId then
            table.remove(self.records, i)
        end
    end
end

function PlayerBoxDropRecord:getRecords()
    return self.records
end



--- 使用宝箱生成道具
---@param actor any 玩家对象
---@param itemConfigId number 道具配置ID
---@param count number 数量
function RandomChest.generateChestItem(actor, itemConfigId, count)
    local itemRow = ConfigDataManager.getTableFirst("cfg_item", "id", itemConfigId)
    if table.isNullOrEmpty(itemRow) then
        gameDebug.print("RandomChest.generateChestItem itemConfigId error")
        return
    end
    local boxConfigName = itemRow.useparam
    local allItem = {}
    local rewardList = {}
    if tonumber(itemRow.type) == ItemType.BOX and tonumber(itemRow.subtype) == ItemSubType.EQUIP_BOX then
        local rewardRecord = getplaydef(actor, chestReward)
        for i = 1, count do
            local res = this.getItemAndCount(actor, itemRow.useparam, rewardRecord)
            if table.isNullOrEmpty(res) then
                gameDebug.print("RandomChest.generateChestItem getItemAndCount res is nil")
            else
                for itemId, itemCount in pairs(res) do
                    itemId = tonumber(itemId)
                    itemCount = tonumber(itemCount)
                    if table.isNullOrEmpty(rewardRecord) then
                        rewardRecord = {}
                        rewardRecord[itemId] = 1
                    else
                        if rewardRecord[itemId] then
                            rewardRecord[itemId] = rewardRecord[itemId] + 1
                        else
                            rewardRecord[itemId] = 1
                        end
                    end
                    table.mergeAdd(allItem, { [itemId] = itemCount })
                end
                table.insert(rewardList,res)
            end
        end
        setplaydef(actor, chestReward, rewardRecord)
       
    end

    if table.count(allItem) > 0 then
        local openType = string.tonumber(itemRow.useparam2)
        if openType == 1 then
            -- 1走掉落
            this.dropItemFromBox(actor, tonumber(itemRow.id), boxConfigName, rewardList)
            info(actor:toString() .. "玩家开启掉落宝箱，掉落道具为：" .. table.toString(allItem))
        else
            local genericIds = Bag.sendRewards(actor, allItem, ItemActionProxy.RANDOMCHEST)
            for i, id in pairs(genericIds) do
               local itemInfo = getbagiteminfo(actor, id, 1)
                if this.isHorseLamp(itemInfo.cfgid) then
                    local getItem = ItemFactory.build(itemInfo)
                    local costItem = {cfgId = tonumber(itemRow.id)}
                    local tipItems = {}
                    table.insert(tipItems, costItem)
                    table.insert(tipItems, getItem)
                    this.excHorseLamp(actor, tipItems, itemRow)
                end
            end
        end
    end
end

--玩家对象，道具列表{{},{}..}
function this.dropItemFromBox(actor, boxCfgId, boxConfigName, rewardList)
    local dropId = createid(IdType.BOX_DROP)
    local x = getbaseinfo(actor, "x")
    local y = getbaseinfo(actor, "y")
    local mapId = getbaseinfo(actor, "unimapid")
    local timeStamp = getbaseinfo(actor, "nowsec")
    for _, partItems in pairs(rewardList) do
        for itemId, itemCount in pairs(partItems) do
            local itemConfig = ConfigDataManager.getTableFirst("cfg_item", "id", itemId)
            local notEnterPack = itemConfig["notenterpack"]
            local overlying = itemConfig["overlying"]

            local itemType = tonumber(itemConfig.type)
            local luxExtData = { fromBox = true, dropId = dropId, timeStamp = timeStamp, boxCfgId = boxCfgId }
            if itemType == ItemType.EQUIP then
                local equipExtData = Equip_PuTong.randomBoxQzEquipAtt(itemId, boxConfigName)
                --info(actor, "玩家", actor, "触发掉落随机相关 随机宝箱 cfgId：", itemId ,"内容：", equipExtData)
                table.merge(luxExtData, equipExtData)
            end

            if (string.isNullOrEmpty(notEnterPack) or tonumber(notEnterPack) == 0)
                and (string.isNullOrEmpty(overlying) or tonumber(overlying) <= 1) and (itemType ~= ItemType.COIN) then
                for i = 1, itemCount do
                    throwitem(actor, mapId, x, y, 0, itemId, 1, 1000000, 3, 0, {}, "random_box_drop_items_after", luxExtData)
                end
            else
                throwitem(actor, mapId, x, y, 0, itemId, itemCount, 1000000, 3, 0, {}, "random_box_drop_items_after", luxExtData)
            end
        end
    end
end




-- 事件：随机宝箱掉落道具后
function random_box_drop_items_after(actor, itemList)
    local playerRecord = PlayerBoxDropRecord.get(actor)
    for _, itemInfo in pairs(itemList) do
        local luaextdata = itemInfo.iteminfo.luaextdata or {}
        local boxCfgId = luaextdata.boxCfgId or 0
        local boxItem = ConfigDataManager.getById("cfg_item", boxCfgId)
        if boxCfgId > 0 and not table.isEmpty(boxItem) then
            if this.isHorseLamp(itemInfo.iteminfo.cfgid) then
                local getItem = ItemFactory.build(itemInfo.iteminfo or {})
                local costItem = {cfgId = boxCfgId}
                local tipItems = {}
                table.insert(tipItems, costItem)
                table.insert(tipItems, getItem)
                this.excHorseLamp(actor, tipItems, boxItem)
            end
        end
        local boxDropItem = BoxDropItem.new(itemInfo.iteminfo.id, itemInfo.iteminfo.cfgid, itemInfo.iteminfo.count, itemInfo.iteminfo.luaextdata)
        playerRecord:addDropRecord(boxDropItem)
    end
    playerRecord:save(actor)
end


function this.excHorseLamp(actor, tipItems, boxItem)
    if table.isNullOrEmpty(tipItems) then
        return
    end
    local item = ConfigDataManager.getById("cfg_item", tipItems[2].cfgId)
    local noticeId = item.runninghorselamp
    if not string.isNullOrEmpty(noticeId) then
        local name = getbaseinfo(actor, "rolename")
        noticeTip.noticeinfo0(actor, noticeId, tipItems, name)
    end
    --local noticeId = boxItem.runninghorselamp
    --if #noticeId > 0 then
    --    local name = getbaseinfo(actor, "rolename")
    --    local item = ConfigDataManager.getById("cfg_item", tipItems[2].cfgId)
    --    local boxItemName = boxItem.name
    --    local itemName = item.name
    --    if not table.isNullOrEmpty(item) then
    --        local type = tonumber(item.type)
    --        -- 暂时按同样格式处理材料和装备
    --        if type == ItemType.MATERIAL then
    --            noticeTip.noticeinfo(actor, noticeId, name, boxItemName, itemName)
    --            noticeTip.noticeinfo0(actor, StringIdConst.TEXT4891, tipItems, name)
    --        elseif type == ItemType.EQUIP then
    --            noticeTip.noticeinfo(actor, noticeId, name, boxItemName, itemName)
    --            noticeTip.noticeinfo0(actor, StringIdConst.TEXT4891, tipItems, name)
    --        end
    --    end
    --end
end

--- 获取随机生成的道具数量
---@param actor any 玩家对象
---@param tableName string 配置表名
function this.getItemAndCount(actor, tableName,rewardRecord)
    local res = {}
    local boxConfig = ConfigDataManager.getList(tableName)
    if table.isNullOrEmpty(boxConfig) then
        gameDebug.print("RandomChest.generateChestItem useParam error")
        return res
    end
    local idMap = {}

    -- 职业限制判断
    local playerCareer = tonumber(getbaseinfo(actor, "getbasecareer"))
    -- 等级限制判断
    local playerLevel = getbaseinfo(actor, "level")

    for _, config in pairs(boxConfig) do
        if config.career ~= "" and tonumber(playerCareer) ~= tonumber(string.split(config.career, "#")[1]) then
            goto tag
        end
        local lv_split = string.split(config.level, "#")
        if config.level ~= "" and
                (tonumber(playerLevel) < tonumber(lv_split[1])
                        or tonumber(playerLevel) > tonumber(lv_split[2])) then
            goto tag
        end
        local id = config.id
        local item = config.item
        local probability = string.split(config.probability, "|")
        local pro1 = string.split(probability[1], "#")
        if tonumber(config.type) == 1 then
            if not rewardRecord or not rewardRecord[item] then
                idMap[id] = pro1[2]
            else
                for _, v in pairs(probability) do
                    local strs = string.split(v, "#")
                    idMap[id] = tonumber(strs[1]) <= tonumber(rewardRecord[item]) and strs[2] or pro1[2]
                end
            end
        else
            local weight = pro1[2]
            if rewardRecord and rewardRecord[item] then
                for _, v in pairs(probability) do
                    local v_split = string.split(v, "#")
                    if tonumber(v_split[1]) ~= 0 then
                        weight = v_split[1] >= rewardRecord[item] and v_split[2] or pro1[2]
                    end
                end
            end
            if tonumber(randomex(actor, weight, 10000)) == 1 then
                local num_split = string.split(config.num, "#")
                res[item] = math.random(num_split[1], num_split[2])
            end
        end
        :: tag ::
    end
    if table.isNullOrEmpty(idMap) then
        gameDebug.print("RandomChest.generateChestItem itemMap is nil")
        return res
    end
    if tonumber(boxConfig[1].type) == 1 then
        local id = randombyweight(actor, idMap, 1)[1]
        local num = ConfigDataManager.getTableValue(tableName, "num", "id", id)
        local itemId = ConfigDataManager.getTableValue(tableName, "item", "id", id)
        local num_split = string.split(num, "#")
        res[itemId] = math.random(num_split[1], num_split[2])
        return res
    else
        return res
    end
end


function RandomChest.checkBoxDrop(actor)
    local playerBoxDropRecord = PlayerBoxDropRecord.get(actor)
    local records = playerBoxDropRecord:getRecords()
    if #records <= 0 then
        return
    end
    local currentTime = getbaseinfo(actor, "nowsec")
    local sec = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 600001))
    local items = {}
    for i = #records, 1, -1 do
        local item = records[i]
        if currentTime - item.timeStamp >= sec then
            -- 从记录中移除已补发的项
            table.remove(records, i)
            table.insert(items, { cfgid = item.cfgId, count = item.count, luaextdata = item.luaExtData })
        end
    end

    if next(items) then
        -- 保存更新后的记录
        playerBoxDropRecord:save(actor)
        -- 发送邮件逻辑
        sendconfigmailbyrid(actor, getbaseinfo(actor, "rid"), MailConfig.BOX_DROP_RESEND, items)
        info("宝箱道具未拾取,补发邮件给玩家: " .. getbaseinfo(actor, "rolename") .. ", 道具: " .. table.toString(items, true))
    end

end

--- 检测获取的道具是否要执行跑马灯逻辑
---@param cfgId number 道具配置ID
---@return boolean 是否执行跑马灯逻辑
function this.isHorseLamp(cfgId)
    local tableInfo = ConfigDataManager.getById("cfg_item", cfgId)
    if table.isNullOrEmpty(tableInfo) then
        return false
    end
    return not string.isNullOrEmpty(tableInfo.runninghorselamp)
end

function test_clear_box_drop(actor)
    local data = PlayerBoxDropRecord.get(actor)
    data:clear()
    data:save(actor)
end

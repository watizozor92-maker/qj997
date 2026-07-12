---@class GoodsData
---@field number number @上架数量
---@field capacity number @总容量
---@field allgoods


---@class KLTradeSalesPanel:UIKmlLuaPanelBase
---@field view KLTradeSalesPanelView
---@field itemPanelList KLTradeSalesItem[]
local KLTradeSalesPanel = class(UIKmlLuaPanelBase)
local this = KLTradeSalesPanel
---创建时调用一次
function this:Init()
    self.itemPanelList = {}
    self.capacity = 0
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_MY_SHELVES, self.RES_TRADE_MY_SHELVES, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_LISTING_GOODS, self.RES_TRADE_LISTING_GOODS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_OFF_GOODS, self.RES_TRADE_OFF_GOODS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_STALL_INFO, self.RES_STALL_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.RefreshBag, self)
    GUI:AddOnClickEvent(self.view.StallButton, self, self.StallButtonOnclick)
    GUI:AddOnClickEvent(self.view.stall_btn_chat, self, self.stall_btn_chat_OnClick)
    GUI:AddOnClickEvent(self.view.stall_btn_walk, self, self.stall_btn_walk_OnClick)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.bagItem then
        GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeBag/KLTradeBagPanel", self.view.root, _, {
            --itemList = self:ShowItem(),
            --id = EBagShowType.EquipAdd,
            --forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT"),
            --hor = self.maxHor,
            --vet = self.maxVet,
            canDrag = false,
            --forbidClickCallback = self.forbidClick,
            itemClick = self.ClickItem,
            callBackUI = self,
            itemList = self:ShowItem(),
            x = 372,
            y = -20
        }, false, function(bagItem)
            self.bagItem = bagItem
            self:RefreshUI()
        end)
    else
        self:RefreshUI()
    end
end

function this:RefreshUI()
    for _, v in pairs(self.itemPanelList) do
        v:Remove()
    end

    local taxRate =  PrivilegeCardManager:GetTaxRate() or 0
    GUI:Text_setText(self.view.taxRate, "交易税:".. tostring(taxRate).. "%")
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_MY_SHELVES)
    if self.bagItem then
        self.bagItem:RefreshItem(self:ShowItem())
    end
end

function this:RefreshBag()
    self.bagItem:RefreshItem(self:ShowItem())
end

---@param message GoodsData
function this:RES_TRADE_MY_SHELVES(_, message)
    self.message = message
    local capacity = message.capacity or SL:GetConfig("cfg_global", 8001, "id").value
    local allCapacity = capacity
    if capacity < table.count(message.allgoods) then
        capacity = table.count(message.allgoods)
    end
    if table.count(message.allgoods) <= 0 then
        GUI:Text_setString(self.view.TradeSales_title,
                "寄售的货架 " .. tostring(table.count(message.allgoods)) .. "/" .. tostring(allCapacity))
    else
        GUI:Text_setString(self.view.TradeSales_title,
                "寄售的货架 " .. SL:GetColorText(tostring(table.count(message.allgoods)) ,"#00ff00") .. "/" .. tostring(allCapacity))
    end

    --self.isCapacity = table.count(message.allgoods) < capacity and true or false
    self:CreateItem(capacity)
    self:ShowGoodsInfo(message.allgoods)
end

function this:RES_TRADE_OFF_GOODS(_, message)
    if message then
        self:RefreshUI()
    end
end

function this:RES_TRADE_LISTING_GOODS(_, message)
    if message then
        self:RefreshUI()
    end
end

function this:ShowItem()
    local data = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]
    if bagItemTabl then
        for i, v in pairs(bagItemTabl) do
            if not EquipFunc.GetItemIsBind(nil,v) and SL:HasConfigTwoKeys("cfg_stall", v.cfgId, 4, "id", "way") then
                table.insert(data, v)
            end
        end
    end
    ---月卡或者日卡生效
    if SL:HasConfigTwoKeys("cfg_stall", EMonthType.MonthCardTime, 4, "id", "way") and InfoManager.monthCardInfo.MonthCardTimeTotal > (SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME) + 86400000) then
        ---月卡时间特殊处理
        if InfoManager.monthCardInfo.IsGetDailyCard or InfoManager.monthCardInfo.IsGetMonthCard then
            local MonthTimeData = {
                bind = false,
                id = EMonthType.MonthCardTime,
                cfgId = EMonthType.MonthCardTime,
                count = 1,
                endTime = 0,
                itemExtInfo = nil,
                gmExtInfo = nil,
                correctId = 0,
                luaExtData = ""
            }
            table.insert(data, MonthTimeData)
        end
    end
    --货币特殊处理
    for _, id in pairs(MUEResourceType) do
        if SL:HasConfigTwoKeys("cfg_stall", id, 4, "id", "way") then
            local coinCount = SL:GetMetaValue(EMetaVarGetKey.MONEY, id)
            if coinCount > 0 then
                local coinData = {
                    cfgId = id,
                    count = coinCount,
                    itemExtInfo = nil,
                    luaExtData = ""
                }
                table.insert(data, coinData)
            end
        end
    end

    --货币特殊处理
    for _, id in pairs(ETradeCoinType) do
        if SL:HasConfigTwoKeys("cfg_stall", id, 4, "id", "way") then
            local coinCount = SL:GetBagItemCount(id, false)
            if coinCount > 0 then
                local coinData = {
                    cfgId = id,
                    count = coinCount,
                    itemExtInfo = nil,
                    luaExtData = ""
                }
                table.insert(data, coinData)
            end
        end
    end

    return self:SortItemList(data)
end

function this:CreateItem(capacity)
    for i = table.count(self.itemPanelList), capacity - 1 do
        ---@type KLTradeSalesItem
        local item = GUI:UIPanel_Open("dev/outui/Trade/Item/KLTradeSales/KLTradeSalesItem", self.view.sales_grid, self,
            nil, true)
        table.insert(self.itemPanelList, item)
    end
    
end

---@param data Allgoods[]
function this:ShowGoodsInfo(data)
    if not data then
        return
    end
    local now = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    for i, v in pairs(data) do
        if not self.itemPanelList[tonumber(i)] then
            return
        end
        InfoManager.faceTradeInfo.SetTradeTime(v, now)
        if not self.itemPanelList[tonumber(i)]:IsGoods() then
            self.itemPanelList[tonumber(i)]:UpdateUI(v)
        end
    end
end

function this:ClickItem(itemControl, itemData)
    local itemInfo = SL:GetItemInfoByItemId(itemData.id)
    local cfgMinCount = SL:GetConfig("cfg_stall", itemData.cfgId, "id").minNumber
    local bagCount = SL:GetBagItemCount(itemData.cfgId)
    if bagCount < cfgMinCount then
        SL:MessageTip({id = 35001})
        return
    end

    SL:OpenTips("nil", itemData.cfgId, itemData.id, nil, itemInfo,{posX=57,hideBtn = true}, false, function()
        GUI:UIPanel_Open("dev/outui/Trade/Panel/KLSalesTips/KLSalesTipsPanel", nil, nil,
                { cfgId = itemData.cfgId, id = itemData.id, index = SL:GetBagIndex(itemData.id), capacity = self.isCapacity, IsNeedOffsetXPos = 0,count = itemData.count })
    end)
end

function this:Tick()

end

function this:Close()
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeBag/KLTradeBagPanel")
    for i, v in pairs(self.itemPanelList) do
        GUI:UIPanel_Close(nil,v)
    end
end

---@param itemList CommonProtos.Item[]
---@return CommonProtos.Item[]
function this:SortItemList(itemList)
    local bag_str = SL:GetConfig("cfg_global", 6).value
    local bag_tbl = string.split(bag_str, '#')
    local bag_hor = tonumber(bag_tbl[1])
    local bag_vet = tonumber(bag_tbl[2])
    local use_cell_dict = {}
    local sortItemList = {}
    local cfg_id, now_hor, now_vet, is_put, hold_vet, hole_hor, item, now_hold_hor, now_judge_hor, now_hold_vet, now_judge_vet, now_cell_index
    local max_hor = bag_hor + 20
    for _, v in pairs(itemList) do
        cfg_id = v.cfgId
        now_hor = 1
        while now_hor <= max_hor do
            now_vet = 1
            while now_vet <= bag_vet do
                is_put = true
                ---@type cfg_item_column
                item = SL:GetConfig("cfg_item", cfg_id)
                hold_vet = item.holdGrid[1]
                hole_hor = item.holdGrid[2]
                now_hold_hor = 0
                if item.id == MUEResourceType.MiracleCurrency then
                    hole_hor = 2
                    hold_vet = 2
                end
                if hole_hor == nil then
                    hole_hor = 1
                end
                if hold_vet == nil then
                    hold_vet = 1
                end
                while now_hold_hor < hole_hor do
                    now_judge_hor = now_hor + now_hold_hor
                    now_hold_vet = 0
                    while now_hold_vet < hold_vet do
                        now_judge_vet = now_vet + now_hold_vet
                        now_cell_index = now_judge_hor * 100 + now_judge_vet
                        if use_cell_dict[now_cell_index] or now_judge_vet > bag_vet then
                            is_put = false
                            break
                        end
                        now_hold_vet = now_hold_vet + 1
                    end
                    if not is_put then
                        break
                    end
                    now_hold_hor = now_hold_hor + 1
                end
                if is_put then
                    break
                end
                now_vet = now_vet + 1
            end
            if is_put then
                break
            end
            now_hor = now_hor + 1
        end

        local now_index = now_hor * 100 + now_vet
        sortItemList[now_index] = v

        now_hold_hor = 0
        while now_hold_hor < hole_hor do
            now_hold_vet = 0
            local now_hold_judge_hor = now_hor + now_hold_hor
            while now_hold_vet < hold_vet do
                local now_hold_judge_vet = now_vet + now_hold_vet
                now_cell_index = now_hold_judge_hor * 100 + now_hold_judge_vet
                use_cell_dict[now_cell_index] = true
                now_hold_vet = now_hold_vet + 1
            end
            now_hold_hor = now_hold_hor + 1
        end
    end
    return sortItemList
end

function this:StallButtonOnclick()
    if not InfoManager.monthCardInfo:IsHaveMonthCardRights("stall") then
        SL:TipMessage(SL:GetConfig('cfg_string', 278).text, 1, NoticeType.NoticeMid) --"开通月卡后可使用交易行功能",
        return
    end
    GUI:UIPanel_Open("dev/outui/Stall/Panel/KLOpenStall/KLOpenStallPanel")
end

function this:RES_STALL_INFO(_, message)
    if message.mapId then
        local endTime = message.endTime
        local current_time = Time.GetServerTime()
        current_time = math.floor(current_time / 1000)
        local last_time = endTime - current_time
        GUI:SetControl_time(self.view.stall_time, last_time)
        GUI:setVisible(self.view.StallView, true)
        GUI:setVisible(self.view.StallButton, false)
        self.stall_data = message
    else
        GUI:setVisible(self.view.StallView, false)
        GUI:setVisible(self.view.StallButton, true)
    end
end

function this:stall_btn_chat_OnClick()
    if not self.stall_data then
        return
    end
    GUI:UIPanel_Open("dev/outui/Stall/Panel/KLChatStall/KLChatStallPanel", nil, nil,
        { data = self.message, pos = self.stall_data })
end

function this:stall_btn_walk_OnClick()
    if not self.stall_data then
        return
    end
    local map_id = self.stall_data.mapId
    local serverType = SL:GetConfig("cfg_map_info", map_id, "id").serverType
    if serverType == 2 then
        if not self:CrossServerStall() then
            return
        end
        local mapId1 = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
        if mapId1 == self.stall_data.mapId then
            SL:Pathfinding(self.stall_data.mapId, self.stall_data.line, self.stall_data.pointX, self.stall_data.pointY,nil,nil,true)
        else
            SL.Scene:SetTransMapMoveToPointCallbackFunc(function()
                if not self.stall_data then
                    SL.Scene:SetTransMapMoveToPointCallbackFunc()
                    return
                end
                local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
                if mapId ~= self.stall_data.mapId then
                    SL.Scene:SetTransMapMoveToPointCallbackFunc()
                    return
                end
                SL:Pathfinding(self.stall_data.mapId, self.stall_data.line, self.stall_data.pointX,
                    self.stall_data.pointY,nil,nil,true)
            end)
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GOTO_CROSS_MAP, {})
        end
    else
        SL:Pathfinding(self.stall_data.mapId, self.stall_data.line, self.stall_data.pointX, self.stall_data.pointY,nil,nil,true)
    end

    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel")
    SL.ShowMainPanel()
end

function this:CrossServerStall()
    local cond, message = InfoManager.godsDescendInfo.CheckActivityConditionMapId(20001)
    if not cond then
        SL:TipMessage(message, 1, NoticeType.NoticeMid)
    end
    return cond
end

function this:IsHavePrivilege()
    if InfoManager.monthCardInfo.IsGetMonthCard or InfoManager.monthCardInfo.IsGetDailyCard then
        --有月卡或是日卡
        return true
    end
    return false
end

return this

---@class KLFaceTradePanel:UIKmlLuaPanelBase
---@field view KLFaceTradePanelView
---@field indexToItem KLBagItemItem[]
local KLFaceTradePanel = class(UIKmlLuaPanelBase)
local this =KLFaceTradePanel

---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    self.bagLoadItemSpeed = 0.1 --背包打开加载Item的速度
    self.bagItemIntervalTime = 0.15 --背包每加载3个Item的停顿时间

    local global = SL:GetConfig("cfg_global", 690004)
    local split = string.split(global.value, "#")
    self.gold1 = tonumber(split[1])
    self.gold2 = tonumber(split[2])

    self.maxTradeNum = tonumber(SL:GetConfig("cfg_global", 690006).value)
end

local TradeState = {
    IDLE = 0, --空闲
    INVITING = 1, --邀请中
    TRADING = 2, --交易中
    LOCKED = 3, --已锁定
    CONFIRMED = 4 --已确认
}

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.btn_closeMe, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.btn_lock, self, self.LockSelf)
    GUI:AddOnClickEvent(self.view.btn_confirm, self, self.Confirm)
    GUI:Input_SetOnEndEdit(self.view.input_meGold1, self, self.MeGold1EndEdit)
    GUI:Input_SetOnEndEdit(self.view.input_meGold2, self, self.MeGold2EndEdit)
    GUI:AddOnClickEvent(self.view.btn_targetGold1, self, self.ShowGold1Tips)
    GUI:AddOnClickEvent(self.view.btn_targetGold2, self, self.ShowGold2Tips)
    GUI:AddOnClickEvent(self.view.btn_ownGold1, self, self.ShowGold1Tips)
    GUI:AddOnClickEvent(self.view.btn_ownGold2, self, self.ShowGold2Tips)
    GUI:AddOnClickEvent(self.view.btn_meGold1, self, self.ShowGold1Tips)
    GUI:AddOnClickEvent(self.view.btn_meGold2, self, self.ShowGold2Tips)
    GUI:AddOnClickEvent(self.view.btn_tips, self, self.TipsOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.LUA_EVENT_MONEYCHANGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_FACE_TRADE_UPDATE, self.RES_FACE_TRADE_UPDATE, self)
end

function this:CloseSelf()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_CANCEL)
    GUI:UIPanel_Close(self.filePath)
end
--锁定自己
function this:LockSelf()
    if self.meState == TradeState.CONFIRMED then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_TOGGLE_LOCK)
end
--点击确认交易
function this:Confirm()
    if self.meState < TradeState.LOCKED then
        SL:TipMessage("请先锁定交易栏", 1, NoticeType.NoticeMid)
        return
    end
    if self.targetState < TradeState.LOCKED then
        SL:TipMessage("等待对方锁定交易栏", 1, NoticeType.NoticeMid) 
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_TOGGLE_CONFIRM)
end
---金币1输入变化
function this:MeGold1EndEdit(a, b, data)
    local num = tonumber(data[1]) 
    if data[1] and num ~= nil then
        local own = SL:GetTotalCoinBaseId(self.gold1, false)
        if num > own then
            num = own
            GUI:SetInputText(self.view.input_meGold1, tostring(num))
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_ADD_CURRENCY, 
            {currencyId = self.gold1, amount = num})
    else
        GUI:SetInputText(self.view.input_meGold1, "0")
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_ADD_CURRENCY, 
            {currencyId = self.gold1, amount = 0})
    end
end
---金币2输入变化
function this:MeGold2EndEdit(a, b, data)
    local num = tonumber(data[1]) 
    if data[1] and num ~= nil then
        local own = SL:GetTotalCoinBaseId(self.gold2, false)
        if num > own then
            num = own
            GUI:SetInputText(self.view.input_meGold2, tostring(num))
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_ADD_CURRENCY, 
            {currencyId = self.gold2, amount = num})
    else
        GUI:SetInputText(self.view.input_meGold2, "0")
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_ADD_CURRENCY, 
            {currencyId = self.gold2, amount = 0})
    end
end
---货币1tips
function this:ShowGold1Tips()
    SL:OpenTips("", self.gold1)
end
---货币2tips
function this:ShowGold2Tips()
    SL:OpenTips("", self.gold2)
end
function this:TipsOnClick()
    local ruleCfg = SL:GetConfig("cfg_rule_text", 33001) 
    if ruleCfg then
        SL:CommonStrTipsMessage({title =ruleCfg.menutxt,str=ruleCfg.location})
    end
end
---货币显示
function this:LUA_EVENT_MONEYCHANGE()
    GUI:Text_setString(self.view.txt_ownGold1, tostring(SL:GetTotalCoinBaseId(self.gold1, false)))
    GUI:Text_setString(self.view.txt_ownGold2, tostring(SL:GetTotalCoinBaseId(self.gold2, false)))
end
---交易栏更新
function this:RES_FACE_TRADE_UPDATE(_, message)
    local tempList = {}
    for _, v in pairs(message.myItems) do
        --我的交易栏新增
        tempList[v.id] = 1
        if not self.selectList[v.id] then
            self:CreateTradeItem(v, true) 
        end
    end
    for itemid, v in pairs(self.selectList) do
        --我的交易栏移除
        if not tempList[itemid] then
            self:RemoveTradeItem(itemid, true)
        end
    end
    --我的状态更新
    self.meState = message.myState
    if message.myState == TradeState.LOCKED then
        GUI:setVisible(self.view.mask_me, true)
        GUI:Text_setString(self.view.txt_myState, "已锁定")
    elseif message.myState == TradeState.CONFIRMED then
        GUI:setVisible(self.view.mask_me, true)
        GUI:Text_setString(self.view.txt_myState, "已确认")
    else
        GUI:setVisible(self.view.mask_me, false)
    end
    for _, v in pairs(message.myCurrency) do
        --我的货币更新
        if v.cfgId == self.gold1 then
            GUI:SetInputText(self.view.input_meGold1, tostring(v.amount))
        else
            GUI:SetInputText(self.view.input_meGold2, tostring(v.amount))
        end
    end
    table.clear(tempList)
    for _, v in pairs(message.targetItems) do
        --对方的交易栏新增
        tempList[v.id] = 1
        if not self.targetSelectList[v.id] then
            self:CreateTradeItem(v, false) 
        end
    end
    for itemid, v in pairs(self.targetSelectList) do
        --对方的交易栏移除
        if not tempList[itemid] then
            self:RemoveTradeItem(itemid, false)
        end
    end
    --对方的状态更新
    self.targetState = message.targetState
    if message.targetState == TradeState.LOCKED then
        GUI:setVisible(self.view.mask_target, true)
        GUI:Text_setString(self.view.txt_targetState, "已锁定")
    elseif message.targetState == TradeState.CONFIRMED then
        GUI:setVisible(self.view.mask_target, true)
        GUI:Text_setString(self.view.txt_targetState, "已确认")
    else
        GUI:setVisible(self.view.mask_target, false)
    end
    for _, v in pairs(message.targetCurrency) do
        --对方的货币更新
        if v.cfgId == self.gold1 then
            GUI:Text_setString(self.view.txt_targetGold1, tostring(v.amount))
        else
            GUI:Text_setString(self.view.txt_targetGold2, tostring(v.amount))
        end
    end
end

---确认我的当前状态是否能操作
function this:CheckCanOperate()
    if self.meState == TradeState.LOCKED or self.meState == TradeState.CONFIRMED then
        return false
    end
    return true
end

---界面显示时调用一次
function this:Show()
end

function this:InitData()
    self.bagItemList = {}
    self.indexToItem = {}
    self.selectList = {}
    self.indexList = {}
    self.targetSelectList = {}
    self.mePosList = {}
    self.targetPosList = {}
    self.meState = TradeState.TRADING
    self.targetState = TradeState.TRADING
    GUI:Image_setType(self.view.bg_bagScroll, EImageType.Tiled)
    GUI:Image_setType(self.view.bg_meScroll, EImageType.Tiled)
    GUI:Image_setType(self.view.bg_targetScroll, EImageType.Tiled)
    GUI:setVisible(self.view.mask_me, false)
    GUI:setVisible(self.view.mask_target, false)
    GUI:SetInputText(self.view.input_meGold1, "0")
    GUI:SetInputText(self.view.input_meGold2, "0")
    GUI:Text_setString(self.view.txt_titleMe, SL:GetMetaValue(EMetaVarGetKey.USER_NAME))
    self:LUA_EVENT_MONEYCHANGE()
    local icon1 = SL:GetConfig("cfg_item", self.gold1).looks
    local icon2 = SL:GetConfig("cfg_item", self.gold2).looks
    GUI:Image_loadTexture(self.view.icon_meGold1, icon1,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    GUI:Image_loadTexture(self.view.icon_meGold2, icon2,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    GUI:Image_loadTexture(self.view.icon_targetGold1, icon1,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    GUI:Image_loadTexture(self.view.icon_targetGold2, icon2,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    GUI:Image_loadTexture(self.view.icon_ownGold1, icon1,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    GUI:Image_loadTexture(self.view.icon_ownGold2, icon2,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:InitData()
    GUI:Text_setString(self.view.txt_targetName, InfoManager.faceTradeInfo:GetTradeTargetName())
    --显示背包所有可交易物品
    local bagItems = SL:GetMetaValue(EMetaVarGetKey.BAG_DATA)   
    local num = 0
    for page, items in pairs(bagItems) do
        for idx, v in pairs(items) do          
            ---@type cfg_item_column
            local itemCfg = SL:GetConfig("cfg_item", v.cfgId)
            local isBind = EquipFunc.GetItemIsBind(v.cfgId, v)
            if not isBind and itemCfg.tradeFacetoFace ~= 1 and SL:HasConfig("cfg_stall", v.cfgId) then
                table.insert(self.bagItemList, v)
                table.insert(self.indexList, page * 10000 + idx)
                num = num + 1
            end
        end
    end
    local c = 4
    local r = 10
    local realR = math.ceil(num / c)
    if realR > r then
        r = realR
    end
    local height = r * 84
    GUI:setContentSize(self.view.bg_bagScroll, 4*84, height)
    self:RefreshItem()
    GUI:setVisible(self.view.prefab1, true)
    GUI:setVisible(self.view.prefab2, true)
end

function this:RefreshItem()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    if table.count(self.bagItemList) == 0 then
       return 
    end
    local count = 0
    local vet = 0
    local hor = 1
    local function processNextItem()
        count = count + 1
        vet = vet + 1
        if vet > 4 then
            vet = vet - 4
            hor = hor + 1
        end
        local item = self.bagItemList[count]
        local index = self.indexList[count]
        local itemArgs = {
            BagTileScrollViewId = self.id,
            item = item,
            x = (vet - 1) * 84,
            y = (hor - 1) * -84,
            z = -100,
            canDrag = false,
            beginDrag = self.beginDrag,
            onDrag = self.onDrag,
            endDrag = self.endDrag,
            ins = self,
            click = self.itemClick,
            index = index,
            isSelect = nil,
            callBackUI = self,
            isShowEffect = self.isShowEffect,
            isFilterTag = nil,
            type = "common",
            default = {
                width = 84,
                height = 84,
                mfixSizeY = 84,
                mfixSizeX = 84
            }
        }
        ---@param bagItem KLBagItemItem
            local tempItem =  GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.bg_bagScroll, self, itemArgs, true,
                    function(bagItem)
                        GUI:SetOnPrefabControlLoaded(bagItem.view.bag_item_, function()
                            self.indexToItem[item.id] = bagItem
                            if self.bagItemList[count + 1] then
                                self.timer = SL:ScheduleOnce(Time.deltaTime * self.bagLoadItemSpeed, processNextItem)
                            end
                            bagItem:ShowFaceTradeBG()
                        end)
                        GUI:SetZIndex(bagItem.view.root,102)
                        GUI:SetZIndex(bagItem.view.equipInfo,203)
                    end)
    end

    processNextItem()
end

---@param bagitemView KLBagItemItemView
---@param bagitem KLBagItemItem
function this:itemClick(bagitemView, item, bagitem)
    if not self:CheckCanOperate() then
        return
    end
    local isSelect = self.selectList[item.id] ~= nil
    SL:CloseTips()
    if isSelect then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_REMOVE_ITEM, item.id)
    else
        if table.count(self.selectList) >= self.maxTradeNum then
            local text = SL:GetConfig("cfg_string", 59005)
            SL:TipMessage(text.text, 1, NoticeType.NoticeMid)
            return
        end
        SL:OpenTips("", item.cfgId, item.id, nil, item, {zindex = 101, hideComparsion = true})
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_ADD_ITEM, {itemId = item.id, index = bagitem.index})
    end
end

---创建交易道具显示
function this:CreateTradeItem(item, isMe)
    if isMe then
        self.indexToItem[item.id]:ShowFaceTradeSelect(true)
    end
    local parent = isMe and self.view.bg_meScroll or self.view.bg_targetScroll
    local saveList = isMe and self.selectList or self.targetSelectList
    local posList = isMe and self.mePosList or self.targetPosList
    local pos
    for i=1, self.maxTradeNum do
        if not posList[i] then
            posList[i] = item.id
            pos = i
            break
        end
    end
    local hor = pos > 5 and 2 or 1
    local vet = pos > 5 and pos - 5 or pos
    local itemArgs = {
            BagTileScrollViewId = self.id,
            item = item,
            x = (vet - 1) * 84,
            y = (hor - 1) * -84,
            z = -100,
            canDrag = false,
            beginDrag = nil,
            onDrag = nil,
            endDrag = nil,
            ins = self,
            click = self.TradeItemCick,
            isSelect = nil,
            callBackUI = self,
            isShowEffect = nil,
            isFilterTag = nil,
            type = "common",
            default = {
                width = 84,
                height = 84,
                mfixSizeY = 84,
                mfixSizeX = 84
            }
        }
        ---@param bagItem KLBagItemItem
        local tempItem =  GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", parent, self, itemArgs, true,
            function(bagItem)
                GUI:SetOnPrefabControlLoaded(bagItem.view.bag_item_, function()
                    bagItem:ShowFaceTradeBG()
                end)
                GUI:SetZIndex(bagItem.view.equipInfo,100)
            end)
        saveList[item.id] = tempItem
end

function this:TradeItemCick(_, item, bagItem)
    SL:OpenTips("", item.cfgId, item.id, nil, item, {hideComparsion = true})
end

--移除交易道具显示
function this:RemoveTradeItem(itemId, isMe)
    if isMe then
        self.indexToItem[itemId]:ShowFaceTradeSelect(false)
    end
    local saveList = isMe and self.selectList or self.targetSelectList
    local posList = isMe and self.mePosList or self.targetPosList
    for i=1, self.maxTradeNum do
        if posList[i] and posList[i] == itemId then
            posList[i] = nil
            break
        end
    end
    if saveList[itemId] then
        GUI:UIPanel_Close(nil, saveList[itemId])
    end
    saveList[itemId] = nil
end

function this:Hide()
end

function this:Close()
    SL.ShowMainPanel()
end

-- 道具拖拽中
function this:onDrag(eventData, systemData)
    self:MoveScrollView(Time.deltaTime * 80 * systemData.delta.y)
end


function this:MoveScrollView(moveDelta)
    local position = GUI:GetRectTransform(self.view.layout2).anchoredPosition
    position.y = position.y + moveDelta
    GUI:GetRectTransform(self.view.layout2).anchoredPosition = position
end

return this

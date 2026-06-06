---@class KLFriendChatItem:UIKmlLuaPanelBase
---@field view KLFriendChatItemView
---@field item_is_show boolean @背包显示标记
---@field chatView KLUIChatView
local KLFriendChatItem = class(UIKmlLuaPanelBase)
local this =KLFriendChatItem
---创建时调用一次
function this:Init()
    self.item_is_show = false
    self.emoji_is_show = false
    self.item_select_type = 1
    self:ItemBtnShow()
    self.ChatItem = {}
    self:UpdateMessage("")

    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    self.maxHor = tonumber(bag_info[1])
    self.maxVet = tonumber(bag_info[2])
    --表情
    self.all_emoji_info = {}
    for i = 61, 87 do
        table.insert(self.all_emoji_info,i.."000")
    end
    GUI:Text_sethorwrap(self.view.text_input,"1")
    GUI:Text_setmline(self.view.text_input,"0")
    GUI:DataListInitData(self.view.emoji_data_list,function()
        return self:EmojiDataListItemCountFunc()
    end,function(realIndex)
        return self:EmojiDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:EmojiDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EmojiDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.btn_emoji_item = {}
    GUI:UIPanel_Open("dev/ui/FriendSys/Item/KLFriendChatView/KLFriendChatViewItem",
            self.view.panel_root,self,nil,false,function(chatView)
                self.chatView = chatView
                self:UpdateChatContent()
            end)
    self.friendId = nil
    GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatItem/KLUIChatItem",self.view.root,self,{},true,function (item)
        self.calculationUI = item
        GUI:setPositionX(self.calculationUI.view.root,2000)
        GUI:setPositionY(self.calculationUI.view.root,2000)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:SetFriend(rid)
    self.friendId = rid
    self:UpdateChatContent()
end

---更新当前输入的消息文本
function this:UpdateMessage(str)
    self.message = str
    GUI:Text_setString(self.view.text_input,self.message)
end

---********************************背包************************************

function this:ShowItem()
    GUI:UIPanel_Close("dev/ui/Chat/Item/KLUIChatBagScrollView/KLUIChatBagScrollViewItem")
    local itemList_ = {}
    local show_id = EBagTileScrollViewId.Bag
    if self.item_select_type == 1 then
        itemList_ = SL:GetMetaValue("BAG_DATA")[1]
    else
        local baseWearBar = SL:GeCareerBaseWearBar(SL:MeData_GetCareer())
        local itemList_1 = SL:GetWearBarsData(baseWearBar)
        for _, item in pairs(itemList_1) do
            table.insert(itemList_, item)
        end
        --itemList_ = BagCellUtil.SortItemList(itemList_)
        itemList_ = SL.Bag:SortItemList(itemList_)
        show_id = EBagTileScrollViewId.Recover
    end

    GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatBagScrollView/KLUIChatBagScrollViewItem", self.view.item_panel, self,
            {
                itemList = itemList_,
                id = show_id,
                forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT"),
                hor = self.maxHor,
                vet = self.maxVet,
                canDrag = false,
                forbidClickCallback = self.forbidClick,
                itemClick = self.ClickItemCallBack,
                --contentScale = 1.125,
                callBackUI = self
            })
end

function this:HideItem()
    self.item_is_show = false
    GUI:setVisible(self.view.item_panel,self.item_is_show)
end

function this:ClickItemCallBack(itemControl, itemData)
    local cfgId = itemData.cfgId
    local id = itemData.id
    -- @item@0:0@
    local index = #self.ChatItem + 1
    table.insert(self.ChatItem,{lid=id,type=self.item_select_type})
    local emojiStr = string.format("item@%s:%s@",index,self.item_select_type)
    self:UpdateMessage(self.message .. emojiStr)
    self:HideItem()
end

function this:forbidClick()
end

function this:btn_bag_onclick()
    self.item_select_type = 1
    self:ItemBtnShow()
    self:ShowItem()
end

function this:btn_equip_onclick()
    self.item_select_type = 2
    self:ItemBtnShow()
    self:ShowItem()
end

function this:ItemBtnShow()
    if self.item_select_type == 1 then
        GUI:setVisible(self.view.btn_bag_select,true)
        GUI:setVisible(self.view.btn_equip_select,false)
    else
        GUI:setVisible(self.view.btn_bag_select,false)
        GUI:setVisible(self.view.btn_equip_select,true)
    end
end
---***********************************************************


---***********************表情***************************

function this:EmojiDataListItemInitFunc(realIndex, kmlcontrol)

end


function this:EmojiDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_emoji_info[realIndex + 1]
    self.btn_emoji_item[kmlcontrol]:RefreshItem(data,self)
end


function this:EmojiDataListItemCountFunc()
    return #self.all_emoji_info
end

function this:EmojiDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatEmojiItem/KLUIChatEmojiItem", self.view.emoji_data_list, self, {}, true)
    
    self.btn_emoji_item[item.view.root] = item
    return item.view.root
end

--添加表情
function this:AddEmoji(emoji_id)
    self:HideEmoji()
    -- emoji@61000:1@
    local emojiStr = string.format("emoji@%s:1@",emoji_id)
    self:UpdateMessage(self.message .. emojiStr)
end

function this:HideEmoji()
    self.emoji_is_show = false
    GUI:setVisible(self.view.emoji_panel,self.emoji_is_show)
end

---****************************************************

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.bag_btn, self, self.BagOnClick)
    GUI:AddOnClickEvent(self.view.pos_btn, self, self.PosOnClick)
    GUI:AddOnClickEvent(self.view.biaoqing_btn, self, self.EmojiOnClick)
    GUI:AddOnClickEvent(self.view.fasong, self, self.SendMessageOnClick)
    GUI:Input_SetOnEndEdit(self.view.text_input, self, self.TextChange)
    
    GUI:AddOnClickEvent(self.view.btn_bag, self, self.btn_bag_onclick)
    GUI:AddOnClickEvent(self.view.btn_equip, self, self.btn_equip_onclick)
    GUI:AddOnClickEvent(self.view.item_mask, self, self.BagOnClick)
    GUI:AddOnClickEvent(self.view.emoji_mask, self, self.EmojiOnClick)
    --SL:RegisterLUAEvent(Event.FriendChatReceiveEvent, self.FriendChatReceiveEvent, self)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_RECEIVE, self.LUA_EVENT_CHAT_RECEIVE, self)
end

function this:BagOnClick()
    self.item_is_show = not self.item_is_show
    GUI:setVisible(self.view.item_panel,self.item_is_show)
    if self.item_is_show then
        self:ShowItem()
    else
        GUI:UIPanel_Close("dev/ui/Chat/Item/KLUIChatBagScrollView/KLUIChatBagScrollViewItem")
    end

end

function this:PosOnClick()
    local x = SL:MeData_GetCoord().x
    local y = SL:MeData_GetCoord().z
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local line = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    local posStr = string.format("pos@%s,%s,%s,%s@",x,y,mapId,line)
    self:UpdateMessage(self.message .. posStr)
end

function this:EmojiOnClick()
    self.emoji_is_show = not self.emoji_is_show
    GUI:setVisible(self.view.emoji_panel,self.emoji_is_show)
    if self.emoji_is_show then
        GUI:DataListUpdateData(self.view.emoji_data_list)
    end
end

function this:SendMessageOnClick()
    --SL:SendChat(EChatChannelType.FRIEND,self.message,self.friendId,self.ChatItem)
    SL:SendChat(EChatChannelType.PERSONAL,self.message,self.friendId,self.ChatItem)
    self.ChatItem = {}
    self:UpdateMessage("")
end

function this:TextChange(a, b,eventData)
    local messageStr = eventData[1]
    if string.isNullOrEmpty(messageStr) then
        self.message = messageStr
        self.ChatItem = {}
    else
        local str = self:CheckInputRichText(messageStr)
        if str ~= messageStr then
            messageStr = str
            GUI:Text_setString(self.view.text_input,messageStr)
        end
        local mess = {message={channel = EChatChannelType.SYSTEM,message = messageStr}}
        self.calculationUI:RefreshItem(mess)
        local xx,yy = GUI:getSizeDelta(self.calculationUI.view.richT)
        if yy <= 320 then
            self.message = messageStr
        else
            GUI:Text_setString(self.view.text_input,self.message)
        end
    end
end

--去掉玩家输入的富文本
function this:CheckInputRichText(message)
    --<size=500>超大字体</size>
    --<color=red>红色</color>
    local str = string.gsub(message, "<[^>]+>", "")
    return str
end

---聊天信息变化
function this:FriendChatReceiveEvent(_, senderId)
    if self.friendId == senderId or senderId == SL:GetMetaValue(EMetaVarGetKey.UID) then
        self:UpdateChatContent()
    end
end

--刷新聊天记录content
-- function this:UpdateChatContent()
--     local chatIdList = SL:FriendInfo_GetChatHistory(self.friendId)

--     local chatList = {}
--     for _,v in pairs(chatIdList) do
--         local msg = SL:FriendInfo_GetMsg(v)

--         if msg then
--             table.insert(chatList, msg)
--         end
--     end
--     if self.chatView then
--         self.chatView:RefreshData(chatList)
--     end
-- end

function this:LUA_EVENT_CHAT_RECEIVE(_,message)
    if message.channel == EChatChannelType.PERSONAL then
        self:UpdateChatContent()
    end
end

function this:UpdateChatContent()
    if not self.friendId then
        return
    end
    local chatIdList = SL:ChatInfo_GetChaTargetInfo(self.friendId)
    local chatList = {}
    for i, v in ipairs(chatIdList) do
        table.insert(chatList,v)
    end
    if self.chatView then
        self.chatView:RefreshData(chatList)
    end
    SL:ChatInfo_FriendShow(self.friendId)
    local is_show = SL:ChatInfo_FriendLookTipShow()
    if is_show then
        local popoverPanel = GUI:GetUI("dev/ui/Preview/Panel/KLPopover/KLPopoverPanel")
        popoverPanel:SetPopoverData(19)
        popoverPanel:RefreshUI()
    else
        local popoverPanel = GUI:GetUI("dev/ui/Preview/Panel/KLPopover/KLPopoverPanel")
        popoverPanel:ClosePopover(19)
        popoverPanel:RefreshUI()
    end
end

function this:Close()
end

return this

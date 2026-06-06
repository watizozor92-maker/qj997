---@class KLFriendAddSubItem:UIKmlLuaPanelBase
---@field view KLFriendAddSubItemView
local KLFriendAddSubItem = class(UIKmlLuaPanelBase)
local this =KLFriendAddSubItem
---创建时调用一次
function this:Init()
    if SL:FriendInfo_GetRecommendFriends() then
        self:UpdateData(SL:FriendInfo_GetRecommendFriends(), false)
        GUI:Text_setString(self.view.tui_jian_text, "系统推荐")
    else
        SL.Friend:ReqRecommendFriendsMessage()
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:RefreshInputValue()
    self:StartTimeDown()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.shua_xin_img, self, self.ReqRefreshAddFriends)
    SL:RegisterLuaNetMsg(MessageDef.ResRecommendFriendsMessage, self.ResRecommendFriendsMessage, self)
    GUI:AddOnClickEvent(self.view.BtnSearch, self, self.SearchFriend)
    SL:RegisterLuaNetMsg(MessageDef.ResSearchFriendMessage, self.ResSearchFriendMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_FRIEND_LIST_CHANGE, self.OnFriendChange, self)
    GUI:Input_SetOnValueChange(self.view.IptSearch, self, self.InputValueChange)
end

function  this:InputValueChange()
    self:RefreshInputValue()
end

function  this:RefreshInputValue()
    local str = GUI:Text_getString(self.view.IptSearch)
    GUI:setVisible(self.view.text2, string.isNullOrEmpty(str))
end

function this:OnFriendChange(_, type)
    if type == 5 and not self.isSearch and self.dataList then
        local list= SL:GetFriendData(5)
        if not table.isNullOrEmpty(list) then
            local checkList = {}
            for _, v in pairs(list) do
                table.insert(checkList, v.rid)
            end
            --屏蔽好友推荐
            for i = #self.dataList, 1 , -1 do
                if table.contains(checkList, self.dataList[i].rid) then
                    table.remove(self.dataList, i)
                end
            end
            self:UpdateData(self.dataList, false)
        end
    end
end

function this:ReqRefreshAddFriends()
    if self.canRefresh then
        SL:FriendInfo_SetNextTime(SL:GetMetaValue(EMetaVarGetKey.UID))

        SL.Friend:ReqRecommendFriendsMessage()
        self:StartTimeDown()
    else
        
    end
end

---@param message FriendProto.RecommendFriendsRes
function this:ResRecommendFriendsMessage(id, message)
    self:UpdateData(message.friendInfo)
    GUI:Text_setString(self.view.tui_jian_text, "系统推荐", false)
end

---查找
function this:SearchFriend()
    local str = GUI:Text_getString(self.view.IptSearch)
    if not string.isNullOrEmpty(str) then
        SL.Friend:ReqSearchFriendMessage(str)
    else
        if SL:FriendInfo_GetRecommendFriends() then
            self:UpdateData(SL:FriendInfo_GetRecommendFriends(), false)
            GUI:Text_setString(self.view.tui_jian_text, "系统推荐")
        else
            SL.Friend:ReqRecommendFriendsMessage()
        end
    end
end

---@param message FriendProto.SearchFriendRes
function this:ResSearchFriendMessage(id, message)
    self:UpdateData(message.friendInfo, true)
    GUI:Text_setString(self.view.tui_jian_text, "搜索 '好友' 符合条件的结果")
end

---@param dataList FriendProto.FriendInfo[]
function this:UpdateData(dataList, isSearch)
    self.dataList = dataList
    self.isSearch = isSearch
    local filePath = "dev/ui/FriendSys/Item/KLFriendAddList/KLFriendAddListItem"
    GUI:UIPanel_Close(filePath)
    for _, v in pairs(dataList) do
        GUI:UIPanel_Open(filePath, self.view.datalist3,
                self, {addFriend = true, data = v}, true)
    end
end

function this:Close()
    GUI:UIPanel_Close("dev/ui/FriendSys/Item/KLFriendAddList/KLFriendAddListItem")
    if self.co_timer then
        Coroutine.Stop(self.co_timer)
    end
end


function this:StartTimeDown()
    if self.co_timer then
        Coroutine.Stop(self.co_timer)
        self.co_timer = nil
    end
    self.co_timer = Coroutine.Start(function()
        local nextTime = SL:FriendInfo_GetNextTime(SL:GetMetaValue(EMetaVarGetKey.UID))

        if not nextTime then
            nextTime = os.time() - 1
        end
        local left = nextTime - os.time()
        self.canRefresh = left <= 0
        if left > 0 then
            GUI:setVisible(self.view.TxtCdCountdown, true)
            GUI:setVisible(self.view.shua_xin_text, false)
            GUI:Button_setGrey(self.view.shua_xin_img, true)
        end
        while left > 0 do
            local minute = math.modf(left / 60)
            local second = left % 60
            local fmtTime = string.format("%02s:%02s", minute, second)
            GUI:Text_setString(self.view.TxtCdCountdown, fmtTime)
            Coroutine.Wait(1)
            left = left - 1
        end
        self.canRefresh = true
        GUI:setVisible(self.view.TxtCdCountdown, false)
        GUI:setVisible(self.view.shua_xin_text, true)
        GUI:Button_setGrey(self.view.shua_xin_img, false)
    end)
end

return this

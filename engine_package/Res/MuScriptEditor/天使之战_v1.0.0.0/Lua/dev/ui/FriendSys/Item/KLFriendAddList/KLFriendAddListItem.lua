---@class KLFriendAddListItem:UIKmlLuaPanelBase
---@field view KLFriendAddListItemView
local KLFriendAddListItem = class(UIKmlLuaPanelBase)
local this =KLFriendAddListItem
---创建时调用一次
function this:Init()
    self.isAddFriend = self.args and self.args.addFriend or false
    GUI:setVisible(self.view.BtnForbid1, self.isAddFriend)

    GUI:setVisible(self.view.BtnRefuse1, not self.isAddFriend)
    GUI:setVisible(self.view.BtnAgree, not self.isAddFriend)
    ---@type FriendProto.FriendInfo
    local data = self.args.data
    self.data = data 
    GUI:Text_setString(self.view.friend_name, data.name)
    GUI:Text_setString(self.view.friend_level, "LV."..data.level)
    if self.isAddFriend then
        local isFriend = SL:CheckIsFriend(data.rid)
        GUI:setVisible(self.view.BtnAlreadyAdd, isFriend)
        GUI:setVisible(self.view.BtnAdd, not isFriend)
    else
        GUI:setVisible(self.view.BtnAlreadyAdd, false)
        GUI:setVisible(self.view.BtnAdd, false)
    end
    if self.data.career == 7 then
        GUI:Image_loadTexture(self.view.Icon,"177","Atlas/FG_AttrPanel.spriteatlas")
    else 
        GUI:Image_loadTexture(self.view.Icon,"1" .. self.data.career,"Atlas/MUIcon.spriteatlas")
    end  

end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnAgree, self, self.AgreeApply)
    GUI:AddOnClickEvent(self.view.BtnRefuse1, self, self.RefuseApply)
    GUI:AddOnClickEvent(self.view.BtnForbid1, self, self.Forbid)
    GUI:AddOnClickEvent(self.view.BtnAdd, self, self.AddFriend)
    GUI:AddOnClickEvent(self.view.BtnAlreadyAdd, self, self.AlreadyAddFriend)
end

function this:AgreeApply()
    SL:HandleAddFriendRequest(self.data.rid, 1)
end

function this:RefuseApply()
    SL:HandleAddFriendRequest(self.data.rid, 0)
end

function this:Forbid()
    SL.Friend:ReqAddFriendMessage(5, self.data.rid)
end

function this:AddFriend()
    SL:AddFriend(self.data.rid)
    local friends = SL:GetFriendData(EFriendRelation.Friend)
    ---@type cfg_global_column
    local tbl = SL:GetConfig("cfg_global", 45)
    local split = string.split(tbl.value, "#")
    local friendMax = tonumber(split[1])
    if table.count(friends) < friendMax then
        SL:FriendInfo_AddIdToAlreadySendFriendReq(self.data.rid)
        GUI:UIPanel_Close(nil, self)
    end
end

function this:AlreadyAddFriend()
    SL:TipMessage("对方已存在您的好友列表中！", 1, NoticeType.NoticeMid)
end

function this:Close()
end

return this

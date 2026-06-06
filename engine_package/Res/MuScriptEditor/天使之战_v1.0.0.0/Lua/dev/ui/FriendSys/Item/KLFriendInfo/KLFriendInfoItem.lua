---@class KLFriendInfoItem:UIKmlLuaPanelBase
---@field view KLFriendInfoItemView
local KLFriendInfoItem = class(UIKmlLuaPanelBase)
local this =KLFriendInfoItem
---创建时调用一次
function this:Init()
    
end

---@param friend FriendProto.FriendInfo
function this:SetFriend(friend)
    self.friend = friend
    GUI:Image_loadTexture(self.view.Icon,"1"..friend.career,"Atlas/MUIcon.spriteatlas")
    GUI:Text_setString(self.view.friend_level, "LV."..friend.level)
    GUI:Text_setString(self.view.friend_name, friend.name)
    GUI:Text_setString(self.view.friend_union_name, "战盟："..(string.isNullOrEmpty(friend.unionName) and "无" or friend.unionName))
    if friend.online == 1 then
        GUI:Text_setString(self.view.TextOnline, "在线")
        GUI:Text_setTextColor(self.view.TextOnline, "#00ff00")
        GUI:Image_setGrey(self.view.Icon, false)
        GUI:Image_setGrey(self.view.friend_select, false)
    else
        GUI:Text_setString(self.view.TextOnline, "离线")
        GUI:Text_setTextColor(self.view.TextOnline,  "#C8C8C8")
        GUI:Image_setGrey(self.view.Icon, true)
        GUI:Image_setGrey(self.view.friend_select, true)
    end
    GUI:Text_setString(self.view.friend_value, (self.type == EFriendRelation.Friend and "亲密度：" or "仇恨值：")..friend.friendLove)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.type = self.args.type
    local friend = self.args.info
    self:SetFriend(friend)
    local toggleGroup = self.args.toggleGroup
    GUI:SetToggleGroup(self.view.KmlFriendListItem, toggleGroup)
end

function this:SetChoose()
    --self.view.KmlFriendListItem:SetTogDefaultThis()
    GUI:SetTogDefaultThis(self.view.KmlFriendListItem)
end
    
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.friend_message, self, self.OperateFriend)
--[[    SL:RegisterLuaNetMsg(LuaMessageIdToClient.FRIEND_LIKE_CHANGE, self.ON_FRIEND_LIKE_CHANGE, self)]]
    SL:RegisterLuaNetMsg(LuaMessageIdToSever.SET_FRIEND_DEGREE, self.ON_FRIEND_LIKE_CHANGE, self)
end

function this:ON_FRIEND_LIKE_CHANGE(id, message)
    if self.friend.rid == message.targetfriendid then
        GUI:Text_setString(self.view.friend_value, (message.type == EFriendRelation.Friend and "亲密度：" or "仇恨值：")
                ..message.likevalue)
        if message.likevalue <= 0 then
            SL:onLUAEvent(FRIEND_LIKE_ZERO_EVENT, message.type)
        end
    end
end

function this:OperateFriend()
    GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendOperate/KLFriendOperatePanel", _, _, {rid = self.friend.rid})
end

function this:Close()
end

return this

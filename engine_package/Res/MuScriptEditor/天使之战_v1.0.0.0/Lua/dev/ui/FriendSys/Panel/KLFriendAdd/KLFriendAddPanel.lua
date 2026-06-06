---@class KLFriendAddPanel:UIKmlLuaPanelBase
---@field view KLFriendAddPanelView
local KLFriendAddPanel = class(UIKmlLuaPanelBase)
local this =KLFriendAddPanel
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
    --self.view.add_friend_butten:SetTogDefaultThis()
    if self.args and self.args.showApplicationInfo then
        GUI:SetTogDefaultThis(self.view.friend_applay_butten)
        return
    end
    GUI:SetTogDefaultThis(self.view.add_friend_butten)

--[[    if SL:GetIsWebGL() then
        GUI:setAnchorPoint(self.view.BtnClose,1,1)
        GUI:setPosition(self.view.BtnClose,0,0)
    end]]
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.add_friend_butten, self, self.TogChange, true)
    GUI:SetToggleOnValueChange(self.view.friend_applay_butten, self, self.TogChange, false)
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.CloseMe)
end

function this:CloseMe()
    GUI:UIPanel_Close(self.filePath)
end

function this:TogChange(_, isFriend, data)
    if data[1] then
        if isFriend then
            GUI:UIPanel_Open("dev/ui/FriendSys/Item/KLFriendAddSub/KLFriendAddSubItem", self.view.SubRoot, self)
            GUI:UIPanel_Close("dev/ui/FriendSys/Item/KLFriendApplySub/KLFriendApplySubItem")
        else
            GUI:UIPanel_Close("dev/ui/FriendSys/Item/KLFriendAddSub/KLFriendAddSubItem")
            GUI:UIPanel_Open("dev/ui/FriendSys/Item/KLFriendApplySub/KLFriendApplySubItem", self.view.SubRoot, self)
        end
    end
end

function this:Close()
end

return this

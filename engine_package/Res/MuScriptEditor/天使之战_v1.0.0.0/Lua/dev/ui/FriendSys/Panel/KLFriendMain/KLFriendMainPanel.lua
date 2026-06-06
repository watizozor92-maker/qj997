---@class KLFriendMainPanel:UIKmlLuaPanelBase
---@field view KLFriendMainPanelView
---@field relatePanel KLFriendUIItem
local KLFriendMainPanel = class(UIKmlLuaPanelBase)
local this = KLFriendMainPanel
---创建时调用一次
function this:Init()
    GUI:SetToggleGroup(self.view.Options_friend, self.view.friend_head_common_layout)
    GUI:SetToggleGroup(self.view.Options_archenemy, self.view.friend_head_common_layout)
    GUI:SetToggleGroup(self.view.Options_blacklist, self.view.friend_head_common_layout)
    self.relationShip = {
        [EFriendRelation.Friend] = self.view.Options_friend,
        [EFriendRelation.BlackList] = self.view.Options_blacklist,
    }
    SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_DEL,{id=PopoverType.Tip_friends})
    GUI:SetZIndex(self.view.BtnHelp,210)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local defaultType = EFriendRelation.Friend
    if self.args and self.args.type and self.relationShip[self.args.type] then
        defaultType = self.args.type
    end
    --self.relationShip[defaultType]:SetTogDefaultThis()
    GUI:SetTogDefaultThis(self.relationShip[defaultType])
--[[
    if SL:GetIsWebGL() then
        GUI:setAnchorPoint(self.view.BtnClose,1,1)
        GUI:setPosition(self.view.BtnClose,0,0)
    end]]
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.CloseSelf)
    GUI:SetToggleOnValueChange(self.view.Options_friend, self, self.ChangeOptions, EFriendRelation.Friend)
    GUI:SetToggleOnValueChange(self.view.Options_archenemy, self, self.ChangeOptions, EFriendRelation.Enemy)
    GUI:SetToggleOnValueChange(self.view.Options_blacklist, self, self.ChangeOptions, EFriendRelation.BlackList)
    GUI:AddOnClickEvent(self.view.add_friend, self, self.AddFriendOnClick)
    GUI:AddOnClickEvent(self.view.BtnHelp, self, self.OpenFriendTips)
end

---打开帮助面板
function this:OpenFriendTips()
    local content = "1、添加好友时需对方同意后才会成为好友。\n2、好友互动可以增加亲密度。\n3、屏蔽后将无法接收该玩家的信息。\n4、被陌生人击杀后会自动将其加入宿敌。"
    SL:CommonStrTipsMessage({title = "提 示",str = content})
    --GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendTips/KLFriendTipsPanel")
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
end

function this:ChangeOptions(control, type, data)
    if data[1] then
        if not self.relatePanel then
            GUI:UIPanel_Open("dev/ui/FriendSys/Item/KLFriendUI/KLFriendUIItem", self.view.root, self,self.args,true,function(win)
                self.relatePanel = win
                if self.relatePanel:SetType(type) then
                    SL.Friend:ReqOpenFriendPanelMessage(type)
                end
            end)
        else
            if self.relatePanel:SetType(type) then
                SL.Friend:ReqOpenFriendPanelMessage(type)
            end
        end
        
    end
end

function this:AddFriendOnClick()
    GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendAdd/KLFriendAddPanel")
end

function this:Close()
    SL.ShowMainPanel()
end

return this

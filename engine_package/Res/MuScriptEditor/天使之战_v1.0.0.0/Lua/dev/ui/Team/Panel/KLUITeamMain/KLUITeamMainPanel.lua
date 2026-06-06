---@class KLUITeamMainPanel:UIKmlLuaPanelBase
---@field view KLUITeamMainPanelView
local KLUITeamMainPanel = class(UIKmlLuaPanelBase)
local this =KLUITeamMainPanel
---创建时调用一次
function this:Init()
    self.subPanel = {
        "dev/ui/Team/Panel/KLUIMyTeam/KLUIMyTeamPanel",
        "dev/ui/Team/Panel/KLUINearTeam/KLUINearTeamPanel",
        "dev/ui/Team/Panel/KLUINearPlayer/KLUINearPlayerPanel",
        "dev/ui/Team/Panel/KLUITeamApplication/KLUITeamApplicationPanel",
        "dev/ui/Team/Panel/KLUINearPlayer/KLUINearPlayerPanel",
        "dev/ui/Team/Panel/KLUINearPlayer/KLUINearPlayerPanel",
    }
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    if self.args then
        self.panelType = self.args.panelType
        GUI:UIPanel_Open(self.subPanel[self.panelType], nil, nil, {basePanel = self})
        self:SetToggleDefault(self.panelType)
    else
        self.panelType = 1
        GUI:UIPanel_Open(self.subPanel[self.panelType], nil, nil, {basePanel = self})
    end
    GUI:SetZIndex(self.view.TipsTxt,100)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.my_team, self, self.TeamToggleChange, 1)
    GUI:SetToggleOnValueChange(self.view.near_team, self, self.TeamToggleChange, 2)
    GUI:SetToggleOnValueChange(self.view.near_player, self, self.TeamToggleChange, 3)
    GUI:SetToggleOnValueChange(self.view.request_list, self, self.TeamToggleChange, 4)
    GUI:SetToggleOnValueChange(self.view.my_friend, self, self.TeamToggleChange, 5)
    GUI:SetToggleOnValueChange(self.view.my_union, self, self.TeamToggleChange, 6)
    
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.HelpButton, self, self.OnClickHelpButton)
end

function this:OnClickHelpButton()
    local helpCfg=SL:GetConfig("cfg_rule_text",8)
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
    --SL:CommonStrTipsMessage({title = "队伍说明",str="1、队伍最大人数为5人。\n2、队伍人数越多，经验加成越高。\n3、申请队伍后需队长同意才能入队。"})
end

function this:TeamToggleChange(control, eventData)
    if eventData ~= self.panelType then
        self:CloseTeamOtherPanel()
        self.panelType = eventData
        local myPlayerType = 1
        if self.panelType == 5 then--好友
            myPlayerType = 2
        elseif self.panelType == 6 then--战盟
            myPlayerType = 3
        end
        GUI:UIPanel_Open(self.subPanel[self.panelType], nil, nil, {basePanel = self,myPlayerType = myPlayerType})
    end
end

function this:SetToggleDefault(type)
    if type == 1 then
        GUI:Toggle_setIsOn(self.view.my_team,1)
    elseif type == 2 then
        GUI:Toggle_setIsOn(self.view.near_team,1)
    elseif type == 3 then
        GUI:Toggle_setIsOn(self.view.near_player,1)
    elseif type == 4 then
        GUI:Toggle_setIsOn(self.view.request_list,1)
    elseif type == 5 then
        GUI:Toggle_setIsOn(self.view.my_friend,1)
    elseif type == 6 then
        GUI:Toggle_setIsOn(self.view.my_union,1)
    end
end

function this:CloseTeamOtherPanel()
    GUI:UIPanel_Close(self.subPanel[self.panelType])
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    SL.ShowMainPanel()
end

function this:Close()
    self:CloseTeamOtherPanel()
    self.panelType = 0
end

function this:SetTipText(str)
    GUI:Text_setString(self.view.TipsTxt,str)
end

return this

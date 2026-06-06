---@class KLUINearTeamPanel:UIKmlLuaPanelBase
---@field view KLUINearTeamPanelView
local KLUINearTeamPanel = class(UIKmlLuaPanelBase)
local this =KLUINearTeamPanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData( self.view.near_team_datalist,function()
        return self:ListItemCountFunc()
    end,function(realIndex)
        return self:ListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

function this:ListItemCountFunc()
    return #self.teamList
end

function this:ListItemGetFunc(realIndex)

end

function this:ListItemInitFunc(realIndex, kmlcontrol)

end

function this:ListItemUpdateFunc(realIndex, kmlcontrol)
    local team_info = self.teamList[realIndex + 1]
    local team_name = GUI:GetChildControl(self.view.near_team_datalist,realIndex,'team_name')
    local team_num = GUI:GetChildControl(self.view.near_team_datalist,realIndex,'team_num')
    local apply_btn = GUI:GetChildControl(self.view.near_team_datalist,realIndex,'apply_btn')
    local had_apply_btn = GUI:GetChildControl(self.view.near_team_datalist,realIndex,'had_apply_btn')
    local in_team_btn = GUI:GetChildControl(self.view.near_team_datalist,realIndex,'in_team_btn')
    GUI:Text_setString(team_name, team_info.roleInfo.name)
    GUI:Text_setString(team_num, tostring(team_info.count))
    local teamId = SL:TeamInfo_GetTeamId()
    if teamId == team_info.teamId then
    
        GUI:SetActive(apply_btn, false)
        GUI:SetActive(had_apply_btn, false)
        GUI:SetActive(in_team_btn, true)
    else
        if team_info.applyState == 0 then
            GUI:SetActive(apply_btn, true)
            GUI:SetActive(had_apply_btn, false)
            GUI:SetActive(in_team_btn, false)
            GUI:AddOnClickEvent(apply_btn, self, self.ApplyTeam, {teamId = team_info.teamId})
        else
            GUI:SetActive(apply_btn, false)
            GUI:SetActive(had_apply_btn, true)
            GUI:SetActive(in_team_btn, false)
            GUI:AddOnClickEvent(apply_btn, self, self.HadApplyTeam)
        end
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:RequestNearTeam()
end

function this:ApplyTeam(_, eventData)
    local teamId = SL:TeamInfo_GetTeamId()
    if teamId and teamId > 0 then
        if teamId == eventData.teamId then
            SL:CommonTipsMessage({stringTblID=236,showTips = "您已在队伍中，无需申请"})
        else
            SL:CommonTipsMessage({stringTblID=237,showTips = "您已加入其他队伍，无法申请该队伍"})
        end
    else
        SL:RequestApplyAgree(eventData.teamId)
    end
end

function this:HadApplyTeam()
    SL:CommonTipsMessage({ stringTblID=238,showTips = "请勿重复申请" })
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(MessageDef.ResNearbyTeamListMessage, self.ResNearbyTeamListMessage, self)
end

---@param message TeamProto.NearbyTeamList
function this:ResNearbyTeamListMessage(_, message)
    if message then
        self.teamList = message.nearbyTeam
    end
    ---@type KLUITeamMainPanel
    local panel = GUI:GetUI("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    if panel then
        if #self.teamList == 0 then
            panel:SetTipText("附近无已创建队伍")
        else
            panel:SetTipText("")
        end
    end
    GUI:DataListUpdateData(self.view.near_team_datalist)
end

function this:Close()
    local panel = GUI:GetUI("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    if panel then
        panel:SetTipText("")
    end
end

return this

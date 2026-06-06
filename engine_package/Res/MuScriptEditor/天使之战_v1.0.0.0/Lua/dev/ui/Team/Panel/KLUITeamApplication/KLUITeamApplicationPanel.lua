---@class KLUITeamApplicationPanel:UIKmlLuaPanelBase
---@field view KLUITeamApplicationPanelView
local KLUITeamApplicationPanel = class(UIKmlLuaPanelBase)
local this =KLUITeamApplicationPanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData( self.view.application_datalist,function()
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
    return #self.InviteListOrApplyList
end

function this:ListItemGetFunc(realIndex)

end

function this:ListItemInitFunc(realIndex, kmlcontrol)

end

function this:ListItemUpdateFunc(realIndex, kmlcontrol)
    local info = self.InviteListOrApplyList[realIndex + 1]
    local apply_name = GUI:GetChildControl(self.view.application_datalist,realIndex,'apply_name')
    local apply_level = GUI:GetChildControl(self.view.application_datalist,realIndex,'apply_level')
    local apply_career = GUI:GetChildControl(self.view.application_datalist,realIndex,'apply_career')
    local apply_tips = GUI:GetChildControl(self.view.application_datalist,realIndex,'apply_tips')
    local refuse_btn = GUI:GetChildControl(self.view.application_datalist,realIndex,'refuse_btn')
    local agree_btn = GUI:GetChildControl(self.view.application_datalist,realIndex,'agree_btn')

    if self.type == 1 then
        GUI:Text_setString(apply_name, info.roleInfo.name)
        GUI:Text_setString(apply_level, "Lv : " .. info.roleInfo.level)
        local career = info.roleInfo.career
        ---@type cfg_career_column[]
        local career_tbl = SL:GetConfigTable("cfg_career")
        for _, v in pairs(career_tbl) do
            if v.baseCareer == career.baseCareer and v.careerRank == career.careerRank then
                GUI:Text_setString(apply_career, v.name)
                break
            end
        end
        GUI:Text_setString(apply_tips, "邀请加入队伍")
        GUI:AddOnClickEvent(refuse_btn, self, self.RefuseOtherInvite,{ leaderId = info.roleInfo.rid })
        GUI:AddOnClickEvent(agree_btn, self, self.AgreeOtherInvite,{ leaderId = info.roleInfo.rid })
    elseif self.type == 2 then
        GUI:Text_setString(apply_name, info.name)
        GUI:Text_setString(apply_level, "Lv." .. info.level)
        local career = info.career
        ---@type cfg_career_column[]
        local career_tbl = SL:GetConfigTable("cfg_career")
        for _, v in pairs(career_tbl) do
            if v.baseCareer == career.baseCareer and v.careerRank == career.careerRank then
                GUI:Text_setString(apply_career, v.name)
                break
            end
        end
        GUI:Text_setString(apply_tips, "申请加入队伍")
        GUI:AddOnClickEvent(refuse_btn, self, self.RefuseOtherApply,{ leaderId = info.rid })
        GUI:AddOnClickEvent(agree_btn, self, self.AgreeOtherApply,{ leaderId = info.rid })
    end
end

function this:RefuseOtherInvite(_, eventData)
    SL:RequestRefuseTeamInvite(eventData.leaderId)
end

function this:AgreeOtherInvite(_, eventData)
    SL:RequestAgreeTeamInvite(eventData.leaderId)
end

function this:RefuseOtherApply(_, eventData)
    SL:ReqRefuseReplyApply(eventData.leaderId)
end

function this:AgreeOtherApply(_, eventData)
    SL:ReqAgreeReplyApply(eventData.leaderId)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:DelBubbleTips(15)
    SL:RequestApplyData()
    self.scheduleId = SL:Schedule( self.scheduleId,10, 10, -1, function()
        SL:RequestApplyData()
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(MessageDef.ResInvitationListMessage, self.ResInvitationListMessage, self)
    SL:RegisterLuaNetMsg(MessageDef.ResApplicationListMessage, self.ResApplicationListMessage, self)
    
    GUI:AddOnClickEvent(self.view.clearbtn, self, self.ClearAllRequestList)
    GUI:AddOnClickEvent(self.view.agreebtn, self, self.AgreeAllRequestList)
end

function this:AgreeAllRequestList()
    SL:SendLuaNetMsg(LuaMessageIdToSever.LEADER_AGREE_APPLY)
    self.InviteListOrApplyList = {}
    GUI:DataListUpdateData(self.view.application_datalist)
    GUI:SetActive(self.view.agreebtn,false)
    GUI:SetActive(self.view.clearbtn,false)
end

function this:ClearAllRequestList()
    SL:ReqClearAllRequestList()
    self.InviteListOrApplyList = {}
    GUI:DataListUpdateData(self.view.application_datalist)
    GUI:SetActive(self.view.agreebtn,false)
    GUI:SetActive(self.view.clearbtn,false)
end

---@param message TeamProto.InvitationList
function this:ResInvitationListMessage(_, message)
    self.type = 1
    self.InviteListOrApplyList = message.invitation
    ---@type KLUITeamMainPanel
    local panel = GUI:GetUI("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    if panel then
        if #self.InviteListOrApplyList == 0 then
            panel:SetTipText("暂无请求信息")
        else
            panel:SetTipText("")
        end
    end
    GUI:DataListUpdateData(self.view.application_datalist)
    GUI:SetActive(self.view.agreebtn,false)
    GUI:SetActive(self.view.clearbtn,#self.InviteListOrApplyList > 0)
end

---@param message TeamProto.ApplicationList
function this:ResApplicationListMessage(_, message)
    self.type = 2
    self.InviteListOrApplyList = message.roleInfo
    ---@type KLUITeamMainPanel
    local panel = GUI:GetUI("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    if panel then
        if #self.InviteListOrApplyList == 0 then
            panel:SetTipText("暂无请求信息")
        else
            panel:SetTipText("")
        end
    end
    GUI:DataListUpdateData(self.view.application_datalist)
    GUI:SetActive(self.view.agreebtn,#self.InviteListOrApplyList > 0)
    GUI:SetActive(self.view.clearbtn,#self.InviteListOrApplyList > 0)
end

function this:Close()
    SL:UnSchedule(self.scheduleId)
    local panel = GUI:GetUI("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    if panel then
        panel:SetTipText("")
    end
end

return this

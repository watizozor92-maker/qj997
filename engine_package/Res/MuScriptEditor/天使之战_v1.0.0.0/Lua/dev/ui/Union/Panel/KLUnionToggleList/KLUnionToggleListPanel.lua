---@class KLUnionToggleListPanel:UIKmlLuaPanelBase
---@field view KLUnionToggleListPanelView
local KLUnionToggleListPanel = class(UIKmlLuaPanelBase)
local this =KLUnionToggleListPanel
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.isFrist = true
    GUI:setVisible(self.view.armbandToggle, false)
    GUI:Toggle_setIsOn(self.view.armbandToggle, false)
    GUI:setVisible(self.view.electionToggle, false)
    GUI:Toggle_setIsOn(self.view.electionToggle, false)
    GUI:setVisible(self.view.replaceToggle, false)
    GUI:Toggle_setIsOn(self.view.replaceToggle, false)
    GUI:setVisible(self.view.campaignToggle, false)
    GUI:Toggle_setIsOn(self.view.campaignToggle, false)
    --[[GUI:setVisible(self.view.taskToggle, false)
    GUI:Toggle_setIsOn(self.view.taskToggle, false)]]
    local unionId = self.args and self.args.unionId or SL:MeData_GetUnionId()
    if unionId == 0 then
        GUI:setVisible(self.view.ToggleUnionIcon, true)
        GUI:setVisible(self.view.ToggleUnionInIcon, false)
        self:joinToggle(nil,nil,{[1]=true})
    else
        GUI:setVisible(self.view.ToggleUnionIcon, false)
        GUI:setVisible(self.view.ToggleUnionInIcon, true)
        local def = self.args and self.args.def or 1
        self.isFrist = def == 1
        if def == 1 then
            GUI:SetTogDefaultThis(self.view.infoToggle)
        elseif def == 2 then
            GUI:SetTogDefaultThis(self.view.armbandToggle)
        elseif def == 3 then
            GUI:SetTogDefaultThis(self.view.activityToggle)
        elseif def == 4 then
            GUI:SetTogDefaultThis(self.view.taskToggle)
        else
            GUI:SetTogDefaultThis(self.view.infoToggle)
        end
        
        --self:infoToggle()
        SL:ScheduleOnce(Time.deltaTime,function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_INFO)
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_RUN_FOR_LEADER_DATA)
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_IMPEACH_INFO)
        end)
    end
    SL.HideMainPanel()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.joinToggle, self, self.joinToggle)
    GUI:SetToggleOnValueChange(self.view.createToggle, self, self.createToggle)
    GUI:SetToggleOnValueChange(self.view.infoToggle, self, self.infoToggle)
    GUI:SetToggleOnValueChange(self.view.armbandToggle, self, self.armbandToggle)
    GUI:SetToggleOnValueChange(self.view.activityToggle, self, self.ActivityToggleChange)
    GUI:SetToggleOnValueChange(self.view.electionToggle, self, self.ElectionToggleChange)
    GUI:SetToggleOnValueChange(self.view.replaceToggle, self, self.ReplaceToggleChange)
    GUI:SetToggleOnValueChange(self.view.campaignToggle, self, self.CampaignToggleChange)
    GUI:SetToggleOnValueChange(self.view.taskToggle, self, self.taskToggleChange)
    
    SL:RegisterLUAEvent(LUA_EVENT_ELECTION_DATA_CHANGE, self.On_ElectionDataChange, self)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, self.On_ChangeToggle, self)
    SL:RegisterLUAEvent(LUA_EVENT_UNION_CAMPAIGN_DATA, self.On_CampaignDataChange, self)
end

function this:On_ChangeToggle(id, toggle)
    if self.view[toggle] then
        GUI:SetTogDefaultThis(self.view[toggle])
--[[        GUI:Toggle_setIsOn(self.view[toggle], true)
        GUI:Tog]]
    end
end

function this:infoToggle(control,eventData,value)
    if value[1] then
        GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel")
        GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionInfo/KLUnionInfoPanel")
        GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionActivity/KLUnionActivityPanel")
        self.isFrist = false
        self:OnClickBlock()
    else
        GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel")
        GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionInfo/KLUnionInfoPanel")
        GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionMemberInfo/KLUnionMemberInfoPanel")
        GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionModifyFlag/KLUnionModifyFlagPanel")
    end
end

function this:joinToggle(control,eventData,value)
    if value[1] then
        GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionCreate/KLUnionCreatePanel")
        GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionJoin/KLUnionJoinPanel")
        self:OnClickBlock()
        GUI:Button_setBright(self.view.joinToggle,false)
    else
        GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionJoin/KLUnionJoinPanel")
        GUI:Button_setBright(self.view.joinToggle,true)
    end
    
end

function this:createToggle(control,eventData,value)
    if value[1] then
        GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionSummaryInfo/KLUnionSummaryInfoPanel")
        GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionJoin/KLUnionJoinPanel")
        GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionCreate/KLUnionCreatePanel")
        self:OnClickBlock()
        GUI:Button_setBright(self.view.createToggle,false)
    else
        GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionCreate/KLUnionCreatePanel")
        GUI:Button_setBright(self.view.createToggle,true)
    end
end

---臂章
function this:armbandToggle(control,eventData,value)
    if value[1] and self.isFrist == false then
        GUI:UIPanel_Open("dev/outui/Union/Panel/KLArmbandUpgrade/KLArmbandUpgradePanel")
        self:OnClickBlock()
        GUI:Button_setBright(self.view.armbandToggle,false)
    else
        GUI:UIPanel_Close("dev/outui/Union/Panel/KLArmbandUpgrade/KLArmbandUpgradePanel")
        GUI:Button_setBright(self.view.armbandToggle,true)
    end      
end

function this:ActivityToggleChange(control,eventData,value)
    if value[1] and self.isFrist == false then
        GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionActivity/KLUnionActivityPanel")
        self:OnClickBlock()
        GUI:Button_setBright(self.view.activityToggle,false)
    else
        GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionActivity/KLUnionActivityPanel")
        GUI:Button_setBright(self.view.activityToggle,true)
    end
end

function this:ElectionToggleChange(control,eventData,value)
    if value[1] and self.isFrist == false then
        GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionElectionAndReplace/KLUnionElectionAndReplacePanel", 
            _, _, {type = EUnionLeaderOperateType.Election})
        self:OnClickBlock()
        GUI:Button_setBright(self.view.electionToggle,false)
    else
        GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionElectionAndReplace/KLUnionElectionAndReplacePanel")
        GUI:Button_setBright(self.view.electionToggle,true)
    end
end

function this:ReplaceToggleChange(control,eventData,value)
    if value[1] and self.isFrist == false then
        GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionElectionAndReplace/KLUnionElectionAndReplacePanel",
                _, _, {type = EUnionLeaderOperateType.Replace})
        self:OnClickBlock()
        GUI:Button_setBright(self.view.replaceToggle,false)
    else
        GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionElectionAndReplace/KLUnionElectionAndReplacePanel")
        GUI:Button_setBright(self.view.replaceToggle,true)
    end
end

function this:CampaignToggleChange(control,eventData,value)
    if value[1] and self.isFrist == false then
        GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionCampaign/KLUnionCampaignPanel",
                _, _, {type = EUnionLeaderOperateType.Campaign})
        self:OnClickBlock()
        GUI:Button_setBright(self.view.campaignToggle,false)
    else
        GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionCampaign/KLUnionCampaignPanel")
        GUI:Button_setBright(self.view.campaignToggle,true)
    end
end

function this:taskToggleChange(control,eventData,value)
    if value[1] and self.isFrist == false then
        GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionTask/KLUnionTaskPanel")
        self:OnClickBlock()
        GUI:Button_setBright(self.view.taskToggle,false)
    else
        GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionTask/KLUnionTaskPanel")
        GUI:Button_setBright(self.view.taskToggle,true)
    end
end

function this:On_ElectionDataChange(id, isReplace)
    if isReplace then
        GUI:setVisible(self.view.replaceToggle, false)
        if self.electionTimer then
            SL:UnSchedule(self.electionTimer)
        end
        if table.count(InfoManager.unionElectionInfo:GetReplaceDataList()) > 0 then
            local endTime = InfoManager.unionElectionInfo:GetReplaceEndTime()
            if endTime then
                endTime = tonumber(endTime)
                local nowTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
                local deltaTime = endTime - tonumber(nowTime)
                if deltaTime > 0 then
                    GUI:setVisible(self.view.replaceToggle, true)
                    self.electionTimer = SL:Schedule(self.electionTimer,0, 1, deltaTime // 1000 + 1,  function()
                        local nowTime_ = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
                        local deltaTime_ = endTime - tonumber(nowTime_)
                        if deltaTime_ <= 0 then
                            GUI:setVisible(self.view.replaceToggle, false)
                            SL:UnSchedule(self.electionTimer)
                            self.electionTimer = nil
                        end
                    end)
                end
            end
        end
    else
        GUI:setVisible(self.view.electionToggle, false)
        if self.electionTimer then
            SL:UnSchedule(self.electionTimer)
        end
        if table.count(InfoManager.unionElectionInfo:GetElectionDataList()) > 0 then
            local endTime = InfoManager.unionElectionInfo:GetElectionEndTime()
            if endTime then
                local nowTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
                local deltaTime = endTime - nowTime
                if deltaTime > 0 then
                    GUI:setVisible(self.view.electionToggle, true)
                    self.electionTimer = SL:Schedule(self.electionTimer,0, 1, deltaTime // 1000 + 1,  function()
                        local nowTime_ = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
                        local deltaTime_ = endTime - nowTime_
                        if deltaTime_ <= 0 then
                            GUI:setVisible(self.view.electionToggle, false)
                            SL:UnSchedule(self.electionTimer)
                            self.electionTimer = nil
                        end
                    end)
                end
            end
        end
    end
end

function this:On_CampaignDataChange()
    GUI:setVisible(self.view.campaignToggle, false)
    if self.electionTimer then
        SL:UnSchedule(self.electionTimer)
    end
    local endTime = InfoManager.unionElectionInfo:GetCampaignEndTime()
    if endTime then
        endTime = tonumber(endTime)
        local nowTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local deltaTime = endTime - tonumber(nowTime)
        if deltaTime > 0 then
            GUI:setVisible(self.view.campaignToggle, true)
            self.electionTimer = SL:Schedule(self.electionTimer,0, 1, deltaTime // 1000 + 1,  function()
                local nowTime_ = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
                local deltaTime_ = endTime - tonumber(nowTime_)
                if deltaTime_ <= 0 then
                    GUI:setVisible(self.view.campaignToggle, false)
                    SL:UnSchedule(self.electionTimer)
                    self.electionTimer = nil
                end
            end)
        end
    end
end

function this:Close()
    if self.electionTimer then
        SL:UnSchedule(self.electionTimer)
    end
    if self.blockTimer then
        SL:UnSchedule(self.blockTimer)
        self.blockTimer = nil
    end
    self.electionTimer = nil
end

function this:OnClickBlock()
    GUI:setVisible(self.view.img_block, true)
    if self.blockTimer then
        SL:UnSchedule(self.blockTimer)
        self.blockTimer = nil
    end
    
    self.blockTimer = SL:ScheduleOnce(0.5, function()
        GUI:setVisible(self.view.img_block, false)
    end)
end

return this

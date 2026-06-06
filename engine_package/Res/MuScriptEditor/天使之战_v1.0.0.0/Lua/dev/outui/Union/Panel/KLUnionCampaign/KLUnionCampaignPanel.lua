---@class KLUnionCampaignPanel:UIKmlLuaPanelBase
---@field view KLUnionCampaignPanelView
---@field cfg cfg_unionLevel_column
local KLUnionCampaignPanel = class(UIKmlLuaPanelBase)
local this = KLUnionCampaignPanel
---创建时调用一次
function this:Init()
    self.level = nil
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_INFO)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnAgree, self, self.AgreeOnClick)
    GUI:AddOnClickEvent(self.view.btnRefuse, self, self.RefuseOnClick)
    GUI:AddOnClickEvent(self.view.btnClose, self, self.CloseSelf)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_UNION_INFO, self.RES_GET_UNION_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_UNION_CAMPAIGN_DATA, self.SetData, self)
    SL:RegisterLUAEvent(LUA_EVENT_UNION_CAMPAIGN_VOTE_CHANGE, self.UpdateVoteNum, self)
end

function this:RES_GET_UNION_INFO(id, message)
    local tipdes ="在投票结束时，若同意人数多于反对人数则".."<color=#00ff00>".."弹劾成功".. "</color>".."，当前盟主将变为普通成员，且战盟变为".."<color=#ff2323>".."无盟主状态".. "</color>"
    GUI:Text_setString(self.view.txtDesc, tipdes)
    self.level = tonumber(message.unionlevel)
    local cfg = SL:GetConfig("cfg_unionLevel", self.level, "unionLevel")
    self.cfg = cfg
    local own = SL:GetBagItemCount(cfg.campaignVoteCast[1])
    local str = string.format("<color=%s>%s</color>", own >= cfg.campaignVoteCast[2] and "#1BE419" or "#9b1818",
            cfg.campaignVoteCast[2])
    GUI:Item_UpdataData(self.view.itemAgree, {
        ["itemid"] = cfg.campaignVoteCast[1]
    })
    GUI:Text_setString(self.view.txtAgree, str)
    GUI:Item_UpdataData(self.view.itemRefuse, {
        ["itemid"] = self.cfg.campaignVoteCast[1]
    })
    GUI:Text_setString(self.view.txtRefuse, str)
    if message.leaderid ~= "0" then
        local leaderInfo = message.memberinfos[message.leaderid]
        GUI:Text_setString(self.view.txtName,
                "是否同意弹劾当前盟主" .. string.format("<color=#E07907>%s</color>", leaderInfo.name))
    else
        GUI:Text_setString(self.view.txtName, "是否同意弹劾当前盟主")
    end
    self:SetData()
end

function this:SetData()
    self:UpdateVoteNum()
    self:UnSchedule()
    local endTime = InfoManager.unionElectionInfo:GetCampaignEndTime()
    if endTime then
        endTime = tonumber(endTime)
        --local delta = endTime - SL:server
        local nowTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local deltaTime = endTime - tonumber(nowTime)
        local preStr = "弹劾结束倒计时："
        if deltaTime > 0 then
            local takeABreak = false
            self.schedule = SL:Schedule(self.schedule, 0, 1, deltaTime // 1000 + 2, function()
                local nowTime_ = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
                local deltaTime_ = endTime - tonumber(nowTime_)
                if deltaTime_ <= 0 then
                    deltaTime_ = 0
                    if takeABreak == false then
                        takeABreak = true
                    else
                        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_IMPEACH_INFO)
                        SL:onLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, "infoToggle")
                        GUI:UIPanel_Close(self.filePath)
                        return
                    end
                end
                GUI:Text_setString(self.view.txtCountDown, preStr .. InfoManager.unionElectionInfo.FormatTimeStr(deltaTime_))
            end)
        else
            deltaTime = 0
            GUI:Text_setString(self.view.txtCountDown, preStr .. InfoManager.unionElectionInfo.FormatTimeStr(deltaTime))
        end
    end
end

function this:UpdateVoteNum()
    GUI:Text_setString(self.view.txtAgreeNum, tostring(InfoManager.unionElectionInfo:GetCampaignAgreeNum()))
    GUI:Text_setString(self.view.txtDisagreeNum, tostring(InfoManager.unionElectionInfo:GetCampaignOpposeNum()))
end

function this:AgreeOnClick()
    if not self.level then return end
    ---弹劾发起者不可投票
    if SL:GetMetaValue("UID") == tonumber(InfoManager.unionElectionInfo.campaignData.initiator) then return end
    GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionLeaderOperate/KLUnionLeaderOperatePanel",
            _, _, { type = EUnionLeaderOperateType.Campaign, unionLevel = self.level, isAgree = true })
end

function this:RefuseOnClick()
    if not self.level then return end
    ---弹劾发起者不可投票
    if SL:GetMetaValue("UID") == tonumber(InfoManager.unionElectionInfo.campaignData.initiator) then return end
    GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionLeaderOperate/KLUnionLeaderOperatePanel",
            _, _, { type = EUnionLeaderOperateType.Campaign, unionLevel = self.level, isAgree = false })
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    SL.ShowMainPanel()
end

function this:Close()
    self:UnSchedule()
end

function this:UnSchedule()
    if self.schedule then
        SL:UnSchedule(self.schedule)
    end
    self.schedule = nil
end

return this

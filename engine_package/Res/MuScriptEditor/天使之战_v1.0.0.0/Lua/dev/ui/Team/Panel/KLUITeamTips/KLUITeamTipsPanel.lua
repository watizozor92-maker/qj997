---@class KLUITeamTipsPanel:UIKmlLuaPanelBase
---@field view KLUITeamTipsPanelView
---@field onClickData TeamProto.TeamMember @点击数据
---@field teamId number @ 队伍id
---@field leaderId number @ 队长rid
local KLUITeamTipsPanel = class(UIKmlLuaPanelBase)
local this =KLUITeamTipsPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.unionName = ""
    self.unionPosition = 0
    if self.args and self.args.onClickData then
        self.onClickData = self.args.onClickData
        if self.onClickData.roleInfo.rid then
            self.playerID = self.onClickData.roleInfo.rid -- 队伍信息的类id命名的是rid
        else
            self.playerID = self.onClickData.roleInfo.id -- 人物信息的类id命名的是id
        end
        
        if self.onClickData.roleInfo.roleInfoExt then
            self.unionName = self.onClickData.roleInfo.roleInfoExt.unionName
            self.unionPosition = self.onClickData.roleInfo.roleInfoExt.position
        else
            self.unionName = self.onClickData.roleInfo.unionName
            self.unionPosition = self.onClickData.roleInfo.position
        end
        
    end
    if self.args and self.args.teamId then
        self.teamId = self.args.teamId
    end
    if self.args and self.args.leaderId then
        self.leaderId = self.args.leaderId
    end
    if self.args and self.args.listType then
        self.listType = self.args.listType
    end
    if not self.leaderId then
        self.leaderId = SL:TeamInfo_GetLeaderId()
    end
    self:ShowButton()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeButton, self, self.OnClickButton,1)
    GUI:AddOnClickEvent(self.view.invitationButton, self, self.OnClickButton,2)
    GUI:AddOnClickEvent(self.view.leaveButton, self, self.OnClickButton,3)
    GUI:AddOnClickEvent(self.view.kickButton, self, self.OnClickButton,4)
    GUI:AddOnClickEvent(self.view.upCaptainButton, self, self.OnClickButton,5)
    GUI:AddOnClickEvent(self.view.lockButton, self, self.OnClickButton,6)
    GUI:AddOnClickEvent(self.view.chatButton, self, self.OnClickButton,7)
    GUI:AddOnClickEvent(self.view.selectPlayerButton, self, self.OnClickButton,8)
    GUI:AddOnClickEvent(self.view.reqPointButton, self, self.OnClickButton,9)
    GUI:AddOnClickEvent(self.view.joinButton, self, self.OnClickButton,10)
    
end

function this:Close()
end

function this:OnClickButton(control,data)
    if data == 2 then--邀请入队
        SL:ReqSendTeamInvitation(self.playerID, self.listType and self.listType or 1)
    elseif data == 3 then--离开队伍
        SL:DelBubbleTips(15)
        SL:ReqQuitTeam()
    elseif data == 4 then--踢出队伍
        SL:ReqKickOutMember(self.playerID, self.listType and self.listType or 1)
    elseif data == 5 then--升为队长
        SL:ReqChangeCaptain(self.playerID, self.listType and self.listType or 1)
    elseif data == 6 then--查看玩家
        SL:RequestLookPlayer(self.playerID)
    elseif data == 7 then--聊天
        
    elseif data == 8 then--选中玩家
    elseif data == 9 then--发送位置
    elseif data == 10 then--加入队伍
    end
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamTips/KLUITeamTipsPanel")
    EventManager.Dispatch(Event.CloseTeamTipsUI)
end

---显示玩家数据
function this:ShowPlayInfo()
    GUI:Image_loadTexture(self.view.sp_careerIcon,"1"..self.onClickData.roleInfo.career.baseCareer,"Atlas/MUIcon.spriteatlas")
    GUI:Text_setString(self.view.lab_level,"等级:"..self.onClickData.roleInfo.level)
    ---@type cfg_career_column
    local careerTbl =  SL:GetConfigMultiKeys("cfg_career",self.onClickData.roleInfo.career.baseCareer
    , self.onClickData.roleInfo.career.careerRank, "baseCareer", "careerRank")
    GUI:Text_setString(self.view.lab_career,careerTbl.name)
    GUI:Text_setString(self.view.lab_name,self.onClickData.roleInfo.name)
    GUI:Text_setTextColor(self.view.lab_name,"#E6E600")
    GUI:Text_setString(self.view.lab_union,self.unionName.."   "..EUnionPositionToName[self.unionPosition])
end

function this:ShowButton()
    self:HideAllButton()
    self:ShowPlayInfo()
    
    ---处理队伍信息
    if SL:MeData_GetTeamId() > 0 then
        --是自己
        if self.playerID == SL:GetMetaValue(EMetaVarGetKey.UID) then
            GUI:SetActive(self.view.leaveButton,true)
            GUI:SetActive(self.view.reqPointButton,true)
            return
        end
        if self.teamId == SL:MeData_GetTeamId() then
            --队长点击队员
            if self.leaderId and self.leaderId == SL:GetMetaValue(EMetaVarGetKey.UID) then
                GUI:SetActive(self.view.kickButton,true)
                GUI:SetActive(self.view.lockButton,true)
                GUI:SetActive(self.view.chatButton,true)
                GUI:SetActive(self.view.upCaptainButton,true)
                GUI:SetActive(self.view.selectPlayerButton,true)
                return
            else
                GUI:SetActive(self.view.lockButton,true)
                GUI:SetActive(self.view.selectPlayerButton,true)
                GUI:SetActive(self.view.chatButton,true)
                return
            end
        else
            --不同队伍邀请玩家
            GUI:SetActive(self.view.invitationButton,true)
            GUI:SetActive(self.view.lockButton,true)
            GUI:SetActive(self.view.chatButton,true)
            return
        end
    end
    GUI:SetActive(self.view.joinButton,self.teamId > 0)
    GUI:SetActive(self.view.lockButton,true)
    GUI:SetActive(self.view.chatButton,true)
end

---隐藏所有按钮
function this:HideAllButton()
    GUI:SetActive(self.view.invitationButton,false)
    GUI:SetActive(self.view.leaveButton,false)
    GUI:SetActive(self.view.kickButton,false)
    GUI:SetActive(self.view.upCaptainButton,false)
    GUI:SetActive(self.view.lockButton,false)
    GUI:SetActive(self.view.selectPlayerButton,false)
    GUI:SetActive(self.view.chatButton,false)
    GUI:SetActive(self.view.reqPointButton,false)
    GUI:SetActive(self.view.joinButton,false)
end

return this

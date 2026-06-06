---@class KLFriendOperatePanel:UIKmlLuaPanelBase
---@field view KLFriendOperatePanelView
---@field friendInfo FriendProto.FriendInfo
---@field role UserProtos.RoleInfo
---@field uiType number @ 1：通用  2：组队 3：跨服
local KLFriendOperatePanel = class(UIKmlLuaPanelBase)
local this =KLFriendOperatePanel
---创建时调用一次
function this:Init()
    if self.args.pos then
        GUI:SetWorldPosition(self.view.BgBor,self.args.pos.x,self.args.pos.y,self.args.pos.z)
    end
    self.rid = self.args.rid
    self.name = self.args.name
    self.role = nil
    self.uiType = self.args.uiType or 1
    GUI:setVisible(self.view.BtnGrid, false)
    self.is_team = false
    if self.args and self.args.isTeam and self.args.roleInfo and self.rid ~= SL:GetMetaValue(EMetaVarGetKey.UID) then
        self.is_team = true
        self.isMe = false
        self:ResOtherRoleInfoMessage(nil, { type = 1, role = self.args.roleInfo })
    elseif self.rid == SL:GetMetaValue(EMetaVarGetKey.UID) then
        self.isMe = true
        self:ResOtherRoleInfoMessage(nil, { type = 1, role = self.args.roleInfo })
    else
        self.isMe = false
        SL.Friend:ReqOtherRoleInfoMessage(self.rid, 1)
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

---显示玩家数据
---@param friendInfo UserProtos.RoleInfo
function this:ShowPlayInfo(friendInfo)
    GUI:Image_loadTexture(self.view.SpPlayer,"1"..friendInfo.career.baseCareer,"Atlas/MUIcon.spriteatlas")
    GUI:Text_setString(self.view.TxtLevel,"等级:"..friendInfo.level)
    ---@type cfg_career_column
    local careerTbl =  SL:GetConfigMultiKeys("cfg_career", friendInfo.career.baseCareer
    , friendInfo.career.careerRank, "baseCareer", "careerRank")
    GUI:Text_setString(self.view.TxtCareer, careerTbl.name)
    GUI:Text_setString(self.view.TxtName, friendInfo.name)
    GUI:Text_setTextColor(self.view.TxtName,"#FFFFFF")
    if friendInfo.roleInfoExt.unionName == nil then
        GUI:Text_setString(self.view.TxtUnion, "")
    else
        GUI:Text_setString(self.view.TxtUnion,friendInfo.roleInfoExt.unionName.."   "..EUnionPositionToName[friendInfo.roleInfoExt.position])
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(MessageDef.ResOtherRoleInfoMessage, self.ResOtherRoleInfoMessage, self)
    GUI:AddOnClickEvent(self.view.BtnViewPlayer, self, self.ShowPlayerEquips)
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.CloseMe)
    GUI:AddOnClickEvent(self.view.BtnAddFriend, self, self.AddOrRemoveFriend, true)
    GUI:AddOnClickEvent(self.view.BtnDelFriend, self, self.AddOrRemoveFriend, false)
    GUI:AddOnClickEvent(self.view.BtnAddBlack, self, self.AddOrRemoveBlack, true)
    GUI:AddOnClickEvent(self.view.BtnRemoveBlack, self, self.AddOrRemoveBlack, false)
    GUI:AddOnClickEvent(self.view.BtnPrivateChat, self, self.PrivateChat)
    GUI:AddOnClickEvent(self.view.BtnUnionInvite, self, self.BtnUnionInvite)
    GUI:AddOnClickEvent(self.view.BtnUnionReq, self, self.BtnUnionReq)
    GUI:AddOnClickEvent(self.view.BtnTeamInvite, self, self.TeamInvite)
    GUI:AddOnClickEvent(self.view.BtnTeamReq, self, self.TeamReq)
    GUI:AddOnClickEvent(self.view.BtnTeamLeader, self, self.BtnTeamLeader)
    GUI:AddOnClickEvent(self.view.BtnTeamKickOff, self, self.BtnTeamKickOff)
    GUI:AddOnClickEvent(self.view.BtnLeaveTeam, self, self.BtnLeaveTeam)

    GUI:AddOnClickEvent(self.view.lockButton, self, self.ShowPlayerEquips)
    GUI:AddOnClickEvent(self.view.selectPlayerButton, self, self.OnClickSelectPlayerButton)
    GUI:AddOnClickEvent(self.view.reqPointButton, self, self.OnClickReqPointButton)
    GUI:AddOnClickEvent(self.view.joinButton, self, self.OnClickJoinTeamButton)
    -- GUI:AddOnClickEvent(self.view.BtnFlowerSend, self, self.OnClickSendFlower)
    GUI:AddOnClickEvent(self.view.btn_faceTrade, self, self.OnClickFaceTrade)
end

function this:OnClickFaceTrade()
    local Global = SL:GetConfig("cfg_global", 690007)
    if not ConditionManager.Check4D(Global.value) then
        SL:OpenCommonTipPanelById(28)
        return
    end
    if SL:Out_IsInCopy() then
        local stringTbl = SL:GetConfig("cfg_string", 59004)
        SL:TipMessage(stringTbl.text, 1, NoticeType.NoticeMid)
        return
    end
    local cding, countDown = InfoManager.faceTradeInfo:CheckApplyCD()
    if not cding then
        local role = SL:GetRoleById(self.rid)
        if role and InfoManager.faceTradeInfo:CheckRoleDisCanTrade(role) then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_APPLY, self.rid)
            GUI:UIPanel_Close(self.filePath)
        else
            local Global = SL:GetConfig("cfg_string", 59001)
            SL:TipMessage(Global.text, 1, NoticeType.NoticeMid)
        end
    else
        local time = math.ceil(countDown / 1000)
        local Global = SL:GetConfig("cfg_string", 59003)
        SL:TipMessage(string.format(Global.text, time), 1, NoticeType.NoticeMid)
    end
end

function this:OnClickSendFlower()
    GUI:UIPanel_Open("dev/outui/FriendSys/Panel/KLFriendFlowerSend/KLFriendFlowerSendPanel", nil, nil, 
            {rid = self.rid})
    --SL:SendLuaNetMsg(LuaMessageIdToSever.FRIEND_SEND_FLOWERS, {61200001, self.rid})
end

function this:CloseMe()
    if self.uiType == 2 then
        SL:onLUAEvent(Event.CloseTeamTipsUI)
    end
    GUI:UIPanel_Close(self.filePath)
end

---选择玩家
function this:OnClickSelectPlayerButton()
    if self.is_team then
        SL:OpenBossHp(self.rid,self.role)
    else
        SL:OpenBossHp(self.rid)
    end
    self:CloseMe()
end

---发送位置
function this:OnClickReqPointButton()
    local x = SL:MeData_GetCoord().x
    local y = SL:MeData_GetCoord().z
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local line = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    local posStr = string.format("pos@%s,%s,%s,%s@",x,y,mapId,line)
    SL:SendChat(7,posStr,nil,nil)
    self:CloseMe()
end

---加入队伍
function this:OnClickJoinTeamButton()
    if self.otherPlayerTeamId and self.otherPlayerTeamId > 0 then
        SL:RequestApplyAgree(self.otherPlayerTeamId)
        self:CloseMe()
    end
end

function this:ShowPlayerEquips()
    GUI:UIPanel_Close("dev/ui/FriendSys/Panel/KLFriendMain/KLFriendMainPanel")
    local _zindex
    if self.is_team then
        _zindex = 203
    end
    --角色装备信息
    GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel", _, _, {
        isOther = true,
        rid = self.rid,
        x = 0,
        isHideMainUI = self.args.isHideMainUI,
        zindex = _zindex
    })
    self:CloseMe()
end

--添加或删除好友
function this:AddOrRemoveFriend(_, isAdd)
    if isAdd then
        SL:AddFriend(self.rid)    
    else
        SL:DelFriend(self.rid)
    end
    self:CloseMe()
end

--添加或移除黑名单
function this:AddOrRemoveBlack(_, isAdd)
    if isAdd then
        SL:AddBlackList(self.rid)
    else
        SL:DelBlackList(self.rid)    
    end
    self:CloseMe()
end

--私聊
function this:PrivateChat()
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    GUI:UIPanel_Close("dev/ui/FriendSys/Panel/KLFriendMain/KLFriendMainPanel")
    SL:CloseChatUI()
    SL:OpenChatUI({channel=8,rid=self.rid,name=self.name})
    self:CloseMe()
end

--邀请加入战盟
function this:BtnUnionInvite()
    
end

--申请加入战盟
function this:BtnUnionReq()
    
end

--邀请入队
function this:TeamInvite()
    if self.role then
        if SL:MeData_GetTeamId() == 0 then
            SL:TipMessage(SL:GetConfig('cfg_string',22).text, 1, NoticeType.NoticeMid)--请先创建队伍
            return 
        end
        --local isFriend = SL:CheckIsFriend(self.rid)
        if self.role.roleInfoExt.unionId ~= 0 and self.role.roleInfoExt.unionId == SL:MeData_GetUnionId() then
            SL:ReqSendTeamInvitation(self.rid, 3)
        else
            SL:ReqSendTeamInvitation(self.rid)
        end
        self:CloseMe()
    end
end

--申请入队
function this:TeamReq()
    if self.role and self.role.roleInfoExt.teamId > 0 then
        SL:RequestApplyAgree(self.role.roleInfoExt.teamId)
        self:CloseMe()
    end
end

---升为队长
function this:BtnTeamLeader()
    SL:ReqChangeCaptain(self.rid)
    self:CloseMe()
end

---踢出队伍
function this:BtnTeamKickOff()
    SL:ReqKickOutMember(self.rid)
    self:CloseMe()
end

---离开队伍
function this:BtnLeaveTeam()
    SL:ReqQuitTeam()
    self:CloseMe()
end

---@param message UserProtos.OtherRoleInfoRes
function this:ResOtherRoleInfoMessage(id, message)
    self:HideAllButton()
    self.isHideMainPanel = false
    if message.type == 1 and self.rid == message.role.rid then 
        self.role = message.role
        self.name = message.role.name
        --角色基本信息  
        self:ShowPlayInfo(message.role)
        local rid = message.role.rid
        if self.uiType == 1 then
            --查看装备
            GUI:setVisible(self.view.BtnViewPlayer, true)
            --私聊
            GUI:SetActive(self.view.BtnPrivateChat,true)
            --黑名单
            local inBlack = SL:CheckIsInBlackList(rid)
            if inBlack then
                GUI:setVisible(self.view.BtnRemoveBlack, true)
            else
                GUI:setVisible(self.view.BtnAddBlack, true)
            end
            --好友
            local isFriend = SL:CheckIsFriend(rid)
            if isFriend then
                GUI:setVisible(self.view.BtnDelFriend, true)
            else
                --不是好友且不在黑名单，才显示添加好友
                if not inBlack then
                    GUI:setVisible(self.view.BtnAddFriend, true)
                end
            end
            --战盟
            local inUnion = not string.isNullOrEmpty(message.role.roleInfoExt.unionName)
            local meInUnion = not string.isNullOrEmpty(SL:GetMetaValue(EMetaVarGetKey.UNION_NAME))
            if inUnion then
                --对方已有战盟
                --GUI:setVisible(self.view.BtnUnionReq, true)
            elseif not inUnion and meInUnion then
                --对方无战盟 我有战盟 显示战盟邀请
                --GUI:setVisible(self.view.BtnUnionInvite, true)
            end
            --队伍
            local inTeam = message.role.roleInfoExt.teamId > 0
            local meInTeam = SL:MeData_GetTeamId() > 0
            if inTeam and not meInTeam then
                --对方已组队且我无队伍
                GUI:setVisible(self.view.BtnTeamReq, true)
            elseif meInTeam then
                if inTeam then
                    --对方有队伍且不是跟我同队
                    GUI:setVisible(self.view.BtnTeamInvite,  message.role.roleInfoExt.teamId ~=  SL:MeData_GetTeamId())
                else
                    --我有队伍皆显示邀请组队
                    GUI:setVisible(self.view.BtnTeamInvite, true)
                end
            end
            GUI:setVisible(self.view.btn_faceTrade, true)
        elseif self.uiType == 2 then
            self.isHideMainPanel = true
            local leaderId, teamId
            if self.isMe then
                leaderId = SL:TeamInfo_GetLeaderId()
                teamId = SL:TeamInfo_GetTeamId()
            elseif self.is_team then
                leaderId = self.role.leaderId
                teamId = self.role.teamId
            else
                teamId = message.role.roleInfoExt.teamId
                if teamId == SL:MeData_GetTeamId() and teamId ~= 0 then
                    leaderId = SL:TeamInfo_GetLeaderId()
                end
            end
            if SL:MeData_GetTeamId() > 0 then
                --是自己
                if self.rid == SL:GetMetaValue(EMetaVarGetKey.UID) then
                    GUI:SetActive(self.view.BtnLeaveTeam,true)
                    GUI:SetActive(self.view.reqPointButton,true)
                    return
                end
                if teamId == SL:MeData_GetTeamId() then
                    --队长点击队员
                    if leaderId and leaderId == SL:GetMetaValue(EMetaVarGetKey.UID) then
                        GUI:SetActive(self.view.BtnTeamKickOff,true)
                        GUI:SetActive(self.view.BtnTeamLeader,true)
                        GUI:SetActive(self.view.BtnPrivateChat,true)
                        GUI:SetActive(self.view.lockButton,true)
                        GUI:SetActive(self.view.selectPlayerButton,true)
                        return
                    else
                        GUI:SetActive(self.view.lockButton,true)
                        GUI:SetActive(self.view.selectPlayerButton,true)
                        GUI:SetActive(self.view.BtnPrivateChat,true)
                        return
                    end
                else
                    --不同队伍邀请玩家
                    GUI:SetActive(self.view.BtnTeamInvite,true)
                    GUI:SetActive(self.view.lockButton,true)
                    GUI:SetActive(self.view.BtnPrivateChat,true)
                    return
                end
            end

            self.otherPlayerTeamId = teamId
            GUI:SetActive(self.view.joinButton,teamId > 0)
            GUI:SetActive(self.view.lockButton,true)
            GUI:SetActive(self.view.BtnPrivateChat,true)
        elseif self.uiType == 3 then
            GUI:setVisible(self.view.BtnViewPlayer, true)
            -- GUI:setVisible(self.view.BtnFlowerSend, false)
        end
    end
end

---隐藏所有按钮
function this:HideAllButton()
    GUI:setVisible(self.view.BtnGrid, true)
    GUI:setVisible(self.view.BtnViewPlayer, false)
    GUI:setVisible(self.view.BtnUnionInvite, false)
    GUI:setVisible(self.view.BtnAddFriend, false)
    GUI:setVisible(self.view.BtnDelFriend, false)
    GUI:setVisible(self.view.BtnUnionReq, false)
    GUI:setVisible(self.view.BtnPrivateChat, false)
    GUI:setVisible(self.view.BtnAddBlack, false)
    GUI:setVisible(self.view.BtnRemoveBlack, false)
    GUI:setVisible(self.view.BtnTeamInvite, false)
    GUI:setVisible(self.view.BtnTeamReq, false)
    GUI:setVisible(self.view.BtnTeamLeader, false)
    GUI:setVisible(self.view.BtnTeamKickOff, false)
    GUI:setVisible(self.view.BtnLeaveTeam, false)
    GUI:setVisible(self.view.lockButton, false)
    GUI:setVisible(self.view.selectPlayerButton, false)
    GUI:setVisible(self.view.reqPointButton, false)
    GUI:setVisible(self.view.joinButton, false)
    GUI:setVisible(self.view.btn_faceTrade, false)
end

function this:Close()
end

return this

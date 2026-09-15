---@class KLUINearPlayerPanel:UIKmlLuaPanelBase
---@field view KLUINearPlayerPanelView
local KLUINearPlayerPanel = class(UIKmlLuaPanelBase)
local this =KLUINearPlayerPanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData( self.view.near_player_datalist,function()
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
    return #self.playerList
end

function this:ListItemGetFunc(realIndex)

end

function this:ListItemInitFunc(realIndex, kmlcontrol)

end

function this:ListItemUpdateFunc(realIndex, kmlcontrol)
    local player_info = self.playerList[realIndex + 1]
    local player_name = GUI:GetChildControl(self.view.near_player_datalist,realIndex,'player_name')
    local player_level = GUI:GetChildControl(self.view.near_player_datalist,realIndex,'player_level')
    local player_career = GUI:GetChildControl(self.view.near_player_datalist,realIndex,'player_career')
    local player_unionName = GUI:GetChildControl(self.view.near_player_datalist,realIndex,'player_unionName')
    local invite_btn = GUI:GetChildControl(self.view.near_player_datalist,realIndex,'invite_btn')
    local had_invite_btn = GUI:GetChildControl(self.view.near_player_datalist,realIndex,'had_invite_btn')
    GUI:Text_setString(player_name, player_info.roleInfo.name)
    GUI:Text_setString(player_level, "Lv." .. player_info.roleInfo.level)
    GUI:Text_setString(player_unionName, "无")
    if player_info.roleInfo.roleInfoExt and player_info.roleInfo.roleInfoExt.unionName and player_info.roleInfo.roleInfoExt.unionName ~= "" then
        GUI:Text_setString(player_unionName, player_info.roleInfo.roleInfoExt and player_info.roleInfo.roleInfoExt.unionName)
    end
   
    local career = player_info.roleInfo.career
    ---@type cfg_career_column[]
    local career_tbl = SL:GetConfigTable("cfg_career")
    for _, v in pairs(career_tbl) do
        if v.baseCareer == career.baseCareer and v.careerRank == career.careerRank then
            GUI:Text_setString(player_career, v.name)
            break
        end
    end
    if SL:TeamInfo_GetLeaderId() == SL:GetMetaValue(EMetaVarGetKey.UID) then
    
        if player_info.invitationState == 0 then
            GUI:SetActive(invite_btn, true)
            GUI:SetActive(had_invite_btn, false)
            GUI:AddOnClickEvent(invite_btn, self, self.InvitePlayer, { id = player_info.roleInfo.rid })
        else
            GUI:SetActive(invite_btn, false)
            GUI:SetActive(had_invite_btn, true)
        end
    else
        GUI:SetActive(invite_btn, true)
        GUI:SetActive(had_invite_btn, false)
        GUI:AddOnClickEvent(invite_btn, self, self.InvitePlayer, { id = player_info.roleInfo.rid })
    end
end

function this:InvitePlayer(_, eventData)
    local teamId = SL:TeamInfo_GetTeamId()
    local leaderId = SL:TeamInfo_GetLeaderId()
    if teamId > 0 then
        if leaderId == SL:GetMetaValue(EMetaVarGetKey.UID) then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TEAM_INVITE, {teamId = teamId, leaderId = leaderId , playerId = eventData.id})
            -- SL:ReqSendTeamInvitation(eventData.id,self.type)
        else
            SL:TipMessage(SL:GetConfig('cfg_string',297).text,1,NoticeType.NoticeMid )--您不是队长，不能邀请队员
        end
    else
        SL:TipMessage(SL:GetConfig('cfg_string',22).text,1,NoticeType.NoticeMid )--"请先创建队伍",
    end
    
    --SL:CommonTipsMessage({ showTips = "发送邀请成功" })
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.type = 1
    if self.args and self.args.myPlayerType then
        self.type = self.args.myPlayerType
    end
    
    local panel = GUI:GetUI("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    if panel then
        panel:SetTipText("当前未加入战盟")
    end
    if self.type == 3 then
        if SL:MeData_GetUnionId() ~= 0 then
            SL:ReqPlayerList(self.type)
        end
    else
        SL:ReqPlayerList(self.type)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(MessageDef.ResPlayerListMessage, self.ResPlayerListMessage, self)
end

---@param message TeamProto.PlayerList
function this:ResPlayerListMessage(_, message)
    if message then
        self.playerList = {}
        for i, v in ipairs(message.nearbyPlayer) do
            if v.roleInfo.rid ~= SL:GetMetaValue(EMetaVarGetKey.UID) then
                table.insert(self.playerList,v)
            end
        end
    end
    ---@type KLUITeamMainPanel
    local panel = GUI:GetUI("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    if panel then
        if #self.playerList == 0 then
            if self.type == 1 then
                panel:SetTipText("附近无其它玩家")
            elseif self.type == 2 then
                local friends = SL:GetFriendData(1)
                if table.count(friends) == 0 then
                    panel:SetTipText("当前未添加好友")
                else
                    panel:SetTipText("当前无好友在线")
                end
            elseif self.type == 3 then
                panel:SetTipText("战盟当前无玩家在线")
            end
        else
            panel:SetTipText("")
        end
    end
    GUI:DataListUpdateData(self.view.near_player_datalist)
end

function this:Close()
    local panel = GUI:GetUI("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    if panel then
        panel:SetTipText("")
    end
end

return this

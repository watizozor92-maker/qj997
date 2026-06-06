---@class KLUITeamWindowPanel:UIKmlLuaPanelBase
---@field view KLUITeamWindowPanelView
---@field KLUITeamHeadData TeamProto.TeamInfo
---@field selectItem KLUITeamHeadItem
local KLUITeamWindowPanel = class(UIKmlLuaPanelBase)
local this =KLUITeamWindowPanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.Members_list,function()
        return self:PlayerDataListItemCountFunc()
    end,function(realIndex)
        return self:PlayerDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:PlayerDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:PlayerDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.Members_list)

end

---创建或者刷新界面数据时调用
function this:Refresh()
    local teamInfo = SL:GetMetaValue(EMetaVarGetKey.TEAM_MEMBER_INFO)
    if table.isNullOrEmpty(teamInfo.teamMember) then
        self:TeamInfoChange(_,teamInfo)
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TEAM_EQUIP_INFO)
    end

    if self.args and self.args.x then
        GUI:setPositionX(self.view.root,self.args.x)
    end
    if self.args and self.args.y then
        GUI:setPositionY(self.view.root,self.args.y)
    end
    --self.view.tog_autoJoin:SetTogIsOn(SL:GetMetaValue(EMetaVarGetKey.GET_IS_AUTO_ACCEPT_TEAM_INVITATION))
    GUI:Toggle_setIsOn(self.view.tog_autoJoin,SL:GetMetaValue(EMetaVarGetKey.GET_IS_AUTO_ACCEPT_TEAM_INVITATION))
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.tog_autoJoin,self,self.AutoToggleChaneg)
    GUI:AddOnClickEvent(self.view.btn_createTeam, self, self.OnClickCreatTeam)
    GUI:AddOnClickEvent(self.view.btn_team, self, self.OnClickOpenTeamMainPanel,1)
    GUI:AddOnClickEvent(self.view.btn_joinTeam, self, self.OnClickOpenTeamMainPanel,2)
    GUI:AddOnClickEvent(self.view.btn_invitation, self, self.OnClickOpenTeamMainPanel,3)
    
    GUI:AddOnClickEvent(self.view.CloseSelectPlayerUIButton, self, self.CloseSelectPlayerUI)
    
    GUI:AddOnClickEvent(self.view.LockButton, self, self.OnClickSelectPlayerButton,1)
    GUI:AddOnClickEvent(self.view.ChatButton, self, self.OnClickSelectPlayerButton,2)
    GUI:AddOnClickEvent(self.view.KickButton, self, self.OnClickSelectPlayerButton,3)
    GUI:AddOnClickEvent(self.view.PromotedButton, self, self.OnClickSelectPlayerButton,4)
    GUI:AddOnClickEvent(self.view.SelectPlayerButton, self, self.OnClickSelectPlayerButton,5)
    GUI:AddOnClickEvent(self.view.ReqPointButton, self, self.OnClickSelectPlayerButton,6)
    GUI:AddOnClickEvent(self.view.LeaveTeamButton, self, self.OnClickSelectPlayerButton,7)

    SL:RegisterLUAEvent(LUA_EVENT_TEAM_INFO_CHANGE, self.TeamInfoChange,self)
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_PLAYER_HP_CHANGE, self.TeamInfoHpChange,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TEAM_EQUIP_INFO, self.TeamInfoChange, self)

    SL:RegisterLUAEvent(Event.CloseTeamTipsUI,self.CloseTeamTipsUI,self)
end

function this:OnClickSelectPlayerButton(_,eventData)
    if eventData == 1 then--查看装备
        --角色装备信息
        GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel", nil, nil, {
            isOther = true,
            rid = self.selectItem.data.roleInfo.rid,
            x = 0
        })
        SL.HideMainPanel()
    elseif eventData == 2 then--私聊
        SL:OpenChatUI({channel=8,rid=self.selectItem.data.roleInfo.rid,name=self.selectItem.data.roleInfo.name})
    elseif eventData == 3 then--踢出队伍
        SL:ReqKickOutMember(self.selectItem.data.roleInfo.rid)
    elseif eventData == 4 then--升为队长
        SL:ReqChangeCaptain(self.selectItem.data.roleInfo.rid)
    elseif eventData == 5 then--选中玩家
        SL:OpenBossHp(self.selectItem.data.roleInfo.rid)
    elseif eventData == 6 then--发送位置
        local x = SL:MeData_GetCoord().x
        local y = SL:MeData_GetCoord().z
        local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
        local line = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
        local posStr = string.format("pos@%s,%s,%s,%s@",x,y,mapId,line)
        SL:SendChat(7,posStr,nil,nil)
    elseif eventData == 7 then--离开队伍
        SL:ReqQuitTeam()
    end
    self:CloseSelectPlayerUI()
end

function this:CloseTeamTipsUI()
    if self.selectItem then
        self.selectItem:SetSelectImage(false)
    end
end

---邀请队员按钮是否显示
function this:InvitationButtonIsShow()
    local isShow = self.KLUITeamHeadData and self.KLUITeamHeadData.leaderId and self.KLUITeamHeadData.leaderId == SL:GetMetaValue(EMetaVarGetKey.UID)
    GUI:SetActive(self.view.btn_invitation,isShow)
    -- GUI:setPosition(self.view.btn_team,10,-87)
    --[[GUI:setPositionX(self.view.btn_team,10)
    if isShow then
        GUI:setPositionX(self.view.btn_team,60)
        -- GUI:setPosition(self.view.btn_team,60,-87)
    end]]
end

---队伍信息变化
---@param message TeamProto.TeamInfo
function this:TeamInfoChange(_,message)
    message = ToolFunc:tblkeytonumber(message)
    local isShowTeamUI = message and message.teamMember and table.count(message.teamMember) > 0
    GUI:SetActive(self.view.MemberPanel,isShowTeamUI)
    GUI:SetActive(self.view.NoMemberPanel,not isShowTeamUI)
    if message then
        self.KLUITeamHeadData = message
        GUI:DataListUpdateData(self.view.Members_list)
    end
    self:CloseSelectPlayerUI()
    self:InvitationButtonIsShow()
end

---队伍信息中血量变化
---@param message TeamProto.TeamMemberHpChangeRes
function this:TeamInfoHpChange(_,message)
    if self.KLUITeamHeadData and self.KLUITeamHeadData.teamMember then
        for i, v in pairs(self.KLUITeamHeadData.teamMember) do
            if v.roleInfo.rid == message.targetRid then
                v.hp = message.hp
                v.maxHp = message.maxHp
                break
            end
        end
    end
    GUI:DataListUpdateData(self.view.Members_list)
    self:InvitationButtonIsShow()
end

---创建队伍
function this:OnClickCreatTeam()
    SL:RequestCreateTeam()
end

---打开队伍界面
---@param data number @对应页签 1：我的队伍，2：附近队伍，3：附近玩家，4：申请列表
function this:OnClickOpenTeamMainPanel(control,data)
    GUI:UIPanel_Open("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel",_,_,{panelType = data})
end

function this:AutoToggleChaneg(_,customData,eventData)
    if eventData[1]==SL:GetMetaValue(EMetaVarGetKey.GET_IS_AUTO_ACCEPT_TEAM_INVITATION) then
        return
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_IS_AUTO_ACCEPT_TEAM_INVITATION,eventData[1])
end

function this:SelectTeamPlayer(control, eventData)
    if self.selectItem then
        self.selectItem:SetSelectImage(false)
        self.selectItem = nil
    end
    if eventData.data.roleInfo.roleInfoExt.teamId == SL:MeData_GetTeamId() then
        self.selectItem = eventData
        self.selectItem:SetSelectImage(true)
        --GUI:UIPanel_Open("dev/ui/Team/Panel/KLUITeamTips/KLUITeamTipsPanel",_,_,{onClickData = self.selectItem.data
        --,teamId = self.selectItem.data.roleInfo.roleInfoExt.teamId
        --,leaderId = self.selectItem.leaderId})
        --GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendOperate/KLFriendOperatePanel", nil, nil, {rid = self.selectItem.data.roleInfo.rid, roleInfo = self.selectItem.data.roleInfo, uiType = 2})
        self:OpenSelectPlayerUI()
    end
end

---隐藏所有选择玩家操作的按钮
function this:HideAllSelectPlayerButton()
    GUI:SetActive(self.view.LockButton, false)
    GUI:SetActive(self.view.ChatButton, false)
    GUI:SetActive(self.view.KickButton, false)
    GUI:SetActive(self.view.PromotedButton, false)
    GUI:SetActive(self.view.SelectPlayerButton, false)
    GUI:SetActive(self.view.ReqPointButton,false)
    GUI:SetActive(self.view.LeaveTeamButton,false)
end

---打开选择玩家界面
function this:OpenSelectPlayerUI()
    self:HideAllSelectPlayerButton()
    local leftUp = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
    if leftUp then
        GUI:SetActive(leftUp.view.expanfBg,false)
    end
    GUI:SetActive(self.view.go_playerPanelBg,true)
    local isLeader = self.KLUITeamHeadData and self.KLUITeamHeadData.leaderId and self.KLUITeamHeadData.leaderId == SL:GetMetaValue(EMetaVarGetKey.UID)
    local showBtnCount = 0
    ---玩家是队长
    if isLeader then
        if self.selectItem.data.roleInfo.rid == SL:GetMetaValue(EMetaVarGetKey.UID) then--玩家是队长点击自己
            --GUI:setContentSize(self.view.sp_playerPanelBg,123,103 + 14)
            -- GUI:setPosition(self.view.sp_playerPanelBg,0,-20)
            GUI:SetActive(self.view.ReqPointButton,true)
            GUI:SetActive(self.view.LeaveTeamButton,true)
            showBtnCount = 2
        else--玩家是队长点其他人
            --GUI:setContentSize(self.view.sp_playerPanelBg,123,240)
            -- GUI:setPosition(self.view.sp_playerPanelBg,0,-79)
            GUI:SetActive(self.view.LockButton, true)
            GUI:SetActive(self.view.ChatButton, true)
            GUI:SetActive(self.view.KickButton, true)
            GUI:SetActive(self.view.PromotedButton, true)
            GUI:SetActive(self.view.SelectPlayerButton, true)
            showBtnCount = 5
        end
    else--不是队长点其他人的操作
        if self.selectItem.data.roleInfo.rid == SL:GetMetaValue(EMetaVarGetKey.UID) then--点自己
            --GUI:setContentSize(self.view.sp_playerPanelBg,123,103+ 14)
            -- GUI:setPosition(self.view.sp_playerPanelBg,0,-20 )
            GUI:SetActive(self.view.ReqPointButton,true)
            GUI:SetActive(self.view.LeaveTeamButton,true)
            showBtnCount = 2
        else
            
            -- GUI:setPosition(self.view.sp_playerPanelBg,0,-38)
            GUI:SetActive(self.view.LockButton, true)
            GUI:SetActive(self.view.ChatButton, true)
            GUI:SetActive(self.view.SelectPlayerButton, true)
            showBtnCount = 3
        end
    end
    GUI:setContentSize(self.view.sp_playerPanelBg,123,5 + showBtnCount * 43)
    GUI:SetActive(self.view.go_playerPanelBg,true)
end

---关闭选择玩家界面
function this:CloseSelectPlayerUI()
    self:CloseTeamTipsUI()
    --[[local leftUp = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
    if leftUp then
        GUI:SetActive(leftUp.view.expanfBg,true)
    end]]
    GUI:SetActive(self.view.go_playerPanelBg,false)
end

----------------------队伍人员--------------------------
function this:PlayerDataListItemCountFunc()
    if self.KLUITeamHeadData and self.KLUITeamHeadData.teamMember then
        return #self.KLUITeamHeadData.teamMember
    end
    return 0
end

function this:PlayerDataListItemGetFunc(realIndex)
    ---@type KLUITeamHeadItem
    local item = GUI:UIPanel_Open("dev/ui/Team/Item/KLUITeamHead/KLUITeamHeadItem", self.view.Members_list, self, nil, true)
    if not self.PlayerItem then
        ---@type table<KingML.KmlControl,KLUITeamHeadItem>
        self.PlayerItem = {}
    end
    local kmlCtrl = item.view.root
    GUI:AddOnClickEvent(item.view.KLUITeamHeadButton,self,self.SelectTeamPlayer,item)
    self.PlayerItem[kmlCtrl] = item
    return kmlCtrl
end

function this:PlayerDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:PlayerDataListItemUpdateFunc(realIndex, kmlcontrol)
    local item = self.PlayerItem[kmlcontrol]

    local luaIndex = realIndex + 1
    local data = self.KLUITeamHeadData.teamMember[luaIndex]
    item:ShowInfo(data,self.KLUITeamHeadData.leaderId)
end
-----------------------------------------------------

function this:Close()
    --[[local leftUp = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
    if leftUp then
        GUI:SetActive(leftUp.view.expanfBg,true)
    end]]
    if self.PlayerItem then
        for i, v in pairs(self.PlayerItem) do
            GUI:UIPanel_Close(nil,v)
        end  
    end
    
end

return this

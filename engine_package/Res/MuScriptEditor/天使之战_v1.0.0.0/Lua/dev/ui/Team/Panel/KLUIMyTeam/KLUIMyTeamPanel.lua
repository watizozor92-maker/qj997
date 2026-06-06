---@class KLUIMyTeamPanel:UIKmlLuaPanelBase
---@field view KLUIMyTeamPanelView
---@field ActiveLvDataList table<number,cfg_rep_column> @组队等级信息
local KLUIMyTeamPanel = class(UIKmlLuaPanelBase)
local this =KLUIMyTeamPanel
---创建时调用一次
function this:Init()
    self:GetActiveAndLvInfo()
    ---选择的活动id
    self.selectActiveId = 0
    ---选择的组队等级id
    self.selectActiveLvId = 0
    self.ActiveLvDataList = {}
    self.maxTeamNum = SL:GetMetaValue(EMetaVarGetKey.TEAM_MAC_COUNT) or 5
    self.roleModelList = {}
    GUI:DataListInitData( self.view.team_datalist,function()
        return self:ListItemCountFunc()
    end,function(realIndex)
        return self:ListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListInitData( self.view.ActivityDataList,function()
        return self:ActivityDataListItemCountFunc()
    end,function(realIndex)
        return self:ActivityDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ActivityDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ActivityDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListInitData(self.view.TeamLvDataList,function()
        return self:TeamLvDataListItemCountFunc()
    end,function(realIndex)
        return self:TeamLvDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:TeamLvDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:TeamLvDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    -- GUI:SetOnPrefabControlLoaded(self.view.cutArea_left, function()
    --     self:SetCutAreaRect(self.view.cutArea_left)
    -- end)
    -- GUI:SetOnPrefabControlLoaded(self.view.cutArea_right, function()
    --     self:SetCutAreaRect(self.view.cutArea_right)
    -- end)
end

function this:SetCutAreaRect(curArea)
    local trans = GUI:GetRectTransform(curArea):GetChild(0)
    trans.localScale = Vector3.New(40, 1, 50)
end

function this:GetActiveAndLvInfo()
    ---@type cfg_global_column
    local activeCfgStr = SL:GetConfig("cfg_global",49)
    ---活动id列表
    self.ActiveIDList = {}
    table.insert(self.ActiveIDList,0)
    local idStrList = string.split(activeCfgStr.value,'#')
    for i, v in ipairs(idStrList) do
        if SL:HasConfig("cfg_activity_rule",tonumber(v)) then
            table.insert(self.ActiveIDList,tonumber(v))
        end
    end
end

function this:ListItemCountFunc()
    if self.teamInfo and self.teamInfo.teamId > 0 and self.teamInfo.leaderId ~= SL:GetMetaValue(EMetaVarGetKey.UID) then
        return table.count(self.teamInfo.teamMember)
    else
        return self.maxTeamNum
    end
end

function this:ListItemGetFunc(realIndex)

end

function this:ListItemInitFunc(realIndex, kmlcontrol)

end

function this:ListItemUpdateFunc(realIndex, kmlcontrol)
    local player_btn = GUI:GetChildControl(self.view.team_datalist,realIndex,'player_btn')
    local team_none_btn = GUI:GetChildControl(self.view.team_datalist,realIndex,'team_none_btn')
    if self.teamInfo then
        local teamMember = self.teamInfo.teamMember[tostring(realIndex + 1)]
        if teamMember then
            teamMember.roleInfo.teamId = self.teamInfo.teamId
            teamMember.roleInfo.leaderId = self.teamInfo.leaderId
            teamMember.roleInfo.hp = teamMember.hp
            teamMember.roleInfo.maxHp = teamMember.maxHp
            GUI:SetActive(player_btn, true)
            GUI:SetActive(team_none_btn, false)
            local leader_img = GUI:GetChildControl(self.view.team_datalist,realIndex,'leader_img')
            local player_name = GUI:GetChildControl(self.view.team_datalist,realIndex,'player_name')
            local player_level = GUI:GetChildControl(self.view.team_datalist,realIndex,'player_level')
            local player_map_line = GUI:GetChildControl(self.view.team_datalist,realIndex,'player_map_line')
            local titleModel = GUI:GetChildControl(self.view.team_datalist,realIndex,'titleModel')
            --local player_role = GUI:GetChildControl(self.view.team_datalist,realIndex,'player_role')

            if self.teamInfo.leaderId == teamMember.roleInfo.rid then
                GUI:SetActive(leader_img, true)
            else
                GUI:SetActive(leader_img, false)
            end
            GUI:Text_setString(player_name, teamMember.roleInfo.name)
            GUI:Text_setString(player_level, "Lv." .. tostring(teamMember.roleInfo.level))
            GUI:SetZIndex(player_name, 202)
            GUI:SetZIndex(player_level, 202)
            GUI:SetZIndex(player_map_line, 202)
            ---@type cfg_map_info_column
            local mapInfo = SL:GetConfig("cfg_map_info", teamMember.mapId)
            GUI:Text_setString(player_map_line, mapInfo.mapname .. "-" .. teamMember.mapLine .. "线")
            --[[local model_list, equip_list = self:GetPlayerRoleInfo(teamMember.roleInfo)
            GUI:SetPlayerRoleInfo(player_role, model_list, equip_list)]]
            if self.roleModelList[realIndex + 1] then
                SL:UIModel_Recycle(self.roleModelList[realIndex + 1])
                self.roleModelList[realIndex + 1] = nil
            end
            self.roleModelList[realIndex + 1] = self:ShowUIRole(teamMember.roleInfo, titleModel)
            GUI:AddOnClickEvent(player_btn, self, self.ShowPlayerInfo, { onClickData = teamMember, teamId = self.teamInfo.teamId, leaderId = self.teamInfo.leaderId })
        else
            GUI:SetActive(player_btn, false)
            GUI:SetActive(team_none_btn, true)
            GUI:AddOnClickEvent(team_none_btn, self, self.OpenKLUINearPlayerPanel, self.args.basePanel)
        end
    else
        GUI:SetActive(player_btn, false)
        GUI:SetActive(team_none_btn, true)
        GUI:AddOnClickEvent(team_none_btn, self, self.OpenKLUINearPlayerPanel, self.args.basePanel)
    end
end

------------------------------------------参与活动----------------------------------------------------------
function this:ActivityDataListItemCountFunc()
    return #self.ActiveIDList
end

function this:ActivityDataListItemGetFunc(realIndex)

end

function this:ActivityDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:ActivityDataListItemUpdateFunc(realIndex, kmlcontrol)
    local activeId = self.ActiveIDList[realIndex + 1]
    local _btn = GUI:GetChildControl(self.view.ActivityDataList,realIndex,'ActivityData_Item')
    local btnStr = "无"
    if activeId > 0 then
        ---@type cfg_activity_rule_column
        local cfg = SL:GetConfig("cfg_activity_rule",activeId)
        btnStr = cfg.name
    end
    GUI:Button_setTitleText(_btn,btnStr)
    self:SetImgSelectTexture(_btn,activeId == self.selectActiveId)
    if activeId == self.selectActiveId then
        self.selectActiveItem = _btn
        GUI:Text_setString(self.view.Activity_Text,btnStr)
        self:GetNowLvCopyLvData()
    end
    GUI:AddOnClickEvent(_btn, self, self.OnClickActiveID,{activeId,btnStr,_btn})
end

------------------------------------------------------------------------------------------------

------------------------------------------组队等级----------------------------------------------------------
function this:TeamLvDataListItemCountFunc()
    return #self.ActiveLvDataList
end

function this:TeamLvDataListItemGetFunc(realIndex)

end

function this:TeamLvDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:TeamLvDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.ActiveLvDataList[realIndex + 1]
    local _btn = GUI:GetChildControl(self.view.TeamLvDataList,realIndex,'TeamLvData_Item')
    local btnName = self:GetCopyLvName(data)
    GUI:Button_setTitleText(_btn,btnName)
    self:SetImgSelectTexture(_btn,data.id == self.selectActiveLvId)
    if data.id == self.selectActiveLvId then
        self.selectActiveLvItem = _btn
        GUI:Text_setString(self.view.TeamLv_Text,btnName)
    end
    GUI:AddOnClickEvent(_btn, self, self.OnClickActiveLv,{data.id,btnName,_btn})
end
------------------------------------------------------------------------------------------------

---选择活动id
function this:OnClickActiveID(_, eventData)
    self:CloseGridViewUI()
    if not self.teamInfo then
        if eventData[1] ~= 0 then
            SL:TipMessage(SL:GetConfig('cfg_string',459).text,  1, NoticeType.NoticeMid )--"请先创建队伍",
        end
        return
    end
    if not self.isMyLeader then
        if eventData[1] ~= 0 then
            SL:TipMessage(SL:GetConfig('cfg_string',460).text,  1, NoticeType.NoticeMid )--"仅队长可进行喊话",
        end
        return
    end
    if self.selectActiveId == eventData[1] then
        return
    end
    if self.selectActiveItem then
        self:SetImgSelectTexture(self.selectActiveItem,false)
        self.selectActiveItem = nil
    end
    self.selectActiveItem = eventData[3]
    self.selectActiveId = eventData[1]
    self:SetImgSelectTexture(self.selectActiveItem,true)
    GUI:Text_setString(self.view.Activity_Text,eventData[2])
    self.selectActiveLvId = 0
    self:GetNowLvCopyLvData()
end

---选择活动等级
function this:OnClickActiveLv(_, eventData)
    self:CloseGridViewUI()
    if not self.isMyLeader then
        if eventData[1] ~= 0 then
            SL:TipMessage(SL:GetConfig('cfg_string',460).text,  1, NoticeType.NoticeMid )--"仅队长可进行喊话",
        end
        return
    end
    if self.selectActiveLvId == eventData[1] then
        return
    end
    if self.selectActiveLvItem then
        self:SetImgSelectTexture(self.selectActiveLvItem,false)
        self.selectActiveLvItem = nil
    end
    self.selectActiveLvItem = eventData[3]
    self.selectActiveLvId = eventData[1]
    self:SetImgSelectTexture(self.selectActiveLvItem,true)
    GUI:Text_setString(self.view.TeamLv_Text,eventData[2])
end

---设置选择图片Texture
function this:SetImgSelectTexture(Control,isSelect)
    if isSelect then
        GUI:Button_loadTextureNormal(Control,"select2","Atlas/FG_Team.spriteatlas")
    else
        GUI:Button_loadTextureNormal(Control,"no_select","Atlas/FG_Team.spriteatlas")
    end
end

---获取当前等级的副本等级数据
function this:GetNowLvCopyLvData()
    self.ActiveLvDataList = {}
    --self.selectActiveLvId = 0
    table.insert(self.ActiveLvDataList,{id = 0})
    if self.selectActiveId > 0 then
        local myLv = SL:MeData_GetLevel()
        local cfg = SL:GetConfigTable("cfg_rep")
        local oldCfgData = nil
        ---@param v cfg_rep_column
        for i, v in pairs(cfg) do
            if v.type == self.selectActiveId then
                if self.copyMinLevel and self.copyMinLevel > 0
                        and self.copyMaxLevel and self.copyMaxLevel > 0
                        and self.copyMinLevel == v.level[1] and self.copyMaxLevel == v.level[2] then
                    --self.selectActiveLvId = v.id
                    table.insert(self.ActiveLvDataList,v)
                    break
                end
                if self.isMyLeader and v.level[1] <= myLv and v.level[2] >= myLv then
                    --[[if oldCfgData then
                        table.insert(self.ActiveLvDataList,oldCfgData)
                    end--]]
                    table.insert(self.ActiveLvDataList,v)
                end
                --oldCfgData = v
            end
        end
        table.sort(self.ActiveLvDataList,function(a, b)
            return a.id < b.id
        end)
    end
    
    if #self.ActiveLvDataList > 0 then
        if self.selectActiveLvId == 0 then
            self.selectActiveLvId = self.ActiveLvDataList[1].id
        end
        GUI:DataListUpdateData(self.view.TeamLvDataList)
    end
end

---获取副本等级名字
---@param cfg cfg_rep_column
function this:GetCopyLvName(cfg)
    if cfg.id == 0 then
        return "无"
    end
    return cfg.name[1]
end

function this:ShowPlayerInfo(_, eventData)
    GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendOperate/KLFriendOperatePanel", nil, nil, {rid = eventData.onClickData.roleInfo.rid, roleInfo = eventData.onClickData.roleInfo, uiType = 2, isHideMainUI = true,isTeam=true})
end

function this:OpenKLUINearPlayerPanel(_, eventData)
    if SL:TeamInfo_GetTeamId() > 0 then
        ---@class KLUITeamMainPanel
        eventData:TeamToggleChange(nil, 3)
        eventData:SetToggleDefault(3)
    else
        SL:TipMessage(SL:GetConfig('cfg_string',22).text,1,NoticeType.NoticeMid)--请先创建队伍
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local panel = GUI:GetUI("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    if panel then
        panel:SetTipText("")
    end
    --SL:ReqTeamInfo()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TEAM_EQUIP_INFO)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --SL:RegisterLuaNetMsg(MessageDef.ResTeamInfoMessage, self.ResTeamInfoMessage, self)
    --SL:RegisterLUAEvent(LUA_EVENT_TEAM_INFO_CHANGE, self.LUA_EVENT_TEAM_INFO_CHANGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TEAM_EQUIP_INFO, self.RES_TEAM_EQUIP_INFO, self)
    SL:RegisterTrigger(LUA_TRIGGER_SET_STREAM, self.LUA_TRIGGER_SET_STREAM, self)
    
    GUI:AddOnClickEvent(self.view.createteambtn, self, self.CreateTeam)
    GUI:AddOnClickEvent(self.view.leaveteambtn, self, self.LeaveTeam)
    
    GUI:AddOnClickEvent(self.view.Activity_Button, self, self.ShowActiveSelectUI)
    GUI:AddOnClickEvent(self.view.Activity_Button2, self, self.ShowActiveSelectUI)
    GUI:AddOnClickEvent(self.view.TeamLv_Button, self, self.ShowTeamLvSelectUI)
    GUI:AddOnClickEvent(self.view.TeamLv_Button2, self, self.ShowTeamLvSelectUI)
    GUI:AddOnClickEvent(self.view.closeGridviewButton, self, self.CloseGridViewUI)
    GUI:AddOnClickEvent(self.view.ShoutingButton, self, self.OnClickShouting)
    GUI:AddOnClickEvent(self.view.des_btn, self, function()
        local helpCfg = SL:GetConfig("cfg_rule_text", 8, "id")
        if helpCfg then
            SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
        end
    end)
    --SL:RegisterLuaNetMsg(2000015,self.CopyInfoChange,self)
    --SL:RegisterLuaNetMsg(1000010,self.CopyInfoChange,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.TEAM_RECRUIT_CHANGE,self.CopyInfoChange,self)
end

---一键喊话
function this:OnClickShouting()
    --[[if self.selectActiveId == 0 then
        SL:TipMessage({"未选择参与活动",1,NoticeType.NoticeMid})
        return
    end
    if self.selectActiveId > 0 and self.selectActiveLvId == 0 then
        SL:TipMessage({"未选择组队等级",1,NoticeType.NoticeMid})
        return
    end
    --local cfg = SL:GetConfig("cfg_rep",self.selectActiveLvId)
    --]]
    SL:SendLuaNetMsg(LuaMessageIdToSever.RECRUIT_INFO_REQ, {id=self.selectActiveLvId,channel=5})
end

---关闭所有下拉框
function this:CloseGridViewUI()
    GUI:SetActive(self.view.closeGridviewButton,false)
    GUI:SetActive(self.view.Activity_Gridview,false)
    GUI:SetActive(self.view.TeamLv_Gridview,false)
end

---活动下拉框显示
function this:ShowActiveSelectUI()
    if GUI:getVisible(self.view.TeamLv_Gridview) then
        GUI:SetActive(self.view.TeamLv_Gridview,false)
    end
    GUI:SetActive(self.view.closeGridviewButton,not GUI:getVisible(self.view.Activity_Gridview))
    GUI:SetActive(self.view.Activity_Gridview,not GUI:getVisible(self.view.Activity_Gridview))
    GUI:SetZIndex(self.view.Activity_Gridview, 203)
end

---组队等级下拉框显示
function this:ShowTeamLvSelectUI()
    if GUI:getVisible(self.view.Activity_Gridview) then
        GUI:SetActive(self.view.Activity_Gridview,false)
    end
    if not self.ActiveLvDataList or #self.ActiveLvDataList == 0 then
        return
    end
    GUI:SetActive(self.view.closeGridviewButton,not GUI:getVisible(self.view.TeamLv_Gridview))
    GUI:SetActive(self.view.TeamLv_Gridview,not GUI:getVisible(self.view.TeamLv_Gridview))
    GUI:SetZIndex(self.view.TeamLv_Gridview, 203)
end

function this:CreateTeam()
    SL:RequestCreateTeam()
end

function this:LeaveTeam()
    SL:DelBubbleTips(15)
    SL:ReqQuitTeam()
end

---副本信息改变
function this:CopyInfoChange(_,message)
    self.selectActiveId = 0
    self.copyMinLevel = 0
    self.copyMaxLevel = 0
    if message then
        if message["activeid"] and message["activeid"] > 0 then
            ---@type cfg_rep_column
            self.selectActiveId = SL:GetConfig("cfg_rep",message["activeid"]).type
            self.selectActiveLvId = message["activeid"]
        end
        self.copyMinLevel = message["lowerlevel"] and message["lowerlevel"] or 0
        self.copyMaxLevel = message["upperlevel"] and message["upperlevel"] or 0
    end
    GUI:DataListUpdateData(self.view.ActivityDataList)
end

---@param message TeamProto.TeamInfo
function this:LUA_EVENT_TEAM_INFO_CHANGE(_, message)
    self.teamInfo = nil
    if message and message.teamId > 0 then
        self.teamInfo = message
    end
    if self.teamInfo and self.teamInfo.teamId > 0 then
        GUI:SetActive(self.view.createteambtn,false)
        GUI:SetActive(self.view.leaveteambtn,true)

        --SL:SendLuaNetMsg(2000015)
        SL:SendLuaNetMsg(LuaMessageIdToSever.GET_TEAM_RECRUIT)
    else
        GUI:SetActive(self.view.createteambtn,true)
        GUI:SetActive(self.view.leaveteambtn,false)

        self:CopyInfoChange()
    end
    ---玩家自己是否是队长
    self.isMyLeader = message and message.teamId > 0 and message.leaderId == SL:GetMetaValue(EMetaVarGetKey.UID)
    
    GUI:SetActive(self.view.ShoutingButton,self.isMyLeader)
    GUI:DataListUpdateData(self.view.team_datalist)
end

function this:RES_TEAM_EQUIP_INFO(_, message)
    self.teamInfo = nil
    if message and message.teamId > 0 then
        self.teamInfo = message
    end
    
    if self.teamInfo and self.teamInfo.teamId > 0 then
        GUI:SetActive(self.view.createteambtn,false)
        GUI:SetActive(self.view.leaveteambtn,true)

        --SL:SendLuaNetMsg(2000015)
        SL:SendLuaNetMsg(LuaMessageIdToSever.GET_TEAM_RECRUIT)
    else
        GUI:SetActive(self.view.createteambtn,true)
        GUI:SetActive(self.view.leaveteambtn,false)

        self:CopyInfoChange()
    end
    
    ---玩家自己是否是队长
    self.isMyLeader = message and message.teamId > 0 and message.leaderId == SL:GetMetaValue(EMetaVarGetKey.UID)

    GUI:SetActive(self.view.ShoutingButton,self.isMyLeader)

    self:CloseTimer()
    self.timer = SL:ScheduleOnce(Time.deltaTime,function()
        if self.roleModelList then
            for _, v in pairs(self.roleModelList) do
                SL:UIModel_Recycle(v)
            end
        end
        self.roleModelList = {}
        GUI:DataListUpdateData(self.view.team_datalist)
    end)
end

function this:CloseTimer()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

function this:LUA_TRIGGER_SET_STREAM(go, roleId, itemCfgId, strengthLevel)
    if self.teamInfo == nil then
        return
    end
    if not self.tempEquipInfo then
        self.tempEquipInfo = {}
    end
    self.tempEquipInfo.cfgId = itemCfgId
    for _, v in pairs(self.teamInfo.teamMember) do
        if v.roleInfo.rid == roleId then
            for _, k in pairs(v.roleInfo.roleInfoExt.equip) do
                if k.cfgId == itemCfgId then
                    strengthLevel = k.strengthlv
                    break
                end
            end
            if strengthLevel > 0 then
                break
            end
        end
    end
    local liuGuangId = EquipFunc.GetEquipLiuGuangId(self.tempEquipInfo, strengthLevel)
    SL:SetMetaValue(EMetaVarSetKey.EQUIP_STREAMER_REFRESH, go, liuGuangId)
end

---@param data UserProtos.RoleInfo
function this:GetPlayerRoleInfo(data)
    local role_param = { "body", "head", "head1", "armor", "hand", "pants", "boot" }
    local wear_list_str = ""
    local model_list_str = ""
    local equipInfo = data.roleInfoExt.equip
    --[[local luaData = json.decode(data.roleInfoExt.equip[1].gmExtInfo.luaExt)
    local strengthLv = luaData.strengthLv]]
    if equipInfo then
        local default_tbl = SL:GetConfig("cfg_model_default", data.career.baseCareer)
        local model_list = {}
        for _, v in pairs(role_param) do
            model_list[v] = default_tbl[v]
        end
        --修复背了两把短剑只显示一把
        local lastSub2Id = {}
        local hasSuitBody
        local isWeaponLspineParent = false
        for _, v in ipairs(equipInfo) do
            ---@type cfg_item_column
            local itemInfo = SL:GetConfig("cfg_item", v.cfgId)
            local wearBar, pos = SL:GetWearBarAndPosBaseEquipIndex(v.index)
            if itemInfo and itemInfo.type == E_ItemType.Equip then
                if itemInfo.subType == E_ItemSubType_Equip.MainWeapon then
                    if not lastSub2Id[itemInfo.subType] then
                        if wear_list_str == "" then
                            wear_list_str = "WeaponRspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponRspineParent#" .. itemInfo.field[1]
                        end
                        lastSub2Id[itemInfo.subType] = v.cfgId
                    end
                elseif itemInfo.subType == E_ItemSubType_Equip.SecWeapon then
                    if not lastSub2Id[itemInfo.subType] then
                        if wear_list_str == "" then
                            wear_list_str = "WeaponLspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponLspineParent#" .. itemInfo.field[1]
                        end
                        lastSub2Id[itemInfo.subType] = v.cfgId
                    end

                elseif itemInfo.subType == E_ItemSubType_Equip.MainSecWeapon then
                    if not lastSub2Id[itemInfo.subType] then
                        if wear_list_str == "" then
                            wear_list_str = "WeaponRspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponRspineParent#" .. itemInfo.field[1]
                        end
                        lastSub2Id[itemInfo.subType] = v.cfgId
                    else
                        if not isWeaponLspineParent then
                            isWeaponLspineParent = true
                            if wear_list_str == "" then
                                wear_list_str = "WeaponLspineParent#" .. itemInfo.field[1]
                            else
                                wear_list_str = wear_list_str .. ",WeaponLspineParent#" .. itemInfo.field[1]
                            end
                        end
                    end

                elseif itemInfo.subType == 13 then
                    if wear_list_str == "" then
                        wear_list_str = "Wing#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",Wing#" .. itemInfo.field[1]
                    end
                elseif itemInfo.subType == 30 then
                    if wear_list_str == "" then
                        wear_list_str = "BuffspineParent#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",BuffspineParent#" .. itemInfo.field[1]
                    end
                elseif itemInfo.subType == E_ItemSubType_Equip.SuitBody then

                    hasSuitBody = true
                    model_list.head = nil
                    model_list.armor = nil
                    model_list.hand = nil
                    model_list.pants = nil
                    model_list.boot = nil

                    for i = 1, #itemInfo.field do
                        local point
                        ---@type cfg_model_charactor_column
                        local model_tbl = SL:GetConfig("cfg_model_charactor", itemInfo.field[i])
                        if model_tbl then
                            if model_tbl.part == 23 then
                                point = "body"
                            elseif model_tbl.part == 11 then
                                point = "head"
                            elseif model_tbl.part == 2 then
                                point = "armor"
                            elseif model_tbl.part == 9 then
                                point = "hand"
                            elseif model_tbl.part == 15 then
                                point = "pants"
                            elseif model_tbl.part == 5 then
                                point = "boot"
                            end
                            if point then
                                model_list[point] = itemInfo.field[i]
                            end
                        end
                    end
                else
                    local point = ""
                    ---@type cfg_model_charactor_column
                    local model_tbl = SL:GetConfig("cfg_model_charactor", itemInfo.field[1])
                    if model_tbl then
                        if model_tbl.part == 23 then
                            point = "body"
                        elseif model_tbl.part == 11 then
                            if itemInfo.subType == E_ItemSubType_Equip.MianJin then
                                point = "head1"
                            else
                                if not hasSuitBody then
                                    point = "head"
                                end
                            end
                        elseif model_tbl.part == 2 then
                            point = "armor"
                        elseif model_tbl.part == 9 then
                            point = "hand"
                        elseif model_tbl.part == 15 then
                            point = "pants"
                        elseif model_tbl.part == 5 then
                            point = "boot"
                        end
                        if point ~= "" then
                            model_list[point] = itemInfo.field[1]
                        end
                    end
                end
            end
        end
        for _, v in pairs(model_list) do
            if model_list_str == "" then
                model_list_str = v
            else
                model_list_str = model_list_str .. "#" .. v
            end
        end
    end
    return model_list_str, wear_list_str
end

---@param data UserProtos.RoleInfo
function this:ShowUIRole(data, parent)
    local equipInfo = data.roleInfoExt.equip
    local equip = {}
    local equipShowIdx = {}
    local roleAppear = {}
    local mountId = 0
    if equipInfo then
        local temp = {}
        for i, v in pairs(equipInfo) do
            temp[tonumber(i)] = v
        end
        for k, v in pairs(temp) do
            local itemCfg = SL:GetConfig("cfg_item", v.cfgId)
            local intensify = v.strengthlv
            local itemInfo = {
                cfgId = v.cfgId,
                durability = 0,
                gmExtInfo = {
                    field = 0,
                    luaExt = string.format("{\"strengthlv\":%d}", intensify),
                    shape = 0,
                    sweepLevel = 0,
                },
                id = 0,
                index = (1 << 16) | (itemCfg.strPart[1] & 0xFF),
                modelExtInfo = {
                    feedLevel = 0,
                    grade = 1,
                    strengthLevel = intensify
                },
                luaExtData = string.format("{\"strengthlv\":%d}", intensify),
            }
            table.insert(equip, itemInfo)
            table.insert(equipShowIdx, k)
            table.insert(roleAppear, { cfgId = v.cfgId, pos = itemCfg.strPart[1] })
            if itemCfg.type == E_ItemType.Equip and itemCfg.subType == E_ItemSubType_Equip.Mount then
                mountId = SL:GetConfigMultiKeys("cfg_mount", SL:GetItemBindCfgId(v.cfgId), "itemId").id
            end
        end
    end
    local roleInfoExtData = InfoManager.cardShapeShiftInfo:DeepCopy(data.roleInfoExt)
    roleInfoExtData.equip = equip
    roleInfoExtData.equipShowIdx = equipShowIdx
    roleInfoExtData.roleAppear = roleAppear
    return SL:UIModel_Create(GUI:GetRectTransform(parent),data.rid,
            data.career, data.level, data.name,
            mountId, EAction.Stand, EBehaviourType_Stand.Stand, roleInfoExtData,
            0,-154,-70,130,
            0, 30,0)
end

function this:Close()
    self:CloseTimer()
    if self.roleModelList then
        for _, v in pairs(self.roleModelList) do
            SL:UIModel_Recycle(v)
        end
    end
end

return this

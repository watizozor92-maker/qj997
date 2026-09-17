---@class KLUIPlayerInfoPanel:UIKmlLuaPanelBase
---@field view KLUIPlayerInfoPanelView
---@field exprienceTmeplateList table
---@field buffInfoTemplateList table
---@field KLUIBuffInfoListPanel KLUIBuffInfoListPanel
local KLUIPlayerInfoPanel = class(UIKmlLuaPanelBase)

local PkModeToSrc = {
    [EPKMode_Out.AllAttack] = 'btn_atk_all',
    [EPKMode_Out.Peace] = 'btn_atk_peace',
    [EPKMode_Out.Team] = 'btn_atk_team',
    [EPKMode_Out.Union] = 'btn_atk_union',
    [EPKMode_Out.Attack] = 'btn_atk_LoranAtk',
    [EPKMode_Out.Defend] = 'btn_atk_LoranDefen',
}
---创建时调用一次
function KLUIPlayerInfoPanel:Init()
    SL:KeepOpenPanel("KLUIPlayerInfoPanel",true)
    local _, rootMinY = GUI:GetOffsetMin(self.view.root)
    local _, rootMaxY = GUI:GetOffsetMax(self.view.root)
    local _, sliderMinY = GUI:GetOffsetMin(self.view.sliderExperience)
    local _, sliderMaxY = GUI:GetOffsetMax(self.view.sliderExperience)
    -- local _, leftBgMinY = GUI:GetOffsetMin(self.view.leftBg)
    -- local _, leftBgMaxY = GUI:GetOffsetMax(self.view.leftBg)
    GUI:SetOffsetMin(self.view.root,0,rootMinY)
    GUI:SetOffsetMax(self.view.root,0,rootMaxY)
--[[    GUI:SetOffsetMin(self.view.sliderExperience,0,sliderMinY)
    GUI:SetOffsetMax(self.view.sliderExperience,0,sliderMaxY)]]
    -- GUI:SetOffsetMin(self.view.leftBg,-7.5,leftBgMinY)
    -- GUI:SetOffsetMax(self.view.leftBg,7.5,leftBgMaxY)
    self.experienceTemplateList = {}
    self.buffInfoTemplateList = {}
    self.buffInfoList = {}
    self.freeBuffInfo = {}
    self.pkModeTemplateList = {}
    -- local tbl = SL:GetConfigTable("cfg_free_buff")
    if false then
        ---@param v cfg_free_buff_column
        for i, v in pairs(tbl) do
            if v.showType == 1 then
                self.freeBuffInfo[v.id] = v
            end
        end
    end

    self.level = SL:GetMetaValue("LEVEL")
    self:RefreshFastItem()
    self.expEffects = TablePool()
    GUI:setScaleX(self.view.hpTxt, 0.65)
    GUI:setScaleY(self.view.hpTxt, 0.65)
    GUI:setScaleX(self.view.mpTxt, 0.65)
    GUI:setScaleY(self.view.mpTxt, 0.65)
    GUI:setScaleX(self.view.sdTxt, 0.65)
    GUI:setScaleY(self.view.sdTxt, 0.65)
    GUI:setScaleX(self.view.shieldTxt, 0.65)
    GUI:setScaleY(self.view.shieldTxt, 0.65)

end

---创建或者刷新界面数据时调用
function KLUIPlayerInfoPanel:Refresh()
    self:Clear()
    self:RefreshPlayerHp()
    self:RefreshPlayerMp()
    self:RefreshPlayerLevel()
    self:RefreshExperienceAdd()
    self:RefreshShield()
    self:RefreshAgsto()
    self:InitPKMode()
    self:RefreshComboSkillValue()
    self:RefreshTotalExpGain()
    local power = SL:GetMetaValue(EMetaVarGetKey.BATTERY)
    GUI:SetLoadingbar_startper(self.view.sliderPower, power)
    self.timer = SL:Schedule(self.timer,0, 30, -1, function()
        local power = SL:GetMetaValue(EMetaVarGetKey.BATTERY)
        GUI:SetLoadingbar_startper(self.view.sliderPower, power)
    end)
    if Global.LianJiOpenState then
        GUI:setVisible(self.view.lianJiToggle, true)
        GUI:Toggle_setIsOn(self.view.lianJiToggle, Global.LianJiAutoState == 1)
    else
        GUI:setVisible(self.view.lianJiToggle, false)
    end
    self:RefreshAtt()
--[[    self.MonthTime = SL:Schedule(self.MonthTime,0, 1, -1, function()

        if InfoManager.monthCardInfo:IsHaveDayTime() then
            ---小于1天 大于0时才显示
            GUI:SetActive(self.view.MonthCardBtn, true)
        else
            GUI:SetActive(self.view.MonthCardBtn, false)
        end

    end)

    local index = 1
    self.UIWeekTime = SL:Schedule(self.UIWeekTime,0, 0.2, -1, function()
        if InfoManager.monthCardInfo:IsHaveDayTime() then
            ---闪烁
            if index <= 0.2 then
                index = 1
            end
            index = index - 0.15
            GUI:SetImageAlpha(self.view.MonthCardBtn, 1, 1, 1, index)
        end

    end)]]

    if InfoManager.skillInfo.InitBuffList then
        for _,v in pairs(InfoManager.skillInfo.InitBuffList) do
            self:RefreshBuff(_,v)
        end
    end
    self:LUA_EVENT_BAG_CHANGE_AFTER()
    self:roleBtnRed()
    GUI:DataListUpdateData(self.view.fast_data_list)
    local mapName = SL:GetMetaValue(EMetaVarGetKey.MAP_NAME)
    local mapLine = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    ---@type cfg_map_info_column
    local mapInfo = SL:GetConfig("cfg_map_info", SL:GetMetaValue(EMetaVarGetKey.MAP_ID))
    if mapInfo and mapInfo.nopositionmove == 0 then
        GUI:Text_setString(self.view.txt_mapname,string.format("%s<color=#E6E600>[%s线]</color>",mapName,mapLine))
    else
        GUI:Text_setString(self.view.txt_mapname,string.format("%s",mapName))
    end
    self:OnPlayerMapPosChange()

end

---注册UI事件和服务器消息
function KLUIPlayerInfoPanel:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE, self)--主角等级改变事件
    SL:RegisterLUAEvent(LUA_EVENT_EXPCHANGE, self.OnExpUpdate, self)--主角经验改变事件
    SL:RegisterLUAEvent(LUA_EVENT_HPCHANGE, self.RefreshPlayerHp, self)--主角血量改变事件
    SL:RegisterLUAEvent(LUA_EVENT_SHIELDCHANGE, self.RefreshShield, self)--主角护盾值改变事件
    SL:RegisterLUAEvent(LUA_EVENT_MPCHANGE, self.RefreshPlayerMp, self)--主角蓝量改变事件
    SL:RegisterLUAEvent(LUA_EVENT_AGSTOCHANGE, self.RefreshAgsto, self)--主角技能值改变事件
    --SL:RegisterLUAEvent(LUA_EVENT_BUFFCHANHE, self.RefreshBuff, self)--主角buff改变事件
    --SL:RegisterLUAEvent(LUA_EVENT_FREEBUFFCHANHE, self.RefreshFreeBuff, self)--主角免费buff改变事件
    SL:RegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE, self.LUA_EVENT_PKMODE_CHANGE, self)--战斗模式切换
    SL:RegisterLUAEvent(LUA_EVENT_SWITCH_PKMODE, self.LUA_EVENT_SWITCH_PKMODE, self)--战斗模式切换
    SL:RegisterLUAEvent(LUA_EVENT_CROSS_SERVER_PK_MODE, self.LUA_EVENT_CROSS_SERVER_PK_MODE, self)---跨服战斗模式切换
    SL:RegisterLUAEvent(LUA_EVENT_COMBOSKILL_PROGRESS, self.LUA_EVENT_COMBOSKILL_PROGRESS, self)
    SL:RegisterLUAEvent(LUA_EVENT_INIT_SHORT_CUT, self.InitShortcutAfter, self)
    SL:RegisterLUAEvent(LUA_EVENT_SELECT_ROLE, self.SelectAttackRole, self)
    SL:RegisterLUAEvent(LUA_EVENT_RESET_ATTACK_ROLE, self.ResetAttackRole, self)
    SL:RegisterLUAEvent(LUA_EVENT_PRIVILEGE_INFO_CHANGE, self.LUA_EVENT_PRIVILEGE_INFO_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_EXPERIENCE_ADD_CHANGE, self.LUA_EVENT_EXPERIENCE_ADD_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_DIE, self.LUA_EVENT_MAIN_PLAYER_DIE, self)
    SL:RegisterLUAEvent(LUA_EVENT_GUARD_FAST_ITEM_CHANGE, self.LUA_EVENT_GUARD_FAST_ITEM_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE,self.RefreshAtt,self)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SHORTCUTS_INFO, self.RES_SHORTCUTS_INFO, self)

    SL:RegisterLuaNetMsg(MessageDef.ResBagChangeMessage, self.ResBagChangeMessage,self)
    SL:RegisterLUAEvent(Event.BagInfo_Change, self.BagInfo_Change, self)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, self.LUA_EVENT_CLOSEWIN, self)

    GUI:AddOnClickEvent(self.view.buffMenufoldBtn, self, self.OnClickBuffMenufoldBtn)
    GUI:AddOnClickEvent(self.view.buffMenuexpandBtn, self, self.OnClickBuffMenuexpandBtn)
    GUI:AddOnClickEvent(self.view.atkModelMenuBtn, self, self.OnClickAtkModelMenuToggle)
    GUI:AddOnClickEvent(self.view.Btn_AtkModeCloseMask, self, self.Btn_AtkModeCloseMaskOnClick)
    GUI:AddOnClickEvent(self.view.Btn_TeamWindowCloseMask, self, self.Btn_KLUITeamWindowCloseMaskOnClick)

    GUI:AddOnClickEvent(self.view.experienceMenufoldBtn, self, self.OnClickexperienceMenufoldBtn)
    GUI:AddOnClickEvent(self.view.experienceMenuexpandBtn, self, self.OnClickexperienceMenuexpandBtn)

    GUI:AddOnClickEvent(self.view.sliderSd, self, self.OnClickSdBtn)
    GUI:AddOnClickEvent(self.view.sliderShield, self, self.OnClickShieldBtn)
    GUI:AddOnClickEvent(self.view.experienceList, self, self.OnClickexperienceMenufoldBtn)

    GUI:AddOnClickEvent(self.view.tog_role, self, self.OpenRole)
    GUI:AddOnClickEvent(self.view.tog_bag, self, self.OpenBag)
    GUI:AddOnClickEvent(self.view.tog_friend, self, self.OpenFriend)
    GUI:AddOnClickEvent(self.view.tog_masterTalent, self, self.OpenMasterTalent)
    GUI:AddOnClickEvent(self.view.tog_skill, self, self.OpenSkill)
    GUI:AddOnClickEvent(self.view.tog_mail, self, self.OpenMail)
    GUI:AddOnClickEvent(self.view.tog_union, self, self.OpenUnion)
    GUI:AddOnClickEvent(self.view.tog_setting, self, self.OpenSetting)
    GUI:AddOnClickEvent(self.view.tog_shop, self, self.OpenShop)
    GUI:AddOnClickEvent(self.view.btn_team, self, self.OpenTeam)
    
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE, self.LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE, self)
    --GUI:AddOnClickEvent(self.view.MonthCardBtn, self, self.MonthCardBtn)
    SL:RegisterLUAEvent(LUA_EVENT_LIANJI_AUTO_DATACHANGE, self.RefreshLianJiBtn, self)
    GUI:AddOnClickEvent(self.view.lianJiToggle, self, self.AutoComboOnToggleValueChange)
    SL:RegisterLUAEvent(LUA_EVENT_CAREER_CHANGED, self.LUA_EVENT_CAREER_CHANGED, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, self.roleBtnRed, self)    

    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE,self.OnPlayerMapPosChange,self)
end

function KLUIPlayerInfoPanel:OnPlayerMapPosChange()   
    local pos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
    GUI:Text_setString(self.view.txt_coord,pos.x..","..pos.z)
end

function KLUIPlayerInfoPanel:roleBtnRed()
    ---@type cfg_redDot_new_column
    local cfg = SL:GetConfig("cfg_redDot_new",116)
    if cfg then
        if SL:CheckCalculateConditionGroup(cfg.condition) then
            GUI:setVisible(self.view.icon_AttrPoint, true)
        else
            GUI:setVisible(self.view.icon_AttrPoint, false)
        end
    end
end

function KLUIPlayerInfoPanel:AutoComboOnToggleValueChange(control,  data)
    SL:SendLuaNetMsg(LuaMessageIdToSever.LianJi_MsgID, {2})
end

--连击按钮逻辑
function KLUIPlayerInfoPanel:RefreshLianJiBtn()
    GUI:setVisible(self.view.lianJiToggle, Global.LianJiOpenState)
    if Global.LianJiAutoState == 0 then
        GUI:Image_loadTexture(self.view.lianJiToggle,"UI_zy_lianji","Atlas/UIMainPanel_Out.spriteatlas")
    else
        GUI:Image_loadTexture(self.view.lianJiToggle,"UI_zy_lianji1","Atlas/UIMainPanel_Out.spriteatlas")
    end
end
function KLUIPlayerInfoPanel:OpenRole(_, type, isClick)
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Role,"id")
    -- if isClick[1] then
        SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
        self.nowSys = self.view.tog_role
    -- else

    --     GUI:UIPanel_Close(tbl.command)
    --     SL:onLUAEvent(LUA_EVENT_CLOSEWIN,tbl.systemId)
    -- end
    if self.last_open_tab and self.last_open_tab.systemId ~= tbl.systemId then
        GUI:UIPanel_Close(self.last_open_tab.command)
        SL:onLUAEvent(LUA_EVENT_CLOSEWIN,self.last_open_tab.systemId)
    end
    self.last_open_tab = tbl
end
function KLUIPlayerInfoPanel:OpenBag(_, type, isClick)
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Bag,"id")
    -- if isClick[1] then
        SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
        self.nowSys = self.view.tog_bag
    -- else
    --     local params = string.split(tbl.command, '#')
    --     GUI:UIPanel_Close(params[1])
    --     SL:onLUAEvent(LUA_EVENT_CLOSEWIN,tbl.systemId)
    -- end
    if self.last_open_tab and self.last_open_tab.systemId ~= tbl.systemId then
        GUI:UIPanel_Close(self.last_open_tab.command)
        SL:onLUAEvent(LUA_EVENT_CLOSEWIN,self.last_open_tab.systemId)
    end
    self.last_open_tab = tbl
end


function KLUIPlayerInfoPanel:OpenMasterTalent(_, type, isClick)
      ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Trade,"id")
    -- if isClick[1] then
        SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
        self.nowSys = self.view.tog_masterTalent
    -- else
    --     local params = string.split(tbl.command, '#')
    --     GUI:UIPanel_Close(params[1])
    --     SL:onLUAEvent(LUA_EVENT_CLOSEWIN,tbl.systemId)
    -- end
    if self.last_open_tab and self.last_open_tab.systemId ~= tbl.systemId then
        GUI:UIPanel_Close(self.last_open_tab.command)
        SL:onLUAEvent(LUA_EVENT_CLOSEWIN,self.last_open_tab.systemId)
    end
    self.last_open_tab = tbl
end

function KLUIPlayerInfoPanel:OpenFriend(_, type, isClick)
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Friend,"id")
    SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
    self.nowSys = self.view.tog_friend
    if self.last_open_tab and self.last_open_tab.systemId ~= tbl.systemId then
        GUI:UIPanel_Close(self.last_open_tab.command)
        SL:onLUAEvent(LUA_EVENT_CLOSEWIN,self.last_open_tab.systemId)
    end
    self.last_open_tab = tbl
end

function KLUIPlayerInfoPanel:OpenMail(_, type, isClick)
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Mail,"id")
    SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
    self.nowSys = self.view.tog_mail
    if self.last_open_tab and self.last_open_tab.systemId ~= tbl.systemId then
        GUI:UIPanel_Close(self.last_open_tab.command)
        SL:onLUAEvent(LUA_EVENT_CLOSEWIN,self.last_open_tab.systemId)
    end
    self.last_open_tab = tbl
end

function KLUIPlayerInfoPanel:OpenUnion(_, type, isClick)
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Union,"id")
    SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
    self.nowSys = self.view.tog_union
    if self.last_open_tab and self.last_open_tab.systemId ~= tbl.systemId then
        GUI:UIPanel_Close(self.last_open_tab.command)
        SL:onLUAEvent(LUA_EVENT_CLOSEWIN,self.last_open_tab.systemId)
    end
    self.last_open_tab = tbl
end

function KLUIPlayerInfoPanel:OpenSkill(_, type, isClick)
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Skill,"id")
    -- if isClick[1] then
        SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
        self.nowSys = self.view.tog_skill
    -- else
    --         local params = string.split(tbl.command, '#')
    --     GUI:UIPanel_Close(params[1])
    --     SL:onLUAEvent(LUA_EVENT_CLOSEWIN,tbl.systemId)
    --     GUI:UIPanel_Close("dev/ui/Bag/Panel/KLSkillBag/KLSkillBagPanel")
    -- end
    if self.last_open_tab and self.last_open_tab.systemId ~= tbl.systemId then
        GUI:UIPanel_Close(self.last_open_tab.command)
        SL:onLUAEvent(LUA_EVENT_CLOSEWIN,self.last_open_tab.systemId)
    end
    self.last_open_tab = tbl
end

function KLUIPlayerInfoPanel:OpenSetting(_, type, isClick)
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.System,"id")
    -- if isClick[1] then
        SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
        self.nowSys = self.view.tog_setting
    -- else
    --     local params = string.split(tbl.command, '#')
    --     GUI:UIPanel_Close(params[1])
    --     SL:onLUAEvent(LUA_EVENT_CLOSEWIN,tbl.systemId)
    -- end
    if self.last_open_tab and self.last_open_tab.systemId ~= tbl.systemId then
        GUI:UIPanel_Close(self.last_open_tab.command)
        SL:onLUAEvent(LUA_EVENT_CLOSEWIN,self.last_open_tab.systemId)
    end
    self.last_open_tab = tbl
end

function KLUIPlayerInfoPanel:OpenShop(_, type, isClick)
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Shop,"id")
    SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
    self.nowSys = self.view.tog_shop
    if self.last_open_tab and self.last_open_tab.systemId ~= tbl.systemId then
        GUI:UIPanel_Close(self.last_open_tab.command)
        SL:onLUAEvent(LUA_EVENT_CLOSEWIN,self.last_open_tab.systemId)
    end
    self.last_open_tab = tbl
end
local clickCount = 0
function KLUIPlayerInfoPanel:OpenTeam(_, type, isClick)
    clickCount = clickCount + 1
    if clickCount == 1 then
        GUI:UIPanel_Open("dev/ui/Team/Panel/KLUITeamWindow/KLUITeamWindowPanel",self.view.teamObjRoot,nil,{parentview = self})
        GUI:setVisible(self.view.TeamWindowClosePanel, true)
    elseif clickCount >= 2 then
        GUI:UIPanel_Open("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
        --关闭组队页面
        GUI:setVisible(self.view.TeamWindowClosePanel, false)
        clickCount = 0
        GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamWindow/KLUITeamWindowPanel")
    end
end

function KLUIPlayerInfoPanel:LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE()
    -- if self.nowSys then
    --     GUI:Toggle_setIsOn(self.nowSys, false)
    -- end
    self.nowSys = nil
    self.last_open_tab = nil
end

--[[function KLUIPlayerInfoPanel:MonthCardBtn()
    local desc = "您的月卡剩余时间小于24小时,交易行交易税将\n提升至20%,是否购买增加月卡时间?"
    GUI:UIPanel_Open("dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel", nil, nil,
            { showTips = desc,
              callback = self.btnCall, callbackData = nil, ui = self })

end]]
function KLUIPlayerInfoPanel:btnCall(callbackData)
    GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
end
function KLUIPlayerInfoPanel:RefreshFastItem()
    local fastItemList = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    self.fastData = table.copyFrom({},fastItemList)
    if not SL:HasConfig("cfg_item",self.fastData[1]) then
        self.fastData[1] = InfoManager.mainUIInfo.mpShowModeItemId
    end
    if not SL:HasConfig("cfg_item",self.fastData[2]) then
        self.fastData[2] = InfoManager.mainUIInfo.hpShowModeItemId
    end
    if InfoManager.mainUIInfo.guardId then
        self.fastData[5] = InfoManager.mainUIInfo.guardId
    end
    self.fastData_all_item = {}
    GUI:DataListInitData(self.view.fast_data_list, function()
        return self:FastDataListItemCountFunc()
    end, function(realIndex)
        return self:FastDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:FastDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:FastDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.fast_data_list)
end

--经验值变化回调
function KLUIPlayerInfoPanel:OnExpUpdate()
    self:RefreshPlayerLevel()
    if self.effectTimer then
        SL:UnSchedule(self.effectTimer) 
        self.effectTimer = nil
    end
    self.effectTimer = SL:ScheduleOnce(0.5, function()
        local x,y,z = GUI:GetWorldPosition(self.view.sliderExperience_ballEndPos)
        local effect = self:GetExpBallEffect()
        SL:UIEffectDoMove(effect, Vector3.New(x,y,z), 0.8, function()
            if not IsNil(effect.modelParent) then
                effect.modelParent:SetActive(false)
                self.expEffects:Push(effect)
            end
        end)
    end)
end

function KLUIPlayerInfoPanel:LUA_EVENT_LEVELCHANGE()
    self:RefreshPlayerLevel()
    self:RefreshExperienceAdd()
    SL:RefreshPanelALLRedStateKmlByCondition("checkSkillCanLearn")
end

--刷新等级
---@param data RoleChangeData
function KLUIPlayerInfoPanel:RefreshPlayerLevel(data)
    local tbl = SL:GetConfig("cfg_global", 10000, "id")
    local level = SL:GetMetaValue("LEVEL")
    if tbl and self.level ~= level and level == tonumber(tbl.value) then
        --GUI:DataListUpdateData(self.view.fast_data_list)
    end
    self:OnClickexperienceMenufoldBtn()
    self:RefreshPlayerExp()
end

--刷新经验加成
function KLUIPlayerInfoPanel:RefreshExperienceAdd()
    local expriencePercent = 0
    local freeBuffList = InfoManager.mainUIInfo.experienceAddInfoList
    local t = {}
    if freeBuffList then
        table.copyFrom(t,freeBuffList) 
    end
    table.sort(t,function(a, b)
        if a.type > b.type then
            return true
        end
        return false
    end)
    local level = SL:GetMetaValue("LEVEL")
    for i, v in pairs(t) do
        if v.needLevel <= level then
            ---@type KLUIExperienceItem
            local exprienceTmeplate = self.experienceTemplateList[v.type]
            if not exprienceTmeplate then
                exprienceTmeplate = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLUIExperience/KLUIExperienceItem", self.view.experience_list, self, v, true)
                self.experienceTemplateList[v.type] = exprienceTmeplate
            else
                exprienceTmeplate.args = v
                exprienceTmeplate:Refresh()
            end

            if v.endTime > Time.GetServerTime() or v.endTime <=0 then
                expriencePercent = expriencePercent + v.exp
            end
            if v.endTime > Time.GetServerTime() then
                self:UpdateBuff(0,v)
            else
                self:UpdateBuff(1,v)
            end
            if v.lastCfgId ~= 0 and v.lastCfgId ~= v.cfgId then
                self:UpdateBuff(1,{cfgId =v.lastCfgId})
                if InfoManager.mainUIInfo.experienceAddInfoList[v.type] then
                    InfoManager.mainUIInfo.experienceAddInfoList[v.type].lastCfgId = 0
                end
            end 
        end
    end
    GUI:setVisible(self.view.arrow1, #self.experienceTemplateList > 0)
    GUI:Text_setString(self.view.allExperienceTxt, expriencePercent .. "%")
end

--刷新经验条
function KLUIPlayerInfoPanel:RefreshPlayerExp()

    ---@type MeData
    local level = SL:GetMetaValue("LEVEL")
    local name = SL:GetCurServerName()
    local exp = SL:GetMetaValue("EXP")
    local expandExp = SL:GetMetaValue("EXPANDEXP")
    local lvTbl = SL:GetConfig("cfg_level", level, "id")
    local precent = (exp + expandExp) / lvTbl.exp
    local str = string.format("%.2f", precent * 100)
    local percent_ = precent
    if precent >= 1 then
        str = 100.0
        percent_ = 1
    end
    if Mathf.IsNan(percent_) then
        percent_ = 1
    end

    if SL:HasConfig("cfg_level", level + 1, "id") then
        str = "<color=#ADAEAD>" .. str .. "%</color>"
    else
        str = " "
        precent = 1
    end
    precent = math.floor(precent * 100)
    --GUI:Text_setString(self.view.experiencePercentage,  str)
    --GUI:Text_setString(self.view.level, str.." 等级"..level)
    --GUI:Text_setString(self.view.level, "等级 "..level)
    --GUI:Text_setString(self.view.txt_server, "["..name.."]")
    GUI:SetLoadingbar_startper(self.view.sliderExperience, precent)
    --设置经验球飞行的终点坐标
    local width = SL:GetMetaValue(EMetaVarGetKey.SCREEN_WIDTH)
    local endX = width * percent_
    local pos = GUI:GetAnchoredPosition(self.view.sliderExperience_ballEndPos)
    pos.x = endX
    --self.view.sliderExperience_ballEndPos.rectTransform.anchoredPosition = pos
    GUI:SetAnchoredPosition(self.view.sliderExperience_ballEndPos, pos)
end

--刷新血条
---@param data RoleChangeData
function KLUIPlayerInfoPanel:RefreshPlayerHp(data)
    ---@type MeData
    local hp = SL:GetMetaValue("HP")
    local maxHp = SL:GetMetaValue("MAXHP")
    local precent = hp / maxHp
    precent = math.floor(precent * 100)
    GUI:Text_setString(self.view.hpTxt, tostring(math.floor(hp)))
    GUI:SetLoadingbar_startper(self.view.sliderHp, precent)
end
--刷新蓝条
---@param data RoleChangeData
function KLUIPlayerInfoPanel:RefreshPlayerMp(data)
    ---@type MeData
    local mp = SL:GetMetaValue("MP")
    local maxMp = SL:GetMetaValue("MAXMP")
    local precent = mp / maxMp
    precent = math.floor(precent * 100)
    GUI:Text_setString(self.view.mpTxt, tostring(math.floor(mp)))
    GUI:SetLoadingbar_startper(self.view.sliderMp, precent)
end
--刷新护盾值
---@param data RoleChangeData
function KLUIPlayerInfoPanel:RefreshShield(data)
    ---@type MeData
--[[    local shield = SL:GetMetaValue("SHIELD")
    local maxShield = SL:GetMetaValue("MAXSHIELD")]]

    local shield = Global.CurSD
    local maxShield = Global.MaxSD
    if maxShield ~= 0 and maxShield ~= nil then
        local precent = shield / maxShield
        precent = math.floor(precent * 100)
        --GUI:Text_setString(self.view.sdTxt, tostring(precent).."%")
        GUI:Text_setString(self.view.sdTxt, tostring(math.floor(shield)))
        GUI:SetLoadingbar_startper(self.view.sliderSd, precent)
    end
    GUI:setVisible(self.view.sdContainer, maxShield ~= 0)
end
--刷新技能值
---@param data RoleChangeData
function KLUIPlayerInfoPanel:RefreshAgsto(data)
    ---@type MeData
--[[    local agsto = SL:GetMetaValue("AGSTO")
    local maxAgsto = SL:GetMetaValue("MAXAGSTO")]]

    local agsto = Global.CurAG
    local maxAgsto = Global.MaxAG
    if maxAgsto ~= 0 and maxAgsto ~= nil then
        local precent = agsto / maxAgsto
        precent = math.floor(precent * 100)
        --GUI:Text_setString(self.view.shieldTxt, tostring(precent).."%")
        GUI:Text_setString(self.view.shieldTxt, tostring(math.floor(agsto)))
        GUI:SetLoadingbar_startper(self.view.sliderShield, precent)
    end
    GUI:setVisible(self.view.shieldContainer, maxAgsto ~= 0)
end
--刷新buff
---@param eventId number
---@param eventData BuffChangeData
function KLUIPlayerInfoPanel:RefreshBuff(eventId, eventData)
    --logError("接收="..eventData.buff.cfgId)
    if not eventData then
        return
    end
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    if eventData.roleId and rid ~= tostring(eventData.roleId) then
        return
    end
    --0:Add 1:Remove 2:Update
    if string.isNullOrEmpty(eventData.buff.buffTbl.showIcon) then
        -- 图标为空不显示
        return
    end
    ---@type cfg_buff_column
    local buffTbl =  SL:GetConfig("cfg_buff",eventData.buff.cfgId)
    local totalTime = eventData.buff.serverBuff and eventData.buff.serverBuff.totalTime or buffTbl.buffTotalTime
    self:UpdateBuff(eventData.updateType,{cfgId = eventData.buff.cfgId,totalTime=totalTime,endTime = eventData.buff.endTime,buffText=eventData.buff.buffText,bufferLayer = eventData.buff.layers})
end

function KLUIPlayerInfoPanel:UpdateBuff(updateType,data)
    if updateType == 0 and table.count(self.buffInfoTemplateList) < 4 then
        --添加
        self:AddOrRemoveBuff(data,true)
        ---@type KLBuffInfoItem
        local buffInfoTemplateItem = self.buffInfoTemplateList[data.cfgId]
        if not buffInfoTemplateItem then
            buffInfoTemplateItem = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLBuffInfo/KLBuffInfoItem", self.view.buffs_list, self, data, true)
            self.buffInfoTemplateList[data.cfgId] = buffInfoTemplateItem
        else
            buffInfoTemplateItem.args = data
            buffInfoTemplateItem:Refresh()
        end

    elseif updateType == 1 then
        --移除
        ---@type KLBuffInfoItem
        local buffInfoTemplateItem = self.buffInfoTemplateList[data.cfgId]
        if buffInfoTemplateItem then
            GUI:UIPanel_Close(nil, buffInfoTemplateItem)
        end
        self.buffInfoTemplateList[data.cfgId] = nil
        self:AddOrRemoveBuff(data,false)

        --有移除的后要把原来隐藏的buff显示出来
        for i, v in ipairs(self.buffInfoList) do
            if not self.buffInfoTemplateList[v.cfgId] and table.count(self.buffInfoTemplateList) < 4 then
                buffInfoTemplateItem = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLBuffInfo/KLBuffInfoItem", self.view.buffs_list, self, v, true)
                self.buffInfoTemplateList[v.cfgId] = buffInfoTemplateItem
            end
        end
    elseif updateType == 2 then
        --更新
        ---@type KLBuffInfoItem
        local buffInfoTemplateItem = self.buffInfoTemplateList[data.cfgId]
        if buffInfoTemplateItem then
            buffInfoTemplateItem.args = data
            buffInfoTemplateItem:Refresh()
        end
        self:AddOrRemoveBuff(data,true)
    end
    if table.count(self.buffInfoTemplateList) >= 4 then
        GUI:setVisible(self.view.buffMenuBtn, true)
        if data.cfgId ~= 0 and updateType == 0 then
            self:AddOrRemoveBuff(data,true)
        end
    else
        --GUI:setVisible(self.view.buffMenuBtn, false)
        --GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
    end
    local panel =  GUI:GetUI("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
    if panel then
        panel.args = self.buffInfoList
        panel:Refresh()
    end
end

function KLUIPlayerInfoPanel:InitPKMode()
    if not table.isNullOrEmpty(self.pkModeTemplateList) then
        ---@param pkModeTemplate KLPkItem
        for i, pkModeTemplate in pairs(self.pkModeTemplateList) do
            GUI:UIPanel_Close(nil, pkModeTemplate)
        end
    end

    self.pkModeTemplateList = {}
    local pkInfo = { 0, 1, 4, 5 }
    for i, pkMode in pairs(pkInfo) do
        local pkTemplateItem = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLPk/KLPkItem", self.view.atkModelMenu, self, { pkMode = pkMode, pkName = PkModeToSrc[pkMode] }, true)
        table.insert(self.pkModeTemplateList, pkTemplateItem)
    end
    local pkMode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
    self:LUA_EVENT_PKMODE_CHANGE(_, pkMode)
    --local count = table.count(self.pkModeTemplateList) - 1
    --GUI:setContentSize(self.view.AtkModePanel, GUI:GetControlWidth(self.view.AtkModePanel), count * 34)
end

---刷新pk模式item显隐
function KLUIPlayerInfoPanel:RefreshPKModeItem()
    if InfoManager.loranSiegeInfo:IsMap() then
        SL:TipMessage(SL:GetConfig('cfg_string', 69001).text, 1, NoticeType.NoticeMid)
        return
    end
    GUI:setVisible(self.view.AtkModePanel, true)
    GUI:setVisible(self.view.AtkModeClosePanel, true)
    local pkMode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
    for _, v in pairs(self.pkModeTemplateList) do
        if v.args.pkMode == pkMode then
            v:SetHide(false)
        else
            v:SetHide(true)
        end
    end
end

function KLUIPlayerInfoPanel:LUA_EVENT_PKMODE_CHANGE(_, pkMode)
    --GUI:Button_setTitleText(self.view.atkModelname, EPKModeToUI_Out[pkMode] or "")

    --GUI:Image_loadTexture(self.view.atkModelMenuBtn, PkModeToSrc[pkMode].."1","Atlas/UIMainPanel_Out.spriteatlas")
    GUI:Image_loadTexture(self.view.atkModelMenuBtn, PkModeToSrc[pkMode],"Atlas/NewMainPanel.spriteatlas")
    self:Btn_AtkModeCloseMaskOnClick()
end

function KLUIPlayerInfoPanel:LUA_EVENT_SWITCH_PKMODE(_, pkMode)
    self:Btn_AtkModeCloseMaskOnClick()
    local curr_pkMode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
    if curr_pkMode == EPKMode.Camp then
        SL:TipMessage("当前地图无法切换pk模式", 1, NoticeType.NoticeMid)
        return
    end
    if curr_pkMode == EPKMode_Out.Camp_out then
        SL:TipMessage("当前地图无法切换pk模式", 1, NoticeType.NoticeMid)
        return
    end
    if GlobalLuaEventManager.isCrossServer and GlobalLuaEventManager.isCrossServer == 1 then
        if not SL:MeData_GetUnionId() or SL:MeData_GetUnionId() == 0 then
            if pkMode ~= 0 then
                SL:TipMessage("当前地图无法切换pk模式", 1, NoticeType.NoticeMid)
                return
            end
        else
            if pkMode ~= 5 then
                SL:TipMessage("当前地图无法切换pk模式", 1, NoticeType.NoticeMid)
                return
            end
        end
    end
    if InfoManager.loranSiegeInfo:IsMap() then
        SL:TipMessage(SL:GetConfig('cfg_string', 69001).text, 1, NoticeType.NoticeMid)
        return
    end
    local tip = SL:GetMetaValue(EMetaVarGetKey.PKMODE_CAN_USE, pkMode)
    if not string.isNullOrEmpty(tip) then
        SL:TipMessage(tip, 1, NoticeType.NoticeMid)
        return
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, pkMode)
end

function KLUIPlayerInfoPanel:LUA_EVENT_CROSS_SERVER_PK_MODE(_, pkMode)
    if GUI:getVisible(self.view.Img_AtkModeBg) then
        self:RefreshPKModeItem()
    end
    --SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, pkMode)
end

function KLUIPlayerInfoPanel:RefreshComboSkillValue()
    local comboSkillId = SL:GetComboSkillId()
    if comboSkillId and comboSkillId > 0 then
        --RoleManager.me.skillEngine.skillCombo:SetSkillAutoReleaseSwitch(true)
        SL:Skill_SetSkillAutoReleaseSwitch(true)
    end
    self:LUA_EVENT_COMBOSKILL_PROGRESS(_, 0)
end

function KLUIPlayerInfoPanel:RefreshTotalExpGain()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_MONTH_PRIVILEGE_DATA)
    --SL:SendLuaNetMsg(LuaMessageIdToSever.TRIPLE_INCOME_PANEL)
end

---@param comboValue number  -2,隐藏 -1,显示0 其他,正常显示
function KLUIPlayerInfoPanel:LUA_EVENT_COMBOSKILL_PROGRESS(_, comboValue)
    local value, _ = math.modf(comboValue)
    if value >= 100 then
        value = 100
    end
--[[    GUI:Text_setString(self.view.shieldTxt, tostring(value) .. "%")
    GUI:SetLoadingbar_startper(self.view.sliderShield, value)]]
    self.comboValue = value
    SL:onLUAEvent(LUA_EVENT_COMBOVALUE_CHANGE, value)
end

function KLUIPlayerInfoPanel:OnClickBuffMenufoldBtn()
    --GUI:setVisible(self.view.buffMenufoldBtn, false)
    GUI:setVisible(self.view.buffMenuexpandBtn, true)
    local panel =  GUI:GetUI("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
    if not panel then
        panel = GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel", nil, nil, self.buffInfoList)
    else
        panel.args = self.buffInfoList
        panel:Refresh()
    end
end

function KLUIPlayerInfoPanel:OnClickBuffMenuexpandBtn()
    --GUI:setVisible(self.view.buffMenufoldBtn, true)
    GUI:setVisible(self.view.buffMenuexpandBtn, false)
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
end

function KLUIPlayerInfoPanel:OnClickAtkModelMenuToggle()
    self:RefreshPKModeItem()
end

function KLUIPlayerInfoPanel:Btn_KLUITeamWindowCloseMaskOnClick()
    --关闭组队页面
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamWindow/KLUITeamWindowPanel")
    clickCount = 0
    GUI:setVisible(self.view.TeamWindowClosePanel, false)
end

function KLUIPlayerInfoPanel:Btn_AtkModeCloseMaskOnClick()    
    GUI:setVisible(self.view.AtkModePanel, false)
    GUI:setVisible(self.view.AtkModeClosePanel, false)
end

function KLUIPlayerInfoPanel:OnClickexperienceMenufoldBtn()
    GUI:setVisible(self.view.experienceList, false)
    --GUI:setVisible(self.view.experienceMenuexpandBtn, true)
    GUI:setVisible(self.view.experienceMenufoldBtn, false)
    GUI:setRotation(self.view.arrow1, 0)
end

function KLUIPlayerInfoPanel:OnClickexperienceMenuexpandBtn()
    GUI:setVisible(self.view.experienceList, true)
    --GUI:setVisible(self.view.experienceMenuexpandBtn, false)
    GUI:setVisible(self.view.experienceMenufoldBtn, true)
    GUI:setRotation(self.view.arrow1, 180)
end

function KLUIPlayerInfoPanel:OnClickSdBtn()
    if Global.MaxSD then
        if GUI:GetUI("dev/ui/MainUI/Panel/KLSDTip/KLSDTipPanel") then
            GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLSDTip/KLSDTipPanel")
        end
        local shield = math.floor(Global.CurSD)
        local maxShield = math.floor(Global.MaxSD)
        local des = "防护值（SD）：" .. shield .. "/" .. maxShield
        local width =122+ (string.len(shield .. "/"..maxShield) - 3)*7
        GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLSDTip/KLSDTipPanel", nil, nil, { type="SD",content = des,x=-168, y = 89, width = width, height = 14 })
    end
  
end

function KLUIPlayerInfoPanel:OnClickShieldBtn()
    if Global.MaxAG then
        if GUI:GetUI("dev/ui/MainUI/Panel/KLSDTip/KLSDTipPanel") then
            GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLSDTip/KLSDTipPanel")
        end
        local agsto = math.floor(Global.CurAG)
        local maxAgsto = math.floor(Global.MaxAG)
        local des = "技能值（AG）：" .. agsto .. "/"..maxAgsto
        local width =122+ (string.len(agsto .. "/"..maxAgsto) - 3)*7
        GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLSDTip/KLSDTipPanel", nil, nil, { type="AG",content = des, x = 168, y = 89, width = width, height = 14 })
    end
end

function KLUIPlayerInfoPanel:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    if self.effectTimer then
        SL:UnSchedule(self.effectTimer)
        self.effectTimer = nil
    end
--[[    if self.MonthTime then
        SL:UnSchedule(self.MonthTime)
        self.MonthTime = nil
    end
    if self.UIWeekTime then
        SL:UnSchedule(self.UIWeekTime)
        self.UIWeekTime = nil
    end]]
    --GUI:SetImageAlpha(self.view.MonthCardBtn, 1, 1, 1, 1)
end
---清除数据
function KLUIPlayerInfoPanel:Clear()
    ---@param exprienceTmeplate KLUIExperienceItem
    for i, exprienceTmeplate in pairs(self.experienceTemplateList) do
        GUI:UIPanel_Close(nil, exprienceTmeplate)
    end
    self.experienceTemplateList = {}

    ---@param buffInfoTemplateItem KLBuffInfoItem
    for i, buffInfoTemplateItem in pairs(self.buffInfoTemplateList) do
        GUI:UIPanel_Close(nil, buffInfoTemplateItem)
    end
    self.buffInfoTemplateList = {}
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
    table.clear(self.buffInfoList)

    ---@param pkModeTemplate KLPkItem
    for i, pkModeTemplate in pairs(self.pkModeTemplateList) do
        GUI:UIPanel_Close(nil, pkModeTemplate)
    end
    self.pkModeTemplateList = {}
end

function KLUIPlayerInfoPanel:FastDataListItemCountFunc()
    local count = #self.fastData
    local maxShield = SL:GetMetaValue("MAXSHIELD")
    local maxAgsto = SL:GetMetaValue("MAXAGSTO")
--[[    if maxShield == 0 or maxAgsto == 0 then
        GUI:setPositionX(self.view.left,25)
        GUI:setPositionX(self.view.right,18)
    else
        count = count - 1
        GUI:setPositionX(self.view.left,36)
        GUI:setPositionX(self.view.right,-22)
    end]]
    --local w = count * 70
    --local w2 = math.floor((self.view.root.kmlControl.rectTransform.rect.width - w)/2)
    --GUI:setContentSize(self.view.leftBg, w2, 41)
    --GUI:setContentSize(self.view.rightBg, w2, 41)
    GUI:setContentSize(self.view.fast_grid, count * 53 + (count - 1), 54)
    if count > 3 then
        count = 3
    end
    return count
end

function KLUIPlayerInfoPanel:FastDataListItemGetFunc(realIndex)
    local data = self.fastData[realIndex + 1]
    local message = { cfgId = data, itemIndex = realIndex + 1 }
    local item = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLFast/KLFastItem", self.view.fast_data_list, self, message, true,function(_item)
        self.fastData_all_item[_item.view.root] = _item
        self:FastDataListItemUpdateFunc(realIndex,_item.view.root)
    end)
    return item.view.root
end

function KLUIPlayerInfoPanel:FastDataListItemInitFunc(realIndex, kmlcontrol)
end

function KLUIPlayerInfoPanel:FastDataListItemUpdateFunc(realIndex, kmlcontrol)
    if self.fastData_all_item[kmlcontrol] then
        local data = self.fastData[realIndex + 1]
        local message = { cfgId = data, itemIndex = realIndex + 1 }
        self.fastData_all_item[kmlcontrol]:RefreshItem(message)
    end
end

function KLUIPlayerInfoPanel:InitShortcutAfter()
    local fastItemList = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    self.fastData = table.copyFrom({},fastItemList)
    if not SL:HasConfig("cfg_item",self.fastData[1]) then
        self.fastData[1] = InfoManager.mainUIInfo.mpShowModeItemId
    end
    if not SL:HasConfig("cfg_item",self.fastData[2]) then
        self.fastData[2] = InfoManager.mainUIInfo.hpShowModeItemId
    end
    if InfoManager.mainUIInfo.guardId then
        self.fastData[5] = InfoManager.mainUIInfo.guardId
    end
    --GUI:DataListUpdateData(self.view.fast_data_list)
end

function KLUIPlayerInfoPanel:SelectAttackRole(_id, select_id)
    --logError("SelectAttackRole-----"..select_id)
    local is_open = false
    local is_player = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_PLAYER, select_id)
    if is_player then
        is_open = true
    else
        local is_monster = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_MONSTER, select_id)
        if is_monster then
            local role = SL:GetRoleById(select_id)
            local cfgId = role.data.serverData.cfgId
            is_open = SL:MonsterIsShowHP(cfgId)
        end
    end
    if InfoManager.redFortInfo.isEnter then
        is_open = false
    end
    if is_open then
        SL:OpenBossHp(select_id)
    else
        --SL:CloseBossHp()
    end
end

function KLUIPlayerInfoPanel:ResetAttackRole()
    SL:CloseBossHp()
end

function KLUIPlayerInfoPanel:LUA_EVENT_PRIVILEGE_INFO_CHANGE()
    -----特权收益
    --local exp = PrivilegeCardManager.GetExperienceUp()
    -----三倍收益
    --if PrivilegeCardManager.tripleEarningsInfo then
    --    if PrivilegeCardManager.tripleEarningsInfo.effectSec > 0 then
    --        exp = (100 + exp) * 3 - 100
    --    end 
    --end
    --GUI:Text_setString(self.view.allExperienceTxt, exp .. "%")
end

function KLUIPlayerInfoPanel:LUA_EVENT_EXPERIENCE_ADD_CHANGE()
    self:RefreshExperienceAdd()
end

function KLUIPlayerInfoPanel:LUA_EVENT_MAIN_PLAYER_DIE()
    ---@param buffInfoTemplateItem KLBuffInfoItem
    for i, buffInfoTemplateItem in pairs(self.buffInfoTemplateList) do
        GUI:UIPanel_Close(nil, buffInfoTemplateItem)
    end
    self.buffInfoTemplateList = {}
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
    table.clear(self.buffInfoList)
end

---@return UIModel
function KLUIPlayerInfoPanel:GetExpBallEffect()
    local effect = self.expEffects:Pop()
    if next(effect) == nil then
        local obj = GUI:GetGameObject(self.view.root)
        ---@type UIModelData
        local t = { id = 148, tableName = "cfg_model_effect", parent = obj,
                    selfRotate = false, resetPosition = true, pos = { 0, 0, 0 }, scale = { 100, 100, 100 } }
        t.diffuseFlowing = SL:GmInfo_GetDiffuseFlowing()
        effect = SL:AddModelEffect(t)
    end
    effect.modelParent:SetActive(true)
    local pos = effect.modelParent.transform.anchoredPosition
    pos.x = 0
    local _,ly,_ = GUI:GetLocalPosition(self.view.root)
    pos.y = -ly
    effect.modelParent.transform.anchoredPosition = pos
    return effect
end

---获得药品后快捷栏自动选择
function KLUIPlayerInfoPanel:ResBagChangeMessage(id, message)
        if not message.itemList or #message.itemList <= 0 then
            return
        end
        ---@type number[]
        local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
        local fast_list = {}
        local hp_pill_itemId = 0
        local mp_pill_itemId = 0
        for i, v in ipairs(message.itemList) do
            if v.item and v.item.cfgId and v.item.count and v.item.count > 0 then
                ---@type cfg_item_column
                local tbl1 = SL:GetConfig("cfg_item",v.item.cfgId)
                if tbl1.isFast and tbl1.isFast == 1 then
                    local isInsert = true
                    --蓝药
                    if tbl1.type==InfoManager.mainUIInfo.mpType and tbl1.subType==InfoManager.mainUIInfo.mpSubType and InfoManager.mainUIInfo.mpPillIdList[tbl1.id] then
                        if not SL:HasConfig("cfg_item",fastItems[1]) then
                            mp_pill_itemId = v.item.cfgId
                        else
                            local tbl2 = SL:GetConfig("cfg_item", fastItems[1])
                            if tbl1.rank > tbl2.rank then
                                mp_pill_itemId = v.item.cfgId
                            end
                        end
                        isInsert = false
                    end
                    --血药
                    if tbl1.type==InfoManager.mainUIInfo.hpType and tbl1.subType==InfoManager.mainUIInfo.hpSubType and InfoManager.mainUIInfo.hpPillIdList[tbl1.id] then
                        if not SL:HasConfig("cfg_item",fastItems[2]) then
                            hp_pill_itemId = v.item.cfgId
                        else
                            local tbl2 = SL:GetConfig("cfg_item", fastItems[2])
                            if tbl1.rank > tbl2.rank then
                                hp_pill_itemId = v.item.cfgId
                            end 
                        end
                        isInsert = false
                    end
                    if isInsert then
                        table.insert(fast_list,{cfgId=v.item.cfgId,index=v.index,id=v.item.id,isJoin = 0})
                    end
                end
            end
        end
        if #fast_list > 0 then
            local current_fast_list = {}
            for i=1,#self.fastData,1 do
                table.insert(current_fast_list,{cfgId=self.fastData[i],idx=i,is_new=false})
            end
            for i=1,#current_fast_list,1 do
                local current_cfgId = current_fast_list[i].cfgId
                if current_cfgId ~= 0 then
                    local tbl1 = SL:GetConfig("cfg_item", current_cfgId)
                    current_fast_list[i].Group = tbl1.Group
                    current_fast_list[i].rank = tbl1.rank
                else
                    current_fast_list[i].Group = 0
                    current_fast_list[i].rank = 0
                end
            end
            table.sort(current_fast_list, function(a, b)
                if a.Group ~= b.Group then
                    return a.Group < b.Group
                else
                    return a.rank < b.rank
                end
            end)
            for i=1,#fast_list,1 do
                local current_cfgId = fast_list[i].cfgId
                local tbl1 = SL:GetConfig("cfg_item", current_cfgId)
                fast_list[i].Group = tbl1.Group
                fast_list[i].rank = tbl1.rank
            end
            table.sort(fast_list, function(a, b)
                if a.Group ~= b.Group then
                    return a.Group < b.Group
                else
                    return a.rank > b.rank
                end
            end)
            for i=1,#current_fast_list,1 do
                local current_cfgId = current_fast_list[i].cfgId
                if current_cfgId ~= 0 then
                    for j=1,#fast_list,1 do
                        local data = fast_list[j]
                        if current_cfgId == data.cfgId then
                            fast_list[j].isJoin = 2
                        end
                    end
                end
            end
            for i=1,#current_fast_list,1 do
                if not current_fast_list[i].is_new then
                    local current_cfgId = current_fast_list[i].cfgId
                    if current_cfgId ~= 0 then
                        for j=1,#fast_list,1 do
                            local data = fast_list[j]
                            if data.isJoin == 0 and current_fast_list[i].Group == data.Group then
                                if data.rank > current_fast_list[i].rank then
                                    current_fast_list[i].cfgId = data.cfgId
                                    current_fast_list[i].is_new = true
                                    fast_list[j].isJoin = 1
                                    break
                                end
                            end
                        end
                    end
                end
            end
            table.sort(current_fast_list, function(a, b)
                return a.idx < b.idx
            end)
            for i=1,#current_fast_list,1 do
                if not current_fast_list[i].is_new then
                    local current_cfgId = current_fast_list[i].cfgId
                    if current_cfgId == 0 then
                        for j=1,#fast_list,1 do
                            local data = fast_list[j]
                            if data.isJoin == 0 then
                                current_fast_list[i].cfgId = data.cfgId
                                current_fast_list[i].is_new = true
                                fast_list[j].isJoin = 1
                                break
                            end
                        end
                    end
                end
            end
            for i=1,#current_fast_list,1 do
                if current_fast_list[i].is_new and current_fast_list[i].idx >2 then
                    SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, current_fast_list[i].idx, current_fast_list[i].cfgId, 0)
                end
            end
        end
        if mp_pill_itemId ~= 0 then
            SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, 1, mp_pill_itemId, 0)
        end
        if hp_pill_itemId ~= 0 then
            SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, 2, hp_pill_itemId, 0)
        end
end


function KLUIPlayerInfoPanel:BagInfo_Change(id,message)
    local hp_pill_itemId = -1
    local mp_pill_itemId = -1
    local itemList_ = SL:GetIsFastItemList()
    ---@type number[]
    local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    for i, item in pairs(itemList_) do
        ---@type cfg_item_column
        local tbl1 = SL:GetConfig("cfg_item",item.cfgId)
        --蓝药 
        if tbl1.type==InfoManager.mainUIInfo.mpType and tbl1.subType==InfoManager.mainUIInfo.mpSubType and InfoManager.mainUIInfo.mpPillIdList[tbl1.id] then
            local cfgId = fastItems[1]
            if mp_pill_itemId ~= -1 then
                cfgId = mp_pill_itemId
            end
            local ownerCount = SL:GetBagItemCount(cfgId)
            if not SL:HasConfig("cfg_item",fastItems[1]) or ownerCount <=0 then
                mp_pill_itemId = item.cfgId
            else
                local tbl2 = SL:GetConfig("cfg_item", cfgId)

                if tbl1.rank > tbl2.rank then
                    mp_pill_itemId = item.cfgId
                end
            end
        end
        --血药
        if tbl1.type==InfoManager.mainUIInfo.hpType and tbl1.subType==InfoManager.mainUIInfo.hpSubType and InfoManager.mainUIInfo.hpPillIdList[tbl1.id] then
            local cfgId = fastItems[2]
            if hp_pill_itemId ~= -1 then
                cfgId = hp_pill_itemId
            end
            local ownerCount = SL:GetBagItemCount(cfgId)
            if not SL:HasConfig("cfg_item",fastItems[2]) or ownerCount <=0 then
                hp_pill_itemId = item.cfgId
            else
                local tbl2 = SL:GetConfig("cfg_item", cfgId)

                if tbl1.rank > tbl2.rank then
                    hp_pill_itemId = item.cfgId
                end
            end
        end
    end
    
    local ownerCount = SL:GetBagItemCount(fastItems[1])
    mp_pill_itemId = (mp_pill_itemId == -1 and ownerCount <= 0) and 0 or mp_pill_itemId
    
    if mp_pill_itemId ~= -1 and fastItems[1] ~= mp_pill_itemId then
        SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, 1, mp_pill_itemId, 0)
    end

    ownerCount = SL:GetBagItemCount(fastItems[2])
    hp_pill_itemId = (hp_pill_itemId == -1 and ownerCount <= 0) and 0 or hp_pill_itemId
    
    if hp_pill_itemId ~= -1 and fastItems[2] ~= hp_pill_itemId then
        SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, 2, hp_pill_itemId, 0)
    end
    SL:onLUAEvent(LUA_EVENT_FASTITEM_CHANGE)
    SL:RefreshPanelALLRedStateKmlByCondition("checkSkillCanLearn")
    self:LUA_EVENT_BAG_CHANGE_AFTER()
end


function KLUIPlayerInfoPanel:LUA_EVENT_CLOSEWIN(id,panelName)
    if panelName == "KLUIBuffInfoListPanel" then
        self:OnClickBuffMenuexpandBtn()
    end
end

function KLUIPlayerInfoPanel:AddOrRemoveBuff(data,isAdd)
    local isContains = false
    local pos
    for i, v in pairs(self.buffInfoList) do
        if v.cfgId == data.cfgId then
            isContains = true
            pos = i
        end
    end
    if isContains and pos and not isAdd then
        table.remove(self.buffInfoList,pos)
    end
    if isAdd then
        if isContains then
            self.buffInfoList[pos] = data
        else
            table.insert(self.buffInfoList,data)
        end
    end
end

function KLUIPlayerInfoPanel:LUA_EVENT_GUARD_FAST_ITEM_CHANGE()
    --SL:SetMetaValue("FAST_ITEM_ID_LIST", message.guard and message.guard or 0)
    local fastItemList = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    self.fastData = table.copyFrom({},fastItemList)
    if not SL:HasConfig("cfg_item",self.fastData[1]) then
        self.fastData[1] = InfoManager.mainUIInfo.mpShowModeItemId
    end
    if not SL:HasConfig("cfg_item",self.fastData[2]) then
        self.fastData[2] = InfoManager.mainUIInfo.hpShowModeItemId
    end   
      -- if InfoManager.mainUIInfo.guardId then
    --     self.fastData[5] = InfoManager.mainUIInfo.guardId
    -- end  
    GUI:DataListUpdateData(self.view.fast_data_list)
end

function KLUIPlayerInfoPanel:RefreshAtt()
    local definse = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.armor)
    local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
    local minAttack = 0
    local maxAttack = 0
    if baseCareer == 1 or baseCareer == 3 or baseCareer == 5 then
        minAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.minDC)
        maxAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxDC)
    else
        minAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.minMC)
        maxAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxMC)
    end
    --local num = (minAttack + maxAttack)/2
    ---策划需求改成最大攻击力
    local num = maxAttack
    num = Mathf.Floor(num)
    GUI:Text_setString(self.view.Text_Att1,"攻击："..tostring(num))
    GUI:Text_setString(self.view.Text_Att2,"防御："..tostring(definse))
end

function KLUIPlayerInfoPanel:LUA_EVENT_CHANGESCENE()
    if not GUIUtil.IsCanMapLinePkModeChange() then
        SL:onLUAEvent(LUA_EVENT_SWITCH_PKMODE,1)
    end
end

function KLUIPlayerInfoPanel:LUA_EVENT_CAREER_CHANGED()
    SL:RefreshPanelALLRedStateKmlByCondition("checkSkillCanLearn")
end

function KLUIPlayerInfoPanel:LUA_EVENT_BAG_CHANGE_AFTER()
    ---@type cfg_redDot_new_column
    local cfg = SL:GetConfig("cfg_redDot_new",117)
    if cfg then
        if SL:CheckCalculateConditionGroup(cfg.condition) then
            GUI:setVisible(self.view.icon_bagFull, true)
        else
            GUI:setVisible(self.view.icon_bagFull, false)
        end 
    end
end

return KLUIPlayerInfoPanel

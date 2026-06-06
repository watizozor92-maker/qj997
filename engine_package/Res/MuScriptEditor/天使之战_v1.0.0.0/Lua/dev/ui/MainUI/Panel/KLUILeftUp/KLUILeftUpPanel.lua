---@class KLUILeftUpPanel:UIKmlLuaPanelBase
---@field view KLUILeftUpPanelView
local KLUILeftUpPanel = class(UIKmlLuaPanelBase)
local this =KLUILeftUpPanel

local PkModeToSrc = {
    [EPKMode_Out.AllAttack] = 'btn_atk_all',
    [EPKMode_Out.Peace] = 'btn_atk_peace',
    [EPKMode_Out.Team] = 'btn_atk_team',
    [EPKMode_Out.Union] = 'btn_atk_union',
}
---创建时调用一次
function this:Init()
    ---页签类型
    self.tabType = 1
    --GUI:Toggle_setIsOn(self.view.taskToggle,true)
    self.buffInfoList = {}
    --GUI:setVisible(self.view.AtkModeClosePanel, false)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:ReqTeamInfo()
    --self:RefreshAtt()
    --因为UI可能异步加载，数据先于UI的话，会存一份数据
--[[    if GlobalLuaEventManager.Get_AFTER_ENTER_SECRET_REALM() then        --秘境boss副本
        local message = GlobalLuaEventManager.Get_AFTER_ENTER_SECRET_REALM()
        --self:AFTER_ENTER_SECRET_REALM(nil,message)
        --GlobalLuaEventManager.Clear_AFTER_ENTER_SECRET_REALM()
    else]]
    if GlobalLuaEventManager.Get_RES_PRIVILEGE_BOSS_STATUS() then   --特权boss副本
        local message = GlobalLuaEventManager.Get_RES_PRIVILEGE_BOSS_STATUS()
        self:RES_PRIVILEGE_BOSS_STATUS(nil,message)
        GlobalLuaEventManager.Clear_RES_PRIVILEGE_BOSS_STATUS()
    elseif GlobalLuaEventManager.Get_RES_ENTER_BIG_SECRET_REALM() or GlobalLuaEventManager.Get_RES_BIG_SECRET_REALM_TASK_UPDATE() then  --大天使秘境
        local message1 = GlobalLuaEventManager.Get_RES_ENTER_BIG_SECRET_REALM()
        local message2 = GlobalLuaEventManager.Get_RES_BIG_SECRET_REALM_TASK_UPDATE()
        if message1 and message2 then
            self:RES_ENTER_BIG_SECRET_REALM(nil,message1,message2)
            GlobalLuaEventManager.Clear_RES_ENTER_BIG_SECRET_REALM()
            GlobalLuaEventManager.Clear_RES_BIG_SECRET_REALM_TASK_UPDATE()
        elseif message1 then
            self:RES_ENTER_BIG_SECRET_REALM(nil,message1)
            GlobalLuaEventManager.Clear_RES_ENTER_BIG_SECRET_REALM()
        elseif message2 then
            self:RES_BIG_SECRET_REALM_TASK_UPDATE(nil,message2)
            GlobalLuaEventManager.Clear_RES_BIG_SECRET_REALM_TASK_UPDATE()
        end
    elseif GlobalLuaEventManager.Get_RES_KUN_DUN_PANEL_INFO() then   --昆顿入侵副本
        local message = GlobalLuaEventManager.Get_RES_KUN_DUN_PANEL_INFO()
        self:RES_KUN_DUN_PANEL_INFO(nil,message)
        GlobalLuaEventManager.Clear_RES_KUN_DUN_PANEL_INFO()
    elseif InfoManager.copActivityInfo:CheckDevilMessage() then
        local message = InfoManager.copActivityInfo:CheckDevilMessage()
        self:DEVIL_SQUARE_STATE(_, message)
        InfoManager.copActivityInfo:ClearDevilMessage()
    elseif InfoManager.copActivityInfo:GetBloodMessage() then
        local message = InfoManager.copActivityInfo:GetBloodMessage()
        self:RES_BLOODY_CASTLE_STATE_UPDATE(_, message)
        InfoManager.copActivityInfo:ClearBloodMessage()
    elseif GlobalLuaEventManager.Get_RES_BRAVE_TEST_STATE() then
        local message = GlobalLuaEventManager.Get_RES_BRAVE_TEST_STATE()
        self:BRAVE_TEST_STATE(nil,message)
        GlobalLuaEventManager.Clear_RES_BRAVE_TEST_STATE()
    elseif GlobalLuaEventManager.Get_RES_COMBO_TEST_STATE() then
        local message = GlobalLuaEventManager.Get_RES_COMBO_TEST_STATE()
        self:COMBO_TEST_STATE(nil, message)
        GlobalLuaEventManager.Clear_RES_COMBO_TEST_STATE()
    elseif GlobalLuaEventManager.Get_RES_WOLF_SOUL_STATE() then
        local message = GlobalLuaEventManager.Get_RES_WOLF_SOUL_STATE()
        self:RES_WOLF_SOUL_STATE(nil, message)
        GlobalLuaEventManager.Clear_RES_WOLF_SOUL_STATE()
    elseif GlobalLuaEventManager.Get_RES_RED_FORTRESS_STATE_UPDATE() then
        local message = GlobalLuaEventManager.Get_RES_RED_FORTRESS_STATE_UPDATE()
        self:RES_RED_FORTRESS_STATE_UPDATE(nil, message)
        GlobalLuaEventManager.Clear_RES_RED_FORTRESS_STATE_UPDATE()
    end

    SL:SetMainUIBlockDisplayUI("KLUITeamWindowPanel",not SL:IsMainUIBlockDisplayUI("KLTaskPanel") and not InfoManager.copActivityInfo.hideTask)
    if not SL:IsMainUIBlockDisplayUI("KLTaskPanel") and not InfoManager.copActivityInfo.hideTask then
        SL:LogWarning("打开KLTaskPanel")
        GUI:UIPanel_Open("dev/ui/Task/Panel/KLTask/KLTaskPanel",self.view.tabObjRoot,nil,nil,false,
        function (temp)
            if InfoManager.copActivityInfo.hideTask then
                GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
            end
        end)
    end
    SL:SetMainUIBlockDisplayUI("KLUITeamMainPanel",true)
    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_KING_ROAD_TASK_INFO)
    --:SetKingOfRoadData()
    --self:InitPKMode()

    --local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    --self:SetOnHookIcon(onHookState)
end

function this:RefreshAtt()
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
    GUI:Text_setString(self.view.combat_power,tostring(num))
    GUI:Text_setString(self.view.defense,tostring(definse))
end

function this:LUA_EVENT_LEVELCHANGE()
    self:SetKingOfRoadVis()
end

function this:SetKingOfRoadData()
    self:SetKingOfRoadVis()
    if self.curChapter < 1 then
        return
    end
    
    local tbl = SL:GetConfig('cfg_king_road', self.curChapter)
    GUI:Item_setItemId(self.view.kingOfRoadItem, tbl.rewardItem[1])
end

function this:SetKingOfRoadVis()
    GUI:setVisible(self.view.kingOfRoadIcon, false)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE,self.RefreshAtt,self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE,self.LUA_EVENT_LEVELCHANGE,self)
    SL:RegisterLUAEvent(LUA_EVENT_SHOW_TASK,self.LUA_EVENT_SHOW_TASK,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.DEVIL_SQUARE_STATE,self.DEVIL_SQUARE_STATE,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BLOODY_CASTLE_STATE_UPDATE,self.RES_BLOODY_CASTLE_STATE_UPDATE,self)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.BRAVE_TEST_STATE,self.BRAVE_TEST_STATE,self)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.COMBO_TEST_STATE,self.COMBO_TEST_STATE,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE,self.RES_QUIT_SUCCESS,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_SECRET_REALM,self.RES_QUIT_SECRET_REALM,self)
    
    GUI:SetToggleOnValueChange(self.view.taskToggle,self,self.OnClickTaskToggle)
    GUI:SetToggleOnValueChange(self.view.teamToggle,self,self.OnClickTeamToggle)
    GUI:AddOnClickEvent(self.view.expandBtn,self,self.OnClickFoldToggle,true)
    GUI:AddOnClickEvent(self.view.foldBtn,self,self.OnClickFoldToggle,false)
    GUI:AddOnClickEvent(self.view.kingOfRoadIcon, self, self.kingOfRoadIconOnClick)
    --GUI:AddOnClickEvent(self.view.Btn_OnHook, self, self.OnClick_Btn_OnHook)
    --GUI:AddOnClickEvent(self.view.Btn_AutoFight, self, self.OnClick_Btn_AutoFight)
    SL:RegisterLUAEvent(LUA_EVENT_ONHOOK_STATE_CHANGE,self.LUA_EVENT_ONHOOK_STATE_CHANGE,self)
    --GUI:AddOnClickEvent(self.view.btn_atkMode, self, self.btn_atkModeOnClick)
    --GUI:AddOnClickEvent(self.view.Btn_AtkModeCloseMask, self, self.Btn_AtkModeCloseMaskOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_KING_ROAD_TASK_CHANGE, self.RES_KING_ROAD_TASK_CHANGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_KING_ROAD_TASK_INFO, self.ResKingRoadTaskInfo, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RED_FORTRESS_STATE_UPDATE, self.RES_RED_FORTRESS_STATE_UPDATE, self)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WOLF_SOUL_STATE, self.RES_WOLF_SOUL_STATE , self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE, self.LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE , self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLAND_SIEGE_TASK_INFO_CHANGE, self.LUA_EVENT_ROLAND_SIEGE_TASK_INFO_CHANGE , self)

    --SL:RegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE, self.LUA_EVENT_PKMODE_CHANGE, self)
    --SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE,self.OnPlayerMapPosChange,self)
    --SL:RegisterLUAEvent(LUA_EVENT_BUFFCHANHE, self.RefreshBuff, self)--主角buff改变事件
    --SL:RegisterLUAEvent(LUA_EVENT_SWITCH_PKMODE, self.LUA_EVENT_SWITCH_PKMODE, self)
    --SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
end
function this:LUA_EVENT_CHANGESCENE()
    if not GUIUtil.IsCanMapLinePkModeChange() then
        SL:onLUAEvent(LUA_EVENT_SWITCH_PKMODE,1)
    end
end
--刷新buff
---@param eventId number
---@param eventData BuffChangeData
function this:RefreshBuff(eventId, eventData)

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
function this:UpdateBuff(updateType,data)
    if updateType == 0 and table.count(self.buffInfoTemplateList) < 4 then
        --添加
        self:AddOrRemoveBuff(data,true)
    elseif updateType == 1 then
        self:AddOrRemoveBuff(data,false)
    elseif updateType == 2 then
        --更新
        self:AddOrRemoveBuff(data,true)
    end
end
function this:AddOrRemoveBuff(data,isAdd)
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

function this:RES_QUIT_SUCCESS(id,message)
    SL:SetMainUIBlockDisplayUI("KLTaskPanel",false)
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
end

function this:RES_QUIT_SECRET_REALM(id, message)
    SL:SetMainUIBlockDisplayUI("KLTaskPanel",false)
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
end

function this:ResKingRoadTaskInfo(_, message)
    local curChapter = message.now_chapter
    self.curChapter = curChapter
    if curChapter <= 0 then
        GUI:SetActive(self.view.kingOfRoadIcon, false)
        return
    end
    self:SetKingOfRoadData()
    
    local taskInfo = message.chapter_task_info[tostring(curChapter)].task_info
    local curCount = 0
    local canAccept = false
    local allFinish = true
    for _, task in pairs(taskInfo) do

        if task.state ~= 3 then
            allFinish = false    
        end
        
        if task.state == 3 then
            curCount = curCount + 1
        end

        if task.state == 2 then
            canAccept = true
        end
    end
    local totalCount = table.count(taskInfo)
    GUI:Text_setString(self.view.count, string.format("（%d/%d）",curCount, totalCount))

    if canAccept or allFinish then
        GUI:SetActive(self.view.effect_tishi, true)
    else
        GUI:SetActive(self.view.effect_tishi, false)
    end
end

function this:InitPKMode()
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
    --GUI:Button_setTitleText(self.view.atkModelname, EPKModeToUI_Out[pkMode] or "")
end

-- 需求变化 简单处理下
function this:RES_KING_ROAD_TASK_CHANGE(_, message)
    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_KING_ROAD_TASK_INFO)
    --local curChapter = message.now_chapter
    --local taskInfo = message.chapter_task_info[tostring(curChapter)].task_info
    --local curCount = 0
    --for _, task in pairs(taskInfo) do
    --    if task.state == 3 then
    --        curCount = curCount + 1
    --    end
    --end
    --
    --local totalCount = table.count(taskInfo)
    --GUI:Text_setString(self.view.count, string.format("（%d/%d）",curCount, totalCount))
    --self.curChapter = curChapter
    --self:SetKingOfRoadData()
end

function this:kingOfRoadIconOnClick()
    GUI:UIPanel_Open("dev/outui/Task/Panel/KLKingOfRoad/KLKingOfRoadPanel")
    SL.HideMainPanel()
end

function this:btn_atkModeOnClick()
    GUI:setVisible(self.view.atkModelMenu, true)
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

function this:Btn_AtkModeCloseMaskOnClick()
    GUI:setVisible(self.view.atkModelMenu, false)
    GUI:setVisible(self.view.AtkModeClosePanel, false)
end

function this:SetOnHookIcon(onHookState)
    if PrivilegeCardManager.onHookType == EOnHookType.Situ then
        --GUI:setVisible(self.view.Btn_AutoFight,true)
        GUI:setVisible(self.view.Model_AutoFightEff, onHookState == EAutoOnHookStatus.OnHooking)
        --GUI:Button_loadTextureNormal(self.view.btn_fightLog, onHookState == EAutoOnHookStatus.OnHooking and "btn_rizhi_shou" or "btn_rizhi", "Atlas/UIMainPanel_Out.spriteatlas")
        if onHookState == EAutoOnHookStatus.OnHooking then
            --GUI:Button_loadTextureNormal(self.view.Btn_AutoFight,"btn_pauseFight","Atlas/UIMainPanel_Out.spriteatlas")
            SL:onLUAEvent(LUA_EVENT_HIDE_RIGHT_BTN_VIEW)
        elseif onHookState == EAutoOnHookStatus.StopOnHook then
            --GUI:Button_loadTextureNormal(self.view.Btn_AutoFight,"btn_autoFight","Atlas/UIMainPanel_Out.spriteatlas")
        end
    elseif PrivilegeCardManager.onHookType == EOnHookType.Patrol then
        ---巡逻挂机走另一断逻辑
        if PrivilegeCardManager.patrolOnHookState then
            --GUI:setVisible(self.view.Btn_AutoFight,false)
        else
            --GUI:setVisible(self.view.Btn_AutoFight,true)
        end
    end
end

function this:OnClick_Btn_OnHook()
    GUI:UIPanel_Open("dev/outui/Hook/Panel/KLHookHelp/KLHookHelpPanel")
end

function this:OnClick_Btn_AutoFight()
    if SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA) then
        SL:TipMessage("安全区不能自动战斗", 1, NoticeType.NoticeMid)
        return
    end
    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    if onHookState == EAutoOnHookStatus.PauseOnHook then
        SL:StopOnHook(true)
        PrivilegeCardManager.StopPatrolOnHook()
    elseif onHookState == EAutoOnHookStatus.StopOnHook then
        if PrivilegeCardManager.onHookType == EOnHookType.Situ then
            if SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                return
            end
            SL:StartOnHook(true,true)
            --[[elseif PrivilegeCardManager.onHookType == EOnHookType.Patrol then
                self:OnClickPatrolBtn()]]
        end
    elseif onHookState == EAutoOnHookStatus.OnHooking then
        SL:StopOnHook(true)
    end
end

function this:LUA_EVENT_ONHOOK_STATE_CHANGE(_,onHookState, isOnHook, isReq)
    self:SetOnHookIcon(onHookState)
    --[[if isOnHook and not isReq and onHookState == EAutoOnHookStatus.StopOnHook then
        SL.AutoFight:ReqEndAutoPlayGameMessage()
    end]]
end

function this:DEVIL_SQUARE_STATE(id,message)
    InfoManager.copActivityInfo.hideTask = true
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLDevilCopyTaskProgress/KLDevilCopyTaskProgressPanel")
    if not panel then
        panel = GUI:UIPanel_Open("dev/outui/Activity/Panel/KLDevilCopyTaskProgress/KLDevilCopyTaskProgressPanel",self.view.tabObjRoot,nil,message)
    end
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    --关闭任务页面
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
end

function this:RES_BLOODY_CASTLE_STATE_UPDATE(id,message)
    InfoManager.copActivityInfo.hideTask = true
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLBloodCopyTaskProgress/KLBloodCopyTaskProgressPanel")
    if not panel then
        panel = GUI:UIPanel_Open("dev/outui/Activity/Panel/KLBloodCopyTaskProgress/KLBloodCopyTaskProgressPanel",self.view.tabObjRoot,nil,message)
    end
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    --关闭任务页面
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
end

function this:BRAVE_TEST_STATE(id, message)
    InfoManager.copActivityInfo.hideTask = true
    ---@type KLBraveTrialsWindowPanel
    local panel = GUI:GetUI("dev/outui/BraveTrials/Panel/KLBraveTrialsWindow/KLBraveTrialsWindowPanel")
    if not panel then
        GUI:UIPanel_Open("dev/outui/BraveTrials/Panel/KLBraveTrialsWindow/KLBraveTrialsWindowPanel",self.view.tabObjRoot,nil,message)
    else
        panel:RefreshBraveState(message)
    end
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
end

function this:COMBO_TEST_STATE(id, message)
    InfoManager.copActivityInfo.hideTask = true
    ---@type KLActivityComboProgressPanel
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLActivityComboProgress/KLActivityComboProgressPanel")
    if not panel then
        GUI:UIPanel_Open("dev/outui/Activity/Panel/KLActivityComboProgress/KLActivityComboProgressPanel",self.view.tabObjRoot,nil,message)
    else
        panel:RefreshComboState(message)
    end
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
end

function this:LUA_EVENT_SHOW_TASK()
    self:Refresh()
end

--[[---秘境副本界面
function this:AFTER_ENTER_SECRET_REALM(id, message)
    InfoManager.copActivityInfo.hideTask = true
    SL:KeepOpenPanel("KLChallengeBossPosPanel",true)
    local panel = GUI:GetUI("dev/outui/ChallengeBoss/Panel/KLChallengeBossPos/KLChallengeBossPosPanel")
    if not panel then
        GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBossPos/KLChallengeBossPosPanel",self.view.tabObjRoot,nil,nil,false,
        function (temp)
            temp:InitData(message)
        end)
    else
        panel:InitData(message)
    end
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
end]]

function this:RES_PRIVILEGE_BOSS_STATUS(id, message)
    InfoManager.copActivityInfo.hideTask = true
    SL:KeepOpenPanel("KLPrivilegeBossPosPanel",true)
    local panel = GUI:GetUI("dev/outui/ChallengeBoss/Panel/KLPrivilegeBossPos/KLPrivilegeBossPosPanel")
    if not panel then
        GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLPrivilegeBossPos/KLPrivilegeBossPosPanel",self.view.tabObjRoot,nil,nil,false,
        function (temp)
            temp:InitData(message)
        end)
    else
        panel:InitData(message)
    end
    
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
end

--大天使秘境进入副本响应
function this:RES_ENTER_BIG_SECRET_REALM(id, message,message2)
    InfoManager.copActivityInfo.hideTask = true
    SL:KeepOpenPanel("KLBigSecretCopyTaskPanel",true)
    local panel = GUI:GetUI("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel")
    if not panel then
        GUI:UIPanel_Open("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel",self.view.tabObjRoot,nil,nil,false,
        function (temp)
            temp:InitBegin(message)
            if message2 then
                temp:InitData(message)
            end
        end)
    else
        panel:InitBegin(message)
        if message2 then
            panel:InitData(message)
        end
    end
    
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
end
--大天使秘境任务更新相应
function this:RES_BIG_SECRET_REALM_TASK_UPDATE(id, message)
    InfoManager.copActivityInfo.hideTask = true
    SL:KeepOpenPanel("KLBigSecretCopyTaskPanel",true)
    local panel = GUI:GetUI("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel")
    if not panel then
        GUI:UIPanel_Open("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel",self.view.tabObjRoot,nil,nil,false,
        function (temp)
            temp:InitData(message)
        end)
    else
        panel:InitData(message)
    end
    
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
    GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
end

---赤色要塞
function this:RES_RED_FORTRESS_STATE_UPDATE(id, message)
    InfoManager.copActivityInfo.hideTask = true
    ---@type KLRedFortTaskPanel
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLRedFortTask/KLRedFortTaskPanel")
    local CounterPanel = GUI:GetUI("dev/outui/Activity/Panel/KLRedFortCounter/KLRedFortCounterPanel")
    if not panel then
        panel = GUI:UIPanel_Open("dev/outui/Activity/Panel/KLRedFortTask/KLRedFortTaskPanel",self.view.tabObjRoot,nil)
        CounterPanel = GUI:UIPanel_Open("dev/outui/Activity/Panel/KLRedFortCounter/KLRedFortCounterPanel")
    end
    panel:InitData(message)
    self:SetTeamToogleEnabled(false)
    --CounterPanel:InitData(message)
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    --关闭任务页面
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
end

--昆顿入侵
function this:RES_KUN_DUN_PANEL_INFO(id, message)
    if not GUI:IsWebGLAsync() then
        InfoManager.copActivityInfo.hideTeam = true
        --排行
        ---@type KLQuintonInvasionRankListPanel
        local panel_rank = GUI:GetUI("dev/outui/Activity/Panel/KLQuintonInvasionRankList/KLQuintonInvasionRankListPanel")
        if not panel_rank then
            panel_rank = GUI:UIPanel_Open("dev/outui/Activity/Panel/KLQuintonInvasionRankList/KLQuintonInvasionRankListPanel",self.view.tabObjRoot)
        end
        GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamWindow/KLUITeamWindowPanel")
        if panel_rank then
            panel_rank:SetVisible(self.tabType == 2)
            panel_rank:SetData(message)
        end
        InfoManager.kundunInfo:SetRankList(message)
        --任务
        InfoManager.copActivityInfo.hideTask = true
        local panel = GUI:GetUI("dev/outui/Activity/Panel/KLQuintonInvasionTaskProgress/KLQuintonInvasionTaskProgressPanel")
        if not panel then
            panel = GUI:UIPanel_Open("dev/outui/Activity/Panel/KLQuintonInvasionTaskProgress/KLQuintonInvasionTaskProgressPanel",self.view.tabObjRoot)
        end
        --关闭任务页面
        GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
        
        if panel then
            panel:SetVisible(self.tabType == 1)
            panel:SetData(message)
        end
    else
        InfoManager.copActivityInfo.hideTeam = true
        GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamWindow/KLUITeamWindowPanel")
        --排行
        ---@type KLQuintonInvasionRankListPanel
        local panel_rank = GUI:GetUI("dev/outui/Activity/Panel/KLQuintonInvasionRankList/KLQuintonInvasionRankListPanel")
        if not panel_rank then
            GUI:UIPanel_Open("dev/outui/Activity/Panel/KLQuintonInvasionRankList/KLQuintonInvasionRankListPanel",self.view.tabObjRoot,nil,nil,false,
            function (temp)
                panel_rank = temp
                panel_rank:SetVisible(self.tabType == 2)
                panel_rank:SetData(message)
            end)
        else
            panel_rank:SetVisible(self.tabType == 2)
            panel_rank:SetData(message)
        end
        InfoManager.kundunInfo:SetRankList(message)

        InfoManager.copActivityInfo.hideTask = true
        --关闭任务页面
        GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
        --任务
        local panel = GUI:GetUI("dev/outui/Activity/Panel/KLQuintonInvasionTaskProgress/KLQuintonInvasionTaskProgressPanel")
        if not panel then
            GUI:UIPanel_Open("dev/outui/Activity/Panel/KLQuintonInvasionTaskProgress/KLQuintonInvasionTaskProgressPanel",self.view.tabObjRoot,nil,nil,false,
            function (temp)
                panel = temp
                panel:SetVisible(self.tabType == 1)
                panel:SetData(message)
            end)
        
        else
            panel:SetVisible(self.tabType == 1)
            panel:SetData(message)
        end

    end
end

---狼魂要塞
function this:RES_WOLF_SOUL_STATE(id, message)
    InfoManager.copActivityInfo.hideTask = true
    ---@type KLWolfSoulFortressTaskPanel
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLWolfSoulFortressTask/KLWolfSoulFortressTaskPanel")
    if not panel then
        GUI:UIPanel_Open("dev/outui/Activity/Panel/KLWolfSoulFortressTask/KLWolfSoulFortressTaskPanel",self.view.tabObjRoot,nil,nil,false,
                         function(uiPanel)
                             uiPanel:InitData(message)
                         end)
    else
        panel:InitData(message)
    end
    self:SetTeamToogleEnabled(false)
    GUI:Toggle_setIsOn(self.view.taskToggle,true)
    --关闭任务页面
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
end

---罗兰攻城战阶段信息变动
function this:LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE()
    InfoManager.copActivityInfo.hideTask = true
    ---@type KLLoranSiegeCopyTaskPanel
    local panel = GUI:GetUI("dev/outui/LoranSiege/Panel/KLLoranSiegeCopyTask/KLLoranSiegeCopyTaskPanel")
    if not panel then
        GUI:UIPanel_Open("dev/outui/LoranSiege/Panel/KLLoranSiegeCopyTask/KLLoranSiegeCopyTaskPanel",self.view.tabObjRoot)
    end
    --关闭任务页面
    ---@type KLTaskPanel
    local taskPanel = GUI:GetUI("dev/ui/Task/Panel/KLTask/KLTaskPanel")
    if taskPanel then
        self:SetTeamToogleEnabled(false)
        GUI:Toggle_setIsOn(self.view.taskToggle,true)
        GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
        GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel")
    end
end

---罗兰攻城战任务信息变动
function this:LUA_EVENT_ROLAND_SIEGE_TASK_INFO_CHANGE()
    self:LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE()
end

function this:LUA_EVENT_PKMODE_CHANGE(_, pkMode)
    GUI:Image_loadTexture(self.view.btn_atkMode, PkModeToSrc[pkMode].."2","Atlas/UIMainPanel_Out.spriteatlas")
    GUI:setVisible(self.view.atkModelMenu, false)
    GUI:setVisible(self.view.AtkModeClosePanel, false)
end


function this:OnPlayerMapPosChange()
    ---@type Dot2
    local pos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
    local mapName = SL:GetMetaValue(EMetaVarGetKey.MAP_NAME)
    GUI:Text_setString(self.view.txt_pos,string.format("%s <color=#CCCCCC>%d,%d</color>", mapName, pos.x, pos.z))
end

---切换pk模式
function this:LUA_EVENT_SWITCH_PKMODE(_, pkMode)
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
    local tip = SL:GetMetaValue(EMetaVarGetKey.PKMODE_CAN_USE, pkMode)
    if not string.isNullOrEmpty(tip) then
        SL:TipMessage(tip, 1, NoticeType.NoticeMid)
        return
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, pkMode)
end

function this:OnClickTaskToggle(control,eventData,value)
    if value[1] then
        self.tabType = 1
        if not InfoManager.copActivityInfo.hideTask then
            --打开任务页面
            GUI:UIPanel_Open("dev/ui/Task/Panel/KLTask/KLTaskPanel",self.view.tabObjRoot)
            SL:SetMainUIBlockDisplayUI("KLTaskPanel",false)
        end
        if self.curTaskPanel then
            GUI:setVisible(self.curTaskPanel.view.root,true)
        end
    else
        --关闭任务页面
        GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
        SL:SetMainUIBlockDisplayUI("KLTaskPanel",true)
        if self.curTaskPanel then
            GUI:setVisible(self.curTaskPanel.view.root,false)
        end
    end

    ---@type KLDevilCopyTaskProgressPanel
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLDevilCopyTaskProgress/KLDevilCopyTaskProgressPanel")
    if panel then
        panel:SetVisible(value[1])
    end

    ---@type KLBloodCopyTaskProgressPanel
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLBloodCopyTaskProgress/KLBloodCopyTaskProgressPanel")
    if panel then
        panel:SetVisible(value[1])
    end

    ---@type KLBraveTrialsWindowPanel
    local panel = GUI:GetUI("dev/outui/BraveTrials/Panel/KLBraveTrialsWindow/KLBraveTrialsWindowPanel")
    if panel then
        panel:SetVisible(value[1])
    end

    ---@type KLActivityComboProgressPanel
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLActivityComboProgress/KLActivityComboProgressPanel")
    if panel then
        panel:SetVisible(value[1])
    end

    ---@type KLChallengeBossPosPanel
    local ChallengeBossPosPanel = GUI:GetUI("dev/outui/ChallengeBoss/Panel/KLChallengeBossPos/KLChallengeBossPosPanel")
    if ChallengeBossPosPanel then
        ChallengeBossPosPanel:SetVisible(value[1])
    end

    ---@type KLPrivilegeBossPosPanel
    local PrivilegeBossPosPanel = GUI:GetUI("dev/outui/ChallengeBoss/Panel/KLPrivilegeBossPos/KLPrivilegeBossPosPanel")
    if PrivilegeBossPosPanel then
        PrivilegeBossPosPanel:SetVisible(value[1])
    end

    ---@type KLBigSecretCopyTaskPanel
    local BigSecretCopyTaskPanel = GUI:GetUI("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel")
    if BigSecretCopyTaskPanel then
        BigSecretCopyTaskPanel:SetVisible(value[1])
    end
    
    ---@type KLLoranSiegeCopyTaskPanel
    local LoranSiegeCopyTaskPanel = GUI:GetUI("dev/outui/LoranSiege/Panel/KLLoranSiegeCopyTask/KLLoranSiegeCopyTaskPanel")
    if LoranSiegeCopyTaskPanel then
        LoranSiegeCopyTaskPanel:SetVisible(value[1])
    end

    ---@type KLQuintonInvasionTaskProgressPanel
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLQuintonInvasionTaskProgress/KLQuintonInvasionTaskProgressPanel")
    if panel then
        panel:SetVisible(value[1])
    end
end

function this:OnClickTeamToggle(control,eventData,value)
    if value[1] then
        if not InfoManager.copActivityInfo.hideTeam then
            --打开组队页面
            if self.tabType == 2 then
                GUI:UIPanel_Open("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel",_,_,{panelType = 1})
                SL:SetMainUIBlockDisplayUI("KLUITeamMainPanel",false)
                return
            end
            self.tabType = 2
            GUI:UIPanel_Open("dev/ui/Team/Panel/KLUITeamWindow/KLUITeamWindowPanel",self.view.tabObjRoot)
            SL:SetMainUIBlockDisplayUI("KLUITeamWindowPanel",false)
        else
            self.tabType = 2
        end
        
    else
        --关闭组队页面
        GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamWindow/KLUITeamWindowPanel")
        SL:SetMainUIBlockDisplayUI("KLUITeamMainPanel",true)
        SL:SetMainUIBlockDisplayUI("KLUITeamWindowPanel",true)
        
    end
    ---@type KLQuintonInvasionRankListPanel
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLQuintonInvasionRankList/KLQuintonInvasionRankListPanel")
    if panel then
        panel:SetVisible(value[1])
    end
end

function this:OnClickFoldToggle(control,eventData,value)
    if eventData then
        GUI:SetControl_moveto(self.view.activityRoot,"-55,-140,0")
        GUI:SetControl_moveto(self.view.tabObjRoot,"593,-298,0")
        GUI:DOAnchorPos(GUI:GetRectTransform(self.view.expanfBg), Vector2.New(157, -40),0.4)
        --GUI:setPositionX(self.view.expanfBg,157)
    else
        GUI:SetControl_moveto(self.view.activityRoot,"-472,-140,0")
        GUI:SetControl_moveto(self.view.tabObjRoot,"0,-298,0")
        --GUI:setPositionX(self.view.expanfBg,-176)
        GUI:DOAnchorPos(GUI:GetRectTransform(self.view.expanfBg), Vector2.New(-176, -40),0.4)
    end

    GUI:setVisible(self.view.expandBtn,not eventData)
    GUI:setVisible(self.view.foldBtn,eventData)
end

function this:Close()
    InfoManager.copActivityInfo.hideTask = false
end

---@param panel UIKmlLuaPanelBase
function this:HookTaskPanel(panel)
    if panel then
        if self.curTaskPanel and self.curTaskPanel ~= panel then
            GUI:UIPanel_Close(nil,self.curTaskPanel)
        end
        GUI:Toggle_setIsOn(self.view.taskToggle,true)
        --关闭任务页面
        GUI:UIPanel_Close("dev/ui/Task/Panel/KLTask/KLTaskPanel")
        ---@type UIKmlLuaPanelBase
        self.curTaskPanel = panel
        GUI:SetParent(panel.view.root,GUI:GetRectTransform(self.view.tabObjRoot))
        InfoManager.copActivityInfo.hideTask = true
    else
        GUI:UIPanel_Open("dev/ui/Task/Panel/KLTask/KLTaskPanel",self.view.tabObjRoot)
        self.curTaskPanel = nil
        InfoManager.copActivityInfo.hideTask = false
    end
end

function this:SetTeamToogleEnabled(isEnabled)
    GUI:setTouchEnabled(self.view.teamToggle,isEnabled)
end


return this

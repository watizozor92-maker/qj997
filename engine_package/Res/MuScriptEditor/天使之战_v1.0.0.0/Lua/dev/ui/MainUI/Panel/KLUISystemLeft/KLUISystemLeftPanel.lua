---@class KLUISystemLeftPanel:UIKmlLuaPanelBase
---@field view KLUISystemLeftPanelView
---@field mountPanelItem KLUISystemItem
local KLUISystemLeftPanel = class(UIKmlLuaPanelBase)
local this =KLUISystemLeftPanel

local ESystemType = {
    NoShow = enum(0),
    ShowRight = enum(1),
    ShowTop = enum(2),
}

local ETopSystemType = {
    None = enum(0),
    Show = enum(1),
}
---创建时调用一次
function this:Init()
    self.systemTemplateList = {}
    GUI:setVisible(self.view.maxBagTips, false)
    GUI:setVisible(self.view.autoMaxIcon_2, false)
    GUI:setVisible(self.view.img_new_hook, false)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:Clear()
    SL:LogWarning("打开KLUISystemLeftPanel")
    PrivilegeCardManager.onHookType = EOnHookType.Situ
    PrivilegeCardManager.StopPatrolOnHook()
    self.systemType = ESystemType.ShowRight
    self.topSystemType = ETopSystemType.None
    self:RefreshSystemMenu()
    --[[local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    self:SetOnHookIcon(onHookState)]]
    if not SL:GetIsExpandSystemFunction() then
        GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLMainAttack/KLMainAttackPanel")
    end
    SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
    self:OnClickShapeShiftBtn(_, true)
end

function this:RefreshSystemMenu()
    self:Clear()
    local tbl = SL:GetConfigTable("cfg_MainPanelUI")
    local data = {}
    ---@param v cfg_MainPanelUI_column
    for i, v in pairs(tbl) do
        if v.displayLocation == self.systemType then
            table.insert(data,v)
        end
        if v.systemId == "变身卡牌变身" and v.displayLocation == 0 then
            GUI:setPosition(self.view.shapeShiftRoot,v.positionOffset[1] or 25,v.positionOffset[2] or -74)
        end
    end
    
    table.sort(data,function(a, b)
            if a.id < b.id then
                return true
            end
            return false
        end)
    
    ---@param v cfg_MainPanelUI_column
    for i, v in pairs(data) do
        local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION,v.systemId)
        if isMeet and v.showon == 0 then
            ---@type KLUISystemItem
            local systemPanelItem = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLUISystem/KLUISystemItem",self.view.systemMenu,self,v,true)
            table.insert(self.systemTemplateList,systemPanelItem)
            GUI:SetID(systemPanelItem.view.root,v.btnName)
            SL:AddRedPoint(systemPanelItem)
            if v.dec == "坐骑" then
                self.mountPanelItem = systemPanelItem
                GUI:setVisible(self.mountPanelItem.view.root,InfoManager.mountInfo.isHasOwnerMount)
            elseif v.dec == "连击" then
                GUI:setVisible(systemPanelItem.view.root,Global.LianJiOpenState)
            else
                GUI:setVisible(systemPanelItem.view.root,isMeet)
            end
        end
        
    end
end
--[[

function this:ChangeBagIcon()
    local is_empty = SL:GetMetaValue(EMetaVarGetKey.BAG_REMAIN_COUNT)
    if is_empty then
        GUI:Image_loadTexture(self.view.bagBtn,"btn_beibao", "Atlas/UIMainPanel.spriteatlas")
        GUI:setVisible(self.view.maxBagTips, false)
    else
        GUI:Image_loadTexture(self.view.bagBtn,"bag_btn_full", "Atlas/UIMainPanel.spriteatlas")

        local show = SL:GetLocalString("showMaxBagTips", "true")
        if show=="true" then
            GUI:setVisible(self.view.maxBagTips, true)
        end
    end
end
]]

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.expandBtn,self,self.OnClicksysExpandBtn)
    GUI:AddOnClickEvent(self.view.foldBtn,self,self.OnClicksysFoldBtn)
    --GUI:AddOnClickEvent(self.view.bagBtn,self,self.OnClickBagBtn)
    GUI:AddOnClickEvent(self.view.hookBtn,self,self.OnClickHookBtn)

    GUI:AddOnClickEvent(self.view.autoHookIconContainer_2,self,self.OnClickAutoHookIconContainerBtn_2)
    GUI:AddOnClickEvent(self.view.btn_hook_out, self, self.OnClickHootOutBtn)
    GUI:AddOnClickEvent(self.view.img_auto_2_close, self, self.OnClickHootInBtn)
    GUI:AddOnClickEvent(self.view.btn_hook_in, self, self.OnClickHootInBtn)

    GUI:AddOnClickEvent(self.view.btn_shift, self, self.OnClickShapeShiftBtn)
    GUI:AddOnClickEvent(self.view.btn_shift_cancel, self, self.OnClickShapeShiftCancelBtn)
    GUI:AddOnClickEvent(self.view.maxTipsCloseBtn, self, self.maxTipsCloseBtn)
    GUI:AddOnClickEvent(self.view.equipRecycleBtn, self, self.equipRecycleBtn)
    GUI:AddOnClickEvent(self.view.autoRecycleBtn, self, self.autoRecycleBtn)
    for i = 1, 3 do
        GUI:AddOnClickEvent(self.view["btn_shift_" .. i], self, self.OnClickEachShapeShiftBtn, i)
    end

    --SL:RegisterLUAEvent(LUA_EVENT_ONHOOK_STATE_CHANGE,self.LUA_EVENT_ONHOOK_STATE_CHANGE,self)
    --SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER,self.LUA_EVENT_BAG_CHANGE_AFTER,self)
    SL:RegisterLUAEvent(LUA_EVENT_SHAPE_SHIFT_CARD_SKILL_CHANGE,self.RefreshShapeShiftCardBtn,self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE,self.LUA_EVENT_ROLE_PROPERTY_CHANGE,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MOUNT_LOGO,self.RES_MOUNT_LOGO,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRANSFER_CARD_CD,self.RES_TRANSFER_CARD_CD,self)
    --SL:RegisterLUAEvent(LUA_EVENT_ROLE_TRANSFER, self.RoleTransfer, self)
    GUI:SetToggleOnValueChange(self.view.notNoticeToggle, self, self.notNoticeToggleChange)
    SL:RegisterLUAEvent(LUA_EVENT_LIANJI_OPEN,self.RefreshSystemMenu,self)
end

function this:notNoticeToggleChange(_, customData, eventData)
    if eventData[1] then
        SL:SetLocalString("showMaxBagTips", "false")
    else
        SL:SetLocalString("showMaxBagTips", "true")
    end
end

function this:autoRecycleBtn()
    ---@param panel KLRecoverPanel
    GUI:UIPanel_Open("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel",nil,nil,nil,false,function(panel)
        panel:SetAutoRecover(true)
    end)
 
end

function this:equipRecycleBtn()
    GUI:UIPanel_Open("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
end

function this:maxTipsCloseBtn()
    GUI:setVisible(self.view.maxBagTips, false)
end

---人物属性改变时（刷新红点）
function this:LUA_EVENT_ROLE_PROPERTY_CHANGE()
    SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
end

function this:RES_MOUNT_LOGO(id,message)
    if self.mountPanelItem then
        GUI:setVisible(self.mountPanelItem.view.root,message.logo == 1)
    end
end

function this:OnClicksysExpandBtn()
    --GUI:setVisible(self.view.expandBtn,false)
    --GUI:setVisible(self.view.foldBtn,true)
    GUI:setVisible(self.view.systemArea,false)
    GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLMainAttack/KLMainAttackPanel")
    SL:onLUAEvent(LUA_EVENT_EXPAND_RIGHTSYSTEMFUNCTION,false)
end

function this:OnClicksysFoldBtn()
    --GUI:setVisible(self.view.expandBtn,true)
    --GUI:setVisible(self.view.foldBtn,false)
    GUI:setVisible(self.view.systemArea,true)
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLMainAttack/KLMainAttackPanel")
    SL:onLUAEvent(LUA_EVENT_EXPAND_RIGHTSYSTEMFUNCTION,true)
end

function this:OnClickBagBtn()
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI",107,"id")
    SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION, tbl and tbl.systemId or "背包")
end

function this:OnClickHookBtn()
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
        elseif PrivilegeCardManager.onHookType == EOnHookType.Patrol then
            self:OnClickPatrolBtn()
        end
    elseif onHookState == EAutoOnHookStatus.OnHooking then
        SL:StopOnHook(true)
    end
end

    
---挂机新界面自动按钮
function this:OnClickAutoHookIconContainerBtn_2()
    GUI:UIPanel_Open("dev/outui/Hook/Panel/KLHookHelp/KLHookHelpPanel")
end
---打开挂机新界面
function this:OnClickHootOutBtn()
    self:RefreshOnHookIconType(PrivilegeCardManager.onHookType)
    if PrivilegeCardManager.onHookType == EOnHookType.Patrol then
        self:RefreshAutoOnHookIcon_2State(not PrivilegeCardManager.patrolOnHookState)
    else
        self:RefreshAutoOnHookIcon_2State(not self.animationStart)
    end
    GUI:setVisible(self.view.btn_hook_out_icon, false)
    GUI:setVisible(self.view.img_new_hook, true)
end
---刷新挂机新界面自动按钮动画
function this:RefreshAutoOnHookIcon_2State(state)
    --GUI:SetControlAnimation_stop(self.view.autoMaxIcon_2,state)
    GUI:SetControlAnimation_stop(self.view.autoMinIcon_2,state)
    self.autoIcon_2State = state
end
---隐藏挂机新界面
function this:OnClickHootInBtn()
    GUI:setVisible(self.view.img_new_hook, false)
    GUI:setVisible(self.view.btn_hook_out_icon, true)
end
---点击巡逻按钮
function this:OnClickPatrolBtn()
    ---如果之前再挂机则暂停
    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    if onHookState == EAutoOnHookStatus.OnHooking then
        SL:StopOnHook(true)
    end
    ---判断激活特权是否能巡逻
    if PrivilegeCardManager.isAutoPatrolOnHook() then
        if PrivilegeCardManager.StartPatrolOnHook() then
            if SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                return
            end
            ---找直线距离最近的黄金boss
            if not PrivilegeCardManager:GetThisMapGoldBossAttack() then
                self:RefreshOnHookIconType(EOnHookType.Patrol)
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SET_PATROL, EOnHookType.Patrol)
                PrivilegeCardManager.onHookType = EOnHookType.Patrol
                self:RefreshAutoOnHookIcon_2State(false)
                self:SetOnHookIcon()
            end
        end
    else
        SL:CommonTipsMessage({ stringTblID = 481, ui = self, sureBtnText = "确定", cancelBtnText = "取消",
                               callback = self.OpenFirsh })
    end
end

function this:OpenFirsh()
--[[    if InfoManager.monthCardInfo:IsHaveMonthCardRights("privilege") then
        GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel", nil, nil, { type = "privilege" })
    else
        GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
    end]]
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel",nil,nil,{2})
end
---点击挂机新界面原地挂机按钮
function this:OnClickSituBtn()
    if SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
        return
    end
    ---刷新挂机按钮状态
    if PrivilegeCardManager.IsCanOnHookCheck() then
        self:RefreshAutoOnHookIcon_2State(false)
        self:RefreshOnHookIconType(EOnHookType.Situ)
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SET_PATROL, EOnHookType.Situ)
        PrivilegeCardManager.onHookType = EOnHookType.Situ
        ---停止巡逻挂机
        if PrivilegeCardManager.patrolOnHookState then
            PrivilegeCardManager.StopPatrolOnHook()
        end
        SL:StartOnHook(true,true)
    end
end
---离线挂机，退出游戏
function this:OnClickOffLineBtn()
    SL:CommonTipsMessage({ stringTblID = 448, callback = function()
            if SL.LoginInfo:IsOutSDK() then
                MuInterface.Instance:LogoutAccount()
            end
            SL:QuitGame()
        end })
end
---刷新挂机新界面挂机状态图标
function this:RefreshOnHookIconType(type)
    local patrol = "icon_patrol"
    local situ = "icon_situ"
    local offline = "icon_offline"
    if EOnHookType.No == type then
        situ = situ .. "_no"
        offline = offline  .. "_no"
        patrol = patrol  .. "_no"
    elseif type == EOnHookType.Patrol then
        situ = situ .. "_no"
        offline = offline  .. "_no"
    elseif type == EOnHookType.Situ then
        patrol = patrol .. "_no"
        offline = offline  .. "_no"
    elseif type == EOnHookType.OffLine then
        situ = situ .. "_no"
        patrol = patrol  .. "_no"
    end
end

---@param onHookState EAutoOnHookStatus
function this:LUA_EVENT_ONHOOK_STATE_CHANGE(_,onHookState)
    self:SetOnHookIcon(onHookState)
end

function this:SetOnHookIcon(onHookState)
    if PrivilegeCardManager.onHookType == EOnHookType.Situ then
        if onHookState == EAutoOnHookStatus.OnHooking then
            GUI:setVisible(self.view.hookBtn,true)
            GUI:Image_loadTexture(self.view.hookBtn,"btn_autoing","Atlas/UIMainPanel_Out.spriteatlas")
            --GUI:setVisible(self.view.autoHookIconContainer,true)
            --GUI:SetControlAnimation_stop(self.view.autoMaxIcon,false)
           -- GUI:SetControlAnimation_stop(self.view.autoMinIcon,false)
            --self.animationStart = true
        elseif onHookState == EAutoOnHookStatus.PauseOnHook then
            GUI:setVisible(self.view.hookBtn,true)
--[[            GUI:setVisible(self.view.autoHookIconContainer,false)
            GUI:SetControlAnimation_stop(self.view.autoMaxIcon,true)
            GUI:SetControlAnimation_stop(self.view.autoMinIcon,true)
            self.animationStart = false
            GUI:Image_loadTexture(self.view.hookBtn,"button_main_pause","Atlas/UIMainPanel.spriteatlas")]]
        elseif onHookState == EAutoOnHookStatus.StopOnHook then
            GUI:setVisible(self.view.hookBtn,true)
            GUI:setVisible(self.view.autoHookIconContainer,false)
            GUI:SetControlAnimation_stop(self.view.autoMaxIcon,true)
            GUI:SetControlAnimation_stop(self.view.autoMinIcon,true)
            self.animationStart = false
            GUI:Image_loadTexture(self.view.hookBtn,"btn_auto","Atlas/UIMainPanel_Out.spriteatlas")
        end
    elseif PrivilegeCardManager.onHookType == EOnHookType.Patrol then
        ---巡逻挂机走另一断逻辑
        if PrivilegeCardManager.patrolOnHookState then
            GUI:setVisible(self.view.hookBtn,false)
            GUI:setVisible(self.view.autoHookIconContainer,true)
            GUI:SetControlAnimation_stop(self.view.autoMaxIcon,false)
            GUI:SetControlAnimation_stop(self.view.autoMinIcon,false)
            self.animationStart = true
        else
            GUI:setVisible(self.view.hookBtn,true)
            GUI:setVisible(self.view.autoHookIconContainer,false)
            GUI:SetControlAnimation_stop(self.view.autoMaxIcon,true)
            GUI:SetControlAnimation_stop(self.view.autoMinIcon,true)
            self.animationStart = false
        end
    end
end

function this:RefreshShapeShiftCardBtn()
    self:ShapeShiftStateChangeRefreshUI()
    local info = InfoManager.shapeShiftCardInfo.shiftSkill
    self.btnInfo = {}
    local index = 1
    for i, v in pairs(info) do
        GUI:setVisible(self.view["btn_shift_" .. index], true)
        local icon = InfoManager.shapeShiftCardInfo:GetMonsterIcon(i)
        GUI:Image_loadTexture(self.view["img_shift_icon_" .. index], icon, "Atlas/UIbianshentb.spriteatlas")
        self.btnInfo[index] = v
        index = index + 1
    end
    if index <= 3 then
        for i = index, 3 do
            GUI:setVisible(self.view["btn_shift_" .. index], false)
        end
    end
    if self.allSkillCDTbl then
        self:RES_TRANSFER_CARD_CD(_, self.allSkillCDTbl)
    end
end

function this:OnClickShapeShiftBtn(_, isHide)
    if isHide then
        self.shiftShow = not isHide
    else
        self.shiftShow = not self.shiftShow
    end

    GUI:setVisible(self.view.img_shift_bg, self.shiftShow)
end

function this:OnClickShapeShiftCancelBtn()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRANSFORMATION, 0)
end

function this:OnClickEachShapeShiftBtn(_, eventData)
    if self.btnInfo[eventData].group ~= InfoManager.shapeShiftCardInfo.shiftMonsterGroup then
        if self.shiftSkillCDTbl and self.shiftSkillCDTbl[self.btnInfo[eventData].group] then
            local time = Time.GetServerTime()
            local time2 = self.shiftSkillCDTbl[self.btnInfo[eventData].group]
            if time < time2 then
                return
            end
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRANSFORMATION, self.btnInfo[eventData].group)
    end
end

function this:ShapeShiftStateChangeRefreshUI()
    ---@type cfg_system_switch_column
    local cfg = SL:GetConfig("cfg_system_switch", 113)
    if cfg.needLevel > SL:GetMetaValue("LEVEL") or cfg.needDay > SL:GetOpenServerDay() then
        GUI:setVisible(self.view.shapeShiftRoot, false)
        return
    end
    local info = InfoManager.shapeShiftCardInfo.shiftSkill
    if table.count(info) > 0 then
        GUI:setVisible(self.view.shapeShiftRoot, true)
    else
        GUI:setVisible(self.view.shapeShiftRoot, false)
        return
    end
    if InfoManager.shapeShiftCardInfo:isShiftMonster() then
        GUI:setVisible(self.view.btn_shift_cancel, true)
        GUI:setVisible(self.view.btn_shift, false)
        self:OnClickShapeShiftBtn(nil, true)
    else
        GUI:setVisible(self.view.btn_shift_cancel, false)
        GUI:setVisible(self.view.btn_shift, true)
    end
end

function this:RES_TRANSFER_CARD_CD(_, message)
    if not self.shiftSkillCDTbl then
        self.shiftSkillCDTbl = {}
    end
    for j, k in pairs(self.btnInfo) do
        local isRefresh = false
        for i, v in pairs(message) do
            if tonumber(i) == k.group then
                isRefresh = true
                local time = (v - Time.GetServerTime()) / 1000
                if time < 0 then
                    GUI:SetCirclebar_startper(self.view["Img_cdTime_" .. j], 0)
                else
                    GUI:SetCirclebar_startper(self.view["Img_cdTime_" .. j], 100)
                    GUI:SetCirclebar_time(self.view["Img_cdTime_" .. j], time)
                end

                self.shiftSkillCDTbl[k.group] = v
            end
        end
        if not isRefresh then
            GUI:SetCirclebar_startper(self.view["Img_cdTime_" .. j], 0)
        end
    end
    self:ShapeShiftStateChangeRefreshUI()
    self.allSkillCDTbl = message
end

function this:RoleTransfer()
    if PrivilegeCardManager.onHookType == EOnHookType.Patrol then
        PrivilegeCardManager.StopPatrolOnHook()
        local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
        if onHookState ~= EAutoOnHookStatus.OnHooking then
            SL:StartOnHook(true,true)
            --self:RefreshAutoOnHookIcon_2State(false)
        end
        PrivilegeCardManager.onHookType = EOnHookType.Situ
        self:RefreshOnHookIconType(EOnHookType.Situ)
        --self:RefreshAutoOnHookIcon_2State(true)
        --self:SetOnHookIcon()
    end
end

function this:RefreshTransferDurationCD(duration)
    local time = (duration - Time.GetServerTime()) / 1000
    if time <= 0 then
        GUI:SetCirclebar_startper(self.view.circlebar_cancel, 0)
    else
        GUI:SetCirclebar_startper(self.view.circlebar_cancel, 100)
        GUI:SetCirclebar_time(self.view.circlebar_cancel, time)
    end
end

function this:CreateBtn(systemName)
    ---@type cfg_MainPanelUI_column
    local tbl = SL:cfg_MainPanelUI_post_GetSystemInfoBySystemId(systemName)
    if tbl.displayLocation == self.systemType and tbl.showon ~= 1 then
        ---@type KLUISystemItem
        local systemPanelItem = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLUISystem/KLUISystemItem",self.view.systemMenu,self,tbl,true)
        table.insert(self.systemTemplateList,systemPanelItem)
        GUI:SetID(systemPanelItem.view.root,tbl.btnName)
        SL:AddRedPoint(systemPanelItem)
        if tbl.dec == "连击" then
            GUI:setVisible(systemPanelItem.view.root,Global.LianJiOpenState)
        else
            GUI:setVisible(systemPanelItem.view.root,true)
        end
        table.sort(self.systemTemplateList,function(a, b)
            if a.args.id < b.args.id then
                return true
            end
            return false
        end)
        for i = 1, #self.systemTemplateList do
            ---@type KLUISystemItem
            local templateItem = self.systemTemplateList[i]
            GUI:setLocalZOrder(templateItem.view.root, i)
        end

    end
end

---清除数据
function this:Clear()
    ---@param systemItem KLUISystemItem
    for i, systemItem in pairs(self.systemTemplateList) do
        GUI:UIPanel_Close(nil,systemItem)
    end
    self.systemTemplateList = {}
    self.shiftSkillCDTbl = {}
    self.allSkillCDTbl = nil
end

function this:Close()
    self.systemTemplateList = {}
    self.shiftSkillCDTbl = {}
    self.allSkillCDTbl = nil
    GUI:SetControlAnimation_stop(self.view.autoMaxIcon,true)
    GUI:SetControlAnimation_stop(self.view.autoMinIcon,true)
end

return this

---@class KLUISystemTopPanel:UIKmlLuaPanelBase
---@field view KLUISystemTopPanelView
local KLUISystemTopPanel = class(UIKmlLuaPanelBase)
local this = KLUISystemTopPanel

local ESystemType = {
    NoShow = enum(0),
    ShowRight = enum(1),
    ShowTop = enum(2),
}

local ETopSystemType = {
    None = enum(0),
    Show = enum(1),
}
local fixedShowBtns = {
    --["挑战首领"] = { index = 0 },
    --["月卡"] = { index = 1 }
}
local foldoutStartPos = 0
---系统按钮间隔
local systemBtnInterval = 74
---最大显示总数量
local maxShowTotalCount = 7
---创建时调用一次
function this:Init()
    self.systemType = ESystemType.ShowTop
    self.allCfgs = {}
    local tbl = SL:GetConfigTable("cfg_MainPanelUI")
    for i, v in pairs(tbl) do
        if v.displayLocation == self.systemType or v.displayLocation == ESystemType.NoShow then
            table.insert(self.allCfgs, v)
        end
    end
    table.sort(self.allCfgs, function(a, b)
        return a.sort < b.sort
    end)
    self.systemTemplateList = {}
    self.systemTemplateUnusedList = {}
    self.topSystemType = ETopSystemType.None
    GUI:setVisible(self.view.sysExpand, self.topSystemType == ETopSystemType.Show)
    GUI:setVisible(self.view.sysFold, self.topSystemType == ETopSystemType.None)
    --[[if SL:GetIsWebGL() then
        local h5BtnData = { x = -3,sysExpandX = 8, y = -17, height = 100, width = 60 }
        GUI:setPosition(self.view.sysExpandClickBg,h5BtnData.sysExpandX,h5BtnData.y)
        GUI:setContentSize(self.view.sysExpandClickBg,h5BtnData.width,h5BtnData.height)
        GUI:setPosition(self.view.sysFoldClickBg,h5BtnData.x,h5BtnData.y)
        GUI:setContentSize(self.view.sysFoldClickBg,h5BtnData.width,h5BtnData.height)
    end]]
    --fixedShowBtns["挑战首领"].btn = self.view.bossBtn
    --fixedShowBtns["月卡"].btn = self.view.monthCardBtn
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:Clear()
    self:RefreshSystemMenu()
end

function this:RefreshSystemMenu()
    self:Clear()
    self.showBtnCount = 0
    --local tbl = SL:GetConfigTable("cfg_MainPanelUI")
    ---@param v cfg_MainPanelUI_column
    for i, v in pairs(self.allCfgs) do
        if fixedShowBtns[v.systemId] then
            local fixedShowBtn = fixedShowBtns[v.systemId]
            local show = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, v.systemId)
            GUI:setVisible(fixedShowBtn.btn, show)
            if show then
                GUI:setPosition(fixedShowBtn.btn, v.positionOffset[1] or fixedShowBtn.index * -systemBtnInterval, v.positionOffset[2] or 0)
                GUI:Button_loadTextureNormal(fixedShowBtn.btn, v.BtnImage, "Atlas/KLMainPanelIcon.spriteatlas")
            end
        else
            if v.showon == 0 then
                self:CreateBtn(v.systemId)
            end
        end
    end

    self:RefreshFixedSystemBtn()

    SL:RefreshPanelALLRedPoint("KLUISystemTopPanel")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.sysExpand, self, self.OnClicksysExpandBtn)
    GUI:AddOnClickEvent(self.view.sysExpandClickBg, self, self.OnClicksysExpandBtn)
    GUI:AddOnClickEvent(self.view.sysFold, self, self.OnClicksysFoldBtn)
    GUI:AddOnClickEvent(self.view.sysFoldClickBg, self, self.OnClicksysFoldBtn)
    --GUI:AddOnClickEvent(self.view.bossBtn, self, self.OnClickBossBtn)
    --GUI:AddOnClickEvent(self.view.monthCardBtn, self, self.OnClickMonthCardBtn)
    SL:RegisterLUAEvent(LUA_EVENT_HIDE_RIGHT_BTN_VIEW, self.OnClicksysFoldBtn, self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.RefreshFixedSystemBtn, self)
    SL:RegisterLUAEvent(LUA_EVENT_OPEN_SERVER_DAY_CHANGE, self.RefreshFixedSystemBtn, self)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
    SL:RegisterLUAEvent(LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE, self.LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE, self)
    SL:RegisterLUAEvent(LUA_EVENT_RES_FIRST_CHARGE_GIFT_INFO, self.RES_FirstChargeGift_Info, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self.RefreshSystemMenu, self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.RefreshSystemMenu, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_UI_VISIBLE, self.LUA_EVENT_MAIN_UI_VISIBLE, self)
end

function this:RES_FirstChargeGift_Info(_, message)
    
    local count = 0
    for rewardId, state in pairs(message.data.rewards) do
        if state == 2 then
            count = count + 1
        end
    end

    if count == 3 then
        for i, systemItem in pairs(self.systemTemplateList) do
            if systemItem.args.id == 203 then
                GUI:SetActive(systemItem.view.root, false)
            end
        end
    end
end

function this:OnClicksysExpandBtn()
    if self.topSystemType ~= ETopSystemType.None then
        GUI:setVisible(self.view.sysExpand, false)
        GUI:setVisible(self.view.sysFold, true)
        self.topSystemType = ETopSystemType.None
        --GUI:setContentSize(self.view.systemMenu,470,115)
        self:RefreshSystemMenu()
        --隐藏boss血条
        SL:onLUAEvent(LUA_EVENT_HIDE_BOSS_HP)
    end
    self:StartAutoFoldCountTime()
end

function this:OnClicksysFoldBtn()
    if self.topSystemType ~= ETopSystemType.Show then
        GUI:setVisible(self.view.sysExpand, true)
        GUI:setVisible(self.view.sysFold, false)
        self.topSystemType = ETopSystemType.Show
        --GUI:setContentSize(self.view.systemMenu,170,115)
        self:RefreshSystemMenu()
        --取消隐藏boss血条
        SL:onLUAEvent(LUA_EVENT_CANCEL_HIDE_BOSS_HP)
    end
    self:StopAutoFoldCountTime()
end

function this:OnClickBossBtn()
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI", 215, "id")
    --EventManager.Dispatch(LUA_EVENT_OPENMAINSYSTEMFUNCTION, tbl and tbl.systemId or "挑战首领")
    SL:LUA_EVENT_OPENMAINSYSTEMFUNCTION(tbl and tbl.systemId or "挑战首领")
end

function this:OnClickMonthCardBtn()
    ---@type cfg_MainPanelUI_column
    local tbl = SL:GetConfig("cfg_MainPanelUI", 230, "id")
    --EventManager.Dispatch(LUA_EVENT_OPENMAINSYSTEMFUNCTION, tbl and tbl.systemId or "挑战首领")
    SL:LUA_EVENT_OPENMAINSYSTEMFUNCTION(tbl and tbl.systemId or "月卡")
end

function this:RefreshFixedSystemBtn()
    foldoutStartPos = 0
    local maxShowCount = maxShowTotalCount
    for i, v in pairs(fixedShowBtns) do
        if SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, i) then
            foldoutStartPos = foldoutStartPos - systemBtnInterval
            maxShowCount = maxShowCount - 1
        end
    end

    GUI:setPositionX(self.view.systemMenu, foldoutStartPos)
    if self.topSystemType == ETopSystemType.Show then
        --GUI:setPositionX(self.view.expanfBg, foldoutStartPos)
    else
        local maxCount = math.min(self.showBtnCount, maxShowCount)
        --GUI:setPositionX(self.view.expanfBg, foldoutStartPos - maxCount * 70 - (maxCount - 1) * 4)
    end
end

function this:LUA_EVENT_CHANGESCENE(_, data)
    ---@type cfg_map_info_column
    local tbl = SL:GetConfig("cfg_map_info", data.cfgId)
    if tbl and tbl.type == EMapType.CopyMap then
        self:OnClicksysFoldBtn()
    end
end

function this:LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE(_, data)
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    ---@type cfg_map_info_column
    local tbl = SL:GetConfig("cfg_map_info", mapId)
    if tbl and tbl.type == EMapType.CopyMap then
        self:OnClicksysFoldBtn()
    end
end

---清除数据
function this:Clear()
    --if GUI:GetUI("dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanel") then
    --    GUI:UIPanel_Close("dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanel")
    --end
    if self.systemTemplateList then
        ---@param systemItem KLUISystemItem
        for i, systemItem in pairs(self.systemTemplateList) do
            --GUI:UIPanel_Close(nil, systemItem)
            GUI:setVisible(systemItem.view.root)
            self.systemTemplateUnusedList[systemItem.args.id] = systemItem
        end
    end
    
    self.systemTemplateList = {}
    self.cur_monthCard_effect = nil
    if self.PushGiftTimer then
        SL:UnSchedule(self.PushGiftTimer)
        self.PushGiftTimer = nil
    end
    if self.mountPreTimer then
        SL:UnSchedule(self.mountPreTimer)
        self.mountPreTimer = nil
    end
    self.TimeLimitGiftNextEndGroup = nil
	if self.TimeLimitGiftTimer then
        SL:UnSchedule(self.TimeLimitGiftTimer)
		self.TimeLimitGiftTimer = nil
    end
    if self.MainOperateTimer then
        SL:UnSchedule(self.MainOperateTimer)
        self.MainOperateTimer = nil
    end
    if self.MainOperateTimer2 then
        SL:UnSchedule(self.MainOperateTimer2)
        self.MainOperateTimer2 = nil
    end
end

function this:CreateBtn(systemName)
    ---@type cfg_MainPanelUI_column
    local v = SL:cfg_MainPanelUI_post_GetSystemInfoBySystemId(systemName)
    if v and v.displayLocation == self.systemType and (self.topSystemType == ETopSystemType.None or (self.topSystemType == ETopSystemType.Show and v.shrink == ETopSystemType.Show)) then
        local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, v.systemId)
        if v.systemId == "运营活动" then
            --运营活动入口显隐由后端和system_switch表配置决定
            isMeet = InfoManager.mainOperateActivityInfo.isOperateActivityMainBtnShow and isMeet
            if isMeet then
                ---@type KLUISystemItem
                local systemTopTemplatePanelItem = self:CreateSystemBtn(v)
                local TimeText = systemTopTemplatePanelItem.view.TimeText
                local endTime = (InfoManager.mainOperateActivityInfo.operateActivityTypeCloseTime - Time.GetServerTime()) // 1000
                if endTime > 0 then
                    GUI:setVisible(TimeText, true)
                    self.MainOperateTimer = SL:Schedule(self.MainOperateTimer, 0, 1, endTime+1, function()
                        local timeText = (InfoManager.mainOperateActivityInfo.operateActivityTypeCloseTime - Time.GetServerTime()) // 1000
                        GUI:Text_setString(TimeText, GUIUtil.FormatTimeHMS(timeText))
                        if timeText <= 0 then
                            GUI:setVisible(TimeText, false)
                            return
                        end
                    end)
                else
                    GUI:setVisible(TimeText, false)
                end
            end
        elseif v.systemId == "运营活动2" then
            --运营活动入口显隐由后端和system_switch表配置决定
            isMeet = InfoManager.mainOperateActivitySecondInfo.isOperateActivityMainBtnShow and isMeet
            if isMeet then
                ---@type KLUISystemItem
                local systemTopTemplatePanelItem = self:CreateSystemBtn(v)
                local TimeText = systemTopTemplatePanelItem.view.TimeText
                local endTime = (InfoManager.mainOperateActivitySecondInfo.operateActivityTypeCloseTime - Time.GetServerTime()) // 1000
                if endTime > 0 then
                    GUI:setVisible(TimeText, true)
                    self.MainOperateTimer2 = SL:Schedule(self.MainOperateTimer2, 0, 1, endTime+1, function()
                        local timeText = (InfoManager.mainOperateActivitySecondInfo.operateActivityTypeCloseTime - Time.GetServerTime()) // 1000
                        GUI:Text_setString(TimeText, GUIUtil.FormatTimeHMS(timeText))
                        if timeText <= 0 then
                            GUI:setVisible(TimeText, false)
                            return
                        end
                    end)
                else
                    GUI:setVisible(TimeText, false)
                end
            end
        elseif v.systemId == "特惠礼包" then
            isMeet = InfoManager.rechargePushInfo:IsShowBtn()
            local endTime = (InfoManager.rechargePushInfo.endTime - Time.GetServerTime()) // 1000
            if endTime > 0 and isMeet then
                ---@type KLUISystemItem
                local systemTopTemplatePanelItem = self:CreateSystemBtn(v)
                local TimeText = systemTopTemplatePanelItem.view.TimeText
                local BtnPanel = systemTopTemplatePanelItem.view.root
                GUI:setVisible(TimeText, true)
                self.PushGiftTimer = SL:Schedule(self.PushGiftTimer, 0, 1, endTime + 1, function()
                    local timeText = InfoManager.rechargePushInfo.endTime - Time.GetServerTime()
                    GUI:Text_setString(TimeText, GUIUtil.FormatTimeHMS(timeText // 1000))
                    if timeText <= 0 then
                        GUI:setVisible(BtnPanel, false)
                        GUI:setVisible(TimeText, false)
                        return
                    end
                end)
            end
        elseif v.systemId == "首充" then
            isMeet = InfoManager.uiFirstChargeInfo:IsShowBtn()
            if isMeet then
                self:CreateSystemBtn(v)
            end
            --if isMeet then
            --    local RoleId = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
            --    local IsShow = PlayerPrefs.GetString("FirstChargeAdComplete" .. RoleId, "false")
            --    if IsShow then
            --        local reTime = PlayerPrefs.GetString("FirstChargeAdTime" .. RoleId, "0")
            --        if tonumber(reTime) > 0 then
            --            local careerId = PlayerPrefs.GetString("FirstChargeAdPopUpsPictureCareerID" ..RoleId,  "")
            --            local Icon = PlayerPrefs.GetString("FirstChargeAdPopUpsPictureIcon" ..RoleId,  "")
            --            GUI:UIPanel_Open("dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanel", nil, nil, { count = tonumber(reTime),popUpsPicture={careerId,Icon} })
            --        end
            --    end
            --end
        elseif v.systemId == "限时礼包" then
            isMeet = InfoManager.rechargeActivityInfo:IsShowTimeLimitGiftBtn()
            if isMeet then
                ---@type KLUISystemItem
                local systemTopTemplatePanelItem = self:CreateSystemBtn(v)
                local TimeText = systemTopTemplatePanelItem.view.TimeText
                local BtnPanel = systemTopTemplatePanelItem.view.root
                local msgEndTime = InfoManager.rechargeActivityInfo:GetTimeLimitGiftEndTime()
                if msgEndTime then
                    local endTime = (msgEndTime - Time.GetServerTime()) // 1000
                    if endTime > 0 then
                        GUI:setVisible(TimeText, true)
                        local maxTime = InfoManager.rechargeActivityInfo:GetMaxTimeLimitGiftEndTime()
                        self.TimeLimitGiftTimer = SL:Schedule(self.TimeLimitGiftTimer, 0, 1, maxTime+1, function()
                            local endTime1,TimeLimitGiftNextEndGroup = InfoManager.rechargeActivityInfo:GetTimeLimitGiftEndTime()
                            local maxTime1 = InfoManager.rechargeActivityInfo:GetMaxTimeLimitGiftEndTime()
                            if not endTime1 then
                                --SL:LogError("全买光或过期或没有")
                                GUI:setVisible(BtnPanel, false)
                                GUI:setVisible(TimeText, false)
                                local panel = GUI:GetUI("dev/outui/Recharge/Panel/KLRechargeActivity/KLRechargeActivityPanel")
                                if panel then
                                    GUI:UIPanel_Close("dev/outui/Recharge/Panel/KLRechargeActivity/KLRechargeActivityPanel")
                                    SL.ShowMainPanel()
                                end
                                return
                            end
                            local timeText = endTime1 - Time.GetServerTime()
                            GUI:Text_setString(TimeText, GUIUtil.FormatTimeHMS(timeText // 1000))
                            if not self.TimeLimitGiftNextEndGroup or TimeLimitGiftNextEndGroup ~= self.TimeLimitGiftNextEndGroup then
                                --SL:LogError("转到下一个礼包（）")
                                self.TimeLimitGiftNextEndGroup = TimeLimitGiftNextEndGroup
                                local panel = GUI:GetUI("dev/outui/Recharge/Panel/KLRechargeActivity/KLRechargeActivityPanel")
                                if panel then
                                    panel:Refresh()
                                end
                            end
                            --SL:LogError("endTime1"..(timeText // 1000).."     maxTime1"..maxTime1)
                            if timeText < 1000 then
                                if timeText // 1000 == maxTime1 then
                                    --SL:LogError("倒计时结束")
                                    GUI:setVisible(BtnPanel, false)
                                    GUI:setVisible(TimeText, false)
                                    local panel = GUI:GetUI("dev/outui/Recharge/Panel/KLRechargeActivity/KLRechargeActivityPanel")
                                    if panel then
                                        GUI:UIPanel_Close("dev/outui/Recharge/Panel/KLRechargeActivity/KLRechargeActivityPanel")
                                        SL.ShowMainPanel()
                                    end
                                    return
                                else
                                    --SL:LogError("转到下一个礼包2")
                                    local panel = GUI:GetUI("dev/outui/Recharge/Panel/KLRechargeActivity/KLRechargeActivityPanel")
                                    if panel then
                                        panel:Refresh()
                                    end
                                end
                            end
                        end)
                    else
                        GUI:setVisible(BtnPanel, false)
                        GUI:setVisible(TimeText, false)
                    end
                else
                    GUI:setVisible(BtnPanel, false)
                    GUI:setVisible(TimeText, false)
                end
            end
        else
            if isMeet then
                ---@type KLUISystemItem
                local systemTopTemplatePanelItem = self:CreateSystemBtn(v)
                if v.systemId == "月卡" then
--[[                    if self.cur_monthCard_effect then
                        GUI:SetParent(self.cur_monthCard_effect, systemTopTemplatePanelItem)
                    else
                        ---@type cfg_model_effect_column
                        local effect_tbl = SL:GetConfig("cfg_model_effect", 20001, "id")
                        self.cur_monthCard_effect = GUI:Model_Create(systemTopTemplatePanelItem.view.root, {
                            id = "cur_monthCard_effect",
                            mscale = "1,1,1",
                            mrotate = "0,200,0",
                            zindex = "0",
                            x = "0",
                            y = "2",
                            z = "0",
                            a = "00",
                            src = effect_tbl.path
                        })
                    end]]
                end
            end
        end
    end
end

function this:CreateSystemBtn(tbl)
    if tbl.showon == 1 then
        return
    end
    ---@type KLUISystemItem
    local systemTopTemplatePanelItem
    if self.systemTemplateUnusedList[tbl.id] == nil then
        systemTopTemplatePanelItem = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLUISystem/KLUISystemItem", self.view.systemMenu, self, tbl, true)
    else
        systemTopTemplatePanelItem = self.systemTemplateUnusedList[tbl.id]
        GUI:setVisible(systemTopTemplatePanelItem.view.root)
    end
    table.insert(self.systemTemplateList, systemTopTemplatePanelItem)
    GUI:SetID(systemTopTemplatePanelItem.view.root, tbl.btnName)
    GUI:setVisible(systemTopTemplatePanelItem.view.root, true)

    table.sort(self.systemTemplateList,function(a, b)
        if a.args.sort < b.args.sort then
            return true
        end
        return false
    end)

    for i = 1, #self.systemTemplateList do
        ---@type KLUISystemItem
        local templateItem = self.systemTemplateList[i]
        GUI:setLocalZOrder(templateItem.view.root, i)
    end
    
    return systemTopTemplatePanelItem
end

function this:LUA_EVENT_MAIN_UI_VISIBLE(_, msg)
    if msg.vis then
        --self:StartAutoFoldCountTime()
    end
end

---开始自动折叠倒计时
function this:StartAutoFoldCountTime()
    if self.autoFoldTimer == nil then
        self.autoFoldTimer = SL:Schedule(self.autoFoldTimer, 0.02, 0.02, -1, self.AutoFoldCountTime, self)
    end
    self.AutoFoldTime = 15
end

---停止自动折叠倒计时
function this:StopAutoFoldCountTime()
    if self.autoFoldTimer == nil then
        return
    end
    SL:UnSchedule(self.autoFoldTimer)
    self.autoFoldTimer = nil
end

function this:AutoFoldCountTime()
    if InputExt.IsAnyOperation() then
        self.AutoFoldTime = 15
        return
    end
    self.AutoFoldTime = self.AutoFoldTime - 0.02
    if self.AutoFoldTime <= 0 then
        -- 自动收起
        self:OnClicksysFoldBtn()
    end
end

function this:Close()
    if self.PushGiftTimer then
        SL:UnSchedule(self.PushGiftTimer)
        self.PushGiftTimer = nil
    end
    if self.mountPreTimer then
        SL:UnSchedule(self.mountPreTimer)
        self.mountPreTimer = nil
    end
    self.TimeLimitGiftNextEndGroup = nil
	if self.TimeLimitGiftTimer then
        SL:UnSchedule(self.TimeLimitGiftTimer)
		self.TimeLimitGiftTimer = nil
    end
    self.cur_monthCard_effect = nil
    self.systemTemplateList = {}
    if self.MainOperateTimer then
        SL:UnSchedule(self.MainOperateTimer)
        self.MainOperateTimer = nil
    end
    if self.MainOperateTimer2 then
        SL:UnSchedule(self.MainOperateTimer2)
        self.MainOperateTimer2 = nil
    end
    self:StopAutoFoldCountTime()
end

return this

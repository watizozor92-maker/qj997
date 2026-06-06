---@class KLRedFortPanel:UIKmlLuaPanelBase
---@field view KLRedFortPanelView
---@field cfg cfg_rep_column
local KLRedFortPanel = class(UIKmlLuaPanelBase)
local this = KLRedFortPanel
---创建时调用一次
function this:Init()
    self.itemList = {}
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnClose, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.btnEnter, self, self.BtnEnterOnClick)
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLRedFort/KLRedFortPanel")
end

function this:BtnEnterOnClick()
    self.cfg = InfoManager.redFortInfo:GetCfgByLevel()
    ---@type cfg_activity_rule_column
    self.activityInfo = InfoManager.activityPreviewInfo:GetActivityInfo(InfoManager.redFortInfo.activityCfg.id)
    local isInTeam =  SL:GetMetaValue(EMetaVarGetKey.TEAM_IS_IN)
    if isInTeam then
        SL:TipMessage( SL:GetConfig('cfg_string',248).text, 1, NoticeType.NoticeMid )--"请先退出队伍！",
        return
    end
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if level < InfoManager.redFortInfo.activityCfg.level then
        SL:TipMessage( SL:GetConfig('cfg_string',249).text,1, NoticeType.NoticeMid )--"等级不足！", 
        return
    end
    if not self.cfg or not self.activityInfo then
        SL:TipMessage(SL:GetConfig('cfg_string',250).text,1, NoticeType.NoticeMid )-- "活动未开启", 
        return
    end
    if not self.activityInfo.open then
        SL:TipMessage(SL:GetConfig('cfg_string',251).text,1, NoticeType.NoticeMid )-- "本次活动报名已截止", 
        return
    end
    local isCopy = SL:Out_IsInCopy()
    if isCopy then
        SL:TipMessage("已在副本内",1, NoticeType.NoticeMid )
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, self.cfg.id)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:HideMainPanel()
    self:RefreshUI()
end

function this:RefreshUI()
    self.cfg = InfoManager.redFortInfo:GetCfgByMinLevel()
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    GUI:Text_setString(self.view.textLevel, tostring(InfoManager.redFortInfo.activityCfg.level).."级")
    if level < InfoManager.redFortInfo.activityCfg.level then
        GUI:Text_setTextColor(self.view.textLevel,EColor[EGradColor.red])
    else
        GUI:Text_setTextColor(self.view.textLevel,EColor[EGradColor.green])
    end

    local times = string.split(InfoManager.redFortInfo.activityCfg.timeText, "|")
    GUI:Text_setString(self.view.textOpenTime, times[1])
    GUI:Text_setString(self.view.textActivityTime, times[2])
    self:InitRewards()
    self:RefreshTimeText()
    if not self.timer then
        ---self.timer = Timer.StartLoopForever(1, self.RefreshTimeText, self)
        self.timer = SL:StartLoopForever(1, self.RefreshTimeText, self)
    end
end

function this:InitRewards()
    local itemRewards = self.cfg.UIreward
    if not itemRewards or #itemRewards == 0 then
        itemRewards = InfoManager.redFortInfo:GetCfgByMinLevel()
    end
    if #self.itemList >= #itemRewards then
        for i = 1, #self.itemList do
            if i <= #itemRewards then
                GUI:setVisible(self.itemList[i], true)
            else
                GUI:setVisible(self.itemList[i], false)
            end
        end
    else
        for i = #self.itemList + 1, #itemRewards do
            local itemId = itemRewards[i][1]
            local item = GUI:Item_Create(self.view.itemRoot, {
                width = "50",
                height = "50",
                itemid = itemId,
                mfixsize = "50,50",
                tips = "1",
                itemcustomcount = itemRewards[i][2]
            })
            GUI:AddOnClickEvent(item, self, function()
                SL:OpenTips(nil, itemId)
            end)
            table.insert(self.itemList, item)
        end
        for i = 1, #self.itemList do
            if i <= #itemRewards then
                GUI:setVisible(self.itemList[i], true)
            else
                GUI:setVisible(self.itemList[i], false)
            end
        end
    end
end

function this:RefreshTimeText()
    self.activityInfo = InfoManager.activityPreviewInfo:GetActivityInfo(InfoManager.redFortInfo.activityCfg.id)
    if self.activityInfo then
        if self.activityInfo.open then
            GUI:Text_setTextColor(self.view.textOpenTime,EColor[EGradColor.green])
            GUI:Text_setTextColor(self.view.textActivityTime,EColor[EGradColor.green])
        else
            GUI:Text_setTextColor(self.view.textOpenTime,EColor[EGradColor.red])
            GUI:Text_setTextColor(self.view.textActivityTime,EColor[EGradColor.red])
        end
    end
end

function this:Close()
    SL:ShowMainPanel()
    if self.timer then
        ---Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

return this

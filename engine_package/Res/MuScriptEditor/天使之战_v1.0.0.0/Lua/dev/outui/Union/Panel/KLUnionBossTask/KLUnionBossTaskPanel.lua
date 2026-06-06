---@class KLUnionBossTaskPanel:UIKmlLuaPanelBase
---@field view KLUnionBossTaskPanelView
local KLUnionBossTaskPanel = class(UIKmlLuaPanelBase)
local this = KLUnionBossTaskPanel
local UnionBossTaskPanelPath = "dev/outui/Union/Panel/KLUnionBossTask/KLUnionBossTaskPanel"
---创建时调用一次
function this:Init()
    self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
        return self:Tick()
    end)
    SL:KeepOpenPanel("KLUnionBossTaskPanel", true)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.exitBtn, self, self.BtnExitOnClick)
    GUI:AddOnClickEvent(self.view.btn_next, self, self.BtnNextOnClick)
    GUI:AddOnClickEvent(self.view.btn_auction, self, self.BtnAuctionOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
end
function this:LUA_EVENT_CHANGESCENE()
    if not SL:Out_IsInCopy() then
        local leftUpPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
        leftUpPanel:HookTaskPanel(nil)
        InfoManager.unionBossInfo.inChallengeBoss = false
        GUI:UIPanel_Close(UnionBossTaskPanelPath)
    end
end

function this:BtnExitOnClick()
    local data = { content = "离开副本将丢失进度，是否退出", okFunc = function()
        --请求退出副本
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EXIT_WAR_ALLIANCE)
    end }
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLSure/KLSurePanel", nil, nil, data)
end

function this:BtnNextOnClick()
    local curTransConfig = self.transConfigs[self.curLevel]
    if not curTransConfig then
        return
    end
    ---@type cfg_transfer_point_column
    local transferPoint = SL:GetConfig("cfg_transfer_point", tonumber(string.split(curTransConfig, "#")[2]))
    local pos = transferPoint.position
    SL:MapMove(pos[1], pos[2])
end

function this:BtnAuctionOnClick()
    GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel", nil, nil, "toggle_trade_union")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:Tick()
    ---@type cfg_repGlobal_column
    local config = SL:GetConfig("cfg_repGlobal", 14001001)
    local tipStr = string.format("前<color=#4CC5FE>%s</color>个通关的战盟将获得拍卖奖励", config.value)
    GUI:Text_setString(self.view.txt_pass_tip, tipStr)
end

function this:Tick()
    local endTime = InfoManager.unionBossInfo.dupEndTime
    local countdown = SL:SecondToHMS((endTime - SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)) // 1000)
    GUI:Text_setString(self.view.text_end_time, string.format("%02s:%02s", countdown.m, countdown.s))
end

function this:SetData(message)
    ---@type cfg_repGlobal_column
    local globalConfig = SL:GetConfig("cfg_repGlobal", 14001003)
    local value = globalConfig.value
    self.transConfigs = string.split(value, "|")

    self.curLevel = message.position or self.curLevel

    --local curRepMonsterId = tonumber(message.taskId)
    local count = #self.transConfigs + 1
    --[[while curRepMonsterId ~= 0 do
        count = count + 1
        ---@type cfg_repMonster_column
        local monster = SL:GetConfig("cfg_repMonster",curRepMonsterId)
        if monster and monster.nextID ~= 0 then
            curRepMonsterId = monster.nextID
        else
            curRepMonsterId = 0
        end
    end]]
    if message.phrase < count then
        GUI:Text_setString(self.view.text_level, string.format("<color=#ff2323>%d</color><color=#00ff00>/%d</color>", message.phrase, count))
    else
        GUI:Text_setString(self.view.text_level, string.format("<color=#00ff00>%d/%d</color>", message.phrase, count))
    end
    local forbidPass = message.nowCount < message.totalCount
    if forbidPass then
        GUI:Text_setString(self.view.text_progress, string.format("<color=#ff2323>%d</color><color=#00ff00>/%d</color>", message.nowCount, message.totalCount))
    else
        GUI:Text_setString(self.view.text_progress, string.format("<color=#00ff00>%d/%d</color>", message.nowCount, message.totalCount))
    end
    GUI:setVisible(self.view.btn_next, message.position ~= math.max(message.phrase,message.myCurrPhrase) and message.position < count)
    GUI:setVisible(self.view.btn_auction, message.goAuction ~= nil)
end

function this:Close()
    if self.tickTimer then
        SL:UnSchedule(self.tickTimer)
    end
end

return this

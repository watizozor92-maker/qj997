---@class KLWolfSoulFortressPanel:UIKmlLuaPanelBase
---@field view KLWolfSoulFortressPanelView
local KLWolfSoulFortressPanel = class(UIKmlLuaPanelBase)
local this =KLWolfSoulFortressPanel
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:RefreshTimeText()
    if not self.timer then
        self.timer = SL:StartLoopForever(1, self.RefreshTimeText, self) ---Timer.StartLoopForever(1, self.RefreshTimeText, self)
    end
end

function this:RefreshTimeText()
    if self.args then
        local endTime = self.args - SL.Time:GetServerTime() --Time.GetServerTime()
        if endTime > 0 and endTime < InfoManager.wolfSoulFortressInfo.nowWolfSoulFortressCfg.save * 1000 then
            GUI:Text_setString(self.view.textTime, "副本结束倒计时：".. SL.Time:FormatTimeHMS(math.floor(endTime))) ---Time.FormatTimeHMS(math.floor(endTime)))
        else
            GUI:Text_setString(self.view.textTime, "")
        end
    end
end

function this:Close()
    if self.timer then
        ---Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

return this

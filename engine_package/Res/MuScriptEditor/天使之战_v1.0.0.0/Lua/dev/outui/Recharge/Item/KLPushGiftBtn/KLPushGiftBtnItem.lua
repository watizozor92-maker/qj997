---@class KLPushGiftBtnItem:UIKmlLuaPanelBase
---@field view KLPushGiftBtnItemView
local KLPushGiftBtnItem = class(UIKmlLuaPanelBase)
local this = KLPushGiftBtnItem

---创建时调用一次
function this:Init()
    self.Timer = nil
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
   
end
---创建或者刷新界面数据时调用
function this:Refresh()
end
function this:ShowTime(endTime)
    self.Timer = SL:Schedule(self.Timer, 0, 1, endTime + 1, function()
        local timeText = endTime - Time.GetServerTime()
        GUI:Text_setString(self.view.Time, GUIUtil.FormatTimeHMS(timeText // 1000))
        if timeText <= 0 then
            local panel=GUI:GetUI("dev/outui/Recharge/Panel/KLRechargePush/KLRechargePushPanel")
            if panel then
                panel:Refresh()
            end
            return
        end
    end)
end

function this:Close()
    if self.Timer then
        SL:UnSchedule(self.Timer)
    end
    self.Timer = nil
end

return this

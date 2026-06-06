---@class KLNavTipPanel:UIKmlLuaPanelBase
---@field view KLNavTipPanelView
local KLNavTipPanel = class(UIKmlLuaPanelBase)
local this =KLNavTipPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_UI_SHOW_ME_PATH_MOVE, self.ShowMePathMove, self)
    SL:RegisterLUAEvent(LUA_EVENT_UI_SHOW_ME_PATH_STOP, self.ShowMePathStop, self)
end

function this:ShowMePathMove()
    GUI:SetActive(self.view.panel_content, true)
    self.animIndex = 0
    self.enableAnim = true
end

function this:ShowMePathStop()
    GUI:SetActive(self.view.panel_content, false)
    self.enableAnim = false
end

---界面显示时调用一次
function this:Show()
    self.tickTimer = SL:Schedule(self.tickTimer,0,1,-1,self.Tick,self)
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Hide()
end

function this:Close()
    SL:UnSchedule(self.tickTimer)
end

function this:Tick()
    if not self.enableAnim then
        return
    end
    GUI:Text_setText(self.view.text_tip, "自动寻路中" .. string.rep(".", self.animIndex))
    self.animIndex = (self.animIndex + 1) % 6
end

return this

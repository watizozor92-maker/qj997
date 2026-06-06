---@class KLLockPanel:UIKmlLuaPanelBase
---@field view KLLockPanelView
local KLLockPanel = class(UIKmlLuaPanelBase)
local this =KLLockPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetSliderOnValueChange(self.view.Slider,self,self.SliderOnValueChange)
    GUI:AddOnTouchEvent(self.view.Slider,self,self.SliderOnEndDrag)
end

function this:SliderOnValueChange(control,_,data)
    local value = math.ceil(data[1])
    if value >= 100 then
        GUI:UIPanel_Close("dev/ui/Setting/Panel/KLLock/KLLockPanel")
    end
end

function this:SliderOnEndDrag(control,eventType, data)
    if eventType == EUIEventName.OnEndDrag then
        GUI:Slider_setPercent(self.view.Slider,0)
    end
end

function this:Close()
end

return this

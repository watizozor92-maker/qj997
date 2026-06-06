---@class KLMapTransferAnimPanelPanel:UIKmlLuaPanelBase
---@field view KLMapTransferAnimPanelPanelView
local KLMapTransferAnimPanelPanel = class(UIKmlLuaPanelBase)
local this =KLMapTransferAnimPanelPanel
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.anim = Coroutine.Start(self.PlayAnim,self)
end

function this:PlayAnim()
    SL.HideMainPanel()
    local curFillAmount = 0
    while(curFillAmount < 1) do
        GUI:Image_setFillAmount(self.view.img_trans_anim, curFillAmount)
        curFillAmount = curFillAmount + Time.deltaTime
        Coroutine.WaitForEndOfFrame()
    end
    GUI:UIPanel_Close("dev/ui/Map/Panel/KLMapTransferAnimPanel/KLMapTransferAnimPanelPanel")
end

function this:Close()
    SL.ShowMainPanel()
    Coroutine.Stop(self.anim)
end

return this

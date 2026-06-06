---@class KLPickUpItem:UIKmlLuaPanelBase
---@field view KLPickUpItemView
local KLPickUpItem = class(UIKmlLuaPanelBase)
local this =KLPickUpItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:SetIsOnWithoutNotify(self.view.pick_toggle,self.args.isPickUp)
    GUI:Text_setString(self.view.pickItemName,self.args.name)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.pick_toggle,self,self.PickUpOnToggleValueChange)
end

function this:PickUpOnToggleValueChange(control,_,data)
    local isToggle = data[1]
    self.baseUI:SetData(self.args.pickUpId,isToggle)
end

function this:Close()
end

return this

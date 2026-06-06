---@class KLMailItemItem:UIKmlLuaPanelBase
---@field view KLMailItemItemView
---@field index
---@field mailId
---@field callback
---@field ui
local KLMailItemItem = class(UIKmlLuaPanelBase)
local this =KLMailItemItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.mail_btn_,self,self.SelectMail)
end
function this:SelectMail(index, mailId)
    self.callback(self.ui, self.index,self.mailId)
end
function this:Selected(isActive)
    GUI:SetActive(self.view.selected,isActive)
end

function this:Close()
end

return this

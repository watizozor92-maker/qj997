---@class KLStallChatSelectItem:UIKmlLuaPanelBase
---@field view KLStallChatSelectItemView
local KLStallChatSelectItem = class(UIKmlLuaPanelBase)
local this = KLStallChatSelectItem
---创建时调用一次
function this:Init()
   
end

---创建或者刷新界面数据时调用
function this:RefreshItem(data,select,StallPanel)
    self.data = data
    self.StallPanel = StallPanel
    self.select_id = select
    GUI:Text_setString(self.view.name,self.data.message.name)
    self:CheckShow()
end

function this:CheckShow()
    if self.select_id == self.data.message.id then
        GUI:setVisible(self.view.select, true)
    else
        GUI:setVisible(self.view.select, false)
    end
    
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.name,self,self.SelectClick)
end


function this:Close()
end

function this:SelectClick()
    self.StallPanel:Select(self.data.type,self.data.message.id)

end


return this

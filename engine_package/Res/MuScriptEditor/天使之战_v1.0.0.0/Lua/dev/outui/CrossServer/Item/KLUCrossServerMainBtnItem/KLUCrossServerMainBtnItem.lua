---@class KLUCrossServerMainBtnItem:UIKmlLuaPanelBase
---@field view KLUCrossServerMainBtnItemView
local KLUCrossServerMainBtnItem = class(UIKmlLuaPanelBase)
local this = KLUCrossServerMainBtnItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:RefreshItem(data,select_id,panel)
    self.panel = panel
    self.data = data
    
    GUI:Text_setString(self.view.type_name,self.data.name)
    if self.data.id == select_id then
        GUI:setVisible(self.view.level_select,true)
    else
        GUI:setVisible(self.view.level_select,false)
    end
end

function this:HideItem()
    GUI:setVisible(self.view.level_select,false)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn,self,self.OnclickIcon)
end


function this:OnclickIcon()
    self.panel:HideSelect()
    GUI:setVisible(self.view.level_select,true)
    self.panel:Select(self.data.id,self)
end


function this:Close()
end

return this

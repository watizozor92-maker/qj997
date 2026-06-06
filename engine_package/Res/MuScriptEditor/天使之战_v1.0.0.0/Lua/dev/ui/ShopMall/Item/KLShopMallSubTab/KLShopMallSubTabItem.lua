---@class KLShopMallSubTabItem:UIKmlLuaPanelBase
---@field view KLShopMallSubTabItemView
local KLShopMallSubTabItem = class(UIKmlLuaPanelBase)
local this =KLShopMallSubTabItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_menu_layer_column
    local config = self.args
    GUI:Text_setString(self.view.Label,config.name)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this

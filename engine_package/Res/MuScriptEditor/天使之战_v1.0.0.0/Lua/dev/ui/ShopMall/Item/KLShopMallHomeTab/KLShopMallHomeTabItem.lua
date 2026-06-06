---@class KLShopMallHomeTabItem:UIKmlLuaPanelBase
---@field view KLShopMallHomeTabItemView
local KLShopMallHomeTabItem = class(UIKmlLuaPanelBase)
local this =KLShopMallHomeTabItem
---创建时调用一次
function this:Init()
    ---@type cfg_menu_layer_column
    local config = self.args
    GUI:Text_setString(self.view.Label,config.name)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this

---@class KLBoxPrivilegePanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field close UIKmlLuaControl
---@field big_title UIKmlLuaControl
---@field fu_title UIKmlLuaControl
---@field content_bg UIKmlLuaControl
---@field left UIKmlLuaControl
---@field right UIKmlLuaControl
---@field toggle_group UIKmlLuaControl
---@field layout_38 UIKmlLuaControl
---@field toggle_list UIKmlLuaControl
---@field panel_1 UIKmlLuaControl
---@field att_point_1 UIKmlLuaControl
---@field att_title UIKmlLuaControl
---@field att_layout UIKmlLuaControl
---@field att_list UIKmlLuaControl
---@field activate_text UIKmlLuaControl
---@field appellation_point_1 UIKmlLuaControl
---@field att_title UIKmlLuaControl
---@field appellation_scroll UIKmlLuaControl
---@field appellation_layout UIKmlLuaControl
---@field appellation_list UIKmlLuaControl
---@field panel_2 UIKmlLuaControl
---@field att_point_2 UIKmlLuaControl
---@field att_title UIKmlLuaControl
---@field item_scroll UIKmlLuaControl
---@field item_layout UIKmlLuaControl
---@field item_list UIKmlLuaControl
---@field privilege_btn UIKmlLuaControl
---@field tip UIKmlLuaControl
---@field DownLoad UIKmlLuaControl
local KLBoxPrivilegePanelView = {}
setmetatable(KLBoxPrivilegePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MiracleBox/Panel/KLBoxPrivilege/KLBoxPrivilegePanelKml'
---@param parent UIKmlLuaControl
function KLBoxPrivilegePanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLBoxPrivilegePanelView

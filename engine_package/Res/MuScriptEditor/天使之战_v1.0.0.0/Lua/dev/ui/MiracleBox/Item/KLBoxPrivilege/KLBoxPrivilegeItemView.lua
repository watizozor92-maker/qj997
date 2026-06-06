---@class KLBoxPrivilegeItemView:UIKmlLuaViewBase
---@field toggle_privilege UIKmlLuaControl
---@field select_toggle UIKmlLuaControl
---@field text_privilege UIKmlLuaControl
local KLBoxPrivilegeItemView = {}
setmetatable(KLBoxPrivilegeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MiracleBox/Item/KLBoxPrivilege/KLBoxPrivilegeItemKml'
---@param parent UIKmlLuaControl
function KLBoxPrivilegeItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLBoxPrivilegeItemView

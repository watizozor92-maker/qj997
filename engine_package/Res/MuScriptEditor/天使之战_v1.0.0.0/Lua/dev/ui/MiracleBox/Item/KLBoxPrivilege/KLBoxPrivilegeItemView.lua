---@class KLBoxPrivilegeItemView:UIKmlLuaViewBase
---@field toggle_privilege UIKmlLuaControlHandler
---@field select_toggle UIKmlLuaControlHandler
---@field text_privilege UIKmlLuaControlHandler
local KLBoxPrivilegeItemView = {}
setmetatable(KLBoxPrivilegeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MiracleBox/Item/KLBoxPrivilege/KLBoxPrivilegeItemKml'
---@param parent UIKmlLuaControlHandler
function KLBoxPrivilegeItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLBoxPrivilegeItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MiracleBox/Item/KLBoxPrivilege/KLBoxPrivilegeItem']

return KLBoxPrivilegeItemView

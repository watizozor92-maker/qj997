---@class KLMapBranchItemView:UIKmlLuaViewBase
---@field branch_toggle UIKmlLuaControl
---@field btn_switch UIKmlLuaControl
---@field line_name UIKmlLuaControl
---@field line_state UIKmlLuaControl
---@field img_pk UIKmlLuaControl
---@field costText UIKmlLuaControl
local KLMapBranchItemView = {}
setmetatable(KLMapBranchItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Item/KLMapBranch/KLMapBranchItemKml'
---@param parent UIKmlLuaControl
function KLMapBranchItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMapBranchItemView

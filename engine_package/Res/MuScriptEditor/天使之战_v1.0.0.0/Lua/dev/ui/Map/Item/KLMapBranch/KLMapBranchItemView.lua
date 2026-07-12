---@class KLMapBranchItemView:UIKmlLuaViewBase
---@field branch_toggle UIKmlLuaControlHandler
---@field btn_switch UIKmlLuaControlHandler
---@field line_name UIKmlLuaControlHandler
---@field line_state UIKmlLuaControlHandler
---@field img_pk UIKmlLuaControlHandler
---@field costText UIKmlLuaControlHandler
local KLMapBranchItemView = {}
setmetatable(KLMapBranchItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Item/KLMapBranch/KLMapBranchItemKml'
---@param parent UIKmlLuaControlHandler
function KLMapBranchItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMapBranchItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Map/Item/KLMapBranch/KLMapBranchItem']

return KLMapBranchItemView

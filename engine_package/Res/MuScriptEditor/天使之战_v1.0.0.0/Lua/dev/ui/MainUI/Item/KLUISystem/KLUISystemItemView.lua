---@class KLUISystemItemView:UIKmlLuaViewBase
---@field sysIcon UIKmlLuaControl
---@field red UIKmlLuaControl
---@field TimeText UIKmlLuaControl
local KLUISystemItemView = {}
setmetatable(KLUISystemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLUISystem/KLUISystemItemKml'
---@param parent UIKmlLuaControl
function KLUISystemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUISystemItemView

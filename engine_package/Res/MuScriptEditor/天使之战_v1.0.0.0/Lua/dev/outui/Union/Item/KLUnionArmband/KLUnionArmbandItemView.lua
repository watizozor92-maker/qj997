---@class KLUnionArmbandItemView:UIKmlLuaViewBase
---@field img_55 UIKmlLuaControl
---@field predes UIKmlLuaControl
---@field preArr UIKmlLuaControl
---@field tag1 UIKmlLuaControl
---@field nextpreArr UIKmlLuaControl
---@field tag2 UIKmlLuaControl
local KLUnionArmbandItemView = {}
setmetatable(KLUnionArmbandItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Item/KLUnionArmband/KLUnionArmbandItemKml'
---@param parent UIKmlLuaControl
function KLUnionArmbandItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUnionArmbandItemView

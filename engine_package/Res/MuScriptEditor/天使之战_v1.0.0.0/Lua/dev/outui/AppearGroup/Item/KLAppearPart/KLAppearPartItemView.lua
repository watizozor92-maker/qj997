---@class KLAppearPartItemView:UIKmlLuaViewBase
---@field SpTag UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field gridview1 UIKmlLuaControlHandler
---@field datalist11 UIKmlLuaControlHandler
local KLAppearPartItemView = {}
setmetatable(KLAppearPartItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Item/KLAppearPart/KLAppearPartItemKml'
---@param parent UIKmlLuaControlHandler
function KLAppearPartItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLAppearPartItemView

---@class KLAttPointSuitItemView:UIKmlLuaViewBase
---@field ImgSuitName UIKmlLuaControl
---@field ImgSuitPic UIKmlLuaControl
---@field TextSuitAdvantage UIKmlLuaControl
---@field BtnChoice UIKmlLuaControl
local KLAttPointSuitItemView = {}
setmetatable(KLAttPointSuitItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Role/Item/KLAttPointSuit/KLAttPointSuitItemKml'
---@param parent UIKmlLuaControl
function KLAttPointSuitItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLAttPointSuitItemView

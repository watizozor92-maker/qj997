---@class KLSuitItemView:UIKmlLuaViewBase
---@field SpTag UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field gridview1 UIKmlLuaControlHandler
---@field datalist11 UIKmlLuaControlHandler
local KLSuitItemView = {}
setmetatable(KLSuitItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Item/KLSuit/KLSuitItemKml'
---@param parent UIKmlLuaControlHandler
function KLSuitItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLSuitItemView

---@class KLTitleItemView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field TitleModel UIKmlLuaControlHandler
---@field SpState UIKmlLuaControlHandler
---@field TxtTime UIKmlLuaControlHandler
---@field TxtType UIKmlLuaControlHandler
---@field TimeDown UIKmlLuaControlHandler
local KLTitleItemView = {}
setmetatable(KLTitleItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Item/KLTitle/KLTitleItemKml'
---@param parent UIKmlLuaControlHandler
function KLTitleItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTitleItemView

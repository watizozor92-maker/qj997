---@class KLAttPointSuitItemView:UIKmlLuaViewBase
---@field ImgSuitName UIKmlLuaControlHandler
---@field ImgSuitPic UIKmlLuaControlHandler
---@field TextSuitAdvantage UIKmlLuaControlHandler
---@field BtnChoice UIKmlLuaControlHandler
local KLAttPointSuitItemView = {}
setmetatable(KLAttPointSuitItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Role/Item/KLAttPointSuit/KLAttPointSuitItemKml'
---@param parent UIKmlLuaControlHandler
function KLAttPointSuitItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLAttPointSuitItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Role/Item/KLAttPointSuit/KLAttPointSuitItem']

return KLAttPointSuitItemView

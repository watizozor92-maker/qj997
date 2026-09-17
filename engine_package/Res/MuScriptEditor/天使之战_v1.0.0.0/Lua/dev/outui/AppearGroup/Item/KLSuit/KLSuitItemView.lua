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
---@type KLSuitItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/AppearGroup/Item/KLSuit/KLSuitItem']

return KLSuitItemView

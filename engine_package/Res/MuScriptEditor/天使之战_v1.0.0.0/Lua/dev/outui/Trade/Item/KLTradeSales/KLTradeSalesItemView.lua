---@class KLTradeSalesItemView:UIKmlLuaViewBase
---@field null_panel UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field add UIKmlLuaControlHandler
---@field null_title UIKmlLuaControlHandler
---@field have_panel UIKmlLuaControlHandler
---@field Item_btn UIKmlLuaControlHandler
local KLTradeSalesItemView = {}
setmetatable(KLTradeSalesItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Item/KLTradeSales/KLTradeSalesItemKml'
---@param parent UIKmlLuaControlHandler
function KLTradeSalesItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeSalesItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Item/KLTradeSales/KLTradeSalesItem']

return KLTradeSalesItemView

---@class KLTradeSalesItemView:UIKmlLuaViewBase
---@field null_panel UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field add UIKmlLuaControl
---@field null_title UIKmlLuaControl
---@field have_panel UIKmlLuaControl
---@field Item_btn UIKmlLuaControl
local KLTradeSalesItemView = {}
setmetatable(KLTradeSalesItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Item/KLTradeSales/KLTradeSalesItemKml'
---@param parent UIKmlLuaControl
function KLTradeSalesItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeSalesItemView

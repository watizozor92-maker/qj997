---@class KLSpecialNPCShopPanelView:UIKmlLuaViewBase
---@field Background UIKmlLuaControl
---@field title UIKmlLuaControl
---@field scrollerBg UIKmlLuaControl
---@field ItemList UIKmlLuaControl
---@field ItemLayout UIKmlLuaControl
---@field goods UIKmlLuaControl
---@field desButton UIKmlLuaControl
---@field CloseButton UIKmlLuaControl
---@field MoneyList UIKmlLuaControl
---@field MoneyList UIKmlLuaControl
---@field moneyBackground UIKmlLuaControl
---@field moneyText UIKmlLuaControl
---@field MUCoinBackground UIKmlLuaControl
---@field muCoinText UIKmlLuaControl
---@field MUBindCoinBackground UIKmlLuaControl
---@field muBindCoinText UIKmlLuaControl
---@field diamondBackground UIKmlLuaControl
---@field diamondText UIKmlLuaControl
---@field noItem UIKmlLuaControl
local KLSpecialNPCShopPanelView = {}
setmetatable(KLSpecialNPCShopPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/NPC/Panel/KLSpecialNPCShop/KLSpecialNPCShopPanelKml'
---@param parent UIKmlLuaControl
function KLSpecialNPCShopPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLSpecialNPCShopPanelView

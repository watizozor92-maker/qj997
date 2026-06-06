---@class KLSalesTipsPanelView:UIKmlLuaViewBase
---@field togglegroup13 UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field sales_panel UIKmlLuaControl
---@field img_16 UIKmlLuaControl
---@field panel_17 UIKmlLuaControl
---@field layout1 UIKmlLuaControl
---@field costNode UIKmlLuaControl
---@field text_18 UIKmlLuaControl
---@field txt_number UIKmlLuaControl
---@field number_minus UIKmlLuaControl
---@field number_add UIKmlLuaControl
---@field priceNode_1 UIKmlLuaControl
---@field toggle_1 UIKmlLuaControl
---@field txt_price_unit_1 UIKmlLuaControl
---@field img_coin_unit_1 UIKmlLuaControl
---@field priceNode_2 UIKmlLuaControl
---@field toggle_2 UIKmlLuaControl
---@field txt_price_unit_2 UIKmlLuaControl
---@field img_coin_unit_2 UIKmlLuaControl
---@field priceNode_3 UIKmlLuaControl
---@field toggle_3 UIKmlLuaControl
---@field txt_price_unit_3 UIKmlLuaControl
---@field img_coin_unit_3 UIKmlLuaControl
---@field priceNode_4 UIKmlLuaControl
---@field toggle_4 UIKmlLuaControl
---@field txt_price_unit_4 UIKmlLuaControl
---@field img_coin_unit_4 UIKmlLuaControl
---@field priceNode_5 UIKmlLuaControl
---@field toggle_5 UIKmlLuaControl
---@field txt_price_unit_5 UIKmlLuaControl
---@field img_coin_unit_5 UIKmlLuaControl
---@field allNode UIKmlLuaControl
---@field text_25 UIKmlLuaControl
---@field img_26 UIKmlLuaControl
---@field img_coin_total UIKmlLuaControl
---@field txt_price_total UIKmlLuaControl
---@field panel1 UIKmlLuaControl
---@field price_slider UIKmlLuaControl
---@field fillArea_attach UIKmlLuaControl
---@field fill_attach UIKmlLuaControl
---@field fillArea_attach UIKmlLuaControl
---@field handle_attach UIKmlLuaControl
---@field btnNode UIKmlLuaControl
---@field btn UIKmlLuaControl
local KLSalesTipsPanelView = {}
setmetatable(KLSalesTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLSalesTips/KLSalesTipsPanelKml'
---@param parent UIKmlLuaControl
function KLSalesTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLSalesTipsPanelView

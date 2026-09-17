---@class KLSalesTipsPanelView:UIKmlLuaViewBase
---@field togglegroup13 UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field sales_panel UIKmlLuaControlHandler
---@field img_16 UIKmlLuaControlHandler
---@field panel_17 UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field costNode UIKmlLuaControlHandler
---@field text_18 UIKmlLuaControlHandler
---@field txt_number UIKmlLuaControlHandler
---@field number_minus UIKmlLuaControlHandler
---@field number_add UIKmlLuaControlHandler
---@field priceNode_1 UIKmlLuaControlHandler
---@field toggle_1 UIKmlLuaControlHandler
---@field txt_price_unit_1 UIKmlLuaControlHandler
---@field img_coin_unit_1 UIKmlLuaControlHandler
---@field priceNode_2 UIKmlLuaControlHandler
---@field toggle_2 UIKmlLuaControlHandler
---@field txt_price_unit_2 UIKmlLuaControlHandler
---@field img_coin_unit_2 UIKmlLuaControlHandler
---@field priceNode_3 UIKmlLuaControlHandler
---@field toggle_3 UIKmlLuaControlHandler
---@field txt_price_unit_3 UIKmlLuaControlHandler
---@field img_coin_unit_3 UIKmlLuaControlHandler
---@field priceNode_4 UIKmlLuaControlHandler
---@field toggle_4 UIKmlLuaControlHandler
---@field txt_price_unit_4 UIKmlLuaControlHandler
---@field img_coin_unit_4 UIKmlLuaControlHandler
---@field priceNode_5 UIKmlLuaControlHandler
---@field toggle_5 UIKmlLuaControlHandler
---@field txt_price_unit_5 UIKmlLuaControlHandler
---@field img_coin_unit_5 UIKmlLuaControlHandler
---@field allNode UIKmlLuaControlHandler
---@field text_25 UIKmlLuaControlHandler
---@field img_26 UIKmlLuaControlHandler
---@field img_coin_total UIKmlLuaControlHandler
---@field txt_price_total UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field price_slider UIKmlLuaControlHandler
---@field fillArea_attach UIKmlLuaControlHandler
---@field fill_attach UIKmlLuaControlHandler
---@field fillArea_attach UIKmlLuaControlHandler
---@field handle_attach UIKmlLuaControlHandler
---@field btnNode UIKmlLuaControlHandler
---@field btn UIKmlLuaControlHandler
local KLSalesTipsPanelView = {}
setmetatable(KLSalesTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLSalesTips/KLSalesTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSalesTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSalesTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Panel/KLSalesTips/KLSalesTipsPanel']

return KLSalesTipsPanelView

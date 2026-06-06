---@class KLTradeMainPanelView:UIKmlLuaViewBase
---@field img4 UIKmlLuaControlHandler
---@field img_33 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field img_36 UIKmlLuaControlHandler
---@field toggle_group_home_tab UIKmlLuaControlHandler
---@field layout_38 UIKmlLuaControlHandler
---@field toggle_trade_home UIKmlLuaControlHandler
---@field text_40 UIKmlLuaControlHandler
---@field toggle_month_card UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field toggle_trade_union UIKmlLuaControlHandler
---@field text_42 UIKmlLuaControlHandler
---@field toggle_trade_CrossServer UIKmlLuaControlHandler
---@field text_43 UIKmlLuaControlHandler
---@field toggle_trade_record UIKmlLuaControlHandler
---@field text_44 UIKmlLuaControlHandler
---@field toggle_trade_my_up UIKmlLuaControlHandler
---@field text_46 UIKmlLuaControlHandler
---@field img_52 UIKmlLuaControlHandler
---@field img_53 UIKmlLuaControlHandler
---@field img_54 UIKmlLuaControlHandler
---@field txt_qj_count UIKmlLuaControlHandler
---@field btn_qj_tip UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field scoreCount UIKmlLuaControlHandler
---@field scoreBtn UIKmlLuaControlHandler
---@field text_cost_tips UIKmlLuaControlHandler
---@field img_line UIKmlLuaControlHandler
local KLTradeMainPanelView = {}
setmetatable(KLTradeMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTradeMainPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeMainPanelView

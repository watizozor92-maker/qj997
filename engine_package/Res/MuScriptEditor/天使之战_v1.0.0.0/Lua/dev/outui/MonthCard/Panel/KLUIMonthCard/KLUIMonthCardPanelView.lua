---@class KLUIMonthCardPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field UI UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field item_model UIKmlLuaControlHandler
---@field GoTripleEarningBtn UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field TimeText UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field gridview UIKmlLuaControlHandler
---@field chat_Btn UIKmlLuaControlHandler
---@field tradeLine_Btn UIKmlLuaControlHandler
---@field TripleEarningsBtn UIKmlLuaControlHandler
---@field auto_pickUpBtn UIKmlLuaControlHandler
---@field auto_recyBtn UIKmlLuaControlHandler
---@field ex_privilegeBtn UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field inputText UIKmlLuaControlHandler
---@field Reduce_btn UIKmlLuaControlHandler
---@field Add_Btn UIKmlLuaControlHandler
---@field Buy_countText UIKmlLuaControlHandler
---@field monthCardBuy_Btn UIKmlLuaControlHandler
---@field daliyCardBuy_btn UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field LimitCount UIKmlLuaControlHandler
---@field Help_Btn UIKmlLuaControlHandler
---@field CloseBtn UIKmlLuaControlHandler
---@field text_cost_tips UIKmlLuaControlHandler
local KLUIMonthCardPanelView = {}
setmetatable(KLUIMonthCardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MonthCard/Panel/KLUIMonthCard/KLUIMonthCardPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMonthCardPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMonthCardPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MonthCard/Panel/KLUIMonthCard/KLUIMonthCardPanel']

return KLUIMonthCardPanelView

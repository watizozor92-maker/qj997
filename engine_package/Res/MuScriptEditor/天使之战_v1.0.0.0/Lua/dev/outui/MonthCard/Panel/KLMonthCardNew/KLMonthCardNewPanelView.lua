---@class KLMonthCardNewPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field left UIKmlLuaControlHandler
---@field content_scroll2 UIKmlLuaControlHandler
---@field content_layout_scroll2 UIKmlLuaControlHandler
---@field contentlist2 UIKmlLuaControlHandler
---@field bg_leftPrice UIKmlLuaControlHandler
---@field txt_leftPrice UIKmlLuaControlHandler
---@field txt_leftContent UIKmlLuaControlHandler
---@field btn_leftBuy UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field LeftTimeText UIKmlLuaControlHandler
---@field right UIKmlLuaControlHandler
---@field content_scroll UIKmlLuaControlHandler
---@field content_layout_scroll UIKmlLuaControlHandler
---@field contentlist UIKmlLuaControlHandler
---@field bg_rightPrice UIKmlLuaControlHandler
---@field txt_rightPrice UIKmlLuaControlHandler
---@field txt_rightContent UIKmlLuaControlHandler
---@field btn_rightBuy1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field RightTimeText1 UIKmlLuaControlHandler
---@field btn_rightBuy2 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field RightTimeText2 UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field effectRoot UIKmlLuaControlHandler
---@field effect1 UIKmlLuaControlHandler
---@field effect2 UIKmlLuaControlHandler
local KLMonthCardNewPanelView = {}
setmetatable(KLMonthCardNewPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMonthCardNewPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMonthCardNewPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel']

return KLMonthCardNewPanelView

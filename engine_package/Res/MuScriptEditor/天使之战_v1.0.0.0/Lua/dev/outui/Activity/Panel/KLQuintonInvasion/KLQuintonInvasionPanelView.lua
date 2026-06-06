---@class KLQuintonInvasionPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field layout19 UIKmlLuaControlHandler
---@field enterTimeDes UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field enterLevel UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field activity_des UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field img11 UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field rewardList1 UIKmlLuaControlHandler
---@field rewardList2 UIKmlLuaControlHandler
---@field rewardList UIKmlLuaControlHandler
---@field rewardBtn UIKmlLuaControlHandler
---@field enterBtn UIKmlLuaControlHandler
---@field shopBtn UIKmlLuaControlHandler
local KLQuintonInvasionPanelView = {}
setmetatable(KLQuintonInvasionPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLQuintonInvasion/KLQuintonInvasionPanelKml'
---@param parent UIKmlLuaControlHandler
function KLQuintonInvasionPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLQuintonInvasionPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLQuintonInvasion/KLQuintonInvasionPanel']

return KLQuintonInvasionPanelView

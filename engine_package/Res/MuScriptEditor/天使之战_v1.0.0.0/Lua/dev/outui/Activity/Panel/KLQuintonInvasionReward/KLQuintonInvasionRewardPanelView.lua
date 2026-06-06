---@class KLQuintonInvasionRewardPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field img12 UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field openDay UIKmlLuaControlHandler
---@field opentime UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field activityDes UIKmlLuaControlHandler
---@field img13 UIKmlLuaControlHandler
---@field img14 UIKmlLuaControlHandler
---@field rewardMountDes UIKmlLuaControlHandler
---@field model UIKmlLuaControlHandler
---@field model_item UIKmlLuaControlHandler
---@field text18 UIKmlLuaControlHandler
---@field img19 UIKmlLuaControlHandler
---@field text20 UIKmlLuaControlHandler
---@field rewardList1 UIKmlLuaControlHandler
---@field layout23 UIKmlLuaControlHandler
---@field rewardList UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
local KLQuintonInvasionRewardPanelView = {}
setmetatable(KLQuintonInvasionRewardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLQuintonInvasionReward/KLQuintonInvasionRewardPanelKml'
---@param parent UIKmlLuaControlHandler
function KLQuintonInvasionRewardPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLQuintonInvasionRewardPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLQuintonInvasionReward/KLQuintonInvasionRewardPanel']

return KLQuintonInvasionRewardPanelView

---@class KLGoldChallengePanelView:UIKmlLuaViewBase
---@field bgRoot UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field FinishCount UIKmlLuaControlHandler
---@field FinishCountText UIKmlLuaControlHandler
---@field cost UIKmlLuaControlHandler
---@field costText UIKmlLuaControlHandler
---@field costModel UIKmlLuaControlHandler
---@field CloseBtn UIKmlLuaControlHandler
---@field tipsText UIKmlLuaControlHandler
---@field grid UIKmlLuaControlHandler
---@field items UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field RefreshBtn UIKmlLuaControlHandler
local KLGoldChallengePanelView = {}
setmetatable(KLGoldChallengePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLGoldChallenge/KLGoldChallengePanelKml'
---@param parent UIKmlLuaControlHandler
function KLGoldChallengePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLGoldChallengePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLGoldChallenge/KLGoldChallengePanel']

return KLGoldChallengePanelView

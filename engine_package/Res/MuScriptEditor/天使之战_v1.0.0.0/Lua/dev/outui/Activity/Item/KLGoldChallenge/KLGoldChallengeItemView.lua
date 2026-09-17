---@class KLGoldChallengeItemView:UIKmlLuaViewBase
---@field bgRoot UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field textRoot UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field textTask UIKmlLuaControlHandler
---@field textName UIKmlLuaControlHandler
---@field textMap UIKmlLuaControlHandler
---@field frame_2 UIKmlLuaControlHandler
---@field frame_3 UIKmlLuaControlHandler
---@field model UIKmlLuaControlHandler
---@field model1 UIKmlLuaControlHandler
---@field model2 UIKmlLuaControlHandler
---@field starGrid UIKmlLuaControlHandler
---@field getTaskBtnRoot UIKmlLuaControlHandler
---@field btnAbandon UIKmlLuaControlHandler
---@field btnGo UIKmlLuaControlHandler
---@field btnGetTask UIKmlLuaControlHandler
---@field btnSubmit UIKmlLuaControlHandler
---@field btnEffect UIKmlLuaControlHandler
---@field itemRootView UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field itemRoot UIKmlLuaControlHandler
local KLGoldChallengeItemView = {}
setmetatable(KLGoldChallengeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLGoldChallenge/KLGoldChallengeItemKml'
---@param parent UIKmlLuaControlHandler
function KLGoldChallengeItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLGoldChallengeItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLGoldChallenge/KLGoldChallengeItem']

return KLGoldChallengeItemView

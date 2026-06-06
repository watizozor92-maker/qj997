---@class KLGoldChallengeItemView:UIKmlLuaViewBase
---@field bgRoot UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field textRoot UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field textTask UIKmlLuaControl
---@field textName UIKmlLuaControl
---@field textMap UIKmlLuaControl
---@field frame_2 UIKmlLuaControl
---@field frame_3 UIKmlLuaControl
---@field model UIKmlLuaControl
---@field model1 UIKmlLuaControl
---@field starGrid UIKmlLuaControl
---@field getTaskBtnRoot UIKmlLuaControl
---@field btnAbandon UIKmlLuaControl
---@field btnGo UIKmlLuaControl
---@field btnGetTask UIKmlLuaControl
---@field btnSubmit UIKmlLuaControl
---@field btnEffect UIKmlLuaControl
---@field itemRootView UIKmlLuaControl
---@field layout2 UIKmlLuaControl
---@field itemRoot UIKmlLuaControl
local KLGoldChallengeItemView = {}
setmetatable(KLGoldChallengeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLGoldChallenge/KLGoldChallengeItemKml'
---@param parent UIKmlLuaControl
function KLGoldChallengeItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLGoldChallengeItemView

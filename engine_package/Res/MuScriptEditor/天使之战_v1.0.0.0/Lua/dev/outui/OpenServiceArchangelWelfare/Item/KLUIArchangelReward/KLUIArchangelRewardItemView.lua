---@class KLUIArchangelRewardItemView:UIKmlLuaViewBase
---@field UIArchangelRewardTemplate UIKmlLuaControl
---@field UIArchangelRewardTemplateBg UIKmlLuaControl
---@field Image UIKmlLuaControl
---@field icon UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field numtext UIKmlLuaControl
---@field TextTime UIKmlLuaControl
---@field itemReward UIKmlLuaControl
---@field ClaimedText UIKmlLuaControl
---@field ClaimedIcon UIKmlLuaControl
---@field bg_1 UIKmlLuaControl
---@field effect_model UIKmlLuaControl
---@field Textcur UIKmlLuaControl
---@field remainCount UIKmlLuaControl
---@field getButton UIKmlLuaControl
---@field buyButton UIKmlLuaControl
local KLUIArchangelRewardItemView = {}
setmetatable(KLUIArchangelRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OpenServiceArchangelWelfare/Item/KLUIArchangelReward/KLUIArchangelRewardItemKml'
---@param parent UIKmlLuaControl
function KLUIArchangelRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIArchangelRewardItemView

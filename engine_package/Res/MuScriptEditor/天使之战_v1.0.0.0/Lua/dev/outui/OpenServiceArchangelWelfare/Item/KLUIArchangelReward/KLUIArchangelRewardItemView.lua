---@class KLUIArchangelRewardItemView:UIKmlLuaViewBase
---@field UIArchangelRewardTemplate UIKmlLuaControlHandler
---@field UIArchangelRewardTemplateBg UIKmlLuaControlHandler
---@field Image UIKmlLuaControlHandler
---@field icon UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field numtext UIKmlLuaControlHandler
---@field TextTime UIKmlLuaControlHandler
---@field itemReward UIKmlLuaControlHandler
---@field ClaimedText UIKmlLuaControlHandler
---@field ClaimedIcon UIKmlLuaControlHandler
---@field bg_1 UIKmlLuaControlHandler
---@field effect_model UIKmlLuaControlHandler
---@field Textcur UIKmlLuaControlHandler
---@field remainCount UIKmlLuaControlHandler
---@field getButton UIKmlLuaControlHandler
---@field redpoint UIKmlLuaControlHandler
---@field buyButton UIKmlLuaControlHandler
local KLUIArchangelRewardItemView = {}
setmetatable(KLUIArchangelRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OpenServiceArchangelWelfare/Item/KLUIArchangelReward/KLUIArchangelRewardItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIArchangelRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIArchangelRewardItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/OpenServiceArchangelWelfare/Item/KLUIArchangelReward/KLUIArchangelRewardItem']

return KLUIArchangelRewardItemView

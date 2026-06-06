---@class KLSelectRewardItemView:UIKmlLuaViewBase
---@field select_toggle UIKmlLuaControl
---@field selectName UIKmlLuaControl
local KLSelectRewardItemView = {}
setmetatable(KLSelectRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLSelectReward/KLSelectRewardItemKml'
---@param parent UIKmlLuaControl
function KLSelectRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLSelectRewardItemView

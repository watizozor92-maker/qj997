---@class KLSelectRewardItemView:UIKmlLuaViewBase
---@field select_toggle UIKmlLuaControlHandler
---@field selectName UIKmlLuaControlHandler
local KLSelectRewardItemView = {}
setmetatable(KLSelectRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLSelectReward/KLSelectRewardItemKml'
---@param parent UIKmlLuaControlHandler
function KLSelectRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSelectRewardItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLSelectReward/KLSelectRewardItem']

return KLSelectRewardItemView

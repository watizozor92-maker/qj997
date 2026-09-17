---@class KLBraveTrialsItemView:UIKmlLuaViewBase
---@field btn_level UIKmlLuaControlHandler
---@field img_level_select UIKmlLuaControlHandler
---@field img_title_bg UIKmlLuaControlHandler
---@field img_title_select UIKmlLuaControlHandler
---@field text_title UIKmlLuaControlHandler
---@field level_reward UIKmlLuaControlHandler
---@field img_level_reward_click UIKmlLuaControlHandler
local KLBraveTrialsItemView = {}
setmetatable(KLBraveTrialsItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BraveTrials/Item/KLBraveTrials/KLBraveTrialsItemKml'
---@param parent UIKmlLuaControlHandler
function KLBraveTrialsItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBraveTrialsItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/BraveTrials/Item/KLBraveTrials/KLBraveTrialsItem']

return KLBraveTrialsItemView

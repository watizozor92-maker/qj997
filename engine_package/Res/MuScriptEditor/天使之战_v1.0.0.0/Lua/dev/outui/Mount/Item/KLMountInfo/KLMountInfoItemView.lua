---@class KLMountInfoItemView:UIKmlLuaViewBase
---@field selectToggle UIKmlLuaControlHandler
---@field select UIKmlLuaControlHandler
---@field model_item_bg UIKmlLuaControlHandler
---@field mountIcon UIKmlLuaControlHandler
---@field item_model UIKmlLuaControlHandler
---@field tipClick UIKmlLuaControlHandler
---@field mountName UIKmlLuaControlHandler
---@field wear_mount_icon UIKmlLuaControlHandler
---@field endTime UIKmlLuaControlHandler
---@field gainTip UIKmlLuaControlHandler
---@field activeTip UIKmlLuaControlHandler
---@field red UIKmlLuaControlHandler
local KLMountInfoItemView = {}
setmetatable(KLMountInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Item/KLMountInfo/KLMountInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLMountInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMountInfoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Item/KLMountInfo/KLMountInfoItem']

return KLMountInfoItemView

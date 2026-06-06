---@class KLMountInfoItemView:UIKmlLuaViewBase
---@field selectToggle UIKmlLuaControl
---@field select UIKmlLuaControl
---@field model_item_bg UIKmlLuaControl
---@field mountIcon UIKmlLuaControl
---@field item_model UIKmlLuaControl
---@field tipClick UIKmlLuaControl
---@field mountName UIKmlLuaControl
---@field wear_mount_icon UIKmlLuaControl
---@field endTime UIKmlLuaControl
---@field gainTip UIKmlLuaControl
---@field activeTip UIKmlLuaControl
---@field red UIKmlLuaControl
local KLMountInfoItemView = {}
setmetatable(KLMountInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Item/KLMountInfo/KLMountInfoItemKml'
---@param parent UIKmlLuaControl
function KLMountInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMountInfoItemView

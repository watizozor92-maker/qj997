---@class KLMountAttInfoItemView:UIKmlLuaViewBase
---@field MsakBtn UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field MountItemData UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
local KLMountAttInfoItemView = {}
setmetatable(KLMountAttInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Item/KLMountAttInfo/KLMountAttInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLMountAttInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMountAttInfoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Item/KLMountAttInfo/KLMountAttInfoItem']

return KLMountAttInfoItemView

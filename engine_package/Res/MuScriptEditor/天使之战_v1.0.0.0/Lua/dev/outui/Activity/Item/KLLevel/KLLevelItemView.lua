---@class KLLevelItemView:UIKmlLuaViewBase
---@field KLLevel UIKmlLuaControlHandler
---@field noClick UIKmlLuaControlHandler
---@field levelName UIKmlLuaControlHandler
---@field no_btn UIKmlLuaControlHandler
local KLLevelItemView = {}
setmetatable(KLLevelItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLLevel/KLLevelItemKml'
---@param parent UIKmlLuaControlHandler
function KLLevelItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLLevelItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLLevel/KLLevelItem']

return KLLevelItemView

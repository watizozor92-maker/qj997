---@class KLTalentNameItemView:UIKmlLuaViewBase
---@field name_bg UIKmlLuaControlHandler
---@field talent_icon UIKmlLuaControlHandler
---@field talent_name UIKmlLuaControlHandler
---@field select UIKmlLuaControlHandler
local KLTalentNameItemView = {}
setmetatable(KLTalentNameItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Item/KLTalentName/KLTalentNameItemKml'
---@param parent UIKmlLuaControlHandler
function KLTalentNameItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTalentNameItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Item/KLTalentName/KLTalentNameItem']

return KLTalentNameItemView

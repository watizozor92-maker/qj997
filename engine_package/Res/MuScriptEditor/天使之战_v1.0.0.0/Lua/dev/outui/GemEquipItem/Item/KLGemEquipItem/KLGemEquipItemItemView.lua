---@class KLGemEquipItemItemView:UIKmlLuaViewBase
---@field bag_item_ UIKmlLuaControlHandler
---@field empty UIKmlLuaControlHandler
---@field item_model_ UIKmlLuaControlHandler
---@field item_count_unit UIKmlLuaControlHandler
---@field fluoriteLevel_ UIKmlLuaControlHandler
---@field strengthLevel_ UIKmlLuaControlHandler
---@field appendLevel_ UIKmlLuaControlHandler
---@field selectImg UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field gemCell1 UIKmlLuaControlHandler
---@field gemImg1 UIKmlLuaControlHandler
---@field gemCell2 UIKmlLuaControlHandler
---@field gemImg2 UIKmlLuaControlHandler
---@field gemCell3 UIKmlLuaControlHandler
---@field gemImg3 UIKmlLuaControlHandler
---@field selectTagImg UIKmlLuaControlHandler
---@field quality_ UIKmlLuaControlHandler
---@field holdImg_ UIKmlLuaControlHandler
---@field tipsIcon_ UIKmlLuaControlHandler
---@field arrow_ UIKmlLuaControlHandler
---@field puton UIKmlLuaControlHandler
---@field equipInfo UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field button2 UIKmlLuaControlHandler
---@field TimeText UIKmlLuaControlHandler
local KLGemEquipItemItemView = {}
setmetatable(KLGemEquipItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/GemEquipItem/Item/KLGemEquipItem/KLGemEquipItemItemKml'
---@param parent UIKmlLuaControlHandler
function KLGemEquipItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLGemEquipItemItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/GemEquipItem/Item/KLGemEquipItem/KLGemEquipItemItem']

return KLGemEquipItemItemView

---@class KLGemEquipItemItemView:UIKmlLuaViewBase
---@field bag_item_ UIKmlLuaControl
---@field empty UIKmlLuaControl
---@field item_model_ UIKmlLuaControl
---@field item_count_unit UIKmlLuaControl
---@field fluoriteLevel_ UIKmlLuaControl
---@field strengthLevel_ UIKmlLuaControl
---@field appendLevel_ UIKmlLuaControl
---@field selectImg UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field gemCell1 UIKmlLuaControl
---@field gemImg1 UIKmlLuaControl
---@field gemCell2 UIKmlLuaControl
---@field gemImg2 UIKmlLuaControl
---@field gemCell3 UIKmlLuaControl
---@field gemImg3 UIKmlLuaControl
---@field selectTagImg UIKmlLuaControl
---@field quality_ UIKmlLuaControl
---@field holdImg_ UIKmlLuaControl
---@field tipsIcon_ UIKmlLuaControl
---@field arrow_ UIKmlLuaControl
---@field puton UIKmlLuaControl
---@field equipInfo UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field button2 UIKmlLuaControl
---@field TimeText UIKmlLuaControl
local KLGemEquipItemItemView = {}
setmetatable(KLGemEquipItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/GemEquipItem/Item/KLGemEquipItem/KLGemEquipItemItemKml'
---@param parent UIKmlLuaControl
function KLGemEquipItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLGemEquipItemItemView

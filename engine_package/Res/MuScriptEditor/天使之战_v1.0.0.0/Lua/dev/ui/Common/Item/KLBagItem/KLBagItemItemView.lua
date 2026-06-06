---@class KLBagItemItemView:UIKmlLuaViewBase
---@field bag_item_ UIKmlLuaControlHandler
---@field empty UIKmlLuaControlHandler
---@field item_model_ UIKmlLuaControlHandler
---@field item_count_unit UIKmlLuaControlHandler
---@field fluoriteLevel_ UIKmlLuaControlHandler
---@field InteractionMaskPanel UIKmlLuaControlHandler
---@field InteractionMask UIKmlLuaControlHandler
---@field bindItemTips UIKmlLuaControlHandler
---@field bg_faceTrade UIKmlLuaControlHandler
---@field TimeText UIKmlLuaControlHandler
---@field button2 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field equipInfo UIKmlLuaControlHandler
---@field xinyun UIKmlLuaControlHandler
---@field puton UIKmlLuaControlHandler
---@field arrow_ UIKmlLuaControlHandler
---@field tipsIcon_ UIKmlLuaControlHandler
---@field holdImg_ UIKmlLuaControlHandler
---@field quality_ UIKmlLuaControlHandler
---@field selectTagImg UIKmlLuaControlHandler
---@field selectImg UIKmlLuaControlHandler
---@field img_dur0 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field gemCell1 UIKmlLuaControlHandler
---@field gemImg1 UIKmlLuaControlHandler
---@field gemCell2 UIKmlLuaControlHandler
---@field gemImg2 UIKmlLuaControlHandler
---@field gemCell3 UIKmlLuaControlHandler
---@field gemImg3 UIKmlLuaControlHandler
---@field appendLevel_ UIKmlLuaControlHandler
---@field strengthLevel_ UIKmlLuaControlHandler
---@field filterTagImg UIKmlLuaControlHandler
---@field select_faceTrade UIKmlLuaControlHandler
local KLBagItemItemView = {}
setmetatable(KLBagItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Item/KLBagItem/KLBagItemItemKml'
---@param parent UIKmlLuaControlHandler
function KLBagItemItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLBagItemItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Item/KLBagItem/KLBagItemItem']

return KLBagItemItemView

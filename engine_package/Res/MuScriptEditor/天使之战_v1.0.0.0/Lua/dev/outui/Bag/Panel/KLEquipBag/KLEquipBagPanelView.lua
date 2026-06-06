---@class KLEquipBagPanelView:UIKmlLuaViewBase
---@field cut_area_up UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
---@field img_68 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field person_shop_btn UIKmlLuaControlHandler
---@field storage_btn UIKmlLuaControlHandler
---@field recycle_btn UIKmlLuaControlHandler
---@field tidy_btn UIKmlLuaControlHandler
local KLEquipBagPanelView = {}
setmetatable(KLEquipBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Bag/Panel/KLEquipBag/KLEquipBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipBagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Bag/Panel/KLEquipBag/KLEquipBagPanel']

return KLEquipBagPanelView

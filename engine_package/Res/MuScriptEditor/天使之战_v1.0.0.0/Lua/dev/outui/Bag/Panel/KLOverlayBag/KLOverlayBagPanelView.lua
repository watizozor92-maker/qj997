---@class KLOverlayBagPanelView:UIKmlLuaViewBase
---@field cut_area_up UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
---@field img_14 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field person_shop_btn UIKmlLuaControlHandler
---@field storage_btn UIKmlLuaControlHandler
---@field recycle_btn UIKmlLuaControlHandler
---@field tidy_btn UIKmlLuaControlHandler
local KLOverlayBagPanelView = {}
setmetatable(KLOverlayBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Bag/Panel/KLOverlayBag/KLOverlayBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLOverlayBagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLOverlayBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Bag/Panel/KLOverlayBag/KLOverlayBagPanel']

return KLOverlayBagPanelView

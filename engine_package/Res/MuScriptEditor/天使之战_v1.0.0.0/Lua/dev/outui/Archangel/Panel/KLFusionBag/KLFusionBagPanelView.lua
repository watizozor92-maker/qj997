---@class KLFusionBagPanelView:UIKmlLuaViewBase
---@field cut_area_up UIKmlLuaControl
---@field cut_area_down UIKmlLuaControl
---@field img_495 UIKmlLuaControl
---@field title UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field sv_frame UIKmlLuaControl
---@field person_shop_btn UIKmlLuaControl
---@field storage_btn UIKmlLuaControl
---@field recycle_btn UIKmlLuaControl
---@field tidy_btn UIKmlLuaControl
local KLFusionBagPanelView = {}
setmetatable(KLFusionBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLFusionBag/KLFusionBagPanelKml'
---@param parent UIKmlLuaControl
function KLFusionBagPanelView:Init(parent)

    self:InitRoot(parent, kmlPath, KLFusionBagPanelView.content)
end
return KLFusionBagPanelView

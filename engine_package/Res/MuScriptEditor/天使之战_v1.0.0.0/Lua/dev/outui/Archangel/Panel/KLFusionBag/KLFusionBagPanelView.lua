---@class KLFusionBagPanelView:UIKmlLuaViewBase
---@field cut_area_up UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
---@field img_495 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field person_shop_btn UIKmlLuaControlHandler
---@field storage_btn UIKmlLuaControlHandler
---@field recycle_btn UIKmlLuaControlHandler
---@field tidy_btn UIKmlLuaControlHandler
local KLFusionBagPanelView = {}
setmetatable(KLFusionBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLFusionBag/KLFusionBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLFusionBagPanelView:Init(parent)

    self:InitRoot(parent, kmlPath, KLFusionBagPanelView.content)
end
---@type KLFusionBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLFusionBag/KLFusionBagPanel']

return KLFusionBagPanelView

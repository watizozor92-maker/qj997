---@class KLGemSlateBagPanelView:UIKmlLuaViewBase
---@field cut_area_up UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
---@field img_13 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field decomposeGem_Btn UIKmlLuaControlHandler
---@field combineSlate_Btn UIKmlLuaControlHandler
---@field combineGem_Btn UIKmlLuaControlHandler
local KLGemSlateBagPanelView = {}
setmetatable(KLGemSlateBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLGemSlateBagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLGemSlateBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel']

return KLGemSlateBagPanelView

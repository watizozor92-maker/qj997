---@class KLUIForgeGroupPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field toggleGroup UIKmlLuaControlHandler
---@field toggleLayout UIKmlLuaControlHandler
---@field strengthToggle UIKmlLuaControlHandler
---@field appendToggle UIKmlLuaControlHandler
---@field decomposeToggle UIKmlLuaControlHandler
---@field transferToggle UIKmlLuaControlHandler
---@field overlayToggle UIKmlLuaControlHandler
---@field JewelryToggle UIKmlLuaControlHandler
---@field RegenerateToggle UIKmlLuaControlHandler
---@field InlayToggle UIKmlLuaControlHandler
---@field luckyToggle UIKmlLuaControlHandler
---@field refineToggle UIKmlLuaControlHandler
---@field img_block UIKmlLuaControlHandler
local KLUIForgeGroupPanelView = {}
setmetatable(KLUIForgeGroupPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIForgeGroupPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIForgeGroupPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel']

return KLUIForgeGroupPanelView

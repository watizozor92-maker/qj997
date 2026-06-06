---@class KLArchangelGroupPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field toggleGroup UIKmlLuaControl
---@field toggleLayout UIKmlLuaControl
---@field breakthroughToggle UIKmlLuaControl
---@field grailToggle UIKmlLuaControl
---@field decomposeToggle UIKmlLuaControl
local KLArchangelGroupPanelView = {}
setmetatable(KLArchangelGroupPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanelKml'
---@param parent UIKmlLuaControl
function KLArchangelGroupPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLArchangelGroupPanelView

---@class KLArchangelGroupPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field toggleGroup UIKmlLuaControlHandler
---@field toggleLayout UIKmlLuaControlHandler
---@field breakthroughToggle UIKmlLuaControlHandler
---@field grailToggle UIKmlLuaControlHandler
---@field decomposeToggle UIKmlLuaControlHandler
local KLArchangelGroupPanelView = {}
setmetatable(KLArchangelGroupPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanelKml'
---@param parent UIKmlLuaControlHandler
function KLArchangelGroupPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLArchangelGroupPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel']

return KLArchangelGroupPanelView

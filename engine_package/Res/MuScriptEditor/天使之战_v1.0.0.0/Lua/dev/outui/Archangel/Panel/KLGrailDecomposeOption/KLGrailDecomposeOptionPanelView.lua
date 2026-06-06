---@class KLGrailDecomposeOptionPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field option_layout UIKmlLuaControl
---@field option_list UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field close UIKmlLuaControl
local KLGrailDecomposeOptionPanelView = {}
setmetatable(KLGrailDecomposeOptionPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLGrailDecomposeOption/KLGrailDecomposeOptionPanelKml'
---@param parent UIKmlLuaControl
function KLGrailDecomposeOptionPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLGrailDecomposeOptionPanelView

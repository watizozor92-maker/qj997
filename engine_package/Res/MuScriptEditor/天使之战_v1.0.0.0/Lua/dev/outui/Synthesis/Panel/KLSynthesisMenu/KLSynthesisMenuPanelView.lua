---@class KLSynthesisMenuPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
---@field scrollview4 UIKmlLuaControlHandler
---@field layout5 UIKmlLuaControlHandler
---@field DataList_SynthesisEntrys UIKmlLuaControlHandler
local KLSynthesisMenuPanelView = {}
setmetatable(KLSynthesisMenuPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Panel/KLSynthesisMenu/KLSynthesisMenuPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSynthesisMenuPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLSynthesisMenuPanelView

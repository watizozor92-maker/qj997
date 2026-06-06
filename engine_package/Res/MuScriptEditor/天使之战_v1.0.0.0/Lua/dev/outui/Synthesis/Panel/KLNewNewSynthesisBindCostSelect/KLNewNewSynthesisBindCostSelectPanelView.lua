---@class KLNewNewSynthesisBindCostSelectPanelView:UIKmlLuaViewBase
---@field Btn_MaskClose UIKmlLuaControlHandler
---@field Content UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field scrollview8 UIKmlLuaControlHandler
---@field layout9 UIKmlLuaControlHandler
---@field DataList_Cost UIKmlLuaControlHandler
---@field Btn_Confirm UIKmlLuaControlHandler
local KLNewNewSynthesisBindCostSelectPanelView = {}
setmetatable(KLNewNewSynthesisBindCostSelectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Panel/KLNewNewSynthesisBindCostSelect/KLNewNewSynthesisBindCostSelectPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNewNewSynthesisBindCostSelectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLNewNewSynthesisBindCostSelectPanelView

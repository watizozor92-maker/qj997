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
---@type KLNewNewSynthesisBindCostSelectPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Synthesis/Panel/KLNewNewSynthesisBindCostSelect/KLNewNewSynthesisBindCostSelectPanel']

return KLNewNewSynthesisBindCostSelectPanelView

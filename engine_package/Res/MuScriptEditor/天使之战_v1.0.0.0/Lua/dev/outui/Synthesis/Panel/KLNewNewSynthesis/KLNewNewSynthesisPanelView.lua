---@class KLNewNewSynthesisPanelView:UIKmlLuaViewBase
---@field Content UIKmlLuaControlHandler
---@field Text_Title UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
---@field SuccessRate UIKmlLuaControlHandler
---@field Text1 UIKmlLuaControlHandler
---@field Text_SuccessRate UIKmlLuaControlHandler
---@field Cost UIKmlLuaControlHandler
---@field Text_CostName UIKmlLuaControlHandler
---@field Text_CostValue UIKmlLuaControlHandler
---@field Banner UIKmlLuaControlHandler
---@field Item_Model UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field img14 UIKmlLuaControlHandler
---@field Text_SynthesisName UIKmlLuaControlHandler
---@field Text_MainTips UIKmlLuaControlHandler
---@field Btn_ShowTips UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field MainCostMat UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field Btn_LookPreview UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field DataList_MainCost UIKmlLuaControlHandler
---@field MinorCostMat UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field scrollview3 UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field DataList_MinorCost UIKmlLuaControlHandler
---@field AuxiliaryCostMat UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field scrollview11 UIKmlLuaControlHandler
---@field layout12 UIKmlLuaControlHandler
---@field DataList_AuxiliaryCost UIKmlLuaControlHandler
---@field Btn_Confirm UIKmlLuaControlHandler
---@field tishi UIKmlLuaControlHandler
---@field TabType UIKmlLuaControlHandler
---@field TogGroup_Tab UIKmlLuaControlHandler
---@field scrollview2 UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field DataList_TabType UIKmlLuaControlHandler
---@field NumSelect UIKmlLuaControlHandler
---@field NumSelectMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Input_PutNum UIKmlLuaControlHandler
---@field Btn_NumberMinus UIKmlLuaControlHandler
---@field Btn_NumberAdd UIKmlLuaControlHandler
---@field text_18 UIKmlLuaControlHandler
---@field Slider_PutNum UIKmlLuaControlHandler
---@field Btn_ConfirmPutNum UIKmlLuaControlHandler
local KLNewNewSynthesisPanelView = {}
setmetatable(KLNewNewSynthesisPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Panel/KLNewNewSynthesis/KLNewNewSynthesisPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNewNewSynthesisPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLNewNewSynthesisPanelView

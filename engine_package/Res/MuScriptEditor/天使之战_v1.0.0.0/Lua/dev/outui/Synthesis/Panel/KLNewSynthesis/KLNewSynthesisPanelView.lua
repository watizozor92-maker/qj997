---@class KLNewSynthesisPanelView:UIKmlLuaViewBase
---@field img4 UIKmlLuaControlHandler
---@field Content UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field Text_Title UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
---@field SuccessRate UIKmlLuaControlHandler
---@field Text1 UIKmlLuaControlHandler
---@field Text_SuccessRate UIKmlLuaControlHandler
---@field Cost UIKmlLuaControlHandler
---@field Text_CostName UIKmlLuaControlHandler
---@field Text_CostValue UIKmlLuaControlHandler
---@field Smelter11 UIKmlLuaControlHandler
---@field Smelter UIKmlLuaControlHandler
---@field Text_ResultPreview UIKmlLuaControlHandler
---@field Btn_LookPreview UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field synthesisName UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field Text_Tips UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field scrollview3 UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field Text_Tips2 UIKmlLuaControlHandler
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
local KLNewSynthesisPanelView = {}
setmetatable(KLNewSynthesisPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNewSynthesisPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLNewSynthesisPanelView

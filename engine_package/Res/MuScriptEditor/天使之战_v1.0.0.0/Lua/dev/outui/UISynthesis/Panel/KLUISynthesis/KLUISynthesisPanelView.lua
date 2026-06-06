---@class KLUISynthesisPanelView:UIKmlLuaViewBase
---@field Mask UIKmlLuaControlHandler
---@field Right UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeButton UIKmlLuaControlHandler
---@field ModelBG UIKmlLuaControlHandler
---@field Model UIKmlLuaControlHandler
---@field ModelName UIKmlLuaControlHandler
---@field ModelDescription UIKmlLuaControlHandler
---@field PreviewButton UIKmlLuaControlHandler
---@field MaterialTitle UIKmlLuaControlHandler
---@field MaterialScrollview UIKmlLuaControlHandler
---@field gridview7 UIKmlLuaControlHandler
---@field MaterialDataList UIKmlLuaControlHandler
---@field SuccessRateText UIKmlLuaControlHandler
---@field MaxCountText UIKmlLuaControlHandler
---@field SynthesisButton UIKmlLuaControlHandler
---@field SynthesisButton_Red UIKmlLuaControlHandler
---@field SelectCount UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field BtnMinus UIKmlLuaControlHandler
---@field Input UIKmlLuaControlHandler
---@field BtnAdd UIKmlLuaControlHandler
---@field Left UIKmlLuaControlHandler
---@field title2 UIKmlLuaControlHandler
---@field LeftButtonScrollview UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field LeftButtonDataList UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field Preview UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field scrollview3 UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field PreviewDataList UIKmlLuaControlHandler
---@field PreviewCloseButton UIKmlLuaControlHandler
---@field Special UIKmlLuaControlHandler
---@field SpecialCloseButton UIKmlLuaControlHandler
---@field SpecialBG UIKmlLuaControlHandler
---@field SelectSpecialButton UIKmlLuaControlHandler
---@field SpecialTitleText UIKmlLuaControlHandler
---@field SpecialItemScrollview UIKmlLuaControlHandler
---@field gridview20 UIKmlLuaControlHandler
---@field SpecialItemDataList UIKmlLuaControlHandler
local KLUISynthesisPanelView = {}
setmetatable(KLUISynthesisPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/UISynthesis/Panel/KLUISynthesis/KLUISynthesisPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISynthesisPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISynthesisPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/UISynthesis/Panel/KLUISynthesis/KLUISynthesisPanel']

return KLUISynthesisPanelView

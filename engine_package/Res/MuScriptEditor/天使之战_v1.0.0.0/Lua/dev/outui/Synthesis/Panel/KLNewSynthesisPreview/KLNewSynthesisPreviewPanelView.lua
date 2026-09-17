---@class KLNewSynthesisPreviewPanelView:UIKmlLuaViewBase
---@field Content UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field scrollview3 UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field DataList_Item UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLNewSynthesisPreviewPanelView = {}
setmetatable(KLNewSynthesisPreviewPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Panel/KLNewSynthesisPreview/KLNewSynthesisPreviewPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNewSynthesisPreviewPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLNewSynthesisPreviewPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Synthesis/Panel/KLNewSynthesisPreview/KLNewSynthesisPreviewPanel']

return KLNewSynthesisPreviewPanelView

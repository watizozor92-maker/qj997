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
---@type KLSynthesisMenuPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Synthesis/Panel/KLSynthesisMenu/KLSynthesisMenuPanel']

return KLSynthesisMenuPanelView

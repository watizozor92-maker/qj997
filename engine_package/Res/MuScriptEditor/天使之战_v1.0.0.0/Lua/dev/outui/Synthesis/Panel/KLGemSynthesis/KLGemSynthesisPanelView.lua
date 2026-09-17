---@class KLGemSynthesisPanelView:UIKmlLuaViewBase
---@field main UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field tabInfo UIKmlLuaControlHandler
---@field togglegroup_tab UIKmlLuaControlHandler
---@field scrollview_tab UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field datalist_tab UIKmlLuaControlHandler
---@field synthesisInfo UIKmlLuaControlHandler
---@field scrollview_synthesisInfo UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field target UIKmlLuaControlHandler
---@field img11 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field txt_targetTitle UIKmlLuaControlHandler
---@field target_bg UIKmlLuaControlHandler
---@field layout_target UIKmlLuaControlHandler
---@field datalist_target UIKmlLuaControlHandler
---@field btn_inlayInfo UIKmlLuaControlHandler
---@field txt_inlayInfo UIKmlLuaControlHandler
---@field cost UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field txt_costTitle UIKmlLuaControlHandler
---@field cost_bg UIKmlLuaControlHandler
---@field layout_cost UIKmlLuaControlHandler
---@field datalist_cost UIKmlLuaControlHandler
---@field desc UIKmlLuaControlHandler
---@field desc_bg UIKmlLuaControlHandler
---@field txt_costMoney UIKmlLuaControlHandler
---@field txt_successRate UIKmlLuaControlHandler
---@field btn_synthesis UIKmlLuaControlHandler
---@field result UIKmlLuaControlHandler
---@field img34 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field txt_resultTitle UIKmlLuaControlHandler
---@field result_bg UIKmlLuaControlHandler
---@field result_show UIKmlLuaControlHandler
---@field result_tip UIKmlLuaControlHandler
---@field inlayInfoPanel UIKmlLuaControlHandler
---@field inlayInfoPanel1 UIKmlLuaControlHandler
---@field inlayInfoContent UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field layout_inlay UIKmlLuaControlHandler
---@field datalist_inlay UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
local KLGemSynthesisPanelView = {}
setmetatable(KLGemSynthesisPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Panel/KLGemSynthesis/KLGemSynthesisPanelKml'
---@param parent UIKmlLuaControlHandler
function KLGemSynthesisPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLGemSynthesisPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Synthesis/Panel/KLGemSynthesis/KLGemSynthesisPanel']

return KLGemSynthesisPanelView

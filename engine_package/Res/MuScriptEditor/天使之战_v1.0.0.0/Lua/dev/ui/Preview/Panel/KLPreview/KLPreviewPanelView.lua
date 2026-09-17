---@class KLPreviewPanelView:UIKmlLuaViewBase
---@field PreviewUI UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img_367 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field slider1 UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field FG_line UIKmlLuaControlHandler
---@field togglegroup3 UIKmlLuaControlHandler
---@field layout5 UIKmlLuaControlHandler
---@field Tog_Guide UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field RedDot_Guide UIKmlLuaControlHandler
---@field Tog_Preview UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field RedDot_Preview UIKmlLuaControlHandler
---@field Previewview UIKmlLuaControlHandler
---@field layout UIKmlLuaControlHandler
---@field previewlist UIKmlLuaControlHandler
---@field content_scroll UIKmlLuaControlHandler
---@field content_layout_scroll UIKmlLuaControlHandler
---@field contentlist UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field BtnLayout UIKmlLuaControlHandler
---@field layoutelement_Reward UIKmlLuaControlHandler
---@field Item_Reward UIKmlLuaControlHandler
---@field layoutelement_BtnReceive UIKmlLuaControlHandler
---@field Btn_Receive UIKmlLuaControlHandler
---@field img_receiveRed UIKmlLuaControlHandler
---@field preview_receive UIKmlLuaControlHandler
---@field receive_btn UIKmlLuaControlHandler
---@field btnEffect UIKmlLuaControlHandler
---@field receive_text UIKmlLuaControlHandler
---@field receive_tips UIKmlLuaControlHandler
---@field rewardscroll UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field reward_data UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLPreviewPanelView = {}
setmetatable(KLPreviewPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Panel/KLPreview/KLPreviewPanelKml'
---@param parent UIKmlLuaControlHandler
function KLPreviewPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLPreviewPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Preview/Panel/KLPreview/KLPreviewPanel']

return KLPreviewPanelView

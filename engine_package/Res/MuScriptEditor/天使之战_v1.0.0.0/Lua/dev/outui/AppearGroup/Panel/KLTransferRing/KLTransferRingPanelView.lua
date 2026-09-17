---@class KLTransferRingPanelView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field BgList UIKmlLuaControlHandler
---@field BgTitle1 UIKmlLuaControlHandler
---@field TxtTitle1 UIKmlLuaControlHandler
---@field loopscrollview UIKmlLuaControlHandler
---@field loopscrollviewData UIKmlLuaControlHandler
---@field BgTitle2 UIKmlLuaControlHandler
---@field TxtTitle2 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field layout10 UIKmlLuaControlHandler
---@field datalist11 UIKmlLuaControlHandler
---@field BtnCancel UIKmlLuaControlHandler
---@field BtnSure UIKmlLuaControlHandler
local KLTransferRingPanelView = {}
setmetatable(KLTransferRingPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Panel/KLTransferRing/KLTransferRingPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTransferRingPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTransferRingPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/AppearGroup/Panel/KLTransferRing/KLTransferRingPanel']

return KLTransferRingPanelView

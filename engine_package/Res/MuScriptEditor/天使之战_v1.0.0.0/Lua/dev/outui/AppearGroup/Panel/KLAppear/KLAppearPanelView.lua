---@class KLAppearPanelView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field BgList UIKmlLuaControlHandler
---@field BgTitle UIKmlLuaControlHandler
---@field TxtTitle UIKmlLuaControlHandler
---@field loopscrollview UIKmlLuaControlHandler
---@field loopscrollviewData UIKmlLuaControlHandler
---@field BtnCancel UIKmlLuaControlHandler
---@field BtnSure UIKmlLuaControlHandler
---@field WndTitle UIKmlLuaControlHandler
local KLAppearPanelView = {}
setmetatable(KLAppearPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Panel/KLAppear/KLAppearPanelKml'
---@param parent UIKmlLuaControlHandler
function KLAppearPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLAppearPanelView

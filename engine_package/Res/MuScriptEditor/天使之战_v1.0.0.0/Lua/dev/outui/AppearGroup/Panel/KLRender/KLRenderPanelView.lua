---@class KLRenderPanelView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field WndTitle UIKmlLuaControlHandler
---@field loopscrollview UIKmlLuaControlHandler
---@field loopscrollviewData UIKmlLuaControlHandler
---@field BtnCancel UIKmlLuaControlHandler
---@field BtnSure UIKmlLuaControlHandler
---@field BgTitle UIKmlLuaControlHandler
---@field TxtTitle UIKmlLuaControlHandler
local KLRenderPanelView = {}
setmetatable(KLRenderPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Panel/KLRender/KLRenderPanelKml'
---@param parent UIKmlLuaControlHandler
function KLRenderPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRenderPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/AppearGroup/Panel/KLRender/KLRenderPanel']

return KLRenderPanelView

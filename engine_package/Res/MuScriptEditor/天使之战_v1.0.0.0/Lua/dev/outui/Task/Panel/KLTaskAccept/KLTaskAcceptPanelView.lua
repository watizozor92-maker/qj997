---@class KLTaskAcceptPanelView:UIKmlLuaViewBase
---@field main UIKmlLuaControlHandler
---@field bgMask UIKmlLuaControlHandler
---@field interior UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field img_taskTitle UIKmlLuaControlHandler
---@field txt_taskTitle UIKmlLuaControlHandler
---@field txt_content UIKmlLuaControlHandler
---@field btn_accept UIKmlLuaControlHandler
---@field txt_noTask UIKmlLuaControlHandler
local KLTaskAcceptPanelView = {}
setmetatable(KLTaskAcceptPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Task/Panel/KLTaskAccept/KLTaskAcceptPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTaskAcceptPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLTaskAcceptPanelView

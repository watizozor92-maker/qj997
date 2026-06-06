---@class KLShowStallPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field stop_stall UIKmlLuaControlHandler
---@field add_stall UIKmlLuaControlHandler
---@field sales_scroll UIKmlLuaControlHandler
---@field sales_grid UIKmlLuaControlHandler
---@field zanwushanping UIKmlLuaControlHandler
local KLShowStallPanelView = {}
setmetatable(KLShowStallPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Panel/KLShowStall/KLShowStallPanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLShowStallPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLShowStallPanelView

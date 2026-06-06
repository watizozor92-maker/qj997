---@class KLPopoverPanelView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field ScrollView UIKmlLuaControlHandler
---@field leftdatalist UIKmlLuaControlHandler
local KLPopoverPanelView = {}
setmetatable(KLPopoverPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Panel/KLPopover/KLPopoverPanelKml'
---@param parent UIKmlLuaControlHandler
function KLPopoverPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLPopoverPanelView

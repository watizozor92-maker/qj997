---@class KLUnionToggleListPanelView:UIKmlLuaViewBase
---@field ToggleUnionIcon UIKmlLuaControlHandler
---@field layout_56 UIKmlLuaControlHandler
---@field joinToggle UIKmlLuaControlHandler
---@field createToggle UIKmlLuaControlHandler
---@field ToggleUnionInIcon UIKmlLuaControlHandler
---@field layout_60 UIKmlLuaControlHandler
---@field infoToggle UIKmlLuaControlHandler
---@field armbandToggle UIKmlLuaControlHandler
---@field activityToggle UIKmlLuaControlHandler
---@field electionToggle UIKmlLuaControlHandler
---@field replaceToggle UIKmlLuaControlHandler
---@field campaignToggle UIKmlLuaControlHandler
---@field taskToggle UIKmlLuaControlHandler
---@field img_block UIKmlLuaControlHandler
local KLUnionToggleListPanelView = {}
setmetatable(KLUnionToggleListPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionToggleListPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUnionToggleListPanelView

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
---@type KLUnionToggleListPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel']

return KLUnionToggleListPanelView

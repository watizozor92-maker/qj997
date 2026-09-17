---@class KLSelfSelectBoxPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field NumText UIKmlLuaControlHandler
---@field scrollview UIKmlLuaControlHandler
---@field ItemLayout UIKmlLuaControlHandler
---@field loopscrollviewData UIKmlLuaControlHandler
---@field btnclose UIKmlLuaControlHandler
---@field btnopen UIKmlLuaControlHandler
local KLSelfSelectBoxPanelView = {}
setmetatable(KLSelfSelectBoxPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ItemBase/Panel/KLSelfSelectBox/KLSelfSelectBoxPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSelfSelectBoxPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLSelfSelectBoxPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/ItemBase/Panel/KLSelfSelectBox/KLSelfSelectBoxPanel']

return KLSelfSelectBoxPanelView

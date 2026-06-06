---@class KLSelfSelectBoxPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field text4 UIKmlLuaControl
---@field NumText UIKmlLuaControl
---@field scrollview UIKmlLuaControl
---@field ItemLayout UIKmlLuaControl
---@field loopscrollviewData UIKmlLuaControl
---@field btnclose UIKmlLuaControl
---@field btnopen UIKmlLuaControl
local KLSelfSelectBoxPanelView = {}
setmetatable(KLSelfSelectBoxPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ItemBase/Panel/KLSelfSelectBox/KLSelfSelectBoxPanelKml'
---@param parent UIKmlLuaControl
function KLSelfSelectBoxPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLSelfSelectBoxPanelView

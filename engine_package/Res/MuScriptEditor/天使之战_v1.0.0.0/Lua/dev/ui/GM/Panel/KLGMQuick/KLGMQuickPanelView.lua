---@class KLGMQuickPanelView:UIKmlLuaViewBase
---@field btnGM UIKmlLuaControl
---@field text UIKmlLuaControl
---@field btnGMMenu UIKmlLuaControl
---@field datas UIKmlLuaControl
local KLGMQuickPanelView = {}
setmetatable(KLGMQuickPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/GM/Panel/KLGMQuick/KLGMQuickPanelKml'
---@param parent UIKmlLuaControl
function KLGMQuickPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLGMQuickPanelView

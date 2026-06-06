---@class KLSanctuaryBossActivityPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field join_btn UIKmlLuaControl
---@field tishi UIKmlLuaControl
local KLSanctuaryBossActivityPanelView = {}
setmetatable(KLSanctuaryBossActivityPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CrossServer/Panel/KLSanctuaryBossActivity/KLSanctuaryBossActivityPanelKml'
---@param parent UIKmlLuaControl
function KLSanctuaryBossActivityPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLSanctuaryBossActivityPanelView

---@class KLEquipForgeEffectPanelView:UIKmlLuaViewBase
---@field strength_ok UIKmlLuaControlHandler
---@field strength_fail UIKmlLuaControlHandler
---@field xilian_ok UIKmlLuaControlHandler
---@field xilian_fail UIKmlLuaControlHandler
---@field huanyuan UIKmlLuaControlHandler
---@field zaisheng_ok UIKmlLuaControlHandler
---@field zaisheng_fail UIKmlLuaControlHandler
---@field jinhua_ok UIKmlLuaControlHandler
---@field jinhua_fail UIKmlLuaControlHandler
local KLEquipForgeEffectPanelView = {}
setmetatable(KLEquipForgeEffectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipForgeEffectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipForgeEffectPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel']

return KLEquipForgeEffectPanelView

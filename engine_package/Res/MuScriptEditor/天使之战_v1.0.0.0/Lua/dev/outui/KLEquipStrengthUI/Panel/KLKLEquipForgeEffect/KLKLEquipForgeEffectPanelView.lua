---@class KLKLEquipForgeEffectPanelView:UIKmlLuaViewBase
local KLKLEquipForgeEffectPanelView = {}
setmetatable(KLKLEquipForgeEffectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/KLEquipStrengthUI/Panel/KLKLEquipForgeEffect/KLKLEquipForgeEffectPanelKml'
---@param parent UIKmlLuaControlHandler
function KLKLEquipForgeEffectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLKLEquipForgeEffectPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/KLEquipStrengthUI/Panel/KLKLEquipForgeEffect/KLKLEquipForgeEffectPanel']

return KLKLEquipForgeEffectPanelView

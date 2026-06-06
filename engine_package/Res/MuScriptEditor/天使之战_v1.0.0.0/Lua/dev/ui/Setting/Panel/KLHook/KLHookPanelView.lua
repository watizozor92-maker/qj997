---@class KLHookPanelView:UIKmlLuaViewBase
---@field prefab_794 UIKmlLuaControlHandler
---@field ScopeOfMonster1 UIKmlLuaControlHandler
---@field ScopeOfMonster2 UIKmlLuaControlHandler
---@field explain UIKmlLuaControlHandler
---@field ScopeOfMonster3 UIKmlLuaControlHandler
---@field ScopeOfMonster4 UIKmlLuaControlHandler
---@field ScopeOfMonster5 UIKmlLuaControlHandler
---@field ScopeOfMonster6 UIKmlLuaControlHandler
---@field ScopeOfMonster7 UIKmlLuaControlHandler
---@field ScopeOfMonster8 UIKmlLuaControlHandler
---@field hpSlider UIKmlLuaControlHandler
---@field mpSlider UIKmlLuaControlHandler
---@field hpTxt UIKmlLuaControlHandler
---@field mpTxt UIKmlLuaControlHandler
---@field combackAtk UIKmlLuaControlHandler
---@field combackHookPoint UIKmlLuaControlHandler
---@field comebackTime UIKmlLuaControlHandler
---@field callSkill UIKmlLuaControlHandler
---@field CallSkillBtn UIKmlLuaControlHandler
---@field skillIcon UIKmlLuaControlHandler
---@field skillName UIKmlLuaControlHandler
---@field skillLevel UIKmlLuaControlHandler
---@field planToggleGroup UIKmlLuaControlHandler
---@field planToggle1 UIKmlLuaControlHandler
---@field planToggle2 UIKmlLuaControlHandler
---@field ContainerContent UIKmlLuaControlHandler
---@field HookSkillContainer UIKmlLuaControlHandler
local KLHookPanelView = {}
setmetatable(KLHookPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Panel/KLHook/KLHookPanelKml'
---@param parent UIKmlLuaControlHandler
function KLHookPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLHookPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Panel/KLHook/KLHookPanel']

return KLHookPanelView

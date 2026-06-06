---@class KLMainAttackPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field AttackButton UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field clickEffect UIKmlLuaControlHandler
---@field sword UIKmlLuaControlHandler
---@field Img_cdTime UIKmlLuaControlHandler
---@field killPerson UIKmlLuaControlHandler
---@field red2 UIKmlLuaControlHandler
---@field killMonster UIKmlLuaControlHandler
---@field yellow2 UIKmlLuaControlHandler
---@field BtnKillMonster UIKmlLuaControlHandler
---@field BtnKillPerson UIKmlLuaControlHandler
---@field mask_skill UIKmlLuaControlHandler
---@field SkillStruct UIKmlLuaControlHandler
---@field BtnMount UIKmlLuaControlHandler
local KLMainAttackPanelView = {}
setmetatable(KLMainAttackPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLMainAttack/KLMainAttackPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMainAttackPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMainAttackPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLMainAttack/KLMainAttackPanel']

return KLMainAttackPanelView

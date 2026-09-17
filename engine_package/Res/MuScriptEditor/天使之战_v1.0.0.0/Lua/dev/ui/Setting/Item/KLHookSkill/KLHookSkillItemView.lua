---@class KLHookSkillItemView:UIKmlLuaViewBase
---@field hookSkill_item UIKmlLuaControlHandler
---@field skill_bg UIKmlLuaControlHandler
---@field imgBG UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field skillIcon UIKmlLuaControlHandler
---@field skillLevel UIKmlLuaControlHandler
---@field skillName UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field selectToggle UIKmlLuaControlHandler
---@field selectToggle_new UIKmlLuaControlHandler
local KLHookSkillItemView = {}
setmetatable(KLHookSkillItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Item/KLHookSkill/KLHookSkillItemKml'
---@param parent UIKmlLuaControlHandler
function KLHookSkillItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLHookSkillItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Item/KLHookSkill/KLHookSkillItem']

return KLHookSkillItemView

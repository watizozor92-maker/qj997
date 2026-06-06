---@class KLCallSkillPanelView:UIKmlLuaViewBase
---@field bg2 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field content UIKmlLuaControlHandler
---@field item_list UIKmlLuaControlHandler
---@field callSkillList UIKmlLuaControlHandler
local KLCallSkillPanelView = {}
setmetatable(KLCallSkillPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Panel/KLCallSkill/KLCallSkillPanelKml'
---@param parent UIKmlLuaControlHandler
function KLCallSkillPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLCallSkillPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Panel/KLCallSkill/KLCallSkillPanel']

return KLCallSkillPanelView

---@class KLCareerChangePanelView:UIKmlLuaViewBase
---@field prefab_95 UIKmlLuaControlHandler
---@field BtnOk UIKmlLuaControlHandler
---@field SkillContent UIKmlLuaControlHandler
local KLCareerChangePanelView = {}
setmetatable(KLCareerChangePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Career/Panel/KLCareerChangePanel/KLCareerChangePanelKml'
---@param parent UIKmlLuaControlHandler
function KLCareerChangePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLCareerChangePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Career/Panel/KLCareerChangePanel/KLCareerChangePanel']

return KLCareerChangePanelView

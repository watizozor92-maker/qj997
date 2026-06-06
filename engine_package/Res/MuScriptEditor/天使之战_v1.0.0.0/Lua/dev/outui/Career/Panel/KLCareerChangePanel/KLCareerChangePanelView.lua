---@class KLCareerChangePanelView:UIKmlLuaViewBase
---@field img_55 UIKmlLuaControlHandler
---@field img_56 UIKmlLuaControlHandler
---@field panel_57 UIKmlLuaControlHandler
---@field img_58 UIKmlLuaControlHandler
---@field TextOriginalProfession UIKmlLuaControlHandler
---@field img_60 UIKmlLuaControlHandler
---@field TextPresentProfession UIKmlLuaControlHandler
---@field panel_62 UIKmlLuaControlHandler
---@field AttUp UIKmlLuaControlHandler
---@field img_64 UIKmlLuaControlHandler
---@field text_65 UIKmlLuaControlHandler
---@field TextAttAward UIKmlLuaControlHandler
---@field SkillUnlock UIKmlLuaControlHandler
---@field img_68 UIKmlLuaControlHandler
---@field text_69 UIKmlLuaControlHandler
---@field SkillRollRect UIKmlLuaControlHandler
---@field datalist_71 UIKmlLuaControlHandler
---@field EquipUnlock UIKmlLuaControlHandler
---@field img_77 UIKmlLuaControlHandler
---@field text_78 UIKmlLuaControlHandler
---@field EquipRollRect UIKmlLuaControlHandler
---@field datalist_80 UIKmlLuaControlHandler
---@field BtnOk UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
local KLCareerChangePanelView = {}
setmetatable(KLCareerChangePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Career/Panel/KLCareerChangePanel/KLCareerChangePanelKml'
---@param parent UIKmlLuaControlHandler
function KLCareerChangePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLCareerChangePanelView

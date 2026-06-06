---@class KLUICareerTalentPanelView:UIKmlLuaViewBase
---@field LvTitle UIKmlLuaControl
---@field Lv UIKmlLuaControl
---@field loadingbar UIKmlLuaControl
---@field ExpText UIKmlLuaControl
---@field ExchangeExpButton UIKmlLuaControl
---@field ExchangeExpRedDot UIKmlLuaControl
---@field PointTitle UIKmlLuaControl
---@field PointText UIKmlLuaControl
---@field ResetButton UIKmlLuaControl
---@field LeftButton1 UIKmlLuaControl
---@field LeftButton1_Title UIKmlLuaControl
---@field LeftButton1_Icon UIKmlLuaControl
---@field LeftButton1_Enable UIKmlLuaControl
---@field LeftButton1_EnableText UIKmlLuaControl
---@field LeftButton2 UIKmlLuaControl
---@field LeftButton2_Title UIKmlLuaControl
---@field LeftButton2_Icon UIKmlLuaControl
---@field LeftButton2_Enable UIKmlLuaControl
---@field LeftButton2_EnableText UIKmlLuaControl
---@field SkillScrollview UIKmlLuaControl
---@field layout3 UIKmlLuaControl
---@field SkillDataList UIKmlLuaControl
local KLUICareerTalentPanelView = {}
setmetatable(KLUICareerTalentPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUICareerTalent/KLUICareerTalentPanelKml'
---@param parent UIKmlLuaControl
function KLUICareerTalentPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUICareerTalentPanelView

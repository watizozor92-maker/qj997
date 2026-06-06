---@class KLSkillBagPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControl
---@field ReMask UIKmlLuaControl
---@field img1231 UIKmlLuaControl
---@field Frame UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field cut_area_up UIKmlLuaControl
---@field cut_area_down UIKmlLuaControl
---@field img_66 UIKmlLuaControl
---@field title UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field sv_frame UIKmlLuaControl
---@field layout1 UIKmlLuaControl
---@field btn_fix UIKmlLuaControl
---@field btn_arrange UIKmlLuaControl
---@field btn_storage UIKmlLuaControl
---@field btn_sell UIKmlLuaControl
---@field bgGridRoot UIKmlLuaControl
---@field fastItemTip UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field text4 UIKmlLuaControl
local KLSkillBagPanelView = {}
setmetatable(KLSkillBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Bag/Panel/KLSkillBag/KLSkillBagPanelKml'
---@param parent UIKmlLuaControl
function KLSkillBagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLSkillBagPanelView

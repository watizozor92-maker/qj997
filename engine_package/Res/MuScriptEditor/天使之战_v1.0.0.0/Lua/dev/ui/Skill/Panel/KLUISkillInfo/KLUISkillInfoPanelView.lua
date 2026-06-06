---@class KLUISkillInfoPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControl
---@field ReMask UIKmlLuaControl
---@field img1231 UIKmlLuaControl
---@field Frame UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field KmlXWSkillInfoUI UIKmlLuaControl
---@field SkillTogGroup UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field listMask UIKmlLuaControl
---@field loopscrollview UIKmlLuaControl
---@field loopscrollviewData UIKmlLuaControl
---@field BtnSkillSetting UIKmlLuaControl
---@field pageList UIKmlLuaControl
---@field pageData UIKmlLuaControl
---@field TextTitle UIKmlLuaControl
---@field shapeShiftRoot UIKmlLuaControl
---@field img_shift_bg UIKmlLuaControl
---@field layout_transfer_skill UIKmlLuaControl
---@field transfer_datalist UIKmlLuaControl
---@field btn_shift UIKmlLuaControl
local KLUISkillInfoPanelView = {}
setmetatable(KLUISkillInfoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanelKml'
---@param parent UIKmlLuaControl
function KLUISkillInfoPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLUISkillInfoPanelView

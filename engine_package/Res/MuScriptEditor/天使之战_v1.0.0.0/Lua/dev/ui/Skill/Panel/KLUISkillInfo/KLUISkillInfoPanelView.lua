---@class KLUISkillInfoPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1231 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field KmlXWSkillInfoUI UIKmlLuaControlHandler
---@field SkillTogGroup UIKmlLuaControlHandler
---@field listMask UIKmlLuaControlHandler
---@field loopscrollview UIKmlLuaControlHandler
---@field loopscrollviewData UIKmlLuaControlHandler
---@field BtnSkillSetting UIKmlLuaControlHandler
---@field pageList UIKmlLuaControlHandler
---@field pageData UIKmlLuaControlHandler
---@field TextTitle UIKmlLuaControlHandler
---@field shapeShiftRoot UIKmlLuaControlHandler
---@field img_shift_bg UIKmlLuaControlHandler
---@field layout_transfer_skill UIKmlLuaControlHandler
---@field transfer_datalist UIKmlLuaControlHandler
---@field btn_shift UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
local KLUISkillInfoPanelView = {}
setmetatable(KLUISkillInfoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISkillInfoPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLUISkillInfoPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel']

return KLUISkillInfoPanelView

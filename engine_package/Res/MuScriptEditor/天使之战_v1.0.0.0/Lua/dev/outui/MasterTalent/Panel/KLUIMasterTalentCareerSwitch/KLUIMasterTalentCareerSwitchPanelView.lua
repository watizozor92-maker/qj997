---@class KLUIMasterTalentCareerSwitchPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field Left UIKmlLuaControl
---@field img6 UIKmlLuaControl
---@field LeftText UIKmlLuaControl
---@field LeftConsume UIKmlLuaControl
---@field ConsumeItem UIKmlLuaControl
---@field ConsumeText UIKmlLuaControl
---@field LeftButton UIKmlLuaControl
---@field Right UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field RightButton UIKmlLuaControl
---@field CloseButton UIKmlLuaControl
---@field Title UIKmlLuaControl
local KLUIMasterTalentCareerSwitchPanelView = {}
setmetatable(KLUIMasterTalentCareerSwitchPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUIMasterTalentCareerSwitch/KLUIMasterTalentCareerSwitchPanelKml'
---@param parent UIKmlLuaControl
function KLUIMasterTalentCareerSwitchPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIMasterTalentCareerSwitchPanelView

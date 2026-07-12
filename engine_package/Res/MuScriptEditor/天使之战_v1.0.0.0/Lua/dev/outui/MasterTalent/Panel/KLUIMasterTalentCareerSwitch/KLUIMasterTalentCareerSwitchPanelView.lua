---@class KLUIMasterTalentCareerSwitchPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field Left UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field LeftText UIKmlLuaControlHandler
---@field LeftConsume UIKmlLuaControlHandler
---@field ConsumeItem UIKmlLuaControlHandler
---@field ConsumeText UIKmlLuaControlHandler
---@field LeftButton UIKmlLuaControlHandler
---@field Right UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field RightButton UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
local KLUIMasterTalentCareerSwitchPanelView = {}
setmetatable(KLUIMasterTalentCareerSwitchPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUIMasterTalentCareerSwitch/KLUIMasterTalentCareerSwitchPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMasterTalentCareerSwitchPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMasterTalentCareerSwitchPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MasterTalent/Panel/KLUIMasterTalentCareerSwitch/KLUIMasterTalentCareerSwitchPanel']

return KLUIMasterTalentCareerSwitchPanelView

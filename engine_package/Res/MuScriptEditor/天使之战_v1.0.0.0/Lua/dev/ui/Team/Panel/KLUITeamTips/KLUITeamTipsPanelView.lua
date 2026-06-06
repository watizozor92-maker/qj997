---@class KLUITeamTipsPanelView:UIKmlLuaViewBase
---@field closeButton UIKmlLuaControl
---@field panel_97 UIKmlLuaControl
---@field img_98 UIKmlLuaControl
---@field img_99 UIKmlLuaControl
---@field img_100 UIKmlLuaControl
---@field img_101 UIKmlLuaControl
---@field sp_careerIcon UIKmlLuaControl
---@field lab_name UIKmlLuaControl
---@field lab_level UIKmlLuaControl
---@field lab_career UIKmlLuaControl
---@field lab_union UIKmlLuaControl
---@field btGridView UIKmlLuaControl
---@field lockButton UIKmlLuaControl
---@field text_109 UIKmlLuaControl
---@field chatButton UIKmlLuaControl
---@field text_111 UIKmlLuaControl
---@field joinButton UIKmlLuaControl
---@field text_113 UIKmlLuaControl
---@field invitationButton UIKmlLuaControl
---@field text_115 UIKmlLuaControl
---@field reqPointButton UIKmlLuaControl
---@field text_117 UIKmlLuaControl
---@field leaveButton UIKmlLuaControl
---@field text_119 UIKmlLuaControl
---@field kickButton UIKmlLuaControl
---@field text_121 UIKmlLuaControl
---@field upCaptainButton UIKmlLuaControl
---@field text_123 UIKmlLuaControl
---@field selectPlayerButton UIKmlLuaControl
---@field text_125 UIKmlLuaControl
---@field text_126 UIKmlLuaControl
local KLUITeamTipsPanelView = {}
setmetatable(KLUITeamTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUITeamTips/KLUITeamTipsPanelKml'
---@param parent UIKmlLuaControl
function KLUITeamTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUITeamTipsPanelView

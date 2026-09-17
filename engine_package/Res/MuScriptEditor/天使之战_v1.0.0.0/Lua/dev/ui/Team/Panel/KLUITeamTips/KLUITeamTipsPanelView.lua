---@class KLUITeamTipsPanelView:UIKmlLuaViewBase
---@field closeButton UIKmlLuaControlHandler
---@field panel_97 UIKmlLuaControlHandler
---@field img_98 UIKmlLuaControlHandler
---@field img_99 UIKmlLuaControlHandler
---@field img_100 UIKmlLuaControlHandler
---@field img_101 UIKmlLuaControlHandler
---@field sp_careerIcon UIKmlLuaControlHandler
---@field lab_name UIKmlLuaControlHandler
---@field lab_level UIKmlLuaControlHandler
---@field lab_career UIKmlLuaControlHandler
---@field lab_union UIKmlLuaControlHandler
---@field btGridView UIKmlLuaControlHandler
---@field lockButton UIKmlLuaControlHandler
---@field text_109 UIKmlLuaControlHandler
---@field chatButton UIKmlLuaControlHandler
---@field text_111 UIKmlLuaControlHandler
---@field joinButton UIKmlLuaControlHandler
---@field text_113 UIKmlLuaControlHandler
---@field invitationButton UIKmlLuaControlHandler
---@field text_115 UIKmlLuaControlHandler
---@field reqPointButton UIKmlLuaControlHandler
---@field text_117 UIKmlLuaControlHandler
---@field leaveButton UIKmlLuaControlHandler
---@field text_119 UIKmlLuaControlHandler
---@field kickButton UIKmlLuaControlHandler
---@field text_121 UIKmlLuaControlHandler
---@field upCaptainButton UIKmlLuaControlHandler
---@field text_123 UIKmlLuaControlHandler
---@field selectPlayerButton UIKmlLuaControlHandler
---@field text_125 UIKmlLuaControlHandler
---@field text_126 UIKmlLuaControlHandler
local KLUITeamTipsPanelView = {}
setmetatable(KLUITeamTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUITeamTips/KLUITeamTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUITeamTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUITeamTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Team/Panel/KLUITeamTips/KLUITeamTipsPanel']

return KLUITeamTipsPanelView

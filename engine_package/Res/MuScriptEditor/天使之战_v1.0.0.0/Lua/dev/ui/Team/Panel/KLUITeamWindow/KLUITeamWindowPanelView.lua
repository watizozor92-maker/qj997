---@class KLUITeamWindowPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field img_17 UIKmlLuaControlHandler
---@field MemberPanel UIKmlLuaControlHandler
---@field sc_member UIKmlLuaControlHandler
---@field Content_Members UIKmlLuaControlHandler
---@field Content_Members_list UIKmlLuaControlHandler
---@field Members_list UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field btn_invitation UIKmlLuaControlHandler
---@field btn_team UIKmlLuaControlHandler
---@field NoMemberPanel UIKmlLuaControlHandler
---@field text_27 UIKmlLuaControlHandler
---@field btn_joinTeam UIKmlLuaControlHandler
---@field btn_createTeam UIKmlLuaControlHandler
---@field tog_autoJoin UIKmlLuaControlHandler
---@field text_33 UIKmlLuaControlHandler
---@field go_playerPanelBg UIKmlLuaControlHandler
---@field go_playerPanelBgIcon UIKmlLuaControlHandler
---@field sp_playerPanelBg UIKmlLuaControlHandler
---@field CloseSelectPlayerUIButton UIKmlLuaControlHandler
---@field ButtonGridView UIKmlLuaControlHandler
---@field LockButton UIKmlLuaControlHandler
---@field ChatButton UIKmlLuaControlHandler
---@field KickButton UIKmlLuaControlHandler
---@field PromotedButton UIKmlLuaControlHandler
---@field SelectPlayerButton UIKmlLuaControlHandler
---@field ReqPointButton UIKmlLuaControlHandler
---@field LeaveTeamButton UIKmlLuaControlHandler
local KLUITeamWindowPanelView = {}
setmetatable(KLUITeamWindowPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUITeamWindow/KLUITeamWindowPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUITeamWindowPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUITeamWindowPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Team/Panel/KLUITeamWindow/KLUITeamWindowPanel']

return KLUITeamWindowPanelView

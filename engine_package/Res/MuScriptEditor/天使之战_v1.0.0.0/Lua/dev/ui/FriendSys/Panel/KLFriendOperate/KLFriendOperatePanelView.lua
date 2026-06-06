---@class KLFriendOperatePanelView:UIKmlLuaViewBase
---@field BtnMask UIKmlLuaControlHandler
---@field BgBor UIKmlLuaControlHandler
---@field window_di UIKmlLuaControlHandler
---@field TxtTitle UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field TxtName UIKmlLuaControlHandler
---@field TxtUnion UIKmlLuaControlHandler
---@field TxtLevel UIKmlLuaControlHandler
---@field TxtCareer UIKmlLuaControlHandler
---@field SpPlayerBG UIKmlLuaControlHandler
---@field SpPlayer UIKmlLuaControlHandler
---@field BtnFlowerSend UIKmlLuaControlHandler
---@field BtnGrid UIKmlLuaControlHandler
---@field lockButton UIKmlLuaControlHandler
---@field BtnViewPlayer UIKmlLuaControlHandler
---@field BtnUnionInvite UIKmlLuaControlHandler
---@field BtnDelFriend UIKmlLuaControlHandler
---@field BtnAddFriend UIKmlLuaControlHandler
---@field BtnUnionReq UIKmlLuaControlHandler
---@field BtnPrivateChat UIKmlLuaControlHandler
---@field BtnAddBlack UIKmlLuaControlHandler
---@field BtnRemoveBlack UIKmlLuaControlHandler
---@field BtnTeamInvite UIKmlLuaControlHandler
---@field BtnTeamReq UIKmlLuaControlHandler
---@field BtnTeamKickOff UIKmlLuaControlHandler
---@field BtnTeamLeader UIKmlLuaControlHandler
---@field reqPointButton UIKmlLuaControlHandler
---@field BtnLeaveTeam UIKmlLuaControlHandler
---@field joinButton UIKmlLuaControlHandler
---@field selectPlayerButton UIKmlLuaControlHandler
---@field btn_faceTrade UIKmlLuaControlHandler
local KLFriendOperatePanelView = {}
setmetatable(KLFriendOperatePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Panel/KLFriendOperate/KLFriendOperatePanelKml'
---@param parent UIKmlLuaControlHandler
function KLFriendOperatePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLFriendOperatePanelView

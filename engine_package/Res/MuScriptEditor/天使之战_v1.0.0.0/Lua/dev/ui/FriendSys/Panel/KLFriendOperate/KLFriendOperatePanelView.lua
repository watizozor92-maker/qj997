---@class KLFriendOperatePanelView:UIKmlLuaViewBase
---@field BtnMask UIKmlLuaControlHandler
---@field BgBor UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field BtnFlowerSend UIKmlLuaControlHandler
---@field BtnGrid UIKmlLuaControlHandler
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
---@field BtnLeaveTeam UIKmlLuaControlHandler
---@field btn_faceTrade UIKmlLuaControlHandler
---@field lockButton UIKmlLuaControlHandler
---@field joinButton UIKmlLuaControlHandler
---@field selectPlayerButton UIKmlLuaControlHandler
---@field reqPointButton UIKmlLuaControlHandler
---@field TxtLevel UIKmlLuaControlHandler
---@field TxtCareer UIKmlLuaControlHandler
---@field TxtName UIKmlLuaControlHandler
---@field SpPlayerBG UIKmlLuaControlHandler
---@field SpPlayer UIKmlLuaControlHandler
---@field TxtUnion UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field window_di UIKmlLuaControlHandler
---@field TxtTitle UIKmlLuaControlHandler
local KLFriendOperatePanelView = {}
setmetatable(KLFriendOperatePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Panel/KLFriendOperate/KLFriendOperatePanelKml'
---@param parent UIKmlLuaControlHandler
function KLFriendOperatePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendOperatePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Panel/KLFriendOperate/KLFriendOperatePanel']

return KLFriendOperatePanelView

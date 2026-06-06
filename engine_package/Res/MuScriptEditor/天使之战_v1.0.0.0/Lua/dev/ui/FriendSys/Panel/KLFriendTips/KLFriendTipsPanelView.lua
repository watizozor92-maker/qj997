---@class KLFriendTipsPanelView:UIKmlLuaViewBase
---@field FriendAdd_ UIKmlLuaControl
---@field BtnClose UIKmlLuaControl
---@field TextContent UIKmlLuaControl
local KLFriendTipsPanelView = {}
setmetatable(KLFriendTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Panel/KLFriendTips/KLFriendTipsPanelKml'
---@param parent UIKmlLuaControl
function KLFriendTipsPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLFriendTipsPanelView

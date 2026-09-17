---@class KLFriendTipsPanelView:UIKmlLuaViewBase
---@field FriendAdd_ UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field TextContent UIKmlLuaControlHandler
local KLFriendTipsPanelView = {}
setmetatable(KLFriendTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Panel/KLFriendTips/KLFriendTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLFriendTipsPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLFriendTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Panel/KLFriendTips/KLFriendTipsPanel']

return KLFriendTipsPanelView

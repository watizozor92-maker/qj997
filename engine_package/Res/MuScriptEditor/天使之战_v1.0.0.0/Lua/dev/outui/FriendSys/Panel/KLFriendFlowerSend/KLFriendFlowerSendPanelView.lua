---@class KLFriendFlowerSendPanelView:UIKmlLuaViewBase
---@field BtnMask UIKmlLuaControl
---@field Bg UIKmlLuaControl
---@field TxtTitle UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field BtnClose UIKmlLuaControl
---@field BtnSend UIKmlLuaControl
---@field desc UIKmlLuaControl
---@field BtnTipDown UIKmlLuaControl
---@field dropdown_list_flower UIKmlLuaControl
---@field layout_63 UIKmlLuaControl
---@field btn_flower_0 UIKmlLuaControl
---@field btn_flower_1 UIKmlLuaControl
---@field btn_flower_2 UIKmlLuaControl
---@field btn_flower_3 UIKmlLuaControl
---@field btn_flower UIKmlLuaControl
---@field Item UIKmlLuaControl
local KLFriendFlowerSendPanelView = {}
setmetatable(KLFriendFlowerSendPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FriendSys/Panel/KLFriendFlowerSend/KLFriendFlowerSendPanelKml'
---@param parent UIKmlLuaControl
function KLFriendFlowerSendPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLFriendFlowerSendPanelView

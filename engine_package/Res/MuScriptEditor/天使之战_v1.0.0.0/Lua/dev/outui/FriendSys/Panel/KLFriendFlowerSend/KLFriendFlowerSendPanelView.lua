---@class KLFriendFlowerSendPanelView:UIKmlLuaViewBase
---@field BtnMask UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field TxtTitle UIKmlLuaControlHandler
---@field BtnSend UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field BtnTipDown UIKmlLuaControlHandler
---@field dropdown_list_flower UIKmlLuaControlHandler
---@field layout_63 UIKmlLuaControlHandler
---@field btn_flower_0 UIKmlLuaControlHandler
---@field btn_flower_1 UIKmlLuaControlHandler
---@field btn_flower_2 UIKmlLuaControlHandler
---@field btn_flower_3 UIKmlLuaControlHandler
---@field btn_flower UIKmlLuaControlHandler
---@field desc UIKmlLuaControlHandler
---@field Item UIKmlLuaControlHandler
local KLFriendFlowerSendPanelView = {}
setmetatable(KLFriendFlowerSendPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FriendSys/Panel/KLFriendFlowerSend/KLFriendFlowerSendPanelKml'
---@param parent UIKmlLuaControlHandler
function KLFriendFlowerSendPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendFlowerSendPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/FriendSys/Panel/KLFriendFlowerSend/KLFriendFlowerSendPanel']

return KLFriendFlowerSendPanelView

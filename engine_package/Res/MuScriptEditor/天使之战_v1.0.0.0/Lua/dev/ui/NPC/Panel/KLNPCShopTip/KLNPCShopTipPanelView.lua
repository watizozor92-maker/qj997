---@class KLNPCShopTipPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field text_bg UIKmlLuaControlHandler
---@field close_btn UIKmlLuaControlHandler
---@field ContentTxt UIKmlLuaControlHandler
local KLNPCShopTipPanelView = {}
setmetatable(KLNPCShopTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/NPC/Panel/KLNPCShopTip/KLNPCShopTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNPCShopTipPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLNPCShopTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/NPC/Panel/KLNPCShopTip/KLNPCShopTipPanel']

return KLNPCShopTipPanelView

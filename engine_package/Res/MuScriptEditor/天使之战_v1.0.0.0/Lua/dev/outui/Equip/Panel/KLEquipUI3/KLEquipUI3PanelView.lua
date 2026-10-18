---@class KLEquipUI3PanelView:UIKmlLuaViewBase
---@field UIEquipPanel UIKmlLuaControlHandler
---@field UIEquip2Panel_Root UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field rootBg UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field EquipGrid UIKmlLuaControlHandler
---@field MoneyList UIKmlLuaControlHandler
---@field moneyBackground UIKmlLuaControlHandler
---@field moneyText UIKmlLuaControlHandler
---@field MUCoinBackground UIKmlLuaControlHandler
---@field muCoinText UIKmlLuaControlHandler
---@field MUBindCoinBackground UIKmlLuaControlHandler
---@field muBindCoinText UIKmlLuaControlHandler
---@field diamondBackground UIKmlLuaControlHandler
---@field diamondText UIKmlLuaControlHandler
---@field WearBarList UIKmlLuaControlHandler
---@field Content UIKmlLuaControlHandler
---@field panelName UIKmlLuaControlHandler
---@field Grade UIKmlLuaControlHandler
---@field btnPanel UIKmlLuaControlHandler
---@field wearBarChange UIKmlLuaControlHandler
---@field WearArchange UIKmlLuaControlHandler
---@field panelNameText UIKmlLuaControlHandler
local KLEquipUI3PanelView = {}
setmetatable(KLEquipUI3PanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLEquipUI3/KLEquipUI3PanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipUI3PanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipUI3Panel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLEquipUI3/KLEquipUI3Panel']

return KLEquipUI3PanelView

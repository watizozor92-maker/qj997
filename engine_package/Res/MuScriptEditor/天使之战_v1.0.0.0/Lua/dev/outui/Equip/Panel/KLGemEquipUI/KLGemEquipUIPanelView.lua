---@class KLGemEquipUIPanelView:UIKmlLuaViewBase
---@field UIEquipPanel UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field UIEquipPanel_Root UIKmlLuaControlHandler
---@field panelNameText UIKmlLuaControlHandler
---@field EquipGrid UIKmlLuaControlHandler
---@field wearBarChange UIKmlLuaControlHandler
---@field MoneyList UIKmlLuaControlHandler
---@field moneyBackground UIKmlLuaControlHandler
---@field moneyText UIKmlLuaControlHandler
---@field WearArchange UIKmlLuaControlHandler
---@field MUCoinBackground UIKmlLuaControlHandler
---@field muCoinText UIKmlLuaControlHandler
---@field MUBindCoinBackground UIKmlLuaControlHandler
---@field muBindCoinText UIKmlLuaControlHandler
---@field diamondBackground UIKmlLuaControlHandler
---@field diamondText UIKmlLuaControlHandler
---@field Grade UIKmlLuaControlHandler
---@field WearBarList UIKmlLuaControlHandler
---@field Content UIKmlLuaControlHandler
local KLGemEquipUIPanelView = {}
setmetatable(KLGemEquipUIPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanelKml'
---@param parent UIKmlLuaControlHandler
function KLGemEquipUIPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLGemEquipUIPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel']

return KLGemEquipUIPanelView

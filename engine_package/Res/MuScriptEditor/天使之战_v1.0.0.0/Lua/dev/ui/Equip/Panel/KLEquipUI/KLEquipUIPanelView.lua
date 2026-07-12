---@class KLEquipUIPanelView:UIKmlLuaViewBase
---@field UIEquipPanel UIKmlLuaControlHandler
---@field UIEquipPanel_Root UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field rootBg UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
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
---@field CloseButton UIKmlLuaControlHandler
local KLEquipUIPanelView = {}
setmetatable(KLEquipUIPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipUIPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipUIPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel']

return KLEquipUIPanelView

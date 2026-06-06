---@class KLEquipJewelryActivePanelView:UIKmlLuaViewBase
---@field panel2 UIKmlLuaControlHandler
---@field maskBtn UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field gridview15 UIKmlLuaControlHandler
---@field cost_list UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field Level UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field Add UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field count UIKmlLuaControlHandler
---@field itemModel UIKmlLuaControlHandler
---@field ActiveBtn UIKmlLuaControlHandler
---@field CloseBtn UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field activeIcon UIKmlLuaControlHandler
local KLEquipJewelryActivePanelView = {}
setmetatable(KLEquipJewelryActivePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLEquipJewelryActive/KLEquipJewelryActivePanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipJewelryActivePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipJewelryActivePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLEquipJewelryActive/KLEquipJewelryActivePanel']

return KLEquipJewelryActivePanelView

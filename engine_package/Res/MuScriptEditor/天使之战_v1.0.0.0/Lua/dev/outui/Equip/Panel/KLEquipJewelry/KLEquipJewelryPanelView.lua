---@class KLEquipJewelryPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field tips UIKmlLuaControlHandler
---@field bg2 UIKmlLuaControlHandler
---@field BGInner_2 UIKmlLuaControlHandler
---@field item_model UIKmlLuaControlHandler
---@field equipName UIKmlLuaControlHandler
---@field line_1 UIKmlLuaControlHandler
---@field line_2 UIKmlLuaControlHandler
---@field success_ok UIKmlLuaControlHandler
---@field success_anim UIKmlLuaControlHandler
---@field successText UIKmlLuaControlHandler
---@field maxLevelTips UIKmlLuaControlHandler
---@field LevelButton UIKmlLuaControlHandler
---@field LevelButtonRedPoint UIKmlLuaControlHandler
---@field strengthLevelBg UIKmlLuaControlHandler
---@field strengthIntro UIKmlLuaControlHandler
---@field preLevel UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field nextLevel UIKmlLuaControlHandler
---@field LevelIcon UIKmlLuaControlHandler
---@field equipAttribute UIKmlLuaControlHandler
---@field arrContent UIKmlLuaControlHandler
---@field gridview3 UIKmlLuaControlHandler
---@field Attr_list UIKmlLuaControlHandler
---@field Excellenceicon UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field scrollView UIKmlLuaControlHandler
---@field gridview15 UIKmlLuaControlHandler
---@field Exce_list UIKmlLuaControlHandler
---@field Material UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field scrollview4 UIKmlLuaControlHandler
---@field gridview5 UIKmlLuaControlHandler
---@field cost_List UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field CloseBtn UIKmlLuaControlHandler
local KLEquipJewelryPanelView = {}
setmetatable(KLEquipJewelryPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLEquipJewelry/KLEquipJewelryPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipJewelryPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipJewelryPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLEquipJewelry/KLEquipJewelryPanel']

return KLEquipJewelryPanelView

---@class KLPickupSettingPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field toggleSetting UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field AutoPickToggle UIKmlLuaControlHandler
---@field AutoPickToggleText UIKmlLuaControlHandler
---@field autopickUpShowPanel UIKmlLuaControlHandler
---@field pickItemList UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field TextInput UIKmlLuaControlHandler
---@field Text_attach UIKmlLuaControlHandler
---@field addBtn UIKmlLuaControlHandler
---@field scrollview6 UIKmlLuaControlHandler
---@field layout7 UIKmlLuaControlHandler
---@field ItemDataList UIKmlLuaControlHandler
---@field MyAutoPickUpToggle UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field img19 UIKmlLuaControlHandler
---@field text20 UIKmlLuaControlHandler
---@field selfPickNode_title UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field panel37 UIKmlLuaControlHandler
---@field toggle_pos_1 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field toggle_2 UIKmlLuaControlHandler
---@field toggle_pos_2 UIKmlLuaControlHandler
---@field img10 UIKmlLuaControlHandler
---@field toggle_3 UIKmlLuaControlHandler
---@field toggle_pos_3 UIKmlLuaControlHandler
---@field img13 UIKmlLuaControlHandler
---@field toggle_4 UIKmlLuaControlHandler
---@field toggle_pos_4 UIKmlLuaControlHandler
---@field img17 UIKmlLuaControlHandler
---@field toggle_5 UIKmlLuaControlHandler
---@field toggle_pos_5 UIKmlLuaControlHandler
---@field img20 UIKmlLuaControlHandler
---@field toggle_6 UIKmlLuaControlHandler
---@field toggle_pos_6 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field toggle_7 UIKmlLuaControlHandler
---@field toggle_pos_7 UIKmlLuaControlHandler
---@field img26 UIKmlLuaControlHandler
---@field panel27 UIKmlLuaControlHandler
---@field toggle_pos_8 UIKmlLuaControlHandler
---@field img29 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field img11 UIKmlLuaControlHandler
---@field togglegroup1 UIKmlLuaControlHandler
local KLPickupSettingPanelView = {}
setmetatable(KLPickupSettingPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Panel/KLPickupSetting/KLPickupSettingPanelKml'
---@param parent UIKmlLuaControlHandler
function KLPickupSettingPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLPickupSettingPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Panel/KLPickupSetting/KLPickupSettingPanel']

return KLPickupSettingPanelView

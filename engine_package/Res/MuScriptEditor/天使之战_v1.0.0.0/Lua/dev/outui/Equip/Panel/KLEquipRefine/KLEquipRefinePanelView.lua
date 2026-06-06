---@class KLEquipRefinePanelView:UIKmlLuaViewBase
---@field Content UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field panel3 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field EquipsBanner UIKmlLuaControlHandler
---@field ToggleGroupSource UIKmlLuaControlHandler
---@field Tog_Equip UIKmlLuaControlHandler
---@field Tog_Bag UIKmlLuaControlHandler
---@field panel_equip_source UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field item_mainEquip UIKmlLuaControlHandler
---@field img_equip_source_add UIKmlLuaControlHandler
---@field text26 UIKmlLuaControlHandler
---@field Btn_MainEquipCancel UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field Text_MainEquipName UIKmlLuaControlHandler
---@field panel_equip_target UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field item_assistantEquip UIKmlLuaControlHandler
---@field img_equip_target_add UIKmlLuaControlHandler
---@field text27 UIKmlLuaControlHandler
---@field Btn_AssistantEquipCancel UIKmlLuaControlHandler
---@field panel5 UIKmlLuaControlHandler
---@field Text_AssistantEquipName UIKmlLuaControlHandler
---@field AttTitle UIKmlLuaControlHandler
---@field text15 UIKmlLuaControlHandler
---@field img16 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field scrollview17 UIKmlLuaControlHandler
---@field layout18 UIKmlLuaControlHandler
---@field DataList_Att UIKmlLuaControlHandler
---@field scrollviewMain UIKmlLuaControlHandler
---@field layoutMain UIKmlLuaControlHandler
---@field DataList_MainAtt UIKmlLuaControlHandler
---@field NeedMatTitle UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field DataList_Cost UIKmlLuaControlHandler
---@field Btn_Refine UIKmlLuaControlHandler
---@field Btn_RefineMain UIKmlLuaControlHandler
---@field Img_Tips UIKmlLuaControlHandler
---@field Text_NoTips UIKmlLuaControlHandler
---@field Prefab_RefineComponent UIKmlLuaControlHandler
local KLEquipRefinePanelView = {}
setmetatable(KLEquipRefinePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLEquipRefine/KLEquipRefinePanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipRefinePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipRefinePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLEquipRefine/KLEquipRefinePanel']

return KLEquipRefinePanelView

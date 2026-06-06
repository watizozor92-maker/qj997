---@class KLEquipRegenerateUIPanelView:UIKmlLuaViewBase
---@field BG UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field xilian_top UIKmlLuaControlHandler
---@field xilian_top_bg UIKmlLuaControlHandler
---@field equipName UIKmlLuaControlHandler
---@field line_1 UIKmlLuaControlHandler
---@field line_2 UIKmlLuaControlHandler
---@field item_model UIKmlLuaControlHandler
---@field jinhua_top UIKmlLuaControlHandler
---@field jinhua_top_bg UIKmlLuaControlHandler
---@field equipName2 UIKmlLuaControlHandler
---@field 2line_1 UIKmlLuaControlHandler
---@field 2line_2 UIKmlLuaControlHandler
---@field item_model2 UIKmlLuaControlHandler
---@field btn_xilian UIKmlLuaControlHandler
---@field btn_xilian_select UIKmlLuaControlHandler
---@field btn_jinhua UIKmlLuaControlHandler
---@field btn_jinhua_select UIKmlLuaControlHandler
---@field xilian_panel UIKmlLuaControlHandler
---@field zaisheng_title UIKmlLuaControlHandler
---@field 初始页展示di UIKmlLuaControlHandler
---@field yulan_btn UIKmlLuaControlHandler
---@field zaisheng_title_text UIKmlLuaControlHandler
---@field lock UIKmlLuaControlHandler
---@field 装备再生等级限制 UIKmlLuaControlHandler
---@field info_panel UIKmlLuaControlHandler
---@field grid_current UIKmlLuaControlHandler
---@field grid_current_layout UIKmlLuaControlHandler
---@field datalist_current UIKmlLuaControlHandler
---@field 27 UIKmlLuaControlHandler
---@field grid_new UIKmlLuaControlHandler
---@field grid_new_layout UIKmlLuaControlHandler
---@field datalist_new UIKmlLuaControlHandler
---@field 12 UIKmlLuaControlHandler
---@field 13 UIKmlLuaControlHandler
---@field need_panel UIKmlLuaControlHandler
---@field gridview15 UIKmlLuaControlHandler
---@field cost_list UIKmlLuaControlHandler
---@field tihuan_btn UIKmlLuaControlHandler
---@field xilian_btn UIKmlLuaControlHandler
---@field 15 UIKmlLuaControlHandler
---@field yulan_panel UIKmlLuaControlHandler
---@field yulan_close_btn UIKmlLuaControlHandler
---@field img_词条预览 UIKmlLuaControlHandler
---@field equipName_yulan UIKmlLuaControlHandler
---@field line_1 UIKmlLuaControlHandler
---@field line_2 UIKmlLuaControlHandler
---@field scroll_词条预览 UIKmlLuaControlHandler
---@field grid_词条预览 UIKmlLuaControlHandler
---@field datalist_yulan UIKmlLuaControlHandler
---@field jinhua_panel UIKmlLuaControlHandler
---@field jinhua_lock UIKmlLuaControlHandler
---@field 装备再生等级限制 UIKmlLuaControlHandler
---@field jinhua_info_panel UIKmlLuaControlHandler
---@field level_root UIKmlLuaControlHandler
---@field level_bg UIKmlLuaControlHandler
---@field jinhua_info UIKmlLuaControlHandler
---@field preLevel UIKmlLuaControlHandler
---@field jinhua_info_panel_arrow UIKmlLuaControlHandler
---@field nextLevel UIKmlLuaControlHandler
---@field maxLevelTips UIKmlLuaControlHandler
---@field jilv_img UIKmlLuaControlHandler
---@field jilv UIKmlLuaControlHandler
---@field success_anim UIKmlLuaControlHandler
---@field successText UIKmlLuaControlHandler
---@field panel_满级属性 UIKmlLuaControlHandler
---@field 21 UIKmlLuaControlHandler
---@field 满级属性 UIKmlLuaControlHandler
---@field 满级词条 UIKmlLuaControlHandler
---@field jin_title UIKmlLuaControlHandler
---@field 20 UIKmlLuaControlHandler
---@field jinhua_view UIKmlLuaControlHandler
---@field jinhua_view_layout UIKmlLuaControlHandler
---@field datalist_jinhua UIKmlLuaControlHandler
---@field img_manji UIKmlLuaControlHandler
---@field panel_jinhua_cailiao UIKmlLuaControlHandler
---@field panel_jinhua_cailiao_title UIKmlLuaControlHandler
---@field 23 UIKmlLuaControlHandler
---@field need_jinhua_panel UIKmlLuaControlHandler
---@field need_jinhua_panel_gridview UIKmlLuaControlHandler
---@field jinhua_cost_list UIKmlLuaControlHandler
---@field jinhua_btn UIKmlLuaControlHandler
local KLEquipRegenerateUIPanelView = {}
setmetatable(KLEquipRegenerateUIPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLEquipRegenerateUI/KLEquipRegenerateUIPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipRegenerateUIPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipRegenerateUIPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLEquipRegenerateUI/KLEquipRegenerateUIPanel']

return KLEquipRegenerateUIPanelView

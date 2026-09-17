---@class KLChangeAttrSchemePanelView:UIKmlLuaViewBase
---@field img_958 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field edit_btn UIKmlLuaControlHandler
---@field img_name_bg UIKmlLuaControlHandler
---@field name_input UIKmlLuaControlHandler
---@field btn_choice_scheme_show UIKmlLuaControlHandler
---@field layout_scheme UIKmlLuaControlHandler
---@field btn_first_scheme UIKmlLuaControlHandler
---@field btn_second_scheme UIKmlLuaControlHandler
---@field btn_exchange_point UIKmlLuaControlHandler
---@field edit_panel UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field edit_oldName UIKmlLuaControlHandler
---@field edit_CloseBtn UIKmlLuaControlHandler
---@field old_Store_Name UIKmlLuaControlHandler
---@field attr_Name_Input UIKmlLuaControlHandler
---@field edit_Cancel UIKmlLuaControlHandler
---@field edit_Enter UIKmlLuaControlHandler
local KLChangeAttrSchemePanelView = {}
setmetatable(KLChangeAttrSchemePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Role/Panel/KLChangeAttrScheme/KLChangeAttrSchemePanelKml'
---@param parent UIKmlLuaControlHandler
function KLChangeAttrSchemePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLChangeAttrSchemePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Role/Panel/KLChangeAttrScheme/KLChangeAttrSchemePanel']

return KLChangeAttrSchemePanelView

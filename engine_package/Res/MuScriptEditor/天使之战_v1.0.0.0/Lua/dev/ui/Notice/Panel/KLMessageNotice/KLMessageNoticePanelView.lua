---@class KLMessageNoticePanelView:UIKmlLuaViewBase
---@field layout_55 UIKmlLuaControl
---@field item_ld1 UIKmlLuaControl
---@field img_57 UIKmlLuaControl
---@field text_message UIKmlLuaControl
---@field item_ld2 UIKmlLuaControl
---@field img_60 UIKmlLuaControl
---@field text_message UIKmlLuaControl
---@field item_ld3 UIKmlLuaControl
---@field img_63 UIKmlLuaControl
---@field text_message UIKmlLuaControl
---@field item_ld4 UIKmlLuaControl
---@field img_66 UIKmlLuaControl
---@field text_message UIKmlLuaControl
---@field item_ld5 UIKmlLuaControl
---@field img_69 UIKmlLuaControl
---@field text_message UIKmlLuaControl
---@field item_ld6 UIKmlLuaControl
---@field img_72 UIKmlLuaControl
---@field text_message UIKmlLuaControl
---@field panel_74 UIKmlLuaControl
---@field text_mid_message UIKmlLuaControl
local KLMessageNoticePanelView = {}
setmetatable(KLMessageNoticePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Notice/Panel/KLMessageNotice/KLMessageNoticePanelKml'
---@param parent UIKmlLuaControl
function KLMessageNoticePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMessageNoticePanelView

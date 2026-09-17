---@class KLMessageNoticePanelView:UIKmlLuaViewBase
---@field layout_55 UIKmlLuaControlHandler
---@field item_ld1 UIKmlLuaControlHandler
---@field img_57 UIKmlLuaControlHandler
---@field text_message UIKmlLuaControlHandler
---@field item_ld2 UIKmlLuaControlHandler
---@field img_60 UIKmlLuaControlHandler
---@field text_message UIKmlLuaControlHandler
---@field item_ld3 UIKmlLuaControlHandler
---@field img_63 UIKmlLuaControlHandler
---@field text_message UIKmlLuaControlHandler
---@field item_ld4 UIKmlLuaControlHandler
---@field img_66 UIKmlLuaControlHandler
---@field text_message UIKmlLuaControlHandler
---@field item_ld5 UIKmlLuaControlHandler
---@field img_69 UIKmlLuaControlHandler
---@field text_message UIKmlLuaControlHandler
---@field item_ld6 UIKmlLuaControlHandler
---@field img_72 UIKmlLuaControlHandler
---@field text_message UIKmlLuaControlHandler
---@field panel_74 UIKmlLuaControlHandler
---@field text_mid_message UIKmlLuaControlHandler
local KLMessageNoticePanelView = {}
setmetatable(KLMessageNoticePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Notice/Panel/KLMessageNotice/KLMessageNoticePanelKml'
---@param parent UIKmlLuaControlHandler
function KLMessageNoticePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMessageNoticePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Notice/Panel/KLMessageNotice/KLMessageNoticePanel']

return KLMessageNoticePanelView

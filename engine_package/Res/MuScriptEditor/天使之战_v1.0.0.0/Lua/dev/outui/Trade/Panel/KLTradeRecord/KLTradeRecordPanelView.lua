---@class KLTradeRecordPanelView:UIKmlLuaViewBase
---@field img_19 UIKmlLuaControlHandler
---@field text_20 UIKmlLuaControlHandler
---@field text_21 UIKmlLuaControlHandler
---@field text_22 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text_23 UIKmlLuaControlHandler
---@field osa_list_record UIKmlLuaControlHandler
---@field datalist_225 UIKmlLuaControlHandler
local KLTradeRecordPanelView = {}
setmetatable(KLTradeRecordPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeRecord/KLTradeRecordPanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLTradeRecordPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeRecordPanelView

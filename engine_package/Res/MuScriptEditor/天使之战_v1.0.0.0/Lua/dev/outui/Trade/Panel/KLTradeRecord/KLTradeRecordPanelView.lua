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
---@param parent UIKmlLuaControlHandler
function KLTradeRecordPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeRecordPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Panel/KLTradeRecord/KLTradeRecordPanel']

return KLTradeRecordPanelView

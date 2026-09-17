---@class KLCommonGainItemShowPanelView:UIKmlLuaViewBase
---@field 11 UIKmlLuaControlHandler
---@field CloseBG UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field scrollviewList UIKmlLuaControlHandler
---@field gridview23 UIKmlLuaControlHandler
---@field rewards UIKmlLuaControlHandler
---@field showTxt UIKmlLuaControlHandler
local KLCommonGainItemShowPanelView = {}
setmetatable(KLCommonGainItemShowPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Panel/KLCommonGainItemShow/KLCommonGainItemShowPanelKml'
---@param parent UIKmlLuaControlHandler
function KLCommonGainItemShowPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLCommonGainItemShowPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/OperateActivity/Panel/KLCommonGainItemShow/KLCommonGainItemShowPanel']

return KLCommonGainItemShowPanelView

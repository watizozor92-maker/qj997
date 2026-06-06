---@class KLCommonGainItemShowPanelView:UIKmlLuaViewBase
---@field 11 UIKmlLuaControl
---@field CloseBG UIKmlLuaControl
---@field bgImg UIKmlLuaControl
---@field title UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field scrollviewList UIKmlLuaControl
---@field gridview23 UIKmlLuaControl
---@field rewards UIKmlLuaControl
---@field showTxt UIKmlLuaControl
local KLCommonGainItemShowPanelView = {}
setmetatable(KLCommonGainItemShowPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Panel/KLCommonGainItemShow/KLCommonGainItemShowPanelKml'
---@param parent UIKmlLuaControl
function KLCommonGainItemShowPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLCommonGainItemShowPanelView

---@class KLFashionMountTipPanelView:UIKmlLuaViewBase
---@field maskBg UIKmlLuaControl
---@field Bg UIKmlLuaControl
---@field scrollview3 UIKmlLuaControl
---@field layout4 UIKmlLuaControl
---@field gridview5 UIKmlLuaControl
---@field datalist_ride UIKmlLuaControl
---@field panel1 UIKmlLuaControl
---@field fashionTitle UIKmlLuaControl
---@field titleText UIKmlLuaControl
---@field layout_Name UIKmlLuaControl
---@field datalist_Name UIKmlLuaControl
---@field panel2 UIKmlLuaControl
---@field fashionInfoTitle UIKmlLuaControl
---@field text4 UIKmlLuaControl
---@field layout_Info UIKmlLuaControl
---@field datalist_Info UIKmlLuaControl
local KLFashionMountTipPanelView = {}
setmetatable(KLFashionMountTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLFashionMountTip/KLFashionMountTipPanelKml'
---@param parent UIKmlLuaControl
function KLFashionMountTipPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLFashionMountTipPanelView

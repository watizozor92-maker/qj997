---@class KLCDKUsePanelView:UIKmlLuaViewBase
---@field Btn_Close UIKmlLuaControl
---@field Content UIKmlLuaControl
---@field Title UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field Input_CDK UIKmlLuaControl
---@field Btn_Confirm UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field CloseBtn UIKmlLuaControl
local KLCDKUsePanelView = {}
setmetatable(KLCDKUsePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ShopMain/Panel/KLCDKUse/KLCDKUsePanelKml'
---@param parent UIKmlLuaControl
function KLCDKUsePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLCDKUsePanelView

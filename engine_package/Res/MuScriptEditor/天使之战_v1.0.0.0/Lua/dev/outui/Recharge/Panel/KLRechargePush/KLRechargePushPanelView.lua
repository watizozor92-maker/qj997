---@class KLRechargePushPanelView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControl
---@field ImageTitle UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field img5 UIKmlLuaControl
---@field Texts UIKmlLuaControl
---@field BuyBtn UIKmlLuaControl
---@field Item_model UIKmlLuaControl
---@field scrollview1 UIKmlLuaControl
---@field gridview2 UIKmlLuaControl
---@field CloseBtn UIKmlLuaControl
local KLRechargePushPanelView = {}
setmetatable(KLRechargePushPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Recharge/Panel/KLRechargePush/KLRechargePushPanelKml'
---@param parent UIKmlLuaControl
function KLRechargePushPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRechargePushPanelView

---@class KLMountShowTipsPanelView:UIKmlLuaViewBase
---@field MsakBtn UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field MountItemData UIKmlLuaControlHandler
local KLMountShowTipsPanelView = {}
setmetatable(KLMountShowTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Tips/Panel/KLMountShowTips/KLMountShowTipsPanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLMountShowTipsPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMountShowTipsPanelView

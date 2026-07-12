---@class KLMountShowTipsPanelView:UIKmlLuaViewBase
---@field MsakBtn UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field MountItemData UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
local KLMountShowTipsPanelView = {}
setmetatable(KLMountShowTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Tips/Panel/KLMountShowTips/KLMountShowTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMountShowTipsPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMountShowTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Tips/Panel/KLMountShowTips/KLMountShowTipsPanel']

return KLMountShowTipsPanelView

---@class KLMountTipPanelView:UIKmlLuaViewBase
---@field bgMask UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field mount_model UIKmlLuaControl
---@field info_root UIKmlLuaControl
---@field item_model UIKmlLuaControl
---@field t UIKmlLuaControl
---@field img8 UIKmlLuaControl
---@field attList UIKmlLuaControl
---@field cancelBtn UIKmlLuaControl
---@field putOnBtn UIKmlLuaControl
---@field title UIKmlLuaControl
---@field text2 UIKmlLuaControl
---@field expTxt UIKmlLuaControl
---@field levelTxt UIKmlLuaControl
local KLMountTipPanelView = {}
setmetatable(KLMountTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountTip/KLMountTipPanelKml'
---@param parent UIKmlLuaControl
function KLMountTipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMountTipPanelView

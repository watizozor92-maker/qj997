---@class KLMountTipPanelView:UIKmlLuaViewBase
---@field bgMask UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field mount_model UIKmlLuaControlHandler
---@field info_root UIKmlLuaControlHandler
---@field item_model UIKmlLuaControlHandler
---@field t UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field attList UIKmlLuaControlHandler
---@field cancelBtn UIKmlLuaControlHandler
---@field putOnBtn UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field expTxt UIKmlLuaControlHandler
---@field levelTxt UIKmlLuaControlHandler
local KLMountTipPanelView = {}
setmetatable(KLMountTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountTip/KLMountTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMountTipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMountTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Panel/KLMountTip/KLMountTipPanel']

return KLMountTipPanelView

---@class KLFirstChargeADPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field model_icon UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field DevilText UIKmlLuaControlHandler
---@field CloseBtn UIKmlLuaControlHandler
local KLFirstChargeADPanelView = {}
setmetatable(KLFirstChargeADPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanelKml'
---@param parent UIKmlLuaControlHandler
function KLFirstChargeADPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFirstChargeADPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanel']

return KLFirstChargeADPanelView

---@class KLBloodTipPanelView:UIKmlLuaViewBase
---@field root1 UIKmlLuaControlHandler
---@field bg1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field ContentTxt UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field okBtn UIKmlLuaControlHandler
---@field cancelBtn UIKmlLuaControlHandler
---@field root2 UIKmlLuaControlHandler
---@field bg1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field ContentTxt1 UIKmlLuaControlHandler
---@field cancelBtn1 UIKmlLuaControlHandler
local KLBloodTipPanelView = {}
setmetatable(KLBloodTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLBloodTip/KLBloodTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBloodTipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBloodTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLBloodTip/KLBloodTipPanel']

return KLBloodTipPanelView

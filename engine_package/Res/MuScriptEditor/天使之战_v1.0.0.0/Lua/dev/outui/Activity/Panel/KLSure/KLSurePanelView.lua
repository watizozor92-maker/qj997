---@class KLSurePanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field ContentTxt UIKmlLuaControlHandler
---@field cancelBtn UIKmlLuaControlHandler
---@field okBtn UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLSurePanelView = {}
setmetatable(KLSurePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLSure/KLSurePanelKml'
---@param parent UIKmlLuaControlHandler
function KLSurePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSurePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLSure/KLSurePanel']

return KLSurePanelView

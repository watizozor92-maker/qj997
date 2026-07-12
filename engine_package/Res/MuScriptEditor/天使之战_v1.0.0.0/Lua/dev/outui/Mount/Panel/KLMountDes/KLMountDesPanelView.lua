---@class KLMountDesPanelView:UIKmlLuaViewBase
---@field bgMask UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field ContentTxt UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
local KLMountDesPanelView = {}
setmetatable(KLMountDesPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountDes/KLMountDesPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMountDesPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMountDesPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Panel/KLMountDes/KLMountDesPanel']

return KLMountDesPanelView

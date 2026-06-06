---@class KLMountDesPanelView:UIKmlLuaViewBase
---@field bgMask UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field title UIKmlLuaControl
---@field ContentTxt UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
local KLMountDesPanelView = {}
setmetatable(KLMountDesPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountDes/KLMountDesPanelKml'
---@param parent UIKmlLuaControl
function KLMountDesPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMountDesPanelView

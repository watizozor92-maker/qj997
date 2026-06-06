---@class KLArchangelMasterPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field scrollview4 UIKmlLuaControl
---@field layout5 UIKmlLuaControl
---@field suit_datalist UIKmlLuaControl
---@field close UIKmlLuaControl
---@field title UIKmlLuaControl
local KLArchangelMasterPanelView = {}
setmetatable(KLArchangelMasterPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelMaster/KLArchangelMasterPanelKml'
---@param parent UIKmlLuaControl
function KLArchangelMasterPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLArchangelMasterPanelView

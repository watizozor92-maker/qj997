---@class KLArchangelMasterPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field scrollview4 UIKmlLuaControlHandler
---@field layout5 UIKmlLuaControlHandler
---@field suit_datalist UIKmlLuaControlHandler
---@field close UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
local KLArchangelMasterPanelView = {}
setmetatable(KLArchangelMasterPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelMaster/KLArchangelMasterPanelKml'
---@param parent UIKmlLuaControlHandler
function KLArchangelMasterPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLArchangelMasterPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLArchangelMaster/KLArchangelMasterPanel']

return KLArchangelMasterPanelView

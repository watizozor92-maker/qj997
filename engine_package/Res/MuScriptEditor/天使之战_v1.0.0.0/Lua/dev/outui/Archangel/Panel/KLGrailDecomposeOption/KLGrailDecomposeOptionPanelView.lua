---@class KLGrailDecomposeOptionPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field option_layout UIKmlLuaControlHandler
---@field option_list UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field close UIKmlLuaControlHandler
local KLGrailDecomposeOptionPanelView = {}
setmetatable(KLGrailDecomposeOptionPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLGrailDecomposeOption/KLGrailDecomposeOptionPanelKml'
---@param parent UIKmlLuaControlHandler
function KLGrailDecomposeOptionPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLGrailDecomposeOptionPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLGrailDecomposeOption/KLGrailDecomposeOptionPanel']

return KLGrailDecomposeOptionPanelView

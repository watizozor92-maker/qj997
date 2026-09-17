---@class KLGrailDecomposeItemView:UIKmlLuaViewBase
---@field grail_item UIKmlLuaControlHandler
---@field strengthLevel UIKmlLuaControlHandler
local KLGrailDecomposeItemView = {}
setmetatable(KLGrailDecomposeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Item/KLGrailDecompose/KLGrailDecomposeItemKml'
---@param parent UIKmlLuaControlHandler
function KLGrailDecomposeItemView:Init(parent)

    self:InitRoot(parent, kmlPath, KLGrailDecomposeItemView.content)
end
---@type KLGrailDecomposeItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Item/KLGrailDecompose/KLGrailDecomposeItem']

return KLGrailDecomposeItemView

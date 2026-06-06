---@class KLGrailDecomposeItemView:UIKmlLuaViewBase
---@field grail_item UIKmlLuaControl
---@field strengthLevel UIKmlLuaControl
local KLGrailDecomposeItemView = {}
setmetatable(KLGrailDecomposeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Item/KLGrailDecompose/KLGrailDecomposeItemKml'
---@param parent UIKmlLuaControl
function KLGrailDecomposeItemView:Init(parent)

    self:InitRoot(parent, kmlPath, KLGrailDecomposeItemView.content)
end
return KLGrailDecomposeItemView

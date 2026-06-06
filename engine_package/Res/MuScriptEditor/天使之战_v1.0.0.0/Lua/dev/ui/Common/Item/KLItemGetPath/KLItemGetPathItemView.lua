---@class KLItemGetPathItemView:UIKmlLuaViewBase
---@field item UIKmlLuaControlHandler
---@field itemBg UIKmlLuaControlHandler
---@field buyContainer UIKmlLuaControlHandler
---@field itemModel UIKmlLuaControlHandler
---@field costModel UIKmlLuaControlHandler
---@field costItemName UIKmlLuaControlHandler
---@field costCount UIKmlLuaControlHandler
---@field gainTxt UIKmlLuaControlHandler
---@field buyBtn UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
local KLItemGetPathItemView = {}
setmetatable(KLItemGetPathItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Item/KLItemGetPath/KLItemGetPathItemKml'
---@param parent UIKmlLuaControlHandler
function KLItemGetPathItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLItemGetPathItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Item/KLItemGetPath/KLItemGetPathItem']

return KLItemGetPathItemView

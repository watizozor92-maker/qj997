---@class KLRenderItemView:UIKmlLuaViewBase
---@field SpTag UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field gridview1 UIKmlLuaControlHandler
---@field datalist11 UIKmlLuaControlHandler
local KLRenderItemView = {}
setmetatable(KLRenderItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Item/KLRender/KLRenderItemKml'
---@param parent UIKmlLuaControlHandler
function KLRenderItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRenderItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/AppearGroup/Item/KLRender/KLRenderItem']

return KLRenderItemView

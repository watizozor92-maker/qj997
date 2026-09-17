---@class KLUnionArmbandItemView:UIKmlLuaViewBase
---@field img_55 UIKmlLuaControlHandler
---@field predes UIKmlLuaControlHandler
---@field preArr UIKmlLuaControlHandler
---@field tag1 UIKmlLuaControlHandler
---@field nextpreArr UIKmlLuaControlHandler
---@field tag2 UIKmlLuaControlHandler
local KLUnionArmbandItemView = {}
setmetatable(KLUnionArmbandItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Item/KLUnionArmband/KLUnionArmbandItemKml'
---@param parent UIKmlLuaControlHandler
function KLUnionArmbandItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionArmbandItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Item/KLUnionArmband/KLUnionArmbandItem']

return KLUnionArmbandItemView

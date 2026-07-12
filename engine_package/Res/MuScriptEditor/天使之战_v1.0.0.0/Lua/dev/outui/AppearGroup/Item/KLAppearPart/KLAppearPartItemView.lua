---@class KLAppearPartItemView:UIKmlLuaViewBase
---@field SpTag UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field gridview1 UIKmlLuaControlHandler
---@field datalist11 UIKmlLuaControlHandler
local KLAppearPartItemView = {}
setmetatable(KLAppearPartItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Item/KLAppearPart/KLAppearPartItemKml'
---@param parent UIKmlLuaControlHandler
function KLAppearPartItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLAppearPartItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/AppearGroup/Item/KLAppearPart/KLAppearPartItem']

return KLAppearPartItemView

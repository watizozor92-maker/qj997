---@class KLBuffInfoItemView:UIKmlLuaViewBase
---@field control_circlebar UIKmlLuaControlHandler
---@field text_layer UIKmlLuaControlHandler
local KLBuffInfoItemView = {}
setmetatable(KLBuffInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLBuffInfo/KLBuffInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLBuffInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBuffInfoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Item/KLBuffInfo/KLBuffInfoItem']

return KLBuffInfoItemView

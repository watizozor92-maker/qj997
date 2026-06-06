---@class KLPkItemView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field pkBtn UIKmlLuaControlHandler
---@field pk_name UIKmlLuaControlHandler
local KLPkItemView = {}
setmetatable(KLPkItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLPk/KLPkItemKml'
---@param parent UIKmlLuaControlHandler
function KLPkItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLPkItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Item/KLPk/KLPkItem']

return KLPkItemView

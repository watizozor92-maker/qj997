---@class KLUISystemItemView:UIKmlLuaViewBase
---@field sysIcon UIKmlLuaControlHandler
---@field red UIKmlLuaControlHandler
---@field TimeText UIKmlLuaControlHandler
local KLUISystemItemView = {}
setmetatable(KLUISystemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLUISystem/KLUISystemItemKml'
---@param parent UIKmlLuaControlHandler
function KLUISystemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISystemItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Item/KLUISystem/KLUISystemItem']

return KLUISystemItemView

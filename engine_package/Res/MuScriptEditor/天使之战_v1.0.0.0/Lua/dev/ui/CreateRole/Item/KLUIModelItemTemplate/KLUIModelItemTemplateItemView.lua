---@class KLUIModelItemTemplateItemView:UIKmlLuaViewBase
---@field UIModelItemTemplate UIKmlLuaControlHandler
---@field Image UIKmlLuaControlHandler
---@field ImageCareer UIKmlLuaControlHandler
---@field DeleteBtn UIKmlLuaControlHandler
---@field Name UIKmlLuaControlHandler
---@field Level UIKmlLuaControlHandler
---@field ModelBtn UIKmlLuaControlHandler
local KLUIModelItemTemplateItemView = {}
setmetatable(KLUIModelItemTemplateItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/CreateRole/Item/KLUIModelItemTemplate/KLUIModelItemTemplateItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIModelItemTemplateItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLUIModelItemTemplateItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/CreateRole/Item/KLUIModelItemTemplate/KLUIModelItemTemplateItem']

return KLUIModelItemTemplateItemView

---@class KLCareerButtonItemView:UIKmlLuaViewBase
---@field toggle_createrole UIKmlLuaControlHandler
---@field text_toggle_createrole UIKmlLuaControlHandler
local KLCareerButtonItemView = {}
setmetatable(KLCareerButtonItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/CreateRole/Item/KLCareerButton/KLCareerButtonItemKml'
---@param parent UIKmlLuaControlHandler
function KLCareerButtonItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLCareerButtonItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/CreateRole/Item/KLCareerButton/KLCareerButtonItem']

return KLCareerButtonItemView

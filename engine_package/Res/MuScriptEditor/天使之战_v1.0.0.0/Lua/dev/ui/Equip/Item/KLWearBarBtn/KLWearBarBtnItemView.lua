---@class KLWearBarBtnItemView:UIKmlLuaViewBase
---@field prefab_293 UIKmlLuaControlHandler
---@field toggle_item UIKmlLuaControlHandler
---@field ItemBackground UIKmlLuaControlHandler
---@field ItemCheckmark UIKmlLuaControlHandler
---@field ItemLabel UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
local KLWearBarBtnItemView = {}
setmetatable(KLWearBarBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Equip/Item/KLWearBarBtn/KLWearBarBtnItemKml'
---@param parent UIKmlLuaControlHandler
function KLWearBarBtnItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLWearBarBtnItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Equip/Item/KLWearBarBtn/KLWearBarBtnItem']

return KLWearBarBtnItemView

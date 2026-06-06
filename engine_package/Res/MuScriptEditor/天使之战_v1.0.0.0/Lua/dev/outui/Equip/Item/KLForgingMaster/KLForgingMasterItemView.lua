---@class KLForgingMasterItemView:UIKmlLuaViewBase
---@field Title UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field Text_Title UIKmlLuaControlHandler
---@field Text_Progress UIKmlLuaControlHandler
---@field layout9 UIKmlLuaControlHandler
---@field DataList_Attr UIKmlLuaControlHandler
local KLForgingMasterItemView = {}
setmetatable(KLForgingMasterItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Item/KLForgingMaster/KLForgingMasterItemKml'
---@param parent UIKmlLuaControlHandler
function KLForgingMasterItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLForgingMasterItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Item/KLForgingMaster/KLForgingMasterItem']

return KLForgingMasterItemView

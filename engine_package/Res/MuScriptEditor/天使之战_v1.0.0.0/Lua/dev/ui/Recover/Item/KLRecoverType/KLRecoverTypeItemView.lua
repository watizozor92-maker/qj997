---@class KLRecoverTypeItemView:UIKmlLuaViewBase
---@field prefab_11 UIKmlLuaControlHandler
---@field KmlRecycleTypeItemTemplate UIKmlLuaControlHandler
---@field TypeCheck UIKmlLuaControlHandler
---@field TypeText UIKmlLuaControlHandler
---@field xiangxi UIKmlLuaControlHandler
---@field xiangxi_btn UIKmlLuaControlHandler
local KLRecoverTypeItemView = {}
setmetatable(KLRecoverTypeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Recover/Item/KLRecoverType/KLRecoverTypeItemKml'
---@param parent UIKmlLuaControlHandler
function KLRecoverTypeItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRecoverTypeItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Recover/Item/KLRecoverType/KLRecoverTypeItem']

return KLRecoverTypeItemView

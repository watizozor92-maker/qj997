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
---@param parent UIKmlLuaControlHandlerHandlerHandler
function KLRecoverTypeItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRecoverTypeItemView

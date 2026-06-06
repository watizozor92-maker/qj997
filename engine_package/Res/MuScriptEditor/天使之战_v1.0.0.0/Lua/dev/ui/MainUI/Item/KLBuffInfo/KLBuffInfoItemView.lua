---@class KLBuffInfoItemView:UIKmlLuaViewBase
---@field control_circlebar UIKmlLuaControl
---@field text_layer UIKmlLuaControl
local KLBuffInfoItemView = {}
setmetatable(KLBuffInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLBuffInfo/KLBuffInfoItemKml'
---@param parent UIKmlLuaControl
function KLBuffInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLBuffInfoItemView

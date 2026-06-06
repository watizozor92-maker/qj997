---@class KLCommonItemView:UIKmlLuaViewBase
---@field item UIKmlLuaControl
---@field outNode UIKmlLuaControl
---@field txt_rank UIKmlLuaControl
---@field img_arrow UIKmlLuaControl
---@field img_leftTop UIKmlLuaControl
local KLCommonItemView = {}
setmetatable(KLCommonItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OutCommon/Item/KLCommon/KLCommonItemKml'
---@param parent UIKmlLuaControl
function KLCommonItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLCommonItemView

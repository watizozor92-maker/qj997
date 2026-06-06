---@class KLStallNoticeSelectItemView:UIKmlLuaViewBase
---@field no_select UIKmlLuaControl
---@field select UIKmlLuaControl
---@field toggle UIKmlLuaControl
---@field toggle_select UIKmlLuaControl
---@field one_notice_select UIKmlLuaControl
---@field one_notice UIKmlLuaControl
local KLStallNoticeSelectItemView = {}
setmetatable(KLStallNoticeSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLStallNoticeSelectItem/KLStallNoticeSelectItemKml'
---@param parent UIKmlLuaControl
function KLStallNoticeSelectItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLStallNoticeSelectItemView

---@class KLStallNoticeSelectItemView:UIKmlLuaViewBase
---@field no_select UIKmlLuaControlHandler
---@field select UIKmlLuaControlHandler
---@field toggle UIKmlLuaControlHandler
---@field toggle_select UIKmlLuaControlHandler
---@field one_notice_select UIKmlLuaControlHandler
---@field one_notice UIKmlLuaControlHandler
local KLStallNoticeSelectItemView = {}
setmetatable(KLStallNoticeSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLStallNoticeSelectItem/KLStallNoticeSelectItemKml'
---@param parent UIKmlLuaControlHandler
function KLStallNoticeSelectItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLStallNoticeSelectItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Stall/Item/KLStallNoticeSelectItem/KLStallNoticeSelectItem']

return KLStallNoticeSelectItemView

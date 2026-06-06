---@class KLStallNoticeSelectItemView:UIKmlLuaViewBase
---@field equip_item UIKmlLuaControl
---@field arrow UIKmlLuaControl
---@field btn UIKmlLuaControl
local KLStallNoticeSelectItemView = {}
setmetatable(KLStallNoticeSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLStallNoticeSelectItem/KLStallNoticeSelectItemKml'
KLStallNoticeSelectItemView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath,nil,'.txt')
---@param parent UIKmlLuaControl
function KLStallNoticeSelectItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath,KLStallNoticeSelectItemView.content)
end
return KLStallNoticeSelectItemView

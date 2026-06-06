---@class KLShowStallItemView:UIKmlLuaViewBase
---@field null_panel UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field null_title UIKmlLuaControlHandler
---@field add UIKmlLuaControlHandler
---@field have_panel UIKmlLuaControlHandler
local KLTradeSalesItemView = {}
setmetatable(KLTradeSalesItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLShowStallItem/KLShowStallItemKml'
KLTradeSalesItemView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath,nil,'.txt')
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLTradeSalesItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath,KLTradeSalesItemView.content)
end
return KLTradeSalesItemView

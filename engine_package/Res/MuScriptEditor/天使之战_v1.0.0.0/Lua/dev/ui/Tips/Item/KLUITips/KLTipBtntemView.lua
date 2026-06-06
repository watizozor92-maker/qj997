---@class KLTipBtntemView:UIKmlLuaViewBase
---@field button_id UIKmlLuaControlHandler
local KLTipBtntemView = {}
setmetatable(KLTipBtntemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Tips/Item/KLUITips/KLTipBtntemKml'
---@param parent UIKmlLuaControlHandlerHandler
function KLTipBtntemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTipBtntemView

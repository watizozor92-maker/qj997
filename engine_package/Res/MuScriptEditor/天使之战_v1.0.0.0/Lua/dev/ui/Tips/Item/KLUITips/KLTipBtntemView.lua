---@class KLTipBtntemView:UIKmlLuaViewBase
---@field button_id UIKmlLuaControlHandler
local KLTipBtntemView = {}
setmetatable(KLTipBtntemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Tips/Item/KLUITips/KLTipBtntemKml'
---@param parent UIKmlLuaControlHandler
function KLTipBtntemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTipBtntem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Tips/Item/KLUITips/KLTipBtntem']

return KLTipBtntemView

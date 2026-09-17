---@class KLMainOperateAddRechargePanelView:UIKmlLuaViewBase
---@field img_bg UIKmlLuaControlHandler
---@field img_title UIKmlLuaControlHandler
---@field txt_showTime UIKmlLuaControlHandler
---@field scrollview_bg UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field showItemInfoList UIKmlLuaControlHandler
local KLMainOperateAddRechargePanelView = {}
setmetatable(KLMainOperateAddRechargePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MainOperateActivity/Panel/KLMainOperateAddRecharge/KLMainOperateAddRechargePanelKml'
---@param parent UIKmlLuaControlHandler
function KLMainOperateAddRechargePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMainOperateAddRechargePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MainOperateActivity/Panel/KLMainOperateAddRecharge/KLMainOperateAddRechargePanel']

return KLMainOperateAddRechargePanelView

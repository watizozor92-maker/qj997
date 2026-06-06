---@class KLMainOperateAddRechargePanelView:UIKmlLuaViewBase
---@field img_bg UIKmlLuaControl
---@field img_title UIKmlLuaControl
---@field txt_showTime UIKmlLuaControl
---@field scrollview_bg UIKmlLuaControl
---@field layout4 UIKmlLuaControl
---@field showItemInfoList UIKmlLuaControl
local KLMainOperateAddRechargePanelView = {}
setmetatable(KLMainOperateAddRechargePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MainOperateActivity/Panel/KLMainOperateAddRecharge/KLMainOperateAddRechargePanelKml'
---@param parent UIKmlLuaControl
function KLMainOperateAddRechargePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMainOperateAddRechargePanelView

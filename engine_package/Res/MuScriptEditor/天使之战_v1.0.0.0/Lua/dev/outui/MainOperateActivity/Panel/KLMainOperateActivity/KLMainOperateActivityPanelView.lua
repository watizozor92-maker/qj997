---@class KLMainOperateActivityPanelView:UIKmlLuaViewBase
---@field img_operate UIKmlLuaControl
---@field img_tog UIKmlLuaControl
---@field txt_title UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field togglegroup UIKmlLuaControl
---@field scrollview_tog UIKmlLuaControl
---@field layout6 UIKmlLuaControl
---@field TogInfoList UIKmlLuaControl
---@field img_mainOperateMask UIKmlLuaControl
---@field subParent UIKmlLuaControl
local KLMainOperateActivityPanelView = {}
setmetatable(KLMainOperateActivityPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MainOperateActivity/Panel/KLMainOperateActivity/KLMainOperateActivityPanelKml'
---@param parent UIKmlLuaControl
function KLMainOperateActivityPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMainOperateActivityPanelView

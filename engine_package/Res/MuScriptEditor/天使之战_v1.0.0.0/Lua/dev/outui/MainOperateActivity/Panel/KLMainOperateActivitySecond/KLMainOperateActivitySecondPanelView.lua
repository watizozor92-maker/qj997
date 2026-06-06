---@class KLMainOperateActivitySecondPanelView:UIKmlLuaViewBase
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
local KLMainOperateActivitySecondPanelView = {}
setmetatable(KLMainOperateActivitySecondPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MainOperateActivity/Panel/KLMainOperateActivitySecond/KLMainOperateActivitySecondPanelKml'
---@param parent UIKmlLuaControl
function KLMainOperateActivitySecondPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMainOperateActivitySecondPanelView

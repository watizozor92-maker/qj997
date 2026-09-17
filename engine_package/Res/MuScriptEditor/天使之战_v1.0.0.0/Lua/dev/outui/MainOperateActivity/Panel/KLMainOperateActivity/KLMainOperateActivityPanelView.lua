---@class KLMainOperateActivityPanelView:UIKmlLuaViewBase
---@field img_operate UIKmlLuaControlHandler
---@field img_tog UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field togglegroup UIKmlLuaControlHandler
---@field scrollview_tog UIKmlLuaControlHandler
---@field layout6 UIKmlLuaControlHandler
---@field TogInfoList UIKmlLuaControlHandler
---@field img_mainOperateMask UIKmlLuaControlHandler
---@field subParent UIKmlLuaControlHandler
local KLMainOperateActivityPanelView = {}
setmetatable(KLMainOperateActivityPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MainOperateActivity/Panel/KLMainOperateActivity/KLMainOperateActivityPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMainOperateActivityPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMainOperateActivityPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MainOperateActivity/Panel/KLMainOperateActivity/KLMainOperateActivityPanel']

return KLMainOperateActivityPanelView

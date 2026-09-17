---@class KLMainOperateActivitySecondPanelView:UIKmlLuaViewBase
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
local KLMainOperateActivitySecondPanelView = {}
setmetatable(KLMainOperateActivitySecondPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MainOperateActivity/Panel/KLMainOperateActivitySecond/KLMainOperateActivitySecondPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMainOperateActivitySecondPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMainOperateActivitySecondPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MainOperateActivity/Panel/KLMainOperateActivitySecond/KLMainOperateActivitySecondPanel']

return KLMainOperateActivitySecondPanelView

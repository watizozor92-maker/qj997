---@class KLUnionLeaderOperatePanelView:UIKmlLuaViewBase
---@field BtnMask UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field txtTitle UIKmlLuaControlHandler
---@field ImgTitle_left UIKmlLuaControlHandler
---@field ImgTitle_right UIKmlLuaControlHandler
---@field btnConfirm UIKmlLuaControlHandler
---@field btnCancel UIKmlLuaControlHandler
---@field BgCost UIKmlLuaControlHandler
---@field text14 UIKmlLuaControlHandler
---@field textCost UIKmlLuaControlHandler
---@field item17 UIKmlLuaControlHandler
---@field txtDesc UIKmlLuaControlHandler
---@field txtDescNew UIKmlLuaControlHandler
---@field txtCondTitle UIKmlLuaControlHandler
---@field txtCond1 UIKmlLuaControlHandler
---@field img21 UIKmlLuaControlHandler
---@field txtCond2 UIKmlLuaControlHandler
---@field img23 UIKmlLuaControlHandler
local KLUnionLeaderOperatePanelView = {}
setmetatable(KLUnionLeaderOperatePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Panel/KLUnionLeaderOperate/KLUnionLeaderOperatePanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionLeaderOperatePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionLeaderOperatePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Panel/KLUnionLeaderOperate/KLUnionLeaderOperatePanel']

return KLUnionLeaderOperatePanelView

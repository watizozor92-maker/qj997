---@class KLUnionElectionAndReplacePanelView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field Bg_Templete UIKmlLuaControlHandler
---@field panel3 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field TitleImage UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field txtCountDown UIKmlLuaControlHandler
---@field scrollTitle UIKmlLuaControlHandler
---@field nameList UIKmlLuaControlHandler
---@field levelList UIKmlLuaControlHandler
---@field ticketList UIKmlLuaControlHandler
---@field replaceLevel UIKmlLuaControlHandler
---@field scrollview3 UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field CostBg UIKmlLuaControlHandler
---@field btnAdd UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field txtCost UIKmlLuaControlHandler
---@field item UIKmlLuaControlHandler
---@field btnJoin UIKmlLuaControlHandler
---@field tips UIKmlLuaControlHandler
local KLUnionElectionAndReplacePanelView = {}
setmetatable(KLUnionElectionAndReplacePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Panel/KLUnionElectionAndReplace/KLUnionElectionAndReplacePanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionElectionAndReplacePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionElectionAndReplacePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Panel/KLUnionElectionAndReplace/KLUnionElectionAndReplacePanel']

return KLUnionElectionAndReplacePanelView

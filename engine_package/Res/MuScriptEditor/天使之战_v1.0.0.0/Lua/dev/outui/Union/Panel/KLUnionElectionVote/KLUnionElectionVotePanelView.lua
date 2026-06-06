---@class KLUnionElectionVotePanelView:UIKmlLuaViewBase
---@field btnMask UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field btnConfirm UIKmlLuaControlHandler
---@field btnCancel UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field BgNum UIKmlLuaControlHandler
---@field text15 UIKmlLuaControlHandler
---@field txtNum UIKmlLuaControlHandler
---@field img18 UIKmlLuaControlHandler
---@field btnMinus UIKmlLuaControlHandler
---@field btnAdd UIKmlLuaControlHandler
---@field BgCost UIKmlLuaControlHandler
---@field text14 UIKmlLuaControlHandler
---@field txtCost UIKmlLuaControlHandler
---@field itemCost UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field BgOwn UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field txtOwn UIKmlLuaControlHandler
---@field itemOwn UIKmlLuaControlHandler
---@field img13 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field imgTitle UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLUnionElectionVotePanelView = {}
setmetatable(KLUnionElectionVotePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Panel/KLUnionElectionVote/KLUnionElectionVotePanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionElectionVotePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionElectionVotePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Panel/KLUnionElectionVote/KLUnionElectionVotePanel']

return KLUnionElectionVotePanelView

---@class KLCopyTeamPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field ticketBtn UIKmlLuaControlHandler
---@field ticketCount UIKmlLuaControlHandler
---@field ticketModel UIKmlLuaControlHandler
---@field addBtn UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field countDown UIKmlLuaControlHandler
---@field BtnDissolve UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field Btcanel UIKmlLuaControlHandler
---@field Btnok UIKmlLuaControlHandler
---@field teamInfoList UIKmlLuaControlHandler
---@field layout12 UIKmlLuaControlHandler
---@field teamList UIKmlLuaControlHandler
local KLCopyTeamPanelView = {}
setmetatable(KLCopyTeamPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanelKml'
---@param parent UIKmlLuaControlHandler
function KLCopyTeamPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLCopyTeamPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel']

return KLCopyTeamPanelView

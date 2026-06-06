---@class KLTeamCopyStatusPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field img_522 UIKmlLuaControlHandler
---@field img_title UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field tipsContent UIKmlLuaControlHandler
---@field btn_sure UIKmlLuaControlHandler
---@field btn_Join UIKmlLuaControlHandler
---@field btn_cancel UIKmlLuaControlHandler
---@field input UIKmlLuaControlHandler
---@field toggle UIKmlLuaControlHandler
---@field tip_text UIKmlLuaControlHandler
---@field scrollview_playerlist UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field all_player_dl UIKmlLuaControlHandler
---@field cost_1 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field ticketBtn3 UIKmlLuaControlHandler
---@field ticketCount3 UIKmlLuaControlHandler
---@field ticketModel3 UIKmlLuaControlHandler
---@field addCountBtn2 UIKmlLuaControlHandler
---@field ticketItem UIKmlLuaControlHandler
---@field cost_2 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field ticketBtn UIKmlLuaControlHandler
---@field ticketCount UIKmlLuaControlHandler
---@field ticketModel UIKmlLuaControlHandler
---@field changeTicketButton UIKmlLuaControlHandler
---@field changeRoot UIKmlLuaControlHandler
---@field ticketBtn2 UIKmlLuaControlHandler
---@field ticketCount2 UIKmlLuaControlHandler
---@field ticketModel2 UIKmlLuaControlHandler
---@field addCountBtn UIKmlLuaControlHandler
local KLTeamCopyStatusPanelView = {}
setmetatable(KLTeamCopyStatusPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLTeamCopyStatus/KLTeamCopyStatusPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTeamCopyStatusPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTeamCopyStatusPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLTeamCopyStatus/KLTeamCopyStatusPanel']

return KLTeamCopyStatusPanelView

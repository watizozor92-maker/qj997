---@class KLLoranSiegeCopyTaskPanelView:UIKmlLuaViewBase
---@field Boss UIKmlLuaControlHandler
---@field ActivityName UIKmlLuaControlHandler
---@field line_1 UIKmlLuaControlHandler
---@field line_2 UIKmlLuaControlHandler
---@field task_root UIKmlLuaControlHandler
---@field pos_root UIKmlLuaControlHandler
---@field TaskButton UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field taskIcon UIKmlLuaControlHandler
---@field stateName UIKmlLuaControlHandler
---@field taskName UIKmlLuaControlHandler
---@field taskProgress UIKmlLuaControlHandler
---@field nowOccupyingPartyTitle UIKmlLuaControlHandler
---@field nowOccupyingPartyName UIKmlLuaControlHandler
---@field unionRankTitle UIKmlLuaControlHandler
---@field unionRankText UIKmlLuaControlHandler
---@field myRankTitle UIKmlLuaControlHandler
---@field myRankText UIKmlLuaControlHandler
---@field myPointsTitle UIKmlLuaControlHandler
---@field myPointsText UIKmlLuaControlHandler
---@field end_time UIKmlLuaControlHandler
---@field HelpButton UIKmlLuaControlHandler
---@field text_countdown_tips UIKmlLuaControlHandler
---@field text_countdown_tips_text UIKmlLuaControlHandler
---@field begin_root UIKmlLuaControlHandler
---@field openDes UIKmlLuaControlHandler
---@field openDesTxt UIKmlLuaControlHandler
---@field exitBtn UIKmlLuaControlHandler
---@field loading UIKmlLuaControlHandler
---@field loadingText UIKmlLuaControlHandler
---@field loadingNumText UIKmlLuaControlHandler
local KLLoranSiegeCopyTaskPanelView = {}
setmetatable(KLLoranSiegeCopyTaskPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/LoranSiege/Panel/KLLoranSiegeCopyTask/KLLoranSiegeCopyTaskPanelKml'
---@param parent UIKmlLuaControlHandler
function KLLoranSiegeCopyTaskPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLLoranSiegeCopyTaskPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/LoranSiege/Panel/KLLoranSiegeCopyTask/KLLoranSiegeCopyTaskPanel']

return KLLoranSiegeCopyTaskPanelView

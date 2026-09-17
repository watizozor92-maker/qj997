---@class KLLuckyTurnTablePanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field mask UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field bg2 UIKmlLuaControlHandler
---@field reTime UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field xunbaoquanModel UIKmlLuaControlHandler
---@field ModelCount UIKmlLuaControlHandler
---@field OneBtn UIKmlLuaControlHandler
---@field freeTime UIKmlLuaControlHandler
---@field oneBtnTextCount UIKmlLuaControlHandler
---@field oneBtnText UIKmlLuaControlHandler
---@field oneBtnImage UIKmlLuaControlHandler
---@field OnecostModel UIKmlLuaControlHandler
---@field FreeRedDot UIKmlLuaControlHandler
---@field TenBtn UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field tenBtntext UIKmlLuaControlHandler
---@field tenBtnTextCount UIKmlLuaControlHandler
---@field tenBtnImage UIKmlLuaControlHandler
---@field TenCostModel UIKmlLuaControlHandler
---@field img14 UIKmlLuaControlHandler
---@field SkipToggle UIKmlLuaControlHandler
---@field text16 UIKmlLuaControlHandler
---@field oddsBtn UIKmlLuaControlHandler
---@field table UIKmlLuaControlHandler
---@field 1 UIKmlLuaControlHandler
---@field 2 UIKmlLuaControlHandler
---@field 3 UIKmlLuaControlHandler
---@field 4 UIKmlLuaControlHandler
---@field 5 UIKmlLuaControlHandler
---@field 6 UIKmlLuaControlHandler
---@field 7 UIKmlLuaControlHandler
---@field 8 UIKmlLuaControlHandler
---@field 9 UIKmlLuaControlHandler
---@field 10 UIKmlLuaControlHandler
---@field 11 UIKmlLuaControlHandler
---@field 12 UIKmlLuaControlHandler
---@field 13 UIKmlLuaControlHandler
---@field 14 UIKmlLuaControlHandler
---@field 15 UIKmlLuaControlHandler
---@field 16 UIKmlLuaControlHandler
---@field rewardShow UIKmlLuaControlHandler
---@field rewardShowGrid UIKmlLuaControlHandler
---@field GetShowText UIKmlLuaControlHandler
---@field getShow UIKmlLuaControlHandler
---@field GetShowGrid UIKmlLuaControlHandler
---@field exreward UIKmlLuaControlHandler
---@field NowTime UIKmlLuaControlHandler
---@field NowTimeText UIKmlLuaControlHandler
---@field img40 UIKmlLuaControlHandler
---@field text39 UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field Reward_list UIKmlLuaControlHandler
local KLLuckyTurnTablePanelView = {}
setmetatable(KLLuckyTurnTablePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Panel/KLLuckyTurnTable/KLLuckyTurnTablePanelKml'
---@param parent UIKmlLuaControlHandler
function KLLuckyTurnTablePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
    --self.root = UIKmlLuaControl(CS.KmlResourceManager.Create(p,kmlPath,KLLuckyTurnTablePanelView.content))
end
---@type KLLuckyTurnTablePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/OperateActivity/Panel/KLLuckyTurnTable/KLLuckyTurnTablePanel']

return KLLuckyTurnTablePanelView

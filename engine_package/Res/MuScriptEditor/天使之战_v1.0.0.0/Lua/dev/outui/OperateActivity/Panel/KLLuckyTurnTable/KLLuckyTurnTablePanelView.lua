---@class KLLuckyTurnTablePanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControl
---@field mask UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field bg2 UIKmlLuaControl
---@field reTime UIKmlLuaControl
---@field text3 UIKmlLuaControl
---@field xunbaoquanModel UIKmlLuaControl
---@field ModelCount UIKmlLuaControl
---@field OneBtn UIKmlLuaControl
---@field freeTime UIKmlLuaControl
---@field oneBtnTextCount UIKmlLuaControl
---@field oneBtnText UIKmlLuaControl
---@field oneBtnImage UIKmlLuaControl
---@field OnecostModel UIKmlLuaControl
---@field FreeRedDot UIKmlLuaControl
---@field TenBtn UIKmlLuaControl
---@field text10 UIKmlLuaControl
---@field tenBtntext UIKmlLuaControl
---@field tenBtnTextCount UIKmlLuaControl
---@field tenBtnImage UIKmlLuaControl
---@field TenCostModel UIKmlLuaControl
---@field img14 UIKmlLuaControl
---@field SkipToggle UIKmlLuaControl
---@field text16 UIKmlLuaControl
---@field oddsBtn UIKmlLuaControl
---@field table UIKmlLuaControl
---@field 1 UIKmlLuaControl
---@field 2 UIKmlLuaControl
---@field 3 UIKmlLuaControl
---@field 4 UIKmlLuaControl
---@field 5 UIKmlLuaControl
---@field 6 UIKmlLuaControl
---@field 7 UIKmlLuaControl
---@field 8 UIKmlLuaControl
---@field 9 UIKmlLuaControl
---@field 10 UIKmlLuaControl
---@field 11 UIKmlLuaControl
---@field 12 UIKmlLuaControl
---@field 13 UIKmlLuaControl
---@field 14 UIKmlLuaControl
---@field 15 UIKmlLuaControl
---@field 16 UIKmlLuaControl
---@field rewardShow UIKmlLuaControl
---@field rewardShowGrid UIKmlLuaControl
---@field GetShowText UIKmlLuaControl
---@field getShow UIKmlLuaControl
---@field GetShowGrid UIKmlLuaControl
---@field exreward UIKmlLuaControl
---@field NowTime UIKmlLuaControl
---@field NowTimeText UIKmlLuaControl
---@field img40 UIKmlLuaControl
---@field text39 UIKmlLuaControl
---@field scrollview1 UIKmlLuaControl
---@field layout3 UIKmlLuaControl
---@field Reward_list UIKmlLuaControl
local KLLuckyTurnTablePanelView = {}
setmetatable(KLLuckyTurnTablePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Panel/KLLuckyTurnTable/KLLuckyTurnTablePanelKml'
---@param parent UIKmlLuaControl
function KLLuckyTurnTablePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
    --self.root = UIKmlLuaControl(CS.KmlResourceManager.Create(p,kmlPath,KLLuckyTurnTablePanelView.content))
end
return KLLuckyTurnTablePanelView

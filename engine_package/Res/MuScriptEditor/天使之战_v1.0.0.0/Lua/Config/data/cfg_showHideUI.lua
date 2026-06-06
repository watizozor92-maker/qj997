-- 此文件工具自动生成，不要修改
---@class cfg_showHideUI_column
---@field id number @控制UIID column=1 A
---@field panelName string @UI名 column=2 B
---需要做消失显示的物体路径
---@field path string @子物体路径 column=3 C
---顺时针递增 正上=0 右上=1 右=2 右下=3 下=4 左下=5 左=6 左上=7
---@field direction number @消失方向 column=4 D
---@field showTime number @显示时间 column=5 E
---@field hideTime number @消失时间 column=6 F
---@field moveX number @上下移动距离 column=7 G
---@field moveY number @左右移动距离 column=8 H
---@field npcTalkShow number @npc聊天显示的界面 column=9 I
---控制 主界面的显示位置
---@field showPos string @控制 主界面的显示位置 column=10 J
---[[客户端不使用]]@field name sting @策划用 column=11 K
local cfg_showHideUI =
{
	{id=1, panelName="KLMiniMapPanel", path="KLMiniMapPanel", npcTalkShow=1},
	{id=2, panelName="KLTaskPanel", path="KLTaskPanel", direction=7},
	{id=7, panelName="KLMainAttackPanel", path="KLMainAttackPanel", direction=3, showPos="0#56"},
	{id=8, panelName="KLJoyStickPanel", path="KLJoyStickPanel", direction=5, showPos="0#76"},
	{id=9, panelName="KLActivityTipPanel", path="KLActivityTipPanel", direction=2, showPos="603#181"},
	{id=10, panelName="KLTalkBtnPanel", path="KLTalkBtnPanel", direction=2, showPos="0#60"},
	{id=11, panelName="KLUIChatSmallPanel", path="KLUIChatSmallPanel", direction=7},
	{id=12, panelName="KLPreviewEntrancePanel", path="KLPreviewEntrancePanel", direction=7, showPos="-300#150"},
	{id=27, panelName="KLUILeftUpPanel", path="KLUILeftUpPanel", direction=7},
	{id=28, panelName="KLUIPlayerInfoPanel", path="KLUIPlayerInfoPanel", direction=4},
	{id=29, panelName="KLUISystemLeftPanel", path="KLUISystemLeftPanel", direction=2, showPos="602#155"},
	{id=30, panelName="KLUISystemTopPanel", path="KLUISystemTopPanel", direction=0, showPos="-497#-51"},
	{id=31, panelName="KLMonsterMapPointPanel", path="KLMonsterMapPointPanel"},
	{id=32, panelName="KLUITeamWindowPanel", path="KLUITeamWindowPanel"},
	{id=33, panelName="KLPopoverPanel", path="KLPopoverPanel"},
	{id=34, panelName="KLBagTipsPanel", path="KLBagTipsPanel", direction=4, moveX=0, showPos="260#-195"},
	{id=35, panelName="KLActivityPreviewPanel", path="KLActivityPreviewPanel", direction=4},
	{id=37, panelName="KLUIBossHpPanel", path="KLUIBossHpPanel", direction=0},
	{id=38, panelName="KLUIInfoPanel", path="KLUIInfoPanel", direction=0, moveX=0, moveY=0},
	{id=39, panelName="KLFirstChargeADPanel", path="KLFirstChargeADPanel", direction=2, moveY=0},
	{id=40, panelName="KLUIHurtExpPanel", path="KLUIHurtExpPanel", direction=4},
	{id=41, panelName="KLHorseRaceLampPanel", path="KLHorseRaceLampPanel", direction=6},
	{id=42, panelName="KLNewTopMapPanelKml", path="KLNewTopMapPanelKml", direction=7},
	{id=43, panelName="KLBagButtonTipsPanelKml", path="KLBagButtonTipsPanelKml", direction=4, showPos="228#-210"},
	{id=44, panelName="KLShortcutUseItemPanelKml", path="KLShortcutUseItemPanelKml"},
}

local defaults = {direction=1, showTime=1, hideTime=0, moveX=1200, moveY=1200, npcTalkShow=0, showPos="0#0"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_showHideUI) do
	setmetatable(v, mt)
end

return cfg_showHideUI
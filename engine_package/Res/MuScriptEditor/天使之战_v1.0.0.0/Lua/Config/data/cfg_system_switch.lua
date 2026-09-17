-- 此文件工具自动生成，不要修改
---@class cfg_system_switch_column
---id
---@field id number @id column=1 A
---策划备注
---@field systemName string @ column=2 B
---格式：UI路径
---备注：工程运行时的UI路径
---1、从一级主界面的下一级开始填写
---@field btnPath string @系统按钮路径 column=3 C
---按钮类型：
---必须填写1主界面按钮 2页签
---@field btnType number @按钮名称 column=4 D
---角色到达该等级后开启该系统的功能入口
---
---填0表示该系统不开启
---@field needLevel number @开启等级 column=5 E
---开服天数到达后开启该系统的功能入口
---填0表示该系统不开启
---@field needDay number @开服天数 column=6 F
---使用cron表达式，表达式为6位数，1：秒，2：分，3：时，4：日，5：月，6：周；不指定用？；周和日只能指定一个,且另一个填成问号；csv文件格式原因，填表需将，替换为&；符号填写英文格式
---为空则表示只开服开启一次
---填1，就代表服务器开启后这个活动就会一直开启 不会重启或者中断，且会一直记录数据，不重置，（或者随便乱填，只要不是按照cron的表达式，也会导致活动不关闭，）
---全天一直开放：alltime，配置此格式 活动一直开放，服务器重启也不会重置数据
---@field time string @开启时间 column=7 G
---按钮开启持续时间，格式：时#分
---@field continuous IntList @持续时间 column=8 H
---格式:职业id#任务id|职业id#任务id
---备注:开始任务，打开按钮
---@field taskOpenid IntListList @进行任务激活按钮 column=9 I
---格式:职业id#任务id|职业id#任务id
---完成指定任务后，开启按钮，引援cfg_task
---@field finishTaskid IntListList @完成任务激活按钮 column=10 J
---关闭时间格式为：开服天数
---例：9(该天0点）
---@field endTime number @关闭时间 column=11 K
---备注：
---1 ：首充
---0或不填： 不需要首充
---@field firstCharge number @首充激活 column=12 L

local local_continuous = {
    continuous_1={},

}

local local_taskOpenid = {
    taskOpenid_1={},

}

local local_finishTaskid = {
    finishTaskid_1={},

}

local cfg_system_switch =
{
	{id=101, systemName="设    置", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnSetting", needLevel=1},
	{id=102, systemName="技能", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/button_jineng", needLevel=1},
	{id=103, systemName="邮    件", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnMail", needLevel=1},
	{id=104, systemName="锻    造", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnForge"},
	{id=10401, systemName="强化页签", btnPath="KLUIForgeGroupPanel/toggleLayout/strengthToggle", btnType=2, needLevel=1},
	{id=10402, systemName="追加页签", btnPath="KLUIForgeGroupPanel/toggleLayout/appendToggle", btnType=2, needLevel=1},
	{id=10403, systemName="镶宝页签", btnPath="KLUIForgeGroupPanel/toggleLayout/InlayToggle", btnType=2},
	{id=10404, systemName="分解页签", btnPath="KLUIForgeGroupPanel/toggleLayout/decomposeToggle", btnType=2},
	{id=10405, systemName="装备叠加页签", btnPath="KLUIForgeGroupPanel/toggleLayout/overlayToggle", btnType=2},
	{id=10406, systemName="转移页签", btnPath="KLUIForgeGroupPanel/toggleLayout/transferToggle", btnType=2},
	{id=10407, systemName="首饰", btnPath="KLUIForgeGroupPanel/toggleLayout/JewelryToggle", btnType=2},
	{id=10408, systemName="装备再生", btnPath="KLUIForgeGroupPanel/toggleLayout/RegenerateToggle", btnType=2},
	{id=105, systemName="战    盟", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnUnion", needLevel=35},
	{id=106, systemName="坐    骑"},
	{id=107, systemName="背包", btnPath="KLUISystemLeftPanel/move_root/bagBtn", needLevel=1},
	{id=108, systemName="好    友", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnFriend", needLevel=1},
	{id=109, systemName="外    观", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnDress", needLevel=1, endTime=0},
	{id=110, systemName="天赋", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnMasterRoad", needLevel=1},
	{id=11001, systemName="天赋大天使天赋页签", btnType=2},
	{id=11002, systemName="天赋职业天赋页签", btnType=2},
	{id=11003, systemName="天赋技能天赋页签", btnType=2},
	{id=11004, systemName="天赋通用天赋页签", btnType=2},
	{id=111, systemName="角色", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnRole", needLevel=1},
	{id=112, systemName="变身卡牌功能", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnCard", needDay=3},
	{id=113, systemName="变身卡牌变身", btnPath="KLUISystemLeftPanel/move_root/BtnShapeshift", needDay=3},
	{id=201, systemName="交易", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/btn_trade", needLevel=40},
	{id=202, systemName="商城", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnShop", needLevel=1},
	{id=204, systemName="效率", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnEfficiency"},
	{id=205, systemName="限时礼包", needDay=0},
	{id=206, systemName="悬赏", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnOfferAReward"},
	{id=207, systemName="攻城战", btnPath="BtnSlot/BtnCityWar", needLevel=1, needDay=4},
	{id=209, systemName="会员", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnVIP"},
	{id=211, systemName="跨服", needDay=7},
	{id=212, systemName="每日目标", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnDaily"},
	{id=213, systemName="排 行 榜", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnRankList", needLevel=41},
	{id=214, systemName="挂机", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnOffline", needDay=999},
	{id=215, systemName="挑战首领", btnPath="KLUISystemTopPanel/move_root/left/bossBtn", needLevel=1},
	{id=21502, systemName="挑战首领/野外怪", btnPath="KLChallengeBossPanel/challenge_boss_panel/boss_type_toggle_group/butten_layout/boss_2", btnType=2, needLevel=1},
	{id=21503, systemName="挑战首领/黄金部队", btnPath="KLChallengeBossPanel/challenge_boss_panel/boss_type_toggle_group/butten_layout/boss_7", btnType=2, needLevel=1},
	{id=217, systemName="月卡", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnMonth", needLevel=9999, needDay=9999},
	{id=218, systemName="三倍收益", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnEarnings"},
	{id=219, systemName="雷刃炎狼兽", btnPath="BtnMount", needLevel=9999, needDay=9999, endTime=2},
	{id=220, systemName="龙魂连击", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnCombo", needLevel=9999, needDay=9999},
	{id=223, systemName="新服活动", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnMainActivity", needLevel=9999, needDay=9999, endTime=11},
	{id=22301, systemName="黄金首杀", btnType=2, needLevel=9999, needDay=9999},
	{id=22302, systemName="大天使福利", btnType=2, needLevel=9999, needDay=9999},
	{id=221, systemName="福利", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnRecharge", needLevel=9999, needDay=9999},
	{id=224, systemName="大天使装备", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/btn_angel_equip", needLevel=1},
	{id=22401, systemName="突破", btnPath="KLArchangelGroupPanel/toggleLayout/breakthroughToggle", btnType=2, needLevel=600},
	{id=22402, systemName="圣杯", btnPath="KLArchangelGroupPanel/toggleLayout/grailToggle", btnType=2, needLevel=9999, needDay=9999},
	{id=22403, systemName="圣杯分解", btnPath="KLArchangelGroupPanel/toggleLayout/decomposeToggle", btnType=2, needLevel=9999, needDay=9999},
	{id=226, systemName="猎魔积分争霸赛", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnHuntingDemons", needLevel=9999, needDay=9999},
	{id=227, systemName="运营活动", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnOperateActivity", needLevel=9999, needDay=9999},
	{id=228, systemName="昆顿入侵", btnType=2, needLevel=9999, needDay=9999},
	{id=229, systemName="聊天/跨服", btnPath="KLUIChatPanelKml/root_panel/root/ToggleGroupChat/toggle_layout/corss_server_chat_toggle_panel", btnType=2, needLevel=9999, needDay=9999},
	{id=230, systemName="运营活动2", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/BtnOperateActivitySecond", needLevel=9999, needDay=9999},
	{id=231, systemName="装备首爆", btnPath="dev/outui/FirstDrop/Panel/KLFirstDrop/KLFirstDropPanel", needLevel=9999, needDay=9999},
	{id=232, systemName="攻略", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/Btn_gonglue", needLevel=1},
	{id=234, systemName="时装", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/Btnfashion", needLevel=400},
	{id=235, systemName="坐骑", btnPath="KLUISystemLeftPanel/move_root/systemArea/systemMenu/BtnMountStore", needLevel=9999, needDay=9999},
	{id=236, systemName="玩法", btnPath="KLUISystemTopPanel/move_root/left/systemContainer/systemMenu/Btn_wanfa", needLevel=9999, needDay=9999},
	{id=237, systemName="幸运页签", btnPath="KLUIForgeGroupPanel/toggleLayout/luckyToggle", btnType=2, needLevel=1},
	{id=238, systemName="系统", needLevel=1},
	{id=239, systemName="幻化页签", btnPath="KLAppearGroupPanel/TogList/TogChange", btnType=2, needLevel=9999, needDay=9999},
}

local defaults = {btnPath="", btnType=1, needLevel=999, needDay=1, time="", continuous={}, taskOpenid={}, finishTaskid={}, endTime=0, firstCharge=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_system_switch) do
	setmetatable(v, mt)
end

return cfg_system_switch
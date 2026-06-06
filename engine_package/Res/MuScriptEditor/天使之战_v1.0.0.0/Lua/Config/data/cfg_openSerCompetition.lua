-- 此文件工具自动生成，不要修改
---@class cfg_openSerCompetition_column
---唯一id
---@field id number @活动id column=1 A
---1等级冲刺；2恶魔效率；3活跃收集；4二连击等级；5强化等级；6追加等级；7勇气试炼；8套装冲榜；9变身；10大天使装备
---@field type number @活动类型 column=2 B
---@field name string @活动名称 column=3 C
---配置condition条件集
---@field activityCondition string @活动开启条件 column=4 D
---配置condition条件集
---@field showCondition string @页签显示条件 column=5 E
---引用cfg_openSerCompetition_rank表rankGroup字段
---@field rankGroup number @竞技排行组 column=6 F
---引用cfg_openSerCompetition_challenge表challengeGroup字段
---@field challengeGroup number @个人挑战组 column=7 G
---配置礼包id，格式：根职业id#礼包id#礼包id|根职业id#礼包id#礼包id
---@field gift IntListList @特惠礼包 column=8 H
---可以获得奖励的上榜人数
---@field rankNumber number @上榜人数 column=9 I
---不满足条件无法参与排行
---@field rankLimitData number @最低上榜条件 column=10 J
---排行奖励开服第几天的0点进行结算（开服天数）
---@field rankSettlementTime number @排行结算时间 column=11 K
---个人挑战限时奖励在开服第几天的0点失效（开服天数）
---@field challengeLimitTime number @限时奖励到期时间 column=12 L
---格式：我的数据标题文本#界面底部提示信息
---@field desc StringList @竞技排行底部描述 column=13 M
---transfer#传送ID#X坐标#Y坐标
---未填坐标则传送到该地图的默认传送点
---传送ID参考mapMove表id
---
---transferNPC#NPCID
---传送到NPC位置，并交互
---NPCID参考npc_list表ID
---
---moveTo#传送ID#X坐标#Y坐标
---寻路，并将坐标设为主动目标
---传送ID参考mapMove表id
---
---moveToNPC#NPCID
---寻路至该NPC位置，并交互
---NPCID参考npc_list表ID
---
---openUI#UI名#[0,1] 0=不关闭界面 1=关闭界面   任务界面专用
---
---openUIpanel#UI名#[0,1]#参数  0=不关闭界面 1=关闭界面  参数为子页签所需要锁定的参数名（可以不填）  通用（任务界面+每日目标）
---
---moveToRandom#传送ID#X1坐标#Y1坐标#X2坐标#Y2坐标#X3坐标#Y3坐标
---寻路，并将多个坐标随机选择一个作为设为主动目标
---传送ID参考mapMove表id
---
---transferRandom#传送ID#X1坐标#Y1坐标#X2坐标#Y2坐标#X3坐标#Y3坐标
---从多个坐标中，随机选择一个坐标进行传送，直接传到该坐标位置
---传送ID参考mapMove表id
---@field instruction StringList @快捷指令 column=14 N
---页签显示顺序,数字越小，顺序越靠前
---@field order number @页签排序 column=15 O
---个人挑战结束不能再达成的时间，也是个人挑战中未领取的奖励补发的时间（开服第几天0点）
---@field supplementReward number @个人挑战结束时间 column=16 P

local local_instruction = {
    instruction_1={"openUIPanel","dev/outui/DailyGoal/Panel/KLDailyGoalMain/KLDailyGoalMainPanel","1"},
    instruction_2={"openUIPanel","dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel","1"},

}

local cfg_openSerCompetition =
{
	{id=2, type=2, name="恶魔效率", rankGroup=2, challengeGroup=2, rankLimitData=900000, rankSettlementTime=4, challengeLimitTime=4, order=4},
	{id=3, type=3, name="活跃收集", activityCondition="901#1&903#10", rankGroup=3, challengeGroup=3, gift={{1,3001,3002,3003,3004,3005,3006,3007},{2,3001,3002,3003,3004,3005,3006,3007},{3,3001,3002,3003,3004,3005,3006,3007}}, rankLimitData=84, rankSettlementTime=6, challengeLimitTime=6, desc={"我的活跃","完成日常活动获得活跃度","当前活跃"}, order=3},
	{id=4, type=4, name="连击大师", activityCondition="901#1&903#10", rankGroup=4, challengeGroup=4, gift={{1,4001,4002,4003,4004,4005,4006,4007},{2,4001,4002,4003,4004,4005,4006,4007},{3,4001,4002,4003,4004,4005,4006,4007}}, rankLimitData=5, rankSettlementTime=4, challengeLimitTime=4, desc={"我的连击等级","升级龙魂连击","当前等级"}, instruction={"openUIPanel","dev/outui/DragonSoulCombo/Panel/KLDragonSoulCombo/KLDragonSoulComboPanel","1"}, order=2},
	{id=5, type=5, name="强化大师", activityCondition="901#1&903#10", rankGroup=5, challengeGroup=5, gift={{1,5001,5002,5003,5004,5005,5006,5007},{2,5001,5002,5003,5004,5005,5006,5007},{3,5001,5002,5003,5004,5005,5006,5007}}, rankLimitData=84, rankSettlementTime=3, challengeLimitTime=3, desc={"我的强化等级","强化装备提升强化等级","当前等级"}, instruction=local_instruction.instruction_2, order=1},
	{id=6, type=6, name="追加大师", activityCondition="901#3&903#10", rankGroup=6, challengeGroup=6, gift={{1,6001,6002,6003,6004,6005,6006,6007},{2,6001,6002,6003,6004,6005,6006,6007},{3,6001,6002,6003,6004,6005,6006,6007}}, rankLimitData=39, rankSettlementTime=6, challengeLimitTime=6, desc={"我的追加等级","追加装备提升追加等级","当前等级"}, instruction=local_instruction.instruction_2, order=7},
	{id=7, type=7, name="勇气试炼", rankGroup=7, challengeGroup=7, gift={{1,7001,7002,7003,7004,7005,7006,7007},{2,7001,7002,7003,7004,7005,7006,7007},{3,7001,7002,7003,7004,7005,7006,7007}}, rankLimitData=25, rankSettlementTime=8, challengeLimitTime=12, desc={"我的层数","通关勇气试炼到达更高层数","当前层数"}, instruction={""}, order=6},
	{id=8, type=8, name="套装收集", rankGroup=8, challengeGroup=8, gift={{1,8001,8002,8003,8004,8005,8006,8007},{2,8001,8002,8003,8004,8005,8006,8007},{3,8001,8002,8003,8004,8005,8006,8007}}, rankLimitData=45, rankSettlementTime=7, challengeLimitTime=7, desc={"我的套装阶数","穿戴更高级套装装备","当前阶数"}, instruction={"openUIPanel","dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel","1"}, order=5},
	{id=9, type=9, name="变身收集", activityCondition="901#5&903#10", rankGroup=9, challengeGroup=9, gift={{1,9001,9002,9003,9004,9005,9006,9007},{2,9001,9002,9003,9004,9005,9006,9007},{3,9001,9002,9003,9004,9005,9006,9007}}, rankLimitData=13000, rankSettlementTime=7, challengeLimitTime=7, desc={"我的评分","兑换变身卡牌提高变身评分","当前评分"}, instruction={"openUIPanel","dev/outui/ShapeShiftCard/Panel/KLShapeShiftCardMain/KLShapeShiftCardMainPanel","1","4"}, order=9},
	{id=10, type=10, name="大天使收集", activityCondition="901#3&903#10", rankGroup=10, challengeGroup=10, gift={{1,10001,10002,10003,10004,10005,10006,10007},{2,10001,10002,10003,10004,10005,10006,10007},{3,10001,10002,10003,10004,10005,10006,10007}}, rankLimitData=336, rankSettlementTime=5, challengeLimitTime=5, desc={"我的等级","穿戴更高级大天使装备","当前等级"}, instruction={"transferNPC","100404"}, order=8},
}

local defaults = {activityCondition="901#2&903#10", showCondition="901#1&903#10", gift={{1,2001,2002,2003,2004,2005,2006,2007},{2,2001,2002,2003,2004,2005,2006,2007},{3,2001,2002,2003,2004,2005,2006,2007}}, rankNumber=10, desc={"我的效率","前往恶魔广场提升效率","当前效率"}, instruction={"openUIPanel","dev/outui/DailyGoal/Panel/KLDailyGoalMain/KLDailyGoalMainPanel","1"}, supplementReward=11}
local mt = {__index = defaults}
for _, v in ipairs(cfg_openSerCompetition) do
	setmetatable(v, mt)
end

return cfg_openSerCompetition
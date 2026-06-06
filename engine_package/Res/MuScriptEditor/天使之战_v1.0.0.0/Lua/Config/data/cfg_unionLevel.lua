-- 此文件工具自动生成，不要修改
---@class cfg_unionLevel_column
---等级序号
---@field unionLevel number @等级 column=1 A
---升至下级的经验 最后一级不填经验
---@field unionExp number @等级 column=2 B
---战盟等级对应人数上限
---@field playerNumber number @人数 column=3 C
---单位：分钟
---@field abdicationTime number @盟主在位时间检测 column=4 D
---单位：分钟
---@field impeachment number @盟主被弹劾期持续时间 column=5 E
---单位：分钟
---@field campaign number @新盟主竞选持续时间 column=6 F
---格式：道具id#数量
---不配置=不需要消耗道具
---@field campaignCast IntList @弹劾消耗 column=7 G
---格式：condition条件及参数|condition条件及参数
---配置几条就有几条生效，不配置等于不需要条件检测
---@field campaignCondition string @弹劾条件 column=8 H
---格式：文字文字#文字文字
---配置多少个，显示多少行
---@field campaignText StringList @弹劾条件文字描述 column=9 I
---格式：道具id#数量
---不配置=不需要消耗道具
---@field cast IntList @盟主竞选消耗 column=10 J
---格式：condition条件及参数|condition条件及参数
---配置几条就有几条生效，不配置等于不需要条件检测
---@field electionConditions string @盟主竞选条件 column=11 K
---参与竞选需要满足：加入战盟大于等于x天数
---@field electionTime number @盟主竞选条件2 column=12 L
---格式：文字文字#文字文字
---配置多少个，显示多少行
---@field text StringList @盟主竞选条件文字描述 column=13 M
---战盟赐福时，玩家可选择的最高转数
---@field gardBless number @战盟赐福转数上限 column=14 N
---工资等级-升级条件-工资奖励顺序一一对应，若缺一个则对应的都不显示
---@field level IntList @工资等级 column=15 O
---格式：每周内，每个工资等级在战盟内需获得多少声望
---格式：工资等级#声望数量|工资等级#声望数量
---@field condition IntListList @升级条件 column=16 P
---格式：工资等级#领取时获得的道具id#修正id#数量|工资等级#领取时获得的道具id#修正id#数量
---修正id=给的道具是装备时 填写修正表的id  是给的普通道具则填0
---@field reward IntListList @工资奖励 column=17 Q
---格式：保底人数#每周每人保底贡献值
---@field bottom IntList @工资解锁保底参数 column=18 R
---格式：道具id#数量
---不配置=不需要消耗道具
---@field replaceCast IntList @取代消耗 column=19 S
---格式：condition条件及参数|condition条件及参数
---配置几条就有几条生效，不配置等于不需要条件检测
---@field replaceConditions string @盟主取代条件 column=20 T
---格式：文字文字#文字文字
---配置多少个，显示多少行
---@field replaceText StringList @盟主取代条件文字描述 column=21 U
---单位：分钟
---@field continuousOfflineTime number @盟主多久没上线可被取代 column=22 V
---单位：分钟
---@field replaceTime number @盟主取代持续时间 column=23 W
---给竞选盟主的进行投票时，一票需要消耗的货币数量
---@field voteCast IntList @盟主竞选投票消耗 column=24 X
---弹劾盟主时，进行投票的消耗
---@field campaignVoteCast IntList @盟主弹劾投票消耗 column=25 Y

local local_campaignCast = {
    campaignCast_1={10040001,500},

}

local local_campaignText = {
    campaignText_1={"加入战盟时间超过<color=%s>12小时</color>"},

}

local local_cast = {
    cast_1={10010002,20000},

}

local local_text = {
    text_1={"等级达到<color=%s>100</color>"},

}

local local_level = {
    level_1={1,2,3,4,5,6},
    level_2={1,2,3,4},

}

local local_condition = {
    condition_1={{1,100},{2,300},{3,450},{4,650},{5,700},{6,880}},

}

local local_reward = {
    reward_1={{1,10950001,0,100},{2,10950001,0,200},{3,10950001,0,300},{4,10950001,0,400},{5,10950001,0,500},{6,10950001,0,600}},

}

local local_bottom = {
    bottom_1={1,100},
    bottom_2={2,101},
    bottom_3={3,102},

}

local local_replaceCast = {
    replaceCast_1={10010002,2000},

}

local local_replaceText = {
    replaceText_1={"等级达到<color=%s>150</color>"},

}

local local_voteCast = {
    voteCast_1={10010002,10000},

}

local local_campaignVoteCast = {
    campaignVoteCast_1={10010002,10000},

}

local cfg_unionLevel =
{
	{unionLevel=1, unionExp=1750, playerNumber=30, gardBless=1, bottom=local_bottom.bottom_1},
	{unionLevel=2, unionExp=2000, playerNumber=30, gardBless=2, level=local_level.level_2},
	{unionLevel=3, unionExp=3000, playerNumber=30, gardBless=3, bottom=local_bottom.bottom_3},
	{unionLevel=4, unionExp=4000, playerNumber=30, gardBless=1, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=5, unionExp=6000, playerNumber=30, gardBless=2},
	{unionLevel=6, unionExp=9000, playerNumber=100, gardBless=3, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=7, unionExp=12000, playerNumber=100, gardBless=1, bottom=local_bottom.bottom_1},
	{unionLevel=8, unionExp=17000, playerNumber=100, gardBless=2, level=local_level.level_2},
	{unionLevel=9, unionExp=20000, playerNumber=100, gardBless=3, bottom=local_bottom.bottom_3},
	{unionLevel=10, unionExp=20000, playerNumber=100, gardBless=1, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=11, unionExp=20000, playerNumber=100, gardBless=2},
	{unionLevel=12, unionExp=20000, playerNumber=100, gardBless=3, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=13, unionExp=20000, playerNumber=100, gardBless=1, bottom=local_bottom.bottom_1},
	{unionLevel=14, unionExp=20000, playerNumber=100, gardBless=2, level=local_level.level_2},
	{unionLevel=15, unionExp=40000, playerNumber=100, gardBless=3, bottom=local_bottom.bottom_3},
	{unionLevel=16, unionExp=40000, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=17, unionExp=40000, playerNumber=100},
	{unionLevel=18, unionExp=40000, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=19, unionExp=60000, playerNumber=100, bottom=local_bottom.bottom_1},
	{unionLevel=20, unionExp=60000, playerNumber=100, level=local_level.level_2},
	{unionLevel=21, unionExp=60000, playerNumber=100, bottom=local_bottom.bottom_3},
	{unionLevel=22, unionExp=60000, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=23, unionExp=60000, playerNumber=100},
	{unionLevel=24, unionExp=60000, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=25, unionExp=80000, playerNumber=100, bottom=local_bottom.bottom_1},
	{unionLevel=26, unionExp=80000, playerNumber=100, level=local_level.level_2},
	{unionLevel=27, unionExp=80000, playerNumber=100, bottom=local_bottom.bottom_3},
	{unionLevel=28, unionExp=80000, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=29, unionExp=80000, playerNumber=100},
	{unionLevel=30, unionExp=100000, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=31, unionExp=100000, playerNumber=100, bottom=local_bottom.bottom_1},
	{unionLevel=32, unionExp=100000, playerNumber=100, level=local_level.level_2},
	{unionLevel=33, unionExp=100000, playerNumber=100, bottom=local_bottom.bottom_3},
	{unionLevel=34, unionExp=100000, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=35, playerNumber=100},
	{unionLevel=36, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=37, playerNumber=100, bottom=local_bottom.bottom_1},
	{unionLevel=38, playerNumber=100, level=local_level.level_2},
	{unionLevel=39, playerNumber=100, bottom=local_bottom.bottom_3},
	{unionLevel=40, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=41, playerNumber=100},
	{unionLevel=42, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=43, playerNumber=100},
	{unionLevel=44, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=45, playerNumber=100, bottom=local_bottom.bottom_1},
	{unionLevel=46, playerNumber=100, level=local_level.level_2},
	{unionLevel=47, playerNumber=100, bottom=local_bottom.bottom_3},
	{unionLevel=48, playerNumber=100, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=49, playerNumber=100, level=local_level.level_2},
	{unionLevel=50, bottom=local_bottom.bottom_3},
	{unionLevel=51, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=52},
	{unionLevel=53, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=54, bottom=local_bottom.bottom_1},
	{unionLevel=55, level=local_level.level_2},
	{unionLevel=56, bottom=local_bottom.bottom_1},
	{unionLevel=57, level=local_level.level_2},
	{unionLevel=58, bottom=local_bottom.bottom_3},
	{unionLevel=59, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=60},
	{unionLevel=61, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=62, bottom=local_bottom.bottom_1},
	{unionLevel=63, level=local_level.level_2},
	{unionLevel=64, bottom=local_bottom.bottom_3},
	{unionLevel=65, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=66},
	{unionLevel=67, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=68, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=69},
	{unionLevel=70, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=71, bottom=local_bottom.bottom_1},
	{unionLevel=72, level=local_level.level_2},
	{unionLevel=73, bottom=local_bottom.bottom_3},
	{unionLevel=74, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=75, level=local_level.level_2},
	{unionLevel=76, bottom=local_bottom.bottom_3},
	{unionLevel=77, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=78},
	{unionLevel=79, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=80},
	{unionLevel=81, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=82, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=83, level=local_level.level_2},
	{unionLevel=84, bottom=local_bottom.bottom_3},
	{unionLevel=85, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=86},
	{unionLevel=87, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=88, bottom=local_bottom.bottom_1},
	{unionLevel=89, level=local_level.level_2},
	{unionLevel=90, level=local_level.level_2, bottom=local_bottom.bottom_3},
	{unionLevel=91, bottom=local_bottom.bottom_1},
	{unionLevel=92, level=local_level.level_2},
	{unionLevel=93, bottom=local_bottom.bottom_3},
	{unionLevel=94, level=local_level.level_2},
	{unionLevel=95, bottom=local_bottom.bottom_3},
	{unionLevel=96, level=local_level.level_2, bottom=local_bottom.bottom_1},
	{unionLevel=97},
	{unionLevel=98, level=local_level.level_2},
	{unionLevel=99, bottom=local_bottom.bottom_3},
	{unionLevel=100, level=local_level.level_2, bottom=local_bottom.bottom_1},
}

local defaults = {unionExp=120000, playerNumber=200, abdicationTime=4320, impeachment=1440, campaign=1440, campaignCast={10040001,500}, campaignCondition="2501#720", campaignText={"加入战盟时间超过<color=%s>12小时</color>"}, cast={10010002,20000}, electionConditions="101#100", electionTime=0, text={"等级达到<color=%s>100</color>"}, gardBless=5, level={1,2,3,4,5,6}, condition={{1,100},{2,300},{3,450},{4,650},{5,700},{6,880}}, reward={{1,10950001,0,100},{2,10950001,0,200},{3,10950001,0,300},{4,10950001,0,400},{5,10950001,0,500},{6,10950001,0,600}}, bottom={2,101}, replaceCast={10010002,2000}, replaceConditions="101#150", replaceText={"等级达到<color=%s>150</color>"}, continuousOfflineTime=1440, replaceTime=1440, voteCast={10010002,10000}, campaignVoteCast={10010002,10000}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_unionLevel) do
	setmetatable(v, mt)
end

return cfg_unionLevel
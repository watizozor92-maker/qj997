-- 此文件工具自动生成，不要修改
---@class cfg_newarea_ranking_column
---10：BOSS首杀
---20：其他竞技类活动
---30：商业化活动
---@field id number @开服竞技活动ID column=1 A
---类型——对应开服天数
---1：BOSS首杀（引援cfg_newarea_rankingboss）
---2：其他竞技类活动
---3：商业化活动
---@field type number @开服竞技活动类型 column=2 B
---@field name string @活动名称 column=3 C
---涉及礼包的活动需要填写关联礼包类型的id（引援cfg_recharge/Type）
---@field rechargeType number @关联礼包类型 column=4 D
---客户端控制页签是否开启
---@field condition string @开启条件 column=5 E
---活动显示激活的时间
---
---开服天数(该天0点）
---@field startTime IntList @开启时间 column=6 F
---结束时间
---
---开服天数(该天0点）
---@field endTime IntList @活动结束时间 column=7 G
---活动结束，界面继续保留到的时间点
---
---开服天数(该天0点）
---@field uiTime IntList @界面关闭时间 column=8 H
---关联cfg_newarea_rankingreward表group字段
---【BOSS首杀无此项.商业化活动无此项】
---@field index number @全服挑战组编号 column=9 I
---关联cfg_newarea_personalrewardtype字段
---【BOSS首杀无此项，商业化活动无此项】
---@field subtype number @个人挑战组编号 column=10 J
---关联
---cfg_newarea_rankingboss表group字段
---【其他竞技类活动无此项，商业化活动无此项】
---@field bossGroup number @BOSS挑战组编号 column=11 K
---开服活动中的排序
---按照从小到达，从上到下排序
---@field sort number @页签排序 column=12 L
---关联cfg_obtain
---@field jump number @去提升按钮绑定跳转 column=13 M

local local_startTime = {
    startTime_1={1},

}

local local_endTime = {
    endTime_1={8},

}

local local_uiTime = {
    uiTime_1={8},

}

local cfg_newarea_ranking =
{
	{id=10001, type=1, name="BOSS首杀", condition="checkLevel>=27", index=0, subtype=0, bossGroup=10001, sort=1},
	{id=10002, type=1, name="黄金怪首杀", index=0, subtype=0, bossGroup=10002, sort=2},
	{id=20001, name="强化冲榜", index=20001, subtype=20001, sort=3},
	{id=20002, name="追加冲榜", index=20002, subtype=20002, sort=4},
	{id=20003, name="装备首爆", index=20003, subtype=20003, sort=5},
	{id=20004, name="等级竞技", index=20004, subtype=20004, sort=6},
	{id=20005, name="卓越竞技", index=20005, subtype=20005, sort=7},
	{id=20006, name="首饰竞技", index=20006, subtype=20006, sort=8},
}

local defaults = {type=2, rechargeType=0, condition="checkLevel>=1", startTime={1}, endTime={8}, uiTime={8}, bossGroup=0, jump=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_newarea_ranking) do
	setmetatable(v, mt)
end

return cfg_newarea_ranking
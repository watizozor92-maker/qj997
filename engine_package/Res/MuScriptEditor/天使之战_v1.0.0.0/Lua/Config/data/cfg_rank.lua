-- 此文件工具自动生成，不要修改
---@class cfg_rank_column
---@field id number @id column=1 A
---1：本服榜
---2：跨服榜
---
---@field roottype number @排行榜根类型 column=2 B
---数字越小，排的越靠前
---@field oneId number @子页签排序 column=3 C
---1.等级排行榜
---2.勇气试炼排行榜
---3.战力排行榜
---4.圣杯榜
---@field type number @排行榜子类型 column=4 D
---0代表全职业
---其余为cfg_career表根职业
---当type=4时，此处填的为圣杯阶数
---@field career number @职业 column=5 E
---@field name string @名称 column=6 F
---@field careerName string @子页签名字 column=7 G
---第几名可以获得奖励
---@field rewardRule IntList @奖励 column=8 H
---@field reward IntListList @奖励 column=9 I
---空不显示
---@field rewardText string @奖励说明 column=10 J
---0：不生效
---1、生效
---@field effective number @是否生效 column=11 K
---只给type字段里面，同一个数字类型的唯一id ，都配置同样的条件才会生效
---配置condition表的条件，当条件输出为 是 时， 显示页签 否则隐藏
---不配置的话 = 一直显示
---@field condition string @排行榜显示条件 column=12 L
---1.等级排行榜上榜条件是等级
---2.勇气试炼排行榜上榜条件是勇气试炼层数
---@field rankCondition string @排行榜上榜条件 column=13 M

local local_rewardRule = {
    rewardRule_1={1,2,3},

}

local local_reward = {
    reward_1={},

}

local cfg_rank =
{
	{id=1, oneId=1, career=0, careerName="综合"},
	{id=2, oneId=2, career=1, careerName="剑士"},
	{id=3, oneId=3, career=2, careerName="魔法师"},
	{id=4, oneId=4, career=3, careerName="弓箭手"},
	{id=5, oneId=5, career=4, careerName="魔剑士"},
	{id=6, oneId=6, career=5, careerName="圣导师"},
	{id=7, oneId=7, career=6, careerName="召唤师"},
	{id=8, oneId=8, career=7, careerName="光明法师"},
	{id=22, roottype=2, oneId=1, career=0, careerName="综合", condition="checkLevel>=999999"},
	{id=23, roottype=2, oneId=2, career=1, careerName="剑士", condition="checkLevel>=999999"},
	{id=24, roottype=2, oneId=3, career=2, careerName="魔法师", condition="checkLevel>=999999"},
	{id=25, roottype=2, oneId=4, career=3, careerName="弓箭手", condition="checkLevel>=999999"},
	{id=26, roottype=2, oneId=5, career=4, careerName="魔剑士", condition="checkLevel>=999999"},
	{id=27, roottype=2, oneId=6, career=5, careerName="圣导师", condition="checkLevel>=999999"},
	{id=28, roottype=2, oneId=7, career=6, careerName="召唤师", condition="checkLevel>=999999"},
}

local defaults = {roottype=1, type=1, name="等级榜", rewardRule={1,2,3}, reward={}, rewardText="", effective=1, condition="checkLevel>=1", rankCondition="50"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_rank) do
	setmetatable(v, mt)
end

return cfg_rank
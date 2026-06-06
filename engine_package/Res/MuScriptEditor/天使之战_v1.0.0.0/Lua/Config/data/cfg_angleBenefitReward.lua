-- 此文件工具自动生成，不要修改
---@class cfg_angleBenefitReward_column
---唯一id，也是道具顺序
---@field id number @id column=1 A
---格式：根职业id#道具id#道具数量|根职业id#道具id#道具数量
---@field reward IntListList @奖励道具 column=2 B
---领取奖励需要的积分，格式：积分道具id#积分道具数量
---@field rewardPoint IntList @奖励所需积分 column=3 C
---全服可领取奖励数量
---@field limitNum number @全服限量 column=4 D
---奖励可领取的限定时长（过了开服第几天后结束）
---@field limitTime number @限定时间 column=5 E
---购买奖励消耗道具,格式：道具id#道具数量
---@field payConsume IntList @购买消耗 column=6 F

local local_payConsume = {
    payConsume_1={10040001,500},

}

local cfg_angleBenefitReward =
{
	{id=1, rewardPoint={10210001,200}, limitTime=2},
	{id=2, reward={{1,20410531,1},{2,20420531,1},{3,20430531,1}}, rewardPoint={10210001,400}, limitTime=5},
	{id=3, reward={{1,20610531,1},{2,20620531,1},{3,20630531,1}}, rewardPoint={10210001,650}, limitTime=7},
	{id=4, reward={{1,20710531,1},{2,20720531,1},{3,20730531,1}}, rewardPoint={10210001,900}, limitTime=10},
}

local defaults = {reward={{1,20310531,1},{2,20120531,1},{3,20240531,1}}, limitNum=5, payConsume={10040001,500}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_angleBenefitReward) do
	setmetatable(v, mt)
end

return cfg_angleBenefitReward
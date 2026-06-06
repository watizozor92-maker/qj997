-- 此文件工具自动生成，不要修改
---@class cfg_turntable_column
---唯一id，每个唯一id对应一个抽奖活动
---@field id number @id column=1 A
---对应cfg_OperateActivity_all表mainGroup字段子活动组配置
---@field mainGroup number @所属活动组 column=2 B
---策划看
---[[客户端不使用]]@field beizhu string @备注 column=3 C
---使用的是哪个奖池
---对应cfg_turntable_reward的group字段配置
---@field reward number @使用奖池 column=4 D
---单次抽取消耗
---消耗道具#消耗数量
---
---@field oneCost IntList @单次抽取消耗 column=5 E
---多次抽取消耗
---抽取次数#消耗道具#消耗数量
---@field manyCost IntList @多次抽取消耗 column=6 F
---免费抽取次数刷新间隔时间，每次次数用完后开始重新倒计时
---间隔时长（分钟）
---@field free number @免费次数时长 column=7 G

local local_oneCost = {
    oneCost_1={10040001,50},

}

local local_manyCost = {
    manyCost_1={10,10040001,450},

}

local cfg_turntable =
{
	{id=101, mainGroup=3, reward=1},
	{id=201, mainGroup=5, reward=2},
	{id=301, mainGroup=7, reward=3},
	{id=401, mainGroup=9, reward=4},
	{id=501, mainGroup=11, reward=5},
	{id=601, mainGroup=13, reward=6},
}

local defaults = {oneCost={10040001,50}, manyCost={10,10040001,450}, free=480}
local mt = {__index = defaults}
for _, v in ipairs(cfg_turntable) do
	setmetatable(v, mt)
end

return cfg_turntable
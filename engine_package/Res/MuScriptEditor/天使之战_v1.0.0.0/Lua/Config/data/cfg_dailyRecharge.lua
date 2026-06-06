-- 此文件工具自动生成，不要修改
---@class cfg_dailyRecharge_column
---唯一礼包id
---@field id number @id column=1 A
---礼包名称
---@field name string @礼包名称 column=2 B
---礼包条件
---@field condition string @条件 column=3 C
---展示该条返利需要消费多少元
---@field showCondition string @展示条件 column=4 D
---目标描述
---@field taskDes string @目标描述 column=5 E
---消费满多少元可以领取
---@field goal number @消费目标 column=6 F
---礼包给的奖励，格式：道具id#数量|道具id#数量
---@field reward IntListList @道具 column=7 G
---奖励邮件id
---[[客户端不使用]]@field mail number @邮件id column=8 H
local cfg_dailyRecharge =
{
	{id=1, name="免费礼包", taskDes="免费领取", goal=1},
	{id=2, name="6元", taskDes="今日充值6元", goal=6, reward={{50030001,2},{50030002,3},{10020001,2880}}},
	{id=3, name="30元", taskDes="今日充值30元", goal=30, reward={{10040001,480},{50030003,1},{10020001,3880}}},
	{id=4, name="98元", taskDes="今日充值98元", goal=98, reward={{10040001,1080},{50030003,3},{10020001,8880}}},
	{id=5, name="328元", taskDes="今日充值328元", goal=328, reward={{10040001,1980},{50030005,1},{10020001,12880}}},
	{id=6, name="648元", taskDes="今日充值648元", goal=648, reward={{10040001,3280},{50030005,2},{10020001,16880}}},
}

local defaults = {condition="901#9999", showCondition="", reward={{50030001,1},{50030002,1},{10020001,988}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_dailyRecharge) do
	setmetatable(v, mt)
end

return cfg_dailyRecharge
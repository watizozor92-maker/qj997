-- 此文件工具自动生成，不要修改
---@class cfg_zhuoyuezhuangLv20_column
---唯一id
---[[客户端不使用]]@field id number @id column=1 A
---1=统计概率，从所有道具中抽取1个（按权重）
---2=独立概率，每个道具单独判断概率
---*每张表只允许使用1个类型
---[[客户端不使用]]@field type number @掉落类型 column=2 B
---道具id
---@field item number @道具id column=3 C
---策划备注
---[[客户端不使用]]@field beizhu string @ column=4 D
---数量区间，从中随机数量
---x#y，左右闭区间
---@field num string @数量 column=5 E
---掉落类型为1时，此处为：掉落次数#权重
---掉落类型为2时，此处为：掉落次数#概率（万分比）
---掉落次数填本次掉落之前已经掉落的次数，例如首次掉落，之前没掉过，这里就填0
---[[客户端不使用]]@field probability string @概率 column=6 F
---限制职业
---只有对应职业才会掉落
---不填不做限制
---格式：所属职业#职业等级|所属职业#职业等级
---[[客户端不使用]]@field career string @职业 column=7 G
---限制等级
---只有角色在对应等级区间内才会掉
---x#y，左右闭区间
---999999标识无限大
---不填不做限制
---[[客户端不使用]]@field level string @等级 column=8 H
local cfg_zhuoyuezhuangLv20 =
{
	{item=20122021},
	{item=20132021},
	{item=20142021},
	{item=20222021},
	{item=20232021},
	{item=20242021},
	{item=20312021},
	{item=20412021},
	{item=20422021},
	{item=20432021},
	{item=20442021},
	{item=20612021},
	{item=20622021},
	{item=20632021},
	{item=20642021},
	{item=20712021},
	{item=20722021},
	{item=20732021},
	{item=20742021},
	{item=20812021},
	{item=20822021},
	{item=20832021},
	{item=20842021},
	{item=20912021},
	{item=20922021},
	{item=20932021},
	{item=20942021},
}

local defaults = {num="1#1"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_zhuoyuezhuangLv20) do
	setmetatable(v, mt)
end

return cfg_zhuoyuezhuangLv20
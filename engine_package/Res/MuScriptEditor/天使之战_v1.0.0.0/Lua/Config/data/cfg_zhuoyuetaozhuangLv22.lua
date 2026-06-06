-- 此文件工具自动生成，不要修改
---@class cfg_zhuoyuetaozhuangLv22_column
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
local cfg_zhuoyuetaozhuangLv22 =
{
	{item=20122231},
	{item=20132231},
	{item=20142231},
	{item=20222231},
	{item=20232231},
	{item=20242231},
	{item=20312231},
	{item=20412231},
	{item=20422231},
	{item=20432231},
	{item=20442231},
	{item=20612231},
	{item=20622231},
	{item=20632231},
	{item=20642231},
	{item=20712231},
	{item=20722231},
	{item=20732231},
	{item=20742231},
	{item=20812231},
	{item=20822231},
	{item=20832231},
	{item=20842231},
	{item=20912231},
	{item=20922231},
	{item=20932231},
	{item=20942231},
}

local defaults = {num="1#1"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_zhuoyuetaozhuangLv22) do
	setmetatable(v, mt)
end

return cfg_zhuoyuetaozhuangLv22
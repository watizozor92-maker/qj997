-- 此文件工具自动生成，不要修改
---@class cfg_zhuoyuetaozhuangLv15_column
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
local cfg_zhuoyuetaozhuangLv15 =
{
	{item=20121531},
	{item=20131531},
	{item=20141531},
	{item=20221531},
	{item=20231531},
	{item=20241531},
	{item=20311531},
	{item=20411531},
	{item=20421531},
	{item=20431531},
	{item=20441531},
	{item=20611531},
	{item=20621531},
	{item=20631531},
	{item=20641531},
	{item=20711531},
	{item=20721531},
	{item=20731531},
	{item=20741531},
	{item=20811531},
	{item=20821531},
	{item=20831531},
	{item=20841531},
	{item=20911531},
	{item=20921531},
	{item=20931531},
	{item=20941531},
}

local defaults = {num="1#1"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_zhuoyuetaozhuangLv15) do
	setmetatable(v, mt)
end

return cfg_zhuoyuetaozhuangLv15
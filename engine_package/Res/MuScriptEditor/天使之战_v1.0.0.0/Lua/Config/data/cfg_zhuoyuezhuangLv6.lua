-- 此文件工具自动生成，不要修改
---@class cfg_zhuoyuezhuangLv6_column
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
local cfg_zhuoyuezhuangLv6 =
{
	{item=20120621},
	{item=20130621},
	{item=20140621},
	{item=20220621},
	{item=20230621},
	{item=20240621},
	{item=20310621},
	{item=20410621},
	{item=20420621},
	{item=20430621},
	{item=20440621},
	{item=20610621},
	{item=20620621},
	{item=20630621},
	{item=20640621},
	{item=20710621},
	{item=20720621},
	{item=20730621},
	{item=20740621},
	{item=20810621},
	{item=20820621},
	{item=20830621},
	{item=20840621},
	{item=20910621},
	{item=20920621},
	{item=20930621},
	{item=20940621},
}

local defaults = {num="1#1"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_zhuoyuezhuangLv6) do
	setmetatable(v, mt)
end

return cfg_zhuoyuezhuangLv6
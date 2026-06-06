-- 此文件工具自动生成，不要修改
---@class cfg_huolonglinpian_column
---唯一id
---[[客户端不使用]]@field id number @id column=1 A
---1=统计概率，从所有道具中抽取1个（按权重）
---2=独立概率，每个道具单独判断概率
---*每张表只允许使用1个类型
---[[客户端不使用]]@field type number @掉落类型 column=2 B
---策划备注
---[[客户端不使用]]@field beizhu string @ column=3 C
---道具id
---@field item number @道具id column=4 D
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
local cfg_huolonglinpian =
{
	{num="400000#400000"},
	{num="1600000#1600000"},
	{num="3149622#3149622"},
	{num="5651417#5651417"},
	{num="11302834#11302834"},
	{num="22103982#22103982"},
	{num="37020522#37020522"},
	{num="55789113#55789113"},
	{num="84072965#84072965"},
	{num="126982320#126982320"},
	{num="166697191#166697191"},
	{num="199779527#199779527"},
	{num="245182914#245182914"},
	{num="299289836#299289836"},
	{num="339858558#339858558"},
	{num="384312335#384312335"},
	{num="432634856#432634856"},
	{num="476225098#476225098"},
	{num="514975424#514975424"},
}

local defaults = {item=10080001}
local mt = {__index = defaults}
for _, v in ipairs(cfg_huolonglinpian) do
	setmetatable(v, mt)
end

return cfg_huolonglinpian
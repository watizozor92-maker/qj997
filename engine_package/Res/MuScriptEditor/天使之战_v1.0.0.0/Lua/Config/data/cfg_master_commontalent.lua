-- 此文件工具自动生成，不要修改
---@class cfg_master_commontalent_column
---第1位：职业天赋1，技能天赋2，通用天赋3
---第23位：根职业
---第4位；行
---第56位：位
---
---@field id number @唯一id，天赋id column=1 A
---天赋名称
---@field name string @天赋名称 column=2 B
---默认职业归属
---引援career职业表
---格式：所属根职业
---0为全职业
---多职业之间用#分割
---@field career IntList @所属职业 column=3 C
---天赋处于当前天赋系的哪一行
---@field row number @天赋所在行 column=4 D
---天赋处于当前行的哪一位
---@field arrange number @天赋所在列数 column=5 E
---天赋最低最高等级
---格式：最小等级#最大等级
---@field minMaxLevel IntList @天赋最低最高等级 column=6 F
---配置资源路径
---@field icon string @天赋图标 column=7 G

local local_career = {
    career_1={0},

}

local local_minMaxLevel = {
    minMaxLevel_1={0,2},

}

local cfg_master_commontalent =
{
	{id=300101, name="对剑士伤害提高", arrange=1, icon="3001"},
	{id=300102, name="对法师伤害提高", arrange=2, icon="3002"},
	{id=300103, name="对弓箭手伤害提高", arrange=3, icon="3003"},
	{id=300104, name="卓越一击伤害提高", arrange=4, icon="3007"},
	{id=300105, name="双倍攻击伤害提高", arrange=5, icon="3008"},
	{id=300106, name="幸运一击伤害提高", arrange=6, icon="1007"},
	{id=300107, name="无视防御概率提高", arrange=7, icon="3010"},
	{id=300201, name="受到剑士伤害降低", row=2, arrange=1, icon="3004"},
	{id=300202, name="受到法师伤害降低", row=2, arrange=2, icon="3005"},
	{id=300203, name="受到弓箭手伤害降低", row=2, arrange=3, icon="3006"},
	{id=300204, name="降低受到卓越一击的概率", row=2, arrange=4, icon="3011"},
	{id=300205, name="降低受到双倍攻击的概率", row=2, arrange=5, icon="3012"},
	{id=300206, name="降低受到幸运一击的概率", row=2, arrange=6, icon="3013"},
	{id=300207, name="降低受到无视防御的概率", row=2, arrange=7, icon="3009"},
}

local defaults = {career={0}, row=1, minMaxLevel={0,2}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_master_commontalent) do
	setmetatable(v, mt)
end

return cfg_master_commontalent
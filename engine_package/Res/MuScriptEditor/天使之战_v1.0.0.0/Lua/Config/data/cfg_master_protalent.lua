-- 此文件工具自动生成，不要修改
---@class cfg_master_protalent_column
---第1位：系
---第2位：层
---第3位：位
---@field id number @唯一id，天赋id column=1 A
---天赋名称
---@field name string @天赋名称 column=2 B
---天赋类型
---1天赋；2技能
---@field type number @天赋类型 column=3 C
---默认职业归属
---引援career职业表
---格式：所属根职业
---0为全职业
---多职业之间用#分割
---@field career IntList @所属职业 column=4 D
---天赋所的天赋系
---1-Valor
---2-Protection
---3-Wrath
---@field series number @所属天赋系 column=5 E
---天赋处于当前天赋系的哪一层
---@field tier number @天赋所在层 column=6 F
---天赋处于当前层的哪个位置
---@field place number @天赋所在位置 column=7 G
---天赋最低最高等级
---格式：最小等级#最大等级
---@field minMaxLevel IntList @天赋最低最高等级 column=8 H
---配置资源路径
---@field icon string @天赋图标 column=9 I
---引用cfg_skill表id
---@field skillId number @技能id column=10 J

local local_career = {
    career_1={},

}

local local_minMaxLevel = {
    minMaxLevel_1={0,20},

}

local cfg_master_protalent =
{
	{id=111, name="命中强化", tier=1, place=1, icon="11001"},
	{id=112, name="防御率强化", tier=1, icon="11002"},
	{id=121, name="破盾者", tier=2, place=1, icon="11003"},
	{id=122, name="AG恢复强化", tier=2, icon="11004"},
	{id=131, name="防御装备强化", tier=3, place=1, icon="11005"},
	{id=132, name="防御力强化", tier=3, icon="11006"},
	{id=141, name="体力强化", place=1, icon="11007"},
	{id=142, name="智力强化", icon="11008"},
	{id=143, name="敏捷强化", place=3, icon="11009"},
	{id=144, name="力量强化", place=4, icon="11010"},
	{id=145, name="三代翅膀攻击强化", place=5, icon="11011"},
	{id=146, name="三代翅膀防御强化", place=6, icon="11012"},
	{id=151, name="装备大师", tier=5, icon="11013"},
	{id=211, name="魔法力提升强化", series=2, tier=1, place=1, icon="11014"},
	{id=212, name="攻击力强化", series=2, tier=1, icon="11015"},
	{id=221, name="AG上限强化", series=2, tier=2, place=1, icon="11016"},
	{id=222, name="生命值强化", series=2, tier=2, icon="11017"},
	{id=231, name="SD上限强化", series=2, tier=3, place=1, icon="11018"},
	{id=232, name="生命力强化", series=2, tier=3, icon="11019"},
	{id=241, name="强化技能", series=2, place=1, icon="11020"},
	{id=242, name="减伤强化", series=2, icon="11021"},
	{id=243, name="吸收强化", series=2, place=3, icon="11022"},
	{id=251, name="噬血", series=2, tier=5, icon="11023"},
	{id=311, name="恢复强化", series=3, tier=1, place=1, icon="11024"},
	{id=312, name="魔法值恢复强化", series=3, tier=1, icon="11025"},
	{id=321, name="攻速强化Ⅰ", series=3, tier=2, place=1, icon="11026"},
	{id=322, name="SD值恢复", series=3, tier=2, icon="11027"},
	{id=331, name="攻速强化Ⅱ", series=3, tier=3, place=1, icon="11028"},
	{id=332, name="魔法值上限", series=3, tier=3, icon="11029"},
	{id=341, name="幸运一击强化", series=3, place=1, icon="11030"},
	{id=342, name="双倍概率强化", series=3, icon="11031"},
	{id=343, name="卓越一击强化", series=3, place=3, icon="11032"},
	{id=351, name="守护者", series=3, tier=5, icon="11033"},
}

local defaults = {type=1, career={}, series=1, tier=4, place=2, minMaxLevel={0,20}, skillId=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_master_protalent) do
	setmetatable(v, mt)
end

return cfg_master_protalent
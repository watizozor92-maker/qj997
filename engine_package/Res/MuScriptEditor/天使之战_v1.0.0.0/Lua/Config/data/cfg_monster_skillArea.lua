-- 此文件工具自动生成，不要修改
---@class cfg_monster_skillArea_column
---序号
---@field id number @id column=1 A
---怪物id，引用cfg_monster表id
---@field monster number @怪物 column=2 B
---技能id，引用cfg_skill表id
---@field skill number @技能 column=3 C
---区域显示的资源模型，填写资源名称；模型资源决定区域显示形状
---@field model string @区域模型 column=4 D
---显示区域颜色颜色，引用cfg_color表id
---@field color number @区域颜色 column=5 E
---备注说明
---@field notes string @备注 column=6 F
local cfg_monster_skillArea =
{
	{id=1, monster=1024, skill=2020002, notes="冰后暴风雪红色显示区域"},
	{id=2, monster=1052, skill=2020004, model="Eff_fang_hong", color=5, notes="海魔希特拉紫色显示区域"},
	{id=3, monster=1059, skill=2020009, notes="炽焰魔毁灭火焰"},
	{id=4, monster=1075, skill=2020012, notes="天魔菲尼克斯火海"},
	{id=5, monster=1088, skill=2020016, model="Eff_fang_hong", color=5, notes="咒怨魔王脉动冲击"},
	{id=6, monster=1095, skill=2020018, notes="冰霜巨蛛冰天雪地"},
	{id=7, monster=1009, skill=2020023, notes="火龙王火海"},
	{id=8, monster=1009, skill=2020027, model="Eff_fang_hong", color=5, notes="火龙王龙王怒火"},
	{id=9, monster=1066, skill=2020029, model="Eff_fang_hong", color=5, notes="丛林召唤者脉动冲击"},
	{id=10, monster=1060, skill=2020034, notes="魔王扎坎碎石降临"},
	{id=11, monster=1060, skill=2020037, notes="炼狱魔王炼狱降临"},
	{id=12, monster=1060, skill=2020038, notes="炼狱魔王碎石降临"},
	{id=13, monster=1047, skill=2020042, notes="美杜莎魅惑"},
	{id=14, monster=1129, skill=2020045, model="Eff_fang_hong", color=5, notes="魔王昆顿脉冲攻击"},
	{id=15, monster=1044, skill=2020049, notes="魔王巴洛克地狱召唤"},
}

local defaults = {model="Eff_yuan_hong", color=24}
local mt = {__index = defaults}
for _, v in ipairs(cfg_monster_skillArea) do
	setmetatable(v, mt)
end

return cfg_monster_skillArea
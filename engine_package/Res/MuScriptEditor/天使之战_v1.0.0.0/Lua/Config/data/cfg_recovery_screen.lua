-- 此文件工具自动生成，不要修改
---@class cfg_recovery_screen_column
---唯一序号
---@field id number @id column=1 A
---空为父页签
---子页签填父页签ID
---@field groupLevel number @父页签 column=2 B
---筛选名称
---@field screenName string @页签名 column=3 C
---3.职业
---5.强化等级
---6.追加等级
---7.幸运属性
---8.装备技能
---9.宝石类型
---11.无视装备提升
---@field type number @类型 column=4 D
---3.职业
---5.强化等级
---6.追加等级
---7.幸运属性
---8.装备技能
---9.宝石类型
---11.无视装备提升
---@field typeName string @类型名称 column=5 E
---@field strengthlevel number @强化等级 column=6 F
---@field appendlevel number @追加等级 column=7 G
---@field luncky IntListList @幸运属性 column=8 H
---@field skill number @装备技能 column=9 I
---宝石道具id
---@field gem number @宝石类型 column=10 J
---1：默认勾选
---0或空：不勾选
---@field DefaultTick number @父页签开启时的默认勾选 column=11 K
---装备阶数筛选，读rank
---@field rank number @阶数限制 column=12 L
---卓越词条数判断
---@field count number @卓越词条数限制 column=13 M
---职业筛选 读所属职业#职业等级|所属职业#职业等级
---@field career IntListList @职业限制 column=14 N

local local_luncky = {
    luncky_1={},

}

local local_career = {
    career_1={},

}

local cfg_recovery_screen =
{
	{id=1, screenName="+0", strengthlevel=0},
	{id=2, screenName="+1", strengthlevel=1},
	{id=3, screenName="+2", strengthlevel=2},
	{id=4, screenName="+3", strengthlevel=3},
	{id=5, screenName="+4", strengthlevel=4},
	{id=6, screenName="+5", strengthlevel=5},
	{id=7, screenName="+6", strengthlevel=6},
	{id=8, screenName="+7", strengthlevel=7},
	{id=9, screenName="+8", strengthlevel=8},
	{id=10, screenName="+9", strengthlevel=9},
	{id=11, screenName="+10", strengthlevel=10},
	{id=12, screenName="Z0", type=6, typeName="追加等级", appendlevel=0},
	{id=13, screenName="Z4", type=6, typeName="追加等级", appendlevel=1},
	{id=14, screenName="Z8", type=6, typeName="追加等级", appendlevel=2},
	{id=15, screenName="Z12", type=6, typeName="追加等级", appendlevel=3},
	{id=16, screenName="Z16", type=6, typeName="追加等级", appendlevel=4},
	{id=17, screenName="剑士", type=3, typeName="职业", career={{1,1},{1,2},{1,3},{1,4}}},
	{id=18, screenName="魔法师", type=3, typeName="职业", career={{2,1},{2,2},{2,3},{2,4}}},
	{id=19, screenName="弓箭手", type=3, typeName="职业", career={{3,1},{3,2},{3,3},{3,4}}},
	{id=20, screenName="魔剑士", type=3, typeName="职业", career={{4,1},{4,2},{4,3}}},
	{id=21, screenName="携带技能", type=7, typeName="装备技能", skill=1},
	{id=22, screenName="幸运属性", type=8, typeName="幸运属性", luncky={{1}}},
	{id=23, screenName="无视装备提升", type=11, typeName="无视装备提升"},
	{id=24, groupLevel=102, screenName="祝福宝石（30积分）", type=9, typeName="宝石类型", gem=1253000299},
	{id=25, groupLevel=102, screenName="灵魂宝石（20积分）", type=9, typeName="宝石类型", gem=1253000399},
	{id=26, groupLevel=102, screenName="生命宝石（50积分）", type=9, typeName="宝石类型", gem=1253000499},
	{id=27, groupLevel=102, screenName="玛雅之石（10积分）", type=9, typeName="宝石类型", gem=1253000199},
	{id=28, groupLevel=102, screenName="创造宝石（10积分）", type=9, typeName="宝石类型", gem=1253000599},
	{id=29, groupLevel=102, screenName="国王卷轴（100积分）", type=9, typeName="宝石类型", gem=1254001399},
	{id=30, groupLevel=102, screenName="洛克之羽（200积分）", type=9, typeName="宝石类型", gem=1254001499},
	{id=31, groupLevel=103, screenName="卓越（10积分）/手动回收", type=0, typeName="卓越（10积分）/手动回收"},
	{id=32, groupLevel=199, screenName="套装（50积分）/手动回收", type=0, typeName="套装（50积分）/手动回收"},
	{id=33, groupLevel=198, screenName="卓越套装（100积分）/手动回收", type=0, typeName="卓越套装（100积分）/手动回收"},
	{id=34, screenName="圣导师", type=3, typeName="职业", career={{5,1},{5,2},{5,3}}},
	{id=35, screenName="召唤师", type=3, typeName="职业", career={{6,1},{6,2},{6,3}}},
	{id=36, screenName="光明法师", type=3, typeName="职业", career={{7,1},{7,2},{7,3},{7,4}}},
	{id=37, groupLevel=104, screenName="技能", type=0, typeName=""},
}

local defaults = {groupLevel=101, type=5, typeName="强化等级", strengthlevel=0, appendlevel=0, luncky={}, skill=0, gem=0, DefaultTick=0, rank=0, count=0, career={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_recovery_screen) do
	setmetatable(v, mt)
end

return cfg_recovery_screen
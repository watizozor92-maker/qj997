-- 此文件工具自动生成，不要修改
---@class cfg_equip_guard_column
---引援item表里的装备id
---@field id number @id column=1 A
---1-守护
---2-守护皮肤
---策划用于区分表格数据，程序不处理
---@field type number @类型 column=2 B
---策划备注，程序不读
---@field desc string @名字 column=3 C
---Type=1时配置
---0：无
---1：自动拾取
---2：装备技能
---@field ability number @特殊属性ID column=4 D
---Type=1时配置
---【ability = 1】拾取范围#拾取数量
---范围以守护为中心，周围X格
---数量为单次拾取道具数量
---【ability = 2】技能ID，参考cfg_skill.xlsx表id
---技能可配置多个格式为技能id#技能id#技能id……
---@field abilityParameter IntList @特殊属性参数 column=5 E
---Type=2时配置
---是否绑定原先守护的行为逻辑
---若不绑定原先守护的行为逻辑，则守护的初始状态跟随字段
---0-绑定
---1-不绑定
---@field isBind number @状态绑定 column=6 F
---若不配置则读取默认初始状态机，若配置则读取对应得状态机
---@field animation string @初始状态 column=7 G
---Type=2时配置
---定义守护皮肤自身的行为逻辑
---1-飞行
---2-地面
---3-环绕（特殊行为，玩家静止不动时，守护会围绕玩家旋转）
---若需要配置多个行为状态，则通过#连接，如：1#2
---@field ai IntList @行为逻辑 column=8 H
---Type=1时配置
---用于区分守护是否为某一守护的强化类型
---0：无
---1：强化类型
---@field isStrengthen number @强化类型 column=9 I
---从小到大进行替换，替换到最大值后，循环回最小值
---@field rank number @替换排序 column=10 J
---0或空：不可修理
---1：可修理
---@field repair number @守护是否可修理 column=11 K

local local_abilityParameter = {
    abilityParameter_1={},
    abilityParameter_2={6,2},

}

local local_ai = {
    ai_1={1},
    ai_2={2,3},

}

local cfg_equip_guard =
{
	{id=21400001, desc="守护天使", abilityParameter=local_abilityParameter.abilityParameter_1, rank=10},
	{id=21400002, desc="小恶魔", abilityParameter=local_abilityParameter.abilityParameter_1, rank=9},
	{id=21400004, desc="独角兽", abilityParameter=local_abilityParameter.abilityParameter_1, rank=11},
	{id=21400005, desc="鲁道夫", abilityParameter=local_abilityParameter.abilityParameter_1, rank=12},
	{id=21400006, desc="魔界幻龙", abilityParameter=local_abilityParameter.abilityParameter_1, rank=13},
	{id=21400007, desc="强化恶魔(30天)", ability=1, isStrengthen=1, rank=5},
	{id=21400008, desc="强化天使(30天)", ability=1, isStrengthen=1, rank=6},
	{id=21400015, desc="强化恶魔(1天)", ability=1, isStrengthen=1, rank=7},
	{id=21400016, desc="强化天使(1天)", ability=1, isStrengthen=1, rank=8},
	{id=2140000799, desc="强化恶魔(30天)", ability=1, isStrengthen=1, rank=1},
	{id=2140000899, desc="强化天使(30天)", ability=1, isStrengthen=1, rank=2},
	{id=2140001599, desc="强化恶魔(1天)", ability=1, isStrengthen=1, rank=3},
	{id=2140001699, desc="强化天使(1天)", ability=1, isStrengthen=1, rank=4},
	{id=21400009, desc="熊猫", abilityParameter=local_abilityParameter.abilityParameter_1, animation="walk", ai=local_ai.ai_2},
	{id=21400003, desc="小战士", abilityParameter=local_abilityParameter.abilityParameter_1},
	{id=21400011, desc="守护天使", abilityParameter=local_abilityParameter.abilityParameter_1},
	{id=61300001, type=2, desc="魔界幻龙皮肤", ability=0, abilityParameter=local_abilityParameter.abilityParameter_1},
	{id=61300004, type=2, desc="小麋鹿皮肤", ability=0, abilityParameter=local_abilityParameter.abilityParameter_1},
	{id=61300005, type=2, desc="独角天马皮肤", ability=0, abilityParameter=local_abilityParameter.abilityParameter_1},
	{id=61300006, type=2, desc="幽冥蛛皮肤", ability=0, abilityParameter=local_abilityParameter.abilityParameter_1, animation="run", ai=local_ai.ai_2},
	{id=61300007, type=2, desc="苍翼虎皮肤", ability=0, abilityParameter=local_abilityParameter.abilityParameter_1, animation="walk", ai=local_ai.ai_2},
	{id=61300008, type=2, desc="炎烈鸟皮肤", ability=0, abilityParameter=local_abilityParameter.abilityParameter_1, animation="fly"},
	{id=2140000199, desc="守护天使", abilityParameter=local_abilityParameter.abilityParameter_1, rank=10},
	{id=2140000299, desc="小恶魔", abilityParameter=local_abilityParameter.abilityParameter_1, rank=9},
}

local defaults = {type=1, ability=0, abilityParameter={6,2}, isBind=1, animation="idle", ai={1}, isStrengthen=0, rank=0, repair=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_guard) do
	setmetatable(v, mt)
end

return cfg_equip_guard
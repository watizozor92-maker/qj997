-- 此文件工具自动生成，不要修改
---@class cfg_att_special_column
---@field id number @属性ID column=1 A
---属性名称
---显示在属性面板
---@field name string @名称 column=2 B
---属性英文名
---开发新属性需要与程序沟通
---@field attribute string @属性 column=3 C
---1,累加。在转化属性ID的基础上，增加赋值变量
---2,累乘。转化属性ID=（1+赋值变量/10000）*原值
---3,增加等级/X。在转化属性ID的基础上，增加等级/X*赋值变量，格式：3#X
---4,累乘，增幅当前装备的转化属性ID。
---5,杀怪恢复生命值数值
---6,杀怪恢复生命值比例
---7,安全区生命自动恢复速度，每X秒回复最大生命值比例的当前生命值，X配置于全局表ID=250。#1=安全区，#2=野外，#3=安全区+野外
---8,杀怪恢复魔法值数值
---9,杀怪恢复魔法值比例
---10,安全区魔法自动恢复速度，每X秒回复最大魔法值比例的当前魔法值，X配置于全局表ID=251。#1=安全区，#2=野外，#3=安全区+野外
---11,AG值消耗时降低固定数值
---12,AG值消耗减少比例
---13,指定道具掉落率乘以（1+赋值变量），格式：13#ITEMid#
---14,卓越装备掉落率乘以（1+赋值变量），格式14#X。X=cfg_equip_quality 表ID
---15,所有装备掉落率乘以（1+赋值变量）
---16,冷却缩减
---17,调整红药恢复效果比例
---18,调整蓝药恢复效果比例
---19,经验获得（1+赋值变量）
---20,经验获得（1-赋值变量）
---21,当前装备所需要的属性减少，格式：21#需要的attID#
---23,指定合成配方成功率增加，格式：23#cfg_synthesisID# param不填写=所有合成表ID得合成配方成功率都加
---24,攻击回血固定值  攻击后，回复固定的生命值
---25,杀怪后护盾回复
---26,杀怪后护盾回复比例
---27,杀怪后技能值回复
---28,杀怪后技能值回复比例
---29,满血回复率   回 最大生命值百分比 的 当前血量
---30,满魔回复率   回 最大魔法值百分比 的 当前魔法
---40,穿戴指定部位装备增加属性。格式：装备部位
---@field type IntList @类型 column=4 D
---于类型相对应
---3,X
---7,1=安全区，2=野外
---10,1=安全区，2=野外
---13,道具item
---21，attId
---23，cfg_synthesisID
---@field param string @条件 column=5 E
---读att_infoid，增加的属性值
---@field attId IntList @转化属性ID column=6 F

local local_type = {
    type_1={1},
    type_2={2},
    type_3={3},
    type_4={7},
    type_5={10},
    type_6={13},
    type_7={21},
    type_8={23},

}

local local_attId = {
    attId_1={201021,202021,205021},
    attId_2={201011,202011,205011},
    attId_3={201011,201021,202011,202021,205011,205021},
    attId_4={201011,201021},
    attId_5={202011,202021},
    attId_6={205011,205021},
    attId_7={206011},
    attId_8={207011},
    attId_9={},
    attId_10={208011},
    attId_11={211011},
    attId_12={302011},
    attId_13={209011},
    attId_14={210031},
    attId_15={212031},
    attId_16={301011},

}

local cfg_att_special =
{
	{id=10011, name="全属性增加", attribute="Allatt", type=local_type.type_1, attId={10001,10002,10003,10004,10005}},
	{id=200011, name="最小攻击力增加", attribute="minAtkUpPercent", type=local_type.type_1, attId=local_attId.attId_1},
	{id=200012, name="最小攻击力加成", attribute="minimumAttackPowerBonus", attId=local_attId.attId_1},
	{id=200021, name="最大攻击力增加", attribute="maxAtkUpPercent", type=local_type.type_1, attId=local_attId.attId_2},
	{id=200022, name="最大攻击力加成", attribute="maximumAttackPowerBonus", attId=local_attId.attId_2},
	{id=200030, name="攻击力+等级/10", attribute="Per10levelAtkUp", type=local_type.type_3, param="10"},
	{id=200031, name="攻击力+等级/20", attribute="Per20levelAtkUp", type=local_type.type_3, param="20"},
	{id=200032, name="攻击力+等级/19", attribute="Per19levelAtkUp", type=local_type.type_3, param="19"},
	{id=200033, name="攻击力+等级/18", attribute="Per18levelAtkUp", type=local_type.type_3, param="18"},
	{id=200034, name="攻击力+等级/17", attribute="Per17levelAtkUp", type=local_type.type_3, param="17"},
	{id=200035, name="攻击力+等级/16", attribute="Per16levelAtkUp", type=local_type.type_3, param="16"},
	{id=200036, name="攻击力+等级/15", attribute="Per15levelAtkUp", type=local_type.type_3, param="15"},
	{id=200037, name="攻击力+等级/14", attribute="Per14levelAtkUp", type=local_type.type_3, param="14"},
	{id=200038, name="攻击力+等级/13", attribute="Per13levelAtkUp", type=local_type.type_3, param="13"},
	{id=200039, name="攻击力+等级/12", attribute="Per12levelAtkUp", type=local_type.type_3, param="12"},
	{id=200040, name="攻击力+等级/11", attribute="Per11levelAtkUp", type=local_type.type_3, param="11"},
	{id=200041, name="攻击力增加", attribute="AtkUp", type=local_type.type_1},
	{id=200042, name="攻击力加成", attribute="AtkUpPercent"},
	{id=201031, name="攻击力等级提高", attribute="level20Dc", type=local_type.type_3, param="20", attId=local_attId.attId_4},
	{id=201041, name="物理攻击增加", attribute="physicalattackpowervalue", type=local_type.type_1, attId=local_attId.attId_4},
	{id=201042, name="物理攻击加成", attribute="attackBonusDc", attId=local_attId.attId_4},
	{id=202012, name="最大魔法攻击力加成", attribute="maxMCPercent", attId={202011}},
	{id=202022, name="最小魔法攻击力加成", attribute="minMCPercent", attId={202021}},
	{id=202031, name="魔法攻击力等级提高", attribute="level20MC", type=local_type.type_3, param="40", attId=local_attId.attId_5},
	{id=202032, name="魔法攻击力等级提高", attribute="levelMC20", type=local_type.type_3, param="20", attId=local_attId.attId_5},
	{id=202041, name="魔法攻击增加", attribute="magicattackpowervalue", type=local_type.type_1, attId=local_attId.attId_5},
	{id=202042, name="魔法攻击加成", attribute="magicattackpowerratio", attId=local_attId.attId_5},
	{id=202062, name="魔法攻击力加成", attribute="enchantedMagicAttackPowerBonus", attId=local_attId.attId_5},
	{id=213011, name="魔法攻击速度加成", attribute="AniSpeedMagicAdd", type=local_type.type_1, attId={500125}},
	{id=203041, name="权杖提升宠物攻击百分比", attribute="skyhawksAttackBonus", attId={203011,203021,204011}},
	{id=205032, name="诅咒攻击力加成", attribute="curseOfStaffAttackPowerBonus", attId=local_attId.attId_6},
	{id=205042, name="诅咒攻击力加成", attribute="enchantmentCurseAttackPowerBonus", attId=local_attId.attId_6},
	{id=205051, name="诅咒攻击增加", attribute="curseAttackPowerIncreased", type=local_type.type_1, attId=local_attId.attId_6},
	{id=205052, name="诅咒攻击加成", attribute="curseStaffAttackPowerBonus", attId=local_attId.attId_6},
	{id=205061, name="诅咒攻击力等级提高", attribute="LevelCurse", type=local_type.type_3, param="20", attId=local_attId.attId_6},
	{id=206022, name="盾牌防御力", attribute="shieldArmorPercent", type={4}, attId=local_attId.attId_7},
	{id=206032, name="防御力加成", attribute="armorPercent", attId=local_attId.attId_7},
	{id=206033, name="防御力增加", attribute="armorAdd", type=local_type.type_1, attId=local_attId.attId_7},
	{id=207021, name="最大生命值增加", attribute="maximumHealth", type=local_type.type_1, attId=local_attId.attId_8},
	{id=207022, name="最大生命值加成", attribute="maximumHealthBonus", attId=local_attId.attId_8},
	{id=207041, name="杀怪回复生命值", attribute="killRestoreHPvalue", type={5}, attId=local_attId.attId_9},
	{id=207042, name="杀怪回复生命值比例", attribute="killRestoreHP", type={6}, attId=local_attId.attId_9},
	{id=207062, name="HP自动回复", attribute="HPSafeRecoverPer", type=local_type.type_4, param="1", attId=local_attId.attId_9},
	{id=207063, name="生命回复速度", attribute="HPFieldRecoverPer", type=local_type.type_4, param="3#1", attId=local_attId.attId_9},
	{id=207091, name="满血回复率", attribute="HPFullRecoverRate", type={29}, attId=local_attId.attId_9},
	{id=208022, name="魔法值加成", attribute="maxMPBonus", attId=local_attId.attId_10},
	{id=208023, name="魔法值增加", attribute="maxMPadd", type=local_type.type_1, attId=local_attId.attId_10},
	{id=208041, name="杀怪回复魔法值", attribute="killRestoreMpvalue", type={8}, attId=local_attId.attId_9},
	{id=208042, name="杀怪回复魔法值比例", attribute="killRestoreMp", type={9}, attId=local_attId.attId_9},
	{id=208052, name="魔法值野外自动回复比例", attribute="magicrecoveryspeed", type=local_type.type_5, param="3#1", attId=local_attId.attId_9},
	{id=208062, name="魔法值野外自动回复比例", attribute="MPFieldRecoverPer", type=local_type.type_5, param="2", attId=local_attId.attId_9},
	{id=208072, name="魔法值安全区自动回复比例", attribute="MPSafeRecoverPer", type=local_type.type_5, param="1", attId=local_attId.attId_9},
	{id=208091, name="满魔回复率", attribute="MPFullRecoverRate", type={30}, attId=local_attId.attId_9},
	{id=209022, name="PVE攻击率加成", attribute="pvehitRateBonus", attId=local_attId.attId_13},
	{id=210022, name="PVP攻击率加成", attribute="attackRateBonus", attId=local_attId.attId_14},
	{id=211021, name="PVE防御率增加", attribute="defenseSuccessRate", type=local_type.type_1, attId=local_attId.attId_11},
	{id=211022, name="PVE防御率加成", attribute="missRateBonus", attId=local_attId.attId_11},
	{id=212022, name="PVP防御率加成", attribute="eraRateBonus", attId=local_attId.attId_15},
	{id=301022, name="最大SD值加成", attribute="sdValueIncrease", attId=local_attId.attId_16},
	{id=301091, name="杀怪回复SD值", attribute="killRestoreSDvalue", type={25}, attId=local_attId.attId_9},
	{id=301092, name="杀怪后SD值回复比例", attribute="killRestoreSDvaluePer", type={26}, attId=local_attId.attId_9},
	{id=302021, name="最大AG值提升", attribute="maximumAgValueIncrease", type=local_type.type_1, attId=local_attId.attId_12},
	{id=302022, name="最大AG值加成", attribute="agValueIncrease", attId=local_attId.attId_12},
	{id=302041, name="AG值消耗降低", attribute="agValueConsumptionReduced", type={11}, attId=local_attId.attId_12},
	{id=302042, name="AG值消耗减少", attribute="agValuePercentageConsumptionReduced", type={12}, attId=local_attId.attId_12},
	{id=302081, name="杀怪回复AG值", attribute="killRestoreAGvalue", type={27}, attId=local_attId.attId_9},
	{id=302082, name="杀怪后AG值回复比例", attribute="killRestoreAGvaluePer", type={28}, attId=local_attId.attId_9},
	{id=319012, name="金币掉落率", attribute="goldIncrease", type=local_type.type_6, param="10010001", attId=local_attId.attId_9},
	{id=319022, name="提高宝石掉落率", attribute="stoneDropRateIncrease", type=local_type.type_6, param="60300002#60300003#60300004#60300005#60300006", attId=local_attId.attId_9},
	{id=319032, name="提高卓越装备掉落率", attribute="exEquipDropRateIncrease", type={14}, param="2", attId=local_attId.attId_9},
	{id=319052, name="道具掉落提升", attribute="propdropincrease", type={15}, attId=local_attId.attId_9},
	{id=321012, name="冷却缩减", attribute="CDReduce", type={16}, attId=local_attId.attId_9},
	{id=324012, name="红药恢复效果", attribute="redrestoreRatio", type={17}, attId=local_attId.attId_9},
	{id=324022, name="蓝药恢复效果", attribute="bluerestoreRatio", type={18}, attId=local_attId.attId_9},
	{id=325012, name="经验加成", attribute="increaseExperience", type={19}, attId=local_attId.attId_9},
	{id=325022, name="经验消减", attribute="decreaseExperience", type={20}, attId=local_attId.attId_9},
	{id=327011, name="穿戴所需力量减少", attribute="reducedWearingPower", type=local_type.type_7, param="10001", attId=local_attId.attId_9},
	{id=327021, name="穿戴所需智力减少", attribute="wearingReducedIntelligence", type=local_type.type_7, param="10003", attId=local_attId.attId_9},
	{id=327031, name="穿戴所需敏捷减少", attribute="wearingAgilityReduces", type=local_type.type_7, param="10002", attId=local_attId.attId_9},
	{id=327041, name="穿戴所需力/智减少", attribute="wearingStrengthandIntelligenceDecrease", type=local_type.type_7, param="10001#10003", attId=local_attId.attId_9},
	{id=331012, name="合成物品成功率增加", attribute="theSuccessRateOfSynthesizingItemsHasIncreased", type=local_type.type_8, attId=local_attId.attId_9},
	{id=331022, name="合成翅膀成功率增加", attribute="theSuccessRateOfSynthesizingWingsHasIncreased", type=local_type.type_8, param="10002", attId=local_attId.attId_9},
	{id=400003, name="防御+等级/10", attribute="freeAtt3", type=local_type.type_3, param="10", attId=local_attId.attId_7},
	{id=400004, name="当前HP百分比回复", attribute="freeAtt4", attId={207031}},
	{id=400005, name="当前MP百分比回复", attribute="freeAtt5", attId={208031}},
	{id=932, name="SD值加成", attribute="hudunzhiRate", attId={931}},
	{id=213021, name="攻击（魔法）速度增加", attribute="EquipattAttackSpeed", type=local_type.type_1, attId={500125,500126}},
	{id=314023, name="攻击力上升", attribute="allAttackPowerBonus", attId={201021,202021,205021,201011,202011,205011}},
	{id=600011, name="装备双手武器伤害提高", attribute="wearingTwoHandedWeaponDamageRate", type={40}, param="3", attId={311022}},
	{id=209012, name="攻击率加成", attribute="hitRateBonus", type=local_type.type_3, param="1", attId=local_attId.attId_13},
	{id=210023, name="PVP攻击率加成", attribute="attackLevelBonus", type=local_type.type_3, param="1", attId=local_attId.attId_14},
	{id=212023, name="PVP防御率加成-等级", attribute="eraRateLevelBonus", type=local_type.type_3, param="1", attId=local_attId.attId_15},
	{id=207023, name="最大生命值增加百分比-等级", attribute="maximumHealthByLvBonus", type=local_type.type_3, param="1", attId=local_attId.attId_8},
	{id=208024, name="最大魔法值按等级增加", attribute="maxMPByLvBonus", type=local_type.type_3, param="1", attId=local_attId.attId_10},
	{id=301083, name="护盾值按等级加成", attribute="sdAddByLevel", type=local_type.type_3, param="5", attId=local_attId.attId_16},
}

local defaults = {type={2}, param="", attId={201011,201021,202011,202021,205011,205021}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_att_special) do
	setmetatable(v, mt)
end

return cfg_att_special
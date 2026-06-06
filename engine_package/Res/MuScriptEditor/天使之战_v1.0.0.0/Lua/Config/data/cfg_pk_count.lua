-- 此文件工具自动生成，不要修改
---@class cfg_pk_count_column
---唯一id
---@field id number @id column=1 A
---击杀1名非红名玩家产生的PK值
---@field addByKill number @击杀玩家增加pk值 column=2 B
---1增加，0或空对方不增加
---@field addBekilled number @被击杀时  对方是否增加pk值 column=3 C
---时间(s)#值
---
---每多少秒减少多少PK值
---@field reduceByTime IntList @时间减少 column=4 D
---怪物等级*PK点数参数，万分比，例如：击杀一只100级怪物配置1000（10%） → 减少10点
---@field reduceByMonsterParam number @杀怪减少PK值参数 column=5 E
---PK值下限#PK值上限#颜色
---|分隔，颜色引援color表ID
---
---
---大于等于该阶段PK值则显示该阶段的颜色，PK值大的覆盖PK值小的
---@field nameColor IntList @名称颜色 column=6 F
---大于等于这个值为红名玩家
---@field redNameNeed number @红名界限 column=7 G
---大于等于这个值为黄名玩家
---（决定发什么邮件）
---@field yellowNameNeed number @黄名界限 column=8 H
---控制是否限制使用地图传送功能
---0否
---1是
---2 限制进入和平线路
---@field mapTransmission number @地图传送 column=9 I
---配置格式：整数倍率
---@field mapTransmissionCost number @传送费用倍率 column=10 J
---1限制，0或空不限制
---@field tradeLimit number @交易行限制使用 column=11 K
---控制是否可在野外（除去副本）对玩家造成伤害买功能
---0否
---1是
---@field pvpDamage number @pvp伤害 column=12 L
---显示在游戏内角色头顶的标签
---@field label string @显示标签 column=13 M
---cfg_color内的id
---@field displayColor number @显示颜色 column=14 N
---1、被击杀时概率掉落道具
---概率|道具id#道具id|执行次数
---2、概率使用万分比
---@field dropGemPVP IntListList @PVP被击杀掉落随机宝石 column=15 O
---1、被击杀时概率掉落道具
---概率|道具id#道具id|执行次数
---2、概率使用万分比
---@field dropGemPVE IntListList @PVE被击杀掉落随机宝石 column=16 P
---1、优先非绑金币id#固定值#总值万分比|优先绑定金币id#固定值#总值万分比
---2、非绑金币掉落地上，绑定金币直接消失
---@field dropCoinPVP IntListList @PVP被击杀掉落金币 column=17 Q
---1、优先非绑金币id#固定值#总值万分比|优先绑定金币id#固定值#总值万分比
---2、非绑金币掉落地上，绑定金币直接消失
---@field dropCoinPVE IntListList @PVE被击杀掉落金币 column=18 R
---掉落概率|执行次数|穿戴栏装备比重#背包装备比重
---@field dropEquipPVP IntListList @PVP被击杀掉落装备概率 column=19 S
---掉落概率|执行次数|穿戴栏装备比重#背包装备比重
---@field dropEquipPVE IntListList @PVE被击杀掉落装备概率 column=20 T

local local_reduceByTime = {
    reduceByTime_1={},

}

local local_dropGemPVE = {
    dropGemPVE_1={},

}

local local_dropCoinPVE = {
    dropCoinPVE_1={{10010001,0,0},{10010002,0,400}},

}

local local_dropEquipPVP = {
    dropEquipPVP_1={},

}

local local_dropEquipPVE = {
    dropEquipPVE_1={},

}

local cfg_pk_count =
{
	{id=1, addByKill=21600, addBekilled=1, mapTransmission=0, mapTransmissionCost=1, tradeLimit=0, label="", displayColor=0, dropEquipPVP=local_dropEquipPVP.dropEquipPVP_1, dropEquipPVE=local_dropEquipPVE.dropEquipPVE_1},
	{id=2, addByKill=21600, addBekilled=0, nameColor={21600,43199,2001}, mapTransmission=0, mapTransmissionCost=2, tradeLimit=0, label="[无赖]", displayColor=2001, dropGemPVP={{2000},{50030001,50030002,50030003,50030004,50030005,50030008,1253000199,1253000299,1253000399,1253000499,1253000599,1253000899},{1}}, dropCoinPVP={{10010001,0,100},{10010002,0,400}}, dropEquipPVP=local_dropEquipPVP.dropEquipPVP_1, dropEquipPVE=local_dropEquipPVE.dropEquipPVE_1},
	{id=3, addByKill=21600, addBekilled=0, nameColor={43200,86399,2002}, mapTransmission=0, mapTransmissionCost=5, tradeLimit=1, label="[恶人]", displayColor=2002, dropGemPVP={{3000},{50030001,50030002,50030003,50030004,50030005,50030008,1253000199,1253000299,1253000399,1253000499,1253000599,1253000899},{1}}, dropCoinPVP={{10010001,0,200},{10010002,0,400}}},
	{id=4, addByKill=25200, addBekilled=0, nameColor={86400,9999999,2003}, mapTransmission=2, mapTransmissionCost=5, tradeLimit=1, label="[魔头]", displayColor=2003, dropGemPVP={{5500},{50030001,50030002,50030003,50030004,50030005,50030008,1253000199,1253000299,1253000399,1253000499,1253000599,1253000899},{3}}, dropCoinPVP={{10010001,0,400},{10010002,0,400}}, dropEquipPVP={{7500},{1},{5000,5000}}, dropEquipPVE={{200},{2},{6500,3500}}},
}

local defaults = {reduceByTime={}, reduceByMonsterParam=1000, nameColor={0,21599,2001}, redNameNeed=43200, yellowNameNeed=21600, pvpDamage=0, dropGemPVP={{300},{50030001,50030002,50030003,50030004,50030005,50030008,1253000199,1253000299,1253000399,1253000499,1253000599,1253000899},{1}}, dropGemPVE={}, dropCoinPVP={{10010001,0,0},{10010002,0,100}}, dropCoinPVE={{10010001,0,0},{10010002,0,400}}, dropEquipPVP={{1500},{1},{5000,5000}}, dropEquipPVE={{100},{1},{6500,3500}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_pk_count) do
	setmetatable(v, mt)
end

return cfg_pk_count
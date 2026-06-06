-- 此文件工具自动生成，不要修改
---@class cfg_free_buff_column
---@field id number @唯一id column=1 A
---名称
---@field name string @加成名称 column=2 B
---加成生效条件
---引援cfg_conditions的判定公式
---@field conditions string @生效条件 column=3 C
---角色BUFF状态栏显示图标，填写文件名；
---填空表示不显示
---@field icon string @图标 column=4 D
---引援cfg_conditions的判定公式；
---格式：条件表达式|条件表达式；数量需要与指令数量对应；
---填0则无此要求
---@field instructionConditions StringList @指令生效条件 column=5 E
---使用脚本命令
---@field instruction StringListList @快捷指令 column=6 F
---buff增益效果的持续时间填
---格式:天#时#分#秒
---填空表示永久生效
---@field time IntList @BUff时间 column=7 G
---格式：单次自动拾取数量#最大飞行时间（秒）
---配置则可开启该功能
---多条数据生效则取最后一条数据
---@field autoPick IntList @自动拾取 column=8 H
---格式：背包剩余格子数开启自动回收
---配置则可开启该功能
---多条数据生效则取最后一条数据
---@field autoRecovery number @自动回收 column=9 I
---格式：0或空：不开启自动买药 1：开启自动买药
---@field autoPotion number @自动买药 column=10 J
---格式：0或空：不开启随身商店 1：开启随身商店
---@field withStore number @随身商店 column=11 K
---格式：0或空：不开启随身仓库 1：开启随身仓库
---@field withWarehouse number @随身仓库 column=12 L
---交易行寄售格子增加
---@field tradeNumber number @交易行寄售格子增加 column=13 M
---格式：0或空：不开启交易行寄售 1：开启交易行寄售
---@field trade number @交易行寄售 column=14 N
---离线挂机经验加成
---单位：万分比
---@field offlineExpAdd number @离线挂机经验加成 column=15 O
---格式：0或空：不开启离线挂机领取道具 1：开启离线挂机领取道具
---@field offlineItem number @离线挂机是否领取道具 column=16 P
---是否开启付费线路，填空则不开启
---格式：线路类型id#线路类型id（cfg_map_line/id）
---@field mapLine IntList @付费线路 column=17 Q
---格式:正值 直接填数字； 负值 -号  ，单位 万比
---例：增加百分之10的经验值获取量  1000
---降低百分之25的经验值获取量  -2500
---为空=此项没有加成
---只能对玩家生效
---@field experience IntList @经验获取加成 column=18 R
---格式:道具ID#爆率提升；爆率单位 万分比
---例：增加奇迹币、革铠 百分之10的掉落概率   10020001#1000|20060003#1000
---降低金币、革盔百分之25的掉落概率  
---10010001#-2500|20040003#-2500
---为空=此项没有加成
---@field itemDrop IntListList @道具爆率增加 column=19 S
---格式：消耗道具ID#消耗数量#获取道具ID#获取数量|消耗道具ID#消耗数量#获取道具ID#获取数量(适用于道具主动使用，系统商城购买，NPC商店购买，摆摊商店购买，拍卖行购买)
---@field itemConsume IntListList @消耗道具获取另一个道具 column=20 T
---只对cfg_monster表/type字段为1的怪物生效
---格式：万分比
---@field monsterExp number @击杀小怪经验加成 column=21 U
---格式:正值 直接填数字； 负值 -号  ，单位 万比
---例：增加百分之10的金币数量掉落  1000
---降低百分之25的金币数量掉落  -2500
--- 为空=此项没有加成
---只能对玩家生效
---@field gold IntList @金币掉落加成 column=22 V
---格式:正值 直接填数字； 负值 -号  ，单位 万比
---例：增加百分之10的移动速度  1000
---降低百分之25的移动速度 -2500
---为空=此项没有加成
---只能对玩家生效，增加移速
---@field move IntList @移速加成 column=23 W
---格式:正值 直接填数字； 负值 -号  ，单位 万比
---例：增加百分之10的回收金币所得  1000
---降低百分之25的回收金币所得  -2500
---为空=此项没有加成
---只能对玩家生效
---@field recovery IntList @道具回收金币加成 column=24 X
---格式:正值 直接填数字； 负值 -号  ，单位 万比
--- #后面跟item表的type=2后面的子类别数字。
---例：增加主手武器、头盔、鞋子 百分之10的掉落概率   1000#2#4#9
---降低主手武器、头盔、鞋子的掉落概率  -2500#2#4#9
---为空=此项没有加成
---只能对玩家生效
---@field explode IntListList @装备爆率增加 column=25 Y
---格式：属性id#增加数值|属性id#增加数值
---@field attribute IntListList @属性增加 column=26 A
---与道具表自动使用自动关联；
---格式：0或空：不开启自动使用 1：开启自动使用
---@field autoUse number @自动使用 column=27 AA
---格式：填数字代表离线挂机的额外小时数
---@field onHookTime number @增加的离线挂机时长 column=28 AB
---0：不显示
---1：固定显示
---2：生效后固定显示
---3：仅生效时显示
---@field showType number @显示方式 column=29 AC
---界面所显示的道具模型；
---格式：道具id#道具id；
---配置多个道具根据当前拥有的道具进行显示，如果都满足则显示配置顺序靠后的道具模型；
---填空则不显示模型；
---@field itemModel IntList @道具模型 column=30 AD
---是否开启：1=开
---
---2=关
---@field open number @开关 column=31 AE
---1=只对玩家生效
---2=只对怪物生效
---
---格式：玩家 就填1
---怪物  2
---@field type number @作用对象 column=32 AF

local local_instructionConditions = {
    instructionConditions_1={""},

}

local local_instruction = {
    instruction_1={{"KmlShopMallUI/OpenKmlShopMallUI"}},

}

local local_time = {
    time_1={30,0,0,0},

}

local local_mapLine = {
    mapLine_1={},

}

local local_experience = {
    experience_1={},

}

local local_itemDrop = {
    itemDrop_1={},

}

local local_itemConsume = {
    itemConsume_1={},

}

local local_gold = {
    gold_1={},

}

local local_move = {
    move_1={},

}

local local_recovery = {
    recovery_1={},

}

local local_explode = {
    explode_1={},

}

local local_attribute = {
    attribute_1={},

}

local local_itemModel = {
    itemModel_1={},

}

local cfg_free_buff =
{
	{id=1, name="特权卡", conditions="checkUseItemTime[30030121]=1", icon="28", instructionConditions=local_instructionConditions.instructionConditions_1, instruction=local_instruction.instruction_1, autoPick={3,2}, autoRecovery=0, autoPotion=0, withStore=1, withWarehouse=1, tradeNumber=0, trade=0, offlineExpAdd=0, offlineItem=0, mapLine=local_mapLine.mapLine_1, experience=local_experience.experience_1, itemDrop=local_itemDrop.itemDrop_1, itemConsume=local_itemConsume.itemConsume_1, monsterExp=0, gold=local_gold.gold_1, move=local_move.move_1, recovery=local_recovery.recovery_1, explode=local_explode.explode_1, attribute=local_attribute.attribute_1, autoUse=0, onHookTime=0, showType=0, itemModel=local_itemModel.itemModel_1, open=0, type=0},
	{id=2, name="高级特权卡", conditions="checkUseItemTime[30030122]=1", icon="34", instructionConditions=local_instructionConditions.instructionConditions_1, instruction=local_instruction.instruction_1, autoPick={6,2}, autoRecovery=6, autoPotion=1, withStore=1, withWarehouse=1, tradeNumber=0, trade=0, offlineExpAdd=2000, offlineItem=1, mapLine=local_mapLine.mapLine_1, experience=local_experience.experience_1, itemDrop=local_itemDrop.itemDrop_1, itemConsume=local_itemConsume.itemConsume_1, monsterExp=0, gold=local_gold.gold_1, move=local_move.move_1, recovery=local_recovery.recovery_1, explode=local_explode.explode_1, attribute=local_attribute.attribute_1, autoUse=0, onHookTime=0, showType=0, itemModel=local_itemModel.itemModel_1, open=0, type=0},
	{id=3, name="黄金线路卡", conditions="checkUseItemTime[30030124]=1", icon="34", instructionConditions=local_instructionConditions.instructionConditions_1, instruction={}, autoPick={}, autoRecovery=0, autoPotion=0, withStore=0, withWarehouse=0, tradeNumber=0, trade=0, offlineExpAdd=0, offlineItem=0, mapLine={3}, experience=local_experience.experience_1, itemDrop=local_itemDrop.itemDrop_1, itemConsume=local_itemConsume.itemConsume_1, monsterExp=0, gold=local_gold.gold_1, move=local_move.move_1, recovery=local_recovery.recovery_1, explode=local_explode.explode_1, attribute=local_attribute.attribute_1, autoUse=0, onHookTime=0, showType=0, itemModel=local_itemModel.itemModel_1, open=0, type=0},
}

local defaults = {time={30,0,0,0}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_free_buff) do
	setmetatable(v, mt)
end

return cfg_free_buff
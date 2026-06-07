-- 此文件工具自动生成，不要修改
---@class cfg_skill_column
---第一位占位（1：角色，2：怪物），第二位技能类型，第三位技能分类，第四位职业id，第五六七为编号
---@field id number @技能id column=1 A
---备注字段
---@field name string @技能名称 column=2 B
---0：主动技能；
---1：被动技能；
---（不填默认为主动技能）
---@field type number @技能类型 column=3 C
---0：普通技能
---1：天赋技能
---2：连击技能
---3：召唤技能
---4：普通攻击技能
---5：大天使天赋技能
---@field group number @技能分类 column=4 D
---0不显示
---1显示
---2激活时显示
---
---编辑器读取
---{不显示=0|显示=1}
---@field isshow number @是否显示 column=5 E
---技能学习后自动添加到技能轮盘
---不填则不生效
---0：否
---1：是
---@field skillBar number @是否自动添加到技能轮盘 column=6 F
---用于在界面中的排序
---
---序号小的在前面
---@field index number @排序 column=7 G
---1攻击（参考属性maxDC、minDC）
---2魔攻（参考属性maxMC、minMC）
---0无效果
---编辑器读取
---{攻击力=1|魔法=2}
---@field powerSource number @威力来源 column=8 H
---废弃字段，配置无效
---单位：万分比
---[[客户端不使用]]@field accuracyType number @基础命中率 column=9 I
---是否是范围技能
---编辑器读取
---{否=0|是=1}
---[[客户端不使用]]@field aoe number @是否是范围技能 column=10 J
---1：敌人
---4：自己
---5：玩家
---6：红名
---7：归属者
---8：队友和自己
---
---编辑器读取
---{敌人=1|友方(不包含自己)=2|友方(包含自己)=3|自己=4}
---@field targetType number @技能效果作用目标类型 column=11 K
---为匹配技能释放动画和战斗飘字所用字段，无延迟需求填0即可
---非0会有掉落显示比飘字扣血提前的显示bug风险
---@field hurtDelay number @伤害显示延迟（客户端）单位为毫秒 column=12 L
---施法是否需求锁定目标
---0无需目标（需点击范围内技能地面后，释放）
---1需求目标(目标类型取targetType)
---2锁定自身(不寻找目标或地面坐标,直接施放技能)
---
---编辑器读取
---{无需目标=0|需锁定目标=1}
---@field releaseType number @施法需要目标 column=13 M
---1.点 3.直线 5.扇形 7.圆形
---大小受控与skill_info表的targetRange列
---编辑器读取
---{点=1|直线=3|扇形=5|圆形=7}
---@field areaType number @施法形状 column=14 N
---1.点 2.十字 3.直线 4.横线 5.扇形 6.菱形 7.圆形
---形状大小控制：cfg_skill_info\targetRange
---编辑器读取
---{点=1|十字=2|直线=3|横线=4|扇形=5|菱形=6|圆形=7}
---@field targetAreaType number @目标受击形状 column=15 O
---当releaseType=1时进行判断
---0客户端发来的点（即目标位置）
---1自身所在点
---[[客户端不使用]]@field holdUpBeginPoint number @受击区域起始点 column=16 P
---0或空 内挂不予显示
---1 单体环境  
---2 群体环境 
---3 通用  3#1状态 3#2召唤 3#3治疗 3#4移动 3#5 三目标技能
---4 公共环境 （既可以适配单体环境又可以适配群体环境）
---编辑器读取
---{单体=1|群体=2|状态=3|召唤=4}
---@field assistType IntList @内挂分类 column=17 Q
---数值越大，优先级越高，释放越早
---召唤技能（assistType=3#2）>增益技能（assistType=3#1）>其他技能
---不填表示不会自动释放
---@field priorityLevel number @自动释放优先级 column=18 R
---范围读取设置挂机范围；优先判断目标数量，再判断优先级大小
---不填则不判断数量
---@field targetNumber number @自动释放目标数量 column=19 S
---释放该技能时可获得的连击值
---单位：万分比
---不填表示该技能释放时不会获得连击值
---[[客户端不使用]]@field comboValue number @连击值 column=20 T
---0或空，默认学习技能后，便会出现在挂机设置里
---1，学习技能后，不出现在挂机设置里
---@field set number @设置技能 column=21 U
---0-进入技能盘
---1-不进入技能轮盘
---（不进入技能轮盘时，技能会在学习后直接进入特殊按钮中）
---@field isroulette number @是否进入技能轮盘 column=22 V
---1 起手技
---2 衔接技
---3 终结技
---格式：如有多个类型可以用#分割 例如1#2
---@field comboType IntList @连击技能类型 column=23 W
---1、仅特殊技能需要配置
---如五重箭、三重箭
---2、配空或0时该字段不生效被过滤
---@field damageNumberLimit number @伤害人数上限 column=24 X
---默认不震动，填1 震动
---@field vibration number @技能是否震动 column=25 Y
---配置参数：震动次数#震动等级#震屏延迟#震动持续时间#震动强度#多次震动间歇时间#震动间隔帧数#是否影响他人（0自己;1其他人）
---
---震动次数：技能释放后进行震动的次数
---震动等级：1-6级，对震动强度影响较小，配1即可
---震动延迟：技能释放后多久开始进行震动（单位：毫秒）
---震动持续时间：单次震动持续的时间（单位：秒）
---震动强度：和震动等级组合计算出最后的震动强度（总震动强度公式：震动等级*0.02+震动强度）。
---多次震动间歇时间：震动次数2次以上时，每次震动间隔的时间（单位：秒）
---震动间隔帧数：单次震动持续过程中每间隔几帧移动一次相机
---是否影响其他人（0自己；1其他人）
---
---（需要按顺序配置参数，不需要的配0）
---@field vibrationCount IntList @震动次数和震动等级 column=26 A

local local_assistType = {
    assistType_1={1},
    assistType_2={3,4},
    assistType_3={3,2},
    assistType_4={},
    assistType_5={2},
    assistType_6={3,1},
    assistType_7={3,3},
    assistType_8={4},

}

local local_comboType = {
    comboType_1={},
    comboType_2={1,2,3},

}

local local_vibrationCount = {
    vibrationCount_1={},

}

local cfg_skill =
{
	{id=1004000, name="全职业普通攻击", group=4, isshow=0, skillBar=0, targetNumber=1, isroulette=0},
	{id=1304001, name="弓箭手弓箭普通攻击", group=4, isshow=0, skillBar=0, targetNumber=1, set=0, isroulette=0},
	{id=1304002, name="弓箭手弩箭普通攻击", group=4, isshow=0, skillBar=0, targetNumber=1},
	{id=1020063, name="弓箭手普通攻击", type=0, group=0, isshow=0, skillBar=0, index=1, targetNumber=1},
	{id=1100001, name="升龙击", isshow=2, skillBar=1, index=1, priorityLevel=4, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1100002, name="地裂斩", isshow=2, skillBar=1, index=2, priorityLevel=5, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1100003, name="旋风斩", isshow=2, skillBar=1, index=3, priorityLevel=2, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1100004, name="牙突刺", isshow=2, skillBar=1, index=4, priorityLevel=3, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1100005, name="天地十字剑", isshow=2, skillBar=1, index=5, priorityLevel=6, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200001, name="能量球", isshow=1, skillBar=1, index=1, powerSource=2, priorityLevel=2, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200002, name="火球", isshow=1, skillBar=1, index=2, powerSource=2, priorityLevel=3, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200003, name="真空波", isshow=1, skillBar=1, index=3, powerSource=2, priorityLevel=4, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200004, name="掌心雷", isshow=1, skillBar=1, index=4, powerSource=2, priorityLevel=5, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200006, name="陨石", isshow=1, skillBar=1, index=6, powerSource=2, priorityLevel=6, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200013, name="爆炎", isshow=1, skillBar=1, index=12, powerSource=2, hurtDelay=500, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=7, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200014, name="冰封", isshow=1, skillBar=1, index=13, powerSource=2, priorityLevel=8, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200015, name="毒咒", isshow=1, skillBar=1, index=14, powerSource=2, priorityLevel=9, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200017, name="瞬间移动", type=0, group=0, isshow=1, skillBar=1, index=17, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_2, priorityLevel=0, set=1},
	{id=1200018, name="小挪移", type=0, group=0, isshow=1, skillBar=1, index=18, powerSource=0, targetType=8, assistType=local_assistType.assistType_2, priorityLevel=0},
	{id=1200019, name="毒炎", isshow=1, skillBar=1, index=19, powerSource=2, priorityLevel=10, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1300006, name="冰封箭", isshow=1, skillBar=1, index=13, priorityLevel=3, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1303001, name="召唤哥布林", group=3, isshow=1, skillBar=1, index=1, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_3, priorityLevel=99},
	{id=1303002, name="召唤石巨人", group=3, isshow=1, skillBar=1, index=2, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_3, priorityLevel=999},
	{id=1303003, name="召唤暗杀者", group=3, isshow=1, skillBar=1, index=3, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_3, priorityLevel=9999},
	{id=1303004, name="召唤雪人王", group=3, isshow=1, skillBar=1, index=4, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_3, priorityLevel=99999},
	{id=1303005, name="召唤暗黑骑士", group=3, isshow=1, skillBar=1, index=5, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_3, priorityLevel=999999},
	{id=1303006, name="召唤守护兽巴里", group=3, isshow=1, skillBar=1, index=6, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_3, priorityLevel=9999999},
	{id=1303007, name="召唤黄金斗士", group=3, isshow=1, skillBar=1, index=7, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_3, priorityLevel=99999999},
	{id=1030001, name="战士连击技能", type=0, group=2, skillBar=0, releaseType=2, targetAreaType=7, assistType=local_assistType.assistType_4, priorityLevel=5},
	{id=1030002, name="法师连击技能", type=0, group=2, skillBar=0, releaseType=2, targetAreaType=7, assistType=local_assistType.assistType_4, priorityLevel=5, set=1},
	{id=1030003, name="弓箭手连击技能", type=0, group=2, skillBar=0, releaseType=2, targetAreaType=7, assistType=local_assistType.assistType_4, priorityLevel=5, set=1},
	{id=1100006, name="霹雳回旋斩", isshow=1, skillBar=1, index=6, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=4, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1100008, name="袭风刺", isshow=1, skillBar=1, index=8, areaType=3, targetAreaType=3, priorityLevel=10, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1100009, name="雷霆裂闪", isshow=1, skillBar=1, index=9, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=98, targetNumber=1, comboType=local_comboType.comboType_2, vibration=1, vibrationCount={7,1,400,0.1,0.2,0,3,1}},
	{id=1100010, name="致命一击", isshow=1, skillBar=1, index=10, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=99, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200005, name="龙卷风", isshow=1, skillBar=1, index=5, powerSource=2, areaType=3, targetAreaType=3, assistType=local_assistType.assistType_5, priorityLevel=11, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200008, name="黑龙波", isshow=1, skillBar=1, index=8, powerSource=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=14, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200007, name="火龙", isshow=1, skillBar=1, index=7, powerSource=2, hurtDelay=500, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=10, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200009, name="毁灭烈焰", isshow=1, skillBar=1, index=9, powerSource=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=12, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200010, name="暴风雪术", isshow=1, skillBar=1, index=10, powerSource=2, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=13, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1200012, name="地狱火", isshow=1, skillBar=1, index=15, powerSource=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=15, comboType=local_comboType.comboType_2, vibration=1, vibrationCount={10,1,100,0.1,0.2,0,3,1}},
	{id=1200016, name="极光", isshow=1, skillBar=1, index=16, powerSource=2, areaType=3, targetAreaType=3, assistType=local_assistType.assistType_5, priorityLevel=16, comboType=local_comboType.comboType_2},
	{id=1300001, name="穿透箭", isshow=1, skillBar=1, index=8, areaType=7, targetAreaType=3, assistType=local_assistType.assistType_5, priorityLevel=2, targetNumber=1, comboType=local_comboType.comboType_2},
	{id=1300002, name="多重箭", isshow=2, skillBar=1, index=9, areaType=7, targetAreaType=5, assistType=local_assistType.assistType_5, priorityLevel=4, targetNumber=1, comboType=local_comboType.comboType_2, damageNumberLimit=3},
	{id=1300007, name="五重箭", isshow=1, skillBar=1, index=14, areaType=7, targetAreaType=5, assistType=local_assistType.assistType_5, priorityLevel=5, targetNumber=1, comboType=local_comboType.comboType_2, damageNumberLimit=5},
	{id=1300005, name="治疗", isshow=1, skillBar=1, index=12, powerSource=0, targetType=8, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_7, priorityLevel=0},
	{id=1300003, name="战神之力", isshow=1, skillBar=1, index=10, powerSource=0, targetType=8, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_6, priorityLevel=9999},
	{id=1300004, name="守护之光", isshow=1, skillBar=1, index=11, powerSource=0, targetType=8, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_6, priorityLevel=999},
	{id=1200011, name="守护之魂", isshow=1, skillBar=1, index=11, powerSource=0, targetType=8, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_6, priorityLevel=99},
	{id=1100007, name="生命之光", isshow=1, skillBar=1, index=7, powerSource=0, targetType=8, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_6, priorityLevel=99, set=1},
	{id=1004019, name="天雷闪", isshow=2, skillBar=1, index=19, areaType=7, targetAreaType=5, assistType=local_assistType.assistType_5, priorityLevel=5, comboType=local_comboType.comboType_2},
	{id=1004020, name="玄月斩", isshow=1, skillBar=1, index=20, areaType=3, assistType=local_assistType.assistType_5, priorityLevel=28, comboType=local_comboType.comboType_2},
	{id=1004021, name="火剑袭", isshow=1, skillBar=1, index=17, areaType=7, targetAreaType=5, assistType=local_assistType.assistType_5, priorityLevel=40, comboType=local_comboType.comboType_2},
	{id=1004022, name="闪电轰顶", isshow=1, skillBar=1, index=22, powerSource=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=35, comboType=local_comboType.comboType_2},
	{id=1004023, name="暗影突袭", isshow=1, skillBar=1, index=23, powerSource=0, targetType=4, releaseType=2, priorityLevel=25},
	{id=1020064, name="召唤兽4级普攻", type=0, group=0},
	{id=1020065, name="召唤兽5级普攻", type=0, group=0},
	{id=1014035, name="守护治疗", index=6, powerSource=0, targetType=4, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_7, priorityLevel=80},
	{id=1000011, name="大天使攻速主动技能", group=5, isshow=2, skillBar=1, index=99, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=99},
	{id=1000012, name="大天使暴击主动技能", group=5, isshow=2, skillBar=1, index=99, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=99},
	{id=1000013, name="大天使减伤主动技能", group=5, isshow=2, skillBar=1, index=99, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=99},
	{id=2000011, name="变身卡牌地狱角魔主动技能，单体伤害", isshow=0, priorityLevel=2, set=1},
	{id=2000021, name="变身卡牌水晶鹿主动技能，瞬移", isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_2, priorityLevel=0, set=1},
	{id=2000031, name="变身卡牌泰克图斯主动技能，范围伤害，伤害减免，降低自身移速", isshow=0, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=2, set=1},
	{id=2000041, name="变身卡牌丛林召唤者主动技能，提升攻速", isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=99, set=1},
	{id=2000051, name="变身卡牌大恶魔主动技能，突进目标范围伤害", isshow=0, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=2, set=1},
	{id=2000052, name="变身卡牌大恶魔主动技能，单体伤害，附带持续伤害", isshow=0, priorityLevel=3, set=1},
	{id=2000061, name="变身卡牌天使审判长主动技能，护盾", isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=99, set=1},
	{id=2000062, name="变身卡牌天使审判长主动技能，直线范围伤害", isshow=0, areaType=3, targetAreaType=3, assistType=local_assistType.assistType_5, priorityLevel=2, set=1},
	{id=2200011, name="变身卡牌地狱角魔被动技能，自身周围每秒持续伤害", type=1, isshow=0, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=0, set=1},
	{id=2200021, name="变身卡牌水晶鹿被动技能，移速加成", type=1, isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=0, set=1},
	{id=2200031, name="变身卡牌泰克图斯被动技能，伤害吸收", type=1, isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=0, set=1},
	{id=2200032, name="变身卡牌泰克图斯被动技能，目标伤害降低", type=1, isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=0, set=1},
	{id=2200041, name="变身卡牌丛林召唤者被动技能，伤害加成", type=1, isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=0, set=1},
	{id=2200042, name="变身卡牌丛林召唤者被动技能，目标伤害加深", type=1, isshow=0, powerSource=0, assistType=local_assistType.assistType_6, priorityLevel=0, set=1},
	{id=2200051, name="变身卡牌大恶魔被动技能，受到控制后免控", type=1, isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=0, set=1},
	{id=2200052, name="变身卡牌大恶魔被动技能，对满血目标首次百分比伤害", type=1, isshow=0, assistType=local_assistType.assistType_6, priorityLevel=0, set=1},
	{id=2200061, name="变身卡牌天使审判长被动技能，每秒生命回复", type=1, isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_7, priorityLevel=0, set=1},
	{id=2200062, name="变身卡牌天使审判长被动技能，伤害转化生命回复", type=1, isshow=0, powerSource=0, targetType=4, releaseType=2, assistType=local_assistType.assistType_7, priorityLevel=0, set=1},
	{id=2040011, name="变身卡牌地狱角魔普通攻击", group=4, isshow=0, areaType=7, targetAreaType=7, set=1},
	{id=2040021, name="变身卡牌水晶鹿普通攻击", group=4, isshow=0, areaType=7, targetAreaType=7, set=1},
	{id=2040031, name="变身卡牌泰克图斯普通攻击", group=4, isshow=0, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, set=1},
	{id=2040041, name="变身卡牌丛林召唤者普通攻击", group=4, isshow=0, areaType=3, targetAreaType=3, assistType=local_assistType.assistType_5, set=1},
	{id=2040051, name="变身卡牌大恶魔普通攻击", group=4, isshow=0, areaType=3, targetAreaType=3, assistType=local_assistType.assistType_5, set=1},
	{id=2040061, name="变身卡牌天使审判长普通攻击", group=4, isshow=0, targetAreaType=7, assistType=local_assistType.assistType_5, set=1},
	{id=1020001, name="怪物一格普攻", type=0, group=0},
	{id=1020002, name="幼龙喷火", type=0, group=0},
	{id=1020003, name="黑巫师陨石术", type=0, group=0},
	{id=1020004, name="怪物二格普攻", type=0, group=0},
	{id=1020005, name="偷猎者射击", type=0, group=0},
	{id=1020006, name="寒冰魔冰封", type=0, group=0},
	{id=1020007, name="雪人雪球", type=0, group=0},
	{id=1020009, name="毒虫放毒", type=0, group=0},
	{id=1020010, name="骷髅弓箭手射击", type=0, group=0},
	{id=1020011, name="地狱蜘蛛真空波", type=0, group=0},
	{id=1020012, name="怪物掌心雷", type=0, group=0},
	{id=1020013, name="毒牛怪放毒", type=0, group=0},
	{id=1020015, name="恶魔技能", type=0, group=0},
	{id=1020016, name="死神戈登掌心雷", type=0, group=0},
	{id=1020017, name="巴洛克地狱火陨石术", type=0, group=0, targetAreaType=7},
	{id=1020019, name="死亡美人鱼技能", type=0, group=0},
	{id=1020020, name="蓝翼海怪射击", type=0, group=0},
	{id=1020021, name="银弓海怪射击", type=0, group=0},
	{id=1020022, name="巫师王红色闪电", type=0, group=0},
	{id=1020025, name="铁轮战士射击", type=0, group=0},
	{id=1020026, name="破坏骑士震地", type=0, group=0, targetAreaType=7},
	{id=1020027, name="黑炎魔技能", type=0, group=0},
	{id=1020032, name="丛林残暴者", type=0, group=0},
	{id=1020033, name="丛林女巫师技能", type=0, group=0},
	{id=1020036, name="阿卡摩斯粒子射击", type=0, group=0},
	{id=1020037, name="恶灵/恶灵王毁灭烈焰", type=0, group=0, targetAreaType=7},
	{id=1020038, name="风后暴风雪", type=0, group=0, targetAreaType=7},
	{id=1020039, name="蓝/红魔龙喷射", type=0, group=0},
	{id=1020040, name="蓝/红魔龙毁灭烈焰", type=0, group=0, targetAreaType=7},
	{id=1020043, name="金甲兽射击", type=0, group=0},
	{id=1020044, name="半兽人普攻", type=0, group=0},
	{id=1020045, name="刀刃猎手普攻", type=0, group=0},
	{id=1020046, name="寒冰刺客射击", type=0, group=0},
	{id=1020047, name="狂巨人普攻", type=0, group=0},
	{id=1020049, name="屠杀者普攻", type=0, group=0},
	{id=1020050, name="假面巫龙卷风", type=0, group=0, targetAreaType=3},
	{id=1020051, name="假面巫黑龙波", type=0, group=0, targetAreaType=7},
	{id=1020052, name="毒步妖普攻", type=0, group=0},
	{id=1020053, name="恐惧天使普攻", type=0, group=0},
	{id=1020058, name="召唤兽近战攻击", type=0, group=0},
	{id=1020059, name="召唤兽黄金斗士射击", type=0, group=0},
	{id=1020060, name="召唤萨迪洛斯攻击", type=0, group=0},
	{id=1020061, name="鬼魅/剧毒鬼魅普攻", type=0, group=0},
	{id=1020062, name="赤血要塞能量球", type=0, group=0, powerSource=2},
	{id=1020008, name="冰后三重真空波", type=0, group=0, targetAreaType=5},
	{id=1020014, name="魔鬼戈登龙卷风", type=0, group=0, areaType=3, targetAreaType=3},
	{id=1020018, name="巴洛克群体普攻", type=0, group=0, targetAreaType=7},
	{id=1020023, name="海魔希特拉极光", type=0, group=0, targetAreaType=3},
	{id=1020024, name="海魔希特拉范围极光", type=0, group=0, targetAreaType=7},
	{id=1020028, name="炽炎魔毁灭烈焰", type=0, group=0, targetAreaType=7},
	{id=1020029, name="炽炎魔爆炎", type=0, group=0, targetAreaType=7},
	{id=1020030, name="魔王扎坎震地", type=0, group=0, targetAreaType=7},
	{id=1020031, name="魔王扎坎飞剑", type=0, group=0, targetAreaType=7},
	{id=1020034, name="丛林召唤者火焰龙卷风", type=0, group=0, targetAreaType=7},
	{id=1020035, name="林召唤者火焰极光", type=0, group=0, targetAreaType=3},
	{id=1020041, name="幻影骑士技能", type=0, group=0, targetAreaType=7},
	{id=1020042, name="菲尼斯扇形火焰", type=0, group=0, targetAreaType=5},
	{id=1020048, name="疯魔群体普攻", type=0, group=0, targetAreaType=7},
	{id=1020054, name="咒怨魔王5格群体普攻", type=0, group=0, targetAreaType=7},
	{id=1020055, name="咒怨魔王2格群体普攻", type=0, group=0, targetAreaType=7},
	{id=1020056, name="玛雅之手5格群体普攻", type=0, group=0, targetAreaType=7},
	{id=1020057, name="玛雅之手2格群体普攻", type=0, group=0, targetAreaType=7},
	{id=1020067, name="BOSS六格普攻", type=0, group=0},
	{id=1020066, name="火龙王攻击技能（额外5%最大生命值伤害）", type=0, group=0, areaType=3},
	{id=1040001, name="突袭（大师技）", isshow=2, index=20, priorityLevel=25},
	{id=1040002, name="血腥风暴（大师技）", isshow=2, index=20, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=50},
	{id=1040003, name="格挡（大师技）", isshow=2, index=20, powerSource=0, targetType=4, releaseType=2, priorityLevel=25},
	{id=1040004, name="坚固的庇护（大师技）", isshow=2, index=20, powerSource=0, targetType=4, releaseType=2, areaType=7, targetAreaType=7, priorityLevel=30},
	{id=1040005, name="极光（大师技）", isshow=2, index=20, powerSource=2, priorityLevel=25},
	{id=1040006, name="爆炎（大师技）", isshow=2, index=20, powerSource=2, priorityLevel=25},
	{id=1040007, name="流星石（大师技）", isshow=2, index=20, powerSource=0, targetType=4, releaseType=2, priorityLevel=25},
	{id=1040008, name="毒炎术（大师技）", isshow=2, index=20, priorityLevel=25},
	{id=1040009, name="掌心雷（大师技）", isshow=2, index=20, priorityLevel=25},
	{id=1040010, name="地牢术（大师技）", isshow=2, index=20, powerSource=0, targetType=4, releaseType=2, priorityLevel=25},
	{id=1040011, name="闪避（大师技）", isshow=2, index=20, powerSource=0, targetType=4, releaseType=2, priorityLevel=25},
	{id=1040012, name="聚击（大师技）", isshow=2, index=20, priorityLevel=25},
	{id=1040013, name="毒箭（大师技）", isshow=2, index=20, targetType=4, releaseType=2, priorityLevel=25},
	{id=1040014, name="祝福（大师技）", type=0, group=0, isshow=2, index=20, powerSource=2, targetType=4, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=5},
	{id=1040015, name="组队治疗（大师技）", group=0, isshow=2, index=20, powerSource=0, targetType=4, priorityLevel=5},
	{id=1040016, name="幻影（大师技）", isshow=2, index=20, powerSource=0, targetType=8, areaType=7, targetAreaType=7, priorityLevel=25},
	{id=1040017, name="极限（大师技）", isshow=2, index=20, powerSource=2, targetAreaType=3, assistType=local_assistType.assistType_5, priorityLevel=25},
	{id=1040018, name="暗爆炎（大师技）", isshow=2, index=20, powerSource=2, priorityLevel=25},
	{id=1040019, name="冰封血（大师技）", isshow=2, index=20, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=25},
	{id=1040020, name="魔魂之握（大师技）", isshow=2, index=20, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=25},
	{id=1040021, name="暗影突袭（大师技）", isshow=2, index=20, powerSource=2, priorityLevel=25},
	{id=1040022, name="小挪移（大师技）", isshow=2, index=20, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=25},
	{id=1014005, name="圣盾防御（大师技）", group=0, isshow=2, index=20, powerSource=0, targetType=4, priorityLevel=5},
	{id=1012020, name="法神附体", type=0, group=0, isshow=1, skillBar=1, index=20, powerSource=0, targetType=4, releaseType=2, areaType=7, assistType=local_assistType.assistType_6, priorityLevel=5, set=1},
	{id=1040023, name="坐骑被动技能", type=1, isshow=0, index=30, priorityLevel=25},
	{id=1000001, name="坐骑主动技能袭风刺", type=0, group=0, isshow=2, index=30, areaType=7, targetAreaType=7, priorityLevel=25},
	{id=1000002, name="坐骑主动技能毁灭烈焰", type=0, group=0, isshow=2, index=30, powerSource=2, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=30},
	{id=1014010, name="致命圣印", isshow=1, skillBar=1, index=6, powerSource=0, targetType=8, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_6, priorityLevel=5},
	{id=1014012, name="冲击波", isshow=1, skillBar=1, index=1, hurtDelay=250, priorityLevel=15, targetNumber=1},
	{id=1014013, name="炎狼闪电链", group=0, isshow=1, index=9, hurtDelay=250, assistType=local_assistType.assistType_5, priorityLevel=5},
	{id=1014015, name="摄魂咒", group=0, isshow=1, index=10, powerSource=2, hurtDelay=250, priorityLevel=18},
	{id=1014017, name="伤害反射", group=0, isshow=1, index=6, powerSource=0, targetType=4, hurtDelay=250, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=0, targetNumber=1},
	{id=1014018, name="狂爆术", group=0, isshow=1, index=7, powerSource=0, targetType=4, hurtDelay=250, assistType=local_assistType.assistType_6, priorityLevel=5, set=1},
	{id=1014025, name="防御值恢复", group=0, isshow=1, index=12, powerSource=0, targetType=4, hurtDelay=250, assistType=local_assistType.assistType_6, priorityLevel=5},
	{id=1014029, name="专属宠物：天鹰", type=0, group=0, hurtDelay=250, assistType=local_assistType.assistType_3, priorityLevel=5},
	{id=1014030, name="血腥风暴", isshow=0, index=12, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=50},
	{id=1014031, name="流星石", isshow=0, index=12, powerSource=2, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=50},
	{id=1014032, name="天崩", isshow=2, index=12, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=2},
	{id=1014033, name="地震", isshow=2, index=12, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=2},
	{id=1014034, name="海啸", isshow=2, index=12, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=2},
	{id=1014011, name="圣极光", isshow=1, skillBar=1, index=8, hurtDelay=250, areaType=3, targetAreaType=3, assistType=local_assistType.assistType_5, priorityLevel=5},
	{id=1014016, name="链雷咒", group=0, isshow=1, index=10, powerSource=2, hurtDelay=250, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=25},
	{id=1014019, name="虚弱阵", isshow=1, skillBar=1, index=5, powerSource=0, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=5},
	{id=1014020, name="破御阵", isshow=1, skillBar=1, index=4, powerSource=0, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=5},
	{id=1014021, name="爆裂击", group=0, isshow=1, index=8, powerSource=2, hurtDelay=250, areaType=7, assistType=local_assistType.assistType_5, priorityLevel=19},
	{id=1014022, name="刺袭", group=0, isshow=1, index=12, powerSource=2, hurtDelay=250, areaType=7, assistType=local_assistType.assistType_5, priorityLevel=20},
	{id=1014023, name="污染", group=0, isshow=1, index=12, powerSource=2, hurtDelay=250, areaType=5, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=25},
	{id=1014024, name="烈光闪", group=0, isshow=1, index=12, powerSource=2, hurtDelay=250, areaType=7, assistType=local_assistType.assistType_5, priorityLevel=24},
	{id=1014000, name="魔剑士普通攻击", type=0, group=4, isshow=1, index=1, hurtDelay=250},
	{id=1014028, name="暴风雪术(大师技)", group=0, isshow=2, index=17, powerSource=2, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_2, priorityLevel=0, targetNumber=0},
	{id=1400001, name="宝石被动技能（测试）", type=1, isshow=0, hurtDelay=250},
	{id=1016005, name="链雷咒", isshow=1, skillBar=1, index=5, powerSource=2, hurtDelay=250, targetAreaType=7, priorityLevel=25},
	{id=1016006, name="狂暴术", isshow=1, skillBar=1, index=6, powerSource=0, targetType=4, hurtDelay=250, releaseType=2, priorityLevel=0, targetNumber=1, set=1, isroulette=1},
	{id=1016007, name="昏睡术", isshow=1, skillBar=1, index=7, powerSource=2, hurtDelay=250, areaType=3, targetAreaType=3, priorityLevel=5, targetNumber=1},
	{id=1016008, name="烈袭", isshow=1, skillBar=1, index=8, powerSource=2, hurtDelay=250, areaType=7, targetAreaType=7, priorityLevel=11, targetNumber=1},
	{id=1016009, name="影煞", isshow=1, skillBar=1, index=9, powerSource=2, hurtDelay=250, assistType=local_assistType.assistType_5, priorityLevel=10, targetNumber=1},
	{id=1016010, name="聚灵", isshow=1, skillBar=1, index=10, powerSource=2, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=10, targetNumber=1},
	{id=1016011, name="烈光闪", isshow=1, skillBar=1, index=11, powerSource=2, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=24},
	{id=1016012, name="恶灵召唤", isshow=1, skillBar=1, index=12, powerSource=2, hurtDelay=250, areaType=5, targetAreaType=5, assistType=local_assistType.assistType_8, priorityLevel=99, targetNumber=1},
	{id=1016013, name="黑暗镇魂曲", isshow=1, skillBar=0, index=13, powerSource=0, targetType=4, hurtDelay=250, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=0, targetNumber=1, set=1, isroulette=1},
	{id=1016014, name="水幻兽", isshow=1, skillBar=1, index=14, powerSource=2, hurtDelay=250, assistType=local_assistType.assistType_8, priorityLevel=6, targetNumber=1},
	{id=1016015, name="伤害反射", isshow=1, skillBar=1, index=15, powerSource=0, targetType=8, hurtDelay=250, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_6, priorityLevel=0, targetNumber=1},
	{id=1016016, name="魔隐者", isshow=1, skillBar=1, index=16, powerSource=2, targetType=4, hurtDelay=250, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=0, targetNumber=1},
	{id=1016017, name="恶灵召唤普通攻击1", type=0, group=0, powerSource=0, hurtDelay=250, assistType=local_assistType.assistType_8, priorityLevel=97, targetNumber=1},
	{id=1016018, name="恶灵召唤普通攻击2", type=0, group=0, powerSource=0, hurtDelay=250, assistType=local_assistType.assistType_8, priorityLevel=98, targetNumber=1},
	{id=1016019, name="恶灵召唤普通攻击3", type=0, group=0, powerSource=0, hurtDelay=250, assistType=local_assistType.assistType_8, priorityLevel=99, targetNumber=1},
	{id=1014014, name="火舞旋风", isshow=1, skillBar=1, index=4, hurtDelay=250, areaType=7, targetAreaType=5, assistType=local_assistType.assistType_5, targetNumber=1},
	{id=1014026, name="黑暗之力", isshow=1, skillBar=1, index=3, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=50, targetNumber=1},
	{id=1005001, name="星云火链", isshow=1, skillBar=1, index=2, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, targetNumber=1},
	{id=1005002, name="地裂", isshow=1, skillBar=1, index=5, hurtDelay=250, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=45, targetNumber=1},
	{id=1020068, name="新手怪物一格普功", type=0, group=0},
	{id=1020070, name="新手黑巫师陨石术", type=0, group=0},
	{id=1020071, name="新手怪物二格普攻", type=0, group=0},
	{id=1020069, name="新手偷猎者射击", type=0, group=0},
	{id=1014009, name="冲击", isshow=0, skillBar=1, index=1, priorityLevel=14, targetNumber=1},
	{id=1005003, name="圣盾防御", isshow=2, skillBar=1, index=4, powerSource=0, targetType=4, hurtDelay=250, releaseType=2, assistType=local_assistType.assistType_6, priorityLevel=99},
	{id=1005005, name="星辰一怒", isshow=1, skillBar=1, index=7, powerSource=2, hurtDelay=800, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=5},
	{id=1011000, name="剑士普通攻击", type=0, group=4, isshow=0, targetNumber=1},
	{id=1012000, name="魔法师普通攻击", type=0, group=4, isshow=0, index=1, targetNumber=1},
	{id=1015000, name="圣导普通攻击", type=0, group=4, isshow=0, index=1, targetNumber=1},
	{id=1016000, name="召唤普通攻击", type=0, group=4, isshow=0, index=1, targetNumber=1},
	{id=1007001, name="幻龙", isshow=2, skillBar=1, index=101, powerSource=2, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=55, targetNumber=1},
	{id=1007002, name="审判", isshow=2, skillBar=1, index=102, powerSource=2, targetAreaType=7, assistType=local_assistType.assistType_5, priorityLevel=66, targetNumber=1},
	{id=1007003, name="雷鸟", isshow=2, skillBar=1, index=103, powerSource=2, targetAreaType=3, assistType=local_assistType.assistType_5, priorityLevel=44, targetNumber=1},
	{id=1005006, name="无影箭", isshow=1, skillBar=1, index=12, powerSource=0, targetType=4, releaseType=2, areaType=7, targetAreaType=7, assistType=local_assistType.assistType_6, priorityLevel=0},
}

local defaults = {type=0, group=0, isshow=0, skillBar=0, index=0, powerSource=1, targetType=1, hurtDelay=350, releaseType=1, areaType=1, targetAreaType=1, assistType={1}, priorityLevel=1, targetNumber=0, set=0, isroulette=0, comboType={}, damageNumberLimit=0, vibration=0, vibrationCount={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_skill) do
	setmetatable(v, mt)
end

return cfg_skill
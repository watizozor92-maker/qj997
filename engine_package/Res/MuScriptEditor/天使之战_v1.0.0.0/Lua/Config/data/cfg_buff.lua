-- 此文件工具自动生成，不要修改
---@class cfg_buff_column
---技能id+两位编号
---@field id number @buff序号 column=1 A
---buff的名称
---@field name string @名称 column=2 B
---策划备注字段
---[[客户端不使用]]@field remark string @备注 column=3 C
---0或空，释放某个技能时触发
---1，攻击时触发      
---2，受到怪物伤害时触发
---3，受到玩家伤害时触发
---@field bufftrigger number @触发类型 column=4 D
---2.调整状态类（控制类）
---3.调整属性类（增益减益类）
---5.清除类Buff（清除控制or增益减益类）
---@field buffType number @buff类型 column=5 E
---buffType=2 格式:
---9禁锢 10防禁锢
---11眩晕12防眩晕
---15击退16防击退
---17瞬移18防瞬移
---23无敌24防无敌
---25滞空26防滞空
---29护盾
---31免死 41瞬移队友（内置）
---buffType=3(属性类) 格式:属性id(映射att_info属性表，支持多属性 如 （属性id#权重&属性id#权重|属性id#权重&属性id#权重；)
---buffType=5 格式：Buff组id（映射cfg_buff/group）
---@field buffParam IntListList @buff效果参数 column=6 F
---填0或空则无公式
---6.固定属性数值
---7、外置最终伤害公式：属性id*系数
---9、防护值恢复：属性id#比例（万分比）
---10、技能值恢复：属性id#比例（万分比）
---11、参数不生效（随便配置过校验），参数值计算走cfg_buff_Calculation
---12、治疗药水恢复计算公式：属性id#V值#比例（万分比）#回复次数
---13、魔力药水恢复计算公式：属性id#V值#比例（万分比）#回复次数
---[[客户端不使用]]@field buffCount IntList @buff计算公式 column=7 G
---格式:数值
---
---详细说明
---
---状态类
---buffType=2&buffParam=11(眩晕）buffValue格式为眩晕时间（毫秒）
---buffType=2&buffParam=15(击退) 则 buffValue格式为:击退格子数#方向来源#触发反方向概率百分比(1:伤害者 2:自身)#初始速度#目标速度（通过调节初始速度和目标速度修改击退速度变化效果，初始速度大于目标速度则由快倒慢，目标速度大于初始速度则由慢到快）
---buffType=2&buffParam=17(瞬移) 则 buffValue格式为:瞬移范围半径（根据角色朝向在该范围内随机瞬移）#瞬移延迟时间（秒）#是否隐藏模型（0不隐藏模型，1隐藏模型）#(瞬移出来的动画时间/100)
---buffType=2&buffParam=29(护盾) 则 buffValue格式为:护盾固定值#属性ID#属性系数（最终护盾指=固定值+角色当前属性*属性系数）系数单位为万比
---buffType=2&buffParam=41(瞬移队友) 则 buffValue格式为:瞬移延迟时间（秒）
---属性类
---根据计算公式填写格式
---清除类
---清除个数#清除层数
---
---@field buffValue IntListList @buff参数值 column=8 H
---0或空 范围内全部目标 1全部敌人 2全部友方(不包含自己) 3全部友方(包含自己) 4自己 5技能作用对象
---[[客户端不使用]]@field targetBuffObj number @buff目标对象 column=9 I
---buff效果延时获取
---格式
---为0或空不延时
---大于0为延时时间
---单位:毫秒
---(延迟时间是在总持续时间之内的)
---[[客户端不使用]]@field delayExecute number @buff获取延迟 column=10 J
---buff效果首次生效延时
---格式
---为0或空延时为intervalTime字段时间
---大于0为延时时间
---单位:毫秒
---[[客户端不使用]]@field buffEffectDelay number @buff首次生效延迟 column=11 K
---单位:毫秒；
---填-1表示永久Buff；
---buffTotalTime和intervalTime字段都为0时，为一次性Buff，立即执行，属性类buff只能生效生命值和法力值
---@field buffTotalTime number @Buff总持续时间 column=12 L
---单位:毫秒
---循环型buff此项必填 持续型选填(冷却)；
---buff效果为击退时 为每一步间隔时间；
---存在间隔时间时先施加Buff再执行间隔再生效Buff
---[[客户端不使用]]@field intervalTime number @buff间隔时间 column=13 M
---单位：万分比；不填默认为0
---[[客户端不使用]]@field Probability number @BUFF触发概率 column=14 N
---0或空不计算执行次数
---执行次数完成后原则上删除buff；地面Buff不进行次数计算
---@field excuteTimes number @Buff执行次数 column=15 O
---Buff叠加类型
---0：每次叠加都会刷新持续时间
---1：每次叠加都不会刷新持续时间
---2：叠加至上限后则不会刷新持续时间
---3：继承上一个BUFF时间
---不填默认为0
---[[客户端不使用]]@field floorsType number @Buff叠加类型 column=16 P
---Buff叠加层数上限
---不填或0则不能叠加
---@field floors number @Buff叠加层数 column=17 Q
---Buff组，用于清除BUFF标识
---[[客户端不使用]]@field group number @Buff组 column=18 R
---Buff标签，新增需要程序处理
---1.控制类
---[[客户端不使用]]@field tag string @Buff标签 column=19 S
---buff施加到身上播放一次
---对应cfg_model_effect表
---格式:特效编号1#特效编号2#特效编号3
---@field selfBeginEffect IntList @开始时播放 column=20 T
---循环buff执行效果时播放一次.
---对应cfg_model_effect表
---格式:特效编号1#特效编号2#特效编号3
---@field selfEffect IntList @执行播放 column=21 U
---buff持续时间内自身一直循环播放
---对应cfg_model_effect表
---格式:特效编号1#特效编号2#特效编号3
---@field selfSustainEffect IntList @持续播放 column=22 V
---buff持续时间内进行攻击播放一次，此特效播放时替换selfSustainEffect效果，播放结束后，恢复selfSustainEffect效果
---对应cfg_model_effect表
---格式:特效编号1#特效编号2#特效编号3
---播放层级:
---0 目标下
---1 目标上
---@field selfAttackEffect IntList @攻击时播放 column=23 W
---buff持续时间内受到攻击(掉血)播放一次，此特效播放时替换selfSustainEffect效果，播放结束后，恢复selfSustainEffect效果
---对应cfg_model_effect表
---格式:特效编号1#特效编号2#特效编号3
---@field selfBeAttackEffect IntList @被攻击时播放 column=24 X
---buff结束前播放一次
---对应cfg_model_effect表
---格式:特效编号1#特效编号2#特效编号3
---@field selfEndEffect IntList @结束前播放 column=25 Y
---cfg_skill_effect表
---格式:特效编号
---@field selfuseEffect number @引用技能特效 column=26 A
---Buff生效期间修改为对应怪物模型以及动画
---格式为:怪物id；目标模型（调用cfg_monster表id）
---@field modelChange number @模型变化 column=27 AA
---Buff生效期间缩放模型大小
---格式：万分比
---@field modelSize number @目标模型缩放 column=28 AB
---对应cfg_color表
---@field targetColor number @目标染色 column=29 AC
---不填不显示
---对应客户端的buff_Icon文件夹
---@field showIcon string @icon路径 column=30 AD
---显示在tips框首行
---@field buffName string @buff名称 column=31 AE
---点击buff图标显示具体tips文本；
---
---若buff文本中需要使用buffvalue中的相关数据，可使用%s代替
---%s填写规则：
---1、%s的取值为buffvalue中所填数据
---2、%s后面的数字1代表buffvalue 第一个数据，依次类推
---3、%s的位置可以随便放
---
---例如：（buffvalue = 201011#50|201021#30）
---buff文本描述：提升30~50的攻击力，则bufftext字段可填：提升%s4~%s2的攻击力
---@field buffText string @buff文本 column=32 AF
---伤害和治疗型buff专用.
---对应cfg_damage_number内的Id
---@field damageNumber number @飘血效果 column=33 AG
---角色下线时BUFF是否保存
---0：否
---1：是
---[[客户端不使用]]@field offlineSave number @BUFF下线是否保存 column=34 AH
---BUFF来源
---1.变身BUFF
---[[客户端不使用]]@field source number @BUFF来源 column=35 AI
---1不移除 0或空移除
---[[客户端不使用]]@field deathClean number @死亡是否移除 column=36 AJ

local local_buffParam = {
    buffParam_1={{206011,1},{201041,1},{207021,1},{202041,1},{205051,1},{208023,1}},
    buffParam_2={{207031,1}},
    buffParam_3={{208031,1}},
    buffParam_4={{931,1}},
    buffParam_5={},
    buffParam_6={{325012,1}},
    buffParam_7={{213022,1}},
    buffParam_8={{304012,1}},
    buffParam_9={{312012,1}},
    buffParam_10={{207022,1}},
    buffParam_11={{400006,1}},
    buffParam_12={{321012,1}},
    buffParam_13={{318022,1},{5000001,1}},
    buffParam_14={{400007,1}},
    buffParam_15={{318022,1}},
    buffParam_16={{313012,1}},
    buffParam_17={{311012,1}},
    buffParam_18={{1}},
    buffParam_19={{15}},
    buffParam_20={{206011,1}},
    buffParam_21={{200041,1}},
    buffParam_22={{9}},
    buffParam_23={{206032,1}},
    buffParam_24={{208023,1}},

}

local local_buffValue = {
    buffValue_1={{206011,20},{201041,20},{207021,50},{202041,40},{205051,20},{208023,25}},
    buffValue_2={},
    buffValue_3={{325012,3000}},
    buffValue_4={{213022,1000}},
    buffValue_5={{213022,2000}},
    buffValue_6={{400006,3000}},
    buffValue_7={{400006,6000}},
    buffValue_8={{321012,10000}},
    buffValue_9={{400007,1700}},
    buffValue_10={{400007,2000}},
    buffValue_11={{400007,3000}},
    buffValue_12={{400007,6000}},
    buffValue_13={{400006,10000}},
    buffValue_14={{99,1}},
    buffValue_15={{207011,-500}},
    buffValue_16={{312012,1500}},
    buffValue_17={{1,2,50,7,6}},
    buffValue_18={{1}},
    buffValue_19={{10003,1250}},
    buffValue_20={{1,2,0,7,6}},

}

local local_selfBeginEffect = {
    selfBeginEffect_1={},

}

local local_selfEffect = {
    selfEffect_1={},
    selfEffect_2={22},

}

local local_selfSustainEffect = {
    selfSustainEffect_1={},
    selfSustainEffect_2={1000011},
    selfSustainEffect_3={1000012},
    selfSustainEffect_4={1000013},
    selfSustainEffect_5={6},
    selfSustainEffect_6={30},
    selfSustainEffect_7={42},
    selfSustainEffect_8={60000020},

}

local local_selfAttackEffect = {
    selfAttackEffect_1={},

}

local local_selfBeAttackEffect = {
    selfBeAttackEffect_1={},

}

local local_selfEndEffect = {
    selfEndEffect_1={},

}

local cfg_buff =
{
	{id=83, name="安全区回血", buffParam={{207062,1}}, buffValue={{207062,1000}}, buffTotalTime=-1, showIcon="48", buffName="安全区回血", buffText="在安全区内，每秒回复10%最大生命值的血量", damageNumber=118},
	{id=84, name="安全区回蓝", buffParam={{208091,1}}, buffValue={{208091,1000}}, buffTotalTime=-1, showIcon="49", buffName="安全区回蓝", buffText="在安全区内，每秒回复10%最大魔法值的蓝量", damageNumber=119},
	{id=100, name="一格击退BUFF", buffType=2, buffParam=local_buffParam.buffParam_19, buffValue=local_buffValue.buffValue_17, buffTotalTime=0, excuteTimes=1},
	{id=10300002, name="新手BUFF", buffParam=local_buffParam.buffParam_1, buffValue=local_buffValue.buffValue_1, buffTotalTime=28800000, showIcon="53", buffName="新手buff", buffText="勇士新手buff，物理防御力增加20，物理攻击力增加20，魔法攻击力增加40，生命值+50，魔法值+25"},
	{id=10300003, name="新手BUFF(白银特权)", buffParam=local_buffParam.buffParam_1, buffValue=local_buffValue.buffValue_1, buffTotalTime=28800000, showIcon="53", buffName="新手buff(白银特权)", buffText="勇士新手buff，物理防御力增加20，物理攻击力增加20，魔法攻击力增加40，生命值+50，魔法值+25，死亡不消失"},
	{id=10400001, name="挂机保护buff", buffType=2, buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=-1, showIcon="30"},
	{id=20000002, name="小瓶治疗药水", buffParam=local_buffParam.buffParam_2, buffValue={{207011,10,2000,2}}, excuteTimes=2, showIcon="48", buffName="小瓶治疗药水", buffText="持续回复生命值", damageNumber=118},
	{id=20000202, name="中瓶治疗药水", buffParam=local_buffParam.buffParam_2, buffValue={{207011,20,3000,2}}, excuteTimes=2, showIcon="48", buffName="中瓶治疗药水", buffText="持续回复生命值", damageNumber=118},
	{id=20000302, name="大瓶治疗药水", buffParam=local_buffParam.buffParam_2, buffValue={{207011,30,4000,2}}, excuteTimes=2, showIcon="48", buffName="大瓶治疗药水", buffText="持续回复生命值", damageNumber=118},
	{id=20000312, name="超大治疗药水", buffParam=local_buffParam.buffParam_2, buffValue={{207011,40,5000,2}}, excuteTimes=2, showIcon="48", buffName="超大治疗药水", buffText="持续回复生命值", damageNumber=118},
	{id=20000322, name="小型精华治疗药水", buffParam=local_buffParam.buffParam_2, buffValue={{207011,10,4000,2}}, excuteTimes=2, showIcon="48", buffName="小型精华治疗药水", buffText="持续回复生命值", damageNumber=118},
	{id=20000332, name="中型精华治疗药水", buffParam=local_buffParam.buffParam_2, buffValue={{207011,20,5000,2}}, excuteTimes=2, showIcon="48", buffName="中型精华治疗药水", buffText="持续回复生命值", damageNumber=118},
	{id=20000342, name="大型精华治疗药水", buffParam=local_buffParam.buffParam_2, buffValue={{207011,30,6000,2}}, excuteTimes=2, showIcon="48", buffName="大型精华治疗药水", buffText="持续回复生命值", damageNumber=118},
	{id=20000352, name="超大精华治疗药水", buffParam=local_buffParam.buffParam_2, buffValue={{207011,40,7000,2}}, excuteTimes=2, showIcon="48", buffName="超大精华治疗药水", buffText="持续回复生命值", damageNumber=118},
	{id=20000362, name="神圣治疗药水持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,6800}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="神圣治疗药水持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000372, name="神圣治疗精华持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,10000}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="神圣治疗精华持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000373, name="登神治疗精华持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,13500}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="登神治疗精华持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000374, name="神域治疗精华持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,17000}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="神域治疗精华持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000375, name="创世治疗精华持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,20000}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="创世治疗精华持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000376, name="祝福治疗万灵药持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,24000}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="祝福治疗万灵药持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000377, name="神佑治疗万灵药持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,30000}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="神佑治疗万灵药持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000378, name="神圣治疗万灵药持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,32000}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="神圣治疗万灵药持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000379, name="神圣治疗万灵精华持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,40000}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="神圣治疗万灵精华持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000380, name="登神治疗万灵精华持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,48000}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="登神治疗万灵精华持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000381, name="神域治疗万灵精华持续", buffParam=local_buffParam.buffParam_2, buffValue={{207031,55000}}, buffTotalTime=4000, excuteTimes=3, showIcon="48", buffName="神域治疗万灵精华持续", buffText="持续回复生命值", damageNumber=118},
	{id=20000402, name="小瓶魔力药水", buffParam=local_buffParam.buffParam_3, buffValue={{208011,10,2000,2}}, excuteTimes=2, showIcon="49", buffName="小瓶魔力药水", buffText="持续回复魔法值", damageNumber=119},
	{id=20000502, name="中瓶魔力药水", buffParam=local_buffParam.buffParam_3, buffValue={{208011,20,3000,2}}, excuteTimes=2, showIcon="49", buffName="中瓶魔力药水", buffText="持续回复魔法值", damageNumber=119},
	{id=20000602, name="大瓶魔力药水", buffParam=local_buffParam.buffParam_3, buffValue={{208011,30,4000,2}}, excuteTimes=2, showIcon="49", buffName="大瓶魔力药水", buffText="持续回复魔法值", damageNumber=119},
	{id=20000612, name="精华魔力药水", buffParam=local_buffParam.buffParam_3, buffValue={{208011,40,5000,2}}, excuteTimes=2, showIcon="49", buffName="精华魔力药水", buffText="持续回复魔法值", damageNumber=119},
	{id=20000622, name="中型精华魔力药水", buffParam=local_buffParam.buffParam_3, buffValue={{208011,20,6000,2}}, excuteTimes=2, damageNumber=119},
	{id=20000632, name="大型精华魔力药水", buffParam=local_buffParam.buffParam_3, buffValue={{208011,30,7000,2}}, excuteTimes=2, damageNumber=119},
	{id=20000642, name="极效魔力药水持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,1600}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="极效魔力药水持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000652, name="祝福魔力药水持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,1700}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="祝福魔力药水持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000662, name="神佑魔力药水持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,1800}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神佑魔力药水持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000672, name="神圣魔力药水持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,1900}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神圣魔力药水持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000682, name="神圣魔力精华持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2000}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神圣魔力精华持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000683, name="登神魔力精华持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2100}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神圣魔力精华持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000684, name="神域魔力精华持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2200}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神圣魔力精华持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000685, name="创世魔力精华持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2300}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神圣魔力精华持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000686, name="祝福魔力万灵药持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2400}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="祝福魔力万灵药持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000687, name="神佑魔力万灵药持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2500}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神佑魔力万灵药持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000688, name="神圣魔力万灵药持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2600}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神圣魔力万灵药持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000689, name="神圣魔力万灵精华持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2700}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神圣魔力万灵精华持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000690, name="登神魔力万灵精华持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2800}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="登神魔力万灵精华持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000691, name="神域魔力万灵精华持续", buffParam=local_buffParam.buffParam_3, buffValue={{208011,2900}}, buffTotalTime=4000, excuteTimes=3, showIcon="49", buffName="神域魔力万灵精华持续", buffText="持续回复魔法值", damageNumber=119},
	{id=20000702, name="苹果", buffParam=local_buffParam.buffParam_2, buffValue={{207011,5,1000,2}}, excuteTimes=2, showIcon="48", buffName="苹果", buffText="持续回复生命值", damageNumber=118},
	{id=20000801, name="酒", buffParam=local_buffParam.buffParam_7, buffValue=local_buffValue.buffValue_4, buffTotalTime=0, showIcon="30", buffName="酒"},
	{id=20000901, name="防护值药水", buffParam={{301032,1}}, buffValue={{301032,2000}}, showIcon="30", buffName="防护值药水"},
	{id=20000902, name="守护治疗", buffParam={{207052,1}}, buffValue={{207052,1000}}, buffTotalTime=-1, targetColor=241, showIcon="48", buffName="守护治疗", buffText="回复智力属性除以5生命值", damageNumber=118},
	{id=20000903, name="小型防护药水", buffParam=local_buffParam.buffParam_4, buffValue={{931,1000}}, buffTotalTime=0, excuteTimes=1, showIcon="30", buffName="防护值药水"},
	{id=20000904, name="中型防护药水", buffParam=local_buffParam.buffParam_4, buffValue={{931,2000}}, buffTotalTime=0, excuteTimes=1, showIcon="30", buffName="防护值药水"},
	{id=20000905, name="大型防护药水", buffParam=local_buffParam.buffParam_4, buffValue={{931,3000}}, buffTotalTime=0, excuteTimes=1, showIcon="30", buffName="防护值药水"},
	{id=30000001, name="特权卡30天（废弃）", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=2592000000, showIcon="28", buffName="特权卡倒计时", buffText="开启一键拾取、随身商店、随\n身仓库"},
	{id=30000002, name="高级特权卡30天（废弃）", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=2592000000, showIcon="34", buffName="特权卡倒计时", buffText="开启一键拾取、随身商店、随\n身仓库、自动回收、自动买药"},
	{id=30000013, name="畅玩卡", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=0, showIcon="54", buffName="畅玩卡倒计时", buffText="\n激活后开启以下特权：\n<color=#00FF00>世界聊天\n随身商店\n随身仓库\n自动维修、买药\n自动回收、拾取\n交易行\n面对面交易\n材料解绑\n宝石解绑\n宝石爆率*200%</color>"},
	{id=30000014, name="黄金特权卡", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=0, showIcon="55", buffName="黄金特权卡倒计时", buffText="\n激活后开启以下特权：\n<color=#00FF00>交易行\n面对面交易\n黄金分线\n材料解绑\n宝石解绑\n宝石爆率*200%</color>"},
	{id=30030201, name="经验加成药水", buffParam=local_buffParam.buffParam_6, buffValue=local_buffValue.buffValue_3, buffTotalTime=86400000, showIcon="47", buffName="经验加成药水", buffText="杀怪经验提升30%"},
	{id=30030202, name="经验加成药水", buffParam=local_buffParam.buffParam_6, buffValue=local_buffValue.buffValue_3, buffTotalTime=-1, showIcon="47", buffName="经验加成药水", buffText="杀怪经验提升30%"},
	{id=30030203, name="经验加成药水", buffParam=local_buffParam.buffParam_6, buffValue=local_buffValue.buffValue_3, buffTotalTime=3600000, showIcon="47", buffName="经验加成药水", buffText="杀怪经验提升30%"},
	{id=30039701, name="大天使经验加成", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=60000, showIcon="47", buffText="大天使经验提升100%"},
	{id=30039702, name="大天使经验加成", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=86400000, showIcon="47", buffText="大天使经验提升100%"},
	{id=30040001, name="掉落2倍卡", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=86400000, showIcon="56", buffName="2倍宝石解绑卡", buffText="解绑宝石掉落\n额外增加<color=#00FF00>100%</color>宝石掉率"},
	{id=30040002, name="掉落4倍卡", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=86400000, showIcon="56", buffName="4倍宝石解绑卡", buffText="解绑宝石掉落\n额外增加<color=#00FF00>300%</color>宝石掉率"},
	{id=30040003, name="掉落6倍卡", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=86400000, showIcon="56", buffName="6倍宝石解绑卡", buffText="解绑宝石掉落\n额外增加<color=#00FF00>400%</color>宝石掉率"},
	{id=40000010, name="盒子特权——物理攻击增加", buffParam={{201041,1}}, buffValue={{201041,50}}, buffTotalTime=-1, buffName="物理攻击力+50"},
	{id=40000020, name="盒子特权——魔法攻击增加", buffParam={{202041,1}}, buffValue={{202041,50}}, buffTotalTime=-1, buffName="魔法攻击力+50"},
	{id=40000030, name="盒子特权——防御增加", buffParam=local_buffParam.buffParam_20, buffValue={{206011,50}}, buffTotalTime=-1, buffName="防御+50"},
	{id=100001101, name="攻速", buffParam=local_buffParam.buffParam_7, buffValue=local_buffValue.buffValue_5, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成", buffText="攻速加成20%"},
	{id=100001102, name="攻速2级", buffParam=local_buffParam.buffParam_7, buffValue={{213022,400}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成2级", buffText="攻速加成4%"},
	{id=100001103, name="攻速3级", buffParam=local_buffParam.buffParam_7, buffValue={{213022,600}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成3级", buffText="攻速加成6%"},
	{id=100001104, name="攻速4级", buffParam=local_buffParam.buffParam_7, buffValue={{213022,800}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成4级", buffText="攻速加成8%"},
	{id=100001105, name="攻速5级", buffParam=local_buffParam.buffParam_7, buffValue=local_buffValue.buffValue_4, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成5级", buffText="攻速加成10%"},
	{id=100001106, name="攻速6级", buffParam=local_buffParam.buffParam_7, buffValue={{213022,1200}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成6级", buffText="攻速加成12%"},
	{id=100001107, name="攻速7级", buffParam=local_buffParam.buffParam_7, buffValue={{213022,1400}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成7级", buffText="攻速加成14%"},
	{id=100001108, name="攻速8级", buffParam=local_buffParam.buffParam_7, buffValue={{213022,1600}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成8级", buffText="攻速加成16%"},
	{id=100001109, name="攻速9级", buffParam=local_buffParam.buffParam_7, buffValue={{213022,1800}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成9级", buffText="攻速加成18%"},
	{id=100001110, name="攻速10级", buffParam=local_buffParam.buffParam_7, buffValue=local_buffValue.buffValue_5, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_2, showIcon="30", buffName="攻速加成10级", buffText="攻速加成20%"},
	{id=100001201, name="双倍一击", buffParam=local_buffParam.buffParam_8, buffValue={{304012,2000}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成", buffText="双倍一击概率提升20%"},
	{id=100001202, name="双倍一击2级", buffParam=local_buffParam.buffParam_8, buffValue={{304012,300}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成2级", buffText="双倍一击概率提升3%"},
	{id=100001203, name="双倍一击3级", buffParam=local_buffParam.buffParam_8, buffValue={{304012,450}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成3级", buffText="双倍一击概率提升4.5%"},
	{id=100001204, name="双倍一击4级", buffParam=local_buffParam.buffParam_8, buffValue={{304012,600}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成4级", buffText="双倍一击概率提升6%"},
	{id=100001205, name="双倍一击5级", buffParam=local_buffParam.buffParam_8, buffValue={{304012,750}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成5级", buffText="双倍一击概率提升7.5%"},
	{id=100001206, name="双倍一击6级", buffParam=local_buffParam.buffParam_8, buffValue={{304012,900}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成6级", buffText="双倍一击概率提升9%"},
	{id=100001207, name="双倍一击7级", buffParam=local_buffParam.buffParam_8, buffValue={{304012,1050}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成7级", buffText="双倍一击概率提升10.5%"},
	{id=100001208, name="双倍一击8级", buffParam=local_buffParam.buffParam_8, buffValue={{304012,1200}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成8级", buffText="双倍一击概率提升12%"},
	{id=100001209, name="双倍一击9级", buffParam=local_buffParam.buffParam_8, buffValue={{304012,1350}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成9级", buffText="双倍一击概率提升13.5%"},
	{id=100001210, name="双倍一击10级", buffParam=local_buffParam.buffParam_8, buffValue={{304012,1500}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_3, showIcon="26", buffName="双倍一击加成10级", buffText="双倍一击概率提升15%"},
	{id=100001301, name="减伤", buffParam=local_buffParam.buffParam_9, buffValue={{312012,2000}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成", buffText="伤害减免20%"},
	{id=100001302, name="减伤2级", buffParam=local_buffParam.buffParam_9, buffValue={{312012,300}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成2级", buffText="伤害减免3%"},
	{id=100001303, name="减伤3级", buffParam=local_buffParam.buffParam_9, buffValue={{312012,450}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成3级", buffText="伤害减免4.5%"},
	{id=100001304, name="减伤4级", buffParam=local_buffParam.buffParam_9, buffValue={{312012,600}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成4级", buffText="伤害减免6%"},
	{id=100001305, name="减伤5级", buffParam=local_buffParam.buffParam_9, buffValue={{312012,750}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成5级", buffText="伤害减免7.5%"},
	{id=100001306, name="减伤6级", buffParam=local_buffParam.buffParam_9, buffValue={{312012,900}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成6级", buffText="伤害减免9%"},
	{id=100001307, name="减伤7级", buffParam=local_buffParam.buffParam_9, buffValue={{312012,1050}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成7级", buffText="伤害减免10.5%"},
	{id=100001308, name="减伤8级", buffParam=local_buffParam.buffParam_9, buffValue={{312012,1200}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成8级", buffText="伤害减免12%"},
	{id=100001309, name="减伤9级", buffParam=local_buffParam.buffParam_9, buffValue={{312012,1350}}, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成9级", buffText="伤害减免13.5%"},
	{id=100001310, name="减伤10级", buffParam=local_buffParam.buffParam_9, buffValue=local_buffValue.buffValue_16, buffTotalTime=10000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_4, showIcon="10", buffName="减伤加成10级", buffText="伤害减免15%"},
	{id=110000702, name="生命之光", buffParam=local_buffParam.buffParam_10, buffValue={{207022,1700}}, buffTotalTime=600000, floors=3, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_5, showIcon="26", buffName="生命之光", buffText="增加自身<color=#00FF00>16%</color>的生命上限"},
	{id=110000703, name="生命之光", buffParam=local_buffParam.buffParam_10, buffValue={{207022,2000}}, buffTotalTime=600000, floors=3, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_5, showIcon="26", buffName="生命之光", buffText="增加自身<color=#00FF00>18%</color>的生命上限"},
	{id=110000704, name="生命之光减少", buffParam={{312032,1}}, buffValue={{312032,3000}}, buffTotalTime=600000, showIcon="26", buffName="生命之光", buffText="受击时，有<color=#00FF00>5%</color>的概率减少<color=#00FF00>30%</color>的伤害。"},
	{id=110000705, name="生命之光减少", buffParam={{312042,1}}, buffValue={{312042,6000}}, buffTotalTime=600000, showIcon="26", buffName="生命之光", buffText="受击时，有<color=#00FF00>10%</color>的概率减少<color=#00FF00>60%</color>的伤害。"},
	{id=110000101, name="升龙击伤害加成", buffTotalTime=500, excuteTimes=1},
	{id=110000102, name="升龙击伤害加成", buffValue=local_buffValue.buffValue_7, buffTotalTime=500, excuteTimes=1},
	{id=110000201, name="地裂斩伤害加成", buffTotalTime=500, excuteTimes=1},
	{id=110000202, name="地裂斩伤害加成", buffValue=local_buffValue.buffValue_7, buffTotalTime=500, excuteTimes=1},
	{id=110000301, name="旋风斩伤害加成", buffTotalTime=500, excuteTimes=1},
	{id=110000302, name="旋风斩伤害加成", buffValue=local_buffValue.buffValue_7, buffTotalTime=500, excuteTimes=1},
	{id=110000401, name="牙突刺伤害加成", buffTotalTime=500, excuteTimes=1},
	{id=110000402, name="牙突刺伤害加成", buffValue=local_buffValue.buffValue_7, buffTotalTime=500, excuteTimes=1},
	{id=110000501, name="天地十字剑伤害加成", buffTotalTime=500, excuteTimes=1},
	{id=110000502, name="天地十字剑伤害加成", buffValue=local_buffValue.buffValue_7, buffTotalTime=500, excuteTimes=1},
	{id=110000601, name="霹雳回旋斩伤害加成", buffTotalTime=500, excuteTimes=1},
	{id=110000602, name="霹雳回旋斩伤害加成", buffValue=local_buffValue.buffValue_7, buffTotalTime=500, excuteTimes=1},
	{id=110000901, name="雷霆裂闪伤害加成", buffTotalTime=500, excuteTimes=1},
	{id=110000902, name="雷霆裂闪伤害加成", buffValue=local_buffValue.buffValue_7, buffTotalTime=500, excuteTimes=1},
	{id=110001001, name="致命一击伤害加成", buffTotalTime=500, excuteTimes=1},
	{id=110001002, name="致命一击伤害加成", buffValue=local_buffValue.buffValue_7, buffTotalTime=500, excuteTimes=1},
	{id=110001003, name="致命一击减速", buffParam=local_buffParam.buffParam_13, buffValue={{318022,-6000},{5000001,-6000}}, buffTotalTime=2500, targetColor=180, showIcon="45", buffName="致命一击减速", buffText="降低<color=#00FF00>60%</color>移动速度，共持续<color=#00FF00>2.5</color>秒"},
	{id=110000801, name="袭风刺冷却", buffParam=local_buffParam.buffParam_12, buffValue=local_buffValue.buffValue_8, buffTotalTime=500, excuteTimes=1},
	{id=110000802, name="袭风刺冷却", buffParam=local_buffParam.buffParam_12, buffValue=local_buffValue.buffValue_8, buffTotalTime=500, excuteTimes=1},
	{id=120001001, name="暴风雪减速", buffParam=local_buffParam.buffParam_13, buffValue={{318022,-2000},{5000001,-2000}}, buffTotalTime=1000, targetColor=180, showIcon="45", buffName="暴风雪减速", buffText="降低<color=#00FF00>20%</color>移动速度，共持续<color=#00FF00>1</color>秒"},
	{id=120001102, name="守护之魂", buffParam=local_buffParam.buffParam_14, buffValue=local_buffValue.buffValue_9, buffTotalTime=600000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_6, showIcon="10", buffName="守护之魂", buffText="减少17%受到的伤害，持续<color=#00FF00>10</color>分钟"},
	{id=120001103, name="守护之魂", buffParam=local_buffParam.buffParam_14, buffValue=local_buffValue.buffValue_10, buffTotalTime=600000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_6, showIcon="10", buffName="守护之魂", buffText="减少20%受到的伤害，持续<color=#00FF00>10</color>分钟"},
	{id=120001104, name="守护之魂减伤", buffParam=local_buffParam.buffParam_14, buffValue=local_buffValue.buffValue_11, buffTotalTime=600000, excuteTimes=1},
	{id=120001105, name="守护之魂减伤", buffParam=local_buffParam.buffParam_14, buffValue=local_buffValue.buffValue_12, buffTotalTime=600000, excuteTimes=1},
	{id=120001401, name="冰封减速", buffParam=local_buffParam.buffParam_13, buffValue={{318022,-5000},{5000001,-5000}}, buffTotalTime=2000, targetColor=180, showIcon="45", buffName="冰封减速", buffText="降低<color=#00FF00>50%</color>移动速度，共持续<color=#00FF00>2</color>秒"},
	{id=120001501, name="中毒", buffParam=local_buffParam.buffParam_2, buffValue={{10003,-300}}, buffTotalTime=15000, targetColor=241, showIcon="5", buffName="中毒", buffText="受到中毒效果，每3秒1次伤害，共持续<color=#00FF00>15</color>秒"},
	{id=120001502, name="中毒", buffParam=local_buffParam.buffParam_2, buffValue={{10003,-400}}, buffTotalTime=15000, targetColor=241, showIcon="5", buffName="中毒", buffText="受到中毒效果，每3秒1次伤害，共持续<color=#00FF00>15</color>秒"},
	{id=120001503, name="中毒", buffParam=local_buffParam.buffParam_2, buffValue={{10003,-500}}, buffTotalTime=15000, targetColor=241, showIcon="5", buffName="中毒", buffText="受到中毒效果，每3秒1次伤害，共持续<color=#00FF00>15</color>秒"},
	{id=120001701, name="瞬间移动瞬移", buffType=2, buffParam={{17}}, buffValue={{5,1,1,20}}, buffTotalTime=0, excuteTimes=1, selfEffect=local_selfEffect.selfEffect_2},
	{id=120001801, name="小挪移瞬移", buffType=2, buffParam={{41}}, buffValue=local_buffValue.buffValue_18, buffTotalTime=0, excuteTimes=1, selfEffect=local_selfEffect.selfEffect_2},
	{id=120000101, name="能量球伤害加成", excuteTimes=1},
	{id=120000102, name="能量球伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120000201, name="火球伤害加成", excuteTimes=1},
	{id=120000202, name="火球伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120000301, name="真空波伤害加成", excuteTimes=1},
	{id=120000302, name="真空波伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120000401, name="掌心雷伤害加成", excuteTimes=1},
	{id=120000402, name="掌心雷伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120000601, name="陨石伤害加成", excuteTimes=1},
	{id=120000602, name="陨石伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120001301, name="爆炎伤害加成", excuteTimes=1, selfuseEffect=26},
	{id=120001302, name="爆炎伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1, selfuseEffect=26},
	{id=120001402, name="冰封伤害加成", excuteTimes=1},
	{id=120001403, name="冰封伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120001504, name="毒咒伤害加成", excuteTimes=1},
	{id=120001505, name="毒咒伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120001601, name="极光伤害加成", excuteTimes=1},
	{id=120001602, name="极光伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120000501, name="龙卷风伤害加成", excuteTimes=1},
	{id=120000502, name="龙卷风伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120000701, name="火龙伤害加成", excuteTimes=1},
	{id=120000702, name="火龙伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120000801, name="黑龙波伤害加成", excuteTimes=1},
	{id=120000802, name="黑龙波伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120000901, name="毁灭烈焰伤害加成", excuteTimes=1},
	{id=120000902, name="毁灭烈焰伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120001002, name="暴风雪伤害加成", excuteTimes=1},
	{id=120001003, name="暴风雪伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=120001201, name="地狱火伤害加成", excuteTimes=1},
	{id=120001202, name="地狱火伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=130000501, name="治疗瞬间回复", buffParam={{207031,1},{207031,1}}, buffValue={{207031,5},{10003,2000}}, buffTotalTime=0, excuteTimes=1, damageNumber=118},
	{id=130000302, buffValue={{400006,900}}, buffTotalTime=600000, excuteTimes=1, showIcon="1", buffName="战神之力", buffText="增加自身<color=#00FF00>9%</color>的伤害加成，共持续<color=#00FF00>10</color>分钟"},
	{id=130000303, buffValue={{400006,1000}}, buffTotalTime=600000, excuteTimes=1, showIcon="1", buffName="战神之力", buffText="增加自身<color=#00FF00>10%</color>的伤害加成，共持续<color=#00FF00>10</color>分钟"},
	{id=130000304, buffValue={{400006,1200}}, buffTotalTime=600000, excuteTimes=1, showIcon="1", buffName="战神之力", buffText="增加自身<color=#00FF00>12%</color>的伤害加成，共持续<color=#00FF00>10</color>分钟"},
	{id=130000305, buffValue={{400006,1500}}, buffTotalTime=600000, excuteTimes=1, showIcon="1", buffName="战神之力", buffText="增加自身<color=#00FF00>15%</color>的伤害加成，共持续<color=#00FF00>10</color>分钟"},
	{id=130000101, name="四级穿透箭伤害加成", excuteTimes=1},
	{id=130000102, name="五级穿透箭伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=130000601, name="四级冰封箭伤害加成", excuteTimes=1},
	{id=130000602, name="五级冰封箭伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=130000603, name="冰封箭禁锢", buffType=2, buffParam={{11}}, buffValue={{1000}}, buffTotalTime=1000, targetColor=180, showIcon="3", buffName="冰封禁锢", buffText="无法移动，共持续<color=#00FF00>1</color>秒"},
	{id=130000201, name="四级多重箭伤害加成", excuteTimes=1},
	{id=130000202, name="五级多重箭伤害加成", buffValue=local_buffValue.buffValue_7, excuteTimes=1},
	{id=130000402, name="守护之光减伤", buffParam=local_buffParam.buffParam_14, buffValue=local_buffValue.buffValue_9, buffTotalTime=600000, excuteTimes=1, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_7, showIcon="32", buffName="守护之光减伤", buffText="减少<color=#00FF00>17%</color>受到的伤害，持续<color=#00FF00>10</color>分钟"},
	{id=130000403, name="守护之光减伤", buffParam=local_buffParam.buffParam_14, buffValue=local_buffValue.buffValue_10, buffTotalTime=600000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_7, showIcon="32", buffName="守护之光减伤", buffText="减少<color=#00FF00>20%</color>受到的伤害，持续<color=#00FF00>10</color>分钟"},
	{id=130000404, name="守护之光减伤", buffParam=local_buffParam.buffParam_14, buffValue=local_buffValue.buffValue_11, buffTotalTime=600000, showIcon="32", buffName="守护之光概率减伤", buffText="5%概率降低受到伤害的30%"},
	{id=130000405, name="守护之光减伤", buffParam=local_buffParam.buffParam_14, buffValue=local_buffValue.buffValue_12, buffTotalTime=600000, showIcon="32", buffName="守护之光概率减伤", buffText="10%概率降低受到伤害的60%"},
	{id=102006401, name="四级召唤兽攻击伤害加成", buffValue=local_buffValue.buffValue_13, buffTotalTime=-1, excuteTimes=1},
	{id=102006501, name="五级召唤兽攻击伤害加成", buffValue=local_buffValue.buffValue_13, buffTotalTime=-1, excuteTimes=1},
	{id=200003101, name="山崩地裂", buffParam={{318022,1},{313012,1}}, buffValue={{318022,-3000},{313012,1000}}, buffTotalTime=5000, excuteTimes=1},
	{id=200004101, name="急速咒印", buffParam=local_buffParam.buffParam_7, buffValue=local_buffValue.buffValue_4, buffTotalTime=5000, selfSustainEffect={3003}, showIcon="15", buffName="急速咒印", buffText="增加<color=#00FF00>10%</color>攻击速度"},
	{id=200006101, name="天使圣盾", buffType=2, buffParam={{29}}, buffValue={{0,207011,2000}}, buffTotalTime=5000, selfSustainEffect={3001}, showIcon="4", buffName="天使圣盾", buffText="获取<color=#00FF00>20%</color>最大生命值护盾"},
	{id=200005201, name="毁灭", buffParam=local_buffParam.buffParam_2, buffValue={{207011,-100}}, buffTotalTime=6000, excuteTimes=5, showIcon="46", buffName="毁灭", buffText="持续扣除<color=#00FF00>1%</color>最大生命值血量"},
	{id=220002101, name="轻盈敏捷", buffParam=local_buffParam.buffParam_15, buffValue={{318022,500}}, buffTotalTime=40000},
	{id=220002102, name="轻盈敏捷", buffParam=local_buffParam.buffParam_15, buffValue={{318022,800}}, buffTotalTime=40000},
	{id=220003101, name="铜皮铁骨", buffParam=local_buffParam.buffParam_16, buffValue={{313012,300}}, buffTotalTime=40000},
	{id=220003102, name="铜皮铁骨", buffParam=local_buffParam.buffParam_16, buffValue={{313012,500}}, buffTotalTime=40000},
	{id=220003201, name="恐惧使者", buffParam=local_buffParam.buffParam_9, buffValue={{312012,100}}, buffTotalTime=6000, floors=5, showIcon="19", buffName="恐惧使者", buffText="受到伤害降低<color=#00FF00>1%</color>，最多叠加<color=#00FF00>5</color>层"},
	{id=220004101, name="增幅咒印", buffParam=local_buffParam.buffParam_17, buffValue={{311012,300}}, buffTotalTime=40000},
	{id=220004102, name="增幅咒印", buffParam=local_buffParam.buffParam_17, buffValue={{311012,500}}, buffTotalTime=40000},
	{id=220004201, name="衰减咒印", buffParam=local_buffParam.buffParam_16, buffValue={{313012,-100}}, buffTotalTime=6000, floors=5, showIcon="38", buffName="衰减咒印", buffText="受到伤害加深<color=#00FF00>1%</color>，最多叠加<color=#00FF00>5</color>层"},
	{id=220005101, name="恶魔本能", buffType=5, buffParam=local_buffParam.buffParam_18, buffValue=local_buffValue.buffValue_14, buffTotalTime=0},
	{id=220005102, name="恶魔本能", buffType=5, buffParam=local_buffParam.buffParam_18, buffValue=local_buffValue.buffValue_14, buffTotalTime=0},
	{id=220005201, name="斩首", buffParam=local_buffParam.buffParam_2, buffValue=local_buffValue.buffValue_15, buffTotalTime=1000, excuteTimes=1},
	{id=220006101, name="自愈之光", buffParam=local_buffParam.buffParam_2, buffValue={{207011,100}}, buffTotalTime=-1, damageNumber=118},
	{id=220006102, name="自愈之光", buffParam=local_buffParam.buffParam_2, buffValue={{207011,200}}, buffTotalTime=-1, damageNumber=118},
	{id=220006201, name="生命夺取", buffParam={{5000013,1}}, buffValue={{5000013,500}}, buffTotalTime=40000, excuteTimes=1},
	{id=230000001, name="火龙攻击", buffParam=local_buffParam.buffParam_2, buffValue=local_buffValue.buffValue_15, buffTotalTime=0, excuteTimes=1},
	{id=100402301, name="暗影突袭", buffParam={{318011,1},{312052,1}}, buffValue={{318011,120},{312052,5000}}, buffTotalTime=4000, excuteTimes=1, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_8, showIcon="38", buffName="暗影突袭", buffText="1111"},
	{id=100402302, name="暗影突袭", buffType=5, buffParam=local_buffParam.buffParam_18, buffValue=local_buffValue.buffValue_14, buffTotalTime=4000, excuteTimes=1, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_8, showIcon="38", buffName="暗影突袭", buffText="1111"},
	{id=101601601, name="魔隐者", buffParam=local_buffParam.buffParam_9, buffValue=local_buffValue.buffValue_16, excuteTimes=1},
	{id=100500201, name="地裂", buffType=2, buffParam=local_buffParam.buffParam_19, buffValue=local_buffValue.buffValue_17, buffTotalTime=0},
	{id=100500202, name="地裂", buffType=2, buffParam=local_buffParam.buffParam_22, buffValue=local_buffValue.buffValue_18, buffTotalTime=5000},
	{id=110000701, name="生命之光", buffParam=local_buffParam.buffParam_10, buffValue=local_buffValue.buffValue_19, buffTotalTime=300000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_5, showIcon="26", buffName="生命之光", buffText="增加自身的生命上限%s"},
	{id=110000708, name="生命之光（精灵MM）", buffParam=local_buffParam.buffParam_10, buffValue=local_buffValue.buffValue_19, buffTotalTime=86400000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_5, showIcon="26", buffName="生命之光", buffText="增加自身的生命上限%s"},
	{id=120001101, name="守护之魂", buffParam=local_buffParam.buffParam_16, buffValue=local_buffValue.buffValue_19, buffTotalTime=300000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_6, showIcon="10", buffName="守护之魂", buffText="减少受到的伤害%s"},
	{id=120001108, name="守护之魂（精灵MM）", buffParam=local_buffParam.buffParam_16, buffValue=local_buffValue.buffValue_19, buffTotalTime=86400000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_6, showIcon="10", buffName="守护之魂", buffText="减少受到的伤害%s"},
	{id=130000401, name="守护之光", buffParam=local_buffParam.buffParam_20, buffValue=local_buffValue.buffValue_19, buffTotalTime=600000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_7, showIcon="32", buffName="守护之光减伤", buffText="增加自身防御力%s"},
	{id=130000408, name="守护之光（精灵MM）", buffParam=local_buffParam.buffParam_20, buffValue=local_buffValue.buffValue_19, buffTotalTime=86400000, selfSustainEffect=local_selfSustainEffect.selfSustainEffect_7, showIcon="32", buffName="守护之光减伤", buffText="增加自身防御力%s"},
	{id=130000301, buffParam=local_buffParam.buffParam_21, buffValue=local_buffValue.buffValue_19, buffTotalTime=600000, showIcon="1", buffName="战神之力", buffText="增加自身攻击力%s"},
	{id=130000308, name="战神之力（精灵MM）", buffParam=local_buffParam.buffParam_21, buffValue=local_buffValue.buffValue_19, buffTotalTime=86400000, showIcon="1", buffName="战神之力", buffText="增加自身攻击力%s"},
	{id=250001014, name="SD破盾BUFF", buffParam=local_buffParam.buffParam_5, buffValue=local_buffValue.buffValue_2, buffTotalTime=0, excuteTimes=10000, selfEffect={60000023}},
	{id=100500403, name="占领中", buffType=2, buffParam=local_buffParam.buffParam_22, buffValue={{0}}, buffTotalTime=3600000, excuteTimes=10000, showIcon="101", buffName="占领中", buffText="正在占领王座，无法移动，至死方休"},
	{id=100500406, name="占领中", buffType=2, buffParam={{16}}, buffValue={{3600000}}, buffTotalTime=3600000, excuteTimes=10000, showIcon="103", buffName="禁止击退", buffText="正在占领王座，禁止击退"},
	{id=240001003, name="圣盾防御", buffParam=local_buffParam.buffParam_23, buffValue={{206032,1000}}, buffTotalTime=5000, showIcon="32", buffName="圣盾防御", buffText="增加防御力10%"},
	{id=250001009, name="虚弱阵", buffParam={{200022,1}}, buffValue={{200022,-1500}}, buffTotalTime=15000, showIcon="33", buffName="虚弱阵", buffText="降低自身15%的攻击力"},
	{id=250001010, name="破御阵", buffParam=local_buffParam.buffParam_23, buffValue={{206032,-1500}}, buffTotalTime=15000, showIcon="33", buffName="破御阵", buffText="降低自身15%的防御力"},
	{id=1300000401, name="加速卷轴", buffParam={{500125,1},{500126,1}}, buffValue={{500125,15},{500126,15}}, buffTotalTime=86400000, floors=7, showIcon="3", buffName="加速卷轴", buffText="攻击速度+<color=#00FF00>15</color>\n持续1天\n重复使用可叠加时长\n最高叠加7天"},
	{id=1300000402, name="防御卷轴", buffParam=local_buffParam.buffParam_20, buffValue={{206011,40}}, buffTotalTime=86400000, floors=7, showIcon="4", buffName="防御卷轴", buffText="防御力+<color=#00FF00>40</color>\n持续1天\n重复使用可叠加时长\n最高叠加7天"},
	{id=1300000403, name="愤怒卷轴", buffParam=local_buffParam.buffParam_21, buffValue={{200041,30}}, buffTotalTime=86400000, floors=7, showIcon="1", buffName="愤怒卷轴", buffText="所有攻击力+<color=#00FF00>30</color>\n持续1天\n重复使用可叠加时长\n最高叠加7天"},
	{id=1300000404, name="魔力卷轴", buffParam=local_buffParam.buffParam_24, buffValue={{208023,500}}, buffTotalTime=86400000, floors=7, showIcon="6", buffName="魔力卷轴", buffText="魔法值+<color=#00FF00>500</color>\n持续1天\n重复使用可叠加时长\n最高叠加7天"},
	{id=1300000405, name="体力卷轴", buffParam={{207021,1}}, buffValue={{207021,200}}, buffTotalTime=86400000, floors=7, showIcon="8", buffName="体力卷轴", buffText="生命值+<color=#00FF00>200</color>\n持续1天\n重复使用可叠加时长\n最高叠加7天"},
	{id=1300000406, name="魔法卷轴", buffParam=local_buffParam.buffParam_24, buffValue={{208011,200}}, buffTotalTime=86400000, floors=7, showIcon="42", buffName="魔法卷轴", buffText="魔法值+<color=#00FF00>200</color>\n持续1小时\n重复使用可叠加时长"},
	{id=1300000407, name="幸运一击卷轴", buffParam={{305072,1}}, buffValue={{305072,40}}, buffTotalTime=86400000, showIcon="44", buffName="幸运一击卷轴", buffText="幸运一击伤害+<color=#00FF00>40</color>\n持续1小时\n重复使用可叠加时长"},
	{id=1300000408, name="卓越一击卷轴", buffParam={{303072,1}}, buffValue={{303072,40}}, buffTotalTime=86400000, showIcon="43", buffName="卓越一击卷轴", buffText="卓越一击伤害+<color=#00FF00>40</color>\n持续1小时\n重复使用可叠加时长"},
	{id=250001007, name="法神附体", buffParam={{202022,1}}, buffValue={{202021,2000}}, buffTotalTime=300000, selfSustainEffect={73}, showIcon="117", buffName="法神附体", buffText="提升自身20%最小魔法攻击力，持续5分钟"},
	{id=20000906, name="奇迹之魂", buffParam={{314016,1},{313012,1},{325012,1}}, buffValue={{314016,1000},{313012,500},{325012,1000}}, buffTotalTime=-1, showIcon="30", buffName="奇迹之魂", buffText="伤害提升10%，伤害吸收5%，经验提升10%"},
	{id=120000403, name="掌心雷一格击退BUFF", buffType=2, buffParam=local_buffParam.buffParam_19, buffValue=local_buffValue.buffValue_20, buffTotalTime=0, excuteTimes=1},
	{id=100500501, name="星辰一怒一格击退BUFF", buffType=2, buffParam=local_buffParam.buffParam_19, buffValue=local_buffValue.buffValue_20, buffTotalTime=0, excuteTimes=1},
}

local defaults = {name="战神之力", bufftrigger=0, buffType=3, buffParam={{400006,1}}, buffValue={{400006,3000}}, buffTotalTime=3000, excuteTimes=0, floors=0, selfBeginEffect={}, selfEffect={}, selfSustainEffect={}, selfAttackEffect={}, selfBeAttackEffect={}, selfEndEffect={}, selfuseEffect=0, modelChange=0, modelSize=0, targetColor=0, showIcon="", buffName="", buffText="", damageNumber=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_buff) do
	setmetatable(v, mt)
end

return cfg_buff
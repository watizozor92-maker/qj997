-- 此文件工具自动生成，不要修改
---@class cfg_skill_effects_column
---索引id
---@field id number @id column=1 A
---@field name string @技能名 column=2 B
---格式:特效1#特效2#特效3
---例如: 0#1#2
---引用cfg_model_effect表内的特效id
---@field releaseEffect IntList @施法特效 column=3 C
---格式:特效1模式#特效2模式#特效3模式
---说明:1跟随目标 2地面播放
---默认跟随地面
---@field releasePlayMode IntList @施法特效播放模式 column=4 D
---格式:特效1延迟#特效2延迟#特效3延迟
---单位:毫秒
---@field releaseDelayTime IntList @施法特效延迟 column=5 E
---0或空 没有
---1有
---编辑器读取
---{没有=0|有=1}
---@field flyAction number @是否有飞行动作 column=6 F
---有飞行动作生效
---0或空 主目标播放
---1主目标播放+副目标播放
---2副目标播放
---@field moreFly number @飞行多目标播放 column=7 G
---格式:万分比
---例如:
---填的是1000,万分比算下来就是10,也就是一秒钟飞过10格
---@field flySpeed IntList @飞行速度 column=8 H
---格式:是否强化#技能等级#特效Id
---例如: 0#1#2
---@field flyEffect IntList @飞行特效 column=9 I
---0或空：默认播放
---1：随机播放；
---格式：0#1;数量需要与特效数量一致
---@field effectRandom IntList @飞行特效播放模式 column=10 J
---格式:特效1延迟#特效2延迟#特效3延迟
---单位:毫秒
---@field flyDelayTime IntList @飞行特效延迟 column=11 K
---飞行特效到达目标位置后再往前飞一段距离后消失
---（目前只有雷鸟特效使用该字段）
---@field flyDelayDistance number @飞行特效消失延长距离 column=12 L
---0或空 不播放
---1播放
---编辑器读取
---{没有=0|有=1}
---@field targetAction number @是否播放目标特效 column=13 M
---0或空 主目标播放
---1主目标播放+副目标播放
---2副目标播放
---@field moreTarget number @多目标效果播放 column=14 N
--- 
---@field targetEffect IntList @主目标特效id column=15 O
---格式:特效1延迟#特效2延迟#特效3延迟
---单位:毫秒
---@field targetDelayTime IntList @主目标特效延迟 column=16 P
---格式:特效1模式#特效2模式#特效3模式
---说明:1跟随目标 2地面播放
---默认跟随地面
---@field targetEffectMode IntList @主目标特效模式 column=17 Q
---格式:特效1Id#特效2id#特效3id
---例如: 0#1#2
---@field otherTargetEffect IntList @副目标特效id column=18 R
---格式:特效1模式#特效2模式#特效3模式
---说明:1跟随目标 2地面播放
---默认跟随地面
---@field otherTargetEffectMode IntList @副目标特效模式 column=19 S
---格式:特效1延迟#特效2延迟#特效3延迟
---单位:毫秒
---@field othertargetDelayTime IntList @副目标特效延迟 column=20 T
---填写cfg_audio表对应的音效id
---空为不播放
---释放时，播放音效
---@field costSound number @释放音效 column=21 U
---填写cfg_audio表对应的音效id
---空为不播放
---释放时，播放音效
---@field hitSound number @打击音效 column=22 V
---填写cfg_audio表对应的音效id
---空为不播放
---释放时，播放音效
---@field flySound number @飞行音效 column=23 W

local local_releaseEffect = {
    releaseEffect_1={23,45},
    releaseEffect_2={},
    releaseEffect_3={4,32},
    releaseEffect_4={35},
    releaseEffect_5={44},
    releaseEffect_6={44,110},
    releaseEffect_7={145},
    releaseEffect_8={126},
    releaseEffect_9={127,128},
    releaseEffect_10={2011},
    releaseEffect_11={2024},
    releaseEffect_12={24,25},
    releaseEffect_13={30},
    releaseEffect_14={60000024,27},

}

local local_releasePlayMode = {
    releasePlayMode_1={},
    releasePlayMode_2={1},
    releasePlayMode_3={2,1},
    releasePlayMode_4={2},

}

local local_releaseDelayTime = {
    releaseDelayTime_1={},
    releaseDelayTime_2={400},
    releaseDelayTime_3={500,0},
    releaseDelayTime_4={200},
    releaseDelayTime_5={0},
    releaseDelayTime_6={300},
    releaseDelayTime_7={0,900},

}

local local_flySpeed = {
    flySpeed_1={},
    flySpeed_2={1000},
    flySpeed_3={800},
    flySpeed_4={400},

}

local local_flyEffect = {
    flyEffect_1={},
    flyEffect_2={36,47},
    flyEffect_3={84},
    flyEffect_4={85},
    flyEffect_5={86},
    flyEffect_6={87},
    flyEffect_7={88},
    flyEffect_8={89},
    flyEffect_9={90},
    flyEffect_10={91},
    flyEffect_11={92},
    flyEffect_12={108},
    flyEffect_13={109},
    flyEffect_14={111},
    flyEffect_15={117},
    flyEffect_16={115},
    flyEffect_17={113},
    flyEffect_18={38},
    flyEffect_19={77,77,77,77,77},
    flyEffect_20={78,78,78,78,78},
    flyEffect_21={74,74,74,74,74},
    flyEffect_22={79,79,79,79,79},
    flyEffect_23={76,76,76,76,76},
    flyEffect_24={75,75,75,75,75},
    flyEffect_25={112,112,112,112,112},
    flyEffect_26={118,118,118,118,118},
    flyEffect_27={116,116,116,116,116},
    flyEffect_28={114,114,114,114,114},
    flyEffect_29={15},
    flyEffect_30={2023},

}

local local_effectRandom = {
    effectRandom_1={},
    effectRandom_2={1,1,1,1,1},

}

local local_flyDelayTime = {
    flyDelayTime_1={},
    flyDelayTime_2={400},
    flyDelayTime_3={500,500,500},
    flyDelayTime_4={500,500},
    flyDelayTime_5={500},
    flyDelayTime_6={500,500,500,500,500},
    flyDelayTime_7={1000},
    flyDelayTime_8={200},

}

local local_targetEffect = {
    targetEffect_1={},
    targetEffect_2={39},
    targetEffect_3={16},
    targetEffect_4={103},
    targetEffect_5={28},
    targetEffect_6={2},
    targetEffect_7={14},
    targetEffect_8={8},
    targetEffect_9={105},

}

local local_targetDelayTime = {
    targetDelayTime_1={},
    targetDelayTime_2={400},
    targetDelayTime_3={500},
    targetDelayTime_4={0,500},
    targetDelayTime_5={300},

}

local local_targetEffectMode = {
    targetEffectMode_1={},
    targetEffectMode_2={1},
    targetEffectMode_3={2},
    targetEffectMode_4={2,1},

}

local local_otherTargetEffect = {
    otherTargetEffect_1={},
    otherTargetEffect_2={103},
    otherTargetEffect_3={28},

}

local local_otherTargetEffectMode = {
    otherTargetEffectMode_1={},
    otherTargetEffectMode_2={1},

}

local local_othertargetDelayTime = {
    othertargetDelayTime_1={},
    othertargetDelayTime_2={100},
    othertargetDelayTime_3={400},

}

local cfg_skill_effects =
{
	{id=1, name="普通攻击", flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2, name="致命一击", releaseEffect={1,46}, releaseDelayTime={450,400}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetEffect={2,3}, targetDelayTime={500,600}, targetEffectMode=local_targetEffectMode.targetEffectMode_4, otherTargetEffect={3}, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime={600}, costSound=50017},
	{id=3, name="雷霆裂闪", releaseEffect=local_releaseEffect.releaseEffect_3, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_3, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50014, hitSound=50015, flySound=50016},
	{id=4, name="旋风斩", releaseEffect={9}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50011},
	{id=5, name="袭风刺", releaseEffect={7,8}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_8, targetEffectMode=local_targetEffectMode.targetEffectMode_2, costSound=50013},
	{id=6, name="霹雳回旋斩", releaseEffect={11,33}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50011},
	{id=7, name="生命之光", releaseEffect={5,6}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50012},
	{id=8, name="升龙击", releaseEffect=local_releaseEffect.releaseEffect_1, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50028},
	{id=9, name="地裂斩", releaseEffect=local_releaseEffect.releaseEffect_1, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50008},
	{id=10, name="天地十字剑", releaseEffect=local_releaseEffect.releaseEffect_1, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50008},
	{id=11, name="火球", flyEffect={13}, flyDelayTime=local_flyDelayTime.flyDelayTime_2, targetAction=1, targetEffect=local_targetEffect.targetEffect_7, targetEffectMode=local_targetEffectMode.targetEffectMode_2, costSound=50018},
	{id=12, name="能量球", flyEffect=local_flyEffect.flyEffect_29, costSound=50018},
	{id=13, name="陨石", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_3, targetDelayTime=local_targetDelayTime.targetDelayTime_2, targetEffectMode=local_targetEffectMode.targetEffectMode_3, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_3, costSound=50020, hitSound=50021},
	{id=14, name="龙卷风", flySpeed={200}, flyEffect={17}, costSound=50024},
	{id=15, name="真空波", flyEffect={18}, costSound=50018},
	{id=16, name="掌心雷", flySpeed=local_flySpeed.flySpeed_4, flyEffect={19}, costSound=50019},
	{id=17, name="毁灭烈焰", releaseEffect={20}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_2, moreFly=1, flySpeed=local_flySpeed.flySpeed_1, costSound=50028},
	{id=18, name="黑龙波", releaseEffect={2102,2102,2102,2102,2102,2102,2103,2103,2103,2103,2103}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=2, targetEffect=local_targetEffect.targetEffect_6, targetDelayTime=local_targetDelayTime.targetDelayTime_3, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50025},
	{id=19, name="火龙", releaseDelayTime={1000}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={22}, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50023},
	{id=20, name="地狱火", releaseEffect=local_releaseEffect.releaseEffect_12, releaseDelayTime={800}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, flyDelayTime=local_flyDelayTime.flyDelayTime_2, costSound=50026},
	{id=21, name="毒咒", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={26}, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50031, hitSound=50032},
	{id=22, name="瞬间移动", releaseEffect=local_releaseEffect.releaseEffect_14, releasePlayMode=local_releasePlayMode.releasePlayMode_3, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_7, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50018},
	{id=23, name="冰封", releaseDelayTime=local_releaseDelayTime.releaseDelayTime_4, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_5, targetEffectMode=local_targetEffectMode.targetEffectMode_2, costSound=50022},
	{id=24, name="极光", releaseEffect={29}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=25, name="守护之魂", releaseEffect=local_releaseEffect.releaseEffect_13, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50027},
	{id=26, name="爆炎", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={31}, targetDelayTime=local_targetDelayTime.targetDelayTime_4, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50031, hitSound=50032},
	{id=27, name="暴风雪", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={34}, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50029, hitSound=50030},
	{id=28, name="穿透箭", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect=local_flyEffect.flyEffect_2, costSound=50038},
	{id=29, name="多重箭", moreFly=1, flyEffect={150,150,150}, costSound=50036},
	{id=30, name="召唤哥布林", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_2, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=31, name="召唤石巨人", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_2, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=32, name="召唤暗杀者", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_2, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=33, name="召唤雪人王", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_2, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=34, name="召唤黑骑士", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_2, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=35, name="召唤黄金斗士", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_2, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=36, name="召唤守护兽巴里", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_2, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=37, name="治疗", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetEffect={40}, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect={40}, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50037},
	{id=38, name="守护之光", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetEffect={41}, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect={41}, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50037},
	{id=39, name="战神之力", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetEffect={43}, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect={43}, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50037},
	{id=40, name="弓箭手普通攻击特效", flyEffect={37}},
	{id=41, name="五重箭", releaseEffect=local_releaseEffect.releaseEffect_6, moreFly=1, flyEffect={150,150,150,150,150}},
	{id=42, name="牙突刺", releaseEffect={45}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=43, name="雷霆裂闪（无需目标）", releaseEffect=local_releaseEffect.releaseEffect_3, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_3, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=44, name="陨石", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=2, targetEffect=local_targetEffect.targetEffect_3, targetDelayTime=local_targetDelayTime.targetDelayTime_2, targetEffectMode=local_targetEffectMode.targetEffectMode_3, otherTargetEffect={16}, otherTargetEffectMode={2}, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_3},
	{id=45, name="恶魔攻击", flyEffect={56}},
	{id=46, name="铁轮战士攻击", flySpeed={100}, flyEffect={57}, flyDelayTime=local_flyDelayTime.flyDelayTime_8},
	{id=47, name="寒冰刺客攻击特效", flyEffect=local_flyEffect.flyEffect_18, targetAction=1},
	{id=48, name="死亡美人鱼攻击", flyEffect={59}},
	{id=49, name="黑炎魔攻击", flyEffect={60}, targetAction=1, targetEffect={2010}, targetDelayTime=local_targetDelayTime.targetDelayTime_2},
	{id=50, name="猎犬步伐特效", releaseEffect={25}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_4, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=51, name="突刺特效", releaseEffect={7}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=52, name="狮子斩", releaseEffect=local_releaseEffect.releaseEffect_1, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=53, name="二连斩", releaseEffect=local_releaseEffect.releaseEffect_1, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=54, name="托普斯的力场", releaseEffect=local_releaseEffect.releaseEffect_1, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=55, name="拉满弓", releaseEffect=local_releaseEffect.releaseEffect_4, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_2, flyEffect=local_flyEffect.flyEffect_2, flyDelayTime={400,400}, targetAction=1, targetEffect={62}, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=56, name="落雷", flyEffect={66}, targetAction=1, moreTarget=1, targetEffect={63}, otherTargetEffect={63}},
	{id=57, name="卡利亚大剑", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={64}, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=58, name="恐惧", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={61}, targetDelayTime=local_targetDelayTime.targetDelayTime_2, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=59, name="守护兽巴里", releaseEffect={71}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50036},
	{id=60, name="多重箭红羽神弓", moreFly=1, flyEffect={74,74,74}, flyDelayTime=local_flyDelayTime.flyDelayTime_3, costSound=50036},
	{id=61, name="多重箭紫焰之弓", moreFly=1, flyEffect={75,75,75}, flyDelayTime=local_flyDelayTime.flyDelayTime_3, costSound=50036},
	{id=62, name="多重箭碧影魔弓", moreFly=1, flyEffect={76,76,76}, flyDelayTime=local_flyDelayTime.flyDelayTime_3, costSound=50036},
	{id=63, name="多重箭精灵之弓", moreFly=1, flyEffect={77,77,77}, flyDelayTime=local_flyDelayTime.flyDelayTime_3, costSound=50036},
	{id=64, name="多重箭玛雅神弓", moreFly=1, flyEffect={78,78,78}, flyDelayTime=local_flyDelayTime.flyDelayTime_3, costSound=50036},
	{id=65, name="穿透箭精灵之弓", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,81}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50036},
	{id=66, name="穿透箭玛雅神弓", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,82}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50036},
	{id=67, name="穿透箭红羽神弓", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,80}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50036},
	{id=68, name="冰封箭精灵之弓", flyEffect={81}, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=69, name="冰封箭玛雅神弓", flyEffect={82}, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=70, name="冰封箭红羽神弓", flyEffect={80}, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=71, name="冰封箭弩类", flyEffect=local_flyEffect.flyEffect_3, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=72, name="冰封箭火神弩施法特效", flyEffect=local_flyEffect.flyEffect_4, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=73, name="冰封箭巨人弩施法特效", flyEffect=local_flyEffect.flyEffect_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=74, name="冰封箭诱惑之弩施法特效", flyEffect=local_flyEffect.flyEffect_6, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=75, name="冰封箭大天使之弩施法特效", flyEffect=local_flyEffect.flyEffect_7, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=76, name="冰封箭圣者之弩施法特效", flyEffect=local_flyEffect.flyEffect_8, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=77, name="冰封箭蓝翎弩施法特效", flyEffect=local_flyEffect.flyEffect_9, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=78, name="冰封箭追月神弩施法特效", flyEffect=local_flyEffect.flyEffect_10, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=79, name="冰封箭温蒂妮施法特效", flyEffect=local_flyEffect.flyEffect_11, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=80, name="多重箭圣灵之弓", moreFly=1, flyEffect={79,79,79}, flyDelayTime=local_flyDelayTime.flyDelayTime_3, costSound=50036},
	{id=81, name="穿透箭圣灵之弓", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,83}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50036},
	{id=82, name="冰封箭圣灵之弓", flyEffect={83}, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_5, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_3, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50036},
	{id=83, name="普攻红羽神弓特效", flyEffect={74}, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=84, name="普攻精灵之弓特效", flyEffect={77}, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=85, name="普攻玛雅神弓特效", flyEffect={78}, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=86, name="穿透箭黄金石弩、石弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,84}, costSound=50036},
	{id=87, name="穿透箭火神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,85}, costSound=50036},
	{id=88, name="穿透箭巨人弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,86}, costSound=50036},
	{id=89, name="穿透箭诱惑之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,87}, costSound=50036},
	{id=90, name="穿透箭大天使之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,88}, costSound=50036},
	{id=91, name="穿透箭圣者之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,89}, costSound=50036},
	{id=92, name="穿透箭蓝翎弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,90}, costSound=50036},
	{id=93, name="穿透箭追月神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,91}, costSound=50036},
	{id=94, name="穿透箭温蒂妮施法特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,92}, costSound=50036},
	{id=95, name="多重箭黄金石弩、石弩施法特效", moreFly=1, flyEffect={151,151,151}, costSound=50036},
	{id=96, name="多重箭火神弩施法特效", moreFly=1, flyEffect={152,152,152}, costSound=50036},
	{id=97, name="多重箭巨人弩施法特效", moreFly=1, flyEffect={153,153,153}, costSound=50036},
	{id=98, name="多重箭诱惑之弩施法特效", moreFly=1, flyEffect={154,154,154}, costSound=50036},
	{id=99, name="多重箭大天使之弩施法特效", moreFly=1, flyEffect={155,155,155}, costSound=50036},
	{id=100, name="多重箭圣者之弩施法特效", moreFly=1, flyEffect={156,156,156}, costSound=50036},
	{id=101, name="多重箭蓝翎弩施法特效", moreFly=1, flyEffect={157,157,157}, costSound=50036},
	{id=102, name="多重箭追月神弩施法特效", moreFly=1, flyEffect={158,158,158}, costSound=50036},
	{id=103, name="多重箭温蒂妮施法特效", moreFly=1, flyEffect={159,159,159}, costSound=50036},
	{id=104, name="五重箭精灵之弓", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect=local_flyEffect.flyEffect_19, flyDelayTime=local_flyDelayTime.flyDelayTime_6, costSound=50036},
	{id=105, name="五重箭玛雅神弓", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect=local_flyEffect.flyEffect_20, flyDelayTime=local_flyDelayTime.flyDelayTime_6, costSound=50036},
	{id=106, name="五重箭红羽神弓", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect=local_flyEffect.flyEffect_21, flyDelayTime=local_flyDelayTime.flyDelayTime_6, costSound=50036},
	{id=107, name="五重箭黄金石弩、石弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect={151,151,151,151,151}, costSound=50036},
	{id=108, name="五重箭火神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect={152,152,152,152,152}, costSound=50036},
	{id=109, name="五重箭巨人弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect={153,153,153,153,153}, costSound=50036},
	{id=110, name="五重箭诱惑之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect={154,154,154,154,154}, costSound=50036},
	{id=111, name="五重箭大天使之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect={155,155,155,155,155}, costSound=50036},
	{id=112, name="五重箭圣者之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect={156,156,156,156,156}, costSound=50036},
	{id=113, name="五重箭蓝翎弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect={157,157,157,157,157}, costSound=50036},
	{id=114, name="五重箭追月神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect={158,158,158,158,158}, costSound=50036},
	{id=115, name="五重箭温蒂妮施法特效", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect={159,159,159,159,159}, costSound=50036},
	{id=116, name="普攻黄金石弩、石弩施法特效", flyEffect=local_flyEffect.flyEffect_3, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=117, name="普攻火神弩施法特效", flyEffect=local_flyEffect.flyEffect_4, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=118, name="普攻巨人弩施法特效", flyEffect=local_flyEffect.flyEffect_5, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=119, name="普攻诱惑之弩施法特效", flyEffect=local_flyEffect.flyEffect_6, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=120, name="普攻大天使之弩施法特效", flyEffect=local_flyEffect.flyEffect_7, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=121, name="普攻圣者之弩施法特效", flyEffect=local_flyEffect.flyEffect_8, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=122, name="普攻蓝翎弩施法特效", flyEffect=local_flyEffect.flyEffect_9, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=123, name="普攻追月神弩施法特效", releaseEffect={91}, flyEffect=local_flyEffect.flyEffect_10, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=124, name="普攻温蒂妮施法特效", flyEffect=local_flyEffect.flyEffect_11, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=125, name="圣灵之弓普通攻击特效", flyEffect={79}, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50036},
	{id=126, name="五重箭圣灵之弓", releaseEffect=local_releaseEffect.releaseEffect_5, moreFly=1, flyEffect=local_flyEffect.flyEffect_22, costSound=50036},
	{id=127, name="玄月斩", releaseEffect={143,144}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50051},
	{id=128, name="天雷闪施法特效", releaseEffect={102}, flySpeed=local_flySpeed.flySpeed_3, flyEffect={102,102,102,102,102}, costSound=100065},
	{id=129, name="闪电轰顶施法特效", releaseEffect={104}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50050},
	{id=130, name="毒炎施法特效", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_9, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50037},
	{id=131, name="星辰一怒施法特效", releaseEffect={106,107}, flyAction=0, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50033},
	{id=132, name="法神附体施法特效", releaseEffect={72,73}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_4, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, moreTarget=1, costSound=50045},
	{id=133, name="强袭施法特效", releaseEffect={132,132,132}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_6, flyAction=0, flySpeed=local_flySpeed.flySpeed_3},
	{id=134, name="祝福施法特效", releaseEffect={119}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50049},
	{id=135, name="绝对零度施法特效", releaseEffect={122}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetEffect={103,103}, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect={103,103}, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, costSound=50040},
	{id=136, name="血腥风暴施法特效", releaseEffect={123,123,123,123,123,123,124,124,124,124,124}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50040},
	{id=137, name="普攻碧影魔弓特效", flyEffect=local_flyEffect.flyEffect_12, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50035},
	{id=138, name="普攻紫焰之弓特效", flyEffect=local_flyEffect.flyEffect_13, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50035},
	{id=139, name="普攻傲视魔弓特效", flyEffect=local_flyEffect.flyEffect_14, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50035},
	{id=140, name="普攻血色天使特效", flyEffect=local_flyEffect.flyEffect_17, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50035},
	{id=141, name="普攻暗黑天使之弓特效", flyEffect=local_flyEffect.flyEffect_16, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50035},
	{id=142, name="普攻圣天使特效", flyEffect=local_flyEffect.flyEffect_15, flyDelayTime=local_flyDelayTime.flyDelayTime_5, costSound=50035},
	{id=143, name="多重箭傲视魔弓特效", moreFly=1, flyEffect={112,112,112}, flyDelayTime=local_flyDelayTime.flyDelayTime_3, costSound=50035},
	{id=144, name="多重箭圣天使特效", moreFly=1, flyEffect={118,118,118}, flyDelayTime=local_flyDelayTime.flyDelayTime_3, costSound=50035},
	{id=145, name="多重箭暗黑天使之弓特效", moreFly=1, flyEffect={116,116,116}, flyDelayTime=local_flyDelayTime.flyDelayTime_3, costSound=50035},
	{id=146, name="多重箭血色天使特效", moreFly=1, flyEffect={114,114,114}, costSound=50035},
	{id=147, name="五重箭碧影魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_6, moreFly=1, flyEffect=local_flyEffect.flyEffect_23, costSound=50039},
	{id=148, name="五重箭紫焰之弓特效", releaseEffect=local_releaseEffect.releaseEffect_6, moreFly=1, flyEffect=local_flyEffect.flyEffect_24, costSound=50039},
	{id=149, name="五重箭傲视魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_6, moreFly=1, flyEffect=local_flyEffect.flyEffect_25, costSound=50039},
	{id=150, name="五重箭圣天使特效", releaseEffect=local_releaseEffect.releaseEffect_6, moreFly=1, flyEffect=local_flyEffect.flyEffect_26, costSound=50039},
	{id=151, name="五重箭暗黑天使之弓特效", releaseEffect=local_releaseEffect.releaseEffect_6, moreFly=1, flyEffect=local_flyEffect.flyEffect_27, costSound=50039},
	{id=152, name="五重箭血色天使特效", releaseEffect=local_releaseEffect.releaseEffect_6, moreFly=1, flyEffect=local_flyEffect.flyEffect_28, costSound=50039},
	{id=153, name="冰封箭碧影魔弓特效", flyEffect=local_flyEffect.flyEffect_12, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=154, name="冰封箭紫焰之弓特效", flyEffect=local_flyEffect.flyEffect_13, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=155, name="冰封箭傲视魔弓特效", flyEffect=local_flyEffect.flyEffect_14, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=156, name="冰封箭圣天使特效", flyEffect=local_flyEffect.flyEffect_15, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=157, name="冰封箭暗黑天使之弓特效", flyEffect=local_flyEffect.flyEffect_16, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=158, name="冰封箭血色天使特效", flyEffect=local_flyEffect.flyEffect_17, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=159, name="穿透箭碧影魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,108}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=160, name="穿透箭紫焰之弓特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,109}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=161, name="穿透箭傲视魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,111}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=162, name="穿透箭圣天使特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,117}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=163, name="穿透箭暗黑天使之弓特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,115}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=164, name="穿透箭血色天使特效", releaseEffect=local_releaseEffect.releaseEffect_4, flyEffect={36,113}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=165, name="冰封箭", flyEffect=local_flyEffect.flyEffect_18, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=166, name="冰封冽箭", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={38,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=167, name="冰封冽箭精灵之弓", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={81,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=168, name="冰封冽箭玛雅神弓", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={82,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=169, name="冰封冽箭红羽神弓", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={80,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=170, name="冰封冽箭圣灵之弓", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={83,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_5, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_3, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=171, name="冰封冽箭碧影魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={108,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=172, name="冰封冽箭紫焰之弓特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={109,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=173, name="冰封冽箭傲视魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={111,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=174, name="冰封冽箭圣天使特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={117,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=175, name="冰封冽箭暗黑天使之弓特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={115,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=176, name="冰封冽箭血色天使特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={113,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=177, name="冰封冽箭普通弩", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={84,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=178, name="冰封冽箭火神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={85,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=179, name="冰封冽箭巨人弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={86,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=180, name="冰封冽箭诱惑之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={87,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=181, name="冰封冽箭蓝翎弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={90,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=182, name="冰封冽箭温蒂妮施法特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={92,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=183, name="冰封冽箭圣者之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={89,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=184, name="冰封冽箭追月神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={91,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=185, name="穿透刺箭", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,47}, costSound=50038},
	{id=186, name="穿透刺箭精灵之弓", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,81}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=187, name="穿透刺箭玛雅神弓", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,82}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=188, name="穿透刺箭红羽神弓", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,80}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=189, name="穿透刺箭圣灵之弓", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,83}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=190, name="穿透刺箭碧影魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,108}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=191, name="穿透刺箭紫焰之弓特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,109}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=192, name="穿透刺箭傲视魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,111}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=193, name="穿透刺箭圣天使特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,117}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=194, name="穿透刺箭暗黑天使之弓特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,115}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=195, name="穿透刺箭血色天使特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,113}, flyDelayTime=local_flyDelayTime.flyDelayTime_4, costSound=50038},
	{id=196, name="穿透刺箭黄金石弩、石弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,84}, costSound=50038},
	{id=197, name="穿透刺箭火神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,85}, costSound=50038},
	{id=198, name="穿透刺箭巨人弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,86}, costSound=50038},
	{id=199, name="穿透刺箭诱惑之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,87}, costSound=50038},
	{id=200, name="穿透刺箭蓝翎弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,90}, costSound=50038},
	{id=201, name="穿透刺箭温蒂妮施法特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,92}, costSound=50038},
	{id=202, name="穿透刺箭圣者之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,89}, costSound=50038},
	{id=203, name="穿透刺箭追月神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,91}, costSound=50038},
	{id=204, name="五重杀箭", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={38,38,38,38,38}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=205, name="五重杀箭精灵之弓", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_19, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=206, name="五重杀箭玛雅神弓", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_20, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=207, name="五重杀箭红羽神弓", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_21, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=208, name="五重杀箭圣灵之弓", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_22, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=209, name="五重杀箭碧影魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_23, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=210, name="五重杀箭紫焰之弓特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_24, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=211, name="五重杀箭傲视魔弓特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_25, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=212, name="五重杀箭圣天使特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_26, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=213, name="五重杀箭暗黑天使之弓特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_27, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=214, name="五重杀箭血色天使特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect=local_flyEffect.flyEffect_28, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=215, name="五重杀箭黄金石弩、石弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={84,84,84,84,84}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=216, name="五重杀箭火神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={85,85,85,85,85}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=217, name="五重杀箭巨人弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={86,86,86,86,86}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=218, name="五重杀箭诱惑之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={87,87,87,87,87}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=219, name="五重杀箭蓝翎弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={90,90,90,90,90}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=220, name="五重杀箭温蒂妮施法特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={92,92,92,92,92}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=221, name="五重杀箭圣者之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={89,89,89,89,89}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=222, name="五重杀箭追月神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={91,91,91,91,91}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=223, name="五重杀箭大天使之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_9, flyEffect={88,88,88,88,88}, effectRandom=local_effectRandom.effectRandom_2, costSound=50039},
	{id=224, name="霹雳雷旋斩", releaseEffect={11,33,129}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50011},
	{id=225, name="袭风刺(大师）", releaseEffect={130}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={131}, targetEffectMode=local_targetEffectMode.targetEffectMode_2, costSound=50013},
	{id=226, name="雷霆裂闪", releaseEffect={133,134,32}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_3, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50014},
	{id=227, name="血龙波", releaseEffect={135,135,135,135,135}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=2, targetEffect=local_targetEffect.targetEffect_6, targetDelayTime=local_targetDelayTime.targetDelayTime_3, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50014},
	{id=228, name="爆烈炎", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={136,136}, targetDelayTime=local_targetDelayTime.targetDelayTime_4, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50031},
	{id=229, name="暴风凛雪", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={137}, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50029},
	{id=230, name="玄月斩施法特效", releaseEffect={138,143,144}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50052},
	{id=231, name="天雷轰顶施法特效", releaseEffect={139}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50050},
	{id=232, name="烈火剑袭施法特效", releaseEffect={140,141}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50051},
	{id=233, name="穿透刺箭大天使之弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_8, flyEffect={125,88}, costSound=50038},
	{id=234, name="冰封冽箭追月神弩施法特效", releaseEffect=local_releaseEffect.releaseEffect_7, flyEffect={88,121}, targetAction=1, moreTarget=1, targetEffect=local_targetEffect.targetEffect_4, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect=local_otherTargetEffect.otherTargetEffect_2, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50038},
	{id=1001, name="雪人攻击", flyEffect={1001}, flyDelayTime=local_flyDelayTime.flyDelayTime_5, targetAction=1, targetEffect={1003}, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=1002, name="冰后攻击", flyEffect={1002}, flyDelayTime=local_flyDelayTime.flyDelayTime_7, targetAction=1, targetEffect=local_targetEffect.targetEffect_7, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=1004, name="偷猎者攻击", releaseEffect={1004}, flyEffect={1004}, flyDelayTime=local_flyDelayTime.flyDelayTime_7},
	{id=1005, name="骷髅弓箭手攻击特效", flyEffect={1005}, flyDelayTime=local_flyDelayTime.flyDelayTime_7},
	{id=1006, name="死灵巫师攻击特效", flyEffect={1006}},
	{id=1007, name="毒攻击特效", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={1007}, targetDelayTime={200}, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=1009, name="守护兽巴里", releaseEffect={1009}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1010, name="暗黑傀儡攻击", flyAction=0, flyEffect={1010}, flyDelayTime=local_flyDelayTime.flyDelayTime_7},
	{id=1011, name="巨斧战士攻击", releaseEffect={1011}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1012, name="诅咒之王攻击", releaseEffect=local_releaseEffect.releaseEffect_10, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={1013}, targetDelayTime=local_targetDelayTime.targetDelayTime_2, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=1014, name="熔岩巨魔攻击", releaseEffect={1014}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1015, name="毒巨魔攻击", releaseEffect={1015}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1016, name="嗜血蜂后攻击", releaseEffect={1016}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1017, name="死亡天使攻击", flyEffect=local_flyEffect.flyEffect_29},
	{id=1018, name="幼龙攻击", releaseEffect=local_releaseEffect.releaseEffect_11, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_4, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1021, name="魔弓侦察兵攻击", flyEffect={1021}, flyDelayTime=local_flyDelayTime.flyDelayTime_5},
	{id=1022, name="英雄血狼人攻击", releaseEffect=local_releaseEffect.releaseEffect_3, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_3, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1023, name="暗黑指挥官攻击", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=0, targetEffect=local_targetEffect.targetEffect_5, targetDelayTime={100}, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=1024, name="暗影骑士攻击", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=0, targetEffect=local_targetEffect.targetEffect_5, targetDelayTime=local_targetDelayTime.targetDelayTime_2, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=1025, name="树妖攻击", releaseEffect={1022}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1026, name="毒树妖攻击", releaseEffect={1023}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_5, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1027, name="残忍的树妖攻击", releaseEffect={1024}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_4, flySpeed={500}, flyEffect={1025}, flyDelayTime=local_flyDelayTime.flyDelayTime_2, targetAction=1, targetEffect={1026}, targetDelayTime=local_targetDelayTime.targetDelayTime_2, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=1028, name="幽灵巨人攻击", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=0, targetEffect={1027}, targetDelayTime=local_targetDelayTime.targetDelayTime_2, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=1029, name="炼狱魔王技能", releaseEffect={1028}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_4, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2001, name="鬼魅攻击", releaseEffect={2001}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2002, name="恶魔攻击", flyEffect={2002}},
	{id=2003, name="死亡美人鱼攻击", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={2003}},
	{id=2004, name="蓝翼海怪攻击", flyEffect={2005}, flyDelayTime=local_flyDelayTime.flyDelayTime_8},
	{id=2005, name="巫师王攻击", releaseEffect={2006}, flyEffect={2006}},
	{id=2006, name="海魔希特拉攻击", releaseEffect={2007}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1},
	{id=2007, name="铁轮战士攻击", flyEffect={2008,2008,2008}},
	{id=2008, name="破坏骑士攻击", releaseEffect={2009}, releaseDelayTime={500}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2009, name="黑炎魔攻击", releaseEffect={2010}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2010, name="炽炎魔攻击", releaseEffect=local_releaseEffect.releaseEffect_10, flyEffect={2010}},
	{id=2011, name="魔王扎坎攻击", releaseEffect={2012}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2012, name="丛林女巫师攻击", releaseEffect={2013}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1},
	{id=2013, name="丛林召唤者攻击", releaseEffect={2014}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2014, name="金甲兽攻击", releaseEffect={2015}, flyEffect={2015}},
	{id=2015, name="刀刃猎手攻击", releaseEffect={2016}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2016, name="寒冰刺客攻击", releaseEffect={2017}, flyEffect={2017}},
	{id=2017, name="阿卡摩斯攻击", releaseEffect={2018}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1},
	{id=2018, name="风后攻击", releaseEffect={2020}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2019, name="蓝魔龙远程攻击", releaseEffect={2021}, flyEffect={2021}},
	{id=2020, name="幻影骑士攻击", releaseEffect={2022}, flyEffect={2022}},
	{id=2021, name="魔王昆顿火焰气攻击", releaseEffect={2023}, flyEffect=local_flyEffect.flyEffect_30},
	{id=2022, name="冰之魔犬攻击", releaseEffect=local_releaseEffect.releaseEffect_11, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2023, name="冰之魔蛛攻击", releaseEffect={2025}, flySpeed=local_flySpeed.flySpeed_4, flyEffect={2025}},
	{id=2024, name="冰铁剑魂攻击", releaseEffect={7,45}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_8, targetEffectMode=local_targetEffectMode.targetEffectMode_2},
	{id=2025, name="怪物普通攻击2", flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2026, name="魔王巴洛克攻击技能", releaseEffect=local_releaseEffect.releaseEffect_12, flySpeed=local_flySpeed.flySpeed_1, targetAction=1},
	{id=2027, name="天魔菲尼斯攻击", releaseEffect={19}, flyEffect=local_flyEffect.flyEffect_30},
	{id=2028, name="怪物普通攻击1", flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2029, name="海魔希特拉范围光柱", releaseEffect={2052,2053,2054,2055,2056,2057,2058,2059}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1},
	{id=2030, name="赤色要塞法师能量球", flyEffect={2060}, flyDelayTime=local_flyDelayTime.flyDelayTime_5},
	{id=3001, name="铠甲武装", releaseEffect={3001}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=3002, name="愤怒之火", releaseEffect={3002}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=3003, name="魔法之光", releaseEffect={3003}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=4000, name="逆流", releaseEffect={4000}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=4010, name="坚固的庇护", releaseEffect={4010}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=4020, name="陨石雨", releaseEffect={4020}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=4030, name="流星石", releaseEffect={4030}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=4040, name="剧毒风暴", releaseEffect={4040}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_9, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=4050, name="地牢束", releaseEffect={4050}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetEffect={3004}, targetDelayTime={0}, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect={3004}, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime={0}},
	{id=4060, name="法神祝福", releaseEffect={4060}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=4070, name="火箭", releaseEffect={4070}, flyEffect={4070,47}},
	{id=4080, name="落雨", releaseEffect={4080}, flyEffect={4080}},
	{id=4090, name="破敌", releaseEffect={4090}, flySpeed=local_flySpeed.flySpeed_1},
	{id=4100, name="毒箭", releaseEffect={4100}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect=local_targetEffect.targetEffect_9, targetEffectMode=local_targetEffectMode.targetEffectMode_3},
	{id=4110, name="精灵祝福", releaseEffect={4110}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=4112, name="钻云枪", releaseEffect={4112}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6000, name="星云火链", releaseEffect={6001,6002}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_6, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetDelayTime=local_targetDelayTime.targetDelayTime_5, othertargetDelayTime={300}},
	{id=6001, name="冲击波", releaseEffect={6003}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_6, flyAction=0, flySpeed=local_flySpeed.flySpeed_3},
	{id=6002, name="地裂", releaseEffect={6080,6081,6082,6083,6084}, releasePlayMode={2,2,2,2,2}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_6, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetEffect={6083}, targetDelayTime=local_targetDelayTime.targetDelayTime_5, targetEffectMode=local_targetEffectMode.targetEffectMode_3, otherTargetEffect={6083}, otherTargetEffectMode={300}, othertargetDelayTime={2}},
	{id=1014010, name="致命圣印", releaseEffect={6005,6006}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6004, name="圣极光", releaseEffect={6007,6008}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6005, name="炎狼闪电链", flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6006, name="火舞旋风", releaseEffect={6010}, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_6, flySpeed=local_flySpeed.flySpeed_3},
	{id=6007, name="专属宠物：天鹰", releaseEffect={6011,6012,6013,6014}, releasePlayMode={1,1,1,1}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6008, name="黑暗之力", releaseEffect={6015}, flySpeed=local_flySpeed.flySpeed_3, flyEffect={6015}, flyDelayTime=local_flyDelayTime.flyDelayTime_2},
	{id=6009, name="摄魂咒", releaseEffect={6016,6017,6018,6019}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6010, name="链雷咒", releaseEffect={6020,6021,6022}, releasePlayMode={1,1,1}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6011, name="伤害反射", releaseEffect={6023}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6012, name="狂爆术", releaseEffect={6050}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6013, name="虚弱阵", releaseEffect={6060}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=100063},
	{id=6014, name="破御阵", releaseEffect={6070}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=100064},
	{id=6015, name="爆裂", releaseEffect={6029,6029,6029,6029,6029,6029,6030,6030,6030,6030,6030}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=2, targetEffect=local_targetEffect.targetEffect_6, targetDelayTime=local_targetDelayTime.targetDelayTime_3, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50025},
	{id=6016, name="刺袭", releaseEffect={6031,6031,6031,6031,6031,6031,6032,6032,6032,6032,6032}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=2, targetEffect=local_targetEffect.targetEffect_6, targetDelayTime=local_targetDelayTime.targetDelayTime_3, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50025},
	{id=6017, name="聚灵(污染)", releaseEffect={6033,6034}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=6018, name="烈光闪", releaseEffect={6035}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=100054},
	{id=23501, name="龙魂连击（2格）", releaseEffect={6101}, moreFly=1, flySpeed=local_flySpeed.flySpeed_1, costSound=50028},
	{id=23502, name="龙魂连击（3格）", releaseEffect={6102}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50028},
	{id=23503, name="龙魂连击（4格）", releaseEffect={6103}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50028},
	{id=23504, name="龙魂连击（5格）", releaseEffect={6104}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50028},
	{id=23505, name="龙魂连击（6格）", releaseEffect={6105}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50028},
	{id=23506, name="龙魂连击（7格）", releaseEffect={6106}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50028},
	{id=23507, name="龙魂连击（8格）", releaseEffect={6107}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50028},
	{id=2000062, name="变身卡牌天使审判长终极审判", releaseEffect={2000062}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2040011, name="变身卡牌地狱角魔普通攻击", releaseEffect={2040011}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2040021, name="变身卡牌水晶鹿普通攻击", releaseEffect={2040021}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2040031, name="变身卡牌泰克图斯普通攻击", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={2040031}, targetDelayTime=local_targetDelayTime.targetDelayTime_5},
	{id=2040041, name="变身卡牌丛林召唤者普通攻击", releaseEffect={2040041}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2040051, name="变身卡牌大恶魔普通攻击", releaseEffect={2040051}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=2040061, name="变身卡牌天使审判长普通攻击", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={2040061}},
	{id=10040231, name="暗影突袭释放特效", releaseEffect={10040231}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50037},
	{id=1016006, name="狂爆术技能施放特效", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetEffect={60000002}, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect={60000002}, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50037},
	{id=1016013, name="黑暗镇魂曲技能施放特效", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetEffect={60000015}, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect={60000015}, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, othertargetDelayTime=local_othertargetDelayTime.othertargetDelayTime_2, costSound=50037},
	{id=1016011, name="烈光闪施放特效", releaseEffect={60000009}, releasePlayMode=local_releasePlayMode.releasePlayMode_4, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1016007, name="昏睡术施放特效", releaseEffect={60000002}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1016010, name="聚灵施放特效", releaseEffect={60000008,60000016}, releasePlayMode=local_releasePlayMode.releasePlayMode_3, releaseDelayTime={0,500}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1016005, name="链雷咒施放特效", flySpeed=local_flySpeed.flySpeed_4, flyEffect={60000001}, costSound=50019},
	{id=1016009, name="影煞施放特效", releaseEffect={60000006}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1016014, name="水幻兽施放特效", releaseEffect={60000018,60000018,60000018,60000018,60000018}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=2, targetEffect=local_targetEffect.targetEffect_6, targetDelayTime=local_targetDelayTime.targetDelayTime_3, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50025},
	{id=1016008, name="烈袭施放特效", releaseEffect={60000005,60000005,60000005,60000005,60000005}, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=2, targetEffect=local_targetEffect.targetEffect_6, targetDelayTime=local_targetDelayTime.targetDelayTime_3, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50025},
	{id=1016012, name="恶灵召唤施放特效", releaseEffect={60000010}, releasePlayMode=local_releasePlayMode.releasePlayMode_4, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1016016, name="魔隐者特效", releaseEffect={60000019}, releasePlayMode=local_releasePlayMode.releasePlayMode_4, flyAction=0, flySpeed=local_flySpeed.flySpeed_1},
	{id=1016017, name="圣盾防御", releaseEffect=local_releaseEffect.releaseEffect_13, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50012},
	{id=1007001, name="幻龙特效", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, moreTarget=1, targetEffect={10070011}, targetEffectMode=local_targetEffectMode.targetEffectMode_2, otherTargetEffect={10070011}, otherTargetEffectMode=local_otherTargetEffectMode.otherTargetEffectMode_2, costSound=50025},
	{id=1007002, name="审判特效", flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={10070021}, targetEffectMode=local_targetEffectMode.targetEffectMode_3, costSound=50017},
	{id=1007003, name="雷鸟特效", flyEffect={10070031}, flyDelayDistance=5, costSound=50020},
	{id=10070031, name="自带动画雷鸟特效", releaseEffect={10070032}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50023},
	{id=1200018, name="小挪移", releaseEffect=local_releaseEffect.releaseEffect_14, releasePlayMode=local_releasePlayMode.releasePlayMode_3, releaseDelayTime=local_releaseDelayTime.releaseDelayTime_7, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, targetAction=1, targetEffect={60000024,27}, targetDelayTime={0,900}, targetEffectMode=local_targetEffectMode.targetEffectMode_4, costSound=50018},
	{id=1005007, name="星云召唤", releaseEffect=local_releaseEffect.releaseEffect_14, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50012},
	{id=1007004, name="惩戒屏障", releaseEffect={10070041}, releasePlayMode=local_releasePlayMode.releasePlayMode_2, flyAction=0, flySpeed=local_flySpeed.flySpeed_1, costSound=50037},
}

local defaults = {releaseEffect={}, releasePlayMode={}, releaseDelayTime={}, flyAction=1, moreFly=0, flySpeed={1000}, flyEffect={}, effectRandom={}, flyDelayTime={}, flyDelayDistance=0, targetAction=0, moreTarget=0, targetEffect={}, targetDelayTime={}, targetEffectMode={}, otherTargetEffect={}, otherTargetEffectMode={}, othertargetDelayTime={}, costSound=0, hitSound=0, flySound=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_skill_effects) do
	setmetatable(v, mt)
end

return cfg_skill_effects
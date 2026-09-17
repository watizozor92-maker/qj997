-- 此文件工具自动生成，不要修改
---@class cfg_monster_column
---常规怪物：第一，二位分类占位符，第三四五位编号
---活动怪物：活动id+三位编号
---@field id number @怪物ID column=1 A
---策划用
---[[客户端不使用]]@field cehua string @策划备注 column=2 B
---要显示的
---@field name string @怪物名称 column=3 C
---@field ai number @怪物AI column=4 D
---1：小怪
---2：黄金怪
---3：boss
---@field type number @怪物类型 column=5 E
---1：祭坛怪
---配空无狩猎时间不给经验
---@field subtype number @怪物子类型 column=6 F
---怪物是否能被玩家选中
---0：是（能被玩家选中进行攻击）
---1：否（不能被玩家选中，不被玩家攻击设定为目标）
---不填默认为0
---@field beSelect number @怪物被选中 column=7 G
---怪物是否能被敌对怪物选中
---0：是（能被选中进行攻击）
---1：否（不能被选中，不被攻击设定为目标）
---不填默认为0
---@field beMonsterSelect number @怪物被怪物选中 column=8 H
---0：动态，1：静态（无法被强制位移，无法转向）；默认为动态
---@field form number @怪物形态 column=9 I
---怪物模型；读取cfg_model_monsterid
---@field appr number @怪物形象 column=10 J
---怪物头像文件路径
---@field icon string @怪物头像 column=11 K
---@field level number @怪物等级 column=12 L
---怪物模型大小，格式读取unity大小
---@field scale number @怪物模型大小 column=13 M
---填0时为默认大小，非0时为配置大小
---@field UIscale number @UI模型显示尺寸 column=14 N
---三个值代表模型在UI界面x,y,z轴偏移，填空则默认不偏移
---@field uipos IntList @UI界面模型偏移 column=15 O
---玩家变身怪物模型大小，格式读取unity大小
---不填则不生效
---@field shapeshiftScale number @玩家变身怪物模型大小 column=16 P
---y坐标偏移
---@field headoffset number @血条名称位置 column=17 Q
---y坐标偏移
---@field np number @名称位置 column=18 R
---@field exp number @经验值 column=19 S
---每次攻击给
---@field angelExp number @大天使经验 column=20 T
---怪物对应属性
---读取cfg_monster_attribute_group/monsterID
---[[客户端不使用]]@field group number @怪物属性组 column=21 U
---怪物经验值衰减使用的衰减类型，匹配cfg_boss_dropDecay表中decaySign字段配置，获取衰减系数
---衰减系数*怪物经验=最终玩家获得经验值
---不配置不衰减
---@field decaySign number @经验衰减 column=22 V
---怪物打玩家最终伤害<保底伤害时，最终伤害=保底伤害
---@field guaranteedDamage number @怪物保底伤害 column=23 W
---1：不可穿
---2：可穿
---为空和0则该字段不生效
---@field pveCrossModel number @玩家与怪物是否可穿 column=24 X
---1：不可穿
---2：可穿
---为空和0则该字段不生效
---[[客户端不使用]]@field eveCrossModel number @怪物与怪物是否可穿 column=25 Y
---填写cfg_audio表对应的音效id
---空为不播放
---@field bornSound number @进入视野声音 column=26 A
---填写cfg_audio表对应的音效id
---空为不播放
---@field attackSound number @攻击声音 column=27 AA
---填写cfg_audio表对应的音效id
---空为不播放
---@field hitSound number @受击声音 column=28 AB
---填写cfg_audio表对应的音效id
---空为不播放
---@field dieSound number @死亡声音 column=29 AC
---填写cfg_audio表对应的音效id
---空为不播放
---@field birthSound number @复活声音 column=30 AD
---填写cfg_audio表对应的音效id
---空为不播放
---@field walkSound number @移动音效 column=31 AE
---填写cfg_audio表对应的音效id
---空为不播放
---@field runSound number @快速移动音效 column=32 AF
---填写cfg_audio表对应的音效id
---空为不播放
---@field trackSound number @移动追踪音效 column=33 AG
---填写cfg_audio表对应的音效id
---空为不播放
---@field fastTrack number @快速追踪音效 column=34 AH
---在怪物生命为0时播放，为空不播放；
---格式：特效ID#挂载模式
---特效ID：引用cfg_model_effect表id字段
---挂载模式：0或者不填，特效挂载怪物模型上，模型消失特效消失；填1特效挂载死亡时所在场景格子
---@field deathEffect IntList @死亡特效 column=35 AI
---填写free buff表的只对怪物生效的buffid，
---[[客户端不使用]]@field buff IntList @增加buff column=36 AJ
---用于对比玩家和怪物战力
---配置怪物防御值，与玩家主界面左上角防御值进行对比
---@field sword number @怪物战力值 column=37 AK
---击杀怪物后场景里出现标记
---@field deathmark string @击杀标记 column=38 AL
---怪物掉落组，用于怪物掉落处配置，同一组内怪物视为一个主体进行掉落与计数;
---同一怪物可配置多个掉落组，怪物死后对应掉落组全部进行掉落并分别计数+1
---
---@field mgroup IntList @怪物组 column=39 AM
---怪物衰减组，用于控制组内怪物死亡达到一定次数触发对应掉落内容衰减系数用
---@field mDecayGroup IntList @怪物衰减组 column=40 AN
---填写资源名称，资源格式为2D图片[填写资源名称，资源格式为2D图片]
---@field efficiencyLvIcon string @怪点图标资源 column=41 AO
---是否显示地图界面怪物图标
---0或空：不显示；1：显示[0或空：不显示；1：显示]
---@field monsterShowIcon number @大地图怪物图标开关 column=42 AP
---是否显示地图界面怪物名称
---0或空：不显示；1：显示[0或空：不显示；1：显示]
---@field monsterShowName number @大地图怪物名称开关 column=43 AQ
---是否显示地图界面怪物等级
---0或空：不显示；1：显示[0或空：不显示；1：显示]
---@field monsterShowLv number @大地图怪物等级 column=44 AR
---怪物等级与怪物名称字体颜色显示；
---cfg_color表id[怪物等级与怪物名称字体颜色显示；
---cfg_color表id]
---@field txtColor number @字体颜色 column=45 AS
---根据玩家自身的职业，显示不同的道具。格式：职业ID#道具ID|职业ID#道具ID
---若没有奖励则：为空
---UI显示根据从做左到右显示，显示不足时优先显示顺序考前的。
---职业ID填基础职业
---@field UIDrop IntListList @BOSS血条掉落预览 column=46 AT
---猎魔积分争霸赛
---怪物积分组
---cfg_monsterHunt
---@field monsterHunt number @猎魔积分 column=47 AU
---判断怪物是否可以被玩家攻击击退
---默认为0不可击退
---
---0-不可击退
---
---1-可击退
---@field repelled number @是否可击退 column=48 AV
---@field shengdaoshiexp number @圣导师黑王马、天鹰经验 column=49 AW
---掉落个体值
---@field dropvalue number @掉落个体值 column=50 AX
---怪物金币掉落判定值
---@field gloddropvalue number @金币掉落值 column=51 AY
---该挂机地图推荐的攻击力数值
---@field RecommendedAtk number @推荐攻击 column=52 B
---该挂机地图推荐的防御力数值
---@field RecommendedDef number @推荐防御 column=53 BA
---怪物衰减组，用于控制组内怪物击杀达到一定次数触发对应掉落内容衰减系数用，和死亡次数不同，这个会被重置，每天第x\y\z。。。分钟重置，参数在global表
---@field KillGroup IntList @怪物击杀衰减组 column=54 BB
---该怪物交战推荐使用的药水
---@field RecommendedPotion number @推荐药水 column=55 BC
---0无归属（自由捡）
---1仇恨第一
---2补刀者（尾刀）
---3伤害第一（适用于排行类BOSS）
---4参与者
---5首刀（角色不死的情况下算第一个人的）
---@field droptype number @怪物归属显示 column=56 BD
---最多x只怪物攻击同一名玩家
---@field monsterCount number @会同时攻击玩家的怪只数 column=57 BE
---特效表ID
---@field petEffect number @召唤类怪物身上特效 column=58 BF

local local_uipos = {
    uipos_1={},
    uipos_2={1.7},
    uipos_3={0,-100,0},

}

local local_deathEffect = {
    deathEffect_1={},
    deathEffect_2={2051,1},
    deathEffect_3={2030,1},
    deathEffect_4={2050,1},
    deathEffect_5={2029,1},
    deathEffect_6={2027,1},

}

local local_mgroup = {
    mgroup_1={2},
    mgroup_2={},
    mgroup_3={15001030},
    mgroup_4={80005},
    mgroup_5={11001},
    mgroup_6={11002},
    mgroup_7={11003},
    mgroup_8={11004},
    mgroup_9={11005},
    mgroup_10={90001},
    mgroup_11={90003},
    mgroup_12={90004},
    mgroup_13={90005},
    mgroup_14={90006},
    mgroup_15={90007},
    mgroup_16={12002},
    mgroup_17={12003},
    mgroup_18={12004},
    mgroup_19={12005},
    mgroup_20={12006},
    mgroup_21={12007},
    mgroup_22={13001},
    mgroup_23={13002},
    mgroup_24={13003},
    mgroup_25={33001},
    mgroup_26={33002},
    mgroup_27={33003},
    mgroup_28={14001},
    mgroup_29={14002},
    mgroup_30={14003},
    mgroup_31={14004},
    mgroup_32={14005},
    mgroup_33={16001},
    mgroup_34={16002},
    mgroup_35={16003},
    mgroup_36={16004},
    mgroup_37={16005},
    mgroup_38={16006},
    mgroup_39={1901},
    mgroup_40={1951},
    mgroup_41={1981},
    mgroup_42={2151},
    mgroup_43={2181},
    mgroup_44={2101},
    mgroup_45={2051},
    mgroup_46={2081},
    mgroup_47={2001},
    mgroup_48={2351},
    mgroup_49={2451},
    mgroup_50={2551},
    mgroup_51={2651},
    mgroup_52={8001},
    mgroup_53={8003},
    mgroup_54={8005},
    mgroup_55={8007},
    mgroup_56={8009},
    mgroup_57={8011},
    mgroup_58={8013},

}

local local_mDecayGroup = {
    mDecayGroup_1={},

}

local local_UIDrop = {
    UIDrop_1={},
    UIDrop_2={{1,20310221},{1,20610221},{2,20120221},{2,20420221},{3,20130221},{3,20430221},{1,50030002},{1,50030003},{2,50030002},{2,50030003},{3,50030002},{3,50030003}},
    UIDrop_3={{1,20310421},{1,20610421},{2,20120421},{2,20420421},{3,20130421},{3,20430421},{1,50030002},{1,50030003},{2,50030002},{2,50030003},{3,50030002},{3,50030003}},
    UIDrop_4={{1,50030014}},
    UIDrop_5={{1,20312131},{2,20122131},{3,20132131},{1,50030002},{1,50030003},{1,50010010},{2,50030002},{2,50030003},{2,50010010},{3,50030002},{3,50030003},{3,50010010}},
    UIDrop_6={{1,20311431},{2,20121431},{3,20131431},{1,50030002},{1,50030003},{1,50010010},{2,50030002},{2,50030003},{2,50010010},{3,50030002},{3,50030003},{3,50010010}},
    UIDrop_7={{1,20311631},{2,20121631},{3,20131631},{1,50030002},{1,50030003},{1,50010010},{2,50030002},{2,50030003},{2,50010010},{3,50030002},{3,50030003},{3,50010010}},
    UIDrop_8={{1,20311531},{2,20121531},{3,20131531},{1,50030002},{1,50030003},{1,50010010},{2,50030002},{2,50030003},{2,50010010},{3,50030002},{3,50030003},{3,50010010}},
    UIDrop_9={{1,20311831},{2,20121831},{3,20131831},{1,50030002},{1,50030003},{1,50010010},{2,50030002},{2,50030003},{2,50010010},{3,50030002},{3,50030003},{3,50010010}},
    UIDrop_10={{1,20311931},{2,20121931},{3,20131931},{1,50030002},{1,50030003},{1,50010010},{2,50030002},{2,50030003},{2,50010010},{3,50030002},{3,50030003},{3,50010010}},
    UIDrop_11={{1,20312031},{2,20122031},{3,20132031},{1,50030002},{1,50030003},{1,50010010},{2,50030002},{2,50030003},{2,50010010},{3,50030002},{3,50030003},{3,50010010}},

}

local local_KillGroup = {
    KillGroup_1={1},
    KillGroup_2={1,1001},
    KillGroup_3={1,2001},
    KillGroup_4={3001},
    KillGroup_5={},

}

local cfg_monster =
{
	{id=1, name="蜘蛛 100全属性", ai=101, type=3, appr=10002, icon="Monster10", level=2, scale=0.2, headoffset=-0.8, np=-0.8, guaranteedDamage="10", attackSound=40090, mgroup={1}, efficiencyLvIcon="", monsterShowIcon=0, repelled=1, dropvalue=110, gloddropvalue=110, RecommendedDef=200, KillGroup=local_KillGroup.KillGroup_1},
	{id=2, name="蜘蛛 200全属性", ai=101, type=3, beMonsterSelect=1, appr=10002, icon="Monster10", level=2, scale=0.2, headoffset=-0.8, np=-0.8, guaranteedDamage="10", attackSound=40090, mgroup=local_mgroup.mgroup_1, efficiencyLvIcon="", monsterShowIcon=0, repelled=1, dropvalue=115, gloddropvalue=115, RecommendedDef=400, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=3, name="蜘蛛 300全属性", ai=101, type=3, beMonsterSelect=1, appr=10002, icon="Monster10", level=2, scale=0.2, headoffset=-0.8, np=-0.8, guaranteedDamage="10", attackSound=40090, mgroup=local_mgroup.mgroup_1, efficiencyLvIcon="", monsterShowIcon=0, repelled=1, dropvalue=115, gloddropvalue=115, KillGroup=local_KillGroup.KillGroup_1},
	{id=4, name="连击技能测试怪", ai=100, form=1, appr=10004, icon="Monster_038", level=2, scale=0.5, exp=0, guaranteedDamage="10", mgroup={4}, efficiencyLvIcon="", monsterShowIcon=0, repelled=1, dropvalue=120, gloddropvalue=120, KillGroup=local_KillGroup.KillGroup_1},
	{id=10000, name="伤害测试怪", ai=100, type=3, form=1, appr=10004, icon="Monster_038", level=2, scale=0.5, exp=0, guaranteedDamage="10", mgroup={10000}, efficiencyLvIcon="", monsterShowIcon=0, repelled=1, dropvalue=125, gloddropvalue=125, KillGroup=local_KillGroup.KillGroup_1, droptype=3},
	{id=10002, name="蜘蛛", ai=10002, appr=10002, icon="Monster10", level=2, scale=0.2, headoffset=-0.8, np=-0.8, exp=8, decaySign=1000, attackSound=40090, mgroup={10002,6666}, repelled=1, dropvalue=120, gloddropvalue=200, KillGroup={2,1001}},
	{id=10003, name="骷髅兵", ai=10003, appr=10003, icon="Monster163", level=39, scale=0.38, shapeshiftScale=1, headoffset=0.2, np=0.2, exp=14, decaySign=1000, attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, mgroup={10003,6666}, repelled=1, dropvalue=160, gloddropvalue=240},
	{id=10001, name="幼龙", ai=10001, appr=10001, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, np=-0.8, exp=20, decaySign=1000, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={10001,6666}, repelled=1, dropvalue=120, gloddropvalue=200, KillGroup={1,2,3,1001}},
	{id=10004, name="牛怪", ai=10004, appr=10004, icon="Monster01_1", level=6, headoffset=0.2, np=0.2, exp=34, decaySign=1000, attackSound=40065, dieSound=40067, mgroup={10004,6666}, repelled=1, dropvalue=130, gloddropvalue=200},
	{id=20004, name="猎犬怪", ai=20004, appr=20004, icon="Monster02_liequanguai", level=8, headoffset=0.2, np=0.2, exp=72, decaySign=1000, attackSound=40075, dieSound=40077, birthSound=40073, mgroup={20004,6666}, repelled=1, dropvalue=130, gloddropvalue=200},
	{id=10005, name="蛮牛怪", ai=10005, appr=10005, icon="Monster01_1", level=10, scale=0.45, headoffset=0.45, np=0.45, exp=106, decaySign=1000, attackSound=40065, dieSound=40067, mgroup={10005,6666}, repelled=1, dropvalue=140, gloddropvalue=240},
	{id=10007, name="黑巫师", ai=10007, appr=10007, icon="Monster05_1", level=12, headoffset=0, np=0, exp=132, decaySign=1000, attackSound=40112, dieSound=40114, birthSound=40110, mgroup={10007,6666}, repelled=1, dropvalue=150, gloddropvalue=240},
	{id=20008, name="巨人", ai=105, appr=20008, icon="Monster06", level=14, scale=0.7, headoffset=1.5, np=1.5, exp=178, decaySign=1000, attackSound=40034, dieSound=40036, birthSound=40032, deathEffect={2026,1}, mgroup={20008,6666}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=150, gloddropvalue=240},
	{id=20001, name="小哥布林", ai=20001, appr=20001, icon="Monster20_1", level=3, headoffset=-0.35, np=-0.35, exp=14, decaySign=1000, attackSound=40023, dieSound=40025, birthSound=40021, mgroup={20001,6666}, repelled=1, dropvalue=120, gloddropvalue=200},
	{id=20002, name="勾尾蝎", ai=20002, appr=20002, icon="Monster21", level=5, headoffset=-0.8, np=-0.8, exp=30, decaySign=1000, attackSound=40018, dieSound=40020, birthSound=40016, mgroup={20002,6666}, repelled=1, dropvalue=120, gloddropvalue=200},
	{id=20003, name="大哥布林", ai=20003, appr=20003, icon="Monster20_1", level=7, scale=0.45, headoffset=0, np=0, exp=62, decaySign=1000, attackSound=40023, dieSound=40025, birthSound=40021, mgroup={20003,6666}, repelled=1, dropvalue=130, gloddropvalue=200},
	{id=20005, name="瓢虫怪", ai=20005, appr=20005, icon="Monster22", level=9, scale=0.32, headoffset=0, np=0, exp=82, decaySign=1000, attackSound=40079, dieSound=40080, mgroup={20005,6666}, repelled=1, dropvalue=140, gloddropvalue=200},
	{id=10006, name="偷猎者", ai=10006, appr=10006, icon="Monster23", level=11, scale=0.37, headoffset=0, np=0, exp=119, decaySign=1000, attackSound=40008, dieSound=40010, birthSound=40006, mgroup={10006,6666}, repelled=1, dropvalue=140, gloddropvalue=240},
	{id=20006, name="树妖", ai=20006, appr=20006, icon="Monster24", level=13, headoffset=0.1, np=0.1, exp=147, decaySign=1000, attackSound=40058, dieSound=40059, birthSound=40056, mgroup={20006,6666}, repelled=1, dropvalue=150, gloddropvalue=240},
	{id=20007, name="亚昆", ai=105, appr=20007, icon="Monster25", level=16, scale=0.5, headoffset=0.5, np=0.5, exp=162, decaySign=1000, attackSound=40003, dieSound=40005, mgroup={20007,6666}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=150, gloddropvalue=240},
	{id=20009, name="石巨人", ai=20009, appr=20009, icon="Monster26", level=17, scale=0.37, headoffset=1.5, np=1.5, exp=194, decaySign=1000, attackSound=40034, dieSound=40036, deathEffect=local_deathEffect.deathEffect_4, mgroup={20009,6666}, repelled=1, dropvalue=160, gloddropvalue=240},
	{id=30001, name="怪异的兔子", ai=30001, appr=30001, icon="monster129", level=5, headoffset=0, np=0, exp=33, decaySign=1000, mgroup={30001,6666}, dropvalue=120, gloddropvalue=20},
	{id=30002, name="疯狂的兔子", ai=30002, appr=30002, icon="monster130", headoffset=0.35, np=0.35, exp=147, decaySign=1000, mgroup={30002,6666}, dropvalue=120, gloddropvalue=20},
	{id=30003, name="狼人", ai=30003, appr=30003, icon="monster131", level=24, scale=0.43, headoffset=0.35, np=0.35, exp=194, decaySign=1000, mgroup={30003,6666}, dropvalue=130, gloddropvalue=20},
	{id=30004, name="污染之蝶", ai=30004, appr=30004, icon="monster132", level=13, headoffset=0.25, np=0.25, exp=82, decaySign=1000, mgroup={30004,6666}, dropvalue=140, gloddropvalue=24},
	{id=30005, name="诅咒巫师", ai=30005, appr=30005, icon="monster133", level=60, scale=0.5, headoffset=0, np=0, exp=260, decaySign=1000, attackSound=40112, dieSound=40114, birthSound=40091, mgroup={30005,6666}, dropvalue=130, gloddropvalue=20},
	{id=30006, name="图腾树人", ai=30006, appr=30006, icon="monster134", level=66, scale=0.6, headoffset=0.5, np=0.5, exp=420, decaySign=1000, mgroup={30006,6666}, dropvalue=150, gloddropvalue=24},
	{id=30007, name="灰熊", ai=30007, appr=30007, icon="monster135", level=68, scale=0.45, headoffset=0.35, np=0.35, exp=550, decaySign=1000, mgroup={30007,6666}, dropvalue=150, gloddropvalue=24},
	{id=30008, name="残暴的灰熊", ai=30008, appr=30008, icon="monster136", level=78, scale=0.51, headoffset=0.5, np=0.5, exp=590, decaySign=1000, mgroup={30008}, dropvalue=150, gloddropvalue=24},
	{id=40001, name="雪虫", ai=40001, appr=40001, icon="Monster18", level=55, headoffset=-0.5, np=-0.5, exp=230, decaySign=1000, attackSound=40100, dieSound=40102, mgroup={40001,6667}, repelled=1, dropvalue=160, gloddropvalue=280, monsterCount=1},
	{id=40002, name="寒冰魔", ai=40002, appr=40002, icon="Monster16", level=56, headoffset=0, np=0, exp=268, decaySign=1000, attackSound=40029, dieSound=40031, birthSound=40030, deathEffect=local_deathEffect.deathEffect_6, mgroup={40002,6667}, repelled=1, dropvalue=170, gloddropvalue=280, monsterCount=1},
	{id=40003, name="蓝魔怪", ai=40003, appr=40003, icon="Monster17", level=57, scale=0.45, headoffset=0.45, np=0.45, exp=310, decaySign=1000, attackSound=40086, dieSound=40089, birthSound=40087, mgroup={40003,6667}, repelled=1, dropvalue=170, gloddropvalue=28, monsterCount=1},
	{id=50002, name="暗杀者", ai=50002, appr=50002, icon="Monster15", level=58, scale=0.4, headoffset=0.15, np=0.15, exp=330, decaySign=1000, attackSound=40053, dieSound=40055, birthSound=40052, mgroup={50002,6667}, repelled=1, dropvalue=180, gloddropvalue=28, monsterCount=1},
	{id=40004, name="雪人", ai=112, appr=40004, icon="Monster13", level=59, scale=0.45, shapeshiftScale=1, headoffset=0.15, np=0.15, exp=552, decaySign=1000, attackSound=40098, dieSound=40099, mgroup={40004,6667}, dropvalue=180, gloddropvalue=28, monsterCount=1},
	{id=40005, name="雪人王", ai=40005, appr=40005, icon="Monster14", level=60, scale=0.55, headoffset=0.5, np=0.5, exp=655, decaySign=1000, attackSound=40098, dieSound=40099, mgroup={40005,6667}, repelled=1, dropvalue=180, gloddropvalue=46, monsterCount=1},
	{id=50001, name="毒虫", ai=50001, appr=50001, icon="Monster07", level=69, scale=0.3, headoffset=-0.45, np=-0.45, exp=332, decaySign=1000, attackSound=40061, dieSound=40062, mgroup={50001,6668}, repelled=1, dropvalue=200, gloddropvalue=28, monsterCount=1},
	{id=50003, name="独眼巨人", ai=50003, appr=50003, icon="Monster11", level=70, scale=0.4, headoffset=0.5, np=0.5, exp=502, decaySign=1000, attackSound=40070, dieSound=40072, birthSound=40068, mgroup={50003,6668}, repelled=1, dropvalue=170, gloddropvalue=28, monsterCount=1},
	{id=50004, name="幽灵", ai=50004, appr=50004, icon="Monster08", level=71, headoffset=0, np=0, exp=606, decaySign=1000, attackSound=40043, dieSound=40045, birthSound=40041, mgroup={50004,6668}, repelled=1, dropvalue=190, gloddropvalue=46, monsterCount=1},
	{id=50005, name="骷髅弓箭手", ai=50005, appr=50005, icon="Monster162", level=72, scale=0.4, headoffset=0.35, np=0.35, exp=668, decaySign=1000, attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, mgroup={50005,6668}, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=50006, name="地狱猎犬怪", ai=50006, appr=50006, icon="Monster02_2", level=73, scale=0.4, headoffset=0.35, np=0.35, exp=802, decaySign=1000, attackSound=40027, dieSound=40028, mgroup={50006,6668}, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=50007, name="地狱蜘蛛", ai=50007, appr=50007, icon="Monster10", level=74, scale=0.4, headoffset=0, np=0, exp=874, decaySign=1000, attackSound=40027, dieSound=40028, birthSound=40026, mgroup={50007,6668}, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=50009, name="骷髅战士", ai=50009, appr=50009, icon="Monster163", level=75, scale=0.4, headoffset=0.45, np=0.45, exp=948, decaySign=1000, attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, mgroup={50009,6668}, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=50010, name="死灵巫师", ai=50010, appr=50010, icon="Monster05_1", level=76, headoffset=0.35, np=0.35, exp=1026, decaySign=1000, attackSound=40112, dieSound=40114, mgroup={50010,6668}, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=50011, name="毒牛怪", ai=50011, appr=50011, icon="Monster01_3", level=77, scale=0.5, shapeshiftScale=1, headoffset=0.45, np=0.45, exp=1106, decaySign=1000, attackSound=40065, dieSound=40067, birthSound=40063, mgroup={50011,6668}, repelled=1, dropvalue=190, gloddropvalue=46, monsterCount=1},
	{id=50008, name="暗黑骑士", ai=50008, appr=50008, icon="Monster04", level=78, scale=0.4, headoffset=0.35, np=0.35, exp=1190, decaySign=1000, attackSound=40117, dieSound=40119, birthSound=40115, mgroup={50008,6668}, repelled=1, dropvalue=200, gloddropvalue=28, monsterCount=1},
	{id=60001, name="鬼魂", ai=60001, appr=60001, icon="Monster29", level=81, scale=0.5, headoffset=0, np=0, exp=1233, decaySign=1000, attackSound=40107, dieSound=40109, birthSound=40105, mgroup={60001,6669}, repelled=1, dropvalue=200, gloddropvalue=28, monsterCount=3},
	{id=60002, name="剧毒鬼魂", ai=60002, appr=60002, icon="Monster29_02", level=82, scale=0.5, headoffset=0, np=0, exp=1321, decaySign=1000, attackSound=40107, dieSound=40109, birthSound=40105, mgroup={60002,6669}, repelled=1, dropvalue=200, gloddropvalue=46, monsterCount=3},
	{id=60003, name="诅咒巫师", ai=60003, appr=60003, icon="Monster164", level=83, scale=0.4, headoffset=0, np=0, exp=1458, decaySign=1000, attackSound=40112, dieSound=40114, birthSound=40091, mgroup={60003,6669}, repelled=1, dropvalue=200, gloddropvalue=46, monsterCount=4},
	{id=60004, name="牛魔王", ai=60004, appr=60004, icon="Monster31", level=84, scale=0.5, headoffset=0.45, np=0.45, exp=1506, decaySign=1000, attackSound=40065, dieSound=40067, mgroup={60004,6669}, repelled=1, dropvalue=200, gloddropvalue=46, monsterCount=4},
	{id=60005, name="恶魔", ai=60005, appr=60005, icon="Monster27", level=85, scale=0.5, headoffset=0.45, np=0.45, exp=1966, decaySign=1000, attackSound=40003, dieSound=40005, mgroup={60005,6669}, repelled=1, dropvalue=200, gloddropvalue=46, monsterCount=5},
	{id=60006, name="死神骑士", ai=60006, appr=60006, icon="Monster30", level=86, scale=0.5, headoffset=0.5, np=0.5, exp=2008, decaySign=1000, attackSound=40117, dieSound=40119, mgroup={60006,6669}, repelled=1, dropvalue=200, gloddropvalue=46, monsterCount=5},
	{id=60007, name="死神戈登", ai=60007, appr=60007, icon="Monster105", level=87, scale=0.5, headoffset=0.5, np=0.5, exp=2166, decaySign=1000, attackSound=40049, dieSound=40051, mgroup={60007,6669}, repelled=1, dropvalue=180, gloddropvalue=46, monsterCount=5},
	{id=25001, name="恶魔", ai=60005, appr=60005, icon="Monster27", level=88, scale=0.5, headoffset=0.45, np=0.45, exp=2566, decaySign=1000, attackSound=40003, dieSound=40005, mgroup={25001,6669}, repelled=1, dropvalue=200, gloddropvalue=46, monsterCount=6},
	{id=25002, name="死神骑士", ai=60006, appr=60006, icon="Monster30", level=89, scale=0.5, headoffset=0.5, np=0.5, exp=2576, decaySign=1000, attackSound=40117, dieSound=40119, mgroup={25002,6669}, repelled=1, dropvalue=200, gloddropvalue=46, monsterCount=6},
	{id=25003, name="死神戈登", ai=60007, appr=60007, icon="Monster105", level=90, scale=0.5, headoffset=0.5, np=0.5, exp=2690, decaySign=1000, attackSound=40049, dieSound=40051, mgroup={25003,6669}, repelled=1, dropvalue=180, gloddropvalue=46, monsterCount=6},
	{id=70001, name="小巴哈姆特", ai=70001, appr=70001, icon="Monster34", level=123, scale=0.25, headoffset=0, np=0, exp=1966, decaySign=1000, attackSound=40037, mgroup={70001}, repelled=1, dropvalue=185, gloddropvalue=28, monsterCount=3},
	{id=70002, name="死亡美人鱼", ai=70002, appr=70002, icon="Monster35", level=125, scale=0.43, headoffset=0.85, np=0.85, exp=2008, decaySign=1000, attackSound=40103, mgroup={70002}, repelled=1, dropvalue=185, gloddropvalue=28, monsterCount=3},
	{id=70003, name="蓝翼海怪", ai=70003, appr=70003, icon="Monster36_1", level=136, scale=0.43, headoffset=0.65, np=0.65, exp=2166, decaySign=1000, attackSound=40103, deathEffect=local_deathEffect.deathEffect_5, mgroup={70003}, repelled=1, dropvalue=185, gloddropvalue=28, monsterCount=4},
	{id=70004, name="大巴哈姆特", ai=70004, appr=70004, icon="Monster34_1", level=136, scale=0.4, headoffset=0.35, np=0.35, exp=2566, decaySign=1000, attackSound=40103, mgroup={70004}, repelled=1, dropvalue=175, gloddropvalue=46, monsterCount=4},
	{id=70005, name="银弓海怪", ai=70005, appr=70005, icon="Monster36_2", level=148, scale=0.5, headoffset=1.25, np=1.25, exp=2576, decaySign=1000, attackSound=40103, mgroup={70005}, repelled=1, dropvalue=175, gloddropvalue=46, monsterCount=4},
	{id=70006, name="巫师王", ai=70006, appr=70006, icon="Monster37", level=150, scale=0.5, headoffset=0.85, np=0.85, exp=2690, decaySign=1000, attackSound=40103, mgroup={70006}, repelled=1, dropvalue=175, gloddropvalue=46, monsterCount=5},
	{id=80001, name="铁脊怪", ai=80001, appr=80001, icon="Monster46", level=170, scale=0.58, exp=2700, decaySign=1000, attackSound=40034, dieSound=100025, mgroup={80001}, repelled=1, dropvalue=170, gloddropvalue=100, monsterCount=3},
	{id=80002, name="巨齿兽", ai=80002, appr=80002, icon="Monster44", level=175, scale=0.9, exp=3000, decaySign=1000, attackSound=40034, dieSound=100026, mgroup={80002}, repelled=1, dropvalue=170, gloddropvalue=100, monsterCount=3},
	{id=80003, name="铁轮战士", ai=80003, appr=80003, icon="Monster42", level=180, scale=0.5, exp=3100, decaySign=1000, attackSound=40034, dieSound=100027, mgroup={80003}, repelled=1, dropvalue=160, gloddropvalue=100, monsterCount=4},
	{id=80004, name="破坏骑士", ai=80004, appr=80004, level=185, scale=0.7, exp=3200, decaySign=1000, attackSound=40034, dieSound=100028, mgroup={80004}, repelled=1, dropvalue=160, gloddropvalue=100, monsterCount=4},
	{id=80005, name="黑炎魔", ai=80005, appr=80005, icon="Monster45", level=190, scale=0.5, exp=3300, decaySign=1000, attackSound=40094, dieSound=100029, deathEffect=local_deathEffect.deathEffect_3, mgroup=local_mgroup.mgroup_4, repelled=1, dropvalue=160, gloddropvalue=100, monsterCount=5},
	{id=11001, name="丛林树精灵", ai=101, appr=11001, icon="NewMonster_2", level=220, scale=0.5, exp=2400, decaySign=1000, attackSound=100042, dieSound=100043, mgroup=local_mgroup.mgroup_5, dropvalue=130, gloddropvalue=30, monsterCount=3},
	{id=11002, name="丛林残暴者", ai=11002, appr=11002, icon="NewMonster_3", level=225, scale=0.46, exp=2600, decaySign=1000, attackSound=100046, dieSound=100047, mgroup=local_mgroup.mgroup_6, repelled=1, dropvalue=130, gloddropvalue=30, monsterCount=3},
	{id=11003, name="丛林暗杀者", ai=11003, appr=11003, icon="NewMonster_4", level=230, scale=0.45, exp=3000, decaySign=1000, guaranteedDamage="2", attackSound=100044, dieSound=100045, mgroup=local_mgroup.mgroup_7, repelled=1, dropvalue=130, gloddropvalue=30, monsterCount=4},
	{id=11004, name="丛林生命体", ai=11004, appr=11004, icon="NewMonster_5", level=235, scale=0.55, exp=3800, decaySign=1000, guaranteedDamage="2", attackSound=100050, dieSound=100051, mgroup=local_mgroup.mgroup_8, repelled=1, dropvalue=130, gloddropvalue=30, monsterCount=4},
	{id=11005, name="丛林女巫师", ai=101, appr=11005, icon="NewMonster_6", level=240, scale=0.52, exp=4200, decaySign=1000, attackSound=100048, dieSound=100049, mgroup=local_mgroup.mgroup_9, dropvalue=130, gloddropvalue=30, monsterCount=5},
	{id=90002, name="阿卡摩斯", ai=90002, appr=90002, icon="Monster104", level=269, exp=24000, decaySign=1000, guaranteedDamage="2", dieSound=100042, mgroup={90002}, repelled=1, dropvalue=160, gloddropvalue=46, monsterCount=3},
	{id=90001, name="恶灵", ai=101, appr=90001, icon="Monster105", level=280, scale=0.4, exp=25000, decaySign=1000, dieSound=100041, mgroup=local_mgroup.mgroup_10, dropvalue=160, gloddropvalue=46, monsterCount=3},
	{id=90003, name="风后", ai=101, appr=90003, icon="Monster103", level=285, scale=0.5, exp=26000, decaySign=1000, guaranteedDamage="2", dieSound=100043, mgroup=local_mgroup.mgroup_11, dropvalue=160, gloddropvalue=46, monsterCount=4},
	{id=90004, name="蓝魔龙", ai=90004, appr=90004, icon="Monster102", level=290, scale=0.3, exp=27000, decaySign=1000, guaranteedDamage="2", dieSound=100044, mgroup=local_mgroup.mgroup_12, repelled=1, dropvalue=160, gloddropvalue=46, monsterCount=4},
	{id=90005, name="恶灵王", ai=90005, appr=90005, icon="Monster101", level=300, scale=0.5, exp=30000, decaySign=1000, guaranteedDamage="2", dieSound=100041, mgroup=local_mgroup.mgroup_13, repelled=1, dropvalue=160, gloddropvalue=46, monsterCount=5},
	{id=90006, name="幻影骑士", ai=90006, appr=90006, icon="Monster54", level=310, scale=0.5, exp=35000, decaySign=1000, guaranteedDamage="2", dieSound=100046, mgroup=local_mgroup.mgroup_14, repelled=1, dropvalue=150, gloddropvalue=46, monsterCount=5},
	{id=90007, name="红魔龙", ai=90007, appr=90007, icon="Monster55_2", level=320, scale=0.3, exp=50000, decaySign=1000, guaranteedDamage="2", dieSound=100044, mgroup=local_mgroup.mgroup_15, repelled=1, dropvalue=140, gloddropvalue=46, monsterCount=5},
	{id=12002, name="裂角狼", ai=12002, appr=12002, icon="NewMonster_8", level=245, scale=0.3, exp=3200, decaySign=1000, guaranteedDamage="28", dieSound=100030, mgroup=local_mgroup.mgroup_16, repelled=1, dropvalue=155, gloddropvalue=33, monsterCount=3},
	{id=12003, name="金甲兽", ai=12003, appr=12003, icon="NewMonster_9", level=249, scale=0.5, exp=3500, decaySign=1000, guaranteedDamage="2", dieSound=100031, mgroup=local_mgroup.mgroup_17, repelled=1, dropvalue=155, gloddropvalue=33, monsterCount=3},
	{id=12004, name="半兽人", ai=12004, appr=12004, icon="NewMonster_10", level=255, scale=0.5, shapeshiftScale=1, exp=4000, decaySign=1000, guaranteedDamage="2", dieSound=100032, mgroup=local_mgroup.mgroup_18, repelled=1, dropvalue=155, gloddropvalue=33, monsterCount=4},
	{id=12005, name="刀刃猎手", ai=101, appr=12005, icon="NewMonster_11", level=260, scale=0.5, shapeshiftScale=1, exp=4500, decaySign=1000, guaranteedDamage="2", dieSound=100034, mgroup=local_mgroup.mgroup_19, dropvalue=135, gloddropvalue=33, monsterCount=4},
	{id=12006, name="寒冰刺客", ai=12006, appr=12006, level=265, scale=0.4, exp=5400, decaySign=1000, guaranteedDamage="2", dieSound=100033, mgroup=local_mgroup.mgroup_20, repelled=1, dropvalue=135, gloddropvalue=33, monsterCount=5},
	{id=12007, name="狂巨人", ai=12007, appr=12007, icon="monster151", level=270, scale=0.5, exp=5800, decaySign=1000, guaranteedDamage="2", dieSound=100035, mgroup=local_mgroup.mgroup_21, repelled=1, dropvalue=135, gloddropvalue=33, monsterCount=5},
	{id=13001, name="假面巫", ai=13001, appr=13001, icon="Monster115", level=290, scale=0.4, decaySign=1000, guaranteedDamage="3", dieSound=100039, mgroup=local_mgroup.mgroup_22, repelled=1, dropvalue=130, gloddropvalue=33, monsterCount=3},
	{id=13002, name="毒步妖", ai=13002, appr=13002, icon="NewMonster_19", level=295, scale=0.5, exp=8500, decaySign=1000, guaranteedDamage="3", dieSound=100038, mgroup=local_mgroup.mgroup_23, repelled=1, dropvalue=130, gloddropvalue=33, monsterCount=3},
	{id=13003, name="恐惧天使", ai=13003, appr=13003, icon="NewMonster_20", level=300, scale=0.5, exp=9000, decaySign=1000, guaranteedDamage="4", dieSound=100040, mgroup=local_mgroup.mgroup_24, repelled=1, dropvalue=130, gloddropvalue=33, monsterCount=4},
	{id=33001, name="真面巫", ai=13001, appr=13001, icon="Monster115", level=305, scale=0.4, exp=9500, decaySign=1000, guaranteedDamage="3", dieSound=100039, mgroup=local_mgroup.mgroup_25, repelled=1, dropvalue=130, gloddropvalue=33, monsterCount=4},
	{id=33002, name="剧毒步妖", ai=13002, appr=13002, icon="NewMonster_19", level=310, scale=0.5, exp=10000, decaySign=1000, guaranteedDamage="3", dieSound=100038, mgroup=local_mgroup.mgroup_26, repelled=1, dropvalue=130, gloddropvalue=33, monsterCount=5},
	{id=33003, name="恐惧大天使", ai=13003, appr=13003, icon="NewMonster_20", level=320, scale=0.5, exp=10500, decaySign=1000, guaranteedDamage="4", dieSound=100040, mgroup=local_mgroup.mgroup_27, repelled=1, dropvalue=130, gloddropvalue=33, monsterCount=5},
	{id=14001, name="冰之魔犬", ai=14001, appr=14001, icon="NewMonster_21", level=340, scale=0.45, exp=12000, decaySign=1000, guaranteedDamage="5", mgroup=local_mgroup.mgroup_28, repelled=1, dropvalue=140, gloddropvalue=33, monsterCount=3},
	{id=14003, name="冰之巨魔", ai=14003, appr=14003, icon="Monster148", level=345, scale=0.45, exp=12500, decaySign=1000, guaranteedDamage="6", mgroup=local_mgroup.mgroup_30, repelled=1, dropvalue=150, gloddropvalue=33, monsterCount=3},
	{id=14002, name="冰之魔象", ai=14002, appr=14002, icon="Monster147", level=350, scale=0.6, exp=13200, decaySign=1000, guaranteedDamage="6", mgroup=local_mgroup.mgroup_29, repelled=1, dropvalue=140, gloddropvalue=33, monsterCount=4},
	{id=14004, name="冰之魔蛛", ai=14004, appr=14004, icon="Monster177", level=355, exp=13888, decaySign=1000, guaranteedDamage="7", mgroup=local_mgroup.mgroup_31, repelled=1, dropvalue=140, gloddropvalue=33, monsterCount=4},
	{id=14005, name="冰铁剑魂", ai=14005, appr=14005, icon="Monster174", level=360, scale=0.65, exp=15000, decaySign=1000, guaranteedDamage="7", mgroup=local_mgroup.mgroup_32, repelled=1, dropvalue=140, gloddropvalue=33, monsterCount=5},
	{id=16001, name="树妖", ai=16001, appr=16001, icon="NewMonster_38", level=375, scale=0.6, exp=15600, decaySign=1000, guaranteedDamage="10", mgroup=local_mgroup.mgroup_33, repelled=1, dropvalue=150, gloddropvalue=24, monsterCount=3},
	{id=16002, name="毒树妖", ai=16002, appr=16002, icon="NewMonster_39", level=380, scale=0.6, exp=15800, decaySign=1000, guaranteedDamage="10", mgroup=local_mgroup.mgroup_34, repelled=1, dropvalue=150, gloddropvalue=24, monsterCount=3},
	{id=16003, name="残忍的树妖", ai=16003, appr=16003, icon="NewMonster_40", level=385, scale=0.6, exp=16000, decaySign=1000, guaranteedDamage="13", mgroup=local_mgroup.mgroup_35, repelled=1, dropvalue=150, gloddropvalue=24, monsterCount=4},
	{id=16004, name="暗影爪牙", ai=16004, appr=16004, icon="NewMonster_41", level=390, scale=0.6, exp=16000, decaySign=1000, guaranteedDamage="13", mgroup=local_mgroup.mgroup_36, repelled=1, dropvalue=150, gloddropvalue=24, monsterCount=4},
	{id=16005, name="暗影骑士", ai=16005, appr=16005, icon="NewMonster_42", level=395, scale=0.6, exp=16500, decaySign=1000, guaranteedDamage="15", mgroup=local_mgroup.mgroup_37, repelled=1, dropvalue=150, gloddropvalue=24, monsterCount=5},
	{id=16006, name="暗影武士", ai=16006, appr=16006, icon="NewMonster_43", level=400, scale=0.6, shapeshiftScale=1.2, exp=17200, decaySign=1000, guaranteedDamage="15", mgroup=local_mgroup.mgroup_38, repelled=1, dropvalue=150, gloddropvalue=24, monsterCount=5},
	{id=40006, name="冰后", ai=40006, type=3, appr=40006, icon="Monster19", level=88, scale=0.45, headoffset=1, np=1, exp=0, guaranteedDamage="50", attackSound=40013, birthSound=40011, deathmark="Model/Monster/Monster177.prefab", mgroup={40006}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, shengdaoshiexp=10000, dropvalue=30, gloddropvalue=100, KillGroup=local_KillGroup.KillGroup_3},
	{id=50012, name="魔鬼戈登", ai=50012, type=3, appr=50012, icon="Monster12_1", level=135, scale=0.55, headoffset=1, np=1, exp=0, guaranteedDamage="100", attackSound=40049, birthSound=40047, deathmark="Model/Monster/Monster177.prefab", mgroup={50012}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, shengdaoshiexp=10000, dropvalue=30, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_3},
	{id=60008, name="魔王巴洛克", ai=60008, type=3, icon="monster106_g", level=166, scale=0.7, headoffset=1, np=1, exp=0, guaranteedDamage="150", attackSound=40049, deathmark="Model/Monster/Monster177.prefab", mgroup={60008}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, shengdaoshiexp=10000, dropvalue=30, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_3},
	{id=70007, name="海魔希特拉", ai=70007, type=3, appr=70007, icon="Monster173", level=199, scale=0.4, headoffset=0.5, np=0.5, exp=0, guaranteedDamage="200", attackSound=40103, deathmark="Model/Monster/Monster177.prefab", mgroup={70007}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, shengdaoshiexp=10000, dropvalue=30, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_3},
	{id=80006, name="魔王扎坎", ai=80006, type=3, appr=80007, icon="Monster43_2", level=219, scale=0.73, exp=0, guaranteedDamage="300", attackSound=40034, deathmark="Model/Monster/Monster177.prefab", mgroup={80006}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, shengdaoshiexp=20000, dropvalue=30, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_3},
	{id=80007, name="炽炎魔", ai=80007, type=3, appr=80006, icon="Monster57_g", level=239, scale=0.59, exp=0, guaranteedDamage="400", attackSound=40094, deathEffect=local_deathEffect.deathEffect_3, deathmark="Model/Monster/Monster177.prefab", mgroup={80007}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, shengdaoshiexp=20000, dropvalue=30, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_3},
	{id=11010, name="丛林召唤者", ai=11010, type=3, appr=11010, icon="Monster165", level=270, scale=0.7, exp=0, guaranteedDamage="400", attackSound=100052, dieSound=100053, deathmark="Model/Monster/Monster177.prefab", mgroup={11010}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, shengdaoshiexp=40000, dropvalue=30, gloddropvalue=30, KillGroup=local_KillGroup.KillGroup_3},
	{id=90008, name="天魔菲尼斯", ai=90008, type=3, appr=90008, icon="Monster56", level=330, UIscale=0.32, exp=0, guaranteedDamage="500", deathmark="Model/Monster/Monster177.prefab", mgroup={90008}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, shengdaoshiexp=30000, dropvalue=30, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_3},
	{id=14012, name="冰霜巨蛛", ai=14012, type=3, appr=21001, icon="Monster174", level=380, scale=0.7, exp=0, guaranteedDamage="146", deathmark="Model/Monster/Monster177.prefab", mgroup={14012}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_3},
	{id=12001, name="疯魔", ai=12001, appr=12001, icon="Monster166", level=280, scale=0.4, shapeshiftScale=1, exp=6500, guaranteedDamage="25", dieSound=100036, deathmark="Model/Monster/Monster177.prefab", mgroup={12001}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, dropvalue=175, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_3},
	{id=12008, name="屠杀者", ai=12008, appr=12008, icon="Monster167", level=285, scale=0.5, exp=7500, guaranteedDamage="27", dieSound=100037, deathmark="Model/Monster/Monster177.prefab", mgroup={12008}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, dropvalue=135, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_3},
	{id=13006, name="咒怨魔王", ai=13006, type=3, appr=25020, icon="NewMonster_74", level=400, scale=0.65, exp=8888, guaranteedDamage="66", mgroup={13006}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, dropvalue=130, gloddropvalue=100, KillGroup=local_KillGroup.KillGroup_3},
	{id=10008, name="火龙王", ai=10008, type=3, appr=10008, icon="Monster32", level=280, headoffset=1, np=1, exp=8888, mgroup={10008}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, dropvalue=100, gloddropvalue=99999, KillGroup=local_KillGroup.KillGroup_1},
	{id=23001, name="阿卡斯", ai=23001, appr=23001, icon="NewMonster_86", level=111, scale=0.6, exp=3800, guaranteedDamage="363", mgroup={23001}, dropvalue=180, gloddropvalue=99999, KillGroup=local_KillGroup.KillGroup_1},
	{id=23002, name="武士", ai=23002, appr=23002, icon="NewMonster_87", level=114, scale=0.45, exp=4200, guaranteedDamage="385", mgroup={23002}, dropvalue=180, gloddropvalue=99999, KillGroup=local_KillGroup.KillGroup_1},
	{id=23003, name="龙虾守卫", ai=23003, appr=23003, icon="NewMonster_88", level=117, exp=4600, guaranteedDamage="403", mgroup={23003}, dropvalue=180, gloddropvalue=99999, KillGroup=local_KillGroup.KillGroup_1},
	{id=23004, name="死亡天使", ai=23004, appr=23004, icon="NewMonster_89", level=121, scale=0.5, exp=5000, mgroup={23004}, dropvalue=160, gloddropvalue=99999, KillGroup=local_KillGroup.KillGroup_1},
	{id=23005, name="暗黑巫师", ai=23005, appr=23005, icon="NewMonster_90", level=125, exp=5400, mgroup={23005}, dropvalue=160, gloddropvalue=99999, KillGroup=local_KillGroup.KillGroup_1},
	{id=23006, name="狂武士", ai=23006, appr=23006, icon="NewMonster_91", level=130, exp=5700, mgroup={23006}, dropvalue=160, gloddropvalue=99999, KillGroup=local_KillGroup.KillGroup_1},
	{id=23007, name="暗黑傀儡", appr=23007, icon="NewMonster_92", level=135, exp=6000, mgroup={23007}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=160, gloddropvalue=99999, KillGroup=local_KillGroup.KillGroup_1},
	{id=23008, name="魔王昆顿", ai=23008, type=3, appr=23008, icon="NewMonster_93", level=400, scale=0.83, shapeshiftScale=1, exp=0, mgroup={23008}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, dropvalue=140, gloddropvalue=99999, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001023, name="深渊之巴洛克", ai=60008, type=3, icon="Monster28", level=66, scale=0.7, headoffset=1, np=1, attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", mgroup={21001023}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001024, name="深渊之希特拉", ai=70007, type=3, appr=70007, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, attackSound=40103, dieSound=40046, deathmark="Model/Monster/Monster177.prefab", mgroup={21001024}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001025, name="深渊之炽炎魔", ai=80007, type=3, appr=80006, icon="Monster43_2", level=93, scale=0.59, attackSound=40094, dieSound=40093, deathEffect=local_deathEffect.deathEffect_3, deathmark="Model/Monster/Monster177.prefab", mgroup={21001025}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001026, name="深渊之菲尼斯", ai=90008, type=3, appr=90008, icon="Monster56", level=108, UIscale=0.32, attackSound=40070, dieSound=40072, deathmark="Model/Monster/Monster177.prefab", mgroup={21001026}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001027, name="独眼巨人", ai=21001027, beSelect=1, beMonsterSelect=1, appr=610002, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001027}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001028, name="小魔剑", ai=21001028, beSelect=1, beMonsterSelect=1, appr=610003, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001028}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001029, name="小法法", ai=21001029, beSelect=1, beMonsterSelect=1, appr=610004, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001029}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001030, name="双戟骑士", ai=21001030, beSelect=1, beMonsterSelect=1, appr=610005, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001030}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001031, name="婕拉", ai=21001031, beSelect=1, beMonsterSelect=1, appr=610006, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001031}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001032, name="皇家武士", ai=21001032, beSelect=1, beMonsterSelect=1, appr=610007, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001032}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001033, name="咩咩", ai=21001033, beSelect=1, beMonsterSelect=1, appr=610008, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001033}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001034, name="巨爪机关", ai=21001034, beSelect=1, beMonsterSelect=1, appr=610009, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001034}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001035, name="小战战", ai=21001035, beSelect=1, beMonsterSelect=1, appr=610010, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001035}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001036, name="茉莉", ai=21001036, beSelect=1, beMonsterSelect=1, appr=610011, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001036}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001037, name="金甲虫", ai=21001037, beSelect=1, beMonsterSelect=1, appr=610012, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001037}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001038, name="小mm", ai=21001038, beSelect=1, beMonsterSelect=1, appr=610013, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001038}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001039, name="海贼", ai=21001039, beSelect=1, beMonsterSelect=1, appr=610014, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001039}, KillGroup=local_KillGroup.KillGroup_1},
	{id=21001040, name="法老守卫", ai=21001040, beSelect=1, beMonsterSelect=1, appr=610015, icon="Monster03", level=4, scale=0.15, headoffset=-0.8, exp=0, pveCrossModel=2, attackSound=40039, dieSound=40040, birthSound=40038, mgroup={21001040}, KillGroup=local_KillGroup.KillGroup_1},
	{id=27001, name="召唤哥布林", ai=148, appr=20001, icon="Monster20_1", level=3, headoffset=-0.35, np=-0.35, exp=0, mgroup={27001}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27002, name="召唤哥布林", ai=149, appr=20001, icon="Monster20_1", level=3, headoffset=-0.35, np=-0.35, exp=0, mgroup={27002}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27003, name="召唤哥布林", ai=150, appr=20001, icon="Monster20_1", level=3, headoffset=-0.35, np=-0.35, exp=0, mgroup={27003}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27004, name="召唤石巨人", ai=153, appr=20009, icon="Monster26", level=18, scale=0.3, headoffset=1.5, np=1.5, exp=0, deathEffect=local_deathEffect.deathEffect_4, mgroup={27004}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27005, name="召唤石巨人", ai=154, appr=20009, icon="Monster26", level=18, scale=0.3, headoffset=1.5, np=1.5, exp=0, deathEffect=local_deathEffect.deathEffect_4, mgroup={27005}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27006, name="召唤石巨人", ai=155, appr=20009, icon="Monster26", level=18, scale=0.3, headoffset=1.5, np=1.5, exp=0, deathEffect=local_deathEffect.deathEffect_4, mgroup={27006}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27007, name="召唤暗杀者", ai=148, appr=50002, icon="Monster15", level=26, scale=0.4, headoffset=0.15, np=0.15, exp=0, mgroup={27007}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27008, name="召唤暗杀者", ai=149, appr=50002, icon="Monster15", level=26, scale=0.4, headoffset=0.15, np=0.15, exp=0, mgroup={27008}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27009, name="召唤暗杀者", ai=150, appr=50002, icon="Monster15", level=26, scale=0.4, headoffset=0.15, np=0.15, exp=0, mgroup={27009}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27010, name="召唤雪人王", ai=148, appr=40005, icon="Monster14", level=36, scale=0.55, headoffset=0.5, np=0.5, exp=0, mgroup={27010}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27011, name="召唤雪人王", ai=149, appr=40005, icon="Monster14", level=36, scale=0.55, headoffset=0.5, np=0.5, exp=0, mgroup={27011}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27012, name="召唤雪人王", ai=150, appr=40005, icon="Monster14", level=36, scale=0.55, headoffset=0.5, np=0.5, exp=0, mgroup={27012}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27013, name="召唤暗黑骑士", ai=148, appr=50008, icon="Monster04", level=48, headoffset=0.35, np=0.35, exp=0, mgroup={27013}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27014, name="召唤暗黑骑士", ai=149, appr=50008, icon="Monster04", level=48, headoffset=0.35, np=0.35, exp=0, mgroup={27014}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27015, name="召唤暗黑骑士", ai=150, appr=50008, icon="Monster04", level=48, headoffset=0.35, np=0.35, exp=0, mgroup={27015}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27016, name="召唤黄金斗士", ai=148, appr=26001, icon="Monster04", level=100, headoffset=0.35, np=0.35, exp=0, mgroup={27016}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27017, name="召唤黄金斗士", ai=149, appr=26001, icon="Monster04", level=100, headoffset=0.35, np=0.35, exp=0, mgroup={27017}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27018, name="召唤黄金斗士", ai=150, appr=26001, icon="Monster04", level=100, headoffset=0.35, np=0.35, exp=0, mgroup={27018}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27019, name="召唤守护兽巴里", ai=148, appr=26982, icon="Monster04", level=150, headoffset=0.35, np=0.35, exp=0, mgroup={27019}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27020, name="召唤守护兽巴里", ai=149, appr=26982, icon="Monster04", level=150, headoffset=0.35, np=0.35, exp=0, mgroup={27020}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=27021, name="召唤守护兽巴里", ai=150, appr=26982, icon="Monster04", level=150, headoffset=0.35, np=0.35, exp=0, mgroup={27021}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, petEffect=39},
	{id=60000601, name="死神", ai=0, type=0, appr=600006, icon="", level=0, scale=0.15, exp=0, guaranteedDamage="", mgroup={60000601}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=60000612, name="天鹰", ai=60000612, beSelect=1, beMonsterSelect=1, appr=610001, icon="", level=0, scale=0, headoffset=100, np=100, exp=0, mgroup={60000612}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=27022, name="宝藏骷髅兵", ai=27022, appr=10003, icon="Monster163", scale=0.38, shapeshiftScale=1, headoffset=0.2, np=0.2, exp=288, attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, mgroup={27022}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27023, name="宝藏牛魔王", ai=27023, appr=60004, icon="Monster31", scale=0.5, headoffset=0.45, np=0.45, exp=288, attackSound=40065, dieSound=40067, mgroup={27023}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27024, name="宝藏毒虫", ai=27024, appr=50001, icon="Monster07", scale=0.3, headoffset=-0.45, np=-0.45, exp=288, attackSound=40061, dieSound=40062, mgroup={27024}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27025, name="宝藏死灵巫师", ai=27025, appr=50010, icon="Monster05_1", scale=0.4, headoffset=0.35, np=0.35, exp=288, attackSound=40112, dieSound=40114, mgroup={27025}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27026, name="宝藏毒牛怪", ai=27026, appr=50011, icon="Monster01_3", scale=0.5, shapeshiftScale=1, headoffset=0.45, np=0.45, exp=288, attackSound=40065, dieSound=40067, birthSound=40063, mgroup={27026}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27027, name="宝藏鬼魂", ai=27027, appr=60001, icon="Monster29", scale=0.5, headoffset=0, np=0, exp=288, attackSound=40107, dieSound=40109, birthSound=40105, mgroup={27027}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27028, name="宝藏剧毒鬼魂", ai=27028, appr=60002, icon="Monster29_02", scale=0.5, headoffset=0, np=0, exp=288, attackSound=40107, dieSound=40109, birthSound=40105, mgroup={27028}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27029, name="宝藏恶魔", ai=27029, appr=60005, icon="Monster27", scale=0.5, headoffset=0.45, np=0.45, exp=288, attackSound=40003, dieSound=40005, mgroup={27029}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27030, name="宝藏死神骑士", ai=27030, appr=60006, icon="Monster30", scale=0.5, headoffset=0.5, np=0.5, exp=288, attackSound=40117, dieSound=40119, mgroup={27030}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27031, name="宝藏小巴哈姆特", ai=27031, appr=70001, icon="Monster34", scale=0.25, headoffset=0, np=0, exp=288, attackSound=40037, dieSound=40046, mgroup={27031}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27032, name="宝藏蓝翼海怪", ai=27032, appr=70003, icon="Monster36_1", scale=0.43, headoffset=0.65, np=0.65, exp=288, attackSound=40103, dieSound=40046, deathEffect=local_deathEffect.deathEffect_5, mgroup={27032}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27033, name="宝藏大巴哈姆特", ai=27033, appr=70004, icon="Monster34_1", scale=0.4, headoffset=0.35, np=0.35, exp=288, attackSound=40103, dieSound=40046, mgroup={27033}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27034, name="宝藏巫师王", ai=27034, appr=70006, icon="Monster37", scale=0.65, headoffset=0.85, np=0.85, exp=288, attackSound=40103, dieSound=40046, mgroup={27034}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27035, name="宝藏铁脊怪", ai=27035, appr=80001, icon="Monster46", scale=0.62, exp=288, attackSound=40034, dieSound=40036, mgroup={27035}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27036, name="宝藏巨齿兽", ai=27036, appr=80002, icon="Monster44", scale=0.9, exp=288, attackSound=40034, dieSound=40036, mgroup={27036}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27037, name="宝藏破坏骑士", ai=27037, appr=80004, scale=0.73, exp=288, attackSound=40034, dieSound=40036, mgroup={27037}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27038, name="宝藏黑炎魔", ai=27038, appr=80005, icon="Monster45", scale=0.5, exp=288, attackSound=40094, dieSound=40093, deathEffect=local_deathEffect.deathEffect_3, mgroup={27038}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27039, name="宝藏阿卡摩斯", ai=27039, appr=90002, icon="Monster104", exp=288, guaranteedDamage="2", attackSound=40070, dieSound=40072, mgroup={27039}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27040, name="宝藏恶灵", ai=27040, appr=90001, icon="Monster105", scale=0.5, exp=288, attackSound=40070, dieSound=40072, mgroup={27040}, KillGroup=local_KillGroup.KillGroup_1},
	{id=27041, name="宝藏蓝魔龙", ai=27041, appr=90004, icon="Monster102", scale=0.5, exp=288, guaranteedDamage="2", attackSound=40070, dieSound=40072, mgroup={27041}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27042, name="宝藏红魔龙", ai=27042, appr=90007, icon="Monster55_2", scale=0.3, exp=288, guaranteedDamage="2", attackSound=40070, dieSound=40072, mgroup={27042}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27043, name="宝藏幻影骑士", ai=27043, appr=90006, icon="Monster54", scale=0.5, exp=288, guaranteedDamage="2", attackSound=40070, dieSound=40072, mgroup={27043}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27044, name="宝藏风后", ai=27044, appr=90003, icon="Monster103", scale=0.5, exp=288, guaranteedDamage="2", attackSound=40070, dieSound=40072, mgroup={27044}, KillGroup=local_KillGroup.KillGroup_1},
	{id=27045, name="宝藏铁轮战士", ai=27045, appr=80003, icon="NewMonster_1", scale=0.5, exp=288, attackSound=40034, dieSound=40036, mgroup={27045}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27046, name="宝藏银弓海怪", ai=27046, appr=70005, icon="Monster36_2", scale=0.65, headoffset=1.25, np=1.25, exp=288, attackSound=40103, dieSound=40046, mgroup={27046}, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27047, name="玛雅左手", ai=27047, type=3, appr=19002, icon="Monster171", level=135, scale=0.6, exp=8888, mgroup={27047}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=27048, name="玛雅右手", ai=27048, type=3, appr=19003, icon="Monster172", level=135, scale=0.6, exp=8888, mgroup={27048}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=27049, name="【一阶】北部魔王", ai=27049, type=3, appr=70006, icon="Monster37", level=55, scale=0.65, headoffset=0.85, np=0.85, exp=1888, attackSound=40103, dieSound=40046, mgroup={27049}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, repelled=1, KillGroup=local_KillGroup.KillGroup_1},
	{id=27050, name="【二阶】东部魔王", ai=27050, type=3, appr=23004, icon="NewMonster_89", level=55, scale=0.5, exp=1888, mgroup={27050}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=27051, name="【三阶】南部魔王", ai=27051, type=3, icon="Monster28", level=66, scale=0.7, headoffset=1, np=1, exp=1888, attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", mgroup={27051}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=27052, name="【四阶】西部魔王", ai=27052, type=3, appr=80006, icon="Monster43_2", level=90, scale=0.59, exp=3888, guaranteedDamage="6", attackSound=40094, dieSound=40093, deathEffect=local_deathEffect.deathEffect_3, deathmark="Model/Monster/Monster177.prefab", mgroup={27052}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=27053, name="【五阶】迷雾之主", ai=27053, type=3, appr=80007, icon="Monster_45_2", level=93, scale=0.73, exp=3888, guaranteedDamage="6", attackSound=40034, dieSound=40036, deathmark="Model/Monster/Monster177.prefab", mgroup={27053}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1},
	{id=27054, name="假面巫", ai=27054, appr=13001, icon="Monster115", level=118, scale=0.5, exp=5888, guaranteedDamage="3", mgroup={27054}, repelled=1, dropvalue=130, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_1},
	{id=27055, name="毒步妖", ai=27055, appr=13002, icon="NewMonster_19", level=117, scale=0.5, exp=5888, guaranteedDamage="3", mgroup={27055}, repelled=1, dropvalue=130, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_1},
	{id=27056, name="恐惧天使", ai=27056, appr=13003, icon="monster133", level=119, scale=0.65, exp=5888, guaranteedDamage="4", mgroup={27056}, repelled=1, dropvalue=130, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_1},
	{id=16007, name="闪电巨人", ai=16007, appr=16007, icon="Monster168", level=400, scale=0.6, exp=14888, guaranteedDamage="198", deathmark="Model/Monster/Monster177.prefab", mgroup={16007}, efficiencyLvIcon="img_minimap__boss2", monsterShowIcon=0, txtColor=271, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=16008, name="幽灵巨人", ai=101, appr=16008, icon="Monster169", level=400, scale=0.6, exp=14888, guaranteedDamage="60", deathmark="Model/Monster/Monster177.prefab", mgroup={16008}, efficiencyLvIcon="img_minimap__boss2", monsterShowIcon=0, txtColor=271, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=16009, name="火焰巨人", ai=16009, appr=16009, icon="Monster186", level=400, scale=0.6, exp=15888, guaranteedDamage="242", deathmark="Model/Monster/Monster177.prefab", mgroup={16009}, efficiencyLvIcon="img_minimap__boss2", monsterShowIcon=0, txtColor=271, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=16014, name="美杜莎", ai=16014, type=3, appr=16014, level=500, scale=0.65, exp=8888, guaranteedDamage="10", deathmark="Model/Monster/Monster177.prefab", mgroup={16014}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=22002, name="假面武士", ai=127, appr=22004, icon="NewMonster_82", level=74, np=0, exp=2888, guaranteedDamage="", mgroup={22002}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=22001, name="假面弓手", ai=128, appr=22005, icon="NewMonster_83", level=70, np=0, exp=2888, guaranteedDamage="", mgroup={22001}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=24003, name="巨斧战士", ai=106, appr=24001, icon="NewMonster_95", level=75, np=0, exp=2888, guaranteedDamage="", mgroup={24003}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=24004, name="冷血变异者", ai=107, appr=24002, icon="NewMonster_96", level=78, scale=0.5, np=0, exp=2888, guaranteedDamage="", mgroup={24004}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=24005, name="毒巨魔", ai=24003, appr=24003, icon="NewMonster_97", level=84, scale=0.8, np=0, exp=3888, guaranteedDamage="", deathmark="1881", mgroup={24005}, efficiencyLvIcon="1", dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=24006, name="嗜血蜂后", ai=24004, appr=24004, icon="NewMonster_98", level=92, scale=0.9, np=0, exp=3888, guaranteedDamage="", deathmark="1881", mgroup={24006}, efficiencyLvIcon="1", dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=24007, name="熔岩巨魔", ai=24005, appr=24005, icon="NewMonster_99", level=102, scale=0.8, np=0, exp=4888, guaranteedDamage="", deathmark="1881", mgroup={24007}, efficiencyLvIcon="1", dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1},
	{id=46001, name="外城门", ai=100, type=3, form=1, appr=22007, level=20, scale=0.4, headoffset=1.7, exp=0, angelExp=0, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=46002, name="中城门", ai=100, type=3, form=1, appr=22007, level=20, scale=0.4, headoffset=1.7, exp=0, angelExp=0, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=46003, name="内城门", ai=100, type=3, form=1, appr=22007, level=20, scale=0.4, headoffset=1.7, exp=0, angelExp=0, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=46004, name="守护石像A", ai=100, form=1, appr=29001, level=20, scale=0.4, headoffset=1.7, exp=0, angelExp=0, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=46005, name="守护石像B", ai=100, form=1, appr=29001, level=20, scale=0.4, headoffset=1.7, exp=0, angelExp=0, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=46006, name="守护石像C", ai=100, form=1, appr=29001, level=20, scale=0.4, headoffset=1.7, exp=0, angelExp=0, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=46007, name="守护石像D", ai=100, form=1, appr=29001, level=20, scale=0.4, headoffset=1.7, exp=0, angelExp=0, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=100001, name="荣耀旗帜", ai=100001, beSelect=1, beMonsterSelect=1, appr=100001, icon="NewMonster_63", level=0, scale=1, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001001, name="刺锤侦察兵", ai=15001001, appr=17001, icon="NewMonster_48", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001001}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001002, name="长矛侦察兵", ai=15001002, appr=17002, icon="NewMonster_49", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001002}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001003, name="魔弓侦察兵", ai=15001003, appr=17003, icon="NewMonster_50", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001003}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001004, name="刺锤侦察兵", ai=15001001, appr=17001, icon="NewMonster_48", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001004}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001005, name="长矛侦察兵", ai=15001002, appr=17002, icon="NewMonster_49", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001005}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001006, name="魔弓侦察兵", ai=15001003, appr=17003, icon="NewMonster_50", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001006}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001007, name="暗黑扫荡者", ai=15001004, appr=17008, icon="NewMonster_55", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001007}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001008, name="暗黑血狼人", ai=15001005, appr=17004, icon="NewMonster_51", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001008}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001009, name="暗黑防御者", ai=15001006, appr=17007, icon="NewMonster_54", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001009}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001010, name="暗黑扫荡者", ai=15001004, appr=17008, icon="NewMonster_55", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001010}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001011, name="暗黑血狼人", ai=15001005, appr=17004, icon="NewMonster_51", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001011}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001012, name="暗黑防御者", ai=15001006, appr=17007, icon="NewMonster_54", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001012}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001013, name="英雄侦察兵", ai=15001007, appr=17005, level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001013}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001014, name="暗黑防御者", ai=15001006, appr=17007, icon="NewMonster_54", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001014}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001015, name="英雄铁脊怪", ai=15001009, appr=17009, icon="NewMonster_56", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001015}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001016, name="英雄侦察兵", ai=15001007, appr=17005, level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001016}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001017, name="暗黑防御者", ai=15001006, appr=17007, icon="NewMonster_54", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001017}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001018, name="英雄铁脊怪", ai=15001009, appr=17009, icon="NewMonster_56", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001018}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001019, name="英雄血狼人", ai=15001008, appr=17006, icon="NewMonster_51", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001019}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001020, name="魔弓侦察兵", ai=15001003, appr=17003, icon="NewMonster_50", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001020}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001021, name="暗黑咒术师", ai=15001010, appr=17014, icon="NewMonster_61", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001021}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001022, name="英雄血狼人", ai=15001008, appr=17006, icon="NewMonster_51", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001022}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001023, name="魔弓侦察兵", ai=15001003, appr=17003, icon="NewMonster_50", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001023}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001024, name="暗黑咒术师", ai=15001010, appr=17014, icon="NewMonster_61", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001024}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001025, name="英雄血狼人", ai=15001008, appr=17006, icon="NewMonster_51", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001025}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001026, name="暗黑咒术师", ai=15001010, appr=17014, icon="NewMonster_61", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001026}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001027, name="暗黑扫荡者", ai=15001004, appr=17008, icon="NewMonster_55", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001027}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001028, name="英雄血狼人", ai=15001008, appr=17006, icon="NewMonster_51", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001028}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001029, name="暗黑咒术师", ai=15001010, appr=17014, icon="NewMonster_61", level=97, scale=0.3, exp=288, angelExp=0, mgroup={15001029}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001030, name="暗黑扫荡者", ai=15001004, appr=17008, icon="NewMonster_55", level=97, scale=0.3, exp=288, angelExp=0, mgroup=local_mgroup.mgroup_3, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001051, name="【普通】弓箭手", ai=15001051, beSelect=1, appr=17017, icon="NewMonster_64", level=3, scale=0.3, exp=288, angelExp=0, mgroup={15001051}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001052, name="【精英】弓箭手", ai=15001052, beSelect=1, appr=17018, icon="NewMonster_65", level=3, scale=0.3, exp=288, angelExp=0, mgroup={15001052}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001053, name="【传奇】弓箭手", ai=15001053, beSelect=1, appr=17019, icon="NewMonster_66", level=3, scale=0.3, exp=288, angelExp=0, mgroup={15001053}, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001054, name="暗黑指挥官", ai=15001011, appr=17013, icon="NewMonster_60", level=135, scale=0.5, exp=288, angelExp=0, mgroup=local_mgroup.mgroup_3, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=15001055, name="巴卡斯司令官", ai=15001012, appr=17015, icon="NewMonster_62", level=135, scale=0.5, exp=288, angelExp=0, mgroup=local_mgroup.mgroup_3, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1},
	{id=17016, name="狼神护台", ai=100, type=3, beSelect=1, form=1, appr=17016, icon="NewMonster_63", level=100, scale=1, exp=8888, angelExp=0, mgroup={17016}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500004, name="黄金蓝魔怪", ai=500004, type=2, appr=28004, icon="Monster17", level=30, scale=0.45, headoffset=0.45, np=0.45, exp=23888, attackSound=40086, dieSound=40089, birthSound=40087, mgroup={500004}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_2, KillGroup=local_KillGroup.KillGroup_1},
	{id=500001, name="黄金寒冰魔", ai=500001, type=2, appr=28001, icon="Monster16", level=40, headoffset=0, np=0, exp=25888, attackSound=40029, dieSound=40031, birthSound=40030, deathEffect=local_deathEffect.deathEffect_6, mgroup={500001}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_2, KillGroup=local_KillGroup.KillGroup_1},
	{id=500017, name="黄金暗黑骑士", ai=500017, type=2, appr=28017, icon="Monster04", level=50, scale=0.5, headoffset=0.35, np=0.35, exp=38888, attackSound=40117, dieSound=40119, birthSound=40115, mgroup={500017}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop={{1,20310321},{1,20610321},{2,20120321},{2,20420321},{3,20130321},{3,20430321},{1,50030002},{1,50030003},{2,50030002},{2,50030003},{3,50030002},{3,50030003}}, KillGroup=local_KillGroup.KillGroup_1},
	{id=500101, name="黄金鬼魂", ai=500101, type=2, appr=28019, icon="Monster05_1", level=60, scale=0.5, headoffset=0, np=0, exp=128888, attackSound=40112, dieSound=40114, birthSound=40110, mgroup={500101}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_3, KillGroup=local_KillGroup.KillGroup_1},
	{id=500018, name="黄金牛魔王", ai=500018, type=2, appr=28018, icon="Monster31", level=70, scale=0.5, headoffset=0.45, np=0.45, exp=138888, attackSound=40065, dieSound=40067, mgroup={500018}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_3, KillGroup=local_KillGroup.KillGroup_1},
	{id=500024, name="黄金死神戈登", ai=500024, type=2, appr=28024, icon="Monster12_2", level=80, scale=0.5, headoffset=0.5, np=0.5, exp=148888, attackSound=40049, dieSound=40051, mgroup={500024}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_3, KillGroup=local_KillGroup.KillGroup_1},
	{id=500025, name="黄金小巴哈姆特", ai=500025, type=2, appr=28025, icon="Monster34", level=90, scale=0.25, headoffset=0, np=0, exp=198888, attackSound=40037, dieSound=40046, mgroup={500025}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_3, KillGroup=local_KillGroup.KillGroup_1},
	{id=500026, name="黄金死亡美人鱼", ai=500026, type=2, appr=28026, icon="Monster35", level=100, scale=0.43, headoffset=0.85, np=0.85, exp=199999, attackSound=40103, dieSound=40046, mgroup={500026}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_3, KillGroup=local_KillGroup.KillGroup_1},
	{id=11001001, name="假面武士", ai=11001001, appr=22004, level=100, exp=3388, guaranteedDamage="", mgroup={11001001}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11001002, name="假面弓手", ai=11001002, appr=22005, level=100, exp=3388, guaranteedDamage="", mgroup={11001002}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11001003, name="骷灵战士", ai=11001003, appr=22006, level=100, exp=3388, guaranteedDamage="", mgroup={11001003}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11001004, name="骷灵兽", ai=11001004, appr=22001, level=100, scale=0.3, exp=3388, guaranteedDamage="", mgroup={11001004}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11001005, name="骷灵骑士", ai=11001005, appr=22002, icon="NewMonster_80", level=100, exp=3388, guaranteedDamage="", mgroup={11001005}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11001006, name="骷灵巫师", ai=11001006, appr=22003, icon="NewMonster_81", level=100, exp=3388, guaranteedDamage="", mgroup={11001006}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11001007, name="血色城门", ai=11001007, type=3, form=1, appr=22007, icon="Monster_cm", level=100, scale=0.4, uipos=local_uipos.uipos_2, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11001008, name="水晶灵柩", ai=11001008, type=3, form=1, appr=22008, icon="Monster_sjlj", level=100, scale=0.5, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=170, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11002001, name="假面武士", ai=11001001, appr=22005, level=150, exp=7000, guaranteedDamage="", mgroup={11002001}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11002002, name="假面弓手", ai=11001002, appr=22006, level=150, exp=7000, guaranteedDamage="", mgroup={11002002}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11002003, name="骷灵战士", ai=11001003, appr=22004, level=150, exp=7000, guaranteedDamage="", mgroup={11002003}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11002004, name="骷灵兽", ai=11001004, appr=22001, level=150, scale=0.3, exp=7000, guaranteedDamage="", mgroup={11002004}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11002005, name="骷灵骑士", ai=11001005, appr=22002, icon="NewMonster_80", level=150, exp=7888, guaranteedDamage="", mgroup={11002005}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11002006, name="骷灵巫师", ai=11001006, appr=22003, icon="NewMonster_81", level=150, exp=7888, guaranteedDamage="", mgroup={11002006}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11002007, name="血色城门", ai=11001007, type=3, form=1, appr=22007, icon="Monster_cm", level=150, scale=0.4, uipos=local_uipos.uipos_2, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11002008, name="水晶灵柩", ai=11001008, type=3, form=1, appr=22008, icon="Monster_sjlj", level=150, scale=0.5, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11003001, name="假面武士", ai=11001001, appr=22005, level=199, exp=15888, guaranteedDamage="", mgroup={11003001}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11003002, name="假面弓手", ai=11001002, appr=22006, level=199, exp=15888, guaranteedDamage="", mgroup={11003002}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11003003, name="骷灵战士", ai=11001003, appr=22004, level=199, exp=15888, guaranteedDamage="", mgroup={11003003}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=170, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11003004, name="骷灵兽", ai=11001004, appr=22001, level=199, scale=0.3, exp=15888, guaranteedDamage="", mgroup={11003004}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11003005, name="骷灵骑士", ai=11001005, appr=22002, icon="NewMonster_80", level=199, exp=17888, guaranteedDamage="", mgroup={11003005}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11003006, name="骷灵巫师", ai=11001006, appr=22003, icon="NewMonster_81", level=199, exp=17888, guaranteedDamage="", mgroup={11003006}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11003007, name="血色城门", ai=11001007, type=3, form=1, appr=22007, icon="Monster_cm", level=199, scale=0.4, uipos=local_uipos.uipos_2, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11003008, name="水晶灵柩", ai=11001008, type=3, form=1, appr=22008, icon="Monster_sjlj", level=249, scale=0.5, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11004001, name="假面武士", ai=11001001, appr=22005, level=249, exp=20888, guaranteedDamage="", mgroup={11004001}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11004002, name="假面弓手", ai=11001002, appr=22006, level=249, exp=20888, guaranteedDamage="", mgroup={11004002}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11004003, name="骷灵战士", ai=11001003, appr=22004, level=249, exp=20888, guaranteedDamage="", mgroup={11004003}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11004004, name="骷灵兽", ai=11001004, appr=22001, level=249, scale=0.3, exp=20888, guaranteedDamage="", mgroup={11004004}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11004005, name="骷灵骑士", ai=11001005, appr=22002, icon="NewMonster_80", level=249, exp=24888, guaranteedDamage="", mgroup={11004005}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11004006, name="骷灵巫师", ai=11001006, appr=22003, icon="NewMonster_81", level=249, exp=24888, guaranteedDamage="", mgroup={11004006}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=170, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11004007, name="血色城门", ai=11001007, type=3, form=1, appr=22007, icon="Monster_cm", level=249, scale=0.4, uipos=local_uipos.uipos_2, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11004008, name="水晶灵柩", ai=11001008, type=3, form=1, appr=22008, icon="Monster_sjlj", level=249, scale=0.5, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11005001, name="假面武士", ai=11001001, appr=22005, level=300, exp=27888, guaranteedDamage="", mgroup={11005001}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11005002, name="假面弓手", ai=11001002, appr=22006, level=300, exp=27888, guaranteedDamage="", mgroup={11005002}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11005003, name="骷灵战士", ai=11001003, appr=22004, level=300, exp=27888, guaranteedDamage="", mgroup={11005003}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11005004, name="骷灵兽", ai=11001004, appr=22001, level=300, scale=0.3, exp=27888, guaranteedDamage="", mgroup={11005004}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11005005, name="骷灵骑士", ai=11001005, appr=22002, icon="NewMonster_80", level=300, exp=30888, guaranteedDamage="", mgroup={11005005}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11005006, name="骷灵巫师", ai=11001006, appr=22003, icon="NewMonster_81", level=300, exp=30888, guaranteedDamage="", mgroup={11005006}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11005007, name="血色城门", ai=11001007, type=3, form=1, appr=22007, icon="Monster_cm", level=300, scale=0.4, uipos=local_uipos.uipos_2, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11005008, name="水晶灵柩", ai=11001008, type=3, form=1, appr=22008, icon="Monster_sjlj", level=350, scale=0.5, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11006001, name="假面武士", ai=11001001, appr=22005, level=350, exp=35888, guaranteedDamage="", mgroup={11006001}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=170, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11006002, name="假面弓手", ai=11001002, appr=22006, level=350, exp=35888, guaranteedDamage="", mgroup={11006002}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11006003, name="骷灵战士", ai=11001003, appr=22004, level=350, exp=35888, guaranteedDamage="", mgroup={11006003}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11006004, name="骷灵兽", ai=11001004, appr=22001, level=350, scale=0.3, exp=35888, guaranteedDamage="", mgroup={11006004}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11006005, name="骷灵骑士", ai=11001005, appr=22002, icon="NewMonster_80", level=350, exp=38888, guaranteedDamage="", mgroup={11006005}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11006006, name="骷灵巫师", ai=11001006, appr=22003, icon="NewMonster_81", level=350, exp=38888, guaranteedDamage="", mgroup={11006006}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11006007, name="血色城门", ai=11001007, type=3, form=1, appr=22007, icon="Monster_cm", level=350, scale=0.4, uipos=local_uipos.uipos_2, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11006008, name="水晶灵柩", ai=11001008, type=3, form=1, appr=22008, icon="Monster_sjlj", level=350, scale=0.5, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11007001, name="假面武士", ai=11001001, appr=22005, level=400, exp=55888, guaranteedDamage="", mgroup={11007001}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11007002, name="假面弓手", ai=11001002, appr=22006, level=400, exp=55888, guaranteedDamage="", mgroup={11007002}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11007003, name="骷灵战士", ai=11001003, appr=22004, level=400, exp=55888, guaranteedDamage="", mgroup={11007003}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=11007004, name="骷灵兽", ai=11001004, appr=22001, level=400, scale=0.3, exp=55888, guaranteedDamage="", mgroup={11007004}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=170, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11007005, name="骷灵骑士", ai=11001005, appr=22002, icon="NewMonster_80", level=400, exp=65888, guaranteedDamage="", mgroup={11007005}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11007006, name="骷灵巫师", ai=11001006, appr=22003, icon="NewMonster_81", level=400, exp=65888, guaranteedDamage="", mgroup={11007006}, efficiencyLvIcon="", monsterShowIcon=0, dropvalue=190, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=11007007, name="血色城门", ai=11001007, type=3, form=1, appr=22007, icon="Monster_cm", level=400, scale=0.4, uipos=local_uipos.uipos_2, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=11007008, name="水晶灵柩", ai=11001008, type=3, form=1, appr=22008, icon="Monster_sjlj", level=400, scale=0.5, exp=0, guaranteedDamage="", efficiencyLvIcon="", monsterShowIcon=0, dropvalue=180, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4, droptype=0},
	{id=12001001, name="鬼魂", ai=12001001, appr=60001, icon="Monster29", level=100, scale=0.5, headoffset=0, np=0, exp=2488, attackSound=40107, dieSound=40109, birthSound=40105, mgroup={60001}, repelled=1, dropvalue=200, gloddropvalue=28, KillGroup=local_KillGroup.KillGroup_4},
	{id=12001002, name="诅咒巫师", ai=12001002, appr=60003, icon="Monster164", level=100, scale=0.4, headoffset=0, np=0, exp=2488, attackSound=40112, dieSound=40114, birthSound=40091, mgroup={60003}, repelled=1, dropvalue=200, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12001003, name="牛魔王", ai=12001003, appr=60004, icon="Monster31", level=100, scale=0.5, headoffset=0.45, np=0.45, exp=2488, attackSound=40065, dieSound=40067, mgroup={60004}, repelled=1, dropvalue=200, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12001004, name="恶魔", ai=12001004, appr=60005, icon="Monster27", level=100, scale=0.5, headoffset=0.45, np=0.45, exp=2488, attackSound=40003, dieSound=40005, mgroup={60005}, repelled=1, dropvalue=200, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12001005, name="死神骑士", ai=12001005, appr=60006, icon="Monster30", level=100, scale=0.5, headoffset=0.5, np=0.5, exp=2488, attackSound=40117, dieSound=40119, mgroup={60006}, repelled=1, dropvalue=200, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12001006, name="死神戈登", ai=12001006, appr=60007, icon="Monster105", level=100, scale=0.5, headoffset=0.5, np=0.5, exp=2488, attackSound=40049, dieSound=40051, mgroup={60007}, repelled=1, dropvalue=180, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12002001, name="黑炎魔", ai=12002001, appr=80005, icon="Monster45", level=150, scale=0.5, exp=5388, attackSound=40094, dieSound=100029, deathEffect=local_deathEffect.deathEffect_3, mgroup=local_mgroup.mgroup_4, repelled=1, dropvalue=160, gloddropvalue=100, KillGroup=local_KillGroup.KillGroup_4},
	{id=12002002, name="丛林树精灵", ai=12002002, appr=11001, icon="NewMonster_2", level=150, scale=0.5, exp=5388, attackSound=100042, dieSound=100043, mgroup=local_mgroup.mgroup_5, dropvalue=130, gloddropvalue=30, KillGroup=local_KillGroup.KillGroup_4},
	{id=12002003, name="丛林残暴者", ai=12002003, appr=11002, icon="NewMonster_3", level=150, scale=0.46, exp=5388, attackSound=100046, dieSound=100047, mgroup=local_mgroup.mgroup_6, repelled=1, dropvalue=130, gloddropvalue=30, KillGroup=local_KillGroup.KillGroup_4},
	{id=12002004, name="丛林暗杀者", ai=12002004, appr=11003, icon="NewMonster_4", level=150, scale=0.45, exp=5388, guaranteedDamage="2", attackSound=100044, dieSound=100045, mgroup=local_mgroup.mgroup_7, repelled=1, dropvalue=130, gloddropvalue=30, KillGroup=local_KillGroup.KillGroup_4},
	{id=12002005, name="丛林生命体", ai=12002005, appr=11004, icon="NewMonster_5", level=150, scale=0.55, exp=5388, guaranteedDamage="2", attackSound=100050, dieSound=100051, mgroup=local_mgroup.mgroup_8, repelled=1, dropvalue=130, gloddropvalue=30, KillGroup=local_KillGroup.KillGroup_4},
	{id=12002006, name="丛林女巫师", ai=12002006, appr=11005, icon="NewMonster_6", level=150, scale=0.52, exp=5388, attackSound=100048, dieSound=100049, mgroup=local_mgroup.mgroup_9, dropvalue=130, gloddropvalue=30, KillGroup=local_KillGroup.KillGroup_4},
	{id=12003001, name="恶灵", ai=12003001, appr=90001, icon="Monster105", level=199, scale=0.4, exp=8888, dieSound=100041, mgroup=local_mgroup.mgroup_10, dropvalue=160, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12003002, name="风后", ai=12003002, appr=90003, icon="Monster103", level=199, scale=0.5, exp=8888, guaranteedDamage="2", dieSound=100043, mgroup=local_mgroup.mgroup_11, dropvalue=160, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12003003, name="蓝魔龙", ai=12003003, appr=90004, icon="Monster102", level=199, scale=0.3, exp=8888, guaranteedDamage="2", dieSound=100044, mgroup=local_mgroup.mgroup_12, repelled=1, dropvalue=160, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12003004, name="恶灵王", ai=12003004, appr=90005, icon="Monster101", level=199, scale=0.5, exp=8888, guaranteedDamage="2", dieSound=100041, mgroup=local_mgroup.mgroup_13, repelled=1, dropvalue=160, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12003005, name="幻影骑士", ai=12003005, appr=90006, icon="Monster54", level=199, scale=0.5, exp=8888, guaranteedDamage="2", dieSound=100046, mgroup=local_mgroup.mgroup_14, repelled=1, dropvalue=150, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12003006, name="红魔龙", ai=12003006, appr=90007, icon="Monster55_2", level=200, scale=0.3, exp=8888, guaranteedDamage="2", dieSound=100044, mgroup=local_mgroup.mgroup_15, repelled=1, dropvalue=140, gloddropvalue=46, KillGroup=local_KillGroup.KillGroup_4},
	{id=12004001, name="裂角狼", ai=12004001, appr=12002, icon="NewMonster_8", level=249, scale=0.3, exp=12888, guaranteedDamage="28", dieSound=100030, mgroup=local_mgroup.mgroup_16, repelled=1, dropvalue=155, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12004002, name="金甲兽", ai=12004002, appr=12003, icon="NewMonster_9", level=249, scale=0.5, exp=12888, guaranteedDamage="2", dieSound=100031, mgroup=local_mgroup.mgroup_17, repelled=1, dropvalue=155, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12004003, name="半兽人", ai=12004003, appr=12004, icon="NewMonster_10", level=249, scale=0.5, shapeshiftScale=1, exp=12888, guaranteedDamage="2", dieSound=100032, mgroup=local_mgroup.mgroup_18, repelled=1, dropvalue=155, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12004004, name="刀刃猎手", ai=12004004, appr=12005, icon="NewMonster_11", level=249, scale=0.5, shapeshiftScale=1, exp=12888, guaranteedDamage="2", dieSound=100034, mgroup=local_mgroup.mgroup_19, dropvalue=135, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12004005, name="寒冰刺客", ai=12004005, appr=12006, level=249, scale=0.4, exp=12888, guaranteedDamage="2", dieSound=100033, mgroup=local_mgroup.mgroup_20, repelled=1, dropvalue=135, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12004006, name="狂巨人", ai=12004006, appr=12007, icon="monster151", level=249, scale=0.5, exp=12888, guaranteedDamage="2", dieSound=100035, mgroup=local_mgroup.mgroup_21, repelled=1, dropvalue=135, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12005001, name="假面巫", ai=12005001, appr=13001, icon="Monster115", level=300, scale=0.4, exp=15888, guaranteedDamage="3", dieSound=100039, mgroup=local_mgroup.mgroup_22, repelled=1, dropvalue=130, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12005002, name="毒步妖", ai=12005002, appr=13002, icon="NewMonster_19", level=300, scale=0.5, exp=15888, guaranteedDamage="3", dieSound=100038, mgroup=local_mgroup.mgroup_23, repelled=1, dropvalue=130, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12005003, name="恐惧天使", ai=12005003, appr=13003, icon="NewMonster_20", level=300, scale=0.5, exp=15888, guaranteedDamage="4", dieSound=100040, mgroup=local_mgroup.mgroup_24, repelled=1, dropvalue=130, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12005004, name="假面巫", ai=12005004, appr=13001, icon="Monster115", level=300, scale=0.4, exp=15888, guaranteedDamage="3", dieSound=100039, mgroup=local_mgroup.mgroup_25, repelled=1, dropvalue=130, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12005005, name="毒步妖", ai=12005005, appr=13002, icon="NewMonster_19", level=300, scale=0.5, exp=15888, guaranteedDamage="3", dieSound=100038, mgroup=local_mgroup.mgroup_26, repelled=1, dropvalue=130, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12005006, name="恐惧天使", ai=12005006, appr=13003, icon="NewMonster_20", level=300, scale=0.5, exp=15888, guaranteedDamage="4", dieSound=100040, mgroup=local_mgroup.mgroup_27, repelled=1, dropvalue=130, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12006001, name="冰之魔犬", ai=12006001, appr=14001, icon="NewMonster_21", level=350, scale=0.45, exp=22888, guaranteedDamage="5", mgroup=local_mgroup.mgroup_28, repelled=1, dropvalue=140, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12006002, name="冰之魔象", ai=12006002, appr=14002, icon="Monster147", level=350, scale=0.45, exp=22888, guaranteedDamage="6", mgroup=local_mgroup.mgroup_29, repelled=1, dropvalue=150, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12006003, name="冰之巨魔", ai=12006003, appr=14003, icon="Monster148", level=350, scale=0.6, exp=22888, guaranteedDamage="6", mgroup=local_mgroup.mgroup_30, repelled=1, dropvalue=140, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12006004, name="冰之魔蛛", ai=12006004, appr=14004, icon="Monster177", level=350, exp=22888, guaranteedDamage="7", mgroup=local_mgroup.mgroup_31, repelled=1, dropvalue=140, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12006005, name="冰铁剑魂", ai=12006005, appr=14005, icon="Monster174", level=350, scale=0.65, exp=22888, guaranteedDamage="7", mgroup=local_mgroup.mgroup_32, repelled=1, dropvalue=140, gloddropvalue=33, KillGroup=local_KillGroup.KillGroup_4},
	{id=12007001, name="树妖", ai=12007001, appr=16001, icon="NewMonster_38", level=400, scale=0.6, exp=22888, guaranteedDamage="10", mgroup=local_mgroup.mgroup_33, repelled=1, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_4},
	{id=12007002, name="毒树妖", ai=12007002, appr=16002, icon="NewMonster_39", level=400, scale=0.6, exp=28888, guaranteedDamage="10", mgroup=local_mgroup.mgroup_34, repelled=1, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_4},
	{id=12007003, name="残忍的树妖", ai=12007003, appr=16003, icon="NewMonster_40", level=400, scale=0.6, exp=28888, guaranteedDamage="13", mgroup=local_mgroup.mgroup_35, repelled=1, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_4},
	{id=12007004, name="暗影爪牙", ai=12007004, appr=16004, icon="NewMonster_41", level=400, scale=0.6, exp=28888, guaranteedDamage="13", mgroup=local_mgroup.mgroup_36, repelled=1, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_4},
	{id=12007005, name="暗影骑士", ai=12007005, appr=16005, icon="NewMonster_42", level=400, scale=0.6, exp=28888, guaranteedDamage="15", mgroup=local_mgroup.mgroup_37, repelled=1, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_4},
	{id=12007006, name="暗影武士", ai=12007006, appr=16006, icon="NewMonster_43", level=400, scale=0.6, shapeshiftScale=1.2, exp=28888, guaranteedDamage="15", mgroup=local_mgroup.mgroup_38, repelled=1, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_4},
	{id=47001, name="冰后", ai=115, type=3, appr=40006, icon="Monster19", scale=0.45, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47006, name="冰后", ai=115, type=3, appr=40006, icon="Monster19", scale=0.45, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47011, name="冰后", ai=115, type=3, appr=40006, icon="Monster19", scale=0.45, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47016, name="冰后", ai=115, type=3, appr=40006, icon="Monster19", scale=0.45, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47021, name="冰后", ai=115, type=3, appr=40006, icon="Monster19", scale=0.45, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47026, name="冰后", ai=115, type=3, appr=40006, icon="Monster19", scale=0.45, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47031, name="冰后", ai=115, type=3, appr=40006, icon="Monster19", scale=0.45, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47036, name="冰后", ai=115, type=3, appr=40006, icon="Monster19", scale=0.45, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47002, name="魔鬼戈登", ai=129, type=3, appr=50012, icon="Monster12_1", level=52, scale=0.55, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40013, dieSound=40015, birthSound=40011, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47007, name="魔鬼戈登", ai=129, type=3, appr=50012, icon="Monster12_1", level=52, scale=0.55, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40013, dieSound=40015, birthSound=40011, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47012, name="魔鬼戈登", ai=129, type=3, appr=50012, icon="Monster12_1", level=52, scale=0.55, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40013, dieSound=40015, birthSound=40011, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47017, name="魔鬼戈登", ai=129, type=3, appr=50012, icon="Monster12_1", level=52, scale=0.55, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40013, dieSound=40015, birthSound=40011, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47022, name="魔鬼戈登", ai=129, type=3, appr=50012, icon="Monster12_1", level=52, scale=0.55, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40013, dieSound=40015, birthSound=40011, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47027, name="魔鬼戈登", ai=129, type=3, appr=50012, icon="Monster12_1", level=52, scale=0.55, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40013, dieSound=40015, birthSound=40011, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47032, name="魔鬼戈登", ai=129, type=3, appr=50012, icon="Monster12_1", level=52, scale=0.55, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40013, dieSound=40015, birthSound=40011, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47037, name="魔鬼戈登", ai=129, type=3, appr=50012, icon="Monster12_1", level=52, scale=0.55, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40013, dieSound=40015, birthSound=40011, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47003, name="魔王巴洛克", ai=135, type=3, icon="Monster28", level=55, scale=0.7, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, birthSound=40047, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47008, name="魔王巴洛克", ai=135, type=3, icon="Monster28", level=55, scale=0.7, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, birthSound=40047, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47013, name="魔王巴洛克", ai=135, type=3, icon="Monster28", level=55, scale=0.7, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, birthSound=40047, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47018, name="魔王巴洛克", ai=135, type=3, icon="Monster28", level=55, scale=0.7, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, birthSound=40047, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47023, name="魔王巴洛克", ai=135, type=3, icon="Monster28", level=55, scale=0.7, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, birthSound=40047, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47028, name="魔王巴洛克", ai=135, type=3, icon="Monster28", level=55, scale=0.7, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, birthSound=40047, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47033, name="魔王巴洛克", ai=135, type=3, icon="Monster28", level=55, scale=0.7, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, birthSound=40047, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47038, name="魔王巴洛克", ai=135, type=3, icon="Monster28", level=55, scale=0.7, headoffset=1, np=1, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, birthSound=40047, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47004, name="海魔希特拉", ai=145, type=3, appr=70007, icon="Monster38", level=66, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47009, name="海魔希特拉", ai=145, type=3, appr=70007, icon="Monster38", level=66, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47014, name="海魔希特拉", ai=145, type=3, appr=70007, icon="Monster38", level=66, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47019, name="海魔希特拉", ai=145, type=3, appr=70007, icon="Monster38", level=66, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47024, name="海魔希特拉", ai=145, type=3, appr=70007, icon="Monster38", level=66, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47029, name="海魔希特拉", ai=145, type=3, appr=70007, icon="Monster38", level=66, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47034, name="海魔希特拉", ai=145, type=3, appr=70007, icon="Monster38", level=66, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47039, name="海魔希特拉", ai=145, type=3, appr=70007, icon="Monster38", level=66, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40049, dieSound=40051, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47005, name="炽炎魔", type=3, appr=80006, icon="Monster43_2", level=74, scale=0.59, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40046, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47010, name="炽炎魔", type=3, appr=80006, icon="Monster43_2", level=74, scale=0.59, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40046, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47015, name="炽炎魔", type=3, appr=80006, icon="Monster43_2", level=74, scale=0.59, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40046, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47020, name="炽炎魔", type=3, appr=80006, icon="Monster43_2", level=74, scale=0.59, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40046, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47025, name="炽炎魔", type=3, appr=80006, icon="Monster43_2", level=74, scale=0.59, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40046, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47030, name="炽炎魔", type=3, appr=80006, icon="Monster43_2", level=74, scale=0.59, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40046, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47035, name="炽炎魔", type=3, appr=80006, icon="Monster43_2", level=74, scale=0.59, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40046, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=47040, name="炽炎魔", type=3, appr=80006, icon="Monster43_2", level=74, scale=0.59, headoffset=0.5, np=0.5, angelExp=0, guaranteedDamage="3", attackSound=40103, dieSound=40046, deathmark="Model/Monster/Monster177.prefab", efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_4, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=200001, name="黄金暗黑骑士", ai=500017, type=2, appr=28017, icon="NewMonster_130", level=40, scale=0.5, headoffset=0.35, np=0.35, exp=0, attackSound=40117, dieSound=40119, birthSound=40115, mgroup={200001}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=200002, name="黄金牛魔王", ai=200002, type=2, appr=28018, icon="NewMonster_125", level=70, scale=0.5, headoffset=0.35, np=0.35, exp=0, attackSound=40065, dieSound=40067, mgroup={200002}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=200003, name="黄金巫师王", ai=200003, type=2, appr=28029, icon="NewMonster_126", level=130, scale=0.5, headoffset=0.35, np=0.35, exp=0, attackSound=40103, mgroup={200003}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=200004, name="黄金破坏骑士", ai=200004, type=2, appr=28032, icon="Monster43_2", level=170, scale=0.7, headoffset=0.35, np=0.35, exp=0, attackSound=40034, dieSound=100028, mgroup={200004}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=200005, name="黄金丛林残暴者", ai=200005, type=2, appr=28035, icon="NewMonster_121", level=210, scale=0.46, headoffset=0.35, np=0.35, exp=0, attackSound=100046, dieSound=100047, mgroup={200005}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=200006, name="黄金风后", ai=200006, type=2, appr=28039, icon="NewMonster_132", level=250, scale=0.5, headoffset=0.35, np=0.35, exp=0, dieSound=100043, mgroup={200006}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=200007, name="黄金半兽人", ai=200007, type=2, appr=28045, icon="NewMonster_127", level=290, scale=0.5, headoffset=0.35, np=0.35, exp=0, dieSound=100032, mgroup={200007}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=200008, name="黄金毒步妖", ai=200008, type=2, appr=28048, icon="NewMonster_130", level=330, scale=0.5, headoffset=0.35, np=0.35, exp=0, dieSound=100038, mgroup={200008}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=200009, name="黄金冰铁剑魂", ai=200009, type=2, appr=28055, icon="NewMonster_137", level=370, scale=0.65, headoffset=0.35, np=0.35, exp=0, mgroup={200009}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=200010, name="黄金狂巨人", ai=200010, type=2, appr=28042, icon="NewMonster_124", level=400, scale=0.5, headoffset=0.35, np=0.35, exp=0, dieSound=100035, mgroup={200010}, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, KillGroup=local_KillGroup.KillGroup_1},
	{id=17001001, appr=27000, icon="Monster12_1", level=55, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17001002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17001003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17002001, appr=27000, icon="Monster12_1", level=55, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="77", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17002002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="77", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17002003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, guaranteedDamage="77", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17003001, appr=27000, icon="Monster12_1", level=55, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="176", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17003002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="176", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17003003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, guaranteedDamage="176", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17004001, appr=27000, icon="Monster12_1", level=55, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="338", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17004002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="338", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17004003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, guaranteedDamage="338", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17005001, appr=27000, icon="Monster12_1", level=55, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="583", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17005002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="583", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17005003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, guaranteedDamage="583", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17006001, appr=27000, icon="Monster12_1", level=55, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="1045", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17006002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="1045", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17006003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, guaranteedDamage="1045", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17007001, appr=27000, icon="Monster12_1", level=55, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="1888", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17007002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="1888", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17007003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, guaranteedDamage="1888", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17008001, appr=27000, icon="Monster12_1", level=55, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="3251", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17008002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="3251", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17008003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, guaranteedDamage="3251", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17009001, appr=27000, icon="Monster12_1", level=55, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="5506", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17009002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=0.4, headoffset=1, np=1, angelExp=0, decaySign=4000, guaranteedDamage="5506", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=17009003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=0.4, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, guaranteedDamage="5506", efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=44001, appr=27000, icon="Monster12_1", level=55, scale=1, shapeshiftScale=1, headoffset=1, np=1, angelExp=0, decaySign=4000, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5},
	{id=44002, name="赤色要塞法师", ai=129, appr=27001, icon="Monster28", level=66, scale=1, shapeshiftScale=1, headoffset=1, np=1, angelExp=0, decaySign=4000, efficiencyLvIcon="", monsterShowIcon=0, UIDrop=local_UIDrop.UIDrop_5, KillGroup=local_KillGroup.KillGroup_5},
	{id=44003, name="赤色要塞弓箭手", ai=139, appr=27002, icon="Monster38", level=74, scale=1, shapeshiftScale=1, headoffset=0.5, np=0.5, angelExp=0, decaySign=4000, efficiencyLvIcon="", monsterShowIcon=0, UIDrop=local_UIDrop.UIDrop_5, KillGroup=local_KillGroup.KillGroup_5},
	{id=550001, name="骷灵兽", ai=550001, appr=22001, icon="NewMonster_79", level=121, exp=10000, angelExp=56, decaySign=4000, guaranteedDamage="89", sword=16767.6673099593, mgroup=local_mgroup.mgroup_39, UIDrop=local_UIDrop.UIDrop_5, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=550002, name="骷灵骑士", ai=550002, appr=22002, icon="NewMonster_80", level=122, exp=10000, angelExp=56, decaySign=4000, guaranteedDamage="98", sword=17208.6463371436, mgroup=local_mgroup.mgroup_39, UIDrop=local_UIDrop.UIDrop_5, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=550003, name="骷灵巫师", ai=550003, appr=22003, icon="NewMonster_81", level=123, exp=10000, angelExp=56, decaySign=4000, guaranteedDamage="97", sword=17671.2253643279, mgroup=local_mgroup.mgroup_39, UIDrop=local_UIDrop.UIDrop_5, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500062, name="黄金贪婪狼人", ai=500062, type=2, appr=28062, icon="Monster131", level=126, scale=0.6, headoffset=0.35, np=0.35, exp=20000, angelExp=420, decaySign=4000, guaranteedDamage="737", mgroup=local_mgroup.mgroup_40, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_6, monsterHunt=5501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500063, name="黄金狂躁兔子", ai=500063, type=2, appr=28063, icon="Monster130", level=127, scale=0.6, headoffset=0.35, np=0.35, exp=20000, angelExp=420, decaySign=4000, guaranteedDamage="815", mgroup=local_mgroup.mgroup_40, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_6, monsterHunt=5501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500067, name="黄金飞蜈", ai=500067, type=2, appr=28067, icon="Monster03", level=128, scale=0.75, headoffset=-0.8, np=-0.8, exp=20000, angelExp=420, decaySign=4000, guaranteedDamage="800", mgroup=local_mgroup.mgroup_40, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_6, monsterHunt=5501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=18002, name="幽灵角斗士", ai=18002, type=3, appr=18002, icon="NewMonster_68", level=131, scale=0.7, exp=20000, angelExp=560, decaySign=4000, guaranteedDamage="1145", deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_41, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_6, monsterHunt=5502, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=18003, name="幽灵屠杀者", ai=18003, type=3, appr=18003, icon="NewMonster_69", level=132, headoffset=1.4, np=1.4, exp=20000, angelExp=560, decaySign=4000, guaranteedDamage="1208", deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_41, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_6, monsterHunt=5502, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=18004, name="幽灵暗杀者", ai=18004, type=3, appr=18004, icon="NewMonster_70", level=133, scale=0.7, exp=20000, angelExp=560, decaySign=4000, guaranteedDamage="1211", deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_41, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_6, monsterHunt=5502, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=650004, name="黄金暗黑骑士", ai=650004, type=2, appr=28017, icon="Monster04", level=175, scale=0.6, headoffset=0.35, np=0.35, exp=40000, angelExp=420, decaySign=4000, guaranteedDamage="1217", attackSound=40117, dieSound=40119, birthSound=40115, mgroup=local_mgroup.mgroup_42, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_7, monsterHunt=6501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=650005, name="黄金死神骑士", ai=650005, type=2, appr=28023, icon="Monster30", level=176, scale=0.6, uipos={0,-70,0}, headoffset=0.5, np=0.5, exp=40000, angelExp=420, decaySign=4000, guaranteedDamage="1301", mgroup=local_mgroup.mgroup_42, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_7, monsterHunt=6501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=650006, name="黄金死神戈登", ai=650006, type=2, appr=28024, icon="Monster12_2", level=177, scale=0.6, headoffset=0.5, np=0.5, exp=40000, angelExp=420, decaySign=4000, guaranteedDamage="1336", attackSound=40049, dieSound=40051, mgroup=local_mgroup.mgroup_42, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_7, monsterHunt=6501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=17013, name="暗黑指挥官", ai=17013, type=3, appr=17013, icon="NewMonster_60", level=180, scale=0.7, exp=40000, angelExp=560, decaySign=4000, guaranteedDamage="1677", deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_43, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_7, monsterHunt=6502, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=17014, name="暗黑咒术师", ai=17014, type=3, appr=17014, icon="NewMonster_61", level=181, scale=0.7, exp=40000, angelExp=560, decaySign=4000, guaranteedDamage="1769", deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_43, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_7, monsterHunt=6502, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=17015, name="巴卡斯司令官", ai=17015, type=3, appr=25004, icon="NewMonster_104", level=182, exp=40000, angelExp=560, decaySign=4000, guaranteedDamage="1734", deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_43, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_7, monsterHunt=6502, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=650001, name="深渊恶魔", ai=650001, appr=60005, icon="Monster27", level=170, scale=0.5, headoffset=0.45, np=0.45, exp=40000, angelExp=56, decaySign=4000, guaranteedDamage="146", attackSound=40003, dieSound=40005, sword=21952.0740274902, mgroup=local_mgroup.mgroup_44, UIDrop=local_UIDrop.UIDrop_5, repelled=1, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=650002, name="深渊骑士", ai=650002, appr=60006, icon="Monster30", level=171, scale=0.5, headoffset=0.5, np=0.5, exp=40000, angelExp=56, decaySign=4000, guaranteedDamage="157", attackSound=40117, dieSound=40119, sword=22369.1780582121, mgroup=local_mgroup.mgroup_44, UIDrop=local_UIDrop.UIDrop_5, repelled=1, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=650003, name="深渊戈登", ai=650003, appr=60007, icon="Monster12_2", level=172, scale=0.5, headoffset=0.5, np=0.5, exp=40000, angelExp=56, decaySign=4000, guaranteedDamage="161", attackSound=40049, dieSound=40051, sword=22799.0820889341, mgroup=local_mgroup.mgroup_44, UIDrop=local_UIDrop.UIDrop_5, repelled=1, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500068, name="黄金蜥蜴人", ai=500068, type=2, appr=28068, icon="Monster10", level=197, scale=0.75, uipos={5,-77,0}, headoffset=-0.8, np=-0.8, exp=30000, angelExp=420, decaySign=4000, guaranteedDamage="907", mgroup=local_mgroup.mgroup_45, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_8, monsterHunt=6001, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500069, name="黄金沼泽飞蝇", ai=500069, type=2, appr=28069, icon="Monster163", level=198, scale=0.5, headoffset=0.2, np=0.2, exp=30000, angelExp=420, decaySign=4000, guaranteedDamage="973", deathEffect=local_deathEffect.deathEffect_2, mgroup=local_mgroup.mgroup_45, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_8, monsterHunt=6001, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500070, name="黄金暗影虫", ai=500070, type=2, appr=28070, icon="Monster01_1", level=199, scale=0.6, headoffset=0.2, np=0.2, exp=30000, angelExp=420, decaySign=4000, guaranteedDamage="1046", mgroup=local_mgroup.mgroup_45, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_8, monsterHunt=6001, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=17017, name="幽影疯魔", ai=17017, type=3, appr=12009, icon="NewMonster_14", level=202, scale=0.5, exp=30000, angelExp=560, decaySign=4000, guaranteedDamage="1423", deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_46, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_8, monsterHunt=6002, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=17018, name="幽影寒冰刺客", ai=17018, type=3, appr=12010, icon="NewMonster_15", level=203, scale=0.5, exp=30000, angelExp=560, decaySign=4000, guaranteedDamage="1508", deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_46, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_8, monsterHunt=6002, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=17019, name="幽影刀刃猎手", ai=17019, type=3, appr=12011, icon="NewMonster_16", level=204, scale=0.5, exp=30000, angelExp=560, decaySign=4000, guaranteedDamage="1481", deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_46, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, UIDrop=local_UIDrop.UIDrop_8, monsterHunt=6002, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=17001, name="刺锤侦察兵", ai=17001, appr=17001, icon="NewMonster_49", level=192, scale=0.45, exp=30000, angelExp=56, decaySign=4000, guaranteedDamage="109", sword=19380.423377134, mgroup=local_mgroup.mgroup_47, UIDrop=local_UIDrop.UIDrop_5, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=17002, name="长矛侦察兵", ai=17002, appr=17002, icon="NewMonster_50", level=193, scale=0.45, exp=30000, angelExp=56, decaySign=4000, guaranteedDamage="117", sword=19805.7185610572, mgroup=local_mgroup.mgroup_47, UIDrop=local_UIDrop.UIDrop_5, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=17003, name="魔弓侦察兵", ai=17003, appr=17003, icon="NewMonster_51", level=194, scale=0.45, exp=30000, angelExp=56, decaySign=4000, guaranteedDamage="126", sword=20219.0137449804, mgroup=local_mgroup.mgroup_47, UIDrop=local_UIDrop.UIDrop_5, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500073, name="菲利亚骑士", ai=500080, appr=1011301, icon="Monster292", level=450, scale=0.26, uipos=local_uipos.uipos_3, headoffset=0, np=0, exp=60000, angelExp=420, decaySign=4000, guaranteedDamage="4490", mgroup=local_mgroup.mgroup_50, efficiencyLvIcon="img_minimap__boss1", txtColor=274, UIDrop=local_UIDrop.UIDrop_11, monsterHunt=8501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500074, name="菲利亚弓箭手", ai=500076, appr=1011302, icon="Monster293", level=450, scale=0.25, headoffset=0.2, np=0.2, exp=60000, angelExp=420, decaySign=4000, guaranteedDamage="3297", deathEffect=local_deathEffect.deathEffect_2, mgroup=local_mgroup.mgroup_48, efficiencyLvIcon="img_minimap__boss1", txtColor=274, UIDrop=local_UIDrop.UIDrop_9, monsterHunt=7501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500075, name="菲利亚格斗家", ai=500077, appr=1011303, icon="Monster294", level=450, scale=0.25, headoffset=0.2, np=0.2, exp=60000, angelExp=420, decaySign=4000, guaranteedDamage="3724", mgroup=local_mgroup.mgroup_49, efficiencyLvIcon="img_minimap__boss1", txtColor=274, UIDrop=local_UIDrop.UIDrop_10, monsterHunt=8001, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500076, name="菲利亚弓箭手", ai=500076, appr=1011302, icon="Monster293", level=480, scale=0.25, headoffset=0.2, np=0.2, exp=60000, angelExp=420, decaySign=4000, guaranteedDamage="3297", deathEffect=local_deathEffect.deathEffect_2, mgroup=local_mgroup.mgroup_48, efficiencyLvIcon="img_minimap__boss1", txtColor=274, UIDrop=local_UIDrop.UIDrop_9, monsterHunt=7501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500077, name="菲利亚格斗家", ai=500077, appr=1011303, icon="Monster294", level=480, scale=0.25, headoffset=0.2, np=0.2, exp=60000, angelExp=420, decaySign=4000, guaranteedDamage="3724", mgroup=local_mgroup.mgroup_49, efficiencyLvIcon="img_minimap__boss1", txtColor=274, UIDrop=local_UIDrop.UIDrop_10, monsterHunt=8001, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500078, name="菲利亚君主", ai=500078, type=3, appr=1011305, icon="Monster296", level=530, scale=0.41, headoffset=0.45, np=0.45, exp=60000, angelExp=420, decaySign=4000, guaranteedDamage="3992", mgroup=local_mgroup.mgroup_49, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_10, monsterHunt=8001, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500079, name="菲利亚将军", ai=500079, appr=1011304, icon="Monster295", level=520, scale=0.34, headoffset=0, np=0, exp=60000, angelExp=420, decaySign=4000, guaranteedDamage="4196", mgroup=local_mgroup.mgroup_49, efficiencyLvIcon="img_minimap__boss1", txtColor=274, UIDrop=local_UIDrop.UIDrop_10, monsterHunt=8001, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500080, name="菲利亚骑士", ai=500080, appr=1011301, icon="Monster292", level=510, scale=0.26, uipos=local_uipos.uipos_3, headoffset=0, np=0, exp=60000, angelExp=420, decaySign=4000, guaranteedDamage="4490", mgroup=local_mgroup.mgroup_50, efficiencyLvIcon="img_minimap__boss1", txtColor=274, UIDrop=local_UIDrop.UIDrop_11, monsterHunt=8501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500081, name="帕拉卡", ai=500081, appr=1011401, icon="Monster299", level=550, scale=0.4, headoffset=-0.8, np=-0.8, exp=80000, angelExp=420, decaySign=4000, guaranteedDamage="4576", mgroup=local_mgroup.mgroup_50, efficiencyLvIcon="img_minimap__boss1", txtColor=274, UIDrop=local_UIDrop.UIDrop_11, monsterHunt=8501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500082, name="瓦苏基", ai=500082, appr=1011402, icon="Monster300", level=560, scale=0.65, headoffset=-0.8, np=-0.8, exp=80000, angelExp=420, decaySign=4000, guaranteedDamage="4666", mgroup=local_mgroup.mgroup_50, efficiencyLvIcon="img_minimap__boss1", txtColor=274, UIDrop=local_UIDrop.UIDrop_11, monsterHunt=8501, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500083, name="贝斯", ai=500083, appr=1011403, icon="Monster301", level=570, scale=0.65, headoffset=0.2, np=0.2, exp=80000, angelExp=420, decaySign=4000, guaranteedDamage="5086", deathEffect=local_deathEffect.deathEffect_2, mgroup=local_mgroup.mgroup_51, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_5, monsterHunt=9001, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500084, name="尼克西", ai=500084, type=3, appr=1011404, icon="Monster302", level=580, scale=0.65, headoffset=0.2, np=0.2, exp=80000, angelExp=420, decaySign=4000, guaranteedDamage="5176", mgroup=local_mgroup.mgroup_51, efficiencyLvIcon="img_minimap__boss1", monsterShowName=1, txtColor=274, UIDrop=local_UIDrop.UIDrop_5, monsterHunt=9001, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500085, name="地下城的毒虫", ai=50001, appr=50001, icon="Monster07", level=650, scale=0.3, headoffset=-0.45, np=-0.45, exp=100000, angelExp=420, decaySign=4000, guaranteedDamage="4576", attackSound=40061, dieSound=40062, mgroup=local_mgroup.mgroup_50, txtColor=274, monsterHunt=8501, repelled=1, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=500086, name="地下城的骷髅战士", ai=50009, appr=50009, icon="Monster163", level=660, scale=0.4, headoffset=0.45, np=0.45, exp=100000, decaySign=1000, attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, mgroup=local_mgroup.mgroup_50, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=500087, name="地下城的独眼巨人", ai=50003, appr=50003, icon="Monster11", level=670, scale=0.4, headoffset=0.5, np=0.5, exp=100000, decaySign=1000, attackSound=40070, dieSound=40072, birthSound=40068, mgroup=local_mgroup.mgroup_50, repelled=1, dropvalue=170, gloddropvalue=28, monsterCount=1},
	{id=500088, name="地下城的幽灵", ai=50004, appr=50004, icon="Monster08", level=680, headoffset=0, np=0, exp=100000, decaySign=1000, attackSound=40043, dieSound=40045, birthSound=40041, mgroup=local_mgroup.mgroup_50, repelled=1, dropvalue=190, gloddropvalue=46, monsterCount=1},
	{id=500089, name="地下城的地狱猎犬怪", ai=50006, appr=50006, icon="Monster02_2", level=690, scale=0.4, headoffset=0.35, np=0.35, exp=100000, decaySign=1000, attackSound=40027, dieSound=40028, mgroup=local_mgroup.mgroup_50, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=500090, name="地下城的骷髅弓箭手", ai=50005, appr=50005, icon="Monster162", level=700, scale=0.4, headoffset=0.35, np=0.35, exp=100000, decaySign=1000, attackSound=40103, dieSound=40104, deathEffect=local_deathEffect.deathEffect_2, mgroup=local_mgroup.mgroup_50, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=500091, name="地下城的地狱蜘蛛", ai=50007, appr=50007, icon="Monster10", level=710, scale=0.4, headoffset=0, np=0, exp=100000, decaySign=1000, attackSound=40027, dieSound=40028, birthSound=40026, mgroup=local_mgroup.mgroup_50, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=500092, name="地下城的假面武士", ai=127, appr=22004, icon="NewMonster_82", level=720, np=0, exp=100000, decaySign=1000, mgroup=local_mgroup.mgroup_50, dropvalue=150, gloddropvalue=24, KillGroup=local_KillGroup.KillGroup_1, monsterCount=1},
	{id=500093, name="地下城的死灵巫师", ai=50010, appr=50010, icon="Monster05_1", level=730, headoffset=0.35, np=0.35, exp=100000, decaySign=1000, attackSound=40112, dieSound=40114, mgroup=local_mgroup.mgroup_50, repelled=1, dropvalue=190, gloddropvalue=28, monsterCount=1},
	{id=500094, name="地下城的毒牛怪", ai=50011, appr=50011, icon="Monster01_3", level=740, scale=0.5, shapeshiftScale=1, headoffset=0.45, np=0.45, exp=100000, decaySign=1000, attackSound=40065, dieSound=40067, birthSound=40063, mgroup=local_mgroup.mgroup_50, repelled=1, dropvalue=190, gloddropvalue=46, monsterCount=1},
	{id=500095, name="地下城的暗黑骑士", ai=50008, appr=50008, icon="Monster04", level=750, scale=0.4, headoffset=0.35, np=0.35, exp=100000, decaySign=1000, attackSound=40117, dieSound=40119, birthSound=40115, mgroup=local_mgroup.mgroup_50, repelled=1, dropvalue=200, gloddropvalue=28, monsterCount=1},
	{id=700060, name="暗黑指挥官", ai=700060, appr=17013, icon="NewMonster_60", level=300, scale=0.65, exp=5000, decaySign=4000, deathmark="Model/Monster/Monster177.prefab", mgroup=local_mgroup.mgroup_50, efficiencyLvIcon="img_minimap__boss4", monsterShowName=1, txtColor=271, UIDrop={{1,20312231},{2,20122231},{3,20132231},{1,50040901},{1,50043009},{1,50010010},{2,50040901},{2,50043009},{2,50010010},{3,50040901},{3,50043009},{3,50010010}}, monsterHunt=9502, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=700061, name="暗黑防御者", ai=700061, appr=17007, icon="NewMonster_54", level=300, scale=0.3, exp=5000, angelExp=0, decaySign=4000, attackSound=40034, dieSound=40036, mgroup=local_mgroup.mgroup_50, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=700062, name="暗黑咒术师", ai=700062, appr=17014, icon="NewMonster_61", level=300, scale=0.3, exp=5000, angelExp=0, decaySign=4000, mgroup=local_mgroup.mgroup_50, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=700063, name="暗黑扫荡者", ai=700063, appr=17008, icon="NewMonster_55", level=300, scale=0.3, exp=5000, angelExp=0, decaySign=4000, mgroup=local_mgroup.mgroup_50, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_5, droptype=0},
	{id=102500001, name="阿卡斯", ai=102500001, appr=23001, icon="NewMonster_86", level=50, scale=0.6, shapeshiftScale=1, exp=1888, angelExp=0, mgroup=local_mgroup.mgroup_52, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500002, name="武士", ai=102500002, appr=23002, icon="NewMonster_87", level=50, scale=0.45, shapeshiftScale=1, exp=1888, angelExp=0, mgroup=local_mgroup.mgroup_52, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500003, name="龙虾守卫", ai=102500003, appr=23003, icon="NewMonster_88", level=50, shapeshiftScale=1, exp=1888, angelExp=0, mgroup=local_mgroup.mgroup_52, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500004, name="死亡天使", ai=102500004, appr=23004, icon="NewMonster_89", level=50, scale=0.5, shapeshiftScale=1, exp=1888, angelExp=0, mgroup=local_mgroup.mgroup_52, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500005, name="暗黑巫师", ai=102500005, appr=23005, icon="NewMonster_90", level=50, shapeshiftScale=1, exp=1888, angelExp=0, mgroup=local_mgroup.mgroup_52, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500006, name="狂武士", ai=102500006, appr=23006, icon="NewMonster_91", level=50, shapeshiftScale=1, exp=1888, angelExp=0, mgroup=local_mgroup.mgroup_52, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500007, name="暗黑傀儡", ai=102500007, appr=23007, icon="NewMonster_92", level=50, shapeshiftScale=1, exp=1888, angelExp=0, mgroup=local_mgroup.mgroup_52, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500009, name="魔王昆顿", ai=102500009, type=3, appr=23009, level=100, scale=0.7, shapeshiftScale=1, headoffset=1.7, exp=18888, angelExp=0, attackSound=40049, dieSound=40051, mgroup={8002}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500011, name="阿卡斯", ai=102500011, appr=23001, icon="NewMonster_86", level=100, scale=0.6, shapeshiftScale=1, exp=3888, angelExp=0, mgroup=local_mgroup.mgroup_53, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500012, name="武士", ai=102500012, appr=23002, icon="NewMonster_87", level=100, scale=0.45, shapeshiftScale=1, exp=3888, angelExp=0, mgroup=local_mgroup.mgroup_53, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500013, name="龙虾守卫", ai=102500013, appr=23003, icon="NewMonster_88", level=100, shapeshiftScale=1, exp=3888, angelExp=0, mgroup=local_mgroup.mgroup_53, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500014, name="死亡天使", ai=102500014, appr=23004, icon="NewMonster_89", level=100, scale=0.5, shapeshiftScale=1, exp=3888, angelExp=0, mgroup=local_mgroup.mgroup_53, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500015, name="暗黑巫师", ai=102500015, appr=23005, icon="NewMonster_90", level=100, shapeshiftScale=1, exp=3888, angelExp=0, mgroup=local_mgroup.mgroup_53, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500016, name="狂武士", ai=102500016, appr=23006, icon="NewMonster_91", level=100, shapeshiftScale=1, exp=3888, angelExp=0, mgroup=local_mgroup.mgroup_53, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500017, name="暗黑傀儡", ai=102500017, appr=23007, icon="NewMonster_92", level=100, shapeshiftScale=1, exp=3888, angelExp=0, mgroup=local_mgroup.mgroup_53, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500019, name="魔王昆顿", ai=102500019, type=3, appr=23009, level=149, scale=0.7, shapeshiftScale=1, headoffset=1.7, exp=28888, angelExp=0, attackSound=40049, dieSound=40051, mgroup={8004}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500021, name="阿卡斯", ai=102500021, appr=23001, icon="NewMonster_86", level=149, scale=0.6, shapeshiftScale=1, exp=5888, angelExp=0, mgroup=local_mgroup.mgroup_54, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500022, name="武士", ai=102500022, appr=23002, icon="NewMonster_87", level=149, scale=0.45, shapeshiftScale=1, exp=5888, angelExp=0, mgroup=local_mgroup.mgroup_54, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500023, name="龙虾守卫", ai=102500023, appr=23003, icon="NewMonster_88", level=149, shapeshiftScale=1, exp=5888, angelExp=0, mgroup=local_mgroup.mgroup_54, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500024, name="死亡天使", ai=102500024, appr=23004, icon="NewMonster_89", level=149, scale=0.5, shapeshiftScale=1, exp=5888, angelExp=0, mgroup=local_mgroup.mgroup_54, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500025, name="暗黑巫师", ai=102500025, appr=23005, icon="NewMonster_90", level=149, shapeshiftScale=1, exp=5888, angelExp=0, mgroup=local_mgroup.mgroup_54, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500026, name="狂武士", ai=102500026, appr=23006, icon="NewMonster_91", level=149, shapeshiftScale=1, exp=5888, angelExp=0, mgroup=local_mgroup.mgroup_54, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500027, name="暗黑傀儡", ai=102500027, appr=23007, icon="NewMonster_92", level=149, shapeshiftScale=1, exp=5888, angelExp=0, mgroup=local_mgroup.mgroup_54, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500029, name="魔王昆顿", ai=102500029, type=3, appr=23009, level=200, scale=0.7, shapeshiftScale=1, headoffset=1.7, exp=38888, angelExp=0, attackSound=40049, dieSound=40051, mgroup={8006}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500031, name="阿卡斯", ai=102500031, appr=23001, icon="NewMonster_86", level=200, scale=0.6, shapeshiftScale=1, exp=8888, angelExp=0, mgroup=local_mgroup.mgroup_55, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500032, name="武士", ai=102500032, appr=23002, icon="NewMonster_87", level=200, scale=0.45, shapeshiftScale=1, exp=8888, angelExp=0, mgroup=local_mgroup.mgroup_55, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500033, name="龙虾守卫", ai=102500033, appr=23003, icon="NewMonster_88", level=200, shapeshiftScale=1, exp=8888, angelExp=0, mgroup=local_mgroup.mgroup_55, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500034, name="死亡天使", ai=102500034, appr=23004, icon="NewMonster_89", level=200, scale=0.5, shapeshiftScale=1, exp=8888, angelExp=0, mgroup=local_mgroup.mgroup_55, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500035, name="暗黑巫师", ai=102500035, appr=23005, icon="NewMonster_90", level=200, shapeshiftScale=1, exp=8888, angelExp=0, mgroup=local_mgroup.mgroup_55, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500036, name="狂武士", ai=102500036, appr=23006, icon="NewMonster_91", level=200, shapeshiftScale=1, exp=8888, angelExp=0, mgroup=local_mgroup.mgroup_55, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500037, name="暗黑傀儡", ai=102500037, appr=23007, icon="NewMonster_92", level=200, shapeshiftScale=1, exp=8888, angelExp=0, mgroup=local_mgroup.mgroup_55, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500039, name="魔王昆顿", ai=102500039, type=3, appr=23009, level=249, scale=0.7, shapeshiftScale=1, headoffset=1.7, exp=58888, angelExp=0, attackSound=40049, dieSound=40051, mgroup={8008}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500041, name="阿卡斯", ai=102500041, appr=23001, icon="NewMonster_86", level=249, scale=0.6, shapeshiftScale=1, exp=10888, angelExp=0, mgroup=local_mgroup.mgroup_56, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500042, name="武士", ai=102500042, appr=23002, icon="NewMonster_87", level=249, scale=0.45, shapeshiftScale=1, exp=10888, angelExp=0, mgroup=local_mgroup.mgroup_56, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500043, name="龙虾守卫", ai=102500043, appr=23003, icon="NewMonster_88", level=249, shapeshiftScale=1, exp=10888, angelExp=0, mgroup=local_mgroup.mgroup_56, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500044, name="死亡天使", ai=102500044, appr=23004, icon="NewMonster_89", level=249, scale=0.5, shapeshiftScale=1, exp=10888, angelExp=0, mgroup=local_mgroup.mgroup_56, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500045, name="暗黑巫师", ai=102500045, appr=23005, icon="NewMonster_90", level=249, shapeshiftScale=1, exp=10888, angelExp=0, mgroup=local_mgroup.mgroup_56, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500046, name="狂武士", ai=102500046, appr=23006, icon="NewMonster_91", level=249, shapeshiftScale=1, exp=10888, angelExp=0, mgroup=local_mgroup.mgroup_56, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500047, name="暗黑傀儡", ai=102500047, appr=23007, icon="NewMonster_92", level=249, shapeshiftScale=1, exp=10888, angelExp=0, mgroup=local_mgroup.mgroup_56, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500049, name="魔王昆顿", ai=102500049, type=3, appr=23009, level=300, scale=0.7, shapeshiftScale=1, headoffset=1.7, exp=68888, angelExp=0, attackSound=40049, dieSound=40051, mgroup={8010}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500051, name="阿卡斯", ai=102500051, appr=23001, icon="NewMonster_86", level=300, scale=0.6, shapeshiftScale=1, exp=12888, angelExp=0, mgroup=local_mgroup.mgroup_57, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500052, name="武士", ai=102500052, appr=23002, icon="NewMonster_87", level=300, scale=0.45, shapeshiftScale=1, exp=12888, angelExp=0, mgroup=local_mgroup.mgroup_57, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500053, name="龙虾守卫", ai=102500053, appr=23003, icon="NewMonster_88", level=300, shapeshiftScale=1, exp=12888, angelExp=0, mgroup=local_mgroup.mgroup_57, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500054, name="死亡天使", ai=102500054, appr=23004, icon="NewMonster_89", level=300, scale=0.5, shapeshiftScale=1, exp=12888, angelExp=0, mgroup=local_mgroup.mgroup_57, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500055, name="暗黑巫师", ai=102500055, appr=23005, icon="NewMonster_90", level=300, shapeshiftScale=1, exp=12888, angelExp=0, mgroup=local_mgroup.mgroup_57, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500056, name="狂武士", ai=102500056, appr=23006, icon="NewMonster_91", level=300, shapeshiftScale=1, exp=12888, angelExp=0, mgroup=local_mgroup.mgroup_57, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500057, name="暗黑傀儡", ai=102500057, appr=23007, icon="NewMonster_92", level=300, shapeshiftScale=1, exp=12888, angelExp=0, mgroup=local_mgroup.mgroup_57, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500059, name="魔王昆顿", ai=102500059, type=3, appr=23009, level=350, scale=0.7, shapeshiftScale=1, headoffset=1.7, exp=88888, angelExp=0, attackSound=40049, dieSound=40051, mgroup={8012}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500061, name="阿卡斯", ai=102500061, appr=23001, icon="NewMonster_86", level=350, scale=0.6, shapeshiftScale=1, exp=15888, angelExp=0, mgroup=local_mgroup.mgroup_58, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500062, name="武士", ai=102500062, appr=23002, icon="NewMonster_87", level=350, scale=0.45, shapeshiftScale=1, exp=15888, angelExp=0, mgroup=local_mgroup.mgroup_58, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500063, name="龙虾守卫", ai=102500063, appr=23003, icon="NewMonster_88", level=350, shapeshiftScale=1, exp=15888, angelExp=0, mgroup=local_mgroup.mgroup_58, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500064, name="死亡天使", ai=102500064, appr=23004, icon="NewMonster_89", level=350, scale=0.5, shapeshiftScale=1, exp=15888, angelExp=0, mgroup=local_mgroup.mgroup_58, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500065, name="暗黑巫师", ai=102500065, appr=23005, icon="NewMonster_90", level=350, shapeshiftScale=1, exp=15888, angelExp=0, mgroup=local_mgroup.mgroup_58, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500066, name="狂武士", ai=102500066, appr=23006, icon="NewMonster_91", level=350, shapeshiftScale=1, exp=15888, angelExp=0, mgroup=local_mgroup.mgroup_58, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500067, name="暗黑傀儡", ai=102500067, appr=23007, icon="NewMonster_92", level=350, shapeshiftScale=1, exp=15888, angelExp=0, mgroup=local_mgroup.mgroup_58, efficiencyLvIcon="", monsterShowIcon=0, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
	{id=102500069, name="魔王昆顿", ai=102500069, type=3, appr=23009, level=350, scale=0.7, shapeshiftScale=1, headoffset=1.7, exp=188888, angelExp=0, attackSound=40049, dieSound=40051, mgroup={8014}, efficiencyLvIcon="img_minimap__boss2", monsterShowName=1, txtColor=271, KillGroup=local_KillGroup.KillGroup_1, droptype=0},
}

local defaults = {name="赤色要塞剑士", ai=103, type=1, subtype=0, beSelect=0, beMonsterSelect=0, form=0, appr=60008, icon="Monster43_1", level=19, scale=0.35, UIscale=0, uipos={}, shapeshiftScale=0, headoffset=0, np=0, exp=8000, angelExp=0, decaySign=0, guaranteedDamage="1", pveCrossModel=0, bornSound=0, attackSound=0, hitSound=0, dieSound=0, birthSound=0, walkSound=0, runSound=0, trackSound=0, fastTrack=0, deathEffect={}, sword=0, deathmark="", mgroup={}, mDecayGroup={}, efficiencyLvIcon="img_minimap__shuaguaidian", monsterShowIcon=1, monsterShowName=0, monsterShowLv=0, txtColor=0, UIDrop={}, monsterHunt=0, repelled=0, shengdaoshiexp=0, dropvalue=0, gloddropvalue=0, RecommendedAtk=0, RecommendedDef=0, KillGroup={1,1001}, RecommendedPotion=0, droptype=5, monsterCount=0, petEffect=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_monster) do
	setmetatable(v, mt)
end

return cfg_monster
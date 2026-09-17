-- 此文件工具自动生成，不要修改
---@class cfg_skill_info_column
---与cfg_skill关联
---@field skillID number @技能id column=1 A
---技能名称，界面读取
---@field name string @技能名称 column=2 B
---@field skillLevel number @技能等级 column=3 C
---@field skillAtt IntListList @习得后增加属性 column=4 D
---引用cfg_passive_condition表id
---格式：条件id#条件id
---配置多个则表示都需要满足，不填或0则不生效
---[[客户端不使用]]@field passivityTrigger IntList @被动技能触发条件 column=5 E
---格式：Buffid#权重&Buffid#权重|Buffid#权重&Buffid#权重；（Buffid调用cfg_buff表id）多个Buff按配置顺序排队触发
---@field targetBuffID IntListList @目标buffID column=6 F
---目标buff生效节点
---格式:
---1:施放时
---2:生效前
---3:生效后
---编辑器读取
---{生效前=2#生效后=3}
---@field targetExecutNode IntList @目标加载节点 column=7 G
---默认0或空和之前一样不影响，配置成1就走外置CD
---
---@field cdType number @攻速冷却逻辑是否使用外置 column=8 H
---单位为毫秒
---不填表示0
---@field cdTime number @冷却时间（内置） column=9 I
---单位为毫秒
---不填表示0
---@field commonCd number @公共冷却（内置） column=10 J
---1、cdType字段配1时读外置cd
---2、毫秒，不填为0
---@field skillCd number @技能初始释放时间外置（cd） column=11 K
---1、cdType字段配1时读外置公共cd
---2、毫秒，不填为0
---@field commonCdOut number @公共冷却（外置） column=12 L
---技能冷却是否受攻速影响
---0：不影响
---1：影响
---@field speedCd number @攻速影响冷却 column=13 M
---技能释放时有概率不进入冷却
---单位：万比
---@field noCd number @概率不进入冷却 column=14 N
---技能图标
---资源文件名
---@field icon string @icon column=15 O
---0-通用伤害公式
---1-链式伤害公式
---（对应公式：总伤害 = 链接数量*衰减伤害+主目标伤害）
---@field damageType number @伤害公式类型 column=16 P
---damageType=1，链接数量|衰减伤害（最大攻击属性id#威力倍数#最大攻击属性id）|主目标伤害（最大攻击属性id#威力倍数#最大攻击属性id）|副目标伤害（最大攻击属性id#威力倍数#最大攻击属性id）
---@field damageformula IntListList @特殊伤害公式计算 column=17 Q
---该字段标识技能伤害类型
---1攻击力（对应att_info表中id为201011、201021）
---2魔法攻击力（对应att_info表中id为202011、202021）
---3诅咒攻击力（对应att_info表中id为205011、205021）
---填0或不填为不判断伤害类型，取上述伤害类型最高值
---@field injuryType number @伤害类型 column=18 R
---该字段标识技能伤害附带类型
---1 神圣攻击力（对应att_info表中id为333011、333021）
---2 剧毒攻击力（对应att_info表中id为334011、334021）
---3 火焰攻击力（对应att_info表中id为335011、335021）
---4 雷电攻击力（对应att_info表中id为336011、336021） 
---填0或不填为不判断伤害类型
---@field injurySubtype number @次要伤害类型 column=19 S
---技能满足解锁条件是否自动学习
---0：否
---1：是
---@field autoLearn number @自动学习 column=20 T
---升级所需等级
---格式：职业1所需等级#职业2所需等级
---@field needLevel IntList @等级 column=21 U
---升级所需职业，格式：所属职业#职业等级#职业编号|所属职业#职业等级#职业编号；
---@field needCareer IntListList @职业 column=22 V
---升级所需属性，不填则没有属性要求；格式：属性id#属性值|属性id#属性值
---@field needAtt IntListList @属性 column=23 W
---item表subType字段id#model_charactor表part字段id
---用|分隔表示多个武器类型，多类型时，需保留0作为默认值，填1取正值(该武器)，填2取反值（除了该武器）；
---（比如弓箭手武器：0|1#6|1#601|1#602|1#603|1#604|1#605|1#606|1#607|1#608|1#609|1#610|1#701|1#702|1#703|1#704|1#705|1#706|1#707|1#708|1#709）
---精确到某个装备时首位填3，引用item表道具id，多武器时以|号分隔；
---不填为所有武器可空手；0为所有武器，不可空手；
---@field needWeapon IntListList @武器 column=24 X
---升级所需材料；格式：道具ID#道具数量|道具ID#道具数量（调用item表id）
---@field skillLevelUpItemID IntListList @升级材料 column=25 Y
---技能造成的伤害次数
---格式：伤害次数#权重|伤害次数#权重
---[[客户端不使用]]@field valueTimes IntListList @伤害次数 column=26 A
---技能基础威力
---[[客户端不使用]]@field skillPower number @技能威力 column=27 AA
---技能基础最小威力
---[[客户端不使用]]@field power number @基础威力 column=28 AB
---技能基础最大威力
---[[客户端不使用]]@field maxPower number @基础最大威力 column=29 AC
---技能伤害的固定值
---@field fixedDamage number @固定伤害 column=30 AD
---1是攻击伤害百分比，2是固伤
---百分比的话是造成攻击力*配置的值伤害（万分比），固定的话是固伤
---走战斗公式
---@field monsterExtraDamage IntListList @对怪物额外伤害 column=31 AE
---1是当前生命值伤害百分比，2是固伤
---百分比的话是当前生命值*配置的值伤害（万分比），固定的话是固伤
---走战斗公式
---@field playerExtraDamage IntListList @对玩家额外伤害 column=32 AF
---不配默认为百分之百，万分比
---@field decayDamage number @衰减伤害百分比 column=33 AG
---通用公式的攻击威力倍数
---单位:万分比
---@field powerRate number @威力倍数 column=34 AH
---格式:万分比
---[[客户端不使用]]@field doubleRate number @双倍伤害系数 column=35 AI
---格式:万分比
---[[客户端不使用]]@field excellentRate number @卓越一击 column=36 AJ
---是否受技能攻击力增加属性影响（isSkillDamage）：0、受影响 1、不受影响
---不填默认0
---[[客户端不使用]]@field isSkillDamage number @是否受技能攻击力增加属性影响 column=37 AK
---施放技能时自身位移
---格式:位移方向#位移距离
---位移方向:
---1:前
---2:后
---3:随机
---4:目标身边
---@field changePoint IntList @施放时位移 column=38 AL
---技能施放时位移的速度
---@field changePointSpeed number @位移速度 column=39 AM
---受击目标是否旋转
---0或空 不旋转
---1顺时针旋转
---2逆时针旋转
---@field targetRotate number @受击目标旋转 column=40 AN
---扇形：距离长度#偏移斜线数值（1个数量为目标左右各偏移45°）
---其他形状：距离
---@field releaseRange IntList @攻击范围[施法距离] column=41 AO
---扇形：距离#偏移斜线数量（1个数量为目标左右各偏移45°）
---直线:长度半径#宽度半径
---其他形状：半径
---@field targetRange IntList @受击范围[效果范围] column=42 AP
---技能最大作用目标数
---0或空为不限制数量
---大于0为限制数量
---@field maxtarget number @最多作用目标 column=43 AQ
---仇恨计算公式=造成伤害*hatep/100
---格式：百分比
---[[客户端不使用]]@field hatep number @仇恨修正值 column=44 AR
---每次施法消耗的生命值
---@field costHp number @消耗生命 column=45 AS
---每次施法消耗的魔法值，固定值
---@field costMp number @消耗魔法 column=46 AT
---每次施法消耗的魔法值，根据角色最大魔法值计算；
---万分比，向上取整
---@field costMpRatio number @消耗魔法（万比） column=47 AU
---每次施法消耗的AG值
---@field costAG number @消耗AG（内置）（已废弃） column=48 AV
---每次施法消耗的AG值
---@field newConsumeAG number @消耗AG（外置） column=49 AW
---技能与目标之间有阻挡的话是否允许技能生效
---格式:
---0允许
---1不允许
---编辑器读取
---{允许=0|不允许=1}
---@field throughWall number @是否穿墙 column=50 AX
--- 
---@field tips string @技能描述说明 column=51 AY
---引用cfg_damage_number表内的飘血配置id.但此效果会被一些状态飘血覆盖，例如暴击，切割，卓越一击等等
---@field piaozi number @飘字引用 column=52 B
---根据武器类型，匹配特效，和下一字段一一对应
---0或空表示所有武器
---武器类型：
---item表subType字段id#model_charactor表part字段id
---用|分隔表示多个武器类型，多类型时，需保留0作为默认值
---@field weaponMatch IntListList @武器匹配 column=53 BA
---根据武器类型，匹配特效，和上字段，一一对应
---引援skill_effect表索引id
---用#分隔表示多个特效类型
---@field effectId IntList @匹配特效 column=54 BB
---备注：脚本路径/函数名
---[[客户端不使用]]@field Script string @技能ai(脚本) column=55 BC
---造成玩家某个属性的伤害
---格式：属性ID#数值|属性ID#数值；多个属性时，每次造成伤害随机取其中一个
---单位：万分比
---@field attributeDamage IntListList @属性伤害 column=56 BD
---连击技能所需连击值增长系数
---与skill表comboValue字段乘算来取得释放技能加的连击值最终结果 万分比处理
---
---@field growthFactor number @连击值增长系数 column=57 BE
---连击技能等级对应环身光环特效
---@field haloEffect number @光环特效 column=58 BF
---玩家职业转换时，返还的材料，item表ID+数量
---@field refund IntListList @技能返还 column=59 BG
---@field skillatk number @技能攻击力 column=60 BH
---1、该技能的释放时间的攻击速度转换系数
---2、初始施放时间/(1+攻击速度*该技能的攻击速度转换系数+法攻击速度*该技能的魔法攻击速度转换系数
---3、万分比
---@field speedSkillCd number @攻击速度转换系数 column=61 BI
---1、该技能的释放时间的魔法攻击速度转换系数
---2、初始施放时间/(1+攻击速度*该技能的攻击速度转换系数+法攻击速度*该技能的魔法攻击速度转换系数 
---3、万分比
---@field magicSpeedSkillCd number @该技能魔法攻击速度转换系数 column=62 BJ
---属性id#数值|属性id#数值
---不满足时不能使用道具
---@field useItemAtt IntListList @使用道具所要求的属性 column=63 BK
---角色相应的属性会额外的增加攻击力
---运算1
---
---技能ID#参数
---@field skillattPower IntListList @属性攻击增加 column=64 BL
---默认有关，1无关
---@field CanUseSkillEffectPlayTime number @特效速度是否和攻速有关 column=65 BM

local local_skillAtt = {
    skillAtt_1={},

}

local local_targetBuffID = {
    targetBuffID_1={},
    targetBuffID_2={{10220200,1}},
    targetBuffID_3={{100,1}},
    targetBuffID_4={{120001701,1}},

}

local local_targetExecutNode = {
    targetExecutNode_1={},
    targetExecutNode_2={3},
    targetExecutNode_3={2},

}

local local_damageformula = {
    damageformula_1={},
    damageformula_2={{3},{202011,3000,202011},{202011,12000,202011},{202011,6000,202011}},

}

local local_needLevel = {
    needLevel_1={},
    needLevel_2={1},
    needLevel_3={220},
    needLevel_4={400},
    needLevel_5={170},

}

local local_needCareer = {
    needCareer_1={{1,1},{2,1},{3,1}},
    needCareer_2={{5,1},{5,2},{5,3}},
    needCareer_3={},
    needCareer_4={{3,1}},
    needCareer_5={{1,1}},
    needCareer_6={{2,1}},
    needCareer_7={{4,1}},
    needCareer_8={{1,1},{4,1},{5,1}},
    needCareer_9={{1,2},{1,3}},
    needCareer_10={{2,1},{4,1},{6,1},{7,1}},
    needCareer_11={{2,1},{4,1},{7,1}},
    needCareer_12={{2,1},{4,1}},
    needCareer_13={{2,1},{2,2}},
    needCareer_14={{2,1},{2,2},{4,1}},
    needCareer_15={{3,1},{3,2},{3,3}},
    needCareer_16={{3,2},{3,3}},
    needCareer_17={{4,1},{4,2},{4,3}},
    needCareer_18={{2,1},{2,2},{7,1},{7,2}},
    needCareer_19={{6,1},{6,2},{6,3}},
    needCareer_20={{1,2},{4,2},{5,2},{1,1},{4,1},{5,1},{1,3},{4,3},{5,3}},
    needCareer_21={{7,1},{7,2},{7,3}},

}

local local_needAtt = {
    needAtt_1={},
    needAtt_2={{10003,20}},
    needAtt_3={{10003,72}},
    needAtt_4={{10003,849}},
    needAtt_5={{10003,500}},
    needAtt_6={{10003,345}},
    needAtt_7={{10003,88}},
    needAtt_8={{10003,1058}},
    needAtt_9={{10003,300}},
    needAtt_10={{10003,180}},
    needAtt_11={{10003,1052}},
    needAtt_12={{10003,52}},

}

local local_needWeapon = {
    needWeapon_1={},
    needWeapon_2={{0}},

}

local local_skillLevelUpItemID = {
    skillLevelUpItemID_1={},
    skillLevelUpItemID_2={{60030075,1}},
    skillLevelUpItemID_3={{60030076,1}},
    skillLevelUpItemID_4={{60035082,1},{10010001,100}},
    skillLevelUpItemID_5={{60030077,1}},
    skillLevelUpItemID_6={{60030018,1}},
    skillLevelUpItemID_7={{60030040,1}},

}

local local_monsterExtraDamage = {
    monsterExtraDamage_1={},

}

local local_playerExtraDamage = {
    playerExtraDamage_1={},

}

local local_changePoint = {
    changePoint_1={},
    changePoint_2={1,1},

}

local local_releaseRange = {
    releaseRange_1={1},
    releaseRange_2={0},
    releaseRange_3={6},
    releaseRange_4={8},
    releaseRange_5={3},
    releaseRange_6={5},
    releaseRange_7={7},
    releaseRange_8={2},
    releaseRange_9={4},
    releaseRange_10={6,1},

}

local local_targetRange = {
    targetRange_1={0},
    targetRange_2={3},
    targetRange_3={1},
    targetRange_4={2},
    targetRange_5={5},
    targetRange_6={5,1},
    targetRange_7={6},
    targetRange_8={6,1},
    targetRange_9={5,2},

}

local local_weaponMatch = {
    weaponMatch_1={},
    weaponMatch_2={{0},{1,6},{1,601},{1,602},{1,603},{1,604},{1,605},{1,606},{1,607},{1,608},{1,609},{1,610},{1,701},{1,702},{1,703},{1,704},{1,705},{1,706},{1,707},{1,708},{1,709}},

}

local local_effectId = {
    effectId_1={1},
    effectId_2={},
    effectId_3={4},
    effectId_4={4020},
    effectId_5={1007},
    effectId_6={2004},
    effectId_7={23502},
    effectId_8={136},
    effectId_9={16},
    effectId_10={42},
    effectId_11={5},
    effectId_12={15},
    effectId_13={14},
    effectId_14={13},
    effectId_15={18},
    effectId_16={17},
    effectId_17={27},
    effectId_18={26},
    effectId_19={23},
    effectId_20={24},
    effectId_21={130},
    effectId_22={40,84,85,83,125,137,138,139,142,141,146,116,117,118,119,122,124,121,123,120},
    effectId_23={22},
    effectId_24={20},
    effectId_25={6001},
    effectId_26={117},
    effectId_27={131},
    effectId_28={25},
    effectId_29={1200018},

}

local local_attributeDamage = {
    attributeDamage_1={},
    attributeDamage_2={{201011,12000},{201021,12000}},
    attributeDamage_3={{201011,24000},{201021,24000}},

}

local local_refund = {
    refund_1={},

}

local local_useItemAtt = {
    useItemAtt_1={},
    useItemAtt_2={{10003,20}},
    useItemAtt_3={{10003,72}},
    useItemAtt_4={{10003,849}},
    useItemAtt_5={{10003,500}},
    useItemAtt_6={{10003,345}},
    useItemAtt_7={{10003,88}},
    useItemAtt_8={{10003,1058}},
    useItemAtt_9={{10003,300}},
    useItemAtt_10={{10003,180}},
    useItemAtt_11={{10003,1052}},
    useItemAtt_12={{10003,52}},
    useItemAtt_13={{10003,408}},

}

local local_skillattPower = {
    skillattPower_1={},
    skillattPower_2={{10001,60}},
    skillattPower_3={{10001,14}},
    skillattPower_4={{10001,10}},
    skillattPower_5={{10003,10}},
    skillattPower_6={{10002,7}},

}

local cfg_skill_info =
{
	{skillID=1000001, name="袭风冲撞", skillCd=0, icon="11110100", skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_2, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_1, maxtarget=2, tips="50%概率单段伤害，50%概率2段伤害(延迟0.1秒)，怪物被此技能攻击有被电的特效", effectId=local_effectId.effectId_11, speedSkillCd=33},
	{skillID=1000002, name="烈焰护体", skillCd=0, icon="12170100", skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_3, releaseRange=local_releaseRange.releaseRange_2, targetRange=local_targetRange.targetRange_5, maxtarget=0, throughWall=1, tips="对周围所有目标造成<color=#00FF00>150%</color>的伤害，冷却时间6秒", speedSkillCd=33},
	{skillID=1012020, name="法神附体", targetBuffID={{250001007,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=10000, commonCdOut=1000, icon="fashenfuti(1)", injuryType=0, needLevel=local_needLevel.needLevel_3, needCareer={{2,2},{2,3},{7,1},{7,2},{7,3}}, needAtt=local_needAtt.needAtt_8, skillLevelUpItemID={{60030066,1}}, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, costMp=200, newConsumeAG=50, tips="提升自身20%最小魔法攻击力，持续5分钟", effectId={132}, skillatk=0, speedSkillCd=33, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_8},
	{skillID=1014000, name="魔剑士普通攻击", skillCd=1000, commonCdOut=1000, speedCd=1, icon="11007", needCareer=local_needCareer.needCareer_7, powerRate=10000, releaseRange=local_releaseRange.releaseRange_1, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=0, tips="魔剑士普通攻击", effectId=local_effectId.effectId_1, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_2},
	{skillID=1015000, name="圣导普通攻击", skillCd=1000, commonCdOut=1000, speedCd=1, icon="11007", needCareer={{5,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_1, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=0, tips="圣导普通攻击", effectId=local_effectId.effectId_1, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_2},
	{skillID=1016000, name="召唤普通攻击", skillCd=1000, commonCdOut=1000, speedCd=1, icon="11007", needCareer={{6,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_1, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=0, tips="召唤普通攻击", effectId=local_effectId.effectId_1, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_2},
	{skillID=1014005, name="圣盾防御", targetBuffID=local_targetBuffID.targetBuffID_2, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=990, commonCdOut=920, icon="shengdunfangyu(1)", injuryType=0, needCareer=local_needCareer.needCareer_20, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_2, targetRange=local_targetRange.targetRange_1, maxtarget=6, costMp=30, tips="举盾姿势，释放此技能期间受到伤害减少<color=#00FF00>10%</color>", skillatk=0, speedSkillCd=33},
	{skillID=1005001, name="星云火链", skillCd=1010, commonCdOut=1600, speedCd=1, icon="xingyunhuolian(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_2, needAtt={{10003,79}}, skillLevelUpItemID={{60035100,1}}, fixedDamage=11, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_2, maxtarget=5, costMp=8, tips="对目标造成<color=#00FF00>物理攻击力*101%</color>的伤害+额外11点技能伤害，对目标周围两名敌人造成25%伤害溅射，冷却时间0.72秒", effectId={6000}, skillatk=150, speedSkillCd=33, useItemAtt={{10003,79}}, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1005002, name="地裂", targetBuffID={{100500201,1},{100500202,1}}, targetExecutNode={2,3}, skillCd=10000, commonCdOut=1000, speedCd=1, icon="dilie(1)", needCareer=local_needCareer.needCareer_2, skillLevelUpItemID={{60035103,1}}, fixedDamage=15, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=6, newConsumeAG=30, tips="对目标造成<color=#00FF00>物理攻击力*140%</color>的伤害+额外15点技能伤害，并击退目标且造成1.25秒禁锢，冷却时间10.83秒", effectId={6002}, skillatk=150, speedSkillCd=33, magicSpeedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1014010, name="致命圣印", targetBuffID={{101401012,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=10000, commonCdOut=1000, speedCd=1, icon="zhimingshengyin(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_2, needAtt={{10003,102},{10005,300}}, skillLevelUpItemID={{1116039,1}}, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_7, maxtarget=8, costMp=50, newConsumeAG=30, tips="自身与队友的致命一击几率提升。", effectId={6003}, skillatk=0, speedSkillCd=33, useItemAtt={{10003,102},{10005,300}}},
	{skillID=1014011, name="圣极光", skillCd=5000, commonCdOut=1000, speedCd=1, icon="shengjiguang(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_2, needAtt={{10003,126},{10005,340}}, skillLevelUpItemID={{1116040,1}}, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_2, maxtarget=6, costMp=10, newConsumeAG=6, tips="对直线上的敌人造成伤害", effectId={6004}, skillatk=250, speedSkillCd=33, useItemAtt={{10003,126},{10005,340}}, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1014012, name="冲击波", skillCd=990, commonCdOut=1000, speedCd=1, icon="chongji(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_2, skillLevelUpItemID={{60030072,1}}, fixedDamage=8, releaseRange=local_releaseRange.releaseRange_5, targetRange={1,1}, maxtarget=3, costMp=10, tips="对目标造成<color=#00FF00>物理攻击力*80%</color>+额外8点技能伤害，冷却时间0.72秒", effectId=local_effectId.effectId_25, skillatk=70, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1014013, name="闪电链", skillCd=1000, commonCdOut=1000, speedCd=1, icon="huojianxi", injuryType=0, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, maxtarget=6, costMp=50, newConsumeAG=1, tips="对目标造成<color=#00FF00>攻击力*160%</color>的伤害，并且提升自身伤害，每<color=#00FF00>600点力量</color>提升<color=#00FF00>1%</color>，持续10秒，冷却时间8秒", effectId=local_effectId.effectId_3, skillatk=60, magicSpeedSkillCd=33},
	{skillID=1014014, name="火舞旋风", skillCd=1020, commonCdOut=1000, speedCd=1, icon="huowuxuanfeng(1)", needLevel={100}, needCareer=local_needCareer.needCareer_2, needAtt={{10003,150},{10005,70}}, skillLevelUpItemID={{60035102,1}}, fixedDamage=7, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_6, maxtarget=6, costMp=10, newConsumeAG=2, tips="对前方6格扇形范围内的敌人造成<color=#00FF00>物理攻击力*63%</color>+额外7点技能伤害，冷却时间0.72秒", effectId={6006}, skillatk=180, speedSkillCd=33, useItemAtt={{10003,150},{10005,70}}, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1014025, name="防御值恢复", commonCdOut=1000, icon="fangyulitigao(1)", injuryType=0, needLevel=local_needLevel.needLevel_3, needCareer=local_needCareer.needCareer_3, needAtt={{10003,168}}, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_7, releaseRange=local_releaseRange.releaseRange_1, maxtarget=6, costMp=20, tips="对目标造成<color=#00FF00>攻击力*160%</color>的伤害，并且提升自身伤害，每<color=#00FF00>600点力量</color>提升<color=#00FF00>1%</color>，持续10秒，冷却时间8秒", effectId=local_effectId.effectId_3, useItemAtt={{10003,168}}},
	{skillID=1014026, name="黑暗之力", skillCd=1030, commonCdOut=1500, speedCd=1, icon="heianzhili(1)", needLevel=local_needLevel.needLevel_3, needCareer=local_needCareer.needCareer_2, needAtt={{10003,84}}, skillLevelUpItemID={{60035101,1}}, fixedDamage=29, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_2, maxtarget=6, costMp=12, newConsumeAG=4, tips="对目标造成<color=#00FF00>物理攻击力*280%</color>的伤害+额外29点技能伤害，对目标周围三格敌人造成10%伤害溅射，冷却时间4.33秒", effectId={6008}, skillatk=220, speedSkillCd=33, useItemAtt={{10003,84}}, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1014028, name="暴风雪术（大师）", targetBuffID={{103006,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=1800, icon="12190100", injuryType=2, needLevel=local_needLevel.needLevel_5, needCareer=local_needCareer.needCareer_3, needAtt=local_needAtt.needAtt_4, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_6, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_4, maxtarget=6, costMp=100, tips="攻击目标有%5概率冰冻减速效果，持续3秒，移动速度减少30%", effectId=local_effectId.effectId_17, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_4},
	{skillID=1014029, name="天鹰攻击", skillCd=500, commonCdOut=500, speedCd=1, icon="huojianxi", needLevel={20}, needCareer=local_needCareer.needCareer_2, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_4, tips="单段伤害，当主人待机时，自动攻击身边怪物；当主人攻击目标时，与主人一同攻击同一个目标", effectId={6007}, speedSkillCd=33, skillattPower={{10005,1}}},
	{skillID=1014030, name="血腥风暴", skillCd=0, icon="xuexingfengbao", needLevel={50}, needCareer=local_needCareer.needCareer_3, skillLevelUpItemID={{60030074,1}}, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=87, newConsumeAG=1, tips="对目标造成<color=#00FF00>攻击力*760%</color>的伤害，同时对其周围目标造成<color=#00FF00>攻击力*76%</color>的伤害，冷却时间15秒", effectId=local_effectId.effectId_8, skillatk=25, magicSpeedSkillCd=33},
	{skillID=1014031, name="流星石", skillCd=0, icon="liuxingshi", injuryType=2, needLevel=local_needLevel.needLevel_4, needCareer=local_needCareer.needCareer_3, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_2, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=105, newConsumeAG=10, tips="3秒内，对目标累计造成<color=#00FF00>攻击力*1400%</color>的伤害，并对其周围玩家造成<color=#00FF00>攻击力*700%</color>的伤害，该技能无视防御，冷却时间60秒", effectId=local_effectId.effectId_4, skillatk=105, magicSpeedSkillCd=33},
	{skillID=1014032, name="天崩", skillCd=0, icon="liuxingshi", needCareer=local_needCareer.needCareer_3, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_3, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=50, tips="测试技能，不在正式数据内", effectId=local_effectId.effectId_4, magicSpeedSkillCd=33},
	{skillID=1014033, name="地震", skillCd=0, icon="liuxingshi", needCareer=local_needCareer.needCareer_3, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_5, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=50, tips="测试技能，不在正式数据内", effectId=local_effectId.effectId_4},
	{skillID=1014034, name="海啸", skillCd=0, icon="liuxingshi", needCareer=local_needCareer.needCareer_3, skillLevelUpItemID={{60030078,1}}, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=50, tips="测试技能，不在正式数据内", effectId=local_effectId.effectId_4},
	{skillID=1014035, name="守护治疗", targetBuffID={{20000902,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=0, icon="", injuryType=0, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, maxtarget=0, tips="治疗生命值", weaponMatch={{14,201}}, effectId=local_effectId.effectId_4},
	{skillID=1000011, name="纯洁狂热", targetBuffID={{100001101,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=0, icon="1000011", injuryType=0, releaseRange=local_releaseRange.releaseRange_1, tips="主动释放后，攻速加成<color=#00FF00>20%</color>\n持续10秒，冷却100秒，蓝耗5%"},
	{skillID=1000012, name="神圣制裁", targetBuffID={{100001201,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=0, icon="1000012", injuryType=0, releaseRange=local_releaseRange.releaseRange_1, tips="主动释放后，双倍一击概率<color=#00FF00>20%</color>\n持续10秒，冷却100秒，蓝耗5%"},
	{skillID=1000013, name="天使庇佑", targetBuffID={{100001301,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=0, icon="1000013", injuryType=0, releaseRange=local_releaseRange.releaseRange_1, tips="主动释放后，伤害减免<color=#00FF00>20%</color>\n持续10秒，冷却100秒，蓝耗5%"},
	{skillID=1020001, name="怪物一格普攻(蜘蛛、幼龙、牛怪、猎犬怪、巨人、雪虫、暗杀者、蓝魔怪、雪人王、独眼巨人、幽灵、地狱猎犬怪、暗黑骑士）", commonCdOut=3000, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, throughWall=1},
	{skillID=1020002, name="幼龙喷火", needCareer=local_needCareer.needCareer_3, throughWall=1, effectId={1018}},
	{skillID=1020003, name="黑巫师陨石术", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_1, throughWall=1, effectId=local_effectId.effectId_14},
	{skillID=1020004, name="怪物二格普攻（哥布林、勾尾蝎、瓢虫、树妖、亚昆、石巨人、骷髅兵、骷髅战士、牛魔王、死神骑士、巴哈姆特、铁脊兽、巨齿兽、丛林树精灵、丛林暗杀者、丛林生命体、丛林女巫师、幻影骑士、裂角狼）", skillCd=10000, commonCdOut=10000, needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020005, name="偷猎者射击", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, throughWall=1, effectId=local_effectId.effectId_26},
	{skillID=1020006, name="寒冰魔冰封", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_1, throughWall=1, effectId=local_effectId.effectId_19},
	{skillID=1020007, name="雪人雪球", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_1, throughWall=1, effectId={1001}},
	{skillID=1020008, name="冰后三重真空波", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, maxtarget=99, throughWall=1, effectId={1002}},
	{skillID=1020009, name="毒虫放毒", targetExecutNode=local_targetExecutNode.targetExecutNode_2, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, throughWall=1, effectId=local_effectId.effectId_5},
	{skillID=1020010, name="骷髅弓箭手射击", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_4, throughWall=1, effectId={1005}},
	{skillID=1020011, name="地狱蜘蛛真空波", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, maxtarget=99, throughWall=1, effectId=local_effectId.effectId_12},
	{skillID=1020012, name="怪物掌心雷（死灵巫师、诅咒巫师）", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, throughWall=1, effectId=local_effectId.effectId_9},
	{skillID=1020013, name="毒牛怪放毒", targetExecutNode=local_targetExecutNode.targetExecutNode_2, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, throughWall=1, effectId=local_effectId.effectId_5},
	{skillID=1020014, name="魔鬼戈登", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_3, throughWall=1},
	{skillID=1020015, name="恶魔技能", needCareer=local_needCareer.needCareer_3, throughWall=1, effectId={2002}},
	{skillID=1020016, name="死神戈登掌心雷", needCareer=local_needCareer.needCareer_3, throughWall=1, effectId=local_effectId.effectId_1},
	{skillID=1020017, name="巴洛克地狱火陨石术", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, maxtarget=99, throughWall=1, effectId={2026}},
	{skillID=1020018, name="巴洛克群体普攻", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, throughWall=1},
	{skillID=1020019, name="死亡美人鱼技能", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_9, throughWall=1, effectId={2003}},
	{skillID=1020020, name="蓝翼海怪射击", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, throughWall=1, effectId=local_effectId.effectId_6},
	{skillID=1020021, name="银弓海怪射击", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, throughWall=1, effectId=local_effectId.effectId_6},
	{skillID=1020022, name="巫师王红色闪电", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_9, throughWall=1, effectId={2005}},
	{skillID=1020023, name="海魔希特拉极光", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_8, maxtarget=99, throughWall=1, effectId={2006}},
	{skillID=1020024, name="海魔希特拉范围极光", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_1, maxtarget=99, throughWall=1, effectId={2029}},
	{skillID=1020025, name="铁轮战士射击", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, throughWall=1, effectId={2007}},
	{skillID=1020026, name="破坏骑士震地", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, throughWall=1, effectId={2008}},
	{skillID=1020027, name="黑炎魔技能", targetBuffID={{103019,1}}, needCareer=local_needCareer.needCareer_3, throughWall=1, effectId={49}},
	{skillID=1020028, name="炽炎魔毁灭烈焰", needCareer=local_needCareer.needCareer_3, targetRange=local_targetRange.targetRange_4, throughWall=1, effectId={2009}},
	{skillID=1020029, name="炽炎魔爆炎", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, throughWall=1, effectId={2010}},
	{skillID=1020030, name="魔王扎坎震地", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_4, throughWall=1},
	{skillID=1020031, name="魔王扎坎飞剑", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, throughWall=1, effectId={2011}},
	{skillID=1020032, name="丛林残暴者", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020033, name="丛林女巫师技能", skillCd=10000, needCareer=local_needCareer.needCareer_3, throughWall=1, effectId={2012}},
	{skillID=1020034, name="丛林召唤者火焰龙卷风", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_5, throughWall=1},
	{skillID=1020035, name="丛林召唤者火焰极光", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_6, throughWall=1, effectId={2013}},
	{skillID=1020036, name="阿卡摩斯粒子射击", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_9, throughWall=1, effectId={2017}},
	{skillID=1020037, name="恶灵/恶灵王毁灭烈焰", needCareer=local_needCareer.needCareer_3, targetRange=local_targetRange.targetRange_4, throughWall=1, effectId=local_effectId.effectId_16},
	{skillID=1020038, name="风后暴风雪", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_4, throughWall=1, effectId={2018}},
	{skillID=1020039, name="蓝/红魔龙喷射", needCareer=local_needCareer.needCareer_3, throughWall=1, effectId={2019}},
	{skillID=1020040, name="蓝/红魔龙毁灭烈焰", needCareer=local_needCareer.needCareer_3, targetRange=local_targetRange.targetRange_4, throughWall=1},
	{skillID=1020041, name="幻影骑士技能", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_1, throughWall=1, effectId={2020}},
	{skillID=1020042, name="菲尼斯扇形火焰", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_1, throughWall=1, effectId={2027}},
	{skillID=1020043, name="金甲兽射击", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_9, throughWall=1, effectId={2014}},
	{skillID=1020044, name="半兽人普攻", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020045, name="刀刃猎手普攻", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020046, name="寒冰刺客射击", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_9, throughWall=1, effectId={47}},
	{skillID=1020047, name="狂巨人普攻", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020048, name="疯魔群体普攻", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020049, name="屠杀者普攻", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020050, name="假面巫龙卷风", needCareer=local_needCareer.needCareer_3, throughWall=1, effectId=local_effectId.effectId_13},
	{skillID=1020051, name="假面巫黑龙波", needCareer=local_needCareer.needCareer_3, targetRotate=1, releaseRange=local_releaseRange.releaseRange_1, targetRange=local_targetRange.targetRange_4, throughWall=1, effectId=local_effectId.effectId_15},
	{skillID=1020052, name="毒步妖普攻", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020053, name="恐惧天使普攻", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020054, name="咒怨魔王5格群体普攻", skillCd=10000, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, throughWall=1},
	{skillID=1020055, name="咒怨魔王2格群体普攻", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020056, name="玛雅之手5格群体普攻", skillCd=10000, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, throughWall=1},
	{skillID=1020057, name="玛雅之手2格群体普攻", needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020058, name="召唤兽近战攻击", skillCd=1000, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, throughWall=1},
	{skillID=1020059, name="召唤兽黄金斗士射击", skillCd=1000, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, throughWall=1},
	{skillID=1020060, name="召唤萨迪洛斯攻击", skillCd=1000, needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020061, name="剧毒鬼魅普攻", needCareer=local_needCareer.needCareer_3, throughWall=1, effectId=local_effectId.effectId_5},
	{skillID=1020062, name="赤血要塞能量球", skillCd=500, icon="12020100", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_1, costMp=1, tips="单段伤害", effectId={2030}},
	{skillID=1020063, name="赤血要塞弓箭手普通攻击", skillCd=1000, commonCdOut=1000, speedCd=1, icon="", needCareer=local_needCareer.needCareer_4, powerRate=10000, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=0, throughWall=1, tips="弓箭手普通攻击", effectId={40}, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_2},
	{skillID=1020064, name="召唤兽4级普攻", targetBuffID={{130000411,1}}, commonCdOut=1000, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, throughWall=1},
	{skillID=1020065, name="召唤兽5级普攻", targetBuffID={{130000412,1}}, commonCdOut=1000, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, throughWall=1},
	{skillID=1020067, name="BOSS六格普攻", commonCdOut=3000, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_3, throughWall=1},
	{skillID=1030001, name="战士连击技能", cdType=0, skillCd=0, icon="", needCareer=local_needCareer.needCareer_5, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_4, fixedDamage=1000, powerRate=50000, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_7, maxtarget=8, tips="·<color=#e6e600>激活体内龙魂之力，对周围大范围目标造成高额伤害！</color>\n·造成<color=#00FF00>攻击力*30%+200</color>的伤害\n·在角色周身<color=#00FF00>3</color>格范围对最多<color=#00FF00>3</color>个目标生效\n·每一击增长<color=#00FF00>20%</color>连击值槽", effectId=local_effectId.effectId_7, growthFactor=10000, haloEffect=8001, skillatk=100},
	{skillID=1030002, name="法师连击技能", cdType=0, skillCd=0, icon="", injuryType=2, needCareer=local_needCareer.needCareer_6, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_4, fixedDamage=200, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=3, tips="·<color=#e6e600>激活体内龙魂之力，对周围大范围目标造成高额伤害！</color>\n·造成<color=#00FF00>魔法攻击力*30%+200</color>的伤害\n·在角色周身<color=#00FF00>3</color>格范围对最多<color=#00FF00>3</color>个目标生效\n·每一击增长<color=#00FF00>20%</color>连击值槽", effectId=local_effectId.effectId_7, growthFactor=10000, haloEffect=8001},
	{skillID=1030003, name="弓箭手连击技能", cdType=0, skillCd=0, icon="", needCareer=local_needCareer.needCareer_4, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_4, fixedDamage=200, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=3, tips="·<color=#e6e600>激活体内龙魂之力，对周围大范围目标造成高额伤害！</color>\n·造成<color=#00FF00>攻击力*30%+200</color>的伤害\n·在角色周身<color=#00FF00>3</color>格范围对最多<color=#00FF00>3</color>个目标生效\n·每一击增长<color=#00FF00>20%</color>连击值槽", effectId=local_effectId.effectId_7, growthFactor=10000, haloEffect=8001},
	{skillID=1040001, name="突袭（大师技）", skillCd=0, speedCd=1, icon="tuxi2", needCareer=local_needCareer.needCareer_5, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_1, costMp=200, newConsumeAG=1, throughWall=1, tips="冲到目标身前，对目标造成<color=#00FF00>攻击力*110%</color>的伤害，冷却时间22秒，释放后自身受到伤害减少<color=#00FF00>10%</color>，持续5秒", effectId={133}, attributeDamage={{201011,11000},{201021,11000}}, skillatk=178, speedSkillCd=33},
	{skillID=1040002, name="血腥风暴（大师技）", skillCd=0, speedCd=1, icon="xuexingfengbao2", needCareer=local_needCareer.needCareer_5, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=57, newConsumeAG=1, tips="对目标敌人造成<color=#00FF00>攻击力*240%</color>的伤害，同时对目标周围<color=#00FF00>攻击力*24%</color>的伤害，冷却时间30秒", effectId=local_effectId.effectId_8, attributeDamage=local_attributeDamage.attributeDamage_3, skillatk=25, speedSkillCd=33},
	{skillID=1040003, name="格挡（大师技）", targetBuffID=local_targetBuffID.targetBuffID_2, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=0, icon="gedang2", injuryType=0, needCareer=local_needCareer.needCareer_5, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_2, targetRange=local_targetRange.targetRange_1, maxtarget=6, tips="开启圣盾防御时，<color=#00FF00>5.0%</color>概率格挡伤害", skillatk=2, speedSkillCd=33},
	{skillID=1040004, name="坚固的庇护（大师技）", skillCd=0, icon="jiangudebihu2", injuryType=0, needCareer=local_needCareer.needCareer_5, needAtt=local_needAtt.needAtt_11, needWeapon=local_needWeapon.needWeapon_2, releaseRange={10}, targetRange={10}, maxtarget=5, costMp=65, newConsumeAG=1, tips="释放后，承担周围玩家<color=#00FF00>10%</color>的伤害，并且免疫该伤害的<color=#00FF00>18.0%</color>，持续10秒，冷却时间60秒", effectId={4010}, skillatk=0, speedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_11},
	{skillID=1040005, name="极光（大师技）", skillCd=0, speedCd=1, icon="12140100", injuryType=2, needCareer=local_needCareer.needCareer_6, needAtt=local_needAtt.needAtt_6, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_6, maxtarget=6, costMp=10, newConsumeAG=1, throughWall=0, tips="向目标发射一道纯净的极光，对路径上的敌人造成<color=#00FF00>魔法攻击力*252%</color>+额外<color=#00FF00>26</color>点技能伤害，冷却时间3.07秒", effectId=local_effectId.effectId_20, attributeDamage={{202011,25200},{202021,25200}}, skillatk=3, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_6},
	{skillID=1040006, name="爆炎（大师技）", skillCd=0, speedCd=1, icon="12160100", injuryType=2, needLevel=local_needLevel.needLevel_4, needCareer=local_needCareer.needCareer_6, needAtt=local_needAtt.needAtt_5, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_4, costMp=165, tips="造成<color=#00FF00>魔法攻击力*120%</color>+额外<color=#00FF00>13</color>点技能伤害，对目标周围两个敌人造成<color=#00FF00>魔法攻击力*60%</color>+额外<color=#00FF00>6</color>点技能伤害，冷却时间0.43秒", effectId=local_effectId.effectId_18, attributeDamage={{202011,12000},{202021,12000}}, skillatk=17, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_5},
	{skillID=1040007, name="流星石（大师技）", skillCd=0, speedCd=1, icon="12240100", needLevel=local_needLevel.needLevel_4, needCareer=local_needCareer.needCareer_6, needAtt={{10003,1160}}, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=105, tips="在3秒内，对主目标累计造成400%*攻击力的伤害，对主目标周围的玩家造成100%*攻击力的伤害，该伤害无视防御，冷却时间为60秒", effectId={4030}, attributeDamage={{201011,40000},{201021,40000}}, skillatk=105, magicSpeedSkillCd=33, useItemAtt={{10003,1160}}},
	{skillID=1040008, name="毒炎术（大师技）", skillCd=840, commonCdOut=840, speedCd=1, icon="12200100", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_12, needAtt={{10003,953}}, needWeapon=local_needWeapon.needWeapon_2, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_4, costMp=110, newConsumeAG=1, throughWall=1, tips="对范围内的目标释放猛毒，每3秒造成一次攻击力*100%的伤害，该伤害无视防御，持续6秒", effectId=local_effectId.effectId_21, attributeDamage=local_attributeDamage.attributeDamage_2, skillatk=95, magicSpeedSkillCd=33, useItemAtt={{10003,953}}},
	{skillID=1040009, name="掌心雷（大师技）", skillCd=0, speedCd=1, icon="12050100", injuryType=2, needCareer=local_needCareer.needCareer_6, needAtt=local_needAtt.needAtt_3, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_1, costMp=20, tips="发射闪电对目标造成魔法攻击力*96%+额外10点技能伤害，有概率击退目标，冷却时间0.43秒", effectId=local_effectId.effectId_9, attributeDamage={{202011,9600},{202021,9600}}, skillatk=40, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_3},
	{skillID=1040010, name="地牢术（大师技）", skillCd=0, speedCd=1, icon="12260100", needCareer=local_needCareer.needCareer_6, needAtt=local_needAtt.needAtt_2, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=180, newConsumeAG=1, tips="对一定范围内的目标造成攻击力*60%的伤害，有15%概率禁锢被命中的目标，冷却时间30秒", effectId={4050}, attributeDamage={{201011,6000},{201021,6000}}, skillatk=26, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_2},
	{skillID=1040011, name="闪避（大师技）", skillCd=0, icon="shanbi2", injuryType=0, needCareer=local_needCareer.needCareer_4, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_1, costMp=200, newConsumeAG=1, tips="释放后，在 1秒 内闪避所有攻击，冷却时间60秒", skillatk=0, speedSkillCd=33},
	{skillID=1040012, name="聚击（大师技）", skillCd=0, icon="juji2", needLevel=local_needLevel.needLevel_4, needCareer=local_needCareer.needCareer_4, needAtt={{10002,1302}}, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_4, costMp=12, newConsumeAG=1, tips="对一个目标连续造成 4段伤害，有 15% 概率造成 5段伤害，每段伤害攻击力*177%，冷却时间30秒", attributeDamage={{201011,17700},{201021,17700}}, skillatk=110, speedSkillCd=33, useItemAtt={{10002,1302}}},
	{skillID=1040013, name="毒箭（大师技）", skillCd=0, icon="dujian2", needCareer=local_needCareer.needCareer_4, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, costMp=50, newConsumeAG=1, tips="射出一支毒箭，让目标中毒，每3秒对目标造成攻击力*120%的伤害，该伤害无视防御，持续6秒，冷却时间40秒", effectId={4100}, attributeDamage=local_attributeDamage.attributeDamage_2, skillatk=27, speedSkillCd=33},
	{skillID=1040014, name="祝福（大师技）", skillCd=0, icon="13200100", injuryType=0, needCareer=local_needCareer.needCareer_4, needAtt=local_needAtt.needAtt_2, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=108, newConsumeAG=1, tips="增加周围玩家的智力、敏捷、力量属性，持续时长8秒，冷却时间60秒", effectId={134}, skillatk=0, speedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_2},
	{skillID=1040015, name="组队治疗（大师技）", skillCd=0, icon="13220100", injuryType=0, needCareer=local_needCareer.needCareer_4, needAtt=local_needAtt.needAtt_2, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=266, newConsumeAG=1, tips="以自身为中心治疗 5个玩家，恢复智力*10的生命，优先治疗最低生命玩家，冷却时间50秒", skillatk=0, speedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_2},
	{skillID=1040016, name="幻影（大师技）", skillCd=0, icon="13230100", injuryType=0, needCareer=local_needCareer.needCareer_4, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_1, costMp=150, newConsumeAG=1, tips="释放后可以使自己或目标隐身8秒，冷却时间40秒", skillatk=0, speedSkillCd=33},
	{skillID=1040017, name="极限（大师技）", skillCd=0, icon="jixian2", injuryType=0, needCareer=local_needCareer.needCareer_7, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_1, costMp=20, tips="使用后，造成的伤害增加10%，同时受到的伤害增加7%，持续时间6秒，冷却时间30秒"},
	{skillID=1040018, name="暗爆炎（大师技）", skillCd=0, icon="anbaoyan2", needLevel=local_needLevel.needLevel_4, needCareer=local_needCareer.needCareer_7, needAtt={{10003,1073}}, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_4, costMp=92, newConsumeAG=1, tips="对单个目标造成攻击力*240%伤害，冷却时间30秒", attributeDamage=local_attributeDamage.attributeDamage_3, skillatk=120, useItemAtt={{10003,1073}}},
	{skillID=1040019, name="冰封血（大师技）", skillCd=0, icon="bingfengxue2", needLevel=local_needLevel.needLevel_4, needCareer=local_needCareer.needCareer_7, needAtt={{10001,900}}, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_4, maxtarget=0, costMp=19, newConsumeAG=1, tips="对范围内目标造成攻击力*130%伤害，同时降低目标15%移速，以及5%攻速，持续4秒，冷却时间60秒", attributeDamage={{201011,13000},{201021,13000}}, skillatk=330, useItemAtt={{10001,900}}},
	{skillID=1040020, name="魔魂之握（大师技）", skillCd=0, icon="mohunzhiwo2", needCareer=local_needCareer.needCareer_7, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_1, costMp=20, tips="将距离1格内的目标拉到自己身边，对目标造成物理攻击*100%的伤害，并禁锢1秒，冷却时间15秒", attributeDamage={{201011,10000},{201021,10000}}},
	{skillID=1040021, name="暗影突袭（大师技）", skillCd=0, icon="anyingtuxi2", injuryType=0, needCareer=local_needCareer.needCareer_7, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_1, costMp=150, tips="释放技能后，提升自身120的移动速度，同时其他玩家对自身造成的物理伤害降低50%，抵抗1次冰封、致命一击、冰封血、冰封箭、魔魂之握、地裂的控制效果，持续4.0秒，冷却时间50秒。习得技能后自身获得10%伤害减免"},
	{skillID=1040022, name="小挪移（大师技）", skillCd=840, commonCdOut=840, icon="12180100", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer={{2,2}}, needAtt={{10003,644}}, needWeapon=local_needWeapon.needWeapon_2, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_7, costMp=90, newConsumeAG=1, tips="将6格内的一个友方玩家，拉到自己身边", skillatk=0, magicSpeedSkillCd=33, useItemAtt={{10003,644}}},
	{skillID=1040023, name="坐骑被动技能", skillCd=0, icon="12180100", autoLearn=1, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_5, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="被动技能，额外对敌人照成伤害", effectId=local_effectId.effectId_10},
	{skillID=1004000, name="全职业普通攻击", skillCd=1000, commonCdOut=1000, speedCd=1, icon="11007", needCareer={{1,1},{2,1},{3,1},{4,1},{5,1},{6,1},{7,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, effectId=local_effectId.effectId_1, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_2},
	{skillID=1100001, name="升龙击", targetBuffID=local_targetBuffID.targetBuffID_3, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=980, commonCdOut=920, speedCd=1, icon="shenglongji(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_8, needWeapon={{3,1004},{3,1007},{3,1008},{3,2004},{3,2007},{3,2008},{3,100499},{3,100799},{3,100899},{3,200499},{3,200799},{3,200899}}, skillLevelUpItemID={{60030062,1}}, changePoint=local_changePoint.changePoint_2, changePointSpeed=5, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=8, tips="对目标造成<color=#00FF00>物理攻击力*100%</color>技能伤害", effectId={8}, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1100002, name="地裂斩", skillCd=970, commonCdOut=920, speedCd=1, icon="diliezhan(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_8, needWeapon={{3,1012},{3,1038},{3,1039},{3,1041},{3,1042},{3,1043},{3,1044},{3,1046},{3,1048},{3,1049},{3,2037},{3,2012},{3,2038},{3,2040},{3,2041},{3,2042},{3,2043},{3,2045},{3,2048},{3,2047},{3,101299},{3,103899},{3,103999},{3,104199},{3,104299},{3,104399},{3,104499},{3,104699},{3,104899},{3,104999},{3,201299},{3,203799},{3,203899},{3,204099},{3,204199},{3,204299},{3,204399},{3,204599},{3,204799},{3,204899}}, skillLevelUpItemID={{60030060,1}}, costHp=0, costMp=9, tips="对目标造成<color=#00FF00>物理攻击力*100%</color>技能伤害", effectId={9}, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1100003, name="旋风斩", targetBuffID=local_targetBuffID.targetBuffID_3, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=960, commonCdOut=920, speedCd=1, icon="xuanfengzhan(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_8, needWeapon={{3,20310511},{3,20310521},{3,20310211},{3,20310221},{3,20310311},{3,20310321},{3,20310411},{3,20310421},{3,20310611},{3,20310621},{3,20310711},{3,20310721},{3,1010},{3,1019},{3,1024},{3,1035},{3,1067},{3,1074},{3,1075},{3,1076},{3,1077},{3,1078},{3,1147},{3,2010},{3,2024},{3,2065},{3,2072},{3,2073},{3,2074},{3,2075},{3,2076},{3,31105801},{3,2031051199},{3,2031052199},{3,2031021199},{3,2031022199},{3,2031031199},{3,2031032199},{3,2031041199},{3,2031042199},{3,2031061199},{3,2031062199},{3,2031071199},{3,101099},{3,2031072199},{3,101999},{3,102499},{3,103599},{3,106799},{3,107499},{3,107599},{3,107699},{3,107799},{3,107899},{3,114799},{3,201099},{3,202499},{3,206599},{3,207299},{3,207399},{3,207499},{3,207599},{3,207699},{3,1110580199}}, skillLevelUpItemID={{60030063,1}}, changePoint=local_changePoint.changePoint_2, changePointSpeed=5, maxtarget=3, costHp=0, costMp=9, tips="对目标造成<color=#00FF00>物理攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_3, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1100004, name="牙突刺", skillCd=950, commonCdOut=920, speedCd=1, icon="Ya_TuCi(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_8, needWeapon={{3,1003},{3,1006},{3,1011},{3,1009},{3,1071},{3,2003},{3,2006},{3,2009},{3,2011},{3,2069},{3,100399},{3,100699},{3,100999},{3,101199},{3,107199},{3,200399},{3,200699},{3,200999},{3,201199},{3,206999}}, skillLevelUpItemID={{60030061,1}}, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=9, tips="对目标造成<color=#00FF00>物理攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_10, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1100005, name="天地十字剑", skillCd=940, commonCdOut=920, speedCd=1, icon="tiandishizijian(1)", needLevel=local_needLevel.needLevel_2, needCareer={{1,1},{4,1}}, needWeapon={{3,1015},{3,1017},{3,1018},{3,1050},{3,2015},{3,2017},{3,2018},{3,2049},{3,101599},{3,101799},{3,101899},{3,105099},{3,201799},{3,201599},{3,201899},{3,204999}}, skillLevelUpItemID={{60030064,1}}, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=10, tips="对目标造成<color=#00FF00>物理攻击力*100%</color>技能伤害", effectId={10}, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1100006, name="霹雳回旋斩", skillCd=1110, commonCdOut=1120, speedCd=1, icon="pilihuixuanzhan(1)", needLevel={80}, needCareer={{1,1},{4,1},{1,2},{1,3}}, skillLevelUpItemID={{60030022,1}}, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=10, newConsumeAG=3, tips="对周围敌人造成<color=#00FF00>物理攻击力*100%</color>技能伤害", effectId={6}, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1100007, name="生命之光", targetBuffID={{110000701,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=10000, commonCdOut=1120, speedCd=0, icon="shengmingzhiguang(1)", injuryType=0, needLevel={120}, needCareer={{1,1},{1,2},{1,3}}, skillLevelUpItemID={{60030025,1}}, releaseRange=local_releaseRange.releaseRange_2, targetRange=local_targetRange.targetRange_7, maxtarget=8, costHp=0, costMp=22, newConsumeAG=24, tips="提高自身及周遭队友<color=#00FF00>基础10%+体力值/100*1%+智力值/20*1%</color>血量上限，提高比例受体力与智力的加成，持续<color=#00FF00>5分钟</color>", effectId={7}, skillatk=0, speedSkillCd=33},
	{skillID=1100008, name="袭风刺", skillCd=1130, commonCdOut=1120, speedCd=1, icon="xifengci(1)", needLevel={160}, needCareer=local_needCareer.needCareer_9, skillLevelUpItemID={{60030021,1}}, releaseRange=local_releaseRange.releaseRange_5, targetRange={2,1}, maxtarget=3, costHp=0, costMp=15, newConsumeAG=3, tips="对前方的目标和敌人<color=#00FF00>物理攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_11, skillatk=70, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_4},
	{skillID=1100009, name="雷霆裂闪", skillCd=1140, commonCdOut=1120, speedCd=1, icon="leitinglieshan(1)", needLevel=local_needLevel.needLevel_5, needCareer=local_needCareer.needCareer_9, skillLevelUpItemID={{60030023,1}}, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=25, newConsumeAG=20, tips="对自身周围的敌人造成<color=#00FF00>物理攻击力*100%</color>技能伤害", effectId={3}, skillatk=60, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_4},
	{skillID=1100010, name="致命一击", targetBuffID={{110001003,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=1150, commonCdOut=1120, speedCd=1, icon="zhimingyiji(1)", needLevel=local_needLevel.needLevel_3, needCareer=local_needCareer.needCareer_9, skillLevelUpItemID={{60030026,1}}, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=30, newConsumeAG=24, tips="对目标和周围敌人造成<color=#00FF00>物理攻击力*100%</color>技能伤害，10%概率使目标减速<color=#00FF00>60%</color>持续<color=#00FF00>2.5秒</color>", effectId={2}, skillatk=110, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_4},
	{skillID=1200001, name="能量球", skillCd=840, commonCdOut=840, speedCd=1, icon="nengliangqiu(1)", injuryType=2, autoLearn=1, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_10, fixedDamage=6, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=1, tips="发射能量球对目标造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId={12}, skillatk=3, magicSpeedSkillCd=33, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200002, name="火球", skillCd=850, commonCdOut=840, speedCd=1, icon="huoqiu(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer={{2,1},{2,2},{2,3},{4,1},{4,2},{4,3},{6,1},{6,2},{6,3}}, needAtt={{10003,40}}, skillLevelUpItemID={{60030004,1}}, fixedDamage=7, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=3, tips="发射火球对目标造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId={11}, skillatk=8, magicSpeedSkillCd=33, useItemAtt={{10003,40}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200003, name="真空波", skillCd=860, commonCdOut=840, speedCd=1, icon="zhenkongbo(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_10, needAtt={{10003,56}}, skillLevelUpItemID={{60030011,1}}, fixedDamage=8, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=5, tips="发射真空波对目标造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_12, skillatk=14, magicSpeedSkillCd=33, useItemAtt={{10003,56}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200004, name="掌心雷", targetBuffID={{120000403,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=870, commonCdOut=840, speedCd=1, icon="zhangxinlei(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_11, needAtt=local_needAtt.needAtt_3, skillLevelUpItemID={{60030003,1}}, fixedDamage=9, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=15, tips="发射闪电对目标造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_9, skillatk=17, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_3, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200005, name="龙卷风", skillCd=880, commonCdOut=840, speedCd=1, icon="longjuanfeng(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_11, needAtt=local_needAtt.needAtt_10, skillLevelUpItemID={{60030008,1}}, monsterExtraDamage={{1,16000},{2,100}}, playerExtraDamage={{1,1000},{2,100}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange={5,3}, maxtarget=6, costHp=0, costMp=60, tips="召唤龙卷风，对路径上的目标造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_13, skillatk=35, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_10, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200006, name="陨石", skillCd=890, commonCdOut=840, speedCd=1, icon="yunshi(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer={{2,1},{4,1},{6,1}}, needAtt={{10003,104}}, skillLevelUpItemID={{60030002,1}}, fixedDamage=11, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=12, tips="召唤陨石对目标造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_14, skillatk=21, magicSpeedSkillCd=33, useItemAtt={{10003,104}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200007, name="火龙", skillCd=900, commonCdOut=840, speedCd=1, icon="huolong(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_12, needAtt={{10003,160}}, skillLevelUpItemID={{60030005,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, maxtarget=3, costHp=0, costMp=50, tips="召唤火龙，对目标及周围敌人造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId={19}, skillatk=25, magicSpeedSkillCd=33, useItemAtt={{10003,160}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200008, name="黑龙波", skillCd=910, commonCdOut=840, speedCd=1, icon="heilongbo(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer={{2,1},{4,1},{2,2}}, needAtt={{10003,220}}, skillLevelUpItemID={{60030009,1}}, powerRate=10000, targetRotate=1, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_7, maxtarget=6, costHp=0, costMp=90, tips="对自身周围敌人造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_15, skillatk=45, magicSpeedSkillCd=33, useItemAtt={{10003,220}}, skillattPower=local_skillattPower.skillattPower_5, CanUseSkillEffectPlayTime=1},
	{skillID=1200009, name="毁灭烈焰", skillCd=920, commonCdOut=840, speedCd=1, icon="huimielieyan(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer={{2,1},{4,1},{2,2},{4,1}}, needAtt={{10003,724}}, skillLevelUpItemID={{60030014,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_4, maxtarget=6, costHp=0, costMp=200, tips="对周围敌人造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_16, skillatk=100, magicSpeedSkillCd=33, useItemAtt={{10003,724}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200010, name="暴风雪", targetBuffID={{120001001,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=930, commonCdOut=840, speedCd=1, icon="baofengxue1(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_13, needAtt=local_needAtt.needAtt_4, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_6, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=100, newConsumeAG=5, tips="对目标和周围敌人造成<color=#00FF00>魔法攻击力*100%</color>技能伤害，20%概率使目标减速<color=#00FF00>20%</color>持续<color=#00FF00>1秒</color>", effectId=local_effectId.effectId_17, skillatk=80, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_4, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200011, name="守护之魂", targetBuffID={{120001101,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=10000, commonCdOut=840, speedCd=0, icon="shouhuzhihun(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_13, needAtt={{10003,408}}, skillLevelUpItemID={{60030016,1}}, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_5, maxtarget=6, costHp=0, costMp=70, newConsumeAG=22, tips="生成一个法力护盾，减少<color=#00FF00>基础10%+敏捷值/50*1%+智力值/200*1%</color>自身受到的伤害，减少的伤害受敏捷与智力的加成，持续时间<color=#00FF00>5分钟</color>", effectId=local_effectId.effectId_28, skillatk=0, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_13, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200012, name="地狱火", skillCd=950, commonCdOut=840, speedCd=1, icon="diyuhuo(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_14, needAtt={{10003,260}}, skillLevelUpItemID={{60030010,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=160, tips="对自身周围敌人造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_24, skillatk=120, magicSpeedSkillCd=33, useItemAtt={{10003,260}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200013, name="爆炎", skillCd=960, commonCdOut=840, speedCd=1, icon="yanbao(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_14, needAtt=local_needAtt.needAtt_5, skillLevelUpItemID={{60030013,1}}, fixedDamage=13, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_4, maxtarget=5, costHp=0, costMp=150, tips="造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_18, skillatk=70, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_5, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200014, name="冰封", targetBuffID={{120001401,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=970, commonCdOut=840, speedCd=1, icon="bingfengyu(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_10, needAtt={{10003,120}}, skillLevelUpItemID={{60030007,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=38, tips="对目标造成<color=#00FF00>魔法攻击力*100%</color>技能伤害，10%概率使目标减速<color=#00FF00>50%</color>持续<color=#00FF00>2秒</color>", effectId=local_effectId.effectId_19, skillatk=10, magicSpeedSkillCd=33, useItemAtt={{10003,120}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200015, name="毒咒", targetBuffID={{120001501,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=980, commonCdOut=840, speedCd=1, icon="duzhou(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_12, needAtt={{10003,140}}, skillLevelUpItemID={{60030001,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, costHp=0, costMp=42, tips="对目标造成<color=#00FF00>魔法攻击力*100%</color>技能伤害，并使目标中毒", effectId={21}, skillatk=12, magicSpeedSkillCd=33, useItemAtt={{10003,140}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200016, name="极光", skillCd=990, commonCdOut=840, speedCd=1, icon="jiguang(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_11, needAtt=local_needAtt.needAtt_6, skillLevelUpItemID={{60030012,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_6, maxtarget=6, costHp=0, costMp=140, tips="向目标发射一道纯净的极光，对路径上的敌人造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId=local_effectId.effectId_20, skillatk=80, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_6, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1200017, name="瞬间移动", targetBuffID=local_targetBuffID.targetBuffID_4, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=1000, commonCdOut=840, speedCd=1, icon="shunjianyidong(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_18, needAtt=local_needAtt.needAtt_7, skillLevelUpItemID={{60030006,1}}, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_5, costHp=0, costMp=30, tips="瞬移到自身前方的另一个位置", effectId=local_effectId.effectId_23, skillatk=0, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_7},
	{skillID=1200018, name="小挪移", targetBuffID={{120001801,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, cdType=0, cdTime=6000, skillCd=1010, commonCdOut=840, speedCd=1, icon="xiaonuoyi(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_6, needAtt=local_needAtt.needAtt_7, skillLevelUpItemID={{60035104,1}}, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_5, costHp=0, costMp=30, newConsumeAG=25, tips="仅组队可释放，使选中的队友瞬移到自身前方的另一个位置", effectId=local_effectId.effectId_29, skillatk=0, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_7},
	{skillID=1200019, name="毒炎", skillCd=1020, commonCdOut=840, speedCd=1, icon="duzhou(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_6, needAtt={{10003,100}}, skillLevelUpItemID={{60035105,1}}, fixedDamage=11, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=12, newConsumeAG=7, tips="向指定的地方掉落剧毒陨石向多数敌人造成伤害，受伤害的目标以一定概率造成毒伤害。", effectId=local_effectId.effectId_21, skillatk=21, magicSpeedSkillCd=33, useItemAtt={{10003,100}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1300001, name="穿透箭", skillCd=860, commonCdOut=960, speedCd=1, icon="chuantoujian(1)", needLevel={130}, needCareer={{3,1},{3,2}}, skillLevelUpItemID={{60030037,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_6, maxtarget=6, costHp=0, costMp=7, newConsumeAG=9, tips="向目标射出一支箭矢，对途径的敌人造成<color=#00FF00>物理攻击力*100%</color>技能伤害", weaponMatch=local_weaponMatch.weaponMatch_2, effectId={28,65,66,67,81,159,160,161,162,163,164,86,87,88,89,92,94,91,93,90}, skillatk=70, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_6},
	{skillID=1300002, name="多重箭", skillCd=870, commonCdOut=960, speedCd=1, icon="duochongjian2", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needWeapon={{0},{1,6},{1,601},{1,602},{1,603},{1,604},{1,605},{1,606},{1,607},{1,608},{1,609},{1,610},{1,701},{1,702},{1,703},{1,704},{1,705},{1,706},{1,707},{1,708},{1,709}}, skillLevelUpItemID={{60030067,1}}, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_6, maxtarget=6, costHp=0, costMp=5, tips="对敌人造成<color=#00FF00>物理攻击力*100%</color>技能伤害", weaponMatch=local_weaponMatch.weaponMatch_2, effectId={29,63,64,60,80,62,61,143,144,145,146,95,96,97,98,101,103,100,102,99}, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_6},
	{skillID=1300003, name="战神之力", targetBuffID={{130000301,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=880, commonCdOut=960, icon="gongjilitigao(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt={{10003,92}}, skillLevelUpItemID={{60030029,1}}, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_7, maxtarget=8, costHp=0, costMp=40, tips="对自身施放时，增加自身<color=#00FF00>3+智力值/7</color>攻击力，增加的攻击力受施法者智力加成，持续<color=#00FF00>5+智力/7</color>秒", effectId={39}, skillatk=0, speedSkillCd=33, useItemAtt={{10003,92}}},
	{skillID=1300004, name="守护之光", targetBuffID={{130000401,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=890, commonCdOut=960, icon="8001130", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt=local_needAtt.needAtt_3, skillLevelUpItemID={{60030028,1}}, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_7, maxtarget=8, costHp=0, costMp=30, tips="对自身施放时，增加自身<color=#00FF00>2+智力值/8</color>防御力，增加的防御力受施法者智力加成，持续<color=#00FF00>5+智力/7</color>秒", effectId={38}, skillatk=0, speedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_3},
	{skillID=1300005, name="治疗", targetBuffID={{130000501,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=900, commonCdOut=960, icon="zhiliao(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt=local_needAtt.needAtt_12, skillLevelUpItemID={{60030027,1}}, monsterExtraDamage={{1,100},{2,200}}, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_7, maxtarget=8, costHp=0, costMp=20, tips="恢复自身或队友<color=#00FF00>5+智力值/5</color>血量，恢复血量受施法者智力加成", effectId={37}, skillatk=0, speedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_12},
	{skillID=1300006, name="冰封箭", targetBuffID={{130000603,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=910, commonCdOut=960, speedCd=1, icon="bingfengjian(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_16, needAtt={{10002,646}}, skillLevelUpItemID={{60030038,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=10, newConsumeAG=12, tips="造成<color=#00FF00>物理攻击力*100%</color>技能伤害，同时10%概率使目标无法移动，持续<color=#00FF00>1秒</color>", weaponMatch=local_weaponMatch.weaponMatch_2, effectId={165,68,69,70,82,153,154,155,156,157,158,71,72,73,74,77,79,76,78,75}, skillatk=105, speedSkillCd=33, useItemAtt={{10002,646}}, skillattPower=local_skillattPower.skillattPower_6},
	{skillID=1300007, name="五重箭", skillCd=920, commonCdOut=960, speedCd=1, icon="wuchongjian(1)", needLevel=local_needLevel.needLevel_3, needCareer=local_needCareer.needCareer_16, skillLevelUpItemID={{60030039,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_9, maxtarget=6, costHp=0, costMp=11, newConsumeAG=4, tips="射出五支箭，每支造成<color=#00FF00>物理攻击力*100%</color>技能伤害", weaponMatch=local_weaponMatch.weaponMatch_2, effectId={41,104,105,106,126,147,148,149,150,151,152,107,108,109,110,113,115,112,114,111}, skillatk=40, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_6},
	{skillID=1303001, name="召唤哥布林", skillCd=930, commonCdOut=960, icon="zhaohuangebulin(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt={{10003,30}}, skillLevelUpItemID={{60030030,1}}, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=40, tips="召唤一只哥布林，继承人物<color=#00FF00>35%</color>物理攻击力", effectId={30}, skillatk=0, speedSkillCd=33, useItemAtt={{10003,30}}},
	{skillID=1303002, name="召唤石巨人", skillCd=940, commonCdOut=960, icon="zhaohuanshijuren(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt={{10003,60}}, skillLevelUpItemID={{60030031,1}}, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=70, tips="召唤一只石巨人，继承人物<color=#00FF00>42%</color>物理攻击力", effectId={31}, skillatk=0, speedSkillCd=33, useItemAtt={{10003,60}}},
	{skillID=1303003, name="召唤暗杀者", skillCd=950, commonCdOut=960, icon="zhaohuananshazhe(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt={{10003,90}}, skillLevelUpItemID={{60030032,1}}, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=110, tips="召唤一位暗杀者，继承人物<color=#00FF00>49%</color>物理攻击力", effectId={32}, skillatk=0, speedSkillCd=33, useItemAtt={{10003,90}}},
	{skillID=1303004, name="召唤雪人王", skillCd=960, commonCdOut=960, icon="zhaohuanxuerenwang(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt={{10003,130}}, skillLevelUpItemID={{60030033,1}}, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=160, tips="召唤一只雪人王，继承人物<color=#00FF00>56%</color>物理攻击力", effectId={33}, skillatk=0, speedSkillCd=33, useItemAtt={{10003,130}}},
	{skillID=1303005, name="召唤暗黑骑士", skillCd=970, commonCdOut=960, icon="zhaohuananheiqishi(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt={{10003,170}}, skillLevelUpItemID={{60030034,1}}, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=200, tips="召唤一位暗黑骑士，继承人物<color=#00FF00>63%</color>物理攻击力", effectId={34}, skillatk=0, speedSkillCd=33, useItemAtt={{10003,170}}},
	{skillID=1303006, name="召唤守护兽巴里", skillCd=980, commonCdOut=960, icon="zhaohuanbali(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt={{10003,210}}, skillLevelUpItemID={{60030035,1}}, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=250, tips="召唤守护兽巴里，继承人物<color=#00FF00>70%</color>物理攻击力", effectId={36}, skillatk=0, speedSkillCd=33, useItemAtt={{10003,210}}},
	{skillID=1303007, name="召唤黄金斗士", skillCd=990, commonCdOut=960, icon="zhaohuanhuangjindoushi(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt=local_needAtt.needAtt_9, skillLevelUpItemID={{60030036,1}}, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=350, tips="召唤一位黄金斗士，继承人物<color=#00FF00>91%</color>物理攻击力", effectId={35}, skillatk=0, speedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_9},
	{skillID=1004019, name="天雷闪", skillCd=870, commonCdOut=1120, speedCd=1, icon="tianleishan(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_17, needWeapon={{3,1021},{3,1023},{3,1025},{3,1031},{3,1051},{3,2021},{3,2023},{3,2025},{3,2031},{3,102199},{3,102399},{3,102599},{3,103199},{3,105199},{3,202199},{3,202399},{3,202599},{3,203199}}, skillLevelUpItemID={{60030068,1}}, powerRate=20000, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_6, maxtarget=6, costHp=0, costMp=15, tips="对扇形范围内目标造成<color=#00FF00>攻击力*200%</color>的伤害", effectId={128}, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1004020, name="玄月斩", targetExecutNode=local_targetExecutNode.targetExecutNode_3, skillCd=880, commonCdOut=1120, speedCd=1, icon="xuanyuezhan(1)", needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_17, needAtt={{10001,596}}, skillLevelUpItemID={{60030079,1}}, powerRate=20000, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_6, maxtarget=3, costHp=0, costMp=17, newConsumeAG=10, tips="对目标造成<color=#00FF00>攻击力*200%</color>的伤害，并减少目标玩家<color=#00FF00>30%</color>的回复效果，持续5秒", effectId={127}, skillatk=80, speedSkillCd=33, useItemAtt={{10001,596}}, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1004021, name="火剑袭", skillCd=890, commonCdOut=1120, speedCd=1, icon="huojianxi(1)", needLevel=local_needLevel.needLevel_3, needCareer=local_needCareer.needCareer_17, skillLevelUpItemID={{60030080,1}}, monsterExtraDamage={{1,16000},{2,17}}, playerExtraDamage={{1,510}}, powerRate=20000, releaseRange=local_releaseRange.releaseRange_5, targetRange={3,3}, maxtarget=6, costHp=0, costMp=20, newConsumeAG=25, tips="对目标造成<color=#00FF00>攻击力*200%</color>的伤害，并且提升自身伤害，每<color=#00FF00>600点力量</color>提升<color=#00FF00>1%</color>，持续10秒", effectId={232}, skillatk=140, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1004022, name="闪电轰顶", skillCd=900, commonCdOut=840, speedCd=1, icon="shandianhongding(1)", injuryType=2, needLevel=local_needLevel.needLevel_3, needCareer=local_needCareer.needCareer_17, needAtt=local_needAtt.needAtt_8, skillLevelUpItemID={{60035098,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_5, maxtarget=6, costHp=0, costMp=120, newConsumeAG=8, tips="对周围大范围目标造成<color=#00FF00>魔法攻击力*100%</color>的伤害", effectId={129}, skillatk=110, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_8, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1004023, name="暗影突袭", skillAtt={{312052,1000}}, targetBuffID={{100402301,1},{100402302,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_3, skillCd=910, commonCdOut=1000, speedCd=0, icon="meiying(1)", injuryType=0, needCareer={{4,2}}, skillLevelUpItemID={{60030082,1}}, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, costHp=0, costMp=0, tips="施放技能后，提升自身120的移动速度，同时其他玩家对自身造成的物理伤害降低50%，抵抗l次冰封、致命一击、冰封血、冰封箭、魔魂之握、地裂的控制效果，持续4秒，冷却时间50秒。习得技能后自身获得10%伤害减免", effectId={10040231}},
	{skillID=1304001, name="弓箭手弓箭普通攻击", skillCd=1000, commonCdOut=1000, speedCd=1, icon="13130100_3", needCareer=local_needCareer.needCareer_4, powerRate=10000, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=0, tips="弓箭手弓箭普通攻击", effectId=local_effectId.effectId_22, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_2},
	{skillID=1304002, name="弓箭手弩箭普通攻击", skillCd=1010, commonCdOut=1000, speedCd=1, icon="13130100_3", needCareer=local_needCareer.needCareer_4, powerRate=10000, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=0, tips="弓箭手弩箭普通攻击", effectId=local_effectId.effectId_22, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_2},
	{skillID=1400001, name="宝石被动技能（测试）", skillCd=880, speedCd=1, icon="", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="攻击时有30%概率造成50点额外伤害", effectId=local_effectId.effectId_10},
	{skillID=2000011, name="狂暴", skillCd=880, commonCdOut=1000, speedCd=1, icon="kuangbaoshu(1)", injuryType=0, targetRange=local_targetRange.targetRange_2, costHp=0, costMp=100, newConsumeAG=1, tips="对敌人单体造成5倍攻击力伤害，cd10秒", effectId=local_effectId.effectId_18},
	{skillID=2000021, name="瞬间移动", targetBuffID=local_targetBuffID.targetBuffID_4, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=1030, commonCdOut=1000, icon="shunjianyidong(1)", injuryType=0, needCareer=local_needCareer.needCareer_18, needAtt=local_needAtt.needAtt_7, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_5, costHp=0, costMp=30, tips="瞬间移动", effectId=local_effectId.effectId_23, useItemAtt=local_useItemAtt.useItemAtt_7},
	{skillID=2000031, name="山崩地裂", skillCd=890, commonCdOut=1000, icon="8004130", needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=10, costHp=0, costMp=0, tips="对自身周围3格造成4倍攻击力伤害", effectId=local_effectId.effectId_27},
	{skillID=2000041, name="急速咒印", targetBuffID={{200004101,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=910, commonCdOut=1000, icon="8003130", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="攻速提升10%，持续5秒，cd20秒", effectId={3003}},
	{skillID=2000051, name="突袭", skillCd=920, commonCdOut=1000, icon="8002130", injuryType=0, changePoint={1,3}, changePointSpeed=6, releaseRange=local_releaseRange.releaseRange_9, targetRange={4}, maxtarget=6, costHp=0, costMp=200, newConsumeAG=1, tips="突进到目标旁边，对周围4格造成6倍攻击力伤害，cd15秒", effectId=local_effectId.effectId_3, skillatk=178},
	{skillID=2000052, name="毁灭", targetBuffID={{200005201,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=930, commonCdOut=1000, icon="8002150", injuryType=0, needLevel=local_needLevel.needLevel_2, costHp=0, costMp=0, tips="对敌单体造成10倍攻击力伤害，并每秒造成1%最大生命值伤害，持续5秒，cd20秒", effectId={4040}},
	{skillID=2000061, name="天使圣盾", targetBuffID={{200006101,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=940, commonCdOut=1000, icon="8001130", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="生成一个自身最大生命20%的护盾，cd20秒", effectId={3001}},
	{skillID=2000062, name="终极审判", skillCd=50, commonCdOut=1000, icon="8001150", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_10, targetRange=local_targetRange.targetRange_8, maxtarget=6, costHp=0, costMp=0, tips="对面前6格造成8倍攻击力伤害，cd20秒", effectId={2000062}},
	{skillID=2200011, name="地狱之炎", skillCd=960, icon="8006120", injuryType=0, needLevel=local_needLevel.needLevel_2, targetRange=local_targetRange.targetRange_4, maxtarget=5, costHp=0, costMp=0, tips="对自身周围每秒造成0.4倍攻击力伤害"},
	{skillID=2200021, name="轻盈敏捷", targetBuffID={{220002101,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=890, icon="8005120", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="移速加成5%"},
	{skillID=2200031, name="铜皮铁骨", targetBuffID={{220003101,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=890, icon="8004120", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="伤害吸收3%"},
	{skillID=2200032, name="恐惧使者", targetBuffID={{220003201,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=890, icon="8004140", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="攻击敌人时给自身施加1%伤害降低效果，可叠加5层，持续6秒"},
	{skillID=2200041, name="增幅咒印", targetBuffID={{220004101,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=890, icon="8003120", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="伤害加成3%"},
	{skillID=2200042, name="衰减咒印", targetBuffID={{220004201,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=890, icon="8003140", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="攻击敌人施加1%易伤效果，可叠加5层，持续6秒"},
	{skillID=2200051, name="恶魔本能", targetBuffID={{220005101,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=890, icon="8002120", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="受到玩家控制（眩晕，减速，止步)后清除受到控制，CD长30秒"},
	{skillID=2200052, name="斩首", targetBuffID={{220005201,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=890, icon="8002140", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="敌人满血时，造成5%最大生命值的额外伤害"},
	{skillID=2200061, name="自愈之光", targetBuffID={{220006101,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=890, icon="8001120", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="每3秒恢复1%最大生命值"},
	{skillID=2200062, name="生命夺取", targetBuffID={{220006201,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_3, skillCd=890, icon="8001140", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_1, costHp=0, costMp=0, tips="每次造成伤害的5%转化为生命恢复"},
	{skillID=2040011, name="变身卡牌地狱角魔普通攻击", skillCd=890, commonCdOut=1000, speedCd=1, icon="8001110", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=8, costHp=0, costMp=0, tips="对自身周围3格造成2.5倍攻击力伤害", effectId={2040011}},
	{skillID=2040021, name="变身卡牌水晶鹿普通攻击", skillCd=890, commonCdOut=1000, speedCd=1, icon="8001110", injuryType=0, needLevel=local_needLevel.needLevel_2, targetRange=local_targetRange.targetRange_4, maxtarget=4, costHp=0, costMp=0, tips="对自身周围2格造成2.5倍攻击力伤害", effectId={2040021}},
	{skillID=2040031, name="变身卡牌泰克图斯普通攻击", skillCd=890, commonCdOut=1000, speedCd=1, icon="8001110", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=8, costHp=0, costMp=0, tips="对自身周围3格造成2.6倍攻击力伤害", effectId={2040031}},
	{skillID=2040041, name="变身卡牌丛林召唤者普通攻击", skillCd=890, commonCdOut=1000, speedCd=1, icon="8001110", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_10, targetRange=local_targetRange.targetRange_8, maxtarget=6, costHp=0, costMp=0, tips="对自身周围6格造成2.6倍攻击力伤害", effectId={2040041}},
	{skillID=2040051, name="变身卡牌大恶魔普通攻击", skillCd=890, commonCdOut=1000, speedCd=1, icon="8001110", injuryType=0, needLevel=local_needLevel.needLevel_2, releaseRange=local_releaseRange.releaseRange_10, targetRange=local_targetRange.targetRange_8, maxtarget=6, costHp=0, costMp=0, tips="对自身周围6格造成2.8倍攻击力伤害", effectId={2040051}},
	{skillID=2040061, name="变身卡牌天使审判长普通攻击", skillCd=890, commonCdOut=1000, speedCd=1, icon="8001110", injuryType=0, needLevel=local_needLevel.needLevel_2, targetRange=local_targetRange.targetRange_4, maxtarget=4, costHp=0, costMp=0, tips="对自身周围2格造成2.8倍攻击力伤害", effectId={2040061}},
	{skillID=1020066, name="火龙王攻击技能（额外5%最大生命值伤害）", targetBuffID={{230000001}}, skillCd=905, commonCdOut=1000, icon="", needCareer=local_needCareer.needCareer_3, targetRange=local_targetRange.targetRange_2, maxtarget=4, throughWall=1, effectId=local_effectId.effectId_24},
	{skillID=1016005, name="链雷咒", skillCd=910, commonCdOut=1000, speedCd=1, icon="lianleizhou(1)", damageType=1, damageformula=local_damageformula.damageformula_2, injuryType=2, needCareer=local_needCareer.needCareer_19, needAtt={{10003,245}}, skillLevelUpItemID={{60035083,1}}, fixedDamage=11, powerRate=10000, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_2, maxtarget=3, costHp=0, costMp=85, tips="对目标造成<color=#00FF00>魔法攻击力*170%</color>技能伤害，使目标减速<color=#00FF00>60%</color>持续<color=#00FF00>3.6秒</color>，冷却时间<color=#00FF00>0.85秒</color>；<color=#00FF00>10%</color>概率本次技能伤害提高<color=#00FF00>60%</color>", effectId={1016005}, skillatk=70, magicSpeedSkillCd=33, useItemAtt={{10003,245}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1016006, name="狂暴术", targetBuffID={{250001013,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=920, commonCdOut=1000, speedCd=1, icon="kuangbaoshu(1)", injuryType=0, needCareer=local_needCareer.needCareer_19, needAtt=local_needAtt.needAtt_9, skillLevelUpItemID={{60035084,1}}, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_2, costHp=0, costMp=100, newConsumeAG=50, tips="增加自身的魔法攻击力和攻击速度。追加减少防御力和生命。", effectId={1016006}, skillatk=0, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_9, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1016007, name="昏睡术", skillCd=930, commonCdOut=1000, speedCd=1, icon="hunshuishu(1)", injuryType=2, needCareer=local_needCareer.needCareer_19, needAtt=local_needAtt.needAtt_10, skillLevelUpItemID={{60035085,1}}, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=20, newConsumeAG=3, tips="对目标造成<color=#00FF00>魔法攻击力*170%</color>技能伤害，使目标减速<color=#00FF00>60%</color>持续<color=#00FF00>3.6秒</color>，冷却时间<color=#00FF00>0.85秒</color>；<color=#00FF00>10%</color>概率本次技能伤害提高<color=#00FF00>60%</color>", effectId={1016007}, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_10, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1016008, name="爆裂击", skillCd=940, commonCdOut=1000, speedCd=1, icon="baolieji(1)", damageType=0, injuryType=3, needCareer=local_needCareer.needCareer_19, needAtt=local_needAtt.needAtt_9, skillLevelUpItemID={{60035086,1}}, fixedDamage=11, powerRate=10000, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_9, maxtarget=6, costHp=0, costMp=35, tips="对目标造成<color=#00FF00>魔法攻击力*170%</color>技能伤害，使目标减速<color=#00FF00>60%</color>持续<color=#00FF00>3.6秒</color>，冷却时间<color=#00FF00>0.85秒</color>；<color=#00FF00>10%</color>概率本次技能伤害提高<color=#00FF00>60%</color>", effectId={1016008}, skillatk=40, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_9},
	{skillID=1016009, name="安魂弥撒", skillCd=950, commonCdOut=1000, speedCd=1, icon="anhunmisa(1)", damageType=1, damageformula=local_damageformula.damageformula_2, injuryType=3, needCareer=local_needCareer.needCareer_19, needAtt={{10003,416}}, skillLevelUpItemID={{60035087,1}}, fixedDamage=11, powerRate=10000, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_9, maxtarget=6, costHp=0, costMp=60, newConsumeAG=4, tips="对目标造成<color=#00FF00>魔法攻击力*170%</color>技能伤害，使目标减速<color=#00FF00>60%</color>持续<color=#00FF00>3.6秒</color>，冷却时间<color=#00FF00>0.85秒</color>；<color=#00FF00>10%</color>概率本次技能伤害提高<color=#00FF00>60%</color>", effectId={1016009}, skillatk=65, magicSpeedSkillCd=33, useItemAtt={{10003,416}}},
	{skillID=1016010, name="聚灵", skillCd=960, commonCdOut=1000, speedCd=1, icon="wuran(1)", injuryType=3, needCareer=local_needCareer.needCareer_19, needAtt={{10003,542}}, skillLevelUpItemID={{60035088,1}}, fixedDamage=11, powerRate=10000, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_9, maxtarget=6, costHp=0, costMp=70, newConsumeAG=8, tips="对目标造成<color=#00FF00>魔法攻击力*170%</color>技能伤害，使目标减速<color=#00FF00>60%</color>持续<color=#00FF00>3.6秒</color>，冷却时间<color=#00FF00>0.85秒</color>；<color=#00FF00>10%</color>概率本次技能伤害提高<color=#00FF00>60%</color>", effectId={1016010}, skillatk=80, magicSpeedSkillCd=33, useItemAtt={{10003,542}}},
	{skillID=1016011, name="烈光闪", skillCd=970, speedCd=1, icon="lieguangshan(1)", damageType=1, damageformula=local_damageformula.damageformula_2, injuryType=2, needCareer=local_needCareer.needCareer_19, needAtt={{10003,823}}, skillLevelUpItemID={{60035089,1}}, fixedDamage=11, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_7, maxtarget=6, costHp=0, costMp=115, newConsumeAG=7, tips="对目标造成<color=#00FF00>魔法攻击力*170%</color>技能伤害，使目标减速<color=#00FF00>60%</color>持续<color=#00FF00>3.6秒</color>，冷却时间<color=#00FF00>0.85秒</color>；<color=#00FF00>10%</color>概率本次技能伤害提高<color=#00FF00>60%</color>", effectId={1016011}, skillatk=95, magicSpeedSkillCd=33, useItemAtt={{10003,823}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1016012, name="恶灵召唤", skillCd=980, commonCdOut=1000, speedCd=1, icon="eling(1)", injuryType=3, needCareer=local_needCareer.needCareer_19, needAtt={{10003,930}}, skillLevelUpItemID={{60035090,1}}, fixedDamage=11, releaseRange=local_releaseRange.releaseRange_10, targetRange=local_targetRange.targetRange_8, maxtarget=6, costHp=0, costMp=120, newConsumeAG=20, tips="对目标造成<color=#00FF00>魔法攻击力*170%</color>技能伤害，使目标减速<color=#00FF00>60%</color>持续<color=#00FF00>3.6秒</color>，冷却时间<color=#00FF00>0.85秒</color>；<color=#00FF00>10%</color>概率本次技能伤害提高<color=#00FF00>60%</color>", effectId={1016012}, skillatk=75, magicSpeedSkillCd=33, useItemAtt={{10003,930}}},
	{skillID=1016013, name="黑暗镇魂曲", skillCd=990, commonCdOut=1000, speedCd=1, icon="8004140", injuryType=3, needCareer=local_needCareer.needCareer_19, needAtt=local_needAtt.needAtt_9, skillLevelUpItemID={{60035091,1}}, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_5, maxtarget=6, costHp=0, costMp=100, newConsumeAG=50, tips="切换成诅咒状态", effectId={1016013}, skillatk=0, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_9},
	{skillID=1016014, name="水幻兽", skillCd=1000, commonCdOut=1000, speedCd=1, icon="8005130", injuryType=2, needLevel=local_needLevel.needLevel_4, needCareer=local_needCareer.needCareer_19, needAtt={{10003,1120}}, skillLevelUpItemID={{60035092,1}}, fixedDamage=11, powerRate=10000, releaseRange=local_releaseRange.releaseRange_7, targetRange=local_targetRange.targetRange_9, maxtarget=6, costHp=0, costMp=95, newConsumeAG=10, tips="对目标造成<color=#00FF00>魔法攻击力*170%</color>技能伤害，使目标减速<color=#00FF00>60%</color>持续<color=#00FF00>3.6秒</color>，冷却时间<color=#00FF00>0.85秒</color>；<color=#00FF00>10%</color>概率本次技能伤害提高<color=#00FF00>60%</color>", effectId={1016014}, skillatk=100, magicSpeedSkillCd=33, useItemAtt={{10003,1120}}},
	{skillID=1016015, name="伤害反射", targetBuffID={{250001011,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=1010, commonCdOut=1000, speedCd=1, icon="shanghaifanshe(1)", injuryType=0, needCareer=local_needCareer.needCareer_19, needAtt={{10003,375}}, skillLevelUpItemID={{60035093,1}}, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=40, newConsumeAG=10, tips="身伤害反射提升12%，所受伤害同步反弹给攻击者。", effectId={6011}, skillatk=0, magicSpeedSkillCd=33, useItemAtt={{10003,375}}},
	{skillID=1016016, name="魔隐者", targetBuffID={{101601601,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=1020, commonCdOut=1000, icon="11830000", injuryType=2, needCareer=local_needCareer.needCareer_19, skillLevelUpItemID={{60035094,1}}, releaseRange=local_releaseRange.releaseRange_6, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=0, costMpRatio=425, tips="沉默自身，进入增幅状态", magicSpeedSkillCd=33},
	{skillID=1016017, name="恶灵召唤普通攻击1", skillCd=918, commonCdOut=1000, speedCd=1, damageType=1, damageformula=local_damageformula.damageformula_2, injuryType=3, needCareer=local_needCareer.needCareer_3, costMp=20, magicSpeedSkillCd=33},
	{skillID=1016018, name="恶灵召唤普通攻击2", skillCd=919, commonCdOut=1000, speedCd=1, damageType=1, damageformula=local_damageformula.damageformula_2, injuryType=3, needCareer=local_needCareer.needCareer_3, costMp=20, magicSpeedSkillCd=33},
	{skillID=1016019, name="恶灵召唤普通攻击3", skillCd=920, commonCdOut=1000, speedCd=1, damageType=1, damageformula=local_damageformula.damageformula_2, injuryType=3, needCareer=local_needCareer.needCareer_3, costMp=20, magicSpeedSkillCd=33},
	{skillID=1014009, name="冲击", skillCd=60000, commonCdOut=1000, speedCd=1, icon="chongji(1)", needCareer=local_needCareer.needCareer_3, needAtt={{10003,15}}, fixedDamage=5, releaseRange=local_releaseRange.releaseRange_5, costMp=10, tips="对目标造成<color=#00FF00>物理攻击力*80%</color>冷却时间0.72秒", effectId=local_effectId.effectId_25, skillatk=10, useItemAtt={{10003,15}}, skillattPower=local_skillattPower.skillattPower_3},
	{skillID=1005003, name="圣盾防御", targetBuffID={{240001003,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=920, commonCdOut=920, icon="shengdunfangyu(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_20, skillLevelUpItemID={{20220111,3},{20220121,3},{20220211,3},{20220221,3},{1153,3},{1154,3},{1158,3},{1156,3},{1159,3},{1161,3},{1160,3},{1162,3},{2149,3},{2150,3},{2152,3},{2154,3},{2155,3},{2156,3},{2157,3},{2158,3},{2022011199,3},{2022012199,3},{2022021199,3},{2022022199,3},{115399,3},{115499,3},{115699,3},{115899,3},{115999,3},{116099,3},{116199,3},{116299,3},{214999,3},{215099,3},{215299,3},{215499,3},{215599,3},{215699,3},{215799,3},{215899,3}}, releaseRange=local_releaseRange.releaseRange_2, targetRange=local_targetRange.targetRange_1, costMp=30, tips="释放此技能期间防御力增加10%", effectId={1016017}, skillatk=0, speedSkillCd=33},
	{skillID=1014015, name="摄魂咒", commonCdOut=1000, speedCd=1, icon="shehunzhou(1)", injuryType=2, needCareer=local_needCareer.needCareer_19, needAtt={{10003,150}}, skillLevelUpItemID={{1015348,1}}, fixedDamage=11, releaseRange=local_releaseRange.releaseRange_6, maxtarget=6, costMp=50, skillatk=35, magicSpeedSkillCd=33, useItemAtt={{10003,150}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1014019, name="虚弱阵", targetBuffID={{250001009,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=10000, commonCdOut=1000, speedCd=0, icon="xuruozhen(1)", injuryType=2, needCareer=local_needCareer.needCareer_19, needAtt={{10003,663}}, skillLevelUpItemID={{1015349,1}}, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=50, newConsumeAG=15, tips="发动虚弱阵魔法阵减少走到魔法阵上方敌人的攻击力。", effectId={6013}, skillatk=0, magicSpeedSkillCd=33, useItemAtt={{10003,663}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1014020, name="破御阵", targetBuffID={{250001010,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=10000, commonCdOut=1000, speedCd=0, icon="poyuzhen(1)", injuryType=2, needCareer=local_needCareer.needCareer_19, needAtt={{10003,912}}, skillLevelUpItemID={{1015350,1}}, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_2, maxtarget=6, costHp=0, costMp=50, newConsumeAG=15, tips="发动破御阵魔法阵减少走到魔法阵上方敌人的防御力。", effectId={6014}, skillatk=0, magicSpeedSkillCd=33, useItemAtt={{10003,912}}, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1020068, name="新手怪物一格普功", commonCdOut=3000, needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_1, throughWall=1},
	{skillID=1020070, name="新手黑巫师陨石术", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, targetRange=local_targetRange.targetRange_1, throughWall=1, effectId=local_effectId.effectId_14},
	{skillID=1020071, name="新手怪物二格普攻", skillCd=10000, commonCdOut=10000, needCareer=local_needCareer.needCareer_3, throughWall=1},
	{skillID=1020069, name="新手偷猎者射击", needCareer=local_needCareer.needCareer_3, releaseRange=local_releaseRange.releaseRange_5, throughWall=1, effectId=local_effectId.effectId_26},
	{skillID=1005005, name="星辰一怒", targetBuffID={{100500501,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=1040, commonCdOut=840, icon="xingchenyinu(1)", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer={{2,1},{2,2},{2,3},{7,1},{7,2},{7,3}}, needAtt=local_needAtt.needAtt_11, skillLevelUpItemID={{1116019,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_4, maxtarget=5, costHp=0, costMp=180, newConsumeAG=45, tips="集中自身周围的光能量瞬间产生爆炸，给周围多数的敌人造成伤害。集中光的时间越长伤害就越大。", effectId=local_effectId.effectId_27, skillatk=0, speedSkillCd=33, magicSpeedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_11, skillattPower=local_skillattPower.skillattPower_5},
	{skillID=1011000, name="剑士普通攻击", skillCd=1000, commonCdOut=1000, speedCd=1, icon="11007", needCareer=local_needCareer.needCareer_5, powerRate=5000, releaseRange=local_releaseRange.releaseRange_1, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=0, tips="剑士普通攻击", effectId=local_effectId.effectId_1, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_2},
	{skillID=1012000, name="魔法师普通攻击", skillCd=1000, commonCdOut=1000, speedCd=1, icon="11007", needCareer={{2,1},{7,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_1, targetRange=local_targetRange.targetRange_1, costHp=0, costMp=0, tips="魔法师普通攻击", effectId=local_effectId.effectId_1, skillatk=0, speedSkillCd=33, skillattPower=local_skillattPower.skillattPower_2},
	{skillID=1007001, name="幻龙", skillCd=820, commonCdOut=840, speedCd=1, icon="huanlong", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_21, skillLevelUpItemID={{61007001,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_5, maxtarget=6, costHp=0, costMp=30, tips="召唤幻龙，对目标及周围敌人造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId={1007001}, skillatk=30, magicSpeedSkillCd=33},
	{skillID=1007002, name="审判", skillCd=840, commonCdOut=840, speedCd=1, icon="shenpan", injuryType=2, needLevel={350}, needCareer=local_needCareer.needCareer_21, skillLevelUpItemID={{61007002,1}}, powerRate=15000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_7, maxtarget=8, costHp=0, costMp=105, newConsumeAG=17, tips="召唤审判之矛，对目标及周围敌人造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId={1007002}, skillatk=75, magicSpeedSkillCd=33},
	{skillID=1007003, name="雷鸟", skillCd=860, commonCdOut=840, speedCd=1, icon="leiniao", injuryType=2, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_21, skillLevelUpItemID={{61007003,1}}, powerRate=10000, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_6, maxtarget=8, costHp=0, costMp=5, tips="召唤雷鸟，对目标及周围敌人造成<color=#00FF00>魔法攻击力*100%</color>技能伤害", effectId={10070031}, skillatk=20, magicSpeedSkillCd=33},
	{skillID=1005006, name="无影箭", targetBuffID={{100500502,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=1020, commonCdOut=960, icon="13100100", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_15, needAtt=local_needAtt.needAtt_12, skillLevelUpItemID=local_skillLevelUpItemID.skillLevelUpItemID_7, releaseRange=local_releaseRange.releaseRange_3, targetRange=local_targetRange.targetRange_5, maxtarget=4, costHp=0, costMp=20, tips="恢复自身或队友<color=#00FF00>5+智力值/5</color>血量，恢复血量受施法者智力加成", effectId={1200019}, skillatk=0, speedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_12},
	{skillID=1007004, name="惩戒屏障", targetBuffID={{100700401,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, skillCd=10000, commonCdOut=1000, speedCd=1, icon="8003130", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_21, skillLevelUpItemID={{61007004,1}}, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_7, maxtarget=8, costMp=30, tips="10%概率触发伤害减免", effectId=local_effectId.effectId_28, skillatk=0, speedSkillCd=33, useItemAtt=local_useItemAtt.useItemAtt_13},
	{skillID=1005007, name="星云召唤", targetBuffID={{101401013,1}}, targetExecutNode=local_targetExecutNode.targetExecutNode_2, cdType=0, cdTime=20000, skillCd=1010, commonCdOut=1000, speedCd=1, icon="xingyunzhaohuan(1)", injuryType=0, needLevel=local_needLevel.needLevel_2, needCareer=local_needCareer.needCareer_2, skillLevelUpItemID={{1116038,1}}, releaseRange=local_releaseRange.releaseRange_4, targetRange=local_targetRange.targetRange_7, maxtarget=8, costMp=8, tips="把远距离的队员强制移动到自身的位置。", effectId=local_effectId.effectId_29, skillatk=0},
}

local defaults = {skillLevel=1, skillAtt={}, targetBuffID={}, targetExecutNode={}, cdType=1, cdTime=0, commonCd=0, skillCd=3000, commonCdOut=0, speedCd=0, noCd=0, icon="11100100", damageType=0, damageformula={}, injuryType=1, injurySubtype=0, autoLearn=0, needLevel={}, needCareer={{1,1},{2,1},{3,1}}, needAtt={}, needWeapon={}, skillLevelUpItemID={}, fixedDamage=0, monsterExtraDamage={}, playerExtraDamage={}, decayDamage=0, powerRate=0, changePoint={}, changePointSpeed=0, targetRotate=0, releaseRange={2}, targetRange={1}, maxtarget=1, costHp=0, costMp=0, costMpRatio=0, costAG=0, newConsumeAG=0, throughWall=0, tips="", piaozi=0, weaponMatch={}, effectId={}, attributeDamage={}, growthFactor=0, haloEffect=0, refund={}, skillatk=1, speedSkillCd=0, magicSpeedSkillCd=0, useItemAtt={}, skillattPower={}, CanUseSkillEffectPlayTime=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_skill_info) do
	setmetatable(v, mt)
end

return cfg_skill_info
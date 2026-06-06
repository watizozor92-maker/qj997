--region 表格类型
---@class EBuffSpecialId
EBuffSpecialId =
{
    MoFaDun = 31,--魔法盾
    GreenDu = 32,--绿毒
    RedDu = 33,--红毒
    LiuXingHuoYu = 34,--流星火雨
    LieHuoJianFa = 35,--烈火剑法
    MaBi = 37,--麻痹

    --Silence = 
}
---@class EBuffType
EBuffType =
{
    HpOrMp = 1,--调整血蓝类
    State = 2,--调整状态类
    Attr = 3,--调整属性类
}
---@class EBuffParamType_HpOrMp 对应EBuffType.HpOrMp
EBuffParamType_HpOrMp =
{
    Hp = 1,
    Mp = 2,
}
--客户端特殊技能备注
--客户端刘流星火雨效果（地面buff，3秒往下砸），
--烈火剑法，特殊处理普通附带技能特效
--开天斩（类似烈火，会从buff表中去掉，走特殊处理）
--失明效果（客户端只能看到部分场景，最好中间的颜色分界区做些渐变）
--蛛网（移动速度，客户端自己计算移动速度）
--沉默（不能放技能，表现效果：buff触发时提示，buff表中配置）
--击退（类似野蛮冲撞）
--恐惧（乱走，需要服务器协议支持）。
--失神：不允许使用任何物品
--隐身：自己或者友方半透，其他整个模型看不到。
--野蛮冲撞：残影，每个残影根据时间半透，时间越久的半透越厉害
---@class EBuffParamType_State 对应EBuffType.State
EBuffParamType_State =
{
    Paralysis = 1,--麻痹 颜色值 #4C961D
    ParalysisPrevent = 2,--防麻痹
    Protective=3,--护身,魔法盾
    ProtectivePrevent=4,--防护身
    Relive=5,--复活
    RelivePrevent=6,--防复活
    Blindness = 7,--失明
    BlindnessPrevention = 8,--防失明
    Imprison = 9,--禁锢
    ImprisonPrevent = 10,--防禁锢
    Vertigo = 11,--眩晕
    VertigoPrevent = 12,--防眩晕
    Silence = 13,--沉默
    SilencePrevent = 14,--防沉默
    ToFendOff = 15,--击退
    ToFendOffPrevent = 16,--防击退
    ShunYi = 17,--瞬移
    ShunYiPrevent = 18,--防瞬移
    Absence = 19,--失神
    AbsencePrevent = 20,--防失神
    Stealth = 21,--隐身
    StealthPrevent= 22,--防隐身
    WuDi = 23,--无敌
    WuDiPrevent = 24,--防无敌
    ZhiKong = 25,--滞空 处于透明状态，无法受到伤害；自己看显示特效，称号，名称，血条，主副手部位，翅膀部位，不显示人物，其他部位，守护等，队友，敌人看都不显示
    ZhiKongPrevent = 26,--防滞空
    MoChu = 33,--抹除
    OutOfControl = 34,--失控
    Charm = 35,--魅惑
    Frozen = 36,
    --策划案里面已经没有这个了，保留一下逻辑，枚举值先填一个很大的
    Fear = 1000,--恐惧
    FearPrevent = 1001,--防恐惧
    
    --ASpiderWeb = 9,--蛛网 --走属性类Buff了，服务器直接提供攻速或者移动加成
    --ASpiderWebPrevent = 10,--防蛛网
    --Frozen = 13,--冰冻，--走眩晕了
    --FrozenPrevent = 14,--防冰冻
    --SeriouslyInjured = 21,--重伤
    --SeriouslyInjuredPrevent=22,--防重伤
    --Invincible=23,--无敌
    --InvinciblePrevent = 24,--防无敌
    
    
    FireType = 29,--烈火类
    Mock = 39,--嘲讽
}
--1:单次持续
--2:循环执行
--3:单次执行
--4.光环模式
--编辑器读取
--{单次持续=1|循环执行=2|单次执行=3|光环模式4}
---@class EBuffRunMode
EBuffRunMode =
{
    None = 0,
    SingleSustain = 1,
    Sustain = 2,
    SingleProcess = 3,
    Halo = 4,
}
---@class EEfficacyObjectType @EBuffRunMode == Halo时有效
EEfficacyObjectType=
{
    None = 0,
    Enemy = 1,
    Friend=2,
    Self=3,
    Ground=4,
}
--endregion
--region 非表格类型
---@class EBuffBehaviourType
EBuffBehaviourType = {
    None =enum(0),
    CannotMove =  enum(),
    CannotAttack =  enum(),
    CannotUseBagItem =  enum(),
    Stealth = enum(),--隐身
    Fear = enum(),--恐惧
    ZhiKong = enum(),--滞空
    CanNotOper = enum(),--失控或者魅惑buff下，不能操作战斗，摇杆，点击地面或者其他寻路
    Mock =  enum(),--嘲讽
}

---@class EPlayEffectOverType
EPlayEffectOverType = 
{
    None = enum(0),
    Loop = enum(1),
    Stop = enum(2),
}

---@class BuffChangeData
---@field roleId number
---@field updateType number @0:Add 1:Remove 2:Update
---@field buff Buff


---@class EBuffDisposeModeType
EBuffDisposeModeType = 
{
    Add = 0,
    Replace = 1,
}

---@class EBuffEffectType
EBuffEffectType =
{
    selfBeginEffect = enum(1),
    selfEffect = enum(),
    selfSustainEffect = enum(),
    selfAttackEffect = enum(),
    selfuseEffect = enum(),
    selfBeAttackEffect = enum(),
    selfEndEffect = enum(),
    targetSustainEffect = enum(),
}
--endregion
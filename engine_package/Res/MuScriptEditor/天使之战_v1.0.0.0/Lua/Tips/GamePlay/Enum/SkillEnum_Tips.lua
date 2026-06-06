--region cfg
---@class ESkillHandlerType @技能处理器类型
ESkillHandlerType =
{
    None = 0,
    Hurt = 1,--伤害
    Buff = 2,
    ChongZhuang = 3,--冲撞
    ZhaoHuan = 4,--召唤
    ShunYi = 5,--闪现，瞬移
    KongZhi = 6,--控制
    KaiGuanLei = 7,--开关类
    CiShaLei = 8,--刺杀类
    GroundBuff = 9,--地面Buff
    ZhiLiao = 10,--治疗类
    KaiTian = 11,--开天类
}

---@class ESkillTargetType @施法目标类型
ESkillTargetType =
{
    None = 0,
    Enemy = 1,--敌人
    FriendWithoutSelf = 2,
    FriendWithSelf = 3,
    Self = 4,
}
---@class ESkillReleaseType @释放类型
ESkillReleaseType =
{
    NeedNoTarget = 0,
    NeedTarget = 1,--目标 发送目标ID+目标的Coord
    Self = 2,
}
---@class ESkillAreaDirType @技能溅射
ESkillAreaDirType =
{
    None = 0,
    ToSelfForward = 1,--@释放技能后，自己面向的敌人会受到溅射伤害
    ToTargetForward = 2,--@释放技能后，敌人面向的敌人会受到溅射伤害
}

---@class ESkillAttackAreaType @攻击形状和受击形状枚举值统一
ESkillAttackAreaType =
{
    None = 0,
    Point = 1,--点（攻击时判定）
    ShiZi = 2,--十字
    Line = 3,--直线（攻击时判定）
    HengXinag = 4,--横线
    ShanXing = 5,--扇形（攻击时判定）
    LingXing = 6,--菱形
    Cirle = 7,--圆（攻击时判定）
}

---@class ESkillSpecialId
ESkillSpecialId =
{
    LieHuoJianFa = 1008,
    CiSha = 1005,
    KaiTianZhan = 1002,
    TianDiShiZiJian = 10008,
    ShunYi = 10031,
    Mount = 777777,
}

---@class EModelEffectTypeToResFolder
EModelEffectTypeToResFolder =
{
    ["skill"] = "Skill",
    ["effect"] = "Effect",
}

-----@class ESpecailModelEffectId @临时处理，后面在cfg_model_effect里面添加类型
--ESpecailModelEffectId =
--{
--    ZhiMingYiJi = 1,--致命一击 根据距离显示特效段数
--    LeiTingLieShan_Wp = 32,--雷霆裂闪 将武器挂在特效weapon节点上
--    PiLiHuiXuanZhan_Wp = 33,--霹雳回旋斩 将武器挂在特效weapon节点上
--    ShengLongJi = 12,--升龙击 将特效挂在人物骨骼点上
--    ZhengKongBo = 18,--真空波，朝一个方向移动多少时间
--    LongJuanFeng = 17,--龙卷风
--    ZhangXingLei = 19,--掌心雷
--    HeiLongBo = 21,--黑龙波
--}

--endregion
---@class ESpecialSkillEffectType
ESpecialSkillEffectType=
{
    None = 0,
    MoveToTarget = -1,
    StepShow = 1,--类似致命一击，分段显示
    BindWeapon = 2,--类似雷霆裂闪，霹雳回旋斩 将武器挂在特效weapon节点上
    BindBone = 3,--类似升龙击 将特效挂在人物骨骼点上
    MoveDir = 4,--类似真空波，龙卷风，朝一个方向移动多少时间
    PointToPoint = 5,--类似掌心雷,连接两个骨骼点
    MoveInPath = 6,--类似黑龙波
    AngleLeftRight = 7,--类似多重箭，第一个特效指向目标，第二个特效目标方向向左旋转一个角度，第三特效目标方向向右旋转一个角度，依次类推
    ModityParticle = 8,--类似袭风刺目标特效，需要根据目标的SkinMeshRender设置粒子参数
    MoveInCustomPath = 9,---自定义播放路径
    ModityParticle_Start = 10,--类似袭风刺施法特效，需要根据目标的SkinMeshRender设置粒子参数
    Custom = 11,--自定义技能特效表现
}
---@class ESpecialSkillEffectType_BindBoneParamType
ESpecialSkillEffectType_BindBoneParamType =
{
    RightHand = 0,
    Body = 1,
}
---@class ESpecialSkillEffectType_BindWeaponParamType
ESpecialSkillEffectType_BindWeaponParamType =
{
    LeiTingLieShan = 1,
    PiLiHuiXuanZhan = 2,
}
---@class ESpecialSkillEffectType_PointToPointParamType
ESpecialSkillEffectType_PointToPointParamType =
{
    ZhangXingLei = 1,
    LineRendererBezier = 2,
    ShengLingCurve = 3,
}
---@class EModelEffectPosPivotType
EModelEffectPosPivotType=
{
    Bottom = 0,
    Body = 1,
    Parallel = 2,--平行
    Head = 3,
}

--region skill

---@class ESkillEffectType
ESkillEffectType =
{
    None = 0,
    Start = 1,
    Move = 2,
    End = 3,
}

---@class ESkillEffectPlayType
ESkillEffectPlayType =
{
    None = enum(0),
    Starting = enum(),
    StartOver = enum(),
    Moveing = enum(),
    MoveOver = enum(),
    Ending = enum(),
    EndOver = enum(),
    Stop = enum(),
}

---@class ESkillReleaseError
ESkillReleaseError =
{
    None = 0,
    TargetMiss = 1,--目标丢失
    CDing = 2,
    HPNotEnough = 3,
    MpNotEnough = 4,
    SkillNotExist = 5,
    SkillIsPlaying = 6,
    SkillRangeNotEnough = 7,
    OnlyAttackRole = 8,
    IsCanAttackByPkMode = 9,
    IsCanAttackByPkModeMapUnPk = 10,
    IsSafePoint = 11,
    TargetDead = 12,
    TargetCannotBeAttack = 13,
    CannotOverlap = 14,
    SkillPointNotEnough = 15,
    SkillHurtRangeNotEnough = 16,
    SkillCareerNotCorrect = 17,
    SkillLevelNotEnough = 18,
    SkillAttrNotCorrect = 19,
    NeedWeapon1 = 20,
    NeedWeapon2 = 21,
    NeedWeapon3 = 22,
    NeedWeapon4 = 23,--取反提示
    NeedWeapon5 = 24,--需要装备什么道具
    Custom = 25,--自定义
    IsQuickMoving = 26,--正在快速移动（野蛮冲撞或者闪现）
}

---@class ESkillReleaseErrorNotice
ESkillReleaseErrorNotice = 
{
    [ESkillReleaseError.TargetMiss] ='目标丢失',
    [ESkillReleaseError.CDing] ='CD不足',
    [ESkillReleaseError.HPNotEnough] ='血量不足',
    [ESkillReleaseError.MpNotEnough] ='魔法不足',
    [ESkillReleaseError.SkillNotExist] ='技能不存在',
    [ESkillReleaseError.SkillIsPlaying] ='技能正在播放',
    [ESkillReleaseError.SkillRangeNotEnough] ='技能施法距离不足',
    [ESkillReleaseError.OnlyAttackRole] ='没有选中目标',
    [ESkillReleaseError.IsCanAttackByPkMode] ='当前模式无法攻击目标',
    [ESkillReleaseError.IsCanAttackByPkModeMapUnPk] ='当前地图无法pk',
    [ESkillReleaseError.IsSafePoint] ='安全区无法攻击',
    [ESkillReleaseError.TargetDead] ='目标已经死亡',
    [ESkillReleaseError.TargetCannotBeAttack] = '目标无法被攻击',
    [ESkillReleaseError.CannotOverlap] = '目标不能重叠',
    [ESkillReleaseError.SkillPointNotEnough] = '技能值不足',
    [ESkillReleaseError.SkillCareerNotCorrect] = '职业不符，无法使用技能',
    [ESkillReleaseError.SkillLevelNotEnough] = '未达到技能使用等级',
    [ESkillReleaseError.SkillAttrNotCorrect] = '属性不足，无法使用技能',
    [ESkillReleaseError.NeedWeapon1] = '此技能需要穿戴%s武器才能释放',---提示需要通过代码修改
    [ESkillReleaseError.NeedWeapon2] = '此技能需要穿戴%s或%s武器才能释放',---提示需要通过代码修改
    [ESkillReleaseError.NeedWeapon3] = '此技能需要穿戴%s或%s武器等才能释放',---提示需要通过代码修改
    [ESkillReleaseError.NeedWeapon4] = '此技能不能穿戴%s武器释放',---提示需要通过代码修改
    [ESkillReleaseError.NeedWeapon5] = '此技能需要穿戴%s武器才能释放',---提示需要通过代码修改
    [ESkillReleaseError.Custom] = '自定义覆盖技能无法释放提示',---
    [ESkillReleaseError.IsQuickMoving] = "快速移动中",
}

---@class ESkillPlayState
ESkillPlayState =
{
    Init = enum(0),
    PreparePlay = enum(),
    Playing = enum(),
    PlayEnd = enum(),
    Stop = enum(),
}

---@class EMoreEffectType
EMoreEffectType =
{
    MainTarget = enum(0),--主目标特效
    MainAndOtherTarget = enum(1),--主目标和副目标
    OtherTarget = enum(2),--副目标
}

ETFloorEffectActionType =
{
    None = 0,
    Play_NotHitRole = 1,
    Play_HitRole = 2,
    PlayAll = 3,
}
---@class EEffectModeType
EEffectModeType =
{
    None = 0,
    Role = 1,
    Floor = 2,
}

---@class ETargetRotateType
ETargetRotateType = 
{
    None = 0,
    Clockwise = 1,--顺时针
    Counterclockwise = 2,--逆时针
}

--endregion

ECfgSkillType = 
{
    Normal = 0,--主动技能
    Passive = 1,--被动技能（瞬发）
    Passive2 = 2,--被动技能（持续监听）
}

ECaromModeType = 
{
    Click = 1,--点击连击
    Order = 2,--顺序连击
}
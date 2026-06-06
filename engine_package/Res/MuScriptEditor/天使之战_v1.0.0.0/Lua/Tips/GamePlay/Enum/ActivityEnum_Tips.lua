--活动使用的枚举

EMUActivityType = {
    Daily = enum(1),
    Activity = enum(2),
}

EMUActivityInitType = {
    Activity = enum(1),
    CrossServer = enum(2),

}

EMUActivityHideType = {
    NoHide = enum(0), -- 不隐藏
    NoStartHide = enum(1), -- 没有开启时隐藏
    NoLevelHide = enum(2) -- 等级没到时隐藏
}

---@class EActivityType @活动类型
---@field DevilSquare  number @ 1, --1恶魔广场
---@field MonsterAttack number @ 2, --2怪物袭击
---@field Siege number @ 3, --3攻城战
---@field WolfSoul number @ 4, --狼魂要塞
---@field RedFort number @ 5 , --5赤色要塞
---@field TowerAngels number @ 6 ,--6天使之塔
---@field CommonBoss number @ 8 ,--通用boss
---@field GateWorld number @9 --异界之门
---@field BraveTest number @ 10, --勇者试炼
---@field UnionAttackCity number @12, --战盟攻城战
---@field RoadOfChoice number @ 13,--抉择之路
---@field WorldBoss number @14, --世界boss
---@field UnionBoss number @11 战盟boss
---@field Kalima number @16 卡利玛
---@field DemonRefiningLand number @18 魔炼之地
EActivityType = {
    DevilSquare = 1, --1恶魔广场/血色城堡
    MonsterAttack = 2, --2怪物袭击
    Siege = 3, --3攻城战
    WolfSoul = 4, --狼魂要塞
    RedFort = 5, --5赤色要塞
    TowerAngels = 6, --6天使之塔
    CommonBoss = 8, --普通boss
    GateWorld = 9, --异界之门
    BraveTest = 10, --勇者试炼
    UnionAttackCity = 12, --战盟攻城战
    RoadOfChoice = 13, --抉择之路
    WorldBoss = 14, --世界boss 
    UnionBoss = 11, --战盟boss
    Kalima = 16, --卡利玛
    DeerShadow = 17, --鹿影迷踪
    DemonRefiningLand = 18, --魔炼之地
}

EActivityTypeStr=
{
    [EActivityType.DevilSquare]="血色城堡",
    [EActivityType.MonsterAttack]="怪物袭击",
    [EActivityType.Siege]="3攻城战",
    [EActivityType.WolfSoul]="狼魂要塞",
    [EActivityType.RedFort]="赤色要塞",
    [EActivityType.TowerAngels]="天使之塔",
    [EActivityType.CommonBoss]="普通boss",
    [EActivityType.GateWorld]="异界之门",
    [EActivityType.BraveTest]="勇者试炼",
    [EActivityType.UnionAttackCity]="战盟攻城战",
    [EActivityType.RoadOfChoice]="抉择之路",
    [EActivityType.UnionBoss]="战盟boss",
    [EActivityType.WorldBoss]="世界boss",
}

---@class EDupState @副本状态 1:准备阶段 2:战斗阶段 3:结束阶段 4:活动开始倒计时阶段
---@field Prepare number @ enum(1), --准备阶段
---@field Fighting number @ enum(), --战斗阶段
---@field Finished number @ enum(), --结束阶段
EDupState = {
    Prepare =  1, --准备阶段
    Fighting = 2, --战斗阶段
    Finished = 3, --结束阶段
    StartTimeDown = 4 --活动开始倒计时
}

EDailyActivityType = {
    GoldChallenge = enum(1), --黄金挑战
    Recovery = enum(2), --找回活动
}

ERoadOfChoiceType = {
    leftHurdles = enum(1), --左侧副本
    midHurdles = enum(),
    rightHurdles = enum(),
    ChallengeCount = enum(3), --界面可显示的副本数量
    ShoWRankingCount = enum(3), --主界面中显示排行榜个数
    TopPlayer = enum(1),
    SubPlayer = enum(2),
    RangePlayer = enum(3),
}


---@ 攻城战阵营 0:中立; 1:攻城方; 2:守城方
---@class EAtkCityCamp
EAtkCityCamp = {
    Mid = 0,
    Atk = 1,
    Def = 2,
}

---@class EUnionFightCarState @1:表示战车状态 0:表示正常状态
EUnionFightCarState = {
    Normal = 0, --正常状态
    FightCar = 1, --表示战车状态
}

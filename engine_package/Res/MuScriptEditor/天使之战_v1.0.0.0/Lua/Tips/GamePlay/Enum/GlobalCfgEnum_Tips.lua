---@class EGlobalType
EGlobalType = {
    Is2D = 71200122,
    SceneType = 71200123,
    PublicCD = 14,
    --CommonSkillId = 40,
    Behaviour_StandToShowTime = 52,
    OpenStallInfo = 53,
    StallIsCanMove = 55,
    DefultNpcShopLimitCount = 56,
    DefultNpcShopId = 60,
    OpenNpcShopLevelLimit = 61,
    BattleStateSceneAudioValume = 62,
    AudioExistMaxCount = 63,
    BeAttackMode = 70,
    EquipShowInScene = 71,
    SkillDistCalcType = 73,
    GroundQuickMoveUnLock = 1311,
    WaterQuickMoveUnLock = 1312,
    SkyQuickMoveUnLock = 1313,
    CameraAndTerrain = 712001,
    QuickMoveByCareer = 1310
}
---@class EGlobal_EquipShowInSceneType
EGlobal_EquipShowInSceneType = {
    NotShow = 0,
    ShowMainWeapon = 1,
    ShowSecWeapon = 2,
    ShowAll = 3,
}

EGlobal_SkillDistCalcType = {
    Cell = 1,
    Dist = 2,
}
---@class EHurtType @对应cfg_damage_number的id
EHurtType = {
    Normal = 101, --普通
    AddHp = 118, --加血
    Miss = 201, --闪避
    BigBang = 123, --大爆
    ShuangBei = 107,--双倍伤害
}

---@class EHurtSourceType @伤害来源类型，分为普通伤害，技能伤害，buff
EHurtSourceType = {
    Normal = 1,
    Skill = 2,
    Buff = 3
}


EGlobalSceneType =
{
    QJ_NormalQuality = 0, -- 奇迹普通品质
    XianXia= 1, -- 仙侠
    QJ_HighQuality = 2, -- 奇迹高清
    XianXia2= 3, -- 仙侠2
    WuLinWaiZhuan = 4, -- 武林外传
    BattleFlag_Hexagon = 5, -- // 6边形战旗
}
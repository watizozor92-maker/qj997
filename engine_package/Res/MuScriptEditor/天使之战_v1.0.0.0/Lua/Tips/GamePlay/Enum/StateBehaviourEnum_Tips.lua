--1待机
--2移动
--3追踪
--4攻击
--5死亡
--5被击
--状态为1：1站立，2坐下，3倚靠，4展示
--状态为2：1移动等待，2移动，3快速移动，4向上跳，5向前跳，6向远跳，7转身
--状态为3：1追踪移动，2追踪转身
--状态为4：1普攻，2技能
--状态为5：1倒地

---@class EBehaviourType_Stand
EBehaviourType_Stand = 
{
    Stand = 1,
    Sit = 2,
    RelyOn = 3,--倚靠
    Show = 4,--展示
}
---@class EBehaviourType_Move
EBehaviourType_Move =
{
    Walk = 1,
    Run = 2,
    WalkTurnAround = 3,
    RunTurnAround = 4,
}
---@class EBehaviourType_Jump
EBehaviourType_Jump = 
{
    InSituJump = 1,--原地跳
    WalkJump = 2,
    RunJump = 3,
}
---@class EBehaviourType_Track
EBehaviourType_Track =
{
    Walk = 1,
    Run = 2,
    WalkTurnAround = 3,
    RunTurnAround = 4,
}
---@class EBehaviourType_Attack
EBehaviourType_Attack =
{
    Common = 1,
    Skill = 2,
}
---@class EBehaviourType_BeAttack
EBehaviourType_BeAttack =
{
    BeAttack= 1,
}

---@class EBehaviourType_Dead
EBehaviourType_Dead =
{
    Dead = 1,
}

---@class EBehaviourType
--EBehaviourType = 
--{
--    [EFSMState.Stand] = EBehaviourType_Stand,
--    [EFSMState.Move] = EBehaviourType_Move,
--    [EFSMState.Track] = EBehaviourType_Track,
--    [EFSMState.Attack] = EBehaviourType_Attack,
--    [EFSMState.BeAttack] = EBehaviourType_BeAttack,
--    [EFSMState.Dead] = EBehaviourType_Dead,
--}

---@class EBehaviour_MapAreaType
EBehaviour_MapAreaType = 
{
    None = 0,
    Ground = 1,
    Water = 2,
    Sky = 3,
}

---@class EBehaviour_AnimMode
EBehaviour_AnimMode=
{
    None = 0,
    WeightRandow = 1,--权重随机播放某个动作
    TimeNext = 2,--多少时间内播放同一个行为时，播放一下一个动画
}

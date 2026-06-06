GlobalTimer = {}

local this = {}

TimerIds = {
    UNION_RUN_FOR_LEADER = 100001,
    UNION_IMPEACH = 100002,
    AUTO_RECOVERY_MAGIC = 100004,
    KUN_DUN_AUCTION = 100005,
    OPEN_BREAK_POINT_DEBUG = 100006,
}

-- 全局定时器
---@param timer_id number 定时器id
---@param interva_sed number 间隔执行时间
function GlobalTimer.setontimerex(timer_id, interva_sed)
    this.jprint("timer_id " .. tostring(timer_id))
    setontimerex(timer_id, interva_sed)
end

function GlobalTimer.setofftimer(timer_id)
    setofftimerex(timer_id)
end

----------------------------------------------------------

function ontimerex100001()
    this.jprint("开始执行战盟竞选")
    GlobalTimer.setofftimer(TimerIds.UNION_RUN_FOR_LEADER)
    UnionChangeLeader.RunForLeader.finishRunforLeaderActor()
end

function ontimerex100002()
    this.jprint("开始执行战盟弹劾")
    GlobalTimer.setofftimer(TimerIds.UNION_IMPEACH)
    UnionChangeLeader.Impeach.finishImpeachData()
end

function ontimerex100004()
    this.jprint("开始执行自动恢复蓝量")
    RoleAttr.autoRecoveryMagic()
end

function ontimerex100005()
    KunDunAuction.ontimer()
end

---------------------------- 日志打印 -----------------------------
this.log_open = false
function this.jprint(param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(param)
end

function this.loginfo(actor, param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 日志输出内容为空. nil"
    end
    jprint(param)
    info(actor, param)
end
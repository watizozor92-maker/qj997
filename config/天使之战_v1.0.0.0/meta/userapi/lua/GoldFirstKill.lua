GoldFirstKill = {}
local this = {}
GoldFirstKill.Var = {
    GOLD_FIRST_KILL_TASK = "T$goldfirstkilltask", --个人首杀任务
    GOLD_FIRST_KILL_ENVELOPE = "T$firstkillenvelope", --全服首杀红包
    SERVER_FIRST_KILL_GOLD_BOSS = "R$serverfirstkillgoldboss" --全服首杀
}

---任务状态
GoldFirstKill.TASK_STATUS = {
    ---已接取
    ACCEPT = 1,
    ---已完成
    FINISH = 2,
    ---已提交
    SUBMIT = 3,
}
--请求领取首杀红包
function GoldFirstKill.receiveFirstKillAward(actor,msgData)
    if not GoldFirstKill.tableOpen(actor) then
        tipinfo(actor, "活动未开启")
        return
    end
    local monsterId = msgData.monsterId
    local envelope = getplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_ENVELOPE) or {}
    local isReceive = envelope[tostring(monsterId)]
    if isReceive then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "请勿重复领取！")
        return
    end
    if not isReceive then
        envelope[tostring(monsterId)] = true
        setplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_ENVELOPE,envelope)
        --发奖励
        local config = ConfigDataManager.getTable("cfg_goldFirstKill","id",monsterId)
        if not config then
            return
        end
        local weight = string.split(config[1].redenvelopeweight,"#")
        local map = {}
        for k, v in pairs(weight) do
            map[k] = tonumber(v)
        end
        local index = math.weightedRandom(map)
        local redEnvelope = string.split(config[1].redenvelope,"|")[tonumber(index)]
        local reward = splitbyshuxianandjinghao2(redEnvelope)
        for itemCfgId, count in pairs(reward) do
            additemtobag(actor, itemCfgId, count, 0, 9999, ItemActionProxy.GOLDFIRSTKILL)
        end
        --奖励弹框
        sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, reward)
        --通知客户端
        sendluamsg(actor, LuaMessageIdToClient.RES_RECEIVE_FIRST_KILL_ENVELOPE, table.valueConvertToString(envelope))
    end
end

--根据权重进行随机
function math.weightedRandom(weights)
    local total = 0
    for _, weight in pairs(weights) do
        total = total + weight
    end
 
    local rand = math.random() * total
    local cumulative = 0
    for item, weight in pairs(weights) do
        cumulative = cumulative + weight
        if cumulative >= rand then
            return item
        end
    end
end

--请求获取全服首杀数据和红包数据
function GoldFirstKill.getFirstKillInfo(actor)
    if not GoldFirstKill.tableOpen(actor) then
        return
    end
    local allServerData = getsysvar(GoldFirstKill.Var.SERVER_FIRST_KILL_GOLD_BOSS) or {}
    local envelope = getplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_ENVELOPE) or {}
    local taskInfo = getplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK) or {}
    local taskStatus = {}
    for mId,v in pairs(taskInfo) do
        taskStatus[mId] = v.status
    end
    local result = {}
    result.allServerData = allServerData
    result.envelope = envelope
    result.taskInfo = taskStatus
    sendluamsg(actor, LuaMessageIdToClient.RES_ALL_SERVER_FIRST_KILL_INFO, table.valueConvertToString(result))
end


--活动是否开启
function GoldFirstKill.isActivityOpen(actor)
    local config = ConfigDataManager.getTable("sub_mainActivity","id",1)
    if config == nil then
        return false
    end
    return ConditionManager.Check(actor, config[1].actualcondition)
end
--页签是否开启
function GoldFirstKill.tableOpen(actor)
    local config = ConfigDataManager.getTable("sub_mainActivity","id",1)
    if config == nil then
        return false
    end
    return ConditionManager.Check(actor, config[1].showcondition)
end

--登录时尝试接取任务
function GoldFirstKill.login(actor)
    GoldFirstKill.AcceptTask(actor)
end
---接取任务
function GoldFirstKill.AcceptTask(actor)
    --活动是否开启
    if not GoldFirstKill.isActivityOpen(actor) then
        return
    end
    local taskInfo = getplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK)
    if taskInfo ~= nil then
        --通知客户端
        local result = {}
        for mId,v in pairs(taskInfo) do
            result[mId] = v.status
        end
        sendluamsg(actor, LuaMessageIdToClient.RES_GOAL_FIRST_KILL_CHANGE, table.valueConvertToString(result))
        return
    end
    taskInfo = {}
    local config = ConfigDataManager.getTable("cfg_goldFirstKill")
    if not config then
        return
    end
    --接取任务
    for i = 1, #config,1 do
        local cfg = config[i]
        local monsterId = cfg.id
        local taskId = cfg.taskid
        --local targetId = ConfigDataManager.getTableValue("cfg_task","taskTargetId","id",taskId)
        local targetCfg = ConfigDataManager.getTable("cfg_task_target","id",taskId)
        local task = {}
        task.taskGoalId = targetCfg[1].taskgoalparam
        task.goalCount = targetCfg[1].goalcount
        task.nowCount = 0
        task.status = GoldFirstKill.TASK_STATUS.ACCEPT
        taskInfo[monsterId] = task
    end
    setplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK, taskInfo)
    local result = {}
    for mId,v in pairs(taskInfo) do
        result[mId] = v.status
    end
    result = table.valueConvertToString(result)
    --通知客户端
    sendluamsg(actor, LuaMessageIdToClient.RES_GOAL_FIRST_KILL_CHANGE, result)
end

function GoldFirstKill.UpdateTaskProgress(actor, monsterId)
    local success, errorInfo = xpcall(this.UpdateTaskProgress, debug.traceback, actor, monsterId)
    gameDebug.assertPrint(success, "怪物死亡黄金任务更新进度异常：", actor, monsterId, errorInfo)
end

---更新任务进度
function this.UpdateTaskProgress(actor, monsterId)
    if actor == nil then
        return
    end
    --活动是否开启
    if not GoldFirstKill.isActivityOpen(actor) then
        return
    end
    local taskInfo = getplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK)
    if not taskInfo then
        return
    end
    local task = taskInfo[tostring(monsterId)]
    if not task then
        return
    end
    if task.status ~= GoldFirstKill.TASK_STATUS.ACCEPT then
        return
    end
    if tonumber(task.taskGoalId) ~= tonumber(monsterId)  then
        return
    end
    task.nowCount = task.nowCount + 1
    if task.nowCount >= tonumber(task.goalCount) then
        task.status = GoldFirstKill.TASK_STATUS.FINISH
    end
    taskInfo[tostring(monsterId)] = task
    setplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK, taskInfo)
    --更新全服黄金首杀数据
    callonserial(actor, "update_gold_first_kill_data", monsterId)
    --通知客户端
    local result = {}
    for mId,v in pairs(taskInfo) do
        result[mId] = v.status
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_GOAL_FIRST_KILL_CHANGE, table.valueConvertToString(result))
end

function update_gold_first_kill_data(actor,monsterId)
    --更新全服黄金首杀数据
    local allServerData = getsysvar(GoldFirstKill.Var.SERVER_FIRST_KILL_GOLD_BOSS)
    if allServerData == nil or allServerData == "" then
        allServerData = {}
    end
    local killInfo = allServerData[tostring(monsterId)]
    if not killInfo then
        killInfo = {}
        killInfo.killer = getbaseinfo(actor,"rid")
        killInfo.killerName = getbaseinfo(actor,"rolename")
        killInfo.killTime = getbaseinfo("now")
        allServerData[tostring(monsterId)] = killInfo
        setsysvar(GoldFirstKill.Var.SERVER_FIRST_KILL_GOLD_BOSS,allServerData)
        local config = ConfigDataManager.getTable("cfg_goldFirstKill","id",monsterId)
        if config ~= nil then
            local itemMap = string.toIntIntMap(config[1].serreward)
            local monsterCfg = ConfigDataManager.getTable("cfg_monster","id",monsterId)
            local name = monsterCfg[1].name
            sendconfigmailbyrid(actor, getbaseinfo(actor,"rid"), MailConfig.SERVER_FIRST_KILL_GOLD_BOSS, itemMap, name)
            noticeTip.noticeinfo(actor, StringIdConst.ALL_SERVER_FIRST_KILL, getbaseinfo(actor,"rolename"), name)
        end
    end
end

---提交任务
function GoldFirstKill.SubmitTask(actor, msgData)
    if not GoldFirstKill.tableOpen(actor) then
        tipinfo(actor, "活动未开启")
        return
    end
    local monsterId = msgData.monsterId
    local taskInfo = getplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK)
    if not taskInfo then
        tipinfo(actor, "任务未接取")
        return
    end
    local task = taskInfo[tostring(monsterId)]
    if not task then
        tipinfo(actor, "任务不存在")
        return
    end
    if tonumber(task.status) ~= GoldFirstKill.TASK_STATUS.FINISH then
        tipinfo(actor, "任务未完成")
        return
    end
    --修改任务状态
    task.status = GoldFirstKill.TASK_STATUS.SUBMIT
    taskInfo[tostring(monsterId)] = task
    setplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK, taskInfo)
    --发奖励
    local reward = GoldFirstKill.GetTaskReward(monsterId)
    for itemCfgId, count in pairs(reward) do
        additemtobag(actor, itemCfgId, count, 0, 9999, ItemActionProxy.GOLDFIRSTKILL)
    end
    --奖励弹框
    sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, reward)
    --通知客户端
    local ti = getplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK)
    local result = {}
    for mId,v in pairs(ti) do
        result[mId] = v.status
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_RECEIVE_PERSONAL_FIRST_KILL_AWARD, table.valueConvertToString(result))
end
--获取任务奖励
function GoldFirstKill.GetTaskReward(monsterId)
    local reward = {}
    local config = ConfigDataManager.getTable("cfg_goldFirstKill","id",monsterId)
    if not config then
        return reward
    end
    return string.toIntIntMap(config[1].perreward)
end

--全服奖励
function GoldFirstKill.endTimeReward()
    local allData = getsysvar(GoldFirstKill.Var.SERVER_FIRST_KILL_GOLD_BOSS)
    if allData == nil or allData == "" then
        return
    end
    local allRoleInfos = getallrolesummaryinfos()
    if allRoleInfos == nil or next(allRoleInfos) == nil then
        return
    end
    for _, roleInfo in pairs(allRoleInfos) do
        local reward = {}
        local actor = roleInfo["actor"]
        if GoldFirstKill.tableOpen(actor) then
            return
        end
        --全服首杀红包奖励
        local envelope = getplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_ENVELOPE) or {}
        for monsterId,v in pairs(envelope) do
            if not v then
                local config = ConfigDataManager.getTable("cfg_goldFirstKill","id",monsterId)
                if not config then
                    return
                end
                local weight = string.split(config[1].redenvelopeweight,"#")
                local map = {}
                for k, value in pairs(weight) do
                    map[k] = tonumber(value)
                end
                local index = math.weightedRandom(map)
                local redEnvelope = string.split(config[1].redenvelope,"|")[tonumber(index)]
                string.putIntIntMap(reward,redEnvelope)
            end
        end
        --怪物个人首杀奖励
        local taskInfo = getplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK)
        if taskInfo == nil or taskInfo == "" then
            taskInfo = {}
        end
        for monsterId,v in pairs(taskInfo) do
            if v.status == GoldFirstKill.TASK_STATUS.FINISH then
                table.mergeAdd(reward,GoldFirstKill.GetTaskReward(monsterId))
            end
        end
        --发邮件
        if table.count(reward) > 0 then
            sendconfigmailbyrid(actor,getbaseinfo(actor,"rid"), MailConfig.END_TIME_GOLD_BOSS_REWARD, reward, "")
        end
        setplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_ENVELOPE,nil)
        setplaydef(actor, GoldFirstKill.Var.GOLD_FIRST_KILL_TASK,nil)
    end
    setsysvar(GoldFirstKill.Var.SERVER_FIRST_KILL_GOLD_BOSS,nil)
end
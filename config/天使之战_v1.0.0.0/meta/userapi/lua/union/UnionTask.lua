UnionTask = {}

local this = {}

---@class UnionTask
---@field taskrecord table<number, UnionTaskRecord>
---@field memberrecord number[]
---@field createtime number

---@class UnionTaskRecord
---@field taskid number
---@field tasktype number
---@field taskcount number
---@field createtime string

this.UNION_TASK_KEY = PlayerDefKey.UNION.UNION_TASK_KEY
this.UNION_TASK_RESET_KEY = PlayerDefKey.UNION.UNION_TASK_RESET_KEY

this.UNION_TASK_MAIL_ID = 207004
this.UNION_TASK_SUBMIT_STRING_TIP_ID = 241

this.TASK_TARGET = {
    KILL_SPECIFIED_TYPE_MONSTER = 1, -- 击杀指定类型怪物
    KILL_SPECIFIED_MONSTER      = 2, -- 击杀指定怪物
    FINISH_SPECIFIED_DUPLICATE  = 3, -- 完成指定副本
    KILL_OTHER_UNION_PLAYER     = 4, -- 击杀其他战盟玩家
}

function UnionTask.serverMiddleNight()
    this.middleNightResetTask()
end

function UnionTask.onUnionCreate(actor)
    this.initUnionTaskByActor(actor)
end

function UnionTask.onUnionClose(actor)
    this.clearUnionTaskData(actor)
end

function UnionTask.killMonsterEvent(actor, monsterCfgId)
    this.killMonsterEvent(actor, monsterCfgId)
end

function UnionTask.killPlayerEvent(actor, die_actor)
    this.killPlayerEvent(actor, die_actor)
end

function UnionTask.enterDuplicate(actor, rep_id)
    this.enterDuplicate(actor, rep_id)
end

-- -------------------------------------------------------------------------- --

function this.initUnionTaskByActor(actor)
    local union_id = getbaseinfo(actor, "unionid")
    return this.initUnionTask(union_id)
end

function this.initUnionTask(union_id)
    if tonumber(union_id) < 1 then
        this.jprint("初始化战盟任务失败")
        return {}
    end
    local config_arr = ConfigDataManager.getList("cfg_gard_task")

    local now = getbaseinfo("now")
    local union_task_record = {}
    for _, config in pairs(config_arr) do
        local task_record = this.createUnionTask(config, now)
        union_task_record[tonumber(config.id)] = task_record
    end
    this.setUnionTask(union_id, union_task_record)
    this.setUnionTaskCreateData(union_id, now)
    return union_task_record
end

function this.clearUnionTaskData(actor)
    this.setUnionTask(actor:toString(), nil)
    this.setUnionTaskCreateData(actor:toString(), nil)
end

---@return table<number, UnionTaskRecord>
function this.getUnionTask(union_id)
    local union_actor = getguild(union_id)
    return getguilddef(union_actor, this.UNION_TASK_KEY)
end

function this.setUnionTask(union_id, union_task)
    local union_actor = getguild(union_id)
    setguilddef(union_actor, this.UNION_TASK_KEY, union_task)
end

function this.getUnionTaskCreateData(union_id)
    local union_actor = getguild(union_id)
    return getguilddef(union_actor, this.UNION_TASK_RESET_KEY)
end

function this.setUnionTaskCreateData(union_id, now)
    local union_actor = getguild(union_id)
    setguilddef(union_actor, this.UNION_TASK_RESET_KEY, now)
end

function this.createUnionTask(config, now)
    ---@type UnionTaskRecord
    local task_record = {}
    task_record.taskid = tonumber(config.id)
    task_record.tasktype = tonumber(config.tasktype)
    task_record.taskcount = 0
    task_record.createtime = tostring(now)
    return task_record
end

function this.killMonsterEvent(actor, monster_cfg_id)
    this.updateUnionTask(actor, this.TASK_TARGET.KILL_SPECIFIED_MONSTER, monster_cfg_id)

    local mon_type = ConfigDataManager.getTableValue("cfg_monster", "type", "id", monster_cfg_id)
    this.updateUnionTask(actor, this.TASK_TARGET.KILL_SPECIFIED_TYPE_MONSTER, mon_type)
end

function this.killPlayerEvent(actor, die_actor)
    local union_id = getbaseinfo(actor, "unionid")
    local target_union_id = getbaseinfo(die_actor, "unionid")
    if union_id == target_union_id then
        return
    end
    this.updateUnionTask(actor, this.TASK_TARGET.KILL_OTHER_UNION_PLAYER)
end

function this.enterDuplicate(actor, rep_id)
    local activity_id = ConfigDataManager.getTableValue("cfg_rep", "type", "id", rep_id)
    this.updateUnionTask(actor, this.TASK_TARGET.FINISH_SPECIFIED_DUPLICATE, tonumber(activity_id))
end

function this.updateUnionTask(actor, task_type, target)
    local union_id = getbaseinfo(actor, "unionid")
    if tonumber(union_id) < 1 then
        return
    end
    local change_ids = {}
    ---@type table<number, UnionTaskRecord>
    local union_task = this.getUnionTask(union_id)
    if table.isEmpty(union_task) then
        return
    end

    for task_id, task_record in pairs(union_task) do
        if tonumber(task_record.tasktype) ~= task_type then
            goto continue
        end

        local target_ids, target_count = this.getUnionTaskTargetConfig(task_id)
        if target_ids and (not table.contains(target_ids, tonumber(target))) then
            goto continue
        end
        local task_count = task_record.taskcount
        if task_count >= target_count then
            goto continue
        end
        task_record.taskcount = task_count + 1
        change_ids[task_id] = task_record

        -- 发放特殊奖励
        if task_record.taskcount == target_count then
            local special_reward_str = ConfigDataManager.getTableValue("cfg_gard_task", "rewardspecial", "id", task_id)
            local success, result = xpcall(this.addItemToBag, debug.traceback, actor, special_reward_str)
            gameDebug.assertPrint(success, "特殊奖励发放失败！", result, "参数", actor:toString(), task_id)
        end

        :: continue ::
    end

    if table.isEmpty(change_ids) then
        return
    end
    this.setUnionTask(union_id, union_task)
    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_TASK_CHANGE, change_ids)
end

function this.getUnionTaskTargetConfig(task_id)
    local task_target_str = ConfigDataManager.getTableValue("cfg_gard_task", "taskcontent", "id", task_id)
    if string.contains(task_target_str, "#") then
        local target_arr = string.split(task_target_str, "#")
        local targets = {}
        for i = 1, #target_arr - 1, 1 do
            table.insert(targets, tonumber(target_arr[i]))
        end
        return targets, tonumber(target_arr[#target_arr])
    end

    return nil, tonumber(task_target_str)
end

function this.middleNightResetTask()
    local data = getallunionsummary()
    if table.isEmpty(data) then
        return
    end

    local now = tonumber(getbaseinfo("now"))
    for _, summary in pairs(data) do
        local union_id = summary.unionid
        local time_data = this.getUnionTaskCreateData(union_id)
        local create_mills = string.tonumber(time_data)

        local ret = this.checkTaskResetTime(create_mills, now)
        if not ret then
            goto continue
        end

        local union_data = getunioninfo(union_id)
        if table.isEmpty(union_data) then
            goto continue
        end

        local finish_task_ids = {}
        local task_record_map = this.getUnionTask(union_id)
        if not table.isEmpty(task_record_map) then
            for task_id, task_record in pairs(task_record_map) do
                local _, target_count = this.getUnionTaskTargetConfig(task_id)
                if task_record.taskcount >= target_count then
                    table.insert(finish_task_ids, task_id)
                end
            end
        end

        for member_id, member_info in pairs(union_data.memberinfos) do
            local member_actor = getactor(member_id)
            if #finish_task_ids > 0 then
                local un_received_task_ids = {}
                local member_task = this.getMemberTaskData(member_actor)
                if table.isEmpty(member_task) then
                    un_received_task_ids = finish_task_ids
                else
                    un_received_task_ids = this.tableDifference(finish_task_ids, member_task.finishtask)
                end

                local item_map = {}
                -- 校验在线时间 领取可以领取的奖励
                for _, task_id in pairs(un_received_task_ids) do
                    local can_receive = this.checkJoinTime(member_info, task_id)
                    if can_receive then
                        -- 遍历计算奖励
                        local reward_str = ConfigDataManager.getTableValue("cfg_gard_task", "rewarditem", "id", task_id)
                        string.putIntIntMap(item_map, reward_str, "#", "|")
                    end
                end
                -- 发送邮件
                if not table.isNullOrEmpty(item_map) then
                    sendconfigmailbyrid(member_id, this.UNION_TASK_MAIL_ID, item_map)
                end
            end

            -- 重置成员任务
            this.setMemberTaskData(member_actor, nil)
        end

        -- 重置战盟任务
        this.initUnionTask(union_id)
        :: continue ::
    end
end

function this.tableDifference(table1, table2)
    local result = {}
    local table2Set = {}

    if table.isEmpty(table2) then
        return table1
    end

    for _, value in ipairs(table2) do
        table2Set[value] = true
    end

    for _, value in ipairs(table1) do
        if not table2Set[value] then
            table.insert(result, value)
        end
    end

    return result
end

function this.checkTaskResetTime(create_time, now_time)
    create_time = floor(create_time / 1000)
    now_time = floor(now_time / 1000)

    -- 默认读第一条配置 没有配置时默认为1天
    local days = tonumber(ConfigDataManager.getTableValue("cfg_gard_task", "taskrefreshes", "id", 1)) or 1

    local thirdDayMidnight = create_time + (24 * 60 * 60 * days)
    local thirdDayMidnightDate = os.date("*t", thirdDayMidnight)

    thirdDayMidnightDate.hour = 0
    thirdDayMidnightDate.min = 0
    thirdDayMidnightDate.sec = 0
    local expectedMidnightTimestamp = os.time(thirdDayMidnightDate)

    return now_time >= expectedMidnightTimestamp
end

-- -------------------------------------------------------------------------- --

UnionMemberTask = {}

---@class UnionMemberTask
---@field finishtask number[]
---@field createtime string

this.UnionMemberTaskDataKey = PlayerDefKey.UNION.UnionMemberTaskDataKey

function UnionMemberTask.sendUnionTaskData(actor)
    this.sendUnionTaskData(actor)
end

function UnionMemberTask.submitUnionTask(actor, task_id)
    this.submitUnionTask(actor, task_id)
end

---@return UnionMemberTask
function this.getMemberTaskData(actor)
    return getplaydef(actor, this.UnionMemberTaskDataKey)
end

function this.setMemberTaskData(actor, data)
    setplaydef(actor, this.UnionMemberTaskDataKey, data)
end

function this.initMemberTask(actor)
    ---@type UnionMemberTask
    local member_task = {}
    member_task.finishtask = {}
    member_task.createtime = tostring(getbaseinfo("now"))
    this.setMemberTaskData(actor, member_task)
    return member_task
end

function this.sendUnionTaskData(actor)
    ---@type UnionTask
    local union_task = {}
    local union_id = tostring(getbaseinfo(actor, "unionid"))
    if tonumber(union_id) < 1 then
        return
    end
    local task_record = this.getUnionTask(union_id)
    if table.isEmpty(task_record) then
        task_record = this.initUnionTaskByActor(actor)
    end

    local member_task = this.getMemberTaskData(actor)
    if not table.isEmpty(member_task) then
        union_task.memberrecord = member_task.finishtask
    end
    union_task.taskrecord = task_record

    local mills = this.getUnionTaskCreateData(union_id)
    if mills then
        union_task.createtime = mills
    end

    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_TASK_DATA, union_task)
end

function this.submitUnionTask(actor, task_id)
    local union_id = tostring(getbaseinfo(actor, "unionid"))
    if tonumber(union_id) < 1 then
        return
    end

    local union_task_record = this.getUnionTask(union_id)
    if table.isEmpty(union_task_record) then
        return
    end
    local task_record = union_task_record[task_id]

    local _, target_count = this.getUnionTaskTargetConfig(task_id)
    local task_count = task_record.taskcount
    if target_count > task_count then
        this.debug("-- 任务未完成, 无法提交 --", task_id, target_count, task_count)
        return
    end

    local finish_task_tbl
    local member_task = this.getMemberTaskData(actor)
    if table.isEmpty(member_task) then
        finish_task_tbl = {}
        member_task = this.initMemberTask(actor)
    else
        finish_task_tbl = member_task.finishtask
        if table.contains(finish_task_tbl, task_id) then
            this.jprint("战盟任务奖励已经领取")
            return
        end
    end

    local rid = getbaseinfo(actor, "id")
    local union_data = getunioninfo(actor)

    local can_receive, hour = this.checkJoinTime(union_data.memberinfos[rid], task_id)
    if not can_receive then
        -- sendluamsg(actor, LuaMessageIdToClient.TIPS, "加入战盟时间需要" .. hour .. "小时以上")
        noticeTip.noticeinfo(actor, this.UNION_TASK_SUBMIT_STRING_TIP_ID, hour)
        this.debug("-- 领取任务奖励失败 --", can_receive, hour)
        return
    end

    local reward_str = ConfigDataManager.getTableValue("cfg_gard_task", "rewarditem", "id", task_id)
    this.addItemToBag(actor, reward_str)

    member_task.finishtask[#finish_task_tbl + 1] = task_id
    this.setMemberTaskData(actor, member_task)
    sendluamsg(actor, LuaMessageIdToClient.RES_SUBMIT_UNION_TASK, task_id)
end

function this.addItemToBag(actor, item_str)
    local item_tbl = string.toIntIntMap(item_str, "#", "|")
    additemmaptobag(actor, item_tbl, 0, 9999, ItemActionProxy.UNION_TASK)
end

function this.checkJoinTime(member_info, task_id)
    local now = getbaseinfo("now")
    local join_hour = (tonumber(now) - tonumber(member_info.jointime)) / 60 / 60 / 1000
    local hour = ConfigDataManager.getTableValue("cfg_gard_task", "hour", "id", task_id)
    return join_hour >= tonumber(hour), hour
end

function this.mergeAndSumTables(table1, table2)
    for key, value in pairs(table2) do
        key = tonumber(key)
        value = tonumber(value)
        if table1[key] then
            table1[key] = table1[key] + value
        else
            table1[key] = value
        end
    end
end

-- -------------------------------------------------------------------------- --
-- 日志打印
this.log_open = false
function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(...)
end

function this.jprint(param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(param)
end

-- --------------------- GM 调试函数 --------------------

local gm_open = true
function l_uniontask_resetuniontaskdata()
    if not gm_open then
        return
    end

    local data = getallunionsummary()
    if table.isEmpty(data) then
        return
    end

    for _, summary in pairs(data) do
        this.jprint("------ GM重置战盟任务 ------")
        -- 重置成员任务
        local union_id = summary.unionid
        local union_data = getunioninfo(union_id)
        if table.isEmpty(union_data) then
            goto continue
        end
        for member_id, _ in pairs(union_data.memberinfos) do
            local member_actor = getactor(member_id)
            this.setMemberTaskData(member_actor, nil)
        end

        -- 重置战盟任务
        this.initUnionTask(union_id)
        :: continue ::
    end
end

function l_uniontask_finishuniontask(actor, type, target)
    if not gm_open then
        return
    end
    this.updateUnionTask(actor, tonumber(type), tonumber(target))
end

function l_uniontask_submituniontask(actor, task_id)
    if not gm_open then
        return
    end
    this.submitUnionTask(actor, tonumber(task_id))
end

function l_uniontask_middlenightresettask()
    if not gm_open then
        return
    end
    this.middleNightResetTask()
end

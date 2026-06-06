DailyActivity = {}

--------------------------------- 文件注解 ---------------------------
---@class DailyActivity
---@field activity_value number
---@field reset_time string
---@field daily_task daily_task[]
---@field daily_box daily_box[]

---@class daily_task
---@field task_id number
---@field target_id number
---@field taskgoal_type number
---@field goal_count number
---@field state number
---@field task_finish_count number

---@class daily_box
---@field box_id number
---@field ax_num number
---@field state number

---@class DailyActivity.Activity
---@field activityid string
---@field open boolean

local this = {}
this.box_accept = 0
this.box_received = 1

this.task_accept = 0
this.task_finish = 1
this.item_bind_id = 11
--- 配置表的红点id
this.RedId = 96

function DailyActivity.login(actor)
    this.initPlayerDailyActivity(actor)
end

function DailyActivity.getActivityInfo(actor)
    this.sendActivityInfo(actor)
end

function DailyActivity.receiveBoxReward(actor, msgData)
    this.receiveBoxReward(actor, msgData)
end

function DailyActivity.taskGoalFlush(actor, taskTargetType, param)
    local success, errorInfo = xpcall(this.taskGoalFlush, debug.traceback, actor, taskTargetType, param)
    gameDebug.assertPrint(success, "日常任务目标刷新异常：", actor, taskTargetType, param, errorInfo)
end

function DailyActivity.getActivityList(actor)
    local data = this.getActivityList(actor)
    sendluamsg(actor, LuaMessageIdToClient.GET_DAILY_ACTIVITY_ACTIVITY_LIST, data)
end

function DailyActivity.zeroEvent(actor)
    this.initPlayerDailyActivity(actor)
end

--------------------------------------------------------

---@return DailyActivity
function this.getdata(actor)
    return getplaydef(actor, "T$_role_daily_activity_data")
end

function this.savedata(actor, data)
    setplaydef(actor, "T$_role_daily_activity_data", data)
end

function this.sendActivityInfo(actor)
    local data = this.getdata(actor)
    sendluamsg(actor, LuaMessageIdToClient.GET_DAILY_ACTIVITY_INFO, data)
end

--- 玩家上线触发小红点计算
---@param red_data table 红点数据结果存储器
---@param actor any 玩家对象
function DailyActivity.hasBoxUnReceived(actor)
    local data = this.getdata(actor)
    local value = data.activity_value
    for _, v in pairs(data.daily_box) do
        if value >= tonumber(v.ax_num) and v.state == this.box_accept then
            return true
        end
    end
    return false
end

function DailyActivity.loginRed(red_data, actor)
    if DailyActivity.hasBoxUnReceived(actor) then
        --登陆的时候判定 false 可以不发送的
        red_data[this.RedId] = true
    end
end

function this.initPlayerDailyActivity(actor)
    this.getdata(actor)
    local can = this.canReset(actor)
    if not can then
        this.loginfo(actor, "跳过每日目标初始化")
        return
    end

    this.jprint("初始化每日任务")
    local daily_task = {}
    local configList = ConfigDataManager.getList("cfg_daily_activity")
    for _, config in ipairs(configList) do
        this.buildActivityTask(actor, config, daily_task)
    end

    this.jprint("初始化每日宝箱")
    local daily_box = {}
    local level = getbaseinfo(actor, "level")
    local box_configs = ConfigDataManager.getList("cfg_activeness_reward")
    for _, config in ipairs(box_configs) do
        local level_limit = config.level
        local limit_arr = string.split(level_limit, "#")
        if tonumber(limit_arr[1]) <= level and level <= tonumber(limit_arr[2]) then
            this.jprint("--- 开始初始化宝箱奖励 --- boxId: " .. config.id)
            this.buildActivityBox(config, daily_box)
        end
    end

    local reset_time = this.getTimeStr(actor)

    ---@type DailyActivity
    local role_daily_task_data = {
        daily_task     = daily_task,
        daily_box      = daily_box,
        activity_value = 0,
        reset_time     = reset_time
    }
    this.savedata(actor, role_daily_task_data)
    this.loginfo(actor, "每日任务数据保存完成")
    this.jprint(role_daily_task_data)
end

function this.getTimeStr(actor)
    local year = getbaseinfo(actor, "year")
    local month = getbaseinfo(actor, "month")
    local day = getbaseinfo(actor, "day")
    local reset_time = year .. month .. day
    return reset_time
end

function this.canReset(actor)
    local data = this.getdata(actor)
    if data == nil then
        return true
    end

    if table.isEmpty(data.daily_task) then
        return true
    end

    local last_time = data.reset_time
    if last_time == nil or last_time == "" then
        return true
    end

    local now_time = this.getTimeStr(actor)
    local time_log = "last_time:" .. last_time .. " now_time:" .. now_time
    this.jprint(time_log)
    if last_time == now_time then
        return false
    end
    return true
end

function this.buildActivityTask(actor, config, daily_task)
    local task_id = config["id"]
    local target_id = config["target"]

    local taskInfo = this.buildTaskGlobal(actor, task_id, target_id)
    if taskInfo == nil then
        return
    end

    table.insert(daily_task, taskInfo)
end

function this.buildTaskGlobal(actor, task_id, target_id)
    local targetConfig = ConfigDataManager.getById("cfg_task_target", target_id)
    if table.isEmpty(targetConfig) then
        this.loginfo(actor, "没有找到任务配置:" .. target_id)
        return
    end
    local taskGoalType = targetConfig["taskgoaltype"]

    ---@type daily_task
    local taskData = {
        task_id           = task_id,
        target_id         = target_id,
        taskgoal_type     = taskGoalType,
        goal_count        = 0,
        state             = this.task_accept,
        task_finish_count = 0
    }
    return taskData
end

function this.buildActivityBox(config, daily_box)
    local box_id = config["id"]
    local ax_num = config["axnum"]

    ---@type daily_box
    local box_data = { box_id = box_id, ax_num = ax_num, state = this.box_accept }
    table.insert(daily_box, box_data)
end

function this.receiveBoxReward(actor, param)
    this.jprint(param)
    local box_id = param
    local config = ConfigDataManager.getById("cfg_activeness_reward", box_id)
    if table.isEmpty(config) then
        this.loginfo(actor, "没有找到宝箱配置:" .. box_id)
        return
    end
    local need_num = config["axnum"]

    ---@type DailyActivity
    local data = this.getdata(actor)
    if tonumber(data.activity_value) < tonumber(need_num) then
        this.loginfo(actor, "活跃值不足,无法领取宝箱:" .. box_id)
        return
    end

    local box_list = data.daily_box
    for _, box in ipairs(box_list) do
        if tonumber(box.box_id) == box_id then
            if box.state == this.box_received then
                this.jprint("宝箱奖励已经领取")
                return
            end
            box.state = this.box_received
        end
    end

    this.jprint(config)
    local reward = config["caxitem"]
    local reward_item = string.toIntIntMap(reward, "#", "|")
    this.jprint("必得道具")
    this.jprint(reward_item)
    this.getRandomItem(actor, config, reward_item)

    this.savedata(actor, data)
    local itemBing = ConfigDataManager.getTableValue("cfg_bind", "bind", "id", this.item_bind_id)
    additemmaptobag(actor, reward_item, itemBing, 9999, ItemActionProxy.DAILYACTIVITY)
    this.jprint("发放宝箱奖励：")
    this.jprint(reward_item)
    this.sendActivityInfo(actor)
    GameTips.sendGetRewardMsg(actor, reward_item)
end

function this.getRandomItem(actor, config, reward_item)
    -- local count = config["randomreward"]
    -- if count == nil or count == "" or tonumber(count) < 1 then
    --     this.jprint("randomreward: 随机道具数量错误")
    --     return
    -- end
    local count = 1
    local random_item_str = config["randomreward"]
    if random_item_str == nil or random_item_str == "" then
        this.jprint("randomreward: 随机道具错误")
        return
    end

    local reward_map = {}
    local reward_weight = {}

    local random_item_str_arr = string.split(random_item_str, "|")
    for _, random_item_str in pairs(random_item_str_arr) do
        local random_item = string.split(random_item_str, "#")
        local item_id = random_item[1]
        local item_count = random_item[2]
        local weight = random_item[3]
        reward_weight[item_id] = weight
        reward_map[item_id] = item_count
    end
    local key_set = randombyweight(actor, reward_weight, count)
    this.jprint("key_set:")
    this.jprint(key_set)
    for _, item_id in pairs(key_set) do
        local reward_count = reward_item[item_id]
        local random_count = reward_map[item_id]
        if reward_count ~= nil then
            reward_item[item_id] = reward_count + random_count
        end
        reward_item[item_id] = random_count
    end
end

function this.taskGoalFlush(actor, type, param)
    this.jprint(" -------- 每日目标任务刷新 ----------")
    ---@type DailyActivity
    local data = this.getdata(actor)
    if data == nil then
        return
    end
    local haschange = false
    for index, task in ipairs(data.daily_task) do
        local conditions = ConfigDataManager.getTableValue("cfg_daily_activity", "conditions", "id", task.task_id)
        if conditions and conditions ~= "" then
            local isPass = checkcondition(actor, conditions)
            if tonumber(isPass) ~= 1 then
                goto continue
            end
        end
        local ischange = this.doFlush(actor, data, task, type, param)
        if ischange then
            -- 保存task数据
            haschange = true
            data.daily_task[index] = task
        end
        :: continue ::
    end

    if haschange then
        this.savedata(actor, data)
        if DailyActivity.hasBoxUnReceived(actor) then
            RedPoint.sendOneRedPoint(actor, this.RedId, true)
        end
    end
    this.jprint("-------- 每日任务刷新结束 ----------")
end

function this.doFlush(actor, data, task, type, param)
    if tonumber(task.state) == tonumber(this.task_finish) then
        this.jprint("任务已完成")
        return false
    end
    if tonumber(task.taskgoal_type) ~= tonumber(type) then
        return false
    end

    local count = TaskGoal.FlushTaskCount(actor, type, task.target_id, task.goal_count, param)
    if count == nil or tonumber(task.goal_count) == tonumber(count) then
        this.jprint("任务进度没有变化")
        return false
    end

    -- 进度变化
    local configs = ConfigDataManager.getTable("cfg_daily_activity", "id", task.task_id)
    local target_configs = ConfigDataManager.getTable("cfg_task_target", "id", task.target_id)

    local config = configs[1]
    local target_config = target_configs[1]

    local need_count = target_config["goalcount"]
    if tonumber(need_count) < 1 then
        need_count = 1
    end
    if tonumber(need_count) > tonumber(count) then
        task.goal_count = count
        return true
    end

    -- 每完成一次 重置任务进度
    task.goal_count = 0

    local timemax = config["timemax"]
    local finish_count = task.task_finish_count + 1
    if tonumber(finish_count) >= tonumber(timemax) then
        task.state = this.task_finish
        task.task_finish_count = timemax
    else
        task.task_finish_count = finish_count
    end
    -- 发放活跃值
    local act_value = config["activity"]
    data.activity_value = data.activity_value + act_value
    return true
end

function this.getActivityList(actor)
    local act_data = getallactivities(actor)
    local data = {}
    for _, act in pairs(act_data) do
        local activity_data = {
            activityid = act.activityid,
            open       = act.open
        }
        table.insert(data, activity_data)
    end
    return data
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

this.gm_open = true
function l_daily_activity_init_role_activity_and_box(actor)
    if not this.gm_open then
        return
    end
    this.initPlayerDailyActivity(actor)
end

--- 凌晨时间注册
ZeroEventListerTable:eventLister("0", "每日目标凌晨事件", DailyActivity.zeroEvent)
RedPointEventListerTable:eventLister("0", "每日目标", DailyActivity.loginRed)
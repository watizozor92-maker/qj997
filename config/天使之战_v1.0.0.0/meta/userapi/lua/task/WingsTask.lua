--[[ Wings = {}
local this = {}

---章节状态
local ChapterState = {
    ---已解锁
    ACCEPT = 1,
    ---已完成
    FINISH = 2,
    ---已领取
    REWARD = 3
}

local WingsTask = "T$wings_task"

--全部章节完成
local ALL_FINISH = -1

function this.GetNewWingsTask()
    local WingsTaskInfo = {
        ---当前章节
        now_chapter = 0,
        ---章节任务信息
        chapter_task_info = {}
    }
    return WingsTaskInfo
end

function Wings.Login(actor)
    Wings.TryInitWingsTask(actor)
    Wings.SendWingsTask(actor)
end

function Wings.TryInitWingsTask(actor)
    if this.InitNewChapter(actor) then
        Wings.SendWingsTask(actor)
    end
end

function this.SaveWingsTask(actor, wingsTaskInfo)
    setplaydef(actor, WingsTask, wingsTaskInfo)
end

function this.GetWingsTask(actor)
    local wingsTaskInfo = getplaydef(actor, WingsTask)
    return wingsTaskInfo or this.GetNewWingsTask()
end

function this.CheckAllFinish(wingsTask)
    local nextChapter = wingsTask.now_chapter + 1
    local chapterCfgList = ConfigDataManager.getTable("cfg_wings", "groupid", nextChapter)
    if table.isNullOrEmpty(chapterCfgList) then
        local nowChapter = wingsTask.chapter_task_info[wingsTask.now_chapter] or {}
        local state = nowChapter.state or 0
        return  state == ChapterState.REWARD
    end
    return false
end

function Wings.SendWingsTask(actor)
    local wingsTask = this.GetWingsTask(actor)
    if this.CheckAllFinish(wingsTask) then
        wingsTask.now_chapter = ALL_FINISH
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_WINGS_TASK_INFO, wingsTask)
end

function this.WingsChange(actor, changeTask, chapter, chapterStatus)
    local chapterTask = {
        now_chapter = chapter,
        chapter_state = chapterStatus,
        change_task = changeTask
    }
    sendluamsg(actor, LuaMessageIdToClient.RES_WINGS_TASK_CHANGE, chapterTask)
end

function this.InitNewChapter(actor)
    local wingsTask = this.GetWingsTask(actor)
    local chapterTaskInfo = wingsTask.chapter_task_info
    local nowChapterTask = chapterTaskInfo[wingsTask.now_chapter]

    -- lg("初始化章节任务：", wingsTask)
    if not table.isNullOrEmpty(nowChapterTask) and nowChapterTask.state ~= ChapterState.REWARD then
        return false
    end

    local nextChapter = wingsTask.now_chapter + 1
    local chapterCfgList = ConfigDataManager.getTable("cfg_wings", "groupid", nextChapter)
    -- lg("章节任务配置：", chapterCfgList,nextChapter)
    if table.isNullOrEmpty(chapterCfgList) then
        return false
    end
    local nextChapterTask = this.InitChapterTask(actor, nextChapter)
    -- lg("章节任务：", nextChapterTask)
    if table.isNullOrEmpty(nextChapterTask) then
        return false
    end

    chapterTaskInfo[nextChapter] = nextChapterTask
    wingsTask.now_chapter = nextChapter
    wingsTask.chapter_task_info = chapterTaskInfo
    this.SaveWingsTask(actor, wingsTask)
    return true
end

---初始化章节任务池
function this.InitChapterTask(actor, group)
    local taskCfgList = ConfigDataManager.getTable("cfg_wingstask", "group", group)
    if table.isNullOrEmpty(taskCfgList) then
        return nil
    end
    local chapterTask = {
        state = ChapterState.ACCEPT,
        task_info = {}
    }
    for _, taskCfg in pairs(taskCfgList) do
        -- lg("章节任务配置：", taskCfg)
        local taskId = tonumber(taskCfg["id"])
        local taskTargetId = tonumber(taskCfg["tasktargetid"])
        local careerLimit = taskCfg["careerlimit"]

        if this.CheckCareer(actor, careerLimit) then
            local taskRecord = TaskHandler.BuildTaskRecord(actor, taskId, taskTargetId)
            if taskRecord ~= nil then
                chapterTask.task_info[taskId] = taskRecord
            end
        end
    end
    return next(chapterTask.task_info) ~= nil and chapterTask or nil
end

function this.CheckCareer(actor, careerLimit)
    if not careerLimit or #careerLimit == 0 or (tonumber(careerLimit) == 0) then
        return true
    end
    local baseCareer = tonumber(getbaseinfo(actor, "getbasecareer"))
    return baseCareer == tonumber(careerLimit)
end

function Wings.FlushWingsTask(actor, taskTargetType, param)
    local success, errorInfo = xpcall(this.FlushWingsTask, debug.traceback, actor, taskTargetType, param)
    gameDebug.assertPrint(success, "翅膀任务目标异常：", actor, taskTargetType, param, errorInfo)
end

---刷新任务
function this.FlushWingsTask(actor, taskTargetType, param)
    -- lg("刷新任务：", taskTargetType, param)
    local wingsTask = this.GetWingsTask(actor)
    -- lg("刷新任务：",wingsTask)
    local nowChapter = wingsTask.now_chapter
    if nowChapter == 0 then
        return
    end
    local chapterTaskInfo = wingsTask.chapter_task_info
    if table.isNullOrEmpty(chapterTaskInfo) then
        return
    end
    -- 当前章节
    local chapterTask = chapterTaskInfo[nowChapter]
    if table.isNullOrEmpty(chapterTask) or chapterTask.state >= ChapterState.FINISH then
        return
    end
    local taskList = chapterTask.task_info
    local changeTask = this.CheckTaskRecord(actor, taskList, taskTargetType, param)
    -- lg("刷新任务：", changeTask)
    if table.isNullOrEmpty(changeTask) then
        return
    end
    chapterTask.task_info = taskList
    chapterTaskInfo[nowChapter] = chapterTask
    wingsTask.chapter_task_info = chapterTaskInfo
    this.SaveWingsTask(actor, wingsTask)
    this.WingsChange(actor, changeTask, nowChapter, chapterTask.state)
end

---检查任务记录
function this.CheckTaskRecord(actor, taskList, taskTargetType, param)
    local changeTask = {}
    for taskId, taskRecord in pairs(taskList) do
        local taskGoal = taskRecord.task_goal
        local target_id = taskRecord.target_id
        local goal_count = taskRecord.goal_count
        local needCount = taskRecord.max_count
        if taskTargetType == taskGoal and taskRecord.state == TaskHandler.Status.ACCEPT then
            local count = TaskGoal.FlushTaskCount(actor, taskGoal, target_id, goal_count, param)
            if count >= needCount then
                taskRecord.state = TaskHandler.Status.FINISH
            end
            if count > goal_count then
                taskRecord.goal_count = math.min(count, needCount)
                changeTask[taskId] = taskRecord
            end
        end
    end
    return changeTask
end

---提交任务
function Wings.SubmitChapterTask(actor, taskId)
    -- lg("提交任务：", taskId)
    local wingsTask = this.GetWingsTask(actor)
    local nowChapter = wingsTask.now_chapter
    local chapterTaskInfo = wingsTask.chapter_task_info
    if table.isNullOrEmpty(chapterTaskInfo) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT405)
        return
    end
    local chapterTask = chapterTaskInfo[nowChapter]
    if chapterTask.state >= ChapterState.FINISH then
        tipinfo(actor, "任务已提交")
        return
    end
    local taskList = chapterTask.task_info
    local taskRecord = taskList[taskId]
    if taskRecord == nil then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT355)
        return
    end
    if taskRecord.state == TaskHandler.Status.SUBMIT then
        tipinfo(actor, "任务已提交")
        return
    end
    if taskRecord.state == TaskHandler.Status.ACCEPT then
        tipinfo(actor, "任务未完成")
        return
    end
    --发奖励
    local rewardStr = ConfigDataManager.getTableValue("cfg_wingstask", "rewarditem", "id", taskRecord.task_id)
    this.SendTaskReward(actor, rewardStr)

    taskList[taskId].state = TaskHandler.Status.SUBMIT
    chapterTask.task_info = taskList
    --检查章节完成
    local chapterFinish = this.CheckChapterFinish(taskList)
    if chapterFinish then
        chapterTask.state = ChapterState.FINISH
    end
    chapterTaskInfo[nowChapter] = chapterTask
    wingsTask.chapter_task_info = chapterTaskInfo

    this.SaveWingsTask(actor, wingsTask)
    local changeTask = {}
    changeTask[taskId] = taskRecord
    this.WingsChange(actor, changeTask, nowChapter, chapterTask.state)
end

function this.SendTaskReward(actor, rewarStr)
    if string.isNullOrEmpty(rewarStr) then
        return
    end
    Bag.sendRewards4StringByBind(actor, rewarStr,"3", ItemActionProxy.WINGS)
end

function this.CheckChapterFinish(taskList)
    for _, taskRecord in pairs(taskList) do
        if taskRecord.state ~= TaskHandler.Status.SUBMIT then
            return false
        end
    end
    return true
end

function Wings.ReceiveChapterAward(actor)
    -- lg("领取章节奖励")
    local wingsTask = this.GetWingsTask(actor)
    local nowChapter = wingsTask.now_chapter
    if nowChapter == 0 then
        tipinfo(actor, "未解锁")
        return
    end
    local chapterTaskInfo = wingsTask.chapter_task_info
    local chapterTask = chapterTaskInfo[nowChapter]
    -- lg("领取奖励:",chapterTask)
    if table.isNullOrEmpty(chapterTask) or chapterTask.state ~= ChapterState.FINISH then
        tipinfo(actor, "无奖励可领取")
        return
    end
    --发奖励
    local rewardStr = ConfigDataManager.getTableValue("cfg_wings", "rewarditem", "groupid", nowChapter)
    this.SendTaskReward(actor, rewardStr)
    chapterTask.state = ChapterState.REWARD
    chapterTaskInfo[nowChapter] = chapterTask
    wingsTask.chapter_task_info = chapterTaskInfo
    this.SaveWingsTask(actor, wingsTask)
    --尝试初始化下一章
    this.InitNewChapter(actor)
    Wings.SendWingsTask(actor)
end

--GM一键完成章节所有任务
function finishchapteralltask(actor)
    local wingsTask = this.GetWingsTask(actor)
    local nowChapter = wingsTask.now_chapter
    if nowChapter == 0 then
        return
    end
    local chapterTaskInfo = wingsTask.chapter_task_info
    local chapterTask = chapterTaskInfo[nowChapter]
    if chapterTask.state >= ChapterState.FINISH then
        return
    end
    local taskInfo = chapterTask.task_info
    for _, taskRecord in pairs(taskInfo) do
        if taskRecord.state == TaskHandler.Status.ACCEPT then
            taskRecord.goal_count = taskRecord.max_count
            taskRecord.state = TaskHandler.Status.FINISH
        end
    end
    chapterTask.task_info = taskInfo
    chapterTaskInfo[nowChapter] = chapterTask
    wingsTask.chapter_task_info = chapterTaskInfo 
    this.SaveWingsTask(actor, wingsTask)
    Wings.SendWingsTask(actor)
end
 ]]
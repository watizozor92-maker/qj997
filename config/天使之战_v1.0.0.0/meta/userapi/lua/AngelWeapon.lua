AngelWeapon ={}
local this = {}
AngelWeapon.var ={
    ANGEL_WEAPON_INFO = "T$angelweaponinfo",
}
AngelWeapon.TaskStatus = {
    CAN_RECEIVE = 1,--可领取
    UNFINISHED = 2,--未完成
    RECEIVED = 3 --已领取
}
AngelWeapon.TaskType = {
    MIN = 1,--小奖
    MAX = 2,--大奖
}
--活动是否开启
function AngelWeapon.isActivityOpen(actor)
    local config = ConfigDataManager.getTable("sub_mainActivity","id",5)
    if config == nil then
        return false
    end
    return ConditionManager.Check(actor, config[1].actualcondition)
end
--页签是否开启
function AngelWeapon.tableOpen(actor)
    local config = ConfigDataManager.getTable("sub_mainActivity","id",5)
    if config == nil then
        return false
    end
    return ConditionManager.Check(actor, config[1].showcondition)
end
function AngelWeapon.checkOpenTime(actor)
    local nowGroup = AngelWeapon.getGroup(actor)
    if nowGroup == 0 then
        --活动未开启,找最大的那个group
        local config = ConfigDataManager.getTable("cfg_activity_angelWeaponTime")
        local group = 0
        for i = 1, #config do
            if tonumber(config[i].taskgroup) > group then
                group = tonumber(config[i].taskgroup)
            end
        end
        local cfg = ConfigDataManager.getTable("cfg_activity_angelWeaponTime","taskGroup",group)
        if not cfg then
            return nil
        end
        local condition = cfg[1].condition
        local map = string.putIntIntMap({},condition,"#","&")
        local time = map[903]
        local serverOpenDays = getbaseinfo(actor, "serveropendays")
        if time + 1 == tonumber(serverOpenDays) then
            return group
        end
        return nil
    end
    local config = ConfigDataManager.getTable("cfg_activity_angelWeaponTime","taskGroup",nowGroup - 1)
    if config then
        local condition = config[1].condition
        local map = string.putIntIntMap({},condition,"#","&")
        local time = map[903]
        local serverOpenDays = getbaseinfo(actor, "serveropendays")
        if time + 1 == tonumber(serverOpenDays) then
            return nowGroup - 1
        end
    end
    return nil
end

function AngelWeapon.getGroup(actor)
    local config = ConfigDataManager.getTable("cfg_activity_angelWeaponTime")
    if not config then
        return 0
    end
    for _,cfg in pairs(config)do
        local condition = cfg.condition
        if ConditionManager.Check(actor, condition) then
            return tonumber(cfg.taskgroup)
        end
    end
    return 0
end

function AngelWeapon.login(actor)
    if not AngelWeapon.isActivityOpen(actor) then
        return
    end
    AngelWeapon.updateTaskInfo(actor)
end
--玩家穿戴|脱下装备时需要更新一次
function AngelWeapon.updateTaskInfo(actor)
    if not AngelWeapon.isActivityOpen(actor) then
        return
    end
    local taskInfo = getplaydef(actor, AngelWeapon.var.ANGEL_WEAPON_INFO)
    if taskInfo == nil or taskInfo == "" then
        taskInfo = {}
    end
    local group = AngelWeapon.getGroup(actor)
    local career = getbaseinfo(actor,"getbasecareer")
    local equips = getputonequipinfo(actor)
    local map = {}
    for _,equip in pairs(equips) do
        local cfgId = tonumber(equip.cfgid)
        local num = map[cfgId] or 0
        map[cfgId] = num + 1
    end
    local config = ConfigDataManager.getTable("cfg_activity_angelWeapon","angelWeaponTaskGroup",group,"career",career)
    if not config then
        tipinfo(actor,"没有对应的活动数据！")
        return
    end
    local result = {}
    result.taskGroup = group
    result.taskList = {}
    local info = taskInfo[group]
    if info == nil or info == "" then
        info = {}
        info.taskList = {}
    end
    for _,cfg in pairs(config) do
        if tonumber(cfg.angelweapontype) ~= AngelWeapon.TaskType.MAX then
            local task = info.taskList[tostring(cfg.id)]
            if task == nil or task == "" then
                task = {}
            end
            local itemList = {}
            if table.count(task) == 0 or task.giftState ~= AngelWeapon.TaskStatus.RECEIVED then
                local str = string.toIntIntMap(cfg.angelweapontask,"#","|")
                local flag = true
                for k,v in pairs(str) do
                    local num = map[k] or 0
                    if num >= v then
                        itemList[k] = v
                    else
                        itemList[k] = num
                        flag = false
                    end
                end
                task.id = tonumber(cfg.id)
                task.itemList = itemList
                task.giftState = flag and AngelWeapon.TaskStatus.CAN_RECEIVE or AngelWeapon.TaskStatus.UNFINISHED
            end
            result.taskList[tostring(cfg.id)] = task
        end
    end
    local config2 = ConfigDataManager.getTable("cfg_activity_angelWeapon","angelWeaponTaskGroup",group,"career",career,"angelWeaponType", AngelWeapon.TaskType.MAX)
    if config2 then
        local state = AngelWeapon.TaskStatus.CAN_RECEIVE
        if info.taskList then
            local task = info.taskList[tostring(config2[1].id)]
            if task and task.giftState == AngelWeapon.TaskStatus.RECEIVED then
                state = AngelWeapon.TaskStatus.RECEIVED
            else
                for _,v in pairs(result.taskList)do
                    if v.giftState ~= AngelWeapon.TaskStatus.RECEIVED then
                        state = AngelWeapon.TaskStatus.UNFINISHED
                        break
                    end
                end
            end
        else
            state = AngelWeapon.TaskStatus.UNFINISHED
        end
        local task = {}
        task.id = tonumber(config2[1].id)
        task.itemList = {}
        task.giftState = state
        result.taskList[tostring(config2[1].id)] = task
    end
    info.taskList = result.taskList
    taskInfo[group] = info
    setplaydef(actor, AngelWeapon.var.ANGEL_WEAPON_INFO,taskInfo)
    --通知客户端
    sendluamsg(actor,LuaMessageIdToClient.RES_ANGEL_WEAPON_TASK_CHANGE,result)
end

--请求领取任务奖励
function AngelWeapon.receiveTaskReward(actor, msgData)
    if not AngelWeapon.isActivityOpen(actor) then
        tipinfo(actor,"活动未开启！")
        return
    end
    local taskId = msgData.taskId
    local group = AngelWeapon.getGroup(actor)
    local taskInfo = getplaydef(actor, AngelWeapon.var.ANGEL_WEAPON_INFO)
    if not taskInfo then
        tipinfo(actor,"任务不存在！")
        return
    end
    local info = taskInfo[group]
    if not info or not info.taskList then
        tipinfo(actor,"任务不存在！")
        return
    end
    local task = info.taskList[tostring(taskId)]
    if not task then
        tipinfo(actor,"任务不存在！")
        return
    end
    if task.giftState == AngelWeapon.TaskStatus.RECEIVED then
        tipinfo(actor,"请勿重复领取！")
        return
    end
    if task.giftState ~= AngelWeapon.TaskStatus.CAN_RECEIVE then
        tipinfo(actor,"任务未完成！")
        return
    end
    --发奖励
    local config = ConfigDataManager.getTable("cfg_activity_angelWeapon","id",task.id)
    local reward = string.toIntIntMap(config[1].angelweaponreward,"#","|")
    for k,v in pairs(reward) do
        additemtobag(actor, k, v,0,9999,ItemActionProxy.ANGELWEAPON)
    end
    --奖励弹框
    sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, reward)
    --修改状态
    task.giftState = AngelWeapon.TaskStatus.RECEIVED
    info.taskList[tostring(taskId)] = task
    taskInfo[group] = info
    setplaydef(actor, AngelWeapon.var.ANGEL_WEAPON_INFO,taskInfo)
    --通知客户端
    AngelWeapon.updateTaskInfo(actor)
end

--活动结束时邮件发放奖励
function AngelWeapon.sendReward()
    local allRoleInfos = getallrolesummaryinfos()
    if allRoleInfos == nil or next(allRoleInfos) == nil then
        return
    end
    for _, roleInfo in pairs(allRoleInfos) do
        local reward = {}
        local actor = roleInfo["actor"]
        local group = AngelWeapon.checkOpenTime (actor)
        if not group then
            return
        end
        local taskInfo = getplaydef(actor, AngelWeapon.var.ANGEL_WEAPON_INFO)
        if not (taskInfo == nil or taskInfo == "") then
            local info = taskInfo[group] or {}
            if table.count(info) > 0 and info.taskList ~= nil then
                for _,task in pairs(info.taskList) do
                    if task.giftState == AngelWeapon.TaskStatus.CAN_RECEIVE then
                        local config = ConfigDataManager.getTable("cfg_activity_angelWeapon","id",task.id)
                        string.putIntIntMap(reward,config[1].angelweaponreward,"#","|")
                    end
                end
            end
            taskInfo[group] = nil
            if table.count(reward) > 0 then
                sendconfigmailbyrid(actor,getbaseinfo(actor,"rid"), MailConfig.END_TIME_ANGEL_WEAPON_REWARD, reward, "")
            end
            setplaydef(actor, AngelWeapon.var.ANGEL_WEAPON_INFO,taskInfo)
        end
    end
end

CareerTask = {}
local this = {}

local _free_att_point_id = 10070001
local _table_name = "cfg_task_career"
local _CareerLevelMapCacheKey = "G$_CareerLevelMapCacheKey"

function CareerTask.initLevelCareerRange()
    this.initLevelCareerRange()
end

function this.acceptCareerTask(actor, taskId)
    local config = ConfigDataManager.getById(_table_name, taskId)
    if table.isEmpty(config) then
        tipinfo(actor, "无法领取该任务")
        return
    end

    local condition = config.pretask
    if checkcondition(actor, condition) ~= "1" then
        tipinfo(actor, "领取条件不满足，无法领取该任务")
        return
    end

    local minLevel = string.tonumber(config.levelmin)
    local level = getbaseinfo(actor, "level")
    if level < minLevel then
        tipinfo(actor, "等级不足，无法领取任务")
        return
    end

    if not string.checkBaseCareer(actor, config.careerlimit) then
        tipinfo(actor, "职业不符，无法领取任务")
        return
    end

    local ids = {}
    local completedTaskIds = getcompletedtasklist(actor)
    if table.notEmpty(completedTaskIds) then
        for _, v in pairs(completedTaskIds) do
            table.insert(ids, v.taskid)
        end
    end
    local taskinfoList = gettasklist(actor)
    if table.notEmpty(taskinfoList) then
        for _, v in pairs(taskinfoList) do
            table.insert(ids, v.taskid)
        end
    end

    local postTaskIds = string.split(config.posttask, "#")
    for _, v in pairs(postTaskIds) do
        local careerLimit = ConfigDataManager.getTableValue("cfg_task", "careerLimit", "id", v)
        if string.checkBaseCareer(actor, careerLimit) and not array.contains(ids, tonumber(v)) then
            onlyaccepttask(actor, v)
        end
    end
end

function this.initLevelCareerRange()
    local maxLv = 999
    local ids,configCache = {},{}
    local configList = ConfigDataManager.getTable("cfg_level_career")
    for _, config in pairs(configList) do
        table.insert(ids, tonumber(config.id))
        configCache[tonumber(config.id)] = config
    end

    local taskId = 0
    local att = ""
    local attbonus = ""

    local finalCache = {}
    for i = 1, maxLv do
        if array.contains(ids, i) then
            local config = configCache[i]
            taskId = string.tonumber(config.taskid)
            att = config.att
            attbonus = string.tonumber(config.attbonus)
        end

        local defConfig = {
            id = i,
            taskid = taskId,
            att = att,
            attbonus = attbonus
        }
        finalCache[i] = defConfig
    end
    setsysvar(_CareerLevelMapCacheKey, finalCache)
end

function this.getGlobalCache()
    return getsysvar(_CareerLevelMapCacheKey)
end

function CareerTask.roleLevelUp(actor, level, oldlevel)
    if oldlevel >= level then
        return
    end

    local baseCareer = getbaseinfo(actor, "getbasecareer")
    local cache = this.getGlobalCache()

    local extraPoint = 0
    for i = oldlevel + 1, level do
        local config = cache[i]
        if table.isEmpty(config) then
            goto continue
        end

        -- 是否已完成x任务
        local taskId = config.taskid
        if taskId < 1 then
            goto continue
        end

        local conditionStr = string.format("checkFinishTask[%d]", taskId)
        if checkcondition(actor, conditionStr) ~= "1" then
            goto continue
        end
        local careerAtt = string.toIntIntMap(config.att)
        extraPoint = extraPoint + string.tonumber(careerAtt[baseCareer])

        ::continue::
    end
    if extraPoint > 0 then
        local items = {[_free_att_point_id] = extraPoint}
        Bag.sendRewardsWithoutPanel(actor, items, "等级升级补额外自由属性点", 0)
    end
end

function CareerTask.transferCareer(actor)
    local level = getbaseinfo(actor, "level")
    local baseCareer = getbaseinfo(actor, "getbasecareer")
    local careerRank = getbaseinfo(actor, "getcareerrank")
    local levelLimit = ConfigDataManager.getIntTableValue("cfg_career", "level", "baseCareer", baseCareer, "careerRank",careerRank)
    if levelLimit == 0 or levelLimit >= level then
        return
    end

    local extraPoint = 0
    local cache = this.getGlobalCache()
    
    for i = levelLimit + 1, level do
        local config = cache[i]
        -- 是否已完成x任务
        if table.isEmpty(config) then
            goto continue
        end
        local taskId = config.taskid
        if taskId < 1 then
            goto continue
        end

        local conditionStr = string.format("checkFinishTask[%d]", taskId)
        if checkcondition(actor, conditionStr) ~= "1" then
            goto continue
        end
        extraPoint = extraPoint + string.tonumber(config.attbonus)

        ::continue::
    end

    if extraPoint > 0 then
        local items = {[_free_att_point_id] = extraPoint}
        Bag.sendRewardsWithoutPanel(actor, items, "转职后补额外自由属性点", 0)
    end
end

MessageRouter:register(LuaMessageIdToSever.REQ_ACCEPT_PLAYER_CAREER_TASK, this.acceptCareerTask)

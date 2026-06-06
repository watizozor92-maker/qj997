-- 拍脸预告
FaceShootPreview = {}

-- @description 玩家登录
-- @param 玩家对象
-- @return
function FaceShootPreview.RoleLogin(actor)
    local level = getbaseinfo(actor, "level")
    local severOpenDays = getbaseinfo(actor, "serveropendays")
    --玩家今日不提示的预告变量
    local previewVar = getplaydef(actor, PlayerDefKey.FACE_SHOOT_PREVIEW_NO_TIPS)
    if type(previewVar) ~= "table" then
        previewVar = {}
    end
    local nowMillis = getbaseinfo("now")
    local tables = ConfigDataManager.getList("cfg_system_foreshow")
    if type(tables) ~= "table" then
        return
    end
    local previewList = {}
    for _, oneData in pairs(tables) do
        local cfgId = tonumber(oneData["id"])
        local needLevel = tonumber(oneData["needlevel"]) or 0
        local offLevel = tonumber(oneData["offlevel"]) or 0
        local needDay = tonumber(oneData["needday"]) or 0
        local endTime = tonumber(oneData["endtime"]) or 0

        if needDay > 0 and needLevel > 0 and cfgId then
            if level >= needLevel and needDay <= severOpenDays and severOpenDays < endTime and (offLevel == 0 or level < offLevel) then
                local taskStr = oneData["needtask"]
                local completedConfigs = getplaydef(actor, PlayerDefKey.FACE_SHOOT_PREVIEW_COMPLETED)
                if type(completedConfigs) ~= "table" then
                    completedConfigs = {}
                end
                local lastTime = previewVar[cfgId]

                if (taskStr ~= "" and table.contains(completedConfigs, cfgId)) or taskStr == "" then
                    if lastTime == nil or (datediff(lastTime, nowMillis, "day") >= 1) then
                        table.insert(previewList, cfgId)
                        if lastTime then
                            previewVar[cfgId] = nil
                        end
                    end
                end
            end
        end
    end
    --持久化变量
    setplaydef(actor, PlayerDefKey.FACE_SHOOT_PREVIEW_NO_TIPS, previewVar)
    if table.count(previewList) > 0 then
        --发送响应
        sendluamsg(actor, LuaMessageIdToClient.RES_FSPREVIEW_LIST, previewList)
    end
end

-- @description 取消今日提示
-- @param 玩家对象；cfg_system_foreshow表id
-- @return
function FaceShootPreview.ReqCancelTodayPreview(actor, cfgId)
    cfgId = tonumber(cfgId)
    if cfgId == nil then
        return
    end
    local previewVar = getplaydef(actor, PlayerDefKey.FACE_SHOOT_PREVIEW_NO_TIPS)
    if type(previewVar) ~= "table" then
        return
    end
    local nowMillis = getbaseinfo("now")
    previewVar[cfgId] = nowMillis
    setplaydef(actor, PlayerDefKey.FACE_SHOOT_PREVIEW_NO_TIPS, previewVar)
end

-- @description 完成指定任务发送拍脸
-- @param 玩家对象；任务id
-- @return
function FaceShootPreview.TaskCompleted(actor, taskId)
    local cache = getsysvar(SystemVarConst.FACE_SHOOT_PREVIEW_TASK_CACHE)
    if type(cache) ~= "table" then
        return
    end
    taskId = tonumber(taskId)
    if taskId == nil then
        return
    end
    local configId = cache[taskId]
    if configId == nil then
        return
    end
    local level = getbaseinfo(actor, "level")
    local severOpenDays = getbaseinfo(actor, "serveropendays")
    local previewVar = getplaydef(actor, PlayerDefKey.FACE_SHOOT_PREVIEW_NO_TIPS)
    if type(previewVar) ~= "table" then
        previewVar = {}
    end
    local nowMillis = getbaseinfo("now")
    local oneData = ConfigDataManager.getById("cfg_system_foreshow", configId)
    if oneData == nil then
        return
    end
    local needLevel = tonumber(oneData["needlevel"]) == nil and 0 or tonumber(oneData["needlevel"])
    local offLevel = tonumber(oneData["offlevel"]) == nil and 0 or tonumber(oneData["offlevel"])
    local needDay = tonumber(oneData["needday"]) == nil and 0 or tonumber(oneData["needday"])
    local endTime = tonumber(oneData["endtime"]) == nil and 0 or tonumber(oneData["endtime"])
    -- 全部得大于0
    if needDay <= 0 or needLevel <= 0 then
        return
    end

    -- 判断等级和开服天数
    if level < needLevel or (offLevel ~= 0 and level >= offLevel) or needDay > severOpenDays or severOpenDays >= endTime then
        return
    end

    -- 获取今日不再提示的时间
    local lastTime = previewVar[configId]
    if lastTime ~= nil then
        -- 勾选了今日不再提示
        local dayDiff = datediff(lastTime, nowMillis, "day")
        -- 如果时间和当前不是同一天
        if dayDiff >= 1 then
            -- 取消勾选
            previewVar[configId] = nil
            --持久化变量
            setplaydef(actor, PlayerDefKey.FACE_SHOOT_PREVIEW_NO_TIPS, previewVar)
        else
            return
        end
    end

    --todo 存储任务信息，登录的时候用
    local completedTask = getplaydef(actor, PlayerDefKey.FACE_SHOOT_PREVIEW_COMPLETED)
    if type(completedTask) ~= "table" then
        completedTask = {}
    end
    if not table.contains(completedTask, configId) then
        table.insert(completedTask, configId)
        setplaydef(actor, PlayerDefKey.FACE_SHOOT_PREVIEW_COMPLETED, completedTask)
    end
    --发送响应
    sendluamsg(actor, LuaMessageIdToClient.RES_FSPREVIEW_LIST, { configId })
end

-- @description 做个缓存，优化性能
function FaceShootPreview.CacheConfig()
    local tables = ConfigDataManager.getList("cfg_system_foreshow")
    if type(tables) ~= "table" then
        return
    end
    local cache = {}
    for _, oneData in pairs(tables) do
        local cfgId = tonumber(oneData["id"])
        local taskStr = oneData["needtask"]
        if taskStr ~= "" then
            local taskList = string.split(taskStr, "#")
            for _, taskId in ipairs(taskList) do
                cache[tonumber(taskId)] = cfgId
            end
        end
    end
    setsysvar(SystemVarConst.FACE_SHOOT_PREVIEW_TASK_CACHE, cache)
end

-- 注册登录事件
LoginEventListerTable:eventLister("0", "拍脸预告", FaceShootPreview.RoleLogin, 9999)

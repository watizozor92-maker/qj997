--- 幸运周末运营活动
WeekActives = {}
local this = {}

local CONDITION = {
    TIME_TYPE = 971,
    MAIN_DURATION_TYPE = 980,
    SUB_DURATION_TYPE = 981,
    CHECK_WEEK = 991,
}

CURRENT_WEEKEN_ACTIVE = "R$_CURRENT_WEEKEN_ACTIVE"

-- @description 判断子活动是否在关闭状态
-- @param 活动类型
-- @return
function WeekActives.judgeActiveClose(actor, activeType)
    local currentActive = getsysvar(actor, CURRENT_WEEKEN_ACTIVE)
    if table.isNullOrEmpty(currentActive) then
        return false
    end
    local currentTime = getbaseinfo(actor, "now")
    if currentTime > currentActive.mainActive.closeTime then
        return false
    end
    local mainGroup = currentActive.mainActive.mainGroup
    local closeCondition = ConfigDataManager.getTableValue("cfg_OperateActivity_subActivity", "closeCondition",
        "mainGroup", mainGroup, "subType", activeType)
    if closeCondition == nil then
        return false
    end
    return ConditionManager.Check(actor, closeCondition)
end

-- 登录时整理主活动信息
function this.getMainActive(actor, currentActive, currentActiveInfoTable)
    local currentActiveInfo = currentActiveInfoTable[1]
    local currentTime = getbaseinfo(actor, "now")
    local isShow = true

    if currentTime > currentActive.mainActive.closeTime then
        isShow = false
    end

    local mainActiveInfo = {
        activeId = tonumber(currentActiveInfo.id),
        mainGroup = tonumber(currentActiveInfo.maingroup),
        startTime = currentActive.mainActive.startTime,
        closeTime = currentActive.mainActive.closeTime,
        isShow = isShow
    }
    return mainActiveInfo
end

-- 玩家登录时向玩家发送当前运营活动信息
function WeekActives.openActive(actor, currentActive)
    local activeInfo = {}
    if table.isNullOrEmpty(currentActive) then
        currentActive = getsysvar(actor, CURRENT_WEEKEN_ACTIVE)
    end
    if table.isNullOrEmpty(currentActive) then
        return activeInfo
    end
    local mainActive = currentActive.mainActive
    local currentActiveInfoTable = ConfigDataManager.getTable("cfg_OperateActivity_week", "id", mainActive.activeId)
    if table.isNullOrEmpty(currentActiveInfoTable) then
        error("主活动配置错误")
        return activeInfo
    end
    local mainActiveInfo = this.getMainActive(actor, currentActive, currentActiveInfoTable)
    activeInfo["mainActive"] = mainActiveInfo
    if not mainActiveInfo.isShow then
        -- 当前主活动不展示，不用去整理字子活动信息
        sendluamsg(actor, LuaMessageIdToClient.RES_WEEKEN_GIFT, activeInfo)
        return activeInfo
    end
    local subActive = currentActive.subActive
    local allSubActiveInfo = {}
    if not table.isNullOrEmpty(subActive) then
        for id, subActiveDetail in pairs(subActive) do
            local subActivity = ConfigDataManager.getTable("cfg_OperateActivity_subActivity", "id", subActiveDetail.id)
            if subActiveDetail.openState and not subActiveDetail.closeState and not table.isNullOrEmpty(subActivity) then
                local subActiveInfo = {}
                subActiveInfo["id"] = subActiveDetail.id
                subActiveInfo["openTime"] = subActiveDetail.openTime
                table.insert(allSubActiveInfo, subActiveInfo)
            end
        end
    end
    activeInfo["subActive"] = allSubActiveInfo
    WeekActives.subActiveDetail(actor, activeInfo, currentActive)
    sendluamsg(actor, LuaMessageIdToClient.RES_WEEKEN_GIFT, activeInfo)
    return activeInfo
end

-- 玩家打开子活动页签
function WeekActives.openSubActive(actor, msgData)
    local activeInfo = {}
    local currentActive = getsysvar(actor, CURRENT_WEEKEN_ACTIVE)
    if table.isNullOrEmpty(currentActive) then
        return
    end
    local mainActive = currentActive.mainActive
    local currentActiveInfoTable = ConfigDataManager.getTable("cfg_OperateActivity_week", "id", mainActive.activeId)
    if table.isNullOrEmpty(currentActiveInfoTable) then
        error("主活动配置错误")
        return
    end
    local mainActiveInfo = this.getMainActive(actor, currentActive, currentActiveInfoTable)
    activeInfo["mainActive"] = mainActiveInfo

    local subActive = currentActive.subActive
    local allSubActiveInfo = {}
    local currentTime = getbaseinfo(actor, "now")
    if not table.isNullOrEmpty(subActive) then
        for id, subActiveDetail in pairs(subActive) do
            local subActivity = ConfigDataManager.getTable("cfg_OperateActivity_subActivity", "id", subActiveDetail.id)
            if currentTime > subActiveDetail.openTime and currentTime < subActiveDetail.closeTime and not table.isNullOrEmpty(subActivity) then
                local subActiveInfo = {}
                subActiveInfo["id"] = subActiveDetail.id
                subActiveInfo["openTime"] = subActiveDetail.openTime
                table.insert(allSubActiveInfo, subActiveInfo)
            end
        end
    end
    activeInfo["subActive"] = allSubActiveInfo

    local subType = msgData.subType
    WeekActives.subActiveDetail(actor, activeInfo, currentActive, subType)
    sendluamsg(actor, LuaMessageIdToClient.RES_WEEKEN_GIFT, activeInfo)
end

-- 获取子活动类型
function WeekActives.subActiveDetail(actor, activeInfo, currentActive, subType)
    if subType ~= nil then
        this.setSubActiveInfo(actor, subType, currentActive, activeInfo)
    else
        -- 没有类型的时候就放全部活动数据
        local allSubActiveInfo = ConfigDataManager.getTable("cfg_OperateActivity_subActivity", "mainGroup",
            activeInfo.mainActive.mainGroup)
        if not table.isNullOrEmpty(allSubActiveInfo) then
            for _, subActiveInfo in pairs(allSubActiveInfo) do
                this.setSubActiveInfo(actor, tonumber(subActiveInfo.subtype), currentActive, activeInfo)
            end
        end
    end
end

-- 设置子活动信息
function this.setSubActiveInfo(actor, subType, currentActive, activeInfo)
    if WeekActives.judgeActiveClose(actor, subType) then
        -- 活动开启
        if subType == ACTIVE_TYPE.DIRECT then
            -- 直购开启
            local directInfo = WeekDirectPurchase.reqRechargeAction(actor, currentActive.mainActive.mainGroup)
            activeInfo["directSubActive"] = directInfo
        elseif subType == ACTIVE_TYPE.TOTAL_RECHARGE then
            -- 累充活动
            local directInfo = WeekAccumulatedRecharge.reqRechargeAction(actor, currentActive.mainActive.mainGroup)
            activeInfo["totalSubActive"] = directInfo
        elseif subType == ACTIVE_TYPE.PRIZE_DRAW then
            -- 轮盘抽奖
            local turntableRaffleInfo = WeekTurntableRaffle.getPanelInfo(actor, currentActive.mainActive.mainGroup)
            activeInfo["turntableRaffleActive"] = turntableRaffleInfo
        elseif subType == ACTIVE_TYPE.DIAMOND_PACK then
            -- 钻石礼包
            local diamondPackInfo = WeekDiamondPack.reqRechargeAction(actor, currentActive.mainActive.mainGroup)
            activeInfo["diamondPackInfo"] = diamondPackInfo
        elseif subType == ACTIVE_TYPE.CONSUMER_RANK then
            -- 消费排行
            local diamondPackInfo = WeekConsumerRank.reqRechargeAction(actor, currentActive.mainActive.mainGroup)
            activeInfo["consumerRank"] = diamondPackInfo
        end
    end
end

-- 不同的时间段检查当前有没有活动要开启
function WeekActives.checkActive()
    local currentActive = getsysvar(CURRENT_WEEKEN_ACTIVE)
    if table.isNullOrEmpty(currentActive) then
        -- 检测当前有没有新活动开始
        this.mainActiveChange()
        return
    end
    local currentTime = getbaseinfo("now")
    local mainActive = currentActive["mainActive"]
    if mainActive.closeTime ~= nil and mainActive.closeTime > currentTime then
        -- 当前活动还没有结束，无需添加新的活动
        local send = this.checkSubActiveChange(currentActive)
        setsysvar(CURRENT_WEEKEN_ACTIVE, currentActive)
        if send then
            this.activeChange(currentActive)
        end
        return
    end
    this.checkSubActiveChange(currentActive)
    setsysvar(CURRENT_WEEKEN_ACTIVE, currentActive)
    this.mainActiveChange()
end

-- 主活动变化
function this.mainActiveChange()
    local mainActiveTable = ConfigDataManager.getList("cfg_OperateActivity_week")
    if table.isNullOrEmpty(mainActiveTable) then
        -- 没有主活动信息，不用检查
        return
    end
    local canOpenActive = {}
    for _, mainActive in pairs(mainActiveTable) do
        local openCondition = mainActive.opencondition
        if openCondition ~= nil then
            if ConditionManager.Check(111, openCondition) then
                print("可以开启活动信息", mainActive.id)
                table.insert(canOpenActive, mainActive)
            end
        end
    end
    if table.isNullOrEmpty(canOpenActive) then
        return
    end
    this.openMainActive(canOpenActive)
    this.activeChange()
end

-- 检查子活动是否变化
function this.checkSubActiveChange(currentActive)
    local allSubActiveInfo = currentActive.subActive
    local send = false
    local currentTime = getbaseinfo("now")
    local currentSecTime = tonumber(getbaseinfo("nowsec"))
    if not table.isNullOrEmpty(allSubActiveInfo) then
        for _, subActiveInfo in pairs(allSubActiveInfo) do
            -- 判断当前子活动有没有关闭
            if not subActiveInfo.closeState and subActiveInfo.closeTime <= currentTime then
                subActiveInfo.closeState = true
                -- this.closeSubActive(subActiveInfo.id)
                send = true
            end
        end
    end
    local mainGroup = currentActive.mainActive.mainGroup
    local allSubActiveTable = ConfigDataManager.getTable("cfg_OperateActivity_subActivity", "mainGroup", mainGroup)
    if not table.isNullOrEmpty(allSubActiveTable) then
        for _, subActiveTable in pairs(allSubActiveTable) do
            local have = false
            for _, subActiveInfo in pairs(allSubActiveInfo) do
                if tonumber(subActiveInfo.id) == tonumber(subActiveTable.id) then
                    have = true
                end
            end
            if not have and ConditionManager.Check(111, subActiveTable.opencondition) then
                -- 开启子活动
                jprint("allSubActiveTable", subActiveTable)
                local subActiveInfo = {}
                subActiveInfo["id"] = subActiveTable.id
                subActiveInfo["openTime"] = currentSecTime * 1000
                local durationDay = this.getSubActiveDay(subActiveTable.closecondition)
                local closeTime = TimeUtil.addDayEnd(currentSecTime, durationDay - 1)
                subActiveInfo["closeTime"] = closeTime * 1000
                subActiveInfo["openState"] = true
                subActiveInfo["closeState"] = false
                table.insert(allSubActiveInfo, subActiveInfo)
                send = true
            end
        end
    end
    currentActive.subActive = allSubActiveInfo
    return send
end

function this.closeSubActive(subActiveId)
    -- 处理子活动关闭信息
    local tableValue = ConfigDataManager.getTable("cfg_OperateActivity_subActivity", "id", subActiveId)
    if not table.isNullOrEmpty(tableValue) then
        -- 活动类型
        local subType = tonumber(tableValue[1]["subtype"])
        if string.isNullOrEmpty(subType) then
            error("子活动id为空:", subActiveId)
            return
        end
        -- 主活动组
        local mainGroup = tonumber(tableValue[1]["maingroup"])
        if string.isNullOrEmpty(mainGroup) then
            error("子活动的主组号为空:", subActiveId)
            return
        end
        if subType == ACTIVE_TYPE.DIRECT then
            -- 直购
            WeekDirectPurchase.closeActive(mainGroup)
        elseif subType == ACTIVE_TYPE.TOTAL_RECHARGE then
            -- 累充
            WeekAccumulatedRecharge.closeActive(mainGroup)
        elseif subType == ACTIVE_TYPE.PRIZE_DRAW then
            -- 抽奖
            WeekTurntableRaffle.sendUnReceiveRewards(mainGroup)
        elseif subType == ACTIVE_TYPE.DIAMOND_PACK then
            -- 钻石礼包
            WeekDiamondPack.closeActive(mainGroup)
        elseif subType == ACTIVE_TYPE.CONSUMER_RANK then
            -- 消费排名
            WeekConsumerRank.closeActive(mainGroup)
        end
    end
end

-- 开启主活动
function this.openMainActive(canOpenActive)
    local currentTime = getbaseinfo("nowsec")
    if table.isNullOrEmpty(canOpenActive) then
        return
    end
    local maxLevel = 0
    local mainActive = {}
    for _, openActive in pairs(canOpenActive) do
        if maxLevel < tonumber(openActive.priority) then
            maxLevel = tonumber(openActive.priority)
            mainActive = openActive
        end
    end
    if table.isNullOrEmpty(mainActive) then
        return
    end
    info("可以开启主活动Id:" .. mainActive.id .. "当前时间是：" .. currentTime)
    local currentActive = {}
    -- 添加主活动
    local mainActiveInfo = {}
    -- 活动开启
    local mainActiveId = mainActive.id
    mainActiveInfo["activeId"] = mainActiveId
    mainActiveInfo["mainGroup"] = mainActive.maingroup
    local currentData = TimeUtil.timeToDate(currentTime)
    local mainStartTime = TimeUtil.earlyOneMorning(currentData.year, currentData.month, currentData.day)
    mainActiveInfo["startTime"] = mainStartTime * 1000
    local durationDay = 0
    local closeCondition = mainActive.closecondition
    local groupStrs = string.split(closeCondition, '/')
    for _, groupStr in pairs(groupStrs) do
        local singleStrs = string.split(groupStr, '&')
        for _, singleStr in pairs(singleStrs) do
            local singleStrInfo = string.split(singleStr, '#')
            if tonumber(singleStrInfo[1]) == CONDITION.MAIN_DURATION_TYPE then
                durationDay = tonumber(singleStrInfo[3])
                local closeTime = TimeUtil.addDayEnd(mainStartTime, durationDay - 1)
                mainActiveInfo["closeTime"] = closeTime * 1000
            end
        end
    end
    currentActive["mainActive"] = mainActiveInfo

    -- 整理页签到期时间
    local mainGroup = tonumber(mainActive.maingroup)
    local subActivityTable = ConfigDataManager.getTable("cfg_OperateActivity_subActivity", "mainGroup", mainGroup)
    if table.isNullOrEmpty(subActivityTable) then
        currentActive["subActive"] = {}
        setsysvar(CURRENT_WEEKEN_ACTIVE, currentActive)
        return
    end
    local subActive = {}
    for k, subActivityInfo in pairs(subActivityTable) do
        jprint("subActivityInfo", subActivityInfo)
        local subActiveInfo = {}
        local openCondition = subActivityInfo.opencondition
        if ConditionManager.Check(111, openCondition) then
            subActiveInfo["id"] = tonumber(subActivityInfo.id)
            local currentTime = getbaseinfo("nowsec")
            subActiveInfo["openTime"] = currentTime * 1000
            local durationDay = this.getSubActiveDay(subActivityInfo.closecondition)
            local closeTime = TimeUtil.addDayEnd(currentTime, durationDay - 1)
            subActiveInfo["closeTime"] = closeTime * 1000
            subActiveInfo["openState"] = true
            subActiveInfo["closeState"] = false
            table.insert(subActive, subActiveInfo)
        end
    end
    currentActive["subActive"] = subActive
    setsysvar(CURRENT_WEEKEN_ACTIVE, currentActive)
end

-- 获取子活动持续天数
function this.getSubActiveDay(closeCondition)
    if string.isNullOrEmpty(closeCondition) then
        return 0
    end
    local groupStrs = string.split(closeCondition, '/')
    for k, groupStr in pairs(groupStrs) do
        local singleStrs = string.split(groupStr, '&')
        for k, singleStr in pairs(singleStrs) do
            local singleStrInfo = string.split(singleStr, '#')
            if tonumber(singleStrInfo[1]) == CONDITION.SUB_DURATION_TYPE then
                return tonumber(singleStrInfo[4])
            end
        end
    end
    return 0
end

-- 给当前在线玩家发送活动已经改变
function this.activeChange(currentActive)
    local allRoleInfos = getallrolesummaryinfos(1)
    local activeInfo = {}
    if not table.isNullOrEmpty(allRoleInfos) then
        for k, roleInfo in pairs(allRoleInfos) do
            local actor = roleInfo["actor"]
            if table.isNullOrEmpty(activeInfo) then
                activeInfo = WeekActives.openActive(actor, currentActive)
            else
                sendluamsg(actor, LuaMessageIdToClient.RES_WEEKEN_GIFT, activeInfo)
            end
        end
    end
end

--- 获取当前活动期数
function WeekActives.getCurrentMainGroup(actor)
    local currentActive = getsysvar(actor, CURRENT_WEEKEN_ACTIVE)
    if table.isNullOrEmpty(currentActive) then
        return 0
    end
    return tonumber(currentActive.mainActive.mainGroup)
end

--- 合服时清除活动信息
function WeekActives.combine()
    setsysvar(CURRENT_WEEKEN_ACTIVE, {})
end

function clearactive1(actor)
    setsysvar(actor, CURRENT_WEEKEN_ACTIVE, {})
end

function lookactive1(actor)
    local activity = getsysvar(actor, CURRENT_WEEKEN_ACTIVE)
    lg("activity", activity)
end

function checkactive1(actor)
    WeekActives.checkActive()
end

function sendmsgactive1(actor)
    WeekActives.openSubActive(actor, 111)
end

LoginEventListerTable:eventLister("0", "幸运周末框架", WeekActives.openActive)

--- 运营活动
OperationalActivities = {}
local this = {}

local CONDITION = {
    TIME_TYPE = 971,
    MAIN_DURATION_TYPE = 980,
    SUB_DURATION_TYPE = 981,
    CHECK_WEEK = 991,
}

ACTIVE_TYPE = {
    DIRECT = 1, -- 直购
    TOTAL_RECHARGE = 2, -- 累充
    PRIZE_DRAW = 3, -- 抽奖
    DIAMOND_PACK = 4, -- 钻石礼包
    CONSUMER_RANK = 5, -- 消费排行
}

CURRENT_ACTIVE = "R$_CURRENT_ACTIVE"

-- @description 判断子活动是否在关闭状态
-- @param 活动类型
-- @return
function OperationalActivities.judgeActiveClose(actor,activeType)
    local currentActive = getsysvar(actor, CURRENT_ACTIVE)
    if table.isNullOrEmpty(currentActive) then
        return false
    end
    local currentTime = getbaseinfo(actor,"now")
    if currentTime > currentActive.mainActive.closeTime then
        return false
    end
    local mainGroup = currentActive.mainActive.mainGroup
    local closeCondition = ConfigDataManager.getTableValue("cfg_OperateActivity_subActivity","closeCondition","mainGroup",mainGroup,"subType",activeType)
    if closeCondition == nil then
        return false
    end
    return ConditionManager.Check(actor, closeCondition)
end

-- 登录时整理主活动信息
function this.getMainActive(actor,currentActive,currentActiveInfoTable)
    local currentActiveInfo = currentActiveInfoTable[1]
    local currentTime = getbaseinfo(actor,"now")
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
function OperationalActivities.openActive(actor,currentActive)
    local activeInfo = {}
    if table.isNullOrEmpty(currentActive) then
        currentActive = getsysvar(actor, CURRENT_ACTIVE)
    end
    if table.isNullOrEmpty(currentActive) then
        -- sendluamsg(actor,LuaMessageIdToClient.RES_MAIN_ACTIVE_INFO,activeInfo)
        return activeInfo
    end
    local mainActive = currentActive.mainActive
    local currentActiveInfoTable = ConfigDataManager.getTable("cfg_OperateActivity_all","id",mainActive.activeId)
    if table.isNullOrEmpty(currentActiveInfoTable) then
        error("主活动配置错误")
        -- sendluamsg(actor,LuaMessageIdToClient.RES_MAIN_ACTIVE_INFO,activeInfo)
        return activeInfo
    end
    local mainActiveInfo = this.getMainActive(actor,currentActive,currentActiveInfoTable)
    activeInfo["mainActive"] = mainActiveInfo
    if not mainActiveInfo.isShow then
        -- 当前主活动不展示，不用去整理字子活动信息
        sendluamsg(actor,LuaMessageIdToClient.RES_MAIN_ACTIVE_INFO,activeInfo)
        return activeInfo
    end
    local subActive = currentActive.subActive
    local allSubActiveInfo = {}
    local currentTime = getbaseinfo(actor,"now")
    if not table.isNullOrEmpty(subActive) then
        for id, subActiveDetail in pairs(subActive) do
            local subActivity = ConfigDataManager.getTable("cfg_OperateActivity_subActivity","id",subActiveDetail.id)
            if subActiveDetail.openState and not subActiveDetail.closeState and not table.isNullOrEmpty(subActivity) then
                local subActiveInfo = {}
                subActiveInfo["id"] = subActiveDetail.id
                subActiveInfo["openTime"] = subActiveDetail.openTime
                table.insert(allSubActiveInfo,subActiveInfo)
            end
        end
    end
    activeInfo["subActive"] = allSubActiveInfo
    OperationalActivities.subActiveDetail(actor,activeInfo,currentActive)
    sendluamsg(actor,LuaMessageIdToClient.RES_MAIN_ACTIVE_INFO,activeInfo)
    return activeInfo
end

-- 玩家打开子活动页签
function OperationalActivities.openSubActive(actor,msgData)
    local activeInfo = {}
    local currentActive = getsysvar(actor, CURRENT_ACTIVE)
    if table.isNullOrEmpty(currentActive) then
        return
    end
    local mainActive = currentActive.mainActive
    local currentActiveInfoTable = ConfigDataManager.getTable("cfg_OperateActivity_all","id",mainActive.activeId)
    if table.isNullOrEmpty(currentActiveInfoTable) then
        error("主活动配置错误")
        return
    end
    local mainActiveInfo = this.getMainActive(actor,currentActive,currentActiveInfoTable)
    activeInfo["mainActive"] = mainActiveInfo

    local subActive = currentActive.subActive
    local allSubActiveInfo = {}
    local currentTime = getbaseinfo(actor,"now")
    if not table.isNullOrEmpty(subActive) then
        for id, subActiveDetail in pairs(subActive) do
            local subActivity = ConfigDataManager.getTable("cfg_OperateActivity_subActivity","id",subActiveDetail.id)
            if currentTime > subActiveDetail.openTime and currentTime < subActiveDetail.closeTime and not table.isNullOrEmpty(subActivity) then
                local subActiveInfo = {}
                subActiveInfo["id"] = subActiveDetail.id
                subActiveInfo["openTime"] = subActiveDetail.openTime
                table.insert(allSubActiveInfo,subActiveInfo)
            end
        end
    end
    activeInfo["subActive"] = allSubActiveInfo

    local subType = msgData.subType
    OperationalActivities.subActiveDetail(actor,activeInfo,currentActive,subType)
    sendluamsg(actor,LuaMessageIdToClient.RES_MAIN_ACTIVE_INFO,activeInfo)
end

-- 获取子活动类型
function OperationalActivities.subActiveDetail(actor,activeInfo,currentActive,subType)
    if subType ~= nil then
        this.setSubActiveInfo(actor,subType,currentActive,activeInfo)
    else
        -- 没有类型的时候就放全部活动数据
        local allSubActiveInfo = ConfigDataManager.getTable("cfg_OperateActivity_subActivity","mainGroup",activeInfo.mainActive.mainGroup)
        if not table.isNullOrEmpty(allSubActiveInfo) then
            for _, subActiveInfo in pairs(allSubActiveInfo) do
                this.setSubActiveInfo(actor,tonumber(subActiveInfo.subtype),currentActive,activeInfo)
            end
        end
    end
end

-- 设置子活动信息
function this.setSubActiveInfo(actor,subType,currentActive,activeInfo)
    if OperationalActivities.judgeActiveClose(actor, subType) then
        -- 活动开启
        if subType == ACTIVE_TYPE.DIRECT then
            -- 直购开启
            local directInfo = DirectPurchase.reqRechargeAction(actor,currentActive.mainActive.mainGroup)
            activeInfo["directSubActive"] = directInfo
        elseif subType == ACTIVE_TYPE.TOTAL_RECHARGE then
            -- 累充活动
            local directInfo = AccumulatedRecharge.reqRechargeAction(actor,currentActive.mainActive.mainGroup)
            activeInfo["totalSubActive"] = directInfo
        elseif subType == ACTIVE_TYPE.PRIZE_DRAW then
            -- 轮盘抽奖
            local turntableRaffleInfo = TurntableRaffle.getPanelInfo(actor, currentActive.mainActive.mainGroup)
            activeInfo["turntableRaffleActive"] = turntableRaffleInfo
        elseif subType == ACTIVE_TYPE.DIAMOND_PACK then
            -- 钻石礼包
            local diamondPackInfo = DiamondPack.reqRechargeAction(actor,currentActive.mainActive.mainGroup)
            activeInfo["diamondPackInfo"] = diamondPackInfo
        elseif subType == ACTIVE_TYPE.CONSUMER_RANK then
            -- 消费排行
            local diamondPackInfo = ConsumerRank.reqRechargeAction(actor,currentActive.mainActive.mainGroup)
            activeInfo["consumerRank"] = diamondPackInfo
        end
    end
end

-- 不同的时间段检查当前有没有活动要开启
function OperationalActivities.checkActive()
    local currentActive = getsysvar(CURRENT_ACTIVE)
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
        setsysvar(CURRENT_ACTIVE,currentActive)
        if send then
            this.activeChange(currentActive)
        end
        return
    end
    this.checkSubActiveChange(currentActive)
    setsysvar(CURRENT_ACTIVE,currentActive)
    this.mainActiveChange()
end

-- 主活动变化
function this.mainActiveChange()
    local mainActiveTable = ConfigDataManager.getList("cfg_OperateActivity_all")
    if table.isNullOrEmpty(mainActiveTable) then
        -- 没有主活动信息，不用检查
        return
    end
    local canOpenActive = {}
    for _, mainActive in pairs(mainActiveTable) do
        local openCondition = mainActive.opencondition
        if openCondition ~= nil then
            if ConditionManager.Check(111, openCondition) then
                print("可以开启活动信息",mainActive.id)
                table.insert(canOpenActive,mainActive)
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
    local allSubActiveTable = ConfigDataManager.getTable("cfg_OperateActivity_subActivity","mainGroup",mainGroup)
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
                jprint("allSubActiveTable",subActiveTable)
                local subActiveInfo = {}
                subActiveInfo["id"] = subActiveTable.id
                subActiveInfo["openTime"] = currentSecTime * 1000
                local durationDay = this.getSubActiveDay(subActiveTable.closecondition)
                local closeTime = TimeUtil.addDayEnd(currentSecTime,durationDay - 1)
                subActiveInfo["closeTime"] = closeTime * 1000
                subActiveInfo["openState"] = true
                subActiveInfo["closeState"] = false
                table.insert(allSubActiveInfo,subActiveInfo)
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
            error("cfg_OperateActivity_subActivity subType is null id:", subActiveId)
            return
        end
        -- 主活动组
        local mainGroup = tonumber(tableValue[1]["maingroup"])
        if string.isNullOrEmpty(mainGroup) then
            error("cfg_OperateActivity_subActivity mainGroup is null id:", subActiveId)
            return
        end
        if subType == ACTIVE_TYPE.DIRECT then
            -- 直购
            DirectPurchase.closeActive(mainGroup)
        elseif subType == ACTIVE_TYPE.TOTAL_RECHARGE then
            -- 累充
            OperationalActivities.closeActive(mainGroup)
        elseif subType == ACTIVE_TYPE.PRIZE_DRAW then
            -- 抽奖
            TurntableRaffle.sendUnReceiveRewards(mainGroup)
        elseif subType == ACTIVE_TYPE.DIAMOND_PACK then
            -- 钻石礼包
            DiamondPack.closeActive(mainGroup)
        elseif subType == ACTIVE_TYPE.CONSUMER_RANK then
            -- 消费排名
            ConsumerRank.closeActive(mainGroup)
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
    local mainStartTime = TimeUtil.earlyOneMorning(currentData.year,currentData.month,currentData.day)
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
    local subActivityTable = ConfigDataManager.getTable("cfg_OperateActivity_subActivity","mainGroup",mainGroup)
    if table.isNullOrEmpty(subActivityTable) then
        currentActive["subActive"] = {}
        setsysvar(CURRENT_ACTIVE,currentActive)
        return
    end
    local currentTime = getbaseinfo("nowsec")
    local subActive = {}
    for k, subActivityInfo in pairs(subActivityTable) do
        jprint("subActivityInfo",subActivityInfo)
        local subActiveInfo = {}
        local openCondition = subActivityInfo.opencondition
        if ConditionManager.Check(111, openCondition) then
            subActiveInfo["id"] = tonumber(subActivityInfo.id)
            local currentTime = getbaseinfo("nowsec")
            subActiveInfo["openTime"] = currentTime * 1000
            local durationDay = this.getSubActiveDay(subActivityInfo.closecondition)
            local closeTime = TimeUtil.addDayEnd(currentTime,durationDay - 1)
            subActiveInfo["closeTime"] = closeTime * 1000
            subActiveInfo["openState"] = true
            subActiveInfo["closeState"] = false
            table.insert(subActive,subActiveInfo)
        end
    end
    currentActive["subActive"] = subActive
    setsysvar(CURRENT_ACTIVE,currentActive)
end



--- 累充关闭
function OperationalActivities.closeActive(mainGroup)
    local allRoleInfos = getallrolesummaryinfos()
    local rechargeTable = ConfigDataManager.getTable("cfg_rechargeRccrued","mainGroup",mainGroup)
    if not table.isNullOrEmpty(allRoleInfos) and not table.isNullOrEmpty(rechargeTable) then
        local specialCondition = ConfigDataManager.getTableValue("cfg_OperateActivity_subActivity","specialCondition","mainGroup",mainGroup,"subType",ACTIVE_TYPE.TOTAL_RECHARGE)
        for k, roleInfo in pairs(allRoleInfos) do
            local actor = roleInfo["actor"]
            if ConditionManager.Check(actor, specialCondition) then
                local item = {}
                local money = this.totalMoney(actor,rechargeTable[1].type)
                for k, rechargeInfo in pairs(rechargeTable) do
                    local countInfo = CountManager.getCount(actor,rechargeInfo.countkey)
                    if not table.isNullOrEmpty(countInfo) and countInfo.total > countInfo.count and money >= tonumber(rechargeInfo.amount) then
                        local count = countInfo.total - countInfo.count
                        for i = 1, count do
                            string.putIntIntMap(item, rechargeInfo.reward, "#", "|")
                        end
                    end
                end
                if not table.isNullOrEmpty(item) then
                    sendconfigmailbyrid(actor, actor:toString(), 900003, item)
                end
            end
        end
    end
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
                activeInfo = OperationalActivities.openActive(actor,currentActive)
            else
                sendluamsg(actor,LuaMessageIdToClient.RES_MAIN_ACTIVE_INFO,activeInfo)
            end
        end
    end
end


--- 获取当前活动期数
function OperationalActivities.getCurrentMainGroup(actor)
    local currentActive = getsysvar(actor,CURRENT_ACTIVE)
    if table.isNullOrEmpty(currentActive) then
        return 0
    end
    return tonumber(currentActive.mainActive.mainGroup)
end

--- 合服时清除活动信息
function OperationalActivities.combine()
    setsysvar(CURRENT_ACTIVE,{})
end

function clearactive(actor)
    setsysvar(actor,CURRENT_ACTIVE,{})
end

function lookactive(actor)
    local activity = getsysvar(actor,CURRENT_ACTIVE)
    jprint("activity",activity)
end

function checkactive(actor)
    OperationalActivities.checkActive()
end

function sendmsgactive(actor)
    OperationalActivities.openSubActive(actor,111)
end

LoginEventListerTable:eventLister("0", "运营框架", OperationalActivities.openActive)

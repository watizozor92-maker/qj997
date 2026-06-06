-- 卡利马神庙副本
KalimaTemp = {}
local this = {}
--- 小红点id
this.RedId = 101

local REP_ID_KEY = "COMBO_ID"
local MAX_LEVEL = "T$_COMBO_TEST_MAX_LEVEL"
local SWEEP_DATE_KEY = "T$_KALIMA_SWEEP_DATA"


-- 玩家扫荡的数据
local ActorSweepData = {}
ActorSweepData.__index = ActorSweepData
function ActorSweepData.new()
    local instance = setmetatable({}, ActorSweepData)
    -- 上次刷新时间
    instance.lastFlushSec = getbaseinfo("nowsec")
    -- 已扫荡次数
    instance.sweepTimes = 0
    return instance
end

function ActorSweepData.get(actor)
    return getplaydef(actor, SWEEP_DATE_KEY)
end

function ActorSweepData.set(actor, sweepData)
    setplaydef(actor, SWEEP_DATE_KEY, sweepData)
end

function ActorSweepData.reset(actor)
    local sweepData = ActorSweepData.new()
    setplaydef(actor, SWEEP_DATE_KEY, sweepData)
end

function KalimaTemp.Login(actor)
    local sweepData = getplaydef(actor, SWEEP_DATE_KEY)
    if table.isNullOrEmpty(sweepData) then
        ActorSweepData.reset(actor)
        return
    end
    local lastFlushSec = sweepData.lastFlushSec
    local nowsec = getbaseinfo("nowsec")
    if not TimeUtil.isSameDay(lastFlushSec, nowsec) then
        ActorSweepData.reset(actor)
        return
    end
end

function KalimaTemp.ZeroEvent(actor)
    ActorSweepData.reset(actor)
end

-- 卡利马神庙面板
function KalimaTemp.ReqComboTestPanelInfo(actor)
    local leftCount = getleftcountofactivity(actor, DuplicateType.KALIMA_TEMP)
    local leftSweepCount = this.getLeftSweepTime(actor)
    local maxLevel = getplaydef(actor, MAX_LEVEL)
    if string.isNullOrEmpty(maxLevel) then
        local res = {
            id             = 0,
            level          = 0,
            count          = leftCount,
            leftSweepCount = leftSweepCount,
        }
        sendluamsg(actor, LuaMessageIdToClient.RES_KALIMA_TEMP_PANEL_INFO, res)
        return
    end

    local id = tonumber(KalimaTemp.level2ConfigId(maxLevel))
    local res = {
        id             = id,
        level          = maxLevel,
        count          = leftCount,
        leftSweepCount = leftSweepCount,
    }
    sendluamsg(actor, LuaMessageIdToClient.RES_KALIMA_TEMP_PANEL_INFO, res)
end

-- 进入卡利马神庙
function KalimaTemp.ReqEnterComboTest(actor, configId)
    --个人进入
    if DuplicateCommon.CheckEnterConditonCommon(actor, configId) ~= EnterLimitResultConst.ALLOW then
        return
    end
    if not KalimaTemp.CheckEnterCondition(actor, configId) then
        return
    end
    --寻找是否有可进入的副本，如果没有创建副本
    local mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, true)
    local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    -- 扣除门票和次数
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    reduceactivitytimes(actor, activityId)
    this.deleteTicket(actor, configId, 1)
    --回蓝回血
    DuplicateCommon.RecoverHPMP(actor)
    --进入副本
    enterduplicate(actor, mapId, x, y)
end

-- 校验关卡等级
function KalimaTemp.CheckEnterCondition(actor, configId)
    local repLevel = ConfigDataManager.getTableValue("cfg_rep", "repLevel", "id", configId)
    local maxLevel = getplaydef(actor, MAX_LEVEL)
    repLevel = tonumber(repLevel)
    if (maxLevel == nil and repLevel > 1) or (maxLevel ~= nil and (tonumber(repLevel) - 1) > maxLevel) then
        tipinfo(actor, "请先挑战前边没有挑战过的关卡")
        return false
    end
    return true
end

-- @description 初始化副本数据
-- @param 副本地图id；cfg_rep的id
-- @return
function KalimaTemp.InitComboTest(mapId, configId)
    --当前任务信息
    local taskId = ConfigDataManager.getTableValue("cfg_rep", "repTarget", "id", configId)
    local taskInfo = DuplicateCommon.GenDupTaskInfoCommon(taskId)
    info(gameDebug.toStrings(" ", "我要测试", taskInfo))
    setenvirvar(mapId, DuplicateVarConst.KALIMA_TEMP_TASK_INFO, taskInfo)
end

-- @description 任务阶段更新响应
-- @param 玩家对象；地图唯一id
-- @return
function KalimaTemp.ResTaskPhaseUpdate(actor, mapId)
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.KALIMA_TEMP_TASK_INFO)
    if table.isNullOrEmpty(taskInfo) then
        return
    end
    local taskId = taskInfo[1]
    local taskType = taskInfo[2]
    local taskCount = taskInfo[3]
    local nowCount = taskInfo[4]
    local targetId = taskInfo[5]
    local response = {}
    response["phase"] = 1
    response["taskId"] = taskId
    response["nowCount"] = nowCount
    response["totalCount"] = taskCount
    -- 协议
    sendluamsg(actor, LuaMessageIdToClient.RES_CALIMA_TEMP_TASK_UPDATE, response)
end

-- @description 通知地图玩家任务阶段更新响应
-- @param 玩家对象；地图唯一id
-- @return
function KalimaTemp.ResAllTaskPhaseUpdate(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        KalimaTemp.ResTaskPhaseUpdate(actor, mapId)
    end
end

-- 卡利马神庙红点
function KalimaTemp.CheckEnter(actor)
    local leftCount = getleftcountofactivity(actor, DuplicateType.KALIMA_TEMP)
    if leftCount <= 0 then
        return false
    else
        return true
    end
end

function KalimaTemp.refreshRedDot(actor)
    RedPoint.sendOneRedPoint(actor, this.RedId, KalimaTemp.CheckEnter(actor) or false)
end

function KalimaTemp.loginRedDot(red_data, actor)
    if KalimaTemp.CheckEnter(actor) then
        red_data[this.RedId] = true
    end
end

function KalimaTemp.ComboStateUpdate(system, id, state, nextStateStartTime, configId)
    if state == DuplicateState.PREPARE then
        KalimaTemp.InitComboTest(id, configId)
        --把副本的配置ID保存起来
        setenvirvar(id, REP_ID_KEY, configId)
    elseif state == DuplicateState.FIGHT then
        --战斗阶段，刷怪
        local monsterId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", configId)
        --jprint("【卡利马神庙】战斗阶段开始刷怪",configId,id,state)
        DuplicateCommon.DupGenMonsterCommon(id, monsterId)
        -- setenvirvar(id, REWARD, false)
        KalimaTemp.resCurrencyStateInfo(state, id)
    elseif state == DuplicateState.FINISH then
        KalimaTemp.resCurrencyStateInfo(state, id)
    end
end

-- @description 响应给客户端当前阶段
-- @param 玩家对象；地图id
-- @return
function KalimaTemp.resCurrencyStateInfo(state, mapId, actor)
    local dupInfo = getduplicate(mapId)
    local players = table.getValue(dupInfo, "players")

    local configId = table.getValue(dupInfo, "dupcfgid")
    local nextStateStartTime = table.getValue(dupInfo, "nextstatetime")
    local ok = false
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.KALIMA_TEMP_TASK_INFO)
    if taskInfo[3] == taskInfo[4] and state == DuplicateState.FINISH then
        ok = true
    end

    local res = { state, tostring(nextStateStartTime), configId, ok }
    if actor ~= nil then
        sendluamsg(actor, LuaMessageIdToClient.KALIMA_TEMP_STATE, res)
    else
        for _, actor in ipairs(players) do
            sendluamsg(actor, LuaMessageIdToClient.KALIMA_TEMP_STATE, res)
        end
    end
end

-- 进入卡利马神庙后
function KalimaTemp.AfterEnterComboTest(actor, mapId, state, nextStateStartTime, configId)
    KalimaTemp.resCurrencyStateInfo(state, mapId, actor)
    KalimaTemp.ResTaskPhaseUpdate(actor, mapId)
end

-- @description 刷怪
-- @param 地图唯一id；刷怪表id
-- @return
function KalimaTemp.GenMonsterComboTest(mapId, genMonCfgId)
    --战斗阶段才可以刷怪
    local dupInfo = getduplicate(mapId)
    if dupInfo["state"] ~= DuplicateState.FIGHT then
        return
    end
    DuplicateCommon.DupGenMonsterCommon(mapId, genMonCfgId)
end

-- 卡利马神庙怪物死亡
function KalimaTemp.ComboTestMonsterDie(mapId, killer, monCfgId, monActor)
    -- 更新任务信息
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.KALIMA_TEMP_TASK_INFO)
    local taskType = taskInfo[2]
    if taskType == DuplicateTaskType.KILL_TARGET_MONSTER then
        local taskCount = taskInfo[3]
        local oldKillCount = taskInfo[4]
        local targetId = taskInfo[5]
        if monCfgId == targetId then
            local newKillCount = oldKillCount + 1
            if newKillCount >= taskCount then
                -- 完成任务
                -- 设置最大关卡
                local cfgId = getenvirvar(mapId, REP_ID_KEY)
                --记录下当前的关卡层级
                local level = KalimaTemp.config2Level(cfgId)
                local maxLevel = getplaydef(killer, MAX_LEVEL)
                if maxLevel == nil or maxLevel < level then
                    setplaydef(killer, MAX_LEVEL, level)
                end
                local players = getmapplayer(mapId)
                for _, actor in pairs(players) do
                    DuplicateCommon.FinishDupActivity(actor, cfgId)
                end
                setduplicatestate(mapId, SetDuplicateStateConst.TO_FINISH)
            end
            KalimaTemp.ResAllTaskPhaseUpdate(mapId)
        end
    end
end

-- 扣除门票
function this.deleteTicket(actor, configId, count)
    local ItemConfig = ConfigDataManager.getTableValue("cfg_rep", "itemId", "id", configId)
    if not string.isNullOrEmpty(ItemConfig) then
        local costItem = string.toIntIntMap(ItemConfig, "#", "|")

        for itemId, needCount in pairs(costItem) do
            Bag.cost(actor, tonumber(itemId), tonumber(needCount) * count, 0, 9999, '卡利马神庙')
        end
    end
end

function KalimaTemp.quitDuplicate(actor, cfgId)
    quitduplicate(actor)
end

-- 卡利马神庙扫荡
function KalimaTemp.sweepThroughDungeons(actor, configId)
    -- 判断是否可以参加本关卡利马神庙
    if not KalimaTemp.CheckEnterCondition(actor, configId) then
        error(actor:toSting().."卡利马扫荡失败，未通关此关卡！".."cfgId:"..configId)
        return
    end
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    if string.isNullOrEmpty(configId) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT387)
        return
    end
    -- 判断次数
    local leftCount = getleftcountofactivity(actor, activityId)
    if leftCount < 1 then
        tipinfo(actor,"卡利马扫荡失败，剩余次数不足！".."leftCount:"..leftCount)
        return
    end
    -- 扫荡次数
    local sweepData = ActorSweepData.get(actor)
    local sweepTimes = sweepData.sweepTimes
    local maxSweepTimes = this.getMaxSweepTimes()
    if sweepTimes >= maxSweepTimes then
        tipinfo(actor,"卡利马扫荡失败，扫荡次数不足！".."已扫荡次数:"..sweepTimes)
        return
    end
    -- 判断消耗道具
    local sweepCfgTable = ConfigDataManager.getTableFirst("cfg_rep_QuestSweep", "repid", configId)
    if table.isNullOrEmpty(sweepCfgTable) then
        error(actor:toString().."卡利马扫荡失败，消耗道具配置错误！".."cfgId:"..configId)
        return
    end
    local costItems = string.toIntIntMap(sweepCfgTable.deplete, "#", "|")
    local extraItems = string.toIntIntMap(sweepCfgTable.extra, "#", "|")
    table.mergeAdd(costItems, extraItems)
    for itemId, itemCount in pairs(costItems) do
        -- local ownCount = getbagitemcountbyid(actor, itemId)
        -- if ownCount < itemCount then
        --     return
        -- end
        if not Bag.checkItem(actor, itemId, itemCount) then
            error(actor:toString() .. "卡利马扫荡失败，消耗道具不足！" .. "cfgId:" .. configId)
            return
        end
    end
    -- 扣除次数
    reduceactivitytimes(actor, activityId)
    sweepData.sweepTimes = sweepTimes + 1
    ActorSweepData.set(actor, sweepData)
    -- 扣除消耗道具
    Bag.costMap(actor, costItems, '卡利马神庙')
    -- for key, value in pairs(costItems) do
    --     removeitemfrombag(actor, key, value, 0, 9999, '卡利马神庙')
    -- end
    -- 发奖
    local reward = string.toIntIntMap(sweepCfgTable.drop, "#", "|")
    Bag.sendRewardsByBind(actor, reward, "1", "卡利马神庙")
    info("玩家扫荡卡利马神庙成功", actor:toString(), configId)
    DuplicateCommon.FinishDupActivity(actor, configId)
    KalimaTemp.ReqComboTestPanelInfo(actor)
    KalimaTemp.refreshRedDot(actor)
end

function this.getLeftSweepTime(actor)
    local maxSweepTimes = this.getMaxSweepTimes()
    local sweepData = ActorSweepData.get(actor)
    if table.isNullOrEmpty(sweepData) then
        return maxSweepTimes
    end
    return maxSweepTimes - sweepData.sweepTimes
end

function this.getMaxSweepTimes()
    return tonumber(ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id",
        RepGlobalConfig.KALIMA_TEMP.SWEEP_TIME))
end

-- 根据等级获取配置id
function KalimaTemp.level2ConfigId(level)
    local cfgId = ConfigDataManager.getTableValue("cfg_rep", "id", "type", DuplicateType.KALIMA_TEMP, "replevel", level)
    return cfgId
end

-- 根据副本配置获取副本等级
function KalimaTemp.config2Level(configId)
    local level = ConfigDataManager.getTableValue("cfg_rep", "replevel", "id", configId)
    if level == nil or level == "" then
        return nil
    end
    return tonumber(level)
end


ZeroEventListerTable:eventLister("0", "卡利马神庙", KalimaTemp.ZeroEvent, 999)
LoginEventListerTable:eventLister("0", "卡利马神庙", KalimaTemp.Login, 100)
RedPointEventListerTable:eventLister("0", "卡利马神庙", KalimaTemp.loginRedDot, 9999)

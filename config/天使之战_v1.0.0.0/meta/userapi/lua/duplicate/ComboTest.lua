-- 连击试炼副本
ComboTest = {}
local this = {}
--- 小红点id
this.RedId = 101

local MONSTER_ID_KEY = "COMBO_MONSTER"
local REP_ID_KEY = "COMBO_ID"
local COMBO_ADD_COUNT = "T$COMBO_ADD_COUNT"
local MAX_LEVEL = "T$_COMBO_TEST_MAX_LEVEL"


-- 连击技能面板
function ComboTest.ReqComboTestPanelInfo(actor)
    local totalCount = 0
    local numberAdd = ConfigDataManager.getTableValue("cfg_activity_rule", "numberAdd", "id", DuplicateType.COMBO_TEST)
    if not string.isNullOrEmpty(numberAdd) then
        local activeCount = string.split(numberAdd, "#")
        totalCount = totalCount + tonumber(activeCount[1])
    end
    local addCountInfo = getplaydef(actor, COMBO_ADD_COUNT)
    if not table.isNullOrEmpty(addCountInfo) then
        totalCount = totalCount + tonumber(addCountInfo.addCount)
    end

    local privilegeOpen, comboNum = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.COMBO_NUM)
    if privilegeOpen then

        totalCount = totalCount + tonumber(comboNum)
    end

    local maxLevel = getplaydef(actor, MAX_LEVEL)
    if string.isNullOrEmpty(maxLevel) then
        local res = {
            id    = 0,
            level = 0,
            count = totalCount
        }
        sendluamsg(actor, LuaMessageIdToClient.COMBO_TEST_PANEL_INFO, res)
        return
    end

    local id = tonumber(ComboTest.level2ConfigId(maxLevel))
    local res = {
        id    = id,
        level = maxLevel,
        count = totalCount
    }
    sendluamsg(actor, LuaMessageIdToClient.COMBO_TEST_PANEL_INFO, res)
end


-- 进入连击试炼
function ComboTest.ReqEnterComboTest(actor, configId)
    --个人进入
    if DuplicateCommon.CheckEnterConditonCommon(actor, configId) ~= EnterLimitResultConst.ALLOW then
        return
    end
    if not ComboTest.CheckEnterCondition(actor, configId) then
        return
    end

    local maxHP = getattrinfo(actor, "maxHP")
    local maxMP = getattrinfo(actor, "maxMP")
    sethp(actor, maxHP)
    setmp(actor, maxMP)

    --寻找是否有可进入的副本，如果没有创建副本
    local mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, true)
    local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    --回蓝回血
    DuplicateCommon.RecoverHPMP(actor)
    --进入副本
    enterduplicate(actor, mapId, x, y)
end

-- 校验连击技能等级是否可以进入
function ComboTest.CheckEnterCondition(actor, configId)
    local repLevel = ConfigDataManager.getTableValue("cfg_rep", "repLevel", "id", configId)
    local maxLevel = getplaydef(actor, MAX_LEVEL)
    repLevel = tonumber(repLevel)
    if (maxLevel == nil and repLevel > 1) or (maxLevel ~= nil and (tonumber(repLevel) - 1) > maxLevel) then
        tipinfo(actor, "请先挑战前边没有挑战过的关卡")
        return false
    end
    local skill = ConfigDataManager.getTableValue("cfg_rep", "skill", "id", configId)
    local comboSkill = getrolefield(actor, "role.roleskill.comboskill")
    local skillLv = comboSkill.skillLv
    local skillCfgId = comboSkill.skillCfgId
    if not string.isNullOrEmpty(skill) then
        local skillCfg = string.split(skill, "|")
        for index, skillInfo in pairs(skillCfg) do
            local skillDetail = string.split(skillInfo, "#")
            if tonumber(skillDetail[2]) == skillCfgId and tonumber(skillDetail[3]) <= skillLv then
                return true
            end
        end
    else
        return true
    end
    tipinfo(actor, "连击技能等级不够")
    return false
end

-- @description 初始化副本数据
-- @param 副本地图id；cfg_rep的id
-- @return
function ComboTest.InitComboTest(mapId, configId)
    --当前任务信息
    local taskId = ConfigDataManager.getTableValue("cfg_rep", "repTarget", "id", configId)
    local taskInfo = DuplicateCommon.GenDupTaskInfoCommon(taskId)
    taskInfo[5] = 0
    setenvirvar(mapId, DuplicateVarConst.COMBO_TEST_TASK_INFO, taskInfo)
end


-- @description 任务阶段更新响应
-- @param 玩家对象；地图唯一id
-- @return
function ComboTest.ResTaskPhaseUpdate(actor, mapId)
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.COMBO_TEST_TASK_INFO)
    if table.isNullOrEmpty(taskInfo) then
        return
    end
    local nowPhase = taskInfo[1]
    local taskId = taskInfo[2]
    local totalCount = taskInfo[3]
    local nowCount = taskInfo[4]
    local response = {}
    response["phase"] = nowPhase
    response["taskId"] = taskId
    response["nowCount"] = nowCount
    response["totalCount"] = totalCount
    -- 协议
    sendluamsg(actor, LuaMessageIdToClient.RES_COMBO_TES_TASK_UPDATE, response)
end


-- @description 通知地图玩家任务阶段更新响应
-- @param 玩家对象；地图唯一id
-- @return
function ComboTest.ResAllTaskPhaseUpdate(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        ComboTest.ResTaskPhaseUpdate(actor, mapId)
    end
end

-- 连击试炼红点
function ComboTest.CheckEnter(actor)
    local leftCount = getleftcountofactivity(actor, DuplicateType.COMBO_TEST)
    if leftCount <= 0 then
        return false
    else
        return true
    end
end

function ComboTest.refreshRedDot(actor)
    RedPoint.sendOneRedPoint(actor, this.RedId, ComboTest.CheckEnter(actor) or false)
end

function ComboTest.loginRedDot(red_data, actor)
    if ComboTest.CheckEnter(actor) then
        red_data[this.RedId] = true
    end
end

function ComboTest.ComboStateUpdate(system, id, state, nextStateStartTime, configId)

    if state == DuplicateState.PREPARE then
        ComboTest.InitComboTest(id, configId)
    elseif state == DuplicateState.FIGHT then
        --战斗阶段，刷怪
        local monsterId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", configId)
        --jprint("【连击试炼】战斗阶段开始刷怪",configId,id,state)
        DuplicateCommon.DupGenMonsterCommon(id, monsterId)
        --记录当前是那波怪物
        setenvirvar(id, MONSTER_ID_KEY, monsterId)
        --把副本的配置ID保存起来
        setenvirvar(id, REP_ID_KEY, configId)
        -- setenvirvar(id, REWARD, false)
        ComboTest.resCurrencyStateInfo(state, id)

    elseif state == DuplicateState.FINISH then
        local dupInfo = getduplicate(id)
        local players = table.getValue(dupInfo, "players")
        for _, actor in ipairs(players) do
            ComboTest.ResTaskPhaseUpdate(actor, id)
        end

        local taskInfo = getenvirvar(id, DuplicateVarConst.COMBO_TEST_TASK_INFO)
        if taskInfo[3] ~= taskInfo[4] then
            local configId = getenvirvar(id, REP_ID_KEY)
            for _, actor in ipairs(players) do
                this.lowestRewardByLevel(actor, configId)
                DuplicateCommon.ReqQuitDuplicate(actor)
                this.deleteTicket(actor, configId, 1)
            end
            return
        end
        ComboTest.resCurrencyStateInfo(state, id)
    elseif state == DuplicateState.CLOSED then
        --local reward = getenvirvar(id, REWARD)
        --if reward == nil or reward then
        --    return
        --end
        local dupInfo = getduplicate(id)
        local players = table.getValue(dupInfo, "players")
        if table.isNullOrEmpty(players) then
            return
        end
        for _, actor in ipairs(players) do
            ComboTest.rewardByLevel(actor, configId)
        end
    end
end


-- @description 响应给客户端当前阶段
-- @param 玩家对象；地图id
-- @return
function ComboTest.resCurrencyStateInfo(state, mapId, actor)
    local dupInfo = getduplicate(mapId)
    local players = table.getValue(dupInfo, "players")

    local configId = table.getValue(dupInfo, "dupcfgid")
    local nextStateStartTime = table.getValue(dupInfo, "nextstatetime")
    local ok = false
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.COMBO_TEST_TASK_INFO)
    if taskInfo[3] == taskInfo[4] and state == DuplicateState.FINISH then
        ok = true
    end

    local res = { state, tostring(nextStateStartTime), configId, ok }
    if actor ~= nil then
        sendluamsg(actor, LuaMessageIdToClient.COMBO_TEST_STATE, res)
    else
        for _, actor in ipairs(players) do
            sendluamsg(actor, LuaMessageIdToClient.COMBO_TEST_STATE, res)
        end
    end
end


-- 进入连击试炼后
function ComboTest.AfterEnterComboTest(actor, mapId, state, nextStateStartTime, configId)
    ComboTest.resCurrencyStateInfo(state, mapId, actor)
    ComboTest.ResTaskPhaseUpdate(actor, mapId)
end


-- @description 刷怪
-- @param 地图唯一id；刷怪表id
-- @return
function ComboTest.GenMonsterComboTest(mapId, genMonCfgId)
    --战斗阶段才可以刷怪
    local dupInfo = getduplicate(mapId)
    if dupInfo["state"] ~= DuplicateState.FIGHT then
        return
    end
    --储存当前刷怪配置
    setenvirvar(mapId, MONSTER_ID_KEY, genMonCfgId)
    DuplicateCommon.DupGenMonsterCommon(mapId, genMonCfgId)
end


-- 连击试炼怪物死亡
function ComboTest.ComboTestMonsterDie(mapId, killer, monCfgId, monActor)
    -- 更新任务信息
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.COMBO_TEST_TASK_INFO)
    local killTotal = taskInfo[4]
    local newKillTotal = killTotal + 1
    taskInfo[4] = newKillTotal
    local kill = taskInfo[5]
    taskInfo[5] = kill + 1
    -- setenvirvar(mapId, DuplicateVarConst.COMBO_TEST_TASK_INFO,taskInfo)

    -- 判断是否需要刷下一波怪物
    local monsterCfgId = getenvirvar(mapId, MONSTER_ID_KEY)
    if monsterCfgId == nil then
        return
    end
    local killCount = ConfigDataManager.getTableValue("cfg_repMonster", "kill", "id", monsterCfgId)
    if not string.isNullOrEmpty(killCount) and taskInfo[5] == tonumber(killCount) then
        -- 刷新下一波怪物
        local nextId = ConfigDataManager.getTableValue("cfg_repMonster", "nextID", "id", monsterCfgId)
        if not string.isNullOrEmpty(nextId) then
            ComboTest.GenMonsterComboTest(mapId, tonumber(nextId))
        end
        taskInfo[5] = 0
    end
    setenvirvar(mapId, DuplicateVarConst.COMBO_TEST_TASK_INFO, taskInfo)
    if newKillTotal == taskInfo[3] then
        -- 设置最大关卡
        local cfgId = getenvirvar(mapId, REP_ID_KEY)
        --记录下当前的关卡层级
        local level = ComboTest.config2Level(cfgId)
        local maxLevel = getplaydef(killer, MAX_LEVEL)
        if maxLevel == nil or maxLevel < level then
            -- 判断是否需要增加副本挑战次数
            this.addCount(killer, cfgId)
            setplaydef(killer, MAX_LEVEL, level)

        end
        setduplicatestate(mapId, SetDuplicateStateConst.TO_FINISH)
    end
    ComboTest.ResAllTaskPhaseUpdate(mapId)
end


-- 扣除门票
function this.deleteTicket(actor, configId, count)
    local itemId = ConfigDataManager.getTableValue("cfg_rep", "itemId", "id", configId)
    if not string.isNullOrEmpty(itemId) then
        local costItem = string.toIntIntMap(itemId, "#", "|")
        for itemId, needCount in pairs(costItem) do
            removeitemfrombag(actor, tonumber(itemId), tonumber(needCount) * count, 0, 9999, '连击试练')
        end
    end
end

-- 领取领奖
function ComboTest.rewardByLevel(actor, cfgId)
    local mapId = getbaseinfo(actor, "unimapid")
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", cfgId)
    reduceactivitytimes(actor, activityId, 1)
    if string.isNullOrEmpty(cfgId) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT387)
        return
    end
    local reward = ConfigDataManager.getTableValue("cfg_rep", "reward", "id", cfgId)
    if string.isNullOrEmpty(reward) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT388)
        return
    end
    local rewardMap = string.toIntIntMap(reward, "#", "|")
    if table.isNullOrEmpty(rewardMap) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT389)
        return
    end

    this.sendRewards4String(actor, rewardMap)
    DuplicateCommon.FinishDupActivity(actor, cfgId)
    this.deleteTicket(actor, cfgId, 1)
    DuplicateCommon.ReqQuitDuplicate(actor)
    ComboTest.refreshRedDot(actor)
end

function this.sendRewards4String(actor, rewardsString)
    -- local rewardsMap = string.toIntIntMap(rewardsString, "#", "|")
    -- 添加奖励到背包
    additemmaptobag(actor, rewardsString, 0, 9999, ItemActionProxy.COMBO_REWARD)
    --奖励面板通知
    sendluamsg(actor, LuaMessageIdToClient.COMBO_REWARD_PANEL, rewardsString)
end

function ComboTest.quitDuplicate(actor, cfgId)
    this.lowestRewardByLevel(actor, cfgId)
    this.deleteTicket(actor, cfgId, 1)
end

-- 发送保底奖励
function this.lowestRewardByLevel(actor, cfgId)
    -- 通关失败不扣除次数
    if string.isNullOrEmpty(cfgId) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT387)
        return
    end
    local reward = ConfigDataManager.getTableValue("cfg_rep", "lowestReward", "id", cfgId)
    if string.isNullOrEmpty(reward) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT388)
        return
    end
    local rewardMap = string.toIntIntMap(reward, "#", "|")
    if table.isNullOrEmpty(rewardMap) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT389)
        return
    end
    this.sendRewards4String(actor, rewardMap)
    ComboTest.refreshRedDot(actor)
    -- DuplicateCommon.FinishDupActivity(actor, cfgId)

    -- setenvirvar(mapId, REWARD, true)
end

-- 连击试炼人物死亡
function ComboTest.playerDie(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    --print("mapid", mapId)
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local type = dupInfo["type"]
    if type ~= DuplicateType.COMBO_TEST then
        return
    end
    -- 立即复活
    playrevive(actor, actor:toString(), 6)
end

-- 连击试炼扫荡
function ComboTest.sweepThroughDungeons(actor, configId, count)

    local isOpen, _ = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.COMBO_SWEEP_IS_OPEN)
    if not isOpen then
        tipinfo(actor, "请先开始扫荡特权")
        return
    end

    -- 判断是否可以参加本关连击试炼
    if not ComboTest.CheckEnterCondition(actor, configId) then
        return
    end

    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    reduceactivitytimes(actor, activityId, count)
    if string.isNullOrEmpty(configId) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT387)
        return
    end
    local reward = ConfigDataManager.getTableValue("cfg_rep", "reward", "id", configId)
    if string.isNullOrEmpty(reward) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT388)
        return
    end
    local rewardMap = string.toIntIntMap(reward, "#", "|")
    if table.isNullOrEmpty(rewardMap) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT389)
        return
    end
    local recordInfo = {}
    for itemId, itemCount in pairs(rewardMap) do
        recordInfo[itemId] = itemCount * count
    end
    this.sendRewards4String(actor, recordInfo)
    DuplicateCommon.FinishDupActivity(actor, configId)
    this.deleteTicket(actor, configId, count)
    DuplicateCommon.ReqGetActivityLeftCount(actor, tonumber(activityId))
    ComboTest.refreshRedDot(actor)
end

---@class ComboTest.AddCount 增加副本次数
---@field addTime number 上次刷新时间
---@field addCount number 上次增加次数

function this.addCount(actor, configId)
    local level = ComboTest.config2Level(configId)
    local maxLevel = getplaydef(actor, MAX_LEVEL)
    if string.isNullOrEmpty(maxLevel) then
        setplaydef(actor, MAX_LEVEL, level)
        local addCount = ConfigDataManager.getTableValue("cfg_rep", "numGrowth", "id", configId)
        if string.isNullOrEmpty(addCount) then
            addCount = 0
        end
        addleftcountofactivity(actor, DuplicateType.COMBO_TEST, tonumber(addCount))
        local addCountInfo = {
            addTime  = tonumber(getbaseinfo(actor, "nowsec")),
            addCount = tonumber(addCount)
        }
        setplaydef(actor, COMBO_ADD_COUNT, addCountInfo)
    elseif level <= maxLevel then
        return
    else
        local addCount = ConfigDataManager.getTableValue("cfg_rep", "numGrowth", "id", configId)
        if string.isNullOrEmpty(addCount) then
            addCount = 0
        end
        local addCountInfo = getplaydef(actor, COMBO_ADD_COUNT)
        local needAddCount = tonumber(addCount) - addCountInfo.addCount
        addleftcountofactivity(actor, DuplicateType.COMBO_TEST, tonumber(needAddCount))
        local addCountInfo = {
            addTime  = tonumber(getbaseinfo(actor, "nowsec")),
            addCount = tonumber(addCount)
        }
        setplaydef(actor, COMBO_ADD_COUNT, addCountInfo)
    end
end

function addleftcountest(actor)
    addleftcountofactivity(actor, DuplicateType.COMBO_TEST, 10)
end

-- 增加特权的时候，检查有没有增加过次数
function ComboTest.setComboTestAddCount(actor)
    ComboTest.refreshRedDot(actor)
    local addCountInfo = getplaydef(actor, COMBO_ADD_COUNT)
    if table.isNullOrEmpty(addCountInfo) then
        local addCountInfo = {
            addTime  = tonumber(getbaseinfo(actor, "nowsec")),
            addCount = 0
        }
        setplaydef(actor, COMBO_ADD_COUNT, addCountInfo)
    end
end


-- 登录时检查是否需要增加副本挑战次数
function ComboTest.login(actor)
    local addCountInfo = getplaydef(actor, COMBO_ADD_COUNT)
    if table.isNullOrEmpty(addCountInfo) then
        return
    end
    -- 校验时间
    local numberTime = ConfigDataManager.getTableValue("cfg_activity_rule", "numberTime", "id", DuplicateType.COMBO_TEST)
    if string.isNullOrEmpty(numberTime) then
        return
    end
    local flushTime = string.split(numberTime, "#")
    if tonumber(flushTime[1]) == FlushType.WEEK then
        -- 暂时不做处理
        return
    end
    if TimeUtil.dayFlush(getbaseinfo(actor, "nowsec"), addCountInfo.addTime, tonumber(flushTime[2])) then
        -- 判断是否可以加成
        ComboTest.flushCount(actor)
    end
end

-- 连击试炼刷新可以挑战次数
function ComboTest.flushCount(actor)
    local addCountInfo = getplaydef(actor, COMBO_ADD_COUNT)
    if table.isNullOrEmpty(addCountInfo) then
        return
    end
    addleftcountofactivity(actor, DuplicateType.COMBO_TEST, tonumber(addCountInfo.addCount))
    addCountInfo.addTime = getbaseinfo(actor, "nowsec")
    setplaydef(actor, COMBO_ADD_COUNT, addCountInfo)
    -- 增加特权加成

    local privilegeOpen, comboNum = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.COMBO_NUM)
    if privilegeOpen then
        -- 累加连击加成
        addleftcountofactivity(actor, DuplicateType.COMBO_TEST, tonumber(comboNum))
    end

end

-- 每个小时检查增加副本次数
function ComboTest.roleHourHeart(actor)
    local nowSec = getbaseinfo(actor, "nowsec")
    local time = TimeUtil.timeToDate(nowSec)
    local numberTime = ConfigDataManager.getTableValue("cfg_activity_rule", "numberTime", "id", DuplicateType.COMBO_TEST)
    if string.isNullOrEmpty(numberTime) then
        return
    end
    local flushTime = string.split(numberTime, "#")
    if time.hour ~= tonumber(flushTime[2]) then
        return
    end
    ComboTest.flushCount(actor)
end

-- 根据等级获取配置id
function ComboTest.level2ConfigId(level)
    local cfgId = ConfigDataManager.getTableValue("cfg_rep", "id", "type", DuplicateType.COMBO_TEST, "replevel", level)
    return cfgId
end

-- 根据副本配置获取副本等级
function ComboTest.config2Level(configId)
    local level = ConfigDataManager.getTableValue("cfg_rep", "replevel", "id", configId)
    if level == nil then
        return nil
    end
    return tonumber(level)
end

RedPointEventListerTable:eventLister("0", "连接技能", ComboTest.loginRedDot)

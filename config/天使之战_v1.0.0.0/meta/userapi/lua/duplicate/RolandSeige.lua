-- 罗兰峡谷攻城战
RolandSeige = {}

local this = {}



-- -----------------------------------------------玩家积分类-----------------------------------------------------
-- 副本玩家积分类
local RoleScoreDTO = {}
RoleScoreDTO.__index = RoleScoreDTO

-- 副本玩家积分对象
function RoleScoreDTO.new(rid, unionId)
    local instance = setmetatable({}, RoleScoreDTO)
    instance.id = rid
    instance.unionId = unionId
    instance.attackBuilding = 0 -- 攻方攻击建筑的次数
    instance.kill = 0           -- 击杀玩家的次数
    instance.hurt = 0           -- 伤害量
    instance.occupy = 0         -- 攻方占领次数
    instance.stay = 0           -- 守方停留圈内时间(秒)
    return instance
end

-- 计算玩家个人积分
function RoleScoreDTO.calTotalScore(roleScoreDTO)
    local attackScore = tonumber(ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.ATTACK_BUILDING_SCORE))
    local killScore = tonumber(ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.KILL_SCORE))
    local hurtScore = tonumber(ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.HURT_SCORE))
    local occupyScore = tonumber(ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.OCCUPY_SCORE))
    local stayScore = tonumber(ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.STAY_SCORE))
    local totalScore = roleScoreDTO.attackBuilding * attackScore
        + roleScoreDTO.kill * killScore
        + math.floor(roleScoreDTO.hurt / hurtScore)
        + roleScoreDTO.occupy * occupyScore
        + math.floor(roleScoreDTO.stay / stayScore)
    return totalScore
end

function RoleScoreDTO.calTotalScoreByActor(actor, mapId)
    local roleScoreDTO = RoleScoreDTO.get(actor, mapId)
    return RoleScoreDTO.calTotalScore(roleScoreDTO)
end

function RoleScoreDTO.get(actor, mapId)
    return getenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.PLAYER_KEY_PREFIX .. actor:toString())
end

function RoleScoreDTO.set(actor, mapId, roleScoreDTO)
    setenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.PLAYER_KEY_PREFIX .. actor:toString(), roleScoreDTO)
end

function RoleScoreDTO.addAttackBuilding(actor, mapId, times)
    local roleScoreDTO = RoleScoreDTO.get(actor, mapId)
    roleScoreDTO.attackBuilding = roleScoreDTO.attackBuilding + times
    RoleScoreDTO.set(actor, mapId, roleScoreDTO)
end

function RoleScoreDTO.addKill(actor, mapId, times)
    local roleScoreDTO = RoleScoreDTO.get(actor, mapId)
    roleScoreDTO.kill = roleScoreDTO.kill + times
    RoleScoreDTO.set(actor, mapId, roleScoreDTO)
end

function RoleScoreDTO.addHurt(actor, mapId, times)
    local roleScoreDTO = RoleScoreDTO.get(actor, mapId)
    roleScoreDTO.hurt = roleScoreDTO.hurt + times
    RoleScoreDTO.set(actor, mapId, roleScoreDTO)
end

function RoleScoreDTO.addOccuoy(actor, mapId, times)
    local roleScoreDTO = RoleScoreDTO.get(actor, mapId)
    roleScoreDTO.occupy = roleScoreDTO.occupy + times
    RoleScoreDTO.set(actor, mapId, roleScoreDTO)
end

function RoleScoreDTO.addStay(actor, mapId, times)
    local roleScoreDTO = RoleScoreDTO.get(actor, mapId)
    roleScoreDTO.stay = roleScoreDTO.stay + times
    RoleScoreDTO.set(actor, mapId, roleScoreDTO)
end

-- ---------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------- 战盟进度条类 -----------------------------------------------------
local UnionProgressDTO = {}
UnionProgressDTO.__index = UnionProgressDTO
function UnionProgressDTO.new(unionId, isMax)
    local instance = setmetatable({}, RoleScoreDTO)
    local needTime = tonumber(ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.OCCUPY_PROGRESS_TIME))
    instance.max = needTime
    if isMax then
        instance.now = needTime
    else
        instance.now = 0
    end
    instance.unionId = unionId
    local unionInfo = getunioninfo(unionId)
    instance.unionName = unionInfo.unionname
    return instance
end

function UnionProgressDTO.get(mapId, unionId)
    return getenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.UNION_SCORE_PREFIX .. tostring(unionId))
end

function UnionProgressDTO.set(mapId, unionId, occupyDTO)
    setenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.UNION_SCORE_PREFIX .. tostring(unionId), occupyDTO)
end

function UnionProgressDTO.add(mapId, unionId, add)
    local occupyDTO = UnionProgressDTO.get(mapId, unionId)
    local old = occupyDTO.now
    local new = old + add
    if new > occupyDTO.max then
        new = occupyDTO.max
    end
    occupyDTO.now = new
    UnionProgressDTO.set(mapId, unionId, occupyDTO)
    return occupyDTO
end

function UnionProgressDTO.reset(mapId, unionId)
    local occupyDTO = UnionProgressDTO.get(mapId, unionId)
    occupyDTO.now = 0
    UnionProgressDTO.set(mapId, unionId, occupyDTO)
    return occupyDTO
end

function UnionProgressDTO.isMax(progressDTO)
    if progressDTO.now >= progressDTO.max then
        return true
    end
    return false
end

-- ---------------------------------------------------------------------------------------------------------------------------------------



-- ----------------------------------------------- 战盟进度条类 -----------------------------------------------------

local LogRecord = {}
function LogRecord.new()
    local log = {}
    log.winUninId = 0
    log.winType = "" -- 占领 或 积分
    log.leader = 0
    log.personalScoreList = {}
    return log
end

function LogRecord.log(log)
    local content = "本次罗兰峡谷攻城战获胜方战盟ID：" .. log.winUninId .. "(为0表示攻城失败) ；占领类型为：" .. log.winType .. " ;占领战盟盟主为：" .. log.leader .. " ;"
    local personalScoreContent = "个人积分如下："
    for rid, score in pairs(log.personalScoreList) do
        personalScoreContent = personalScoreContent .. "{" .. rid .. "积分为：" .. score .. " };"
    end
    content = content .. personalScoreContent
    info(content)
    logop(LogOpType.ROLAND_SEIGE, content)
end

-- ---------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------- 请求 -----------------------------------------------------------------
-- 请求主面板信息
function RolandSeige.ReqMainPanel(actor)
    local res = {}
    -- 上次占领战盟信息
    local unionId = this.GetLastOccupyUnionId()
    if unionId ~= nil and unionId > 0 then
        local union = {}
        local unionInfo = getunioninfo(actor, unionId)
        union.id = unionId
        union.name = unionInfo.unionname
        -- 盟主和副盟主
        union.leader = unionInfo.leaderid
        local memberList = unionInfo.memberinfos
        local fuLeaders = {}
        for _, memberInfo in pairs(memberList) do
            if memberInfo.position == 2 then
                table.insert(fuLeaders, memberInfo.rid)
                if #fuLeaders >= 2 then
                    break
                end
            end
        end
        union.deputys = fuLeaders
        res.union = union
    end
    -- 活动开启情况，未开启发送下次开启时间戳，区分首次开启
    local openTimeSec = math.ceil(getbaseinfo(actor, "serveropentime") / 1000)
    local day, hour, minute = this.GetFirstOpenTime()
    local firstOpenSec = openTimeSec + (day - 1) * 86400 + hour * 3600 + minute * 60
    local nowSec = getbaseinfo("nowsec")
    if nowSec <= firstOpenSec then
        res.open = false
        res.nextTime = firstOpenSec
    else
        local activityInfo = getactivityinfo(DuplicateType.ROLAND_SEIGE)
        if activityInfo.open then
            res.open = true
        else
            res.nextTime = math.ceil(activityInfo.nextopentime / 1000)
            res.open = false
        end
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_ROLAND_SEIGE_MAIN_PANEL, res)
end

-- 创建攻城战副本
function RolandSeige.OpenDuplicate(system)
    if not RolandSeige.CanOpenActivity() then
        info("定时器开启罗兰攻城战，未达到首次开启要求，直接关闭此活动")
        closeactivity(DuplicateType.ROLAND_SEIGE)
        return
    end
    local oldDupId = this.GetCurrentDupId()
    if oldDupId ~= nil and oldDupId ~= 0 then
        gameDebug.assertPrintTrace(false, "罗兰峡谷攻城战副本已创建，重复创建副本！")
        return
    end
    -- 创建全服唯一的副本并储存全局变量
    local repId = tonumber(ConfigDataManager.getTableValue("cfg_rep", "id", "type", DuplicateType.ROLAND_SEIGE))
    local dupId = DuplicateCommon.CreateDupMapCommon(system, repId, true)
    this.SetCurrentDupId(dupId)
end

-- 请求进入攻城战副本
function RolandSeige.ReqEnterDupLicate(actor)
    -- 副本需要开启中
    local dupId = this.GetCurrentDupId()
    if dupId == nil or dupId == 0 then
        gameDebug.assertPrintTrace(false, actor:toString() .. "请求进入罗兰峡谷攻城战，副本未开启或已关闭！")
        return
    end
    -- 通用检查
    local repId = tonumber(ConfigDataManager.getTableValue("cfg_rep", "id", "type", DuplicateType.ROLAND_SEIGE))
    local commonCheck = DuplicateCommon.CheckEnterConditonCommon(actor, repId)
    if commonCheck ~= EnterLimitResultConst.ALLOW then
        gameDebug.assertPrintTrace(false, actor:toString() .. "请求进入罗兰峡谷攻城战，进入失败！条件不满足：" .. commonCheck)
        return
    end
    --玩家必须加入战盟
    local unionId = getbaseinfo(actor, "guildid")
    if unionId == 0 then
        gameDebug.assertPrintTrace(false, actor:toString() .. "请求进入罗兰峡谷攻城战，未处于一个战盟中！")
        return
    end
    --  盟主需要在攻城战副本中,4.3版本移除
    local unionInfo = getunioninfo(actor)
    local leaderId  = unionInfo.leaderid
    -- if tostring(leaderId) ~= actor:toString() then
    --     local leaderActor = getactor(leaderId)
    --     local leaderMapId = getbaseinfo(leaderActor, "unimapid")
    --     if dupId ~= leaderMapId then
    --         tipinfo(actor, "条件不满足！")
    --         return
    --     end
    -- end
    --  战盟人数要求
    local needSize = tonumber(ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.NEED_UNION_SIZE))
    local unionSize = unionInfo.num
    if unionSize < needSize then
        tipinfo(actor, "条件不满足！")
        info(actor:toString() .. "请求进入罗兰峡谷攻城战，战盟人数不足！当前人数：" .. unionSize .. " ;需要人数：" .. needSize)
        return
    end
    --回蓝回血
    DuplicateCommon.RecoverHPMP(actor)
    -- 进入副本
    local transferPointStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.TRANSFER_POINT)
    local transferPointStrSplit = string.split(transferPointStr, "|")
    local selfCamp = this.GetCamp(actor, dupId)
    local transferStr
    if selfCamp == RolandConst.CAMP_TYPE.ATTACK then
        transferStr = transferPointStrSplit[1]
    else
        transferStr = transferPointStrSplit[2]
    end
    local transferStrSplit = string.split(transferStr, "#")
    local x = transferStrSplit[1]
    local y = transferStrSplit[2]
    enterduplicate(actor, dupId, x, y)
end

-- 玩家是否在罗兰峡谷
function RolandSeige.IsPlayerInRoland(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return false
    end
    if dupInfo.type ~= DuplicateType.ROLAND_SEIGE then
        return false
    end
    return true
end

function RolandSeige.CanAttackRolandWall(actor, targetActor, castType, targetType)
    if RolandSeige.IsPlayerInRoland(actor) then
        if targetType == MapObjectType.MONSTER then
            local mapId = getbaseinfo(actor, "unimapid")
            if castType == MapObjectType.PET or castType == MapObjectType.PARTNER then
                local masterId = getbaseinfo(actor, "master")
                actor = getactor(masterId, mapId)
            end
            local camp = this.GetCamp(actor, mapId)
            if camp == RolandConst.CAMP_TYPE.DEFEND then
                return false
            end
        end
    end
    return true
end

-----------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------- 事件 -----------------------------------------------------------------

-- 服务器分钟心跳，用于首次开启活动
function RolandSeige.ServerMinuteHeart()
    local seconds = getbaseinfo("nowsec")
    local now = TimeUtil.timeToDate(seconds)
    local nowMin = now.min
    local nowHour = now.hour
    local day, hour, minute = this.GetFirstOpenTime()
    if nowHour == hour and nowMin == minute then
        local openDays = getbaseinfo("serveropendays")
        if day == openDays then
            -- 活动是否开启
            local activityInfo = getactivityinfo(DuplicateType.ROLAND_SEIGE)
            if activityInfo ~= nil then
                local isOpen = activityInfo.open
                if isOpen then
                    gameDebug.assertPrintTrace(false, "首次开启罗兰攻城战时活动已被开启")
                    return
                end
            end
            -- 开启活动
            openactivity(DuplicateType.ROLAND_SEIGE)
        end
    end
end

-- @description 副本阶段更新
-- @param 系统id；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)

function RolandSeige.DupStateUpdate(system, mapId, state, nextStateStartTime, configId)
    if state == DuplicateState.PREPARE then
        this.InitRolandData(mapId, configId)
        --刷怪
        local monsterId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", configId)
        local monsterList = DuplicateCommon.DupGenMonsterCommon(mapId, monsterId)
        for _, monActor in pairs(monsterList) do
            -- 设置怪物的朝向
            setmapobjectdir(monActor, -1)
        end
    elseif state == DuplicateState.FIGHT then
        this.SendAllStateInfo(mapId, configId, state, nextStateStartTime)
    elseif state == DuplicateState.FINISH then
        this.Settlement(mapId, configId)
    elseif state == DuplicateState.CLOSED then
        this.SetCurrentDupId(nil)
        closeactivity(DuplicateType.ROLAND_SEIGE)
    end
end

-- 副本3秒心跳
function RolandSeige.Dup3SecondHeart(mapId, dupConfig, state)
    if state == DuplicateState.FIGHT then
        this.SendAllTaskPanel(mapId)
    end
end

--副本1秒钟心跳
function RolandSeige.DupSecondHeart(mapId, dupConfig, state)
    if state == DuplicateState.FIGHT then
        if this.IsFinalPhase(mapId) then
            local areaStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.OCCUPY_AREA)
            local areaStrSplit = string.split(areaStr, "#")
            local x = areaStrSplit[1]
            local y = areaStrSplit[2]
            local range = areaStrSplit[3]
            -- 获取圈内所有玩家
            local idList = getobjectinmap(mapId, x, y, range)
            if #idList <= 0 then
                this.SendAllUnionProgress(mapId, nil)
                return
            end
            local unionIds = {}
            -- 如果是守方，个人加积分
            for _, rid in pairs(idList) do
                local actor = getactor(rid, mapId)
                if not isdead(actor) then
                    local camp = this.GetCamp(actor, mapId)
                    if camp == RolandConst.CAMP_TYPE.DEFEND then
                        RoleScoreDTO.addStay(actor, mapId, 1)
                    end
                    local unionId = getbaseinfo(actor, "guildid")
                    if not table.contains(unionIds, unionId) then
                        table.insert(unionIds, unionId)
                    end
                end
            end

            -- 如果全部是同一个战盟，修改战盟攻守方，增加战盟进度条
            if #unionIds == 1 then
                local unionId = unionIds[1]
                local oldUnionId = this.GetDefendUnionId(mapId)
                -- 增加进度条
                local progressDTO = UnionProgressDTO.add(mapId, unionId, 1)

                if tostring(unionId) ~= tostring(oldUnionId) then
                    -- 如果不是守方战盟，
                    --1.清空守方战盟进度条；
                    if oldUnionId ~= nil and oldUnionId > 0 then
                        UnionProgressDTO.reset(mapId, oldUnionId)
                    end
                    --2.如果self进度条满了，换成守方,清空所有其他战盟进度条
                    if UnionProgressDTO.isMax(progressDTO) then
                        this.SetDefendUnionId(mapId, unionId)
                        local allUnion = this.GetAllParticipatingUnions(mapId)
                        for _, unionId0 in pairs(allUnion) do
                            if tostring(unionId) ~= tostring(unionId0) then
                                UnionProgressDTO.reset(mapId, unionId0)
                            end
                        end
                    end
                end
                -- 通知全地图进度条信息
                this.SendAllUnionProgress(mapId, progressDTO)
            else
                -- 多个战盟在占领圈内
                this.SendAllUnionProgress(mapId, nil)
            end
        end
    end
end

-- 怪物死亡从副本中移除
function RolandSeige.MapMonsterRemove(mapId, killer, monCfgId)
    this.SendAllPlayMonsterList(mapId)
    local taskInfo = this.GetAttackTask(mapId)
    local taskId = taskInfo[1]
    local taskType = taskInfo[2]
    if taskType == DuplicateTaskType.KILL_TARGET_MONSTER then
        local totalCount = taskInfo[3]
        local nowCount = taskInfo[4]
        local targetCfg = taskInfo[5]
        if monCfgId == targetCfg then
            nowCount = nowCount + 1
        end
        if nowCount >= totalCount then
            -- 当前任务完成，设置下一个任务
            local nextId = tonumber(ConfigDataManager.getTableValue("cfg_repTask", "nextID", "id", taskId))
            if nextId ~= nil then
                local defendTaskInfo = this.GetDefendTask(mapId)
                local nextDeId = tonumber(ConfigDataManager.getTableValue("cfg_repTask", "nextID", "id", defendTaskInfo[1]))
                this.SetAttackTask(mapId, nextId)
                this.SetDefendTask(mapId, nextDeId)
                -- 更新战斗模式
                local nextTaskType = ConfigDataManager.getTableValue("cfg_repTask", "type", "id", nextId)
                if tonumber(nextTaskType) == DuplicateTaskType.ROLAND_SEIGE_OCCUPY then
                    -- 修改所有人的战斗模式
                    local allPlayers = getmapplayer(mapId)
                    for _, actor in pairs(allPlayers) do
                        setplayersetting(actor, 1, 5)
                    end
                end
                this.SendAllTaskPanel(mapId)
            end
        end
    end
end

-- @description 玩家进入副本后
-- @param 玩家对象；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function RolandSeige.AfterEnterRoland(actor, mapId, state, nextStateStartTime, configId)
    -- 记录参与的玩家
    local rid = actor:toString()
    local selfUnionId = getbaseinfo(actor, "guildid")
    local roleScoreDTO = RoleScoreDTO.get(actor, mapId)
    if roleScoreDTO == nil then
        -- 不只是积分，需要修改
        roleScoreDTO = RoleScoreDTO.new(rid, selfUnionId)
        RoleScoreDTO.set(actor, mapId, roleScoreDTO)
    end

    -- 设置战盟进度条
    local progressDTO = UnionProgressDTO.get(mapId, selfUnionId)
    if progressDTO == nil then
        local dto = UnionProgressDTO.new(selfUnionId, false)
        UnionProgressDTO.set(mapId, selfUnionId, dto)
    end

    --  修改战斗模式
    if this.IsFinalPhase(mapId) then
        setplayersetting(actor, 1, 5)
    else
        if this.GetCamp(actor, mapId) == RolandConst.CAMP_TYPE.ATTACK then
            setplayersetting(actor, 1, 11)
        else
            setplayersetting(actor, 1, 12)
        end
    end
    -- 发送副本阶段
    this.SendStateInfo(actor, configId, state, nextStateStartTime)
    -- 任务面板
    this.SendTaskPanel(actor, mapId)
    -- 怪物信息
    this.SendMonsterList(actor, mapId)
    -- if state == DuplicateState.PREPARE then

    -- elseif state == DuplicateState.FIGHT then

    -- elseif state == DuplicateState.FINISH then

    -- end
end

-- 玩家在罗兰峡谷修改战斗模式
function RolandSeige.RolandSettingChange(actor, cType, value)
    if cType ~= 1 or (not RolandSeige.IsPlayerInRoland(actor)) then
        return
    end
    local mapId = getbaseinfo(actor, "unimapid")
    if this.IsFinalPhase(mapId) then
        if value ~= 5 then
            setplayersetting(actor, 1, 5)
        end
    else
        if this.GetCamp(actor, mapId) == RolandConst.CAMP_TYPE.ATTACK then
            if value ~= 11 then
                setplayersetting(actor, 1, 11)
            end
        else
            if value ~= 12 then
                setplayersetting(actor, 1, 12)
            end
        end
    end
end



-- 玩家退出副本
function RolandSeige.OnQuitDup(actor, mapId, state, nextStateStartTime, configId)
    setplayersetting(actor, 1, 5)
end

-- 击杀玩家事件
function RolandSeige.KillPlayer(actor, diePlayer)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil or dupInfo == "" then
        return
    end
    local type = dupInfo["type"]
    if type ~= DuplicateType.ROLAND_SEIGE then
        return
    end
    RoleScoreDTO.addKill(actor, mapId, 1)
    this.SendTaskPanel(actor, mapId)
end

-- @description 玩家复活事件
-- @param 玩家对象
function RolandSeige.PlayerRelive(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local type = dupInfo["type"]
    if type ~= DuplicateType.ROLAND_SEIGE then
        return
    end
    local camp = this.GetCamp(actor, mapId)
    -- 复活后传送
    local x, y
    local taskInfo = this.GetAttackTask(mapId)
    local taskId = taskInfo[1]
    if camp == RolandConst.CAMP_TYPE.ATTACK then
        local relivePointStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.ATTACK_RELIVE_POINT)
        local relivePointStrSplit = string.split(relivePointStr, "|")

        for _, value in pairs(relivePointStrSplit) do
            local valueSplit = string.split(value, "#")
            if tonumber(valueSplit[1]) == taskId then
                x = valueSplit[1]
                y = valueSplit[2]
                break
            end
        end
    elseif camp == RolandConst.CAMP_TYPE.DEFEND then
        local relivePointStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.DEFEND_RELIVE_POINT)
        local relivePointStrSplit = string.split(relivePointStr, "#")
        x = relivePointStrSplit[1]
        y = relivePointStrSplit[2]
    end
    if x ~= nil and y ~= nil then
        maptransfer(actor, x, y, 0, 0, 0)
    else
        gameDebug.assertPrintTrace(false, actor:toString() .. "罗兰峡谷攻城战死亡复活传送未找到传送点！camp: " .. camp .. " ;taskId:" .. taskId)
    end
end

-- 攻击事件
function RolandSeige.Attack(actor, fightData)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local type = dupInfo["type"]
    if type ~= DuplicateType.ROLAND_SEIGE then
        return
    end
    local casterType = fightData.castertype
    local targetType = fightData.targettype
    if casterType ~= MapObjectType.PLAYER and casterType ~= MapObjectType.PET then
        return
    end
    if casterType == MapObjectType.PET or casterType == MapObjectType.PARTNER then
        local masterId = getbaseinfo(actor, "master")
        actor = getactor(masterId, mapId)
    end
    local camp = this.GetCamp(actor, mapId)
    if camp == RolandConst.CAMP_TYPE.ATTACK and targetType == MapObjectType.MONSTER then
        -- 增加攻方攻击建筑的次数
        RoleScoreDTO.addAttackBuilding(actor, mapId, 1)
    end
    -- 累计伤害
    RoleScoreDTO.addHurt(actor, mapId, fightData.targethurt)
    this.SendTaskPanel(actor, mapId)
end

--------------------------------------------------------------------------------------------------------------------------

-- 初始化攻城战数据
function this.InitRolandData(mapId, configId)
    -- 攻守方任务
    local firstTaskStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.FIRST_TASK)
    local firstTaskStrSplit = string.split(firstTaskStr, "#")
    local defendTask = tonumber(firstTaskStrSplit[2])
    local attackTask = tonumber(firstTaskStrSplit[1])
    this.SetAttackTask(mapId, attackTask)
    this.SetDefendTask(mapId, defendTask)
    -- 设置守方战盟
    local defendUnionId = this.GetLastOccupyUnionId()
    if defendUnionId == nil then
        defendUnionId = 0
    end
    this.SetDefendUnionId(mapId, defendUnionId)
    if defendUnionId ~= 0 then
        local progressDTO = UnionProgressDTO.new(defendUnionId, true)
        UnionProgressDTO.set(mapId, defendUnionId, progressDTO)
    end
end

function this.GetUnionListInRange(mapId)
    local unionIds = {}
    local areaStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.OCCUPY_AREA)
    local areaStrSplit = string.split(areaStr, "#")
    local x = areaStrSplit[1]
    local y = areaStrSplit[2]
    local range = areaStrSplit[3]
    -- 获取圈内所有战盟
    local idList = getobjectinmap(mapId, x, y, range)
    for _, rid in pairs(idList) do
        local actor = getactor(rid, mapId)
        local unionId = getbaseinfo(actor, "guildid")
        if not table.contains(unionIds, unionId) then
            table.insert(unionIds, unionId)
        end
    end
    return unionIds
end

-- 获取个人积分排名
function this.GetPlayerRank(actor, mapId)
    local ranking = this.GetPlayerRankList(mapId)
    return ranking[actor:toString()]
end

-- 获取玩家的个人积分排名列表
-- @return 列表<玩家id字符串；排名>
function this.GetPlayerRankList(mapId)
    local playerList = {}
    local allPlayers = this.GetAllParticipatingPlayers(mapId)
    for key, actor0 in pairs(allPlayers) do
        local score = RoleScoreDTO.calTotalScoreByActor(actor0, mapId)
        table.insert(playerList, { rid = actor0:toString(), score = score })
    end

    table.sort(
        playerList,
        function(a, b)
            return a.score > b.score
        end
    )

    -- 计算排名
    local ranks = {}
    local rank = 1 -- 当前排名

    for i = 1, #playerList do
        local player = playerList[i]
        -- 每次循环都增加排名
        ranks[player.rid] = rank
        rank = rank + 1
    end

    return ranks
end

-- 战盟排名
function this.GetUnionRank(unionId, mapId)
    local ranking = this.GetUnionRankMap(mapId)
    return ranking[tostring(unionId)]
end

-- 获取战盟积分排名列表
-- @return 列表<战盟id字符串；排名>
function this.GetUnionRankMap(mapId)
    local union2Score = {}
    local allPlayers = this.GetAllParticipatingPlayers(mapId)
    for key, actor0 in pairs(allPlayers) do
        local score = RoleScoreDTO.calTotalScoreByActor(actor0, mapId)
        local unionId = tostring(getbaseinfo(actor0, "guildid"))
        if union2Score[unionId] == nil then
            union2Score[unionId] = score
        else
            union2Score[unionId] = score + union2Score[unionId]
        end
    end

    local scoreArray = {}
    for unionId, score in pairs(union2Score) do
        table.insert(scoreArray, { unionId = unionId, score = score })
    end

    table.sort(
        scoreArray,
        function(a, b)
            return a.score > b.score
        end
    )

    -- 计算排名
    local ranks = {}
    local rank = 1 -- 当前排名

    for i = 1, #scoreArray do
        local union = scoreArray[i]
        -- 每次循环都增加排名
        ranks[union.unionId] = rank
        rank = rank + 1
    end

    return ranks
end

-- 获取战盟积分排名列表
-- @return 列表{{ unionId = unionId, score = score },....}
function this.GetUnionRankList(mapId)
    local union2Score = {}
    local allPlayers = this.GetAllParticipatingPlayers(mapId)
    for key, actor0 in pairs(allPlayers) do
        local score = RoleScoreDTO.calTotalScoreByActor(actor0, mapId)
        local unionId = tostring(getbaseinfo(actor0, "guildid"))
        if union2Score[unionId] == nil then
            union2Score[unionId] = score
        else
            union2Score[unionId] = score + union2Score[unionId]
        end
    end

    local scoreArray = {}
    for unionId, score in pairs(union2Score) do
        table.insert(scoreArray, { unionId = unionId, score = score })
    end

    table.sort(
        scoreArray,
        function(a, b)
            return a.score > b.score
        end
    )
    return scoreArray
end

-- 是否是最后阶段
function this.IsFinalPhase(mapId)
    local attackTaskInfo = this.GetAttackTask(mapId)
    local taskId = attackTaskInfo[1]
    local nextId = tonumber(ConfigDataManager.getTableValue("cfg_repTask", "nextID", "id", taskId))
    if nextId == nil or nextId == 0 then
        return true
    end
    return false
end

-- 结算
function this.Settlement(mapId)
    local log = LogRecord.new()
    local winUninId
    if this.IsFinalPhase(mapId) then
        -- 守方战盟为胜利方
        local defendUnionId = this.GetDefendUnionId(mapId)
        if defendUnionId == nil or defendUnionId == 0 then
            -- 无守方
            -- 积分第一的为占领战盟，无盟主奖励
            local unionRankList = this.GetUnionRankList(mapId)
            local unionInfo = unionRankList[1]
            winUninId = unionInfo.unionId
            log.winType = "积分"
        else
            local unionInfo = getunioninfo(defendUnionId)
            local leaderId = unionInfo.leaderid
            local leaderActor = getactor(leaderId, mapId)
            local leaderRewardStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.LEADER_REWARD)
            local leaderRewardStrSplit = string.toIntIntMap(leaderRewardStr, "#", "|")
            sendconfigmailbyrid(leaderActor, leaderActor:toString(), MailConfig.ROLAND_SEIGE_LEADER_REWARD, leaderRewardStrSplit)
            winUninId = defendUnionId
            log.winType = "占领"
            log.leader = leaderId
        end
    else
        winUninId = this.GetLastOccupyUnionId()
    end


    -- 设置占领战盟
    winUninId = winUninId or 0
    log.winUninId = winUninId
    this.SetLastOccupyUnionId(winUninId)

    -- 个人积分奖励
    local rank2Reward = {}
    local needScore = tonumber(ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.PERSONAL_LIMIT_SCORE))
    local personalRewardStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.PERSONAL_REWARD)
    local personalRewardStrSplit = string.split(personalRewardStr, "|")
    for key, value in pairs(personalRewardStrSplit) do
        local valueSplit = string.split(value, "&")
        local rankList = string.split(valueSplit[1], "#")
        local startRank = tonumber(rankList[1])
        local endRank = tonumber(rankList[2])

        local totalReward = {}
        for j = 2, #valueSplit do
            local reward = string.split(valueSplit[j], "#")
            totalReward[tonumber(reward[1])] = tonumber(reward[2])
        end

        table.insert(rank2Reward, { startRank = startRank, endRank = endRank, rewards = totalReward })
    end
    -- 获取所有参与的玩家
    local allPlayers = this.GetAllParticipatingPlayers(mapId)
    for _, actor in pairs(allPlayers) do
        local selfUnionId = getbaseinfo(actor, "guildid")
        if tostring(selfUnionId) == tostring(winUninId) then
            -- 获胜
            local winRewardStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.WIN_UNION_REWARD)
            local winRewardStrSplit = string.toIntIntMap(winRewardStr, "#", "|")
            sendconfigmailbyrid(actor, actor:toString(), MailConfig.ROLAND_SEIGE_WIN_UNION_REWARD, winRewardStrSplit)
        else
            --失败
            local failRewardStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.FAIL_UNION_REWARD)
            local failRewardStrSplit = string.toIntIntMap(failRewardStr, "#", "|")
            sendconfigmailbyrid(actor, actor:toString(), MailConfig.ROLAND_SEIGE_FAIL_UNION_REWARD, failRewardStrSplit)
        end

        -- 个人积分奖励
        local ownScore = RoleScoreDTO.calTotalScoreByActor(actor, mapId)
        log.personalScoreList[actor:toString()] = ownScore
        local ranking = this.GetPlayerRankList(mapId)
        if ownScore >= needScore then
            local rank = ranking[actor:toString()]
            for _, rewardInfo in ipairs(rank2Reward) do
                if rank >= rewardInfo.startRank and rank <= rewardInfo.endRank then
                    local rewards = rewardInfo.rewards
                    sendconfigmailbyrid(actor, actor:toString(), MailConfig.ROLAND_SEIGE_PERSONAL_REWARD, rewards, rank)
                end
            end
        end
    end
    gameDebug.debug(LogRecord.log, log)
end

-- 获取玩家的阵营
function this.GetCamp(actor, mapId)
    local defendUnionId = this.GetDefendUnionId(mapId)
    local selfUnionId = getbaseinfo(actor, "guildid")
    if tostring(defendUnionId) == tostring(selfUnionId) then
        return RolandConst.CAMP_TYPE.DEFEND
    else
        return RolandConst.CAMP_TYPE.ATTACK
    end
end

-- 是否可以开启
function RolandSeige.CanOpenActivity()
    local openDays = getbaseinfo("serveropendays")
    local day, hour, minute = this.GetFirstOpenTime()
    if openDays < day then
        return false
    end
    return true
end

-- 获取首次开启时间
function this.GetFirstOpenTime()
    local firstOpenTimeString = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.ROLAND_SEIGE.FIRST_OPEN_TIME)
    local firstOpenTimeStringSplit = string.split(firstOpenTimeString, "#")
    local day = tonumber(firstOpenTimeStringSplit[1])
    local hour = tonumber(firstOpenTimeStringSplit[2])
    local minute = tonumber(firstOpenTimeStringSplit[3])
    return day, hour, minute
end

---------------------------------------------------------- 响应 -----------------------------------------------------------------
-- 响应单个玩家副本阶段
function this.SendStateInfo(actor, repId, state, nextStateStartTime)
    sendluamsg(actor, LuaMessageIdToClient.RES_ROLAND_SEIGE_STATE, { repId, state, tostring(nextStateStartTime) })
end

-- 响应所有玩家副本阶段
function this.SendAllStateInfo(mapId, repId, state, nextStateStartTime)
    local allPlayers = getmapplayer(mapId)
    if #allPlayers > 0 then
        for _, actor in pairs(allPlayers) do
            this.SendStateInfo(actor, repId, state, nextStateStartTime)
        end
    end
end

-- 响应单个玩家任务面板信息
function this.SendTaskPanel(actor, mapId)
    local res = {}
    local selfCamp = this.GetCamp(actor, mapId)
    res.camp = selfCamp
    -- 任务信息
    local taskInfo
    if selfCamp == RolandConst.CAMP_TYPE.ATTACK then
        taskInfo = this.GetAttackTask(mapId)
    else
        taskInfo = this.GetDefendTask(mapId)
    end
    local taskId = taskInfo[1]
    local taskType = taskInfo[2]
    if taskType == DuplicateTaskType.KILL_TARGET_MONSTER then
        local targetMonCfg = taskInfo[5]
        local monsterList = mapbossinfo(mapId, -1, targetMonCfg)
        local minHP = 999999999
        local maxHP = 999999999
        for _, monInfo in pairs(monsterList) do
            local monHP = monInfo.hp
            if monHP < minHP then
                minHP = monHP
            end
            maxHP = monInfo.maxhp
        end
        res.nowCount = math.ceil((minHP / maxHP) * 100)
        res.totalCount = 100
    else
        res.nowCount = 0
        res.totalCount = 1
    end
    res.taskId = taskId
    -- 占领战盟
    local defendUnionId = this.GetDefendUnionId(mapId)
    if defendUnionId == nil or defendUnionId == 0 then
        res.unionName = "无"
    else
        --
        local progressDTO = UnionProgressDTO.get(mapId, defendUnionId)
        res.unionName = progressDTO.unionName
    end

    -- 所在战盟排名
    local unionId = getbaseinfo(actor, "guildid")
    res.unionRank = this.GetUnionRank(unionId, mapId)
    -- 个人排名
    res.selfRank = this.GetPlayerRank(actor, mapId)
    -- 个人积分
    res.selfScore = RoleScoreDTO.calTotalScoreByActor(actor, mapId)
    sendluamsg(actor, LuaMessageIdToClient.RES_ROLAND_SEIGE_TASK_PANEL, res)
end

-- 响应所有玩家任务面板信息
function this.SendAllTaskPanel(mapId)
    local allPlayers = getmapplayer(mapId)
    if #allPlayers > 0 then
        for _, actor in pairs(allPlayers) do
            this.SendTaskPanel(actor, mapId)
        end
    end
end

-- 响应所有玩家战盟占领进度
function this.SendAllUnionProgress(mapId, progressDTO)
    local allPlayers = getmapplayer(mapId)
    if #allPlayers > 0 then
        for _, actor in pairs(allPlayers) do
            sendluamsg(actor, LuaMessageIdToClient.RES_ROLAND_PROGRESS_INFO, progressDTO)
        end
    end
end

-- 响应玩家副本怪物信息
function this.SendMonsterList(actor, mapId)
    local res = this.BuildResMonsterList(mapId)
    sendluamsg(actor, LuaMessageIdToClient.RES_ROLAND_MONSTER_LIST, res)
end

-- 响应所有玩家副本怪物信息
function this.SendAllPlayMonsterList(mapId)
    local res = this.BuildResMonsterList(mapId)
    local allPlayers = getmapplayer(mapId)
    if #allPlayers > 0 then
        for _, actor in pairs(allPlayers) do
            sendluamsg(actor, LuaMessageIdToClient.RES_ROLAND_MONSTER_LIST, res)
        end
    end
end

function this.BuildResMonsterList(mapId)
    local res = {}
    local monList = getmapmon(mapId)
    for _, monActor in pairs(monList) do
        local oneRes = {}
        local monInfo = getmonsterinfo(monActor)
        oneRes.id = monInfo.id
        oneRes.cfg = monInfo.cfgid
        oneRes.x = monInfo.x
        oneRes.y = monInfo.y
        table.insert(res, oneRes)
    end
    return res
end

--------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------- 数据 -----------------------------------------------------------------
-- 获取当前进行的攻城战副本id
function this.GetCurrentDupId()
    local oldDupId = getsysvar(SystemVarConst.ROLAND_SEIGE.DUPLICATE_ID)
    return oldDupId
end

-- 设置当前进行的攻城战副本id
function this.SetCurrentDupId(dupId)
    setsysvar(SystemVarConst.ROLAND_SEIGE.DUPLICATE_ID, dupId)
end

-- 获取上次占领战盟Id
function this.GetLastOccupyUnionId()
    local unionId = getsysvar(SystemVarConst.ROLAND_SEIGE.LAST_OCCUPY_UNION_ID)
    return unionId
end

-- 设置上次占领战盟Id
function this.SetLastOccupyUnionId(unionId)
    setsysvar(SystemVarConst.ROLAND_SEIGE.LAST_OCCUPY_UNION_ID, unionId)
end

-- 获取守方战盟id
function this.GetDefendUnionId(mapId)
    local unionId = getenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.DEFEND_UNION)
    return unionId
end

-- 设置守方战盟id
function this.SetDefendUnionId(mapId, unionId)
    setenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.DEFEND_UNION, unionId)
end

-- 获取守方任务
function this.GetDefendTask(mapId)
    local defendTaskInfo = getenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.DEFEND_TASK)
    return defendTaskInfo
end

-- 设置守方任务
function this.SetDefendTask(mapId, taskId)
    local defendTaskInfo = DuplicateCommon.GenDupTaskInfoCommon(taskId)
    setenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.DEFEND_TASK, defendTaskInfo)
end

-- 获取攻方任务
function this.GetAttackTask(mapId)
    local attackTaskInfo = getenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.ATTACK_TASK)
    return attackTaskInfo
end

-- 设置攻方任务
function this.SetAttackTask(mapId, taskId)
    local attackTaskInfo = DuplicateCommon.GenDupTaskInfoCommon(taskId)
    setenvirvar(mapId, DuplicateVarConst.ROLAND_SEIGE.ATTACK_TASK, attackTaskInfo)
end

-- 获取所有参与的玩家{actor,...}
function this.GetAllParticipatingPlayers(mapId)
    local allPlayers = getdupparticipants(mapId)
    return allPlayers
end

-- 获取所有参与的战盟
function this.GetAllParticipatingUnions(mapId)
    local allUnion = {}
    local allPlayers = this.GetAllParticipatingPlayers(mapId)
    for _, actor in pairs(allPlayers) do
        local unionId = getbaseinfo(actor, "guildid")
        if not table.contains(allUnion, unionId) then
            table.insert(allUnion, unionId)
        end
    end
    return allUnion
end

--------------------------------------------------------------------------------------------------------------------------



function testenterroland(actor)
    RolandSeige.ReqEnterDupLicate(actor)
end

function testcloseroland(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    setduplicatestate(mapId, SetDuplicateStateConst.TO_FINISH)
end

function testfightroland(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    setduplicatestate(mapId, SetDuplicateStateConst.TO_FIGHT)
end

function testreqroland(actor)
    RolandSeige.ReqMainPanel(actor)
end

function testclearroland(actor)
    this.SetLastOccupyUnionId(0)
end

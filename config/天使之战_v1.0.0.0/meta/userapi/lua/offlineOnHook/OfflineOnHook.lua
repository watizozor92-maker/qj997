--- 离线挂机
local this = {}
local __offlineOnHookStateByUid = "G$OFFLINE_ONHOOK_STATE_BY_UID"
onHook = {}
local OPEN_OFFLINE_ON_HOOK = true
function onHook.getOffLineOnHookInfo(actor)
    this.getOffLineOnHookInfo(actor)
end

function this.checkLevel(actor)
    local level = getbaseinfo(actor, "level")
    -- 是否达到开启离线挂机的等级
    local offlineOnHookLevel = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_LEVEL)
    return level >= tonumber(offlineOnHookLevel)
end

function this.checkPrivilege(actor)
    local hasPrivilege = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.OFFLINE_ON_HOOK)
    return hasPrivilege
    -- return false
end

function this.checkActive(actor)
    if not this.checkLevel(actor) then
        return false
    end
    if not this.checkPrivilege(actor) then
        return false
    end
    return true
end

--- 获取离线挂机信息
---@param actor 玩家对象
function this.getOffLineOnHookInfo(actor)
    -- 是否达到开启离线挂机的等级
    if not this.checkLevel(actor) then
        return
    end

    local onHookInfo = getonhookinfo(actor)
    local fightExp = getplaydef(actor, PlayerDefKey.offline.FIGHT_EXP)
    if string.isNullOrEmpty(fightExp) then
        fightExp = 0
    end
    -- 获取泡点和战斗的开始及结束时间
    local bubblePointStart = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START)
    local bubblePointEnd = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END)
    local fightStart = getplaydef(actor, PlayerDefKey.offline.FIGHT_START)
    local fightEnd = getplaydef(actor, PlayerDefKey.offline.FIGHT_END)
    -- 计算泡点时长
    local bubbleDuration = 0
    if bubblePointStart and bubblePointEnd then
        bubbleDuration = math.max(0, (tonumber(bubblePointEnd) - tonumber(bubblePointStart)) / 1000)
    end

    -- 计算战斗时长
    local fightDuration = 0
    if fightStart and fightEnd then
        fightDuration = math.max(0, (tonumber(fightEnd) - tonumber(fightStart)) / 1000)
    end

    -- 总时长为泡点时长+战斗时长
    local duration = bubbleDuration + fightDuration

    local offlineTimeout = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_TIMEOUT)
    local timeout = duration > offlineTimeout * 60
    -- 限制总时长不超过超时限制
    duration = timeout and offlineTimeout * 60 or duration
    fightDuration = math.min(fightDuration, duration)
    bubbleDuration = math.min(bubbleDuration, duration - fightDuration)

    -- 泡点经验
    local bubblePointExp = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP)
    if string.isNullOrEmpty(bubblePointExp) then
        bubblePointExp = 0
    end
    -- onHookInfo["freeExp"] = tostring(bubblePointExp)
    -- 泡点时长与总离线挂机时长
    -- onHookInfo["freeDuration"] = math.round(bubbleDuration)
    onHookInfo["duration"] = math.round(duration)

    -- 战斗时长已计算
    onHookInfo["fightDuration"] = math.round(fightDuration)
    onHookInfo["fightExp"] = tostring(fightExp)
    local isReceive = getplaydef(actor, PlayerDefKey.offline.IS_RECEIVE)
    if string.isNullOrEmpty(isReceive) then
        isReceive = false
    end
    onHookInfo["receiveExp"] = isReceive
    local totalExp = getplaydef(actor, PlayerDefKey.offline.TOTAL_EXP)
    if string.isNullOrEmpty(totalExp) then
        totalExp = 0
    end
    local expLimit = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_EXP_LIMIT)
    local total = totalExp + bubblePointExp + fightExp
    if expLimit and tonumber(expLimit) < total then
        total = tonumber(expLimit)
    end
    onHookInfo["totalExp"] = tostring(total)
    -- local openBubbleTime = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START)
    -- local mapId = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_MAP)
    -- if openBubbleTime and openBubbleTime > 0 then
    --     local temp = {}
    --     temp[openBubbleTime] = mapId
    --     onHookInfo["openBubbleMap"] = temp
    -- end
    -- 如果后端服务重启，则需要重新计算挂机超时时间点
    if timeout then
        local now = getbaseinfo(actor, "now")
        onHookInfo["timeout"] = now - duration * 1000 + offlineTimeout * TimeUnit.MINUTE * TimeUnit.MILLISECOND
    end
    local pickUpItems = OfflineOnHookFSM.getPickUpItems(actor)
    onHookInfo["pickUpItems"] = pickUpItems
    sendluamsg(actor, LuaMessageIdToClient.RES_OFFLINE_ON_HOOK_INFO, onHookInfo)
end

--- 请求领取离线挂机经验
---@param actor 玩家对象
function onHook.reqReceiveOfflineOnHookExp(actor)
    if not this.checkLevel(actor) then
        return
    end
    -- 领取过离线挂机经验直接返回
    if getplaydef(actor, PlayerDefKey.offline.IS_RECEIVE) then
        return
    end
    -- 计算角色泡点经验
    local bubblePointExp = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP)
    if string.isNullOrEmpty(bubblePointExp) then
        bubblePointExp = 0
    end
    local fightExp = getplaydef(actor, PlayerDefKey.offline.FIGHT_EXP)
    if string.isNullOrEmpty(fightExp) then
        fightExp = 0
    end
    local totalExp = getplaydef(actor, PlayerDefKey.offline.TOTAL_EXP)
    if string.isNullOrEmpty(totalExp) then
        totalExp = 0
    end
    local exp = bubblePointExp + fightExp + totalExp
    local expLimit = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_EXP_LIMIT)
    exp = exp > tonumber(expLimit) and tonumber(expLimit) or exp
    additemtobag(actor, ItemConfigId.EXP, exp, 0, 9999, ItemActionProxy.OFFLINE_HANGUP)
    setplaydef(actor, PlayerDefKey.offline.IS_RECEIVE, true)
end

--- 角色登录存储泡点结束时间与离线挂机结束时间
---@param actor 玩家对象
function onHook.login(actor)
    if not this.checkLevel(actor) then
        return
    end

    local now = getbaseinfo(actor, "now")
    local lastPlayTime = getplaydef(actor, PlayerDefKey.offline.LAST_TIME)
    local serverStartTime = getsysvar(SystemVarConst.SERVER_START)
    if lastPlayTime and serverStartTime and lastPlayTime < serverStartTime then
        -- 重启过服务器, 计算战斗和泡点结束时间
        local fightStart = getplaydef(actor, PlayerDefKey.offline.FIGHT_START)
        local bubblePointStart = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START)
        if fightStart and fightStart > 0 then
            if bubblePointStart and bubblePointStart > 0 then
                -- 有战斗有泡点, 角色先战斗,死亡后传送过到泡点区重启过
                if bubblePointStart > fightStart then
                    setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END, lastPlayTime)
                else
                    gameDebug.error(actor, "角色战斗中重启过, 泡点开始时间早于战斗开始时间, 逻辑错误")
                end
            else
                -- 有战斗无泡点, 角色战斗中重启过
                setplaydef(actor, PlayerDefKey.offline.FIGHT_END, lastPlayTime)
            end
        end

        if bubblePointStart and bubblePointStart > 0 then
            -- 无战斗有泡点, 角色在泡点区重启过
            setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END, lastPlayTime)
        end
    end

    -- 计算泡点经验
    local bubblePointStart = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START)
    if bubblePointStart then
        local offlineTimeout = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_TIMEOUT)
        local fightExp = getplaydef(actor, PlayerDefKey.offline.FIGHT_EXP)
        local bubblePointEnd = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END)
        -- 只有等级满足条件且在泡点区域才能获得泡点经验
        if not bubblePointEnd and this.checkBubblePointArea(actor) then
            setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END, now)
            -- 根据时间计算泡点经验
            local bubblePointExp = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP)
            local exp = this.calcBubblePointExp(actor, this.calcBubblePointTime(actor, offlineTimeout))
            if string.isNullOrEmpty(bubblePointExp) then
                -- setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP, exp)
                setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP, 0)
            else
                local bubbleExp = tonumber(bubblePointExp) + exp
                if this.checkExpLimit(actor, fightExp, bubbleExp) then
                    local expLimit = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_EXP_LIMIT)
                    local totalExp = getplaydef(actor, PlayerDefKey.offline.TOTAL_EXP)
                    bubbleExp = tonumber(expLimit) - fightExp - totalExp
                end
                -- setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP, bubbleExp)
                setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP, 0)
            end
        end
    end

    -- 登录时设置战斗结束时间
    local fightStart = getplaydef(actor, PlayerDefKey.offline.FIGHT_START)
    if fightStart and fightStart > 0 then
        local fightEnd = getplaydef(actor, PlayerDefKey.offline.FIGHT_END)
        if not fightEnd then
            setplaydef(actor, PlayerDefKey.offline.FIGHT_END, now)
        end
    end
    -- 发送离线挂机信息
    this.getOffLineOnHookInfo(actor)
end

--- 角色退出清空泡点相关信息
---@param actor 玩家对象
function onHook.logout(actor)
    -- 重置结束时间
    setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END, nil)
    setplaydef(actor, PlayerDefKey.offline.FIGHT_END, nil)
    -- 领取过经验后重置存储的经验信息
    if getplaydef(actor, PlayerDefKey.offline.IS_RECEIVE) then
        setplaydef(actor, PlayerDefKey.offline.IS_RECEIVE, false)
        setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP, nil)
        setplaydef(actor, PlayerDefKey.offline.FIGHT_EXP, nil)
        setplaydef(actor, PlayerDefKey.offline.TOTAL_EXP, nil)
    else
        -- 计算没领取的经验
        local totalExp = getplaydef(actor, PlayerDefKey.offline.TOTAL_EXP)
        if string.isNullOrEmpty(totalExp) then
            totalExp = 0
        end
        local bubblePointExp = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP)
        if not string.isNullOrEmpty(bubblePointExp) then
            totalExp = totalExp + bubblePointExp
        end
        local fightExp = getplaydef(actor, PlayerDefKey.offline.FIGHT_EXP)
        if not string.isNullOrEmpty(fightExp) then
            totalExp = totalExp + fightExp
        end
        local expLimit = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_EXP_LIMIT)
        if expLimit and totalExp > tonumber(expLimit) then
            totalExp = tonumber(expLimit)
        end
        setplaydef(actor, PlayerDefKey.offline.TOTAL_EXP, totalExp)
        setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_EXP, nil)
        setplaydef(actor, PlayerDefKey.offline.FIGHT_EXP, nil)
    end

    if this.checkLevel(actor) then
        -- 等级满足时，根据所在区域记录相应信息
        local now = getbaseinfo(actor, "now")
        if this.checkBubblePointArea(actor) then
            -- 在泡点区域，记录泡点开始时间
            gameDebug.print(actor, "开启泡点", now)
            setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_MAP, getbaseinfo(actor, "map"))
            setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START, now)
            setplaydef(actor, PlayerDefKey.offline.FIGHT_START, nil)
        else
            -- 检查是可以战斗条件
            local isSafeArea = insafezone(actor)
            if this.checkPrivilege(actor) and not isSafeArea then
                -- 开始战斗时间记录
                setplaydef(actor, PlayerDefKey.offline.FIGHT_START, now)
            else
                setplaydef(actor, PlayerDefKey.offline.FIGHT_START, nil)
            end
            setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START, nil)
            setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_MAP, nil)
        end
    else
        -- 等级不足，清空所有相关记录
        setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_MAP, nil)
        setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START, nil)
        setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END, nil)
        setplaydef(actor, PlayerDefKey.offline.FIGHT_START, nil)
        setplaydef(actor, PlayerDefKey.offline.FIGHT_END, nil)
    end
end

--- 玩家传送后判断是否进入泡点区域
---@param actor 玩家对象
function onHook.afterTransmit(actor)
    -- 非离线挂机玩家不处理
    if not isofflineplay(actor) then
        return
    end

    if this.checkLevel(actor) then
        local now = getbaseinfo(actor, "now")
        -- 等级满足时，根据所在区域记录相应信息
        if this.checkBubblePointArea(actor) then
            setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_MAP, getbaseinfo(actor, "map"))
            -- 记录泡点开始时间
            setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START, now)
        end

        -- 记录结束战斗时间
        local fightStart = getplaydef(actor, PlayerDefKey.offline.FIGHT_START)
        if fightStart and fightStart > 0 then
            setplaydef(actor, PlayerDefKey.offline.FIGHT_END, now)
        end
    end
end

--- 检查区域是否是泡点区域
---@param actor 玩家对象
---@return boolean 是否在泡点区域
function this.checkBubblePointArea(actor)
    local level = tonumber(getbaseinfo(actor, "level"))
    local mapId = getbaseinfo(actor, "map")
    local safeArea = getbaseinfo(actor, "safearea")
    local configString = ConfigDataManager.getTableValue("cfg_bubble_point", "expMap", "id", level)
    local configMap = string.toStringStringMap(configString, "#", "|")
    local checkArea = false
    for key, value in pairs(configMap) do
        mapId = tonumber(mapId)
        key = tonumber(key)
        value = tonumber(value)
        if mapId == key then
            if value == 3 then
                checkArea = true
            elseif value == 2 and safeArea == false then
                checkArea = true
            elseif value == 1 and safeArea == true then
                checkArea = true
            end
        end
    end
    return checkArea
end

--- 计算泡点时长
---@param actor 玩家对象
---@param duration 离线挂机战斗时长
---@return number 泡点时长(s)
function this.calcBubblePointTime(actor, offlineTimeout)
    local offlineBubblePointStart = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START)
    local offlineBubblePointEnd = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END)
    local fightStart = getplaydef(actor, PlayerDefKey.offline.FIGHT_START)
    local fightEnd = getplaydef(actor, PlayerDefKey.offline.FIGHT_END)
    if fightStart and fightStart > 0 and fightEnd and fightEnd > 0 then
        -- 总时长减去战斗时长
        local secondMin = math.round((tonumber(fightEnd) - tonumber(fightStart)) / 1000) / 60
        if secondMin > 0 then
            offlineTimeout = offlineTimeout - secondMin
        end
    end

    if offlineBubblePointStart and offlineBubblePointEnd and tonumber(offlineBubblePointEnd) - tonumber(offlineBubblePointStart) > 0 then
        local secondDiff = math.round((tonumber(offlineBubblePointEnd) - tonumber(offlineBubblePointStart)) / 1000)
        -- 泡点时长处理
        if secondDiff > tonumber(offlineTimeout) * 60 then
            secondDiff = tonumber(offlineTimeout) * 60
        end
        return secondDiff
    end
    return 0
end

--- 根据泡点时长获取泡点经验
---@param actor 玩家对象
---@param secondDiff 泡点时长(s)
---@return number 泡点经验
function this.calcBubblePointExp(actor, secondDiff)
    if secondDiff == 0 then
        return 0
    end
    local level = tonumber(getbaseinfo(actor, "level"))
    local expInterval = ConfigDataManager.getTableValue("cfg_bubble_point", "expInterval", "id", level)
    if string.isNullOrEmpty(expInterval) then
        gameDebug.print("找不到cfg_bubble_point配置,id:" .. level)
        return 0, 0
    end
    local times = math.round(secondDiff / expInterval)
    local expConfig = ConfigDataManager.getTableValue("cfg_bubble_point", "exp", "id", level)
    local exp = string.split(expConfig, "#")[2]
    return tonumber(exp) * tonumber(times)
end

--- 检查离线挂机经验是否超限
---@param fightExp number 战斗经验
---@param bubblePointExp number 泡点经验
function this.checkExpLimit(actor, fightExp, bubblePointExp)
    local expLimit = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_EXP_LIMIT)
    if not string.isNullOrEmpty(expLimit) then
        local totalExp = getplaydef(actor, PlayerDefKey.offline.TOTAL_EXP)
        totalExp = totalExp or 0
        fightExp = fightExp or 0
        bubblePointExp = bubblePointExp or 0
        return fightExp + bubblePointExp + totalExp > tonumber(expLimit)
    end
    return false
end

--- 保存离线挂机战斗经验
---@param actor 玩家对象
---@param exp 战斗经验
function onHook.saveOfflineFightExp(actor, exp)
    if not this.checkActive(actor) then
        return
    end

    local now = getbaseinfo(actor, "now")
    local fightStart = getplaydef(actor, PlayerDefKey.offline.FIGHT_START)
    if string.isNullOrEmpty(fightStart) then
        -- 如果没有战斗开始时间，则设置开始时间
        setplaydef(actor, PlayerDefKey.offline.FIGHT_START, now)
    end

    -- 是否超时判断, 正在战斗不可能之前有泡点, 只需要判断战斗时长
    local offlineTimeout = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_TIMEOUT)
    if fightStart and (now - fightStart) > tonumber(offlineTimeout) * TimeUnit.MINUTE * TimeUnit.MILLISECOND then
        -- 超时停止战斗
        setplaydef(actor, PlayerDefKey.offline.FIGHT_END, now)
        onhookstop(actor, 0, 0, 0, 0, 1, 0)
        return
    end

    local offlineFightExp = getplaydef(actor, PlayerDefKey.offline.FIGHT_EXP)
    if string.isNullOrEmpty(offlineFightExp) then
        setplaydef(actor, PlayerDefKey.offline.FIGHT_EXP, tonumber(exp))
    else
        if not this.checkExpLimit(actor, offlineFightExp, 0) then
            setplaydef(actor, PlayerDefKey.offline.FIGHT_EXP, tonumber(offlineFightExp) + tonumber(exp))
        end
    end
end

--- 设置离线挂机巡逻状态
---@param actor table 玩家对象
---@param state number 状态 巡逻状态:1 战斗状态:2 无状态:0
function onHook.setOfflineState(actor, state)
    setofflinepatrolstate(actor, state)
end

--- 记录玩家最后一次离线挂机时间
---@param actor table 玩家对象
function onHook.recordLastTime(actor)
    setplaydef(actor, PlayerDefKey.offline.LAST_TIME, getbaseinfo(actor, "now"))
end

--- 记录服务器启动时间
function onHook.recordStartTime()
    setsysvar(SystemVarConst.SERVER_START, getbaseinfo("now"))
end

function onHook.canHook(actor)
    --禁用挂机
    if not OPEN_OFFLINE_ON_HOOK then
        onhookstop(actor, 0, 0, 0, 0, 1, 1)
        return
    end

    -- 安全区站着
    if insafezone(actor) then
        onhookstop(actor, 0, 0, 0, 0, 1, 0)
        return
    end

    local originx = (function()
        local success, result = pcall(function() return getbaseinfo(actor, "x") end)
        return success and result or 0
    end)()
    local originy = (function()
        local success, result = pcall(function() return getbaseinfo(actor, "y") end)
        return success and result or 0
    end)()

    if originx == 0 or originy == 0 then
        gameDebug.print(actor, "离线挂机时玩家坐标异常")
        onhookstop(actor, 0, 0, 0, 0, 1, 1)
        return
    end

    if not this.checkActive(actor) then
        -- 标记在野外无挂机条件, 因为要自动复活, 还是走内置挂机心跳
        StateManager.transformState(actor, StateManager.STATE_NONE)
        return
    end

    gameDebug.print("玩家" .. actor:toString(), "开启离线挂机")
    
    if not this.openAccountLimit() then        
        return
    end

    -- 顶号检查
    this.checkReplaceActor(actor) 

    -- 初始化角色不变参数
    this.initImmutableCache(actor, originx, originy)
end

function this.openAccountLimit()
    local accountLimit = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_ACCOUNT_LIMIT)
    accountLimit = tonumber(accountLimit) or 0
    return accountLimit == 1
end

function this.checkReplaceActor(actor)
    local uid = getbaseinfo(actor, "uid")
    local data = getsysvar(actor, __offlineOnHookStateByUid) or {}
    if data[uid] and data[uid] ~= actor:toString() then
        gameDebug.print("玩家账号" .. uid, "角色" .. data[uid], "正在离线挂机中", "当前角色 " .. actor:toString() .. " 顶号")
        local otherActor = getactor(data[uid])
        this.replaceActor(otherActor)
    end
    data[uid] = actor:toString()
    setsysvar(actor, __offlineOnHookStateByUid, data)
end

function this.replaceActor(actor)
    -- 顶号原账号离线挂机
    local bubblePointStart = getplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_START)
    local fightStart = getplaydef(actor, PlayerDefKey.offline.FIGHT_START)
    local now = getbaseinfo(actor, "now")
    if fightStart and fightStart > 0 then
        if bubblePointStart and bubblePointStart > 0 then
            -- 有战斗有泡点, 角色先战斗,死亡后传送过到泡点区
            if bubblePointStart > fightStart then
                setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END, now)
            else
                gameDebug.error(actor, "顶号时泡点开始时间早于战斗开始时间, 逻辑错误")
            end
        else
            -- 有战斗无泡点, 角色战斗中
            setplaydef(actor, PlayerDefKey.offline.FIGHT_END, now)
        end
    end

    if bubblePointStart and bubblePointStart > 0 then
        -- 无战斗有泡点, 角色在泡点区
        setplaydef(actor, PlayerDefKey.offline.BUBBLE_POINT_END, now)
    end
    onhookstop(actor, 0, 0, 0, 0, 1, 1)
end

function this.initImmutableCache(actor, originx, originy)
    local roleSetting = getrolesetting(actor)
    local settings = roleSetting.settings
    local isOpen = settings and settings[25]
    local open, _ = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.AUTO_PICKUP)
    local autoPick = (isOpen == "true") and open
    local autoPickRange = HookCommonUtils.getPlayerHookPickRang(actor)
    local autoPickCD = ConfigDataManager.getTableValue("cfg_global", "value", "id", 7121604)
    autoPickCD = (tonumber(autoPickCD) or 0) / 2
    local allowPublicItems = ConfigDataManager.getTableValue("cfg_global", "value", "id", 7121605)
    allowPublicItems = string.tonumber(allowPublicItems) <= 0

    local killMonsterRange, returntime, lessthanSetting, hungupSkills = HookCommonUtils.getPlayerHookSetting(actor)
    local singleSkillIds, multiSkillIds = this.getAllSkills(actor, hungupSkills)
    local allSkills = getplayskilllist(actor, -1, 1)
    local multiFilteredSkills = this.getSkills(multiSkillIds, singleSkillIds, allSkills)
    local singleFilteredSkills = this.getSkills(singleSkillIds, multiSkillIds, allSkills)
    local attackSkill, skilllevel = this.commAttack(actor)
    singleFilteredSkills = this.handlerSingleSkill(attackSkill, singleFilteredSkills)

    local immutableCache = {
        mapId = getbaseinfo(actor, "unimapid"),
        radius = tonumber(killMonsterRange) or StateManager.DEFAULT_ACTIVITY_RADIUS,
        noMonsterTimeout = tonumber(returntime) or StateManager.DEFAULT_NO_MONSTER_TIMEOUT,
        hungupSkillCount = table.count(hungupSkills),
        singleFilteredSkills = singleFilteredSkills,
        multiFilteredSkills = multiFilteredSkills,
        commAttackSkill = { attackSkill, skilllevel },
        autoPick = autoPick,
        autoPickRange = autoPickRange,
        autoPickCD = autoPickCD,
        allowPublicItems = allowPublicItems,
        originx = originx,
        originy = originy,
    }
    setplaydef(actor, PlayerDefKey.offline.IMMUTABLE_CACHE, immutableCache)
    return immutableCache
end

function onHook.getImmutableCache(actor)
    local immutableCache = getplaydef(actor, PlayerDefKey.offline.IMMUTABLE_CACHE)
    if table.isEmpty(immutableCache) then
        immutableCache = this.initImmutableCache(actor)
    end
    return immutableCache
end

function this.getAllSkills(actor, hungupSkills)
    local singleSkillIds = {}
    local multiSkillIds = {}
    for i = 1, #hungupSkills do
        local skillId = hungupSkills[i]
        local aoe = ConfigDataManager.getTableValue("cfg_skill", "aoe", "id", skillId)
        if not string.isNullOrEmpty(aoe) then
            if string.tonumber(aoe) == 0 then
                -- 单体技能
                table.insert(singleSkillIds, skillId)
            else
                -- 群体技能
                table.insert(multiSkillIds, skillId)
            end
        end
    end
    return singleSkillIds, multiSkillIds
end

function this.getSkills(skillIds1, skillIds2, allSkills)
    local skillSort = function(a, b)
        return a.priority > b.priority
    end
    table.sort(allSkills, skillSort)
    local filteredSkills = {}
    if not table.isEmpty(skillIds1) then
        for i = 1, #allSkills do
            local skill = allSkills[i]
            if table.contains(skillIds1, skill.id) then
                local targetType = ConfigDataManager.getTableValue("cfg_skill", "targettype", "id", skill.id)
                local damagenumberlimit = ConfigDataManager.getTableValue("cfg_skill", "damagenumberlimit", "id", skill.id)
                local calcArea = string.tonumber(damagenumberlimit)
                if tonumber(targetType) == 1 then
                    table.insert(filteredSkills, { id = skill.id, level = skill.level, calcArea = calcArea })
                end
            end
        end
    end

    if not table.isEmpty(skillIds2) then
        for i = 1, #allSkills do
            local skill = allSkills[i]
            if table.contains(skillIds2, skill.id) then
                local targetType = ConfigDataManager.getTableValue("cfg_skill", "targettype", "id", skill.id)
                local damagenumberlimit = ConfigDataManager.getTableValue("cfg_skill", "damagenumberlimit", "id", skill.id)
                local calcArea = string.tonumber(damagenumberlimit)
                if tonumber(targetType) == 1 then
                    table.insert(filteredSkills, { id = skill.id, level = skill.level, calcArea = calcArea })
                end
            end
        end
    end
    return filteredSkills
end

function this.handlerSingleSkill(commAttackId, singleFilteredSkills)
    local singleSkills = {}
    local commSkill
    for _, skill in ipairs(singleFilteredSkills) do
        local id = skill.id
        if id ~= commAttackId then
            table.insert(singleSkills, skill)
        else
            commSkill = skill
        end
    end
    -- 把普攻放到最后
    table.insert(singleSkills, commSkill)
    return singleSkills
end

function this.commAttack(actor)
    local skillAttack = ConfigDataManager.getList("cfg_skill_attack")
    if not table.isEmpty(skillAttack) then
        local baseCareer = getbaseinfo(actor, "getbasecareer")
        for i, skillAttk in pairs(skillAttack) do
            local career = string.splitInt(skillAttk.career, "#")[1]
            if career == baseCareer then
                local attackSkill = string.splitInt(skillAttk.skill, "#")[1]
                local skilllevel = getskilllevel(actor, attackSkill) or 1
                return attackSkill, skilllevel
            end
        end
    end
end

-- ====================================测试========================================
function testofflineonhook(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        this.initImmutableCache(actor)
    end
end

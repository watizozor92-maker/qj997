--[[ 通用副本组队使用说明，通用流程均已封装好，只需要处理以下操作
    1.注册自己的副本进入检查方法 --- DuplicateEnterCheckDispath:register(dupType, func)
    2.处理拉人进入 --- this.pullAllMemberEnterDup(actor, teamInfo, configId)
]]

-------------------------------------------------- domain层 -----------------------------------------------------
DuplicateTeam = {}
local this = {}

local ReadyState = {
    NONE = 0,
    READY = 1,
    REJECT = 2,
    NO_CONDITION = 3,
}
-- 副本进入检查调度器
DuplicateEnterCheckDispath = {
    type2fun = {},
    DEFAULT_TYPE = "DEFAULT_TYPE"
}

-- 设置元表，支持面向对象风格调用
setmetatable(DuplicateEnterCheckDispath, {
    __index = function(t, k)
        return rawget(t, "type2fun")[k]
    end,
    __call = function(func, ...) -- 允许像函数一样调用 DuplicateEnterCheckDispath(...)
        local args = { ... }
        local dupType = tostring(args[1])
        return DuplicateEnterCheckDispath:check(dupType, table.unpack(args, 2))
    end
})


function DuplicateEnterCheckDispath:register(dupType, func)
    self.type2fun[tostring(dupType)] = func
end

function DuplicateEnterCheckDispath:check(dupType, actor, configId)
    dupType = tostring(dupType)
    local func = self.type2fun[dupType] or self.type2fun[self.DEFAULT_TYPE]
    if not func then
        gameDebug.assertTrue(false, "未注册副本检查函数", dupType)
        return false
    end
    local s, result = xpcall(func, debug.traceback, actor, configId)
    gameDebug.assertTrue(s, actor:toString() .. "副本进入检查错误，类型：" .. tostring(dupType) .. ";配置：" .. configId, result)
    return result
end

-- 默认检查方法
function DuplicateEnterCheckDispath.defaultCheck(actor, configId)
    return DuplicateCommon.CheckEnterConditonCommon(actor, configId)
end

-- 注册默认方法
DuplicateEnterCheckDispath:register(DuplicateEnterCheckDispath.DEFAULT_TYPE, DuplicateEnterCheckDispath.defaultCheck)


------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- trigger层 -----------------------------------------------------
function DuplicateTeam.enterAsTeam(leader, configId)
    -- 队伍进入检查
    local check, nowSize = this.teamEnterCheck(leader, configId)
    if not check then
        tipinfo(leader, "准备人数不足")
        return
    end
    local teamData = this.getTeamInfo(leader)
    this.cancelTimer(leader, teamData.timerId)
    local now = getbaseinfo("now")
    if nowSize == 1 then
        -- 单人组队，直接倒计时进入
        local timerId = intervalcalldelay(leader, 8000, 1000, 1, "dupleaderdoteamenter")
        local endTime = now + 8000
        this.setTeamInfo(leader, nil, { endTime = endTime, state = 2, timerId = timerId })
        setplaydef(leader, PlayerDefKey.DUP_TEAM_BELONG, configId)
        setplaydef(leader, PlayerDefKey.DUP_TEAM_READY, ReadyState.READY)
        this.resAllTeamPreparePanel(leader, configId)
    else
        local endTime = now + 30000
        local timerId = intervalcalldelay(leader, 30000, 1000, 1, "dupleaderdoteamentercheckstate", configId)
        this.setTeamInfo(leader, nil, { endTime = endTime, state = 1, timerId = timerId })
        -- 判断其他成员在不在副本里，如果在副本里，不拉准备面板
        this.callTeamMembersPrepare(leader, configId)
    end
end

function dupleaderdoteamentercheckstate(leader, configId)
    local teamData = this.getTeamInfo(leader)
    if teamData.state == 1 then
        local now = getbaseinfo("now")
        teamData.state = 2
        teamData.endTime = now + 8000
        this.cancelTimer(leader, teamData.timerId)
        local timerId = intervalcalldelay(leader, 8000, 1000, 1, "dupleaderdoteamenter")
        teamData.timerId = timerId
        this.setTeamInfo(leader, nil, teamData)
        local teamId = getbaseinfo(leader, "teamid")
        this.timeOutHandle(leader, teamId, configId)
        this.resAllTeamPreparePanel(leader, configId)
    end
end

function dupleaderdoteamenter(leader)
    DuplicateTeam.leaderDoTeamEnter(leader)
end

function DuplicateTeam.changeTeamPrepareState(actor, state)
    local belong = getplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG)
    if belong == nil or belong <= 0 then
        gameDebug.assertPrint(false, "副本组队玩家修改组队状态错误，玩家无归属", actor:toString(), state)
        return
    end
    this.ChangeTeamPrepareState(actor, state, belong)
end

function DuplicateTeam.leaderDoTeamEnter(actor)
    local configId = getplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG)
    if configId == nil or configId <= 0 then
        gameDebug.assertPrint(false, "副本组队玩家拉人进入错误，玩家无归属", actor:toString())
        return
    end
    local teamId = getbaseinfo(actor, "teamid")
    local selfId = getbaseinfo(actor, "rid")
    local teamInfo = getteaminfo(actor, teamId)
    local leaderId = teamInfo["leaderid"]
    if tostring(selfId) ~= tostring(leaderId) then
        gameDebug.assertPrintTrace(false, selfId .. "不是队长，组队进入副本！")
        return
    end
    local readyState = getplaydef(actor, PlayerDefKey.DUP_TEAM_READY)
    if readyState ~= ReadyState.READY then
        gameDebug.assertPrint(false, "玩家未准备，无法进入副本", actor:toString())
        this.breakDupTeam(actor, teamId)
        return
    end
    this.pullAllMemberEnterDup(actor, teamInfo, configId)
    -- 解散
    this.breakDupTeam(actor, teamId)
end

function DuplicateTeam.leaveTeam(actor, teamId)
    local configId = getplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG)
    if configId ~= nil and configId > 0 then
        -- 有人退出队伍直接解散准备面板
        this.breakDupTeam(actor, teamId)
    end
end

function DuplicateTeam.checkDupTeamBelongAndBreak(actor)
    local configId = getplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG)
    if configId ~= nil and configId > 0 then
        -- 有人进入其他副本，解散准备面板
        local teamId = getbaseinfo(actor, "teamid")
        if teamId > 0 then
            this.breakDupTeam(actor, teamId)
            return true
        end
    end
    return false
end

function DuplicateTeam.logout(actor)
    local configId = getplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG)
    if configId and configId > 0 then
        this.ChangeTeamPrepareState(actor, DupTeamChangeState.REFUSE, configId)
    end
end

-- function DuplicateTeam.teamEntered(actor, teamId)
--     -- 发送副本信息
--     local teamInfo = getteaminfo(actor, teamId)
--     local leader = teamInfo["leaderid"]
--     local leaderActor = getactor(leader)
--     local configId = getplaydef(leaderActor, PlayerDefKey.DUP_TEAM_BELONG)
--     if configId ~= nil and configId > 0 then
--         if this.isMemberAvailable(actor) then
--             setplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG, configId)
--             setplaydef(actor, PlayerDefKey.DUP_TEAM_READY, ReadyState.NONE)
--             local msg = this.buildTeamPrepareMsg(actor, teamId, configId)
--             sendluamsg(actor, LuaMessageIdToClient.RES_DUPLICATE_TEAM_INFO, msg)
--         end
--     end
-- end

------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- service层 -----------------------------------------------------
function this.cancelTimer(leader, timerId)
    if timerId and timerId > 0 then
        clearintervalcall(leader, timerId)
    end
end

function this.timeOutHandle(actor, teamId, configId)
    if teamId <= 0 or teamId == nil then
        return
    end
    local teamInfo = getteaminfo(actor, teamId)
    local members = teamInfo["allteammemberinfo"]
    local dupType = tonumber(ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId))
    for index, memberInfo in ipairs(members) do
        local memberId = memberInfo["rid"]
        local memberActor = getactor(actor, memberId)
        local belong = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_BELONG)
        if belong ~= nil and belong > 0 then
            local ready = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY)
            if ready == ReadyState.READY then
                local check = DuplicateEnterCheckDispath:check(dupType, memberActor, configId)
                if check ~= EnterLimitResultConst.ALLOW then
                    tipinfo(memberActor, "条件不满足")
                    setplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY, ReadyState.REJECT)
                    this.resBreakDupTeam(memberActor)
                end
            elseif ready == ReadyState.NONE then
                setplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY, ReadyState.REJECT)
            end
        end
    end
end

function this.teamEnterCheck(leader, configId)
    local config = DuplicateCommon.getRepConfig(configId)
    local minSize = config.minSize
    local maxSize = config.maxSize
    local nowSize = 0
    if minSize > 0 and maxSize > 0 then
        local teamId = getbaseinfo(leader, "teamid")
        local teamInfo = getteaminfo(leader, teamId)
        local members = teamInfo["allteammemberinfo"]
        for index, memberInfo in ipairs(members) do
            local memberId = memberInfo["rid"]
            local memberActor = getactor(leader, memberId)
            if this.isMemberAvailable(memberActor) then
                nowSize = nowSize + 1
            end
        end
        if nowSize < minSize or nowSize > maxSize then
            return false, nowSize
        end
    end
    return true, nowSize
end

-- 通知队员准备并返回准备面板
function this.callTeamMembersPrepare(actor, configId)
    local teamId = getbaseinfo(actor, "teamid")
    local teamInfo = getteaminfo(actor, teamId)
    local members = teamInfo["allteammemberinfo"]
    for index, memberInfo in ipairs(members) do
        local memberId = memberInfo["rid"]
        local memberActor = getactor(actor, memberId)
        if this.isMemberAvailable(memberActor) then
            -- 设置组队副本归属，方便后续拉人等操作
            setplaydef(memberActor, PlayerDefKey.DUP_TEAM_BELONG, configId)
            setplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY, ReadyState.NONE)
        end
    end
    --队长默认准备
    setplaydef(actor, PlayerDefKey.DUP_TEAM_READY, ReadyState.READY)
    this.resAllTeamPreparePanel(actor, configId)
end

-- 给成员返回准备面板
function this.resAllTeamPreparePanel(actor, configId, except)
    local teamId = getbaseinfo(actor, "teamid")
    local msg = this.buildTeamPrepareMsg(actor, teamId, configId)
    local teamInfo = getteaminfo(actor, teamId)
    local members = teamInfo["allteammemberinfo"]
    for index, memberInfo in ipairs(members) do
        local memberId = memberInfo["rid"]
        if tostring(memberId) ~= tostring(except) then
            local memberActor = getactor(actor, memberId)
            local state = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY)
            if state ~= ReadyState.REJECT then
                local belong = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_BELONG)
                if belong ~= nil and belong > 0 then
                    sendluamsg(memberActor, LuaMessageIdToClient.RES_DUPLICATE_TEAM_INFO, msg)
                end
            end
        end
    end
end

-- 构建组队准备消息
function this.buildTeamPrepareMsg(actor, teamId, configId)
    local msg = {}
    local teamInfo = getteaminfo(actor, teamId)
    local members = teamInfo["allteammemberinfo"]
    local memberList = {}
    local dupType = DuplicateCommon.GetDuplicateType(configId)
    for index, memberInfo in ipairs(members) do
        local memberId = memberInfo["rid"]
        local memberActor = getactor(actor, memberId)
        local belong = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_BELONG)
        if belong ~= nil and belong > 0 then
            local innerData = {}
            --玩家名字
            local memberName = getbaseinfo(memberActor, "rolename")
            local check = DuplicateEnterCheckDispath:check(dupType, actor, configId)
            if check == EnterLimitResultConst.ALLOW then
                local ready = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY)
                check = ready
            end
            --玩家职业
            local career = getbaseinfo(memberActor, "getbasecareer")

            innerData["rid"] = memberId
            innerData["name"] = memberName
            innerData["state"] = check
            innerData["career"] = career
            table.insert(memberList, innerData)
        end
    end
    msg["members"] = memberList
    -- 副本配置id
    msg["configId"] = configId
    -- 队长id
    msg["leaderid"] = teamInfo["leaderid"]
    local teamData = this.getTeamInfo(actor, teamId)
    local endTime = teamData.endTime
    local state = teamData.state
    msg["endtime"] = endTime
    msg["state"] = state
    return msg
end

function this.isMemberAvailable(actor)
    -- 在线且不在跨服
    local onlineState = getbaseinfo(actor, "onlinestate")
    if onlineState ~= 1 then
        return false
    end
    -- 不在副本中
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo ~= nil then
        return false
    end
    return true
end

-- 队员修改组队状态
function this.ChangeTeamPrepareState(actor, state, configId)
    local teamId = getbaseinfo(actor, "teamid")
    local dupType = DuplicateCommon.GetDuplicateType(configId)
    if state == DupTeamChangeState.READY then
        if not this.checkLeaderReady(actor, teamId) then
            this.breakDupTeam(actor, teamId)
            return
        end
        local check = DuplicateEnterCheckDispath:check(dupType, actor, configId)
        if check ~= EnterLimitResultConst.ALLOW then
            tipinfo(actor, "条件不满足")
            return
        end
        setplaydef(actor, PlayerDefKey.DUP_TEAM_READY, ReadyState.READY)
        -- 所有玩家都准备了, 则拉人进入副本
        if this.isAllReady(actor, teamId) then
            local teamInfo = getteaminfo(actor, teamId)
            local leader = teamInfo["leaderid"]
            local leaderActor = getactor(leader)
            local teamData = this.getTeamInfo(leaderActor, teamId)
            if teamData.state == 1 then
                local now = getbaseinfo("now")
                local endTime = now + 8000
                this.cancelTimer(leaderActor, teamData.timerId)
                local timerId = intervalcalldelay(leaderActor, 8000, 1000, 1, "dupleaderdoteamenter")
                this.setTeamInfo(leaderActor, teamId, { endTime = endTime, state = 2, timerId = timerId })
            end
        end
        this.resAllTeamPreparePanel(actor, configId)
    elseif state == DupTeamChangeState.REFUSE then
        if not this.checkLeaderReady(actor, teamId) then
            tipinfo(actor, "队长取消准备")
            this.breakDupTeam(actor, teamId)
            return
        end
        setplaydef(actor, PlayerDefKey.DUP_TEAM_READY, ReadyState.REJECT)
        if this.isAllReady(actor, teamId) then
            local teamInfo = getteaminfo(actor, teamId)
            local leader = teamInfo["leaderid"]
            local leaderActor = getactor(leader)
            local teamData = this.getTeamInfo(leaderActor, teamId)
            if teamData.state == 1 then
                local now = getbaseinfo("now")
                local endTime = now + 8000
                this.cancelTimer(leaderActor, teamData.timerId)
                local timerId = intervalcalldelay(leaderActor, 8000, 1000, 1, "dupleaderdoteamenter")
                this.setTeamInfo(leaderActor, teamId, { endTime = endTime, state = 2, timerId = timerId })
            end
        end
        this.resAllTeamPreparePanel(actor, configId, actor:toString())
    elseif state == DupTeamChangeState.BREAK then
        local selfId = getbaseinfo(actor, "rid")
        local teamInfo = getteaminfo(actor, teamId)
        local leaderId = teamInfo["leaderid"]
        if tostring(selfId) ~= tostring(leaderId) then
            gameDebug.assertPrintTrace(false, selfId .. "不是队长,解散副本组队！")
            return
        end
        this.breakDupTeam(actor, teamId)
    end
end

function this.checkLeaderReady(actor, teamId)
    local teamInfo = getteaminfo(actor, teamId)
    local leaderId = teamInfo["leaderid"]
    local leaderActor = getactor(leaderId)
    local readyState = getplaydef(leaderActor, PlayerDefKey.DUP_TEAM_READY)
    if readyState ~= ReadyState.READY then
        return false
    end
    return true
end

function this.isAllReady(actor, teamId)
    local teamInfo = getteaminfo(actor, teamId)
    local members = teamInfo["allteammemberinfo"]
    local readyCount = 0
    for index, memberInfo in ipairs(members) do
        local memberId = memberInfo["rid"]
        local memberActor = getactor(memberId)
        local ready = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY)
        if ready == ReadyState.READY or ready == ReadyState.REJECT then
            readyCount = readyCount + 1
        end
    end
    return readyCount == #members
end

function this.breakDupTeam(actor, teamId)
    local teamInfo = getteaminfo(actor, teamId)
    local members = teamInfo["allteammemberinfo"]
    for index, memberInfo in ipairs(members) do
        local memberId = memberInfo["rid"]
        local memberActor = getactor(actor, memberId)
        this.clearDupTeamVar(memberActor)
        this.resBreakDupTeam(memberActor)
    end
    local teamData = this.getTeamInfo(actor, teamId)
    local leader = teamInfo["leaderid"]
    local leaderActor = getactor(leader)
    this.cancelTimer(leaderActor, teamData.timerId)
    this.setTeamInfo(actor, teamId, {})
end

function this.clearDupTeamVar(actor)
    setplaydef(actor, PlayerDefKey.DUP_TEAM_READY, ReadyState.NONE)
    setplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG, 0)
end

function this.resBreakDupTeam(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_BREAK_DUPLICATE_TEAM, nil)
end

-- 队长拉人进入
function this.pullAllMemberEnterDup(actor, teamInfo, configId)
    local dupType = tonumber(ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId))
    local members = teamInfo["allteammemberinfo"]
    local enterMembers = {}
    for index, memberInfo in ipairs(members) do
        local memberId = memberInfo["rid"]
        local memberActor = getactor(actor, memberId)
        local ready = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY)
        if ready == ReadyState.READY then
            local check = DuplicateEnterCheckDispath:check(dupType, actor, configId)
            if check == EnterLimitResultConst.ALLOW then
                table.insert(enterMembers, memberActor)
            else
                tipinfo(memberActor, "条件不满足")
            end
        end
    end

    if table.isEmpty(enterMembers) then
        return
    end

    if dupType == DuplicateType.BLOODY_CASTLE then
        BloodyCastle.doTeamEnter(actor, enterMembers, configId)
    elseif dupType == DuplicateType.DEVIL_SQUARE then
        DevilSquare.doTeamEnter(actor, enterMembers, configId)
    end
end

function this.getTeamInfo(actor, teamId)
    teamId = tonumber(teamId) or getbaseinfo(actor, "teamid")
    if teamId <= 0 then
        return
    end
    local data = getsysvar(actor, "G$TEAM_DUP_INFO") or {}
    local teamInfo = data[teamId] or {}
    return teamInfo
end

function this.setTeamInfo(actor, teamId, teamInfo)
    teamId = tonumber(teamId) or getbaseinfo(actor, "teamid")
    if teamId <= 0 then
        return
    end
    local data = getsysvar(actor, "G$TEAM_DUP_INFO") or {}
    data[teamId] = teamInfo
    setsysvar(actor, "G$TEAM_DUP_INFO", data)
end

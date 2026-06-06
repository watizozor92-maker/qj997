--[[ 副本通用方法尽量走这里，可复用。
接口：
    1、客户端请求进入副本 DuplicateCommon.ReqEnterDupLicate
    2、客户端请求退出副本 DuplicateCommon.ReqQuitDuplicate
    3、通用创建副本地图 DuplicateCommon.CreateDupMapCommon
    4、多人副本，找一个还在准备阶段的空副本 DuplicateCommon.FindEnterableDupCommon
    5、获取进入副本的x,y坐标 DuplicateCommon.GetEnterPointXYCommon
    6、副本刷怪 DuplicateCommon.DupGenMonsterCommon
    7、创建副本任务通用信息 DuplicateCommon.GenDupTaskInfoCommon
    8、请求修改副本状态 DuplicateCommon.ReqChangeDupState
    9、获取活动剩余次数 DuplicateCommon.ReqGetActivityLeftCount
    10、副本组队通用接口，调用DuplicateCommon.CallTeamMembersPrepare;在DuplicateCommon.DoTeamEnterDup写自己的组队拉人进入逻辑
事件： 事件转移到QFunction-0.lua文件中了
    1、副本阶段更新 dupstateupdate
    2、怪物死亡掉落经验事件 monsterdieexp
    3、玩家进入副本事件 afterenterduplicate
    4、玩家退出副本事件 afterquitduplicate
    5、玩家进入地图事件（可以是普通地图也可以是副本） entermap
    6、地图怪物死亡事件（可以是普通地图也可以是副本） mapmonsterdie
    9、玩家进入视野 PlayerEnterView

通用协议：
    请求：
        REQ_ENTER_DUPLICATE = 2000021, -- 请求进入副本
        REQ_CHANGE_DUPLICATE_STATE = 2000024, -- 修改副本状态
        REQ_QUIT_DUPLICATE = 2000034, -- 请求退出副本
    响应：
        RES_QUIT_DUPLICATE = 1000039, -- 退出副本回包
]]
DuplicateCommon = {}

local this = {}

-- @description 请求获取活动剩余次数
-- @param 玩家对象；活动id
-- @return
function DuplicateCommon.ReqGetActivityLeftCount(actor, activityId)
    local leftCount = getleftcountofactivity(actor, activityId)
    if leftCount < 0 then
        leftCount = 0
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_GET_ACTIVITY_COUNT, { activityId, leftCount })
end

-- @description 客户端请求进入副本
-- @param 玩家对象；cfg_rep的id
-- @return
function DuplicateCommon.ReqEnterDupLicate(actor, configId)
    -- 判断活动是否开启
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    gameDebug.assertNil(activityId, "活动", configId, "配置不存在！")
    local activityInfo = getactivityinfo(activityId)
    if activityInfo["open"] == nil or activityInfo["open"] == false then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT390)
        return
    end
    -- 开服天数判断
    local startDay = ConfigDataManager.getTableValue("cfg_rep", "startDay", "id", configId)
    startDay = tonumber(startDay)
    if startDay ~= nil and startDay ~= "" then
        local serverOpenDays = tonumber(getserveropendays(actor))
        if serverOpenDays < startDay then
            noticeTip.noticeinfo(actor, StringIdConst.TEXT391)
            return
        end
    end
    -- 副本中不能进入另一个副本
    if DuplicateCommon.IsInDuplicate(actor) then
        error("玩家进入副本失败：副本中不能进入另一个副本", actor:toString(), configId)
        return
    end

    -- 副本组队限制
    if DuplicateTeam.checkDupTeamBelongAndBreak(actor) then
        error("玩家进入副本失败：副本组队限制", actor:toString(), configId)
        return
    end

    local teamType = ConfigDataManager.getTableValue("cfg_rep", "team", "id", configId)
    teamType = tonumber(teamType)
    local teamId = getbaseinfo(actor, "teamid")
    if teamType == DupTeamType.PERSONAL then
        if teamId <= 0 then
            this.enterAsSolo(actor, configId)
        else
            tipinfo(actor, "单人副本, 不能组队进入")
        end
    elseif teamType == DupTeamType.TEAM then
        if teamId ~= 0 then
            local isCaptain = this.IsTeamLeader(actor)
            gameDebug.assertTrue(isCaptain, "组队副本非队长点击组队进入", actor:toString())
            DuplicateTeam.enterAsTeam(actor, configId)
        else
            tipinfo(actor, "组队副本, 不能单人进入")
        end
    elseif teamType == DupTeamType.UNION then
        -- 组队成员必须是战盟成员
        -- if teamId == 0 then
        --     this.enterAsSolo(actor, configId)
        -- else
        --     local isCaptain = this.IsTeamLeader(actor)
        --     gameDebug.assertTrue(isCaptain, "组队副本非队长点击组队进入", actor:toString())
        --     gameDebug.assertTrue(this.isAllTeamSameUnion(actor), "组队成员非同战盟成员", actor:toString())
        --     DuplicateTeam.enterAsTeam(actor, configId)
        -- end
    elseif teamType == DupTeamType.NONE then
        if teamId == 0 then
            this.enterAsSolo(actor, configId)
        else
            local isCaptain = this.IsTeamLeader(actor)
            gameDebug.assertTrue(isCaptain, "组队副本非队长点击组队进入", actor:toString())
            DuplicateTeam.enterAsTeam(actor, configId)
        end
    end
end

function this.enterAsSolo(actor, configId)
    local dupType = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    dupType = tonumber(dupType)
    if dupType == DuplicateType.DEVIL_SQUARE then
        -- 进入恶魔广场
        DevilSquare.ReqEnterDevilSquare(actor, configId)
    elseif dupType == DuplicateType.BLOODY_CASTLE then
        --进入血色城堡
        BloodyCastle.ReqEnterBloodyCastle(actor, configId)
    elseif dupType == DuplicateType.RED_FORTRESS then
        RedFortress.ReqEnterFortress(actor, configId)
    elseif dupType == DuplicateType.WOLF_SOUL then
        WolfSoul.ReqEnterWolfSoul(actor)
    elseif dupType == DuplicateType.COMBO_TEST then
        ComboTest.ReqEnterComboTest(actor, configId)
    elseif dupType == DuplicateType.BIG_SECRET_REALM then
        BigSecretRealm.ReqEnterBigSecretRealm(actor, configId)
    elseif dupType == DuplicateType.ROLAND_SEIGE then
        RolandSeige.ReqEnterDupLicate(actor)
    elseif dupType == DuplicateType.KALIMA_TEMP then
        KalimaTemp.ReqEnterComboTest(actor, configId)
    end
end

function this.IsTeamLeader(actor)
    local selfId = getbaseinfo(actor, "rid")
    local teamId = getbaseinfo(actor, "teamid")
    local teamInfo = getteaminfo(actor, teamId)
    return tostring(selfId) == tostring(teamInfo["leaderid"])
end

-- @description 组队限制
-- @param 玩家对象
-- @return true | false ; 提示内容
function this.TeamEnterCheck(actor)
    local teamId = getbaseinfo(actor, "teamid")
    if teamId == 0 then
        return false, "请先创建或加入一个队伍！"
    end
    -- local selfId = getbaseinfo(actor, "rid")
    -- local teamInfo = getteaminfo(actor, teamId)
    -- local leaderId = teamInfo["leaderid"]
    -- if tostring(selfId) ~= tostring(leaderId) then
    --     return false, "您不是队长！"
    -- end
    -- local members = teamInfo["allteammemberinfo"]
    -- for index, memberInfo in ipairs(members) do
    --     local memberId = memberInfo["rid"]
    --     local memberActor = getactor(actor, memberId)
    --     local inDup = this.IsInDuplicate(memberActor)
    --     if inDup then
    --         return false, "队员正在副本中！等待队员退出副本！"
    --     end
    -- end
    return true, ""
end

-- @description 是否在副本中
-- @param actor
-- @return  true-在
function DuplicateCommon.IsInDuplicate(actor)
    return this.IsInDuplicate(actor)
end

function this.IsInDuplicate(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    local mapInfo = getmapinfobyid(mapId)
    if mapInfo["isdup"] == true then
        return true
    else
        return false
    end
end

-- @description 回蓝回血
-- @param 玩家对象
-- @return
function DuplicateCommon.RecoverHPMP(actor)
    --设置血量
    local roleInfo = getplayermaininfo(actor)
    local maxHp = roleInfo["maxhp"]
    sethp(actor, maxHp)
    --设置蓝量
    local maxMap = roleInfo["maxmp"]
    setmp(actor, maxMap)
end

-- @description 通用进入限制条件检查
-- @param 玩家对象，cfg_rep的id
-- @return EnterLimitResultConst
function DuplicateCommon.CheckEnterConditonCommon(actor, configId)
    local playerLevel = tonumber(getbaseinfo(actor, "level"))
    local levelConfig = ConfigDataManager.getTableValue("cfg_rep", "level", "id", configId)
    if not string.isNullOrEmpty(levelConfig) then
        local levelList = string.split(levelConfig, "#")
        local minLevel = tonumber(levelList[1])
        local maxLevel = tonumber(levelList[2])
        if playerLevel < minLevel or playerLevel > maxLevel then
            tipinfo(actor,"等级不足")
            return EnterLimitResultConst.LEVEL
        end
    end
    local activityId = tonumber(ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId))
    if activityId == nil or activityId <= 0 then
        gameDebug.assertPrintTrace(false, actor:toString() .. "进入副本检查, 活动id错误，副本cfgId: " .. configId)
        tipinfo(actor,"活动id错误")
        return false
    end
    local leftCount = getleftcountofactivity(actor, activityId)
    if leftCount <= 0 then
        tipinfo(actor,"活动次数不足")
        return EnterLimitResultConst.COUNT
    end
    local itemString = ConfigDataManager.getTableValue("cfg_rep", "itemId", "id", configId)
    local itemTable = string.toIntIntMap(itemString, "#", "|")
    local otherItemString = ConfigDataManager.getTableValue("cfg_rep", "otherItemId", "id", configId)
    local otherItemTable = string.toIntIntMap(otherItemString, "#", "|")
    local isMeet = true
    for itemId, count in pairs(itemTable) do
        itemId = tonumber(itemId)
        count = tonumber(count)
        local ownCount = getbagitemcountbyid(actor, itemId)
        if ownCount < count then
            isMeet = false
            break
        end
    end

    ---有其他通用消耗也能进入副本
    if not isMeet then
        if not string.isNullOrEmpty(otherItemString) then
            for itemId, count in pairs(otherItemTable) do
                itemId = tonumber(itemId)
                count = tonumber(count)
                local ownCount = getbagitemcountbyid(actor, itemId)
                ---也不够就返回
                if ownCount < count then
                    return EnterLimitResultConst.ITEM
                end
            end
        else
            return EnterLimitResultConst.ITEM
        end
    end
    return EnterLimitResultConst.ALLOW
end

-- @description 通用创建副本地图
-- @param 玩家对象；cfg_rep的id；是否可以离线挂机
-- @return 副本地图唯一id
function DuplicateCommon.CreateDupMapCommon(actor, configId, canHook)
    local dupConfigMap = ConfigDataManager.getById("cfg_rep", configId)
    local mapCfgId = dupConfigMap.mapid
    local type = dupConfigMap.type
    local prepareTime = dupConfigMap.preparetime
    local continuous = dupConfigMap.continuous
    local save = dupConfigMap.save
    local mapId = createduplicate(actor, mapCfgId, type, type, configId, prepareTime, continuous, save, canHook)
    return mapId
end

function DuplicateCommon.getCurrentDupNumById(configId)
    local type = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    local existDupList = getduplicatelist(type)

    if existDupList == nil then
        return 0
    end

    local count = 0
    for index, dupInfo in ipairs(existDupList) do
        local dupConfig = dupInfo["dupcfgid"]
        if tonumber(dupConfig) == tonumber(configId) then
            count = count + 1
        end
    end

    return count
end

-- @description 多人副本，找一个还在准备阶段的空副本
-- @param cfg_rep的id；空余人数
-- @return 副本地图唯一id
function DuplicateCommon.FindEnterableDupCommon(configId, needSize)
    local mapId = 0
    local maxSize = ConfigDataManager.getTableValue("cfg_rep", "warNumMax", "id", configId)
    local type = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    local existDupList = getduplicatelist(type)
    for index, dupInfo in ipairs(existDupList) do
        local players = dupInfo["players"]
        local state = dupInfo["state"]
        local dupConfig = dupInfo["dupcfgid"]
        local leftSize = tonumber(maxSize) - #players
        if state == DuplicateState.PREPARE and leftSize >= needSize and tonumber(dupConfig) == tonumber(configId) then
            mapId = dupInfo["id"]
            break
        end
    end
    return mapId
end

-- @description 获取进入副本的x,y坐标
-- @param configId——cfg_rep的id
-- @return
function DuplicateCommon.GetEnterPointXYCommon(configId)
    local mapMoveString = ConfigDataManager.getTableValue("cfg_rep", "mapMove", "id", configId)
    local mapMoveIds = string.split(mapMoveString, "#")
    local randomIndex = math.random(#mapMoveIds)
    local randomId = mapMoveIds[randomIndex]
    local x = ConfigDataManager.getTableValue("cfg_mapMove", "mapX", "id", randomId)
    local y = ConfigDataManager.getTableValue("cfg_mapMove", "mapY", "id", randomId)
    return tonumber(x), tonumber(y)
end

-- @description 通用副本刷怪
-- @param 地图唯一id；刷怪表id(cfg_repMonster)
-- @return
function DuplicateCommon.DupGenMonsterCommon(mapId, configId)
    local monsterStr = ConfigDataManager.getTableValue("cfg_repMonster", "monster", "id", configId)

    local monsterStrList = string.split(monsterStr, "|")

    local monsterActors = {}
    for _, value in ipairs(monsterStrList) do
        local params = string.split(value, "#")
        local monId = params[1]
        local count = params[2]
        local x = params[3]
        local y = params[4]
        local range = params[5]
        local monsterActor = mongen(mapId, x, y, range, monId, count)
        table.insertArray(monsterActors, monsterActor)
        --monsterActors[index] = monsterActor
    end
    return monsterActors
end

-- @description 创建副本任务通用信息
-- @param 任务id
-- @return 任务信息
function DuplicateCommon.GenDupTaskInfoCommon(taskId)
    local ret
    local taskType = ConfigDataManager.getTableValue("cfg_repTask", "type", "id", taskId)
    taskType = tonumber(taskType)
    local param = ConfigDataManager.getTableValue("cfg_repTask", "param", "id", taskId)
    if taskType == DuplicateTaskType.KILL_MONSTER_COUNT then
        ret = { taskId, taskType, tonumber(param), 0 }
    elseif taskType == DuplicateTaskType.KILL_TARGET_MONSTER then
        local split = string.split(param, "#")
        local targetId = tonumber(split[1])
        local count = tonumber(split[2])
        ret = { taskId, taskType, count, 0, targetId }
    elseif taskType == DuplicateTaskType.PICK_TARGET_ITEM then
        ret = { taskId, taskType, 1, 0 }
    elseif taskType == DuplicateTaskType.ROLAND_SEIGE_OCCUPY then
        ret = { taskId, taskType, 1, 0 }
    end
    return ret
end

-- @description 请求退出副本
-- @param 玩家对象
-- @return
function DuplicateCommon.ReqQuitDuplicate(actor, msgData)
    if msgData == nil then
        quitduplicate(actor)
        return
    end
    local type = ConfigDataManager.getTableValue("cfg_rep", "type", "id", msgData)
    if tonumber(type) == DuplicateType.COMBO_TEST then
        ComboTest.quitDuplicate(actor, msgData)
    elseif tonumber(type) == DuplicateType.BIG_SECRET_REALM then
        BigSecretRealm.quitBigSecretRealm(actor, msgData)
    elseif tonumber(type) == DuplicateType.KALIMA_TEMP then
        KalimaTemp.quitDuplicate(actor, msgData)
    end
    quitduplicate(actor)
end

-- @description 请求修改副本状态
-- @param 玩家对象; 下一阶段
-- @return
function DuplicateCommon.ReqChangeDupState(actor, state)
    local mapId = getbaseinfo(actor, "unimapid")
    local mapInfo = getmapinfobyid(mapId)
    if mapInfo["isdup"] == false then
        return
    end
    setduplicatestate(mapId, state)
end

-- @description 玩家进入视野
-- @param 玩家对象；进入视野的玩家对象
-- @return
function DuplicateCommon.PlayerEnterView(actor, target)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == false or dupInfo == nil then
        return
    end
    local dupType = dupInfo["type"]
    if dupType == DuplicateType.BLOODY_CASTLE then
        BloodyCastle.PlayerEnterView(actor, target, mapId)
    end
end

-- @description 副本组队准备
-- @param 玩家对象；配置id
-- @return
function DuplicateCommon.CallTeamMembersPrepare(actor, configId)
    -- local teamId = getbaseinfo(actor, "teamid")
    -- local teamInfo = getteaminfo(actor, teamId)
    -- local members = teamInfo["allteammemberinfo"]
    -- for index, memberInfo in ipairs(members) do
    --     local memberId = memberInfo["rid"]
    --     local memberActor = getactor(actor, memberId)
    --     setplaydef(memberActor, PlayerDefKey.DUP_TEAM_BELONG, configId)
    --     setplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY, false)
    -- end
    -- --队长默认准备
    -- setplaydef(actor, PlayerDefKey.DUP_TEAM_READY, true)
    -- DuplicateCommon.ResAllTeamPreparePanel(actor, configId)
end

-- @description 副本组队面板全体回包
-- @param 玩家对象；配置id；除外的玩家id
-- @return
function DuplicateCommon.ResAllTeamPreparePanel(actor, configId, except)
    -- local teamId = getbaseinfo(actor, "teamid")
    -- local msg = DuplicateCommon.BuildTeamPrepareMsg(actor, teamId, configId)
    -- local teamInfo = getteaminfo(actor, teamId)
    -- local members = teamInfo["allteammemberinfo"]
    -- for index, memberInfo in ipairs(members) do
    --     -- todo 给客户端回包
    --     local memberId = memberInfo["rid"]
    --     if tostring(memberId) ~= tostring(except) then
    --         local memberActor = getactor(actor, memberId)
    --         sendluamsg(memberActor, LuaMessageIdToClient.RES_DUPLICATE_TEAM_INFO, msg)
    --     end
    -- end
end

-- @description 副本组队面板回包
-- @param 玩家对象；配置id
-- @return
function DuplicateCommon.ResTeamPreparePanel(actor, configId)
    -- local teamId = getbaseinfo(actor, "teamid")
    -- local msg = DuplicateCommon.BuildTeamPrepareMsg(actor, teamId, configId)
    -- sendluamsg(actor, LuaMessageIdToClient.RES_DUPLICATE_TEAM_INFO, msg)
end

-- @descrip0tion 构建组队准备消息
-- @param 玩家对象；队伍id
-- @return 响应消息
function DuplicateCommon.BuildTeamPrepareMsg(actor, teamId, configId)
    -- local msg = {}
    -- local teamInfo = getteaminfo(actor, teamId)
    -- local members = teamInfo["allteammemberinfo"]
    -- local memberList = {}
    -- for index, memberInfo in ipairs(members) do
    --     local innerData = {}
    --     local memberId = memberInfo["rid"]
    --     local memberActor = getactor(actor, memberId)
    --     --玩家名字
    --     local memberName = getrolefield(memberActor, "role.basic.name")
    --     local check = DuplicateCommon.CheckEnterConditonCommon(memberActor, configId)
    --     if check == EnterLimitResultConst.ALLOW then
    --         local ready = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY)
    --         if ready ~= true then
    --             check = EnterLimitResultConst.REFUSE
    --         end
    --     end
    --     --玩家职业
    --     local career = getrolefield(memberActor, "role.basic.career.basecareer")

    --     innerData["rid"] = memberId
    --     innerData["name"] = memberName
    --     innerData["state"] = check
    --     innerData["career"] = career
    --     table.insert(memberList, innerData)
    -- end
    -- msg["members"] = memberList
    -- -- 副本配置id
    -- msg["configId"] = configId
    -- -- 队长id
    -- msg["leaderid"] = teamInfo["leaderid"]
    -- return msg
end

-- @description 修改副本组队状态
-- @param 玩家对象；状态
-- @return
function DuplicateCommon.ChangeTeamPrepareState(actor, state)
    -- local configId = getplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG)
    -- state = tonumber(state)
    -- local teamId = getbaseinfo(actor, "teamid")
    -- local name = getrolefield(actor, "role.basic.name")
    -- if state == DupTeamChangeState.READY then
    --     if DuplicateCommon.CheckEnterConditonCommon(actor, configId) ~= EnterLimitResultConst.ALLOW then
    --         return
    --     end
    --     setplaydef(actor, PlayerDefKey.DUP_TEAM_READY, true)
    --     DuplicateCommon.ResAllTeamPreparePanel(actor, configId)
    -- elseif state == DupTeamChangeState.REFUSE then
    --     setplaydef(actor, PlayerDefKey.DUP_TEAM_READY, false)
    --     DuplicateCommon.ResAllBreakDupTeam(actor, teamId)
    --     DuplicateCommon.ResTipsAllTeam(actor, teamId, name .. "取消进入副本")
    -- elseif state == DupTeamChangeState.BREAK then
    --     local selfId = getbaseinfo(actor, "rid")
    --     local teamInfo = getteaminfo(actor, teamId)
    --     local leaderId = teamInfo["leaderid"]
    --     if tostring(selfId) ~= tostring(leaderId) then
    --         gameDebug.assertPrintTrace(false, selfId .. "不是队长,解散副本组队！")
    --         return
    --     end
    --     DuplicateCommon.ResAllBreakDupTeam(actor, teamId)
    --     DuplicateCommon.ResTipsAllTeam(actor, teamId, name .. "取消进入副本")
    -- end
end

-- @description 副本队伍全体tips
-- @param 玩家对象
-- @return
function DuplicateCommon.ResTipsAllTeam(actor, teamId, tip)
    local teamInfo = getteaminfo(actor, teamId)
    local members = teamInfo["allteammemberinfo"]
    for index, memberInfo in ipairs(members) do
        local memberId = memberInfo["rid"]
        local memberActor = getactor(actor, memberId)
        tipinfo(memberActor, tip)
    end
end

-- @description 副本队伍解散全体回包
-- @param 玩家对象
-- @return
function DuplicateCommon.ResAllBreakDupTeam(actor, teamId)
    -- local teamInfo = getteaminfo(actor, teamId)
    -- local members = teamInfo["allteammemberinfo"]
    -- for index, memberInfo in ipairs(members) do
    --     local memberId = memberInfo["rid"]
    --     local memberActor = getactor(actor, memberId)
    --     DuplicateCommon.ResBreakDupTeam(memberActor)
    -- end
end

-- @description 副本队伍解散回包
-- @param 玩家对象
-- @return
function DuplicateCommon.ResBreakDupTeam(actor)
    -- setplaydef(actor, PlayerDefKey.DUP_TEAM_READY, false)
    -- setplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG, 0)
    -- sendluamsg(actor, LuaMessageIdToClient.RES_BREAK_DUPLICATE_TEAM, nil)
end

-- @description 倒计时结束，队长拉人进入
-- @param 玩家对象
-- @return
function DuplicateCommon.DoTeamEnterDup(actor)
    -- local configId = getplaydef(actor, PlayerDefKey.DUP_TEAM_BELONG)
    -- if configId <= 0 or configId == nil then
    --     return
    -- end
    -- local teamId = getbaseinfo(actor, "teamid")
    -- local selfId = getbaseinfo(actor, "rid")
    -- local teamInfo = getteaminfo(actor, teamId)
    -- local leaderId = teamInfo["leaderid"]
    -- if tostring(selfId) ~= tostring(leaderId) then
    --     gameDebug.assertPrintTrace(false, selfId .. "不是队长，组队进入副本！")
    --     return
    -- end
    -- local members = teamInfo["allteammemberinfo"]
    -- for index, memberInfo in ipairs(members) do
    --     local memberId = memberInfo["rid"]
    --     local memberActor = getactor(actor, memberId)
    --     local name = getrolefield(memberActor, "role.basic.name")
    --     local ready = getplaydef(memberActor, PlayerDefKey.DUP_TEAM_READY)
    --     if ready ~= true then
    --         DuplicateCommon.ResTipsAllTeam(actor, teamId, name .. "未准备")
    --         return
    --     end
    -- end
    -- local dupType = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    -- dupType = tonumber(dupType)
    -- if dupType == DuplicateType.DEVIL_SQUARE then
    --     DevilSquare.DoTeamEnter(actor, teamId, configId)
    -- elseif dupType == DuplicateType.BLOODY_CASTLE then
    --     --进入血色城堡
    --     BloodyCastle.DoTeamEnter(actor, teamId, configId)
    -- end
end

---根据地图信息获取怪物数量
---@param actor 玩家对象
---@param msgData 消息对象 mapCfgId：地图configId、line：地图线路、monsterCfgId：怪物configId、state：怪物状态(1:未死亡，0:所有)
function DuplicateCommon.getmonstercountbymap(actor, msgData)
    local mapCfgId = msgData.mapCfgId
    if not mapCfgId then
        error("getmonstercountbymap param mapCfgId is nil")
        return
    end
    local line = msgData.line
    if not line then
        error("getmonstercountbymap param line is nil")
        return
    end
    local monsterCfgId = msgData.monsterCfgId
    if not monsterCfgId then
        error("getmonstercountbymap param monsterCfgId is nil")
        return
    end
    local state = msgData.state
    if not state then
        error("getmonstercountbymap param state is nil")
        return
    end
    local monsterCount = getmapmonstercountbyid(actor, tonumber(mapCfgId), tonumber(line), tonumber(monsterCfgId),
        tonumber(state))
    sendluamsg(
        actor,
        LuaMessageIdToClient.MONSTER_COUNT_RESULT,
        {
            mapCfgId     = mapCfgId,
            line         = line,
            monsterCfgId = monsterCfgId,
            state        = state,
            monsterCount = monsterCount
        }
    )
end

---根据boss表id获取怪物数量
---@param actor 玩家对象
---@param msgData 消息对象 id：cfg_BOSS_challenge表id、state：怪物状态(1:未死亡，0:所有)
function DuplicateCommon.getmonstercountbyid(actor, msgData)
    local res = {}
    for _, value in pairs(msgData) do
        local id = value.id
        if not id then
            error("getmonstercountbyid param id is nil")
            return
        end
        local state = value.state
        if not state then
            error("getmonstercountbyid param state is nil")
            return
        end
        local tableResult = ConfigDataManager.getTable("cfg_BOSS_challenge", "id", id)
        if not tableResult or not next(tableResult) then
            error("getmonstercountbyid tableResult is nil")
            return
        end
        local monsterCfgId = tableResult[1].monsterid
        local mapId = tableResult[1].mapid
        local dupType = tableResult[1].monstertype
        local temp = {}
        for _, v in pairs(string.split(mapId, "|")) do
            local mapInfo = string.split(v, "#")
            for i = 2, #mapInfo, 2 do
                local mapCfgId = mapInfo[i - 1]
                local line = mapInfo[i]
                local monsterCount = this.getMosnterCount(actor, dupType, tonumber(mapCfgId), tonumber(line), tonumber(monsterCfgId), tonumber(state))
                table.insert(temp, {
                    id           = tonumber(id),
                    mapCfgId     = tonumber(mapCfgId),
                    line         = tonumber(line),
                    monsterCfgId = tonumber(monsterCfgId),
                    state        = tonumber(state),
                    monsterCount = tonumber(monsterCount)
                })
            end
        end
        res[id] = temp
    end
    sendluamsg(actor, LuaMessageIdToClient.MONSTER_COUNT_RESULT_BY_ID, res)
end

-- @description 退出游戏
-- @param 玩家对象
-- @return
function DuplicateCommon.OfflineQuitGame(actor)
    local ready = getplaydef(actor, PlayerDefKey.DUP_TEAM_READY)
    if ready then
        DuplicateCommon.ChangeTeamPrepareState(actor, DupTeamChangeState.REFUSE)
    end
end

function this.getMosnterCount(actor, dupType, mapId, line, monsterId, state)
    return getmapmonstercountbyid(actor, tonumber(mapId), tonumber(line), tonumber(monsterId), state)
end

---更新副本任务进度
function this.UpdateDupTask(actor, reqCfgId, dupType)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.FINISH_DUPLICATE, dupType)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.FINISH_GOAL_DUP, reqCfgId)
end

function this.RecordDupCount(actor, reqCfgId, dupType)
    this.RecordDupFinishCount(actor, dupType, PlayerDefKey.duplicate.DUP_TYPE_FINISH_COUNT)
    this.RecordDupFinishCount(actor, reqCfgId, PlayerDefKey.duplicate.DUP_FLOOR_FINISH_COUNT)
end

function this.RecordDupFinishCount(actor, countKey, varName)
    if string.isNullOrEmpty(varName) then
        return
    end
    local countRecord = getplaydef(actor, varName)
    if countRecord == nil then
        countRecord = {}
    end
    local oldCount = tonumber(countRecord[countKey])
    if oldCount == nil then
        oldCount = 0
    end
    countRecord[countKey] = oldCount + 1
    setplaydef(actor, varName, countRecord)
end

---获取副本完成次数
function DuplicateCommon.GetDupFinishCount(actor, countKey, varName)
    if varName == nil or countKey == nil then
        return 0
    end
    local countRecord = getplaydef(actor, varName)
    if table.isNullOrEmpty(countRecord) then
        return 0
    end
    local totalCount = countRecord[countKey]
    if totalCount == nil then
        return 0
    end
    return tonumber(totalCount)
end

---@description 完成一次副本活动后调用
---@param actor table 玩家对象
---@param reqCfgId number cfg_rep的id
function DuplicateCommon.FinishDupActivity(actor, reqCfgId)
    local typeParam = ConfigDataManager.getTableValue("cfg_rep", "type", "id", reqCfgId)
    if typeParam == nil then
        return
    end
    local dupType = tonumber(typeParam)
    local contains = table.contains(DuplicateType, dupType)
    ---未定义的副本类型
    if not contains then
        return
    end
    local cfgId = tonumber(reqCfgId)
    --更新副本完成次数
    this.RecordDupCount(actor, cfgId, dupType)
    --更新任务进度
    this.UpdateDupTask(actor, cfgId, dupType)
end

---@description 扫荡副本
---@param actor 玩家对象
---@param configId number cfg_rep的id
---@param count number 扫荡副本次数
function DuplicateCommon.sweepThroughDungeons(actor, configId, count)
    if DuplicateCommon.CheckEnterCountConditonCommon(actor, configId, count) ~= EnterLimitResultConst.ALLOW then
        return
    end
    local dupType = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    dupType = tonumber(dupType)
    if dupType == DuplicateType.COMBO_TEST then
        -- 连击试炼
        ComboTest.sweepThroughDungeons(actor, configId, count)
    elseif dupType == DuplicateType.KALIMA_TEMP then
        -- 卡利玛
        KalimaTemp.sweepThroughDungeons(actor, configId)
    end
end

-- @description 通用进入限制条件检查
-- @param 玩家对象，cfg_rep的id
-- @return EnterLimitResultConst
function DuplicateCommon.CheckEnterCountConditonCommon(actor, configId, count)
    local playerLevel = tonumber(getbaseinfo(actor, "level"))
    local levelConfig = ConfigDataManager.getTableValue("cfg_rep", "level", "id", configId)
    if not string.isNullOrEmpty(levelConfig) then
        local levelList = string.split(levelConfig, "#")
        local minLevel = tonumber(levelList[1])
        local maxLevel = tonumber(levelList[2])
        if playerLevel < minLevel or playerLevel > maxLevel then
            tipinfo(actor,"等级不足")
            return EnterLimitResultConst.LEVEL
        end
    end
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    local leftCount = getleftcountofactivity(actor, activityId)
    if leftCount <= 0 or leftCount < count then
        tipinfo(actor,"次数不足")
        return EnterLimitResultConst.COUNT
    end
    local itemString = ConfigDataManager.getTableValue("cfg_rep", "itemId", "id", configId)
    local itemTable = string.toIntIntMap(itemString, "#", "|")
    for itemId, needCount in pairs(itemTable) do
        itemId = tonumber(itemId)
        needCount = tonumber(needCount) * count
        local ownCount = getbagitemcountbyid(actor, itemId)
        if ownCount < needCount then
            print("道具不足", itemId, ownCount, needCount)
            return EnterLimitResultConst.ITEM
        end
    end
    return EnterLimitResultConst.ALLOW
end

-- @description 通用扣除道具和次数
-- @param 玩家对象；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function this.RemoveItemBeforeEnter(actor, configId, action)
    local itemString = ConfigDataManager.getTableValue("cfg_rep", "itemId", "id", configId)
    local itemTable = string.toIntIntMap(itemString, "#", "|")
    local otherItemString = ConfigDataManager.getTableValue("cfg_rep", "otherItemId", "id", configId)
    local otherItemTable = string.toIntIntMap(otherItemString, "#", "|")
    local isMeet = true
    local itemMap = itemTable
    for itemId, count in pairs(itemTable) do
        itemId = tonumber(itemId)
        count = tonumber(count)
        local ownCount = getbagitemcountbyid(actor, itemId)
        if ownCount < count then
            isMeet = false
            break
        end
    end
    ---有其他通用消耗也能进入副本
    if not isMeet then
        if not string.isNullOrEmpty(otherItemString) then
            for itemId, count in pairs(otherItemTable) do
                itemId = tonumber(itemId)
                count = tonumber(count)
                local ownCount = getbagitemcountbyid(actor, itemId)
                ---也不够就返回
                if ownCount < count then
                    return false
                end
            end
        else
            return false
        end
        itemMap = otherItemTable
    end
    -- 扣除次数
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    reduceactivitytimes(actor, activityId)
    -- 扣除道具
    for key, value in pairs(itemMap) do
        removeitemfrombag(actor, key, value, 0, 9999, action)
    end
    return true
end

function DuplicateCommon.playerDie(actor, dieInfo, killInfo)
    local dupInfo = getduplicate(getbaseinfo(actor, "unimapid"))
    if dupInfo ~= nil then
        local dupType = dupInfo["type"]
        if dupType == DuplicateType.DEVIL_SQUARE then
            DevilSquare.playerDie(actor)
        elseif dupType == DuplicateType.BLOODY_CASTLE then
            BloodyCastle.playerDie(actor)
        end
    end
end

function DuplicateCommon.getRepConfig(configId)
    local ret = {}
    local config = ConfigDataManager.getById("cfg_rep", configId)
    ret.id = tonumber(config.id)
    ret.type = tonumber(config.type)
    ret.replevel = tonumber(config.replevel)
    ret.costItem = string.toIntIntMap(config.itemid)
    ret.genMonCfgId = tonumber(config.monster)
    ret.taskId = tonumber(config.reptarget)
    ret.minSize = string.tonumber(config.warnum)
    ret.maxSize = string.tonumber(config.warnummax)
    ret.reward = string.toIntIntMap(config.reward, "#", "|")
    return ret
end

function DuplicateCommon.GetDuplicateType(configId)
    return tonumber(ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId))
end

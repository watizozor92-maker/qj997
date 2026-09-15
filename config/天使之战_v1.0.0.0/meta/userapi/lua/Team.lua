Team = {}
local this = {}

-- 获取队伍喊话信息
function Team.getteamrecruitlua(actor, msgID)
    local info = {}
    local teamId = getbaseinfo(actor, "teamid")
    if not teamId or teamId == 0 then
        sendluamsg(actor, LuaMessageIdToClient.TEAM_RECRUIT_CHANGE, info)
        return
    end
    local teamInfo = getteaminfo(actor, teamId)
    if teamInfo == nil then
        sendluamsg(actor, LuaMessageIdToClient.TEAM_RECRUIT_CHANGE, info)
        return
    end
    local allTeamMemberInfo = teamInfo["allteammemberinfo"]
    local leaderRid
    for index, value in ipairs(allTeamMemberInfo) do
        local leader = value["leader"]
        if leader == 1 then
            leaderRid = value["rid"]
        end
    end

    local targetactor
    if actor:toString() == tostring(leaderRid) then
        targetactor = actor
    end
    if actor:toString() ~= tostring(leaderRid) then
        targetactor = getactor(actor, leaderRid)
    end


    local teamShout = getplaydef(targetactor, tostring(teamId))
    if teamShout == nil then
        sendluamsg(actor, LuaMessageIdToClient.TEAM_RECRUIT_CHANGE, info)
        return
    end
    info["activeid"] = teamShout[2]
    info["lowerlevel"] = tonumber(teamShout[3])
    info["upperlevel"] = tonumber(teamShout[4])

    -- local info = getteamrecruit(actor)
    sendluamsg(actor, LuaMessageIdToClient.TEAM_RECRUIT_CHANGE, info)
end

--给队员发送喊话信息
function Team.teamrecruitchange(actor, activeid, upperlevel, lowerlevel)
    local sendData = {}
    sendData["activeid"] = activeid
    sendData["upperlevel"] = tonumber(upperlevel)
    sendData["lowerlevel"] = tonumber(lowerlevel)
    sendluamsg(actor, LuaMessageIdToClient.TEAM_RECRUIT_CHANGE, sendData)
end

-- 队长一键同意审批记录
function Team.leaderAgreeApply(actor, msgData)
    local applyList = msgData
    local teamId = tonumber(getbaseinfo(actor, "teamid"))
    local notifyLeader = false
    for _, rid in ipairs(applyList) do
        local joinActor = getactor(actor, rid)
        if Team.CanJoin(teamId, joinActor) then
            replyapply(actor, 1, rid)
        else
            tipinfo(joinActor, "队伍中不能有2个以上相同的职业")
            if not notifyLeader then
                tipinfo(actor, "因职业人数限制，有队员不能加入队伍")
                notifyLeader = true
            end
            replyapply(actor, 0, rid)
        end
    end
    -- agreeteamapply(actor)
end

---获取队伍所有成员rid
function Team.GetAllMemberRids(actor)
    if actor == nil then
        return nil
    end
    local allMemberRids = {}
    local teamId = tonumber(getbaseinfo(actor, "teamid"))
    if teamId == nil or teamId == 0 then
        return allMemberRids
    end
    local teamInfo = getteaminfo(actor, teamId)
    if table.isNullOrEmpty(teamInfo) then
        return
    end
    local allTeamMemberInfo = teamInfo["allteammemberinfo"]
    if table.isNullOrEmpty(allTeamMemberInfo) then
        return allMemberRids;
    end
    for _, memberInfo in pairs(allTeamMemberInfo) do
        local rid = tonumber(memberInfo["rid"])
        if rid ~= nil and rid > 0 then
            table.insert(allMemberRids, rid)
        end
    end
    return allMemberRids
end

-- 获取组队经验加成。 例 1.2
function Team.getExpBonus(actor)
    local teamId = getbaseinfo(actor, "teamid")
    if teamId <= 0 then
        return 1
    end
    local teamInfo = getteaminfo(actor, teamId)
    if table.count(teamInfo) <= 0 then
        return 1
    end
    if table.count(teamInfo.allteammemberinfo) <= 0 then
        return 1
    end

    local selfInfo = getplayermaininfo(actor)
    local selfMapId = selfInfo.mapid
    local selfX = selfInfo.x
    local selfY = selfInfo.y

    local needDistance = tonumber(ConfigDataManager.getGlobal(880001))
    local needSec = tonumber(ConfigDataManager.getGlobal(880002))
    local nowSec = getbaseinfo(actor, "nowsec")

    local teamSize = 0
    for _, memberInfo in pairs(teamInfo.allteammemberinfo) do
        local memberData = getplayermaininfo(memberInfo.rid)
        local memberMapId = memberData.mapid
        if selfMapId == memberMapId then
            local memberX = memberData.x
            local memberY = memberData.y
            if selfX ~= nil and selfY ~= nil and memberX ~= nil and memberY ~= nil then
                local dx = math.abs(selfX - memberX)
                local dy = math.abs(selfY - memberY)
                local distance = math.max(dx, dy)
                if distance <= needDistance then
                    local memberActor = getactor(actor, memberInfo.rid)
                    local lastSec = Player.getLastAttackTime(memberActor)
                    if nowSec - lastSec <= needSec then
                        teamSize = teamSize + 1
                    end
                end
            end
        end
    end

    local bonus = ConfigDataManager.getTableValue("cfg_teamExp", "exp", "count", teamSize)
    return tonumber(bonus) / 10000
end


function Team.getShareExp(actor, monsterId, originExp,monCfgId)
    local teamExpMap = {}
    local teamId = getbaseinfo(actor, "teamid")
    if teamId <= 0 then
        return false
    end
    local teamInfo = getteaminfo(actor, teamId)
    if table.count(teamInfo) <= 0 then
        return false
    end
    if table.count(teamInfo.allteammemberinfo) <= 1 then
        return false
    end

    local selfInfo = getplayermaininfo(actor)
    local selfMapId = selfInfo.mapid
    local monsterActor = getactor(actor, monsterId)
    local selfX = getbaseinfo(monsterActor, "x")
    local selfY = getbaseinfo(monsterActor, "y")

  
    local function getNeedDistance(a)
        if DevilSquare.isInDup(a) then
            return tonumber(ConfigDataManager.getGlobal(880003))
        end
        return tonumber(ConfigDataManager.getGlobal(880001))
    end

    local needDistance = getNeedDistance(actor)

    local needSec = tonumber(ConfigDataManager.getGlobal(880002))
    local nowSec = getbaseinfo(actor, "nowsec")

    local teamSize = 0
    for _, memberInfo in pairs(teamInfo.allteammemberinfo) do
        local memberData = getplayermaininfo(memberInfo.rid)
        local memberMapId = memberData.mapid
        if selfMapId == memberMapId then
            local memberX = memberData.x
            local memberY = memberData.y
            if selfX ~= nil and selfY ~= nil and memberX ~= nil and memberY ~= nil then
                local dx = math.abs(selfX - memberX)
                local dy = math.abs(selfY - memberY)
                local distance = math.max(dx, dy)
                if distance <= needDistance then
                    -- local memberActor = getactor(actor, memberInfo.rid)
                    -- local lastSec = Player.getLastAttackTime(memberActor)
                    -- if nowSec - lastSec <= needSec then
                        teamSize = teamSize + 1
                        teamExpMap[tonumber(memberInfo.rid)] = 0
                    -- end
                end
            end
        end
    end

    if teamSize <= 1 then
        return false
    end

    local bonus = ConfigDataManager.getTableValue("cfg_teamExp", "exp", "count", teamSize)
    local rate = tonumber(bonus) / 10000
    local retTeamExp = {}
    local finalExp = originExp * rate
    local shareExp = finalExp / table.count(teamExpMap)
    for key, value in pairs(teamExpMap) do
        local decayRate = MonsterScript.GetExpDecayRate(getactor(key), monCfgId)
        local teamExp = math.round(shareExp * decayRate)
        retTeamExp[key] = teamExp
    end
    
    return true, retTeamExp
end


function Team.sendExpBonusMsg(actor)
    local bonus = Team.getExpBonus(actor)
    local rate = math.floor((bonus - 1) * 10000)
    ExpBonus.changeBonus(actor, BonusType.TEAM_EXP_BONUS, rate, 0, 0)
end

function Team.sendExpBonusMsgAll(teamId)
    local teamInfo = getteaminfo(teamId)
    if teamInfo.teamid == nil then
        return
    end
    local teamSize = table.count(teamInfo.allteammemberinfo)
    if teamSize <= 0 then
        return
    end
    local bonus = ConfigDataManager.getTableValue("cfg_teamExp", "exp", "count", teamSize)
    local rate = tonumber(bonus) - 10000
    for _, memberInfo in pairs(teamInfo.allteammemberinfo) do
        local rid = tonumber(memberInfo["rid"])
        local actor = getactor(rid)
        ExpBonus.changeBonus(actor, BonusType.TEAM_EXP_BONUS, rate, 0, 0)
    end
end

function Team.sendEquipInfo(actor, teamId)
    teamId = tonumber(teamId) or tonumber(getbaseinfo(actor, "teamid"))
    if teamId == nil or teamId == 0 then
        return
    end
    local teamInfo = getteaminfo(actor, teamId)
    if table.isEmpty(teamInfo) then
        return
    end
    local allTeamMember = teamInfo["allteammemberinfo"]
    local leaderId
    local teamMember = {}
    for index, member in ipairs(allTeamMember) do
        local rid = member.rid
        local leader = member.leader
        local mapId = member.mapcfgid
        local mapLine = member.mapline
        local memberActor = getactor(rid)
        if leader == 1 then
            leaderId = rid
        end
        local allEquipInfo = getallequipinfo(memberActor)
        local roleInfoExt = {}
        local unionInfo = getunioninfo(memberActor)
        if unionInfo then
            roleInfoExt.unionId = unionInfo.unionid
            roleInfoExt.unionName = unionInfo.unionname
            local memberinfos = unionInfo.memberinfos
            for k, info in pairs(memberinfos) do
                if k == rid then
                    roleInfoExt.position = info.position
                    break
                end
            end
        end
        roleInfoExt.equip = {}
        for _, equip in pairs(allEquipInfo) do
            local itemExtData = EquipAndAppear.getItemExtData(memberActor, equip.id)
            local lv = itemExtData.strengthlv or 0
            if equip.equipindex > 0 then
                local equipinfo = {
                    id = equip.id,
                    index = equip.equipindex,
                    cfgId = equip.cfgid,
                    strengthlv = lv,
                }
                table.insert(roleInfoExt.equip, equipinfo)
            end
        end
        local roleInfo = {
            rid = rid,
            name = getbaseinfo(memberActor, "rolename"),
            level = getbaseinfo(memberActor, "level"),
            career = {
                baseCareer = getbaseinfo(memberActor, "getbasecareer"),
                careerRank = getbaseinfo(memberActor, "getcareerrank"),
                careerNum = getbaseinfo(memberActor, "getcareernum")
            },
            roleInfoExt = roleInfoExt,
        }
        local oneMember = {
            mapId = mapId,
            mapLine = mapLine,
            hp = getbaseinfo(memberActor, "hp"),
            maxHp = getbaseinfo(memberActor, "maxhp"),
            roleInfo = roleInfo,
        }
        table.insert(teamMember, oneMember)
    end

    local info = {
        leaderId = leaderId,
        teamId = teamId,
        teamMember = teamMember,
    }

    for index, member in ipairs(allTeamMember) do
        local rid = member.rid
        local memberActor = getactor(rid)
        sendluamsg(memberActor, LuaMessageIdToClient.RES_TEAM_EQUIP_INFO, info)
    end
end

function Team.levelUp(actor)
    local teamId = tonumber(getbaseinfo(actor, "teamid"))
    if teamId == nil or teamId == 0 then
        return
    end
    Team.sendEquipInfo(actor, teamId)
end

function Team.quitAfter(actor, teamId)
    Team.sendEquipInfo(actor, teamId)
    local info = {
        leaderId = 0,
        teamId = 0,
        teamMember = {},
    }
    sendluamsg(actor, LuaMessageIdToClient.RES_TEAM_EQUIP_INFO, info)
end



function Team.reqGetTeamMemberPosition(actor)
    local teamId = getbaseinfo(actor, "teamid")
    if teamId <= 0 then
        return
    end
    local teamInfo = getteaminfo(actor, teamId)
    if table.count(teamInfo) <= 0 then
        return
    end
    if table.count(teamInfo.allteammemberinfo) <= 1 then
        return
    end

    local selfMapId = getbaseinfo(actor,"unimapid")

    local res = {}
    for _, memberInfo in pairs(teamInfo.allteammemberinfo) do
        local memberData = getplayermaininfo(memberInfo.rid)
        local memberMapId = memberData.mapid
        if selfMapId == memberMapId then
            local memberX = memberData.x
            local memberY = memberData.y
            if memberX ~= nil and memberY ~= nil and actor:toString() ~= tostring(memberInfo.rid) then
                local d = {}
                d.x = memberX
                d.y = memberY
                d.rid = memberInfo.rid
                table.insert(res,d)
            end
        end
    end

    sendluamsg(actor, LuaMessageIdToClient.RES_GET_TEAM_MEMBER_POSITION, res)
end

function Team.CanJoin(teamId, joinActor, maxCareer)
    local teamInfo = getteaminfo(joinActor, teamId)
    if table.isNullOrEmpty(teamInfo) then
        info(joinActor, "没有队伍信息")
        return false
    end
    local teamActorList = teamInfo.allteammemberinfo
    if teamActorList == nil then
        -- 没有队伍信息
        info(joinActor, "没有队伍信息")
        return false
    end
    local joinCareer = getbaseinfo(joinActor, "getbasecareer")
    local careerMap = {}
    careerMap[joinCareer] = (careerMap[joinCareer] or 0) + 1
    maxCareer = maxCareer or 2
    for _, memberInfo in pairs(teamActorList) do
        local targetRid = tonumber(memberInfo["rid"])
        local targetActor = getactor(joinActor, targetRid)
        local career = getbaseinfo(targetActor, "getbasecareer")
        careerMap[career] = (careerMap[career] or 0) + 1
        if careerMap[career] > maxCareer then
            info(joinActor, "队伍中不能有2个以上相同的职业")            
            return false
        end
    end
    for _, memrid in pairs(teamInfo.offlineteammemberinfo) do
        local targetRid = tonumber(memrid)
        local targetActor = getactor(joinActor, targetRid)
        if not targetActor then
            info(joinActor, "队伍中有不在线的玩家")
            return false
        end
        local career = getbaseinfo(targetActor, "getbasecareer")
        careerMap[career] = (careerMap[career] or 0) + 1
        if careerMap[career] > maxCareer then
            info(joinActor, "队伍中不能有2个以上相同的职业")            
            return false
        end
    end
    return true
end
function Team.JoinTeam(actor, msgData)
    info(msgData)
    local teamId = msgData.teamId
    if not Team.CanJoin(teamId, actor) then
        -- sendmsg(actor, 5, "队伍中不能有2个以上相同的职业")
        tipinfo(actor, "队伍中不能有2个以上相同的职业")
        return
    end
    applyjointeam(actor, teamId)
end

function Team.AgreeJoinTeam(actor, msgData)
    -- info(msgData)
    local leaderId = msgData.leaderId
    if not leaderId then
        info(actor, "请求参数 leaderId 为空")
        return
    end
    local leaderActor = getactor(leaderId)
    if not leaderActor then
        info(actor, "未找到领队信息")
        return
    end
    --自己的队伍
    local teamId = getbaseinfo(actor, "teamid")
    if not Team.CanJoin(teamId, leaderActor) then
        -- sendmsg(actor, 5, "队伍中不能有2个以上相同的职业")
        tipinfo(actor, "队伍中不能有2个以上相同的职业")
        replyapply(actor, 0, leaderId)
        return
    end
    replyapply(actor, 1, leaderId)
end

function Team.AgreeInviteTeam(actor, msgData)
    -- info(msgData)
    local leaderId = msgData.leaderId
    if not leaderId then
        info(actor, "请求参数 leaderId 为空")
        return
    end
    local leaderActor = getactor(leaderId)
    if not leaderActor then
        info(actor, "未找到领队信息")
        return
    end
    --别人的队伍
    local teamId = getbaseinfo(leaderActor, "teamid")
    if not Team.CanJoin(teamId, actor) then
        -- sendmsg(actor, 5, "队伍中不能有2个以上相同的职业")
        tipinfo(actor, "队伍中不能有2个以上相同的职业")
        local rolename = getbaseinfo(actor, "rolename")
        tipinfo(leaderActor, rolename.." 加入队伍失败")
        replyinvitation(actor, leaderId, 0)
        return
    end
    replyinvitation(actor, leaderId, 1)
end

function Team.InviteTeam(actor, msgData)
    local leaderId = msgData.leaderId
    if not leaderId then
        info(actor, "请求参数 leaderId 为空")
        return
    end
    
    local playerId = msgData.playerId
    if not playerId then
        info(actor, "请求参数 playerId 为空")
        return
    end
    local playerActor = getactor(playerId)
    if not playerActor then
        info(actor, "未找到玩家信息")
        return
    end
    local teamId = getbaseinfo(actor, "teamid")
    if not Team.CanJoin(teamId, playerActor) then
        -- sendmsg(actor, 5, "队伍中不能有2个以上相同的职业")
        tipinfo(actor, "队伍中不能有2个以上相同的职业")        
        return
    end

    local autoinvite = getplaydef(playerActor, "T$autoacceptinvite")
    if autoinvite == 1 then
        local rid = getbaseinfo(playerActor, "rid")
        sendteaminvitation(actor, rid)
        -- Team.AgreeInviteTeam(playerActor, { leaderId = leaderId })
        return
    else
        local rid = getbaseinfo(playerActor, "rid")
        sendteaminvitation(actor, rid)
    end
    
end

function Team.OnSettingChange(actor, vtype, oldValue, value)
    info("OnSettingChange", actor, vtype, oldValue, value)    
    if vtype == 2 then
        -- 队伍设置改变
        local valNum = 0
        if type(value) == "string" then
           valNum = (value == "true") and 1 or 0
        elseif type(value) == "number" then
            valNum = value
        elseif type(value) == "boolean" then
            valNum = value and 1 or 0
        end
        setplaydef(actor, "T$autoacceptinvite", valNum)
    end
end


MessageRouter:register(LuaMessageIdToSever.REQ_TEAM_EQUIP_INFO, Team.sendEquipInfo)

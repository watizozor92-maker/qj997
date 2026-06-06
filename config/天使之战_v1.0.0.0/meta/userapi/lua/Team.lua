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
function Team.leaderAgreeApply(actor)
    agreeteamapply(actor)
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
                    local memberActor = getactor(actor, memberInfo.rid)
                    local lastSec = Player.getLastAttackTime(memberActor)
                    if nowSec - lastSec <= needSec then
                        teamSize = teamSize + 1
                        teamExpMap[tonumber(memberInfo.rid)] = 0
                    end
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








MessageRouter:register(LuaMessageIdToSever.REQ_TEAM_EQUIP_INFO, Team.sendEquipInfo)

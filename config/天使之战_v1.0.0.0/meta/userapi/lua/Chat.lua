---
--- Created by zhouzhipeng.
--- DateTime: 2024/8/20 下午1:55
---

Chat = {}
local this = {}

--- 消息类型常量
MsgTypeConst = {
    COMMON              = 0, --普通消息
    TEAM_RECRUIT        = 1, --组队招募
    DUPLICATE_RECRUIT   = 2, --副本招募
    SIEGE_RECRUIT       = 3, --攻城战召唤盟友
    KML_DUPTEAM_RECRUIT = 4, -- KML副本组队招募
    UNRECOGNIZED        = -1, -- 未知
}

--- 聊天频道常量
ChannelConst = {
    SYSTEM   = 0; --系统
    FIGHT    = 1; --战斗
    WORLD    = 2; --世界
    CURRENT  = 3; --当前
    UNION    = 4; --公会
    RECRUIT  = 5; --招募
    NEARBY   = 6; --附近
    TEAM     = 7; --队伍
    PERSONAL = 8; --私聊
    FRIEND   = 9; --好友聊天
    TRADE    = 10; --交易

    CROSS_MAP = 101; --跨服聊天
}

function Chat.onQuitGame(actor)
    setplaydef(actor, "T$chat_on_line", 1)
end

function Chat.login(actor)
    setplaydef(actor, "T$chat_on_line", 0)
end

-- 玩家是否在线
function Chat.playerIsOnLineReq (actor, data)
    -- jprint("playerIsOnLineReq actor:" .. actor:toString() .. ", data类型：" .. type(data) .. "，data:" .. tostring(data))
    local onLineInfo = {}
    for _, id in pairs(data) do
        local targetactor = getactor(id, 1001)
        local value = 1
        if targetactor then
            value = getplaydef(targetactor, "T$chat_on_line")
        end
        local online = {}
        online["rid"] = id
        online["onLine"] = value
        table.insert(onLineInfo, online)
    end
    sendluamsg(actor, LuaMessageIdToClient.PLAYER_IS_ON_LINE_RES, onLineInfo)
    -- jprint("playerIsOnLineReq actor:" .. actor:toString() .. ", 结尾 data类型： " .. type(data) .. "，data:" .. tostring(data))
end

-- 发送招募信息
function Chat.reqRecruitInfo (actor, data)
    -- jprint("reqRecruitInfo actor:" .. actor:toString() .. ", data类型：" .. type(data) .. "，data:" .. tostring(data))
    local cfgId = data["id"]
    local channel = data["channel"]
    local maxLv, minLv = 0, 0
    if cfgId > 0 then
        local repList = ConfigDataManager.getById("cfg_rep", cfgId)
        if repList == nil then
            error(actor, actor "reqRecruitInfo cfg_rep id:", cfgId, "不存在")
            return
        end
        local repCfg = repList
        local levelStr = repCfg["level"]
        local levels = string.split(levelStr, "#")
        minLv = levels[1]
        maxLv = levels[2]
    end
    local teamSize = getbaseinfo(actor, "groupmembercount")
    local teamId = getbaseinfo(actor, "teamid")
    local teamMaxSize = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.TEAM_MEMBER_MAX)
    -- recruit@副本id,最小等级,最高等级,人数,总人数,team_id@
    local msg = "recruit@" .. cfgId .. "," .. minLv .. "," .. maxLv .. "," .. tostring(teamSize) .. "," .. teamMaxSize .. "," .. tostring(teamId) .. "@"

    if channel == 5 then
        local canShout = setteamtochannel(actor, cfgId, minLv, maxLv)
        if canShout == 0 then
            return
        end
    end

    sendtochannel(actor, msg, channel, MsgTypeConst.DUPLICATE_RECRUIT)

end

-- 队伍喊话
function setteamtochannel(actor, cfgId, minLv, maxLv)
    local teamId = getbaseinfo(actor, "teamid")
    if teamId == 0 then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT341)
        return 0
    end
    local teamSize = getbaseinfo(actor, "groupmembercount")
    local teamMaxSize = ConfigDataManager.getTableValue("cfg_global", "value", "id", 121)
    if teamMaxSize == teamSize then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT342)
        return 0
    end
    local teamShout = getplaydef(actor, tostring(teamId))
    local now = getbaseinfo("now")
    if teamShout ~= nil and teamShout[1] > now then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT343)
        return 0
    end
    local nextShoutTime = now + 30000
    local shoutInfo = { nextShoutTime, cfgId, minLv, maxLv }
    setplaydef(actor, tostring(teamId), shoutInfo)
    local teamInfo = getteaminfo(actor, teamId)
    local allTeamMemberInfo = teamInfo["allteammemberinfo"]
    for index, value in ipairs(allTeamMemberInfo) do
        local teamRid = value["rid"]
        local targetactor
        if actor:toString() == tostring(teamRid) then
            targetactor = actor
        elseif actor:toString() ~= tostring(teamRid) then
            targetactor = getactor(actor, teamRid)
        end
        Team.teamrecruitchange(targetactor, cfgId, maxLv, minLv)
    end
    return 1
end

function chattest(actor, rid)
    jprint("测试测试 reqRecruitInfo actor:" .. actor:toString())
    local cfgId = 1
    local maxLv, minLv = 0, 0
    if cfgId > 0 then
        local repList = ConfigDataManager.getById("cfg_rep", cfgId)
        if repList == nil then
            jprint("reqRecruitInfo cfg_rep id:" .. cfgId .. "不存在")
            return
        end
        local repCfg = repList[1]
        local levelStr = repCfg["level"]
        local levels = string.split(levelStr, "#")
        minLv = levels[1]
        maxLv = levels[2]
    end
    local teamSize = getbaseinfo(actor, "groupmembercount")
    local teamId = getbaseinfo(actor, "teamid")
    local teamMaxSize = ConfigDataManager.getTableValue("cfg_global", "value", "id", 121)
    local msg = "recruit@" .. cfgId .. "," .. minLv .. "," .. maxLv .. "," .. tostring(teamSize) .. "," .. teamMaxSize .. "," .. tostring(teamId) .. "@"
    sendtochannel(actor, msg, 5, 2)
    jprint("测试测试 reqRecruitInfo actor:" .. actor:toString() .. ", cfgId： " .. tostring(cfgId) .. "，maxLv:" .. tostring(maxLv) .. ", minLv:" .. tostring(minLv) .. ", teamSize:" .. tostring(teamSize) .. ", teamMaxSize:" .. tostring(teamMaxSize) .. ", teamId:" .. tostring(teamId))

end

function Chat.OutVersionChant(actor, param)
    this.outVersionChant(actor, param)
end

function this.outVersionChant(actor, param)
    local channel = tonumber(param['channel'])
    if channel == ChannelConst.CROSS_MAP then
        this.crossMapChatChannel(actor, param)
    end
end

function this.crossMapChatChannel(actor, param)
    local content = param['content']
    local itemList = param['item']
    local nextChatTime = tonumber(param['nextchattime'])
    local channel = tonumber(param['channel'])

    local config = ConfigDataManager.getById("cfg_system_switch", 229)
    local needlevel = config['needlevel']
    if table.notEmpty(config) then
        local level = getbaseinfo(actor, "level")
        if tonumber(level) < string.tonumber(needlevel) then
            return
        end
    end

    local now = tonumber(getbaseinfo(actor, "now"))
    if now < nextChatTime then
        local logText = "再过".. (math.round((nextChatTime - now) / 1000)) .. "秒可以再次发言。"
        tipinfo(actor, logText)
        return
    end

    local chatParam = {}
    chatParam["content"] = content
    chatParam["item"] = itemList
    chatParam["channel"] = channel
    chatParam["target"] = {}
    chatParam["useworldcd"] = 1
    chatParam["iscrossmap"] = 1
    chatParam["crossmapcondition"] = "checklevel>=" .. needlevel

    outversionchat(actor, chatParam)
end

function this.debug(...)
    gameDebug.print("[Chat]", ...)
end

LoginEventListerTable:eventLister("0", "chat", Chat.login)
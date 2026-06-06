PlayOperation = {
    LOGOUT = "登出游戏",
    GO_TO_ATLANTIS = "前往亚特兰蒂斯",
    GO_TO_DEVIL_SQUARE = "进入恶魔广场",
    GO_TO_BLOODY_CASTLE = "进入血色城堡",
    GO_TO_BRAVE_CHALLENGE = "进入勇气试炼",
    MINUTE_HEART = "分钟心跳",
}


RoleScriptLog = {}
local this = {}


function RoleScriptLog.RoleMinuteHeart(actor)
    RoleScriptLog.Log(actor, PlayOperation.MINUTE_HEART, 1)
end

function RoleScriptLog.RoleLevelUp(actor, level)
    local needLevelCfg = ConfigDataManager.getTableValue("cfg_global", "value", "id", 400)
    local needLevelSplit = string.split(needLevelCfg, "#")
    local needLevel = tonumber(needLevelSplit[1])
    local mailId = tonumber(needLevelSplit[2])
    if tonumber(level) >= needLevel then
        local record = getplaydef(actor, PlayerDefKey.LEVEL_UP_TEST_MAIL_RECORD)
        if record == nil or type(record) ~= "table" then
            record = {}
        end
        local contains = table.contains(record, needLevel)
        if not contains then
            local itemStr = ConfigDataManager.getTableValue("cfg_global", "value", "id", 401)
            local itemMap = string.toIntIntMap(itemStr, "#", "|")
            sendconfigmailbyrid(actor, actor:toString(), mailId, itemMap)
            table.insert(record, needLevel)
            setplaydef(actor, PlayerDefKey.LEVEL_UP_TEST_MAIL_RECORD, record)
        end
    end
end

function RoleScriptLog.CreateRole(actor)
    local now = getbaseinfo("now")
    setplaydef(actor, PlayerDefKey.LAST_LOG_RECORD_TIME, now)
    setplaydef(actor, PlayerDefKey.ONLINE_DURATION, 0)
end

function RoleScriptLog.RoleLogin(actor)
    -- local now = getbaseinfo("now")
    local oldDuration = getplaydef(actor, PlayerDefKey.ONLINE_DURATION)
    if tonumber(oldDuration) == nil then
        setplaydef(actor, PlayerDefKey.ONLINE_DURATION, 0)
    end
    -- setplaydef(actor, PlayerDefKey.LAST_LOG_RECORD_TIME, now)
end

function RoleScriptLog.RoleLogout(actor)
    --todo 记录GM压测日志
    RoleScriptLog.Log(actor, PlayOperation.LOGOUT)
end

function RoleScriptLog.EnterMap(actor, lastMapCfgId, mapCfgId)
    if mapCfgId == 1008 or mapCfgId == 1108 then
        RoleScriptLog.Log(actor, PlayOperation.GO_TO_ATLANTIS)
    end
end

function RoleScriptLog.Log(actor, operation, timeAdd)
    if timeAdd == nil then
        timeAdd = 0
    end
    local oldDuration = getplaydef(actor, PlayerDefKey.ONLINE_DURATION)
    oldDuration = tonumber(oldDuration)
    if oldDuration == nil or oldDuration <= 0 then
        oldDuration = 0
    end
    -- local now = getbaseinfo("now")
    -- local lastLoginMills = getplaydef(actor, PlayerDefKey.LAST_LOG_RECORD_TIME)
    -- if tonumber(lastLoginMills) == nil then
    --     lastLoginMills = now
    -- end
    -- local thisDuration = math.round(math.max(0, (now - lastLoginMills) / 60000))
    local newDuration = oldDuration + timeAdd
    setplaydef(actor, PlayerDefKey.ONLINE_DURATION, newDuration)
    -- setplaydef(actor, PlayerDefKey.LAST_LOG_RECORD_TIME, now)
    logplayoperation(actor, operation, newDuration)
end

-- 注册等级提升事件
-- LevelUpEventListerTable:eventLister("0", "压测日志", RoleScriptLog.RoleLevelUp, 5000)

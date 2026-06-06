--三倍收益
--剩余的3倍收益时间，单位秒
local REMAIN_TIME_KEY = "T$_REMAIN_TRIPLE_INCOME_TIME";
--3倍收益有效截至时间(这个时间有值，表示3倍收益生效)，但是毫秒时间戳
local EFFECT_TIMESTAMP_KEY = "T$_EFFECT_TRIPLE_INCOME_TIME"
--3倍收益时间最新领取时间
local RECEIVE_TIME_KEY =  "T$_TRIPLE_INCOME_RECEIVE_TIME"

-- 5006 globalID的值
local RATE_CACHE = 0


TripleIncome = {}

function TripleIncome.getRateFromConfig()
    if RATE_CACHE > 0 then
        return RATE_CACHE
    end
    local value =  ConfigDataManager.getTableValue("cfg_global", "value","id",5006)
    RATE_CACHE = tonumber(value)
    return RATE_CACHE
end


function TripleIncome.getReceiveTime(actor)
    local timestamp = getplaydef(actor, RECEIVE_TIME_KEY)
    if timestamp == nil then
        return 0
    end
    return tonumber(timestamp)
end

function TripleIncome.setReceiveTime(actor, timestampMills)
    setplaydef(actor, RECEIVE_TIME_KEY, timestampMills)
end

function TripleIncome.getRemainTime(actor) 
    local timeSec = getplaydef(actor, REMAIN_TIME_KEY)
    if timeSec == nil then
        timeSec = 0
    end
    return tonumber(timeSec)
end

function TripleIncome.setRemainTime(actor, num)
    setplaydef(actor,REMAIN_TIME_KEY, num)
end

--增加3倍收益时间
function TripleIncome.AddRemainTime(actor, addNumSec)
    local sMaxLimit = ConfigDataManager.getTableValue("cfg_global","value","id", 5001)
    local maxLimitSec = tonumber(sMaxLimit) * 3600
    
    local time = TripleIncome.getRemainTime(actor)
    local final_time = time + addNumSec

    if(maxLimitSec > 0 and final_time > maxLimitSec) then
        final_time = maxLimitSec
    end

    TripleIncome.setRemainTime(actor, final_time)
    gameDebug.print("-------增加三倍收益时间--------", "rid:" .. actor:toString(), addNumSec, time, final_time, debug.traceback())
end

--减少3倍收益时间
function TripleIncome.subRemainTime(actor, subNumSec)
    local time = TripleIncome.getRemainTime(actor)
    time = time - subNumSec
    time = math.max(time, 0)
    TripleIncome.setRemainTime(actor, time)
end


function TripleIncome.getEffectTimestamp(actor)
    local timestampMills = getplaydef(actor, EFFECT_TIMESTAMP_KEY)
    if timestampMills == nil then
        return 0
    end
    return tonumber(timestampMills)
end


function TripleIncome.setEffectTimestamp(actor, timestampMills)
    setplaydef(actor, EFFECT_TIMESTAMP_KEY, tonumber(timestampMills))
end

--三倍收益是否生效
function TripleIncome.IsEffect(actor)
    local timestampMills = TripleIncome.getEffectTimestamp(actor)
    local now = getbaseinfo("now")
    return timestampMills > now
end

function TripleIncome.GetRate(actor)
    local effect = TripleIncome.IsEffect(actor)
    if effect then
        local rate = TripleIncome.getRateFromConfig()
        return rate / 10000
    else
        return 1
    end
end

--领取时间
function TripleIncome.ReceiveTime(actor, hour)
    hour = tonumber(hour)
    local receiveAll = hour == 0
    local remainSec = TripleIncome.getRemainTime(actor)
    local receiveSec = 0
    if receiveAll then
        receiveSec = remainSec
    else
        local sec = hour * 60 * 60
        if remainSec < sec then
            noticeTip.noticeinfo(actor, StringIdConst.TEXT384)
            return
        end
        receiveSec = sec
    end

    local effectTimestamp = TripleIncome.getEffectTimestamp(actor)
    local now = getbaseinfo("now")
    if effectTimestamp <= 0 or effectTimestamp < now then
        effectTimestamp = now
    end
    
    effectTimestamp = effectTimestamp + receiveSec * 1000
    TripleIncome.setReceiveTime(actor, now)
    TripleIncome.setEffectTimestamp(actor, effectTimestamp)
    TripleIncome.subRemainTime(actor, receiveSec)
    TripleIncome.PanelInfo(actor)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.OPEN_TRIPLE_INCOME)
end

--归还3倍奖励时间
function TripleIncome.ReturnTime(actor)
    local effectTimestamp = TripleIncome.getEffectTimestamp(actor)
    local now = getbaseinfo("now")
    if effectTimestamp <= 0 or effectTimestamp <= now then
        return
    end
    local returnSec = (effectTimestamp - now)/1000
    TripleIncome.AddRemainTime(actor, returnSec)
    TripleIncome.setEffectTimestamp(actor,0)
    TripleIncome.PanelInfo(actor)
end


--返回给客户端的3倍收益信息
function TripleIncome.PanelInfo(actor)
    local now = getbaseinfo("now")
    local effectTimestampMills = TripleIncome.getEffectTimestamp(actor)
    local remainSec = TripleIncome.getRemainTime(actor)
    local effectSec = 0
    if effectTimestampMills > now then
        effectSec = ( effectTimestampMills - now ) / 1000
    end
    local receiveTimestamp = TripleIncome.getReceiveTime(actor);
    local res = {
        remainSec = remainSec,
        effectSec = effectSec,
        receiveTimestamp = receiveTimestamp, --毫秒时间戳
    }
    sendluamsg(actor, LuaMessageIdToClient.TRIPLE_INCOME_INFO, res)
end


function TripleIncome.CheckInGoldMap(actor, mapId)
    local isGoldMap = ConfigDataManager.getTableValue("cfg_map_info", "goldmap", "id", mapId)
    if tonumber(isGoldMap) == 1 then
        -- 检查是否具有特权
        local isPrivilege = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.WILD_LINE)
        if isPrivilege then
            return nil
        end
        -- 检查是否具有特权
        local hasPrivilege, _ = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.GOLD_LINE)
        if hasPrivilege then
            local map_id_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.GOLD_LINE_PRIVILEGE)
            local map_ids = string.split(map_id_str, "#")
            if table.contains(map_ids, tostring(mapId)) then
                return nil
            end
        end
        -- 没有权限
        noticeTip.noticeinfo(actor, StringIdConst.TEXT478)
        return {result = true, reason = "无权限进入此地图"}
    end
    return nil
end

--====== gm测试 ================================
function addtripleincomesec(actor, sec)
    sec = tonumber(sec)
    TripleIncome.AddRemainTime(actor,sec)
    local hour = sec / 3600
    jprint("增加三倍收益时间", sec, hour)
    TripleIncome.ReceiveTime(actor, hour)
    TripleIncome.PanelInfo(actor)
end

function tripleincomepanelinfo(actor)
    local remainTimeSec = TripleIncome.getRemainTime(actor)
    local effectTimestamp = TripleIncome.getEffectTimestamp(actor)
    jprint("三倍收益信息", remainTimeSec, effectTimestamp)
    TripleIncome.PanelInfo(actor)
end
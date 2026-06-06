PreferentialGift = {}
local oneHour = 3600
local function _playerDbTimeKey()
    return "T$GiftEndtimes"
end
local function getTimeInfo(actor)
    return getplaydef(actor, _playerDbTimeKey()) or {}
end

local function setTimeInfo(actor, data)
    setplaydef(actor, _playerDbTimeKey(), data)
end

function PreferentialGift.CheckPreferentialGift(actor)
    local configs = ConfigDataManager.getList("cfg_gift_preferential")
    local rechargeRecord = RechargeRecord.get(actor)
    local giftEndtimes = getTimeInfo(actor)
    local msg = {}
    for _, config in pairs(configs) do
        local giftId = config.id
        local result, endtime = PreferentialGift.doCheck(actor, giftId, rechargeRecord, giftEndtimes)
        if result then
            table.insert(msg, { giftId = giftId, endtime = endtime })
        end
    end
    -- lg("特惠礼包检查:",msg)
    sendluamsg(actor, LuaMessageIdToClient.RES_PREFERENTIAL_BUTTON_PANEL_INFO, msg)
end

function PreferentialGift.doCheck(actor, giftId, rechargeRecord, giftEndtimes)
    local nowSec = getbaseinfo(actor, "nowsec")
    local giftRecoed = rechargeRecord[giftId]
    if giftRecoed then
        return false, nil
    end
    local updateTime = false
    if giftEndtimes[tonumber(giftId)] and nowSec > giftEndtimes[tonumber(giftId)] then
        return false, nil
    elseif not giftEndtimes[tonumber(giftId)] then
        updateTime = true
    end
    local condition = ConfigDataManager.getTableValue("cfg_gift_preferential", "conditions", "id", giftId)
    if condition == '' then
        return false
    end
    local result = ConditionManager.Check(actor, condition)
    if result then
        local endtime
        if updateTime then
            local time = ConfigDataManager.getTableValue("cfg_gift_preferential", "time", "id", giftId)
            endtime = nowSec + tonumber(time) * oneHour
            giftEndtimes[tonumber(giftId)] = endtime
            setTimeInfo(actor, giftEndtimes)
        else
            endtime = giftEndtimes[tonumber(giftId)]
        end
        return true, endtime
    end
    return false, nil
end

function checkgift(actor)
    PreferentialGift.CheckPreferentialGift(actor)
end

-- 注册充值回调事件,在所有充值礼包之后
RechargeEventListerTable:eventLister("0", "特惠礼包", PreferentialGift.CheckPreferentialGift, 99999999)

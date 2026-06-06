
local KEY = {
    LAST_HP_KEY  = "T$LAST_HP",
    LAST_MP_KEY = "T$LAST_MP"
}

HpMpRecover = {}

--记录下血量和蓝量，在进入跨服地图或者登录游戏的时候恢复
function HpMpRecover.record(actor)
    local hp = getbaseinfo(actor, "hp")
    local mp = getbaseinfo(actor, "mp")
    if hp > 0 or mp > 0 then
        setplaydef(actor, KEY.LAST_HP_KEY, hp)
        setplaydef(actor, KEY.LAST_MP_KEY, mp)
    end
end


--恢复血量和蓝量
function HpMpRecover.recover(actor)
    intervalcalldelay(actor, 500, 0, 1, "hpmprecover_recover")
end

function hpmprecover_recover(actor)
    local lastHp = getplaydef(actor, KEY.LAST_HP_KEY)
    local lastMp = getplaydef(actor, KEY.LAST_MP_KEY)
    if (lastHp ~= nil and lastHp > 0) or (lastMp ~= nil and lastMp > 0) then
        local numCurrHp = getbaseinfo(actor, "hp")
        if lastHp ~= nil and lastHp ~= numCurrHp then
            sethp(actor, math.max(lastHp, 1))
        end

        local numCurrMp = getbaseinfo(actor, "mp")
        if lastMp ~= nil and lastMp ~= numCurrMp then
            setmp(actor, math.max(lastMp, 1))
        end
    end
end


function HpMpRecover.recoverMP3sec(actor)
    local numCurrMp = getbaseinfo(actor, "mp")
    local attrValue = getattrinfo(actor, "MPBonus3s")
    local maxMp = getbaseinfo(actor, "maxmp")
    setmp(actor, math.min(maxMp, numCurrMp + attrValue))
end

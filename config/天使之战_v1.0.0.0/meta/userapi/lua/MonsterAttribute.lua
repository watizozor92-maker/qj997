MonsterAttribute = {}
local orignalAttrNames = {
    "maxHP", "minDC", "maxDC", "hitRate", "missRate"
}
local attrNames = {
    "maxhp", "mindc", "maxdc", "hitrate", "missrate"
}
function MonsterAttribute.Initmonster(monster, monsterCfgId)
    local group = ConfigDataManager.getTableValue("cfg_monster", "group", "id", monsterCfgId)
    if group == "" or group == nil then
        error("cfg_monster没有对应的group:" .. monsterCfgId)
        return
    end
    local severOpenDays
    local serverType = getbaseinfo("servertype")
    if serverType == 1 then
        severOpenDays = getbaseinfo("serveropendays")
    elseif serverType == 2 then
        local crossOpenTime = getbaseinfo("crossopentime")
        local nowSec = getbaseinfo("nowsec")
        severOpenDays = TimeUtil.diffDays(crossOpenTime / 1000, nowSec) + 1
    end
    local currLine = MonsterAttribute.GetCurrentLine(group, severOpenDays)

    if currLine == nil then
        error("怪物属性初始化时,cfg_monster_attribute_group没有对应的属性表,怪物配置id:" .. monsterCfgId .. ",开服天数:" .. severOpenDays)
        return
    end

    local attrParams = {}

    for i, attrName in ipairs(attrNames) do
        local value = tonumber(currLine[attrName])
        table.insert(attrParams, orignalAttrNames[i])
        table.insert(attrParams, value)
        --updateattrgroup(monster, "monAttrByOpenday", orignalAttrNames[i], value)
    end
    --一次性写入，只调用一次命令
    if not table.isNullOrEmpty(attrParams) then
        updateattrgroup(monster, "monAttrByOpenday", table.unpack(attrParams))
    end

    --其他属性
    local att = currLine["att"]
    if not string.isNullOrEmpty(att) then
        local attMap = string.toIntIntMap(att, "#", "|")
        updateattrgroup(monster, "monAttrByOpenday", attMap)
    end

    local maxHP = getattrinfo(monster, "maxHP")
    sethp(monster, maxHP)
end

function MonsterAttribute.GetCurrentLine(monsterCfgId, severOpenDays)
    local tabs = ConfigDataManager.getTable("cfg_monster_attribute_group", "monsterid", monsterCfgId, "day",
        severOpenDays)
    if tabs == nil or next(tabs) == nil then
        tabs = ConfigDataManager.getTable("cfg_monster_attribute_group", "monsterid", monsterCfgId, "day", 0)
    end
    if tabs == nil or next(tabs) == nil then
        tabs = MonsterAttribute.GetMaxOpenDayLine(monsterCfgId, severOpenDays)
    end
    if tabs == nil or next(tabs) == nil then
        return nil
    end
    return tabs[1]
end

function MonsterAttribute.GetMaxOpenDayLine(monsterCfgId, severOpenDays)
    local tabs = ConfigDataManager.getTable("cfg_monster_attribute_group", "monsterid", monsterCfgId)
    if tabs == nil or next(tabs) == nil then
        return nil
    end
    local maxDay = 0
    local currLine
    for _, line in ipairs(tabs) do
        local day = tonumber(line["day"])
        if day then
            if day <= severOpenDays and day > maxDay then
                maxDay = day
                currLine = line
            end
        end
    end
    if currLine == nil then
        return nil
    end
    return { currLine }
end

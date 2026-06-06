--处理职业解锁

CareerUnlock = {}

function CareerUnlock.unlock(actor, currLevel)
    --jprint("当前等级", currLevel)
    local configList = ConfigDataManager.getList("cfg_character_create")
    for _, config in pairs(configList) do
        local unlockLevel = table.getValue(config, "unlocklv")
        if not string.isNullOrEmpty(unlockLevel) then
            local unlockLevelNum = tonumber(unlockLevel)
            local id = tonumber(table.getValue(config, "id"))
            --print("比较", unlockLevel, currLevel,id)
            if unlockLevelNum > 0 and currLevel >= unlockLevelNum then
                local uid = getbaseinfo(actor, "uid")
                unlockusercareer(actor, id, uid)
            end
        end
    end
end

-- ------------------------------------------------------------- --

CareerChange = {}

local ChangeCareerItemType = 3
local ChangeCareerItemSubType = 95

local LevelCmd = "@setLv %s"
local CareerCmd = "@transferCareer %s"

-- 该物品为测试道具 无需仔细校验
function CareerChange.useItemChangeCareer(actor, itemId)
    local config = ConfigDataManager.getById("cfg_item", itemId)
    if table.isEmpty(config) then
        return
    end

    local type = tonumber(config['type'])
    local subType = tonumber(config['subtype'])
    if type ~= ChangeCareerItemType or subType ~= ChangeCareerItemSubType then
        return
    end

    local useParamStr = config['useparam']
    if not useParamStr then
        return
    end
    local useParam = string.split(useParamStr, "#")

    local level = getbaseinfo(actor, "level")
    if tonumber(level) < tonumber(useParam[1]) then
        local levelGmCmd = string.format(LevelCmd, useParam[1])
        gmexecute(actor, levelGmCmd)
    end

    local careerGmCmd = string.format(CareerCmd, useParam[2])
    gmexecute(actor, careerGmCmd)
end
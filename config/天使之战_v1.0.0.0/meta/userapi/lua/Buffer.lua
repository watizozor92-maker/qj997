Buffer = {}
NOVICE_PROTECT = "T$_noviceProtect"
BuffType = {
    MOVE = 2,
    SD = 9,
    AG = 10,
    ELITE = 11, -- 精英MM
    HP = 12,    -- 血量
    MP = 13,    -- 蓝量
}

function Buffer.buffeffect(actor, buffCfgId, layers, buffFromType, buffId, casterActor)
	local buffConfig = ConfigDataManager.getById("cfg_buff", buffCfgId)
	if table.isNullOrEmpty(buffConfig) then
		return
	end

    -- 计算公式
    local buffCounts = string.splitInt(buffConfig.buffcount, "#")
    -- 参数
    local buffValues = string.split(buffConfig.buffvalue, "|")
    -- 效果
    local buffParams = string.split(buffConfig.buffparam, "|")    

    local attr = {}
    for key, value in pairs(buffCounts) do
        if value == 7 then
            local attrId = string.splitInt(buffParams[key], "#")[1]
            local attrName = attrid2name(actor, attrId)
            local infos = string.splitInt(buffValues[key], "#")
            local currAttr = getattrinfo(actor, attrid2name(actor, infos[1]))
            local result = (currAttr * 0.0001 * infos[2]) * layers
            local oldValue = attr[attrName] or 0
            attr[attrName] = oldValue + result
        elseif value == 8 then
            local attrId = string.splitInt(buffParams[key], "#")[1]
            local attrName = attrid2name(actor, attrId)
            local infos = string.splitInt(buffValues[key], "#")
            local currAttr = getattrinfo(actor, attrid2name(actor, infos[1]))
            local rate = infos[2] / 10000
            local result = (currAttr * rate) * layers
            local oldValue = attr[attrName] or 0
            attr[attrName] = oldValue + result
        elseif value == BuffType.SD then
            local infos = string.splitInt(buffValues[key], "#")
            local rate = infos[2] / 10000
            AGAndSD.addSDRate(actor, rate)
        elseif value == BuffType.AG then
            local infos = string.splitInt(buffValues[key], "#")
            local rate = infos[2] / 10000
            AGAndSD.addAGRate(actor, rate)
        elseif value == BuffType.ELITE then
            -- EliteMM.calcBuffAttr(actor, buffConfig, layers, buffFromType)
        elseif value == BuffType.HP then
            local infos = string.splitInt(buffValues[key], "#")
            local attrId = infos[1]
            local v = infos[2]
            local rate = infos[3] / 10000
            local level = getbaseinfo(actor, "level")
            local attrName = attrid2name(actor, attrId)
            local maxhp = getattrinfo(actor, attrName)
            local res1 = math.max((v * 10) - (level * 2), 0)
            local res2 = (maxhp * rate)
            local param = infos[4] or 1
            local result = math.floor((res1 + res2) * layers / param)
            local targertAttrId = string.splitInt(buffParams[key], "#")[1]
            local targetAttrName = attrid2name(actor, targertAttrId)
            local oldValue = attr[targetAttrName] or 0
            attr[targetAttrName] = oldValue + result
        elseif value == BuffType.MP then
            local infos = string.splitInt(buffValues[key], "#")
            local attrId = infos[1]
            local v = infos[2]
            local rate = infos[3] / 10000
            local level = getbaseinfo(actor, "level")
            local attrName = attrid2name(actor, attrId)
            local maxhp = getattrinfo(actor, attrName)
            local res1 = math.max((v * 10) - (level), 0)
            local res2 = (maxhp * rate)
            local param = infos[4] or 1
            local result = math.floor((res1 + res2) * layers / param)
            local targertAttrId = string.splitInt(buffParams[key], "#")[1]
            local targetAttrName = attrid2name(actor, targertAttrId)
            local oldValue = attr[targetAttrName] or 0
            attr[targetAttrName] = oldValue + result
        end
    end
    -- for attrName, addValue in pairs(attr) do
    --     jprint("类型7的buff属性查看", attrName, addValue)
    --     updateattrgroup(actor, tostring(buffCfgId), attrName, addValue)
    -- end
    if next(attr) then
        updateattrgroup(actor, tostring(buffCfgId), attr)
    end
end

function Buffer.buffeffectafter(actor, buffCfgId, layers, buffFromType, buffId, casterActor)
    local buffConfig = ConfigDataManager.getById("cfg_buff", buffCfgId)
    if table.isNullOrEmpty(buffConfig) then
        return
    end    
    -- 计算公式
    local buffCounts = string.splitInt(buffConfig.buffcount, "#")
    --20260611 加 41 表示移动到目标地图
    Buffer.moveBuff(buffConfig, actor, casterActor)

    for key, value in pairs(buffCounts) do
        if value == BuffType.ELITE then
            EliteMM.afterBuffEffect(actor, buffConfig, layers, buffFromType, buffId, casterActor)
        end
    end
    Buffer.sendBuffInfo(actor, casterActor)
end

function Buffer.sendBuffInfo(actor, casterActor)
    local type = getbaseinfo(actor, "mapobjecttype")
    if type ~= MapObjectType.PLAYER then
        return
    end
    local info = {}
    local buffs = getbuffinfo(actor)
    if not table.isEmpty(buffs) then
        for i, buff in pairs(buffs) do
            local cfgId = buff.buffcfgid
            local id = buff.buffid
            local layers = buff.layers
            local buffValue = {}
            if EliteMM.isEliteOrSkill(actor, cfgId) then
                buffValue = EliteMM.getBuffValue(casterActor or actor, cfgId, layers)
            else
                buffValue = buff.buffext or {}
            end
            local ite = { buffId = id, buffCfgId = cfgId, buffValue = buffValue }
            table.insert(info, ite)
        end
        sendluamsg(actor, LuaMessageIdToClient.RES_BUFF_VALUES, info)
    else
        sendluamsg(actor, LuaMessageIdToClient.RES_BUFF_VALUES, {})
    end
end

function Buffer.bufflose(actor, buffCfgId, reason)
    clearattrgroup(actor, tostring(buffCfgId))
    EliteMM.tryClear(actor, buffCfgId, reason)
    Buffer.sendBuffInfo(actor)
end

function buffertest(actor)
    local petActor = getactor(10942, 2056193)

    local tab = getallattrinfo(petActor)
    jprint("tab数据：", tab)
    jprint("petActor：", petActor)
    jprint("207011：", tab["207011"])
end

-- 完成任务添加buff
function Buffer.taskProgressComplete(actor, taskId)
    local taskTable = ConfigDataManager.getTableValue("cfg_global", "value", "id", "15001")
    if not taskTable then
        return
    end
    local taskInfo = string.split(taskTable, "#")
    local have = false
    for index, task in pairs(taskInfo) do
        if tonumber(task) == taskId then
            have = true
        end
    end
    local maxLevel = ConfigDataManager.getTableValue("cfg_global", "value", "id", "15002")
    if have and getbaseinfo(actor, "level") < tonumber(maxLevel) then
        local buffCfgId = ConfigDataManager.getTableValue("cfg_global", "value", "id", "15003")
        buffer(actor, buffCfgId)
        setplaydef(actor, NOVICE_PROTECT, true)
    end
end

function Buffer.levelUp(actor, level)
    local maxLevel = ConfigDataManager.getTableValue("cfg_global", "value", "id", "15002")
    if tonumber(maxLevel) < level then
        local buffCfgId = ConfigDataManager.getTableValue("cfg_global", "value", "id", "15003")
        delbuff(actor, buffCfgId)
        setplaydef(actor, NOVICE_PROTECT, false)
    end

    EliteMM.levelup(actor, level)
end

--- 添加安全区域buff
---@param actor table 玩家对象
function Buffer.safetyAreaBuff(actor)
    local globalVar = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId
        .SAFETY_AREA_BUFF_CONFIG)
    if not globalVar or string.isNullOrEmpty(globalVar) then
        jprint("========================================>Buffer.safetyAreaBuff globalVar is nil")
        return
    end
    local onlineState = getbaseinfo(actor, "onlinestate")
    local mapId = getbaseinfo(actor, "mapid")
    local mapConfigId = ConfigDataManager.getTableValue("cfg_global", "value", "id",
        GlobalConfigId.SAFETY_AREA_MAP_CONFIG)
    if not mapConfigId or mapConfigId == "" then
        jprint("========================================>Buffer.safetyAreaBuff mapConfigId is nil")
        return
    end
    local splitTable = string.split(globalVar, "#")
    if not splitTable or not next(splitTable) then
        return
    end
    local mapIds = string.split(mapConfigId, "#")
    if insafezone(actor) and onlineState == 1 and table.getKey(mapIds, tostring(mapId)) then
        for _, buffCfgId in pairs(splitTable) do
            if not hasbuff(actor, buffCfgId) then
                buffer(actor, buffCfgId)
            end
        end
    else
        for _, buffCfgId in pairs(splitTable) do
            if hasbuff(actor, buffCfgId) then
                delbuff(actor, buffCfgId)
                --setplaydef(actor, PlayerDefKey.player.SAFETY_AREA_BUFF, false)
                local roleInfo = getsysvar(SystemVarConst.AUTO_RECOVERY_MAGIC_ROLE_INFO)
                if not roleInfo or roleInfo == "" then
                    return
                end
                for k, v in pairs(roleInfo) do
                    local play = v["actor"]
                    if play:toString() == actor:toString() then
                        table.remove(roleInfo, k)
                    end
                end
                setsysvar(SystemVarConst.AUTO_RECOVERY_MAGIC_ROLE_INFO, roleInfo)
            end
        end
    end
end

--移动BUFF 20260621 luo
function Buffer.moveBuff(buffConfig, actor, casterActor)
    -- 参数
    -- local buffValues = string.split(buffConfig.buffvalue, "|")
    -- 效果
    local buffParams = string.split(buffConfig.buffparam, "|")
    if tonumber(buffConfig.bufftype) == BuffType.MOVE then
        local buffParam = tonumber(buffParams[1])
        if buffParam == 41 then
            local id = getbaseinfo(actor, "id")
            local casterId = getbaseinfo(casterActor or actor, "id")
            -- local rolename = getbaseinfo(actor, "rolename")
            -- local casterRolename = getbaseinfo(casterActor, "rolename")
            -- info(actor, "actor:" .. rolename .. ", id:" .. id .. " --> casterActor:" .. casterRolename .. ", id:" .. casterId)
            if casterId ~= id then
                local x = getbaseinfo(casterActor, "x")
                local y = getbaseinfo(casterActor, "y")
                local mapId = getbaseinfo(casterActor , "mapid")
                local srcMapId = getbaseinfo(actor, "mapid")
                movemapplayer(actor, srcMapId, mapId, x, y, 2)
            end
        elseif  buffParam == 42 then
            local teamId = getbaseinfo(actor, "teamid")
            if not teamId or teamId == 0 then
                -- 非队伍成员
                info(actor, "非队伍成员")
                return
            end
            --获取所有队员
            local teamActorList = Team.GetAllMemberRids(actor)
            if teamActorList == nil then
                -- 没有队伍信息
                info(actor, "没有队伍信息")
                return
            end
            local selfRid = getbaseinfo(actor, "rid")
            local x = getbaseinfo(actor, "x")
            local y = getbaseinfo(actor, "y")
            local mapId = getbaseinfo(actor, "mapid")

            -- 移动所有队员
            for _, targetRid in pairs(teamActorList) do
                if selfRid ~= targetRid then
                    local targetActor = getactor(actor, targetRid)
                    local srcMapId = getbaseinfo(targetActor, "mapid")
                    movemapplayer(actor, srcMapId, mapId, x, y, 2)
                end
            end
        end
    end
end
--[[
Buffer = {}

local SKILL_TYPE = 1
local ATTACK_TYPE = 2

local bufferConfigMap;

function Buffer.initBufferConfigMap()
    bufferConfigMap = {}
    bufferConfigMap[SKILL_TYPE] = {}
    bufferConfigMap[ATTACK_TYPE] = {}

    local bufferConfigList = ConfigDataManager.getTable("cfg_buff")
    for _, buffConfig in pairs(bufferConfigList) do
        local bufftrigger = buffConfig["bufftrigger"]
        if not string.isNullOrEmpty(bufftrigger) then
            local data = bufferConfigMap[tonumber(bufftrigger)]
            if data ~= nil then
                table.insert(data, buffConfig)
            end
        end
    end
end

function Buffer.getBufferConfigList(trigger)
    if bufferConfigMap == nil then
        Buffer.initBufferConfigMap()
    end
    return bufferConfigMap[tonumber(trigger)]
end

function Buffer.OnAttack(actor, targetActor)
    local bufferConfigs = Buffer.getBufferConfigList(ATTACK_TYPE)
    for _, buffConfig in ipairs(bufferConfigs) do
        addbuff(targetActor, buffConfig["id"], 1, actor)
    end
end

function Buffer.OnReleaseSkill(actor, targetActorlist)

    local bufferConfigs = Buffer.getBufferConfigList(SKILL_TYPE)
    for _, buffConfig in ipairs(bufferConfigs) do
        for _, targetActor in pairs(targetActorlist) do
            addbuff(targetActor, buffConfig["id"], 1, actor)
        end
    end
end ]]

function Buffer.reqNpcAddBuff(actor, msgData)
    local cfgId = msgData.id
    local type = msgData.type
    local config = ConfigDataManager.getById("cfg_huanyingdaoshi", cfgId)
    if table.isEmpty(config) then
        tipinfo(actor, "配置错误")
        return
    end
    local level = getbaseinfo(actor, "level")
    local cfgLvTab = string.split(config.level, "#")
    if level < tonumber(cfgLvTab[1]) or level > tonumber(cfgLvTab[2]) then
        tipinfo(actor, "等级异常！")
        return
    end
    local condition = config.condition
    if not ConditionManager.Check(actor, condition) then
        return
    end
    if config.type == "1" then
        local buffs = getbuffinfo(actor)
        if not table.isEmpty(buffs) then
            for _, buff in pairs(buffs) do
                local buffId = buff.buffcfgid
                local cfg = ConfigDataManager.getTable("cfg_huanyingdaoshi", "buff", buffId, "type", 3)
                if not table.isEmpty(cfg) then
                    delbuff(actor, buffId)
                end
            end
        end
        buffer(actor, tonumber(config.buff))
        tipinfo(actor, "幻影导师buff已生效")
        gameDebug.print(actor, "幻影导师buff已生效", "类型1")
    elseif config.type == "3" then
        local buffs = getbuffinfo(actor)
        if not table.isEmpty(buffs) then
            for _, buff in pairs(buffs) do
                local buffId = buff.buffcfgid
                local cfg = ConfigDataManager.getTable("cfg_huanyingdaoshi", "buff", buffId, "type", 1)
                if not table.isEmpty(cfg) then
                    delbuff(actor, buffId)
                end
            end
        end
        buffer(actor, tonumber(config.buff))
        tipinfo(actor, "幻影导师buff已生效")
        gameDebug.print(actor, "幻影导师buff已生效", "类型3")
    else
        local itemTab = string.split(config.item, "|")
        local costStr = itemTab[1]
        local costTab = string.split(costStr, "#")
        local itemId = tonumber(costTab[1])
        local itemCount = tonumber(costTab[2])
        local rewardStr = itemTab[2]
        local rewardTab = string.split(rewardStr, "#")
        local rewardItemId = tonumber(rewardTab[1])
        local rewardCount = tonumber(rewardTab[2])

        local nowSec = getbaseinfo("nowsec")
        local endTime = EliteMM.getCD(actor)
        local valid = false -- 是否在有效期
        if nowSec < endTime then
            valid = true
        end
        if string.tonumber(type) == 2 then
            -- 消耗积分叠加时间
            if not valid then
                tipinfo(actor, "幻影导师buff已过期")
                return
            end
            local enough = Bag.checkItem(actor, itemId, itemCount)
            if not enough then
                tipinfo(actor, "消耗不足")
                return
            end
            Bag.cost(actor, itemId, itemCount, "幻影导师对话叠加消耗")
            EliteMM.addEliteTime(actor)
            gameDebug.print(actor, "幻影导师buff已叠加")
        else
            -- 领取新手buff
            if not EliteMM.canUse(actor, rewardItemId) then
                return
            end

            if not valid then
                local enough = Bag.checkItem(actor, itemId, itemCount)
                if not enough then
                    tipinfo(actor, "消耗不足")
                    return
                end
                Bag.cost(actor, itemId, itemCount, "幻影导师对话消耗")
            end
            EliteMM.use(actor, rewardItemId)
            gameDebug.print(actor, "幻影导师buff已生效", "其他类型")
        end
    end
end

function Buffer.sendNpcBuffCd(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_NPC_BUFF_CD, { endTime = EliteMM.getCD(actor) })
end

-- 带有奇迹之魂的玩家被玩家击杀处理
GameEvent.add(EventCfg.onPlaydie, function(actor, dieInfo, killInfo)
    local buffCfgId = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.MIRACLES_SOUL)
    if string.isNullOrEmpty(buffCfgId) then
        gameDebug.print("cfg_global表奇迹之魂buff配置不存在")
        return
    end
    if hasbuff(actor, tonumber(buffCfgId)) and killInfo["type"] == MapObjectType.PLAYER then
        local killer = getactor(killInfo["id"])
        local rewardConfig = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.MIRACLES_SOUL_KILL_REWARD)
        if not string.isNullOrEmpty(rewardConfig) then
            Bag.sendRewards4String(killer, rewardConfig, ItemAction.MIRACLES_SOUL_KILL_REWARD)
            delbuff(actor, tonumber(buffCfgId))
        end
    end
end)

LoginEventListerTable:eventLister("0", "buff", Buffer.sendBuffInfo)
LoginEventListerTable:eventLister("0", "npcBuffCd", Buffer.sendNpcBuffCd)
MessageRouter:register(LuaMessageIdToSever.REQ_NPC_ADD_BUFF, Buffer.reqNpcAddBuff)

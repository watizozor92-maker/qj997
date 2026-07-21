EliteMM = {}
local this = {}

local __buffExistTimeKey = "elite_mm_exist_time" -- 当前存在的buff关闭时间
local __delayAddBuffs = "delay_add_buff_ids"     -- 延迟添加的buff集合

function EliteMM.canUse(actor, cfgId)
    if cfgId == ItemConfigId.ELITEMM then
        local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
        local CD = timeInfo.CD or 0
        local nowSec = getbaseinfo(actor, "nowsec")
        -- if CD > 0 and nowSec <= CD then
        --     noticeTip.noticeinfo(actor, StringIdConst.TEXT50002)
        --     return false
        -- end
        if nowSec >= CD then
            local cdTime = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 410001))
            timeInfo.CD = nowSec + cdTime * 60
            API.SetTable(actor, __buffExistTimeKey, timeInfo)
        end
    end
    return true
end

function EliteMM.getCD(actor)
    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    return timeInfo.CD or 0
end

-- 复活补一下精英buff
function EliteMM.giveBuff(actor)
    local nowSec = getbaseinfo("nowsec")
    local endTime = EliteMM.getCD(actor)
    local valid = false -- 是否在有效期
    if nowSec < endTime then
        valid = true
    end
    if not valid then
        return
    end
    intervalcalldelay(actor, 1000, 1000, 1, "playerrivivegivemmbuff", actor:toString())
end

function playerrivivegivemmbuff(actor, rid)
    actor = getactor(rid)
    gameDebug.print(actor, getbaseinfo(actor, "rolename"), "玩家复活补充精英buff执行")
    EliteMM.use(actor, ItemConfigId.ELITEMM)
end

function EliteMM.use(actor, cfgId)
    if cfgId ~= ItemConfigId.ELITEMM then
        return
    end
    local cd = EliteMM.getCD(actor)
    local nowSec = getbaseinfo(actor, "nowsec")
    local fixTime = 0
    if nowSec < cd then
        fixTime = (cd - nowSec) * 1000
    end
    local useparam = ConfigDataManager.getTableValue("cfg_item", "useparam", "id", cfgId)
    local sp = string.splitInt(useparam, "#")

    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    local skillClose = timeInfo.skillClose or {}
    local eliteClose = timeInfo.eliteClose or {}

    local info = getbuffinfo(actor)
    local g = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.ELITEMM_MAX_VALUE)
    g = string.toIntIntMap(g)
    for _, buffId in pairs(sp) do
        local buffConfig = ConfigDataManager.getById("cfg_buff", buffId)
        if table.isEmpty(buffConfig) then
            goto continue
        end
        local total = buffConfig.bufftotaltime
        if fixTime > 0 then
            total = fixTime
        end

        local buffparam = string.split(buffConfig.buffparam, "|")[1]
        local attrId = string.splitInt(buffparam, "#")[1]
        local max = g[attrId] or 99999
        local eliteValue = this.getBuffValue(actor, buffId)
        eliteValue = math.min(eliteValue, max)
        -- lg("计算buff属性:", buffId, "属性:", attrId, "属性值:", eliteValue)

        if eliteValue > 0 then
            local replaceBuffId = this.getReplaceBuff(buffId)
            -- lg("buff:", buffId, "替换buff:", replaceBuffId, "是否关闭:", skillClose)
            if replaceBuffId and skillClose[replaceBuffId] and hasbuff(actor, replaceBuffId) then
                -- 技能buff存在
                local layers = 1
                if not table.isEmpty(info) then
                    for i = 1, #info do
                        if info[i].buffcfgid == replaceBuffId then
                            layers = info[i].layers
                            break
                        end
                    end
                end
                -- 技能buff值
                local skillValue = this.getBuffValue(actor, replaceBuffId, layers)
                -- lg("技能buff值:", skillValue, "精英buff值:", eliteValue)
                if skillValue >= eliteValue then
                    -- 技能buff值大于等于精英buff值, 不添加buff, 当对方过期时延迟添加
                    this.addDelayBuff(actor, buffId, timeInfo)
                    goto continue
                end
            end

            -- 技能buff值小于精英buff值, 添加精英buff, 直接删除技能buff,因为技能buff时间远小于精英buff时间
            skillClose[replaceBuffId] = nil
            delbuff(actor, replaceBuffId)
            buffer(actor, buffId, 1, nil, { bufftotaltime = math.floor(total) })
            -- 记录精英mm Buff关闭时间
            local closeTime = string.tonumber(total) / 1000 + nowSec
            eliteClose[buffId] = closeTime
        end
        :: continue ::
    end
    timeInfo.eliteClose = eliteClose
    timeInfo.skillClose = skillClose
    API.SetTable(actor, __buffExistTimeKey, timeInfo)
    this.calcPlayerAttr(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_ELITE_MM, 1)
    tipinfo(actor, "精灵MM已生效")
    Buffer.sendNpcBuffCd(actor)
end

function EliteMM.addEliteTime(actor)
    local buffInfo = getbuffinfo(actor)
    if table.isEmpty(buffInfo) then
        return
    end
    local useparam = ConfigDataManager.getTableValue("cfg_item", "useparam", "id", ItemConfigId.ELITEMM)
    local sp = string.splitInt(useparam, "#")
    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    local eliteClose = timeInfo.eliteClose or {}
    for _, buffCfgId in pairs(sp) do
        local buffConfig = ConfigDataManager.getById("cfg_buff", buffCfgId)
        if not table.isEmpty(buffConfig) and eliteClose[buffCfgId] and hasbuff(actor, buffCfgId) then
            local total = buffConfig.bufftotaltime
            local buffId, leftTime = this.getBuffDetail(actor, buffInfo, buffCfgId)
            local newTime = leftTime + total
            setbuffdata(actor, buffId, { bufftotaltime = math.floor(newTime) })
            eliteClose[buffCfgId] = eliteClose[buffCfgId] + total / 1000
        end
    end
    local cdTime = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 410001))
    timeInfo.CD = timeInfo.CD + cdTime * 60
    timeInfo.eliteClose = eliteClose
    API.SetTable(actor, __buffExistTimeKey, timeInfo)
    Buffer.sendNpcBuffCd(actor)
end

function this.getBuffDetail(actor, buffInfo, buffCfgId)
    for _, buff in ipairs(buffInfo) do
        local cfgId = buff.buffcfgid
        if cfgId == buffCfgId then
            return buff.buffid, buff.totaltime
        end
    end
end

function EliteMM.login(actor)
    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    local eliteClose = timeInfo.eliteClose or {}
    local skillClose = timeInfo.skillClose or {}
    local update = false
    local copy = table.copy(eliteClose)
    for buffCfgId, time in pairs(copy) do
        local has = hasbuff(actor, buffCfgId)
        if not has then
            update = true
            eliteClose[buffCfgId] = nil
        end
    end
    copy = table.copy(skillClose)
    for buffCfgId, time in pairs(copy) do
        local has = hasbuff(actor, buffCfgId)
        if not has then
            update = true
            skillClose[buffCfgId] = nil
        end
    end

    if update then
        timeInfo.eliteClose = eliteClose
        timeInfo.skillClose = skillClose
        API.SetTable(actor, __buffExistTimeKey, timeInfo)
        this.calcPlayerAttr(actor)
    end
    if table.isEmpty(eliteClose) then
        sendluamsg(actor, LuaMessageIdToClient.RES_ELITE_MM, 0)
    else
        sendluamsg(actor, LuaMessageIdToClient.RES_ELITE_MM, 1)
    end
end

function EliteMM.calcBuffParams(buffConfig, casterActor, actor, buffId)
    local g = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.ELITEMM_MAX_VALUE)
    g = string.toIntIntMap(g)
    --计算增益属性
    local buffparams = string.split(buffConfig.buffparam, "|")
    local attrId = string.splitInt(buffparams[1], "#")[1]
    local layers = 1
    local info = getbuffinfo(actor)
    if not table.isEmpty(info) then
        for i = 1, #info do
            if info[i].buffcfgid == buffId then
                layers = info[i].layers
                break
            end
        end
    end
    local v = this.getBuffValue(casterActor or actor, buffId, layers)
    local max = g[attrId] or 99999
    v = math.min(v, max)
    return {id = attrId, value = v}
end

function EliteMM.afterBuffEffect(actor, buffConfig, layers, buffFromType, buffId, casterActor)
    local type = getbaseinfo(actor, "mapobjecttype")
    if type ~= MapObjectType.PLAYER then
        return
    end

    local buffCfgId = tonumber(buffConfig.id)
    local buffparam = string.split(buffConfig.buffparam, "|")[1]
    local attrId = string.splitInt(buffparam, "#")[1]

    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    local skillClose = timeInfo.skillClose or {}
    local eliteClose = timeInfo.eliteClose or {}
    local g = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.ELITEMM_MAX_VALUE)
    g = string.toIntIntMap(g)
    local max = g[attrId] or 99999

    local nowSec = getbaseinfo(actor, "nowsec")
    local value
    if buffFromType == 99 then
        -- 精英卡buff属性在使用时处理了
    elseif buffFromType == 2 then
        value = this.getBuffValue(actor, buffCfgId, layers)
        -- 计算技能buff的实际值
        local skillValue = math.min(value, max)
        -- skillValue = 10 -- 测试
        local replaceBuffId = this.getReplaceBuff(buffCfgId)

        -- 如果顶掉精英buff, 判断延迟添加精英buff
        if eliteClose[replaceBuffId] then
            -- 获取精英卡buff的当前值
            local eliteValue = this.getBuffValue(actor, replaceBuffId, 1)
            -- lg("精英卡buff值:", eliteValue, "技能buff值:", skillValue)
            -- 不添加技能buff
            if skillValue <= eliteValue then
                -- 技能buff值小于等于精英buff值, 直接不加, 因为技能buff时间远小于精英buff时间
                delbuff(actor, buffCfgId)
                return
            end
            -- 删除精英buff
            this.addDelayBuff(actor, replaceBuffId, timeInfo)
            this.tryRemoveExistBuff(actor, replaceBuffId, timeInfo, 1)
        end

        local config = ConfigDataManager.getById("cfg_buff_Calculation", buffCfgId)
        if table.isEmpty(config) then
            return
        end

        local calcTime = config.time
        local needTime = 0
        if string.find(calcTime, "|") then
            local info = string.split(calcTime, "|")
            for _, data in pairs(info) do
                if string.find(data, "#") then
                    local v = string.splitInt(data, "#")
                    local name = attrid2name(casterActor, v[1])
                    data = getattrinfo(casterActor, name) * v[2] / 10000
                end
                needTime = needTime + data
            end
        else
            if string.find(calcTime, "#") then
                local v = string.splitInt(calcTime, "#")
                local name = attrid2name(casterActor, v[1])
                local data = getattrinfo(casterActor, name) * v[2] / 10000
                needTime = data
            else
                needTime = string.tonumber(calcTime)
            end
        end
        local newTotal = needTime * 1000
        if needTime <= 0 then
            -- 获取buff总时间配置
            local total = ConfigDataManager.getTableValue("cfg_buff", "bufftotaltime", "id", buffCfgId)
            newTotal = string.tonumber(total)
        end
        -- local buffValue = EliteMM.calcBuffParams(buffConfig, casterActor, actor, buffCfgId)
        -- local newTotal = 10000 -- 测试
        -- 设置新持续时间（秒）
        setbuffdata(actor, buffId, { bufftotaltime = math.floor(newTotal)})

        -- 更新关闭时间戳
        skillClose[buffCfgId] = nowSec + newTotal / 1000
        timeInfo.skillClose = skillClose
        API.SetTable(actor, __buffExistTimeKey, timeInfo)
        -- 更新属性
        this.calcPlayerAttr(actor, casterActor, buffCfgId)
    end
end

-- 计算buff属性值
function this.getBuffValue(actor, buffId, layers)
    local config = ConfigDataManager.getById("cfg_buff_Calculation", buffId)
    if table.isEmpty(config) then
        return 0
    end
    local type = string.tonumber(config.type)
    if type == 1 then
        return this.getSkillValue(actor, buffId, layers)
    elseif type == 2 then
        return this.getEliteValue(actor, buffId, layers)
    end
    return 0
end

-- 计算精英卡buff值
function this.getEliteValue(actor, buffId, layers)
    local mylevel = getbaseinfo(actor, "level")
    local cfg = ConfigDataManager.getTableFirst("cfg_jinglingmmBUFF", "level", mylevel)
    if table.isEmpty(cfg) then
        return 0
    end
    local bids = string.splitInt(cfg.buffid, "#")
    -- 找出与buffId匹配的buff下标
    local j = 0
    for i, bid in pairs(bids) do
        if bid == buffId then
            j = i
            break
        end
    end
    if j == 0 then
        return 0
    end
    local values = string.splitInt(cfg.value, "#")
    local cfgValue = values[j]
    if not cfgValue then
        return 0
    end
    return cfgValue * (layers or 1)
end

-- 计算技能buff值
function this.getSkillValue(actor, buffId, layers)
    local config = ConfigDataManager.getById("cfg_buff_Calculation", buffId)
    if table.isEmpty(config) then
        return 0
    end
    local mylevel = getbaseinfo(actor, "level")
    local level = string.tonumber(config.level)
    local num = level * mylevel
    local way = config.att
    local baseValue = 0
    if string.find(way, "|") then
        local info = string.split(way, "|")
        for _, data in pairs(info) do
            if string.find(data, "#") then
                local v = string.splitInt(data, "#")
                local name = attrid2name(actor, v[1])
                data = getattrinfo(actor, name) * v[2] / 10000
            end
            baseValue = baseValue + data
        end
        baseValue = baseValue + num
    else
        if string.find(way, "#") then
            local v = string.splitInt(way, "#")
            local name = attrid2name(actor, v[1])
            local data = getattrinfo(actor, name) * v[2] / 10000
            baseValue = data
        else
            baseValue = tonumber(way)
        end
        baseValue = baseValue + num
    end

    return baseValue * (layers or 1)
end

-- 升级检测精英buff属性改动
function EliteMM.levelup(actor, level)
    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    local eliteClose = timeInfo.eliteClose or {}
    if table.isEmpty(eliteClose) then
        return
    end
    this.calcPlayerAttr(actor)

    Buffer.sendBuffInfo(actor)
end

-- 某一个buff过期后尝试添加替换的buff
function this.tryAddReplaceBuff(actor, buffId, timeInfo, type)
    local replaceBuffId = this.getReplaceBuff(buffId)
    if not replaceBuffId then
        return
    end
    local replaceBuffConfig = ConfigDataManager.getById("cfg_buff", replaceBuffId)
    if table.isEmpty(replaceBuffConfig) then
        return
    end
    timeInfo = timeInfo or (API.GetTable(actor, __buffExistTimeKey) or {})
    local skillClose = timeInfo.skillClose or {}
    local eliteClose = timeInfo.eliteClose or {}
    if skillClose[replaceBuffId] or eliteClose[replaceBuffId] then
        return
    end

   local delayAddBuffs = API.GetTable(actor, __delayAddBuffs) or {}
    local nowsec = getbaseinfo(actor, "nowsec")
    for i = #delayAddBuffs, 1, -1 do
        local b = delayAddBuffs[i]
        if b.buffId == replaceBuffId then
            table.remove(delayAddBuffs, i)
            if type == 1 then
                -- 精英buff过期，添加技能buff
                skillClose[replaceBuffId] = nowsec + b.totalTime
            elseif type == 2 then
                -- 技能buff过期，添加精英buff
                eliteClose[replaceBuffId] = nowsec + b.totalTime
            end
            buffer(actor, replaceBuffId, 1, actor, { bufftotaltime = math.floor(b.totalTime * 1000) })
            API.SetTable(actor, __buffExistTimeKey, timeInfo)
        end
    end
    API.SetTable(actor, __delayAddBuffs, delayAddBuffs)
end

function this.calcPlayerAttr(actor, casterActor, updatebuffId)
    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    local skillClose = timeInfo.skillClose or {}
    local eliteClose = timeInfo.eliteClose or {}
    local attrClose = timeInfo.attrClose or {}
    local attrs = {}
    local tempAttrClose = {}
    local g = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.ELITEMM_MAX_VALUE)
    g = string.toIntIntMap(g)
    for buffId, _ in pairs(skillClose) do
        local buffConfig = ConfigDataManager.getById("cfg_buff", buffId)
        if table.isEmpty(buffConfig) then
            goto continue
        end
        local v = nil
        if attrClose[buffId] and updatebuffId ~= buffId then
            v = attrClose[buffId]
        else
            v = EliteMM.calcBuffParams(buffConfig, casterActor, actor, buffId)
            -- lg("计算buff:", v)
            attrClose[buffId] = v
        end
        tempAttrClose[buffId] = v
        table.mergeAdd(attrs, { [v.id] = v.value })
        :: continue ::
    end
    --保存属性缓存
    timeInfo.attrClose = tempAttrClose
    API.SetTable(actor, __buffExistTimeKey, timeInfo)
    for buffId, _ in pairs(eliteClose) do
        local buffConfig = ConfigDataManager.getById("cfg_buff", buffId)
        if table.isEmpty(buffConfig) then
            goto continue
        end
        local buffparams = string.split(buffConfig.buffparam, "|")
        local attrId = string.splitInt(buffparams[1], "#")[1]
        local v = this.getBuffValue(actor, buffId)
        local max = g[attrId] or 99999
        v = math.min(v, max)
        table.mergeAdd(attrs, { [attrId] = v })
        :: continue ::
    end
    -- lg("计算后角色属性:", attrs)

    addrolekmlattributes(actor, "elitemm_skill_buff", attrs)
end

function this.addDelayBuff(actor, buffId, timeInfo)
    local nowsec = getbaseinfo(actor, "nowsec")
    local total = ConfigDataManager.getTableValue("cfg_buff", "bufftotaltime", "id", buffId)
    local delayAddBuffs = API.GetTable(actor, __delayAddBuffs) or {}
    timeInfo = timeInfo or (API.GetTable(actor, __buffExistTimeKey) or {})
    local skillClose = timeInfo.skillClose or {}
    local eliteClose = timeInfo.eliteClose or {}
    -- 找出这个buff的结束时间
    local closeTime = 0
    if skillClose[buffId] then
        closeTime = skillClose[buffId] or 0
        skillClose[buffId] = nil
    elseif eliteClose[buffId] then
        closeTime = eliteClose[buffId] or 0
        eliteClose[buffId] = nil
    end
    -- 检测是否之前存在这个buff
    local has = false
    if closeTime > 0 then
        has = true
    end
    if has then
        -- 之前有取剩余时间
        local leftTime = math.max(0, closeTime - nowsec)
        if leftTime > 0 then
            total = leftTime
        else
            return
        end
    else
        for i, delay in ipairs(delayAddBuffs) do
            if delay.buffId == buffId then
                -- 被替换过了
                return
            end
        end
        total = total / 1000
    end
    local delayAdd = { buffId = buffId, totalTime = total }
    table.insert(delayAddBuffs, delayAdd)
    API.SetTable(actor, __delayAddBuffs, delayAddBuffs)
end

-- 尝试删除指定属性的buff和属性
function this.tryRemoveExistBuff(actor, buffId, timeInfo, type)
    timeInfo = timeInfo or (API.GetTable(actor, __buffExistTimeKey) or {})
    local skillClose = timeInfo.skillClose or {}
    local eliteClose = timeInfo.eliteClose or {}
    local attrClose = timeInfo.attrClose or {}
    if type == 1 then
        eliteClose[buffId] = nil
    elseif type == 2 then
        skillClose[buffId] = nil
        attrClose[buffId] = nil
    end
    delbuff(actor, buffId)
    timeInfo.eliteClose = eliteClose
    timeInfo.skillClose = skillClose
    API.SetTable(actor, __buffExistTimeKey, timeInfo)
end

-- 获取相替换的buff
function this.getReplaceBuff(buffId)
    local group = ConfigDataManager.getTableValue("cfg_buff_Calculation", "group", "id", buffId)
    if string.isNullOrEmpty(group) then
        return nil
    end
    local list = ConfigDataManager.getTable("cfg_buff_Calculation", "group", group)
    if not list or #list < 2 then
        return nil
    end
    for i = 1, #list do
        if tonumber(list[i].id) ~= tonumber(buffId) then
            return tonumber(list[i].id)
        end
    end
    return nil
end

-- 是否为精英或者精英替换buff
function EliteMM.isEliteOrSkill(actor, buffCfgId)
    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    return (timeInfo.skillClose and timeInfo.skillClose[buffCfgId]) or
        (timeInfo.eliteClose and timeInfo.eliteClose[buffCfgId])
end

function EliteMM.getBuffValue(actor, buffCfgId, layers)
    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    local attrClose = timeInfo.attrClose or {}
    local skillClose = timeInfo.skillClose or {}
    local v = attrClose[buffCfgId]
    if v and layers == 1 and skillClose[buffCfgId] then
        return { [v.id] = v.value }
    end
    local buffConfig = ConfigDataManager.getById("cfg_buff", buffCfgId)
    if table.isEmpty(buffConfig) then
        return {}
    end

    local g = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.ELITEMM_MAX_VALUE)
    g = string.toIntIntMap(g)
    local buffparams = string.split(buffConfig.buffparam, "|")
    local attrId = string.splitInt(buffparams[1], "#")[1]
    local v = this.getBuffValue(actor, buffCfgId, layers)
    local max = g[attrId] or 99999
    v = math.min(v, max)
    return { [attrId] = v }
end

function EliteMM.tryClear(actor, buffCfgId, reason)
    if reason ~= 1 then
        return
    end
    local timeInfo = API.GetTable(actor, __buffExistTimeKey) or {}
    if table.isEmpty(timeInfo) then
        return
    end
    local eliteClose = timeInfo.eliteClose or {}
    local skillClose = timeInfo.skillClose or {}
    local attrClose = timeInfo.attrClose or {}
    local update = false
    if skillClose[buffCfgId] then
        update = true
        skillClose[buffCfgId] = nil
        attrClose[buffCfgId] = nil
        this.tryAddReplaceBuff(actor, buffCfgId, timeInfo, 2)
    elseif eliteClose[buffCfgId] then
        update = true
        eliteClose[buffCfgId] = nil
        this.tryAddReplaceBuff(actor, buffCfgId, timeInfo, 1)
    end
    if update then
        timeInfo.eliteClose = eliteClose
        timeInfo.skillClose = skillClose
        timeInfo.attrClose = attrClose
        API.SetTable(actor, __buffExistTimeKey, timeInfo)
        -- 更新属性
        this.calcPlayerAttr(actor)
    end
    if table.isEmpty(eliteClose) then
        sendluamsg(actor, LuaMessageIdToClient.RES_ELITE_MM, 0)
    end
end

LoginEventListerTable:eventLister("0", "精英MM", EliteMM.login)

-- ====================================测试========================================
function testelitemm(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        EliteMM.tryClear(actor, args[2])
    elseif opt == 2 then
        local buff_info = getbuffinfo(actor)
        for _, buff in pairs(buff_info) do
            local buffId = buff.buffcfgid
            delbuff(actor, buffId)
        end
        API.SetTable(actor, __buffExistTimeKey, {})
        API.SetTable(actor, __delayAddBuffs, {})
        addrolekmlattributes(actor, "elitemm_skill_buff", {})
        sendluamsg(actor, LuaMessageIdToClient.RES_ELITE_MM, 0)
    elseif opt == 3 then
        local buff_info = getbuffinfo(actor)
        lg(buff_info)
        local info = API.GetTable(actor, __buffExistTimeKey) or {}
        lg(info)
        lg(API.GetTable(actor, __delayAddBuffs))
    elseif opt == 4 then
        EliteMM.addEliteTime(actor)
    end
end

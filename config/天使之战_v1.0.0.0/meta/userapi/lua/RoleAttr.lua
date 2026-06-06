RoleAttr = {}
local this = {}


---@class RoleAttrProgrammeData
---@field current number 当前方案
---@field freeSwitchAttrPointData table<number,FreeSwitchAttrPointData>

---@class FreeSwitchAttrPointData
---@field id number
---@field attr table
---@field name string

this.ROLE_ATTR_CHANGE_LINE_KEY = "T$_ROLE_ATTR_CHANGE_LINE_KEY"

RoleAttrKey = {
    UNION_ARMBAND_LEVEL       = "roleunionarmbandlevelattrkey",       -- 战盟臂章等级属性
    UNION_ARMBAND_STRONG      = "roleunionarmbandstrongattrkey",      -- 战盟臂章强化属性
    PRIVILEGE_MONTH_DROP_RATE = "privilegemonthdroprateattrpointkey", -- 月卡特权增加爆率
    EXP_BOOST_ITEM_USE        = "roleexpboostitemuseattrpointkey",    -- 经验药水使用增加杀怪经验提升
    VIP_GIFT_PACK             = "rolevipgiftpackprivilegekey",        -- VIP特权增加属性
    ANGEL_MAJOR_TALENT        = "roleangelmajorattrkey",              -- 大天使天赋属性
    PRIVILEGE_EXP_BOOST       = "roleexpboostprivilegekey",           -- 经验提升特权
    LIAN_JI_GUO_SHI_ATT       = "lianjiguoshiatt",                    -- 连击属性
    ADJUST_DUALWIELD_ATTR     = "ADJUST_DUALWIELD_ATTR",              -- 调整剑士/魔剑士双持武器属性
    EQUIP_SPECIAL_ATTR        = "EQUIP_SPECIAL_ATTR",                 -- 装备特殊属性调整
    EQUIP_REGENERATION        = "EQUIP_REGENERATION",                 -- 装备再生属性
    EQUIP_PART_SPECIAL_ATTR    = "EQUIP_PART_SPECIAL_ATTR",            -- 装备部位特殊属性调整
}

function RoleAttr.levelup(actor, level, oldlevel)
    this.addAttrPointByCareer(actor, level, oldlevel)
end

-- 添加属性，并把属性保存起来，下次添加属性自动叠加
function RoleAttr.addAndSaveRoleAttr(actor, key, attr_map)
    this.addAndSaveRoleAttr(actor, key, attr_map)
end

-- 减少属性，并把属性保存起来，下次添加属性自动相减
function RoleAttr.reduceAndSaveRoleAttr(actor, key, attr_map)
    this.reduceAndSaveRoleAttr(actor, key, attr_map)
end

-- 清空指定Key的属性和保存的数据
function RoleAttr.clearRoleAttrAndDB(actor, key)
    this.clearRoleAttrAndDB(actor, key)
end

function RoleAttr.createrole(actor)
    --     this.createRoleAddAttrPointByCareer(actor)
end

function RoleAttr.setPrivilegeAttrPointProgramme(actor, data)
    this.setPrivilegeAttrPointProgramme(actor, data)
end

function RoleAttr.getPrivilegeAttrPointProgramme(actor)
    local data = this.getPrivilegeData(actor)
    this.jprint("--- 获取属性点方案数据 ---")
    this.jprint(data)
    sendluamsg(actor, LuaMessageIdToClient.RES_GET_ROLE_ATTR_POINT_PROGRAMME, data)
end

function RoleAttr.changePrivilegeAttrPointProgramme(actor, key)
    this.changePrivilegeAttrPointProgramme(actor, key)
end
-----------------------------------

function this.createRoleAddAttrPointByCareer(actor)
    --local level = getbaseinfo(actor, "level")
    --this.addAttrPointByCareer(actor, level, 0)
end

function this.setPrivilegeAttrPointProgramme(actor, param)
    local data = this.getPrivilegeData(actor)
    if table.isEmpty(data) then
        data = {}
        data.current = 1
    end
    this.jprint("--- param ---")
    this.jprint(param)
    if table.isEmpty(data.freeSwitchAttrPointData) then
        data.freeSwitchAttrPointData = {}
    end
    data.freeSwitchAttrPointData[param.id] = param
    this.setPrivilegeData(actor, data)
    RoleAttr.getPrivilegeAttrPointProgramme(actor)
end

---@return RoleAttrProgrammeData
function this.getPrivilegeData(actor)
    return getplaydef(actor, this.ROLE_ATTR_CHANGE_LINE_KEY)
end

function this.setPrivilegeData(actor, data)
    setplaydef(actor, this.ROLE_ATTR_CHANGE_LINE_KEY, data)
end

function this.changePrivilegeAttrPointProgramme(actor, key)
    local is_has = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.SWITCHING_POINT_SCHEME)
    if not is_has then
        this.jprint("玩家没有权限")
        return
    end
    local data = this.getPrivilegeData(actor)
    if table.isEmpty(data) then
        sendluamsg(actor, LuaMessageIdToClient.RES_CHANGE_ROLE_ATTR_POINT_PROGRAMME, key)
        return
    end

    this.jprint("key")
    this.jprint(key)

    this.jprint("--- data ---")
    this.jprint(data)
    if data.current == key then
        this.jprint("当前方案和要切换的方案一样，无需切换")
        return
    end

    data.current = key
    this.setPrivilegeData(actor, data)

    resetattrpoint(actor, 1, 0)

    local programme_data = data.freeSwitchAttrPointData[key]
    if table.isEmpty(programme_data) then
        sendluamsg(actor, LuaMessageIdToClient.RES_CHANGE_ROLE_ATTR_POINT_PROGRAMME, key)
        return
    end
    this.jprint("-- programme_data --")
    this.jprint(programme_data)
    if not table.isEmpty(programme_data.attr) then
        attr_map = {}
        for _, v in pairs(programme_data.attr) do
            attr_map[v.type] = v.num
        end
        this.jprint("-- attr_map --")
        this.jprint(attr_map)
        deployattrpoint(actor, attr_map, 1)
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_CHANGE_ROLE_ATTR_POINT_PROGRAMME, key)
end

function this.addAttrPointByCareer(actor, level, oldlevel)
    this.jprint(oldlevel)
    this.jprint(level)

    local career = getbaseinfo(actor, "getbasecareer")
    career = tonumber(career)
    this.jprint("职业:" .. career)

    local key = "";
    if career == 1 then
        key = "swordsmanAttribute"
    end
    if career == 2 then
        key = "magicianAttribute"
    end
    if career == 3 then
        key = "archerAttributes"
    end
    if career == 4 then
        key = "magicSwordsmanAttribute"
    end
    if career == 5 then
        key = "saintMentorAttribute"
    end
    if career == 6 then
        key = "summonerAttribute"
    end
    if career == 7 then
        key = "lightMagicianAttribute"
    end
    if key == "" then
        this.jprint("职业错误")
        return
    end

    local attr_map = this.getAttrMap(actor)
    for i = oldlevel + 1, level do
        this.calculAttr(actor, i, key, attr_map)
    end
    if next(attr_map) == nil then
        return
    end
    this.jprint("添加属性点")
    this.jprint(attr_map)
    this.setAttrMap(actor, attr_map)
    addrolekmlattributes(actor, "luaaddattrpointbycareer", attr_map)
end

function this.getAttrMap(actor)
    local data = getplaydef(actor, "T$_luaaddattrpointbycareer")
    if data == nil then
        data = {}
    end
    return data
end

function this.setAttrMap(actor, attr_map)
    setplaydef(actor, "T$_luaaddattrpointbycareer", attr_map)
end

function this.calculAttr(actor, level, key, attr_map)
    local attr_map_str = ConfigDataManager.getTableValue("cfg_level", key, "id", level)
    if attr_map_str == nil or attr_map_str == "" then
        return
    end

    local map = string.toIntIntMap(attr_map_str, "#", "|")
    this.jprint("map")
    for attr_id, value in pairs(map) do
        this.jprint(attr_id)
        this.jprint(value)

        local attr_value = attr_map[attr_id]
        this.jprint("attr_value")
        this.jprint(attr_value)
        if attr_value ~= nil and tonumber(attr_value) > 0 then
            attr_value = attr_value + value
        else
            attr_value = value
        end
        attr_map[attr_id] = attr_value
    end
end

function this.addAndSaveRoleAttr(actor, key, attr_map)
    if table.isEmpty(attr_map) then
        return
    end
    local db_key = "T$_" .. key
    local data = getplaydef(actor, db_key)
    if table.isEmpty(data) then
        data = attr_map
    else
        for attr_id, value in pairs(attr_map) do
            if data[attr_id] == nil then
                data[attr_id] = value
            else
                data[attr_id] = data[attr_id] + value
            end
        end
    end
    setplaydef(actor, db_key, data)
    addrolekmlattributes(actor, key, data)
    this.jprint("---- 添加属性 ----")
    this.jprint("key")
    this.jprint(key)
    this.jprint("data")
    this.jprint(data)
end

function RoleAttr.getAttMapByKey(actor, key)
    local db_key = "T$_" .. key
    return getplaydef(actor, db_key) or {}
end

function this.reduceAndSaveRoleAttr(actor, key, attr_map)
    if table.isEmpty(attr_map) then
        return
    end
    local db_key = "T$_" .. key
    local data = getplaydef(actor, db_key)
    if table.isEmpty(data) then
        data = {}
    end
    for attr_id, value in pairs(attr_map) do
        if data[attr_id] ~= nil then
            data[attr_id] = math.max(0, data[attr_id] - value)
        end
    end
    setplaydef(actor, db_key, data)
    addrolekmlattributes(actor, key, data)
end

function this.clearRoleAttrAndDB(actor, key)
    local db_key = "T$_" .. key
    setplaydef(actor, db_key, {})
    addrolekmlattributes(actor, key, {})
end

---------------------------- 日志打印 -----------------------------
this.log_open = false
function this.jprint(param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(param)
end

function this.loginfo(actor, param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 日志输出内容为空. nil"
    end
    jprint(param)
    info(actor, param)
end

-- 设置角色属性加成方式
function RoleAttr.setRoleAttAddWay(actor, msgData)
    local addAttWay = setroleattaddway(actor, msgData[1])
    sendluamsg(actor, LuaMessageIdToClient.RES_ROLE_ATT_ADD_WAY, addAttWay)
end

-- 设置角色属性加成方式
function RoleAttr.getRoleAttAddWay(actor)
    local addAttWay = getrolefield(actor, "role.RoleAttribute.attrAddWay")
    sendluamsg(actor, LuaMessageIdToClient.RES_ROLE_ATT_ADD_WAY, addAttWay)
end

function RoleAttr.transferCareer(actor, careerName)
    local wash = ConfigDataManager.getTableValue("cfg_career", "wash", "name", careerName)
    if tonumber(wash) == 1 then
        resetattrpoint(actor, 1)
    end
    local msgData = {}
    local careerRec = ConfigDataManager.getTableValue("cfg_career", "careerRec", "name", careerName)
    local careerRecTable = string.split(careerRec, "|")
    if #careerRecTable ~= 1 then
        msgData[1] = -1
    end
    if not table.isNullOrEmpty(msgData) then
        RoleAttr.setRoleAttAddWay(actor, msgData)
    end
end

-- @description 脚本计算角色最终属性
-- @param 玩家对象
-- @return
function RoleAttr.CalcPlayFinalAttr(actor)
    local ret = {}
    local armorBaseDefenseBonus = getattrinfo(actor, "armorBaseDefenseBonus")
    local weaponBaseAttackBonus = getattrinfo(actor, "weaponBaseAttackBonus")
    local lastAttr = getplaydef(actor, PlayerDefKey.LAST_EQUIP_SPECIAL_ATTR)
    if lastAttr ~= nil then
        if armorBaseDefenseBonus ~= lastAttr[1] or weaponBaseAttackBonus ~= lastAttr[2] then
            EquipAndAppear.specialAttrUpdate(actor)
        end
    end

    -- 自动恢复魔法
    local mpRecovery = getattrinfo(actor, "MPFullRecoverRate")
    if mpRecovery and mpRecovery ~= "" and mpRecovery > 0 then
        local roleInfo = getsysvar(SystemVarConst.AUTO_RECOVERY_MAGIC_ROLE_INFO)
        if not table.isEmpty(roleInfo) then
            local exist = false
            for _, v in pairs(roleInfo) do
                if actor:toString() == v["actor"]:toString() then
                    exist = true
                end
            end
            if not exist then
                table.insert(roleInfo, {
                    actor = actor,
                    recovery = mpRecovery
                })
                setsysvar(SystemVarConst.AUTO_RECOVERY_MAGIC_ROLE_INFO, roleInfo)
            end
        else
            local temp = {}
            table.insert(temp, {
                actor = actor,
                recovery = mpRecovery
            })
            setsysvar(SystemVarConst.AUTO_RECOVERY_MAGIC_ROLE_INFO, temp)
            GlobalTimer.setontimerex(TimerIds.AUTO_RECOVERY_MAGIC, TimeUnit.SECOND * 3)
        end
    end
    return ret
end

--- 自动恢复魔法
function RoleAttr.autoRecoveryMagic()
    local roleInfo = getsysvar(SystemVarConst.AUTO_RECOVERY_MAGIC_ROLE_INFO)
    if not table.isEmpty(roleInfo) then
        for key, actorInfo in pairs(roleInfo) do
            local actor = actorInfo["actor"]
            local mpFullRecoverRate = actorInfo["recovery"]
            if mpFullRecoverRate > 0 then
                local mp = getbaseinfo(actor, "mp")
                local maxMp = getbaseinfo(actor, "maxmp")
                local incrementMp = maxMp * mpFullRecoverRate
                if mp + incrementMp > maxMp then
                    setmp(actor, maxMp)
                    table.remove(roleInfo, key)
                else
                    setmp(actor, mp + incrementMp)
                end
            else
                table.remove(roleInfo, key)
            end
        end
        setsysvar(SystemVarConst.AUTO_RECOVERY_MAGIC_ROLE_INFO, roleInfo)
        if table.isEmpty(roleInfo) then
            GlobalTimer.setofftimer(TimerIds.AUTO_RECOVERY_MAGIC)
        end
    end
end

--- 切换地图后将actor对象mapId修改
---@param actor table 玩家对象
---@param mapCfgId number 地图配置id
function RoleAttr.enterMap(actor, mapCfgId)
    local roleInfo = getsysvar(SystemVarConst.AUTO_RECOVERY_MAGIC_ROLE_INFO)
    if not table.isEmpty(roleInfo) then
        for k, v in pairs(roleInfo) do
            local player = v["actor"]
            local recovery = v["recovery"]
            if player:toString() == actor:toString() then
                local getActor = getactor(actor, player:toString(), gamemap.getMapKey(mapCfgId, 1))
                table.remove(roleInfo, k)
                table.insert(roleInfo, {
                    actor = getActor,
                    recovery = recovery
                })
                break
            end
        end
        setsysvar(SystemVarConst.AUTO_RECOVERY_MAGIC_ROLE_INFO, roleInfo)
    end
end

--是否是攻击力属性
function RoleAttr.isAttackAttr(attrId)
    return table.contains({ 201021, 201011, 202021, 202011, 205021, 205011 }, attrId)
end

-- 被攻击回满血/蓝
function RoleAttr.hurtRecoverHpMp(actor)
    local nowSec = string.tonumber(getbaseinfo(actor, "nowsec"))
    local hpRecovery = string.tonumber(getattrinfo(actor, "HitRecoverAllHpRate"))
    local mpRecovery = string.tonumber(getattrinfo(actor, "HitRecoverAllMpRate"))

    if this.checkRecovery(actor, hpRecovery, nowSec, true) then
        local maxHp = getbaseinfo(actor, "maxhp", true)
        sethp(actor, maxHp)
        API.SetInt(actor, VarCfg.ZC_HP_FULL_RECOVEY_TIME, nowSec)
    end

    if this.checkRecovery(actor, mpRecovery, nowSec, false) then
        local maxMp = getbaseinfo(actor, "maxmp", false)
        setmp(actor, maxMp)
        API.SetInt(actor, VarCfg.ZC_MP_FULL_RECOVEY_TIME, nowSec)
    end
end

function this.checkRecovery(actor, rate, nowSec, isHp)
    if rate < 1 then
        return false
    end
    local recoverSec = isHp and API.GetInt(actor, VarCfg.ZC_HP_FULL_RECOVEY_TIME) or API.GetInt(actor, VarCfg.ZC_MP_FULL_RECOVEY_TIME)
    if nowSec - recoverSec < 120 then
        return false
    end
    return RandomUtil.isAttRateHit(rate)
end

function RoleAttr.killMonsterRecoverHpMp(actor)
    local mpRecovery = string.tonumber(getattrinfo(actor, "killMonsterRecoverMp"))
    if mpRecovery > 0 then
        local maxMp = getbaseinfo(actor, "maxmp")
        local curMp = getbaseinfo(actor, "mp")
        if maxMp ~= curMp then
            local final = math.min(maxMp, curMp + maxMp / 8)
            setmp(actor, final)
        end
    end
    local hpRecovery = string.tonumber(getattrinfo(actor, "killMonsterRecoverHp"))
    if hpRecovery > 0 then
        local maxHp = getbaseinfo(actor, "maxhp")
        local curHp = getbaseinfo(actor, "hp")
        if maxHp ~= curHp then
            local final = math.min(maxHp, curHp + maxHp / 8)
            sethp(actor, final)
        end
    end
end
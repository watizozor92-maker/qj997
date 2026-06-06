Privilege = {}
local this = {}
local _playerPrivileges = "PLAYER_HAS_PRIVILEGES"
local _privilegesRecord = "OPEN_PRIVILEGES_RECORD"

Privilege.PrivilegeType = {
    WILD_LINE = 1,                     -- 野外线路
    QUICK_SHOP = 2,                    -- 随身商店
    MONSTER_HOOK_PROTECTION = 3,       -- 小怪挂机保护
    BACKPACK_SPACE_INCREASE = 4,       -- 背包空间增加
    WAREHOUSE_INCREASE = 5,            -- 特权仓库增加
    AUTO_BUY_MEDICINE = 6,             -- 自动买药
    SWITCHING_POINT_SCHEME = 7,        -- 切换加点方案
    MASTER_TALENT_FREE_SWITCHING = 8,  -- 大师天赋免费切换
    FALLING_RATE_UP = 9,               -- 掉落提升
    EXP_ADD_RATE = 10,                 -- 经验提升
    RECYCLING_INCOME_UP = 11,          -- 回收收益提升
    PATROL_AFK = 12,                   -- 巡逻挂机
    REMOTE_WAREHOUSE = 13,             -- 远程仓库
    TRADE_LINE_UP_COUNT_INCREASE = 14, -- 交易行寄售货架数量增加
    AUTO_PICKUP = 16,                  -- 自动拾取
    AUTO_RECOVERY = 17,                -- 自动回收
    TRADE_SALE = 18,                   -- 交易行寄售功能开启
    COMBO_NUM = 19,                    -- 连击试炼每日次数增加
    COMBO_SWEEP_IS_OPEN = 20,          -- 连击副本扫荡功能开启
    TAX_RATE = 21,                     -- 调整税率
    MAPLINE = 22,                      -- 地图换线
    OFFLINE_ON_HOOK = 23,              -- 离线挂机
    WORlD_CHAT = 24,                   -- 世界聊天
    AUTOREPAIR = 25,                   -- 自动修理
    GOLD_LINE = 26,                    -- 黄金线路
}

Privilege.calculateType = {
    OPEN = 1,
    CLOSE = 2,
    ADD = 3,
    SUB = 4,
}

Privilege.Source = {
    DEFAULT       = "默认",
    PRIVILEGECARD = "特权卡",
}

function this.login(actor)
    local has, _ = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.WORlD_CHAT)
    if not has then
        local value = ConfigDataManager.getTableValue("cfg_global", "value", "id", 720001)
        if not string.isNullOrEmpty(value) then
            setinnerusedextdata(actor, { ban_channel = value })
        else
            setinnerusedextdata(actor, { ban_channel = "" })
        end
    else
        setinnerusedextdata(actor, { ban_channel = "" })
    end

    local is_open, rate = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.EXP_ADD_RATE)
    if is_open then
        ExpBonus.changeBonus(actor, BonusType.PRIVILEGE_EXP_BONUS, rate, 0, 0)
    else
        ExpBonus.changeBonus(actor, BonusType.PRIVILEGE_EXP_BONUS, 0, 0, 0)
    end

    Privilege.getPrivileges(actor)
end

-- 根据条件添加特权
function Privilege.conditionActPrivilege(actor)
    local configs = ConfigDataManager.getList("cfg_privilege_new")
    if table.isEmpty(configs) then
        return
    end

    local records = API.GetTable(actor, _privilegesRecord) or {}
    local byCondition = records.condition or {}
    for _, config in pairs(configs) do
        local privilegeId = tonumber(config.id)
        local reOpen = config.reopen
        -- 根据条件开启, 不能重复开启
        if not byCondition[privilegeId] or not string.isNullOrEmpty(reOpen) then
            local condition = config.condition
            if not string.isNullOrEmpty(condition) then
                local result = ConditionManager.Check(actor, condition)
                if result then
                    local has = this.hasSpecPrivilege(actor, Privilege.Source.DEFAULT, privilegeId)
                    -- 根据条件开启, 不能累加时间
                    if not has then
                        byCondition[privilegeId] = true
                        Privilege.addPrivilege(actor, tonumber(config.id))
                    end
                end
            end
        end
    end
    records.condition = byCondition
    API.SetTable(actor, _privilegesRecord, records)
end

-- 是否拥有某特权
function Privilege.hasPrivilege(actor, privilegeId)
    privilegeId = tonumber(privilegeId)
    local privileges = API.GetTable(actor, _playerPrivileges) or {}
    if table.isEmpty(privileges) then
        return false, 0
    end

    local config = ConfigDataManager.getById("cfg_privilege_new", privilegeId)
    if table.isEmpty(config) then
        return false, 0
    end
    local para = config.para
    local value = 0
    if string.contains(para, "#") then
        value = tonumber(string.split(para, "#")[2])
    else
        value = tonumber(para)
    end

    local found = false
    local total = 0
    for _, data in pairs(privileges) do
        local cfgId = data.cfgId
        if cfgId == privilegeId then
            found = true
            if value then
                if privilegeId == Privilege.PrivilegeType.EXP_ADD_RATE then
                    total = total > value and total or value
                elseif privilegeId == Privilege.PrivilegeType.TAX_RATE then
                    total = total == 0 and value or math.min(total, value)
                else
                    total = total + value
                end
            end
        end
    end
    return found, total
end

--- 添加特权 存在增加时间
---@param source any 自定义来源, 不同功能需要不同标识
---@param privilegeId number 配置id
---@param extTime number 持续时间毫秒值
function Privilege.addPrivilege(actor, privilegeId, extTime, source)
    source = source or Privilege.Source.DEFAULT
    local config = ConfigDataManager.getById("cfg_privilege_new", privilegeId)
    if table.isEmpty(config) then
        return
    end
    local privileges = API.GetTable(actor, _playerPrivileges) or {}
    local has, preData = this.hasSpecPrivilege(actor, source, privilegeId)
    local sourceId = source
    local now = getbaseinfo(actor, "now")
    local cfgTime = (tonumber(config.time) and tonumber(config.time) * 60 * 1000 or -1)
    local duration = extTime and extTime or cfgTime
    local closeTime
    if has and duration > 0 then
        local precloseTime = preData.closeTime
        duration = math.max(precloseTime - now, 0) + duration
        closeTime = now + duration
    elseif not has and duration > 0 then
        closeTime = now + duration
    else
        closeTime = -1
    end
    local data = {
        sourceId = sourceId, -- 防止不同功能添加同一特权覆盖导致计算数值只有一份
        cfgId = tonumber(privilegeId),
        startTime = now,
        closeTime = closeTime,
    }
    if has then
        this.replacePrivilege(sourceId, privilegeId, data, privileges)
    else
        table.insert(privileges, data)
    end
    -- 提前发送特权信息
    Privilege.getPrivileges(actor, privileges)
    if not has then
        -- 添加功能特权
        this.handleOtherFunction(actor, source, config, true)
    end
    API.SetTable(actor, _playerPrivileges, privileges)
    gameDebug.print(actor, "添加特权成功", source, privilegeId, extTime, closeTime)
end

-- 某一来源某种特权是否存在
function this.hasSpecPrivilege(actor, sourceId, privilegeId)
    privilegeId = tonumber(privilegeId)
    local privileges = API.GetTable(actor, _playerPrivileges) or {}
    if table.isEmpty(privileges) then
        return false
    end
    local config = ConfigDataManager.getById("cfg_privilege_new", privilegeId)
    if table.isEmpty(config) then
        return false
    end
    for _, data in pairs(privileges) do
        local cfgId = data.cfgId
        local source = data.sourceId
        if cfgId == privilegeId and source == sourceId then
            return true, data
        end
    end
    return false
end

function this.replacePrivilege(sourceId, privilegeId, newData, privileges)
    privilegeId = tonumber(privilegeId)
    if table.isEmpty(privileges) then
        return
    end
    for i, data in pairs(privileges) do
        local cfgId = data.cfgId
        local source = data.sourceId
        if cfgId == privilegeId and source == sourceId then
            privileges[i] = newData
            break
        end
    end
end

function Privilege.checkTimeOut(actor)
    local privileges = API.GetTable(actor, _playerPrivileges) or {}
    if table.isEmpty(privileges) then
        return
    end
    local closePrivileges = {}
    local now = getbaseinfo(actor, "now")
    for i = #privileges, 1, -1 do
        local data = privileges[i]
        local closeTime = data.closeTime
        if closeTime <= now and closeTime > 0 then
            table.remove(privileges, i)
            table.insert(closePrivileges, data)
        end
    end

    if not table.isEmpty(closePrivileges) then
        API.SetTable(actor, _playerPrivileges, privileges)
        Privilege.getPrivileges(actor)

        for _, data in pairs(closePrivileges) do
            local cfgId = data.cfgId
            local sourceId = data.sourceId
            -- 该项特权关闭
            gameDebug.print(actor, "尝试清理特权", sourceId, cfgId)
            local config = ConfigDataManager.getById("cfg_privilege_new", cfgId)
            if not table.isEmpty(config) then
                this.handleOtherFunction(actor, sourceId, config, false)
            end
        end
    end
end

function Privilege.getPrivileges(actor, privileges)
    privileges = privileges or API.GetTable(actor, _playerPrivileges) or {}
    -- lg("获取特权数据:", privileges)
    local sendPrivileges = {}
    for _, data in pairs(privileges) do
        local cfgId = data.cfgId
        local closeTime = data.closeTime
        local has = sendPrivileges[cfgId]
        if not has then
            sendPrivileges[cfgId] = closeTime
        else
            sendPrivileges[cfgId] = math.max(sendPrivileges[cfgId], closeTime)
        end
    end
    local msg = {}
    for cfgId, closeTime in pairs(sendPrivileges) do
        local _, value = Privilege.hasPrivilege(actor, cfgId)
        msg[cfgId] = {
            closeTime = closeTime,
            value = value,
        }
    end
    -- lg("发送特权数据:", msg)
    sendluamsg(actor, LuaMessageIdToClient.RES_PLAYER_PRIVILEGES, msg)
end

function Privilege.privileges(actor)
    local privileges = API.GetTable(actor, _playerPrivileges) or {}
    return privileges
end

-- 加特权之前, 删特权之后调用
function this.handleOtherFunction(actor, source, config, open)
    local id = tonumber(config.id)
    local para = config.para
    local func = Privilege.FunctionMapping[id]
    if not func then
        return
    end
    local preValue
    local type
    local found, data = Privilege.hasPrivilege(actor, id)
    if open then
        -- 其他来源有此特权, 获取已经存在的数据
        if found then
            type = Privilege.calculateType.ADD
            preValue = data
        else
            type = Privilege.calculateType.OPEN
        end
    else
        -- 其他来源有此特权, 获取已经存在的数据
        if found then
            type = Privilege.calculateType.SUB
            preValue = data
        else
            type = Privilege.calculateType.CLOSE
        end
    end

    local success, errorInfo = xpcall(func, debug.traceback, actor, config, para, open, preValue, type)
    gameDebug.assertPrint(success, errorInfo)
end

-- ====================================处理特权功能========================================
function this.autoBuyMedicine(actor, config, para, open, preValue, type)
    gameDebug.print(actor, "处理自动买药", open, para, preValue, type)
    if open then
        local options = AutoBuyPotionScript.findOptions(actor)
        AutoBuyPotionScript.setBuyOption(actor, options, true)
        AutoBuyPotionScript.sendBuyOption(actor)
    else
        AutoBuyPotionScript.setBuyOption(actor, {}, true)
        AutoBuyPotionScript.sendBuyOption(actor)
    end
end

function this.fallRate(actor, config, para, open, preValue, type)
    gameDebug.print(actor, "处理月掉落概率", open, para, preValue, type)
    if para and para ~= "" then
        local drop_tbl = string.split(para, "#")
        local attr_map = {}
        attr_map[tonumber(drop_tbl[1])] = tonumber(drop_tbl[2])
        if type == Privilege.calculateType.CLOSE then
            RoleAttr.clearRoleAttrAndDB(actor, RoleAttrKey.PRIVILEGE_MONTH_DROP_RATE)
        elseif type == Privilege.calculateType.SUB then
            RoleAttr.reduceAndSaveRoleAttr(actor, RoleAttrKey.PRIVILEGE_MONTH_DROP_RATE, attr_map)
        else
            RoleAttr.addAndSaveRoleAttr(actor, RoleAttrKey.PRIVILEGE_MONTH_DROP_RATE, attr_map)
        end
    end
end

function this.changeBagCapacity(actor, config, para, open, preValue, type)
    gameDebug.print(actor, "处理背包容量", open, para, preValue, type)
    local function handleCapacityChange(action, grids)
        action(actor, grids)
    end
    local action = open and unlockbaggridcount or lockbaggridcount
    if para and para ~= "" then
        handleCapacityChange(action, para)
    end
end

function this.changeHouseCapacity(actor, config, para, open, preValue, type)
    gameDebug.print(actor, "处理仓库容量", open, para, preValue, type)
    local function handleCapacityChange(action, pages)
        for _, page in pairs(pages) do
            action(actor, page)
        end
    end
    local pages = string.split(para, "#")
    local action = open and unlockstoregridcount or lockstoregridcount
    if pages then
        handleCapacityChange(action, pages)
    end
end

function this.changeComboCount(actor, config, para, open, preValue, type)
    gameDebug.print(actor, "处理连击次数", open, para, preValue, type)
    local comboNum = para
    if comboNum and comboNum ~= "" then
        comboNum = tonumber(comboNum)
        if open then
            addleftcountofactivity(actor, DuplicateType.COMBO_TEST, comboNum)
            ComboTest.setComboTestAddCount(actor)
        else
            local comboCount = getleftcountofactivity(actor, DuplicateType.COMBO_TEST)
            if comboCount and comboCount > 0 then
                comboNum = comboCount - comboNum > 0 and comboCount - comboNum or comboCount
                reduceactivitytimes(actor, DuplicateType.COMBO_TEST, comboNum)
                ComboTest.setComboTestAddCount(actor)
            end
        end
    end
end

function this.autoRepair(actor, config, para, open, preValue, type)
    gameDebug.print(actor, "处理自动修复", open, para, preValue, type)
    if open then
        EquipDurability.changeAutoRepair(actor, false, true)
    else
        EquipDurability.changeAutoRepair(actor, true, true)
    end
end

function this.expEnhance(actor, config, para, open, preValue, type)
    gameDebug.print(actor, "处理经验加成", open, para, preValue, type)
    local attr = string.split(para, "#")
    local attrMap = { [tonumber(attr[1])] = tonumber(attr[2]) }
    if type == Privilege.calculateType.CLOSE then
        RoleAttr.clearRoleAttrAndDB(actor, RoleAttrKey.PRIVILEGE_EXP_BOOST)
        ExpBonus.changeBonus(actor, BonusType.PRIVILEGE_EXP_BONUS, 0, 0, 0)
    elseif type == Privilege.calculateType.SUB then
        RoleAttr.reduceAndSaveRoleAttr(actor, RoleAttrKey.PRIVILEGE_EXP_BOOST, attrMap)
        ExpBonus.changeBonus(actor, BonusType.PRIVILEGE_EXP_BONUS, -tonumber(attr[2]), 0, 0)
    else
        RoleAttr.addAndSaveRoleAttr(actor, RoleAttrKey.PRIVILEGE_EXP_BOOST, attrMap)
        ExpBonus.changeBonus(actor, BonusType.PRIVILEGE_EXP_BONUS, tonumber(attr[2]), 0, 0)
    end
end

function this.handlekWorldChat(actor, config, para, open, preValue, type)
    gameDebug.print(actor, "处理世界对话权限", open, para, preValue, type)
    if open then
        setinnerusedextdata(actor, { ban_channel = "" })
    else
         local value = ConfigDataManager.getTableValue("cfg_global", "value", "id", 720001)
        if not string.isNullOrEmpty(value) then
            setinnerusedextdata(actor, { ban_channel = value })
        else
            setinnerusedextdata(actor, { ban_channel = "" })
        end
    end
end

function this.autoRecovery(actor, config, para, open, preValue, type)
    gameDebug.print(actor, "处理自动回收", open, para, preValue, type)
    if open then
        -- 勾选自动范围拾取
        setplayersetting(actor, 25, true)
        -- 勾选自动回收
        setplayersetting(actor, 18, true)
    end
end

-- ====================================注册特权处理函数======================================
Privilege.FunctionMapping = {
    [Privilege.PrivilegeType.AUTO_BUY_MEDICINE] = this.autoBuyMedicine,
    [Privilege.PrivilegeType.FALLING_RATE_UP] = this.fallRate,
    [Privilege.PrivilegeType.BACKPACK_SPACE_INCREASE] = this.changeBagCapacity,
    [Privilege.PrivilegeType.WAREHOUSE_INCREASE] = this.changeHouseCapacity,
    [Privilege.PrivilegeType.COMBO_NUM] = this.changeComboCount,
    [Privilege.PrivilegeType.AUTOREPAIR] = this.autoRepair,
    [Privilege.PrivilegeType.EXP_ADD_RATE] = this.expEnhance,
    [Privilege.PrivilegeType.WORlD_CHAT] = this.handlekWorldChat,
    [Privilege.PrivilegeType.AUTO_RECOVERY] = this.autoRecovery,
}


-- 登录
LoginEventListerTable:eventLister("0", "玩家特权", this.login)

-- ====================================测试========================================
function testprivilege(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        -- Privilege.addPrivilege(actor, Privilege.PrivilegeType.AUTOREPAIR, 10000, Privilege.Source.DEFAULT)
        Privilege.addPrivilege(actor, tonumber(args[2]), tonumber(args[3]), Privilege.Source.PRIVILEGECARD)
    elseif opt == 2 then
        API.SetTable(actor, _playerPrivileges, {})
        API.SetTable(actor, _privilegesRecord, {})
    elseif opt == 3 then
        lg(API.GetTable(actor, _playerPrivileges))
        lg(API.GetTable(actor, _privilegesRecord))
    elseif opt == 4 then
        local found, data = Privilege.hasPrivilege(actor, tonumber(args[2]))
        lg(found, data)
    elseif opt == 5 then
        Privilege.getPrivileges(actor)
    end
end

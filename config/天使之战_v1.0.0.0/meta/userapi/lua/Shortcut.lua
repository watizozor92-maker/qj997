Shortcut = {}
local this = {}

local shortcut_key = "T$playershortcut"

function Shortcut.itemChange(actor, cfgId, newCount)
    if newCount > 0 then
        return
    end
    local shortcut = getplaydef(actor, shortcut_key) or {}
    if (shortcut.guard or 0) ~= cfgId then
        return
    end

    local count = Bag.getRealCount(actor, cfgId, -1, 2)
    if count > 0 then
        return
    end
    shortcut.guard = nil
    -- 获取当前穿戴守护的rank
    local currentRank = string.tonumber(ConfigDataManager.getTableValue("cfg_equip_guard", "rank", "id", cfgId))
        -- 选择下一个守护
    local nextGuard = this.selectNextGuard(currentRank, actor)

    if nextGuard then
        shortcut.guard = nextGuard.itemCfgId
    end

    setplaydef(actor, shortcut_key, shortcut)
    this.sendShortcuts(actor)
    --ZzpTest.print("没有该道具，删掉快捷栏", cfgId)
end

-- 辅助函数：根据当前rank选择下一个守护
function this.selectNextGuard(currentRank, actor)
    -- 边界检查
    if not actor then
        return nil
    end

    local data = getallbagiteminfo(actor)
    if not data then
        return nil
    end

    -- 直接收集并排序守护，减少临时变量
    local guardList = {}
    -- 收集并去重所有守护装备
    local seenCfgIds = {}
    for i = 1, #data do
        local item = data[i]
        local itemCfgId = item.cfgid
        if this.isguardequip(itemCfgId) and not seenCfgIds[itemCfgId] then
            local rank = string.tonumber(ConfigDataManager.getTableValue("cfg_equip_guard", "rank", "id", itemCfgId))
            if rank > 0 then -- 确保rank有效
                table.insert(guardList, { itemCfgId = itemCfgId, rank = rank })
                seenCfgIds[itemCfgId] = true
            end
        end
    end
    
    if #guardList == 0 then
        return nil
    end
    
    -- 按rank从小到大排序
    table.sort(guardList, function(a, b) return a.rank < b.rank end)
    
    -- 寻找下一个rank的守护，循环选择（1→2→3→4→5→1...）
    for _, v in ipairs(guardList) do
        if v.rank > currentRank then
            return v
        end
    end
    
    -- 如果没有找到更高rank的守护，选择rank最小的
    return guardList[1]
end

function Shortcut.store(actor, cfgId, index)
    if not this.isguardequip(cfgId) then
        return
    end
    local shortcut = getplaydef(actor, shortcut_key) or {}
    if table.isEmpty(shortcut) then
        shortcut.guard = cfgId
        setplaydef(actor, shortcut_key, shortcut)
        this.sendShortcuts(actor)
        return
    end
    local guard = shortcut.guard
    if guard then
        return
    end
    shortcut.guard = cfgId
    setplaydef(actor, shortcut_key, shortcut)
    this.sendShortcuts(actor)
end

function Shortcut.afterPuton(actor, cfgId)
    if not this.isguardequip(cfgId) then
        return
    end

    local shortcut = getplaydef(actor, shortcut_key) or {}
    local guard = shortcut.guard
    if guard ~= cfgId then
        -- 穿戴的不是快捷栏上的装备
        return
    end

    -- 穿戴了快捷栏上的装备, 背包里的替换上一个
    shortcut.guard = nil
    
    -- 获取当前穿戴守护的rank
    local currentRank = string.tonumber(ConfigDataManager.getTableValue("cfg_equip_guard", "rank", "id", cfgId))
    
    -- 选择下一个守护
    local nextGuard = this.selectNextGuard(currentRank, actor)
    
    if nextGuard then
        shortcut.guard = nextGuard.itemCfgId
    end

    setplaydef(actor, shortcut_key, shortcut)
    this.sendShortcuts(actor)
end

function Shortcut.afterTakeOff(actor, cfgId)    
    if not this.isguardequip(cfgId) then
        return
    end
    local shortcut = getplaydef(actor, shortcut_key) or {}
    local guard = shortcut.guard
    if guard then
        return
    end
    shortcut.guard = cfgId
    setplaydef(actor, shortcut_key, shortcut)
    this.sendShortcuts(actor)
end

function Shortcut.tryRemoveItem(actor, cfgId, itemId)
    if not this.isguardequip(cfgId) then
        return
    end
    local shortcut = getplaydef(actor, shortcut_key) or {}
    local guard = shortcut.guard
    if guard ~= cfgId then
        -- 摧毁的不是快捷栏上的装备
        return
    end
    shortcut.guard = nil

    -- 获取当前销毁守护的rank
    local currentRank = string.tonumber(ConfigDataManager.getTableValue("cfg_equip_guard", "rank", "id", cfgId))
    
    -- 选择下一个守护
    local nextGuard = this.selectNextGuard(currentRank, actor)
    
    if nextGuard then
        shortcut.guard = nextGuard.itemCfgId
    end
    
    setplaydef(actor, shortcut_key, shortcut)
    this.sendShortcuts(actor)
end

-- 手动设置
function Shortcut.setGuard(actor, cfgId)
    if not this.isguardequip(cfgId) then
        return
    end
    local data = getbagitemcountbyid(actor, cfgId)
    if data <= 0 then
        return
    end
    local shortcut = getplaydef(actor, shortcut_key) or {}
    shortcut.guard = cfgId
    setplaydef(actor, shortcut_key, shortcut)
    this.sendShortcuts(actor)
end

function this.sendShortcuts(actor)
    local shortcut = getplaydef(actor, shortcut_key) or {}
    sendluamsg(actor, LuaMessageIdToClient.RES_SHORTCUTS_INFO, shortcut)
end

function this.isguardequip(itemCfgId)
    local config = ConfigDataManager.getById("cfg_item", itemCfgId)
    if table.isEmpty(config) then
        return false
    end
    if string.tonumber(config.subtype) ~= EquipSubType.GUARD or string.tonumber(config.type) ~= ItemType.EQUIP then
        return false
    end
    return true
end

LoginEventListerTable:eventLister("0", "shortvut", this.sendShortcuts)
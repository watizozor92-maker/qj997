RandomUtil = {}


-- 示例："1#80|2#10|3#10"
-- 80%的概率选中1
-- 10%的概率选中2
-- 80%的概率选中3
function RandomUtil.selectKey(configStr)
    local randomValue = math.random(0, 100)
    local configMap = string.toStringStringMap(configStr, "#", "|")
    local count = 0
    for key, value in pairs(configMap) do
        count = count + tonumber(value)
        if randomValue <= count then
            return tonumber(key)
        end
    end
    return 0
end

--- 选择一个key
function RandomUtil.weightKeyToString(configStr, sep1, sep2)
    local weightTable = string.toStringIntMap(configStr, sep1, sep2)
    return RandomUtil.weightKey0(weightTable)
end

function RandomUtil.weightKeyToInt(configStr, sep1, sep2)
    local weightTable = string.toIntIntMap(configStr, sep1, sep2)
    return RandomUtil.weightKey0(weightTable)
end

function RandomUtil.weightKey0(weightTable)
    if table.isEmpty(weightTable) then
        return 0
    end
    local total = table.getValueCount(weightTable)
    local randomValue = math.random(1, total)
    local count = 0
    for key, value in pairs(weightTable) do
        count = count + value
        if randomValue <= count then
            return key
        end
    end
    return 0
end

--根据权重取不同下标
function RandomUtil.GetQZWithout(tab, havdTab)
    if table.isEmpty(tab) then
        return 0
    end

    local max = 0
    for i = 1, #tab do
        local info = tab[i]
        if not table.contains(havdTab, info.id) then
            max = max + info.qz
        end
    end

    local randomValue = math.random(1, max)

    local count = 0
    for i = 1, #tab do
        local info = tab[i]
        if not table.contains(havdTab, info.id) then
            count = count + info.qz
            if randomValue <= count then
                return info.id
            end
        end
    end
    return 0
end

function RandomUtil.isLuck(rate, base)
    if base == nil then
        base = NumConstant.PROP_10000
    end
    if rate <= 0 then
        return false
    end
    return rate >= math.random(0, base)
end

--- 从配置字符串中随机抽取一个 key（不考虑权重，纯随机）
--- @param configStr string 配置字符串，例如："200031#1|213021#7|200021#30"
--- @param sep1 string 内层分隔符，默认为 "#"
--- @param sep2 string 外层分隔符，默认为 "|"
--- @return number 随机选中的 key，失败返回 0
function RandomUtil.randomKey(configStr, sep1, sep2)
    local map = string.toStringIntMap(configStr, sep1, sep2)
    return RandomUtil.randomKeyFromMap(map)
end

--- 从 map 中随机抽取一个 key（不考虑权重，纯随机）
--- @param map table 键值对表
--- @return any 随机选中的 key，如果表为空返回 nil
function RandomUtil.randomKeyFromMap(map)
    if table.isEmpty(map) then
        return nil
    end
    
    -- 获取所有的 keys
    local keys = {}
    for key, _ in pairs(map) do
        table.insert(keys, key)
    end
    
    -- 随机选择一个索引
    local randomIndex = math.random(1, #keys)
    return keys[randomIndex]
end

-- 适用于属性万分比的概率随机 
-- @param rate 从内置直接获取小数的属性值（0-1之间的小数）
-- @return boolean 是否命中
function RandomUtil.isAttRateHit(rate)
    if rate <= 0 then
        return false
    end
    if rate >= 1 then
        return true
    end
    return math.random(1, 10000) <= rate * 10000
end
--[[ 
 带缓存的表配置读取帮助函数
 
 local tableConfig = gettable("cfg_xxx") 
 用
 local tableConfig = ConfigDataManager.getList("cfg_xxx")
 替代
 
 这么实现的原因：gettable命令用于读取表数据，而且往往会返回大量的数据（多条记录或整个表）。根据压测监控发现，将java中数据传递到lua脚本空间中需要大量拷贝操作，很消耗CPU，因此在脚本中直接缓存了数据来提高性能
 
 注：如有热更新表的操作，需要同步热更新脚本
 ]]

ConfigDataManager = {}

local configMap = {}

local configItemMap = {}

local tableValueMap = {}

function ConfigDataManager.clear()
    configMap = {}
    configItemMap = {}
    tableValueMap = {}
end

---读取整个表配置
function ConfigDataManager.getList(tableName)
    local found = table.getValue(configMap, tableName)
    if found ~= nil then
        return found
    end
    local configList = gettable(tableName)
    if configList ~= nil then
        configList = table.proxyReadOnlyTable(configList)
        configMap[tableName] = configList
        return configList
    end
    return nil
end

---读取单个表配置项
function ConfigDataManager.getById(tableName, id)
    local configList = ConfigDataManager.getTable(tableName, "id", id)
    if configList ~= nil and table.count(configList) >= 1 then
        return configList[1]
    end
    return nil
end

---和java的gettable一样，返回列表的第一行
function ConfigDataManager.getTableFirst(tableName, ...)
    local configList = ConfigDataManager.getTable(tableName, ...)
    if configList ~= nil and table.count(configList) >= 1 then
        return configList[1]
    end
    return nil
end

---和java的gettable一样，返回的是列表
function ConfigDataManager.getTable(tableName, ...)
    local success, ret = xpcall(getTable0, debug.traceback, tableName, ...)
    gameDebug.assertTrue(success, "getTable error", ret, "参数 ", tableName, ...)
    return ret
end

---和java的gettablevalue一样，返回的是单个值
function ConfigDataManager.getTableValue(tableName, ...)
    local success, ret = xpcall(getTableValue0, debug.traceback, tableName, ...)
    gameDebug.assertTrue(success, "getTableValue error", ret, "参数 ", tableName, ...)
    return ret
end

--- 和java的gettablevalue一样，返回的是单个值，但是是数字类型空字符串会返回0
function ConfigDataManager.getIntTableValue(tableName, ...)
    local ret = ConfigDataManager.getTableValue(tableName, ...)
    return string.tonumber(ret)
end

function ConfigDataManager.getGlobal(id)
    return ConfigDataManager.getTableValue("cfg_global", "value", "id", id)
end

---和java的gettable一样，返回的是列表
function getTable0(tableName, ...)
    local args = { ... }
    local _key = tableName
    for i, v in pairs(args) do
        _key = _key .. "#" .. v
    end
    local found = table.getValue(configItemMap, _key)
    if found ~= nil then
        return found
    end
    local configList = gettable(tableName, ...)
    if configList ~= nil and table.count(configList) >= 1 then
        configList = table.proxyReadOnlyTable(configList)
        configItemMap[_key] = configList
        return configList
    end
    return nil
end

---和java的gettablevalue一样，返回的是单个值
function getTableValue0(tableName, ...)
    local args = { ... }
    local _key = tableName
    for i, v in pairs(args) do
        _key = _key .. "#" .. v
    end
    local found = table.getValue(tableValueMap, _key)
    if found ~= nil then
        return found
    end
    local cfg = gettablevalue(tableName, ...)
    if cfg ~= nil then
        tableValueMap[_key] = cfg
        return cfg
    end
    return nil
end

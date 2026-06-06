--- 条件注册，触发

---条件注册
ConditionTable = {}

ConditionTable.__index = ConditionTable

--- 创建一个条件监听容器
function ConditionTable.new()
    return setmetatable({}, ConditionTable)
end

--- 获取条件容器
---@param conditionId any 条件类型
function ConditionTable:cMap(conditionId)
    conditionId = tostring(conditionId)
    if not self[conditionId] then
        self[conditionId] = {}
    end
    return self[conditionId]
end

--- 注册条件
---@param conditionId number 条件类型
---@param cName string 条件名称
---@param cFun function 条件回调函数
function ConditionTable:register(conditionId, cName, cFun)
    local em = self:cMap(conditionId)
    if not table.isNullOrEmpty(em) then
        gameDebug.error("存在相同的条件【" .. cName .. "】注册 id为【" .. conditionId .. "】")
    end
    em[cName] = cFun
    --gameDebug.printType(_VERSION, "注册条件:", self, em, conditionId, cName)
end

--- 触发条件
---@param conditionId number 条件类型
---@param name string 条件名称
---@param ... any 条件参数
function ConditionTable:triggerCheck(conditionId, ...)
    local em = self:cMap(conditionId)
    if em then
        for k, v in pairs(em) do
            local s, e = xpcall(v, debug.traceback, ...)
            gameDebug.assertPrintTrace(s, "触发条件", k, "调用异常", ..., e)
            return e
        end
    end
end

--- 条件处理器
ConditionHandler = ConditionTable.new()

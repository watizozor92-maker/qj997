-- 公有的，可以外部调用
LogManager = {}

-- 私有的，只能内部使用
local this = {}

LogRecordType = {
    faceToFaceTrade = 101,
}
-- 注册的日志处理器
local HANDLER_MAP = {}

-- 注册handler
function LogManager.RegisterHandler(type, func)
    HANDLER_MAP[type] = func
end

-- 获取handler
function LogManager.GetHandler(type)
    return HANDLER_MAP[type]
end

-- 执行方法
function LogManager.TriggerByType(actor, type, params)
    local func            = LogManager.GetHandler(type)
    local success, result = xpcall(func, function(err)
        error("LogManager记录脚本日志错误", actor, type, params, debug.traceback())
    end, actor, params)
end

-- 记录日志
function LogManager.log(actor, type, content)
    logop(actor, type, content)
end


---------------------------------------------------------注册不同的日志记录处理器----------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------

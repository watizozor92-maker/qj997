ConditionManager = {}

local this = ConditionManager

function ConditionManager.getParam(singleCondition)
    local strs = string.split(singleCondition, '#')
    local id = tonumber(strs[1])
    local param = string.replace(singleCondition, strs[1] .. '#', '') --strs[2]
    return id, param
end

function ConditionManager.Check(actor, conditionCfg)
    if string.isNullOrEmpty(conditionCfg) then
        return true
    end
    
    local groupStr = string.split(conditionCfg, '/')
    local result = false
    for i = 1, #groupStr do
        local singleStrs = string.split(groupStr[i], '&')
        local andResult = true
        for j = 1, #singleStrs do
            local id, param = this.getParam(singleStrs[j])
            local check    = ConditionHandler:triggerCheck(id, actor, param)
            andResult      = andResult and check
        end
        result = result or andResult
        if (result) then
            break
        end
    end
    return result
end

function checkfunc(actor, param)
    jprint("条件检测参数", param)
    local res = ConditionManager.Check(actor, param)
    jprint("条件检测结果", res)
end

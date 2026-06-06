require "dev/Condition/ConditionBase"
require "dev/Condition/LevelCondition"
require "dev/Condition/TimeCondition"
require "dev/Condition/CareerCondition"
require "dev/Condition/RechargeCondition"
require "dev/Condition/VIPCondition"
require "dev/Condition/BagItemCondition"
require "dev/Condition/UnionCondition"
require "dev/Condition/PrivilegeCondition"
require "dev/Condition/OtherCondition"
ConditionManager = {}

local this = ConditionManager
local excuterMap = {}

---获取条件类实例
---@param singleCondition string|table 单个条件
---@return ConditionBase
function ConditionManager.GenerateSingleCondition(singleCondition)
    if (type(singleCondition) == "table") then
        local stype = singleCondition[1]
        local param = singleCondition[2] --singleCondition[2]
        if table.count(singleCondition) > 2 then
            param = {}
            for i = 2, table.count(singleCondition) do
                table.insert(param, singleCondition[i])
            end
        end
        local classNum = math.floor(stype / 100)
        local comparatorNum = stype % 100
        local instance
        local excuter = excuterMap[classNum]
        if excuter then
            instance = excuter(comparatorNum, param)
        else
            SL:LogError(string.format('%s类型条件不存..参数..%s', classNum, tostring(param)))
        end
        return instance
    else
        local strs = string.split(singleCondition, '#')
        local stype = tonumber(strs[1])
        local param = string.replace(singleCondition, strs[1] .. '#', '')--strs[2]
        local classNum = math.floor(stype / 100)
        local comparatorNum = stype % 100
        local instance
        local excuter = excuterMap[classNum]
        instance = excuter(comparatorNum, param)
        return instance
    end
end

function ConditionManager.Init()
    this.RegistExcuters()
end

function ConditionManager.RegistExcuters()
    this.RegistExcuter(1, LevelCondition)
    this.RegistExcuter(2, RechargeCondition)
    this.RegistExcuter(9, TimeCondition)
    this.RegistExcuter(12, VIPCondition)
    this.RegistExcuter(21, PrivilegeCondition)
    this.RegistExcuter(23, BagItemCondition)
    this.RegistExcuter(25, UnionCondition)
    this.RegistExcuter(26, OtherCondition)
end

---注册条件
---@param head number 条件的大类 如101除百是1
---@param class ConditionBase 对应的条件类
function ConditionManager.RegistExcuter(head, class)
    excuterMap[head] = class
    class.type = head
end

---对外接口 判断条件集是否满足  案例（等级大于等于1并且小于等于10 ）
---@param conditionCfg string|table 具体的条件 支持#,&符号
---@return boolean
function ConditionManager.Check(conditionCfg)
    if (type(conditionCfg) == "table") then
        ---样式：{{101,1},{103,10}}
        local singleStrs = conditionCfg
        local andResult = true
        local conditonInstance
        for j = 1, #singleStrs do
            conditonInstance = this.GenerateSingleCondition(singleStrs[j])
            andResult = andResult and conditonInstance:Check()
            if (andResult == false) then
                return andResult
            end
        end
        return andResult
    else
        ---样式："101#1&103#10"
        local groupStr = string.split(conditionCfg, '/')
        local result = false
        local conditonInstance
        for i = 1, #groupStr do
            local singleStrs = string.split(groupStr[i], '&')
            local andResult = true
            for j = 1, #singleStrs do
                conditonInstance = this.GenerateSingleCondition(singleStrs[j])
                andResult = andResult and conditonInstance:Check()
            end
            result = result or andResult
            if (result) then
                break
            end
        end
        return result
    end
end

---对外接口 判断条件集是否满足    案例（等级大于等于1并且小于等于10 ）或者 （开服天数大于等于1并且小于等于10）
---@param conditionCfg string|table 具体的条件 支持#,&,/符号
---@return boolean
function ConditionManager.Check4D(conditionCfg)
    if (type(conditionCfg) == "table") then
        ---样式：{{{101,1},{103,10}},{{901,1},{903,10}}}
        local groupStr = conditionCfg
        local result = false
        if table.isNullOrEmpty(conditionCfg) then
            return true
        end
        local conditonInstance
        for i = 1, #groupStr do
            local singleStrs = groupStr[i]
            local andResult = true
            for j = 1, #singleStrs do
                conditonInstance = ConditionManager.GenerateSingleCondition(singleStrs[j])
                andResult = andResult and conditonInstance:Check()
            end
            result = result or andResult
            if (result) then
                break
            end
        end
        return result
    else
        ---样式："101#1&103#10/901#1&903#10"
        if conditionCfg == "" then
            return true
        end
        local groupStr = string.split(conditionCfg, '/')
        local result = false
        local conditonInstance
        for i = 1, #groupStr do
            local singleStrs = string.split(groupStr[i], '&')
            local andResult = true
            for j = 1, #singleStrs do
                conditonInstance = this.GenerateSingleCondition(singleStrs[j])
                andResult = andResult and conditonInstance:Check()
            end
            result = result or andResult
            if (result) then
                break
            end
        end
        return result
    end
end

---获取条件里的参数
---"901#1&903#11" 返回{1，11}
function ConditionManager.GetConditionParams(conditionStr)
    local params = {}
    for param in string.gmatch(conditionStr, "#([0-9]+)") do
        table.insert(params, tonumber(param))
    end
    return params
end

this.Init()
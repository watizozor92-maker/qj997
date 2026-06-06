
---@class CareerCondition
CareerCondition = class(ConditionBase)

CareerCondition.comparatorMap = { 
}

function CareerCondition:InitParam(param)
    self.params = {}
    if tonumber(param) then
        table.insert(self.params,tonumber(param))
    else
        if type(param) == "table" then 
            self.params = param
        else
            local strTab = string.split(param,'#')
            for i = 1, table.count(strTab) do
                table.insert(self.params,tonumber(strTab[i]))
            end
        end
        
    end
end
---@class MonsterExtData 怪物扩展数据
---@field lastReliveTime4Type5 number 复活类型为5的怪物上次的复活时间戳(毫秒)
---@field save function 保存


MonsterExtData = {}
MonsterExtData.__index = MonsterExtData




---@return MonsterExtData
function MonsterExtData.get(monsterActor)
    local data = getmonsterextdata(monsterActor)
    return setmetatable(data or {}, MonsterExtData)
end


function MonsterExtData:save(monsterActor)
    setmonsterextdata(monsterActor, self)
end




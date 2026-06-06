Vector3Pool = TablePool(true)
---@return Vector3
function Vector3Pool.Get()
    ---@type Vector3
    local vec = Vector3Pool:Pop(Vector3)
    vec:Set(0,0,0)
    return vec
end

function Vector3Pool.Recycle(t)
    Vector3Pool:Push(t)
end

SimpleVector3Pool = SimpleTablePool(true)
---@return Vector3
function SimpleVector3Pool.Get()
    ---@type Vector3
    local vec = SimpleVector3Pool:Pop(Vector3)
    vec:Set(0,0,0)
    return vec
end

function SimpleVector3Pool.GetNoInitZero()
    ---@type Vector3
    local vec = SimpleVector3Pool:Pop(Vector3)
    return vec
end

function SimpleVector3Pool.Recycle(t)
    SimpleVector3Pool:Push(t)
end
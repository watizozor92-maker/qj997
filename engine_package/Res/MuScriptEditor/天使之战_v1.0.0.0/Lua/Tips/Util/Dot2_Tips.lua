--------------------------------------------------------------------------------
--      Copyright (c) 2015 , 蒙占志(topameng) topameng@gmail.com
--      All rights reserved.
--      Use, modification and distribution are subject to the "MIT License"
--------------------------------------------------------------------------------
-- added by wsh @ 2017-12-28
-- 注意：
-- 1、已经被修改，别从tolua轻易替换来做升级

local sqrt = math.sqrt
local setmetatable = setmetatable
local rawget = rawget
local math = math
local acos = math.acos
local max = math.max

---@class Dot2
---@field public x number
---@field public z number
---@field zero Dot2
---@field normalized Dot2
---@field abs Dot2
---@field sign Dot2
Dot2 = {}
local _getter = {}
Dot2.isValueType = true
Dot2.__index = function(t,k)
    local var = rawget(Dot2, k)
    if var ~= nil then
        return var
    end

    var = rawget(_getter, k)
    if var ~= nil then
        return var(t)
    end

    return nil
end

Dot2.__call = function(t, x, z)
    return setmetatable({x = x or 0, z = z or 0}, Dot2)
end

function Dot2.New(x, z)
    return setmetatable({x = x or 0, z = z or 0}, Dot2)
end

function Dot2:Set(x,z)
    self.x = x or 0
    self.z = z or 0
end

function Dot2:Get()
    return self.x, self.z
end

function Dot2:SqrMagnitude()
    return self.x * self.x + self.z * self.z
end

function Dot2.Abs(v)
    v.x = math.abs(v.x)
    v.z = math.abs(v.z)
    return setmetatable({x = v.x, z = v.z}, Dot2)
end

function Dot2:Clone()
    return setmetatable({x = self.x, z = self.z}, Dot2)
end


function Dot2.Normalize(v)
    local x,z = Dot2.GetNormalizeXZ(v)
    return setmetatable({x = x, z = z}, Dot2)
end

function Dot2.GetNormalizeXZ(v)
    local x = v.x
    local z = v.z
    local magnitude = sqrt(x * x + z * z)

    if magnitude > 1e-05 then
        x = x / magnitude
        z = z / magnitude
    else
        x = 0
        z = 0
    end
    return x,z
end

function Dot2.Sign(v)
    return setmetatable({x =math.sign(v.x), z = math.sign(v.z)}, Dot2)
end

function Dot2:SetNormalize()
    local magnitude = sqrt(self.x * self.x + self.z * self.z)

    if magnitude > 1e-05 then
        self.x = self.x / magnitude
        self.z = self.z / magnitude
    else
        self.x = 0
        self.z = 0
    end

    return self
end


function Dot2.Dot(lhs, rhs)
    return lhs.x * rhs.x + lhs.z * rhs.z
end

function Dot2.Angle(from, to)
    local x1,y1 = from.x, from.z
    local d = sqrt(x1 * x1 + y1 * y1)

    if d > 1e-5 then
        x1 = x1/d
        y1 = y1/d
    else
        x1,y1 = 0,0
    end

    local x2,y2 = to.x, to.z
    d = sqrt(x2 * x2 + y2 * y2)

    if d > 1e-5 then
        x2 = x2/d
        y2 = y2/d
    else
        x2,y2 = 0,0
    end

    d = x1 * x2 + y1 * y2

    if d < -1 then
        d = -1
    elseif d > 1 then
        d = 1
    end

    return acos(d) * 57.29578
end

function Dot2.Magnitude(v)
    return sqrt(v.x * v.x + v.z * v.z)
end

function Dot2.Reflect(dir, normal)
    local dx = dir.x
    local dy = dir.z
    local nx = normal.x
    local ny = normal.z
    local s = -2 * (dx * nx + dy * ny)

    return setmetatable({x = s * nx + dx, z = s * ny + dy}, Dot2)
end

function Dot2.Distance(a, b)
    return sqrt((a.x - b.x) ^ 2 + (a.z - b.z) ^ 2)
end

function Dot2.DistanceXZ(a, b)
    return a.x - b.x,a.z - b.z
end

function Dot2.DistanceXZAbs(a, b)
    return Mathf.Abs(a.x - b.x),Mathf.Abs(a.z - b.z)
end

function Dot2.MaxDistance(a,b)
    local x = Mathf.Abs(a.x - b.x)
    local z = Mathf.Abs(a.z - b.z)
    return Mathf.Max(x,z)
end

function Dot2.DistancePow2(a, b)
    return(a.x - b.x) ^ 2 + (a.z - b.z)^2
end

function Dot2.Lerp(a, b, t)
    if t < 0 then
        t = 0
    elseif t > 1 then
        t = 1
    end

    return setmetatable({x = a.x + (b.x - a.x) * t, z = a.z + (b.z - a.z) * t}, Dot2)
end

function Dot2.LerpUnclamped(a, b, t)
    return setmetatable({x = a.x + (b.x - a.x) * t, z = a.z + (b.z - a.z) * t}, Dot2)
end

function Dot2.MoveTowards(current, target, maxDistanceDelta)
    local cx = current.x
    local cy = current.z
    local x = target.x - cx
    local z = target.z - cy
    local s = x * x + z * z

    if s  > maxDistanceDelta * maxDistanceDelta and s ~= 0 then
        s = maxDistanceDelta / sqrt(s)
        return setmetatable({x = cx + x * s, z = cy + z * s}, Dot2)
    end

    return setmetatable({x = target.x, z = target.z}, Dot2)
end

function Dot2.ClampMagnitude(v, maxLength)
    local x = v.x
    local z = v.z
    local sqrMag = x * x + z * z

    if sqrMag > maxLength * maxLength then
        local mag = maxLength / sqrt(sqrMag)
        x = x * mag
        z = z * mag
        return setmetatable({x = x, z = z}, Dot2)
    end

    return setmetatable({x = x, z = z}, Dot2)
end

function Dot2.SmoothDamp(current, target, Velocity, smoothTime, maxSpeed, deltaTime)
    deltaTime = deltaTime or Time.deltaTime
    maxSpeed = maxSpeed or math.huge
    smoothTime = math.max(0.0001, smoothTime)

    local num = 2 / smoothTime
    local num2 = num * deltaTime
    num2 = 1 / (1 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2)

    local tx = target.x
    local ty = target.z
    local cx = current.x
    local cy = current.z
    local vecx = cx - tx
    local vecy = cy - ty
    local m = vecx * vecx + vecy * vecy
    local n = maxSpeed * smoothTime

    if m > n * n then
        m = n / sqrt(m)
        vecx = vecx * m
        vecy = vecy * m
    end

    m = Velocity.x
    n = Velocity.z

    local vec3x = (m + num * vecx) * deltaTime
    local vec3y = (n + num * vecy) * deltaTime
    Velocity.x = (m - num * vec3x) * num2
    Velocity.z = (n - num * vec3y) * num2
    m = cx - vecx + (vecx + vec3x) * num2
    n = cy - vecy + (vecy + vec3y) * num2

    if (tx - cx) * (m - tx) + (ty - cy) * (n - ty)  > 0 then
        m = tx
        n = ty
        Velocity.x = 0
        Velocity.z = 0
    end

    return setmetatable({x = m, z = n}, Dot2), Velocity
end

function Dot2.Max(a, b)
    return setmetatable({x = math.max(a.x, b.x), z = math.max(a.z, b.z)}, Dot2)
end

function Dot2.Min(a, b)
    return setmetatable({x = math.min(a.x, b.x), z = math.min(a.z, b.z)}, Dot2)
end

function Dot2.Scale(a, b)
    return setmetatable({x = a.x * b.x, z = a.z * b.z}, Dot2)
end

function Dot2:Div(d)
    self.x = self.x / d
    self.z = self.z / d

    return self
end

function Dot2:Mul(d)
    self.x = self.x * d
    self.z = self.z * d

    return self
end

function Dot2:Add(b)
    self.x = self.x + b.x
    self.z = self.z + b.z

    return self
end

function Dot2:Sub(b)
    self.x = self.x - b.x
    self.z = self.z - b.z

    return
end

function Dot2:AbsNoAlloc()
    self.x = Mathf.Abs(self.x)
    self.z = Mathf.Abs(self.z)
end


function Dot2:CopyFromSub(a, b)
    self.x = a.x - b.x
    self.z = a.z - b.z

    return
end

function Dot2:Copy(b)
    self.x =  b.x
    self.z =  b.z
end

function Dot2:Equals(other)
    return self.x == other.x and self.z == other.z
end

function Dot2:EqualsXZ(x,z)
    return self.x == x and self.z == z
end

function Dot2.IsZero(vec)
    return vec.x ==0  and vec.z == 0
end

Dot2.__tostring = function(self)
    return string.format("(%f,%f)", self.x, self.z)
end

Dot2.__div = function(va, d)
    return setmetatable({x = va.x / d, z = va.z / d}, Dot2)
end

Dot2.__mul = function(a, d)
    if type(d) == "number" then
        return setmetatable({x = a.x * d, z = a.z * d}, Dot2)
    else
        return setmetatable({x = a * d.x, z = a * d.z}, Dot2)
    end
end

Dot2.__add = function(a, b)
    return setmetatable({x = a.x + b.x, z = a.z + b.z}, Dot2)
end

Dot2.__sub = function(a, b)
    return setmetatable({x = a.x - b.x, z = a.z - b.z}, Dot2)
end

Dot2.__unm = function(v)
    return setmetatable({x = -v.x, z = -v.z}, Dot2)
end

Dot2.__eq = function(a,b)
    if not a.x or not b.x then
        return false
    end
    return a.x == b.x and a.z == b.z
end

_getter.up 		= function() return setmetatable({x = 0, z = 1}, Dot2) end
_getter.right	= function() return setmetatable({x = 1, z = 0}, Dot2) end
_getter.zero	= function() return setmetatable({x = 0, z = 0}, Dot2) end
_getter.one		= function() return setmetatable({x = 1, z = 1}, Dot2) end

_getter.magnitude 		= Dot2.Magnitude
_getter.normalized 		= Dot2.Normalize
_getter.sign 		= Dot2.Sign
_getter.sqrMagnitude 	= Dot2.SqrMagnitude
_getter.abs 	= Dot2.Abs

---@param vec Vector4
function Dot2:IsSelfMetatable(vec)
    return self.x == nil
end

setmetatable(Dot2, Dot2)

Dot2.upNonAlloc 		= Dot2(0,1)
Dot2.rightNonAlloc	=Dot2(1,0)
Dot2.zeroNonAlloc	= Dot2(0,0)
Dot2.oneNonAlloc		= Dot2(1,1)
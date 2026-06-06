--------------------------------------------------------------------------------
--      Copyright (c) 2015 , 蒙占志(topameng) topameng@gmail.com
--      All rights reserved.
--      Use, modification and distribution are subject to the "MIT License"
--------------------------------------------------------------------------------
-- added by wsh @ 2017-12-28
-- 注意：
-- 1、已经被修改，别从tolua轻易替换来做升级

local math  = math
local acos	= math.acos
local sqrt 	= math.sqrt
local max 	= math.max
local min 	= math.min
local clamp = Mathf.Clamp
local cos	= math.cos
local sin	= math.sin
local abs	= math.abs
local sign	= Mathf.Sign
local setmetatable = setmetatable
local rawset = rawset
local rawget = rawget
local type = type

local rad2Deg = 57.295779513082
local deg2Rad = 0.017453292519943

---@class Vector3
---@field zero Vector3
---@field one Vector3
Vector3 = {}
local this = Vector3
local _getter = {}
local unity_vector3 = CS.UnityEngine.Vector3
Vector3.isValueType = true
Vector3.__index = function(t,k)
	local var = rawget(Vector3, k)
	if var ~= nil then
		return var
	end
	
	var = rawget(_getter, k)
	if var ~= nil then
		return var(t)
	end
	
	return rawget(unity_vector3, k)
end

function Vector3.New(x, y, z)				
	local t = {x = x or 0, y = y or 0, z = z or 0}
	setmetatable(t, Vector3)						
	return t
end

local _new = Vector3.New

Vector3.__call = function(t,x,y,z)
	local t = {x = x or 0, y = y or 0, z = z or 0}
	setmetatable(t, Vector3)					
	return t
end
	
function Vector3:Set(x,y,z)	
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end
---@param u_v3 UnityEngine.Vector3
function Vector3:SetUV3(u_v3)
	self.x = u_v3.x
	self.y = u_v3.y
	self.z = u_v3.z
end

function Vector3.Get(v)		
	return v.x, v.y, v.z	
end

---@return Vector3
function Vector3:Clone()
	return setmetatable({x = self.x, y = self.y, z = self.z}, Vector3)
end

function Vector3.Distance(va, vb)
	return sqrt((va.x - vb.x)^2 + (va.y - vb.y)^2 + (va.z - vb.z)^2)
end

function Vector3.DistancePow2(va, vb)
	return (va.x - vb.x)^2 + (va.y - vb.y)^2 + (va.z - vb.z)^2
end

function Vector3.Dot(lhs, rhs)
	return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
end

function Vector3.Lerp(from, to, t)	
	t = clamp(t, 0, 1)
	return _new(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t)
end

function Vector3:Magnitude()
	return sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector3.Max(lhs, rhs)
	return _new(max(lhs.x, rhs.x), max(lhs.y, rhs.y), max(lhs.z, rhs.z))
end

function Vector3.Min(lhs, rhs)
	return _new(min(lhs.x, rhs.x), min(lhs.y, rhs.y), min(lhs.z, rhs.z))
end

function Vector3.Normalize(v)
	local x,y,z = v.x, v.y, v.z		
	local num = sqrt(x * x + y * y + z * z)	
	
	if num > 1e-5 then		
		return setmetatable({x = x / num, y = y / num, z = z / num}, Vector3)
    end
	  
	return setmetatable({x = 0, y = 0, z = 0}, Vector3)
end

function Vector3:SetNormalize()
	local num = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
	
	if num > 1e-5 then    
        self.x = self.x / num
		self.y = self.y / num
		self.z = self.z /num
    else    
		self.x = 0
		self.y = 0
		self.z = 0
	end 

	return self
end

function Vector3:GetNormalizeXYZ()
	local num = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)

	if num > 1e-5 then
		return self.x/num,self.y/num,self.z/num
	else
		return 0,0,0
	end
end
	
function Vector3:SqrMagnitude()
	return self.x * self.x + self.y * self.y + self.z * self.z
end

local dot = Vector3.Dot

function Vector3.Angle(from, to)
	return acos(clamp(dot(from:Normalize(), to:Normalize()), -1, 1)) * rad2Deg
end
function Vector3.AngleNonAlloc(v1, v2)
	local dx = v1.x - v2.x
	local dz = v1.z - v2.z
	if dx * dx + dz * dz < Mathf.Epsilon then
		return 0
	end
	local dir = 90 - math.deg(Mathf.Atan2(dz, dx))
	return dir
end

function Vector3.Copy(from,to)
	to.x = from.x
	to.y = from.y
	to.z = from.z
end

function Vector3:ClampMagnitude(maxLength)	
	if self:SqrMagnitude() > (maxLength * maxLength) then    
		self:SetNormalize()
		self:Mul(maxLength)        
    end
	
    return self
end


function Vector3.OrthoNormalize(va, vb, vc)	
	va:SetNormalize()
	vb:Sub(vb:Project(va))
	vb:SetNormalize()
	
	if vc == nil then
		return va, vb
	end
	
	vc:Sub(vc:Project(va))
	vc:Sub(vc:Project(vb))
	vc:SetNormalize()		
	return va, vb, vc
end

	
function Vector3.MoveTowards(current, target, maxDistanceDelta)	
	local delta = target - current	
    local sqrDelta = delta:SqrMagnitude()
	local sqrDistance = maxDistanceDelta * maxDistanceDelta
	
    if sqrDelta > sqrDistance then    
		local magnitude = sqrt(sqrDelta)
		
		if magnitude > 1e-6 then
			delta:Mul(maxDistanceDelta / magnitude)
			delta:Add(current)
			return delta
		else
			return current:Clone()
		end
    end
	
    return target:Clone()
end

function Vector3.MoveTowardsNonAlloc(current, target, maxDistanceDelta, pos)
	local sqrDelta = Vector3.DistancePow2(current, target)
	local sqrDistance = maxDistanceDelta * maxDistanceDelta

	if sqrDelta > sqrDistance then
		local magnitude = sqrt(sqrDelta)
		local t = maxDistanceDelta / magnitude
		pos.x = current.x + (target.x - current.x) * t
		pos.y = current.y + (target.y - current.y) * t
		pos.z = current.z + (target.z - current.z) * t
	else
		Vector3.Copy(target,pos)
	end
end

function ClampedMove(lhs, rhs, clampedDelta)
	local delta = rhs - lhs
	
	if delta > 0 then
		return lhs + min(delta, clampedDelta)
	else
		return lhs - min(-delta, clampedDelta)
	end
end

local overSqrt2 = 0.7071067811865475244008443621048490

local function OrthoNormalVector(vec)
	local res = _new()
	
	if abs(vec.z) > overSqrt2 then			
		local a = vec.y * vec.y + vec.z * vec.z
		local k = 1 / sqrt (a)
		res.x = 0
		res.y = -vec.z * k
		res.z = vec.y * k
	else			
		local a = vec.x * vec.x + vec.y * vec.y
		local k = 1 / sqrt (a)
		res.x = -vec.y * k
		res.y = vec.x * k
		res.z = 0
	end
	
	return res
end

function Vector3.RotateTowards(current, target, maxRadiansDelta, maxMagnitudeDelta)
	local len1 = current:Magnitude()
	local len2 = target:Magnitude()
	
	if len1 > 1e-6 and len2 > 1e-6 then	
		local from = current / len1
		local to = target / len2		
		local cosom = dot(from, to)
				
		if cosom > 1 - 1e-6 then		
			return Vector3.MoveTowards (current, target, maxMagnitudeDelta)		
		elseif cosom < -1 + 1e-6 then		
			local axis = OrthoNormalVector(from)						
			local q = Quaternion.AngleAxis(maxRadiansDelta * rad2Deg, axis)	
			local rotated = q:MulVec3(from)
			local delta = ClampedMove(len1, len2, maxMagnitudeDelta)
			rotated:Mul(delta)
			return rotated
		else		
			local angle = acos(cosom)
			local axis = Vector3.Cross(from, to)
			axis:SetNormalize ()
			local q = Quaternion.AngleAxis(min(maxRadiansDelta, angle) * rad2Deg, axis)			
			local rotated = q:MulVec3(from)
			local delta = ClampedMove(len1, len2, maxMagnitudeDelta)
			rotated:Mul(delta)
			return rotated
		end
	end
		
	return Vector3.MoveTowards(current, target, maxMagnitudeDelta)
end

---@return Vector3
---@param position Vector3
---@param center Vector3
---@param axis Vector3
function Vector3.RotateRound(position, center, axis, angle)
	return Quaternion.AngleAxis(angle, axis) * (position - center) + center;
end

function Vector3:RotateRoundNonAlloc(position, center, axis, angle)
	self:CopyFromSub(position,center)
	return self:CopyFromAdd(Quaternion.AngleAxis(angle, axis) * self, center);
end
	
function Vector3.SmoothDamp(current, target, currentVelocity, smoothTime)
	local maxSpeed = Mathf.Infinity
	local deltaTime = Time.deltaTime
    smoothTime = max(0.0001, smoothTime)
    local num = 2 / smoothTime
    local num2 = num * deltaTime
    local num3 = 1 / (1 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2)    
    local vector2 = target:Clone()
    local maxLength = maxSpeed * smoothTime
	local vector = current - target
    vector:ClampMagnitude(maxLength)
    target = current - vector
    local vec3 = (currentVelocity + (vector * num)) * deltaTime
    currentVelocity = (currentVelocity - (vec3 * num)) * num3
    local vector4 = target + (vector + vec3) * num3	
	
    if Vector3.Dot(vector2 - current, vector4 - vector2) > 0 then    
        vector4 = vector2
        currentVelocity:Set(0,0,0)
    end
	
    return vector4, currentVelocity
end	
	
function Vector3.Scale(a, b)
	local x = a.x * b.x
	local y = a.y * b.y
	local z = a.z * b.z	
	return _new(x, y, z)
end
	
function Vector3.Cross(lhs, rhs)
	local x = lhs.y * rhs.z - lhs.z * rhs.y
	local y = lhs.z * rhs.x - lhs.x * rhs.z
	local z = lhs.x * rhs.y - lhs.y * rhs.x
	return _new(x,y,z)	
end

---@param target Vector3
function Vector3:CrossNonAlloc(lhs, rhs)
	local x = lhs.y * rhs.z - lhs.z * rhs.y
	local y = lhs.z * rhs.x - lhs.x * rhs.z
	local z = lhs.x * rhs.y - lhs.y * rhs.x
	self:Set(x,y,z)
end
	
function Vector3:Equals(other)
	return self.x == other.x and self.y == other.y and self.z == other.z
end
		
function Vector3.Reflect(inDirection, inNormal)
	local num = -2 * dot(inNormal, inDirection)
	inNormal = inNormal * num
	inNormal:Add(inDirection)
	return inNormal
end

	
function Vector3.Project(vector, onNormal)
	local num = onNormal:SqrMagnitude()
	
	if num < 1.175494e-38 then	
		return _new(0,0,0)
	end
	
	local num2 = dot(vector, onNormal)
	local v3 = onNormal:Clone()
	v3:Mul(num2/num)	
	return v3
end
	
function Vector3.ProjectOnPlane(vector, planeNormal)
	local v3 = Vector3.Project(vector, planeNormal)
	v3:Mul(-1)
	v3:Add(vector)
	return v3
end		

function Vector3.Slerp(from, to, t)
	local omega, sinom, scale0, scale1

	if t <= 0 then		
		return from:Clone()
	elseif t >= 1 then		
		return to:Clone()
	end
	
	local v2 	= to:Clone()
	local v1 	= from:Clone()
	local len2 	= to:Magnitude()
	local len1 	= from:Magnitude()	
	v2:Div(len2)
	v1:Div(len1)

	local len 	= (len2 - len1) * t + len1
	local cosom = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
	
	if cosom > 1 - 1e-6 then
		scale0 = 1 - t
		scale1 = t
	elseif cosom < -1 + 1e-6 then		
		local axis = OrthoNormalVector(from)		
		local q = Quaternion.AngleAxis(180.0 * t, axis)		
		local v = q:MulVec3(from)
		v:Mul(len)				
		return v
	else
		omega 	= acos(cosom)
		sinom 	= sin(omega)
		scale0 	= sin((1 - t) * omega) / sinom
		scale1 	= sin(t * omega) / sinom	
	end

	v1:Mul(scale0)
	v2:Mul(scale1)
	v2:Add(v1)
	v2:Mul(len)
	return v2
end


function Vector3:Mul(q)
	if type(q) == "number" then
		self.x = self.x * q
		self.y = self.y * q
		self.z = self.z * q
	else
		self:MulQuat(q)
	end
	
	return self
end

function Vector3:Div(d)
	self.x = self.x / d
	self.y = self.y / d
	self.z = self.z / d
	
	return self
end

function Vector3:Add(vb)
	self.x = self.x + vb.x
	self.y = self.y + vb.y
	self.z = self.z + vb.z
	
	return self
end

function Vector3:AddXYZ(x,y,z)
	self.x = self.x + x
	self.y = self.y + y
	self.z = self.z + z

	return self
end

function Vector3:Sub(vb)
	self.x = self.x - vb.x
	self.y = self.y - vb.y
	self.z = self.z - vb.z
	
	return self
end

function Vector3.NewFrom(t)
	local x = t and t.x or 0
	local y = t and t.y or 0
	local z = t and t.z or 0
	local vec = {x = x or 0, y = y or 0, z = z or 0}
	setmetatable(vec, Vector3)
	return vec
end

function Vector3.AngleBetween(v1, v2)
	local dx = v1.x - v2.x
	local dz = v1.z - v2.z
	if dx * dx + dz * dz < Mathf.Epsilon then
		return 0
	end

	local dir = 90 - math.deg(Mathf.Atan2(dz, dx))
	return dir
end

function Vector3.LerpWithFrom(from, to, t)
	t = clamp(t, 0, 1)
	from.x = from.x + (to.x - from.x) * t
	from.y = from.y + (to.y - from.y) * t
	from.z = from.z + (to.z - from.z) * t
	return from
end

function Vector3:MulQuat(quat)	   
	local num 	= quat.x * 2
	local num2 	= quat.y * 2
	local num3 	= quat.z * 2
	local num4 	= quat.x * num
	local num5 	= quat.y * num2
	local num6 	= quat.z * num3
	local num7 	= quat.x * num2
	local num8 	= quat.x * num3
	local num9 	= quat.y * num3
	local num10 = quat.w * num
	local num11 = quat.w * num2
	local num12 = quat.w * num3
	
	local x = (((1 - (num5 + num6)) * self.x) + ((num7 - num12) * self.y)) + ((num8 + num11) * self.z)
	local y = (((num7 + num12) * self.x) + ((1 - (num4 + num6)) * self.y)) + ((num9 - num10) * self.z)
	local z = (((num8 - num11) * self.x) + ((num9 + num10) * self.y)) + ((1 - (num4 + num5)) * self.z)
	
	self:Set(x, y, z)	
	return self
end

function Vector3.AngleAroundAxis (from, to, axis)	 	 
	from = from - Vector3.Project(from, axis)
	to = to - Vector3.Project(to, axis) 	    
	local angle = Vector3.Angle (from, to)	   	    
	return angle * (Vector3.Dot (axis, Vector3.Cross (from, to)) < 0 and -1 or 1)
end

function Vector3.DistancePow2(va, vb)
	return (va.x - vb.x)^2 + (va.y - vb.y)^2 + (va.z - vb.z)^2
end
function Vector3:CopyFrom(target)
	if target and self ~= target then
		self:Set(target.x,target.y,target.z)
	end
end

function Vector3:CopyFromAdd(va, vb)
	self.x = va.x + vb.x
	self.y = va.y + vb.y
	self.z = va.z + vb.z
	return self
end

function Vector3:CopyFromSub(va, vb)
	self.x = va.x - vb.x
	self.y = va.y - vb.y
	self.z = va.z - vb.z
	return self
end

---@param forward Vector3
---@param right Vector3
---@param v Vector3
function Vector3.MoveLocalAxisXZ(forward,right,v)
	local fN = Vector3.Normalize(forward)
	local rN = Vector3.Normalize(right)
	local vec = fN*v.z+rN*v.x
	return vec
end

---@param forward Vector3
---@param right Vector3
---@param v Vector3
function Vector3:MoveLocalAxisXZNonAlloc(forward,right,v)
	local fN_x,fN_y,fN_z = forward:GetNormalizeXYZ()
	local rN_x,rN_y,rN_z = right:GetNormalizeXYZ()
	self:Set(fN_x*v.z+rN_x*v.x,fN_y*v.z+rN_y*v.x,fN_z*v.z+rN_z*v.x)
end


function Vector3.MoveTowardsNonAlloc(current, target, maxDistanceDelta, pos)
	local sqrDelta = Vector3.DistancePow2(current, target)
	local sqrDistance = maxDistanceDelta * maxDistanceDelta

	if sqrDelta > sqrDistance then
		local magnitude = sqrt(sqrDelta)
		local t = maxDistanceDelta / magnitude
		pos.x = current.x + (target.x - current.x) * t
		pos.y = current.y + (target.y - current.y) * t
		pos.z = current.z + (target.z - current.z) * t
	else
		pos:CopyFrom(target)
	end
end 


Vector3.__tostring = function(self)
	return "["..self.x..","..self.y..","..self.z.."]"
end

Vector3.__div = function(va, d)
	return _new(va.x / d, va.y / d, va.z / d)
end

Vector3.__mul = function(va, d)
	if type(d) == "number" then
		return _new(va.x * d, va.y * d, va.z * d)
	else
		local vec = va:Clone()
		vec:MulQuat(d)
		return vec
	end	
end

Vector3.__add = function(va, vb)
	return _new(va.x + vb.x, va.y + vb.y, va.z + vb.z)
end

Vector3.__sub = function(va, vb)
	return _new(va.x - vb.x, va.y - vb.y, va.z - vb.z)
end

Vector3.__unm = function(va)
	return _new(-va.x, -va.y, -va.z)
end

Vector3.__eq = function(a,b)
	if not a.x or not b.x then
		return false
	end
	if not this.eqTemp then
		this.eqTemp = Vector3.zero
	end
	this.eqTemp.x = a.x - b.x
	this.eqTemp.y = a.y - b.y
	this.eqTemp.z = a.z - b.z
	local delta = this.eqTemp:SqrMagnitude()
	return delta < 1e-10
end

---@param vec Vector3
function Vector3.IsZero(vec)
	return vec.x ==0 and vec.y == 0 and vec.z == 0
end

---@param vec Vector4
function Vector3:IsSelfMetatable(vec)
	return self.x == nil
end

_getter.up 		= function() return _new(0,1,0) end
_getter.down 	= function() return _new(0,-1,0) end
_getter.right	= function() return _new(1,0,0) end
_getter.left	= function() return _new(-1,0,0) end
_getter.forward = function() return _new(0,0,1) end
_getter.back	= function() return _new(0,0,-1) end
_getter.zero	= function() return _new(0,0,0) end
_getter.one		= function() return _new(1,1,1) end

_getter.magnitude	= Vector3.Magnitude
_getter.normalized	= Vector3.Normalize
_getter.sqrMagnitude= Vector3.SqrMagnitude
---@type UnityEngine.Vector3
Vector3.unity_vector3 = CS.UnityEngine.Vector3
CS.UnityEngine.Vector3 = Vector3
setmetatable(Vector3, Vector3)
Vector3.upNonAlloc 		= Vector3(0,1,0)
Vector3.downNonAlloc 	= Vector3(0,-1,0)
Vector3.rightNonAlloc	= Vector3(1,0,0)
Vector3.leftNonAlloc	= Vector3(-1,0,0)
Vector3.forwardNonAlloc = Vector3(0,0,1)
Vector3.backNonAlloc	= Vector3(0,0,-1)
Vector3.zeroNonAlloc	= Vector3(0,0,0)
Vector3.oneNonAlloc		= Vector3(1,1,1)

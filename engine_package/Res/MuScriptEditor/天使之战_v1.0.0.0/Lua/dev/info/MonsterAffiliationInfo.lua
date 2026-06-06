---@class MonsterAffiliationInfo
MonsterAffiliationInfo = class()
local this = MonsterAffiliationInfo

function this:ctor()
end

function this:Reset()
    self.affiliationInfo = {}
    self.removeList = {}
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.affiliationInfo = {}
    self.removeList = {}
    self.tempData = {rid= 0,ownerRid = 0}
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MONSTER_FIRST_ATTACK_OWNER_CHANGE,self.RES_MONSTER_FIRST_ATTACK_OWNER_CHANGE,self)
    SL:RegisterLUAEvent(LUA_EVENT_ENTER_MAP,self.LUA_EVENT_ENTER_MAP,self)
end

function this:LUA_EVENT_ENTER_MAP(_,msgData)
    self:Reset()
end

-- function this:RES_MONSTER_FIRST_ATTACK_OWNER_CHANGE(id,message)
--     SL:LogTable(message,true)
--     if not self.affiliationInfo[message.target.id] then
--         self.affiliationInfo[message.target.id] = {ownerRid = message.owner,endTime= message.endTime,maxHurt=message.maxHurt}
--     else
--         self.affiliationInfo[message.target.id].ownerRid = message.owner
--         self.affiliationInfo[message.target.id].endTime = message.endTime
--         self.affiliationInfo[message.target.id].maxHurt = message.maxHurt
--     end
--     self.tempData.rid = message.target.id
--     self.tempData.ownerRid = message.owner
--     self.tempData.maxHurt = message.maxHurt
--     SL:onLUAEvent(LUA_EVENT_MONSTER_AFFILIATION_CHANGE,self.tempData)
    
--     if not self.timer then
--         self.timer = SL:Schedule(self.timer,0,1,-1,function()
--             for rid, v in pairs(self.affiliationInfo) do
--                 local isDie = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_DIE,rid)
--                 if (v.ownerRid and v.ownerRid ~= 0 and v.endTime*1000 < Time.GetServerTime()) or isDie then
--                     table.insert(self.removeList,rid)
--                     self.tempData.rid = rid
--                     self.tempData.ownerRid = 0
--                     self.tempData.maxHurt = 0
--                     SL:onLUAEvent(LUA_EVENT_MONSTER_AFFILIATION_CHANGE,self.tempData)
--                 end
--             end
--             for i, rid in pairs(self.removeList) do
--                 self.affiliationInfo[rid] = nil
--             end
--             table.clear(self.removeList)
--             if table.count(self.affiliationInfo) <= 0 then
--                 if self.timer then
--                     SL:UnSchedule(self.timer)
--                     self.timer = nil
--                 end
--             end
--         end)
--     end
-- end

-- ---通过id获取怪物的归属
-- function this:GetMonsterAffiliationByRid(rid)
--     if self.affiliationInfo[rid] then
--         return self.affiliationInfo[rid].ownerRid
--     end
--     return 0
-- end

-- ---通过id获取怪物的最大仇恨或最高伤害
-- function this:GetMonsterMaxHurtByRid(rid)
--     if self.affiliationInfo[rid] then
--         return self.affiliationInfo[rid].maxHurt
--     end
--     return 0
-- end


function this:RES_MONSTER_FIRST_ATTACK_OWNER_CHANGE(id,message)
    -- SL:LogTable(message,true)
    message.monsterId = tonumber(message.monsterId)
    if message.rid then
        message.rid = tonumber(message.rid)
    end
    self.affiliationInfo[message.monsterId] = message
    SL:onLUAEvent(LUA_EVENT_MONSTER_AFFILIATION_CHANGE,message)
    
end
local zero = 0
---通过id获取怪物的归属
function this:GetMonsterAffiliationType(rid)
    -- SL:LogTable(self.affiliationInfo,true)
     if self.affiliationInfo[rid] then
        return self.affiliationInfo[rid].ownerType
    end
    return zero
end


---通过id获取怪物的最大仇恨或最高伤害
function this:GetMonsterAffiliationByRid(rid)
    if self.affiliationInfo[rid] then
        return self.affiliationInfo[rid].rid 
    end
    return zero
end

function this:GetMonsterAffiliationNameByRid(rid)
    if self.affiliationInfo[rid] then
        return self.affiliationInfo[rid].name 
    end
    return
end


---@class ChallengeBossInfo @注释
---@field count_data table @怪物数量

ChallengeBossInfo = class()
local this = ChallengeBossInfo

function this:ctor()
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.count_data = {}
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.MONSTER_COUNT_RESULT_BY_ID, self.MONSTER_COUNT_RESULT_BY_ID, self)
end

---怪物数量
function this:MONSTER_COUNT_RESULT_BY_ID(id, message)
    self.count_data = message
    SL:onLUAEvent(LUA_EVENT_MONSTER_COUNT_CHANGE)
end

function this:Reset()

end

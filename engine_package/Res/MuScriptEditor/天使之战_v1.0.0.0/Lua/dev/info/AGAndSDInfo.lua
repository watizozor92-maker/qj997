---@class AGAndSDInfo
AGAndSDInfo = class()
local this = AGAndSDInfo

function this:ctor()

end

function this:Reset()
    self.otherRoleSdCurData = {}
    self.otherRoleSdMaxData = {}
end

function this:Init()
    self:Reset()
    self:RegistMessages()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.AGAndSD_MsgID,self.MsgExchange,self) 
end


--data [1]类型 0数据通知 l商店配置请求 2购买请求
function this:MsgExchange(_,msg_data)
    local _data = GUIUtil.tblkeytonumber(msg_data)
    if _data == nil or _data[1] == nil then
        return
    end
    local rid = tonumber(SL:GetMetaValue(EMetaVarGetKey.USER_ID))
    local playerId = tonumber(_data[1])
    if rid ~= playerId then
        local otherRid = playerId
        if _data[2] == 0 then
            self.otherRoleSdCurData[otherRid] = math.floor(_data[3]); --当前sd
            self.otherRoleSdMaxData[otherRid] = math.floor(_data[4]); --最大sd
            SL:onLUAEvent(LUA_EVENT_OTHER_ROLE_SD_SHIELD_CHANGE, otherRid)
        elseif _data[2]== 1 then
            self.otherRoleSdCurData[otherRid] = math.floor(_data[3]); --当前sd
            SL:onLUAEvent(LUA_EVENT_OTHER_ROLE_SD_SHIELD_CHANGE, otherRid)
        end
        return
    end
    -- SL:LogTable(_data,true)
    if _data[2]== 0 then
        Global.CurSD = math.floor(_data[3]); --当前sd
        Global.MaxSD =  math.floor(_data[4]); --最大sd
        Global.CurAG =  math.floor(_data[5]); --当前AG
        Global.MaxAG =  math.floor(_data[6]); --最大AG
        SL:onLUAEvent(LUA_EVENT_SHIELDCHANGE)
        SL:onLUAEvent(LUA_EVENT_AGSTOCHANGE)
    elseif _data[2]== 1 then
        Global.CurSD =  math.floor(_data[3]); --当前sd
        SL:onLUAEvent(LUA_EVENT_SHIELDCHANGE)
    elseif _data[2]== 2 then
        Global.CurAG =  math.floor(_data[3]); --当前AG
        SL:onLUAEvent(LUA_EVENT_AGSTOCHANGE)
    end   
end

---获取其他玩家的sd数据
function this:GetOtherPlayerSdData(rid)
    return self.otherRoleSdCurData[rid], self.otherRoleSdMaxData[rid]
end
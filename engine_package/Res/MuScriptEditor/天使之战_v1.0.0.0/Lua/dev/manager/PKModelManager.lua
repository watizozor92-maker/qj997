
---@class PKModelManager
PKModelManager = {}
local this = PKModelManager

function this.Init()
    this.RegistEvents()
   
end

function this.RegistEvents()
    SL:RegisterTrigger(LUA_TRIGGER_CHECK_PKMODE_RELATION, this.LUA_TRIGGER_CHECK_PKMODE_RELATION)
    SL:RegisterTrigger(LUA_TRIGGER_CHECK_PKMODE_IS_ATTACK, this.LUA_TRIGGER_CHECK_PKMODE_IS_ATTACK)
end


function this.UnRegistEvents()
    SL:UnRegisterTrigger(LUA_TRIGGER_CHECK_PKMODE_RELATION,this.LUA_TRIGGER_CHECK_PKMODE_RELATION)
    SL:UnRegisterTrigger(LUA_TRIGGER_CHECK_PKMODE_IS_ATTACK,this.LUA_TRIGGER_CHECK_PKMODE_IS_ATTACK)
end

function this.Reset()
    this.UnRegistEvents()
end

--判断当前模式玩家之间的关系
function this.LUA_TRIGGER_CHECK_PKMODE_RELATION(_,pk_mode,player1,player2)
    --昆顿阵营模式
    if pk_mode == EPKMode_Out.Camp_out then
        return InfoManager.kundunInfo:CheckPlayerRelation(pk_mode,player1,player2)
    end
end

--判断当前模式玩家是否不能攻击
function this.LUA_TRIGGER_CHECK_PKMODE_IS_ATTACK(_,message)
    local pkMode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
    --昆顿阵营模式
    if pkMode == EPKMode_Out.Camp_out then
        return InfoManager.kundunInfo:CheckPlayerAttack(message)
    end
end


return this
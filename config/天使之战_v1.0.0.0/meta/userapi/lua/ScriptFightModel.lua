ScriptFightModel = {}
local this = {}

ScriptFightModel.FlagId = {
    KunDun = "1000"
}

local FightModelSettingId = 1
local OutScriptFightModelValue = 13

-- 设置攻击模式为外置攻击模式
function ScriptFightModel.setScriptFightModel(actor)
    setplayersetting(actor, FightModelSettingId, OutScriptFightModelValue)
end

-- 设置攻击模式阵营标识以及友军阵营
function ScriptFightModel.setPlayerFightModelValue(actor, flagId, atkFlag, friendTable)
    local flag, friendFlag = this.buildFlagAndFriendFlag(flagId, atkFlag, friendTable)
    setplayeroutfightmodelvalue(actor, flag, friendFlag)
end


-- 拼接副本标识
function this.buildFlagAndFriendFlag(flagId, atkFlag, friendTable)
    local flag = flagId .. atkFlag
    local arrTable = {}
    for _, v in ipairs(friendTable) do
        table.insert(arrTable, flagId .. v)
    end
    return flag, arrTable
end

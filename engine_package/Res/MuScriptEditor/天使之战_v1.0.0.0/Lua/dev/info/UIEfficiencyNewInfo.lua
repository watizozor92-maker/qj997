---@class UIEfficiencyNewInfo
UIEfficiencyNewInfo = class()
local this = UIEfficiencyNewInfo

function this:ctor()

end

function this:Reset()
    self:ResetData()
end

function this:Init()
    self:ResetData()
    self:InitData()
    self:RegistMessages()
end

---刷新初始数据
function this:ResetData()
    ---效率红点信息
    self.EfficiencyRedDotInfoList = {}
    ---效率条件激活信息
    self.EfficiencyTabActiveList = {}
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EFFECIENCY_TAB_ACTIVE,self.RES_EFFECIENCY_TAB_ACTIVE,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EFFECIENCY_RED_DOT,self.RES_EFFECIENCY_RED_DOT,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EFFECIENCY_REWARD_RESULT,self.RES_EFFECIENCY_REWARD_RESULT,self)
end

---响应效率奖励领取结果
function this:RES_EFFECIENCY_REWARD_RESULT(id,message)
    if not message then
        return
    end
    local list = {}
    table.insert(list,{cfgId = message.itemId,count = message.count})
    SL:OpenRewardTipsByItemList(list,0)
end

---响应效率条件激活
function this:RES_EFFECIENCY_TAB_ACTIVE(id,message)
    if not message then
        return
    end
    local list = {}
    for i, v in pairs(message) do
        if SL:HasConfig("cfg_efficiency",v) then
            table.insert(list,v)
        end
    end
    self.EfficiencyTabActiveList = list
    SL:onLUAEvent(LUA_EFFICIENCY_TAB_ACTIVE_CHANGE)
end

---响应效率页面红点信息
function this:RES_EFFECIENCY_RED_DOT(id,message)
    if not message then
        return
    end
    self.EfficiencyRedDotInfoList = message
    SL:onLUAEvent(LUA_EFFICIENCY_RED_DOT_CHANGE)

    SL:RefreshPanelALLRedPoint("KLUISystemTopPanel")
end

---获取激活信息
function this:GetEfficiencyTabActiveInfo()
    if self.EfficiencyTabActiveList then
        return self.EfficiencyTabActiveList
    end
    return {}
end

---是否有单个红点（页签上）
---1 表示上面几个页签, type=2 表示下面奖励页签
function this:GetToggleIsEfficiencyRedDot(group)
    if self.EfficiencyRedDotInfoList and self.EfficiencyRedDotInfoList["1"] then
        return table.contains(self.EfficiencyRedDotInfoList["1"],group)
    end
    return false
end

---获取当前奖励的最低未领取的cfgid
function this:GetNowRewardCfgId()
    if self.EfficiencyRedDotInfoList and self.EfficiencyRedDotInfoList["2"] and self.EfficiencyRedDotInfoList["2"]["targetId"] then
        return tonumber(self.EfficiencyRedDotInfoList["2"]["targetId"])
    end
    return 1
end

---获取效率按钮是否有红点
function this:GetAllIsEfficiencyRedDot()
    local redCount = 0
    if self.EfficiencyRedDotInfoList and self.EfficiencyRedDotInfoList["1"] then
        redCount = table.count(self.EfficiencyRedDotInfoList["1"])
    end
    return redCount > 0 or self:GetIsCanReward()
end

---是否可领取奖励
function this:GetIsCanReward()
    local myLv = SL:GetMetaValue("LEVEL")
    local cfgId = self:GetNowRewardCfgId()
    ---@type cfg_efficiency_level_column
    local cfg = nil
    if cfgId and SL:HasConfig("cfg_efficiency_level",cfgId) then
        cfg = SL:GetConfig("cfg_efficiency_level",cfgId)
    end
    if cfg then
        return myLv >= cfg.level
    end
    return false
end

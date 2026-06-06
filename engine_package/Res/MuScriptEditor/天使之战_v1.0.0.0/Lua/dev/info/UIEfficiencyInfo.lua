---@class UIEfficiencyInfo
---@param expPotionResData  EfficiencyProtos.ExperiencePotionRes
UIEfficiencyInfo = class()
local this = UIEfficiencyInfo

function this:ctor()

end

function this:Reset()
    self.isFirst=false
    self.purchasedIds={}
    self.reveivedRewardTab={}
end

function this:Init()
    self.multiplierInfo={}  --经验倍率信息
    self.efficiencyInfo={}  --cfg_efficiency
    self.efficiencyPomoteCfg=nil
    self.reveivedRewardTab={} --已领取的奖励
    self.rewardCfg=nil --领取奖励cfg
    self.vipCfg = nil
    self.curAllExpMultiplier=0
    self.expPotionEndTime=1
    self.purchasedIds={}
    self.expPotionResData=nil
    self.isFirst=false
    self.vipInfo={}
    
    self:InitData()
    self:RegistMessages()
    self:InitPomoteConfig()

end

function this:InitData()
end

function this:RegistMessages()
--[[    self.messageContainer:Regist(MessageDef.ResEfficiencyMagnificationMessage, self.ResEfficiencyMagnificationMessage, self)
    self.messageContainer:Regist(MessageDef.ResEfficiencyRewardInfoMessage, self.ResEfficiencyRewardInfoMessage, self)
    self.messageContainer:Regist(MessageDef.ResExperiencePotionMessage, self.ResExperiencePotionMessage, self)
    self.messageContainer:Regist(MessageDef.ResEfficiencyBuyInfoMessage,self.ResEfficiencyBuyInfoMessage,self)
    self.messageContainer:Regist(MessageDef.ResFirstRechargeViewMessage,self.ResFirstRechargeViewMessage,self)]]
    --self.messageContainer:Regist(MessageDef.ResEfficiencyBuyRateMessage,self.ResEfficiencyBuyRateMessage,self)
    
    SL:RegisterLuaNetMsg(MessageDef.ResEfficiencyMagnificationMessage, self.ResEfficiencyMagnificationMessage, self)
    SL:RegisterLuaNetMsg(MessageDef.ResEfficiencyRewardInfoMessage, self.ResEfficiencyRewardInfoMessage, self)
    SL:RegisterLuaNetMsg(MessageDef.ResExperiencePotionMessage, self.ResExperiencePotionMessage, self)
    SL:RegisterLuaNetMsg(MessageDef.ResEfficiencyBuyInfoMessage,self.ResEfficiencyBuyInfoMessage,self)
    SL:RegisterLuaNetMsg(MessageDef.ResFirstRechargeViewMessage,self.ResFirstRechargeViewMessage,self)
end

---@param message  EfficiencyProtos.EfficiencyMagnificationRes
function this:ResEfficiencyMagnificationMessage(_,message)
    for k,v in pairs(message.efficiencyMagnificationInfos) do
        local cfg = SL:GetConfig("cfg_efficiency",v.id)
        if cfg then
            if cfg.type==2 then
                self:UpdateMultiplierData(v)
            end
        end
    end
    SL:ReqFirstRechargeViewMessage()
end

---@param message  EfficiencyProtos.EfficiencyRewardInfoRes
function this:ResEfficiencyRewardInfoMessage(_,message)
    for k,v in pairs(message.id) do
        if not table.contains(self.reveivedRewardTab,v) then
            table.insert(self.reveivedRewardTab,v)
        end
    end
end
---@param message EfficiencyProtos.ExperiencePotionRes
function this:ResExperiencePotionMessage(_,message)
    self.isFirst=message.isFirst
    self.expPotionEndTime=message.endTime
    self.expPotionResData=message
end
---@param message EfficiencyProtos.EfficiencyBuyInfoRes
function this:ResEfficiencyBuyInfoMessage(_,message)
    for k,v in pairs(message.id) do
        if not table.contains(self.purchasedIds,v) then
            table.insert(self.purchasedIds,v)
        end
    end
end

---@param message RoleProtos.FirstRechargeViewRes
function this:ResFirstRechargeViewMessage(_,message)
    self.vipInfo = {message.id,message.receiveAmount}
end

---@param message EfficiencyProtos.EfficiencyBuyRateRes
function this:ResEfficiencyBuyRateMessage(_,message)
    for k,v in pairs(message.id) do
        if not table.contains(self.purchasedIds,v) then
            table.insert(self.purchasedIds,v)
        end
    end
end

--获取当前可以显示的奖励ui
function this:GetCanShowReward()
    if self.rewardCfg==nil then
        self:InitRewardConfig()
    end
    for k,v in pairs(self.rewardCfg) do
        if not table.contains(self.reveivedRewardTab,v.id) then
            return v
        end
    end
    return nil
end

function this:GetCanShowVipInfo(id)
    if self.vipCfg == nil then
        self.vipCfg = {}
    end
    if id == #self.vipCfg then
        return true, self.vipCfg[id] or {}
    else
        return false, self.vipCfg[id] or {}
    end
end

function this:GetIsPurchasedById(id)
    return table.contains(self.purchasedIds,id)
end

--更新经验倍率信息v
function this:UpdateMultiplierData(info)
    if self.multiplierInfo[info.id]==nil then
        self.multiplierInfo[info.id]={}
    end
    if self.multiplierInfo[info.id].curLevel~=info.level then
        self.multiplierInfo[info.id].expMultiplier=self:GetExpMultiplierByIdAndLevel(info.id,info.level)
    end
    self.multiplierInfo[info.id].curLevel=info.level
    if self.multiplierInfo[info.id].group==nil then
        self.multiplierInfo[info.id].group=self:GetGroupById(info.id)
    end
    if self.multiplierInfo[info.id].maxLevel==nil then
        self.multiplierInfo[info.id].maxLevel=self:GetEfficiencyMaxLevel(info.id)
    end
    self.curAllExpMultiplier= self.curAllExpMultiplier+self.multiplierInfo[info.id].expMultiplier
end

--获取效率信息通过cfgId
function this:GetEfficiencyInfoById(id)
    if self.efficiencyInfo[id] then
        return self.efficiencyInfo[id]
    end
    return nil
end

--设置当前数据同组最大的等级
function this:GetEfficiencyMaxLevel(id)
    local info = SL:GetConfig("cfg_efficiency",id)
    if info then
        return self:GetPomoteSameGroupMaxLevel(info.conditionGroup)
    end
    return 0
end

--设置当前数据同组最大的等级
function this:GetExpMultiplierByIdAndLevel(id,level)
    return 0
end

--设置当前数据同组最大的等
function this:GetExplosionRateByIdAndLevel(id,level)
    return 0
end
--设置当前数据组
function this:GetGroupById(id)
    local efficiencyInfo = SL:GetConfig("cfg_efficiency",id)
    if efficiencyInfo then
        return efficiencyInfo.conditionGroup
    end
    return 0
end

--获取同组别列表里最大等级
function this:GetPomoteSameGroupMaxLevel(group)
    self:InitPomoteConfig()
    if self.efficiencyPomoteCfg[group]==nil then
        return 0
    end
    if self.efficiencyPomoteCfg[group].maxLevel==nil then
        local level=0
        for k,v in pairs(self.efficiencyPomoteCfg[group]) do
            if level<=v.level then
                level=v.level
            end
        end
        self.efficiencyPomoteCfg[group].maxLevel=level
    end
    return  self.efficiencyPomoteCfg[group].maxLevel
end

--初始化所有奖励数据
function this:InitRewardConfig()
    self.rewardCfg=SL:FindConfigs("cfg_efficiency","type",1)
end

--初始化config数据
function this:InitPomoteConfig()
    if self.efficiencyPomoteCfg==nil then
        self.efficiencyPomoteCfg={}
        if false then
            for k,v in pairs(cfg) do
                if  self.efficiencyPomoteCfg[v.group]==nil then
                    self.efficiencyPomoteCfg[v.group]={}
                end
                self.efficiencyPomoteCfg[v.group][v.level]=v
            end
        end
    end
end


--获取经验倍率数据
function this:GetMultiplierInfoById(cfgId)
    return self.multiplierInfo[cfgId]
end

function this:GetAllExpMultiplier()
    return self.curAllExpMultiplier
end

function this:CheckFirstRecharge(id)
    if self.vipInfo[1] == id then
        return #self.vipInfo[2]
    end
end

function this:CheckBuyGift(str)
    local tab = string.split(str, '#')
    ---@type cfg_first_recharge_column
    local cfg = SL:GetConfig("cfg_first_recharge",tonumber(str))
    if next(self.vipInfo) then
        if #tab == 1 then
            if #cfg.amount == #self.vipInfo[2] then
                return 1
            else
                return 0
            end
        else
            for i, v in pairs(self.vipInfo[2]) do
                if v == tonumber(tab[2]) then
                    return 1
                end
            end
            return 0
        end
    end
    return 0
end



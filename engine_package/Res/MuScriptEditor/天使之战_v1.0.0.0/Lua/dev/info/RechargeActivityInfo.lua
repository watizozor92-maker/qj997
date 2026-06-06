---@class RechargeActivityInfo 
RechargeActivityInfo = class()
local this = RechargeActivityInfo

this.timeLimitGiftData = {} --限时礼包

function this:ctor()
end

function this:Reset()
    this.timeLimitGiftData = {}
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self:InitTimeLimitData()
end

function this:RegistMessages()
    --限时礼包
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ALL_TIME_LIMIT_GIFT,self.RES_ALL_TIME_LIMIT_GIFT,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TIME_LIMIT_GIFT,self.RES_TIME_LIMIT_GIFT,self)
    --
end

--region 限时礼包
function this:InitTimeLimitData()
    this.timeLimitGiftData = {}
    self.timeLimitGift_giftCfg = {}
    local giftCfgs = SL:GetConfigTable("cfg_timelLimitGift_gift")
    for key, value in pairs(giftCfgs) do
        if not self.timeLimitGift_giftCfg[value.group] then
            self.timeLimitGift_giftCfg[value.group] = {}
        end
        self.timeLimitGift_giftCfg[value.group][value.sort] = value
    end
end

function this:RES_ALL_TIME_LIMIT_GIFT(id, message)
    this.timeLimitGiftData = {}
    if message then
        for i,msg in pairs(message) do
            self:RefreshSingleTimeLimitGiftData(msg)
        end
    end
    self:CalculateTimeLimitGiftEndTime()
    self:RefreshTimeLimitGiftUI(message.isNew)
end
function this:RES_TIME_LIMIT_GIFT(id, message)
    if not message then
        this.timeLimitGiftData = {}
    else
        self:RefreshSingleTimeLimitGiftData(message)
    end
    self:CalculateTimeLimitGiftEndTime()
    self:RefreshTimeLimitGiftUI(message.isNew)
end

function this:RefreshSingleTimeLimitGiftData(msg)
    if not msg then
        return
    end
    --msg: group=cfg_timelLimitGift_all 表id, endTime=结束时间, timeLimitGiftInfo={索引=cfg_timelLimit_gift 表id ...已购买的}
    local msgData = {}
    msgData.group = tonumber(msg.group)
    msgData.endTime = tonumber(msg.endTime)
    msgData.timeLimitGiftInfo = {}
    for i,v in pairs(msg.timeLimitGiftInfo) do
        msgData.timeLimitGiftInfo[i] = tonumber(v)
    end
    this.timeLimitGiftData[msgData.group] = msgData
end

function this:RefreshTimeLimitGiftUI(isNew)
    --刷新主界面按钮（显示、红点、倒计时）
    local mainPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUISystemTop/KLUISystemTopPanel")
    if mainPanel and not GUI:IsUILoading(mainPanel) then
        mainPanel:RefreshSystemMenu()
    end
    --如果开着限时礼包主面板，刷新面板
    local TimeLimitGift = GUI:GetUI("dev/outui/Recharge/Panel/KLRechargeActivity/KLRechargeActivityPanel")
    if TimeLimitGift and not GUI:IsUILoading(mainPanel) then
        TimeLimitGift:Refresh()
    elseif isNew then
        GUI:CloseAllUIWithoutMainUI()
        GUI:UIPanel_Open("dev/outui/Recharge/Panel/KLRechargeActivity/KLRechargeActivityPanel")
        SL.HideMainPanel()
    end
end

function this:GetMaxTimeLimitGiftEndTime()
    --返回最大的 没买全的 没过期的 endTime
    local maxEndTime = nil
    for group,msg in pairs(this.timeLimitGiftData) do
        if msg.endTime - Time.GetServerTime() > 0 and table.count(msg.timeLimitGiftInfo) < table.count(self.timeLimitGift_giftCfg[group]) then
            if not maxEndTime then
                maxEndTime = msg.endTime
            else
                if msg.endTime > maxEndTime then
                    maxEndTime = msg.endTime
                end
            end
        end
    end
    if not maxEndTime then
        return 0
    end
    return (maxEndTime - Time.GetServerTime()) // 1000
end
function this:CalculateTimeLimitGiftEndTime()
    --返回最小的 没买全的 没过期的 endTime
    local minEndTime = nil
    local minGroup = nil
    for group,msg in pairs(this.timeLimitGiftData) do
        if msg.endTime - Time.GetServerTime() > 0 and table.count(msg.timeLimitGiftInfo) < table.count(self.timeLimitGift_giftCfg[group]) then
            if not minEndTime then
                minEndTime = msg.endTime
                minGroup = group
            else
                if msg.endTime < minEndTime then
                    minEndTime = msg.endTime
                    minGroup = group
                end
            end
        end
    end
    self.TimeLimitGiftEndTime = minEndTime
    self.TimeLimitGiftNextEndGroup = minGroup
end
function this:GetTimeLimitGiftEndTime()
    --if not self.TimeLimitGiftEndTime or (self.TimeLimitGiftEndTime - Time.GetServerTime()) <= 0 then
    self:CalculateTimeLimitGiftEndTime()
    --end
    return self.TimeLimitGiftEndTime,self.TimeLimitGiftNextEndGroup
end
function this:IsShowTimeLimitGiftBtn()
    for group,msg in pairs(this.timeLimitGiftData) do
        --有 没过期的 没购买的
        if msg.endTime - Time.GetServerTime() > 0 then
            if self.timeLimitGift_giftCfg and self.timeLimitGift_giftCfg[group] then
                for sort,cfg in pairs(self.timeLimitGift_giftCfg[group]) do
                    if not table.contains(msg.timeLimitGiftInfo,cfg.id) then
                        return true
                    end
                end
            end
        end
    end
    return false
end
function this:IsShowTimeLimitGiftRedDot() --TODO:主界面按钮红点刷新？
    local res = {}
    local needRedPoint = false
    for group,msg in pairs(this.timeLimitGiftData) do
        --没过期的 没购买的、免费的、上一个已购买
        if msg.endTime - Time.GetServerTime() > 0 then
            if self.timeLimitGift_giftCfg and self.timeLimitGift_giftCfg[group] then
                for sort,cfg in pairs(self.timeLimitGift_giftCfg[group]) do
                    if not table.contains(msg.timeLimitGiftInfo,cfg.id)
                        and table.count(cfg.cost) == 0
                        and self.timeLimitGift_giftCfg[group][sort-1]
                        and table.contains(msg.timeLimitGiftInfo,self.timeLimitGift_giftCfg[group][sort-1].id)
                    then
                        needRedPoint = true
                        if not res[group] then
                            res[group] = {}
                        end
                        table.insert(res[group],sort)
                    end
                end
            end
        end
    end
    return needRedPoint,res
end
--endregion 限时礼包

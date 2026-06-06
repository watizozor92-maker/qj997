---@class MainOperateActivityInfo
MainOperateActivityInfo = class()
local this = MainOperateActivityInfo

function this:ctor()
end

function this:Reset()
    self.operateMainActivityRedsTbl = {}
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.isOperateActivityMainBtnShow = false --主界面运营活动按钮是否展示 true展示
    self.operateActivityTypeTime = 0 --运营大活动开启时间
    self.operateActivityTypeCloseTime = 0 --运营大活动关闭时间
    self.isOperateHaveShowPanel = false --主界面运营活动按钮内是否有活动 true有
    self.operateMainActivityData = {} --RES_MAIN_ACTIVE_INFO协议内的所有运营活动数据
    self.tmpAllShowPanelTbl = {}  --判断是否有功能开关变动
    self.operateMainConditionInfo = {}  --运营活动条件集相关数据
    self.operateMainActivityRedsTbl = {} --运营活动红点表
    self.NowOperateActivityMainGroup = 0 --当前轮活动mainGroup


    self.addRechargeInfo = {}       --累充活动
    self.diamondPackInfo = {}       --累充活动
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MAIN_ACTIVE_INFO, self.RefreshOperateActivityData, self)
    SL:RegisterLUAEvent(LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE, self.LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE, self)
end
function this:LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE()
    self:RefreshMainOperateActivityRedPoint(EOperateActivityActivityType.RechargeDirect, "tog_Directpurchase", self:IsDirectRedDot())
end
-- [
--     RES_MAIN_ACTIVE_INFO = 10000276, -- 响应：运营活动基础信息
--         mainActive [activeId,closeTime,isShow,mainGroup,startTime]
--         subActive [list = {id,openTime}]
-- ]
function this:RefreshOperateActivityData(_, msg)
    if (not msg) or table.isNullOrEmpty(msg) or table.isNullOrEmpty(msg.mainActive) then
        SL:LogError("RES_MAIN_ACTIVE_INFO(10000276)协议内没有数据,请检查---------")
        return
    end
    local data = msg
    if self.isOperateActivityMainBtnShow ~= data.mainActive.isShow then
        self.isOperateActivityMainBtnShow = data.mainActive.isShow
    end

    self.operateActivityTypeTime = data.mainActive.startTime
    self.operateActivityTypeCloseTime = data.mainActive.closeTime
    local isHideMainOperatePanel = false
    if data.mainActive.isShow then
        local operateActivityAllInfo = SL:GetConfigMultiKeys("cfg_OperateActivity_all", data.mainActive.mainGroup, "mainGroup")
        if table.isNullOrEmpty(operateActivityAllInfo) then
            local str = "cfg_OperateActivity_all表内没有mainGroup为" .. data.mainActive.mainGroup .. "的数据！请检查配置！"
            SL:LogError(str)
            return
        else
            data.operateActivityAllInfo = operateActivityAllInfo
            --获取当前运营活动需要展示的所有子活动
            local allShowPanel = {}
            local returnDataTbl = {}
            if not table.isNullOrEmpty(data.subActive) then
                self.isOperateHaveShowPanel = true
                if not table.isNullOrEmpty(self.tmpAllShowPanelTbl) then
                    for _, v in pairs(data.subActive) do
                        local subActivityData = SL:GetConfig("cfg_OperateActivity_subActivity", tonumber(v.id))
                        if subActivityData then
                            local id = subActivityData.id
                            if not table.contains(self.tmpAllShowPanelTbl, id) then
                                isHideMainOperatePanel = true
                                break
                            end
                        else
                            SL:LogError("cfg_OperateActivity_subActivity表内没有id为" .. v.id .. "的数据！请检查配置！")
                        end

                    end

                    if table.count(self.tmpAllShowPanelTbl) ~= table.count(data.subActive) then
                        isHideMainOperatePanel = true
                    end
                end

                self.tmpAllShowPanelTbl = {}
                self.operateMainConditionInfo = {}
                for _, v in pairs(data.subActive) do
                    if v.openTime < Time.GetServerTime() then
                        if SL:HasConfig("cfg_OperateActivity_subActivity", tonumber(v.id)) then
                            local subActivityData = SL:GetConfig("cfg_OperateActivity_subActivity", tonumber(v.id))
                            table.insert(self.tmpAllShowPanelTbl, subActivityData.id)
                            v.subActivityData = subActivityData   --OperateActivity_subActivity表内对应数据

                            local subPanelData = SL:GetConfig("cfg_sub_OperateActivity", subActivityData.subId)
                            subPanelData.togShowName = subActivityData.showTogName

                            table.insert(allShowPanel, subPanelData)

                            returnDataTbl[subActivityData.subType] = v
                            local time = v.openTime > 0 and v.openTime or 0
                            self.operateMainConditionInfo[subActivityData.subType] = time
                        end
                    end
                end
                data.allShowPanelData = allShowPanel --当前运营活动界面需要展示的页签panel
                data.returnData = returnDataTbl --需要发回给后端的id,也可用来判断功能是否开启
            else
                self.isOperateHaveShowPanel = false
            end
        end

        self.operateMainActivityData = {}
        self.operateMainActivityData = data
        self.NowOperateActivityMainGroup = data.mainActive.mainGroup
        self:InitMainOperateRedInfo()
        self:GetSubActiveDataInfo(data)

        if isHideMainOperatePanel then
            local operateMainPanel = GUI:GetUI("dev/outui/MainOperateActivity/Panel/KLMainOperateActivity/KLMainOperateActivityPanel")
            if operateMainPanel then
                operateMainPanel:OnClickClose()
            end
        end
    else
        --运营活动关闭
        local operateMainPanel = GUI:GetUI("dev/outui/MainOperateActivity/Panel/KLMainOperateActivity/KLMainOperateActivityPanel")
        if operateMainPanel then
            operateMainPanel:OnClickClose()
        end
    end

    --派发事件
    SL:onLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_CHANGE)
end

----------------------------------------------运营活动---------------------------------------------------------------
--初始化子活动红点页签
function this:InitMainOperateRedInfo()
    if self.isOperateHaveShowPanel then
        local showTbl = self.operateMainActivityData.allShowPanelData
        if not table.isNullOrEmpty(showTbl) then
            for _, v in pairs(showTbl) do
                self.operateMainActivityRedsTbl[v.togName] = false
            end
        end
    end
end
--获取子活动数据
function this:GetSubActiveDataInfo(data)
    if not table.isNullOrEmpty(data.totalSubActive) then
        self:RefreshAddRechargeData(data.totalSubActive)
    end
    if not table.isNullOrEmpty(data.diamondPackInfo) then
        self.diamondPackInfo = data.diamondPackInfo
    end
    self:RefershOperateRed()
end

--刷新子活动红点
function this:RefershOperateRed()
    self:RefreshMainOperateActivityRedPoint(EOperateActivityActivityType.RechargeDirect, "tog_Directpurchase", self:IsDirectRedDot())
    self:RefreshMainOperateActivityRedPoint(EOperateActivityActivityType.OperateAddRecharge, "tog_Accumulation", self:RefreshAddRechargeRed())
    self:RefreshMainOperateActivityRedPoint(EOperateActivityActivityType.DiamondRecharge, "tog_Diamond", self:GetDiamondRedPoint())
end

--刷新累充活动红点
function this:RefreshAddRechargeRed()
    local addRechargeData = self.addRechargeInfo
    if not table.isNullOrEmpty(addRechargeData) then
        for _, v in pairs(addRechargeData) do
            if v.isShowRed then
                return true
            end
        end
    end
    return false
end

function this:GetDiamondRedPoint()
    if self.diamondPackInfo then
        for i, v in pairs(self.diamondPackInfo) do
            ---@type cfg_DiamondPack_column
            local tbl = SL:GetConfig("cfg_DiamondPack", tonumber(v.diamondPackId))
            if tbl.type == 3 then
                local buycount = InfoManager.countInfo:GetLimitAndTotalCountByKey(tbl.countkey)
                if buycount > 0 then
                    return true
                end
            end
        end
    end
    return false
end

--判断小活动功能是否开启
---@param subType OperateActivity_subActivity表内的subType EOperateActivityActivityType枚举
function this:JudgeThisSubtypeActivityIsOpen(subType)
    if (not table.isNullOrEmpty(self.operateMainActivityData))
            and (not table.isNullOrEmpty(self.operateMainActivityData.returnData))
            and (not table.isNullOrEmpty(self.operateMainActivityData.returnData[subType])) then
        return true
    end
    return false
end

---刷新运营活动主界面按钮红点以及子页签红点
---togName sub_OperateActivity表内字段
---isShow是否展示红点 true展示
function this:RefreshMainOperateActivityRedPoint(subType, togName, isShow)
    if isShow then
        isShow = self.isOperateActivityMainBtnShow and self:JudgeThisSubtypeActivityIsOpen(subType)
    end
    if not table.isNullOrEmpty(self.operateMainActivityRedsTbl) then
        self.operateMainActivityRedsTbl[togName] = isShow
        SL:RefreshPanelALLRedStateKmlByCondition("checkMainOperateActivityRed")
        local panel = GUI:GetUI("dev/outui/MainOperateActivity/Panel/KLMainOperateActivity/KLMainOperateActivityPanel")
        if panel then
            panel:RefreshTogRedPointShow()
        end
    end
end

--获取今天是周几
function this:WhatDayIsTodayInWeek()
    local time = math.floor(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME) / 1000)
    local TimeData = os.date("*t", time)
    local dayNum = TimeData.wday - 1 --周日为1 周一为2
    if dayNum == 0 then
        dayNum = 7
    end
    return dayNum
end

--获取是否在时间区间内
--time 2024/12/16-2024/12/23 
function this:IntervalTweenyearTime(time)
    local curTime = math.floor(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME) / 1000)
    local tmpData = string.split(time, "-")
    local firstData = tmpData[1]
    local lastData = tmpData[2]
    local stratTime = self:GetyearTimeStamp(firstData)
    if curTime < stratTime then
        return false
    end
    local endTime = self:GetyearTimeStamp(lastData) + 86400
    if curTime > endTime then
        return false
    end
    return true
end
function this:GetyearTimeStamp(data)
    local numbers = string.split(data, "_")
    if table.count(numbers) == 2 then
        return self:DateToServerTime({ year = numbers[1], month = numbers[2], day = 0, hour = 0 })
    end
    if table.count(numbers) == 3 then
        return self:DateToServerTime({ year = numbers[1], month = numbers[2], day = numbers[3], hour = 0 })
    end
    SL:LogError("time Error!!")
    return 0
end
--考虑时区 单位秒
---@param serverDate table 服务器日期table { year = 2021, month = 12, day = 16, hour = 0,min = 0, sec = 0 }
function this:DateToServerTime(serverDate)
    local DAY_SECONDS = 24 * 3600
    local TIMEZONES_SECONDS = 8 * 3600 --东八区 时区时间差
    local TIME_ZONE = os.time({ year = 1970, month = 1, day = 2, hour = 0, isdst = false })
    serverDate.isdst = false ---禁用夏令时
    local localDateTime = os.time(serverDate)
    return localDateTime + ((DAY_SECONDS - TIMEZONES_SECONDS) - TIME_ZONE)
end

function this:GetDurationDayMainGroup()
    local class = 0
    local curTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    class = self:DayApartFromTwoTime(curTime, InfoManager.mainOperateActivityInfo.operateActivityTypeTime) + 1 --持续天数+1天
    return class
end
function this:GetDurationDaySubType(subtype)
    local class = 0
    local openActivityTime = InfoManager.mainOperateActivityInfo.operateMainConditionInfo[subtype]
    if openActivityTime > 0 then
        local curTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        class = self:DayApartFromTwoTime(curTime, openActivityTime) + 1 --持续天数+1天
    end
    return class
end
---@param sTime  number (ms) 毫秒 eTime  时间戳 (ms) 毫秒
---@return number  apart days
function this:DayApartFromTwoTime(sTime, eTime)
    sTime = math.floor(sTime / 1000)
    eTime = math.floor(eTime / 1000)
    local TIMEZONES_SECONDS = 8 * 3600 --东八区 时区时间差
    local DAY_SECONDS = 24 * 3600
    --此处需要知道服务器时区 现在假定是在东八区 则需要加8个小时 8*3600
    local result = math.floor((sTime + TIMEZONES_SECONDS) / DAY_SECONDS) - math.floor((eTime + TIMEZONES_SECONDS) / DAY_SECONDS)
    return result
end

---获取子活动界面倒计时 返回倒计时时间戳
---@return number timeStamp 时间戳
function this:GetOADJSTimeBySubType(subType)
    local actualTbl = {}
    local showData = self.operateMainActivityData.subActive

    if not table.isNullOrEmpty(showData) then
        for _, v in pairs(showData) do
            if v.subActivityData.mainGroup == self.NowOperateActivityMainGroup and v.subActivityData.subType == subType then
                actualTbl = v
                break
            end
        end
    end
    if table.isNullOrEmpty(actualTbl) then
        return
    end

    local condition = actualTbl.subActivityData.closeCondition
    local tmpData = string.split(condition, "#")
    local conditionType = tonumber(tmpData[1]) --条件类型
    local mainGroup = tonumber(tmpData[2]) --大活动类型
    local subSubType = tonumber(tmpData[3]) --子活动类型
    local conditionKey = tonumber(tmpData[4]) --子活动持续天数
    local timeStamp = 0
    local dayTime = 86400
    if mainGroup == self.NowOperateActivityMainGroup then
        if subType == subSubType then
            if conditionType == 981 then
                local curTime = math.floor(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME) / 1000)
                timeStamp = math.floor(self.operateMainConditionInfo[subSubType] / 1000 + conditionKey * dayTime - curTime)
            else
                local tips = "OperateActivity_subActivity表内mainGroup==" .. self.NowOperateActivityMainGroup ..
                        ", subType==" .. subType .. "的closeCondition字段第一个参数应该配置为981条件,请检查！！"
                SL:LogError(tips)
            end
        else
            local tips = "OperateActivity_subActivity表内mainGroup==" .. self.NowOperateActivityMainGroup ..
                    ", subType==" .. subType .. "的closeCondition字段第三个参数配错了,请检查！！"
            SL:LogError(tips)
        end
    else
        local tips = "OperateActivity_subActivity表内mainGroup==" .. self.NowOperateActivityMainGroup ..
                ", subType==" .. subType .. "的closeCondition字段第二个参数配错了,请检查！！"
        SL:LogError(tips)
    end
    return timeStamp
end


----------------------------------------------运营活动子活动---------------------------------------------------------------
--刷新累充活动数据
function this:RefreshAddRechargeData(totalSubActive)
    self.addRechargeInfo = {}
    local tab = {}
    local tbl = {}
    local TgiftState = 2
    ---获取剩余次数和总次数
    local buycount = 0
    local totalcount = 0
    local showmoney = 0
    local isShow = false
    for _, v in pairs(totalSubActive.panel) do
        showmoney = totalSubActive.money
        tbl = SL:GetConfig("cfg_rechargeRccrued", tonumber(v.accumulatedId))
        buycount, totalcount = InfoManager.countInfo:GetLimitAndTotalCountByKey(tbl.Countkey)
        if buycount > 0 and totalSubActive.money >= tbl.amount then
            --剩余次数大于0切可以领取
            TgiftState = E_RechargeState.CanGet --可领取
            showmoney = tbl.amount
            isShow = true
        elseif totalSubActive.money < tbl.amount then
            TgiftState = E_RechargeState.NotComplete --未完成
        else
            TgiftState = E_RechargeState.AlreadyGet --已领取
            showmoney = tbl.amount
        end
        tab = {
            id = v.accumulatedId,
            money = showmoney,
            showCount = tbl.showCount,
            reward = tbl.reward,
            taskDes = tbl.text,
            goal = tbl.amount,
            giftState = TgiftState,
            isShowRed = isShow
        }
        table.insert(self.addRechargeInfo, tab)
    end
end

----直购红点
function this:IsDirectRedDot()
    local currentGroup = self.NowOperateActivityMainGroup
    local cfg = SL:GetConfigTable("cfg_OperateActivity_CDM")
    for k, v in ipairs(cfg) do
        if v.mainGroup == currentGroup and (v.bugType == 1 or v.bugType == 3) then
            local rechargeCfg = SL:GetConfigTwoKeys("cfg_recharge", v.id, v.rechargeType, "parameter", "type")
            if rechargeCfg then
                if rechargeCfg.amount == 0 then
                    local count, totalcount = InfoManager.countInfo:GetLimitAndTotalCountByKey(rechargeCfg.Countkey)
                    if count > 0 then
                        return true
                    end
                end
            end
        end
    end
    return false
end 


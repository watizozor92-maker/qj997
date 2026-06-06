SevenLogin ={}
local this = {}
SevenLogin.var ={
    LOGIN_ACTIVITY_INFO = "T$loginactivityinfo",
}
--活动是否开启
function SevenLogin.isActivityOpen(actor)
    local config = ConfigDataManager.getTable("sub_mainActivity","id",6)
    if config == nil then
        return false
    end
    return ConditionManager.Check(actor, config[1].actualcondition)
end
--页签是否开启
function SevenLogin.tableOpen(actor)
    local config = ConfigDataManager.getTable("sub_mainActivity","id",6)
    if config == nil then
        return nil
    end
    if config then
        local condition = config[1].showcondition
        local map = string.putIntIntMap({},condition,"#","&")
        local time = map[903]
        local serverOpenDays = getbaseinfo(actor, "serveropendays")
        if time + 1 == tonumber(serverOpenDays) then
            return true
        end
    end
    return nil
end
function SevenLogin.login(actor)
    SevenLogin.updateLoginInfo(actor)
end
--玩家凌晨在线时需要更新一次
function SevenLogin.midNightUpdate(actor)
    SevenLogin.updateLoginInfo(actor)
end
---更新登录信息
function SevenLogin.updateLoginInfo(actor)
    if not SevenLogin.isActivityOpen(actor) then
        return
    end
    local result = {}
    local rewardInfo = getplaydef(actor,SevenLogin.var.LOGIN_ACTIVITY_INFO)
    if not rewardInfo then
        rewardInfo = {}
        rewardInfo.countDay = 1
        rewardInfo.hadReceiveReward = {}
        rewardInfo.lastLoginTime = getbaseinfo("now")
    end
    --校验登录时间是否跨天
    local now = getbaseinfo("now")
    local lastLoginTime = rewardInfo.lastLoginTime
    if not TimeUtil.isSameDay4Millis(now, lastLoginTime) then
        rewardInfo.countDay = rewardInfo.countDay + 1
        rewardInfo.lastLoginTime = now
    end
    setplaydef(actor,SevenLogin.var.LOGIN_ACTIVITY_INFO,rewardInfo)
    --通知客户端
    result.countDay = rewardInfo.countDay
    result.hadReceiveReward = rewardInfo.hadReceiveReward
    sendluamsg(actor,LuaMessageIdToClient.RES_LOGIN_REWARD_INFO_CHANGE,result)
end


--请求领取登录奖励
function SevenLogin.receiveLoginReward(actor,msgData)
    if not SevenLogin.isActivityOpen(actor) then
        tipinfo(actor,"活动未开启！")
        return
    end
    local id = msgData.id
    local config = ConfigDataManager.getTable("cfg_accumulateLogOn","id",id)
    if not config then
        return
    end
    local rewardInfo = getplaydef(actor,SevenLogin.var.LOGIN_ACTIVITY_INFO)
    if rewardInfo.countDay < tonumber(config[1].accumulateday) then
        tipinfo(actor, "登录天数不足！")
        return
    end
    if table.contains(rewardInfo.hadReceiveReward, tonumber(id)) then
        tipinfo(actor,"不要重复领取！")
        return
    end
    --发奖励
    local reward = string.putIntIntMap({},config[1].reward,"#","|")
    for itemCfgId, count in pairs(reward) do
        additemtobag(actor, itemCfgId, count, 0, 9999, ItemActionProxy.SEVENLOGIN)
    end
    --奖励弹框
    sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, reward)
    table.insert(rewardInfo.hadReceiveReward,tonumber(id))
    setplaydef(actor,SevenLogin.var.LOGIN_ACTIVITY_INFO,rewardInfo)
    --通知客户端
    local result = {}
    result.countDay = rewardInfo.countDay
    result.hadReceiveReward = rewardInfo.hadReceiveReward
    sendluamsg(actor,LuaMessageIdToClient.RES_RECEIVE_LOGIN_REWARD,result)
end

--活动结束时邮件发放奖励
function SevenLogin.sendReward()
    local allRoleInfos = getallrolesummaryinfos()
    if allRoleInfos == nil or next(allRoleInfos) == nil then
        return
    end
    for _, roleInfo in pairs(allRoleInfos) do
        local reward = {}
        local actor = roleInfo["actor"]
        if not SevenLogin.tableOpen(actor) then
            return
        end
        local rewardInfo = getplaydef(actor,SevenLogin.var.LOGIN_ACTIVITY_INFO)
        if rewardInfo == nil or rewardInfo == "" then
            rewardInfo = {}
        end
        local countDay = rewardInfo.countDay or 0
        if  countDay > 0 then
            local config = ConfigDataManager.getTable("cfg_accumulateLogOn")
            for _, cfg in pairs(config) do
                if not table.contains(rewardInfo.hadReceiveReward, tonumber(cfg.id)) then
                    if tonumber(cfg.accumulateday) <= countDay then
                        string.putIntIntMap(reward, cfg.reward)
                    end
                end

            end
        end
        if table.count(reward) > 0 then
            sendconfigmailbyrid(actor, getbaseinfo(actor, "rid"), MailConfig.END_TIME_LOGIN_REWARD, reward, "")
        end
        setplaydef(actor, SevenLogin.var.LOGIN_ACTIVITY_INFO, nil)
    end

end

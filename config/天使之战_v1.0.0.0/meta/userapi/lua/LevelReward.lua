LevelReward ={}
local this = {}
LevelReward.var ={
    HAD_RECEIVE_REWARD = "T$hadreceivereward",
    SERVER_LIMIT_LEVEL_REWARD = "R$serverlimitlevelreward"
}

--活动是否开启
function LevelReward.isActivityOpen(actor)
    local config = ConfigDataManager.getTable("sub_mainActivity","id",7)
    if config == nil then
        return false
    end
    return ConditionManager.Check(actor, config[1].actualcondition)
end
--是否页签关闭后的第一天
function LevelReward.tableOpen(actor)
    local config = ConfigDataManager.getTable("sub_mainActivity","id",7)
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

function LevelReward.login(actor)
    LevelReward.getLevelRewardInfo(actor)
end

---请求当前已领取信息
function LevelReward.getLevelRewardInfo(actor)
    if not LevelReward.isActivityOpen(actor) then
        return
    end
    local result = {}
    local rewardInfo = getplaydef(actor,LevelReward.var.HAD_RECEIVE_REWARD) or {}
    result.personInfo = rewardInfo
    local serverInfo = getsysvar(LevelReward.var.SERVER_LIMIT_LEVEL_REWARD)
    if not serverInfo then
        setsysvar(LevelReward.var.SERVER_LIMIT_LEVEL_REWARD,{})
        serverInfo = getsysvar(LevelReward.var.SERVER_LIMIT_LEVEL_REWARD)
    end
    result.serverInfo = serverInfo
    sendluamsg(actor,LuaMessageIdToClient.RES_PERSONAL_LEVEL_REWARD_INFO,table.valueConvertToString(result))
end


--请求领取等级奖励
function LevelReward.receiveLevelReward(actor,msgData)
    local id = msgData.id
    callonserial(actor, "level_reward_receive", id)
end

function level_reward_receive(actor,id)
    local config = ConfigDataManager.getTable("cfg_activity_levelUp","id",id)
    if config == nil then
        return
    end
    local level = getbaseinfo(actor,"level")
    local cfgLv = config[1].level
    if tonumber(level) < tonumber(cfgLv) then
        tipinfo(actor,"等级不足！")
        return
    end
    local reward = {}
    local rewardInfo = getplaydef(actor,LevelReward.var.HAD_RECEIVE_REWARD) or {}
    local result = rewardInfo[tostring(id)] or {}
    if not result.basicItem then
        --增加限量判定
        local limitNum= config[1].places
        if not (limitNum == nil or limitNum == "" or limitNum == "0") then
            local nowInfo = getsysvar(LevelReward.var.SERVER_LIMIT_LEVEL_REWARD) or {}
            local nowNum = nowInfo[tostring(id)] or 0
            if nowNum >= tonumber(limitNum) then
                tipinfo(actor,"已达到领取上限！")
                return
            else
                nowNum = nowNum + 1
                nowInfo[tostring(id)] = nowNum
                setsysvar(LevelReward.var.SERVER_LIMIT_LEVEL_REWARD,nowInfo)
            end
        end
        string.putIntIntMap(reward,config[1].basicitem,"#","|")
        result.basicItem = true
    end
    if not result.specialItem then
        local condition = config[1].conditions
        if ConditionManager.Check(actor,condition) then
            string.putIntIntMap(reward,config[1].specialitem,"#","|")
            result.specialItem = true
        else
            result.specialItem = false
        end
    end
    --发奖励
    if table.count(reward) == 0 then
        return
    end
    for itemCfgId, count in pairs(reward) do
        additemtobag(actor, itemCfgId, count,0,9999,ItemActionProxy.LEVEL_REWARD)
    end
    --奖励弹框
    sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, reward)
    rewardInfo[tostring(id)] = result
    setplaydef(actor,LevelReward.var.HAD_RECEIVE_REWARD,rewardInfo)
    --通知客户端
    sendluamsg(actor,LuaMessageIdToClient.RES_RECEIVE_LEVEL_REWARD,table.valueConvertToString(rewardInfo))
    LevelReward.getLevelRewardInfo(actor)
end

--活动结束时发放所有奖励
function LevelReward.sendAllReward()
    local nowInfo = getsysvar(LevelReward.var.SERVER_LIMIT_LEVEL_REWARD)
    if nowInfo == nil or nowInfo == "" then
        return
    end
    local allRoleInfos = getallrolesummaryinfos()
    if allRoleInfos == nil or next(allRoleInfos) == nil then
        return
    end
    local tab = ConfigDataManager.getTable("cfg_activity_levelUp")
    for _, roleInfo in pairs(allRoleInfos) do
        local reward = {}
        local actor = roleInfo["actor"]
        if not LevelReward.tableOpen(actor) then
            return
        end
        local hadReward = getplaydef(actor, LevelReward.var.HAD_RECEIVE_REWARD) or {}
        if hadReward.lastReward then
            return
        end
        for i = 1,#tab,1 do
            local config = tab[i]
            local level = getbaseinfo(actor,"level")
            local id = config.id
            local cfgReward = hadReward[tostring(id)] or {}
            if table.count(cfgReward) > 0  then
                if cfgReward.specialItem == false and ConditionManager.Check(actor,config.conditions) then
                    string.putIntIntMap(reward, config.specialitem)
                    cfgReward.specialItem = true
                end
                hadReward[tostring(id)] = cfgReward
            else
                local cfgLv = config.level
                if tonumber(level) >= tonumber(cfgLv) then
                    --判断限定数量
                    local limitNum= config.places
                    if not (limitNum == nil or limitNum == "" or limitNum == "0") then
                        local nowNum = nowInfo[tostring(config.id)] or 0
                        if nowNum < tonumber(limitNum) then
                            nowNum = nowNum + 1
                            nowInfo[tostring(config.id)] = nowNum
                            setsysvar(LevelReward.var.SERVER_LIMIT_LEVEL_REWARD,nowInfo)
                            string.putIntIntMap(reward, config.basicitem)
                            cfgReward.basicItem = true
                            if ConditionManager.Check(actor,config.conditions) then
                                string.putIntIntMap(reward, config.specialitem)
                                cfgReward.specialitem = true
                            end
                        end
                    else
                        string.putIntIntMap(reward, config.basicitem)
                        cfgReward.basicItem = true
                        if ConditionManager.Check(actor,config.conditions) then
                            string.putIntIntMap(reward, config.specialitem)
                            cfgReward.specialitem = true
                        end
                    end
                end
            end
        end
        --发邮件
        if table.count(reward) > 0 then
            sendconfigmailbyrid(actor,getbaseinfo(actor,"rid"), MailConfig.END_TIME_LEVEL_REWARD, reward, "")
        end
        hadReward.lastReward = true
        setplaydef(actor, LevelReward.var.HAD_RECEIVE_REWARD,hadReward)
    end
    setsysvar(LevelReward.var.SERVER_LIMIT_LEVEL_REWARD,nil)

end

--- 幸运周末消费排行

WeekConsumerRank = { }
WeekConsumerRank.__index = WeekConsumerRank

local this = {}

local function _rechargeType()
    return "199"
end

local function _playerDbKey()
    return "T$WEEK_CONSUMER_RANK"
end

function WeekConsumerRank.get(actor)
    local obj = getplaydef(actor, _playerDbKey())
    return setmetatable(obj or {}, WeekConsumerRank)
end

function WeekConsumerRank:save(actor)
    setplaydef(actor, _playerDbKey(), self);
end


--- 请求充值档位信息
function WeekConsumerRank.reqRechargeAction(actor,mainGroup)
    -- 判断当前主活动是否开启了子直购活动
    local activity = {}
    local rank = ConfigDataManager.getTable("cfg_Activity_costRank","mainGroup",mainGroup)
    if table.isNullOrEmpty(rank) then
        return activity
    end
    local allRechargeInfo = WeekConsumerRank.get(actor)
    local numberId = tonumber(mainGroup)
    local rechargeInfo = allRechargeInfo[numberId]
    activity["ownInfo"] = rechargeInfo
    local topTen = this.getTopTen(numberId)
    activity["rank"] = topTen
    return activity
end

function this.getRankMoney(mainGroup)
    local money = 0
    local allRankMoney = ConfigDataManager.getTableValue("cfg_global","value","id",28004)
    if string.isNullOrEmpty(allRankMoney) then
        return money
    end
    local rankMoneyTable = string.split(allRankMoney,"|")
    for k, rankMoney in pairs(rankMoneyTable) do
        local rankMoneyInfo = string.split(rankMoney,"#")
        if tonumber(rankMoneyInfo[1]) == mainGroup then
            return tonumber(rankMoneyInfo[2])
        end
    end
    return money
end


-- 获取前十名
function this.getTopTen(mainGroup)
    local weekConsumerRank = {}
    local rankMoney = this.getRankMoney(mainGroup)
    local allRoleInfos = getallrolesummaryinfos()
    if not table.isNullOrEmpty(allRoleInfos) then
        for k, roleInfo in pairs(allRoleInfos) do
            local otherActor = roleInfo["actor"]
            local allOtherRechargeInfo = WeekConsumerRank.get(otherActor)
            if not table.isNullOrEmpty(allOtherRechargeInfo) then
                local otherRechargeInfo = allOtherRechargeInfo[mainGroup]
                if not table.isNullOrEmpty(otherRechargeInfo) and otherRechargeInfo.money >= rankMoney then
                    table.insert(weekConsumerRank,otherRechargeInfo)
                end
            end
        end
    end
    table.sort(weekConsumerRank, function(a, b)
        if a.money == b.money and a.time ~= nil and b.time ~= nil then
            return a.time > b.time
        else
            return a.money > b.money
        end

    end)
    local topTen = {}
    if table.count(weekConsumerRank) > 10 then
        for i = 1, 10 do
            local roleInfo =  weekConsumerRank[i]
            table.insert(topTen,roleInfo)
        end
    else
        topTen = weekConsumerRank
    end
    return topTen
end



--- 触发充值
function WeekConsumerRank.rechargeEvent(actor, cfg_recharge, count, amount, ext, outRewards)
    this.saveMoney(actor,amount,count)
    WeekActives.openSubActive(actor,{
        subType = ACTIVE_TYPE.CONSUMER_RANK
    })
end

-- 保存当前充值的钱
function this.saveMoney(actor,amount,count)
    local currentActive = getsysvar(actor,CURRENT_WEEKEN_ACTIVE)
    if table.isNullOrEmpty(currentActive) then
        return
    end
    if WeekActives.judgeActiveClose(actor,ACTIVE_TYPE.CONSUMER_RANK) then
        local numberId = tonumber(currentActive.mainActive.mainGroup)
        if amount ~= nil then
            local operationalActive = WeekConsumerRank.get(actor)
            local rechargeInfo = operationalActive[numberId]
            if table.isNullOrEmpty(rechargeInfo) then
                rechargeInfo = {
                    rid = actor:toString(),
                    name = getbaseinfo(actor,"rolename"),
                    money = tonumber(amount) * tonumber(count),
                    time = getbaseinfo(actor,"now")
                }
                operationalActive[numberId] = rechargeInfo
            else
                rechargeInfo.money = rechargeInfo.money + tonumber(amount) * tonumber(count)
                rechargeInfo.time = getbaseinfo(actor,"now")
            end
            operationalActive:save(actor)
        end
    end
end



--- 累充关闭
function WeekConsumerRank.closeActive(mainGroup)
    local topTen = this.getTopTen(mainGroup)
    if table.isNullOrEmpty(topTen) then
        return
    end
    for index, rechargeInfo in pairs(topTen) do
        local rid = rechargeInfo.rid
        local actor = getactor(rid)
        local career = getbaseinfo(actor,"getbasecareer")
        local mail = ConfigDataManager.getTableValue("cfg_Activity_costRank","mail","mainGroup",mainGroup,"ranking",index)
        local mailTable = string.split(mail,"|")
        local item = {}
        for k, mailInfo in pairs(mailTable) do
            local mailDetail = string.split(mailInfo,"#")
            if table.count(mailDetail) == 3 and tonumber(mailDetail[3]) == career then
                local itemCfgId = tonumber(mailDetail[1])
                local itemCount = item[itemCfgId]
                if itemCount == nil then
                    item[itemCfgId] = tonumber(mailDetail[2])
                else
                    item[itemCfgId] = item[itemCfgId] + tonumber(mailDetail[2])
                end
            end
            if table.count(mailDetail) == 2 then
                local itemCfgId = tonumber(mailDetail[1])
                local itemCount = item[itemCfgId]
                if itemCount == nil then
                    item[itemCfgId] = tonumber(mailDetail[2])
                else
                    item[itemCfgId] = item[itemCfgId] + tonumber(mailDetail[2])
                end
            end
        end
        sendconfigmailbyrid(actor,actor:toString(), 900005, item)
    end
end



-- ------------------------------------------------------------- --
this.log_open = false

function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(...)
end

function this.jprint(...)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(...)
end


-- ------------------------------------------------------------- --
EventListerTable.registerType("幸运周末消费排行", _rechargeType(), _playerDbKey())

RechargeEventListerTable:eventLister("0", "幸运周末消费排行", WeekConsumerRank.rechargeEvent)

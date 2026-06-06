--- 幸运周末累充
WeekAccumulatedRecharge = { }
WeekAccumulatedRecharge.__index = WeekAccumulatedRecharge

local this = {}

local function _rechargeType()
    return "177"
end

local function _playerDbKey()
    return "T$WEEK_OPERATION_ACCUMULATED_RECHARGE"
end

function WeekAccumulatedRecharge.get(actor)
    local obj = getplaydef(actor, _playerDbKey())
    return setmetatable(obj or {}, WeekAccumulatedRecharge)
end

function WeekAccumulatedRecharge:save(actor)
    setplaydef(actor, _playerDbKey(), self);
end

local STATISTICS_TYPE = {
    ALL = 0,
    ACTIVE = 1,
}

--- 请求充值档位信息
function WeekAccumulatedRecharge.reqRechargeAction(actor,mainGroup)
    -- 判断当前主活动是否开启了子直购活动
    local activity = {}
    local allActivityInfo = {}
    local operateActivityTable = ConfigDataManager.getList("cfg_rechargeRccrued")
    if table.isNullOrEmpty(operateActivityTable) then
        return allActivityInfo
    end

    local type = 0
    for _, config in pairs(operateActivityTable) do
        if tonumber(mainGroup) == tonumber(config.maingroup) then
            type = tonumber(config.type)
            local accumulatedId = config.id
            local itemCount = config.itemcount
            local rewardsMap = string.toIntIntMap(itemCount, "#", "|")
            local activityInfo = {
                accumulatedId = accumulatedId,
                itemInfo = rewardsMap
            }
            CountManager.getCount(actor, config.countkey)
            table.insert(allActivityInfo,activityInfo)
        end
    end
    activity["panel"] = allActivityInfo
    local money = this.totalMoney(actor,type)
    activity["money"] = money
    return activity
end

--- 触发充值
function WeekAccumulatedRecharge.rechargeEvent(actor, cfg_recharge, count, amount, ext, outRewards)
    this.debug("购买幸运周末直购礼包", cfg_recharge, "购买数量", count, ext, outRewards)
    this.saveMoney(actor,amount)
    WeekActives.openSubActive(actor,{
        subType = ACTIVE_TYPE.TOTAL_RECHARGE
    })
end


function WeekAccumulatedRecharge.reqAction(actor, rechargeType, action, reqParameter)
    if action == "reward" then
        local directGiftId = reqParameter["id"]
        local config = ConfigDataManager.getById("cfg_rechargeRccrued", directGiftId)
        local mainGroup = WeekActives.getCurrentMainGroup(actor)
        local cfgMainGroup = config.maingroup
        if mainGroup ~= tonumber(cfgMainGroup) then
            return
        end
        local count = CountManager.getCount(actor, config.countkey)
        local total = ConfigDataManager.getTableValue("Count_count","total","id",config.countkey)
        if count.count >= tonumber(total) then
            return
        end
        this.sendReward(actor,config)
        CountManager.count(actor, config.countkey,1)
    end
    WeekActives.openSubActive(actor,{
        subType = ACTIVE_TYPE.TOTAL_RECHARGE
    })
end



-- 保存当前充值的钱
function this.saveMoney(actor,amount)
    local currentActive = getsysvar(actor,CURRENT_WEEKEN_ACTIVE)
    if table.isNullOrEmpty(currentActive) then
        return
    end
    if WeekActives.judgeActiveClose(actor,ACTIVE_TYPE.TOTAL_RECHARGE) then
        local id = ConfigDataManager.getTableValue("cfg_OperateActivity_subActivity","id","mainGroup",currentActive.mainActive.mainGroup,"subType",ACTIVE_TYPE.TOTAL_RECHARGE)
        if string.isNullOrEmpty(id) then
            return
        end
        local numberId = tonumber(id)
        if amount ~= nil then
            local operationalActive = WeekAccumulatedRecharge.get(actor)
            operationalActive[numberId] = tonumber(operationalActive[numberId] or 0) + amount
            operationalActive:save(actor)
        end
    end
end



--- 累充关闭
function WeekAccumulatedRecharge.closeActive(mainGroup)
    local allRoleInfos = getallrolesummaryinfos()
    local rechargeTable = ConfigDataManager.getTable("cfg_rechargeRccrued","mainGroup",mainGroup)
    if not table.isNullOrEmpty(allRoleInfos) and not table.isNullOrEmpty(rechargeTable) then
        local specialCondition = ConfigDataManager.getTableValue("cfg_OperateActivity_subActivity","specialCondition","mainGroup",mainGroup,"subType",ACTIVE_TYPE.TOTAL_RECHARGE)
        for k, roleInfo in pairs(allRoleInfos) do
            local actor = roleInfo["actor"]
            if ConditionManager.Check(actor, specialCondition) then
                local item = {}
                local money = this.totalMoney(actor,rechargeTable[1].type)
                for k, rechargeInfo in pairs(rechargeTable) do
                    local countInfo = CountManager.getCount(actor,rechargeInfo.countkey)
                    if not table.isNullOrEmpty(countInfo) and countInfo.total > countInfo.count and money >= tonumber(rechargeInfo.amount) then
                        local count = countInfo.total - countInfo.count
                        for i = 1, count do
                            string.putIntIntMap(item, rechargeInfo.reward, "#", "|")
                        end
                    end
                end
                if not table.isNullOrEmpty(item) then
                    sendconfigmailbyrid(actor, actor:toString(), 900003, item)
                end
            end
        end
    end
end



-- 发送奖励
function this.sendReward(actor,config)
    local money = this.totalMoney(actor,tonumber(config.type))
    if tonumber(config.amount) <= money and not string.isNullOrEmpty(config.reward) then
        Bag.sendRewards4String(actor, config.reward, ItemActionProxy.WEEKACCUMULATEDRECHARGE..config.id)
    end
end

-- 获取当前充值多钱前
function this.totalMoney(actor,type)
    local money = 0
    if type == STATISTICS_TYPE.ALL then
        money = RechargeRecord.getTotalMoney(actor)
    else
        local activityRecharge = WeekAccumulatedRecharge.get(actor)
        if not table.isNullOrEmpty(activityRecharge) then
            local currentActive = getsysvar(actor, CURRENT_WEEKEN_ACTIVE)
            if not table.isNullOrEmpty(currentActive) then
                local id = ConfigDataManager.getTableValue("cfg_OperateActivity_subActivity","id","mainGroup",currentActive.mainActive.mainGroup,"subType",ACTIVE_TYPE.TOTAL_RECHARGE)
                if not string.isNullOrEmpty(id) then
                    money = activityRecharge[tonumber(id)] or 0
                end
            end
        end
    end
    return money
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
EventListerTable.registerType("幸运周末累充", _rechargeType(), _playerDbKey())

RechargeEventListerTable:eventLister("0", "幸运周末累充", WeekAccumulatedRecharge.rechargeEvent)

RechargeMessageEventListerTable:eventLister(_rechargeType(), "幸运周末累充", WeekAccumulatedRecharge.reqAction)
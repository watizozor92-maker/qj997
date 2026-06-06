--- 运营直购礼包
DirectPurchase = {}
DirectPurchase.__index = DirectPurchase

local this = {}

local function _rechargeType()
    return "16"
end

local function _playerDbKey()
    return nil
end

local BUY_TYPE = {
    NOE_BUY = 2, -- 一键购买
    FREE_BUY = 3 -- 免费购买
}

--- 请求充值档位信息
function DirectPurchase.reqRechargeAction(actor,mainGroup)
    -- 判断当前主活动是否开启了子直购活动
    local allActivityInfo = {}
    local operateActivityTable = ConfigDataManager.getList("cfg_OperateActivity_CDM")
    if table.isNullOrEmpty(operateActivityTable) then
        return allActivityInfo
    end
    for _, config in pairs(operateActivityTable) do
        if tonumber(mainGroup) == tonumber(config.maingroup) then
            local directId = config.id
            local itemCount = config.itemcount
            local rewardsMap = string.toIntIntMap(itemCount, "#", "|")
            local rechargeId = ConfigDataManager.getTableValue("cfg_recharge","id","type",config.rechargetype,"parameter",directId)
            local activityInfo = {
                directId = directId,
                itemInfo = rewardsMap,
                rechargeId = rechargeId
            }
            table.insert(allActivityInfo,activityInfo)
            -- 刷新购买数据
            --local count_key = ConfigDataManager.getTableValue("cfg_recharge", "countkey", "id", rechargeId)
            --CountManager.getCount(actor, count_key)
        end
    end
    -- 更新充值count
    -- CountManager.getCount(actor, count_key)
    return allActivityInfo
end

--- 触发充值
function DirectPurchase.rechargeEvent(actor, cfg_recharge, count, amount, ext, outRewards)
    local directGiftId = cfg_recharge.parameter
    local config = ConfigDataManager.getById("cfg_OperateActivity_CDM", directGiftId)
    local mainGroup = OperationalActivities.getCurrentMainGroup(actor)
    local cfgMainGroup = config.maingroup
    if mainGroup ~= tonumber(cfgMainGroup) then
        return
    end
    if tonumber(config.bugtype) == BUY_TYPE.NOE_BUY then
        -- 一键购买
        local operateActivity = ConfigDataManager.getTable("cfg_OperateActivity_CDM","mainGroup",mainGroup)
        if not table.isNullOrEmpty(operateActivity) then
            for _, config in pairs(operateActivity) do
                local operateActivityId = config.id
                local countKey = ConfigDataManager.getTableValue("cfg_recharge","Countkey","parameter",operateActivityId,"type",_rechargeType())
                local count = CountManager.getCount(actor, tonumber(countKey))
                -- local total = ConfigDataManager.getTableValue("Count_count","total","id",countKey)
                if tonumber(operateActivityId) ~= tonumber(directGiftId) then
                    if tonumber(config.bugtype) ~= BUY_TYPE.FREE_BUY and count.count > 0 then
                        return
                    end
                end
            end
        end
        this.oneBug(actor,outRewards,operateActivity)
    else
        gameDebug.assertTrue(table.notEmpty(config), "没有配置直购礼包", directGiftId)

        local reward_str = config.itemcount
        if not string.isNullOrEmpty(reward_str) then
            string.putIntIntMap(outRewards, reward_str, "#", "|")
        end
    end
    -- 发送界面信息数据
    this.debug("购买直购礼包成功", cfg_recharge, "购买数量", count, ext, outRewards)
    OperationalActivities.openSubActive(actor,{
        subType = ACTIVE_TYPE.DIRECT
    })
end

-- 一键购买
function this.oneBug(actor,outRewards,operateActivity)
    if not table.isNullOrEmpty(operateActivity) then
        for _, config in pairs(operateActivity) do
            local operateActivityId = config.id
            local countKey = ConfigDataManager.getTableValue("cfg_recharge","Countkey","parameter",operateActivityId,"type",_rechargeType())
            local total = ConfigDataManager.getTableValue("Count_count","total","id",countKey)
            CountManager.count(actor, tonumber(countKey),tonumber(total))
            for i = 1, tonumber(total) do
                string.putIntIntMap(outRewards, config.itemcount, "#", "|")
            end
        end
    end
end

--- 直购关闭
function DirectPurchase.closeActive(mainGroup)
    local allRoleInfos = getallrolesummaryinfos()
    local activeInfo = {}
    if not table.isNullOrEmpty(allRoleInfos) then
        local directId = ConfigDataManager.getTableValue("cfg_OperateActivity_CDM","id","mainGroup",mainGroup,"bugType",BUY_TYPE.FREE_BUY)
        local countKey = ConfigDataManager.getTableValue("cfg_recharge","Countkey","parameter",directId,"type",_rechargeType())
        local specialCondition = ConfigDataManager.getTableValue("cfg_OperateActivity_subActivity","specialCondition","mainGroup",mainGroup,"subType",ACTIVE_TYPE.DIRECT)
        for k, roleInfo in pairs(allRoleInfos) do
            local actor = roleInfo["actor"]
            -- 判断当前玩家有没有另外免费直购
            local item = {}
            local countInfo = CountManager.getCount(actor,countKey)
            if not table.isNullOrEmpty(countInfo) and countInfo.total > countInfo.count and ConditionManager.Check(actor, specialCondition) then
                local itemInfo = ConfigDataManager.getTableValue("cfg_OperateActivity_CDM","itemCount","id",directId)
                local count = countInfo.total - countInfo.count
                for i = 1, count do
                    string.putIntIntMap(item, itemInfo, "#", "|")
                end
                sendconfigmailbyrid(actor,actor:toString(), 900002, item)
            end
        end
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
EventListerTable.registerType("直购礼包", _rechargeType(), _playerDbKey())

RechargeEventListerTable:eventLister(_rechargeType(), "直购礼包", DirectPurchase.rechargeEvent)
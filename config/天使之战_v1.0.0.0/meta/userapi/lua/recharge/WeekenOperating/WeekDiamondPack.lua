--- 钻石礼包
WeekDiamondPack = {}
WeekDiamondPack.__index = WeekDiamondPack

local this = {}

local function _rechargeType()
    return "188"
end


local BUY_TYPE = {
    NOE_BUY = 2, -- 一键购买
    FREE_BUY = 3 -- 免费购买
}


--- 请求充值档位信息
function WeekDiamondPack.reqRechargeAction(actor,mainGroup)
    -- 判断当前主活动是否开启了子直购活动
    local allActivityInfo = {}
    local operateActivityTable = ConfigDataManager.getList("cfg_DiamondPack")
    if table.isNullOrEmpty(operateActivityTable) then
        return allActivityInfo
    end
    for _, config in pairs(operateActivityTable) do
        if tonumber(mainGroup) == tonumber(config.maingroup) then
            local diamondPackId = config.id
            local itemCount = config.reward
            local rewardsMap = string.toIntIntMap(itemCount, "#", "|")
            local activityInfo = {
                diamondPackId = diamondPackId,
                itemInfo = rewardsMap
            }
            table.insert(allActivityInfo,activityInfo)
        end
    end
    return allActivityInfo
end

--- 触发充值
function WeekDiamondPack.reqAction(actor, rechargeType, action, reqParameter)
    local directGiftId = reqParameter["id"]
    local config = ConfigDataManager.getById("cfg_DiamondPack", directGiftId)
    local count = CountManager.getCount(actor, config.countkey)
    local total = ConfigDataManager.getTableValue("Count_count","total","id",config.countkey)
    if count.count >= tonumber(total) then
        return
    end
    local mainGroup = WeekActives.getCurrentMainGroup(actor)
    local cfgMainGroup = config.maingroup
    if mainGroup ~= tonumber(cfgMainGroup) then
        return
    end
    if tonumber(config.type) == BUY_TYPE.NOE_BUY then
        -- 一键购买
        local operateActivity = ConfigDataManager.getTable("cfg_DiamondPack","mainGroup",mainGroup)
        if not table.isNullOrEmpty(operateActivity) then
            for _, config in pairs(operateActivity) do
                local operateActivityId = config.id
                local count = CountManager.getCount(actor, tonumber(config.countkey))
                if tonumber(operateActivityId) ~= tonumber(directGiftId) then
                    if tonumber(config.type) ~= BUY_TYPE.FREE_BUY and count.count > 0 then
                        return
                    end
                end
            end
        end
        if this.costDiamond(actor,config.diamond,config.money) then
            local outRewards = {}
            this.oneBug(actor,outRewards,operateActivity)
            Bag.sendRewards(actor, outRewards, ItemActionProxy.WEEKDIAMONDPACK)
        end
    else
        if this.costDiamond(actor,config.diamond,config.money) then
            local reward_str = config.reward
            if not string.isNullOrEmpty(reward_str) then
                Bag.sendRewards4String(actor, reward_str, ItemActionProxy.WEEKDIAMONDPACK..config.id)
            end
            CountManager.count(actor, config.countkey,1)
        end
    end
    -- 发送界面信息数据
    WeekActives.openSubActive(actor,{
        subType = ACTIVE_TYPE.DIAMOND_PACK
    })
end

-- 消耗钻石
function this.costDiamond(actor,type,count)
    if string.isNullOrEmpty(count) then
        return true
    end
    local money = tonumber(count)
    if money == 0 then
        return true
    end
    if tonumber(type) == 2 then
        local haveBindCount = getbagitemcountbyid(actor,10050001)
        if money <= haveBindCount then
            removeitemfrombag(actor,10050001,money)
            return true
        else
            local haveCount = getbagitemcountbyid(actor,10040001)
            if haveCount + haveBindCount >= money then
                removeitemfrombag(actor,10050001,haveBindCount)
                local needCount = money - haveBindCount
                removeitemfrombag(actor,10040001,needCount)
                return true
            else
                return false
            end
        end
    else
        local haveCount = getbagitemcountbyid(actor,10040001)
        if haveCount >= money then
            removeitemfrombag(actor,10040001,money)
        end
        return false
    end
end


-- 一键购买
function this.oneBug(actor,outRewards,operateActivity)
    if not table.isNullOrEmpty(operateActivity) then
        for _, config in pairs(operateActivity) do
            if tonumber(config.type) ~= BUY_TYPE.FREE_BUY then
                local total = ConfigDataManager.getTableValue("Count_count","total","id",config.countkey)
                CountManager.count(actor, tonumber(config.countkey),tonumber(total))
                for i = 1, tonumber(total) do
                    string.putIntIntMap(outRewards, config.reward, "#", "|")
                end
            end
        end
    end
end

--- 直购关闭
function WeekDiamondPack.closeActive(mainGroup)
    local diamondPackTable = ConfigDataManager.getTable("cfg_DiamondPack","mainGroup",mainGroup,"type",BUY_TYPE.FREE_BUY)
    if table.isNullOrEmpty(diamondPackTable) then
        return
    end
    local allRoleInfos = getallrolesummaryinfos()
    local diamondPack = diamondPackTable[1]
    if not table.isNullOrEmpty(allRoleInfos) then
        local specialCondition = ConfigDataManager.getTableValue("cfg_OperateActivity_subActivity","specialCondition","mainGroup",mainGroup,"subType",ACTIVE_TYPE.DIRECT)
        for k, roleInfo in pairs(allRoleInfos) do
            local actor = roleInfo["actor"]
            -- 判断当前玩家有没有另外免费直购
            local item = {}
            local countInfo = CountManager.getCount(actor,diamondPack.countkey)
            if not table.isNullOrEmpty(countInfo) and countInfo.total > countInfo.count and ConditionManager.Check(actor, specialCondition) then
                local itemInfo = diamondPack.reward
                local count = countInfo.total - countInfo.count
                for i = 1, count do
                    string.putIntIntMap(item, itemInfo, "#", "|")
                end
                -- 
                sendconfigmailbyrid(actor,actor:toString(), 900004, item)
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
EventListerTable.registerType("幸运周末钻石礼包", _rechargeType())

RechargeMessageEventListerTable:eventLister(_rechargeType(), "幸运周末钻石礼包", WeekDiamondPack.reqAction)
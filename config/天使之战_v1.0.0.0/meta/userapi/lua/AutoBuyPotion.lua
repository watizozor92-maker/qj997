AutoBuyPotionScript = {}
local __this = {}
local _buySetting = "T$AUTO_BUY_POTION_SETTING"
-- 脚本常量
local scriptConst = {
    -- 两个买药的组,先写死
    HP_GROUP = 1,
    MP_GROUP = 2,


    -- 自动买药开启
    AUTO_BUY_ON = 1,
    -- 随身商店开启
    WITH_STORE = 1,

    coinType = 1,

    -- 最大递归深度, 大于配置表行数
    maxRecurDepth = 60
}

local _getOption = function(actor)
    return getplaydef(actor, _buySetting) or {}
end
local _setOption = function(actor, option)
    setplaydef(actor, _buySetting, option)
end

function AutoBuyPotionScript.setBuyOption(actor, option, ignore)
    if table.isEmpty(option) then
        _setOption(actor, option)
        return
    end
    if not ignore then
        local isOn, _ = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.AUTO_BUY_MEDICINE)
        if not isOn then
            return
        end
    end
    local replica = table.copy(option)
    for index, id in ipairs(replica) do
        local config = ConfigDataManager.getById("cfg_Portableshop", id)
        if table.isEmpty(config) then
            option[index] = nil
        else
            option[index] = tonumber(id)
        end
    end
    _setOption(actor, option)

    AutoBuyPotionScript.autoBuyPotions(actor)
end

function AutoBuyPotionScript.sendBuyOption(actor)
    local option = _getOption(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_AUTO_BUY_POTION_SETTINGS, option)
end

function AutoBuyPotionScript.getOption(actor)
    return _getOption(actor)
end

function AutoBuyPotionScript.coinChange(actor, cfgId)
    local type = ConfigDataManager.getTableValue("cfg_item", "type", "id", cfgId)
    local equalItem = ConfigDataManager.getTableValue("cfg_item", "bindequalitem", "id", cfgId)
    if tonumber(type) == scriptConst.coinType then
        local cfgs = ConfigDataManager.getList("cfg_Portableshop")
        if table.isNullOrEmpty(cfgs) then
            return
        end
        for _, cfg in ipairs(cfgs) do
            local price = cfg.price
            if string.contains(price, cfgId) or (not string.isNullOrEmpty(equalItem) and string.contains(price, equalItem)) then
                AutoBuyPotionScript.autoBuyPotions(actor)
                break
            end
        end
    end
end

-- 根据配置表自动购买等级最大的药品
function AutoBuyPotionScript.autoBuyPotions(actor)
    local options = _getOption(actor)
    if table.isEmpty(options) then
        return
    end

    local portableShopConfigs = ConfigDataManager.getList("cfg_Portableshop")
    if portableShopConfigs == nil or next(portableShopConfigs) == nil then
        return
    end
    local configs = array.deepCopy(portableShopConfigs)
    local hpConfig, hpCanBuyCount, mpConfig, mpCanBuyCount = AutoBuyPotionScript.getPortableShopConfig(actor,
        configs, 1, options)
    if hpConfig == nil and mpConfig == nil then
        return
    end



    if hpConfig ~= nil and hpCanBuyCount > 0 then
        AutoBuyPotionScript.buyPotionByGroup(actor, hpConfig, hpCanBuyCount)
    end
    if mpConfig ~= nil and mpCanBuyCount > 0 then
        AutoBuyPotionScript.buyPotionByGroup(actor, mpConfig, mpCanBuyCount)
    end
end

function AutoBuyPotionScript.buyPotionByGroup(actor, config, canBuyCount)
    local itemId = config["itemid"]
    local hasItemCount = getbagitemcountbyid(actor, itemId) or 0
    -- 判断用不用买
    local autobuy = config["autobuy"]
    local sp = string.split(autobuy, "#")
    local buySthreshold = sp[1]
    local shouldBuyNum = canBuyCount
    if tonumber(hasItemCount) >= tonumber(buySthreshold) then
        return
    end

    local priceInfo = config["price"]
    local info = string.split(priceInfo, "#")
    local costType = info[1]
    local unitPrice = info[2]
    local totalPrice = unitPrice * shouldBuyNum
    __this.printTraceback()
    local hasMoney = getbagitemcountbyid(actor, tonumber(costType))
    if hasMoney < totalPrice then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT334)
        return
    end

    -- 买药
    local result = additemtobag(actor, itemId, shouldBuyNum, 0, 9999, ItemActionProxy.AUTOBUYPOTION)
    if result then
        removeitemfrombag(actor, costType, totalPrice, 0, 9999, '自动购买')
    end
end

-- 根据分组获取买的药品中等级最大的那个config,钱不够了减少购买数量,再不够就买等级低的
function AutoBuyPotionScript.getPortableShopConfig(acotr, portableShopConfigs, depth, option)
    depth = depth or 0
    if depth > scriptConst.maxRecurDepth then
        return nil, 0, nil, 0
    end

    if portableShopConfigs == nil or #portableShopConfigs == 0 or next(portableShopConfigs) == nil then
        return nil, 0, nil, 0
    end

    depth = depth + 1

    local hpConfig = {}
    local mpConfig = {}
    local hpMaxLevel = 0
    local mpMaxLevel = 0

    local level = getbaseinfo(acotr, "level")
    -- 先找到等级最大的两组config
    for _, portableShopConfig in ipairs(portableShopConfigs) do
        local configLevel = portableShopConfig["level"] or 0
        configLevel = configLevel == "" and 0 or configLevel -- 不填等级不限制
        if tonumber(configLevel) <= tonumber(level) then
            local configId = tonumber(portableShopConfig["id"])
            local isEnabled = table.isEmpty(option) or table.contains(option, configId) -- 不设置过滤项不限制
            if isEnabled then
                local group = portableShopConfig["group"]
                if tonumber(group) == scriptConst.HP_GROUP and tonumber(configLevel) >= tonumber(hpMaxLevel) then
                    hpMaxLevel = configLevel
                    hpConfig = portableShopConfig
                elseif tonumber(group) == scriptConst.MP_GROUP and tonumber(configLevel) >= tonumber(mpMaxLevel) then
                    mpMaxLevel = configLevel
                    mpConfig = portableShopConfig
                end
            end
        end
    end
    -- 比较钱,判断是否降低等级
    if next(hpConfig) ~= nil and hpConfig ~= nil and mpConfig ~= nil and next(mpConfig) ~= nil then
        local hpCanBuyCount = tonumber(0)
        local mpCanBuyCount = tonumber(0)
        local hpMoneyType = tonumber(string.split(hpConfig["price"], "#")[1])
        local hpMoneyNum = tonumber(string.split(hpConfig["price"], "#")[2])
        local mpMoneyType = tonumber(string.split(mpConfig["price"], "#")[1])
        local mpMoneyNum = tonumber(string.split(mpConfig["price"], "#")[2])
        local hpShouldBuyNum = tonumber(string.split(hpConfig["autobuy"], "#")[2])
        local mpShouldBuyNum = tonumber(string.split(mpConfig["autobuy"], "#")[2])
        if hpMoneyType == mpMoneyType then
            -- 两个消耗是同一种货币
            local totalPrice = hpMoneyNum * hpShouldBuyNum + mpMoneyNum * mpShouldBuyNum
            __this.printTraceback()
            local hasMoney = getbagitemcountbyid(acotr, hpMoneyType)
            if tonumber(hasMoney) < totalPrice then
                -- 钱不够,尝试随机减少购买数量(先去除)
                local flag = true
                repeat
                    if flag then
                        hpShouldBuyNum = hpShouldBuyNum - 1 >= 1 and hpShouldBuyNum - 1 or 1
                        flag = false
                    elseif not flag then
                        mpShouldBuyNum = mpShouldBuyNum - 1 >= 1 and mpShouldBuyNum - 1 or 1
                        flag = true
                    end

                    totalPrice = hpMoneyNum * hpShouldBuyNum + mpMoneyNum * mpShouldBuyNum
                    if tonumber(hasMoney) >= totalPrice then
                        -- 说明可以通过减少数量来满足条件,两个物品都不用降级
                        hpCanBuyCount = hpShouldBuyNum
                        mpCanBuyCount = mpShouldBuyNum
                        return hpConfig, hpCanBuyCount, mpConfig, mpCanBuyCount
                    end
                until hpShouldBuyNum == 1 and mpShouldBuyNum == 1

                -- logInfo("减少数量钱也不够,尝试买低级药")
                -- 随机降低某个药品的等级
                local random = math.random(0, 1)
                if random == 0 then
                    -- portableShopConfigs中去除当前高等级Config
                    AutoBuyPotionScript.filterPortableShopConfigs(portableShopConfigs, hpConfig)
                elseif random == 1 then
                    AutoBuyPotionScript.filterPortableShopConfigs(portableShopConfigs, mpConfig)
                end
                return AutoBuyPotionScript.getPortableShopConfig(acotr, portableShopConfigs, depth, option)
            end
        else
            -- 两个消耗不同的货币
            __this.printTraceback()
            local hasHpMoney = getbagitemcountbyid(acotr, hpMoneyType)
            __this.printTraceback()
            local hasMpMoney = getbagitemcountbyid(acotr, mpMoneyType)
            local hpTotalPrice = hpMoneyNum * hpShouldBuyNum
            local mpTotalPrice = mpMoneyNum * mpShouldBuyNum

            local hpCanDecreaseToBuy = false -- 是否可以通过减少购买hp数量完成购买
            local mpCanDecreaseToBuy = false -- 是否可以通过减少购买mp数量完成购买

            if tonumber(hasHpMoney) < hpTotalPrice then
                repeat
                    hpShouldBuyNum = hpShouldBuyNum - 1
                    hpTotalPrice = hpMoneyNum * hpShouldBuyNum
                    if tonumber(hasHpMoney) >= hpTotalPrice then
                        hpCanBuyCount = hpShouldBuyNum
                        hpCanDecreaseToBuy = true
                        break
                    end
                until hpShouldBuyNum == 1
                if not hpCanDecreaseToBuy then
                    -- hp减少失败,尝试降低hp等级
                    AutoBuyPotionScript.filterPortableShopConfigs(portableShopConfigs, hpConfig)
                end
            else
                hpCanDecreaseToBuy = true
            end
            if tonumber(hasMpMoney) < mpTotalPrice then
                repeat
                    mpShouldBuyNum = mpShouldBuyNum - 1
                    mpTotalPrice = mpMoneyNum * mpShouldBuyNum
                    if tonumber(hasMpMoney) >= mpTotalPrice then
                        mpCanBuyCount = mpShouldBuyNum
                        mpCanDecreaseToBuy = true
                        break
                    end
                until mpShouldBuyNum == 1
                if not mpCanDecreaseToBuy then
                    -- mp减少失败,尝试降低mp等级
                    AutoBuyPotionScript.filterPortableShopConfigs(portableShopConfigs, mpConfig)
                end
            else
                mpCanDecreaseToBuy = true
            end

            if not hpCanDecreaseToBuy or not mpCanDecreaseToBuy then
                -- 至少有一个不能通过减少购买数量完成购买,只能降级处理
                return AutoBuyPotionScript.getPortableShopConfig(acotr, portableShopConfigs, depth, option)
            end
        end
        -- 到了这里说明购买数量可以满足或者当前配置等级已经满足
        return hpConfig, hpShouldBuyNum, mpConfig, mpShouldBuyNum
    elseif next(hpConfig) ~= nil and hpConfig ~= nil then
        local hpMoneyType = tonumber(string.split(hpConfig["price"], "#")[1])
        local hpMoneyNum = tonumber(string.split(hpConfig["price"], "#")[2])
        local hpShouldBuyNum = tonumber(string.split(hpConfig["autobuy"], "#")[2])
        local totalPrice = hpMoneyNum * hpShouldBuyNum
        __this.printTraceback()
        local hasMoney = getbagitemcountbyid(acotr, hpMoneyType)

        local canBuyCount = tonumber(hpShouldBuyNum)
        local canDecreaseToBuy = false
        if tonumber(hasMoney) < totalPrice then
            -- 尝试减少购买hp数量
            repeat
                hpShouldBuyNum = hpShouldBuyNum - 1
                totalPrice = hpMoneyNum * hpShouldBuyNum
                if tonumber(hasMoney) >= totalPrice then
                    -- 可以通过减少购买hp数量完成购买,不用降级
                    canBuyCount = hpShouldBuyNum
                    canDecreaseToBuy = true
                    break
                end
            until hpShouldBuyNum == 1

            if not canDecreaseToBuy then
                -- 不能减少hp购买数量来满足购买,降级处理
                AutoBuyPotionScript.filterPortableShopConfigs(portableShopConfigs, hpConfig)
                return AutoBuyPotionScript.getPortableShopConfig(acotr, portableShopConfigs, depth, option)
            end
        end
        return hpConfig, canBuyCount, nil, 0
    elseif next(mpConfig) ~= nil and mpConfig ~= nil then
        local mpMoneyType = tonumber(string.split(mpConfig["price"], "#")[1])
        local mpMoneyNum = tonumber(string.split(mpConfig["price"], "#")[2])
        local mpShouldBuyNum = tonumber(string.split(mpConfig["autobuy"], "#")[2])
        local totalPrice = mpMoneyNum * mpShouldBuyNum
        __this.printTraceback()
        local hasMoney = getbagitemcountbyid(acotr, mpMoneyType)
        local canBuyCount = tonumber(mpShouldBuyNum)
        local canDecreaseToBuy = false
        if tonumber(hasMoney) < totalPrice then
            -- 尝试减少购买mp数量
            repeat
                mpShouldBuyNum = mpShouldBuyNum - 1
                totalPrice = mpMoneyNum * mpShouldBuyNum
                if tonumber(hasMoney) >= totalPrice then
                    -- 可以通过减少购买mp数量完成购买,不用降级
                    canBuyCount = mpShouldBuyNum
                    canDecreaseToBuy = true
                    break
                end
            until mpShouldBuyNum == 1

            if not canDecreaseToBuy then
                -- 不能减少mp购买数量来满足购买,降级处理
                AutoBuyPotionScript.filterPortableShopConfigs(portableShopConfigs, mpConfig)
                return AutoBuyPotionScript.getPortableShopConfig(acotr, portableShopConfigs, depth, option)
            end
        end
        return nil, 0, mpConfig, canBuyCount
    end

    return nil, 0, nil, 0
end

-- 过滤掉等级高,买不起的config
function AutoBuyPotionScript.filterPortableShopConfigs(portableShopConfigs, config)
    for i = #portableShopConfigs, 1, -1 do
        if portableShopConfigs[i] == config then
            table.remove(portableShopConfigs, i)
            break
        end
    end
end


function AutoBuyPotionScript.findOptions(actor)
    local options = {}
    local hpConfigs = ConfigDataManager.getTable("cfg_Portableshop", "group", scriptConst.HP_GROUP)
    local mpConfigs = ConfigDataManager.getTable("cfg_Portableshop", "group", scriptConst.MP_GROUP)

    local level = getbaseinfo(actor, "level")
    local maxLevel = 0
    local id
    for i = 1, #hpConfigs do
        local hpConfig = hpConfigs[i]
        local hpLevel = tonumber(hpConfig.level)
        if hpLevel <= level and hpLevel > maxLevel then
            maxLevel = hpLevel
            id = tonumber(hpConfig.id)
        end
    end
    table.insert(options, id)
    maxLevel = 0
    for j = 1, #mpConfigs do
        local mpConfig = mpConfigs[j]
        local mpLevel = tonumber(mpConfig.level)
        if mpLevel <= level and mpLevel > maxLevel then
            maxLevel = mpLevel
            id = tonumber(mpConfig.id)
        end
    end
    table.insert(options, id)
    return options
end

function __this.printTraceback()
    if 1 == 1 then
        return
    end
    gameDebug.printTraceback("自动买药")
end


-- ====================================测试========================================
function testautobuypotion(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        AutoBuyPotionScript.findOptions(actor)
    end
end
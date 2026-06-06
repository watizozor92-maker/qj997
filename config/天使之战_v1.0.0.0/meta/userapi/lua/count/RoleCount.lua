RoleCount = {}
RoleCount.__index = RoleCount
local this = {}
local CountResetType = {
    DAY = 1,
    LIFE = 2,
    WEEK = 3,
    MONTH = 4,
}
local BuyLimit = {
    NO = 0,
    DAY = 1,
    WEEK = 2,
    MONTH = 3,
    LIFE = 4,
}
CountType = {
    ITEM_USE_NUM = { CountType = 1001, CountResetType = CountResetType.DAY, Desc = "道具使用次数" },
    PARTNER_DISPATCH_FLUSH = { CountType = 1002, CountResetType = CountResetType.DAY, Desc = "伙伴-派遣" },
    DISPATCH_VIP_FREE_FLUSH = { CountType = 1003, CountResetType = CountResetType.DAY, Desc = "伙伴-派遣-VIP已使用免费次数" },
    ROLE_RECHARGE_DIAMOND_FIRST_COUNT = { CountType = 42, CountResetType = CountResetType.LIFE, Desc = "玩家首次购买钻石" },
    USER_ITEM_LIFE = { CountType = 1004, CountResetType = CountResetType.LIFE, Desc = "使用道具-整个周期" },
    FIRST_KILL_PERSONAL = { CountType = 1005, CountResetType = CountResetType.LIFE, Desc = "个人怪物首杀" },

    BUY_SHOP_MALL_DAY = { CountType = 2001, CountResetType = CountResetType.DAY, Desc = "购买道具次数-每日" },
    BUY_SHOP_MALL_WEEK = { CountType = 2002, CountResetType = CountResetType.WEEK, Desc = "购买道具次数-每星期" },
    BUY_SHOP_MALL_MONTH = { CountType = 2003, CountResetType = CountResetType.MONTH, Desc = "购买道具次数-每月" },
    BUY_SHOP_MALL_LIFE = { CountType = 2004, CountResetType = CountResetType.LIFE, Desc = "购买道具次数-永久" },
    ACTIVITY_LEFT_COUNT = { CountType = 3001, CountResetType = CountResetType.LIFE, Desc = "日常活动剩余次数-自定义刷新" },

    EQUIP_FEED_COUNT = { CountType = 1006, CountResetType = CountResetType.LIFE, Desc = "装备喂养的次数" }
}

--- func desc 重置指定次数的计数器
---@param actor any
---@param countType number 重置类型
---@param key any 重置键
---@param count number 重置次数, 负数表示重置所有次数
---@param time number 时间戳,毫秒值, 不传不更新时间
function RoleCount.resetCount(actor, countType, key, count, time)
    for k, v in pairs(CountType) do
        local type = v.CountType
        if type == tonumber(countType) then
            resetrolecount(actor, type, key, count, time)
            return
        end
    end
end

--- func desc 重置指定职业商品终身限购计数器
---@param actor any
function RoleCount.resetCareerLifeShopCount(actor, career)
    local configs = ConfigDataManager.getTable("cfg_shopMall", "limitbuy", BuyLimit.LIFE)
    for _, config in ipairs(configs) do
        local occupation = config.occupation
        if not string.isNullOrEmpty(occupation) then
            local info = string.toIntIntMap(occupation,"#","|")
            for baseCareer, level in pairs(info) do
                if baseCareer == tonumber(career) then
                    resetrolecount(actor, CountType.BUY_SHOP_MALL_LIFE.CountType, config.id, -1, getbaseinfo(actor, "now"))
                end
            end
        end
    end
end

--- func desc
---@param actor any
function countteset(actor)
    -- RoleCount.resetCount(actor, CountType.BUY_SHOP_MALL_LIFE.CountType, 1033018, 1)
    RoleCount.resetCareerLifeShopCount(actor, 1)
end

local ItemAction = {
    -- =============外置ItemAction=================
    BIG_SECRET_REALM_REWARD = "大天使秘境通关奖励",
    TURNTABLE_RAFFLE_REWARDS = "轮盘抽奖奖励",
    TURNTABLE_RAFFLE_ACCUMULATE_REWARDS = "轮盘抽奖累次奖励",
    CAREER_TRANSFER_ITEM_SEND = "职业转换道具发放",

    GM="GM-操作",
    FRIEND = "好友",
    FRUIT = "果实",
    GOLDTASK = "黄金任务",
    ITEM_COMPOSE = "物品合成",
    LEVEL_REWARD = "等级奖励",
    OFFLINE_HANGUP = "离线挂机",
    BLOOD_CASTLE = "血色城堡",
    DEMON_SQUARE = "恶魔广场",
    SECRET_REALM_BOSS = "秘境boss",
    GUILD_BOSS = "战盟BOSS",
    UNION_TASK = "战盟任务",
    FLUORESCENT_STONE = "荧石",
    DAILY_LOTTERY = "每日抽奖",
    EQUIPMENT_FIRST_SHOW = "装备首曝",
    TREASURE_MERCHANT = "宝箱商人",
    RECHARGE_REWARD = "充值奖励",
    FIRST_RECHARGE_GIFT = "首充礼包",


    -- ANGELBENEFIT = "天使福利",
    ANGELWEAPON = "天使武器",
    AUTOBUYPOTION = "自动买药",
    -- BOSSBOUNTY = "boss悬赏",
    GOLDFIRSTKILL = "黄金首杀",
    SEVENRECEIVE = "七日连充",
    SEVENLOGIN = "七日登录",
    DAILYACTIVITY = "每日任务",
    ITEMRECYCLING = "物品回收",
    MONSTER_HUNT = "猎魔",
    COMBO_REWARD = "连击奖励",
    WOLF_SOUL = "狼魂要塞",
    DAILYRECHARGE = "每日累充",
    OPENSEVERRECHARGE = "开服连充",
    VIPPRIVILEGE = "VIP特权",
    DAILYGIVEAWAY = "每日赠送",
    OPERATEACTIVITY = "运营活动",
    DIAMONDPACK = "钻石礼包",
    WEEKACCUMULATEDRECHARGE = "周末累充",
    WEEKDIAMONDPACK = "周末钻石礼包",
    WINGS = "翅膀任务",
    RANDOMCHEST = "随机宝箱",
    NPC_INTEGRAL_EXCHANGE = "NPC积分兑换",
    FACE_TRADE = "面对面交易",
    ITEM_SYNTHESIS = "道具合成",

}

RemoveItemAction = {
    RED_NAME_PENALTY = "红名掉落惩罚",
}


ItemActionType = {
    inner = 1,
    outer = 2
}
-- eg: additemtobag(actor, cfgId, count, 0, 9999, ItemActionProxy.FRUIT)
ItemActionProxy = {}

local function isValid(value)
    local configs = ConfigDataManager.getTable("cfg_SourceEnumeration", "source", value)
    if table.isEmpty(configs) then
        return false
    end
    return true
end

local itemActionMt = {
    __index = function(t, key)
        -- 检查键是否存在
        local value = rawget(ItemAction, key)
        if value == nil then
            error(string.format("ItemAction中不存在常量: %s", tostring(key)))
        end

        -- 校验值是否在配置表中存在
        if not isValid(value) then
            error(string.format("来源配置表中不存在该值: %s (%s)", tostring(key), tostring(value)))
            value = "不合法来源:" .. key
        end
        return value
    end,

    __newindex = function(t, key, value)
        gameDebug.error("ItemAction是只读表，不允许修改", key)
    end,

    __pairs = function(t)
        return pairs(ItemAction)
    end
}
setmetatable(ItemActionProxy, itemActionMt)

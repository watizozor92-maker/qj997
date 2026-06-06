NpcShopMall = {}

function buynpcshopgoodsbefore(acotr,shopId, goodId, count)
    return NpcShopMall.buyGoodsBefore(acotr, shopId, goodId, count)
end

function NpcShopMall.buyGoodsBefore(acotr, shopId, goodId, count)
    local config = ConfigDataManager.getById("cfg_npcShop", goodId)
    local result = ConditionManager.Check(acotr, config.bugcondition)
    gameDebug.assertPrint(result, "玩家购买NPC商店道具，不满足条件", acotr:toString(), goodId)
    return result
end


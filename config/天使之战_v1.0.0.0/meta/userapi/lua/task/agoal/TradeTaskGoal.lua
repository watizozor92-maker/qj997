
TradeTaskGoal = {}

---@see 交易行上架商品
function TradeTaskGoal.FlushTradeLineUpGoods(_, _, goal_id, goal_count, param)
    return CommonTaskGoal.CheckItemIdsAndTypeByGoodsId(goal_id, goal_count, param)
end

---@see 商城购买商品
function TradeTaskGoal.FlushMallBuyGoods(_, _, goal_id, goal_count, param)
    local item_id = ConfigDataManager.getTableValue("cfg_shopMall", "itemid", "id", param)
    return CommonTaskGoal.CheckItemIdsAndTypeByGoodsId(goal_id, goal_count, item_id)
end

---@see 从NPC商店购买指定道具
function TradeTaskGoal.FlushNpcMallBuyGoods(_, _, goal_id, goal_count, param)
    return CommonTaskGoal.CheckItemIdsAndTypeByGoodsId(goal_id, goal_count, param)
end


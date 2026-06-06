NpcChest = {
}
local this = {}
local shopOpenId = 25002 -- 商店开启等级全局表id

local PriceInfo = {}
PriceInfo.__index = PriceInfo
function PriceInfo:new(cfgId, count, bind)
    local instance = {
        cfgId = cfgId,
        count = count,
        bind = bind
    }
    setmetatable(instance, self)
    return instance
end

-- 初始化全局数据
function NpcChest.initGlobalGoods()
    local goodsList = ConfigDataManager.getList("cfg_npcchest")
    if table.isNullOrEmpty(goodsList) then
        error("袖珍罐子商店不存在商品")
        return
    end
    local globalGoods = {}
    for i, item in ipairs(goodsList) do
        local shopId = tonumber(item.shopid)
        local goosByShopId = globalGoods[shopId] or {}

        local goods = {}
        goods.id = tonumber(item.id)
        goods.cfgId = tonumber(string.splitByAll(item.itemid, "#")[1])
        goods.count = tonumber(string.splitByAll(item.itemid, "#")[2])
        local price = item.price
        local weightMap = this.convert(price)
        local randomItem = this.doRandom(weightMap)
        if randomItem then
            goods.costType = randomItem.cfgId
            goods.price = math.floor(randomItem.count)
            goods.bind = randomItem.bind
            goods.conditions = item.conditions
            goosByShopId[goods.id] = goods
            globalGoods[shopId] = goosByShopId
        end
    end
    this.saveGlobalGoods(globalGoods)
end

function this.saveBuyRecord(actor, data)
    setplaydef(actor, "T$npcChestBuyRecord", data)
end

function this.getBuyRecord(actor)
    return getplaydef(actor, "T$npcChestBuyRecord") or {}
end

function this.saveGlobalGoods(data)
    setsysvar("G$npcChestGoods", data)
end

function this.getGlobalGoods()
    return getsysvar("G$npcChestGoods") or {}
end

-- 获取商品列表
function NpcChest.sendShopGoodsInfoList(actor, msgData)
    local sendList = {}
    local shopId = msgData.shopId
    if shopId <= 0 then
        this.toClient(actor, sendList)
        return
    end

    local openLv = ConfigDataManager.getTableValue("cfg_global", "value", "id", shopOpenId)
    local lv = getbaseinfo(actor, "level")
    if lv < tonumber(openLv) then
        tipinfo(actor, "等级不足")
        this.toClient(actor, sendList)
        return
    end
    local globalGoods = this.getGlobalGoods()
    local shopGoodsList = globalGoods[shopId] or {}
    local newGoods = this.filterGoods(actor, shopGoodsList)
    -- lg("检验条件后的商品列表", newGoods)
    if table.isNullOrEmpty(newGoods) then
        this.toClient(actor, sendList)
        return
    end
    local record = this.getBuyRecord(actor)
    local recordByShop = record[shopId] or {}


    for id, goods in pairs(newGoods) do
        local alreadyBuyNum = this.getAlreadyBuyNum(id, recordByShop)
        -- lg("goodsId", id, "buyNum", alreadyBuyNum)
        local sendGoods = this.buildSendGoods(goods, alreadyBuyNum)
        table.insert(sendList, sendGoods)
    end
    this.toClient(actor, sendList)
end

function this.toClient(actor, msg)
    -- lg("发送商品列表", msg)
    sendluamsg(actor, LuaMessageIdToClient.RES_NPC_CHEST_GOODS_INFO, msg)
end

-- 购买商品
function NpcChest.buyGoods(actor, msgData)
    local shopId  = msgData.shopId
    local goodsId = msgData.goodsId
    local count   = msgData.count
    if count <= 0 then
        return
    end
    local globalGoods = this.getGlobalGoods()
    local shopGoodsList = globalGoods[shopId] or {}
    local goods = shopGoodsList[goodsId] or {}
    -- lg("购买商品", goodsId, goods)
    if table.isNullOrEmpty(goods) or table.isNullOrEmpty(shopGoodsList) then
        return
    end
    if tonumber(goods.count) ~= count then
        tipinfo(actor, "购买数量不合法")
        return
    end
    local totalPrice = 0
    local unitPrice = goods.price
    totalPrice = unitPrice * count
    -- lg("购买商品价格", totalPrice)
    local costType = goods.costType

    local enough = false
    local bind = goods.bind
    if bind == 1 then
        enough = Bag.checkItemWithBind(actor, costType, totalPrice)
    else
        enough = Bag.checkItem(actor, costType, totalPrice)
    end
    if not enough then
        tipinfo(actor, "货币不足")
        return
    end

    Bag.costBind(actor, costType, totalPrice, "宝箱商人")
    Bag.sendRewards(actor, { [goods.cfgId] = goods.count }, ItemActionProxy.TREASURE_MERCHANT)
    -- this.excHorseLamp(actor, { [goods.cfgId] = goods.count })

    local record = this.getBuyRecord(actor)
    local recordByShop = record[shopId] or {}
    local alreadyBuyNum = this.getAlreadyBuyNum(goods.id, recordByShop)
    this.saveBuyRecords(actor, shopId, count, goods, alreadyBuyNum)
end

-- 存储购买记录
function this.saveBuyRecords(actor, shopId, count, goods, alreadyBuyNum)
    local buyRecords = this.getBuyRecord(actor)
    local buyRecordMap = buyRecords[shopId] or {}
    local id = goods.id
    local buyRecord = buyRecordMap[id] or { id = id, buyNum = 0 }
    buyRecord.buyNum = alreadyBuyNum + count
    buyRecordMap[id] = buyRecord
    buyRecords[shopId] = buyRecordMap
    -- lg("购买记录", buyRecords)
    this.saveBuyRecord(actor, buyRecords)
end

function this.convert(source)
    local priceInfoMap = {}
    if not source or string.trim(source) == "" then
        return priceInfoMap
    end

    local outerArray = string.splitByAll(source, "|")

    for _, o in ipairs(outerArray) do
        local innerArray = string.splitByAll(o, "#")
        local cfgId = tonumber(innerArray[1])
        local count = tonumber(innerArray[2])
        local bind = tonumber(innerArray[3])
        local weight = tonumber(innerArray[4])

        local priceInfo = PriceInfo:new(cfgId, count, bind)

        priceInfoMap[priceInfo] = weight
    end

    return priceInfoMap
end

function this.doRandom(weightMap)
    local allWeight = 0
    if not weightMap or next(weightMap) == nil then
        return nil
    end

    for _, weight in pairs(weightMap) do
        allWeight = allWeight + weight
    end

    if allWeight == 0 then
        return nil
    end

    local randomWeight = math.random(1, allWeight)
    for key, weight in pairs(weightMap) do
        randomWeight = randomWeight - weight
        if randomWeight <= 0 then
            return key
        end
    end
    return nil
end

function this.filterGoods(actor, goodsMap)
    local newGoodsMap = {}

    for id, goods in pairs(goodsMap) do
        local conditions = goods.conditions
        if conditions and #conditions > 0 then
            local result = checkcondition(actor, conditions)
            if tonumber(result) ~= 1 then
                goto continue
            end
        end
        newGoodsMap[id] = goods
        ::continue::
    end
    return newGoodsMap
end

function this.getAlreadyBuyNum(goodsId, recordByShop)
    local buyNum = 0
    if table.isNullOrEmpty(recordByShop) then
        return buyNum
    end
    local record = recordByShop[goodsId]
    if record then
        buyNum = record.buyNum
    end
    return buyNum
end

function this.buildSendGoods(goods, alreadyBuyNum)
    local item = {}
    item.cfgId = goods.cfgId
    item.unitPrice = goods.price
    item.bind = goods.bind
    item.coinType = goods.costType
    item.count = goods.count
    item.id = goods.id
    return item
end

function this.excHorseLamp(actor, itemMap)
    if table.isNullOrEmpty(itemMap) then
        return
    end
    local name = getbaseinfo(actor, "rolename")
    for cfgId, count in pairs(itemMap) do
        local item = ConfigDataManager.getById("cfg_item", cfgId)
        if not table.isNullOrEmpty(item) then
            local itemName = item.name
            local noticeId = item.runninghorselamp
            if #noticeId > 0 then
                noticeTip.noticeinfo(actor, noticeId, name, itemName)
            end
        end
    end
end

function initchest(actor)
    NpcChest.initGlobalGoods()
end

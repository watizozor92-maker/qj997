-- 新的交易行系统 无跨服
-- ==================== 领域层 (Domain Layer) ====================
TRADE_WAY = {
    GARD_BOSS = 1,  -- 战盟boss
    SIEGE = 2,      -- 攻城战
    UNION = 3,      -- 战盟
    WORLD_UP = 4,   -- 世界上架
    SYSTEM_UP = 5,  -- 系统上架
    UNION_FLOW = 6, -- 战盟流拍
    STALL = 7,      -- 面对面商店
}

TRADE_RECORD_TYPE = {
    PREORDER = 0, -- 预购
    PURCHASE = 1, -- 购买
    SALE = 2,     -- 售出
}

SEARCH_TYPE = {
    ALL = 1,
    PUBLISHING = 2,
    PRE_ORDER = 3,
}

TRADE_CAPACITY_GLOBAL_ID = 8001
local TRADE_GOODS_RECORD_UPPER_LIMIT = 80

ROLE_TRADE_GOODS_RECORD = "T$tradeWorldRecord"
ROLE_TRADE_PRE_GOODS = "T$tradeWorldPre"



local this = {}

---@class TradeService 交易行服务类
---@field listItem function 上架
---@field delistedGood function 下架
---@field getWorldTradeRecord function 获取交易记录
---@field buyGood function 购买
---@field preWorldGoods function 预购
---@field getWorldMyListing function 获取自己的上架记录
---@field flushList function 刷新商品-公示、预购、下架等
---@field getListingGoods function 搜索商品
TradeService = {}




--- @class TradeListRequest 上架道具请求DTO
TradeListRequest = {}
TradeListRequest.__index = TradeListRequest
function TradeListRequest.new(msgData)
    local instance = {
        itemId = string.tonumber(msgData.id),         --道具唯一ID
        itemCfgId = tonumber(msgData.itemcfgid),      --上架道具配置Id
        count = tonumber(msgData.count),              --上架道具数量
        listingPrice = tonumber(msgData.listingprice),
        coinType = tonumber(msgData.money),           --货币类型
        bagIndex = string.tonumber(msgData.bagindex), --背包索引
    }
    setmetatable(instance, TradeListRequest)
    return instance
end

---@class TradeGoodEntity 上架道具实体信息
---@field itemCfgId number 商品配置Id
---@field itemId number 商品Id
---@field itemName string 商品名字
---@field entries table 词条信息
---@field entrySize number 词条属性数量
---@field entryNums table 筛选词条编号
---@field appendLv number 追加等级
---@field strengthLv number 强化等级
---@field grade number 品质
---@field ownerId string 商品所属人Id
---@field count number 商品数量
---@field unitPrice number 商品单价
---@field totalPrice number 商品总价
---@field job table 职业
---@field coinType number 货币类型
---@field publicityTime number 公示时间
---@field upShelfDuration number 竞拍时间
---@field tax table 税率
---@field subType number 商品子类型
---@field type number 商量类型
---@field preOrder table 预购人员Id列表
---@field publicityStatue boolean 是不是公示期间
---@field listingTime number 上架时间
---@field serverId number 服务器ID
TradeGoodEntity = {}
TradeGoodEntity.__index = TradeGoodEntity
function TradeGoodEntity.new()
    local instance = {}
    setmetatable(instance, TradeGoodEntity)
    return instance
end

---@class TradeSearchRequest 交易行请求DTO
---@field searchType number 1-全部，2-公式，3-预购
---@field filters table 筛选条件，键值对类型
---@field sort table 排序条件，多条件，list类型
---@field pageParam table 分页参数，页码、数量


---@class TradeGDataService 交易行全局数据服务类
TradeGDataService = {}
TradeGDataService.__index = TradeGDataService
TradeGDataService.tableName = "trade_good_info"
function TradeGDataService.set(id, entity)
    local serverId = getbaseinfo("serverid")
    local tableName = TradeGDataService.tableName .. "_" .. serverId
    return gset(tableName, id, entity)
end

function TradeGDataService.query(sql)
    return gquery(sql)
end

function TradeGDataService.queryAll()
    local tableName = TradeGDataService.getTableName()
    local sql = "select * from " .. tableName .. " order by listingTime asc, itemId asc"
    return TradeGDataService.query(sql)
end

function TradeGDataService.delete(id)
    local serverId = getbaseinfo("serverid")
    local tableName = TradeGDataService.tableName .. "_" .. serverId
    info("交易行商品移除，itemId:" .. id)
    return gdel(tableName, id)
end

function TradeGDataService.getTableName()
    local serverId = getbaseinfo("serverid")
    local tableName = TradeGDataService.tableName .. "_" .. serverId
    return tableName
end

---@param searchRequest TradeSearchRequest
function TradeGDataService.queryListByReq(searchRequest)
    local tableName = TradeGDataService.getTableName()
    local whereClauses = {}
    local filters = searchRequest.filters

    --额外筛选
    if filters.itemId and #filters.itemId > 0 then
        local itemIds = {}
        for _, id in ipairs(filters.itemId) do
            table.insert(itemIds, tostring(id))
        end
        table.insert(whereClauses, "itemId IN (" .. table.concat(itemIds, ",") .. ")")
    end

    if filters.grade then
        table.insert(whereClauses, "grade = " .. filters.grade)
    end

    if filters.type then
        table.insert(whereClauses, "type = " .. filters.type)
    end

    if filters.subType then
        table.insert(whereClauses, "subType = " .. filters.subType)
    end

    if filters.publicityStatue ~= nil then
        table.insert(whereClauses, "publicityStatue = " .. tostring(filters.publicityStatue))
    end


    local whereClause = ""
    if #whereClauses > 0 then
        whereClause = " WHERE " .. table.concat(whereClauses, " AND ")
    end

    local sortParam = searchRequest.sort

    -- 构建排序子句
    local orderClause = ""
    if sortParam and #sortParam > 0 then
        local orderParts = {}
        for _, sortInfo in ipairs(sortParam) do
            if sortInfo.field == "totalPrice" then
                local direction = sortInfo.order == "desc" and "DESC" or "ASC"
                table.insert(orderParts, "totalPrice " .. direction)
            elseif sortInfo.field == "listingTime" then
                local direction = sortInfo.order == "desc" and "DESC" or "ASC"
                table.insert(orderParts, "listingTime " .. direction)
            end
        end
        -- 始终添加itemId升序作为最后的排序条件
        table.insert(orderParts, "itemId ASC")
        orderClause = " ORDER BY " .. table.concat(orderParts, ", ")
    else
        -- 默认排序：时间升序，价格升序，然后是itemId升序
        orderClause = " ORDER BY listingTime DESC, totalPrice ASC, itemId ASC"
    end

    -- 构建分页参数
    local pageParam = searchRequest.pageParam
    local pageNum = pageParam.page
    local pageSize = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", "860001")) or 100

    local offset = (pageNum - 1) * pageSize
    local sql = "SELECT * FROM " .. tableName .. whereClause .. orderClause .. " LIMIT " .. offset .. ", " .. pageSize

    local list = TradeGDataService.query(sql)
    local r = {}
    if table.isNullOrEmpty(list) then
        return r
    end


    if filters.job ~= nil or filters.entryNums ~= nil then
        for _, entity in pairs(list) do
            local shouldInclude = true

            -- 根据job筛选
            if filters.job ~= nil then
                shouldInclude = false -- 默认不包含，除非找到匹配的职业
                if entity.job then
                    for _, job in pairs(entity.job) do
                        if tonumber(job) == 0 or tonumber(job) == tonumber(filters.job) then
                            shouldInclude = true
                            break
                        end
                    end
                end
            end

            -- 如果已经因为job不符合而排除，则跳过entryNums检查
            if shouldInclude and filters.entryNums ~= nil then
                shouldInclude = false -- 默认不包含，除非找到匹配的词条
                if entity.entryNums then
                    for _, entryNum in pairs(entity.entryNums) do
                        if tonumber(entryNum) == tonumber(filters.entryNums) then
                            shouldInclude = true
                            break
                        end
                    end
                end
            end

            -- 只有当满足所有筛选条件时才加入结果
            if shouldInclude then
                table.insert(r, entity)
            end
        end
    else
        for _, entity in pairs(list) do
            table.insert(r, entity)
        end
    end

    table.sort(r, function(a, b)
        return a._rank < b._rank
    end)


    return r
end

function TradeGDataService.getActorListedNums(actor)
    local serverId = getbaseinfo(actor, "currserverid")
    local tableName = TradeGDataService.tableName .. "_" .. serverId
    local whereClause = " where ownerId = " .. actor:toString()
    local sql = "select count(*) as total  from " .. tableName .. whereClause
    local result = TradeGDataService.query(sql)
    if result and result[1] then
        return result[1].total or 0
    else
        return 0
    end
end

function TradeGDataService.getGoodById(itemId)
    local serverId = getbaseinfo("serverid")
    local tableName = TradeGDataService.tableName .. "_" .. serverId
    local entity = gget(tableName, itemId)
    return entity
end

function TradeGDataService.getActorListedGoods(actor)
    local serverId = getbaseinfo("serverid")
    local tableName = TradeGDataService.tableName .. "_" .. serverId
    local sql = "select * from " .. tableName .. " where ownerId=" .. actor:toString() .. " order by listingTime asc, itemId asc"
    return TradeGDataService.query(sql)
end

-- ==================== 用户接口层 (API Layer) ====================

-- 交易行上架
function TradeService.listItem(actor, msgData)
    local requestDTO = TradeListRequest.new(msgData)
    local listContext = { --上架上下文
        requestDTO = requestDTO,
        stallConfig = nil,
        itemInfo = nil,
        minNumber = nil,
    }
    if not this.checkListCondition(actor, listContext) then
        return
    end
    local itemInfo = listContext.itemInfo
    local stallConfig = listContext.stallConfig
    local luaExtdata = EquipAndAppear.getItemExtData(actor, requestDTO.itemId)
    -- 先放到交易行货架
    local result = bagtoshell(actor, msgData, 1)
    local reason = result.reason
    if reason ~= 0 then
        info(actor:toString(), "上架", stallConfig.name, "失败", reason)
        tipinfo(actor, "上架商品失败");
        return
    end
    -- 构建实体信息
    local entries = {}
    local entryNums = {}
    local grade = 0
    if tonumber(stallConfig.type) == 2 then
        entries = itemInfo.entries
        if not table.isNullOrEmpty(entries) then
            for _, e in pairs(entries) do
                local stallNum = string.tonumber(ConfigDataManager.getTableValue("cfg_equip_att", "stallNum", "id", e.entryid))
                if stallNum > 0 and not table.contains(entryNums, stallNum) then
                    table.insert(entryNums, stallNum)
                end
            end
        end
        grade = itemInfo.grade or 0
    end

    local jobTable = stallConfig["job"]
    if string.isNullOrEmpty(jobTable) then
        jobTable = { 0 }
    elseif jobTable then
        jobTable = string.splitInt(jobTable, "#")
    end

    local tax = stallConfig["tax"]
    local taxTable = {}
    if not tax then
        taxTable = { 0, 0 }
    else
        local taxInfo = string.split(tax, "|")
        for index, value in ipairs(taxInfo) do
            local taxDetail = string.split(value, "#")
            table.insert(taxTable, tonumber(taxDetail[2]))
        end
    end

    ---@type TradeGoodEntity
    local entity = TradeGoodEntity.new()
    entity.itemId = result.itemid
    entity.itemCfgId = result.itemcfgid
    entity.itemName = stallConfig.name
    entity.entries = entries
    entity.entrySize = result.entrysize
    entity.entryNums = entryNums
    entity.appendLv = luaExtdata.appendlv or 0
    entity.strengthLv = luaExtdata.strengthlv or 0
    entity.grade = grade
    entity.ownerId = actor:toString()
    entity.count = requestDTO.count
    entity.unitPrice = tonumber(msgData["listingprice"])
    entity.totalPrice = math.round(entity.unitPrice * entity.count / listContext.minNumber)
    entity.job = jobTable
    entity.coinType = requestDTO.coinType
    entity.publicityTime = tonumber(stallConfig.ready) * 60 * 1000
    entity.upShelfDuration = tonumber(stallConfig.time) * 60 * 1000
    entity.tax = taxTable
    entity.subType = tonumber(stallConfig.subtype)
    entity.type = tonumber(stallConfig.type)
    entity.preOrder = nil
    entity.publicityStatue = true
    entity.listingTime = getbaseinfo(actor, "now")
    entity.serverId = getbaseinfo(actor, "currserverid")
    entity.IsLuck = luaExtdata.IsLuck
    entity.luckAttr = luaExtdata.luckAttr

    TradeGDataService.set(entity.itemId, entity)

    sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_LISTING_GOODS, true)
end

function this.checkListCondition(actor, listContext)
    local requestDTO = listContext.requestDTO
    if not PKSystem.canTrade(actor) then
        error("PK值过高，交易行部分功能暂停使用", actor:toString())
        return false
    end
    local isOpen, _ = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.TRADE_SALE)
    if not isOpen then
        sendluamsg(actor, LuaMessageIdToClient.RES_NO_SPEC_PRIVILEGE, Privilege.PrivilegeType.TRADE_SALE)
        return false
    end

    local listingCount = requestDTO.count
    if listingCount <= 0 or requestDTO.listingPrice <= 0 then
        tipinfo(actor, "请正常上架商品")
        return false
    end

    local stallInfo = ConfigDataManager.getTableFirst("cfg_stall", "id", requestDTO.itemCfgId, "way", TRADE_WAY.WORLD_UP)
    if table.isEmpty(stallInfo) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT383)
        return false
    end
    listContext.stallConfig = stallInfo

    local money = requestDTO.coinType
    local moneytype = string.splitInt(stallInfo["money"], "#")
    if string.isNullOrEmpty(moneytype) or not table.contains(moneytype, tonumber(money)) then
        tipinfo(actor, "交易货币类型不合法")
        return false
    end

    local minNumber = tonumber(stallInfo["minnumber"]) or 1
    if tonumber(requestDTO.count) % minNumber ~= 0 then
        error(string.format("上架道具数量(%d)无法被最小上架数量(%d)整除", requestDTO.count, minNumber), actor:toString())
        return false
    end
    listContext.minNumber = minNumber
    if requestDTO.itemId > 0 then
        local itemInfo = getbagiteminfo(actor, requestDTO.itemId, 1)
        if table.isNullOrEmpty(itemInfo) then
            error("交易行上架，获取道具细信息失败，道具id:", requestDTO.itemId)
            noticeTip.noticeinfo(actor, StringIdConst.TEXT371)
            return false
        end
        local itemCount = itemInfo["count"] or 1
        if minNumber > itemCount then
            tipinfo(actor, "当前位置的道具数量小于交易行上架最小数量")
            return false
        end

        listContext.itemInfo = itemInfo
    else
        local itemCount = Bag.getOnlySelfCount(actor, requestDTO.itemCfgId)
        if minNumber > itemCount then
            tipinfo(actor, "当前位置的道具数量小于交易行上架最小数量")
            return false
        end
        if itemCount < listingCount then
            tipinfo(actor, "道具不足")
            return false
        end
    end

    local capacity = ConfigDataManager.getTableValue("cfg_global", "value", "id", TRADE_CAPACITY_GLOBAL_ID)
    local is_has, count = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.TRADE_LINE_UP_COUNT_INCREASE)
    local listNums = TradeGDataService.getActorListedNums(actor)
    if listNums >= capacity + count then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT370)
        return false
    end
    return true
end

function TradeService.getGoodsInfo(actor, msgData)
    local ownActor = getactor(actor, msgData[2])
    local itemId = msgData[1]
    local goodsInfo = getshellgoods(ownActor, itemId, msgData[2])
    if table.isNullOrEmpty(goodsInfo) then
        error("商品流拍，但是真实商品信息已不存在", ownActor:toString(), itemId)
        TradeGDataService.delete(itemId)
        noticeTip.noticeinfo(actor, StringIdConst.TEXT373) -- 商品不存在提示
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end
    goodsdetailinfo(ownActor, itemId, TRADE_WAY.WORLD_UP, actor:toString())
end

-- 交易行下架
function TradeService.delistedGood(actor, msgData)
    local itemId = msgData[2]
    callonserial(actor, "trade_delisted_goods_on_serial", itemId)
end

function trade_delisted_goods_on_serial(actor, itemId)
    ---@type TradeGoodEntity
    local goodEntity = TradeGDataService.getGoodById(itemId)
    if table.isNullOrEmpty(goodEntity) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT373)
        return
    end

    local ownid = goodEntity.ownerId
    if actor:toString() ~= tostring(ownid) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT375)
        return
    end

    local count = goodEntity.count

    local goodsInfo = getshellgoods(actor, tonumber(itemId), actor:toString())
    goodsInfo = goodsInfo[tonumber(itemId)]
    if table.isNullOrEmpty(goodsInfo) then
        tipinfo(actor, "下架失败，商品不存在")
        return
    end

    info("玩家下架交易行商品开始", actor:toString(), itemId)

    local realCount = tonumber(goodsInfo.count)

    if realCount ~= count then
        info("内置数据和外置数据数量不一致，以内置数据为准", itemId, count, realCount)
        count = realCount
    end

    local ret = shelltobag(actor, actor:toString(), itemId, count, actor:toString(), 0, "")
    local reason = ret["reason"]
    if reason ~= 0 then
        tipinfo(actor, "下架商品失败", reason)
        info("玩家下架交易行商品失败", actor:toString(), itemId)
        return
    end

    -- 清除全局数据
    TradeGDataService.delete(itemId)

    local peroreder = goodEntity.preOrder
    if not table.isNullOrEmpty(peroreder) then
        info(actor:toString() .. "下架商品预购人员信息", peroreder)
        -- 清理预购人员存储的信息
        for index, preRid in pairs(peroreder) do
            this.tradeReturnPreOrderCoin(
                preRid,
                itemId,
                goodEntity.coinType,
                goodEntity.totalPrice,
                goodEntity.itemName
            )
        end
    end


    info("玩家下架交易行商品成功", actor:toString(), itemId)
    sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_OFF_GOODS, true)
end

function this.tradeReturnPreOrderCoin(preRid, itemId, coinType, totalPrice, itemName)
    local preActor = getactor(preRid)
    local myPreInfo = getplaydef(preActor, ROLE_TRADE_PRE_GOODS)
    if not table.isEmpty(myPreInfo) then
        local preIndex = this.findPreInfo(myPreInfo, tostring(itemId))
        if preIndex then
            table.remove(myPreInfo, preIndex)
            setplaydef(preActor, ROLE_TRADE_PRE_GOODS, myPreInfo)

            sendconfigmailbyrid(preActor, preRid,
                EmailConfig.TRADE_PRE_FAILED,
                { [tonumber(coinType)] = tonumber(totalPrice) },
                itemName .. "#" .. "货币")
        end
    end
end

-- 获取预购商品索引
function this.findPreInfo(myPreInfo, goodId)
    for index, preInfo in pairs(myPreInfo) do
        if tostring(preInfo.goodId) == tostring(goodId) then
            return index
        end
    end
end

---@param searchRequest TradeSearchRequest
function TradeService.getListingGoods(actor, searchRequest)
    local searchDto = searchRequest
    local searchType = searchDto.searchType
    local goods = {}
    if searchType == SEARCH_TYPE.PRE_ORDER then
        --预购的商品
        goods = this.getActorPreOrderGoodsByReq(actor, searchRequest)
    elseif searchType == SEARCH_TYPE.PUBLISHING then
        -- 公示的商品
        searchRequest.filters.publicityStatue = true
        goods = TradeGDataService.queryListByReq(searchRequest)
    else
        --全部商品
        goods = TradeGDataService.queryListByReq(searchRequest)
    end

    -- 补充装备其他信息
    local res = {}
    for index, tradeEntity in pairs(goods) do
        local dto = array.deepCopy(tradeEntity)
        local goodInfos = getshellgoods(actor, tradeEntity.itemId, tradeEntity.ownerId)
        local goodInfo = goodInfos[tradeEntity.itemId]
        -- dto.basicAttr = goodInfo.basicattr 前端说不要
        dto.luaExtData = goodInfo.luaextdata
        table.insert(res,dto)
    end

    sendluamsg(actor, LuaMessageIdToClient.RES_GET_TRADE_GOODS, res)
end

---@param searchRequest TradeSearchRequest
function this.getActorPreOrderGoodsByReq(actor, searchRequest)
    local goods = {}
    local selfPreGoodInfo = getplaydef(actor, ROLE_TRADE_PRE_GOODS)

    if table.count(selfPreGoodInfo) <= 0 then
        return goods
    end
    
    local itemIds = {}
    for _, value in pairs(selfPreGoodInfo) do
        table.insert(itemIds, value.goodId)
    end

    searchRequest.filters.itemId = itemIds
    goods = TradeGDataService.queryListByReq(searchRequest)

    return goods
end

-- 购买交易行商品
function TradeService.buyGood(actor, msgData)
    local buyCount = msgData[4]
    local itemId = msgData[2]
    local goodRid = msgData[5]

    -- 一些参数检查放这里减少单线程cpu时间
    if buyCount <= 0 then
        tipinfo(actor, "请正确购买商品")
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end
    if not PKSystem.canTrade(actor) then
        error("PK值过高，交易行部分功能暂停使用", actor:toString())
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    callonserial(actor, "trade_buy_goods_on_serial", itemId, buyCount, goodRid)
end

function trade_buy_goods_on_serial(actor, itemId, buyCount, ownerId)
    ---@type TradeGoodEntity
    local goodEntity = TradeGDataService.getGoodById(itemId)
    if table.isNullOrEmpty(goodEntity) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT373) -- 商品不存在提示
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    local itemCfgId = goodEntity.itemCfgId

    local minNumber = ConfigDataManager.getTableValue("cfg_stall", "minnumber", "id", itemCfgId, "way", TRADE_WAY.WORLD_UP)
    if not minNumber then
        error(actor, "购买道具", itemCfgId, "未配置minNumber")
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    if minNumber and tonumber(buyCount) % minNumber ~= 0 then
        error(actor, "购买道具", itemCfgId, "不是minNumber的倍数")
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    if buyCount > goodEntity.count then
        tipinfo(actor, "请正确购买商品")
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    local publicityTime = goodEntity.listingTime + goodEntity.publicityTime
    local now = getbaseinfo("now")
    if now < publicityTime then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT377)
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    -- 检查是否是自己的商品
    if goodEntity.ownerId == actor:toString() then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT378) -- 不能购买自己上架的商品
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    if tostring(ownerId) ~= goodEntity.ownerId then
        error("交易行购买商品时，卖家和客户端请求对应不上", ownerId, goodEntity.ownerId)
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end


    local peroreder = goodEntity.preOrder
    if not table.isNullOrEmpty(peroreder) then
        tipinfo(actor, "当前商品，已经被其他玩家预购，请选择其他商品进行购买")
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    local unitPrice = goodEntity.unitPrice
    local price = math.round(unitPrice * buyCount / minNumber)

    local coinType = goodEntity.coinType
    local ownActor = getactor(actor, ownerId)

    local haveCount = Bag.countItem(actor, coinType)
    if haveCount < price then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT379)
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    local ret = shelltobag(ownActor, goodEntity.ownerId, itemId, buyCount, actor:toString(), EmailConfig.TRADE_BUY, goodEntity.itemName)
    local reason = ret["reason"]
    if reason ~= 0 then
        tipinfo(actor, "购买该商品失败")
        if reason == 2 then
            TradeGDataService.delete(itemId)
        end
        sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, false)
        return
    end

    TradeGDataService.delete(itemId)
    removeitemfrombag(actor, coinType, price, 0, 9999, '交易行-购买商品')


    local afterTaxPrice = this.calculationTax(ownActor, goodEntity, buyCount, minNumber)
    sendconfigmailbyrid(ownActor, ownerId, EmailConfig.TRADE_SUCCESSFUL_SOLD, { [tonumber(coinType)] = tonumber(afterTaxPrice) }, goodEntity.itemName)
    this.saveTradeHistory(actor, TRADE_RECORD_TYPE.PURCHASE, goodEntity, price)
    this.saveTradeHistory(ownActor, TRADE_RECORD_TYPE.SALE, goodEntity, afterTaxPrice)
    sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_BUY_GOODS, true)
    info("购买交易行商品成功", actor:toString(), goodEntity)
end

-- 计算税率
function this.calculationTax(ownActor, goodEntity, count, minNumber)
    local unitPrice = goodEntity.unitPrice
    local totalPrice = math.round(unitPrice * count / minNumber)
    local is_open, rate = Privilege.hasPrivilege(ownActor, Privilege.PrivilegeType.TAX_RATE)
    if is_open then
        totalPrice = totalPrice * (10000 - rate) / 10000
        totalPrice = math.round(totalPrice)
    else
        local table = goodEntity.tax
        local tax = tonumber(table[1])
        local has_vip, vip_rate = VipGiftPack.hasPrivilege(ownActor, VipPrivilege.Type.tax)
        if has_vip and string.tonumber(vip_rate) > 0 then
            tax = tax * (100 - tonumber(vip_rate)) / 100
            tax = math.round(tax)
        end
        totalPrice = totalPrice * (100 - tax) / 100
        totalPrice = math.round(totalPrice)
        local deleteCount = tonumber(table[2])
        if has_vip then
            local addCount = math.round((deleteCount * tonumber(vip_rate)) / 100)
            deleteCount = deleteCount - addCount
        end
        totalPrice = totalPrice - deleteCount
    end
    return totalPrice
end

---保存交易记录
---@param goodsDetail TradeGoodEntity
function this.saveTradeHistory(actor, type, goodsDetail, totalPrice)
    local tradeRecorde = getplaydef(actor, ROLE_TRADE_GOODS_RECORD)
    if table.isNullOrEmpty(tradeRecorde) then
        tradeRecorde = {}
    end
    --- 整理交易记录
    if table.count(tradeRecorde) > TRADE_GOODS_RECORD_UPPER_LIMIT then
        local haveCount = table.count(tradeRecorde)
        local deleteCount = haveCount - TRADE_GOODS_RECORD_UPPER_LIMIT
        for i = 1, deleteCount do
            table.remove(tradeRecorde, 1)
        end
    end

    local goodRecord = {
        itemname = goodsDetail.itemName,
        time = getbaseinfo("now"),
        tradetype = type,
        cointype = goodsDetail.coinType,
        price = totalPrice
    }
    table.insert(tradeRecorde, goodRecord)
    setplaydef(actor, ROLE_TRADE_GOODS_RECORD, tradeRecorde)
end

-- 获取我的交易记录
function TradeService.getWorldTradeRecord(actor)
    local tradeRecorde = getplaydef(actor, ROLE_TRADE_GOODS_RECORD)
    sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_RECORD, tradeRecorde)
end

-- 获取我上架商品
function TradeService.getWorldMyListing(actor)
    local capacity = ConfigDataManager.getTableValue("cfg_global", "value", "id", TRADE_CAPACITY_GLOBAL_ID)
    local is_has, count = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.TRADE_LINE_UP_COUNT_INCREASE)
    capacity = capacity + count

    local stallInfo = Stall.getStallTimeInfo(actor)
    if not stallInfo then
        stallInfo = {}
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_STALL_INFO, stallInfo)

    local listingGood = {}
    local allGoods = {}
    local myListingGoods = TradeGDataService.getActorListedGoods(actor)
    for _, value in pairs(myListingGoods) do
        table.insert(allGoods, value)
    end
    listingGood["capacity"] = capacity
    listingGood["number"] = table.count(allGoods)
    listingGood["allgoods"] = allGoods
    sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_MY_SHELVES, listingGood)
end

-- 预购商品
function TradeService.preWorldGoods(actor, msgData)
    callonserial(actor, "trade_pre_goods_on_serial", msgData[2], msgData[4])
end

function trade_pre_goods_on_serial(actor, itemId, ownerId)
    ---@type TradeGoodEntity
    local goodEntity = TradeGDataService.getGoodById(itemId)
    if table.isNullOrEmpty(goodEntity) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT373) -- 商品不存在提示
        return
    end

    local publicityTime = goodEntity.listingTime + goodEntity.publicityTime
    local now = getbaseinfo("now")
    if now > publicityTime then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT380)
        return
    end

    local ownid = goodEntity.ownerId
    if actor:toString() == tostring(ownid) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT381)
        return
    end

    local peroreder = goodEntity.preOrder
    if peroreder then
        for index, preRid in pairs(peroreder) do
            if tostring(preRid) == actor:toString() then
                noticeTip.noticeinfo(actor, StringIdConst.TEXT382)
                return
            end
        end
    end
    local totalprice = goodEntity.totalPrice
    local cointype = goodEntity.coinType

    local haveCount = Bag.getOnlySelfCount(actor, cointype)
    if haveCount < totalprice then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT379)
        return
    end

    this.addPre(actor, goodEntity)

    removeitemfrombag(actor, cointype, totalprice, 0, 9999, '交易行-预购商品')

    local preGoodInfo = getplaydef(actor, ROLE_TRADE_PRE_GOODS)
    if not preGoodInfo then
        preGoodInfo = {}
    end
    local perGoodInfo = {
        rid = ownerId,
        goodId = itemId,
        coinType = cointype,
        itemName = goodEntity.itemName,
        totalPrice = totalprice
    }
    table.insert(preGoodInfo, perGoodInfo)
    setplaydef(actor, ROLE_TRADE_PRE_GOODS, preGoodInfo)
    this.saveTradeHistory(actor, TRADE_RECORD_TYPE.PREORDER, goodEntity, totalprice)
    info(actor:toString() .. "预购商品信息", goodEntity)
    sendluamsg(actor, LuaMessageIdToClient.RES_TRADE_PRE_ORDER, true)
end

-- 商品中添加预购信息
function this.addPre(preActor, goodEntity)
    local preOrder = goodEntity.preOrder
    if not preOrder then
        preOrder = {}
    end
    table.insert(preOrder, preActor:toString())
    goodEntity.preOrder = preOrder
    TradeGDataService.set(goodEntity.itemId, goodEntity)
end

function TradeService.flushList()
    local serverType = getbaseinfo("servertype")
    if serverType == 2 then
        -- 跨服服务器不执行
        return
    end

    callonserial("trade_flush_goods_on_serial")
end

function trade_flush_goods_on_serial()
    local allGoods = TradeGDataService.queryAll()
    if table.isNullOrEmpty(allGoods) then
        return
    end

    local now = getbaseinfo("now")
    for index, entity in pairs(allGoods) do
        ---@type TradeGoodEntity
        local good = entity

        local publicityTime = good.listingTime + good.publicityTime
        local offShelfTime = publicityTime + good.upShelfDuration

        if now > publicityTime and now < offShelfTime and good.publicityStatue then
            local peroreder = good.preOrder
            if table.isNullOrEmpty(peroreder) then
                good.publicityStatue = false
                TradeGDataService.set(good.itemId, good)
            elseif peroreder then
                this.handlePre(good)
            end
        elseif offShelfTime < now then
            this.flowFilming(good)
        end
    end
end

---@param entity TradeGoodEntity
function this.handlePre(entity)
    local peroreder = entity.preOrder
    local successIndex = math.random(1, #peroreder)
    local successRid = peroreder[successIndex]
    local ownActor = getactor(entity.ownerId)
    local goodId = entity.itemId

    local minNumber = ConfigDataManager.getTableValue("cfg_stall", "minnumber", "id", entity.itemCfgId, "way", TRADE_WAY.WORLD_UP)

    local afterTaxPrice = this.calculationTax(ownActor, entity, entity.count, minNumber)
    local ret = shelltobag(ownActor, entity.ownerId, goodId, entity.count, successRid, EmailConfig.TRADE_BUY, entity.itemName)
    local reason = ret["reason"]
    if reason ~= 0 then
        info("预购商品进入背包失败", entity.ownerId, goodId, entity.count, successRid, EmailConfig.TRADE_BUY, entity.itemName)
        return
    end

    TradeGDataService.delete(goodId)

    -- 清理预购人员存储的信息
    for index, preRid in pairs(peroreder) do
        if tostring(successRid) ~= tostring(preRid) then
            this.tradeReturnPreOrderCoin(
                preRid,
                goodId,
                entity.coinType,
                entity.totalPrice,
                entity.itemName
            );
        end
    end

    -- 清理购买者的预购信息
    local successActor = getactor(successRid)
    local myPreInfo = getplaydef(successActor, ROLE_TRADE_PRE_GOODS)
    if not table.isEmpty(myPreInfo) then
        local preIndex = this.findPreInfo(myPreInfo, tostring(goodId))
        if preIndex then
            table.remove(myPreInfo, preIndex)
            setplaydef(successActor, ROLE_TRADE_PRE_GOODS, myPreInfo)
        end
    end



    sendconfigmailbyrid(ownActor, entity.ownerId, EmailConfig.TRADE_SUCCESSFUL_SOLD, { [tonumber(entity.coinType)] = tonumber(afterTaxPrice) }, entity.itemName)
    this.saveTradeHistory(ownActor, TRADE_RECORD_TYPE.SALE, entity, afterTaxPrice)

    info("预购商品成功", entity.ownerId, goodId, entity.count, successRid, EmailConfig.TRADE_BUY, entity.itemName)
end

-- 商品流拍
---@param good TradeGoodEntity
function this.flowFilming(good)
    local ownId = good.ownerId
    local ownActor = getactor(ownId)

    local goodsInfo = getshellgoods(ownActor, good.itemId, ownId)
    if table.isNullOrEmpty(goodsInfo) then
        error("商品流拍，但是真实商品信息已不存在", ownActor:toString(), good.itemId, good.count)
        TradeGDataService.delete(good.itemId)
        return
    end

    local ret = shelltobag(ownActor, ownActor:toString(), good.itemId, good.count, ownActor:toString())
    local reason = ret["reason"]
    if reason ~= 0 then
        error("商品流拍，但是商品进入背包失败", ownActor:toString(), good.itemId, good.count)
        return
    end
    TradeGDataService.delete(good.itemId)
end

-- 玩家登录，检查真实信息和全局数据是否一致
function TradeService.loginCheck(actor)
    local realListingGoods = getshellgoods(actor, nil, actor:toString())
    local myListingGoods = TradeGDataService.getActorListedGoods(actor)
    if table.count(realListingGoods) ~= table.count(myListingGoods) then
        -- 数据不一致，启动修复流程
        callonserial(actor, "trade_fix_role_listing_goods_on_serial")
    end

    -- -- 对比预购中的数据是否存在，如果不存在，返还预购金币
    -- local selfPreGoodInfo = getplaydef(actor, ROLE_TRADE_PRE_GOODS)
    -- if table.count(selfPreGoodInfo) > 0 then
    --     local itemIds = {}
    --     for _, value in pairs(selfPreGoodInfo) do
    --         table.insert(itemIds, value.goodId)
    --     end
    --     local searchRequest = {}
    --     searchRequest.filters = {itemId = itemIds}
    --     searchRequest.pageParam = { page = 1, size = 99999 }
    --     local goods = TradeGDataService.queryListByReq(searchRequest)
    --     if #itemIds ~= table.count(goods) then
    --         callonserial(actor, "trade_fix_role_pre_goods_on_serial")
    --     end
    -- end
end

function trade_fix_role_listing_goods_on_serial(actor)
    local realListingGoods = getshellgoods(actor, nil, actor:toString())
    local myListingGoods = TradeGDataService.getActorListedGoods(actor)

    -- 检查数据库中有但实际货架没有的商品（需要删除）
    for itemId, good in pairs(realListingGoods) do
        if not myListingGoods[itemId] then
            error("交易行商品真实存在但在全局数据上不存在，返还商品", actor:toString(), good)
            shelltobag(actor, actor:toString(), itemId, good.count, actor:toString())
        end
    end
end

function trade_fix_role_pre_goods_on_serial(actor)
    local selfPreGoodInfo = getplaydef(actor, ROLE_TRADE_PRE_GOODS)
    if table.count(selfPreGoodInfo) > 0 then
        local itemIds = {}
        for _, value in pairs(selfPreGoodInfo) do
            table.insert(itemIds, value.goodId)
        end
        local searchRequest = {}
        searchRequest.filters = { itemId = itemIds }
        searchRequest.pageParam = { page = 1, size = 99999 }
        local goods = TradeGDataService.queryListByReq(searchRequest)
        for key, goodInfo in pairs(selfPreGoodInfo) do
            local itemId = goodInfo.goodId
            if not goods[itemId] then
                error("玩家预购商品在全局数据上不存在，返还货币", actor:toString(), goodInfo)
                this.tradeReturnPreOrderCoin(actor:toString(), itemId, goodInfo.coinType, goodInfo.totalPrice, goodInfo.itemName)
            end
        end
    end
end

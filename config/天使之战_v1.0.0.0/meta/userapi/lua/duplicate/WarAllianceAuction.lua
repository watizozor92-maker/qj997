Auction = {}
AuctionConst = {
    AUCTION_WAY = 1,
    AUCTION_TIMER = 201,
    AUCTION_DIVIDEND = 14001002,   -- 分红比例
    AUCTION_SUCCESS_EMAIL = 106001,
    AUCTION_FAIL_EMAIL = 106002,   -- 拍卖失败返还邮件
    AUCTION_DIVIDE_EMAIL = 106012, -- 拍卖分红邮件
    AUCTION_GOODS = "U$AuctionGoods",
    CAN_DISTRIBUTE_IDS = "U$DistributeIds",
    CAN_REWARD_UNIONS = "R$CanRewardUnions",
}
local SortType = {
    ASC_BY_TIME = 1,   -- 按照时间升序
    DESC_BY_TIME = 2,  -- 按照时间降序
    ASC_BY_PRICE = 3,  -- 按照价格升序
    DESC_BY_PRICE = 4, -- 按照价格降序
}
function Auction.NoticeClientToStartAuction(actor, unionId, myHurtMember, canRewardUnions)
    local goods = ConfigDataManager.getTable("cfg_stall", "way", AuctionConst.AUCTION_WAY)
    local openDays = getbaseinfo(actor, "serveropendays")
    local auctionGoods, closetDay = Auction.GetClosetGoodsData(goods, openDays)
    local idAndCount = {}
    for _, goodsInfo in ipairs(auctionGoods) do
        local probability = goodsInfo["probability"]
        local cfgid = goodsInfo['id']
        local count = goodsInfo['number']
        if probability ~= "" and probability ~= nil then
            probability = tonumber(probability)
            local num = math.random(1, 10000)
            if probability >= num then
                idAndCount[tonumber(cfgid)] = tonumber(count)
            end
        else
            idAndCount[tonumber(cfgid)] = tonumber(count)
        end
    end
    local itemInfos = saveunionitem(actor, DuplicateType.WAR_ALLIANCE, idAndCount)
    -- lg("返回的道具信息", itemInfos)
    local items = {}
    for index, itemInfo in ipairs(itemInfos) do
        local id = itemInfo["id"]
        local itemcfgid = itemInfo["itemcfgid"]
        local rank = itemInfo["rank"]
        local grade = itemInfo["grade"]
        local entrysize = itemInfo["entrysize"]
        local stalls = ConfigDataManager.getTable("cfg_stall", "id", itemcfgid, "startday", closetDay, "way",
            TRADE_WAY.GARD_BOSS)
        local itemStall = stalls[1]
        local bidderid = 0
        local itemname = itemStall["name"]
        local type = itemStall["type"]
        local subtype = itemStall["subtype"]
        local count = itemStall["number"]
        local state = ""
        local oneprice = itemStall["fixedprice"]
        local price = itemStall["startingprice"]
        local increment = itemStall["auction"]
        local cointype = itemStall["money"]
        local time = itemStall["time"]
        local now = getbaseinfo("now")
        local endTime = now + time * 60 * 1000
        local career = itemStall["job"]
        local item = {
            itemid = id,
            itemcfgid = itemcfgid,
            bidderid = bidderid,
            rank = rank,
            grade = grade or 1,
            entrysize = tonumber(entrysize),
            itemname = itemname,
            type = tonumber(type),
            subtype = tonumber(subtype),
            count = tonumber(count),
            state = state,
            price = tonumber(price),
            oneprice = tonumber(oneprice),
            increment = tonumber(increment),
            cointype = tonumber(cointype),
            time = time * 60,
            endtime = endTime,
            career = career,
        }
        table.insert(items, item)
    end
    -- lg("获取到拍卖行物品信息", items)
    local guild = getmyguild(actor)
    if not guild then
        return
    end
    local myUnionGoods = getguilddef(guild, AuctionConst.AUCTION_GOODS) or {}
    myUnionGoods = myUnionGoods == "" and {} or myUnionGoods
    if next(myUnionGoods) ~= nil then
        for _, item in ipairs(items) do
            table.insert(myUnionGoods, item)
        end
    else
        myUnionGoods = items
    end
    setguilddef(guild, AuctionConst.AUCTION_GOODS, myUnionGoods)
    -- lg("我的战盟伤害成员:", myHurtMember)
    setguilddef(guild, AuctionConst.CAN_DISTRIBUTE_IDS, myHurtMember)
    -- lg("可参与竞拍的战盟", canRewardUnions)
    setsysvar(actor, AuctionConst.CAN_REWARD_UNIONS, canRewardUnions)
    GlobalTimer.setontimerex(AuctionConst.AUCTION_TIMER, 3)
    Auction.SendOpenAuctionMessage(actor, myHurtMember)
end

function Auction.GetClosetGoodsData(goods, openDays)
    local closestDay = 0
    local minDiff = 99999
    for _, goodsInfo in ipairs(goods) do
        local startDay = goodsInfo["startday"]
        startDay = tonumber(startDay)
        local diff = math.abs(startDay - openDays)
        if startDay <= openDays then
            if diff < minDiff then
                minDiff = diff
                closestDay = startDay
            end
        end
    end
    local closestElements = {}
    for _, goodsInfo in ipairs(goods) do
        local startDay = goodsInfo["startday"]
        startDay = tonumber(startDay)
        if startDay == closestDay then
            table.insert(closestElements, goodsInfo)
        end
    end
    return closestElements, closestDay
end

function Auction.SendOpenAuctionMessage(actor, myHurtMember)
    for _, player in ipairs(myHurtMember) do
        local role = getactor(actor, player)
        local mapId = getbaseinfo(actor, "unimapid")
        if mapId ~= 0 then
            WarAlliance.ResTaskPhaseUpdate(role, mapId)
        end
        sendluamsg(role, LuaMessageIdToClient.RES_WAR_ALLIANCE_OPEN_AUCTION, { 1 })
    end
end

function ontimerex201()
    local guilds = getsysvar(AuctionConst.CAN_REWARD_UNIONS)
    if guilds == nil or guilds == "" or next(guilds) == nil then
        return
    end
    -- lg("可参与竞拍的战盟:", unionIds)
    for _, guild in ipairs(guilds) do
        local unionId = tonumber(guild:toString())
        local goods = getguilddef(guild, AuctionConst.AUCTION_GOODS) or {}
        goods = goods == "" and {} or goods
        -- lg("当前战盟拍卖行物品信息:", goods)
        if next(goods) ~= nil then
            local removeIndices = {}
            for i, goodsInfo in ipairs(goods) do
                local endTime = goodsInfo["endtime"]
                local now = getbaseinfo("now")
                if endTime < now then
                    table.insert(removeIndices, i)
                end
            end

            -- lg("本次拍卖行过期商品索引:", removeIndices)
            for i = #removeIndices, 1, -1 do
                local indexToRemove = removeIndices[i]
                Auction.OnTimeSettleAuction(goods[indexToRemove], guild)
                table.remove(goods, indexToRemove)
            end
        end
        setguilddef(guild, AuctionConst.AUCTION_GOODS, goods)
    end
    local allHadExpired = true
    for _, guild in ipairs(guilds) do
        local goods = getguilddef(guild, AuctionConst.AUCTION_GOODS) or {}
        if next(goods) ~= nil then
            allHadExpired = false
            break
        end
    end
    if allHadExpired then
        GlobalTimer.setofftimer(AuctionConst.AUCTION_TIMER)
    end
end

-- 筛选商品
function Auction.GetSomeGoods(actor, msgData, isCheck)
    local type = msgData[1]
    local subType = msgData[2]
    local sort = msgData[3]
    local career = msgData[4]
    local rank = msgData[5]
    local grade = msgData[6]
    local guild = getmyguild(actor)
    if not guild then
        return {}
    end
    local myUnionGoods = getguilddef(guild, AuctionConst.AUCTION_GOODS) or {}
    myUnionGoods = myUnionGoods == "" and {} or myUnionGoods
    if next(myUnionGoods) == nil then
        sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_AUCTION_GOODS, myUnionGoods)
        return myUnionGoods
    end
    local filteredGoods = Auction.FilterGoods(myUnionGoods, type, subType, career, grade, rank)
    Auction.SortGoods(filteredGoods, sort)

    -- 添加我的竞拍信息
    for _, goods in ipairs(filteredGoods) do
        local bidder = goods["bidderid"]
        if bidder == 0 then
            goods["state"] = ""
        elseif bidder:toString() == actor:toString() then
            goods["state"] = "我的竞拍"
        else
            goods["state"] = "竞拍中"
        end
    end
    if isCheck then
        return filteredGoods
    else
        sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_AUCTION_GOODS, filteredGoods)
    end
end

function Auction.FilterGoods(myUnionGoods, type, subType, career, grade, rank)
    local filteredGoods = {}
    -- lg("筛选商品:", "type", type, "career", career, "grade", grade, "rank", rank)
    for _, goods in ipairs(myUnionGoods) do
        if (type ~= 0 and type ~= tonumber(goods["type"])) then
            goto continue
        end
        if (subType ~= 0 and subType ~= tonumber(goods["subtype"])) then
            goto continue
        end
        if (career ~= 0) then
            local careers = goods["career"]
            local careerArr = string.splitByAll(careers, "#")
            local baseCareer = careerArr[1]
            local isCareerMatch = career == tonumber(baseCareer)
            if not isCareerMatch then
                goto continue
            end
        end
        if (rank ~= 0 and rank ~= tonumber(goods["rank"])) then
            goto continue
        end
        if (grade ~= 0 and grade ~= tonumber(goods["grade"])) then
            goto continue
        end

        local endTime = goods["endtime"]
        if tonumber(endTime) <= getbaseinfo("now") then
            goto continue
        end

        table.insert(filteredGoods, goods)

        ::continue::
    end
    return filteredGoods
end

function Auction.SortGoods(filteredGoods, sortType)
    local function compare(a, b)
        if sortType == SortType.ASC_BY_TIME then
            return a["time"] < b["time"]
        elseif sortType == SortType.DESC_BY_TIME then
            return a["time"] > b["time"]
        elseif sortType == SortType.ASC_BY_PRICE then
            return a["price"] < b["price"]
        elseif sortType == SortType.DESC_BY_PRICE then
            return a["price"] > b["price"]
        end
    end
    table.sort(filteredGoods, compare)
end

function Auction.GetGoodsDetailInfo(actor, msgData)
    local itemId = msgData["itemId"]
    local type = msgData["type"]
    goodsdetailinfo(actor, itemId, AuctionConst.AUCTION_WAY, actor:toString())
end

-- @description 玩家竞价
function Auction.PlayerBidOnItem(actor, msgData)
    local goodsId = msgData["goodsId"]
    local guild = getmyguild(actor)
    if guild == nil then
        tipinfo(actor, "您不是战盟成员,无法参与竞拍")
        return
    end
    local hasQualify = Auction.CheckHQualify(actor)
    if not hasQualify then
        tipinfo(actor, "战盟boss未通关,无法参与竞拍")
        return
    end

    local result = Auction.BiddingGoods(actor, goodsId, guild)

    local biddingResult
    if result then
        info("玩家竞价成功", actor:toString(), goodsId)
        biddingResult = { opt = "bidding", ret = true }
    else
        info("玩家竞价失败", actor:toString(), goodsId)
        biddingResult = { opt = "bidding", ret = false }
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_OPT_INFO, biddingResult)
end

function Auction.BiddingGoods(actor, goodsId, guild)
    local unionId = tonumber(guild:toString())
    local myUnionGoods = getguilddef(guild, AuctionConst.AUCTION_GOODS) or {}
    myUnionGoods = myUnionGoods == "" and {} or myUnionGoods
    local currGoods
    for _, goods in ipairs(myUnionGoods) do
        if tostring(goodsId) == tostring(goods["itemid"]) then
            currGoods = goods
            break
        end
    end
    if currGoods == nil then
        tipinfo(actor, "该商品已被购买或已下架")
        return false
    end
    local lastBidder = currGoods["bidderid"]
    if lastBidder ~= 0 and lastBidder:toString() == actor:toString() then
        tipinfo(actor, "您已经参与竞价,请勿重复参与")
        return false
    end
    local bidPrice = currGoods["price"]
    local onePrice = currGoods["oneprice"]
    local newPrice = Auction.CalculateNewPrice(currGoods)
    local coinType = currGoods["cointype"]
    local coinCount = getbagitemcountbyid(actor, coinType)
    if coinCount < newPrice then
        local coinName = ConfigDataManager.getTableValue("cfg_item", "name", "id", coinType)
        tipinfo(actor, "您的" .. coinName .. "不足")
        return false
    end
    if lastBidder ~= 0 then
        Auction.SendBidFaileMail(lastBidder, goodsId, coinType, bidPrice)
    end
    if newPrice == onePrice then
        tipinfo(actor, "当前价格达到一口价,转为一口价购买")
        local itemCfgId = tonumber(currGoods["itemcfgid"])
        local itemName = ConfigDataManager.getTableValue("cfg_item", "name", "id", itemCfgId)
        local result = moveunionitem(actor, goodsId, unionId, actor:toString(), AuctionConst.AUCTION_SUCCESS_EMAIL,
            itemName)
        if result then
            removeitemfrombag(actor, coinType, newPrice,0,9999,'战盟BOSS竞拍')
            local myHurtMembers = getguilddef(guild, AuctionConst.CAN_DISTRIBUTE_IDS)
            Auction.DistributeProfits(actor, itemCfgId, coinType, newPrice, myHurtMembers)
        end
        for i = #myUnionGoods, 1, -1 do
            local goods = myUnionGoods[i]
            if tostring(goods["itemid"]) == tostring(goodsId) then
                table.remove(myUnionGoods, i)
            end
        end
        setguilddef(guild, AuctionConst.AUCTION_GOODS, myUnionGoods)
        return true
    end
    removeitemfrombag(actor, coinType, newPrice,0,9999,'战盟BOSS竞拍')
    currGoods["price"] = newPrice
    currGoods["bidderid"] = actor
    setguilddef(guild, AuctionConst.AUCTION_GOODS, myUnionGoods)
    return true
end

function Auction.CalculateNewPrice(currGoods)
    local bidPrice = currGoods["price"]
    local increment = currGoods["increment"]
    local onePrice = currGoods["oneprice"]
    local newPrice = math.ceil(bidPrice * (1 + increment * 0.0001))
    if newPrice > onePrice then
        newPrice = onePrice
    end
    return newPrice
end

-- @description 玩家一口价购买
function Auction.PlayerBuyNow(actor, msgData)
    local goodsId = msgData["goodsId"]
    -- 检查玩家是否属于战盟
    local guild = getmyguild(actor)
    if guild == nil then
        tipinfo(actor, "您不是战盟成员,无法参与竞拍")
        return
    end

    -- 检查战盟通关条件
    local hasQualify = Auction.CheckHQualify(actor)
    if not hasQualify then
        tipinfo(actor, "战盟通关条件不符合,无法一口价购买")
        return
    end
    -- 一口价购买
    local result = Auction.BuyGoods(actor, goodsId, guild)

    local buyResult;
    if result then
        info("玩家一口价购买成功", actor:toString(), goodsId)
        buyResult = { opt = "buy", ret = true }
    else
        info("玩家一口价购买失败", actor:toString(), goodsId)
        buyResult = { opt = "buy", ret = false }
    end
    -- lg("玩家一口价购买结果:", buyResult)
    sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_OPT_INFO, buyResult)
end

function Auction.BuyGoods(actor, goodsId, guild)
    local unionId = tonumber(guild:toString())
    local myUnionGoods = getguilddef(guild, AuctionConst.AUCTION_GOODS) or {}
    myUnionGoods = myUnionGoods == "" and {} or myUnionGoods
    local currGoods
    for _, goods in ipairs(myUnionGoods) do
        if tostring(goodsId) == tostring(goods["itemid"]) then
            currGoods = goods
            break
        end
    end
    if currGoods == nil then
        tipinfo(actor, "该商品已被购买或已下架")
        return false
    end
    local lastBidder = currGoods["bidderid"]
    if lastBidder ~= 0 and lastBidder:toString() == actor:toString() then
        tipinfo(actor, "您已经参与竞价,请勿重复参与")
        return false
    end
    local bidPrice = currGoods["price"]
    local newPrice = currGoods["oneprice"]
    local coinType = currGoods["cointype"]
    local coinCount = getbagitemcountbyid(actor, coinType)
    if coinCount < newPrice then
        local coinName = ConfigDataManager.getTableValue("cfg_item", "name", "id", coinType)
        tipinfo(actor, "您的" .. coinName .. "不足")
        return false
    end
    if lastBidder ~= 0 then
        Auction.SendBidFaileMail(lastBidder, goodsId, coinType, bidPrice)
    end
    local itemCfgId = tonumber(currGoods["itemcfgid"])
    local itemName = ConfigDataManager.getTableValue("cfg_item", "name", "id", itemCfgId)
    local result = moveunionitem(actor, goodsId, unionId, actor:toString(), AuctionConst.AUCTION_SUCCESS_EMAIL, itemName)
    if result then
        removeitemfrombag(actor, coinType, newPrice,0,9999,'战盟BOSS竞拍')
        local myHurtMembers = getguilddef(guild, AuctionConst.CAN_DISTRIBUTE_IDS) or {}
        Auction.DistributeProfits(actor, itemCfgId, coinType, newPrice, myHurtMembers)
    end
    for i = #myUnionGoods, 1, -1 do
        local goods = myUnionGoods[i]
        if tostring(goods["itemid"]) == tostring(goodsId) then
            table.remove(myUnionGoods, i)
        end
    end
    setguilddef(guild, AuctionConst.AUCTION_GOODS, myUnionGoods)
    return true
end

function Auction.ShowAutionPanel(actor)
    local result = Auction.CheckHQualify(actor)
    if result then
        sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_SHOW_AUCTION_PANEL, { true })
    else
        sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_SHOW_AUCTION_PANEL, { false })
    end
end

-- 检查自己的战盟是否通关
function Auction.CheckHQualify(actor)
    local allianceId = getbaseinfo(actor, "guildid")
    if allianceId == 0 then
        return false
    end

    local goods = Auction.GetSomeGoods(actor, { 0, 0, 0, 0, 0, 0 }, true)
    return #goods > 0
end

function Auction.OnTimeSettleAuction(goodsInfo, guild)
    -- lg("开始结算拍卖,商品信息", goodsInfo)
    if goodsInfo == nil then
        return
    end
    local unionId = tonumber(guild:toString())
    local bidder = goodsInfo["bidderid"]
    local goodsId = goodsInfo["itemid"]

    info("结算拍卖,商品信息,竞拍者:", bidder)
    local result
    if bidder == 0 then
        -- lg("结算无购买者","goodsId",goodsId,"unionId",unionId)
        result = moveunionitem(goodsId, unionId)
    else
        local myHurtMembers = getguilddef(guild, AuctionConst.CAN_DISTRIBUTE_IDS)
        local cointype = tonumber(goodsInfo["cointype"])
        local price = tonumber(goodsInfo["price"])
        local itemcfgid = tonumber(goodsInfo["itemcfgid"])
        local itemName = ConfigDataManager.getTableValue("cfg_item", "name", "id", itemcfgid)
        info("结算有购买者", "unionId", unionId, "bidder", bidder)
        result = moveunionitem(bidder, goodsId, unionId, bidder:toString(), AuctionConst.AUCTION_SUCCESS_EMAIL, itemName)
        -- lg("删除结果:", result)
        if result then
            Auction.DistributeProfits(bidder, itemcfgid, cointype, price, myHurtMembers)
        end
    end
end

function Auction.DistributeProfits(actor, itemCfgId, coinType, price, canBuyIds)
    info("分红信息:","角色:",actor, "道具:",itemCfgId, "分红成员:",canBuyIds)
    if array.simpleContains(canBuyIds, actor:toString()) then
        for _, member in ipairs(canBuyIds) do
            local memberActor = getactor(actor, member)
            if memberActor:toString() ~= actor:toString() then
                Auction.ActDistribute(memberActor, itemCfgId, coinType, price, #canBuyIds - 1)
            end
        end
    else
        for _, member in ipairs(canBuyIds) do
            local memberActor = getactor(actor, member)
            Auction.ActDistribute(memberActor, itemCfgId, coinType, price, #canBuyIds)
        end
    end
end

function Auction.ActDistribute(actor, itemCfgId, coinType, price, personCount)
    local dividendRatio = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", AuctionConst.AUCTION_DIVIDEND)
    dividendRatio = tonumber(dividendRatio) * 0.0001
    local profitPerMember = price * dividendRatio
    profitPerMember = math.floor(profitPerMember)
    Auction.SendDivideMail(actor, itemCfgId, coinType, profitPerMember, personCount)
end

-- @description 发送分红邮件
function Auction.SendDivideMail(actor, itemCfgId, coinType, profitPerMember, personCount)
    local itemName = ConfigDataManager.getTableValue("cfg_item", "name", "id", itemCfgId)
    local priceTypeName = ConfigDataManager.getTableValue("cfg_item", "name", "id", coinType)
    local totalDivide = profitPerMember * personCount
    local param = itemName .. "#" .. priceTypeName .. "#" .. totalDivide .. "#" .. profitPerMember
    sendconfigmailbyrid(actor, actor:toString(),
        AuctionConst.AUCTION_DIVIDE_EMAIL, { [tonumber(coinType)] = tonumber(profitPerMember) }, param)
end

-- @description 发送竞价失败邮件
function Auction.SendBidFaileMail(lastBidder, goodsId, costType, costNum)
    -- lg("发送竞价失败邮件:", lastBidder, goodsId, costType, costNum)
    local itemName = ConfigDataManager.getTableValue("cfg_item", "name", "id", goodsId)
    local costName = ConfigDataManager.getTableValue("cfg_item", "name", "id", costType)
    local param = itemName .. "#" .. costName
    sendconfigmailbyrid(lastBidder, lastBidder:toString(),
        AuctionConst.AUCTION_FAIL_EMAIL, { [tonumber(costType)] = tonumber(costNum) }, param)
end

function Auction.combineGlobalVar(varName,varData)
    local data = {}
    for sid, var in pairs(varData) do
        table.AddRanage(data, var)
    end
    setsysvar(varName, data)
end

function clearauction(actor)
    local guild = getmyguild(actor)
    setguilddef(guild, AuctionConst.AUCTION_GOODS, {})
    setguilddef(guild, AuctionConst.CAN_DISTRIBUTE_IDS, {})
    setsysvar(actor, AuctionConst.CAN_REWARD_UNIONS, {})
end

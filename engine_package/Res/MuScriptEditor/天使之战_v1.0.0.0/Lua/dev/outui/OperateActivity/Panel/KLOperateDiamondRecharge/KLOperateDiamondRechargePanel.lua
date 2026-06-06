---@class KLOperateDiamondRechargePanel:UIKmlLuaPanelBase
---@field view KLOperateDiamondRechargePanelView
local KLOperateDiamondRechargePanel = class(UIKmlLuaPanelBase)
local this =KLOperateDiamondRechargePanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    if self.args and self.args.showType then
        if self.args.showType == 1 then
            self.RES_MAIN_ACTIVE_INFO_M = LuaMessageIdToClient.RES_WEEKEN_GIFT
        else
            self.RES_MAIN_ACTIVE_INFO_M = LuaMessageIdToClient.RES_MAIN_ACTIVE_INFO
        end
    end
    self.costItem = { 10040001, 10050001 }
    self.itemInfoList = {}
    GUI:DataListInitData(self.view.DailyPackItemList, function()
        return table.count(self.itemInfoList)
    end,function()

    end,function()

    end,function(realIndex)
        local discountControl = GUI:GetChildControl(self.view.DailyPackItemList,realIndex,'discountImage')               --左上角返利
        local discountTextControl = GUI:GetChildControl(self.view.DailyPackItemList,realIndex,'discountText')            --返利数值
        local ItemPriceShowTextControl = GUI:GetChildControl(self.view.DailyPackItemList,realIndex,'ItemPriceShowText')  --价格标题
        local limitBuyCountControl = GUI:GetChildControl(self.view.DailyPackItemList,realIndex,'limitBuyCount')          --限制次数
        local ItemInfoListControl = GUI:GetChildControl(self.view.DailyPackItemList,realIndex,'ItemInfoList')            --奖励列表
        local BuyBtnControl = GUI:GetChildControl(self.view.DailyPackItemList,realIndex,'daliyPackItemBuyBtn')           --购买按钮
        local redpoint = GUI:GetChildControl(self.view.DailyPackItemList,realIndex,'redpoint')                           --红点
        local diamondImg = GUI:GetChildControl(self.view.DailyPackItemList,realIndex,'DiamondImg')                       --钻石

        local info = self.itemInfoList[realIndex + 1]
        local buycount = 0              --剩余次数
        local totalcount = 0
        buycount,totalcount = InfoManager.countInfo:GetLimitAndTotalCountByKey(info.Countkey)
        
        if info.Diamonditem == 1 then
            GUI:Image_loadTexture(diamondImg, "10040001", "Atlas/TS_Common.spriteatlas")
        else
            GUI:Image_loadTexture(diamondImg, "10050001", "Atlas/TS_Common.spriteatlas")
        end

        --返利
        if info.Rebate and info.Rebate > 0 then
            GUI:setVisible(discountControl, true)
            GUI:Text_setString(discountTextControl, info.Rebate.."%")
        else
            GUI:setVisible(discountControl, false)
        end
        GUI:setVisible(redpoint, false)
        GUI:AddOnClickEvent(BuyBtnControl, self, self.ItemBuyBtn, {info})
        if info.canBuy then
            if info.Price == 0 then
                GUI:Button_setTitleText(BuyBtnControl, "领取")
                GUI:setVisible(redpoint, true)
            else
                GUI:Button_setTitleText(BuyBtnControl, "购买")
            end
        else
            GUI:Button_setTitleText(BuyBtnControl, "已购买")
        end
        if info.Price == 0 then
            GUI:setVisible(diamondImg, false)
            GUI:Text_setString(ItemPriceShowTextControl, "免费")
        else
            GUI:setVisible(diamondImg, true)
            GUI:Text_setString(ItemPriceShowTextControl, tostring(info.Price).."钻石")
        end
        GUI:Text_setString(limitBuyCountControl, "每日限购次数:"..(totalcount-buycount).."/"..totalcount)

        self:ItemUpdateFun(ItemInfoListControl,realIndex)
    end)
end

function this:ItemUpdateFun(ItemInfoListControl,Index)
    local data = self.itemInfoList[Index + 1]
    local showRewards={}
    for k,v in ipairs(data.Rewards) do
        table.insert(showRewards,v)
    end
    
    GUI:DataListInitData(ItemInfoListControl, function()
        return table.count(showRewards)
    end,function()

    end,function()

    end,function(realIndex)
        local ItemInfoSlotModel = GUI:GetChildControl(ItemInfoListControl,realIndex,'ItemInfoSlotModel')               --模型
        local ItemInfoSlotCount = GUI:GetChildControl(ItemInfoListControl,realIndex,'ItemInfoSlotCount')               --数量
        local itemInfoTips = GUI:GetChildControl(ItemInfoListControl,realIndex,'itemInfoTips')               --模型Tips

        GUI:setVisible(ItemInfoSlotModel, false)
        GUI:setVisible(ItemInfoSlotCount, false)
        GUI:setVisible(itemInfoTips, false)
        local itemdata = showRewards[realIndex + 1]
        GUI:setVisible(ItemInfoSlotModel, true)
        GUI:setVisible(itemInfoTips, true)
        GUI:setVisible(ItemInfoSlotCount, true)
        GUI:Item_setItemId(ItemInfoSlotModel, itemdata[1])
        if itemdata[1] == 10040001 or itemdata[1] == 10050001 then
            GUI:Model_setSrc(ItemInfoSlotModel, nil, nil, nil, nil, "24,24")
        end
        GUI:AddOnClickEvent(itemInfoTips,self,function()
            SL:OpenTips(nil, itemdata[1])
        end)
        GUI:Text_setString(ItemInfoSlotCount, tostring(itemdata[2]))
    end)
    GUI:DataListUpdateData(ItemInfoListControl)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.buyAllGift_btn, self, self.buyAllGift_btn)
    SL:RegisterLuaNetMsg(self.RES_MAIN_ACTIVE_INFO_M, self.RES_MAIN_ACTIVE_INFO, self)
end

function this:RES_MAIN_ACTIVE_INFO(_, message)
    if message then
        local list = {}
        local count = table.count(message.diamondPackInfo)
        if count > 0 then
            for i = 1, count do
                local data = {}
                local v = message.diamondPackInfo[tostring(i)]
                ---@type cfg_DiamondPack_column
                local tbl = SL:GetConfig("cfg_DiamondPack", tonumber(v.diamondPackId))
                if tbl.type ~= 2 then
                    data.Type = tbl.type
                    data.Rewards = tbl.reward
                    data.Price = tbl.money
                    data.Diamonditem = tbl.diamond
                    data.Countkey = tbl.countkey
                    data.Rebate = tbl.rebates
                    data.Id = tbl.id
                    list[#list + 1] = data
                else
                    self.autoBuyId = tbl.id
                    self.totalPrice = tbl.text
                    self.discountPrice = tbl.money
                end
            end
        end
        self:RefreshPanel(list)
    end
end

---一键购买
function this:buyAllGift_btn()
    if self.limitBuyAll then
        SL:TipMessage( "已购买，无法购买", 1, NoticeType.NoticeMid )
        return
    end
    ---@type cfg_DiamondPack_column
    local tbl = SL:GetConfig("cfg_DiamondPack", self.autoBuyId)
    local buy = false
    if tbl.diamonditem == 2 then
        local cost_1 = SL:GetBagItemCount(self.costItem[2])
        local cost_2 = SL:GetBagItemCount(self.costItem[1])
        if cost_1 + cost_2 >= tbl.money then
            buy = true
        end
    else
        local cost = SL:GetBagItemCount(self.costItem[1])
        if cost >= tbl.money then
            buy = true
        end
    end
    if buy then
        if self.args and self.args.showType == EOperateActivityType.Week then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.DiamondRechargeWeek, id = self.autoBuyId })
        else
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.DiamondRecharge, id = self.autoBuyId })
        end
    else
        SL:TipMessage( SL:GetConfig('cfg_string',28003).text, 1, NoticeType.NoticeMid )
    end
end

---列表的购买按钮
function this:ItemBuyBtn(control, data)
    if data[1].canBuy then
        local buy = false
        if data[1].Diamonditem == 2 then
            local cost_1 = SL:GetBagItemCount(self.costItem[2])
            local cost_2 = SL:GetBagItemCount(self.costItem[1])
            if cost_1 + cost_2 >= data[1].Price then
                buy = true
            end
        else
            local cost = SL:GetBagItemCount(self.costItem[1])
            if cost >= data[1].Price then
                buy = true
            end
        end
        if buy then
            if self.args and self.args.showType == EOperateActivityType.Week then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.DiamondRechargeWeek,id = data[1].Id })
            else
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.DiamondRecharge,id = data[1].Id })
            end
        else
            SL:TipMessage( SL:GetConfig('cfg_string',28003).text, 1, NoticeType.NoticeMid )
        end
    else
        SL:TipMessage( "请勿重复购买", 1, NoticeType.NoticeMid )
    end
end

---界面显示时调用一次
function this:Show()

end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        self.mainOperateActivityInfo = self.args.OperateActivityInfo
    end
    self.limitBuyAll = false
    if self.args and self.args.showType then
        if self.args.showType == 1 then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WEEKEN_ACTIVE_INFO, { subType = EOperateActivityActivityType.DiamondRecharge })
        else
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAIN_ACTIVE_INFO, { subType = EOperateActivityActivityType.DiamondRecharge })
        end
    end

    if not self.mainOperateActivityInfo then return end
    local leftTime = self.mainOperateActivityInfo:GetOADJSTimeBySubType(EOperateActivityActivityType.DiamondRecharge)
    if leftTime then
        GUI:SetControl_time(self.view.refreshTime, leftTime)
    end
end

function this:RefreshPanel(giftData)
    self.itemInfoList = {}
    if not table.isNullOrEmpty(giftData) then
        for _, v in ipairs(giftData) do
            local buycount = 0      --剩余次数
            local totalcount = 0
            buycount,totalcount = InfoManager.countInfo:GetLimitAndTotalCountByKey(v.Countkey)
            if buycount < 1 then
                v.canBuy = false
            else
                v.canBuy = true
            end
            if buycount ~= totalcount and v.Type == 1 then
                self.limitBuyAll = true
            end
            table.insert(self.itemInfoList, v)
        end
    end
    table.sort(self.itemInfoList,function (a, b)
        if a.canBuy == b.canBuy then
            return a.Price < b.Price
        elseif a.canBuy then
            return true
        else
            return false
        end
    end)
    GUI:DataListUpdateData(self.view.DailyPackItemList)
    
    if self.limitBuyAll then
        GUI:setVisible(self.view.buyAllGift_btn, false)
    else
        ---@type cfg_global_column
        local tbl = SL:GetConfig("cfg_global", 28003)
        if tbl and tbl.value == "0" then
            GUI:setVisible(self.view.buyAllGift_btn, false)
            return
        end
        GUI:setVisible(self.view.buyAllGift_btn, true)
        GUI:Text_setString(self.view.originalPriceNum, tostring(self.totalPrice))
        GUI:Text_setString(self.view.allBuyTextTips, SL:GetConfig("cfg_string", 28004).text)
        GUI:Button_setTitleText(self.view.buyAllGift_btn, tostring(self.discountPrice).."钻石")
    end
end

function this:Close()
end

return this

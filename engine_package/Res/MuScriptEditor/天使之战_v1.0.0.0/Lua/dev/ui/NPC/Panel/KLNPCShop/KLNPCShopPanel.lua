---@class KLNPCShopPanel:UIKmlLuaPanelBase
---@field view KLNPCShopPanelView
---@field goods NpcShopProto.NpcShopGoodsInfoRes
local KLNPCShopPanel = class(UIKmlLuaPanelBase)
local this = KLNPCShopPanel
---创建时调用一次
function this:Init()
    SL:HideMainPanel()
    GUI:DataListInitData(self.view.goods, function()
        return table.count(self.goods) + 60
    end, function(realIndex)
        --return self:DataListGoodsItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        --return self:DataListGoodsItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListGoodsItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.taskItems = {}
    self.animList = {}
    self.LeftConfig = {
        [1] = "小瓶药水",
        [2] = "中瓶药水",
        [3] = "大瓶药水",
    }
    self.leftDataBtnList = {}
    GUI:SetZIndex(self.view.Left, 210)
    GUI:SetActive(self.view.leftDataPanel, false)
    GUI:SetActive(self.view.autoBuyLeftDownBtn11, false)
    --隐藏自动买药的标题
    GUI:SetActive(self.view.img1, false)
    GUI:SetActive(self.view.img2, false)
    local isLeftOpen = false
    if not table.isNullOrEmpty(self.leftDataBtnList) then
        for _, v in pairs(self.leftDataBtnList) do
            if v.IsSelect then
                isLeftOpen = true
            end
        end
    end
    GUI:SetActive(self.view.autoBuyLeftBtnSelectImg, isLeftOpen)
    -----------------------------------------------------------------------------------------------
    self.RightConfig = {
        [1] = "小瓶药水",
        [2] = "中瓶药水",
        [3] = "大瓶药水",
    }
    self.RightDataBtnList = {}
    GUI:SetZIndex(self.view.Right, 210)
    GUI:SetActive(self.view.RightDataPanel, false)
    GUI:SetActive(self.view.autoBuyRightDownBtn11, false)
    local isRightOpen = false
    if not table.isNullOrEmpty(self.RightDataBtnList) then
        for _, v in pairs(self.RightDataBtnList) do
            if v.IsSelect then
                isRightOpen = true
            end
        end
    end
    GUI:SetActive(self.view.autoBuyRightBtnSelectImg, isRightOpen)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.autoBuyBackground, self, self.AutoBuy)
    GUI:AddOnClickEvent(self.view.desButton, self, self.DesBtn)
    GUI:AddOnClickEvent(self.view.btn_gold, self, function()
        SL:OpenTips(nil, 10010001)
    end)
    GUI:AddOnClickEvent(self.view.btn_diamond, self, function()
        SL:OpenTips(nil, 10040001)
    end)

    --SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.UpdateMoney, self)
    --SL:RegisterLUAEvent(LUA_EVENT_AUTO_BUY_POTION_RESULT, self.UpdateAutoBuy, self)

    --SL:RegisterLuaNetMsg(MessageDef.ResBuyShopGoodsMessage, self.ResBuyShopGoodsMessage, self)
    --SL:RegisterLuaNetMsg(MessageDef.RES_AUTO_BUY_POTION_SETTINGS , self.RES_AUTO_BUY_POTION_SETTINGS , self)
    GUI:AddOnClickEvent(self.view.autoBuyLeftDownBtn, self, self.autoBuyLeftDownBtnOnClick)
    GUI:AddOnClickEvent(self.view.autoBuyRightDownBtn, self, self.autoBuyRightDownBtnOnClick)

    GUI:AddOnClickEvent(self.view.autoBuyLeftBtn, self, self.autoBuyLeftBtnOnClick)
    GUI:AddOnClickEvent(self.view.autoBuyRightBtn, self, self.autoBuyRightBtnOnClick)

    GUI:AddOnClickEvent(self.view.leftMaskBtn, self, self.leftMaskBtn)
    GUI:AddOnClickEvent(self.view.rightMaskBtn, self, self.rightMaskBtn)
end

function this:leftMaskBtn()
    GUI:SetActive(self.view.leftDataPanel, false)
    GUI:SetActive(self.view.autoBuyLeftDownBtn11, false)
end

function this:rightMaskBtn()
    GUI:SetActive(self.view.RightDataPanel, false)
    GUI:SetActive(self.view.autoBuyRightDownBtn11, false)
end

function this:autoBuyLeftBtnOnClick()
    if self.leftSelectId ~= nil then
        self.leftSelectId = nil
        GUI:SetActive(self.view.autoBuyLeftBtnSelectImg, false)
        local globalTbl = string.split(SL:GetConfig("cfg_global", 430001).value, "#")
        GUI:Text_setText(self.view.autoBuyLeftBtnText, globalTbl[1])
        self:refreshBtnUI()
    else
        self:autoBuyLeftDownBtnOnClick()
    end
end

function this:autoBuyRightBtnOnClick()
    if self.rightSelectId ~= nil then
        self.rightSelectId = nil
        GUI:SetActive(self.view.autoBuyRightBtnSelectImg, false)
        local globalTbl = string.split(SL:GetConfig("cfg_global", 430001).value, "#")
        GUI:Text_setText(self.view.autoBuyRightBtnText, globalTbl[2])
        self:refreshBtnUI()
    else
        self:autoBuyRightDownBtnOnClick()
    end
end

function this:autoBuyLeftDownBtnOnClick()
    local isOpen = GUI:getVisible(self.view.leftDataPanel)
    if isOpen then
        GUI:SetActive(self.view.leftDataPanel, false)
        GUI:SetActive(self.view.autoBuyLeftDownBtn11, false)
    else
        local leftLen = table.count(self.LeftConfig)
        GUI:setContentSize(self.view.leftDataPanel, 188, leftLen * 38)
        GUI:setContentSize(self.view.scrollviewLeft, 188, leftLen * 38)
        GUI:setPosition(self.view.leftDataPanel, 13, 19 + leftLen * 38 / 2)
        GUI:SetActive(self.view.leftDataPanel, true)
        GUI:SetActive(self.view.autoBuyLeftDownBtn11, true)
        GUI:DataListInitData(self.view.datalistLeft, function()
            return table.count(self.LeftConfig)
        end, function()
        end, function()
        end, function(realIndex)
            local itemId = self.LeftConfig[realIndex + 1]
            local leftDataText = GUI:GetChildControl(self.view.datalistLeft, realIndex, 'leftDataText')
            local leftDataBtn = GUI:GetChildControl(self.view.datalistLeft, realIndex, 'leftDataBtn')
            local leftDataBtnSelectImg = GUI:GetChildControl(self.view.datalistLeft, realIndex, 'leftDataBtnSelectImg')
            local isSelect = false
            --[[            if self.leftDataBtnList[realIndex + 1] then
                            isSelect = self.leftDataBtnList[realIndex + 1].IsSelect
                        end]]
            --local tbl = SL:GetConfig("cfg_npcShop", dataInfo.goodsId, "id")
            local PortableShopInfo = SL:GetConfigMultiKeys("cfg_Portableshop", itemId, "itemId")
            if not table.isNullOrEmpty(PrivilegeCardManager.new_auto_buy_drug) then
                for _, v in pairs(PrivilegeCardManager.new_auto_buy_drug) do
                    local Portableshop = SL:GetConfig("cfg_Portableshop", v, "id")
                    if Portableshop.itemId == itemId then
                        isSelect = true
                    end
                end
            end
            GUI:Text_setText(leftDataText, PortableShopInfo.itemName)
            self.leftDataBtnList[realIndex + 1] = {
                leftDataBtnSelectImg = leftDataBtnSelectImg,
                IsSelect = isSelect,
                name = PortableShopInfo.itemName,
                index = realIndex + 1,
                itemId = PortableShopInfo.itemId
            }
            GUI:SetActive(leftDataBtnSelectImg, isSelect)
            GUI:AddOnClickEvent(leftDataBtn, self, self.leftDataBtnOnClick, self.leftDataBtnList[realIndex + 1])
        end)

        GUI:DataListUpdateData(self.view.datalistLeft, true)
    end
end

function this:leftDataBtnOnClick(_, data)
    if not PrivilegeCardManager.isautoPotion() then
        self:TipCard()
        return
    end
    for _, v in pairs(self.leftDataBtnList) do
        if v.index ~= data.index then
            v.IsSelect = false
            GUI:SetActive(v.leftDataBtnSelectImg, false)
        end
    end
    if data.IsSelect then
        data.IsSelect = false
        self.leftSelectId = nil
        GUI:SetActive(data.leftDataBtnSelectImg, false)
        local globalTbl = string.split(SL:GetConfig("cfg_global", 430001).value, "#")
        GUI:Text_setText(self.view.autoBuyLeftBtnText, globalTbl[1])
    else
        data.IsSelect = true
        local PortableShopInfo = SL:GetConfigMultiKeys("cfg_Portableshop", data.itemId, "itemId")
        self.leftSelectId = PortableShopInfo.id
        GUI:SetActive(data.leftDataBtnSelectImg, true)
        GUI:Text_setText(self.view.autoBuyLeftBtnText, data.name)
    end
    local isOpen = false
    for _, v in pairs(self.leftDataBtnList) do
        if v.IsSelect then
            isOpen = true
        end
    end
    GUI:SetActive(self.view.autoBuyLeftBtnSelectImg, isOpen)
    self:refreshBtnUI()
end

function this:autoBuyRightDownBtnOnClick()
    local isOpen = GUI:getVisible(self.view.RightDataPanel)
    if isOpen then
        GUI:SetActive(self.view.RightDataPanel, false)
        GUI:SetActive(self.view.autoBuyRightDownBtn11, false)
    else
        local leftLen = table.count(self.RightConfig)
        GUI:setContentSize(self.view.RightDataPanel, 188, leftLen * 38)
        GUI:setContentSize(self.view.scrollviewRight, 188, leftLen * 38)
        GUI:setPosition(self.view.RightDataPanel, 13, 19 + leftLen * 38 / 2)
        GUI:SetActive(self.view.RightDataPanel, true)
        GUI:SetActive(self.view.autoBuyRightDownBtn11, true)
        GUI:DataListInitData(self.view.datalistRight, function()
            return table.count(self.RightConfig)
        end, function()
        end, function()
        end, function(realIndex)
            local itemId = self.RightConfig[realIndex + 1]
            local RightDataText = GUI:GetChildControl(self.view.datalistRight, realIndex, 'RightDataText')
            local RightDataBtn = GUI:GetChildControl(self.view.datalistRight, realIndex, 'RightDataBtn')
            local RightDataBtnSelectImg = GUI:GetChildControl(self.view.datalistRight, realIndex, 'RightDataBtnSelectImg')
            local PortableShopInfo = SL:GetConfigMultiKeys("cfg_Portableshop", itemId, "itemId")
            local isSelect = false
            --[[
                        if self.RightDataBtnList[realIndex + 1] then
                            isSelect = self.RightDataBtnList[realIndex + 1].IsSelect
                        end]]
            --local tbl = SL:GetConfig("cfg_npcShop", dataInfo.goodsId, "id")
            if not table.isNullOrEmpty(PrivilegeCardManager.new_auto_buy_drug) then
                for _, v in pairs(PrivilegeCardManager.new_auto_buy_drug) do
                    local Portableshop = SL:GetConfig("cfg_Portableshop", v, "id")
                    if Portableshop.itemId == itemId then
                        isSelect = true
                    end
                end
            end
            GUI:Text_setText(RightDataText, PortableShopInfo.itemName)
            self.RightDataBtnList[realIndex + 1] = {
                RightDataBtnSelectImg = RightDataBtnSelectImg,
                IsSelect = isSelect,
                name = PortableShopInfo.itemName,
                index = realIndex + 1,
                itemId = PortableShopInfo.itemId
            }
            GUI:SetActive(RightDataBtnSelectImg, isSelect)
            GUI:AddOnClickEvent(RightDataBtn, self, self.RightDataBtnOnClick, self.RightDataBtnList[realIndex + 1])
        end)

        GUI:DataListUpdateData(self.view.datalistRight, true)
    end
end

function this:RightDataBtnOnClick(_, data)
    if not PrivilegeCardManager.isautoPotion() then
        self:TipCard()
        return
    end
    for _, v in pairs(self.RightDataBtnList) do
        if v.index ~= data.index then
            v.IsSelect = false
            GUI:SetActive(v.RightDataBtnSelectImg, false)
        end
    end
    if data.IsSelect then
        data.IsSelect = false
        self.rightSelectId = nil
        GUI:SetActive(data.RightDataBtnSelectImg, false)
        local globalTbl = string.split(SL:GetConfig("cfg_global", 430001).value, "#")
        GUI:Text_setText(self.view.autoBuyRightBtnText, globalTbl[2])
    else
        data.IsSelect = true
        local PortableShopInfo = SL:GetConfigMultiKeys("cfg_Portableshop", data.itemId, "itemId")
        self.rightSelectId = PortableShopInfo.id
        GUI:SetActive(data.RightDataBtnSelectImg, true)
        GUI:Text_setText(self.view.autoBuyRightBtnText, data.name)
    end

    local isOpen = false
    for _, v in pairs(self.RightDataBtnList) do
        if v.IsSelect then
            isOpen = true
        end
    end
    GUI:SetActive(self.view.autoBuyRightBtnSelectImg, isOpen)
    self:refreshBtnUI()
end

function this:refreshBtnUI()
    if self.leftSelectId and self.rightSelectId then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_AUTO_BUY_POTION_OPTION, { self.leftSelectId, self.rightSelectId })
        PrivilegeCardManager.new_auto_buy_drug = { self.leftSelectId, self.rightSelectId }
    elseif self.leftSelectId then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_AUTO_BUY_POTION_OPTION, { self.leftSelectId })
        PrivilegeCardManager.new_auto_buy_drug = { self.leftSelectId }
    elseif self.rightSelectId then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_AUTO_BUY_POTION_OPTION, { self.rightSelectId })
        PrivilegeCardManager.new_auto_buy_drug = { self.rightSelectId }
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_AUTO_BUY_POTION_OPTION, {})
        PrivilegeCardManager.new_auto_buy_drug = {}
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    --self.goods = SL:FindConfigs("cfg_npcShop", "shopId", self.args)

    SL.NpcShop:ReqNpcShopInfo(tonumber(self.args), self.ResNpcShopGoodsInfoMessage, self)
    --table.sort(self.goods, function(a, b)
    --    return a.id < b.id
    --end)
end

---@param message NpcShopProto.NpcShopGoodsInfoRes @商品信息响应
function this:ResNpcShopGoodsInfoMessage(_, message)
    self.goods = message["goodsList"]
    table.sort(self.goods, function(a, b)
        return a.id < b.id
    end)
    self:RefreshGoodsUI()
    self:UpdateMoney()

    --根据cfg_npclist表格中的参数,1和5是卖药的npc
    if tonumber(self.args) ~= 1 and tonumber(self.args) ~= 5 then
        GUI:SetActive(self.view.Left, false)
        GUI:SetActive(self.view.Right, false)
        GUI:SetActive(self.view.img1, false)
        GUI:SetActive(self.view.img2, false)
        return
    end
    GUI:SetActive(self.view.Left, true)
    GUI:SetActive(self.view.Right, true)
    GUI:SetActive(self.view.img1, true)
    GUI:SetActive(self.view.img2, true)
    self.LeftConfig = {}
    self.RightConfig = {}
    for _, v in pairs(self.goods) do
        local gooditem = SL:GetConfig("cfg_npcShop", v.id, "id")
        if gooditem.group == 1 and ConditionManager.Check4D(gooditem.bugCondition) then
            if not table.contains(self.LeftConfig, gooditem.itemId) then
                table.insert(self.LeftConfig, gooditem.itemId)
            end
        end
        if gooditem.group == 2 and ConditionManager.Check4D(gooditem.bugCondition) then
            if not table.contains(self.RightConfig, gooditem.itemId) then
                table.insert(self.RightConfig, gooditem.itemId)
            end
        end
    end
    --GUI:DataListUpdateData(self.view.datalistRight, true)
    --GUI:DataListUpdateData(self.view.datalistLeft, true)
    if not table.isNullOrEmpty(PrivilegeCardManager.new_auto_buy_drug) then
        for _, v in pairs(PrivilegeCardManager.new_auto_buy_drug) do
            local Portableshop = SL:GetConfig("cfg_Portableshop", v, "id")
            for _, left in pairs(self.LeftConfig) do
                if Portableshop.itemId == left then
                    self.leftSelectId = v
                    GUI:SetActive(self.view.autoBuyLeftBtnSelectImg, true)
                    GUI:Text_setText(self.view.autoBuyLeftBtnText, Portableshop.itemName)
                end
            end
            for _, right in pairs(self.RightConfig) do
                if Portableshop.itemId == right then
                    self.rightSelectId = v
                    GUI:SetActive(self.view.autoBuyRightBtnSelectImg, true)
                    GUI:Text_setText(self.view.autoBuyRightBtnText, Portableshop.itemName)
                end
            end
        end
    else
        local globalTbl = string.split(SL:GetConfig("cfg_global", 430001).value, "#")
        GUI:SetActive(self.view.autoBuyLeftBtnSelectImg, false)
        GUI:SetActive(self.view.autoBuyRightBtnSelectImg, false)
        GUI:Text_setText(self.view.autoBuyLeftBtnText, globalTbl[1])
        GUI:Text_setText(self.view.autoBuyRightBtnText, globalTbl[2])
    end
end

function this:RefreshGoodsUI()
    for _,v in pairs(self.animList) do
        if v then
            GUI:DOKill(v)
        end
    end
    self.animList = {}
    if not self.bagUI then
        GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", nil, nil,
            { x = -414, y = 0, bagType = EBagShowType.NPCShop }, false, function(bagUI)
                self.bagUI = bagUI
            end)
    end

    if PrivilegeCardManager.AutoBuyIsOpen() then
        GUI:SetActive(self.view.autoBuyToggleCheck, false)
    else
        GUI:SetActive(self.view.autoBuyToggleCheck, false)
    end

    local tasks = SL:GetMetaValue("PROCESS_TASK")
    local taskInfos = SL:TaskInfo_GetAllTasks()
    self.taskItems = {}
    local scrollIndex
    for k, v in pairs(tasks) do
        local taskInfo = taskInfos[v]
        local isFinish = false
        if taskInfo then
            local finish = true
            for _, goal in pairs(taskInfo.taskGoalRecord) do
                if goal.count < goal.maxCount then
                    finish = false
                    break
                end
            end
            isFinish = finish
        end
        local task = SL:GetConfig("cfg_task", v)
        for _, taskTargetId in pairs(task.taskTargetId) do
            local target = SL:GetConfig("cfg_task_target", taskTargetId)
            if target.taskGoalType == 1 and not isFinish then
                if target.taskGoalParam > 0 then
                    table.insert(self.taskItems, target.taskGoalParam)
                end
                if not table.isNullOrEmpty(target.taskGoalParam2) then
                    for i, j in pairs(target.taskGoalParam2) do
                        table.insert(self.taskItems, j)
                    end
                end
            elseif target.taskGoalType == 32 and not isFinish then
                if target.taskGoalParam > 0 then
                    table.insert(self.taskItems, target.taskGoalParam)
                    if not scrollIndex then
                        for kk, vv in ipairs(self.goods) do
                            local gooditem = SL:GetConfig("cfg_npcShop", vv.id, "id")
                            if gooditem.itemId == target.taskGoalParam then
                                scrollIndex = kk
                                break
                            end
                        end
                    end
                end
                if not table.isNullOrEmpty(target.taskGoalParam2) then
                    for i, j in pairs(target.taskGoalParam2) do
                        table.insert(self.taskItems, j)
                        if not scrollIndex then
                            for kk, vv in ipairs(self.goods) do
                                local gooditem = SL:GetConfig("cfg_npcShop", vv.id, "id")
                                if gooditem.itemId == j then
                                    scrollIndex = kk
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    if InfoManager.mainUIInfo.reliveBuyItemId then
        --logError("药品id： ".. InfoManager.mainUIInfo.reliveBuyItemId)
        table.insert(self.taskItems, InfoManager.mainUIInfo.reliveBuyItemId)
        for k, v in ipairs(self.goods) do
            local gooditem = SL:GetConfig("cfg_npcShop", v.id, "id")
            if gooditem.itemId == InfoManager.mainUIInfo.reliveBuyItemId then
                scrollIndex = k
                break
            end
        end
        InfoManager.mainUIInfo:SetReliveBuyItemId()
    end
    GUI:DataListUpdateData(self.view.goods, nil, function()
        -- if scrollIndex and scrollIndex > 7 then
        --     SL:ScheduleOnce(0.1, function()
        --         GUI:setPositionY(self.view.ItemLayout, 370)
        --     end)
        -- end
            SL:ScheduleOnce(0.1, function()
                scrollIndex = scrollIndex and scrollIndex or 1
                local percentage = scrollIndex / #self.goods
                percentage = percentage - percentage % 0.00001
                if scrollIndex == 1 then
                    percentage = 0
                elseif scrollIndex == #self.goods then
                    percentage = 1
                end
                GUI:SetScrollView_scrollpos(self.view.ItemList, percentage)
            end)
        
    end)
end

function this:DataListGoodsItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.goods[realIndex + 1]
    if data == nil then
        return
    end
    local showItem_ = GUI:GetChildControl(self.view.goods, realIndex, "show_item")
    local itemclick = GUI:GetChildControl(self.view.goods, realIndex, "item_click")
    -- local title_ = GUI:GetChildControl(self.view.goods, realIndex, "title_")
    -- local coinitem = GUI:GetChildControl(self.view.goods, realIndex, "coinitem")
    -- local coinClick = GUI:GetChildControl(self.view.goods, realIndex, "coinClick")
    -- local coinnum = GUI:GetChildControl(self.view.goods, realIndex, "coinnum")
    -- local buy = GUI:GetChildControl(self.view.goods, realIndex, "buy")
    -- local light = GUI:GetChildControl(self.view.goods, realIndex, "light")

    local gooditem = SL:GetConfig("cfg_npcShop", data.id, "id")
    GUI:Item_UpdataData(showItem_, {
        itemid = gooditem.itemId,
        itemcount = gooditem.number
    })
    
    -- gooditem = SL:GetConfig("cfg_npcShop", data.id, "id")
    -- local price = data.unitPrice * data.count
    -- if ConditionManager.Check4D(gooditem.bugCondition) then
    --     GUI:SetActive(coinitem, true)
    --     GUI:Item_setItemId(coinitem, data.coinType)
    --     GUI:setPosition(coinnum, 104, -17)
    --     GUI:setColor(coinnum, "#fbd994")
    --     GUI:AddOnClickEvent(coinClick, self, function()
    --         SL:OpenTips(nil, data.coinType)
    --     end)
    --     GUI:Text_setString(coinnum, tostring(price))
    -- else
    --     GUI:SetActive(coinitem, false)
    --     GUI:Text_setString(coinnum, string.format("%s级开放", gooditem.bugCondition[1][1][2]))
    --     GUI:setPosition(coinnum, 75, -17)
    --     GUI:setColor(coinnum, "#f23f23")
    --     --SL:TipMessage( string.format("%s级开放",gooditem.bugCondition[1][1][2]),1, NoticeType.NoticeMid )
    -- end
    GUI:AddOnClickEvent(itemclick, self, function()
        --SL:OpenTips(nil, gooditem.itemId)
        self:ClickBuy(nil, data)
    end)

    -- GUI:Text_setString(title_, gooditem.itemName)
    -- if table.contains(self.taskItems, gooditem.itemId) then
    --     GUI:setVisible(light, true)
    --     self.animList[realIndex] = GUI:DOAlphaImage(light,0,1)
    --     GUI:TweenSetLoops( self.animList[realIndex] ,-1)
    --     GUI:TweenSetEase( self.animList[realIndex] ,ELeanTweenType.pingPong)
    -- else
    --     if self.animList[realIndex] then
    --         GUI:DOKill(self.animList[realIndex])
    --         self.animList[realIndex] = nil
    --     end
    --     GUI:setVisible(light, false)
    -- end
    -- GUI:AddOnClickEvent(buy, self, self.ClickBuy, data)
end

function this:ClickBuy(_, data)
    local gooditem = SL:GetConfig("cfg_npcShop", data.id, "id")
    local price = data.unitPrice * data.count
    local function okFunc()
        if price > SL:GetBagItemCount(data.coinType) then
            SL:CommonItemGetPath(nil, data.coinType)
            SL:TipMessage("消耗道具不足", 1, NoticeType.NoticeMid)
            return
        end
        if ConditionManager.Check4D(gooditem.bugCondition) then
            SL.NpcShop:ReqBuyShopGoods(self.args, data.goodsId, data.count, self.ResBuyShopGoodsMessage, self)
        else
            SL:TipMessage(string.format("%s级开放", gooditem.bugCondition[1][1][2]), 1, NoticeType.NoticeMid)
        end
    end

    local midDesc = SL:GetConfig("cfg_item", gooditem.itemId).midDesc
    --if not ConditionManager.Check4D(gooditem.bugCondition) then
        midDesc = midDesc .. "\n" ..string.format("需要%s级开放", gooditem.bugCondition[1][1][2])
    --end
    local price_name = SL:GetConfig("cfg_item", data.coinType).name
    midDesc = midDesc .. "\n" .. "是否花费" .. price .. price_name .."购买？"
    SL:CommonTipsMessage({
        title = "购买提示",
        showTips = midDesc,
        sureBtnText = "购买",
        cancelBtnText = "取消",
        cancelCallBack = nil,
        callback = okFunc,
        closeCallBack = nil,
    })
end

--自动购买
function this:AutoBuy()
    if not PrivilegeCardManager.isautoPotion() then
        self:TipCard()
        return
    end
    PrivilegeCardManager.ReqAutoBuyDrug()
end

function this:TipCard()
    -- local tipsData = self:AutoBuyTips()
    -- self.leftJump = tipsData.leftUI
    -- self.rightJump = tipsData.rightUI
    -- SL:CommonTipsMessage({
    --     showTips = tipsData.text,
    --     ui = self,
    --     sureBtnText = tipsData.rightText,
    --     cancelBtnText = tipsData.leftText,
    --     callback = self.TipsRight,
    --     cancelCallBack = self.TipsLeft
    -- })

    SL:OpenCommonTipPanelById(6)
end

function this:UpdateAutoBuy()
    if PrivilegeCardManager.AutoBuyIsOpen() then
        GUI:SetActive(self.view.autoBuyToggleCheck, true)
    else
        GUI:SetActive(self.view.autoBuyToggleCheck, false)
    end
end

function this:AutoBuyTips()
    local str = SL:GetConfig("cfg_global", 290001).value
    local strTbl = string.splitByAll(str, "#")
    local data = {
        text = strTbl[1],
        leftText = not string.isNullOrEmpty(strTbl[2]) and strTbl[2] or "取消",
        leftUI = strTbl[3],
        rightText = not string.isNullOrEmpty(strTbl[4]) and strTbl[4] or "确定",
        rightUI = strTbl[5],
    }
    return data
end

function this:TipsLeft(data)
    if string.isNullOrEmpty(self.leftJump) then
        return
    end
    if self.leftJump == "dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel" then
        return
    end
    GUI:UIPanel_Open(self.leftJump)
    self:ClosePanel()
end

function this.TipsRight(data)
    if string.isNullOrEmpty(data.ui.rightJump) then
        return
    end
    if data.ui.rightJump == "dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel" then
        return
    end

    GUI:UIPanel_Open(data.ui.rightJump)
    data.ui:ClosePanel()
end

function this:OpenFirsh()
    --SL:TipMessage({ "首充还未开通", 1, NoticeType.NoticeMid })
    this:ClosePanel()
    --GUI:UIPanel_Open("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel")
    --if InfoManager.monthCardInfo:IsHaveMonthCardRights("privilege") then
    --    GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel", nil, nil, { type = "privilege" })
    --else
    --    GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
    --end
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", nil, nil, { 2 })
end

function this:DesBtn()
    local helpCfg = SL:GetConfig("cfg_rule_text", 13, "id")
    if helpCfg then
        SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
    end
    --GUI:UIPanel_Open("dev/ui/NPC/Panel/KLNPCShopTip/KLNPCShopTipPanel")
end

---@param message NpcShopProto.BuyShopGoodsReq @购买成功回调
function this:ResBuyShopGoodsMessage(_, message)
    local data = {}
    local tbl = SL:GetConfig("cfg_npcShop", message.goodsId, "id")
    local canputbag = SL:CanPutToBag(tbl.itemId, message.count)
    if canputbag then
        data[tbl.itemId] = message.count
        SL:OpenRewardTips(data, 0)  
    end
    SL:ScheduleOnce(Time.deltaTime, function()
        self:RefreshGoodsUI()
    end)
end

--刷新货币数据
function this:UpdateMoney()
    GUI:Text_setString(self.view.txt_gold, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.GoldMoney)))
    GUI:Text_setString(self.view.txt_diamond, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.DiaMond)))
    --[[    GUI:Image_loadTexture(self.view.MUBindCoinIcon, "10050001", "Atlas/TS_Common.spriteatlas")
    GUI:Text_setString(self.view.moneyText, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.GoldMoney)))
    GUI:Text_setString(self.view.muCoinText,
        tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.MiracleCurrency)))
    GUI:Text_setString(self.view.muBindCoinText,
        tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.BindDiaMond)))
    GUI:Text_setString(self.view.diamondText, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.DiaMond)))]]
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel")
end

function this:Close()
    for _,v in pairs(self.animList) do
        if v then
            GUI:DOKill(v)
        end
    end
    SL:UnRegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.UpdateMoney, self)
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    SL:ShowMainPanel()
end

return this

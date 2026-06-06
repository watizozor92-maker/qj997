---@class KLLuckyTurnTablePanel:UIKmlLuaPanelBase
---@field view KLLuckyTurnTablePanelView
local KLLuckyTurnTablePanel = class(UIKmlLuaPanelBase)
local this = KLLuckyTurnTablePanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    if self.args then
        self.mainOperateActivityInfo = self.args.OperateActivityInfo
        if self.args.showType == EOperateActivityType.Week then
            self.luckyTurnTableInfo = InfoManager.luckyTurnTableSecondInfo
            
            self.RES_MAIN_ACTIVE_INFO_M = LuaMessageIdToClient.RES_WEEKEN_GIFT
            self.RES_TURNTABLE_RAFFLE_FREE_TIME_M = LuaMessageIdToClient.RES_WEEK_TURNTABLE_RAFFLE_FREE_TIME
            self.RES_TURNTABLE_RAFFLE_REWARD_IDS_M = LuaMessageIdToClient.RES_WEEK_TURNTABLE_RAFFLE_REWARD_IDS
            self.RES_TURNTABLE_RAFFLE_REWARD_COUNT_INFO_M = LuaMessageIdToClient.RES_WEEK_TURNTABLE_RAFFLE_REWARD_COUNT_INFO

            self.REQ_MAIN_ACTIVE_INFO = LuaMessageIdToSever.REQ_WEEKEN_ACTIVE_INFO
            self.REQ_TURNTABLE_REWARD_COUNT_INFO = LuaMessageIdToSever.REQ_WEEK_TURNTABLE_REWARD_COUNT_INFO
            self.REQ_CHANGE_SKIP_ANIMATION = LuaMessageIdToSever. REQ_WEEK_CHANGE_SKIP_ANIMATION
            self.REQ_TURNTABLE_RAFFLE_DRAWING = LuaMessageIdToSever.REQ_WEEK_TURNTABLE_RAFFLE_DRAWING
        else
            self.luckyTurnTableInfo = InfoManager.luckyTurnTableInfo
            
            self.RES_MAIN_ACTIVE_INFO_M = LuaMessageIdToClient.RES_MAIN_ACTIVE_INFO
            self.RES_TURNTABLE_RAFFLE_FREE_TIME_M = LuaMessageIdToClient.RES_TURNTABLE_RAFFLE_FREE_TIME
            self.RES_TURNTABLE_RAFFLE_REWARD_IDS_M = LuaMessageIdToClient.RES_TURNTABLE_RAFFLE_REWARD_IDS
            self.RES_TURNTABLE_RAFFLE_REWARD_COUNT_INFO_M = LuaMessageIdToClient.RES_TURNTABLE_RAFFLE_REWARD_COUNT_INFO

            self.REQ_MAIN_ACTIVE_INFO = LuaMessageIdToSever.REQ_MAIN_ACTIVE_INFO
            self.REQ_TURNTABLE_REWARD_COUNT_INFO = LuaMessageIdToSever.REQ_TURNTABLE_REWARD_COUNT_INFO
            self.REQ_CHANGE_SKIP_ANIMATION = LuaMessageIdToSever.REQ_CHANGE_SKIP_ANIMATION
            self.REQ_TURNTABLE_RAFFLE_DRAWING = LuaMessageIdToSever.REQ_TURNTABLE_RAFFLE_DRAWING
        end
    end
    self.ItemPos = {}
    self.ShowCount = 16
    self.speed = 0.02
    self.IsSkip = self.luckyTurnTableInfo.IsSkip
    self.LuckyTurnTableItemList = {}
    self.IsAnimation = false
    self.CurSelectCountPosIndex = 1--当前停留的位置
    self.ShowItemList = {}

    self.oneCost = nil
    self.tenCost = nil

    self.bigListItemList = {}---大奖展示
    self.received = nil
    self.CountRewardList = {} ---次数奖励
    self.CountRewardTbl = {}
    self.totalCount = 0

    self.ShowBigBigTbl = nil
    GUI:SetActive(self.view.rewardShow, true)
    GUI:SetActive(self.view.getShow, false)
    self:InitCountRewardList()

    GUI:setScale(self.view.GetShowText,0.5)
end
function this:InitCountRewardList()
    GUI:DataListInitData(self.view.Reward_list, function()
        return table.count(self.CountRewardTbl)
    end, function()
        local item = GUI:UIPanel_Open("dev/outui/OperateActivity/Item/KLTurnTableGetAward/KLTurnTableGetAwardItem", self.view.Reward_list, self, nil, true)
        if not self.CountRewardItemList then
            self.CountRewardItemList = {}
        end
        local kmlCtrl = item.view.root
        self.CountRewardItemList[kmlCtrl] = item
        return kmlCtrl
    end, function()
    end, function(realIndex, kmlCtrl)
        local luaIndex = realIndex + 1
        local item = self.CountRewardItemList[kmlCtrl]
        local CountRewardTbl = self.CountRewardTbl
        if CountRewardTbl then
            item:UpDataUI(CountRewardTbl[luaIndex], luaIndex, self.totalCount, self.received, self.curTurnTbl.id,self.args.showType)
        end
    end)
end
---界面显示时调用一次
function this:Show()
    for i = 1, self.ShowCount do
        self.ItemPos[i] = GUI:GetChildById(self.view.table, tostring(i))
    end
    self.careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)

end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.mainOperateActivityInfo then
        GUI:Text_setString(self.view.freeTime, "")
        self.groupId = self.mainOperateActivityInfo.NowOperateActivityMainGroup
        self.curTurnTbl = self.luckyTurnTableInfo:GetTurnTableDataByActivityId(self.groupId)
        if self.curTurnTbl then
            self.oneCost = self.curTurnTbl.oneCost
            self.tenCost = self.curTurnTbl.manyCost
            self:ShowCostItemCount()
            self:BtnTextUpdata()
            self:ShowRewardItem(self.curTurnTbl.reward)
            self:ShowBigReward(self.curTurnTbl.id)
            SL:SendLuaNetMsg(self.REQ_MAIN_ACTIVE_INFO, { subType = EOperateActivityActivityType.luckyTurnTable, mainGroup = self.groupId })
            SL:SendLuaNetMsg(self.REQ_TURNTABLE_REWARD_COUNT_INFO, { id = self.curTurnTbl.id })
        end
    end
end
---显示玩家寻宝券数量
function this:ShowCostItemCount()
    local allCount = self:GetCoinCount(self.oneCost[1])
    GUI:Text_setString(self.view.ModelCount, GUIUtil.FormatNumber(tostring(allCount)))
    GUI:Item_setItemId(self.view.xunbaoquanModel, self.oneCost[1])
    GUI:Item_setItemId(self.view.OnecostModel, self.oneCost[1])
    GUI:Item_setItemId(self.view.TenCostModel, self.oneCost[1])
    GUI:setScale(self.view.xunbaoquanModel, 0.5)
    GUI:setScale(self.view.OnecostModel, 0.5)
    GUI:setScale(self.view.TenCostModel, 0.5)

end
function this:GetCoinCount(coinId)
    if coinId == 10050001 then
        --绑钻
        return SL:GetBagItemCount(coinId) + SL:GetBagItemCount(10040001)
    else
        return SL:GetBagItemCount(coinId)
    end
end
function this:BtnTextUpdata()
    local needNum1 = self.oneCost[2] - self:GetCoinCount(self.oneCost[1])
    local needNum2 = self.tenCost[3] - self:GetCoinCount(self.tenCost[2])
    if needNum1 > 0 then
        GUI:Text_setString(self.view.oneBtnTextCount, self:ReturnRichTextByColorAndText(EColor[EGradColor.red], "X" .. self.oneCost[2]))
    else
        GUI:Text_setString(self.view.oneBtnTextCount, self:ReturnRichTextByColorAndText(EColor[EGradColor.green], "X" .. self.oneCost[2]))
    end
    if needNum2 > 0 then
        GUI:Text_setString(self.view.tenBtnTextCount, self:ReturnRichTextByColorAndText(EColor[EGradColor.red], "X" .. self.tenCost[3]))
    else
        GUI:Text_setString(self.view.tenBtnTextCount, self:ReturnRichTextByColorAndText(EColor[EGradColor.green], "X" .. self.tenCost[3]))
    end
    if self.IsFree then
        --免费
        GUI:SetActive(self.view.FreeRedDot, true)
        GUI:SetActive(self.view.oneBtnImage, false)
        GUI:Text_setString(self.view.oneBtnTextCount, self:ReturnRichTextByColorAndText(EColor[EGradColor.green], "免费"))
    else
        GUI:SetActive(self.view.FreeRedDot, false)
        GUI:SetActive(self.view.oneBtnImage, true)
        if needNum1 > 0 then
            GUI:Text_setString(self.view.oneBtnTextCount, self:ReturnRichTextByColorAndText(EColor[EGradColor.red], "X" .. self.oneCost[2]))
        else
            GUI:Text_setString(self.view.oneBtnTextCount, self:ReturnRichTextByColorAndText(EColor[EGradColor.green], "X" .. self.oneCost[2]))
        end
    end
    local allCount = self:GetCoinCount(self.oneCost[1])
    GUI:Text_setString(self.view.ModelCount, GUIUtil.FormatNumber(tostring(allCount)))
end
---奖励展示16个
function this:ShowRewardItem(groupId)
    ---@type cfg_turntable_reward_column[]
    local turnRewardTbl = SL:GetConfigTable("cfg_turntable_reward")
    for i, v in pairs(turnRewardTbl) do
        if v.group == groupId and (v.condition == "" or ConditionManager.Check4D(v.condition)) then
            if self.LuckyTurnTableItemList[v.order] == nil then
                local LuckyTurnTableItem = GUI:UIPanel_Open("dev/outui/OperateActivity/Item/KLLuckyTurnTable/KLLuckyTurnTableItem", self.ItemPos[v.order], self, nil, true)
                self.LuckyTurnTableItemList[v.order] = LuckyTurnTableItem
            end
            self.LuckyTurnTableItemList[v.order]:UpDataUI(v)
            self.LuckyTurnTableItemList[v.order]:InitCount(v.num)
            if v.type == 1 then
                self.ShowBigBigTbl = v
            end
        end
    end
end
---显示中间大奖
function this:ShowBigReward(groupId)
    local bigList = self.luckyTurnTableInfo:GetTurnTableBigListByActivityId(groupId)
    for i, v in pairs(bigList) do
        if self.bigListItemList[i] == nil then
            local BigTurnTableItem = GUI:UIPanel_Open("dev/outui/OperateActivity/Item/KLTurnTableAward/KLTurnTableAwardItem", self.view.rewardShowGrid, self, nil, true)
            self.bigListItemList[i] = BigTurnTableItem
        end
        self.bigListItemList[i]:UpDataUI(v, i, self.totalCount, self.received, self.curTurnTbl.id)
    end
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.OneBtn, self, self.OneBtnOnclick)
    GUI:AddOnClickEvent(self.view.TenBtn, self, self.TenBtnOnclick)
    GUI:AddOnClickEvent(self.view.oddsBtn, self, self.oddsBtn)
    GUI:SetToggleOnValueChange(self.view.SkipToggle, self, self.SkipToggleOnclick)
    SL:RegisterLuaNetMsg(self.RES_MAIN_ACTIVE_INFO_M, self.RES_MAIN_ACTIVE_INFO, self)-- 响应抽奖界面
    SL:RegisterLuaNetMsg(self.RES_TURNTABLE_RAFFLE_FREE_TIME_M, self.RES_TURNTABLE_RAFFLE_FREE_TIME, self)-- 响应抽奖免费时间
    SL:RegisterLuaNetMsg(self.RES_TURNTABLE_RAFFLE_REWARD_IDS_M, self.RES_TURNTABLE_RAFFLE_REWARD_IDS, self)-- 响应转盘抽奖奖励id列表
    SL:RegisterLuaNetMsg(self.RES_TURNTABLE_RAFFLE_REWARD_COUNT_INFO_M, self.RES_TURNTABLE_RAFFLE_REWARD_COUNT_INFO, self)-- 响应转盘抽奖奖励id列表
    --SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    --SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
end
function this:LUA_EVENT_BAG_CHANGE_AFTER(_, message)
    if message then
        self:BtnTextUpdata()
    end
end
function this:RES_TURNTABLE_RAFFLE_REWARD_COUNT_INFO(_, message)
    if message then
        for id, value in pairs(message) do
            if next(self.LuckyTurnTableItemList) then
                ---刷新剩余次数
                for _, showList in pairs(self.LuckyTurnTableItemList) do
                    if showList.data.id == tonumber(id) then
                        local reCount = showList.data.num - tonumber(value)
                        showList:InitCount(reCount)
                    end

                end
            end
            if  self.ShowBigBigTbl and  self.ShowBigBigTbl.id == tonumber(id) then
                local reCount = self.ShowBigBigTbl.num - tonumber(value)
                if reCount > 0 then
                    GUI:SetActive(self.view.GetShowText,true)
                else
                    GUI:SetActive(self.view.GetShowText,false)
                end
            end
        end
    end
end
function this:oddsBtn()
    local helpCfg = SL:GetConfig("cfg_rule_text", 301, "id")
    if helpCfg then
        SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
    end
end
function this:RES_TURNTABLE_RAFFLE_FREE_TIME(_, message)
    if message then
        self:ShowFreeTime(tonumber(message.nextFreeTime))
        --self.IsFree = message.isFree
    end
end
function this:RES_MAIN_ACTIVE_INFO(_, message)
    -----面板信息
    if message and next(message.turntableRaffleActive) then
        self.totalCount = 0
        self.received = {}
        --GUI:Toggle_setIsOn(self.view.SkipToggle, self.IsSkip)
        if self.curTurnTbl then
            local curTurnTblId = tostring(self.curTurnTbl.id)
            self.totalCount = message.turntableRaffleActive[curTurnTblId].total--抽奖总次数
            local canFree = message.turntableRaffleActive[curTurnTblId].canFree--可否免费抽奖
            local freeTime = message.turntableRaffleActive[curTurnTblId].freeTime--下次免费抽奖开启时间戳
            local count = message.turntableRaffleActive[curTurnTblId].count--累加次数 前端忽略
            self.received = message.turntableRaffleActive[curTurnTblId].received--已经领取过的奖励id cfg_turntable_extra表id
            local skipAnimation = message.turntableRaffleActive[curTurnTblId].skipAnimation--是否跳过动画
            self.IsFree = canFree
            if  self.ShowBigBigTbl then
                local showTimes =  self.ShowBigBigTbl.guarantees - self.totalCount
                if showTimes > 0 then
                    GUI:Text_setString(self.view.GetShowText, "<color=#e6e600>还剩" .. showTimes .. "抽必得</color><color=#ff8a00>极品大奖</color>")
                    GUI:setPosition(self.view.rewardShowGrid,0,-12)
                else
                    GUI:setPosition(self.view.rewardShowGrid,0,0)
                end
            end
            GUI:Text_setString(self.view.NowTimeText, tostring(self.totalCount))
            if skipAnimation == 0 then
                self.IsSkip = false
            elseif skipAnimation == 1 then
                self.IsSkip = true
            end
            if self.IsAnimation then

            end
            GUI:Toggle_setIsOn(self.view.SkipToggle, self.IsSkip)
            self:ShowFreeTime(tonumber(freeTime))

            self:ShowTime(self.mainOperateActivityInfo:GetOADJSTimeBySubType(EOperateActivityActivityType.luckyTurnTable) * 1000 + Time.GetServerTime())
            self:BtnTextUpdata()
            self.CountRewardTbl = self.luckyTurnTableInfo:GetTurnTableAwardListByActivityId(curTurnTblId)

            GUI:DataListUpdateData(self.view.Reward_list)
            self:ShowBigReward(self.curTurnTbl.id)
            for i, v in pairs(self.CountRewardTbl) do
                if not self.luckyTurnTableInfo:IsGetReceived(v.id, self.received) then
                    if i == 1 then
                        break 
                    end
                    GUI:SetScrollView_scrollpos(self.view.scrollview1, (i - 1) / (table.count(self.CountRewardTbl) - 3)+0.05)
                    break
                end
            end
        end
    end
end
function this:ShowTime(endTime)
    local len = (endTime - Time.GetServerTime()) // 1000 + 1
    if len > 0 then
        self.Timer = SL:Schedule(self.Timer, 0, 1, len, function()
            local timeText = endTime - Time.GetServerTime()
            if timeText <= 21600000 then
                GUI:Text_setString(self.view.reTime, "<color=#FF4F47>剩余时间：" .. GUIUtil.FormatTimeHMSD_S(timeText // 1000) .. "</color>")
            else
                GUI:Text_setString(self.view.reTime, "<color=#5DE367>剩余时间：" .. GUIUtil.FormatTimeHMSD_S(timeText // 1000) .. "</color>")
            end
            if timeText <= 0 then
                GUI:Text_setString(self.view.freeTime, "")
                return
            end
        end)
    end
end
function this:ShowFreeTime(endTime)
    local len = (endTime - Time.GetServerTime()) // 1000 + 1
    if len > 0 then
        self.FreeTimer = SL:Schedule(self.FreeTimer, 0, 1, len, function()
            local timeText = endTime - Time.GetServerTime()
            GUI:Text_setString(self.view.freeTime, "<color=#5DE367>" .. GUIUtil.FormatTimeHMSD_S(timeText // 1000) .. "</color>" .. "后免费")
            if timeText <= 0 then
                self.IsFree = true
                self:BtnTextUpdata()
                GUI:Text_setString(self.view.freeTime, "")
                return
            end
        end)
    end
end
function this:SkipToggleOnclick(kmlCtrl, eventData, args)
    if args[1] then
        SL:SendLuaNetMsg(self.REQ_CHANGE_SKIP_ANIMATION, { skipAnimation = 1, id = self.curTurnTbl.id })
    else
        SL:SendLuaNetMsg(self.REQ_CHANGE_SKIP_ANIMATION, { skipAnimation = 0, id = self.curTurnTbl.id })
    end
    self.IsSkip = args[1]
    self.luckyTurnTableInfo.IsSkip = args[1]
end
function this:OneBtnOnclick(control)
    if self.IsAnimation then
        return
    end
    if self.IsFree then
        SL:SendLuaNetMsg(self.REQ_TURNTABLE_RAFFLE_DRAWING, { id = self.curTurnTbl.id, isFree = self.IsFree, times = 1 })
        return
    end
    local needNum1 = self.oneCost[2] - self:GetCoinCount(self.oneCost[1])
    if needNum1 > 0 then
        SL:CommonItemGetPath(nil, self.oneCost[1])
        return
    end
    if needNum1 <= 0 then
        SL:SendLuaNetMsg(self.REQ_TURNTABLE_RAFFLE_DRAWING, { id = self.curTurnTbl.id, times = 1 })
    end

end

function this:TenBtnOnclick(control)
    if self.IsAnimation then
        return
    end
    local needNum2 = self.tenCost[3] - self:GetCoinCount(self.tenCost[2])
    if needNum2 > 0 then
        SL:CommonItemGetPath(nil, self.tenCost[2])
        return
    end
    if needNum2 <= 0 then
        SL:SendLuaNetMsg(self.REQ_TURNTABLE_RAFFLE_DRAWING, { id = self.curTurnTbl.id, times = self.tenCost[1] })
    end

end
function this:RES_TURNTABLE_RAFFLE_REWARD_IDS(id, message)
    if message then
        local rewardIdList = {}
        for i, v in pairs(message) do
            local index = tonumber(i)
            for id, count in pairs(v) do
                rewardIdList[index] = tonumber(id)
            end
        end
        if self.IsSkip then
            self:NoAnimation(rewardIdList)
        else
            self:AnimationShow(rewardIdList)
        end
    end
end
---计算步数结果
function this:StepCount(oldIndex, newIndex)
    local step = 0
    if newIndex > oldIndex then
        --最终位置大于初始位置
        step = newIndex - oldIndex
    elseif newIndex < oldIndex then
        --最终位置小于初始位置
        step = newIndex + self.ShowCount - oldIndex
    else
        --位置相等 在转一圈
        step = self.ShowCount
    end
    return step
end
function this:FindOrderById(rewardList)
    local List = {}
    for i, v in pairs(rewardList) do
        local tbl = SL:GetConfig("cfg_turntable_reward", tonumber(v))
        local order = tbl.order
        local index = tonumber(i)
        List[index] = order
    end
    return List
end
--抽奖动画
function this:AnimationShow(EndSelectCountPosIndexList)
    local rewardList = self:FindOrderById(EndSelectCountPosIndexList)
    if self.timer then
        Coroutine.Stop(self.timer)
        self.timer = nil
    end
    local step = 0
    local ListLen = #rewardList
    local oldIndex = self.CurSelectCountPosIndex
    local StepList = {}
    local itemList = {}
    for i, newIndex in pairs(rewardList) do
        step = step + self:StepCount(oldIndex, newIndex)
        oldIndex = newIndex
        StepList[i] = step
    end
    for i, Index in pairs(EndSelectCountPosIndexList) do
        local items = SL:GetConfig("cfg_turntable_reward", tonumber(Index)).item
        for _, v in pairs(items) do
            if v[1] == self.careerId then
                local tbl = {
                    cfgId = v[2],
                    count = v[3]
                }
                table.insert(itemList, tbl)
            end
        end
    end

    self.timer = Coroutine.Start(function()
        self.IsAnimation = true
        GUI:SetActive(self.view.rewardShow, false)
        GUI:SetActive(self.view.getShow, true)
        local CircleCount = self.ShowCount * 2 + step
        local count = 0
        local StepListIndex = 1
        local firstCircle = 0
        local itemIndex = 0
        local nowIndex = self.CurSelectCountPosIndex
        while CircleCount > 0 do
            if firstCircle == 0 then
                self:ShowPointSelect(nowIndex)
                nowIndex = nowIndex + 1
                if nowIndex > 16 then
                    nowIndex = nowIndex - 16
                end
                if nowIndex == self.CurSelectCountPosIndex then
                    firstCircle = firstCircle + 1
                end
                Coroutine.Wait(self.speed / 2)
            else
                self.CurSelectCountPosIndex = (self.CurSelectCountPosIndex + 1) % self.ShowCount
                if self.CurSelectCountPosIndex == 0 then
                    self.CurSelectCountPosIndex = self.ShowCount
                end
                self:ShowPointSelect(self.CurSelectCountPosIndex)
                CircleCount = CircleCount - 1
                count = count + 1
                if count == StepList[StepListIndex] + self.ShowCount * 2 then
                    --展示奖品
                    itemIndex = itemIndex + 1
                    self:ShowGetRewardItem(EndSelectCountPosIndexList[StepListIndex], itemIndex)
                    StepListIndex = StepListIndex + 1
                    firstCircle = 0
                    nowIndex = self.CurSelectCountPosIndex
                    Coroutine.Wait(0.5)
                else
                    if StepList[StepListIndex] + self.ShowCount * 2 - count < 5 and table.count(EndSelectCountPosIndexList) == 1 then
                        Coroutine.Wait(self.speed + (5 - (StepList[StepListIndex] + self.ShowCount * 2 - count)) * self.speed * 10)
                    else
                        Coroutine.Wait(self.speed)
                    end

                end
            end
        end
        self.CurSelectCountPosIndex = rewardList[ListLen]
        self.IsAnimation = false
        Coroutine.Wait(0.2)
        self:AnimationEnd()
        self:ShowGetItem(itemList)
    end)
end


--无抽奖动画
function this:NoAnimation(EndSelectCountPosIndexList)
    local rewardList = self:FindOrderById(EndSelectCountPosIndexList)
    local step = 0
    local ListLen = #rewardList
    local oldIndex = self.CurSelectCountPosIndex
    local StepList = {}
    local itemList = {}
    for i, newIndex in pairs(rewardList) do
        step = step + self:StepCount(oldIndex, newIndex)
        oldIndex = newIndex
        StepList[i] = step
    end
    for i, Index in pairs(EndSelectCountPosIndexList) do
        local items = SL:GetConfig("cfg_turntable_reward", tonumber(Index)).item
        for _, v in pairs(items) do
            if v[1] == self.careerId then
                local tbl = {
                    cfgId = v[2],
                    count = v[3]
                }
                table.insert(itemList, tbl)
            end
        end
    end

    self.IsAnimation = true

    GUI:SetActive(self.view.rewardShow, false)
    GUI:SetActive(self.view.getShow, true)
    local CircleCount = self.ShowCount * 2 + step
    local count = 0
    local StepListIndex = 1
    local itemIndex = 0
    while CircleCount > 0 do
        self.CurSelectCountPosIndex = (self.CurSelectCountPosIndex + 1) % self.ShowCount
        if self.CurSelectCountPosIndex == 0 then
            self.CurSelectCountPosIndex = self.ShowCount
        end
        CircleCount = CircleCount - 1
        count = count + 1
        if count == StepList[StepListIndex] + self.ShowCount * 2 then
            --展示奖品
            itemIndex = itemIndex + 1
            self:ShowGetRewardItem(EndSelectCountPosIndexList[StepListIndex], itemIndex)
            StepListIndex = StepListIndex + 1
        end
    end

    self.CurSelectCountPosIndex = rewardList[ListLen]
    self:ShowPointSelect(self.CurSelectCountPosIndex)
    self.IsAnimation = false
    self:AnimationEnd()
    self:ShowGetItem(itemList)
    SL:SendLuaNetMsg(self.REQ_TURNTABLE_REWARD_COUNT_INFO, { id = self.curTurnTbl.id })
end
---动画结束后调用
function this:AnimationEnd()
    GUI:SetActive(self.view.rewardShow, true)
    GUI:SetActive(self.view.getShow, false)
    self:HideAllGetItem()
end
--隐藏所有的获得奖励
function this:HideAllGetItem()
    for _, v in pairs(self.ShowItemList) do
        GUI:SetActive(v, false)
    end
end
--展示获得的奖励
function this:ShowGetRewardItem(index, itemIndex)
    local tblId = index
    local ShowItemTbl = SL:GetConfig("cfg_turntable_reward", tonumber(tblId))
    for _, showList in pairs(self.LuckyTurnTableItemList) do
        if showList.data.id == tonumber(tblId) then
            showList:SetReTimes()
        end
    end
    for k, v in pairs(ShowItemTbl.item) do
        if v[1] and v[1] == self.careerId then
            local data = {
                itemid = v[2],
                mfixsize = "80,80",
                tips = "1",
                width = "80",
                height = "80",
                itemcustomcount = v[3]
            }
            if not self.ShowItemList[itemIndex] then
                self.ShowItemList[itemIndex] = nil
            end
            if self.ShowItemList[itemIndex] then
                GUI:Item_UpdataData(self.ShowItemList[itemIndex], data)
            else
                self.ShowItemList[itemIndex] = GUI:Item_Create(self.view.GetShowGrid, data)
            end
            GUI:AddOnClickEvent(self.ShowItemList[itemIndex], self, function()
                SL:OpenTips(nil, data.itemid)
            end)
            GUI:SetActive(self.ShowItemList[itemIndex], true)
        end
    end
end
--选定可抽取的奖励
function this:ShowPointSelect(index)
    for i, v in pairs(self.LuckyTurnTableItemList) do
        if i == index then
            self.LuckyTurnTableItemList[i]:ShowSelect()
        else
            self.LuckyTurnTableItemList[i]:HideSelect()
        end
    end
end
function this:ShowGetItem(itemList)
    GUI:UIPanel_Open("dev/outui/OperateActivity/Panel/KLCommonGainItemShow/KLCommonGainItemShowPanel", nil, self, { reward = itemList })
end
--  根据rgb和文本返回富文本
function this:ReturnRichTextByColorAndText(color, text)
    return '<color=' .. color .. '>' .. text .. "</color>"
end

function this:Hide()
    if self.timer then
        Coroutine.Stop(self.timer)
        self.timer = nil
    end
    self.CurSelectCountPosIndex = 1--当前停留的位置

end

function this:Close()
    self:Hide()
    for _, v in pairs(self.LuckyTurnTableItemList) do
        GUI:UIPanel_Close(nil, v)
    end
    for _, v in pairs(self.bigListItemList) do
        GUI:UIPanel_Close(nil, v)
    end
    for _, v in pairs(self.CountRewardList) do
        GUI:UIPanel_Close(nil, v)
    end
    if self.FreeTimer then
        SL:UnSchedule(self.FreeTimer)
    end
    self.FreeTimer = nil
    if self.Timer then
        SL:UnSchedule(self.Timer)
    end
    self.Timer = nil
    if self.TimerPos then
        SL:UnSchedule(self.TimerPos)
    end
    self.TimerPos = nil
    self.ItemList = nil
end

return this

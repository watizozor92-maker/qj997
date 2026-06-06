---@class KLGoldChallengePanel:UIKmlLuaPanelBase
---@field view KLGoldChallengePanelView
---@field itemList KLGoldChallengeItem[]
local KLGoldChallengePanel = class(UIKmlLuaPanelBase)
local this = KLGoldChallengePanel
---创建时调用一次
function this:Init()
    self.itemList = {}
    GUI:DataListInitData(self.view.items, function()
        return self:DataListItemCountFunc()
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.isCanRefresh = false
    SL:HideMainPanel()
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_GOLD_TASK_INFO)
end

function this:RefreshUI()
    GUI:DataListUpdateData(self.view.items)
    local challengeCountCfg = SL:GetConfig("cfg_global", 2001)
    if challengeCountCfg then
        local challengeCount = tonumber(challengeCountCfg.value)
        local colorStr = ""

        if table.count(InfoManager.goldChallengeTaskInfo.taskInfo.dailyrecord) >= challengeCount then
            colorStr = EColor[EGradColor.red]
        else
            colorStr = EColor[EGradColor.green]
        end
        local str = string.format("<color=%s>%s/%s</color>", colorStr, table.count(InfoManager.goldChallengeTaskInfo.taskInfo.dailyrecord), challengeCount)
        GUI:Text_setString(self.view.FinishCountText, str)
    else
        local str = string.format("<color=%s>%s/%s</color>", EColor[EGradColor.green], 0, 4)
        GUI:Text_setString(self.view.FinishCountText, str)
    end
    local costCfg = SL:GetConfig("cfg_global", 2004)
    if costCfg then
        costCfg = string.split(costCfg.value, "#")
        local costStr = "%s/%s"
        local costItemId = tonumber(costCfg[1])
        local costItemCount = tonumber(costCfg[2])
        costStr = string.format(costStr, tostring(SL:GetBagItemCount(costItemId)), costItemCount)
        GUI:Text_setString(self.view.costText, costStr)
        local item = GUI:Item_Create(self.view.costModel, {
            width = "30",
            height = "30",
            itemid = costItemId,
            mfixsize = "80,80",
            tips = "1",
            bgtype = "0",
        })
        GUI:AddOnClickEvent(item, self, function()
            SL:OpenTips(nil, costItemId)
        end)
    end
    self:LUA_EVENT_MONEYCHANGE()
    GUI:Button_setGrey(self.view.RefreshBtn, not self:GetIsCanRefresh())
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseBtn, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.RefreshBtn, self, self.BtnRefreshOnClick)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GOLD_TASK_INFO, self.ResGoldTaskInfo, self)

    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.LUA_EVENT_MONEYCHANGE, self)
end

function this:LUA_EVENT_MONEYCHANGE()
    local costCfg = SL:GetConfig("cfg_global", 2004)
    if costCfg then
        costCfg = string.split(costCfg.value, "#")
        local costStr = "<color=%s>%s</color>/%s"
        local costItemId = tonumber(costCfg[1])
        local costItemCount = tonumber(costCfg[2])
        local haveItemCount = SL:GetBagItemCount(costItemId)
        local colorStr = ""
        if haveItemCount >= costItemCount then
            colorStr = EColor[EGradColor.green]
        else
            colorStr = EColor[EGradColor.red]
        end
        costStr = string.format(costStr, colorStr,SL:GetSimpleNumber(haveItemCount,1),SL:GetSimpleNumber(costItemCount,1))
        GUI:Text_setString(self.view.costText, costStr)
    end
    GUI:Button_setGrey(self.view.RefreshBtn, not self:GetIsCanRefresh())
end

---@param message {nowtaskpool:table,flushcount:number,nowtask:GoldChallengeTask,firstopen:boolean,dailyrecord:GoldChallengeTask,lastresettime:number}
function this:ResGoldTaskInfo(_, message)
    InfoManager.goldChallengeTaskInfo.taskInfo = message
    if InfoManager.goldChallengeTaskInfo.taskInfo then
        InfoManager.goldChallengeTaskInfo.taskInfo.taskPool = {}
        for k, v in pairs(InfoManager.goldChallengeTaskInfo.taskInfo.nowtaskpool) do
            table.insert(InfoManager.goldChallengeTaskInfo.taskInfo.taskPool, { k = tonumber(k), v = v })
        end
    end
    self:RefreshUI()

end

----刷新当前任务
function this:BtnRefreshOnClick()
    if self:GetIsCanRefresh(true) then
        SL:SendLuaNetMsg(LuaMessageIdToSever.FLUSH_GOLD_TASK_POOL)
    end
end

----@param isShowTips boolean 是否提示
---@return boolean
function this:GetIsCanRefresh(isShowTips)
    if InfoManager.goldChallengeTaskInfo.taskInfo.nowtas then
        if isShowTips then
            SL:TipMessage(SL:GetConfig('cfg_string',245).text, 1, NoticeType.NoticeMid )--"任务已在进行中！", 
        end
        return false
    end
    local costCfg = SL:GetConfig("cfg_global", 2004)
    if costCfg then
        costCfg = string.split(costCfg.value, "#")
        local costItemId = tonumber(costCfg[1])
        local costItemCount = tonumber(costCfg[2])
        local haveItemCount = SL:GetBagItemCount(costItemId)
        if haveItemCount < costItemCount then
            if isShowTips then
                SL:TipMessage( SL:GetConfig('cfg_string',246).text, 1, NoticeType.NoticeMid )--"道具不足，请补充道具！",
            end
            return false
        end
    else
        SL:TipMessage( SL:GetConfig('cfg_string',246).text,1, NoticeType.NoticeMid )--"道具不足，请补充道具！",
        return false
    end
    local challengeCountCfg = SL:GetConfig("cfg_global", 2001)
    if challengeCountCfg then
        local challengeCount = tonumber(challengeCountCfg.value)
        if #InfoManager.goldChallengeTaskInfo.taskInfo.dailyrecord >= challengeCount then
            if isShowTips then
                SL:TipMessage(SL:GetConfig('cfg_string',247).text, 1, NoticeType.NoticeMid )--"任务已完成！",
            end
            return false
        end
    else
        if isShowTips then
            SL:TipMessage( SL:GetConfig('cfg_string',247).text,1, NoticeType.NoticeMid )--"任务已完成！", 
        end
        return false
    end
    return true
end

----关闭界面
function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLGoldChallenge/KLGoldChallengePanel")
end

function this:DataListItemCountFunc()
    return table.count(InfoManager.goldChallengeTaskInfo.taskInfo.nowtaskpool)
end

function this:DataListItemGetFunc(realIndex)
    ---@type KLGoldChallengeItem
    local tempItem = GUI:UIPanel_Open("dev/outui/Activity/Item/KLGoldChallenge/KLGoldChallengeItem", self.view.items, self, nil, true,
            function(_item)
                self.itemList[_item.view.root] = _item
                self:DataListItemUpdateFunc(realIndex,_item.view.root)
            end)
    return tempItem.view.root
end

---@param kmlcontrol UIKmlLuaControl
function this:DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:DataListItemUpdateFunc(realIndex, kmlcontrol)
    if self.itemList[kmlcontrol] then
        self.itemList[kmlcontrol]:InitData(realIndex + 1, InfoManager.goldChallengeTaskInfo.taskInfo.taskPool[realIndex + 1])
        self.itemList[kmlcontrol]:RefreshUI()
    end
end

function this:Close()
    SL:ShowMainPanel()
end

return this

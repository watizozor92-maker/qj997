---@class KLMainOperateAddRechargePanel:UIKmlLuaPanelBase
---@field view KLMainOperateAddRechargePanelView
local KLMainOperateAddRechargePanel = class(UIKmlLuaPanelBase)
local this = KLMainOperateAddRechargePanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.showList = {}
    GUI:DataListInitData(self.view.showItemInfoList, function()
        return self:GetAllShowItems()
    end, function()
    end, function()
    end, function(realIndex)
        self:ItemUpdateFun(realIndex)
    end)
end
function this:GetAllShowItems()
    return table.count(self.showList)
end
function this:ItemUpdateFun(realIndex)
    local data = self.showList[realIndex + 1]
    local txt_taskDes = GUI:GetChildControl(self.view.showItemInfoList, realIndex, 'txt_taskDes')
    local txt_process = GUI:GetChildControl(self.view.showItemInfoList, realIndex, 'txt_process')
    local showItems = GUI:GetChildControl(self.view.showItemInfoList, realIndex, 'showItems')
    local btn_get = GUI:GetChildControl(self.view.showItemInfoList, realIndex, 'btn_get')
    local btn_nav = GUI:GetChildControl(self.view.showItemInfoList, realIndex, 'btn_nav')
    local txt_get = GUI:GetChildControl(self.view.showItemInfoList, realIndex, 'txt_get')

    --任务描述
    GUI:Text_setString(txt_taskDes, data.taskDes)
    --任务进度
    local todayMoney = data.money
    local color = todayMoney >= data.goal and EColor[EGradColor.green] or EColor[EGradColor.red]
    local str = string.format("<color=%s>%s/%s</color>", color, todayMoney, data.goal)
    GUI:Text_setString(txt_process, str)
    --展示奖励
    local showRewards = data.reward
    GUI:HideAllChilds(showItems)
    for i = 1, table.count(showRewards) do
        local itemId = showRewards[i][1]
        local item = GUI:Item_Create(showItems, {
            width = "70",
            height = "70",
            itemid = itemId,
            mfixsize = "80,80",
            tips = "1",
            itemcustomcount = showRewards[i][2]
        })
        GUI:AddOnClickEvent(item, self, function()
            SL:OpenTips(nil, itemId)
        end)
    end
    --任务状态
    GUI:SetActive(btn_get, false)
    GUI:SetActive(btn_nav, false)
    GUI:SetActive(txt_get, false)
    if data.giftState == E_RechargeState.CanGet then
        GUI:SetActive(btn_get, true)
        GUI:AddOnClickEvent(btn_get, self, self.GetOnClick, { cfgId = data.id })
    elseif data.giftState == E_RechargeState.NotComplete then
        GUI:SetActive(btn_nav, true)
        GUI:AddOnClickEvent(btn_nav, self, self.GoOnClick)
    elseif data.giftState == E_RechargeState.AlreadyGet then
        GUI:SetActive(txt_get, true)
    end
end
function this:GetOnClick(_, data)
    if data.cfgId then
        if self.args and self.args.showType == EOperateActivityType.Week then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.AddRechargeWeek, action = "reward", id = data.cfgId })
        else
            --请求领奖
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.AddRecharge, action = "reward", id = data.cfgId })
        end
 
    end
end
function this:GoOnClick()
    if self.args and self.args.showType == EOperateActivityType.Week then
        GUI:UIPanel_Close("dev/outui/MainOperateActivity/Panel/KLMainOperateActivitySecond/KLMainOperateActivitySecondPanel")
    else
        GUI:UIPanel_Close("dev/outui/MainOperateActivity/Panel/KLMainOperateActivity/KLMainOperateActivityPanel")
    end
   
    --跳转到充值界面
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", nil, nil, { 2 })
end
---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self.RefreshPanelData, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_SECOND_CHANGE, self.RefreshPanelData, self)
end
---界面显示时调用一次
function this:Show()
    if self.args and self.args.showType then
        if self.args.showType == 1 then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WEEKEN_ACTIVE_INFO, { subType = EOperateActivityActivityType.OperateAddRecharge })
        else
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAIN_ACTIVE_INFO, { subType = EOperateActivityActivityType.OperateAddRecharge })
        end
    end

end
---创建或者刷新界面数据时调用
function this:Refresh()
    --self:RefreshPanelData()
end
function this:ShowDJHFunc(time)
    self:ClearDJHFunc()
    local countdown = 1
    if time and time > 0 then
        countdown = time
    end
    self.sectimer = SL:Schedule(self.sectimer, 0, 1, countdown, function()
        countdown = countdown - 1
        if countdown > 0 then
            GUI:SetActive(self.view.txt_showTime, true)
            GUI:Text_setString(self.view.txt_showTime, GUIUtil.FormatTimeDHM(countdown))
        else
            GUI:SetActive(self.view.txt_showTime, false)
            self:ClearDJHFunc()
        end
    end)
end

function this:ClearDJHFunc()
    if self.sectimer then
        SL:UnSchedule(self.sectimer)
        self.sectimer = nil
    end
end

function this:RefreshPanelData()
    --倒计时
    self.showList = {}
    if self.args then
        self.mainOperateActivityInfo = self.args.OperateActivityInfo
    end
    if not self.mainOperateActivityInfo then
        return
    end
    local data = self.mainOperateActivityInfo--InfoManager.mainOperateActivityInfo
    self:ShowDJHFunc(data:GetOADJSTimeBySubType(EOperateActivityActivityType.OperateAddRecharge))
    for k, v in ipairs(data.addRechargeInfo) do
        if v.showCount > 0 and v.money < v.showCount then
            -----策划需求，达到一定充值金额才显示部分礼包
        else
            table.insert(self.showList, v)
        end
    end
    table.sort(self.showList, function(a, b)
        if a.giftState == b.giftState then
            return a.id < b.id
        else
            return a.giftState < b.giftState
        end
    end)
    GUI:DataListUpdateData(self.view.showItemInfoList)
end

function this:Close()
    self:ClearDJHFunc()
end

return this

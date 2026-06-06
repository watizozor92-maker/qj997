---@class KLUIMonthCardPanel:UIKmlLuaPanelBase
---@field view KLUIMonthCardPanelView
local KLUIMonthCardPanel = class(UIKmlLuaPanelBase)
local this = KLUIMonthCardPanel
---创建时调用一次
function this:Init()
    local data = {
        width = "500",
        height = "500",
        itemid = 30030306,
        noclip = "1",
        z = -500,
        y = 50,
        mscale = "160,160,160",
        bgtype = "0",
        mfixsize = "500,500",
        itemcount = nil,
        selfrotation = "4,50,1",
    }
    self.item = GUI:Item_Create(self.view.item_model, data)
    self.reTime = 0
end

---创建或者刷新界面数据时调用
function this:Refresh()

    self.BuyCount = 1
    self.MonthCardTbl = InfoManager.monthCardInfo:GetMonthCardTblData()
    self.DailyCardTbl = InfoManager.monthCardInfo:GetDailyCardTblData()
    if InfoManager.monthCardInfo.DailyCardBuyCount < self.DailyCardTbl.limitCount then
        GUI:Text_setString(self.view.daliyCardBuy_btn, self.DailyCardTbl.price .. "元日卡")
        GUI:SetActive(self.view.text2, true)
        local text2 = ""
        if self.DailyCardTbl.limitType == 1 then
            text2 = "永久限购："
        end
        if self.DailyCardTbl.limitType == 2 then
            text2 = "每月限购："
        end
        if self.DailyCardTbl.limitType == 3 then
            text2 = "每周限购："
        end
        if self.DailyCardTbl.limitType == 4 then
            text2 = "每日限购："
        end
        GUI:Text_setString(self.view.text2, text2)
        GUI:Text_setString(self.view.LimitCount, tostring(InfoManager.monthCardInfo.DailyCardBuyCount .. "/" .. self.DailyCardTbl.limitCount))
    else
        GUI:Text_setString(self.view.daliyCardBuy_btn, "兑换特权")
        GUI:Text_setString(self.view.LimitCount, "")
        GUI:SetActive(self.view.text2, false)
    end

    GUI:Text_setString(self.view.inputText, tostring(self.BuyCount))
    GUI:Text_setString(self.view.monthCardBuy_Btn, "￥" .. self.BuyCount * self.MonthCardTbl.price)

    GUI:SetActive(self.view.chat_Btn, InfoManager.monthCardInfo:IsNeedShowPanel("chat"))
    GUI:SetActive(self.view.tradeLine_Btn, InfoManager.monthCardInfo:IsNeedShowPanel("stall"))
    GUI:SetActive(self.view.TripleEarningsBtn, InfoManager.monthCardInfo:IsNeedShowPanel("inCome"))
    GUI:SetActive(self.view.auto_pickUpBtn, InfoManager.monthCardInfo:IsNeedShowPanel("pickUp"))
    GUI:SetActive(self.view.auto_recyBtn, InfoManager.monthCardInfo:IsNeedShowPanel("recovery"))
    GUI:SetActive(self.view.ex_privilegeBtn, InfoManager.monthCardInfo:IsNeedShowPanel("privilege"))

    self.reTime = InfoManager.monthCardInfo.MonthCardTimeTotal - SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    if self.reTime > 0 then
        GUI:Text_setString(self.view.TimeText, "剩余时间：" .. GUIUtil.FormatTimeDHM(self.reTime // 1000))
        GUI:Button_setGrey(self.view.GoTripleEarningBtn, false)
    else
        self.reTime = 0
        GUI:Text_setString(self.view.TimeText, "")
        GUI:Button_setGrey(self.view.GoTripleEarningBtn, true)
    end
    GUI:SetInputEnable(self.view.inputText, false)

    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_TRADE_INFO)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Help_Btn, self, self.Help_BtnOnClick)
    GUI:AddOnClickEvent(self.view.chat_Btn, self, self.chat_BtnOnClick)
    GUI:AddOnClickEvent(self.view.tradeLine_Btn, self, self.tradeLine_BtnOnClick)
    GUI:AddOnClickEvent(self.view.TripleEarningsBtn, self, self.TripleEarningsBtnOnClick)
    GUI:AddOnClickEvent(self.view.auto_pickUpBtn, self, self.auto_pickUpBtnOnClick)
    GUI:AddOnClickEvent(self.view.auto_recyBtn, self, self.auto_recyBtnOnClick)
    GUI:AddOnClickEvent(self.view.ex_privilegeBtn, self, self.ex_privilegeBtnOnClick)
    GUI:Input_SetOnEndEdit(self.view.inputText, self, self.InputFieldLevelOnEndEdit)
    GUI:AddOnClickEvent(self.view.Reduce_btn, self, self.Reduce_btnOnClick)
    GUI:AddOnClickEvent(self.view.Add_Btn, self, self.Add_BtnOnClick)
    GUI:AddOnClickEvent(self.view.monthCardBuy_Btn, self, self.monthCardBuy_BtnOnClick)
    GUI:AddOnClickEvent(self.view.daliyCardBuy_btn, self, self.daliyCardBuy_btnOnClick)
    GUI:AddOnClickEvent(self.view.CloseBtn, self, self.CloseBtn)
    GUI:AddOnClickEvent(self.view.GoTripleEarningBtn, self, self.GoTripleEarningBtn)
    --SL:RegisterLUAEvent(LUA_EVENT_GET_MONTH_CARD_INFO, self.LUA_EVENT_GET_MONTH_CARD_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_GET_MONTH_CARD_CHANGE, self.LUA_EVENT_GET_MONTH_CARD_CHANGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_TRADE_INFO,self.OnGetRechargeTradeInfo,self)
end
--[[function this:LUA_EVENT_GET_MONTH_CARD_INFO(_, message)
    if message then

    end
end]]

---@param message recharge
function this:OnGetRechargeTradeInfo(_,message)
    if not message then
        return
    end
    --GUI:SetActive(self.view.img_cost_tips,true)
    if message.quit then
        local text = "当前额度：<color=#ff2323>%d</color>\n再充值<color=#00ff00>%d</color>元，即可恢复到<color=#00ff00>%d</color>额度上限！"
        ---@type cfg_lines_column
        local curLines = SL:GetConfig("cfg_lines",message.gearPosition)
        local recoveredCount = message.totalRecharge + curLines.activationRecharge
        local curLimit = self:GetQuotaLimit(recoveredCount)
        GUI:Text_setString(self.view.text_cost_tips, string.format(text, message.upperLimit,curLines.activationRecharge,curLimit))
    else
        local text = "当前额度：<color=#00ff00>%d</color>\n再充值<color=#00ff00>%d</color>元，即可提高<color=#00ff00>%d</color>奇迹币额度上限！"
        ---@type cfg_lines_column
        local curLines = SL:GetConfig("cfg_lines",message.gearPosition)
        GUI:Text_setString(self.view.text_cost_tips, string.format(text, message.upperLimit,curLines.each,curLines.quotaLimit))
    end
end

function this:GetQuotaLimit(count)
    ---@type cfg_lines_column[]
    local tbls = SL:GetConfigTable("cfg_lines")
    local result = 0
    for _, v in pairs(tbls) do
        local min = v.interval[1]
        local max = v.interval[2]
        if count < min then
            break
        end
        local curCount
        if count >= max then
            curCount = max - min + 1
        else
            curCount = count - min + 1
        end
        result = result + curCount // v.each * v.quotaLimit
    end
    
    return result
end

function this:LUA_EVENT_GET_MONTH_CARD_CHANGE(_, message)
    if message then
        self:Refresh()
    end
end
function this:GoTripleEarningBtn()
    if not InfoManager.monthCardInfo:IsHaveMonthCardRights("inCome") then
        return
    end
    GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
    GUI:UIPanel_Open("dev/outui/ThreeEarnings/Panel/KLEarnings/KLEarningsPanel")
end
function this:CloseBtn()
    GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
end
function this:daliyCardBuy_btnOnClick()
    --local emptyGrid = RoleManager.meData.bagInfo:GetRemainTileCount()

    if InfoManager.monthCardInfo.DailyCardBuyCount < self.DailyCardTbl.limitCount then
        local DailyCardTbl = InfoManager.monthCardInfo:GetMonthCardTblData()
        if not SL:CanPutToBag(DailyCardTbl.id, 1) then
            ---背包满
            --local desc = "您的背包已满,月卡购买后将直接使用为月卡点数,是否继续购买?"
            SL:CommonTipsMessage({ stringTblID = 202, ui = self,
                                   callback = self.BuyDailyCard, callbackData = nil })
            return
        end
        --local desc = "日卡无法上架宝石、翅膀材料、时装材料等道具是否花费<color=#5CE366FF>"..self.DailyCardTbl.price.."元</color>购买日卡?\n\n当前月卡剩余时间:".. GUIUtil.FormatTimeDHM(self.reTime // 1000)
        SL:CommonTipsMessage({ stringTblID = 203, stringTblFormat = { tostring(self.DailyCardTbl.price), tostring(GUIUtil.FormatTimeDHM(self.reTime // 1000)) }, ui = self,
                               callback = self.BuyDailyCard, callbackData = nil })
    else
        if self.reTime <= 0 then
            SL:TipMessage( SL:GetConfig('cfg_string', 442).text, 1, NoticeType.NoticeMid )
            return
        end
        GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel", _, _, { type = "privilege" })
    end
end
function this:monthCardBuy_BtnOnClick()
    --local emptyGrid = RoleManager.meData.bagInfo:GetRemainTileCount()
    local MonthCardTbl = InfoManager.monthCardInfo:GetMonthCardTblData()
    if not SL:CanPutToBag(MonthCardTbl.id, 1) then
        ---背包满
        SL:CommonTipsMessage({ stringTblID = 202,
                               callback = self.BuyMonthCard, callbackData = { count = self.BuyCount }, ui = self })
        return
    end
    if InfoManager.monthCardInfo.IsFirstBuyMonthCard then
        SL:CommonTipsMessage({ stringTblID = 204, stringTblFormat = { tostring(self.MonthCardTbl.price * self.BuyCount), tostring(GUIUtil.FormatTimeDHM(self.reTime // 1000)) },
                               callback = self.BuyMonthCard, callbackData = { count = self.BuyCount }, ui = self })
    else
        SL:CommonTipsMessage({ stringTblID = 205, stringTblFormat = { tostring(self.MonthCardTbl.price * self.BuyCount), tostring(GUIUtil.FormatTimeDHM(self.reTime // 1000)) },
                               callback = self.BuyMonthCard, callbackData = { count = self.BuyCount }, ui = self })
    end

end
function this:BuyMonthCard()
    ---@type cfg_recharge_column
    local rechargeTbl = InfoManager.monthCardInfo:GetRechargeMonthCard(EMonthType.MonthCard)
    GUIUtil.SDKPay(rechargeTbl,self.callbackData.count)
end
function this:BuyDailyCard()
    local rechargeTbl = InfoManager.monthCardInfo:GetRechargeMonthCard(EMonthType.DailyCard)
    GUIUtil.SDKPay(rechargeTbl,1)
end
function this:Add_BtnOnClick()
    if self.BuyCount + 1 < self.MonthCardTbl.maxCount + 1 then
        self.BuyCount = self.BuyCount + 1
        GUI:Text_setString(self.view.inputText, tostring(self.BuyCount))
        GUI:Text_setString(self.view.monthCardBuy_Btn, "￥" .. self.BuyCount * self.MonthCardTbl.price)
    end
end
function this:Reduce_btnOnClick()
    if self.BuyCount - 1 > 0 then
        self.BuyCount = self.BuyCount - 1
        GUI:Text_setString(self.view.inputText, tostring(self.BuyCount))
        GUI:Text_setString(self.view.monthCardBuy_Btn, "￥" .. self.BuyCount * self.MonthCardTbl.price)
    end
end
function this:InputFieldLevelOnEndEdit(_, _, eventData)
    self.BuyCount = tonumber(eventData[1])
    if self.BuyCount < 1 then
        self.BuyCount = 1
    end
    if self.BuyCount > self.MonthCardTbl.maxCount then
        self.BuyCount = self.MonthCardTbl.maxCount
    end
    GUI:Text_setString(self.view.inputText, tostring(self.BuyCount))
    GUI:Text_setString(self.view.monthCardBuy_Btn, "￥" .. self.BuyCount * self.MonthCardTbl.price)
end
function this:ex_privilegeBtnOnClick()
    if not InfoManager.monthCardInfo:IsHaveMonthCardRights("privilege") then
        SL:TipMessage( SL:GetConfig('cfg_string', 274).text, 1, NoticeType.NoticeMid )--"开通月卡后显示", 
        return
    end
    local TitleText = "兑换特权"
    local Content = "1.可以消耗月卡时间兑换<color=#5CE366FF>黄金特权</color>或<color=#5CE366FF>钻石特权</color>获取超额收益。\n2.黄金特权激活后可以开启<color=#5CE366FF>黄金分线、开启自动回收、开启自动买药、开启随身商店功能</color>。\n3.钻石特权激活后<color=#5CE366FF>装备掉率增加100%、怪物经验增加100%、奇迹币回收价增加30%、开启自动拾取、开启远程仓库、增加交易行寄售格子5格</color>。"
    local GoBtnBack = function()
        --logError("打开" .. TitleText .. "界面")
        --GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanel")
        GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel", _, _, { type = "privilege" })
    end
    self:OpenMonthCardCommonPanel(TitleText, Content, GoBtnBack)
end
function this:auto_recyBtnOnClick()
    local TitleText = "自动回收"
    local Content = "1.购买并使用<color=#5CE366FF>月卡</color>,解锁<color=#5CE366FF>自动回收功能</color>。\n2.解锁<color=#5CE366FF>自动回收功能</color>后,可以在背包数量不足时自动回收背包中的普通装备和卓越装备。"
    local GoBtnBack = function()
        --logError("打开" .. TitleText .. "界面")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanel")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
        GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", _, _, { JumpType = 1 })
    end
    self:OpenMonthCardCommonPanel(TitleText, Content, GoBtnBack)
end
function this:auto_pickUpBtnOnClick()
    local TitleText = "自动拾取"
    local Content = "1.购买并使用<color=#5CE366FF>月卡</color>,解锁<color=#5CE366FF>自动拾取功能</color>。\n2.解锁<color=#5CE366FF>自动拾取功能</color>后,可以让您快速拾取掉落道具。"
    local GoBtnBack = function()
        --logError("打开" .. TitleText .. "界面")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanel")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
        GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel")
    end
    self:OpenMonthCardCommonPanel(TitleText, Content, GoBtnBack)
end
function this:TripleEarningsBtnOnClick()

    local TitleText = "三倍收益"
    local Content = "1.购买并使用<color=#5CE366FF>月卡</color>,解锁<color=#5CE366FF>三倍收益功能</color>,您可在<color=#5CE366FF>三倍收益界面</color>开启三倍收益时间,获得<color=#5CE366FF>经验、掉落加成</color>。\n2.在三倍收益界面<color=#5CE366FF>点击领取</color>即可领取三倍收益时间。\n3.首次拥有日卡后,立即获得<color=#5CE366FF>4小时</color>三倍收益时间,之后每天可以获得<color=#5CE366FF>8小时</color>的三倍收益时间,可以自由控制三倍收益时间开启的时间。\n4.第一次购买月卡时将会立即增加<color=#5CE366FF>20小时</color>三倍收益时间。\n5.每天剩余的三倍收益时间能够<color=#5CE366FF>继承</color>到下一天继续使用,<color=#5CE366FF>最多可以继承56小时</color>三倍收益时间。\n6.月卡剩余时间大于等于<color=#5CE366FF>24小时</color>时三倍收益时间将在<color=#5CE366FF>每天24:00</color>更新。如果今日没有更新三倍收益时间那么三倍收益时间将在您的月卡剩余时间大于等于<color=#5CE366FF>24小时</color>后发放。"
    local GoBtnBack = function()
        --logError("打开" .. TitleText .. "界面")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanel")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
        GUI:UIPanel_Open("dev/outui/ThreeEarnings/Panel/KLEarnings/KLEarningsPanel")
    end
    self:OpenMonthCardCommonPanel(TitleText, Content, GoBtnBack)
end
function this:tradeLine_BtnOnClick()
    local TitleText = "交易行"
    local Content = "1.购买并使用<color=#5CE366FF>月卡</color>,解锁<color=#5CE366FF>交易行功能</color>,可以在交易行界面进行<color=#5CE366FF>装备、道具、材料</color>之间的交易,是快速获取<color=#5CE366FF>装备、货币</color>的渠道。\n2.没有月卡时间后,可以在交易行使用<color=#5CE366FF>奇迹币</color>购买其他玩家上架的<color=#5CE366FF>月卡道具</color>。\n3.有<color=#5CE366FF>公示期</color>限制的道具上架后,公示期期间内玩家可以对物品进行预约购买,公示期结束后将从所有预约该物品的玩家中<color=#5CE366FF>随机抽选</color>一人出售该道具\n4.公示期结束后玩家可对物品进行直接购买操作。\n5.您可以自行对物品进行上架、下架、定价操作。"
    local GoBtnBack = function()
        --logError("打开" .. TitleText .. "界面")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanel")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
        GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel")
    end
    self:OpenMonthCardCommonPanel(TitleText, Content, GoBtnBack)
end
function this:chat_BtnOnClick()
    local TitleText = "聊天功能"
    local Content = "1.购买并使用<color=#5CE366FF>月卡</color>,解锁<color=#5CE366FF>聊天功能</color>,您可以在聊天界面与其他玩家交流游戏心得,沟通任务进度。\n2.解锁<color=#5CE366FF>聊天功能</color>后,您可以<color=#5CE366FF>快速发送位置信息</color>,也可以点击聊天框中的位置信息前往标记的位置。\n3.解锁<color=#5CE366FF>聊天功能</color>后,您可以<color=#5CE366FF>发送</color>背包中的<color=#5CE366FF>道具或已穿戴的装备信息</color>到聊天框中。"
    local GoBtnBack = function()
        --logError("打开"..TitleText.."界面")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanel")
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
        SL:OpenChatUI()
    end
    self:OpenMonthCardCommonPanel(TitleText, Content, GoBtnBack)
end
function this:Help_BtnOnClick()
    SL:CommonStrTipsMessage({ title = "提示", str = SL:GetConfig("cfg_rule_text", 12).location, ui = self })

    --[[    local content = "1.购买使用月卡后激活<color=#5CE366FF>30天</color>的月卡特权（掉落<color=#5CE366FF>非绑定道具</color>，正常获取回收收益，激活<color=#5CE366FF>交易行上架</color>功能，解锁<color=#5CE366FF>聊天</color>功能，可选择激活<color=#5CE366FF>黄金特权</color>或<color=#5CE366FF>钻石特权</color>获取超额收益)\n2.月卡到期后可以在<color=#5CE366FF>交易行</color>或<color=#5CE366FF>月卡活动</color>界面购买月卡。"
        GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardDescTips/KLUIMonthCardDescTipsPanel", nil, nil, { Content = content })]]
end
function this:OpenMonthCardCommonPanel(TitleText, Content, GoBtnBack)
    GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanel", nil, nil, { TitleText = TitleText, Content = Content, GoBtnBack = GoBtnBack })
end
function this:Close()
    GUI:SetInputEnable(self.view.inputText, true)
    GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardDescTips/KLUIMonthCardDescTipsPanel")

end

return this

---@class KLUIRechargeMonthlycardPanel:UIKmlLuaPanelBase
---@field view KLUIRechargeMonthlycardPanelView
---@field cfgListAll cfg_MonthlyPack_column[]
---@field normalCfg cfg_MonthlyPack_column
---@field goldCfg cfg_MonthlyPack_column
local KLUIRechargeMonthlycardPanel = class(UIKmlLuaPanelBase)
local this = KLUIRechargeMonthlycardPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
	self.cfgListAll = SL:GetConfigTable("cfg_MonthlyPack")
	self:InitNormalRewardList()
	self:InitGoldRewardList()
	self.info = InfoManager.rechargeMonthlycardInfo
	self.normalCfg = self.info:FindCfgInfo(self.cfgListAll, UIMonthCard.WhiteCardID)
	self.goldCfg = self.info:FindCfgInfo(self.cfgListAll, UIMonthCard.GoldCardID)
	self.twoCfg = self.info:FindCfgInfo(self.cfgListAll, UIMonthCard.WhiteAndGoldCardID)
	local allPrice = SL:GetConfigMultiKeys("cfg_recharge", self.twoCfg.id, ERechargeType.MonthCardGift, "parameter", "type").amount
	self.TipStr = "原价" .. self.normalCfg.Price[2] .. "元"
	self.GoldTipStr = "原价" .. self.goldCfg.Price[2] .. "元"
	self.AllCardStr = allPrice .. "元"
end

--region 尊享特权月卡
function this:InitNormalRewardList()
	self.NormalRewardListData = {}
	GUI:DataListInitData(self.view.DataNormalRewardList, function()
		return self:NormalRewardCountFunc()
	end, function(realIndex)
		return self:NormalRewardGetFunc(realIndex)
	end, function(realIndex, kmlcontrol)
		return self:NormalRewardInitFunc(realIndex, kmlcontrol)
	end, function(realIndex, kmlcontrol)
		return self:NormalRewardUpdateFunc(realIndex, kmlcontrol)
	end)
end

function this:NormalRewardCountFunc()
	return table.count(self.NormalRewardListData)
end
function this:NormalRewardGetFunc(realIndex)
end

function this:NormalRewardInitFunc(realIndex, kmlcontrol)
end

function this:NormalRewardUpdateFunc(realIndex, kmlcontrol)
	local data = self.NormalRewardListData[realIndex + 1]
	local ctrlItem = GUI:GetChildControl(self.view.DataNormalRewardList, realIndex, 'ItemNormal')
	GUI:Item_UpdataData(ctrlItem, {
		itemid = data[1],
		itemcustomcount = SL:GetSimpleNumber(data[2], 0),
		textcolor = "#FBD994"
	})
	GUI:AddOnClickEvent(ctrlItem, self, function()
		SL:OpenTips(nil, data[1])
	end)
end
--endregion
--region 黄金特权月卡
function this:InitGoldRewardList()
	self.GoldRewardListData = {}
	GUI:DataListInitData(self.view.DataGoldRewardList, function()
		return self:GoldRewardCountFunc()
	end, function(realIndex)
		return self:GoldRewardGetFunc(realIndex)
	end, function(realIndex, kmlcontrol)
		return self:GoldRewardInitFunc(realIndex, kmlcontrol)
	end, function(realIndex, kmlcontrol)
		return self:GoldRewardUpdateFunc(realIndex, kmlcontrol)
	end)
end

function this:GoldRewardCountFunc()
	return table.count(self.GoldRewardListData)
end
function this:GoldRewardGetFunc(realIndex)
end

function this:GoldRewardInitFunc(realIndex, kmlcontrol)
end

function this:GoldRewardUpdateFunc(realIndex, kmlcontrol)
	local data = self.GoldRewardListData[realIndex + 1]
	local ctrlItem = GUI:GetChildControl(self.view.DataGoldRewardList, realIndex, 'ItemGold')
	GUI:Item_UpdataData(ctrlItem, {
		itemid = data[1],
		itemcustomcount = SL:GetSimpleNumber(data[2], 0),
		textcolor = "#FBD994"
	})
	GUI:AddOnClickEvent(ctrlItem, self, function()
		SL:OpenTips(nil, data[1])
	end)
end
--endregion

---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.MonthCardBtn, self, self.MonthCardBtnOnClick)
	GUI:AddOnClickEvent(self.view.GoldMonthCardBtn, self, self.GoldMonthCardBtnOnClick)
	GUI:AddOnClickEvent(self.view.AllCardBtn, self, self.AllCardBtnOnClick)
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_ACTION, self.ResRecharge, self)
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_COMMON_REWARD_PANEL_WITH_PARAM, self.ResTipMessage, self)

end

function this:MonthCardBtnOnClick(control)
	local tab = SL:GetConfigMultiKeys("cfg_recharge", self.normalCfg.id, ERechargeType.MonthCardGift, "parameter", "type")
	if self:CheckMonthIsEndTime() == true then
		-- 过期或者未充值月卡
		GUIUtil.SDKPay(tab, 1)
	else
		if self.messageTab[UIMonthCard.GoldCardID] and self.messageTab[UIMonthCard.WhiteCardID].receive == false then
			return
		end
		SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.MonthCardGift, action = "reward", id = tab.id })
	end

end

function this:GoldMonthCardBtnOnClick(control)
	local tab = SL:GetConfigMultiKeys("cfg_recharge", self.goldCfg.id, ERechargeType.MonthCardGift, "parameter", "type")
	if self:CheckGoldMonthIsEndTime() == true then
		-- 过期或者未充值月卡
		GUIUtil.SDKPay(tab, 1)
	else
		if self.messageTab[UIMonthCard.GoldCardID] and self.messageTab[UIMonthCard.GoldCardID].receive == false then
			return
		end
		SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.MonthCardGift, action = "reward", id = tab.id })
	end
end

function this:AllCardBtnOnClick()
	if self:CheckGoldMonthIsEndTime() == true and self:CheckMonthIsEndTime() == true then
		local tab = SL:GetConfigMultiKeys("cfg_recharge", self.twoCfg.id, ERechargeType.MonthCardGift, "parameter", "type")
		GUIUtil.SDKPay(tab, 1)
	end
end

function this:ResRecharge(_, message)
	if message.type ~= tostring(ERechargeType.MonthCardGift) then
		return
	end
	local normalKey = tostring(self.normalCfg.id)
	local goldKey = tostring(self.goldCfg.id)
	local data = {}
	local whihtEndTime = 0
	local goldEndTime = 0
	local month_data = message.data.month_data
	local daily_data = message.data.daily_data
	local whiteReceive, goldReceive = true
	if month_data and month_data[normalKey] then
		whihtEndTime = month_data[normalKey] + 86400000 * 30
	end
	if month_data and month_data[goldKey] then
		goldEndTime = month_data[goldKey] + 86400000 * 30
	end
	--- receive 为true可领取
	if daily_data then
		whiteReceive = not table.contains(daily_data, normalKey)
	else
		whiteReceive = true
	end
	
	if daily_data then
		goldReceive = not table.contains(daily_data, goldKey)
	else
		goldReceive = true
	end
	data[UIMonthCard.WhiteCardID] = { endTime = whihtEndTime, receive = whiteReceive }
	data[UIMonthCard.GoldCardID] = { endTime = goldEndTime, receive = goldReceive }
	self:ResMonthlyCardView(_, data)
end

function this:ResTipMessage(_, message)
	if message.param then
		local giftName = SL:GetConfig("cfg_MonthlyPack", tonumber(message.param)).Packagename
		local count = 0
		for k, v in pairs(message.reward) do
			count = count + tonumber(v)
		end
		if count == 0 then
			return
		end
		message.str = string.format("已激活%s,立刻返利%d钻石", giftName, count)
		GUI:UIPanel_Open("dev/outui/RechargeMonthlycard/Panel/KLUIMonthGainItemTipsPanel/KLUIMonthGainItemTipsPanel", nil, nil, message)
	end
end

---代码适配方法
---@param message RechargeMonthlycard.MonthlyCardViewRes[]
function this:ResMonthlyCardView(_, message)
	if message then
		self.messageTab = message
		self:UpdateUI()
	end
end

function this:CheckMonthIsEndTime()
	--- 检查是否过期
	local serverTime = Time.GetServerTime()
	local data = self.messageTab[UIMonthCard.WhiteCardID]
	if data and data.endTime ~= nil then
		if data.endTime < serverTime then
			return true
		end
	end
	return false
end

function this:CheckGoldMonthIsEndTime()
	--- 检查是否过期
	local serverTime = Time.GetServerTime()
	local data = self.messageTab[UIMonthCard.GoldCardID]
	if data and data.endTime ~= nil then
		if data.endTime < serverTime then
			return true
		end
	end
	return false
end

---界面显示时调用一次
function this:Show()
	SL:SetLocalString(SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID) .. "_RechargeMonthlycard" ,"true")
	SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.MonthCardGift, action = "panel" })
	GUI:setVisible(self.view.whiteSelectImg, false)
	GUI:setVisible(self.view.goldSelectImg, false)
	if self.args and self.args.selectId then
		local cfgInfo1 = self.info:FindCfgInfo(self.cfgListAll, 1)
		local cfgInfo2 = self.info:FindCfgInfo(self.cfgListAll, 2)
		if self.args.selectId == cfgInfo1.id then
			GUI:setVisible(self.view.whiteSelectImg, true)
		end
		if self.args.selectId == cfgInfo2.id then
			GUI:setVisible(self.view.goldSelectImg, true)
		end
	end
	if not string.isNullOrEmpty(self.normalCfg.Graphpath) then
		if not table.isNullOrEmpty(self.normalCfg.oneRewards) then
			GUI:Image_loadTexture(self.view.white,string.format("Texture/%s.png",self.normalCfg.Graphpath))
		else
			GUI:Image_loadTexture(self.view.white,string.format("Texture/%s_2.png",self.normalCfg.Graphpath))
		end
	end
	if not string.isNullOrEmpty(self.goldCfg.Graphpath) then
		if not table.isNullOrEmpty(self.goldCfg.oneRewards) then
			GUI:Image_loadTexture(self.view.gold,string.format("Texture/%s.png",self.goldCfg.Graphpath))
		else
			GUI:Image_loadTexture(self.view.gold,string.format("Texture/%s_2.png",self.goldCfg.Graphpath))
		end
		
	end
	self:ShowRewardUI()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

---奖励列表展示
function this:ShowRewardUI()
	self.NormalRewardListData = self.normalCfg.Rewards
	self.GoldRewardListData = self.goldCfg.Rewards
	GUI:DataListUpdateData(self.view.DataNormalRewardList)
	GUI:DataListUpdateData(self.view.DataGoldRewardList)
	if not table.isNullOrEmpty(self.normalCfg.oneRewards) then
		GUI:Item_UpdataData(self.view.whiteCoinItem, {
			itemid = self.normalCfg.oneRewards[1][1],
			itemcount = 0,
			mfixsize = "40,40",
		})
		GUI:Text_setString(self.view.whiteCoinTxt, tostring(self.normalCfg.oneRewards[1][2]))
	else
		GUI:setVisible(self.view.whiteCoinItem,false)
		GUI:setVisible(self.view.whiteCoinTxt,false)
	end
	
	if not table.isNullOrEmpty(self.goldCfg.oneRewards) then
		GUI:Item_UpdataData(self.view.goldCoinItem, {
			itemid = self.goldCfg.oneRewards[1][1],
			itemcount = 0,
			mfixsize = "30,30",
		})
		GUI:Text_setString(self.view.goldCoinTxt, tostring(self.goldCfg.oneRewards[1][2]))
	else
		GUI:setVisible(self.view.goldCoinItem,false)
		GUI:setVisible(self.view.goldCoinTxt,false)
	end
end

function this:UpdateUI()
	local serverTime = Time.GetServerTime()
	GUI:setVisible(self.view.whiteRed, false)
	GUI:setVisible(self.view.goldRed, false)
	if self:CheckMonthIsEndTime() == true then
		if self.messageTab[UIMonthCard.WhiteCardID].receive == true then
			GUI:setVisible(self.view.EndTimeText, false)
			--GUI:Button_setBright(self.view.MonthCardBtn, true)
			GUI:Text_setString(self.view.TipText, self.TipStr)
			GUI:setVisible(self.view.delete, true)
			GUI:Text_setString(self.view.MonthBtnText, self.normalCfg.Price[1] .. "元")
			GUI:Image_loadTexture(self.view.showtext, "img_monthlycard_whitetext", "Atlas/QJ5_UIRechargeMonthlycardPanel.spriteatlas")
		end
	else
		GUI:setVisible(self.view.EndTimeText, true)
		GUI:Text_setString(self.view.TipText, "月卡已激活")
		GUI:setVisible(self.view.delete, false)
		local Remaintime = self.messageTab[UIMonthCard.WhiteCardID].endTime - serverTime
		GUI:Text_setString(self.view.EndTimeText, "有效期剩余：" .. GUIUtil.FormatTimeD((Remaintime / 1000)-10, false))
		GUI:Image_loadTexture(self.view.showtext, "img_monthlycard2", "Atlas/QJ5_UIRechargeMonthlycardPanel.spriteatlas")
		GUI:Text_setString(self.view.AllCardBtnText, "月卡已激活")
		GUI:setVisible(self.view.bg_bottom, false)
		if self.messageTab[UIMonthCard.WhiteCardID].receive == true then
			GUI:Text_setString(self.view.MonthBtnText, "领取")
			GUI:setVisible(self.view.whiteRed, true)
		else
			GUI:Text_setString(self.view.MonthBtnText, "已领取")
		end
	end
	
	if self:CheckGoldMonthIsEndTime() == true then
		if self.messageTab[UIMonthCard.GoldCardID].receive == true then
			GUI:Image_loadTexture(self.view.Goldshowtext, "img_monthlycard_goldtext", "Atlas/QJ5_UIRechargeMonthlycardPanel.spriteatlas")
			GUI:setVisible(self.view.GoldEndTimeText, false)
			GUI:Text_setString(self.view.GoldMonthBtnText, self.goldCfg.Price[1] .. "元")
			GUI:Text_setString(self.view.GoldTipText, self.GoldTipStr)
			GUI:setVisible(self.view.delete_1, true)
		end
	else
		GUI:setVisible(self.view.GoldEndTimeText, true)
		GUI:Text_setString(self.view.GoldTipText, "月卡已激活")
		GUI:setVisible(self.view.delete_1, false)
		GUI:Image_loadTexture(self.view.Goldshowtext, "img_monthlycard2", "Atlas/QJ5_UIRechargeMonthlycardPanel.spriteatlas")
		GUI:Text_setString(self.view.AllCardBtnText, "月卡已激活")
		GUI:setVisible(self.view.bg_bottom, false)
		--GUI:Button_setBright(self.view.AllCardBtn, false)
		
		local GoldRemaintime = self.messageTab[UIMonthCard.GoldCardID].endTime - serverTime
		GUI:Text_setString(self.view.GoldEndTimeText, "有效期剩余：" .. GUIUtil.FormatTimeD((GoldRemaintime / 1000)-10, false))
		if self.messageTab[UIMonthCard.GoldCardID].receive == true then
			GUI:Text_setString(self.view.GoldMonthBtnText, "领取")
			GUI:setVisible(self.view.goldRed, true)
			--GUI:Button_setBright(self.view.GoldMonthCardBtn, true)
		else
			GUI:Text_setString(self.view.GoldMonthBtnText, "已领取")
			--GUI:Button_setBright(self.view.GoldMonthCardBtn, false)
		end
	end
	
	if self:CheckGoldMonthIsEndTime() == true and self:CheckMonthIsEndTime() == true then
		--GUI:Button_setBright(self.view.AllCardBtn, true)
		GUI:Text_setString(self.view.AllCardBtnText, self.AllCardStr)
		GUI:setVisible(self.view.bg_bottom, true)
	else
		--GUI:Button_setBright(self.view.AllCardBtn, false)
		GUI:setVisible(self.view.bg_bottom, false)
	end
end

---@return cfg_MonthlyPack_column
function this:FindCfgInfo(tab, order)
	for _, v in pairs(tab) do
		if v.sortId == order then
			return v
		end
	end
	return nil
end

function this:Close()
	GUI:setVisible(self.view.bg_bottom, false)
end

return this

---@class KLUIArchangelRewardItem:UIKmlLuaPanelBase
---@field view KLUIArchangelRewardItemView
---@field data cfg_angleBenefitReward_column
local KLUIArchangelRewardItem = class(UIKmlLuaPanelBase)
local this = KLUIArchangelRewardItem

---创建时调用一次
function this:Init()
end

function this:InitData(data)
	self.data = data
	self:RefreshUI()
end

function this:SetControlsHide()
	GUI:setVisible(self.view.TextTime, false)
	GUI:setVisible(self.view.icon, false)
	GUI:setVisible(self.view.remainCount, false)
	GUI:setVisible(self.view.getButton, false)
	GUI:setVisible(self.view.buyButton, false)
	GUI:setVisible(self.view.ClaimedText, false)
	GUI:setVisible(self.view.ClaimedIcon, false)
end

-- 已领取
function this:SetControlsClaimed()
	GUI:setVisible(self.view.ClaimedText, true)
	GUI:setVisible(self.view.ClaimedIcon, true)
	GUI:setVisible(self.view.getButton, false)
	GUI:setVisible(self.view.buyButton, false)
	GUI:setVisible(self.view.remainCount, false)
	GUI:setVisible(self.view.icon, false)
	GUI:Image_loadTexture(self.view.ClaimedIcon, "img_kaifu_get", "Atlas/QJ5_Common.spriteatlas")
end

---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.getButton, self, self.BtnGetOnClick)
	GUI:AddOnClickEvent(self.view.buyButton, self, self.BtnBuyOnClick)
end

function this:BtnGetOnClick()
	if self.data and self.data.id then
		SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECEIVE_ANGLE_BENEFIT_REWARD, { order = self.data.id })
	end
end

function this:BtnBuyOnClick()
	if self.data and self.data.id then
		SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECEIVE_ANGLE_BENEFIT_REWARD, { order = self.data.id })
	end
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshUI()
	self:SetControlsHide()
	local openDay = Utility.GetServerOpenDays() -- 开服天数0点刷新
	local count = self.data.limitNum - self.data.usenum  -- 剩余全服数量
	if count < 0 then
		count = 0
	end
	local integral = self.data.curgoal -- 当前积分，从背包获取
	local maxInterag = self.data.rewardPoint[2]
	self:Refreshicon({ self.data.buyid, self.data.buynum })
	-- 限免时间内UI 显示
	local showTime = self.data.diffTime
	
	if showTime > 0 and count > 0 then
		local time = math.ceil(self.data.limitTime - openDay)
		if time > 1 or showTime/86400000 >= 1 then
			GUI:Text_setString(self.view.TextTime, "<color=#5DE367>" .. time .. "天后过期" .. "</color>") -- 过期时间
		else
			self:ShowTime(showTime)
		end
		GUI:setVisible(self.view.TextTime, true)
		if integral >= maxInterag and count > 0 then
			-- 积分满足
			GUI:setVisible(self.view.getButton, true)
		else
			if self.data.lastgetnumid > 0 then
				if self.data.reqid == self.data.lastgetnumid then
					GUI:setVisible(self.view.remainCount, true)
				end
			else
				GUI:setVisible(self.view.remainCount, true)
			end
		end
	else
		GUI:setVisible(self.view.icon, true)
		self:Refreshicon({ self.data.buyid, self.data.buynum })
		if self.data.lastbuyid > 0 then
			if self.data.reqid == self.data.lastbuyid then
				GUI:setVisible(self.view.buyButton, true)
			end
		else
			GUI:setVisible(self.view.buyButton, true)
		end
	end
	if integral >= maxInterag then
		GUI:Text_setString(self.view.Textcur, "<color=#5DE367>" .. maxInterag .. "</color>") -- 当前积分
	else
		GUI:Text_setString(self.view.Textcur, "<color=#FF5047>" .. maxInterag .. "</color>") -- 当前积分
	end
	
	---- 剩余全服数量/总数量
	local str = "全服限量：" .. count .. "/" .. self.data.limitNum
	GUI:Text_setString(self.view.remainCount, str) -- 当前限免次数
	local reward = SL:GetRewardIdByCareer(self.data.reward)
	self:RefreshitemReward({ reward[1], reward[2] })
	if self.data.isGet then
		self:SetControlsClaimed()
	end
end

-- 最后一天倒计时
function this:ShowTime(diff)
	self:SetCountDown(diff)
end

--- 开启倒计时
---@param time number @倒计时时间，毫秒
function this:SetCountDown(time)
	self.countDown = time / 1000
	local txtTime = Time.FormatTimeDHMSFormColon(self.countDown)
	GUI:Text_setString(self.view.TextTime, "<color=#5DE367>" .. txtTime .. "后过期" .. "</color>") -- 过期时间
	
	self:StopRankTimer()
	self.countDownTimer = SL:Schedule(self.countDownTimer, 0, 1, -1, function()
		local time = Time.FormatTimeDHMSFormColon(self.countDown)
		GUI:Text_setString(self.view.TextTime, "<color=#5DE367>" .. time .. "后过期" .. "</color>") -- 过期时间
		if self.countDown <= 0 then
			self:RefreshUI()
			self:StopRankTimer()
			return
		end
		self.countDown = self.countDown - 1
	end)
end

function this:StopRankTimer()
	if self.countDownTimer then
		SL:UnSchedule(self.countDownTimer)
		self.countDownTimer = nil
	end
end

function this:Refreshcount(cfgid, count)
	local txt = ""
	if count then
		txt = tonumber(count) and Misc.GetSampleNumberString(count) or count
	end
	return txt
end

-- 创建花费icon 
function this:Refreshicon(data)
	local num = SL:GetBagItemCount(data[1]) or 0
	if data then
		local strcur = self:Refreshcount(data[1], data[2])
		if tonumber(num) < tonumber(data[2]) then
			strcur = "<color=#FF5047>" .. strcur .. "</color>"
		else
			strcur = "<color=#ECE8E8>" .. strcur .. "</color>"
		end
		GUI:Text_setString(self.view.numtext, strcur) -- 当前花费
		if not self.iconItem then
			self.iconItem = GUI:Item_Create(self.view.icon, {
				width = "50",
				height = "50",
				itemid = data[1],
				mfixsize = "20,20",
				tips = "1",
				bgtype = "0",
				itemcount = "",
			})
		else
			GUI:Item_UpdataData(self.iconItem, {
				itemid = data[1],
			})
		end
		GUI:setPositionY(self.iconItem, -7)
	end
end

--- 创建奖励itemReward
function this:RefreshitemReward(data)
	if not self.rewardItem then
		self.rewardItem = GUI:Item_Create(self.view.itemReward, {
			width = "50",
			height = "50",
			itemid = data[1],
			mfixsize = "80,80",
			tips = "1",
			bgtype = "0",
			itemcustomcount = data[2],
		})
	else
		GUI:Item_UpdataData(self.rewardItem, {
			itemid = data[1],
		})
	end
	GUI:AddOnClickEvent(self.rewardItem, self, function()
		SL:OpenTips(nil, data[1])
	end)
	self:SetItemEffect(data[1])
end

-- 显示奖励特效
function this:SetItemEffect(cfgId)
	---Eff_Ui_kuang_hong02 奇迹5特效
	local sEffect = SL:GetConfig("cfg_item", cfgId, "id").sEffect
	local effect_id = sEffect == 0 and 30001 or sEffect
	if effect_id and effect_id ~= 0 then
		local effect_tbl = SL:GetConfig("cfg_model_effect", effect_id, "id")
		GUI:Model_setSrc(self.view.effect_model, effect_tbl.path)
		GUI:setVisible(self.view.effect_model, true)
	else
		GUI:setVisible(self.view.effect_model, false)
	end
end

function this:Close()
	self:StopRankTimer()
end

return this

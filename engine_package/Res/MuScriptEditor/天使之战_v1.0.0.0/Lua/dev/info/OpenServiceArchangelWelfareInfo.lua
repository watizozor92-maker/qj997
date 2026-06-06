---@class OpenServiceArchangelWelfareInfo
OpenServiceArchangelWelfareInfo = class()
local this = OpenServiceArchangelWelfareInfo

function this:ctor()

end

function this:Init()
	self.BossBossRedPoint = false
	self.RewardRedPoint = false
	self.WelfareTaskConfig = {}
	self.awardsGetid = {}
	local cfgs = SL:GetConfigTable("cfg_angleBenefitTask")
	for i, v in ipairs(cfgs) do
		self.WelfareTaskConfig[v.id] = v
	end
	self.WelfareRewardConfig = SL:GetConfigTable("cfg_angleBenefitReward")
	self.IntegralId = self.WelfareRewardConfig[1].rewardPoint[1]
	self:InitData()
	self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGLE_BENEFIT_INFO, self.RES_ANGLE_BENEFIT_INFO, self)
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECEIVE_ANGLE_BENEFIT_REWARD, self.RES_RECEIVE_ANGLE_BENEFIT_REWARD, self)
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SUBMIT_ANGLE_BENEFIT_TASK, self.RES_SUBMIT_ANGLE_BENEFIT_TASK, self)
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGLE_BENEFIT_TASK_CHANGE, self.RES_ANGLE_BENEFIT_TASK_CHANGE, self)
	SL:RegisterLUAEvent(LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE, self.LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE, self)
end

function this:LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE(_, message)
	self:TryReqMessageOnce()
end

-- 上进度状态改变：
---@param message OpenServiceArchangelWelfareProtos.AngelWelfareRewardInfoRes
function this:RES_ANGLE_BENEFIT_INFO(_, message)
	self.serverReward = message.serverReward -- 已消耗次数[]
	self.awardsGetid = message.awards
	self.curgoal = SL:GetBagItemCount(self.IntegralId)   -- 个人积分
	self.taskInfo = message.taskInfo
	self:RedDotCheck()
end

---@param message number[]
function this:RES_RECEIVE_ANGLE_BENEFIT_REWARD(_, message)
	self.awardsGetid = message  -- 是否已领取[]
	self:RedDotCheck()
end

---@param message number[]
function this:RES_SUBMIT_ANGLE_BENEFIT_TASK(_, message)
	local typeList = {}
	if not table.isNullOrEmpty(self.taskInfo) then
		for i, v in pairs(self.taskInfo) do
			typeList[self.WelfareTaskConfig[tonumber(i)].type] = i
		end
	end
	for i, v in pairs(message) do
		if typeList[self.WelfareTaskConfig[tonumber(i)].type] ~= nil then
			self.taskInfo[typeList[self.WelfareTaskConfig[tonumber(i)].type]] = nil
			self.taskInfo[i] = v
		end
	end
	self.curgoal = SL:GetBagItemCount(self.IntegralId)
	self:RedDotCheck()
end

---@param message number[]
function this:RES_ANGLE_BENEFIT_TASK_CHANGE(_, message)
	self.taskInfo = message
	self:RedDotCheck()
end
----@param data GoldFirstKillProtos.ResponseAllServerFirstKillData
function this:RedDotCheck()
	if not self.serverReward or not self.awardsGetid then
		return
	end
	self.RedPointState = false
	if not table.isNullOrEmpty(self.taskInfo) then
		for i, v in pairs(self.taskInfo) do
			if v.status == "2" then
				self.RedPointState = true
				break
			end
		end
	end
	if not self.RedPointState then
		---@param v cfg_angleBenefitReward_column
		for i, v in pairs(self.WelfareRewardConfig) do
			local num = 0
			if self.serverReward[tostring(v.id)] then
				num = tonumber(self.serverReward[tostring(v.id)])
			end
			if self.curgoal >= v.rewardPoint[2] and (v.limitNum - num) > 0 then
				if not table.getValue(self.awardsGetid, tostring(v.id)) then
					self.RedPointState = true
					break
				end
			end
		end
	end
	InfoManager.mainActivityInfo:RefreshMainActivityRedPoint("tog_2", self.RedPointState)
end

function this:TryReqMessageOnce()
	-- if not self.isReqMsg then
	-- 	self.isReqMsg = true
	-- 	SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ANGLE_BENEFIT_INFO)
	-- end
end

function this:Reset()
	self.isReqMsg = nil
end
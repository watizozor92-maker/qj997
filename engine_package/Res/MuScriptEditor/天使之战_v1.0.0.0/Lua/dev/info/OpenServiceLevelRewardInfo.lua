---@class OpenServiceLevelRewardInfo
OpenServiceLevelRewardInfo = class()
local this = OpenServiceLevelRewardInfo

function this:ctor()
end

function this:Init()
    self.personInfo = {} --个人领取信息
    self.serverInfo = {} --全服限量信息
	self.levelRewardCfg = {}
	local cfgs = SL:GetConfigTable("cfg_activity_levelUp")
	for i,v in pairs(cfgs) do
		self.levelRewardCfg[v.id] = v
	end
	self.ShowTypeInfo = {}
	self.RedPointState = false
	self:InitData()
	self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PERSONAL_LEVEL_REWARD_INFO, self.RES_PERSONAL_LEVEL_REWARD_INFO, self)
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECEIVE_LEVEL_REWARD, self.RES_RECEIVE_LEVEL_REWARD, self)
	SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE, self)
	SL:RegisterLUAEvent(LUA_EVENT_VIP_CHANGE, self.LUA_EVENT_VIP_CHANGE, self)
end

function this:RES_PERSONAL_LEVEL_REWARD_INFO(id, message)
	if not message then
		return
	end
	--个人领取
	self.personInfo = {}
	if message.personInfo then
		for idStr,data in pairs(message.personInfo) do
			local id = tonumber(idStr)
			self.personInfo[id] = {}
			self.personInfo[id].basicItem = data.basicItem == "true"
			self.personInfo[id].specialItem = data.specialItem == "true"
		end
	end
	--全服限量
    self.serverInfo = {}
	if message.serverInfo then
		for idStr,num in pairs(message.serverInfo) do
			self.serverInfo[tonumber(idStr)] = tonumber(num)
		end
	end
	self:RedDotCheck()
	SL:onLUAEvent(LUA_EVENT_OPENSERVICE_LEVEL_REWARD_CHANGE)
end

function this:RES_RECEIVE_LEVEL_REWARD(id, message)
	if not message then
		return
	end
	--个人领取
	for idStr,data in pairs(message) do
		local id = tonumber(idStr)
		self.personInfo[id] = {}
		self.personInfo[id].basicItem = data.basicItem == "true"
		self.personInfo[id].specialItem = data.specialItem == "true"
	end
	self:RedDotCheck()
	SL:onLUAEvent(LUA_EVENT_OPENSERVICE_LEVEL_REWARD_CHANGE)
end

function this:RedDotCheck()
	self.ShowTypeInfo = {}
	local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
	--- @param cfg cfg_activity_levelUp_column
	for id,cfg in pairs(self.levelRewardCfg) do
		--1. 等级不够 无限量不显示，有限量显示限量
		--2. 等级足够 限量已到上限，判断是否已领取普通奖励：
		--  1. 普通奖励未领取，显示限量
		--  2. 普通奖励已领取，判断特殊奖励领取：
		--    1. 特殊奖励已领取，显示已领取
		--    2. 特殊奖励未领取，判断特殊条件，满足显示领取特殊奖励，不满足特殊条件显示特殊跳转
		--3. 等级足够（无限量或限量足够），判断特殊领取：
		--  1. 特殊奖励已领取显示已领取
		--  2. 特殊奖励未领取，判断特殊条件，满足显示领取特殊奖励，不满足特殊条件：
		--    1. 普通奖励已领取，显示特殊跳转
		--    2. 普通奖励未领取，显示领取普通奖励
		if playerLevel < cfg.level then
			if string.isNullOrEmpty(cfg.Places) then
				self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.LevelNotEnough
			else
				self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.ServerCount
			end
		elseif not string.isNullOrEmpty(cfg.Places) and self.serverInfo[id] and self.serverInfo[id] >= tonumber(cfg.Places) then
			if not self.personInfo[id] or not self.personInfo[id].basicItem then
				self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.ServerCount
			else
				if self.personInfo[id].specialItem then
					self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.HaveGotten
				elseif string.isNullOrEmpty(cfg.conditions) or ConditionManager.Check4D(cfg.conditions) then
					self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.GetSpecialOnly
				else
					self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.SpecialGoto
				end
			end
		else
			if self.personInfo[id] and self.personInfo[id].specialItem then
				self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.HaveGotten
			else
				if string.isNullOrEmpty(cfg.conditions) or ConditionManager.Check4D(cfg.conditions) then
					if self.personInfo[id] and self.personInfo[id].basicItem then
						self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.GetSpecialOnly
					else
						self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.GetSpecial
					end
				else
					if self.personInfo[id] and self.personInfo[id].basicItem then
						self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.SpecialGoto
					else
						self.ShowTypeInfo[id] = OpenServiceLevelReward_ShowType.GetNormal
					end
				end
			end
		end
	end
	self.RedPointState = false
	for id,state in pairs(self.ShowTypeInfo) do
		if state == OpenServiceLevelReward_ShowType.GetNormal or state == OpenServiceLevelReward_ShowType.GetSpecial or state == OpenServiceLevelReward_ShowType.GetSpecialOnly then
			self.RedPointState = true
			break
		end
	end
	InfoManager.mainActivityInfo:RefreshMainActivityRedPoint("tog_LevelReward", self.RedPointState)
end

---@class OpenServiceLevelReward_ShowType
OpenServiceLevelReward_ShowType = {
    GetNormal = enum(1), --领取普通奖励
    GetSpecial = enum(), --领取全部奖励
    GetSpecialOnly = enum(), --领取特殊奖励
    SpecialGoto = enum(), --不满足特殊条件 进行跳转
	HaveGotten = enum(), --已经领取
	ServerCount = enum(), --全服限量
	LevelNotEnough = enum(), --等级不够 不显示
}

function this:LUA_EVENT_LEVELCHANGE()
	--暂时每次升级都刷新
	self:RedDotCheck()
	SL:onLUAEvent(LUA_EVENT_OPENSERVICE_LEVEL_REWARD_CHANGE)
end
function this:LUA_EVENT_VIP_CHANGE()
	self:RedDotCheck()
	SL:onLUAEvent(LUA_EVENT_OPENSERVICE_LEVEL_REWARD_CHANGE)
end

function this:Reset()
	
end
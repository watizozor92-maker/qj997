---@class KLBossOfferRewardPanel:UIKmlLuaPanelBase
---@field view KLBossOfferRewardPanelView
---@field bossLevelBtnItem KLBossOfferRewardBtnItem[]
---@field select_btn_level number 选择的按钮对应的等级
---@field select_btn KLBossOfferRewardBtnItem
---@field bossLevelModelItem KLBossOfferRewardModelItem[]
local KLBossOfferRewardPanel = class(UIKmlLuaPanelBase)
local this =KLBossOfferRewardPanel
E_ReceiveState = {
	CanReceive = enum(0),
	HadReceive = enum(1)
}
---创建时调用一次
function this:Init()
	SL.HideMainPanel()
	GUI:DataListInitData(self.view.levelList,function()
		return self:BossBtnDataListItemCountFunc()
	end,function(realIndex)
		return self:BossBtnDataListItemGetFunc(realIndex)
	end,function(realIndex, kmlcontrol)
		return self:BossBtnDataListItemInitFunc(realIndex, kmlcontrol)
	end, function(realIndex, kmlcontrol)
		return self:BossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
	end)
	self.bossLevelBtnItem = {}

	GUI:DataListInitData(self.view.bossDataList,function()
		return self:BossDataListItemCountFunc()
	end,function(realIndex)
		return self:BossDataListItemGetFunc(realIndex)
	end,function(realIndex, kmlcontrol)
		return self:BossDataListItemInitFunc(realIndex, kmlcontrol)
	end, function(realIndex, kmlcontrol)
		return self:BossDataListItemUpdateFunc(realIndex, kmlcontrol)
	end)
	self.bossLevelModelItem = {}
	
	GUI:DataListInitData(self.view.bossRewardList,function()
		return self:BossRewardDataListItemCountFunc()
	end,function(realIndex)
		return self:BossRewardDataListItemGetFunc(realIndex)
	end,function(realIndex, kmlcontrol)
		return self:BossRewardDataListItemInitFunc(realIndex, kmlcontrol)
	end, function(realIndex, kmlcontrol)
		return self:BossRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
	end)
	self.bossRewardItem = {}
end

function this:BossBtnDataListItemCountFunc()
	return #self.allBossLevelData
end

function this:BossBtnDataListItemGetFunc(realIndex)
	local item = GUI:UIPanel_Open("dev/outui/BossOfferReward/Item/KLBossOfferRewardBtn/KLBossOfferRewardBtnItem",self.view.levelList,self,{},true)
	
	self.bossLevelBtnItem[item.view.root] = item
	return item.view.root
end

function this:BossBtnDataListItemInitFunc(realIndex, kmlcontrol)
	
end

function this:BossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
	local data = self.allBossLevelData[realIndex + 1]
	self.bossLevelBtnItem[kmlcontrol]:RefreshItem(data,self.select_btn_level,self)
	if data == self.select_btn_level then
		self.select_btn = self.bossLevelBtnItem[kmlcontrol]
	end
end

function this:BossDataListItemCountFunc()
	return #self.bossModelShowData
end

function this:BossDataListItemGetFunc(realIndex)
	local item = GUI:UIPanel_Open("dev/outui/BossOfferReward/Item/KLBossOfferRewardModel/KLBossOfferRewardModelItem",self.view.bossDataList,self,{},true)
	
	self.bossLevelModelItem[item.view.root] = item
	return item.view.root
end

function this:BossDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:BossDataListItemUpdateFunc(realIndex, kmlcontrol)
	local data = self.bossModelShowData[realIndex + 1]
	self.bossLevelModelItem[kmlcontrol]:RefreshItem(data)
end


function this:BossRewardDataListItemCountFunc()
	return #self.bossRewardData
end

function this:BossRewardDataListItemGetFunc(realIndex)
	local data = self.bossRewardData[realIndex + 1]
	local item = GUI:Item_Create(self.view.bossRewardList,{
		width = "60",
		height = "60",
		itemid = data[1],
		mfixsize = "60,60",
		tips = "1",
		itemcustomcount = SL:GetSimpleNumber(data[2],0),
		textcolor = "#FBD994"
	})
	GUI:AddOnClickEvent(item,self,function()
		SL:OpenTips(nil, data[1])
	end)
	self.bossRewardItem[item] = item
	return item
end

function this:BossRewardDataListItemInitFunc(realIndex, kmlcontrol)
	
end

function this:BossRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
	local data = self.bossRewardData[realIndex + 1]
	local item = self.bossRewardItem[kmlcontrol]
	GUI:Item_UpdataData(item,{
		itemid = data[1],
		itemcustomcount = SL:GetSimpleNumber(data[2],0),
	})
	GUI:AddOnClickEvent(item,self,function()
		SL:OpenTips(nil, data[1])
	end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
	self.bossModelShowData = {}
	self.allBossLevelData = InfoManager.bossOfferRewardInfo:GetCanShowLevel()
	
	self:InitUIShow()
	self:ButtomReceiveBtnState()
end

function this:InitUIShow()
	GUI:setVisible(self.view.btn_reward,false)
	GUI:setVisible(self.view.img_all_receive,false)
	self:InitSelectBtn()
end

function this:InitSelectBtn()
	local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
	--local playerLevel = 60

	self.select_btn_level = nil
	local index = 0
	for i, level in ipairs(self.allBossLevelData) do
		if not self.select_btn_level then
			self.select_btn_level = level
			index = i-1
		else
			if level <= playerLevel and level > self.select_btn_level then
				self.select_btn_level = level
				index = i-1
			end
		end
	end
	self:RefreshRightList()
end

function this:RefreshRightList()
	local groupInfo = cfg_newarea_offerreward_post.GetGroupInfo()
	local levelRewardInfo = cfg_newarea_offerreward_post.GetGroupRewardInfo()
	local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
	if playerLevel >= self.select_btn_level then
		self.bossModelShowData = groupInfo[self.select_btn_level]
		GUI:setVisible(self.view.txt_lock,false)
	else
		self.bossModelShowData = {}
		GUI:setVisible(self.view.txt_lock,true)
		local levelStr =  SL:GetColorText(string.format("%d级",self.select_btn_level),SL:GetColorCfg(271).color)
		GUI:Text_setString(self.view.txt_lock,table.concat{"等级达到",levelStr,"解锁本层悬赏"})
	end
	
	self.bossRewardData =  levelRewardInfo[self.select_btn_level]
	self:SortModelShowData()
	GUI:DataListUpdateData(self.view.levelList)
	GUI:DataListUpdateData(self.view.bossDataList)
	GUI:DataListUpdateData(self.view.bossRewardList)
	GUI:SetScrollView_scrollpos(self.view.levelContent,"1")
end

function this:SortModelShowData()
	table.sort(self.bossModelShowData,function(a, b)
		local status_a = InfoManager.bossOfferRewardInfo:GetMonsterStateByMonserId(a.monsterId)
		local status_b = InfoManager.bossOfferRewardInfo:GetMonsterStateByMonserId(b.monsterId)
		local id_a = cfg_newarea_offerreward_post.GetCfgByMonsterId(a.monsterId).id
		local id_b = cfg_newarea_offerreward_post.GetCfgByMonsterId(b.monsterId).id
		if status_a == E_MonsterShowState.CanReceive and status_b == E_MonsterShowState.CanReceive  then
			if status_a == status_b then
				return id_a < id_b
			end
		end
		if status_a == E_MonsterShowState.CanReceive then
			return true
		end
		if status_b == E_MonsterShowState.CanReceive then
			return false
		end
		
		if status_a == E_MonsterShowState.HadReceive and status_b == E_MonsterShowState.HadReceive  then
			if status_a == status_b then
				return id_a < id_b
			end
		end
		if status_a == E_MonsterShowState.HadReceive then
			return false
		end
		if status_b == E_MonsterShowState.HadReceive then
			return true
		end
		return id_a < id_b
	end)
end

---底部领取按钮状态展示
function this:ButtomReceiveBtnState()
	local state = InfoManager.bossOfferRewardInfo:GetLevelRewardState(self.select_btn_level)
	if state == E_LevelRewardState.HadReceive then
		GUI:setVisible(self.view.img_all_receive,true)
		GUI:setVisible(self.view.btn_reward,false)
	else
		GUI:setVisible(self.view.img_all_receive,false)
		GUI:setVisible(self.view.btn_reward,true)
	end
end

function this:HideSelectLevel()
	self.select_btn:HideItem()
end

function this:SelectLevel(level,btn)
	self.select_btn = btn
	self.select_btn_level = level
	self:RefreshRightList()
	self:ButtomReceiveBtnState()
end

---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.btn_close,self,self.CloseBtn)
	GUI:AddOnClickEvent(self.view.btn_reward,self,self.RewardBtn)
	SL:RegisterLUAEvent(LUA_EVENT_BOSS_OFFER_CHANGE,self.BossOfferDataChange,self) 
end

function this:CloseBtn()
	GUI:UIPanel_Close("dev/outui/BossOfferReward/Panel/KLBossOfferReward/KLBossOfferRewardPanel")
	SL.ShowMainPanel()
end

function this:RewardBtn()
	local state = InfoManager.bossOfferRewardInfo:GetLevelRewardState(self.select_btn_level)
	if state == E_LevelRewardState.NotCanReceive then
		SL:TipMessage("完成所有".. self.select_btn_level .. "级悬赏任务后领取", 3, NoticeType.NoticeMid )
	else
		local _group = cfg_newarea_offerreward_post.GetGroupIdByLevel(self.select_btn_level)
		SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BOUNTY_GROUP_REWARD,{id = _group })
	end
end

function this:BossOfferDataChange()
	self:RefreshRightList()
	self:ButtomReceiveBtnState()
end

function this:Close()
	self.allBossLevelData = nil
	self.bossRewardData = nil
	self.bossModelShowData = nil
end

return this

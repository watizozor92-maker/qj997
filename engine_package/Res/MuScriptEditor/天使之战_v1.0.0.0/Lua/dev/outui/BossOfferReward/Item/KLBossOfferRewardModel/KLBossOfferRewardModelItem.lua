---@class KLBossOfferRewardModelItem:UIKmlLuaPanelBase
---@field view KLBossOfferRewardModelItemView
local KLBossOfferRewardModelItem = class(UIKmlLuaPanelBase)
local this =KLBossOfferRewardModelItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

---@param data cfg_newarea_offerreward_column
function this:RefreshItem(data)
	self.monsterId = data.monsterId
	self.state = InfoManager.bossOfferRewardInfo:GetMonsterStateByMonserId(self.monsterId)
	---@type cfg_monster_column
	local tab = SL:GetConfigMultiKeys('cfg_monster', self.monsterId, 'id')
	local appr = tab.appr
	local path = SL:GetConfigMultiKeys('cfg_model_monster', appr, 'id').path
	self.monsterType = SL:GetConfigMultiKeys('cfg_BOSS_challenge', self.monsterId, 'monsterid').monsterType
	local scale = tab.UIscale
	if data.monsterId == 500023 then
		GUI:setPosition(self.view.node,-36,12)
	else
		GUI:setPosition(self.view.node,0,51)
	end
	
	local pos = nil
	
	if not table.isNullOrEmpty(tab.uipos)  then
		pos = string.format("%d,%d,%d",tab.uipos[1],tab.uipos[2],tab.uipos[3])
	end
	
	if pos then
		GUI:setVisible(self.view.monster,false)
		GUI:setVisible(self.view.monster2,true)
		GUI:Model_setSrc(self.view.monster2,path,"22,22,22",nil,pos)
	else
		GUI:setVisible(self.view.monster,true)
		GUI:setVisible(self.view.monster2,false)
	end
	
	if scale == 0 then
		GUI:Model_setSrc(self.view.monster,path,nil,"0,-150,0",pos,"300,300")
	else
		scale = string.format("%d,%d",200*scale,200*scale)
		GUI:Model_setSrc(self.view.monster,path,nil,"0,-150,0",pos,scale)
		if pos then
			GUI:Model_setSrc(self.view.monster2,path,"22,22,22",nil,pos)
			GUI:setVisible(self.view.monster,false)
			GUI:setVisible(self.view.monster2,true)
		end
	end

	if not self.item then
		self.item = GUI:Item_Create(self.view.modelExp,{
			width = "60",
			height = "60",
			itemid = data.reward[1],
			mfixsize = "60,60",
			tips = "1",
			itemcustomcount = SL:GetSimpleNumber(data.reward[2],0),
			textcolor = "#FBD994"
		})
	else
		GUI:Item_UpdataData(self.item,{
			itemcustomcount = SL:GetSimpleNumber(data.reward[2],0),
		})
	end
	
	GUI:AddOnClickEvent(self.item,self,function()
		SL:OpenTips(nil, data.reward[1])
	end)
	
	
	self:ShowMonsterInfo(tab)
end

---@param monster cfg_monster_column
function this:ShowMonsterInfo(monster)
	local name = monster.name
	local nameStr
	if monster.type == MonsterType.GoldMonster then
		name = SL:GetColorText(name,SL:GetColorCfg(2001).color)
	else
		name = SL:GetColorText(name,SL:GetColorCfg(271).color)
	end
	if self.state == E_MonsterShowState.Go then
		nameStr = SL:GetColorText(table.concat({0,"/","1"}),SL:GetColorCfg(271).color)
		nameStr =  table.concat({name," ",nameStr})
		self:ShowGoState()
	elseif self.state == E_MonsterShowState.CanReceive then
		nameStr = SL:GetColorText(table.concat({1,"/","1"}),SL:GetColorCfg(2).color)
		nameStr =  table.concat({name," ",nameStr})
		self:ShowCanReceiveState()
	elseif self.state == E_MonsterShowState.HadReceive then
		nameStr = SL:GetColorText(table.concat({1,"/","1"}),SL:GetColorCfg(2).color)
		nameStr =  table.concat({name," ",nameStr})
		self:ShowHadReceiveState()
	end
	

	GUI:Text_setString(self.view.name,nameStr)
end

---未击杀状态展示
function this:ShowGoState()
	GUI:setVisible(self.view.img_receive,false)
	GUI:Button_setTitleText(self.view.btn_go_get,"前往击杀")
	GUI:setVisible(self.view.btn_go_get,true)
	GUI:Button_loadTextures(self.view.btn_go_get,"button_interface_window11",nil,nil,"Atlas/Common.spriteatlas")
end

---可领取状态展示
function this:ShowCanReceiveState()
	GUI:setVisible(self.view.btn_go_get,true)
	GUI:setVisible(self.view.img_receive,false)
	GUI:Button_setTitleText(self.view.btn_go_get,"领取")
	GUI:Button_loadTextures(self.view.btn_go_get,"button_interface_window9",nil,nil,"Atlas/Common.spriteatlas")
end

---已领取状态展示
function this:ShowHadReceiveState()
	GUI:setVisible(self.view.img_receive,true)
	GUI:setVisible(self.view.btn_go_get,false)
end

---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.btn_go_get,self,self.OnclickBtn)
end

function this:OnclickBtn()
	if self.state == E_MonsterShowState.Go then
		GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel",nil,
				nil,{monsterId = self.monsterId,monsterType = self.monsterType })
		GUI:UIPanel_Close("dev/outui/BossOfferReward/Panel/KLBossOfferReward/KLBossOfferRewardPanel")
		SL.HideMainPanel()
	elseif self.state == E_MonsterShowState.CanReceive then
		SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BOUNTY_MONSTER_REWARD,{id=self.monsterId})
	end
end

function this:Close()
	self.item = nil
end

return this

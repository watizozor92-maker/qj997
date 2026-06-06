---@class KLUIArchangelWelfareItem:UIKmlLuaPanelBase
---@field view KLUIArchangelWelfareItemView
local KLUIArchangelWelfareItem = class(UIKmlLuaPanelBase)
local this = KLUIArchangelWelfareItem

---创建时调用一次
function this:Init()
	self.remainCount = ""
	self.itemTemplateList = {}
	self.isCanReceive = false
	self.RewardItems = {}
	self.height = GUI:GetControlHeight(self.view.loopscrollview)
	self.oneItemWidth = 70
	self:InitRewardList()
end

function this:InitRewardList()
	GUI:DataListInitData(self.view.loopscrolldata, function()
		return self:RewardItemCountFunc()
	end, function(realIndex)
		return self:RewardItemGetFunc(realIndex)
	end, function(realIndex, kmlcontrol)
		return self:RewardItemInitFunc(realIndex, kmlcontrol)
	end, function(realIndex, kmlcontrol)
		return self:RewardItemUpdateFunc(realIndex, kmlcontrol)
	end)
end

function this:RewardItemCountFunc()
	return table.count(self.rewardInfo)
end

function this:RewardItemGetFunc(realIndex)

end

function this:RewardItemInitFunc(realIndex, kmlcontrol)
end

function this:RewardItemUpdateFunc(realIndex, kmlcontrol)
	local ctrlItem = GUI:GetChildControl(self.view.loopscrolldata, realIndex, 'ItemIcon', kmlcontrol)
	local luaIndex = realIndex + 1
	local dt = self.rewardInfo[luaIndex]
	GUI:Item_setItemId(ctrlItem, dt[1])
	GUI:Item_setItemCount(ctrlItem,tostring(dt[2]))
	GUI:AddOnClickEvent(ctrlItem, self, function()
		SL:OpenTips(nil, dt[1])
	end)
end

---@param data {cfg:cfg_angleBenefitTask_column,info:OpenServiceArchangelWelfareProtos.TaskInfo}
function this:InitData(data)
	self.cfgInfo = data.cfg
	self.taskID = data.cfg.taskTargetId[1]
	self.isCanReceive = false
	--self.view.UIArchangelWelfareTemplate.image.raycastTarget = false
	if data then
		local taskGoalRecord = data.info
		local goalCount = SL:GetConfig("cfg_task_target", self.taskID).goalCount
		if taskGoalRecord.status ~= "1" then
			self.remainCount = "<color=#5DE367>" .. "已完成" .. "</color>"
			GUI:Text_setString(self.view.Text, "领 取")
			self.isCanReceive = true
			GUI:setVisible(self.view.EffectHighlight, true)
		else
			self.remainCount = "<color=#FF5047>" .. data.info.nowCount .. "</color>" .. "/" .. goalCount
			GUI:Text_setString(self.view.Text, "前 往")
			GUI:setVisible(self.view.EffectHighlight, false)
		end
	end
	self.rewardInfo = data.cfg.rewardItem
	if #self.rewardInfo >= 3 then
		GUI:setContentSize(self.view.loopscrollview, self.oneItemWidth * 3 + 10, self.height)
	else
		GUI:setContentSize(self.view.loopscrollview, self.oneItemWidth * #self.rewardInfo + 10, self.height)
	end
	GUI:DataListUpdateData(self.view.loopscrolldata)
end

function this:BtnGetOnClick()
	local isshow = GUI:getVisible(self.view.EffectHighlight)
	if isshow then
		GUI:setVisible(self.view.EffectHighlight, false)
		SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SUBMIT_ANGLE_BENEFIT_TASK, { type = self.cfgInfo.type })
	end
end
---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.BtnGo, self, self.BtnGoOnClick)
end

function this:BtnGoOnClick()
	if self.isCanReceive then
		self:BtnGetOnClick()
		return
	end
	---@type cfg_task_target_column
	local taskConfig = SL:GetConfig("cfg_task_target", self.taskID)
	
	if taskConfig then
		if self.cfgInfo.type == 2 then
			local monsterId = taskConfig.taskGoalParam
			local monsterType = SL:GetConfigMultiKeys('cfg_BOSS_challenge', monsterId, 'monsterid').monsterType
			GUI:UIPanel_Close("dev/outui/MainActivity/Panel/KLMainActivity/KLMainActivityPanel")
			GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel", nil,
					nil, { monsterId = monsterId, monsterType = monsterType })
		
		else
			GUI:UIPanel_Close("dev/outui/MainActivity/Panel/KLMainActivity/KLMainActivityPanel")
			shortcutOutMgr.DO(taskConfig.instruction[1])
		end
	end
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshUI()
	GUI:Text_setString(self.view.giftName, self.cfgInfo.taskTitle)
	GUI:Text_setString(self.view.giftDesc, self.cfgInfo.taskDesc)
	GUI:Text_setString(self.view.remainCount, self.remainCount)
end

function this:Close()
end

return this

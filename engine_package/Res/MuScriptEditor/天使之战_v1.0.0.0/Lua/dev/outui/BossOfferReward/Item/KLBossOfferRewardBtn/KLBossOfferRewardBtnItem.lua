---@class KLBossOfferRewardBtnItem:UIKmlLuaPanelBase
---@field view KLBossOfferRewardBtnItemView
local KLBossOfferRewardBtnItem = class(UIKmlLuaPanelBase)
local this =KLBossOfferRewardBtnItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
	
end

---@param panel KLBossOfferRewardPanel
function this:RefreshItem(level,select_gold_level,panel)
	if not self.redDot then
		self.redDot = SL:CreateRedPoint(self.view.btn,{68,18})
	end
	self.panel = panel
	self.level = level
	GUI:Text_setString(self.view.type_name,level.."级")
	if level == select_gold_level then
		GUI:setVisible(self.view.level_select,true)
	else
		GUI:setVisible(self.view.level_select,false)
	end
	local state = InfoManager.bossOfferRewardInfo:GetLevelRewardState(level)
	local isRedDot = InfoManager.bossOfferRewardInfo:IsHasRewardInOneLevel(level)
	GUI:setVisible(self.view.img_completed_flag,state == E_LevelRewardState.HadReceive)
	GUI:setVisible(self.redDot,isRedDot)
end

function this:HideItem()
	GUI:setVisible(self.view.level_select,false)
end

---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.btn,self,self.OnclickIcon)
end


function this:OnclickIcon()
	self.panel:HideSelectLevel()
	GUI:setVisible(self.view.level_select,true)
	self.panel:SelectLevel(self.level,self)
end

function this:Close()
end

function this:Close()
end
return this

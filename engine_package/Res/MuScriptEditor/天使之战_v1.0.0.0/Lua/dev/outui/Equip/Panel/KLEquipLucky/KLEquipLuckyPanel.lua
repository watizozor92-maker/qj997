---@class KLEquipLuckyPanel:UIKmlLuaPanelBase
---@field view KLEquipLuckyPanelView
local KLEquipLuckyPanel = class(UIKmlLuaPanelBase)
local this =KLEquipLuckyPanel
local canStrengthMaxLevel = 9
---创建时调用一次
function this:Init()
	self:OpenEquipUIPanel()
	self.bagIndex = nil
	self.equipIndex = nil
	self.strengthAttTextList = {}
	self.costList = {}
	self.showLiuGuang = false
	GUI:setVisible(self.view.equip_show_tips, false)
	GUI:DataListInitData(self.view.strength_list, function()
		return table.count(self.strengthAttTextList)
	end,function()
	
	end,function()
	
	end,function(realIndex)
		local strengthInfo = self.strengthAttTextList[realIndex+1]
		local name = strengthInfo['attrName']
		local preValue = strengthInfo['preValue']
		local nextValue = strengthInfo['nextValue']
		local arrowShow = strengthInfo['arrowShow']
		
		local attControl = GUI:GetChildControl(self.view.strength_list,realIndex,'attrName')
		local preControl = GUI:GetChildControl(self.view.strength_list,realIndex,'preValue')
		local nextControl = GUI:GetChildControl(self.view.strength_list,realIndex,'nextValue')
		local arrowControl = GUI:GetChildControl(self.view.strength_list,realIndex,'arrow')
		
		
		local result = ""
		local len = utf8.len(name)  -- 获取字符串的 UTF-8 长度
		local i = 1
		local j = 1
		-- 使用 utf8.offset 来逐个字符提取
		while i <= len do
			local char = utf8.sub(name, i, i+1)
			result = result .. char .. " "
			i = i+1 -- 移动到下一个字符
		end
		GUI:Text_setString(attControl, result)
		GUI:Text_setString(preControl, tostring(preValue))
		GUI:Text_setString(nextControl, tostring(nextValue))
		GUI:setVisible(arrowControl, arrowShow)
	end)
	
	GUI:DataListInitData(self.view.cost_list, function()
		return table.count(self.costList)
	end,function()
	
	end,function()
	
	end,function(realIndex)
		local costInfo = self.costList[realIndex+1]
		local cfgId = costInfo.costTag[1]
		local needCount = costInfo.costTag[2]
		
		local itemControl = GUI:GetChildControl(self.view.cost_list,realIndex,'cost_item')
		local nameControl = GUI:GetChildControl(self.view.cost_list,realIndex,'cost_name')
		local numControl = GUI:GetChildControl(self.view.cost_list,realIndex,'cost_num')
		--local costAddBtn = GUI:GetChildControl(self.view.cost_list,realIndex,'costAddBtn')
		local costSelectTog = GUI:GetChildControl(self.view.cost_list,realIndex,'costSelectTog')
		local bindItemTips = GUI:GetChildControl(self.view.cost_list,realIndex,'bindItemTips')
		
		if not SL:HasConfig('cfg_item', cfgId) then
			return
		end
		GUI:Item_setItemId(itemControl, cfgId)
		
		local cfg = SL:GetConfig('cfg_item', cfgId)
		GUI:Text_setString(nameControl, cfg.name)
		GUI:setVisible(bindItemTips, cfg.lockItem[1] == 2)
		
		local haveCount = SL:GetBagItemCount(cfgId,false)
		
		if haveCount < needCount then
			GUI:Text_setString(numControl, string.format('<color="#9b1818">%d</color>/%d', haveCount, needCount))
		else
			GUI:Text_setString(numControl, string.format('<color="#00ff00">%d</color>/%d', haveCount, needCount))
		end
		
		GUI:SetToggleOnValueChange(costSelectTog, self, self.costSelectTog, { info = costInfo, showTips = true })
		if self.selectCostCfg.id == costInfo.id then
			--GUI:Toggle_setIsOn(costSelectTog, true)
			GUI:SetIsOnWithoutNotify(costSelectTog, true)
		end
	end)

end

function this:costSelectTog(control, eventData, args, force)
	local isOn = args[1]
	if isOn then
		if force or self.selectCostCfg == nil or self.selectCostCfg.id ~= eventData.info.id then
			self.selectCostCfg = eventData.info
			-- 刷新成功等级，成功率，失败概率
			--GUI:Text_setString(self.view.nextLevel, "+" .. self.strengthLevel + self.selectCostCfg.successLevel)
			GUI:Text_setString(self.view.baseSuccessRatioText, "成功率+"..(self.selectCostCfg.rateClient // 100).."%")
			--GUI:Text_setString(self.view.failTips, self.selectCostCfg.tips)baseSuccessRatioTe
		else
			if eventData.showTips then
				SL:CommonItemGetPath(nil, self.selectCostCfg.costTag[1], nil, nil, nil, nil, nil, {clickControl = control})
			end
		end
	end
end

function this:costAddBtn(control, eventData)
	local cfgId = eventData.cfgId
	SL:CommonItemGetPath(nil, cfgId)
end

---创建或者刷新界面数据时调用
function this:Refresh()
	if not self.equipPanel then
		return
	end
	self.bagIndex = nil
	self.equipIndex = nil
	GUI:setVisible(self.view.gotoButton, false)
	self:SelectEquip(self.args and self.args.equipSlot or nil)
	SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
	if self.args and self.args.equipSlot then
		self.args.equipSlot = nil
	end
end

---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.CloseButton, self, self.CloseButton)
	GUI:AddOnClickEvent(self.view.strengthButton, self, self.strengthButton)
	GUI:AddOnClickEvent(self.view.closeMask, self, self.closeMask)
	GUI:AddOnClickEvent(self.view.gotoButton, self, self.gotoButton)
	GUI:AddOnClickEvent(self.view.liuGuangBtn, self, self.liuGuangBtn)
	GUI:AddOnClickEvent(self.view.strengthMasterBtn, self, self.strengthMasterBtn)
	--GUI:AddOnClickEvent(self.view.item_model, self, self.item_modelOnClick)
	GUI:AddOnClickEvent(self.view.Btn_Helper, self, self.OnClick_Btn_Helper)
	SL:RegisterLUAEvent(LUA_EVENT_EQUIP_GRID_CLICK, self.LUA_EVENT_EQUIP_GRID_CLICK, self)
	SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
	--SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.LUA_EVENT_MONEYCHANGE, self)
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ACTIVE_EQUIP_LUCKY_RESULT, self.RES_ACTIVE_EQUIP_LUCKY_RESULT, self)
	
	GUI:SetToggleOnValueChange(self.view.equipBtn, self, self.equipBtn)
	GUI:SetToggleOnValueChange(self.view.bagBtn, self, self.ClickBag)
	SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.CloseButton, self)
end

function this:OpenEquipUIPanel()
	---@param equipPanel KLEquipUIPanel
	GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel",nil,nil,
			{x=-480, hideTips=true, callBack=self.CloseEquipUi,forgeGroupType=EForgeGroupType.Lucky,hideMount = true},nil,function(equipPanel)
				self.equipPanel = equipPanel
				self:Refresh()
			end)
end

function this:item_modelOnClick()
	SL:OpenTips("equip",self.equipInfo.cfgId,self.equipInfo.id,nil, self.equipInfo, {hideBtn=true})
end

function this:OnClick_Btn_Helper()
	local ruleCfg = SL:GetConfig("cfg_rule_text", 1)
	if ruleCfg then
		SL:CommonStrTipsMessage({title =ruleCfg.menutxt,str=ruleCfg.location})
	end
end

function this:liuGuangBtn()
	if self.showLiuGuang == false then
		local stream = SL:GetConfig('cfg_equip_luck', self.equipInfo.cfgId).stream
		if stream then
			local strengthLevel = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
			for _, streamInfo in pairs(stream) do
				local nowStrengthLevel = streamInfo[1]
				local streamId = streamInfo[2]
				if strengthLevel < nowStrengthLevel then
					--GUI:SetStreamAttr(self.view.item_model, streamId)
					GUI:setVisible(self.view.liuguangInfo, true)
					GUI:Text_setString(self.view.liuguangInfo, '+' .. nowStrengthLevel .. '流光效果')
					
					self.showLiuGuang = true
					break
				end
			end
		end
		GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel",
				nil, nil, { ui = self, closeCallback = self.OnEffPreviewClose })
	else
		GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
	end
end

function this:OnEffPreviewClose()
	self:SetLiuGuang(self.equipInfo)
	GUI:setVisible(self.view.liuguangInfo, false)
	self.showLiuGuang = false
end

function this:strengthMasterBtn()
	GUI:UIPanel_Open("dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel", nil, nil, { uiType = 1, cfgId = self.equipInfo.cfgId })
end

function this:equipBtn()
	if not self.isOpenBag then
		return
	end
	self.isOpenBag = false
	self:OpenEquipUIPanel()
	GUI:UIPanel_Close("dev/outui/Bag/Panel/KLLuckyBag/KLLuckyBagPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
	self.selectItem = nil
end

function this.CloseEquipUi()
	GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
	GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipLucky/KLEquipLuckyPanel")
end

function this:closeMask()
	GUI:setVisible(self.view.equip_show_tips, false)
end

-- 强化结果回调
---@param message {issuccess:boolean, strengthlv:number, itemId:number}
function this:RES_ACTIVE_EQUIP_LUCKY_RESULT(id, message)
	GUI:SetActive(self.view.strength_ok, false)
	GUI:SetActive(self.view.strength_fail, false)
	if message.issuccess then
		GUI:SetActive(self.view.strength_ok, true)
	else
		GUI:SetActive(self.view.strength_fail, true)
	end
	
	self:ClickEquip(self.equipInfo)
	if self.bagPanel then
		self.bagPanel:RefreItem()
	end
	if self.delayUpdt then
		SL:UnSchedule(self.delayUpdt)
		self.delayUpdt = nil
	end
	self.delayUpdt =  SL:ScheduleOnce(0.3,function()
		SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
		if self.equipPanel then
			self.equipPanel:UpdateAllItem()
			self.equipPanel:SetSelectIndex(self.equipIndex)
		end
	end)
	SL:onLUAEvent(LUA_EVENT_EQUIP_LUCKY_OK,message)
end

-- 点击强化按钮
function this:strengthButton()
	-- 检查道具够不够
	if not self.selectCostCfg then
		SL:TipMessage("请选择消耗道具", 1, NoticeType.NoticeMid)
		return
	end
	if SL:GetBagItemCount(self.selectCostCfg.costTag[1],false) < self.selectCostCfg.costTag[2] then
		SL:CommonItemGetPath(nil, self.selectCostCfg.costTag[1])
		return
	end
	-- 检查是否绑定道具
	local bindItem = SL:GetConfig("cfg_item", self.selectCostCfg.costTag[1]).lockItem[1] == 2
	if bindItem then
		--SL:CommonTipsMessage({
		--	cancelButtonPos = {x=182,y=39},
		--	sureButtonPos = {x=-182,y=39},
		--	showTips = SL:GetConfig("cfg_string", 40001).text,
		--	callback = function()
		--		self:ConfirmStrength()
		--	end
		--})
		--return
	end
	self:ConfirmStrength()
	-- self:STRENGTH_EQUIP_RESULT(_, {isSuccess = true})
end

function this:ConfirmStrength()
	SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ACTIVATE_EQUIP_LUCKY,{itemId=self.equipInfo.id,costType = self.costType,cfgId=self.equipInfo.cfgId})
end

-- 背包改变后
function this:LUA_EVENT_BAG_CHANGE_AFTER(_,message)
	if not message then
		return
	end
	if self.equipInfo then
		local lv = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
		if lv < canStrengthMaxLevel then
			local isMax = this.IsMaxEquip(self.equipInfo)
			if not isMax then
				self:SetEquipCostInfo(self.equipInfo.cfgId, lv)
			end
		end
	end
	if self.isOpenBag then
		return
	end
	-- 临时处理下， 等后端整合成一个消息包
	
	if self.delayUpdt then
		SL:UnSchedule(self.delayUpdt)
		self.delayUpdt = nil
	end
	self.delayUpdt = SL:ScheduleOnce(0.3,function()
		if self.equipPanel then
			self.equipPanel:UpdateAllItem()
		end
		SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
	end)
end

-- 货币变更
function this:LUA_EVENT_MONEYCHANGE(_,message)
	if self.equipInfo then
		local lv = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
		local isMax = this.IsMaxEquip(self.equipInfo)
		if not isMax then
			self:SetEquipCostInfo(self.equipInfo.cfgId, lv)
		end
	end
	if self.isOpenBag then
		return
	end
	
	if self.delayUpdt then
		SL:UnSchedule(self.delayUpdt)
		self.delayUpdt = nil
	end
	self.delayUpdt = SL:ScheduleOnce(0.3,function()
		if self.equipPanel then
			self.equipPanel:UpdateAllItem()
		end
		SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
	end)
end

-- 点击装备事件回调
function this:LUA_EVENT_EQUIP_GRID_CLICK(_, index)
	local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
	if index == E_AppearEquipType.Weapon and equip == nil then
		equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, E_AppearEquipType.TwoHandWeapon)
	end
	if equip then
		if SL:HasConfig('cfg_equip_luck', equip['cfgId']) then
			self.bagIndex = nil
			self.equipIndex = index
			self.equipPanel:SetSelectIndex(index)
			self:ClickEquip(equip)
			return
		else
			SL:TipMessage( SL:GetConfig('cfg_string',63001).text, 1, NoticeType.NoticeMid )--"该装备无法被强化",
		end
	end
end

-- 关闭按钮回调
function this:CloseButton()
	GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
	GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipLucky/KLEquipLuckyPanel")
	GUI:UIPanel_Close("dev/outui/Bag/Panel/KLLuckyBag/KLLuckyBagPanel")
	self.selectItem = nil
	self.equipPanel = nil
end

function this:Close()
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
	if self.delayUpdt then
		SL:UnSchedule(self.delayUpdt)
		self.delayUpdt = nil
	end
end

-- 选择装备
function this:SelectEquip(_index)
	if self.selectItem then
		if SL:HasConfig('cfg_equip_luck', self.selectItem.item.cfgId) then
			self.bagIndex = nil
			---@type cfg_item_column
			local part =  SL:GetConfig("cfg_item",self.selectItem.item.cfgId).subType
			self.equipIndex = part
			self.equipPanel:SetSelectIndex(part)
			self:ClickEquip(self.selectItem.item)
			return
		end
	end
	if _index then
		local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, _index)
		if equip then
			if SL:HasConfig('cfg_equip_luck', equip['cfgId']) then
				self.bagIndex = nil
				self.equipIndex = _index
				self.equipPanel:SetSelectIndex(_index)
				self:ClickEquip(equip)
				return
			end
		end
	end
	
	-- 策划要求先选中武器
	local equip_boot = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, EEquipSlotType.TwoHandWeapon)
	if equip_boot then
		if SL:HasConfig('cfg_equip_luck', equip_boot['cfgId']) then
			self.bagIndex = nil
			self.equipIndex = EEquipSlotType.TwoHandWeapon
			self.equipPanel:SetSelectIndex(EEquipSlotType.TwoHandWeapon)
			self:ClickEquip(equip_boot)
			return
		end
	end
	
	for index=1, 15 do
		local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
		if equip then
			if SL:HasConfig('cfg_equip_luck', equip['cfgId']) then
				self.bagIndex = nil
				self.equipIndex = index
				self.equipPanel:SetSelectIndex(index)
				self:ClickEquip(equip)
				return
			end
		end
	
	end
	GUI:setVisible(self.view.noticeText, true)
	GUI:setVisible(self.view.bagNoticeText, false)
end

-- 初始化UI为初始状态
function this:ResetUi()
	GUI:setVisible(self.view.maxLevelTips, false)
	GUI:setVisible(self.view.strengthIcon, false)
	GUI:setVisible(self.view.baseSuccessRatioText, false)
	GUI:setVisible(self.view.successIcon, false)
	GUI:setVisible(self.view.strengthIcon_1, false)
	GUI:setVisible(self.view.StrengthCustomScrollView, false)
	GUI:setVisible(self.view.strengthButton, false)
	GUI:setVisible(self.view.strengthLevelBg, false)
	GUI:setVisible(self.view.maxStrengthLevelBg, false)
	GUI:setVisible(self.view.item_model, false)
	GUI:setVisible(self.view.equipName, false)
	GUI:setVisible(self.view.noticeText, false)
	GUI:setVisible(self.view.liuGuangBtn, false)
	GUI:setVisible(self.view.liuguangInfo, false)
	GUI:setVisible(self.view.strengthMasterBtn, false)
	GUI:setVisible(self.view.Text_StrengthTips, false)
	GUI:setVisible(self.view.gotoButton, false)
	GUI:setVisible(self.view.bagNoticeText, false)
	self.showLiuGuang = false
end

-- 点击装备（装备栏内）
-- local testLevel = 0
function this:ClickEquip(equipInfo)
	if SL:HasConfig('cfg_equip_luck', equipInfo.cfgId) then
		self.equipInfo = equipInfo
		self:ResetUi()
		GUI:setVisible(self.view.liuGuangBtn, true)
		local strengthLevel = 1
		self.strengthLevel = strengthLevel
		self:SetEquipName(self.equipInfo.cfgId)
		self:SetEquipModel(self.equipInfo.cfgId)
		self:SetLiuGuang(self.equipInfo)
		self:SetLiuGuangBtn(self.equipInfo)
		local isMax = this.IsMaxEquip(self.equipInfo)
		GUI:setVisible(self.view.arrow, not isMax)
		GUI:setVisible(self.view.nextLevel, not isMax)
		
		
		
		
		GUI:setVisible(self.view.strengthButton, strengthLevel < canStrengthMaxLevel)
		GUI:setVisible(self.view.Text_StrengthTips, strengthLevel >= canStrengthMaxLevel)
		if strengthLevel >= canStrengthMaxLevel then
			GUI:setVisible(self.view.strengthIcon_1, false)
			GUI:setVisible(self.view.StrengthCustomScrollView, false)
			GUI:Text_setText(self.view.Text_StrengthTips, SL:GetConfig('cfg_string', 40002).text)
			
		else
			self:SetEquipCostInfo(self.equipInfo.cfgId, strengthLevel)
			
		end
		
		if isMax and strengthLevel < canStrengthMaxLevel then
			GUI:setVisible(self.view.StrengthCustomScrollView,false)
			GUI:setVisible(self.view.strengthIcon_1,false)
			GUI:setVisible(self.view.strengthButton,false)
			self:SetMaxAttrInfo(self.equipInfo.cfgId, strengthLevel)
			GUI:Text_setText(self.view.equipAttribute, "幸运属性" .. SL:GetColorText("(已激活)","#00ff00"))
			GUI:setVisible(self.view.maxLevelTips, true)
		else
			self:SetEquipAttrInfo(self.equipInfo.cfgId, strengthLevel)
			GUI:setVisible(self.view.StrengthCustomScrollView,true)
			--GUI:setVisible(self.view.strengthIcon_1,true)
			GUI:setVisible(self.view.strengthButton,true)
			GUI:Text_setText(self.view.equipAttribute, "幸运属性" .. SL:GetColorText("(未激活)","#999999"))
			self:RefreshSuccessRatio(self.equipInfo.cfgId, strengthLevel)
			
			
		end

	end
	GUI:setVisible(self.view.strengthMasterBtn, false)
end

function this:SetLiuGuangBtn(equipInfo)
	local stream = SL:GetConfig('cfg_equip_luck', equipInfo.cfgId).stream
	if stream then
		local strengthLevel = EquipFunc.GetEquipStrengthLevel(self.equipInfo)
		for _, streamInfo in pairs(stream) do
			local nowStrengthLevel = streamInfo[1]
			if strengthLevel < nowStrengthLevel then
				GUI:setVisible(self.view.liuGuangBtn, true)
				return
			end
		end
	end
	
	GUI:setVisible(self.view.liuGuangBtn, false)
end

-- 设置流光
function this:SetLiuGuang(equipInfo)
	local liuGuangId = EquipFunc.GetEquipLiuGuangId(equipInfo)
	if liuGuangId then
		--GUI:SetStreamAttr(self.view.item_model, liuGuangId)
	else
		--GUI:ResetStreamAttr(self.view.item_model)
	end
end

-- 点击背包
function this:ClickBag()
	if self.isOpenBag then
		return
	end
	self.selectItem = nil
	self.isOpenBag = true
	self.equipPanel = nil
	self:ResetUi()
	-- 清掉属性
	self.strengthAttTextList = {}
	GUI:DataListUpdateData(self.view.strength_list)
	GUI:setVisible(self.view.bagNoticeText, true)
	GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel")
	GUI:UIPanel_Open("dev/outui/Bag/Panel/KLLuckyBag/KLLuckyBagPanel", nil, nil, {x=-480, bagType = 1 , itemClickCallBack=self.itemClickCallBack,callBackUI=self},nil,function(bagPanel)
		self.bagPanel = bagPanel
	end)
end

-- 点击道具回调（背包）
function this:itemClickCallBack(control, item)
	if SL:HasConfig('cfg_equip_luck', item.cfgId) then
		local itemInfo = SL:GetItemInfoByItemId(item.id)
		self:ClickEquip(itemInfo)
		self:HideSelectItem(false)
		control.ui:SetSelect(true)
		self.selectItem = control.ui
	else
		SL:TipMessage( SL:GetConfig('cfg_string',268).text, 1, NoticeType.NoticeMid )--"该装备无法被强化",
	end
end

function this:HideSelectItem()
	if self.selectItem then
		self.selectItem:SetSelect(false)
	end
end

-- 满级属性
function this:SetMaxAttrInfo(cfgId, strengthLevel)
	strengthLevel = 1
	self.strengthAttTextList = {
		
	}
	--GUI:setVisible(self.view.strengthIcon, true)
	local groupId = SL:GetConfig('cfg_equip_luck', cfgId).groupId
	if not SL:HasConfigTwoKeys('cfg_equip_luckGroup', groupId, strengthLevel, 'group', 'lv') then
		return
	end
	local nowAttrInfo = SL:GetConfigTwoKeys('cfg_equip_luckGroup', groupId, strengthLevel, 'group', 'lv').att
	
	local now_attr_map = {}
	for _, nowAttr in pairs(nowAttrInfo) do
		now_attr_map[nowAttr[1]] = nowAttr[2]
	end
	
	
	for attrId, attrValue in pairs(now_attr_map) do
		if attrId ~= 201021 and attrId ~= 201011 and attrId ~= 202021 and attrId ~= 202011 and attrId ~= 200011 and attrId ~= 200021 then
			local name = SL:GetConfig("cfg_att_info", attrId).name
			local att_remark = SL:GetConfig("cfg_att_info", attrId).remarks
			local tbl = {}
			if att_remark == 1 then
				tbl = {
					attrName = "幸运(会心一击率)",
					preValue = "",
					nextValue = attrValue,
					arrowShow = false
				}
			else
				tbl = {
					attrName = "幸运(会心一击率)",
					preValue = "",
					nextValue = attrValue/100 .. '%',
					arrowShow = false
				}
			end
			table.insert(self.strengthAttTextList, tbl)
		end
	
	end
	
	local rate = SL:GetConfigTwoKeys("cfg_equip_luckGroup",1,1,"group","lv").luckrate[2][1]
	local tbl = {
		attrName = "幸运(灵魂宝石之成功几率)",
		preValue = "",
		nextValue = rate / 100 .. "%",
		arrowShow = false
	}
	table.insert(self.strengthAttTextList, tbl)
	GUI:DataListUpdateData(self.view.strength_list)
end


-- 消耗道具
function this:SetEquipCostInfo(cfgId, strengthLevel)
	strengthLevel = 0
	self.costList = {}
	--GUI:setVisible(self.view.strengthIcon_1, true)
	GUI:setVisible(self.view.StrengthCustomScrollView, true)
	local costId = SL:GetConfig('cfg_equip_luck', cfgId).costId
	local next_level = strengthLevel
	---@type cfg_equip_luckCost_v2_column
	local cost_cfg = SL:GetConfigTwoKeys('cfg_equip_luckCost_v2', costId, next_level, "costGroupId", "level")
	--[[if self.selectCostCfg and SL:GetBagItemCount(self.selectCostCfg.costTag[1],false) < self.selectCostCfg.costTag[2] then
		self.selectCostCfg = nil
	end]]
	local hasCostItem = false
	--for _, v in pairs(cost_info) do
	--	---@type cfg_equip_luckCost_v2_column
	--	local cost2Cfg = SL:GetConfig("cfg_equip_luckCost_v2", v)
	--	-- 找到默认第一个
	--	if (self.selectCostCfg == nil and SL:GetBagItemCount(cost2Cfg.costTag[1]) >= cost2Cfg.costTag[2]) or
	--			(self.selectCostCfg and self.selectCostCfg.costTag[1] == cost2Cfg.costTag[1]) then
	--		self.selectCostCfg = cost2Cfg
	--		hasCostItem = true
	--	end
	--	table.insert(self.costList, cost2Cfg)
	--end
	table.insert(self.costList,cost_cfg) 
	--table.insert(self.costList, cost2Cfg)
	if self.selectCostCfg == nil or not hasCostItem then
		self.selectCostCfg = cost_cfg
	end
	
	self:costSelectTog(nil, {info = self.selectCostCfg}, { true }, true)
	
	GUI:DataListUpdateData(self.view.cost_list)
end

-- 装备属性
function this:SetEquipAttrInfo(cfgId, strengthLevel)
	strengthLevel = 0
	self.strengthAttTextList = {
		
	}
	
	--GUI:setVisible(self.view.strengthIcon, true)
	local groupId = SL:GetConfig('cfg_equip_luck', cfgId).groupId
	local nowAttrInfo
	if SL:HasConfigTwoKeys('cfg_equip_luckGroup', groupId, strengthLevel, 'group', 'lv') then
		nowAttrInfo = SL:GetConfigTwoKeys('cfg_equip_luckGroup', groupId, strengthLevel, 'group', 'lv')
	end
	nowAttrInfo = nowAttrInfo and nowAttrInfo.att or {}
	
	local nextAttrInfo
	if SL:HasConfigTwoKeys('cfg_equip_luckGroup', groupId, strengthLevel+1, 'group', 'lv') then
		nextAttrInfo = SL:GetConfigTwoKeys('cfg_equip_luckGroup', groupId, strengthLevel+1, 'group', 'lv')
	end
	nextAttrInfo = nextAttrInfo and nextAttrInfo.att or {}
	
	local now_attr_map = {}
	for _, nowAttr in pairs(nowAttrInfo) do
		now_attr_map[nowAttr[1]] = nowAttr[2]
	end
	
	local next_attr_map = {}
	for _, nextAttr in pairs(nextAttrInfo) do
		next_attr_map[nextAttr[1]] = tonumber(nextAttr[2])
	end
	
	for nextId, _ in pairs(next_attr_map) do
		if now_attr_map[nextId] == nil then
			now_attr_map[nextId] = 0
		end
	end
	
	for attrId, attrValue in pairs(now_attr_map) do
		if attrId ~= 201021 and attrId ~= 201011 and attrId ~= 202021 and attrId ~= 202011 and attrId ~= 200011 and attrId ~= 200021 then
			local nextValue = next_attr_map[attrId] or 0
			local name = SL:GetConfig("cfg_att_info", attrId).name
			local att_remark = SL:GetConfig("cfg_att_info", attrId).remarks
			local tbl = {}
			if att_remark == 1 then
				tbl = {
					attrName = "幸运(会心一击率)",
					preValue = "",
					nextValue = nextValue,
					arrowShow = false
				}
				
			else
				tbl = {
					attrName = "幸运(会心一击率)",
					preValue = "",
					nextValue = nextValue/100 .. '%',
					arrowShow = false
				}
			end
			if this.IsMaxEquip(self.equipInfo) then
				tbl.preValue = ""
				tbl.arrowShow =false
			end
			table.insert(self.strengthAttTextList, tbl)
		end
	
	end
	
	local tips = SL:GetConfigTwoKeys('cfg_equip_luckGroup',  groupId, strengthLevel+ 1, 'group', 'lv').tips
	if not string.isNullOrEmpty(tips) then
		local tbl = {
			attrName = tips,
			preValue = '',
			nextValue = '',
			arrowShow = false
		}
		table.insert(self.strengthAttTextList, tbl)
	end
	
	local rate = SL:GetConfigTwoKeys("cfg_equip_luckGroup",1,1,"group","lv").luckrate[2][1]
	local tbl = {
		attrName = "幸运(灵魂宝石之成功几率)",
		preValue = "",
		nextValue = rate / 100 .. "%",
		arrowShow = false
	}
	table.insert(self.strengthAttTextList, tbl)
	
	GUI:DataListUpdateData(self.view.strength_list)

end


-- 成功率
function this:RefreshSuccessRatio(cfgId, strengthLevel)
	
	GUI:setVisible(self.view.baseSuccessRatioText, true)
	--GUI:setVisible(self.view.successIcon, true)
	if strengthLevel >= canStrengthMaxLevel then
		local costId = SL:GetConfig('cfg_equip_luck', cfgId).costId
		local next_level = strengthLevel + 1
		local rate_client = SL:GetConfigTwoKeys('cfg_equip_luckCost_v2', costId, next_level, "costGroupId", "level").rateClient
		rate_client = rate_client // 100
		GUI:Text_setString(self.view.baseSuccessRatioText, "成功率 + "..rate_client .. '%')
	end
end

-- 装备名字
function this:SetEquipName(cfgId)
	GUI:setVisible(self.view.equipName, true)
	local equipName = SL:GetConfig('cfg_item', cfgId).name
	local colorStr = EquipFunc.GetEquipNameColor(cfgId)
	GUI:Text_setString(self.view.equipName, string.format("<color=%s>%s</color>", colorStr, equipName))
end

-- 装备模型
function this:SetEquipModel(cfgId)
	--GUI:setVisible(self.view.item_model, true)
	-- GUI:Item_UpdataData(self.view.item_model, {
	-- 	itemid = cfgId,
	-- 	mscale = EquipFunc.GetEquipInScaleAtt(cfgId, nil, EquipFunc.ItemForgeShowEquipScale(cfgId)),
	-- })
	local itemTbl = SL:GetConfig("cfg_item", cfgId)
    local shape = itemTbl.shape[1]
    local model_charactor = SL:GetConfig("cfg_model_charactor", shape)
    local _pos = string.format("%d,%d,%d",model_charactor.forgeposition[1],model_charactor.forgeposition[2],model_charactor.forgeposition[3])
    local _rotate = string.format("%d,%d,%d",model_charactor.wearrotate[1],model_charactor.wearrotate[2],model_charactor.wearrotate[3])
    local data = {
        itemid = cfgId,
        mscale = EquipFunc.GetEquipInScaleAtt(cfgId, nil, EquipFunc.ItemForgeShowEquipScale(cfgId)),
        mrotate = _rotate,
        mpos = _pos,
    }
    --GUI:Item_UpdataData(self.view.item_model, data)
end

--是否是满级装备
function this.IsMaxEquip(equipInfo)
	local cfgId = equipInfo.cfgId
	local luck_tbl = SL:GetConfig('cfg_equip_luck', cfgId)
	if luck_tbl then
		return not table.isNullOrEmpty(EquipFunc.GetEquipLuckyAttr(equipInfo))
	end
	return false
end

return this

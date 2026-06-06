---@class KLItemBatchUsePanel:UIKmlLuaPanelBase
---@field view KLItemBatchUsePanelView
local KLItemBatchUsePanel = class(UIKmlLuaPanelBase)
local this =KLItemBatchUsePanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
	self.itemIndex = self.args.itemIndex
	self.itemCfgId = self.args.itemCfgId
	-- 拆分物品后获取全部数量会不能正确使用选中格子的宝箱
	-- self.maxCount = SL:GetBagItemCount(self.itemCfgId,false)
	self.maxCount = SL:GetMetaValue(EMetaVarGetKey.ITEM_COUNT,self.itemIndex)
	---@type cfg_item_column
	local itemCfg = SL:GetConfig("cfg_item", self.itemCfgId)
	self.maxOpenOneTime = itemCfg.batchUsageLimit
	self:InitInput()
	self:InitItem()
end

function this:InitInput()
	local initNum = math.min(self.maxCount,self.maxOpenOneTime)
	GUI:Text_setString(self.view.InputFieldNum,tostring(initNum))
end

function this:InitItem()
	GUI:Item_Create(self.view.Item, {
		width = "45",
		height = "45",
		itemid = self.itemCfgId,
		noclip = "1",
		mfixsize = "45,45",
		count = 0,
	})
end

---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.BtnCancel,self,self.CancelBtnClick)
	GUI:AddOnClickEvent(self.view.BtnSure,self,self.SureBtnClick)
	GUI:AddOnClickEvent(self.view.BtnCountAdd,self,self.BtnCountAddOnClick)
	GUI:AddOnClickEvent(self.view.BtnCountMinus,self,self.BtnCountMinusOnClick)
	GUI:Input_SetOnEndEdit(self.view.InputFieldNum,self,self.InputFieldNumOnEndEdit)
end

function this:InputFieldNumOnEndEdit(_,_,eventData)
	local text = eventData[1]
	GUI:Text_setString(self.view.InputFieldNum,tostring(text))
	self:CheckInput()
end

function this:CheckInput()
	local inputStr = GUI:Text_getString(self.view.InputFieldNum)
	local inputNum = tonumber(inputStr)
	if not inputNum then
		GUI:Text_setString(self.view.InputFieldNum,"1")
		return
	end

	if inputNum >= self.maxOpenOneTime then
		GUI:Text_setString(self.view.InputFieldNum,tostring(self.maxOpenOneTime))
		return
	end

	if inputNum >= self.maxCount then
		GUI:Text_setString(self.view.InputFieldNum,tostring(self.maxCount))
		return
	end

	if inputNum <= 0 then
		GUI:Text_setString(self.view.InputFieldNum,"1")
		return
	end
end


function this:BtnCountAddOnClick()
	local text = GUI:Text_getString(self.view.InputFieldNum)
	local inputNum = tonumber(text)
	if self.maxOpenOneTime <= inputNum then
		SL:TipMessage("已达到单次批量开启最大数量", 1, NoticeType.NoticeMid)
		return
	end
	if self.maxCount <= inputNum then
		return
	end
	GUI:Text_setString(self.view.InputFieldNum,tostring(inputNum + 1))
end

function this:BtnCountMinusOnClick()
	local text = GUI:Text_getString(self.view.InputFieldNum)
	local inputNum = tonumber(text)
	inputNum = inputNum - 1
	if inputNum <= 0 then
		inputNum = self.maxOpenOneTime
	end
	GUI:Text_setString(self.view.InputFieldNum,tostring(inputNum))
end

function this:Close()
end

function this:CancelBtnClick()
	GUI:UIPanel_Close("dev/ui/ItemBase/Panel/KLItemBatchUse/KLItemBatchUsePanel")
end

function this:SureBtnClick()
	local count = GUI:Text_getString(self.view.InputFieldNum)
	SL:ReqUseItemMessage(self.itemIndex,tonumber(count))
	GUI:UIPanel_Close("dev/ui/ItemBase/Panel/KLItemBatchUse/KLItemBatchUsePanel")
end

return this

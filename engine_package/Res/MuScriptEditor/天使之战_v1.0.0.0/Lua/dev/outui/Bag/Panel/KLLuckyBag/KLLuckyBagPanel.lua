---@class KLLuckyBagPanel:UIKmlLuaPanelBase
---@field view KLLuckyBagPanelView
local KLLuckyBagPanel = class(UIKmlLuaPanelBase)
local this =KLLuckyBagPanel
---创建时调用一次
function this:Init()
	self:InitData(self.args)
	local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
	self.maxHor = tonumber(bag_info[1])
	self.maxVet = tonumber(bag_info[2])
	--EquipFunc:ReplaceEquipBagButton({self.view.btn_fix,self.view.storage_btn,self.view.recycle_btn,self.view.tidy_btn})
	
	---@type KLUIBagTileScrollViewItem
	GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.root,self,
			{
				x=-10,
				y=52,
				contentW = 360,
				contentH = 547,
				-- contentScale = 1.075,
				itemList= self:GetShowItems(),
				id=E_BagTileScrollViewType.Strength,
				hor = tonumber(bag_info[1]),
				vet=tonumber(bag_info[2]),
				canDrag = false,
				contentScale = 1.32,
				itemClick = (self.args and self.args.itemClickCallBack),
				callBackUI = self.args.callBackUI },nil,function(bag)
				self.bagTileScrollView = bag
				self.bagTileScrollView:ResetPos()
				self.bagTileScrollView:RefreshInfo()
				GUI:setContentSize(self.bagTileScrollView.view.BagTileScrollViewPrefab, 360, 549)
				GUI:setPosition(self.bagTileScrollView.view.BagTileScrollViewPrefab, 51, -136.8)
				GUI:setContentSize(self.bagTileScrollView.view.prefabBagTileScrollView_, 360, 549)
			end)
end

---初始化数据
function this:InitData(data)
	self.x=(data and data.x)or 0
	self.y=(data and data.y)or 0
end


---创建或者刷新界面数据时调用
function this:Refresh()
	local x = self.x
	local y = self.y
	GUI:setPosition(self.view.root, x, y)
end

---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn )
	SL:RegisterLUAEvent(Event.BagInfo_Change, self.BagInfo_Change, self)
	
	GUI:AddOnClickEvent(self.view.btn_fix, self, self.personBtn)
	GUI:AddOnClickEvent(self.view.btn_storage, self, self.personBtn)
	GUI:AddOnClickEvent(self.view.btn_arrange, self, self.personBtn)
	GUI:AddOnClickEvent(self.view.btn_sell, self, self.personBtn)
end

function this:GetShowItems()
	local cfgName = "cfg_equip_luck"
	local showItemList = {}
	local bagItemList = SL:GetMetaValue("BAG_DATA")[1]
	for i, v in pairs(bagItemList) do
		if SL:HasConfig(cfgName, v.cfgId) then
			table.insert(showItemList, v)
		end
	end
	showItemList = SL.Bag:SortItemList(showItemList)
	return showItemList
end

function this:personBtn()
	SL:MessageTip({id=502})
end

function this:closeBtn()
	GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipLucky/KLEquipLuckyPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipAppendUI/KLEquipAppendUIPanel")
	GUI:UIPanel_Close("dev/outui/Bag/Panel/KLLuckyBag/KLLuckyBagPanel")
end

function this:Close()
end


---@param eventData {index:number,item:CommonProtos.Item}[]
function this:BagInfo_Change(eventId, eventData)
	self.bagTileScrollView:RefreshItemByItem(self:GetShowItems())
	--self.bagTileScrollView:Item_Change(eventData)
end

function this:RefreItem()
	self.bagTileScrollView:RefreshItemByItem(self:GetShowItems())
end

return this


---@class KLStrengthBagPanel:UIKmlLuaPanelBase
---@field view KLStrengthBagPanelView
local KLStrengthBagPanel = class(UIKmlLuaPanelBase)
local this =KLStrengthBagPanel
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
                itemClick = self.ItemClick,
                callBackUI = self },nil,function(bag)
                    self.bagTileScrollView = bag
                    self.bagTileScrollView:ResetPos()
                    self.bagTileScrollView:RefreshInfo()
                    GUI:setContentSize(self.bagTileScrollView.view.BagTileScrollViewPrefab, 360, 547)
                    GUI:setPosition(self.bagTileScrollView.view.BagTileScrollViewPrefab, 51, -136.8)
                    GUI:setContentSize(self.bagTileScrollView.view.prefabBagTileScrollView_, 360, 547)
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
    local showItemList
    if self.args.itemList == nil then
        local cfgName = self.args.bagType == 1 and "cfg_equip_strengthen" or "cfg_equip_appends"
        showItemList = {}
        local bagItemList = SL:GetMetaValue("BAG_DATA")[1]
        for i, v in pairs(bagItemList) do
            if SL:HasConfig(cfgName, v.cfgId) then
                table.insert(showItemList, v)
            end
        end
        showItemList = SL.Bag:SortItemList(showItemList)
    else
        showItemList = self.args.itemList
    end
    
    return showItemList
end

function this:personBtn()
    SL:MessageTip({id=502})
end

function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipStrengthUI/KLEquipStrengthUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipAppendUI/KLEquipAppendUIPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipRefine/KLEquipRefinePanel")
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
end

function this:Close()
end

function this:ItemClick(control, item)
    local needSelect = self.args.needSelect == nil and true or self.args.needSelect
    if needSelect then
        self.bagTileScrollView.selectList = { [item.id] = true}
    end
    
    if self.args and self.args.itemClickCallBack then
        self.args.itemClickCallBack(self.args.callBackUI, control, item)
    end
end

function this:RefreshBagItemShow(itemList)
    self.bagTileScrollView:RefreshItemByItem(itemList)
end

---@param eventData {index:number,item:CommonProtos.Item}[]
function this:BagInfo_Change(eventId, eventData)
    ---@type KLEquipRefinePanel
    local refinePanel=  GUI:GetUI("dev/outui/Equip/Panel/KLEquipRefine/KLEquipRefinePanel")
    if refinePanel then
        refinePanel:RefreshShowItems()
    else
        self.bagTileScrollView:RefreshItemByItem(self:GetShowItems())
    end
    
    --self.bagTileScrollView:Item_Change(eventData)
    SL:ScheduleOnce(0.3,function()
        local panel = GUI:GetUI("dev/outui/Equip/Panel/KLEquipStrengthUI/KLEquipStrengthUIPanel")
        if panel then
            if panel.selectItem then
                panel.selectItem:SetSelect(true)
                return
            end
        end
    
        panel = GUI:GetUI("dev/outui/Equip/Panel/KLEquipAppendUI/KLEquipAppendUIPanel")
        if panel then
            if panel.selectItem then
                panel.selectItem:SetSelect(true)
            end
        end
    end)

    
end

return this

---@class KLRecoverBagPanel:UIKmlLuaPanelBase
---@field view KLRecoverBagPanelView
local KLRecoverBagPanel = class(UIKmlLuaPanelBase)
local this = KLRecoverBagPanel
---创建时调用一次
function this:Init()
    self:InitData(self.args)
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    self.maxHor = tonumber(bag_info[1])
    self.maxVet = tonumber(bag_info[2])
    self.cfgNameStr = "cfg_recovery"
    -- EquipFunc:ReplaceEquipBagButton({self.view.person_shop_btn,self.view.storage_btn,self.view.recycle_btn,self.view.tidy_btn})

    if self.args and self.args.cfgNameStr then
        self.cfgNameStr = self.args.cfgNameStr
    end
    
    local x = self.x
    local y = 0
    GUI:setPosition(self.view.root, x, y)
    if not self.args or not self.args.itemList then
        self.args.itemList = SL:GetCanRecycleItemList(self.cfgNameStr)
    end
    self.itemList = {}
    table.copyFrom(self.itemList, self.args.itemList)
    local itemList = SL.Bag:SortItemList(self.itemList)

    
    GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.sv_frame, self,
            {--itemList= self:SortItemList(SL:GetCanRecycleItemList(self.cfgNameStr)) ,
                isShowEffect = true,
                --forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT"),
                id = EBagTileScrollViewId.Recover,
                hor = tonumber(bag_info[1]),
                vet = tonumber(bag_info[2]),
                canDrag = false,
                x=4,
                y=-2.44,
                contentScale = 1.32,
                itemClick = (self.args and self.args.itemClickCallBack),
                selectList = self.args and self.args.selectList, 
                callBackUI = self.args and self.args.callBackUI },true,
            function(bagTileScrollView)
                ---@type KLUIBagTileScrollViewItem
                self.bagTileScrollView = bagTileScrollView
                bagTileScrollView:ResetPos()
                GUI:setContentSize(self.bagTileScrollView.view.BagTileScrollViewPrefab, 360, 580)
                GUI:setPosition(self.bagTileScrollView.view.BagTileScrollViewPrefab, 0, 0)
                GUI:setContentSize(self.bagTileScrollView.view.prefabBagTileScrollView_, 360, 580)
                bagTileScrollView:RefreshItemByItem(itemList)
                
            end)
    
end

function this:GetBagItem(id)
    if self.bagTileScrollView then
       return  self.bagTileScrollView:GetBagItem(id)
    end
end


---初始化数据
function this:InitData(data)
    self.x = (data and data.x) or 0
    self.y = (data and data.y) or 0
    self.bagType = (data and data.bagType) or EBagShowType.Recycle
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
    self.bagType = (self.args and self.args.bagType) or EBagShowType.Recycle
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
    -- GUI:AddOnClickEvent(self.view.person_shop_btn, self, self.personBtn)
    -- GUI:AddOnClickEvent(self.view.storage_btn, self, self.personBtn)
    -- GUI:AddOnClickEvent(self.view.recycle_btn, self, self.personBtn)
    -- GUI:AddOnClickEvent(self.view.tidy_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.btn_storage, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.btn_sell, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.btn_arrange, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.btn_fix, self, self.personBtn)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.BagInfo_Change, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_UNLOCK, self.LUA_EVENT_BAG_UNLOCK, self)
    SL:RegisterLUAEvent(Event.RecoverSelectChange, self.RecoverSelectChange, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_SORT, self.LUA_EVENT_BAG_SORT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ITEM_DECOMPOSITION, self.Decompose_Change, self)

end

function this:personBtn()
    SL:MessageTip({id=502})
end

function this:LUA_EVENT_BAG_UNLOCK(_, count)
    self.bagTileScrollView:RefreshForbidGrid(count)
end

---@param data table<number,boolean>
function this:RecoverSelectChange(id, data)
    if self.bagTileScrollView then
        self.bagTileScrollView:RefreshSelect(data)
    end
end

function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel")
    GUI:UIPanel_Close("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipDecomposeUI/KLEquipDecomposeUIPanel")
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
end

function this:Close()
end

function this:UnlockGrid()
end

function this:dragEnd(eventData)
end

---@param eventData {index:number,item:CommonProtos.Item}[]
function this:BagInfo_Change(eventId, eventData)
    self.isChangeBag = true
    self.isChange = false
    ---做个筛选，不符合回收的筛选掉
    for i, v in pairs(eventData) do
        if v.item ~= nil then
            if SL:HasConfig("cfg_item", v.item.cfgId) then
                if self.bagType == EBagShowType.Recycle then
                    if SL:HasConfig(self.cfgNameStr, SL:GetConfig("cfg_item", v.item.cfgId).recoveryGroup) then
                        self.itemList[SL:MeData_GetIndexBaseOnItemId(v.item.id) - 10000] = v.item
                        self.isChange = true
                    elseif self.bagType == EBagShowType.Decompose then
                        --if SL:HasConfig(self.cfgNameStr, SL:GetConfig("cfg_item", v.item.cfgId).decomposeGroup) then
                        --    self.itemList[SL:MeData_GetIndexBaseOnItemId(v.item.id) - 10000] = v.item
                        --    self.isChange = true
                        --end
                    end
                end
            end
        end
        self:DelItem(v)
    end
    local refreshItemCallback = nil
    local refreshItemCallbackUI = nil
    if self.bagType == EBagShowType.Recycle then
        refreshItemCallback = self.args.callBackUI.RefreshSelect
        refreshItemCallbackUI = self.args.callBackUI
        --self.args.callBackUI:RefreshSelect()
    elseif self.bagType == EBagShowType.Decompose then
        refreshItemCallback = self.args.callBackUI.ShowGetItemListBySelect
        refreshItemCallbackUI = self.args.callBackUI
        --self.args.callBackUI:ShowGetItemListBySelect()
    end

    if self.isChange then
        local itemList = SL.Bag:SortItemList(self.itemList)
        self.bagTileScrollView:RefreshItemByItem(itemList,refreshItemCallback,refreshItemCallbackUI)
    end

    self.isChangeBag = false
end

function this:Decompose_Change()
    local refreshItemCallback = self.args.callBackUI.ShowGetItemListBySelect
    local refreshItemCallbackUI = self.args.callBackUI
    
    self.itemList = SL:GetPlayerDecomposeItemList()
    local itemList = SL.Bag:SortItemList(self.itemList)
    self.bagTileScrollView:RefreshItemByItem(itemList,refreshItemCallback,refreshItemCallbackUI)
end

---删除物品
---@param data {index:number,item:CommonProtos.Item}
function this:DelItem(data)
    local delItem = nil
    for z, a in pairs(self.itemList) do
        if data.index == z + 10000 then
            if data.item then
                if data.item.id ~= a.id then
                    delItem = a
                    break
                end
            else
                delItem = a
                break
            end
        end
    end
    if delItem and self.bagType == EBagShowType.Recycle then
        table.removeByKeyValue(self.itemList, delItem)
        self.isChange = true
    end
end

---@param item KLBagItemItem
function this:GetItemCanDrop(item)
    local article = SL:GetConfig('cfg_item', item.item.cfgId).article
    local cantDrop = table.contains(article, 2)
    if cantDrop then
        return false
    end

    return not item.item.bind
end

function this:LUA_EVENT_BAG_SORT(_, eventData)
    if self.isChangeBag then
        return
    end
    if self.bagType == EBagShowType.Recycle then
        self.itemList = SL:GetCanRecycleItemList(self.cfgNameStr)
    elseif self.bagType == EBagShowType.Decompose then
        self.itemList = SL:GetPlayerDecomposeItemList()
    end
    local itemList = SL.Bag:SortItemList(self.itemList)
    self.bagTileScrollView:RefreshItemByItem(itemList)
end

return this

---@class KLMountEquipRecoverPanel:UIKmlLuaPanelBase
---@field view KLMountEquipRecoverPanelView
local KLMountEquipRecoverPanel = class(UIKmlLuaPanelBase)
local this =KLMountEquipRecoverPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    ---回收所得列表
    self.getList = {}
    self.goodsItem = {}
    GUI:DataListInitData(self.view.loopscrollviewData, function()
        return self:ItemCountFunc()
    end, function(realIndex)
        return self:ItemGetFunc(realIndex)
    end, function(realIndex, kmlCtrl)
        return self:ItemInitFunc(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:ItemUpdateFunc(realIndex, kmlCtrl)
    end)
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    self.selectItemList = {}
    self.selectItemCountList = {}
    GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.sv_frame, self,
            {--itemList= self:SortItemList(SL:GetCanRecycleItemList(self.cfgNameStr)) ,
                isShowEffect = true,
                --forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT"),
                --id = EBagTileScrollViewId.Recover,
                hor = tonumber(bag_info[1]),
                vet = tonumber(bag_info[2]),
                canDrag = false,
                itemClick = self.ClickItemCallBack,
                selectList = self.selectItemList,
                callBackUI = self
            }, 
            true,
            function(bagTileScrollView)
                ---@type KLUIBagTileScrollViewItem
                self.bagTileScrollView = bagTileScrollView
                
                local items = InfoManager.mountInfo:GetBagItems()
                local itemList = {}
                for k, v in pairs(items) do
                    itemList[tonumber(k)- 10000] = v
                end
                local finalList =  SL.Bag:SortItemList(itemList)
                bagTileScrollView:RefreshItemByItem(finalList)
                GUI:setPosition(self.bagTileScrollView.view.root, -36, 91)
            end)

    SL.HideMainPanel()
end

---回收获得列表数量
function this:ItemCountFunc()
    return table.count(self.getList)
end

function this:ItemGetFunc()
    ---@type KLRecycleIncomeItemItem
    local item = GUI:UIPanel_Open("dev/ui/Recover/Item/KLRecycleIncomeItem/KLRecycleIncomeItemItem", self.view.loopscrollviewData, self, nil, true)

    self.goodsItem[item.view.root] = item
    return item.view.root
end

---回收获得数据初始化
function this:ItemInitFunc(realIndex, kmlcontrol)

end

---回收获得数据刷新
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local data = self.getList[realIndex + 1]
    ---@type KLRecycleIncomeItemItem
    local goodsItem = self.goodsItem[kmlCtrl]
    goodsItem:RefreshItem(data)
end


---点击背包item回调
---@param itemControl KLBagItemItemView
---@param itemData CommonProtos.Item
function this:ClickItemCallBack(itemControl,itemData,itemSelf)
    ---是否选中
    local isSelect = self.selectItemCountList[itemData.id] and self.selectItemCountList[itemData.id] > 0
    if isSelect then
        self.selectItemCountList[itemData.id] = 0
    else
        self.selectItemCountList[itemData.id] = 1
    end

    self:SetSelectItemState(itemControl,itemData,itemSelf,isSelect)
end

---设置选中的背包item图片状态
---@param itemControl KLBagItemItemView
---@param itemData CommonProtos.Item
function this:SetSelectItemState(itemControl,itemData,itemSelf,isSelect)
    itemSelf:SetSelectEffect(not isSelect,true)
    self.selectItemList[itemData.id] = not isSelect

    self:ShowGetItemListBySelect()
end

---根据背包内勾选刷新收益材料和所需材料
function this:ShowGetItemListBySelect(isUpdateCoin)
    self.SelectItemIndexList={}
    
    local endGetMaterialList = {}
    ---@type number[]
    --local typeList=SL:GetPlayerAutoDecomposeType()
    ---@param v CommonProtos.Item
    for i, v in pairs( InfoManager.mountInfo:GetBagItems()) do
        if self.selectItemList[v.id] then
            ---@type cfg_recovery_Mount_column
            local recycleCfg=SL:GetConfig("cfg_recovery_Mount", v.cfgId)
            local selectCount = 1
            for z, a in ipairs(recycleCfg.material) do
                if not endGetMaterialList[a[1]] then
                    endGetMaterialList[a[1]] = 0
                end
                endGetMaterialList[a[1]] = endGetMaterialList[a[1]] + a[2] * selectCount
            end

            table.insert(self.SelectItemIndexList,InfoManager.mountInfo:GetBagIndex(v.id))
        end
    end
    table.clear(self.getList)
    for k, v in pairs(endGetMaterialList) do
        table.insert(self.getList, {cfgId = k, count = v})
    end
    GUI:DataListUpdateData(self.view.loopscrollviewData, true)
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.BtnRecover, self, self.RecoverOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_MOUNT_BAG_CHANGE, self.LUA_EVENT_MOUNT_BAG_CHANGE, self)
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
    SL.ShowMainPanel()
end

function this:RecoverOnClick()
    if table.count(self.SelectItemIndexList) > 0 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECYCLE_EQUIPS_MOUNT, {idxs = self.SelectItemIndexList})
    end
end

function this:LUA_EVENT_MOUNT_BAG_CHANGE()
    table.clear(self.selectItemCountList)
    table.clear(self.selectItemList)
    table.clear(self.SelectItemIndexList)
    table.clear(self.getList)
    GUI:DataListUpdateData(self.view.loopscrollviewData, true)
    
    local items = InfoManager.mountInfo:GetBagItems()
    local itemList = {}
    for k, v in pairs(items) do
        itemList[tonumber(k)- 10000] = v
    end
    local finalList =  SL.Bag:SortItemList(itemList)
    self.bagTileScrollView:RefreshItemByItem(finalList)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Hide()
end

function this:Close()
end

return this

---@class KLUIChatBagScrollViewItem:UIKmlLuaPanelBase
---@field view KLUIChatBagScrollViewItemView
---@field itemList CommonProtos.Item[]
---@field indexToItem table<number,KLBagItemItem>
local KLUIChatBagScrollViewItem = class(UIKmlLuaPanelBase)
local this = KLUIChatBagScrollViewItem
this.idToIns = {}
---创建时调用一次
function this:Init()
    if not self.args then
        self.args = {}
    end
    self.hor = self.args.hor or 25
    self.vet = self.args.vet or 8
    self.itemList = self.args.itemList or {}
    self.page = self.args.page or 1
    self.forbidCount = self.args.forbidCount or 0
    self.id = self.args.id or EBagTileScrollViewId.Bag
    self.forbidClickCallback = self.args.forbidClickCallback
    self.dragEndCallback = self.args.dragEndCallback
    self.parent = self.args.parent
    self.itemClick=self.args.itemClick
    self.indexToItem = {}
    self.indexToForbidGrid = {}
    self.indexForbidList = {}
    self.selectList=self.args.selectList or  {}
    if this.idToIns[self.id] == nil then
        this.idToIns[self.id] = self
    end

end

---创建或者刷新界面数据时调用
function this:Refresh()

    local x = self.args.x or 0
    local y = self.args.y or 0
    GUI:setPosition(self.view.root, x, y)
    
    local height = self.hor*32
    local width = self.vet*32
    
    GUI:Image_setType(self.view.BagTileContent, EImageType.Tiled)
    GUI:setContentSize(self.view.BagTileScrollViewPrefab,370, 173)
    GUI:setPosition(self.view.BagTileScrollViewPrefab,2, 0)

    GUI:setContentSize(self.view.prefabBagTileScrollView_,370, 173)
    GUI:setContentSize(self.view.BagTileContent,width, height)
     GUI:setScaleX(self.view.BagTileContent, self.args.contentScale or 1.347)
     GUI:setScaleY(self.view.BagTileContent, self.args.contentScale or 1.347)
    self:RefreshItem()
    self:RefreshForbidGrid(self.forbidCount)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
    for id, ins in pairs(this.idToIns) do
        if ins == self then
            this.idToIns[id] = nil
        end
    end
    
end

function this:RefreshItem()
    local canDrag=true
    if self.args and self.args.canDrag~=nil then
        canDrag=self.args.canDrag
    end
    --local item = GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem",self.view.BagTileContent,self,{x=0, y=0},true)
    for index, item in pairs(self.itemList) do
        
        --local hor,vet = BagInfo.GetHorAndVetWithInt(index)
        local hor,vet = SL.Bag:GetHorAndVetWithInt(index)
		GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem",self.view.BagTileContent,self,
                {BagTileScrollViewId=self.id,item=item, x=(vet-1)*32, y=(hor-1)*-32, z=-100, canDrag=canDrag, beginDrag=self.beginDrag, 
                 onDrag=self.onDrag, endDrag=self.endDrag, ins=self, index=index,click=self.itemClick,isSelect=self.selectList[item.id],callBackUI=self.args.callBackUI},true
        , function(bagItem)
                    self.indexToItem[index] = bagItem
                    bagItem:Updatenoclip(0)
                    bagItem:SetItemPutonChatPanel(item)
        end)

    end
end

function this:RefreshItemByItem(itemList)
    self.itemList = itemList
    self:RefreshItem()
end

function this:RefreshInfo()
    for index, klBagItem in pairs(self.indexToItem) do
        klBagItem:RefreshInfo()
    end
end

function this:onDrag(eventData, systemData)
    -- 如果没在拖拽装备图素，则移动滑动条
    if eventData.dragItem == false then
        self:MoveScrollView(Time.deltaTime * 80 * systemData.delta.y)
        return
    end
    
    -- 如果拖到了滑动条上下方区域 滑动条自动上下
    self:JudgeMoveScrollView(systemData)
    
    -- 判断占位情况
    self:JudgeMoveUseGrid(eventData, systemData)
end

local redGridList
local storageRedGridList
local blueGridList
local storageBlueGridList
function this:JudgeMoveUseGrid(eventData, systemData)

    redGridList={}
    blueGridList={}
    storageRedGridList={}
    storageBlueGridList={}
    ---@type KLBagItemItem
    local dragItem = eventData.temp
    
    local bagTileScrollView = this.idToIns[EBagTileScrollViewId.Bag]
    if bagTileScrollView then
        local bool, pos = GUI:ScreenPointToLocalPointInRectangle(bagTileScrollView.view.BagTileContent, systemData["position"])
        local vet = pos.x // 32 + 1
        local hor = -pos.y // 32 + 1
        local holdGrid = SL:GetConfig('cfg_item',dragItem.item.cfgId).holdGrid
        local holdHor = holdGrid[1]
        local holdVet = holdGrid[2]
        local startVet = vet - (holdHor-1)//2
        local startHor = hor - (holdVet-1)//2
        local maxHor, maxVet = SL:GetMetaValue(EMetaVarGetKey.GET_BAG_MAX_HOR_VERT)
        local useGridTable = SL:GetMetaValue(EMetaVarGetKey.GET_BAG_USE_GRID_TABLE)
        local useTable = useGridTable[1]
        local index = dragItem.index
        local itemHor,itemVet = SL.Bag:GetHorAndVetWithInt(index)--BagInfo.GetHorAndVetWithInt(index)
        
        -- 在背包里
        if hor>0 and vet>0 and hor<=maxHor and vet<=maxVet then
            
            -- 边界情况
            if startHor<=0 or startHor+holdVet-1>maxHor or startVet<=0 or startVet+holdHor-1>maxVet then
                for nowHor=startHor, startHor+holdVet-1 do
                    for nowVet=startVet, startVet+holdHor-1 do
                        table.insert(redGridList, BagInfo.GetIntWithHorAndVet(nowHor,nowVet))
                    end
                end
            -- 通常情况
            else
                for nowHor=startHor, startHor+holdVet-1 do
                    for nowVet=startVet, startVet+holdHor-1 do
                        if useTable[BagInfo.GetIntWithHorAndVet(nowHor,nowVet)] == true then
                            
                            -- 还要排除下移动到拖拽的几个格子是红色的情况
                            if nowHor<itemHor or nowHor>itemHor+holdVet-1 or nowVet<itemVet or nowVet >itemVet+holdHor-1 then
                                table.insert(redGridList, BagInfo.GetIntWithHorAndVet(nowHor,nowVet))
                            else
                                table.insert(blueGridList, BagInfo.GetIntWithHorAndVet(nowHor,nowVet))
                            end
                        else
                            table.insert(blueGridList, BagInfo.GetIntWithHorAndVet(nowHor,nowVet))
                        end
                    end
                    
                end
            end
            
        end
        
        GUI:DataListInitData(bagTileScrollView.view.red_grid_,function()
            return table.count(redGridList)
        end,function()
            
        end,function(realIndex)
        end,function(realIndex)
            local root = GUI:GetChildControl(bagTileScrollView.view.red_grid_,realIndex,'red_grid_item')
            local index = redGridList[realIndex+1]
            --local rootRectTrans = GUI:GetRectTransform(root)
            --rootRectTrans.anchoredPosition = Vector2((index%100-1)*32, -(index//100-1)*32)
            --rootRectTrans:SetAsLastSibling()
            GUI:SetAnchoredPosition(root,Vector2((index%100-1)*32, -(index//100-1)*32))
            GUI:SetAsLastSibling(root)
        end)
        GUI:DataListUpdateData(bagTileScrollView.view.red_grid_)

        GUI:DataListInitData(bagTileScrollView.view.green_grid_,function()
            return table.count(blueGridList)
        end,function()

        end,function(realIndex)
        end,function(realIndex)
            local root = GUI:GetChildControl(bagTileScrollView.view.green_grid_,realIndex,'green_grid_item')
            local index = blueGridList[realIndex+1]
            --local rootRectTrans = GUI:GetRectTransform(root)
            --rootRectTrans.anchoredPosition = Vector2((index%100-1)*32, -(index//100-1)*32)
            --rootRectTrans:SetAsLastSibling()
            GUI:SetAnchoredPosition(root,Vector2((index%100-1)*32, -(index//100-1)*32))
            GUI:SetAsLastSibling(root)
        end)

        GUI:DataListUpdateData(bagTileScrollView.view.green_grid_)
    end

    local storageTileScrollView = this.idToIns[EBagTileScrollViewId.Storage]
    if storageTileScrollView then
        local bool, pos = GUI:ScreenPointToLocalPointInRectangle(storageTileScrollView.view.BagTileContent, systemData["position"])
        local vet = pos.x // 32 + 1
        local hor = -pos.y // 32 + 1
        local holdGrid = SL:GetConfig('cfg_item',dragItem.item.cfgId).holdGrid
        local holdHor = holdGrid[1]
        local holdVet = holdGrid[2]
        local startVet = vet - (holdHor-1)//2
        local startHor = hor - (holdVet-1)//2
        local maxHor, maxVet = SL:GetMetaValue(EMetaVarGetKey.GET_STORE_HOUSE_MAX_HV)
        local panel = GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
        local useGridTable = SL:GetMetaValue(EMetaVarGetKey.GET_STORE_HOUSE_USE_GRID_TABLE)
        local useTable = useGridTable[panel.CurPage]
        if useTable == nil then
            useTable = {}
        end
        local index = dragItem.index
        local itemHor,itemVet =SL.Bag:GetHorAndVetWithInt(index) --BagInfo.GetHorAndVetWithInt(index)

        -- 在仓库里
        if hor>0 and vet>0 and hor<=maxHor and vet<=maxVet then

            -- 边界情况
            if startHor<=0 or startHor+holdVet-1>maxHor or startVet<=0 or startVet+holdHor-1>maxVet then
                for nowHor=startHor, startHor+holdVet-1 do
                    for nowVet=startVet, startVet+holdHor-1 do
                        table.insert(storageRedGridList, BagInfo.GetIntWithHorAndVet(nowHor,nowVet))
                    end
                end
                -- 通常情况
            else
                for nowHor=startHor, startHor+holdVet-1 do
                    for nowVet=startVet, startVet+holdHor-1 do
                        if useTable[BagInfo.GetIntWithHorAndVet(nowHor,nowVet)] == true then

                            -- 还要排除下移动到拖拽的几个格子是红色的情况
                            if nowHor<itemHor or nowHor>itemHor+holdVet-1 or nowVet<itemVet or nowVet >itemVet+holdHor-1 then
                                table.insert(storageRedGridList, BagInfo.GetIntWithHorAndVet(nowHor,nowVet))
                            else
                                table.insert(storageBlueGridList, BagInfo.GetIntWithHorAndVet(nowHor,nowVet))
                            end
                        else
                            table.insert(storageBlueGridList, BagInfo.GetIntWithHorAndVet(nowHor,nowVet))
                        end
                    end

                end
            end

        end

        GUI:DataListInitData(storageTileScrollView.view.red_grid_,function()
            return table.count(storageRedGridList)
        end,function()

        end,function(realIndex)
        end,function(realIndex)
            local root = GUI:GetChildControl(storageTileScrollView.view.red_grid_,realIndex,'red_grid_item')
            local index = storageRedGridList[realIndex+1]
            --local rootRectTrans = GUI:GetRectTransform(root)
            --rootRectTrans.anchoredPosition = Vector2((index%100-1)*32, -(index//100-1)*32)
            --rootRectTrans:SetAsLastSibling()
            GUI:SetAnchoredPosition(root,Vector2((index%100-1)*32, -(index//100-1)*32))
            GUI:SetAsLastSibling(root)
        end)
        GUI:DataListUpdateData(storageTileScrollView.view.red_grid_)

        GUI:DataListInitData(storageTileScrollView.view.green_grid_,function()
            return table.count(storageBlueGridList)
        end,function()

        end,function(realIndex)
        end,function(realIndex)
            local root = GUI:GetChildControl(storageTileScrollView.view.green_grid_,realIndex,'green_grid_item')
            local index = storageBlueGridList[realIndex+1]
            --local rootRectTrans = GUI:GetRectTransform(root)
            --rootRectTrans.anchoredPosition = Vector2((index%100-1)*32, -(index//100-1)*32)
            --rootRectTrans:SetAsLastSibling()
            GUI:SetAnchoredPosition(root,Vector2((index%100-1)*32, -(index//100-1)*32))
            GUI:SetAsLastSibling(root)
        end)

        GUI:DataListUpdateData(storageTileScrollView.view.green_grid_)
    end
end

this.InsToCo = {}
function this:JudgeMoveScrollView(systemData)
    for _, bagTileIns in pairs(this.idToIns) do
        local rectTransform = GUI:GetRectTransform(bagTileIns.view.prefabBagTileScrollView_)
        local width = rectTransform.rect.width
        local height = rectTransform.rect.height
        local bool, pos = GUI:ScreenPointToLocalPointInRectangle(bagTileIns.view.prefabBagTileScrollView_,
                systemData["position"])
        if pos.x > 0 and pos.x < width then
            if pos.y > -32 then
                if this.InsToCo[bagTileIns] == nil then
                    this.InsToCo[bagTileIns] = Coroutine.Start(
                            function()
                                while(true) do
                                    Coroutine.WaitForEndOfFrame()
                                    bagTileIns:MoveScrollView(Time.deltaTime * -150)
                                end
                            end
                    )
                end
            elseif pos.y < -height+32 then
                if this.InsToCo[bagTileIns] == nil then
                    this.InsToCo[bagTileIns] = Coroutine.Start(
                            function()
                                while(true) do
                                    Coroutine.WaitForEndOfFrame()
                                    bagTileIns:MoveScrollView(Time.deltaTime * 150)
                                end
                            end
                    )
                end
            else
                if this.InsToCo[bagTileIns] ~= nil then
                    Coroutine.Stop(this.InsToCo[bagTileIns])
                    this.InsToCo[bagTileIns] = nil
                end
            end
        else
            if this.InsToCo[bagTileIns] ~= nil then
                Coroutine.Stop(this.InsToCo[bagTileIns])
                this.InsToCo[bagTileIns] = nil
            end
        end
    end
end

function this:MoveScrollView(moveDelta)
    local position = GUI:GetRectTransform(self.view.BagTileContent).anchoredPosition
    position.y = position.y + moveDelta
    GUI:GetRectTransform(self.view.BagTileContent).anchoredPosition = position
end

function this:beginDrag()
    
end

function this:endDrag(eventData, systemData)
    if self.dragEndCallback then
        
        local mousePosition = systemData["position"]
        ---@type KLBagItemItem
        local dragItem = eventData.dragItem

        local panel = GUI:GetUI("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
        if panel then
            local bool, pos = GUI:ScreenPointToLocalPointInRectangle(panel.bagTileScrollView.view.BagTileContent, mousePosition)
            local vet = pos.x // 32 + 1
            local hor = -pos.y // 32 + 1
            local holdGrid = SL:GetConfig('cfg_item',dragItem.item.cfgId).holdGrid
            local holdHor = holdGrid[1]
            local holdVet = holdGrid[2]
            vet = vet - (holdHor-1)//2
            hor = hor - (holdVet-1)//2
            
            local storageScrollView = this.idToIns[EBagTileScrollViewId.Storage]
            local storageVet, storageHor
            if storageScrollView then
                bool, pos = GUI:ScreenPointToLocalPointInRectangle(storageScrollView.view.BagTileContent, mousePosition)
                storageVet = pos.x // 32 + 1
                storageHor = -pos.y // 32 + 1
                holdGrid = SL:GetConfig('cfg_item',dragItem.item.cfgId).holdGrid
                holdHor = holdGrid[1]
                holdVet = holdGrid[2]
                storageVet = storageVet - (holdHor-1)//2
                storageHor = storageHor - (holdVet-1)//2
            end
            
            self.dragEndCallback(self.parent, {dragItem=dragItem, bagPutHor=hor, bagPutVet=vet, storageHor=storageHor, storageVet=storageVet, index=eventData.index,raycastObj=eventData.raycastObj})
        end
    end

    for _, co in pairs(this.InsToCo) do
        Coroutine.Stop(co)
        this.InsToCo[_] = nil
    end
    
    local bagTileScrollView = this.idToIns[EBagTileScrollViewId.Bag]
    if bagTileScrollView then
        redGridList = {}
        blueGridList = {}
        GUI:DataListUpdateData(bagTileScrollView.view.red_grid_)
        GUI:DataListUpdateData(bagTileScrollView.view.green_grid_)
    end
    local storageTileScrollView = this.idToIns[EBagTileScrollViewId.Storage]
    if storageTileScrollView then
        storageRedGridList = {}
        storageBlueGridList = {}
        GUI:DataListUpdateData(storageTileScrollView.view.red_grid_)
        GUI:DataListUpdateData(storageTileScrollView.view.green_grid_)
    end


end

---刷新选中
---@param data table<number,boolean>
function this:RefreshSelect(data)
    for k,v in pairs(self.indexToItem) do
        GUI:setVisible(v.view.selectImg,data[v.item.id])
    end
end

function this:RefreshForbidGrid(count)

    self.indexForbidList = {}
    self.forbidCount = count
    local remainCount = count
    for nowHor=self.hor,1,-1 do
        for nowVet = self.vet, 1, -1 do

            if remainCount == 0 then
                break
            end

            remainCount = remainCount - 1
            table.insert(self.indexForbidList, nowHor*100+nowVet)
        end
    end
    
    GUI:DataListInitData(self.view.forbid_list_,function()
        return table.count(self.indexForbidList)
    end,function()
        
    end,
    function()  end,
    function(realIndex)
        local index = self.indexForbidList[realIndex+1]
        local hor = index//100
        local vet = index%100
        local forbid_prefab = GUI:GetChildControl(self.view.forbid_list_,realIndex,'forbid_item')
        GUI:setPosition(forbid_prefab, (vet-1)*32,(hor-1)*-32)
        GUI:SetOnPrefabControlLoaded(forbid_prefab, function()
            local forbid_btn = GUI:GetChildControl(self.view.forbid_list_,realIndex,'UIBagForbidButton')
            if self.forbidClickCallback then
                GUI:AddOnClickEvent(forbid_btn, self.parent, self.forbidClickCallback,{index=index})
            end
        end)
        

    end)
    
    GUI:DataListUpdateData(self.view.forbid_list_)
end

function this:Item_Change(eventData)
    local ksItemList={}
    for _, itemInfo in pairs(eventData) do
        local index = itemInfo.index%10000
        local item = itemInfo.item
        if item == nil then
            local bagItem = self.indexToItem[index]
            GUI:UIPanel_Close(nil, bagItem)
            self.indexToItem[index] = nil
        else
            if self.indexToItem[index] then
                local bagItem = self.indexToItem[index]
                bagItem:SetItem(itemInfo.item)
            else
                local canDrag=true
                if self.args and self.args.canDrag~=nil then
                    canDrag=self.args.canDrag
                end
                local hor,vet = SL.Bag:GetHorAndVetWithInt(index)--BagInfo.GetHorAndVetWithInt(index)
                local bagItem = GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem",self.view.BagTileContent,self,{item=item, x=(vet-1)*32, y=(hor-1)*-32, z=-100, canDrag= canDrag,
                                                                                                                             beginDrag=self.beginDrag, onDrag=self.onDrag, endDrag=self.endDrag, ins=self, index=index,click=self.itemClick,callBackUI=self.args.callBackUI},true)
                self.indexToItem[index] = bagItem
                table.insert(ksItemList, bagItem)
            end

        end
    end
    return ksItemList

end

return this

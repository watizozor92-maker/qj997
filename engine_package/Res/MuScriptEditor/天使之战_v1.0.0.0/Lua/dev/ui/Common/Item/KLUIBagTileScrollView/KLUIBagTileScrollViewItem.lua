---@class KLUIBagTileScrollViewItem:UIKmlLuaPanelBase
---@field view KLUIBagTileScrollViewItemView
---@field itemList table<number,CommonProtos.Item>
---@field indexToItem table<number,KLBagItemItem>
local KLUIBagTileScrollViewItem = class(UIKmlLuaPanelBase)
local this = KLUIBagTileScrollViewItem
this.idToIns = {}
---创建时调用一次
function KLUIBagTileScrollViewItem:Init()
    if not self.args then
        self.args = {}
    end
    self.hor = self.args.hor or 25
    self.vet = self.args.vet or 8
    self.itemList = self.args.itemList or {}
    self.page = self.args.page or 1
    if self.args.forbidCount and self.args.forbidCount > 0 then
        self.forbidCount = self.args.forbidCount
    else
        self.forbidCount = 0
    end
    self.id = self.args.id or EBagTileScrollViewId.Bag
    self.forbidClickCallback = self.args.forbidClickCallback
    self.dragEndCallback = self.args.dragEndCallback
    self.parent = self.args.parent
    self.itemClick = self.args.itemClick
    self.indexToItem = {}
    self.indexTempToItem = {}
    self.indexToForbidGrid = {}
    self.indexForbidList = {}
    self.selectList = self.args.selectList or {}
    self.filterTagList = self.args.filterTagList or {}
    ---是否显示选中特效（外置）
    self.isShowEffect = self.args.isShowEffect or false

    if self.args.JumpSelectId then
        self.jumpCfgId = self.args.JumpSelectId
    end

    if this.idToIns[self.id] == nil then
        this.idToIns[self.id] = self
    end

    self.bagLoadItemSpeed = 0.1 --背包打开加载Item的速度
    self.bagItemIntervalTime = 0.15 --背包每加载3个Item的停顿时间
end

---创建或者刷新界面数据时调用
function KLUIBagTileScrollViewItem:Refresh()

    local x = self.args.x or 0
    local y = self.args.y or 0
    GUI:setPosition(self.view.root, x, y)

    local height = self.hor * 32
    local width = self.vet * 32
    local contentW = self.args.contentW or 342
    local contentH = self.args.contentH or 258
    GUI:Image_setType(self.view.BagTileContent, EImageType.Tiled)
    GUI:setContentSize(self.view.BagTileScrollViewPrefab, contentW, contentH)
    GUI:setPosition(self.view.BagTileScrollViewPrefab, 18, -324.5)

    GUI:setContentSize(self.view.prefabBagTileScrollView_, contentW, contentH)
    GUI:setVisible(self.view.prefabBagTileScrollView_,true)
    GUI:setContentSize(self.view.BagTileContent, width, height)
    GUI:setScaleX(self.view.BagTileContent, self.args.contentScale or 1.347)
    GUI:setScaleY(self.view.BagTileContent, self.args.contentScale or 1.347)
    self.contentScale = self.args.contentScale or 1.347
    self:RefreshItem()
    self:RefreshForbidGrid(self.forbidCount)
end

---注册UI事件和服务器消息
function KLUIBagTileScrollViewItem:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_TIPS_PANEL_CLOSE, self.LUA_EVENT_TIPS_PANEL_CLOSE, self)
end

function KLUIBagTileScrollViewItem:LUA_EVENT_TIPS_PANEL_CLOSE()
    self:NoSelectItem()
end

function KLUIBagTileScrollViewItem:Close()
    for id, ins in pairs(this.idToIns) do
        if ins == self then
            this.idToIns[id] = nil
        end
    end
    
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end


function KLUIBagTileScrollViewItem:RefreshItem(callBack, callBackUI)
    local canDrag = true
    if self.args and self.args.canDrag ~= nil then
        canDrag = self.args.canDrag
    end

    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end

    local count = 0
    local indexTable = {}
    for i, v in pairs(self.itemList) do
        table.insert(indexTable, i)
    end
    table.sort(indexTable,function(a, b) 
       return a < b
    end)
    
    local function processNextItem()
        if count >= #indexTable then
            if callBack then
                if callBackUI then
                    callBack(callBackUI)
                else
                    callBack()
                end
            end
            if self.jumpCfgId then
                self:SelectItem(self.jumpCfgId)
            end
            return
        end

        count = count + 1
        local index = indexTable[count]
        local item = self.itemList[index]
        local hor, vet = this.GetHorAndVetWithInt(index)
        local itemArgs = {
            BagTileScrollViewId = self.id,
            item = item,
            x = (vet - 1) * 32,
            y = (hor - 1) * -32,
            z = -100,
            canDrag = canDrag,
            beginDrag = self.beginDrag,
            onDrag = self.onDrag,
            endDrag = self.endDrag,
            ins = self,
            index = index,
            click = self.itemClick,
            isSelect = self.selectList[item.id],
            callBackUI = self.args.callBackUI,
            isShowEffect = self.args.isShowEffect,
            isFilterTag = self.filterTagList[item.id],
            contentScale = self.contentScale
        }
        local intervalTimer = 0
        if count % 3 == 0 then
            intervalTimer = Time.deltaTime * self.bagItemIntervalTime
        end
        if self.indexToItem[index] then
            self.indexToItem[index].args = itemArgs
            self.indexToItem[index]:Refresh()
            self.timer = SL:ScheduleOnce(intervalTimer, processNextItem)
            GUI:SetZIndex(self.indexToItem[index].view.equipInfo,203)
        else
            ---@param bagItem KLBagItemItem
            local tempItem =  GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.BagTileContent, self, itemArgs, true,
                    function(bagItem)
                        GUI:SetOnPrefabControlLoaded(bagItem.view.bag_item_, function()
                            self.indexToItem[index] = bagItem
                            self.timer = SL:ScheduleOnce(Time.deltaTime * self.bagLoadItemSpeed, processNextItem)
                        end)
                        GUI:SetZIndex(bagItem.view.equipInfo,203)
                        if self.filterTagList[item.id] then
                            bagItem:RefreshFilterTagList(true)
                        else
                            bagItem:RefreshFilterTagList(false)
                        end
                        if self.args.itemOpenCallback then
                            self.args.itemOpenCallback(self.args.callBackUI, bagItem)
                        end
                    end)
            self.indexTempToItem[index] = tempItem
        end
    end

    processNextItem()
end

-- 刷新道具列表
function this:RefreshItemByItem(itemList, refreshItemCallback, refreshItemCallbackUI)
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    self.itemList = itemList
    if not self.indexToItem then
        self.indexToItem = {}
    end
    
    for index, klBagItem in pairs(self.indexToItem) do
        if not itemList[index] then
            GUI:UIPanel_Close(nil, klBagItem)
            self.indexToItem[index] = nil
            self.indexTempToItem[index] = nil
        end
    end
    
    --把上次正在加载中的格子关闭
    ---@param klBagItem KLBagItemItem
    for index, klBagItem in pairs(self.indexTempToItem) do
        if GUI:IsUILoading(klBagItem) then
            GUI:UIPanel_Close(nil, klBagItem)
            self.indexTempToItem[index] = nil
            self.indexToItem[index] = nil
        end
    end
    self.indexTempToItem = {}

    return self:RefreshItem(refreshItemCallback, refreshItemCallbackUI)
end

-- 刷新道具信息
function this:RefreshInfo()
    for index, klBagItem in pairs(self.indexToItem) do
        klBagItem:RefreshInfo()
    end
end

--根据number获取物品所在的行和列
function this.GetHorAndVetWithInt(number)
    return number // 100, number % 100
end

-- 道具拖拽中
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
local blueGridList
local storageRedGridList
local storageBlueGridList
local synthesisSmelterRedGridList
local synthesisSmelterBlueGridList
function this:JudgeMoveUseGrid(eventData, systemData)

    redGridList = {}
    blueGridList = {}
    storageRedGridList = {}
    storageBlueGridList = {}
    synthesisSmelterRedGridList = {}
    synthesisSmelterBlueGridList = {}
    ---@type KLBagItemItem
    local dragItem = eventData.temp

    local bagTileScrollView = this.idToIns[EBagTileScrollViewId.Bag]
    if bagTileScrollView then
        -- SL:LogError("JudgeMoveUseGrid", bagTileScrollView.id)
        local bool, pos = GUI:ScreenPointToLocalPointInRectangle(bagTileScrollView.view.BagTileContent, systemData["position"])
        local vet = pos.x // 32 + 1
        local hor = -pos.y // 32 + 1
        local holdGrid = SL:GetConfig('cfg_item', dragItem.item.cfgId).holdGrid
        local holdHor = holdGrid[1]
        local holdVet = holdGrid[2]
        local startVet = vet - (holdHor - 1) // 2
        local startHor = hor - (holdVet - 1) // 2
        local maxHor, maxVet = SL:GetMetaValue(EMetaVarGetKey.GET_BAG_MAX_HOR_VERT)
        local useGridTable = SL:GetMetaValue(EMetaVarGetKey.GET_BAG_USE_GRID_TABLE)
        local useTable = useGridTable[1]
        local index = dragItem.index
        local itemHor, itemVet = this.GetHorAndVetWithInt(index)
        -- 在背包里
        if hor > 0 and vet > 0 and hor <= maxHor and vet <= maxVet and self.id ~= EBagTileScrollViewId_Out.Synthesis then
            
            -- 边界情况
            if startHor <= 0 or startHor + holdVet - 1 > maxHor or startVet <= 0 or startVet + holdHor - 1 > maxVet then
                for nowHor = startHor, startHor + holdVet - 1 do
                    for nowVet = startVet, startVet + holdHor - 1 do
                        table.insert(redGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                    end
                end
                -- 通常情况
            else
                for nowHor = startHor, startHor + holdVet - 1 do
                    for nowVet = startVet, startVet + holdHor - 1 do
                        if useTable[this.GetIntWithHorAndVet(nowHor, nowVet)] == true then

                            -- 还要排除下移动到拖拽的几个格子是红色的情况
                            if nowHor < itemHor or nowHor > itemHor + holdVet - 1 or nowVet < itemVet or nowVet > itemVet + holdHor - 1 then
                                table.insert(redGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                            else
                                table.insert(blueGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                            end
                        else
                            table.insert(blueGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                        end
                    end

                end
            end

        end

        GUI:DataListInitData(bagTileScrollView.view.red_grid_, function()
            return table.count(redGridList)
        end, function()

        end, function(realIndex)
        end, function(realIndex)
            local root = GUI:GetChildControl(bagTileScrollView.view.red_grid_, realIndex, 'red_grid_item')
            local index = redGridList[realIndex + 1]
            local rootRectTransform = GUI:GetRectTransform(root)
            rootRectTransform.anchoredPosition = Vector2((index % 100 - 1) * 32, -(index // 100 - 1) * 32)
            rootRectTransform:SetAsLastSibling()
        end)
        GUI:DataListUpdateData(bagTileScrollView.view.red_grid_)

        GUI:DataListInitData(bagTileScrollView.view.green_grid_, function()
            return table.count(blueGridList)
        end, function()

        end, function(realIndex)
        end, function(realIndex)
            local root = GUI:GetChildControl(bagTileScrollView.view.green_grid_, realIndex, 'green_grid_item')
            local index = blueGridList[realIndex + 1]
            local rootRectTransform = GUI:GetRectTransform(root)
            rootRectTransform.anchoredPosition = Vector2((index % 100 - 1) * 32, -(index // 100 - 1) * 32)
            rootRectTransform:SetAsLastSibling()
        end)

        GUI:DataListUpdateData(bagTileScrollView.view.green_grid_)
    end

    local storageTileScrollView = this.idToIns[EBagTileScrollViewId.Storage]
    if storageTileScrollView then
        local bool, pos = GUI:ScreenPointToLocalPointInRectangle(storageTileScrollView.view.BagTileContent, systemData["position"])
        local vet = pos.x // 32 + 1
        local hor = -pos.y // 32 + 1
        local holdGrid = SL:GetConfig('cfg_item', dragItem.item.cfgId).holdGrid
        local holdHor = holdGrid[1]
        local holdVet = holdGrid[2]
        local startVet = vet - (holdHor - 1) // 2
        local startHor = hor - (holdVet - 1) // 2
        local maxHor, maxVet = SL:GetMetaValue(EMetaVarGetKey.GET_STORE_HOUSE_MAX_HV)
        local useTable
        ---@type KLDepotsPanel
        local panel = GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
        local useGridTable = SL:GetMetaValue(EMetaVarGetKey.GET_STORE_HOUSE_USE_GRID_TABLE)
        if panel.bagType == "privilege" then
            useTable = useGridTable[panel.CurPage + panel.maxDepotsPages]
        else
            useTable = useGridTable[panel.CurPage]
        end
        if useTable == nil then
            useTable = {}
        end
        local index = dragItem.index
        local itemHor, itemVet = this.GetHorAndVetWithInt(index)

        -- 在仓库里
        if hor > 0 and vet > 0 and hor <= maxHor and vet <= maxVet then

            -- 边界情况
            if startHor <= 0 or startHor + holdVet - 1 > maxHor or startVet <= 0 or startVet + holdHor - 1 > maxVet then
                for nowHor = startHor, startHor + holdVet - 1 do
                    for nowVet = startVet, startVet + holdHor - 1 do
                        table.insert(storageRedGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                    end
                end
                -- 通常情况
            else
                for nowHor = startHor, startHor + holdVet - 1 do
                    for nowVet = startVet, startVet + holdHor - 1 do
                        if useTable[this.GetIntWithHorAndVet(nowHor, nowVet)] == true then
                            -- 还要排除下移动到拖拽的几个格子是红色的情况
                            if nowHor < itemHor or nowHor > itemHor + holdVet - 1 or nowVet < itemVet or nowVet > itemVet + holdHor - 1 then
                                table.insert(storageRedGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                            else
                                table.insert(storageBlueGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                            end
                        else
                            table.insert(storageBlueGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                        end
                    end

                end
            end

        end

        GUI:DataListInitData(storageTileScrollView.view.red_grid_, function()
            return table.count(storageRedGridList)
        end, function()

        end, function(realIndex)
        end, function(realIndex)
            local root = GUI:GetChildControl(storageTileScrollView.view.red_grid_, realIndex, 'red_grid_item')
            local index = storageRedGridList[realIndex + 1]
            local rootRectTransform = GUI:GetRectTransform(root)
            rootRectTransform.anchoredPosition = Vector2((index % 100 - 1) * 32, -(index // 100 - 1) * 32)
            rootRectTransform:SetAsLastSibling()
        end)
        GUI:DataListUpdateData(storageTileScrollView.view.red_grid_)

        GUI:DataListInitData(storageTileScrollView.view.green_grid_, function()
            return table.count(storageBlueGridList)
        end, function()

        end, function(realIndex)
        end, function(realIndex)
            local root = GUI:GetChildControl(storageTileScrollView.view.green_grid_, realIndex, 'green_grid_item')
            local index = storageBlueGridList[realIndex + 1]
            local rootRectTransform = GUI:GetRectTransform(root)
            rootRectTransform.anchoredPosition = Vector2((index % 100 - 1) * 32, -(index // 100 - 1) * 32)
            rootRectTransform:SetAsLastSibling()
        end)

        GUI:DataListUpdateData(storageTileScrollView.view.green_grid_)
    end
    
    local synthesisSmelterTileScrollView = this.idToIns[EBagTileScrollViewId_Out.Synthesis]
    if synthesisSmelterTileScrollView then
        local bool, pos = GUI:ScreenPointToLocalPointInRectangle(synthesisSmelterTileScrollView.view.BagTileContent, systemData["position"])
        local vet = pos.x // 32 + 1
        local hor = -pos.y // 32 + 1
        local holdGrid = SL:GetConfig('cfg_item', dragItem.item.cfgId).holdGrid
        local holdHor = holdGrid[1]
        local holdVet = holdGrid[2]
        local startVet = vet - (holdHor - 1) // 2
        local startHor = hor - (holdVet - 1) // 2
        local maxHor = ESynthesisBagSize.H
        local maxVet = ESynthesisBagSize.V
        local useTable
        ---@type KLNewSynthesisPanel
        local panel = GUI:GetUI("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel")
        if panel then
            useTable = panel:GetSmelterGridItems()
        end
        if not panel then
            maxHor = ESynthesisBagSize.H
            maxVet = ESynthesisBagSize.V
            panel = GUI:GetUI("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel")
            if panel then
                useTable = panel:GetSmelterGridItems()
            end
        end

        if useTable == nil then
            useTable = {}
        end
        local index = dragItem.index
        local itemHor, itemVet = this.GetHorAndVetWithInt(index)
        -- 在合成炉里
        if hor > 0 and vet > 0 and hor <= maxHor and vet <= maxVet then
            -- 边界情况
            if startHor <= 0 or startHor + holdVet - 1 > maxHor or startVet <= 0 or startVet + holdHor - 1 > maxVet then
                for nowHor = startHor, startHor + holdVet - 1 do
                    for nowVet = startVet, startVet + holdHor - 1 do
                        table.insert(synthesisSmelterRedGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                    end
                end
                -- 通常情况
            else
                for nowHor = startHor, startHor + holdVet - 1 do
                    for nowVet = startVet, startVet + holdHor - 1 do
                        if useTable[this.GetIntWithHorAndVet(nowHor, nowVet)] == true then
                            if self.id == EBagTileScrollViewId_Out.Synthesis then
                                -- 还要排除下移动到拖拽的几个格子是红色的情况
                                if nowHor < itemHor or nowHor > itemHor + holdVet - 1 or nowVet < itemVet or nowVet > itemVet + holdHor - 1 then
                                    table.insert(synthesisSmelterRedGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                                else
                                    table.insert(synthesisSmelterBlueGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                                end
                            else
                                table.insert(synthesisSmelterRedGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                            end
                        else
                            table.insert(synthesisSmelterBlueGridList, this.GetIntWithHorAndVet(nowHor, nowVet))
                        end
                    end

                end
            end

        end

        GUI:DataListInitData(synthesisSmelterTileScrollView.view.red_grid_, function()
            return table.count(synthesisSmelterRedGridList)
        end, function()

        end, function(realIndex)
        end, function(realIndex)
            local root = GUI:GetChildControl(synthesisSmelterTileScrollView.view.red_grid_, realIndex, 'red_grid_item')
            local index = synthesisSmelterRedGridList[realIndex + 1]
            local rootRectTransform = GUI:GetRectTransform(root)
            rootRectTransform.anchoredPosition = Vector2((index % 100 - 1) * 32, -(index // 100 - 1) * 32)
            rootRectTransform:SetAsLastSibling()
        end)
        GUI:DataListUpdateData(synthesisSmelterTileScrollView.view.red_grid_)

        GUI:DataListInitData(synthesisSmelterTileScrollView.view.green_grid_, function()
            return table.count(synthesisSmelterBlueGridList)
        end, function()

        end, function(realIndex)
        end, function(realIndex)
            local root = GUI:GetChildControl(synthesisSmelterTileScrollView.view.green_grid_, realIndex, 'green_grid_item')
            local index = synthesisSmelterBlueGridList[realIndex + 1]
            local rootRectTransform = GUI:GetRectTransform(root)
            rootRectTransform.anchoredPosition = Vector2((index % 100 - 1) * 32, -(index // 100 - 1) * 32)
            rootRectTransform:SetAsLastSibling()
        end)

        GUI:DataListUpdateData(synthesisSmelterTileScrollView.view.green_grid_)
    end
end

--根据行列获取number
-- hor=5, vet=4 返回504
-- hor=14, vet=3 返回1403
---@public
function this.GetIntWithHorAndVet(hor, vet)
    return hor * 100 + vet
end

this.InsToCo = {}
function this:JudgeMoveScrollView(systemData)
    for _, bagTileIns in pairs(this.idToIns) do
        local rectTransform = GUI:GetRectTransform(bagTileIns.view.prefabBagTileScrollView_)
        local width = rectTransform.rect.width
        local height = rectTransform.rect.height
        local bool, pos = GUI:ScreenPointToLocalPointInRectangle(bagTileIns.view.prefabBagTileScrollView_, systemData["position"])
        if pos.x > 0 and pos.x < width then
            if pos.y > -32 then
                if this.InsToCo[bagTileIns] == nil then
                    this.InsToCo[bagTileIns] = Coroutine.Start(
                            function()
                                while (true) do
                                    Coroutine.WaitForEndOfFrame()
                                    bagTileIns:MoveScrollView(Time.deltaTime * -150)
                                end
                            end
                    )
                end
            elseif pos.y < -height + 32 then
                if this.InsToCo[bagTileIns] == nil then
                    this.InsToCo[bagTileIns] = Coroutine.Start(
                            function()
                                while (true) do
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
        local canPut = false
        local panel = GUI:GetUI("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
        if panel then
            local bool, pos = GUI:ScreenPointToLocalPointInRectangle(panel.bagTileScrollView.view.BagTileContent, mousePosition)
            local vet = pos.x // 32 + 1
            local hor = -pos.y // 32 + 1
            local holdGrid = SL:GetConfig('cfg_item', dragItem.item.cfgId).holdGrid
            local holdHor = holdGrid[1]
            local holdVet = holdGrid[2]
            vet = vet - (holdHor - 1) // 2
            hor = hor - (holdVet - 1) // 2

            local storageScrollView = this.idToIns[EBagTileScrollViewId.Storage]
            local storageVet, storageHor
            if storageScrollView then
                bool, pos = GUI:ScreenPointToLocalPointInRectangle(storageScrollView.view.BagTileContent, mousePosition)
                storageVet = pos.x // 32 + 1
                storageHor = -pos.y // 32 + 1
                holdGrid = SL:GetConfig('cfg_item', dragItem.item.cfgId).holdGrid
                holdHor = holdGrid[1]
                holdVet = holdGrid[2]
                storageVet = storageVet - (holdHor - 1) // 2
                storageHor = storageHor - (holdVet - 1) // 2
                canPut = #storageRedGridList == 0
            end
            
            local synthesisSmelterScrollView = this.idToIns[EBagTileScrollViewId_Out.Synthesis]
            local synthesisSmelterVet, synthesisSmelterHor
            if synthesisSmelterScrollView then
                bool, pos = GUI:ScreenPointToLocalPointInRectangle(synthesisSmelterScrollView.view.BagTileContent, mousePosition)
                synthesisSmelterVet = pos.x // 32 + 1
                synthesisSmelterHor = -pos.y // 32 + 1
                holdGrid = SL:GetConfig('cfg_item', dragItem.item.cfgId).holdGrid
                holdHor = holdGrid[1]
                holdVet = holdGrid[2]
                synthesisSmelterVet = synthesisSmelterVet - (holdHor - 1) // 2
                synthesisSmelterHor = synthesisSmelterHor - (holdVet - 1) // 2
                canPut = #synthesisSmelterRedGridList == 0
            end
            local no_move = false
            if panel.slotRectToGrid then
                for k, v in pairs(panel.slotRectToGrid) do
                    if eventData.raycastObj == v and panel.slotToGrid[k] and panel.slotToGrid[k].item and panel.slotToGrid[k].item.id then
                        no_move = true
                        EquipFunc.DragBagToEquipIForge(panel.slotToGrid[k].item.id,dragItem.item,0)
                    end
                end
            end
            
            for k, v in pairs(self.indexToItem) do
                local obj = GUI:GetGameObject(v.view.empty)
                if eventData.raycastObj == obj and v.item and v.item.id then
                    no_move = true
                    EquipFunc.DragBagToEquipIForge(v.item.id,dragItem.item,1)
                end
            end
            self.dragEndCallback(self.parent, { dragItem = dragItem, bagPutHor = hor, bagPutVet = vet, 
                                                storageHor = storageHor, storageVet = storageVet,
                                                synthesisSmelterHor = synthesisSmelterHor, synthesisSmelterVet = synthesisSmelterVet, 
                                                index = eventData.index, raycastObj = eventData.raycastObj, canPut = canPut,
                                                mousePosition = mousePosition ,noMove=no_move})
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

    local synthesisSmelterTileScrollView = this.idToIns[EBagTileScrollViewId_Out.Synthesis]
    if synthesisSmelterTileScrollView then
        synthesisSmelterRedGridList = {}
        synthesisSmelterBlueGridList = {}
        GUI:DataListUpdateData(synthesisSmelterTileScrollView.view.red_grid_)
        GUI:DataListUpdateData(synthesisSmelterTileScrollView.view.green_grid_)
    end
end



function this:RefreshGrid()
    local bagTileScrollView = this.idToIns[EBagTileScrollViewId.Bag]
    if bagTileScrollView then
        redGridList = {}
        blueGridList = {}
        GUI:DataListUpdateData(bagTileScrollView.view.red_grid_)
        GUI:DataListUpdateData(bagTileScrollView.view.green_grid_)
    end
end

---刷新选中
---@param data table<number,boolean>
function this:RefreshSelect(data)
    for _, v in pairs(self.indexToItem) do
        if self.isShowEffect then
            v:SetSelectEffect(data[v.item.id], true)
        else
            GUI:setVisible(v.view.selectImg, data[v.item.id])
            GUI:setVisible(v.view.selectTagImg, data[v.item.id])
        end
    end
end

-- 选中cfgId的物体
function this:SelectItem(cfgId)
    self.jumpCfgId = cfgId
    for _, v in pairs(self.indexToItem) do
        if cfgId == v.item.cfgId then
            local index = v.index
            local hor = index // 100
            GUI:setPosition(self.view.BagTileContent, 0, (hor - 1) * 32)
            GUI:setVisible(v.view.selectImg, true)
            SL:OpenTips("bag", cfgId, v.item.id)
            return

        end
    end

end

---取消选中cfgId的物体
function this:NoSelectItem()
    if self.jumpCfgId then
        for _, v in pairs(self.indexToItem) do
            if self.jumpCfgId == v.item.cfgId then
                GUI:setVisible(v.view.selectImg, false)
                return

            end
        end
    end
end

-- 刷新禁用格子 
function this:RefreshForbidGrid(count)
    self.indexForbidList = {}
    self.forbidCount = count
    local remainCount = count
    for nowHor = self.hor, 1, -1 do
        for nowVet = self.vet, 1, -1 do

            if remainCount == 0 then
                break
            end

            remainCount = remainCount - 1
            table.insert(self.indexForbidList, nowHor * 100 + nowVet)
        end
    end

    GUI:DataListInitData(self.view.forbid_list_, function()
        return table.count(self.indexForbidList)
    end, function()

    end,
            function()
            end,
            function(realIndex)
                local index = self.indexForbidList[realIndex + 1]
                local hor = index // 100
                local vet = index % 100
                local forbid_prefab = GUI:GetChildControl(self.view.forbid_list_, realIndex, 'forbid_item')
                GUI:setPosition(forbid_prefab, (vet - 1) * 32, (hor - 1) * -32)
                GUI:SetOnPrefabControlLoaded(forbid_prefab, function()
                    if self.forbidClickCallback then
                        local forbid_btn = GUI:GetChildById(forbid_prefab, 'UIBagForbidButton')
                        GUI:AddOnClickEvent(forbid_btn, self.parent, self.forbidClickCallback, { index = index })
                    end
                end)
            end)

    GUI:DataListUpdateData(self.view.forbid_list_)
end

function this:RefreshRedGrid(count)

    self.indexRedList = {}
    --self.redCount = count + self.forbidCount
    local index = 0
    local remainCount = count + self.forbidCount
    for nowHor = self.hor, 1, -1 do
        for nowVet = self.vet, 1, -1 do
            index = index + 1
            if remainCount == 0 then
                break
            end
            remainCount = remainCount - 1
            if index > self.forbidCount then
                table.insert(self.indexRedList, nowHor * 100 + nowVet)
            end
        end
    end

    GUI:DataListInitData(self.view.red_list_, function()
        return table.count(self.indexRedList)
    end, function()

    end,
            function()
            end,
            function(realIndex)
                local hor, vet = this.GetHorAndVetWithInt(self.indexRedList[realIndex + 1])
                local red_prefab = GUI:GetChildControl(self.view.red_list_, realIndex, 'red_item')
                GUI:setPosition(red_prefab, (vet - 1) * 32, (hor - 1) * -32)
            end)

    GUI:DataListUpdateData(self.view.red_list_)
end

---@return KLBagItemItem
function this:GetBagItem(id)
    if self.indexToItem then
        for _, v in pairs(self.indexToItem) do
            if v.item.id == id then
                return v
            end
        end
    end
    return nil
end

---@return KLBagItemItem[]
function this:Item_Change(eventData)
    local ksItemList = {}
    local addItemList = eventData
    for i, itemInfo in pairs(eventData) do
        if itemInfo.item == nil then
            local index = itemInfo.index % 10000
            local bagItem = self.indexToItem[index]
            if bagItem then
                GUI:UIPanel_Close(nil, bagItem)
            else
                bagItem = self.indexTempToItem[index]
                GUI:UIPanel_Close(nil, bagItem)
            end
            self.indexToItem[index] = nil
            self.indexTempToItem[index] = nil
            addItemList[i] = nil
        end
    end
    for _, itemInfo in pairs(addItemList) do
        local index = itemInfo.index % 10000
        local item = itemInfo.item
        if self.indexToItem[index] then
            local bagItem = self.indexToItem[index]
            bagItem:SetItem(itemInfo.item)
            GUI:SetZIndex(bagItem.view.equipInfo,203)
        else
            local canDrag = true
            if self.args and self.args.canDrag ~= nil then
                canDrag = self.args.canDrag
            end
            local hor, vet = this.GetHorAndVetWithInt(index)
            ---@param bagItem KLBagItemItem
            local tempItem = GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.BagTileContent, self,
                    {
                        BagTileScrollViewId = self.id,
                        item = item,
                      x = (vet - 1) * 32,
                      y = (hor - 1) * -32,
                      z = -100,
                      canDrag = canDrag,
                      beginDrag = self.beginDrag,
                      onDrag = self.onDrag,
                      endDrag = self.endDrag,
                      ins = self,
                      index = index,
                      click = self.itemClick,
                      callBackUI = self.args.callBackUI,
                      isShowEffect = self.args.isShowEffect,
                     contentScale = self.contentScale,
                    }, true, function(bagItem)
                        GUI:SetOnPrefabControlLoaded(bagItem.view.bag_item_, function()
                            self.indexToItem[index] = bagItem
                            table.insert(ksItemList, bagItem)
                        end)
                        GUI:SetZIndex(bagItem.view.equipInfo,203)
                        if self.args.itemOpenCallback then
                            self.args.itemOpenCallback(self.args.callBackUI, bagItem)
                        end
                    end)
            self.indexTempToItem[index] = tempItem
        end
    end
    return ksItemList
end

---item 的状态改变
function this:ItemState_Change(eventData)
    for i, itemInfo in pairs(eventData) do
        local index = itemInfo.index % 10000
        local bagItem = self.indexToItem[index]
        bagItem:SetInteractionState(itemInfo.interaction)
    end
end

---刷新指定格子的道具
function this:RefreshItemCountByIndex(index)
    if self.indexToItem[index] then
        self.indexToItem[index]:RefreshCount()
    end
end

function this:ResetPos()
    GUI:setPosition(self.view.BagTileContent, 0, 0)
    for _, co in pairs(this.InsToCo) do
        Coroutine.Stop(co)
        this.InsToCo[_] = nil
    end
end

function this:RefreshFilterTagList(filterTagList)
    -- SL:LogError("RefreshFilterTagList3", SL:JsonEncode(filterTagList))
    self.filterTagList = filterTagList
    for _, v in pairs(self.indexToItem) do
        if self.filterTagList[v.item.id] then
            v:RefreshFilterTagList(true)
        else
            v:RefreshFilterTagList(false)
        end
    end
end

return KLUIBagTileScrollViewItem

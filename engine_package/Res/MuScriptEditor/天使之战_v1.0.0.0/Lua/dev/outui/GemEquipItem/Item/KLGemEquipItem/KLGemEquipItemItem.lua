---@class KLGemEquipItemItem:UIKmlLuaPanelBase
---@field view KLGemEquipItemItemView
local KLGemEquipItemItem = class(UIKmlLuaPanelBase)
local this =KLGemEquipItemItem

-- 当前鼠标的状态
this.EClickState = {
    None = enum(0),
    Down = enum(), --鼠标按下
    DragScrollView = enum(), -- 鼠标拖拽滑动条
    ReallyToDrag = enum(), -- 鼠标拖拽滑动条
    StartDragItem = enum(), -- 鼠标拖拽道具
    DragItemButForbid = enum(), -- 鼠标拖拽道具， 但道具是不让拖拽的
    ShowTips = enum(), -- 展示tips
}

---创建时调用一次
function KLGemEquipItemItem:Init()
    self.equipAttItems = {}
    self.isEquipGrid = self.args.isEquipGrid
    self.BagTileScrollViewId = self.args.BagTileScrollViewId---仓库或者背包
    self.item = self.args.item
    self.x = self.args.x or 0
    self.y = self.args.y or 0
    self.z = self.args.z or 0

    self.mouseState = this.EClickState.None
    self.clickTime = 0
    self.canDrag = self.args.canDrag ~= nil and self.args.canDrag or false
    self.originPos = nil
    self.beginDragCallback = self.args.beginDrag
    self.ins = self.args.ins
    self.onDragCallback = self.args.onDrag
    self.endDragCallback = self.args.endDrag
    self.index = self.args.index
    self.click = self.args.click
    self.callBackUI = self.args.callBackUI
    self.showItemTips = true
    if self.isEquipGrid and self.args.default then
        ---@type EEquipGridDefaultData
        local data = self.args.default
        GUI:setVisible(self.view.holdImg_, false)
        GUI:setVisible(self.view.bg, true)
        GUI:Image_loadTexture(self.view.bg, data.bg, "Atlas/UIBagPanel.spriteatlas")
        self:SetGridSizeDelta(data.width, data.height)
        GUI:setPosition(self.view.quality_, data.qualityX, data.qualityY)
        GUI:setPositionX(self.view.strengthLevel_, data.strengthX)
        GUI:setPositionX(self.view.appendLevel_, data.strengthX)
        self:SetSelectUi(data.selectX, data.selectY, data.selectWidth or data.width, data.selectHeight or data.height)
    elseif self.args.type == "common" then
        self.showItemTips = self.args.showTips
        local data = self.args.default
        GUI:setVisible(self.view.holdImg_, false)
        GUI:setVisible(self.view.bg, false)
        self:SetGridSizeDelta(data.width, data.height)
        self:SetItemMfixSize(data.mfixSizeX, data.mfixSizeY)
        if data.qualityX then
            GUI:setPosition(self.view.quality_, data.qualityX, data.qualityY)
        end
        if data.strengthX then
            GUI:setPositionX(self.view.strengthLevel_, data.strengthX)
            GUI:setPositionX(self.view.appendLevel_, data.strengthX)
        end
    else
        GUI:setVisible(self.view.bg, false)
        GUI:setVisible(self.view.holdImg_, true)
        GUI:setPosition(self.view.quality_, 0, 0)
        if self.item then
            local horSize, vetSize = BagInfo.GetBagSizeByCfgId(self.item.cfgId)
            self:SetGridSizeDelta(horSize * BagInfo.oneTileWidth, vetSize * BagInfo.oneTileWidth)
        end
    end
    GUI:setVisible(self.view.selectImg, self.args.isSelect)
    GUI:setPosition(self.view.bag_item_, self.x, self.y, self.z)
    GUI:UIPanel_Open("dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem",
            self.view.quality_, self, {},true,function(qualityItem)
                self.qualityItem = qualityItem
            end)
end

function this:SetSelectUi(x, y, width, height)
    GUI:setPosition(self.view.selectImg, x, y)
    GUI:setContentSize(self.view.selectImg, width, height)
end


---创建或者刷新界面数据时调用 
function KLGemEquipItemItem:Refresh()
    self.item = self.args.item
    self:RefreshGemShow()

    if  self.item and self.item.cfgId == EMonthType.MonthCardTime then---月卡时间特殊显示
        GUI:Text_setString(self.view.TimeText, GUIUtil.FormatTimeD((InfoManager.monthCardInfo.MonthCardTimeTotal-SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))//1000))
        GUI:setVisible(self.view.tipsIcon_, false)
    else
        GUI:Text_setString(self.view.TimeText, "")
    end
    
    if not self.isEquipGrid and self.item and self.args.type ~= "common" then
        local horSize, vetSize = BagInfo.GetBagSizeByCfgId(self.item.cfgId)
        self:SetGridSizeDelta(horSize * BagInfo.oneTileWidth, vetSize * BagInfo.oneTileWidth)
        self:RefreshInfo()
    end

    if self.isEquipGrid then
        GUI:setVisible(self.view.tipsIcon_, false)
        GUI:setVisible(self.view.arrow_, false)
    end

    self:SetItemData(self.item)
end

---@param item CommonProtos.Item
function this:SetItem(item)
    if not self.args then
        self.args = {}
    end
    self.args.item = item
    self:Refresh()
end

---@param item CommonProtos.Item
function KLGemEquipItemItem:SetItemData(item)
    --默认显示写在这里
    GUI:setVisible(self.view.quality_, false)
    GUI:setVisible(self.view.strengthLevel_, false)
    GUI:setVisible(self.view.appendLevel_, false)
    GUI:setVisible(self.view.item_model_, false)
    GUI:setVisible(self.view.puton, false)
    if item == nil then
        return
    end
    GUI:setVisible(self.view.item_model_, true)
    --交易行需求展示货币，货币数量过多，转换一下
    local count = item.count
    if item.count >= 10000 then
        count = 0
        GUI:setVisible(self.view.item_count_unit,true)
        GUI:Text_setString(self.view.item_count_unit,tostring(SL:GetSimpleNumber(item.count,0)))
    else
        GUI:setVisible(self.view.item_count_unit,false)
    end
    --显示模型
    GUI:Item_UpdataData(self.view.item_model_, {
        ["itemid"] = item.cfgId,
        ["uniqueid"] = item.id,
        ["itemcount"] =count,
    })
    --装备品阶及卓越词条数量
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", item.cfgId)
    local entryCount = 0
    local pos = itemCfg.strPart[1]
    if pos and pos >= EEquipSlotType.Weapon and pos <= EEquipSlotType.Boot then
        local entryAttr = SL:GetEquipEntrys(item)
        entryCount = table.count(entryAttr)
    end
    GUI:setVisible(self.view.quality_, true)
    if item.cfgId ~= EMonthType.MonthCardTime then---月卡时间不在背包里出现的
        self.qualityItem:SetData(item.cfgId, entryCount)
    end
    self:SetItemOutDataInfo(item)
    self:SetItemPuton(item)
end

--显示item的强化追加等属性，外置功能
---@param item CommonProtos.Item
function this:SetItemOutDataInfo(item)
    self:SetLiuGuang(item)

    local data = self.args.default or {}
    if data.strengthX then
        GUI:setPositionX(self.view.strengthLevel_, data.strengthX)
        GUI:setPositionX(self.view.appendLevel_, data.strengthX)
    else
        GUI:setPositionX(self.view.strengthLevel_, 5)
        GUI:setPositionX(self.view.appendLevel_, 5)
    end
    
    --强化等级
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(item)
    GUI:setVisible(self.view.strengthLevel_, true)
    GUI:Text_setString(self.view.strengthLevel_, strengthLevel ~= 0 and ("+" .. strengthLevel) or "")
    --追加等级
    local appendLv = EquipFunc.GetEquipAppendLevel(item)
    GUI:setVisible(self.view.appendLevel_, true)
    GUI:Text_setString(self.view.appendLevel_, appendLv ~= 0 and ("+" .. appendLv) or "")
end

--显示是否已经装备，外置功能装备叠加所需
---@param item CommonProtos.Item
function this:SetItemPuton(item)
    if not self.isEquipGrid and self.args.BagTileScrollViewId == EBagShowType.EquipAdd then
        local putonTab = SL:GetTotalWearEquips()[1]
        if not putonTab then
            return
        end
        for _, v in pairs(putonTab) do
            if v.id == item.id then
                GUI:setVisible(self.view.puton, true)
                return
            end
        end
    end
end

function this:SetGridSizeDelta(x, y)
    GUI:setContentSize(self.view.bag_item_, x, y)
    GUI:setContentSize(self.view.holdImg_, x, y)
    GUI:setContentSize(self.view.empty, x, y)
    GUI:setContentSize(self.view.bg, x, y)
    GUI:setContentSize(self.view.selectImg, x, y)
    GUI:setContentSize(self.view.equipInfo, x, y)
    GUI:Item_UpdataData(self.view.item_model_, {
        ["width"] = x,
        ["height"] = y,
    })
end

function this:SetItemMfixSize(x, y)
    if x and y then
        GUI:Item_UpdataData(self.view.item_model_, { mfixsize = x .. "," .. y })
    end
end

---注册UI事件和服务器消息
function KLGemEquipItemItem:RegistEvents()
    GUI:AddOnTouchEvent(self.view.empty, self, function(ui, control, eventType, systemData)
        if eventType == EUIEventName.OnPointerDown then
            if systemData.button ~= InputButton.Left then
                return
            end

            self.clickTime = Misc.GetTimeStamp()
            self.mouseState = this.EClickState.Down

            Coroutine.Start(self.StartDrag, self)
        end

        if eventType == EUIEventName.OnPointerUp then
            if systemData.button ~= InputButton.Left then
                return
            end

            -- 拖拽滑动条或者拖拽物品， 则不触发逻辑
            if self.mouseState == this.EClickState.DragScrollView or self.mouseState == this.EClickState.StartDragItem then
                return
            end

            if self.mouseState == this.EClickState.ReallyToDrag then
                GUI:setAnchorPoint(self.view.empty, 1, 1)
                GUI:Item_Rotate(self.view.item_model_, "")
                ---- 结束拖拽时显示占位底图
                GUI:setVisible(self.view.holdImg_, true)
                GUI:setScale(self.view.item_model_, 1)
                GUI:setVisible(self.view.equipInfo, true)
                return
            end

            self.mouseState = this.EClickState.ShowTips
            ---有外部传入的点击事件，调用外部的
            if self.click then
                self.click(self.callBackUI, self.view, self.item)
                return
            end
            self:OpenItemTips()

        end

        if eventType == EUIEventName.OnBeginDrag then
            self:BeginDrag(control, systemData)
        end

        if eventType == EUIEventName.OnDrag then
            self:OnDrag(control, systemData)
        end

        if eventType == EUIEventName.OnEndDrag then

            -- 如果物品不允许拖拽或者不是拖拽物品， 也就没有后续的逻辑，直接返回即可
            -- 后续逻辑和拖拽道具结束逻辑相关， 根据位置把道具放到对应的位置上
            if self.canDrag == false or self.mouseState ~= this.EClickState.StartDragItem then
                return
            end

            --local raycastObj = callbackData[1]["pointerCurrentRaycast"].gameObject

            --if self.willEndDragCallBack then
            --    self.willEndDragCallBack(self.cls, { raycastObj = raycastObj, temp = self })
            --end
            --
            GUI:Item_Rotate(self.view.item_model_, "")
            GUI:setAnchorPoint(self.view.empty, 1, 1)
            GUI:SetParent(self.view.empty, self.parentTrans)
            control.rectTransform.anchoredPosition = self.originPos

            SL.AudioMgr.PlaySound(EAudioPlayByCfgType.Item, self.item.cfgId, ESoundFieldType.DownSound)

            if self.endDragCallback then
                self.endDragCallback(self.ins, { raycastObj = systemData["pointerCurrentRaycast"].gameObject, dragItem = self, index = self.index }, systemData)
            end
            --
            ---- 结束拖拽时显示占位底图
            GUI:setVisible(self.view.holdImg_, true)
            GUI:Button_setBright(self.view.empty, true)
            GUI:setScale(self.view.item_model_, 1)
            GUI:setVisible(self.view.equipInfo, true)

            self.mouseState = this.EClickState.None

        end
    end)
    SL:RegisterLUAEvent(LUA_EVENT_STRENGTH_OK, self.LUA_EVENT_STRENGTH_OK, self)
    SL:RegisterLUAEvent(LUA_EVENT_APPEND_OK, self.LUA_EVENT_STRENGTH_OK, self)
    SL:RegisterLUAEvent(LUA_EVENT_TRANSFER_SUCCESS, self.LUA_EVENT_TRANSFER_SUCCESS, self)
    SL:RegisterLUAEvent(LUA_EVENT_REFRESH_GEM_SLATE_INFO, self.RefreshGemShow, self)
end

function this:LUA_EVENT_STRENGTH_OK(id, data)
    if self.item and self.item.id == data.itemId then
        local item
        if self.isEquipGrid then
            item = SL:GetWearEquipByItemId(data.itemId)
        else
            item = SL:GetItemInfoByItemId(data.itemId)
        end
        self.item = item
        self:SetItemOutDataInfo(item)
    end
end

function this:LUA_EVENT_TRANSFER_SUCCESS(_, eventData)
    if eventData and eventData.refresh then
        if self.item then
            if self.item.id == eventData.oldItem or self.item.id == eventData.newItem then
                self:LUA_EVENT_STRENGTH_OK(nil, { itemId = self.item.id })
            end
        end
    end
end

function this:BeginDrag(control, systemData)
    -- 不能拖拽则不执行下面开始拖拽相关的逻辑
    if not self.canDrag then
        return
    end

    if self.mouseState == this.EClickState.ReallyToDrag then
        self.mouseState = this.EClickState.StartDragItem
        GUI:setAnchorPoint(self.view.empty, 0, 0)
        self.originPos = control.rectTransform.anchoredPosition
        self.parentTrans = self.view.empty.rectTransform.parent
        self.beginDragCallback(self.ins, {}, systemData)
        SL.AudioMgr.PlaySound(EAudioPlayByCfgType.Item, self.item.cfgId, ESoundFieldType.HoldSound)
        local panel = GUI:GetUI("dev/ui/Common/Panel/KLTop/KLTopPanel")
        GUI:SetParent(self.view.empty, GUI:GetRectTransform(panel.view.root))
    end
end

function this:OnDrag(control, systemData)
    if self.mouseState == this.EClickState.Down then
        self.mouseState = this.EClickState.DragScrollView
    end

    -- 拖拽滑动条的逻辑
    if self.mouseState == this.EClickState.DragScrollView then

        -- 需要有拖拽滑动条的回调函数， 否则不执行
        -- 有的模块的UIItemGridItem是不依附于BagTileScrollView的
        if self.onDragCallback then
            self.onDragCallback(self.ins, { raycastObj = systemData["pointerCurrentRaycast"].gameObject, dragItem = false, temp = self }, systemData)
        end
        return
    end

    if self.mouseState == this.EClickState.StartDragItem then
        -- 防止反复SetParent
        --if control.transform.parent ~= UIMostDeepPanel.root.transform then
        --    self.bagGridButton.transform:SetParent(UIMostDeepPanel.root.transform, true)
        --    local x, y = self.bagGridButton:GetAnchoredPosition()
        --    self.bagGridButton:SetAnchoredPosition3D(x, y, -500)
        --
        --    -- 防止拖拽结束后射线打到道具icon上
        GUI:Button_setBright(self.view.empty, false)
        --end

        -- 此为基本的拖拽逻辑， 让道具跟着鼠标移动
        local ok, globalMousePos = GUI:ScreenPointToWorldPointInRectangle(control, systemData["position"])
        if ok then
            local pos = globalMousePos
            control.rectTransform.position = pos
        end

        self.onDragCallback(self.ins, { raycastObj = systemData["pointerCurrentRaycast"].gameObject, dragItem = true, temp = self }, systemData)
    end
end

-- 开始拖拽
function this:StartDrag()

    Coroutine.Wait(0.3)

    -- 如果鼠标是按下状态， 不是拖拽状态(在此函数调用前对道具直接拖拽是移动滑动条， 
    -- 此时 self.mouseState == this.EClickState.DragScrollView)
    if self.mouseState == this.EClickState.Down then

        -- 根据道具能否拖拽， 设置不同状态
        if self.canDrag == true then

            self.mouseState = this.EClickState.ReallyToDrag

            -- 开始旋转
            --if not self.notSelectRotate then
            --    self.modelIconTable:StartRotation()
            --end


            local modelId = SL:GetConfig('cfg_item', self.item.cfgId).shape[1]
            --GUI:setAnchorPoint(self.view.empty,0, 0)
            local model_rot = SL:GetConfig('cfg_model_charactor', modelId).rotateAxis
            if model_rot then
                GUI:Item_Rotate(self.view.item_model_, string.format("%s,50,0", model_rot))
                --self.originRot = GUI:getAllRotation(self.view.item_model_)
            end
            -- 开始拖拽道具，隐藏底图， 让玩家知道可以拖拽了
            GUI:setVisible(self.view.holdImg_, false)
            local model_scale = SL:GetConfig('cfg_model_charactor', modelId).dragScale
            GUI:setScale(self.view.item_model_, model_scale / 100)
            GUI:setVisible(self.view.equipInfo, false)
        else
            self.mouseState = this.EClickState.DragItemButForbid
        end

    end
end

---显示tips
function this:OpenItemTips()
    if self.item and self.showItemTips then
        local bag = "bag"
        local item = SL:GetConfig("cfg_item",self.item.cfgId)
        --道具在仓库显示取出tips
        if item.type ~= EItemType.Equip and self.BagTileScrollViewId == EBagTileScrollViewId.Storage then
            --SL:TipMessage({ "仓库不能使用物品", 1, NoticeType.NoticeMid })
            --return
        end
        --if item.type ~= EItemType.Equip and self.BagTileScrollViewId == EBagTileScrollViewId.Bag then
        --    self:UseItem(1)
        --    return
        --end
        if self.BagTileScrollViewId == EBagTileScrollViewId.Storage then
            SL:OpenTips("depots", self.item.cfgId, self.item.id)
        else
            SL:OpenTips(bag, self.item.cfgId, self.item.id)
        end

    end
end

function this:UseItem(count)
    if not ItemCdMgr.cdGroupItem[self.item.cfgId] or (ItemCdMgr.cdGroupItem[self.item.cfgId] and ItemCdMgr.cdGroupItem[self.item.cfgId].remainCd <= 0) then
        --UIEquipInfoPanel:ClearInfo()
        local index = SL:GetBagIndex(self.item.id)
        local tbl = SL:GetConfig("cfg_item", self.item.cfgId)

        if tbl and tbl.type == EItemType.TriggerItem and tbl.subType == ETriggerItemType.ThankLetter then
            BagInfo.thankLetterIndex = index
            SL:ReqUseLetterMessage(index)
            ---赞助特殊使用
        elseif tbl and tbl.type == EItemType.TriggerItem and tbl.subType == ETriggerItemType.Sponsor then
            --self:UseSponsor()
            BagInfo.ReqUseItemMessage(index)
        elseif tbl and tbl.type == EItemType.TriggerItem and tbl.subType == ETriggerItemType.SummonMonsters then
            if SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                SL:TipMessage( SL:GetConfig('cfg_string',291).text,1, NoticeType.NoticeMid )--"安全区无法使用道具", 
                return
            else
                SL:ReqUseItemMessage(index)
            end
        else
            if tbl and tbl.batchUsage == EUseItemType.UseAll then
                local count1 = self.item.count > 0 and self.item.count or 1
                SL:ReqUseItemMessage(index, count1)
            elseif tbl and tbl.batchUsage == EUseItemType.SelectUse and self.item.count > 1 then
                GUI:UIPanel_Open("dev/ui/ItemBase/Panel/KLItemBatchUse/KLItemBatchUsePanel", nil, nil, { itemIndex = index, itemCfgId = self.item.cfgId })
            elseif tbl and tbl.batchUsage ~= 0 then
                SL:ReqUseItemMessage(index, count)
            else
                SL:ReqUseItemMessage(index, 1)
            end
        end
        if self.item ~= nil then
            EventManager.Dispatch(Event.OnRefreshMedicineBottle, self.item.cfgId)
            BagInfo.lastUseBagItemId = self.item.cfgId
            SL:PlaySoundByTypeAndId(EAudioPlayByCfgType.Item, self.item.cfgId, ESoundFieldType.UseSound)
        end
    else
        SL:TipMessage( SL:GetConfig('cfg_string',292).text, 1, NoticeType.NoticeLeftBottom )---物品使用冷却中
    end
end

function KLGemEquipItemItem:Close()
    GUI:SetActive(self.view.selectImg, false)
    GUI:SetActive(self.view.arrow_, false)
    GUI:UIPanel_Close(_, self.qualityItem)
    self.qualityItem = nil
end

function this:SetSelect(val)
    GUI:SetActive(self.view.selectImg, val)
end

function this:RefreshInfo()
    if SL:GetConfig('cfg_item', self.item.cfgId).type ~= EItemType.Equip then
        GUI:setVisible(self.view.tipsIcon_, false)
        GUI:setVisible(self.view.arrow_, false)
        return
    end
    if SL:CheckEquipBaseCareer(self.item) then
        GUI:setVisible(self.view.tipsIcon_, false)
        local equip = self.item
        ---@type cfg_item_column
        local itemCfg = SL:GetConfig("cfg_item", equip.cfgId)
        ---@type cfg_equip_entryLib_column
        local entryLib = SL:GetConfig("cfg_equip_entryLib", equip.cfgId)
        --获取穿戴栏
        local wearBars = SL:GetMetaValue(EMetaVarGetKey.GET_OPEN_WEARBARS)
        local wearBar = itemCfg.wearBarID[1]
        if wearBars and table.count(itemCfg.wearBarID) > 0 then
            for _, v in pairs(itemCfg.wearBarID) do
                if table.contains(wearBars, v) then
                    wearBar = v
                    break
                end
            end
        end
        local targetGrade
        local targetEquip
        local show = false
        --如果有多个穿戴位置 
        --如果有位置没穿装备则算作该评分大于身上装备评分
        --如果都穿装备了，则与评分最低的装备做比较
        for _, pos in pairs(itemCfg.strPart) do
            local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, pos)
            if target then
                ---@type cfg_equip_entryLib_column
                local targetEntryLib = SL:GetConfig("cfg_equip_entryLib", target.cfgId)
                if entryLib.replaceRating[1] and targetEntryLib.replaceRating[1] and targetEntryLib.replaceRating[1] == entryLib.replaceRating[1] then
                    if not targetGrade then
                        targetGrade = targetEntryLib.replaceRating[2]
                        targetEquip = target
                    else
                        if targetEntryLib.replaceRating[2] < targetGrade then
                            targetGrade = targetEntryLib.replaceRating[2]
                            targetEquip = target
                        end
                    end
                end
            else
                show = true
                break
            end
        end
        --评分高则显示箭头
        --评分相同则词条数量多的显示箭头
        if not show and targetGrade then
            if entryLib.replaceRating[2] > targetGrade then
                show = true
            elseif entryLib.replaceRating[2] == targetGrade and targetEquip then
                local entryCount = table.count(SL:GetEquipEntrys(equip))
                local entryCount_ = table.count(SL:GetEquipEntrys(targetEquip))
                if entryCount > entryCount_ then
                    show = true
                end
            end
        end
        if show then
            GUI:setVisible(self.view.arrow_, true)
            if SL:CheckEquipWear(self.item) == 1 then
                GUI:Image_loadTexture(self.view.arrow_, "ty_icon_arrow_small", "Atlas/TS_Common.spriteatlas")
            else
                GUI:Image_loadTexture(self.view.arrow_, "tips_yellow2", "Atlas/TS_Common.spriteatlas")
            end
        else
            GUI:setVisible(self.view.arrow_, false)
        end
--[[        local resCompare = SL:CompareInitGrage(self.item)
        if resCompare == 1 then
            GUI:setVisible(self.view.arrow_, true)
            if SL:CheckEquipWear(self.item) == 1 then
                GUI:Image_loadTexture(self.view.arrow_, "ty_icon_arrow_small", "Atlas/TS_Common.spriteatlas")
            else
                GUI:Image_loadTexture(self.view.arrow_, "tips_yellow2", "Atlas/TS_Common.spriteatlas")
            end
        elseif resCompare == 0 then
            
        end]]
    else
        GUI:setVisible(self.view.tipsIcon_, true)
        GUI:setVisible(self.view.arrow_, false)
    end


end

function this:Updatenoclip(value)
    GUI:Model_setnoclip(self.view.item_model_, value)
end

function this:SetLiuGuang(equipInfo)
    local liuGuangId = EquipFunc.GetEquipLiuGuangId(equipInfo)
    if liuGuangId then
        GUI:SetStreamAttr(self.view.item_model_, liuGuangId)
    else
        GUI:ResetStreamAttr(self.view.item_model_)
    end
end

function this:RefreshGemShow()
    GUI:setVisible(self.view.gemCell1,false)
    GUI:setVisible(self.view.gemCell2,false)
    GUI:setVisible(self.view.gemCell3,false)
    if self.item then
        local pos
        if self.args and self.args.equipPos then
            pos=self.args.equipPos
        end
        ---@type cfg_item_column
        local itemCfg = SL:GetConfig("cfg_item", self.item.cfgId)
        if pos and pos > EEquipSlotType.None and pos <= EEquipSlotType.Boot then
            GUI:setVisible(self.view.gemCell1,true)
            GUI:setVisible(self.view.gemCell2,true)
            GUI:setVisible(self.view.gemCell3,true)

            if pos==EEquipSlotType.Weapon and itemCfg and itemCfg.strPart[1]==EEquipSlotType.TwoHandWeapon then
                pos=EEquipSlotType.TwoHandWeapon
            end

            local tmpGem1=InfoManager.gemSlateInfo:GetCurActiveSchemeGemByEquipPos("1",tostring(pos))
            local tmpGem2=InfoManager.gemSlateInfo:GetCurActiveSchemeGemByEquipPos("2",tostring(pos))
            local tmpGem3=InfoManager.gemSlateInfo:GetCurActiveSchemeGemByEquipPos("3",tostring(pos))
            local gemImgPathStr1="gem_NoInlay"
            local gemImgPathStr2="gem_NoInlay"
            local gemImgPathStr3="gem_NoInlay"
            
            if tmpGem1 then
                local cfg=SL:GetConfig("cfg_equip_gem", tmpGem1)
                gemImgPathStr1=cfg.gemColorImg
            end
            if tmpGem2 then
                local cfg=SL:GetConfig("cfg_equip_gem", tmpGem2)
                gemImgPathStr2=cfg.gemColorImg
            end
            if tmpGem3 then
                local cfg=SL:GetConfig("cfg_equip_gem", tmpGem3)
                gemImgPathStr3=cfg.gemColorImg
            end
            GUI:Image_loadTexture(self.view.gemImg1,gemImgPathStr1,"Atlas/TS_GemInlayPanel.spriteatlas")
            GUI:Image_loadTexture(self.view.gemImg2,gemImgPathStr2,"Atlas/TS_GemInlayPanel.spriteatlas")
            GUI:Image_loadTexture(self.view.gemImg3,gemImgPathStr3,"Atlas/TS_GemInlayPanel.spriteatlas")
        end
        -- end
    end
end

return this

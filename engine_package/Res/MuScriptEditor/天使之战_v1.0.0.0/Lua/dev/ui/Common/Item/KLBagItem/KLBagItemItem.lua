---@class KLBagItemItem:UIKmlLuaPanelBase
---@field view KLBagItemItemView
---@field isEquipGrid boolean @装备界面item
---@field item CommonProtos.Item
---@field interaction boolean @是否可交互
local KLBagItemItem = class(UIKmlLuaPanelBase)
local this = KLBagItemItem
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
function KLBagItemItem:Init()
    GUI:setVisible(self.view.root,true)
    GUI:setVisible(self.view.bag_item_,true)
    GUI:SetZIndex(self.view.InteractionMaskPanel, 205)
    GUI:SetZIndex(self.view.equipInfo, 205)
    ---使用其他背景
    self.useOtherBg = nil
end

function this:SetSelectUi(x, y, width, height)
    GUI:setPosition(self.view.selectImg, x, y)
    GUI:setContentSize(self.view.selectImg, width, height)
end

-- 根据配置表id获取物品占格
function this.GetBagSizeByCfgId(cfgId)
    local item = SL:GetConfig("cfg_item", cfgId)
    if next(item.holdGrid) == nil then
        if item.id == MUEResourceType.MiracleCurrency then
            return 2, 2
        end
        return 1, 1
    end

    return item.holdGrid[1], item.holdGrid[2]
end

---创建或者刷新界面数据时调用
function KLBagItemItem:Refresh()
    local args = self.args
    self.item = args.item
    if self.mouseState and (self.mouseState == this.EClickState.ReallyToDrag or self.mouseState == this.EClickState.StartDragItem) then
        self:RefreshCount()
        return
    end
    
    self.equipAttItems = {}
    -- 添加全局鼠标事件监听，处理可能丢失的鼠标抬起事件
    self.lastMouseDownItem = nil
    
    self.isEquipGrid = args.isEquipGrid
    self.BagTileScrollViewId = args.BagTileScrollViewId---仓库或者背包
   
    self.x = args.x or 0
    self.y = args.y or 0
    self.z = args.z or 0

    self.mouseState = this.EClickState.None
    self.clickTime = 0
    self.canDrag = args.canDrag ~= nil and args.canDrag or false
    self.originPos = nil
    self.beginDragCallback = args.beginDrag
    self.ins = args.ins
    self.onDragCallback = args.onDrag
    self.endDragCallback = args.endDrag
    self.index = args.index
    self.click = args.click
    self.callBackUI = args.callBackUI
    self.showItemTips = true
    ---是否显示选中特效（外置）
    self.isShowEffect = args.isShowEffect or false

    -- 占位底图是否不显示
    self.noShowHoldImg = self.BagTileScrollViewId == EBagTileScrollViewId_Out.GemSynthesis
    
    if args.contentScale and args.contentScale ~= 0 then
        local scale = 1/args.contentScale
        GUI:setScale(self.view.strengthLevel_,scale * 0.85) 
        GUI:setScale(self.view.appendLevel_,scale) 
    else
        GUI:setScale(self.view.strengthLevel_, 0.85) 
        GUI:setScale(self.view.appendLevel_, 1) 
    end
    GUI:setScale(self.view.quality_, 0.8) 
    
    if self.isEquipGrid and args.default then
        ---@type EEquipGridDefaultData
        local data = args.default
        GUI:setVisible(self.view.holdImg_, false)
        GUI:setVisible(self.view.bg, true)
        self:SetGridSizeDelta(data.width, data.height)
        GUI:setPosition(self.view.quality_, data.qualityX, data.qualityY)
        GUI:setPosition(self.view.xinyun, data.xinyunX, data.xinyunY)
        GUI:setPositionX(self.view.strengthLevel_, data.strengthX)
        GUI:setPositionY(self.view.strengthLevel_, -3)
        GUI:setPositionX(self.view.appendLevel_, data.strengthX)
        GUI:setPositionY(self.view.appendLevel_, -20)
        self:SetSelectUi(data.selectX, data.selectY, data.selectWidth or data.width, data.selectHeight or data.height)
    elseif args.type == "common" then
        self.showItemTips = args.showTips
        local data = args.default
        GUI:setVisible(self.view.holdImg_, false)
        GUI:setVisible(self.view.bg, false)
        ---转移隐藏禁用图标
        GUI:setVisible(self.view.tipsIcon_, false)
        self:SetGridSizeDelta(data.width, data.height)
        self:SetItemMfixSize(data.mfixSizeX, data.mfixSizeY)
        if data.qualityX then
            GUI:setPosition(self.view.quality_, data.qualityX, data.qualityY)
        end
        if data.xinyunX then
            GUI:setPosition(self.view.xinyun, data.xinyunX, data.xinyunY)
        end
        if data.strengthX then
            GUI:setPositionX(self.view.strengthLevel_, data.strengthX)
            GUI:setPositionX(self.view.appendLevel_, data.strengthX)
        end
    else
        GUI:setVisible(self.view.bg, false)
        GUI:setVisible(self.view.holdImg_, true)
        GUI:setPosition(self.view.quality_, 0, 0)
        GUI:setPositionY(self.view.strengthLevel_, 0)
        GUI:setPositionY(self.view.appendLevel_, -12)
        if self.item then
            local horSize, vetSize = this.GetBagSizeByCfgId(self.item.cfgId)
            self:SetGridSizeDelta(horSize * 32, vetSize * 32)
        end
    end
    if self.isShowEffect then
        self:SetSelectEffect(args.isSelect, true)
    else
        GUI:setVisible(self.view.selectImg, args.isSelect)
    end
    GUI:setVisible(self.view.filterTagImg, args.isFilterTag)
    GUI:setPosition(self.view.bag_item_, self.x, self.y, self.z)
    GUI:setVisible(self.view.bg_faceTrade, false)
    GUI:setVisible(self.view.select_faceTrade, false)
    if self.item and self.item.cfgId == EMonthType.MonthCardTime then
        ---月卡时间特殊显示
        GUI:Text_setString(self.view.TimeText, GUIUtil.FormatTimeD((InfoManager.monthCardInfo.MonthCardTimeTotal - SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)) // 1000))
        GUI:setVisible(self.view.tipsIcon_, false)
    else
        GUI:Text_setString(self.view.TimeText, "")
    end

    if not self.isEquipGrid and self.item and args.type ~= "common" then
        local horSize, vetSize = this.GetBagSizeByCfgId(self.item.cfgId)
        self:SetGridSizeDelta(horSize * 32, vetSize * 32)
        self:RefreshInfo()
    end

    if self.isEquipGrid then
        GUI:setVisible(self.view.tipsIcon_, false)
        GUI:setVisible(self.view.arrow_, false)
    end

    self:SetItemData(self.item)
    self:RefreshGemShow()
    GUI:Image_setType(self.view.holdImg_, EImageType.Tiled)
   -- GUI:SetAttr(self.view.holdImg_,"ppum",0.8)
    if self.forgeGroupType == EForgeGroupType.Strength then
        --if self.args.equipPos == 9 or self.args.equipPos == 12 or self.args.equipPos == 13 or self.args.equipPos == EEquipSlotType.Mount then
        if self.args.equipPos == EEquipSlotType.Mount then
            GUI:setVisible(self.view.root,false)
        else
            GUI:setVisible(self.view.root,true)
        end
    elseif self.forgeGroupType == EForgeGroupType.Add then
        GUI:setVisible(self.view.root,self.args.equipPos ~= EEquipSlotType.Mount)
    else
        GUI:setVisible(self.view.root,true)
    end
end

---@param item CommonProtos.Item
function this:SetItem(item, forgeGroupType)
    if not self.args then
        self.args = {}
    end
    self.args.item = item
    self.forgeGroupType = forgeGroupType
    
    self:Refresh()
end

function this:set_args(args)
    self.args = args
end

---@param item CommonProtos.Item
function KLBagItemItem:SetItemData(item)
    self:RefreshBg()
    --默认显示写在这里
    GUI:setVisible(self.view.quality_, false)
    GUI:setVisible(self.view.strengthLevel_, false)
    GUI:setVisible(self.view.appendLevel_, false)
    GUI:setVisible(self.view.item_model_, false)
    GUI:setVisible(self.view.puton, false)
    GUI:setVisible(self.view.xinyun, false)
    GUI:setVisible(self.view.img_dur0, false)
    self:SetInteractionState(true)
    if self.redPointItem then
        GUI:setVisible(self.redPointItem, false)
    end
    if item == nil then
        return
    end
    GUI:setVisible(self.view.item_model_, true)
    self:RefreshCount()
    --穿戴栏的装备，位置缩放旋转有自己的字段控制
    if self.args.is_wear_eauip then
        local itemTbl = SL:GetConfig("cfg_item", item.cfgId)
        local shape = itemTbl.shape[1]
        local model_charactor = SL:GetConfig("cfg_model_charactor", shape)
        local _pos = string.format("%d,%d,%d",model_charactor.wearposition[1],model_charactor.wearposition[2],model_charactor.wearposition[3])
        local _mscale = string.format("%d,%d,%d",model_charactor.wearscale[1],model_charactor.wearscale[1],model_charactor.wearscale[1])
        local _rotate = string.format("%d,%d,%d",model_charactor.wearrotate[1],model_charactor.wearrotate[2],model_charactor.wearrotate[3])
        local data = {
            itemid = item.cfgId,
            uniqueid = item.id,
            mscale = _mscale,
            mrotate = _rotate,
            mpos = _pos,
        }
        GUI:Item_UpdataData(self.view.item_model_, data)
    else
        --显示模型
        -- GUI:Item_UpdataData(self.view.item_model_, {
        --     ["itemid"] = item.cfgId,
        --     ["uniqueid"] = item.id,
        --     --["itemcount"] =count,
        -- })
        local itemTbl = SL:GetConfig("cfg_item", item.cfgId)
        local shape = itemTbl.shape[1]
        local model_charactor = SL:GetConfig("cfg_model_charactor", shape)
        local _pos = string.format("%d,%d,%d",model_charactor.inposition[1],model_charactor.inposition[2],model_charactor.inposition[3])
        local _mscale = string.format("%d,%d,%d",model_charactor.inscale,model_charactor.inscale,model_charactor.inscale)
        local _rotate = string.format("%d,%d,%d",model_charactor.inrotate[1],model_charactor.inrotate[2],model_charactor.inrotate[3])
        local data = {
            itemid = item.cfgId,
            uniqueid = item.id,
            mscale = _mscale,
            mrotate = _rotate,
            mpos = _pos,
        }
        GUI:Item_UpdataData(self.view.item_model_, data)
    end
    self:SetLiuGuang(item)

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
    if item.cfgId ~= EMonthType.MonthCardTime then
        if not self.qualityItem then
            ---@param win KLEquipQualityEntryItem
            GUI:UIPanel_Open("dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem",
                    self.view.quality_, self, {}, nil, function(win)
                        self.qualityItem = win
                        ---月卡时间不在背包里出现的
                        self.qualityItem:SetData(item.cfgId, entryCount)
                        GUI:setScale(self.qualityItem.view.root,0.7)
                    end)
        else
            ---月卡时间不在背包里出现的
            self.qualityItem:SetData(item.cfgId, entryCount)
            GUI:setScale(self.qualityItem.view.root,0.7)
        end
    end
    self:SetItemOutDataInfo(item)
    self:SetItemPuton(item)
    if self.args.mscale then
        GUI:SetAttr(self.view.item_model_, "mscale", EquipFunc.GetEquipInScaleAtt(item.cfgId, itemCfg, self.args.mscale))
    end
    if self.args.mscaleType then
        local scale = EquipFunc.GetItemEquipScale(itemCfg.id,self.args.mscaleType)
        GUI:SetAttr(self.view.item_model_, "mscale", EquipFunc.GetEquipInScaleAtt(item.cfgId, itemCfg, scale))
    end
    self:UpdateDurShow()
end

--显示item的强化追加等属性，外置功能
---@param item CommonProtos.Item
function this:SetItemOutDataInfo(item)
    local data = self.args.default or {}
    if data.strengthX then
        GUI:setPositionX(self.view.strengthLevel_, data.strengthX)
        GUI:setPositionX(self.view.appendLevel_, data.strengthX)
    else
        GUI:setPositionX(self.view.strengthLevel_, -2)
        GUI:setPositionX(self.view.appendLevel_, -2)
    end

    --强化等级
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(item)
    GUI:setVisible(self.view.strengthLevel_, true)
    GUI:Text_setString(self.view.strengthLevel_, strengthLevel ~= 0 and ("+" .. strengthLevel) or "")
    --追加等级
    local appendLv = EquipFunc.GetEquipAppendLevel(item)
    GUI:setVisible(self.view.appendLevel_, true)
    GUI:Text_setString(self.view.appendLevel_, appendLv ~= 0 and EquipFunc.GetEquipAppendLevelStr(appendLv) or "")
    ---是否显示幸运图标
    if not table.isNullOrEmpty(EquipFunc.GetEquipLuckyAttr(item))  then
        GUI:setVisible(self.view.xinyun, true)
--[[        --守护处理、
        local ItemTbl = SL:GetConfig("cfg_item",item.cfgId)
        if ItemTbl and ItemTbl.type == E_ItemType.Equip and ItemTbl.subType == E_ItemSubType_Equip.ShouHu then
            GUI:setVisible(self.view.xinyun, false)
        else
            GUI:setVisible(self.view.xinyun, true)
        end]]
    end
    ---是否显示红点
    local isShowRed = false
    if self.forgeGroupType then
        if self.forgeGroupType == EForgeGroupType.Strength then
            isShowRed = EquipFunc.EquipIsCanStrength(item)
        elseif self.forgeGroupType == EForgeGroupType.Jewelry then
            isShowRed = InfoManager.equipJewelryInfo:IsJewelryCanActive(item) or InfoManager.equipJewelryInfo:IsJewelryCanUpLevel(item)
        elseif self.forgeGroupType == EForgeGroupType.Add then
            isShowRed = EquipFunc.EquipIsCanAppend(item)
        elseif self.forgeGroupType == EForgeGroupType.Breakthrough then
            isShowRed = InfoManager.archangeEquipInfo:CanBreakthrough(item.id, item.cfgId)
        elseif self.forgeGroupType == EForgeGroupType.Breakthrough then
            isShowRed = InfoManager.archangeEquipInfo:CanBreakthrough(item.id, item.cfgId)    
        elseif self.forgeGroupType == EForgeGroupType.Lucky then
            isShowRed = EquipFunc.EquipIsCanLucky(item)
        end
    end
    if GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanel") then
        isShowRed = InfoManager.archangeEquipInfo:CanEquipHaveStrengthenGrail(item.id) or InfoManager.archangeEquipInfo:CanEquipHaveGrail(item.id)
    end
    if not self.redPointItem and isShowRed then
        self.redPointItem = GUI:Image_Create(self.view.empty, {
            atlas = "Atlas/Common.spriteatlas",
            src = "bg_gemred",
            width = "20",
            height = "20",
            a = "21",
            x = "0",
            y = "8",
            z = "-500",
        })
    end
    if self.redPointItem then
        GUI:setVisible(self.redPointItem, isShowRed)
    end
    local grailInfo = InfoManager.archangeEquipInfo:GetGrailInfo(item.id)
    if grailInfo then
        GUI:Text_setString(self.view.strengthLevel_, grailInfo.level ~= 0 and ("+" .. grailInfo.level) or "")
    end
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

function this:SetItemPutonChatPanel(item)

    if item and item.datiankshi_show_type and item.datiankshi_show_type > 0 then
        GUI:setVisible(self.view.puton, true)
    else
        GUI:setVisible(self.view.puton, false)
    end

end

function this:SetGridSizeDelta(x, y)
    GUI:setContentSize(self.view.bag_item_, x, y)
    GUI:setContentSize(self.view.holdImg_, x, y)
    GUI:setContentSize(self.view.empty, x, y)
    GUI:setContentSize(self.view.bg, x, y)
    GUI:setContentSize(self.view.selectImg, x, y)
    GUI:setContentSize(self.view.filterTagImg, x, y)
    GUI:setContentSize(self.view.equipInfo, x, y)
    GUI:setContentSize(self.view.img_dur0, x,y)
    GUI:setContentSize(self.view.InteractionMaskPanel, x,y)
    GUI:Item_UpdataData(self.view.item_model_, {
        ["width"] = x,
        ["height"] = y,
    })
end

---选中显示特效
---@param isShow boolean @是否显示
---@param isReplace boolean @是否更换勾选的图片
function this:SetSelectEffect(isShow, isReplace)
    if isShow then
        self:SetRotate()
    else
        self:CloseRotate()
    end
    local horSize, vetSize = this.GetBagSizeByCfgId(self.item.cfgId)
    if not self.selectEff and isShow then
        self.selectEff = GUI:Effect_Create(self.view.empty, { effectid = "10001", mpos = "0,0,0",
                                                                  mscale = "1,1,1", mrotate = "0,0,0" })

        --选中特效的大小
        GUI:setScaleX(self.selectEff, horSize * 32 - 5)
        GUI:setScaleY(self.selectEff, vetSize * 32 * 0.8)
        self:SetSelectTagImg(isShow, isReplace)
        return
    end
    if self.selectEff then
        --选中特效的大小
        GUI:setScaleX(self.selectEff, horSize * 32 - 5)
        GUI:setScaleY(self.selectEff, vetSize * 32 * 0.8)
        GUI:setVisible(self.selectEff, isShow)
        self:SetSelectTagImg(isShow, isReplace)
    end
    
end

---设置勾选以及更改勾选图标
function this:SetSelectTagImg(isShow, isReplace)
    --勾的图标
    GUI:SetActive(self.view.selectImg, isShow)
    GUI:SetActive(self.view.selectTagImg, isShow)
    if isReplace and isShow then
        GUI:Image_setAlpha(self.view.selectImg,0)
        GUI:Image_loadTexture(self.view.selectTagImg, "icon_select", "Atlas/TS_Common.spriteatlas")
        GUI:setContentSize(self.view.selectTagImg, 23, 19)
        GUI:setPositionZ(self.view.selectTagImg, -100)
    end
end

function this:SetItemMfixSize(x, y)
    if x and y then
        GUI:Item_UpdataData(self.view.item_model_, { mfixsize = x .. "," .. y })
    end
end

---注册UI事件和服务器消息
function KLBagItemItem:RegistEvents()

    -- -- 监听全局鼠标抬起事件
    SL:RegisterLUAEvent(LUA_EVENT_APPLICATION_FOCUS, function() 
        if self.lastMouseDownItem and self.lastMouseDownItem.mouseState ~= this.EClickState.None then
            -- 如果检测到鼠标抬起但之前的组件仍处于按压状态，强制恢复状态
            self.lastMouseDownItem:RestoreNormalState()
            self.lastMouseDownItem.mouseState = this.EClickState.None
            self.lastMouseDownItem = nil
        end
     end,self)

    GUI:AddOnTouchEvent(self.view.empty, self, function(ui, control, eventType, systemData)
        if not self.interaction then
            return
        end

        if eventType == EUIEventName.OnPointerDown then
            if systemData.button ~= InputButton.Left then
                return
            end

            self.clickTime = SL:GetMetaValue(EMetaVarGetKey.GetTimeStamp)
            self.mouseState = this.EClickState.Down
            self.lastMouseDownItem = self  -- 记录当前按下鼠标项

            Coroutine.Start(self.StartDrag, self)
        end

        if eventType == EUIEventName.OnPointerUp then
            self.lastMouseDownItem = nil  -- 清除记录
            if systemData.button ~= InputButton.Left or self.clickTime == 0 then
                return
            end

            -- 检查是否为拖拽滑动条或者拖拽物品， 则不触发逻辑
            if self.mouseState == this.EClickState.DragScrollView or self.mouseState == this.EClickState.StartDragItem then
                return
            end

            if self.mouseState == this.EClickState.ReallyToDrag then
                GUI:setAnchorPoint(self.view.empty, 1, 1)
                GUI:Item_Rotate(self.view.item_model_, "")
                ---- 结束拖拽时显示占位底图
                GUI:setVisible(self.view.holdImg_, not self.noShowHoldImg)
                GUI:setScale(self.view.item_model_, 1)
                GUI:setVisible(self.view.equipInfo, true)
                return
            end

            self.mouseState = this.EClickState.ShowTips
            if self.canDrag then
                self:SetRotate()
            end
            ---有外部传入的点击事件，调用外部的
            if self.click then
                self.click(self.callBackUI, self.view, self.item, self)
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

            -- 检查物品是否还有效（数量大于0）
            if not self.item or self.item.count <= 0 then
                -- 物品已无效，直接恢复状态
                self:RestoreNormalState()
                self.mouseState = this.EClickState.None
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
            ---control.rectTransform.anchoredPosition = self.originPos
            GUI:SetAnchoredPosition(control, self.originPos)
            SL.AudioMgr.PlaySound(EAudioPlayByCfgType.Item, self.item.cfgId, ESoundFieldType.DownSound)

            if self.endDragCallback then
                self.endDragCallback(self.ins, { raycastObj = systemData["pointerCurrentRaycast"].gameObject, dragItem = self, index = self.index }, systemData)
            end
            --
            ---- 结束拖拽时显示占位底图
            if self.view and self.view.root then
                GUI:setVisible(self.view.holdImg_, not self.noShowHoldImg)
                GUI:Button_setBright(self.view.empty, true)
                GUI:setScale(self.view.item_model_, 1)
                GUI:setVisible(self.view.equipInfo, true)
            end

            self.mouseState = this.EClickState.None

        end
    end)
    SL:RegisterLUAEvent(LUA_EVENT_STRENGTH_OK, self.LUA_EVENT_STRENGTH_OK, self)
    SL:RegisterLUAEvent(LUA_EVENT_APPEND_OK, self.LUA_EVENT_APPEND_OK, self)
    SL:RegisterLUAEvent(LUA_EVENT_JEWELRY_CHANGE, self.LUA_EVENT_JEWELRY_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_TRANSFER_SUCCESS, self.LUA_EVENT_TRANSFER_SUCCESS, self)
    SL:RegisterLUAEvent(LUA_EVENT_REFRESH_GEM_SLATE_INFO, self.RefreshGemShow, self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.RefreshGemShow, self)
    SL:RegisterLUAEvent(LUA_EVENT_CONTROL_UI_ONCLICK, self.UI_OnClick, self)
end

-- 恢复正常的视觉状态
function this:RestoreNormalState()
    self:CloseRotate()
    GUI:Item_Rotate(self.view.item_model_, "")
    GUI:setAnchorPoint(self.view.empty, 1, 1)
    
    -- 只有当物品存在时才播放音效
    if self.item and self.item.cfgId then
        SL.AudioMgr.PlaySound(EAudioPlayByCfgType.Item, self.item.cfgId, ESoundFieldType.DownSound)
    end
    
    GUI:setVisible(self.view.holdImg_, not self.noShowHoldImg)
    GUI:Button_setBright(self.view.empty, true)
    GUI:setScale(self.view.item_model_, 1)
    GUI:setVisible(self.view.equipInfo, true)
    
    -- 确保父级关系正确
    if self.parentTrans then
        GUI:SetParent(self.view.empty, self.parentTrans)
        if self.originPos then
            GUI:SetAnchoredPosition(self.view.empty, self.originPos)
        end
    end
end

---装备外置信息发生变化
function this:LUA_EVENT_EQUIP_OUT_INFO_CHANGE(type, data)
    if self.item and self.item.id == data.itemId then
        local item
        if self.isEquipGrid then
            item = SL:GetWearEquipByItemId(data.itemId)
        else
            item = SL:GetItemInfoByItemId(data.itemId)
        end
        self.item = item
        self:SetLiuGuang(item)
        -- self.forgeGroupType = type
        self:SetItemOutDataInfo(item)
    end
end

function this:LUA_EVENT_APPEND_OK(id, data)
    self:LUA_EVENT_EQUIP_OUT_INFO_CHANGE(EForgeGroupType.Add, data)
end

function this:LUA_EVENT_STRENGTH_OK(id, data)
    self:LUA_EVENT_EQUIP_OUT_INFO_CHANGE(EForgeGroupType.Strength, data)
end

function this:LUA_EVENT_JEWELRY_CHANGE(id, data)
    self:LUA_EVENT_EQUIP_OUT_INFO_CHANGE(EForgeGroupType.Jewelry, data)
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

    -- 检查物品是否有效
    if not self.item or self.item.count <= 0 then
        return
    end

    if self.mouseState == this.EClickState.ReallyToDrag then
        self.mouseState = this.EClickState.StartDragItem
        GUI:setAnchorPoint(self.view.empty, 0, 0)
        self.originPos = GUI:GetAnchoredPosition(control) ---control.rectTransform.anchoredPosition
        self.parentTrans = GUI:GetParentByTransform(self.view.empty)---self.view.empty.rectTransform.parent
        self.beginDragCallback(self.ins, {}, systemData)
        SL.AudioMgr.PlaySound(EAudioPlayByCfgType.Item, self.item.cfgId, ESoundFieldType.HoldSound)
        local panel = GUI:GetUI("dev/ui/Common/Panel/KLTop/KLTopPanel")
        local emptyParent
        if panel then
            emptyParent = GUI:GetRectTransform(panel.view.root)
        end
        GUI:SetParent(self.view.empty, emptyParent)
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
        -- 再次检查物品是否有效，防止在拖拽过程中物品被使用
        if not self.item or self.item.count <= 0 then
            -- 物品已无效，立即停止拖拽
            self:RestoreNormalState()
            self.mouseState = this.EClickState.None
            return
        end
        
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
            GUI:SetWorldPosition(control, pos.x, pos.y, pos.z)
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
            local model_rot = SL:GetConfig('cfg_model_charactor', modelId).rotateAxis
            if model_rot then
                GUI:Item_Rotate(self.view.item_model_, string.format("%s,50,0", model_rot))
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

function this:SetRotate()
    local modelId = SL:GetConfig('cfg_item', self.item.cfgId).shape[1]
    ---@type cfg_model_charactor_column
    local tbl = SL:GetConfig('cfg_model_charactor', modelId)
    local speed = tbl.rotateSpeed or 200
    local rotateAxis = tbl.rotateAxis
    GUI:SetAttr(self.view.item_model_,"selfrotation",string.format("%d,%d,0",rotateAxis,speed))
end

function this:CloseRotate()
    GUI:SetAttr(self.view.item_model_,"selfrotation","")
end

---显示tips
function this:OpenItemTips()
    if self.item and self.showItemTips then
        local bag = "bag"
        local item = SL:GetConfig("cfg_item", self.item.cfgId)
        --道具在仓库显示取出tips
        if item.type ~= EItemType.Equip and self.BagTileScrollViewId == EBagTileScrollViewId.Storage then
            --SL:TipMessage({ "仓库不能使用物品", 1, NoticeType.NoticeMid })
            --return
        end
        --if item.type ~= EItemType.Equip and self.BagTileScrollViewId == EBagTileScrollViewId.Bag then
        --    self:UseItem(1)
        --    return
        --end
        local synthesisPanel = GUI:GetUI("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel")
        if synthesisPanel then
            GUI:setVisible(self.view.filterTagImg, true)
        end
        if self.BagTileScrollViewId == EBagTileScrollViewId.Storage then
            SL:OpenTips("depots", self.item.cfgId, self.item.id)
        else
            SL:OpenTips(bag, self.item.cfgId, self.item.id, self.item.count)
        end

    end
end

function this:UseItem(count)
    if not ItemCdMgr.cdGroupItem[self.item.cfgId] or (ItemCdMgr.cdGroupItem[self.item.cfgId] and ItemCdMgr.cdGroupItem[self.item.cfgId].remainCd <= 0) then
        local index = SL:GetBagIndex(self.item.id)
        local tbl = SL:GetConfig("cfg_item", self.item.cfgId)

        if tbl and tbl.type == EItemType.TriggerItem and tbl.subType == ETriggerItemType.ThankLetter then
            SL:ReqUseLetterMessage(index)
            ---赞助特殊使用
        elseif tbl and tbl.type == EItemType.TriggerItem and tbl.subType == ETriggerItemType.Sponsor then
            SL:ReqUseItemMessage(index)
        elseif tbl and tbl.type == EItemType.TriggerItem and tbl.subType == ETriggerItemType.SummonMonsters then
            if SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                SL:TipMessage(SL:GetConfig('cfg_string', 291).text, 1, NoticeType.NoticeMid)--"安全区无法使用道具", 
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
            -- BagInfo.lastUseBagItemId = self.item.cfgId
            SL:PlaySoundByTypeAndId(EAudioPlayByCfgType.Item, self.item.cfgId, ESoundFieldType.UseSound)
        end
    else
        SL:TipMessage(SL:GetConfig('cfg_string', 292).text, 1, NoticeType.NoticeLeftBottom)---物品使用冷却中
    end
end

function KLBagItemItem:Close()
    GUI:SetActive(self.view.selectImg, false)
    GUI:SetActive(self.view.selectTagImg, false)
    GUI:setVisible(self.view.filterTagImg, false)
    GUI:Image_setAlpha(self.view.selectImg,100)
    GUI:SetActive(self.view.arrow_, false)
    
    if self.mouseState and (self.mouseState == this.EClickState.ReallyToDrag or self.mouseState == this.EClickState.StartDragItem) then
        self:RestoreNormalState()
        if self.parent and self.parent.panel and self.parent.panel.RefreshGrid then
            self.parent.panel:RefreshGrid()
        end
    end
    if self.qualityItem then
        GUI:UIPanel_Close(_, self.qualityItem)
        self.qualityItem = nil
    end
    
    self.forgeGroupType = nil
end

function this:SetSelect(val)
    if val then
        self:SetRotate()
    else
        self:CloseRotate()
    end
    
    if self.BagTileScrollViewId == EBagTileScrollViewId.Recover then
        self:SetSelectEffect(val, true)
    else
        GUI:setVisible(self.view.selectImg, val)
        self.args.isSelect = val
    end
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
        --[[local targetGrade
        local targetEquip
        local targetPos
        local show = false
        --如果有多个穿戴位置 
        --如果有位置没穿装备则算作该评分大于身上装备评分
        --如果都穿装备了，则与评分最低的装备做比较
        if #itemCfg.strPart == 2 then
            if itemCfg.strPart[1] == EEquipSlotType.OffHandWeapon or itemCfg.strPart[1] == EEquipSlotType.Weapon  then
                local target_1 = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.TwoHandWeapon)
                local target_2 = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.Weapon)
                local target_3 = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.OffHandWeapon)
                ---没有穿戴武器
                if not target_1 and (not target_2 and target_3)  then
                    show = true
                else
                    ---穿戴的双手武器
                    if target_1  then
                        if EquipFunc.CompareItemGradeAndEntrys(target_1, equip) then
                            show = true
                        end
                    else
                        ---同时穿了两件单手
                        if target_2 and target_3 then
                            if EquipFunc.CompareItemGradeAndEntrys(target_2, equip) then
                            show = true
                        end

                        if EquipFunc.CompareItemGradeAndEntrys(target_3, equip) then
                            show = true
                        end
                    else
                        show = true
                    end
                end
            end
        else
            for _, pos in pairs(itemCfg.strPart) do
                local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, pos)
                if target then
                    ---@type cfg_equip_entryLib_column
                    local targetEntryLib = SL:GetConfig("cfg_equip_entryLib", target.cfgId)
                    if entryLib and entryLib.replaceRating[1] and targetEntryLib and targetEntryLib.replaceRating[1] and targetEntryLib.replaceRating[1] == entryLib.replaceRating[1] then
                        if not targetGrade then
                            targetGrade = targetEntryLib.replaceRating[2]
                            targetEquip = target
                            targetEquip = target
                            targetPos = pos
                        else
                            if targetEntryLib.replaceRating[2] < targetGrade then
                                targetGrade = targetEntryLib.replaceRating[2]
                                targetEquip = target
                                targetPos = pos
                            end
                        end
                    end
                else
                    if pos == EEquipSlotType.OffHandWeapon then
                        show = self:CheckOffHandEquipWearLimit(equip)
                    elseif pos == EEquipSlotType.Weapon then
                        local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.TwoHandWeapon)
                        if not target or EquipFunc.CompareItemGradeAndEntrys(target, equip) then
                            show = true
                            break
                        end
                    elseif pos == EEquipSlotType.TwoHandWeapon then
                        local target = SL:GetMetaValue("EQUIP_TARGET_DATA", wearBar, EEquipSlotType.Weapon)
                        if not target or EquipFunc.CompareItemGradeAndEntrys(target, equip) then
                            show = true
                            break
                        end
                    else
                        show = true
                        break
                    end
                end
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
            if show and targetPos and targetPos == EEquipSlotType.OffHandWeapon then
                show = self:CheckOffHandEquipWearLimit(equip)
            end
        end]]
        local show = EquipFunc.CheckBagEquipIsBetter(self.item)
        local useAttList = {}
        local useAttLimit = SL:GetEquipValue(EMetaVarGetKey.EQUIP_WEAR_LIMIT, "", self.item.cfgId)
        local entryAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_ENTRY_ATTR, "bag", self.item.cfgId, self.item.id)
        for _, att in ipairs(useAttLimit) do
            local att_type = att[1]
            local att_num = att[2]
            local offsetValue = EquipFunc.GetAttrValueOffset(att_type, att_num, entryAttr)
            if offsetValue > 0 then
                useAttList[att_type] = -offsetValue
            end
        end
        EquipFunc.SetRoleAttrValueOffset(useAttList)
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
        --[[    local resCompare = SL:CompareInitGrage(self.item)
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
        if self.isShowEffect then
            --回收和分解的背包不显示禁用符号
            GUI:setVisible(self.view.tipsIcon_, false)
        else
            GUI:setVisible(self.view.tipsIcon_, false)
        end
        GUI:setVisible(self.view.arrow_, false)
    end
end

function this:CheckOffHandEquipWearLimit(item)
    --穿戴主副手武器时， 有些职业的副手装备需要单独做检测
    ---@type cfg_equip_entryLib_column
    local entryLib = SL:GetConfig("cfg_equip_entryLib", item.cfgId)
    local result = true
    if not table.isNullOrEmpty(entryLib.assistantJob) and entryLib.assistantJob[1][1] ~= 0 then
        local canEquip = false
        ---@type cfg_career_column
        local careerTbl = SL:GetMetaValue("ME_CAREER_TAB_COLUMN")
        for _, jobInfo in pairs(entryLib.assistantJob) do
            local baseCareer = jobInfo[1]
            local careerRank = jobInfo[2]
            if careerTbl.baseCareer == baseCareer and careerTbl.careerRank >= careerRank then
                canEquip = true
                break
            end
        end
        if canEquip == false then
            result = false
        end
    end
    return result
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

---刷新萤石
function this:RefreshGemShow()
    if not self.view then
        return
    end
    GUI:setVisible(self.view.gemCell1, false)
    GUI:setVisible(self.view.gemCell2, false)
    GUI:setVisible(self.view.gemCell3, false)
    ---@type cfg_system_switch_column
    local systemCfg = SL:GetConfig("cfg_system_switch", 10403)
    local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, systemCfg.systemName)
    if not isMeet then
        return
    end
    if self.isEquipGrid and self.args.default and self.item then
        local pos
        if self.args and self.args.equipPos then
            pos = self.args.equipPos
        end
        ---@type cfg_item_column
        local itemCfg = SL:GetConfig("cfg_item", self.item.cfgId)
        if pos and pos > EEquipSlotType.None and pos <= EEquipSlotType.Boot then
            GUI:setVisible(self.view.gemCell1, true)
            GUI:setVisible(self.view.gemCell2, true)
            GUI:setVisible(self.view.gemCell3, true)

            if pos == EEquipSlotType.Weapon and itemCfg and itemCfg.strPart[1] == EEquipSlotType.TwoHandWeapon then
                pos = EEquipSlotType.TwoHandWeapon
            end

            local tmpGem1 = InfoManager.gemSlateInfo:GetCurActiveSchemeGemByEquipPos("1", tostring(pos))
            local tmpGem2 = InfoManager.gemSlateInfo:GetCurActiveSchemeGemByEquipPos("2", tostring(pos))
            local tmpGem3 = InfoManager.gemSlateInfo:GetCurActiveSchemeGemByEquipPos("3", tostring(pos))
            if self.args and self.args.isOtherPlayer then
                --其他玩家的萤石数据不能用自己的
                tmpGem1 = InfoManager.gemSlateInfo:GetOtherPlayerCurActiveSchemeGemByEquipPos("1", tostring(pos))
                tmpGem2 = InfoManager.gemSlateInfo:GetOtherPlayerCurActiveSchemeGemByEquipPos("2", tostring(pos))
                tmpGem3 = InfoManager.gemSlateInfo:GetOtherPlayerCurActiveSchemeGemByEquipPos("3", tostring(pos))
            end
            local gemImgPathStr1 = "gem_NoInlay"
            local gemImgPathStr2 = "gem_NoInlay"
            local gemImgPathStr3 = "gem_NoInlay"

            if tmpGem1 then
                local cfg = SL:GetConfig("cfg_equip_gem", tmpGem1)
                gemImgPathStr1 = cfg.gemColorImg
            end
            if tmpGem2 then
                local cfg = SL:GetConfig("cfg_equip_gem", tmpGem2)
                gemImgPathStr2 = cfg.gemColorImg
            end
            if tmpGem3 then
                local cfg = SL:GetConfig("cfg_equip_gem", tmpGem3)
                gemImgPathStr3 = cfg.gemColorImg
            end
            GUI:Image_loadTexture(self.view.gemImg1, gemImgPathStr1, "Atlas/TS_GemInlayPanel.spriteatlas")
            GUI:Image_loadTexture(self.view.gemImg2, gemImgPathStr2, "Atlas/TS_GemInlayPanel.spriteatlas")
            GUI:Image_loadTexture(self.view.gemImg3, gemImgPathStr3, "Atlas/TS_GemInlayPanel.spriteatlas")
        end
        -- end
    end
end

function this:UI_OnClick(_,data)
    local panelName = data.selfHandle.panel.panelName
    if panelName == "KLUIItemTipsPanel" or panelName == "KLUIEquipTipsPanel" and data.selfHandle.controlId == "background_close"  then
        self:CloseRotate()
    end
end

---设置交互状态
function this:SetInteractionState(interaction)
    self.interaction = interaction ~= false
    GUI:setVisible(self.view.InteractionMaskPanel, self.interaction == false)
end

---刷新数量
function this:RefreshCount()
    if not self.item then
        return
    end
    --交易行需求展示货币，货币数量过多，转换一下
    local count = self.item.count
    -- 背包有个虚拟消耗
    if self.BagTileScrollViewId == EBagTileScrollViewId.Bag then
        local costCount = SL:onTriggerEvent(LUA_EVENT_BAG_ITEM_COUNT_VIRTUAL_COST, self.item.id)
        if costCount and costCount > 0 then
            count = count - costCount
        end
    end

    if count < 0 then
        count = 0
    end

    if count > 1 and self.BagTileScrollViewId ~= EBagTileScrollViewId_Out.GemSynthesis then
        GUI:setVisible(self.view.item_count_unit, true)
        GUI:Text_setString(self.view.item_count_unit, tostring(SL:GetSimpleNumber(count, 0)))
        GUI:SetZIndex(self.view.item_count_unit,210)
    else
        GUI:setVisible(self.view.item_count_unit, false)
    end
    self:SetInteractionState(count > 0)
end

function this:RefreshFilterTagList(isFilterTag)
    -- SL:LogError("RefreshFilterTagList", self.item.cfgId, isFilterTag)
    GUI:setVisible(self.view.filterTagImg, isFilterTag)
end


function this:RefreshBg()
    if self.isEquipGrid == nil or self.args.default == nil then
        return
    end
    ---@type EEquipGridDefaultData
    local data = self.args.default
    local useOtherBg = self.item ~= nil and data.otherBg ~= nil
    if self.useOtherBg == useOtherBg then
        return
    end
    self.useOtherBg = useOtherBg

    local src = self.useOtherBg and data.otherBg or data.bg
    GUI:setColor(self.view.bg,"#FFFFFFFF")
    GUI:Image_loadTexture(self.view.bg, src, data.bgAtlas and data.bgAtlas or "Atlas/UIBagPanel_Out.spriteatlas")
end

function this:UpdateDurShow()
    if not self.item then
       return 
    end
    local itemCfg = SL:GetConfig("cfg_item", self.item.cfgId)
    local maxDur = EquipFunc.GetMaxDurability(self.item)
    if maxDur ~= 0 and self.isEquipGrid and not self.forgeGroupType and itemCfg.type == E_ItemType.Equip then
       GUI:setVisible(self.view.img_dur0, EquipFunc.GetDurability(self.item) == 0) 
    end
end

function this:ShowFaceTradeBG()
    GUI:setVisible(self.view.bg_faceTrade, true)
end

function this:ShowFaceTradeSelect(select)
    GUI:setVisible(self.view.select_faceTrade, select)
end

function this:Hide()
    -- 加载中不允许操控组件
    if not self.isLoading then
        GUI:setColor(self.view.bg,"#FFFFFF00")
    end
end

return KLBagItemItem

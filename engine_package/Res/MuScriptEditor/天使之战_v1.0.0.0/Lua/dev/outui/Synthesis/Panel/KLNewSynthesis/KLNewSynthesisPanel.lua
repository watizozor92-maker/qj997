---@class KLNewSynthesisPanel:UIKmlLuaPanelBase
---@field view KLNewSynthesisPanelView
---@field bagTileScrollView KLUIBagTileScrollViewItem
---@field smelterItems table<number, table> @熔炉道具 <id, table{ index = 索引，item = item}>
---@field useGridTable table<number, boolean> @熔炉格子是否被使用
---@field bagItemIndex table<number, table> @记录放到熔炉里面的背包道具索引，<id, table{ index = 索引, count = 放到熔炉前的数量}}>
---@field minorCost table<number, table> @次要材料信息
local KLNewSynthesisPanel = class(UIKmlLuaPanelBase)
local this = KLNewSynthesisPanel

---创建时调用一次
function this:Init()
    -- SL:LogTable(SL:GetMetaValue("BAG_DATA")[1],true)
    self.putList = {}
    self.smelterItems = {}
    self.bagItemIndex = {}
    self.useGridTable = {}
    ---@type table<number, table> 次要材料信息
    self.minorCost = {}
    ---额外消耗限制放置数量
    self.consumeItemLimitCount = {
        -- [50040068] = 1
    }
    -- SL:LogTable(SL:GetMetaValue("BAG_DATA"),true)
    GUI:DataListInitData(self.view.DataList_TabType, function()
        return table.count(self.tabDatas)
    end, nil, nil, function(realIndex, kmlcontrol)
        return self:ItemUpdate(realIndex, kmlcontrol)
    end)
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", nil, nil, nil, false, function(uipanel)
        self.bagUI = uipanel
    end)

    GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.Smelter, self,
        {
            x = -17,
            y = 322,
            contentW = 350,
            contentH = 176,
            itemList = {},
            id = EBagTileScrollViewId_Out.Synthesis,
            forbidCount = 0,
            hor = ESynthesisBagSize.H,
            vet = ESynthesisBagSize.V,
            forbidClickCallback = self.forbidClick,
            dragEndCallback = self.DragEnd,
            JumpSelectId = self.JumpSelectId,
            parent = self,
            contentScale = 1.345,
            itemClick = self.ItemClick,
            callBackUI = self,
            itemOpenCallback = self.itemOpenCallback
        }, true, function(bagTileScrollView)
            self.bagTileScrollView = bagTileScrollView
            self.bagTileScrollView:ResetPos()
            self.bagTileScrollView:RefreshInfo()
            --[[if needLockRow and needLockRow > 0 then
             self.bagTileScrollView:RefreshRedGrid(needLockRow * self.maxVet)
         end]]
            if self.bagInfoChangeCallBack then
                self.bagInfoChangeCallBack()
                self.bagInfoChangeCallBack = nil
            end
        end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.OnClick_Btn_Close)
    GUI:AddOnClickEvent(self.view.Btn_LookPreview, self, self.OnClick_Btn_LookPreview)
    GUI:AddOnClickEvent(self.view.Btn_Confirm, self, self.OnClick_Btn_Confirm)
    -- GUI:Input_SetOnEndEdit(self.view.Input_PutNum, self, self.OnValueChange_Input_PutNum)
    -- GUI:AddOnClickEvent(self.view.Btn_NumberMinus, self, self.OnClick_Btn_NumberMinus)
    -- GUI:AddOnClickEvent(self.view.Btn_NumberAdd, self, self.OnClick_Btn_NumberAdd)
    -- GUI:SetSliderOnValueChange(self.view.Slider_PutNum, self, self.OnValueChange_Slider_PutNum)
    -- GUI:AddOnClickEvent(self.view.Btn_ConfirmPutNum, self, self.OnClick_Btn_ConfirmPutNum)
    -- GUI:AddOnClickEvent(self.view.NumSelectMask, self, function()
    --     GUI:setPosition(self.view.NumSelect, 3000, 3000)
    --     GUI:setVisible(self.view.NumSelectMask, false)
    -- end)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.STRENGTH_EQUIP_RESULT, self.STRENGTH_EQUIP_RESULT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.APPEND_EQUIP_RESULT, self.APPEND_EQUIP_RESULT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ITEM_SYNTHESIS, self.RES_ITEM_SYNTHESIS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SYNTHESIS_PUT_BAG, self.RES_SYNTHESIS_PUT_BAG, self)
    SL:RegisterTrigger(LUA_EVENT_BAG_ITEM_COUNT_VIRTUAL_COST, self.LUA_EVENT_BAG_ITEM_COUNT_VIRTUAL_COST, self)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, this.LUA_EVENT_CLOSEWIN, self)
    SL:RegisterTrigger(LUA_TRIGGER_TRAD_GOODS_MESSAGE, self.TipsShow, self)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setText(self.view.Text_Title, self.args.cfg.name)
    local tbl = SL:GetConfigTable("cfg_synthesis")
    local tempTypes = {}
    for i, v in pairs(self.args.cfg.type) do
        tempTypes[v] = true
    end
    self.synthesisCfgDatas = {}
    self.tabDatas = {}
    local career = SL:MeData_GetCareer()
    ---@param v cfg_synthesis_column
    for i, v in pairs(tbl) do
        if tempTypes[v.type] and self:CheckCareer(career, v) then
            if self.synthesisCfgDatas[v.type] == nil then
                self.synthesisCfgDatas[v.type] = { v }
                table.insert(self.tabDatas, v)
            else
                table.insert(self.synthesisCfgDatas[v.type], v)
            end
        end
    end
    GUI:DataListUpdateData(self.view.DataList_TabType)
end

function this:Hide()
end

function this:Close()
    self:ClearSmelter()
    self:ResultBackToBag()
end

---检查职业
---@param cfg cfg_synthesis_column
function this:CheckCareer(career, cfg)
    if #cfg.career == 0 then
        return true
    end
    for i, v in pairs(cfg.career) do
        if v[1] == career.baseCareer and v[2] <= career.careerRank then
            return true
        end
    end
    return false
end

function this:ItemUpdate(realIndex, kmlcontrol)
    local tog = GUI:GetChildControl(self.view.DataList_TabType, realIndex, "Tog")
    local text_togName = GUI:GetChildControl(self.view.DataList_TabType, realIndex, "Text_TogName")
    ---@type cfg_synthesis_column
    local data = self.tabDatas[realIndex + 1]
    GUI:Text_setText(text_togName, data.typeName)
    GUI:SetToggleOnValueChange(tog, self, self.OnValueChange_TabTog, data)
    if realIndex == 0 then
        GUI:SetTogDefaultThis(tog)
    end
end

---获取熔炼格子道具
function this:GetSmelterGridItems()
    return self.useGridTable
end

function this:DragToSmelterItem(oldIndex, newIndex, item)
    self.IsdragToSmelter = true
    if self.bagItemIndex[item.id] == nil then
        self.bagItemIndex[item.id] = { index = oldIndex, count = item.count }
    end
    -- if item.count == 1 then
    --     self:BagToSmelterItem_Out(item.id, item.cfgId)
    --     return
    -- end
    -- self.bagUI:RefreshFilterTagList({ [item.id] = 1 })
    -- self:BagToSmelterItem_Out(item.id, item.cfgId, 1)
    
    -- 20260225 luoxiangri 改成 全部放入
    self:BagToSmelterItem_Out(item.id, item.cfgId, item.count)
    --SL:OpenTips("bag", item.cfgId, item.id)
end

---背包放到熔炉
function this:BagToSmelterItem(oldIndex, newIndex, item, count)
    count = count or 1
    -- 检查道具是否符合要求
    local result, tips = self:CheckItem(item, count)
    tips = tips or "道具不符合要求"
    if not result then
        SL:TipMessage(tips, 1, NoticeType.NoticeMid)
        return
    end
    if not self.IsdragToSmelter then
        if self.bagItemIndex[item.id] == nil then
            self.bagItemIndex[item.id] = { index = oldIndex, count = item.count }
        end
    end
    --[[local isEquip = SL:GetConfig("cfg_item", item.cfgId).type == 2
    local isBind = EquipFunc.GetItemIsBind(_, item)
    if isEquip and not isBind then
        SL:CommonTipsMessage({
            showTips = "必要材料放入不可交易物品，合成后将不可交易，是否放入？",
            sureBtnText = "确定" ,
            callback = function()
                self.putItem = item
                self.newIndex = newIndex
                self:PutCountItem(count)
            end;
            -- showToggle = true;
        })
        return
    end]]
    self.putItem = item
    self.newIndex = newIndex
    self:PutCountItem(count)
end

function this:BagToSmelterItem_Out(itemId, itemCfgId, count)
    if self.isPreview then
        SL:TipMessage("请先把合成道具放回背包", 1, NoticeType.NoticeMid)
        return
    end
    local item = SL:GetPosItemInfo("bag", itemCfgId, itemId)
    local index = SL:GetBagIndex(itemId) - 10000
    local result, putIndex = self:CheckItemGridCanPut(itemCfgId)
    if result then
        --SL:LogError("放置格子：", putIndex)
        self:BagToSmelterItem(index, putIndex, item, count)
    else
        SL:TipMessage("格子已满", 1, NoticeType.NoticeMid)
    end
    self.IsdragToSmelter = false
end

---检查item占用格子是否能放入
function this:CheckItemGridCanPut(itemCfgId)
    local holdGrid = SL:GetConfig('cfg_item', itemCfgId).holdGrid
    local holdHor = holdGrid[1]
    local holdVet = holdGrid[2]
    for hor = 1, ESynthesisBagSize.H do
        for vet = 1, ESynthesisBagSize.V do
            --[[local startVet = vet - (holdHor - 1) // 2
            local startHor = hor - (holdVet - 1) // 2]]
            local startVet = vet
            local startHor = hor
            -- 超出边界
            if startHor <= 0 or startHor + holdVet - 1 > ESynthesisBagSize.H or startVet <= 0 or startVet + holdHor - 1 > ESynthesisBagSize.V then
                goto continue
            end
            local canPut = true
            for nowHor = startHor, startHor + holdVet - 1 do
                for nowVet = startVet, startVet + holdHor - 1 do
                    if self.useGridTable[self.bagTileScrollView.GetIntWithHorAndVet(nowHor, nowVet)] == true then
                        canPut = false
                        break
                    end
                end
                if not canPut then break end
            end
            if canPut then
                return true, self.bagTileScrollView.GetIntWithHorAndVet(hor, vet)
            end
            ::continue::
        end
    end
    return false
end

---熔炉放到背包
function this:SmelterToBagItem(oldIndex, newIndex, item, putCount)
    local count = putCount
    for i = #self.putList, 1, -1 do
        if self.putList[i].id == item.id then
            if self.putList[i].count > count then
                self.putList[i].count = self.putList[i].count - count
            else
                count = count - self.putList[i].count
                table.remove(self.putList, i)
            end
        end
    end

    local curItemInfo = self.smelterItems[item.id]
    local eventData = {}
    if curItemInfo and curItemInfo.item.count > putCount then
        curItemInfo.item.count = curItemInfo.item.count - putCount
        eventData = { curItemInfo }
    else
        curItemInfo = nil
        eventData = { { index = oldIndex } }
    end
    self.smelterItems[item.id] = curItemInfo
    -- 更新背包道具数量
    self.bagUI.bagTileScrollView:RefreshItemCountByIndex(self.bagItemIndex[self.putItem.id].index)
    if not curItemInfo then
        self.bagItemIndex[item.id] = nil
    end
    self:SmelterItemChange({ eventData })
end

---熔炉放到背包
function this:SmelterToBagItem_Out(itemId, putCount)
    if self.isPreview then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SYNTHESIS_PUT_BAG, itemId)
        return
    end
    local curItemInfo = self.smelterItems[itemId]
    if self.selectTab < 3 then
        local itemCfg = SL:GetConfig('cfg_item', curItemInfo.item.cfgId)
        if itemCfg.type == E_ItemType.Equip then
            -- 清空熔炉
            self:ClearSmelter()
            return
        end
    end
    putCount = putCount or 1
    local count = putCount
    for i = #self.putList, 1, -1 do
        if self.putList[i].id == itemId then
            if self.putList[i].count > count then
                self.putList[i].count = self.putList[i].count - count
            else
                count = count - self.putList[i].count
                table.remove(self.putList, i)
            end
        end
    end
    local eventData = {}
    -- SL:LogError("curItemInfo", curItemInfo, curItemInfo.item.count, putCount,curItemInfo.item.count > putCount)
    if curItemInfo and curItemInfo.item.count > putCount then
        curItemInfo.item.count = curItemInfo.item.count - putCount
        eventData = { curItemInfo }
    else
        -- SL:LogError("哦欸")
        eventData = { { index = self.smelterItems[itemId].index } }
        curItemInfo = nil
    end
    self.smelterItems[itemId] = curItemInfo
    self:SmelterItemChange(eventData)
    -- 更新背包道具数量
    self.bagUI.bagTileScrollView:RefreshItemCountByIndex(self.bagItemIndex[itemId].index)
    if not curItemInfo then
        self.bagItemIndex[itemId] = nil
    end
end

---检查道具是否符合要求
function this:CheckItem(item, count)
    local itemCfg = SL:GetConfig("cfg_item", item.cfgId)
    if self.selectTab < 3 then -- 1-2是装备强化，要特殊处理
        local equip
        -- 检查熔炉是否放入了装备
        for i, v in pairs(self.smelterItems) do
            local cfg = SL:GetConfig("cfg_item", v.item.cfgId)
            if cfg.type == 2 then
                equip = v.item
                break
            end
        end
        if itemCfg.type == 2 then
            if equip then -- 熔炉已经放入了装备，不能再放装备
                return false
            end
            -- 检查装备是否能被强化or追加
            if self.selectTab == 1 then
                if not SL:HasConfig("cfg_equip_strengthen", item.cfgId) then
                    return false
                end
                ---@type cfg_equip_strengthen_column
                local strengthenCfg = SL:GetConfig("cfg_equip_strengthen", item.cfgId)
                ---@type cfg_equip_strengthenCost_column
                local strengthenCostCfg = SL:GetConfigTwoKeys("cfg_equip_strengthenCost", strengthenCfg.costId,
                    EquipFunc.GetEquipStrengthLevel(item) + 1, "costGroupId", "level")
                if strengthenCostCfg == nil then -- 装备强化等级到上限了
                    return false, "装备强化等级已到上限"
                end
                if strengthenCostCfg.muneType == 1 then
                    return false
                end
            end
            if self.selectTab == 2 then
                if not SL:GetConfig("cfg_equip_appends", item.cfgId) then
                    return false
                end
                ---@type cfg_equip_appends_column
                local appendCfg = SL:GetConfig("cfg_equip_appends", item.cfgId)
                ---@type cfg_equip_appendsCost_column
                local appendCostCfg = SL:GetConfigTwoKeys("cfg_equip_appendsCost", appendCfg.costId,
                    EquipFunc.GetEquipAppendLevel(item) + 1, "costGroupId", "level")
                if appendCostCfg == nil then -- 装备追加等级到上限了
                    return false, "装备追加等级已到上限"
                end
                if appendCostCfg.muneType == 1 then
                    return false
                end
            end
        else
            if equip == nil then -- 熔炉没有装备，不能放入非装备
                return false, "请先放入装备"
            end
            -- 检查其他道具是否能放进去
            if self.selectTab == 1 then
                ---@type cfg_equip_strengthen_column
                local strengthenCfg = SL:GetConfig("cfg_equip_strengthen", equip.cfgId)
                ---@type cfg_equip_strengthenCost_column
                local strengthenCostCfg = SL:GetConfigTwoKeys("cfg_equip_strengthenCost", strengthenCfg.costId,
                    EquipFunc.GetEquipStrengthLevel(equip) + 1, "costGroupId", "level")
                if strengthenCostCfg then
                    for i, v in pairs(strengthenCostCfg.cost) do
                        if GUIUtil.ItemEquals(v[1], item.cfgId) then
                            return true
                        end
                    end
                end
            else
                ---@type cfg_equip_appends_column
                local appendCfg = SL:GetConfig("cfg_equip_appends", equip.cfgId)
                ---@type cfg_equip_appendsCost_column
                local appendCostCfg = SL:GetConfigTwoKeys("cfg_equip_appendsCost", appendCfg.costId,
                    EquipFunc.GetEquipAppendLevel(equip) + 1, "costGroupId", "level")
                if appendCostCfg then
                    for i, v in pairs(appendCostCfg.cost) do
                        if GUIUtil.ItemEquals(v[1], item.cfgId) then
                            return true
                        end
                    end
                end
            end
            local cfg = self.synthesisCfgDatas[self.selectTab][1]
            for i, v in pairs(cfg.consumeItem2) do
                if GUIUtil.ItemEquals(v[2], item.cfgId) then
                    local result, tips = self:CheckConsumeItemLimitCount(v[2], count)
                    if not result then
                        return false, tips
                    end
                    return true
                end
            end

            return self:CheckItemLimit4(cfg, item, itemCfg)
        end
        return true
    end

    -- 检查是否满足配方需求
    local cfgs = self.synthesisCfgDatas[self.selectTab]
    ---@param v cfg_synthesis_column
    for i, v in pairs(cfgs) do
        -- 检查必要道具
        if self:CheckItemLimit(v, item, itemCfg) then
            return true
        end
        -- SL:LogError("formula", self.formula)
        if table.count(self.smelterItems) > 0 then
            -- 检查额外道具
            local result, tips = self:CheckItemLimit2(v, item, itemCfg, count)
            if result or tips ~= nil then
                return result, tips
            end
            -- 检查定向材料
            result, tips = self:CheckItemLimit3(v, item, itemCfg)
            if not result then
                result = self:CheckItemLimit4(v, item, itemCfg)
            end
            if result then
                return true
            else
                if tips then
                    return false, tips
                end
            end
        end
    end
    return false
end

---检查道具限制
---@param synthesisCfg cfg_synthesis_column
---@param itemCfg cfg_item_column
function this:CheckItemLimit(synthesisCfg, item, itemCfg)
    -- SL:LogError("CheckItemLimit", SL:JsonEncode(itemCfg))
    if itemCfg == nil then
        itemCfg = SL:GetConfig("cfg_item", item.cfgId)
    end
    if #synthesisCfg.consumeItem > 0 then
        for i, v in pairs(synthesisCfg.consumeItem) do
            if v[1] == 1 then
                if GUIUtil.ItemEquals(v[2], item.cfgId) then
                    return true
                end
                goto continue
            end
            -- SL:LogError("CheckItemLimit", SL:JsonEncode(v))
            if v[1] == 2 then
                if EquipFunc.GetEquipStrengthLevel(item) < v[2] then
                    --SL:LogError("strength", EquipFunc.GetEquipStrengthLevel(item), v[2])
                    goto continue
                end
                if EquipFunc.GetEquipAppendLevel(item) < v[3] then
                    --SL:LogError("append", EquipFunc.GetEquipAppendLevel(item), v[3])
                    goto continue
                end
                if v[4] ~= 99 and (itemCfg.Outstanding or 0) ~= v[4] then
                    --SL:LogError("outstanding", itemCfg.Outstanding, v[4])
                    goto continue
                end
                if v[5] == 5 then
                    if itemCfg.type ~= 2 or (itemCfg.subType ~= 10 and itemCfg.subType ~= 11 and itemCfg.subType ~= 12) then
                        --SL:LogError("subtype", itemCfg.subType, v[5])
                        goto continue
                    end
                else
                    if v[5] ~= 0 and (itemCfg.Mixtype or 0) ~= v[5] then
                        --SL:LogError("mixtype", itemCfg.Mixtype, v[5],SL:JsonEncode(itemCfg))
                        goto continue
                    end
                end
                if v[6] > 0 then
                    if not GUIUtil.ItemEquals(v[6], item.cfgId) then
                        --SL:LogError("itemEquals", v[6], item.cfgId)
                        goto continue
                    end
                end
                return true
            end

            if v[1] == 3 then
                if v[2] > 0 then
                    local strengthenLevel_ = EquipFunc.GetEquipStrengthLevel(item)
                    if strengthenLevel_ < v[2] then
                        goto continue
                    end
                end
                if v[3] > 0 then
                    local appendLevel = EquipFunc.GetEquipAppendLevel(item)
                    if appendLevel < v[3] then
                        goto continue
                    end
                end

                if v[4] ~= 99 and (itemCfg.Outstanding or 0) ~= v[4] then
                    --SL:LogError("outstanding", itemCfg.Outstanding, v[4])
                    goto continue
                end
                if v[5] == 5 then
                    if itemCfg.type ~= 2 or (itemCfg.subType ~= 10 and itemCfg.subType ~= 11 and itemCfg.subType ~= 12) then
                        --SL:LogError("subtype", itemCfg.subType, v[5])
                        goto continue
                    end
                else
                    if v[5] ~= 0 and (itemCfg.Mixtype or 0) ~= v[5] then
                        --SL:LogError("mixtype", itemCfg.Mixtype, v[5],SL:JsonEncode(itemCfg))
                        goto continue
                    end
                end
                if v[7] > 0 then
                    if not GUIUtil.ItemEquals(v[7], item.cfgId) then
                        --SL:LogError("itemEquals", v[6], item.cfgId)
                        goto continue
                    end
                end
                return true
            end
            ::continue::
        end
    end
    return false
end

---检查额外道具
---@param synthesisCfg cfg_synthesis_column
---@param item cfg_item_column
---@param itemCfg cfg_item_column
function this:CheckItemLimit2(synthesisCfg, item, itemCfg, count)
    if #synthesisCfg.consumeItem2 > 0 then
        for i, v in pairs(synthesisCfg.consumeItem2) do
            if v[1] == 1 then
                if GUIUtil.ItemEquals(v[2], item.cfgId) then
                    local result, tips = self:CheckConsumeItemLimitCount(v[2], count)
                    if not result then
                        return false, tips
                    end
                    return true
                end
                goto continue
            end
            if v[1] == 2 then
                if EquipFunc.GetEquipStrengthLevel(item) < v[2] then
                    -- SL:LogError("strength", EquipFunc.GetEquipStrengthLevel(item), v[2])
                    goto continue
                end
                if EquipFunc.GetEquipAppendLevel(item) < v[3] then
                    -- SL:LogError("append", EquipFunc.GetEquipAppendLevel(item), v[3])
                    goto continue
                end
                if v[4] ~= 99 and (itemCfg.Outstanding or 0) ~= v[4] then
                    -- SL:LogError("outstanding", item.Outstanding, v[4])
                    goto continue
                end
                if v[5] ~= 0 then
                    if v[5] == 5 then
                        if item.type ~= 2 or (itemCfg.subType ~= 10 and itemCfg.subType ~= 11 and itemCfg.subType ~= 12) then
                            -- SL:LogError("subtype", item.subType, v[5])
                            goto continue
                        end
                    else
                        if (itemCfg.Mixtype or 0) ~= v[5] then
                            -- SL:LogError("mixtype", item.Mixtype, v[5])
                            goto continue
                        end
                    end
                end

                return true
            end

            if v[1] == 3 then
                if v[2] > 0 then
                    local strengthenLevel_ = EquipFunc.GetEquipStrengthLevel(item)
                    if strengthenLevel_ < v[2] then
                        goto continue
                    end
                end
                if v[3] > 0 then
                    local appendLevel = EquipFunc.GetEquipAppendLevel(item)
                    if appendLevel < v[3] then
                        goto continue
                    end
                end
                if v[4] ~= 99 and (itemCfg.Outstanding or 0) ~= v[4] then
                    --SL:LogError("outstanding", itemCfg.Outstanding, v[4])
                    goto continue
                end
                if v[5] ~= 0 then
                    if v[5] == 5 then
                        if itemCfg.type ~= 2 or (itemCfg.subType ~= 10 and itemCfg.subType ~= 11 and itemCfg.subType ~= 12) then
                            --SL:LogError("subtype", itemCfg.subType, v[5])
                            goto continue
                        end
                    else
                        if v[5] ~= 0 and (itemCfg.Mixtype or 0) ~= v[5] then
                            --SL:LogError("mixtype", itemCfg.Mixtype, v[5],SL:JsonEncode(itemCfg))
                            goto continue
                        end
                    end
                end

                if v[7] > 0 then
                    if not GUIUtil.ItemEquals(v[7], item.cfgId) then
                        --SL:LogError("itemEquals", v[6], item.cfgId)
                        goto continue
                    end
                end
                return true
            end
            ::continue::
        end
    end
    return false
end

---检查额外道具限制数量
function this:CheckConsumeItemLimitCount(cfgId, count)
    for i, v in pairs(self.consumeItemLimitCount) do
        if GUIUtil.ItemEquals(i, cfgId) then
            local hasItem = false
            for _, k in pairs(self.extritems) do
                if GUIUtil.ItemEquals(k.itemConfigId, cfgId) then
                    if k.itemCount + count > v then
                        local itemCfg = SL:GetConfig("cfg_item", cfgId)
                        local str = SL:GetConfig("cfg_string", 62001).text
                        return false, string.format(str, tostring(v), itemCfg.name)
                    end
                    hasItem = true
                end
            end
            if not hasItem and count > v then
                local itemCfg = SL:GetConfig("cfg_item", cfgId)
                local str = SL:GetConfig("cfg_string", 62001).text
                return false, string.format(str, tostring(v), itemCfg.name)
            end
        end
    end
    return true
end

---获取限制数量
function this:GetConsumeItemLimitCount(cfgId)
    for i, v in pairs(self.consumeItemLimitCount) do
        if GUIUtil.ItemEquals(i, cfgId) then
            return v
        end
    end
    return 0
end

---检查定向材料
---@param synthesisCfg cfg_synthesis_column
---@param item cfg_item_column
---@param itemCfg cfg_item_column
function this:CheckItemLimit3(synthesisCfg, item, itemCfg)
    if #synthesisCfg.productId > 0 then
        for i, v in pairs(synthesisCfg.productId) do
            if GUIUtil.ItemEquals(v[4], item.cfgId) then
                if table.count(self.dingxia_items) > 0 then
                    return false, "定向材料已锁定"
                end
                return true
            end
        end
    end
    return false
end

---检查保护道具
---@param synthesisCfg cfg_synthesis_column
---@param item cfg_item_column
---@param itemCfg cfg_item_column
function this:CheckItemLimit4(synthesisCfg, item, itemCfg)
    if #synthesisCfg.protect > 0 then
        for i, v in pairs(synthesisCfg.protect) do
            if GUIUtil.ItemEquals(v, item.cfgId) then
                return true
            end
        end
    end
    return false
end

function this:CopySmelterItems()
    local newSmelterItems = {}
    for i, v in pairs(self.smelterItems) do
        newSmelterItems[i] = { index = v.index, item = { id = v.item.id, cfgId = v.item.cfgId, count = v.item.count, luaExtData = v.item.luaExtData } }
    end
    return newSmelterItems
end

---检查合成配方
function this:CheckFormula()
    local cfgs = self.synthesisCfgDatas[self.selectTab]

    -- 熔炉里没有装备
    if table.count(self.smelterItems) == 0 then
        GUI:Text_setText(self.view.Text_Tips, cfgs[1].descriptiondefault)
        GUI:Text_setText(self.view.Text_Tips2, "请先确定配方")
        --GUI:Text_setText(self.view.synthesisName, "")
        GUI:setVisible(self.view.Btn_LookPreview, false)
        GUI:setVisible(self.view.tishi, false)
        GUI:Text_setText(self.view.Text_SuccessRate, "0%")
        GUI:Text_setText(self.view.Text_ResultPreview, "合成：")
        self:RefreshCoinCost(nil)
        return
    end
    if self.selectTab < 3 then -- 装备追加强化
        local equip, equipItemCfg
        for _, itemInfo in pairs(self.smelterItems) do
            local item = itemInfo.item
            local cfg = SL:GetConfig("cfg_item", item.cfgId)
            if cfg.type == 2 then
                equip = item
                equipItemCfg = cfg
                break
            end
        end
        local canSynthesis = true
        self.minorCost = {}
        local equipIntensifyCfg, tips, targetLevel = 0
        local successRate = 0
        tips = string.format("<color=#E6E600>%s</color>", cfgs[1].typeName)
        if self.selectTab == 1 and equip then -- 检查强化合成
            ---@type cfg_equip_strengthen_column
            local strengthenCfg = SL:GetConfig("cfg_equip_strengthen", equip.cfgId)
            targetLevel = EquipFunc.GetEquipStrengthLevel(equip) + 1
            ---@type cfg_equip_strengthenCost_column
            equipIntensifyCfg = SL:GetConfigTwoKeys("cfg_equip_strengthenCost", strengthenCfg.costId, targetLevel,
                "costGroupId", "level")

            for k, itemInfo in pairs(self.smelterItems) do
                local item = itemInfo.item
                for i, v in pairs(equipIntensifyCfg.cost) do
                    if GUIUtil.ItemEquals(item.cfgId, v[1]) then
                        table.insert(self.minorCost, { cfgId = item.cfgId, count = item.count })
                        break
                    end
                end
            end
        elseif self.selectTab == 2 and equip then -- 检查追加合成
            ---@type cfg_equip_appends_column
            local appendCfg = SL:GetConfig("cfg_equip_appends", equip.cfgId)
            targetLevel = EquipFunc.GetEquipAppendLevel(equip) + 1
            ---@type cfg_equip_appendsCost_column
            equipIntensifyCfg = SL:GetConfigTwoKeys("cfg_equip_appendsCost", appendCfg.costId, targetLevel, "costGroupId",
                "level")

            for k, itemInfo in pairs(self.smelterItems) do
                local item = itemInfo.item
                for i, v in pairs(equipIntensifyCfg.cost) do
                    if GUIUtil.ItemEquals(item.cfgId, v[1]) then
                        table.insert(self.minorCost, { cfgId = item.cfgId, count = item.count })
                        break
                    end
                end
            end
        end

        successRate = self:RefreshOtherCost(cfgs[1], self:CopySmelterItems(self.smelterItems), "", 0)

        if equip and equipIntensifyCfg then
            for i, v in pairs(equipIntensifyCfg.cost) do
                local satisfies = self:GetItemCountBySmelter(v[1]) >= v[2]
                if canSynthesis and not satisfies then
                    canSynthesis = false
                end
                local cfg = SL:GetConfig("cfg_item", v[1])
                tips = string.format("%s\n<color=%s>%s x%d</color>", tips, satisfies and "#E6E600" or "#FF2323 ",
                    cfg.name, v[2])
            end
            if not string.isNullOrEmpty(equipIntensifyCfg.tips) then
                --tips = tips.. "\n\n\n" .. string.format("<color=#DF4BE8>%s</color>", equipIntensifyCfg.tips)
                if table.count(self.baohu_items) > 0 then
                    GUI:Text_setText(self.view.tishi, "本次失败装备保留，强化归零（道具保护）")
                else
                    GUI:Text_setText(self.view.tishi, equipIntensifyCfg.tips)
                end
                GUI:setVisible(self.view.tishi, true)
            end
            local rate = math.min(equipIntensifyCfg.rate + successRate, 10000) // 100
            local luckyRate = EquipFunc.GetEquipStrengthLuckyRate(equip)
            local luckyRateStr = luckyRate == 0 and "" or
                SL:GetColorText(string.format("（+%d%%）", luckyRate / 100), "#E27FE3")
            GUI:Text_setText(self.view.Text_SuccessRate,
                canSynthesis and
                tostring(rate) ..
                (table.count(cfgs[1].consumeItem2) > 0 and "%" .. luckyRateStr .. "(<color=#E6E600>上限100%</color>)" or "") or
                "0%")
        else
            tips = cfgs[1].descriptiondefault
            GUI:Text_setText(self.view.Text_SuccessRate, "0%")
        end

        self:RefreshCoinCost(canSynthesis and equipIntensifyCfg and equipIntensifyCfg.coincost or nil)
        self.equipInfo = canSynthesis and equip or nil
        if canSynthesis then
            GUI:Text_setText(self.view.Text_ResultPreview, "合成：" .. equipItemCfg.name .. " +" .. targetLevel)
        else
            GUI:Text_setText(self.view.Text_ResultPreview, "合成：")
        end
        GUI:setVisible(self.view.Btn_LookPreview, canSynthesis)
        GUI:Text_setText(self.view.Text_Tips, tips)
        return
    end
    -- SL:LogError("CheckFormula", table.count(self.smelterItems))
    if self.formula and self:CheckSingleFormulaProgress(self.formula) >= 1 then -- 如果有配方存在，并且还继续满足的话，继续使用这个配方
        self:RefreshFormula(self.formula, 1)
        return
    end
    -- 其他的配方
    ---@type cfg_synthesis_column
    local formula -- 进度最快的配方
    local maxProgress = 0
    ---@param v cfg_synthesis_column
    for i, v in pairs(cfgs) do
        -- 获取最大进度
        local progress = self:CheckSingleFormulaProgress(v)
        if maxProgress < progress then
            maxProgress = progress
            formula = v
        end
    end
    self:RefreshFormula(formula, maxProgress)
end

---@param formula cfg_synthesis_column
function this:RefreshFormula(formula, maxProgress)
    -- SL:LogError("RefreshFormula", formula, maxProgress)
    local consumeItemSuccessRate = 0
    if formula then
        self.consumeItems = {}
        local smelterItems = self:CopySmelterItems(self.smelterItems)
        -- SL:LogTable(smelterItems,true,"smelterItems1")
        -- SL:LogError("RefreshFormula", table.count(smelterItems))
        --GUI:Text_setText(self.view.synthesisName, string.format("<color=#E6E600>(%s合成)</color>", formula.name))
        local tips = ""
        local putlist = table.copy(self.putList)
        -- SL:LogTable(putlist,true,"putlist")
        for k, v in pairs(formula.consumeItem) do
            if v[1] ~= 2 then
                goto continue1
            end
            local str = self:getFormulaType2Str(v)
            -- SL:LogError("str", str)
            local count = 0
            local id = 0
            local cfgId = 0
            local index = 0
            local count_limit = v[7] or 1
            local remmoveKey = {}
            for i = 1, #putlist do
                local iteminfo = smelterItems[putlist[i].id]
                local check = false
                if v[6] > 0 then
                    if GUIUtil.ItemEquals(iteminfo.item.cfgId, v[6]) and iteminfo.item.count > 0 then
                        check = true
                    end
                else
                    local strengthenLevel = v[2]
                    local appendLevel = v[3]
                    local quality = v[4]
                    local subType = v[5]
                    local item = iteminfo.item
                    local cfg = SL:GetConfig("cfg_item", item.cfgId)
                    --[[if cfg.type ~= 2 then
                        goto continue3
                    end]]
                    if strengthenLevel > 0 then
                        local strengthenLevel_ = EquipFunc.GetEquipStrengthLevel(item)
                        if strengthenLevel_ < strengthenLevel then
                            goto continue3
                        end
                    end

                    if appendLevel > 0 then
                        local appendLevel_ = EquipFunc.GetEquipAppendLevel(item)
                        if appendLevel_ < appendLevel then
                            goto continue3
                        end
                    end

                    if quality ~= 99 then
                        local quality_ = cfg.Outstanding or 0
                        if quality_ ~= quality then
                            goto continue3
                        end
                    end

                    if subType ~= 0 then
                        local subType_ = cfg.Mixtype or 0
                        if subType == 5 then
                            if cfg.type ~= 2 and (cfg.subType ~= 10 or cfg.subType ~= 11 or cfg.subType ~= 12) then
                                goto continue3
                            end
                        else
                            if subType_ ~= subType then
                                goto continue3
                            end
                        end
                    end
                    check = true
                end
                if not check then
                    goto continue3
                end
                count = count + putlist[i].count
                if count > count_limit then
                    putlist[i].count = putlist[i].count - (count - count_limit)
                    iteminfo.item.count = iteminfo.item.count - (count - count_limit)
                    count = count_limit
                else
                    remmoveKey[i] = true
                    iteminfo.item.count = iteminfo.item.count - putlist[i].count
                end
                id = iteminfo.item.id
                cfgId = iteminfo.item.cfgId
                index = iteminfo.index
                if count >= count_limit then
                    break
                end
                ::continue3::
            end
            if count > 0 then
                self.consumeItems[id] = {
                    id = id,
                    itemCount = count,
                    itemConfigId = cfgId,
                    itemIndex = index,
                };
            end
            for i, v in pairs(remmoveKey) do
                table.remove(putlist, i)
            end
            tips = string.format("%s<color=%s>%s:%d/%d</color>\n", tips, count >= count_limit and "#E6E600" or "#FF2323",
                str, count, count_limit)
            ::continue1::
        end
        -- SL:LogError("tips", tips)
        --    SL:LogTable(putlist,true,"putlist")
        for i, v in pairs(formula.consumeItem) do
            if v[1] ~= 1 then
                goto continue2
            end
            local cfg = SL:GetConfig("cfg_item", v[2])
            local count = 0
            local id = 0;
            local index = 0
            local cfgId = v[2]
            for i = 1, #putlist do
                local iteminfo = smelterItems[putlist[i].id]
                -- SL:LogTable(iteminfo,true)
                -- SL:LogError("iteminfo.item.cfgId", iteminfo.item.cfgId, v[1],GUIUtil.ItemEquals(iteminfo.item.cfgId, v[1]))
                if GUIUtil.ItemEquals(iteminfo.item.cfgId, v[2]) and iteminfo.item.count > 0 then
                    id = iteminfo.item.id
                    index = iteminfo.index
                    cfgId = iteminfo.item.cfgId
                    --count = count + putlist[i].count
                    self.consumeItems[id] = {
                        id = id,
                        itemConfigId = cfgId,
                        itemIndex = index,
                    }
                    if count + iteminfo.item.count > v[3] then
                        --[[iteminfo.item.count = iteminfo.item.count - (count-v[3])
                        count = math.min(count, v[3])]]
                        local num = v[3] - count
                        iteminfo.item.count = iteminfo.item.count - num
                        count = v[3]
                        self.consumeItems[id].itemCount = num
                    else
                        --iteminfo.item.count = iteminfo.item.count - putlist[i].count
                        self.consumeItems[id].itemCount = iteminfo.item.count
                        count = count + iteminfo.item.count
                        iteminfo.item.count = 0
                    end
                    if count >= v[3] then
                        break
                    end
                end
            end
            --[[if count > 0 then
                self.consumeItems[id] = {
                    id = id,
                    itemCount = count,
                    itemConfigId = cfgId,
                    itemIndex = index;
                }
            end]]
            tips = string.format("%s<color=%s>%s:%d/%d</color>\n", tips, count >= v[3] and "#E6E600" or "#FF2323",
                cfg.name, count, v[3])
            ::continue2::
        end
        -- 类型三
        for i, v in pairs(formula.consumeItem) do
            if v[1] ~= 3 then
                goto continue4
            end

            local count = 0
            for i = 1, #putlist do
                local iteminfo = smelterItems[putlist[i].id]
                local itemCfg = SL:GetConfig("cfg_item", iteminfo.item.cfgId)
                if v[4] ~= 99 and (itemCfg.Outstanding or 0) ~= v[4] then
                    goto continue5
                end
                if v[2] > 0 then
                    local strengthenLevel_ = EquipFunc.GetEquipStrengthLevel(iteminfo.item)
                    if strengthenLevel_ < v[2] then
                        goto continue5
                    end
                end
                if v[3] > 0 then
                    local appendLevel = EquipFunc.GetEquipAppendLevel(iteminfo.item)
                    if appendLevel < v[3] then
                        goto continue5
                    end
                end
                if v[5] == 5 then
                    if itemCfg.type ~= 2 or (itemCfg.subType ~= 10 and itemCfg.subType ~= 11 and itemCfg.subType ~= 12) then
                        --SL:LogError("subtype", itemCfg.subType, v[5])
                        goto continue5
                    end
                else
                    if v[5] ~= 0 and (itemCfg.Mixtype or 0) ~= v[5] then
                        --SL:LogError("mixtype", itemCfg.Mixtype, v[5],SL:JsonEncode(itemCfg))
                        goto continue5
                    end
                end
                if v[7] > 0 then
                    if not GUIUtil.ItemEquals(v[7], itemCfg.id) then
                        --SL:LogError("itemEquals", v[6], item.cfgId)
                        goto continue5
                    end
                end

                count = count + iteminfo.item.count
                self.consumeItems[iteminfo.item.id] = {
                    id = iteminfo.item.id,
                    itemConfigId = iteminfo.item.cfgId,
                    itemIndex = iteminfo.index,
                    itemCount = iteminfo.item.count,
                }
                ---@type cfg_synthesisRateGroup_column
                local rateGroupCfg = SL:GetConfig("cfg_synthesisRateGroup", v[6])


                local strengthenLevel_ = EquipFunc.GetEquipStrengthLevel(iteminfo.item)
                for k, v in pairs(rateGroupCfg.strengthenRate) do
                    if strengthenLevel_ >= v[1] and strengthenLevel_ <= v[2] then
                        consumeItemSuccessRate = consumeItemSuccessRate + v[3]
                        break
                    end
                end
                local appendLevel_ = EquipFunc.GetEquipAppendLevel(iteminfo.item)
                for k, v in pairs(rateGroupCfg.appendsRate) do
                    if appendLevel_ >= v[1] and appendLevel_ <= v[2] then
                        consumeItemSuccessRate = consumeItemSuccessRate + v[3]
                        break
                    end
                end
                local equipEntrys = SL:GetEquipValue("EQUIP_ENTRY_ATTR", "bag", iteminfo.item.cfgId, iteminfo.item.id)
                if not table.isNullOrEmpty(equipEntrys) then
                    local equipEntry = {}
                    for k, v in pairs(equipEntrys) do
                        equipEntry[v.type] = v.num
                    end
                    for k, v in pairs(rateGroupCfg.attRate) do
                        if equipEntry[v[1]] and equipEntry[v[1]] >= v[2] and equipEntry[v[1]] <= v[3] then
                            consumeItemSuccessRate = consumeItemSuccessRate + v[4]
                        end
                    end
                end


                if count >= v[8] then
                    break
                end
                ::continue5::
            end
            local str = self:getFormulaType3Str(v)
            tips = string.format("%s<color=%s>%s:%d/%d</color>\n", tips, count >= v[8] and "#E6E600" or "#FF2323", str,
                count, v[8])
            ::continue4::
        end
        -- SL:LogError("tips", tips)
        -- SL:LogTable(self.consumeItems,true,"consumeItems")
        GUI:Text_setText(self.view.Text_Tips, tips)
        self.dingxia_items = {}
        local tips2 = ""
        if #formula.productId > 0 then
            local dingxing_str = ""
            local have_cfg = false
            for i, v in pairs(formula.productId) do
                if v[4] then
                    have_cfg = true
                    local cfg = SL:GetConfig("cfg_item", v[4])
                    local count, _, tbl = self:GetItemCountBySmelter(v[4], smelterItems, nil, self.dingxia_items)
                    if smelterItems and tbl.extritemsData then
                        smelterItems[tbl.extritemsData.id] = tbl.extritemsData
                    end
                    -- SL:LogError("dingxia_items", v[4],count)
                    dingxing_str = string.format("%s<color=%s>%s(锁定合成结果)</color>\n", dingxing_str,
                        count >= 1 and "#E6E600" or "#FF2323", cfg.name)
                end
            end
            if have_cfg then
                tips2 = tips2 .. dingxing_str
            end
        end
        -- SL:LogTable(smelterItems,true,"smelterItems2")
        local successRate = self:RefreshOtherCost(formula, smelterItems, tips2,
            consumeItemSuccessRate + formula.successRate)
        if #formula.fail > 0 then
            if table.count(self.baohu_items) == 0 then
                if formula.fail[1] == 0 and formula.fail[2] == 0 then
                    GUI:Text_setText(self.view.tishi, "失败后，投入装备强化追加等级清零")
                else
                    GUI:Text_setText(self.view.tishi,
                        string.format("失败后，装备强化等级降为%d级，追加等级降为%d级", formula.fail[1], formula.fail[2]))
                end
            else
                GUI:Text_setText(self.view.tishi, SL:GetConfig("cfg_string", 55001).text)
            end
        else
            GUI:Text_setText(self.view.tishi, "失败后，原先的合成材料会全部消失")
        end
        GUI:setVisible(self.view.tishi, true)
        -- SL:LogError("maxProgress", maxProgress, formula)
        if maxProgress >= 1 then -- 有配方满足
            self.formula = formula
            -- 刷新成功率和消耗显示
            local rate = math.min(successRate, tonumber(formula.successRateMax)) // 100
            -- SL:LogError("rate", rate, formula.successRate, successRate, formula.successRateMax)
            GUI:Text_setText(self.view.Text_SuccessRate,
                rate .. "%(<color=#E6E600>上限" .. (formula.successRateMax // 100) .. "%</color>)")
            self:RefreshCoinCost(formula.coin)
        else
            GUI:Text_setText(self.view.Text_SuccessRate, "0%")
            self.formula = nil
        end
    end

    --- 刷新合成预览装备
    local showPreview = self.formula and #self.formula.productId > 0
    if showPreview then
        if #self.formula.productId == 1 then
            local cfg = SL:GetConfig("cfg_item", self.formula.productId[1][1])
            GUI:Text_setText(self.view.Text_ResultPreview, "合成：" .. cfg.name)
        else
            GUI:Text_setText(self.view.Text_ResultPreview, "合成：" .. self.formula.typeName)
        end
    else
        GUI:Text_setText(self.view.Text_ResultPreview, "合成：")
    end
    GUI:setVisible(self.view.Btn_LookPreview, showPreview)
end

function this:RefreshOtherCost(formula, smelterItems, tips2, successRate)
    self.extritems = {}
    local type1 = {}
    local type2 = {}
    local type3 = {}
    local type1InfoList = {}
    local type2InfoList = {}
    local type3InfoList = {}
    local specialConsumeRate = 0
    for i, v in pairs(formula.consumeItem2) do
        if v[1] == 2 then
            local count, _, tempType2 = self:GetItemCountBySmelter2(v, smelterItems, self.extritems, formula)
            table.insert(type2InfoList, { name = self:getFormulaType2Str(v), hasItem = count > 0 })
            for k, vv in pairs(tempType2 or {}) do
                type2[k] = vv
            end
        elseif v[1] == 3 then
            local count, _, tempType3 = self:GetItemCountBySmelter3(v, smelterItems, self.extritems, formula)
            table.insert(type3InfoList, { name = self:getFormulaType3Str(v), hasItem = count > 0 })
            for k, vv in pairs(tempType3 or {}) do
                type3[k] = vv
            end
        else
            local cfg = SL:GetConfig("cfg_item", v[2])
            local count, _, tempType1 = self:GetItemCountBySmelter(v[2], smelterItems, nil, self.extritems, formula,
                v[3])
            table.insert(type1InfoList, { name = cfg.name, hasItem = count > 0 })
            for k, vv in pairs(tempType1 or {}) do
                type1[k] = vv
            end
        end
    end
    self.specialConsumeRateMax = formula.specialConsumeRateMax or 0
    do
        local merged = {}
        local temp3 = {}
        local noAdd = {}
        -- 去重
        local function mergeType(tbl, ttype)
            if tbl ~= nil then
                for k, v in pairs(tbl) do
                    if merged[k] == nil or v.successRate > merged[k].value.successRate then
                        merged[k] = { value = v, type = ttype }
                    end
                end
            end
        end
        mergeType(type1, 1)
        mergeType(type2, 2)
        mergeType(type3, 3)
        for _, v in pairs(merged) do
            table.insert(temp3, v)
        end
        -- 排序
        table.sort(temp3, function(a, b)
            return a.value.successRate > b.value.successRate
        end)
        local _successRate = successRate
        for i = 1, #temp3 do
            if _successRate < tonumber(formula.successRateMax) then
                _successRate = _successRate + temp3[i].value.successRate
            else
                table.insert(noAdd, temp3[i].value.extritemsData.id)
            end
        end
        local successRate_ = 0
        for _, entry in pairs(merged) do
            successRate_ = successRate_ + entry.value.successRate
            if not table.contains(noAdd, entry.value.extritemsData.id) then
                self.extritems[entry.value.extritemsData.id] = entry.value.extritemsData
            end
        end
        if successRate_ >= formula.specialConsumeRateMax and formula.specialConsumeRateMax > 0 then
            successRate_ = formula.specialConsumeRateMax
        end
        successRate = successRate + successRate_
        for _, info in ipairs(type1InfoList) do
            tips2 = string.format("%s<color=%s>%s(增加成功率)</color>\n", tips2,
                info.hasItem and "#E6E600" or "#FF2323", info.name)
        end
        for _, info in ipairs(type2InfoList) do
            tips2 = string.format("%s<color=%s>%s(增加成功率)</color>\n", tips2,
                info.hasItem and "#E6E600" or "#FF2323", info.name)
        end
        for _, info in ipairs(type3InfoList) do
            tips2 = string.format("%s<color=%s>%s(增加成功率)</color>\n", tips2,
                info.hasItem and "#E6E600" or "#FF2323", info.name)
        end
    end


    self.baohu_items = {}
    if #formula.protect > 0 then
        local baohu_str = ""
        for i, v in pairs(formula.protect) do
            local cfg = SL:GetConfig("cfg_item", v)
            local count, _, tbl = self:GetItemCountBySmelter(v, smelterItems, nil, self.baohu_items)
            if smelterItems and tbl.extritemsData then
                smelterItems[tbl.extritemsData.id] = tbl.extritemsData
            end
            baohu_str = string.format("%s<color=%s>%s(合成保护道具)</color>\n", baohu_str,
                count >= 1 and "#E6E600" or "#FF2323", cfg.name)
        end
        tips2 = tips2 .. baohu_str
    end

    -- tips = tips.. "\n\n\n" .. "<color=#DF4BE8>失败时，原先的合成材料会全部消失</color>"
    -- 刷新配方显示
    GUI:Text_setText(self.view.Text_Tips2, tips2)
    return successRate
end

function this:getFormulaType2Str(v)
    -- SL:LogError("getFormulaType2Str", SL:JsonEncode(v))
    local str = ""
    if v[4] == 0 then
        str = str .. "白装"
    elseif v[4] == 1 then
        str = str .. "卓越"
    elseif v[4] == 2 then
        str = str .. "套装"
    elseif v[4] == 99 then
        -- str = str .. " 任意"
    end

    if v[5] > 0 then
        if v[5] == 1 then
            str = str .. "1代翅膀"
        elseif v[5] == 2 then
            str = str .. "2代翅膀"
        elseif v[5] == 3 then
            str = str .. "3代翅膀"
        elseif v[5] == 4 then
            str = str .. "套装"
        elseif v[5] == 5 then
            str = str .. "首饰"
        elseif v[5] == 6 then
            str = str .. "玛雅武器"
        elseif v[5] == 7 then
            str = str .. "2.5代翅膀材料"
        elseif v[5] == 380 then
            str = str .. "380装备"
        else
            str = str .. "其他"
        end
    else
        if v[6] > 0 then
            local cfg = SL:GetConfig("cfg_item", v[6])
            str = str .. cfg.name
            -- count = self:GetItemCountBySmelter(v[6],smelterItems,nil, nil,formula)
            -- SL:LogError("successRate_1", count,successRate_)
        else
            str = str .. "任意装备"
            -- count = self:GetItemCountBySmelter2(v,smelterItems,nil,formula)
            -- SL:LogError("successRate_2", count,successRate_)
        end
    end
    if v[2] > 0 then
        str = str .. " +" .. v[2]
    end
    if v[3] > 0 then
        -- SL:LogError("v[3]", v[3])
        str = str .. " z" .. tonumber(v[3]) * 4
    end
    return str
end

function this:getFormulaType3Str(v)
    -- SL:LogError("getFormulaType2Str", SL:JsonEncode(v))
    local str = ""
    if v[4] == 0 then
        str = str .. "白装"
    elseif v[4] == 1 then
        str = str .. "卓越"
    elseif v[4] == 2 then
        str = str .. "套装"
    elseif v[4] == 99 then
        -- str = str .. " 任意"
    end

    if v[5] > 0 then
        if v[5] == 1 then
            str = str .. "1代翅膀"
        elseif v[5] == 2 then
            str = str .. "2代翅膀"
        elseif v[5] == 3 then
            str = str .. "3代翅膀"
        elseif v[5] == 4 then
            str = str .. "套装"
        elseif v[5] == 5 then
            str = str .. "首饰"
        elseif v[5] == 6 then
            str = str .. "玛雅武器"
        elseif v[5] == 7 then
            str = str .. "2.5代翅膀材料"
        elseif v[5] == 380 then
            str = str .. "380装备"
        else
            str = str .. "其他"
        end
    else
        if v[7] > 0 then
            local cfg = SL:GetConfig("cfg_item", v[7])
            str = str .. cfg.name
            -- count = self:GetItemCountBySmelter(v[6],smelterItems,nil, nil,formula)
            -- SL:LogError("successRate_1", count,successRate_)
        else
            str = str .. "任意装备"
            -- count = self:GetItemCountBySmelter2(v,smelterItems,nil,formula)
            -- SL:LogError("successRate_2", count,successRate_)
        end
    end
    if v[2] > 0 then
        str = str .. " +" .. v[2]
    end
    if v[3] > 0 then
        -- SL:LogError("v[3]", v[3])
        str = str .. " z" .. tonumber(v[3]) * 4
    end
    return str
end

---检查单个配方进度
---@param cfg cfg_synthesis_column
function this:CheckSingleFormulaProgress(cfg)
    -- 计算需要道具总数
    local needTotal = 0
    local consumeData = {}
    for _, consume in pairs(cfg.consumeItem) do
        if consume[1] == 1 then
            needTotal = needTotal + consume[3]
            consumeData[consume[2]] = consume[3]
        end
        if consume[1] == 2 then
            needTotal = needTotal + consume[7] or 1
            if consume[6] and consume[6] > 0 then
                consumeData[consume[6]] = consume[7] or 1
            else
                consumeData["非指定大类"] = consume[7] or 1
            end
        end
        if consume[1] == 3 then
            needTotal = needTotal + consume[8] or 1
            if consume[7] and consume[7] > 0 then
                consumeData[consume[7]] = consume[8] or 1
            else
                consumeData["非指定大类"] = consume[8] or 1
            end
        end
    end

    local count = 0
    for _, itemInfo in pairs(self.smelterItems) do
        local item = itemInfo.item
        -- 检查是否满足道具限制
        if self:CheckItemLimit(cfg, item) then
            local bindEqualItem = self:GetSynthesisItemBindCfgId(item.cfgId)
            -- 减去相应的道具消耗
            local consumeCount = consumeData[item.cfgId] or consumeData[bindEqualItem] or consumeData["非指定大类"]
            if consumeCount and consumeCount > 0 then
                local consumeCfgId = (consumeData[item.cfgId] and item.cfgId) or (bindEqualItem and bindEqualItem) or
                    "非指定大类"
                if item.count >= consumeCount then
                    count = count + consumeCount
                    consumeData[consumeCfgId] = 0
                else
                    count = count + item.count
                    consumeData[consumeCfgId] = consumeCount - item.count
                end
            end
        end
    end

    return count / needTotal
end

function this:GetSynthesisItemBindCfgId(item_cfg_Id)
    if item_cfg_Id == 50030002 then
        return 1253000299
    elseif item_cfg_Id == 50030004 then
        return 1253000499
    elseif item_cfg_Id == 50030003 then
        return 1253000399
    elseif item_cfg_Id == 1253000299 then
        return 50030002
    elseif item_cfg_Id == 1253000499 then
        return 50030004
    elseif item_cfg_Id == 1253000399 then
        return 50030003
    end
    local cfg = SL:GetConfig("cfg_item", item_cfg_Id) or {}
    return cfg.bindEqualItem or 0
end

---获取熔炉内物品数量
function this:GetItemCountBySmelter(cfgId, smelterItems, count_limit, extritems, formula, addSuccessRate)
    local is_copy = false
    if smelterItems ~= nil then
        is_copy = true
    end
    smelterItems = smelterItems or self.smelterItems

    local count = 0
    local successRate = 0
    local type1 = {}
    for i, v in pairs(smelterItems) do
        if GUIUtil.ItemEquals(v.item.cfgId, cfgId) and v.item.count > 0 then
            count = count + v.item.count
            local successRate_ = (addSuccessRate or 0)
            if extritems then
                -- if successRate == 0 then
                --     successRate = EquipFunc.getItemSuccessRate(formula, cfgId, v.item)
                -- end
                -- SL:LogError("count_", v.item.count)

                local data = {
                    id = v.item.id,
                    itemCount = v.item.count,
                    itemConfigId = v.item.cfgId,
                    itemIndex = v.index,
                    successRate = successRate_
                }
                type1[v.item.id] = { count = v.item.count, successRate = successRate_ * v.item.count, extritemsData =
                data }
            end
            successRate = successRate + successRate_
        end
    end
    return count, successRate, type1
end

---获取熔炉内物品数量2
function this:GetItemCountBySmelter2(condition, smelterItems, extritems, formula)
    local is_copy = false
    local type2 = {}
    if smelterItems ~= nil then
        is_copy = true
    end
    smelterItems = smelterItems or self.smelterItems
    local strengthenLevel = condition[2]
    local appendLevel = condition[3]
    local quality = condition[4]
    local subType = condition[5]
    local count = 0
    local successRate = 0
    for i, v in pairs(smelterItems) do
        if v.item.count <= 0 then
            goto continue
        end
        local item = v.item
        local cfg = SL:GetConfig("cfg_item", item.cfgId)
        if self.consumeItems[v.item.id] ~= nil then
            goto continue
        end
        if cfg.type ~= 2 then
            -- SL:LogError("equip", item.cfgId, cfg.type)
            goto continue
        end
        local strengthenLevel_ = EquipFunc.GetEquipStrengthLevel(item)
        if strengthenLevel_ < strengthenLevel then
            -- SL:LogError("strengthenLevel", strengthenLevel_, strengthenLevel)
            goto continue
        end
        local appendLevel_ = EquipFunc.GetEquipAppendLevel(item)
        if appendLevel_ < appendLevel then
            -- SL:LogError("appendLevel", appendLevel_, appendLevel)
            goto continue
        end
        local quality_ = cfg.Outstanding or 0
        if quality ~= 99 and quality_ ~= quality then
            -- SL:LogError("quality", quality_, quality)
            goto continue
        end
        local subType_ = item.Mixtype or 0
        if subType == 5 then
            if cfg.type ~= 2 and (cfg.subType ~= 10 or cfg.subType ~= 11 or cfg.subType ~= 12) then
                -- SL:LogError("subType", cfg.subType, subType)
                goto continue
            end
        else
            if subType_ ~= 0 and subType_ ~= subType then
                -- SL:LogError("subType", subType_, subType)
                goto continue
            end
        end
        count = count + item.count
        if extritems then
            local data = {
                id = v.item.id,
                itemCount = v.item.count,
                itemConfigId = v.item.cfgId,
                itemIndex = v.index,
                successRate = condition[7] * v.item.count
            }
            type2[item.id] = { count = item.count, successRate = condition[7] * v.item.count, extritemsData = data }
        end
        successRate = successRate + condition[7] * v.item
            .count --EquipFunc.getItemSuccessRate(formula, item.cfgId, item)
        -- SL:LogError("successRate_4", count,successRate)
        :: continue ::
    end
    return count, successRate, type2
end

---获取熔炉内物品数量3
function this:GetItemCountBySmelter3(condition, smelterItems, extritems, formula)
    local type3 = {}
    local is_copy = false
    if smelterItems ~= nil then
        is_copy = true
    end
    smelterItems = smelterItems or self.smelterItems
    local rateGroup = condition[6]
    ---@type cfg_synthesisRateGroup_column
    local rateGroupCfg = SL:GetConfig("cfg_synthesisRateGroup", rateGroup)
    local count = 0
    local successRate = 0
    for i, v in pairs(smelterItems) do
        if self.consumeItems[v.item.id] ~= nil then
            goto continue
        end
        if v.item.count <= 0 then
            goto continue
        end

        local item = v.item
        local itemCfg = SL:GetConfig("cfg_item", item.cfgId)
        if condition[4] ~= 99 and (itemCfg.Outstanding or 0) ~= condition[4] then
            --SL:LogError("outstanding", itemCfg.Outstanding, v[4])
            goto continue
        end
        if condition[5] == 5 then
            if itemCfg.type ~= 2 or (itemCfg.subType ~= 10 and itemCfg.subType ~= 11 and itemCfg.subType ~= 12) then
                --SL:LogError("subtype", itemCfg.subType, v[5])
                goto continue
            end
        else
            if condition[5] ~= 0 and (itemCfg.Mixtype or 0) ~= condition[5] then
                --SL:LogError("mixtype", itemCfg.Mixtype, v[5],SL:JsonEncode(itemCfg))
                goto continue
            end
        end
        if condition[7] > 0 then
            if not GUIUtil.ItemEquals(condition[7], item.cfgId) then
                --SL:LogError("itemEquals", v[6], item.cfgId)
                goto continue
            end
        end

        local strengthenLevel_ = EquipFunc.GetEquipStrengthLevel(item)
        if strengthenLevel_ < condition[2] then
            goto continue
        end
        local appendLevel_ = EquipFunc.GetEquipAppendLevel(item)
        if appendLevel_ < condition[3] then
            goto continue
        end
        local rate = 0
        for k, cfgRate in pairs(rateGroupCfg.strengthenRate) do
            if strengthenLevel_ >= cfgRate[1] and strengthenLevel_ <= cfgRate[2] then
                rate = rate + cfgRate[3]
                break
            end
        end
        for k, cfgRate in pairs(rateGroupCfg.appendsRate) do
            if appendLevel_ >= cfgRate[1] and appendLevel_ <= cfgRate[2] then
                rate = rate + cfgRate[3]
                break
            end
        end
        local equipEntrys = SL:GetEquipValue("EQUIP_ENTRY_ATTR", "bag", item.cfgId, item.id)
        if not table.isNullOrEmpty(equipEntrys) then
            local equipEntry = {}
            for k, cfgRate in pairs(equipEntrys) do
                equipEntry[cfgRate] = cfgRate.num
            end
            for k, cfgRate in pairs(rateGroupCfg.attRate) do
                if equipEntry[cfgRate] and equipEntry[cfgRate] >= cfgRate[2] and equipEntry[cfgRate] <= cfgRate[3] then
                    rate = rate + cfgRate[4]
                end
            end
        end
        rate = rate + condition[8] or 0
        successRate = successRate + rate
        count = count + item.count
        if extritems then
            local data = {
                id = v.item.id,
                itemCount = v.item.count,
                itemConfigId = v.item.cfgId,
                itemIndex = v.index,
                successRate = rate
            }
            type3[item.id] = { count = item.count, successRate = rate, extritemsData = data }
        end

        :: continue ::
    end
    return count, successRate, type3
end

---刷新金币消耗
function this:RefreshCoinCost(coinCost)
    self.coinCost = coinCost
    if table.isNullOrEmpty(coinCost) then
        GUI:Text_setText(self.view.Text_CostName, "消耗金币")
        GUI:Text_setText(self.view.Text_CostValue, "0")
        GUI:Text_setTextColor(self.view.Text_CostValue, "#")
        return
    end
    local cfg = SL:GetConfig("cfg_item", coinCost[1])
    GUI:Text_setText(self.view.Text_CostName, "消耗" .. cfg.name)
    GUI:Text_setText(self.view.Text_CostValue, tostring(coinCost[2]))
    GUI:Text_setTextColor(self.view.Text_CostValue,
        SL:GetBagItemCount(coinCost[1]) < coinCost[2] and "#F33841" or "#FF2323 ")
end

---清空熔炉
function this:ClearSmelter()
    if table.count(self.smelterItems) == 0 then
        self:CheckFormula()
        return
    end
    local itemInfo = {}
    local bagIndexs = {}
    for i, v in pairs(self.smelterItems) do
        table.insert(itemInfo, { index = v.index })
        table.insert(bagIndexs, self.bagItemIndex[i].index)
    end
    table.clear(self.smelterItems)
    table.clear(self.bagItemIndex)
    table.clear(self.putList)
    for i, v in pairs(bagIndexs) do
        self.bagUI.bagTileScrollView:RefreshItemCountByIndex(v)
    end
    self.formula = nil
    self:RefreshCoinCost()
    GUI:Text_setText(self.view.Text_SuccessRate, "0%")
    self:SmelterItemChange(itemInfo, true)
end

---合成结果全部返回背包
function this:ResultBackToBag()
    if table.count(self.synthesisResult) > 0 then
        for i, v in pairs(self.synthesisResult) do
            self:SmelterToBagItem_Out(i)
        end
        self.isPreview = false
    end
end

---移动道具
function this:MoveItem(oldIndex, newIndex, item)
    SL:LogError("放置格子：", oldIndex, newIndex)
    if oldIndex == newIndex or self.isPreview then
        return
    end
    self.smelterItems[item.id].index = newIndex
    self:SmelterItemChange({ [1] = { index = oldIndex }, [2] = self.smelterItems[item.id] })
end

---熔炉物品改变
function this:SmelterItemChange(eventData, immediately)
    if immediately then
        self.bagTileScrollView:Item_Change(eventData)
    else
        SL:ScheduleOnce(0.02, function()
            self.bagTileScrollView:Item_Change(eventData)
        end)
    end

    self:CheckFormula()
    -- 更新使用格子
    self.useGridTable = {}
    for id, itemInfo in pairs(self.smelterItems) do
        local item = itemInfo.item
        local vetSize, horSize = self:GetItemSizeByCfgId(item.cfgId)
        local indexHor, indexVet = self.bagTileScrollView.GetHorAndVetWithInt(itemInfo.index)

        -- 循环嵌套得出物品格子使用情况
        for nowHor = indexHor, indexHor + horSize - 1 do
            for nowVet = indexVet, indexVet + vetSize - 1 do
                self.useGridTable[self.bagTileScrollView.GetIntWithHorAndVet(nowHor, nowVet)] = true
            end
        end
    end
end

---获取物品格子大小
function this:GetItemSizeByCfgId(cfgId)
    local item = SL:GetConfig("cfg_item", cfgId)
    if next(item.holdGrid) == nil then
        if item.id == 10020001 then -- 奇迹币
            return 2, 2
        end
        return 1, 1
    end

    return item.holdGrid[1], item.holdGrid[2]
end

---拖拽结束
function this:DragEnd(eventData)
    SL:LogError("放置格子：", eventData)
    if not eventData.canPut then
        return
    end
    local bagHor = eventData.bagPutHor
    local bagVet = eventData.bagPutVet
    local raycastObj = eventData.raycastObj
    local dragItem = eventData.dragItem
    local synthesisSmelterHor = eventData.synthesisSmelterHor
    local synthesisSmelterVet = eventData.synthesisSmelterVet

    -- 丢弃道具
    if raycastObj == nil then
        return
    end
    local oldIndex = eventData.index
    local bagMaxHor, bagMaxVet = SL:GetMetaValue(EMetaVarGetKey.GET_BAG_MAX_HOR_VERT)
    SL:LogError("放置格子：", bagHor <= bagMaxHor and bagHor > 0 and bagVet <= bagMaxVet and bagVet > 0 )
    if bagHor <= bagMaxHor and bagHor > 0 and bagVet <= bagMaxVet and bagVet > 0 then
        -- 放回背包
        local newIndex = self.bagTileScrollView.GetIntWithHorAndVet(bagHor, bagVet)
        -- self:SmelterToBagItem(oldIndex, newIndex, dragItem.item)
        self:ItemClick(nil, dragItem.item)
    else
        --local maxHor, maxVet = RoleManager.meData.storeHouseInfo:GetMaxHorAndVet()
        local maxHor = ESynthesisBagSize.H
        local maxVet = ESynthesisBagSize.V
        if synthesisSmelterHor and synthesisSmelterHor <= maxHor and synthesisSmelterHor > 0 and synthesisSmelterVet <= maxVet and synthesisSmelterVet > 0 then
            local newIndex = self.bagTileScrollView.GetIntWithHorAndVet(synthesisSmelterHor, synthesisSmelterVet)
            --移动了位置
            self:MoveItem(oldIndex, newIndex, dragItem.item)
        end
    end
end

function this:ItemClick(_, item, args)
    -- SL:LogError("item", item.cfgId, item.id)
    self.IsdragToSmelter = false
    self.smelter_putItem = item
    self.bagTileScrollView:RefreshFilterTagList({ [item.id] = 1 })
    -- if item.count == 1 and args == nil then
    --     self:SmelterToBagItem_Out(item.id)
    --     return
    -- end
    -- self.bagUI:RefreshFilterTagList({ [item.id] = 1 })
    -- self:SmelterToBagItem_Out(item.id, 1)
    self:SmelterToBagItem_Out(item.id, item.count)
    --SL:OpenTips("synthesis", item.cfgId, item.id, nil, self.smelter_putItem)
end

function this:itemOpenCallback(bagItem)
    -- 获取源控件的世界坐标
    --local worldPosX, worldPosY = GUI:GetWorldPosition(bagItem.view.empty)
    --SL:LogError(worldPosX, worldPosY)
    -- 直接转换到目标控件的本地坐标
    --local localPos = GUI:ConvertToNodeSpace(self.view.Smelter11, worldPosX, worldPosY)
    if not self.isPreview then
        return
    end
    if self.modelPreivewEff == nil then
        local data = {
            src = "Effect/UI/EFF_baoshanliuguang_cai",
            mscale = "1,1,1",
            --x = math.floor(localPos.x),
            --y = math.floor(localPos.y),
            zindex = "215",
            z = "-500"
        }
        self.modelPreivewEff = GUI:Model_Create(self.view.Smelter11, data)
    else
        GUI:setVisible(self.modelPreivewEff, false)
        GUI:setVisible(self.modelPreivewEff, true)
    end
    --SL:LogError(localPos.x, localPos.y)
    --GUI:setPosition(self.modelPreivewEff, math.floor(localPos.x), math.floor(localPos.y))
    GUI:SetParent(self.modelPreivewEff, GUI:GetRectTransform(bagItem.view.empty))
    GUI:setPosition(self.modelPreivewEff, 0, 0)
    GUI:setPositionZ(self.modelPreivewEff, -200)
    GUI:SetParent(self.modelPreivewEff, GUI:GetRectTransform(self.view.Smelter11), true)
    GUI:setScale(self.modelPreivewEff, 1)
end

---页签改变
function this:OnValueChange_TabTog(_, args, data)
    if data[1] then
        self.selectTab = args.type
        self:ClearSmelter()
        self:ResultBackToBag()
    end
end

---输入数量改变
function this:OnValueChange_Input_PutNum(_, args, data)
    local putCount = tonumber(data[1])
    if putCount == nil then
        putCount = 1
        GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
    else
        if putCount > self.putItem.count then
            putCount = self.putItem.count
            GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
        end
        if putCount < 1 then
            putCount = 1
            GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
        end
    end

    GUI:Slider_setPercent(self.view.Slider_PutNum, putCount)
end

---点击关闭按钮
function this:OnClick_Btn_Close()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    SL.ShowMainPanel()
end

---点击
function this:OnClick_Btn_LookPreview()
    if self.selectTab == 1 then
        EquipFunc.addStrengthLevel = 1
        SL:OpenTips("bag", self.equipInfo.cfgId, self.equipInfo.id, nil, nil, { hideBtn = true }, false, function()
            EquipFunc.addStrengthLevel = 0
        end)
        return
    end
    for i, v in pairs(self.dingxia_items) do
        for _, k in pairs(self.formula.productId) do
            if #k == 4 and k[4] == v.itemConfigId then
                SL:OpenTips(nil, k[1], nil, nil, nil, { hideBtn = true })
                return
            end
        end
    end
    local previewItemIds = {}
    for i, v in pairs(self.formula.productId) do
        table.insert(previewItemIds, v[1])
    end
    if #previewItemIds > 0 then
        if #previewItemIds == 1 then
            SL:OpenTips(nil, previewItemIds[1], nil, nil, nil, { hideBtn = true })
            return
        end
        -- 打开合成预览界面
        GUI:UIPanel_Open("dev/outui/Synthesis/Panel/KLNewSynthesisPreview/KLNewSynthesisPreviewPanel", nil, nil,
            previewItemIds)
    end
end

---点击确定按钮
function this:OnClick_Btn_Confirm()
    if self.selectTab < 3 then
        if self.equipInfo == nil then
            return SL:TipMessage("合成配方不满足", 1, NoticeType.NoticeMid)
        end
        if not table.isNullOrEmpty(self.coinCost) and SL:GetBagItemCount(self.coinCost[1]) < self.coinCost[2] then
            return SL:TipMessage(SL:GetConfig("cfg_item", self.coinCost[1]).name .. "不足", 1, NoticeType.NoticeMid)
        end
        local extritItems = {}
        if not table.isNullOrEmpty(self.extritems) then
            extritItems = {}
            for i, v in pairs(self.extritems) do
                -- SL:LogTable(v,true)
                local extritItem = {
                    id = i,
                    itemConfigId = v.itemConfigId,
                    itemIndex = self.bagItemIndex[i].index + 10000,
                    itemCount = v.itemCount
                }
                table.insert(extritItems, extritItem)
            end
        end
        local baohuItems = {}
        for i, v in pairs(self.baohu_items) do
            table.insert(baohuItems, v.itemConfigId)
        end
        local putCost = {}
        for i, v in pairs(self.minorCost) do
            table.insert(putCost, { itemConfigId = v.cfgId, itemCount = v.count })
        end
        if self.selectTab == 1 then -- 装备强化
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_STRENGTH_EQUIP,
                { itemId = self.equipInfo.id, successItems = extritItems, protectIds = baohuItems, putCost = putCost })
        else -- 装备追加
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_APPEND_EQUIP,
                { itemId = self.equipInfo.id, successItems = extritItems, putCost = putCost })
        end
        return
    end
    if self.isPreview then
        SL:TipMessage("请先把合成后的道具返回背包再进行合成", 1, NoticeType.NoticeMid)
        return
    end
    if self.formula == nil then
        --SL:LogError("合成配方不满足", self.formula)
        SL:TipMessage("合成配方不满足", 1, NoticeType.NoticeMid)
        return
    end
    if not table.isNullOrEmpty(self.coinCost) and SL:GetBagItemCount(self.coinCost[1]) < self.coinCost[2] then
        return SL:TipMessage(SL:GetConfig("cfg_item", self.coinCost[1]).name .. "不足", 1, NoticeType.NoticeMid)
    end
    local putItems = {}
    for i, v in pairs(self.consumeItems) do
        local putItem = {
            id = v.id,
            itemConfigId = v.itemConfigId,
            itemIndex = self.bagItemIndex[i].index + 10000,
            itemCount = v.itemCount
        }
        table.insert(putItems, putItem)
    end
    local extritItems = {}
    for i, v in pairs(self.extritems) do
        -- SL:LogTable(v,true)
        local extritItem = {
            id = i,
            itemConfigId = v.itemConfigId,
            itemIndex = self.bagItemIndex[i].index + 10000,
            itemCount = v.itemCount
        }
        table.insert(extritItems, extritItem)
    end
    local dingxiaItems = {}
    for i, v in pairs(self.dingxia_items) do
        local dingxiaItem = {
            id = i,
            itemConfigId = v.itemConfigId,
            itemIndex = self.bagItemIndex[i].index + 10000,
            itemCount = v.itemCount
        }
        table.insert(dingxiaItems, dingxiaItem)
    end
    local baohuItems = {}
    for i, v in pairs(self.baohu_items) do
        table.insert(baohuItems, v.itemConfigId)
    end
    local data = {
        [1] = self.formula.id,
        [2] = putItems,
        [3] = extritItems,
        [4] = dingxiaItems,
        [5] = baohuItems,
    }
    ---检查合成是否有绑定道具
    for _, v in pairs(data) do
        if type(v) == "table" then
            for _, k in pairs(v) do
                if type(v) ~= "table" then
                    break
                end
                local item = self.smelterItems[k.id].item
                --local isEquip = SL:GetConfig("cfg_item", item.cfgId).type == 2
                if EquipFunc.GetItemIsBind(item.cfgId, item) then
                    SL:CommonTipsMessage({
                        stringTblID = 67001,
                        sureBtnText = "确定",
                        callback = function()
                            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_SYNTHESIS, data)
                        end,
                    })
                    return
                end
            end
        end
    end

    --SL:LogTable(data,true,"data")
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_SYNTHESIS, data)
end

---点击数量减按钮
function this:OnClick_Btn_NumberMinus()
    local putCount = tonumber(GUI:GetInputText(self.view.Input_PutNum)) - 1
    if putCount < 1 then
        return
    end
    GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
    GUI:Slider_setPercent(self.view.Slider_PutNum, putCount)
    GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
end

---点击数量加按钮
function this:OnClick_Btn_NumberAdd()
    local putCount = tonumber(GUI:GetInputText(self.view.Input_PutNum)) + 1
    if putCount > self.putItem.count then
        return
    end
    GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
    GUI:Slider_setPercent(self.view.Slider_PutNum, putCount)
    GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
end

---放入数量滑动条改变
function this:OnValueChange_Slider_PutNum(_, args, data)
    GUI:SetInputText(self.view.Input_PutNum, tostring(math.floor(data[1])))
end

---点击确定放入数量按钮
function this:OnClick_Btn_ConfirmPutNum()
    -- GUI:setPosition(self.view.NumSelect, 3000, 3000)
    -- GUI:setVisible(self.view.NumSelectMask, false)
    -- local putCount = tonumber(GUI:GetInputText(self.view.Input_PutNum))
    -- self:PutCountItem(putCount)
end

---放置一定数量的item
function this:PutCountItem(putCount)
    local curItemInfo = self.smelterItems[self.putItem.id]
    if curItemInfo == nil then
        curItemInfo = { index = self.newIndex, item = table.copy(self.putItem) }
        curItemInfo.item.count = putCount
        self.smelterItems[self.putItem.id] = curItemInfo
    else
        curItemInfo.item.count = curItemInfo.item.count + putCount
    end
    -- SL:LogError("putCount", putCount,self.putItem.id,self.putItem.cfgId)
    table.insert(self.putList, { id = self.putItem.id, count = putCount })
    -- SL:LogError("putCount", putCount)
    -- 更新背包道具数量
    self.bagUI.bagTileScrollView:RefreshItemCountByIndex(self.bagItemIndex[self.putItem.id].index)
    self:SmelterItemChange({ curItemInfo })
end

---装备强化回包
function this:STRENGTH_EQUIP_RESULT(_, msg)
    if msg.issuccess then
        SL:TipMessage("装备强化成功", 1, NoticeType.NoticeMid)
        local item = SL:GetItemInfoByItemId(msg.itemId)
        SL:OpenTips("bag", item.cfgId, msg.itemId, nil, nil,
            { title = "强化成功!", isConfirmTips = true, hideComparsion = true })
    else
        SL:TipMessage("装备强化失败", 1.5, NoticeType.NoticeMid)
    end

    -- 更新背包道具数量
    self.equipInfo = nil
    self:ClearSmelter()
    SL:onLUAEvent(LUA_EVENT_STRENGTH_OK, msg)
end

---装备追加回包
function this:APPEND_EQUIP_RESULT(_, msg)
    if msg.issuccess then
        SL:TipMessage("装备追加成功", 1, NoticeType.NoticeMid)
    else
        SL:TipMessage("装备追加失败", 1.5, NoticeType.NoticeMid)
    end
    self.equipInfo = nil
    self:ClearSmelter()
    SL:onLUAEvent(LUA_EVENT_APPEND_OK, msg)
end

---合成回包
function this:RES_ITEM_SYNTHESIS(_, msg)
    self:ClearSmelter()
    --self.isPreview = msg.result -- 处于展示状态
    if msg.result then
        --SL:TipMessage("合成成功", 1, NoticeType.NoticeMid)
        --[[local first = msg.res["1"]
        if first then
            SL:OpenTips("bag", first.itemCfgId, first.itemId["1"], nil, nil, { title = "合成成功!", isConfirmTips = true, hideComparsion = true })
        end]]
        self.synthesisResult = {}
        local meId = tostring(SL:MeData_GetId())
        if msg.res then
            for i, v in pairs(msg.res) do
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_GOODS_INFO, { v.itemId, meId })
            end
        end
    else
        SL:TipMessage("合成失败", 1.5, NoticeType.NoticeMid)
        if msg.itemIds then
            for i, v in pairs(msg.itemIds) do
                local item = { itemId = v }
                SL:onLUAEvent(LUA_EVENT_STRENGTH_OK, item)
            end
        end
    end
end

---合成放入背包
function this:RES_SYNTHESIS_PUT_BAG(_, msg)
    local eventData = {}
    eventData = { { index = self.synthesisResult[tonumber(msg)].index } }
    self:SmelterItemChange(eventData)
    self.synthesisResult[tonumber(msg)] = nil
    if table.count(self.synthesisResult.count) == 0 then -- 放置结束
        self.isPreview = false
    end
end

---背包道具虚拟消耗
function this:LUA_EVENT_BAG_ITEM_COUNT_VIRTUAL_COST(itemId)
    if self.smelterItems and self.smelterItems[itemId] then
        return self.smelterItems[itemId].item.count
    end
    return 0
end

--关闭tips
---@param panelName string
function this:LUA_EVENT_CLOSEWIN(_, panelName, panelName3)
    -- SL:LogError("LUA_EVENT_CLOSEWIN", panelName)
    if panelName == "KLUIItemTipsPanel" or panelName == "KLUIEquipTipsPanel" then
        self.bagUI:RefreshFilterTagList({})
        self.bagTileScrollView:RefreshFilterTagList({})
    end
end

function this:TipsShow(message)
    self.isPreview = true
    local item = message.items[1]
    local result, putIndex = self:CheckItemGridCanPut(item.cfgId)
    local eventData = {}
    if result then
        table.insert(eventData, { index = putIndex, item = item })
        self.synthesisResult[item.id] = { index = putIndex, item = item }
    end
    self:SmelterItemChange(eventData)
    --SL:OpenTips("synthesis", item.cfgId, item.id, item.count, item)
    return true
end

return this

---@class KLTaskLoopPanel:UIKmlLuaPanelBase
---@field view KLTaskLoopPanelView
local KLTaskLoopPanel = class(UIKmlLuaPanelBase)
local this = KLTaskLoopPanel


---创建时调用一次
function this:Init()
    self.retList = {}
    self.taskInfo = nil
    self.canSelectItemList = {}
    ---@type KLTaskLoopSelectItem[]
    self.selectItemCtrl = {}
    SL.HideMainPanel()
    GUI:SetZIndex(self.view.select_panel, 3)
    GUI:SetZIndex(self.view.panel2, 2)
    GUI:DataListInitData(self.view.datalist1, function()
        -- SL:LogError("table.count(self.retList)", table.count(self.retList))
        return table.count(self.retList)
    end, function(realIndex)

    end, function(realIndex, kmlcontrol)

    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListInitData(self.view.select_item_list, function()
        return table.count(self.canSelectItemList)
    end, function(realIndex)
        return self:SelectListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SelectListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    self.desc1_str = GUI:Text_getString(self.view.desc1)
    self.desc2_str = GUI:Text_getString(self.view.desc2)
    self.smelterItems = {}
    self.bagItemIndex = {}
    self.useGridTable = {}
end

function this:getBagItemList()
    local items = SL:GetMetaValue("BAG_DATA")[1]
    local list = {}
    for _, v in pairs(items) do
        if self:CheckItem(v) then
            list[v.id] = 1
            -- table.insert(list, v.id)
        end
        if v.cfgId == self.taskInfo.wuzi[1] then
            list[v.id] = 1
        end
    end
    return list
end

function this:PlayAudio(audioId)
    if SL:HasConfig("cfg_audio", audioId) then
        return
    end
    local tabl = SL:GetConfig("cfg_audio", audioId) or {}
    SL:PlaySound(1, tabl.name, false, tabl.volume)
end

function this:DataListItemInitFunc(realIndex, kmlcontrol)
    local item = GUI:GetChildControl(self.view.datalist1, realIndex, 'item')
    local cfgId = self.retList[realIndex + 1][1]
    local itemCount = self.retList[realIndex + 1][2]
    -- SL:LogTable(self.retList[realIndex+1],true)
    GUI:Item_UpdataData(item, {
        itemid = cfgId,
        itemcustomcount = " " .. tostring(itemCount)
    })
    local button1 = GUI:GetChildControl(self.view.datalist1, realIndex, 'button1')
    GUI:AddOnClickEvent(button1, self, function()
        -- SL:LogError("cfgId", cfgId)
        SL:OpenTips(nil, cfgId)
    end)
end

function this:SelectListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Task/Item/KLTaskLoopSelect/KLTaskLoopSelectItem", self.view
        .select_item_list, self, nil, true, function(taskLoopSelectItem)
            local itemRoot = taskLoopSelectItem.view.root
            local isUpdate = self.selectItemCtrl[itemRoot] == false
            self.selectItemCtrl[itemRoot] = taskLoopSelectItem
            if isUpdate then
                self:SelectListItemUpdateFunc(realIndex, itemRoot)
            end
        end)
    return item.view.root
end

function this:SelectListItemUpdateFunc(realIndex, kmlcontrol)
    if not self.selectItemCtrl[kmlcontrol] then
        self.selectItemCtrl[kmlcontrol] = false
        return
    end
    local isSelect = false
    local data = self.canSelectItemList[realIndex + 1]
    if self.selectItem then
        isSelect = data.id == self.selectItem.id
    end
    self.selectItemCtrl[kmlcontrol]:UpdateData(data, isSelect)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    -- GUI:UIPanel_Close("dev/outui/Task/Panel/KLTaskBg/KLTaskBgPanel")
    GUI:setVisible(self.view.submit_item, false)
    GUI:setVisible(self.view.img_add, true)
    self.selectItem = nil
    -- 当前环数
    local currentLoopNum = InfoManager.taskLoopInfo.currentLoopNum + 1
    local taskinfo = SL:GetConfig('cfg_taskline', currentLoopNum)
    GUI:Text_setText(self.view.desc1,
        string.format(self.desc1_str, currentLoopNum, InfoManager.taskLoopInfo.maxLoopCount))
    if not taskinfo then
        GUI:Text_setText(self.view.desc2, "感谢您的大力支持！本轮所有循环任务已顺利完成，但使命仍在继续——随时准备迎接下一轮支援任务！!")
        return
    end
    self.taskInfo = taskinfo

    local text = ''

    --幸运待定
    if taskinfo.xingyun > 0 then
        text = text .. '附加‘幸运’'
    end
    --if taskinfo.jineng > 0 then
    --    text = text .. '<color=#4BA7E8>附加“武器技能”</color>'
    --end
    if taskinfo.zuoyue > 0 then
        text = text .. '、附加' .. taskinfo.zuoyue .. '条卓越属性'
    end

    if taskinfo.strPart and #taskinfo.strPart > 0 then
        text = text .. '的['
        if #taskinfo.strPart == 8 then
            text = text .. '装备'
        else
            for key, part in ipairs(taskinfo.strPart) do
                if part == 1 then
                    text = text .. '主手武器'
                elseif part == 2 then
                    text = text .. '副手武器'
                elseif part == 3 then
                    text = text .. '双手武器'
                elseif part == 4 then
                    text = text .. '头盔'
                elseif part == 5 then
                    text = text .. '铠甲'
                elseif part == 6 then
                    text = text .. '护手'
                elseif part == 7 then
                    text = text .. '护腿'
                elseif part == 8 then
                    text = text .. '鞋子'
                end
                if key < #taskinfo.strPart then
                    text = text .. "/"
                end
            end
        end
        text = text .. ']'
    end

    if taskinfo.itemId and SL:HasConfig('cfg_item', InfoManager.taskLoopInfo.currentCfgId) then
        local itemInfo = SL:GetConfig('cfg_item', InfoManager.taskLoopInfo.currentCfgId)
        text = text .. "的[" .. itemInfo.name .. "]"
    end
    if taskinfo.qianghua > 0 then
        text = text .. '+' .. taskinfo.qianghua
    end

    if taskinfo.zhuijia > 0 then
        text = text .. '、z' .. tonumber(taskinfo.zhuijia) * 4
    end
    self.selectTitle = text

    local jinbiText = ""
    local jinbiDes = ""
    if not table.isNullOrEmpty(taskinfo.jinbi) then
        jinbiDes = ",同时再提供"
        for key, value in ipairs(taskinfo.jinbi) do
            local itemName = SL:GetConfig("cfg_item", value[1], "id").name
            local count = value[2]
            if count >= 10000 then
                count = string.format("%.0f万", count / 10000)
            end
            jinbiText = jinbiText .. count .. itemName
            if key < table.count(taskinfo.jinbi) then
                jinbiText = jinbiText .. "和"
            end
        end
        jinbiText = jinbiText .. "。"
    end

    local wuziText = ""
    wuziText = wuziText .. ToolFunc.GetNotBindItemName(taskinfo.wuzi[1])

    GUI:Text_setText(self.view.desc2, string.format(self.desc2_str, text, jinbiDes, jinbiText, wuziText))

    local count = SL:GetBagItemCount(taskinfo.wuzi[1])
    -- GUI:Text_setText(self.view.textnumber, "拥有：" .. count)
    GUI:Item_setItemId(self.view.submit_item2, taskinfo.wuzi[1])
    self.item2CfgId = taskinfo.wuzi[1]
    local countStr = tostring(SL:GetSimpleNumber(count, 1))
    GUI:Text_setText(self.view.textnumber,
        string.format("<color=%s>需要数量：%s/%s</color>", count >= taskinfo.wuzi[2] and "#00ff00" or "#FF2323", countStr,
            taskinfo.wuzi[2]))
    self.retList = taskinfo.jiangli
    GUI:DataListUpdateData(self.view.datalist1)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.BtnClose)
    GUI:AddOnClickEvent(self.view.button5, self, self.BtnGet)
    CommonClickEvent.AddOnClickEvent(self.view.button6, self, self.BtnSkip, nil, 1000)
    GUI:AddOnClickEvent(self.view.btn_add, self, self.OpenItemSelect)
    GUI:AddOnClickEvent(self.view.sure_item, self, self.SureItem)
    GUI:AddOnClickEvent(self.view.close_select, self, self.CloseSelect)
    GUI:AddOnClickEvent(self.view.btn_item2, self, self.Item2GetClick)
end

function this:Show()

end

function this:Close()
    SL.ShowMainPanel()
end

function this:BtnClose()
    self:ClearSmelter()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel")
    SL.ShowMainPanel()
end

function this:BtnGet()
    -- GUI:UIPanel_Open("dev/outui/Task/Panel/KLTaskBg/KLTaskBgPanel", nil, nil, {list = self:getCanShowItemList()})
    -- local itemid, iteminfo = next(self.smelterItems)
    local itemid = self.selectItem and self.selectItem.id
    if itemid then
        SL:SendLuaNetMsg(LuaMessageIdToClient.TaskLoopMessage, { type = 2, itemId = itemid })
    else
        SL:TipMessage("无可提交道具", 1, NoticeType.NoticeMid)
    end
    self:ClearSmelter()
end

function this:BtnSkip()
    local count = SL:GetBagItemCount(self.taskInfo.wuzi[1])
    if count < self.taskInfo.wuzi[2] then
        SL:CommonItemGetPath(nil, self.taskInfo.wuzi[1])
        SL:TipMessage("所需积分不足", 1, NoticeType.NoticeMid)
        self:PlayAudio(100058)
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToClient.TaskLoopMessage, { type = 2, useJuanZhou = true })
    self:ClearSmelter()
end

function this:OpenItemSelect()
    if self.selectTitle then
        
        GUI:Text_setString(self.view.select_title, "<color=#FFFFFF>选择</color>" .. self.selectTitle)
    end
    local items = SL:GetMetaValue("BAG_DATA")[1]
    self.canSelectItemList = {}
    for _, v in pairs(items) do
        if self:CheckItem(v) then
            table.insert(self.canSelectItemList, v)
        end
        if v.cfgId == self.taskInfo.wuzi[1] then
            table.insert(self.canSelectItemList, v)
        end
        -- table.insert(self.canSelectItemList, v)
    end
    GUI:setVisible(self.view.select_desc,table.isNullOrEmpty(self.canSelectItemList))
    --显示
    GUI:DataListUpdateData(self.view.select_item_list)
    GUI:setVisible(self.view.select_panel, true)
end

function this:CloseSelect()
    self.selectItem = nil
    GUI:setVisible(self.view.select_panel, false)
end

function this:SureItem()
    if self.selectItem then
        self:SetSubmitItem(self.selectItem)
    else
        GUI:setVisible(self.view.submit_item, false)
        GUI:setVisible(self.view.img_add, true)
    end

    GUI:setVisible(self.view.select_panel, false)
end

function this:SetSubmitItem(data)
    GUI:Item_setItemId(self.view.submit_item, data.cfgId)
    ---是否显示幸运图标
    if not table.isNullOrEmpty(EquipFunc.GetEquipLuckyAttr(data)) then
        GUI:setVisible(self.view.xinyun, true)
    end

    --强化等级
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(data)
    GUI:setVisible(self.view.strengthLevel, true)
    GUI:Text_setString(self.view.strengthLevel, strengthLevel ~= 0 and ("+" .. strengthLevel) or "")
    --追加等级
    local appendLv = EquipFunc.GetEquipAppendLevel(data)
    GUI:setVisible(self.view.appendLevel, true)
    GUI:Text_setString(self.view.appendLevel, appendLv ~= 0 and EquipFunc.GetEquipAppendLevelStr(appendLv) or "")

    --装备品阶及卓越词条数量
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", data.cfgId)
    local entryCount = 0
    local pos = itemCfg.strPart[1]
    if pos and pos >= EEquipSlotType.Weapon and pos <= EEquipSlotType.Boot then
        local entryAttr = SL:GetEquipEntrys(data)
        entryCount = table.count(entryAttr)
    end

    GUI:setVisible(self.view.quality, true)
    if not self.qualityItem then
        ---@param win KLEquipQualityEntryItem
        GUI:UIPanel_Open("dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem",
            self.view.quality, self, {}, nil, function(win)
                self.qualityItem = win
                self.qualityItem:SetData(data.cfgId, entryCount)
                GUI:setScale(self.qualityItem.view.root, 0.7)
            end)
    else
        self.qualityItem:SetData(data.cfgId, entryCount)
        GUI:setScale(self.qualityItem.view.root, 0.7)
    end
    GUI:setVisible(self.view.submit_item, true)
    GUI:setVisible(self.view.img_add, false)
end

function this:SelectItem(data)
    for k, v in pairs(self.selectItemCtrl) do
        local isSelect = v.data.id == data.id
        v:SetSelect(isSelect)
    end
    self.selectItem = data
end

---获取熔炼格子道具
function this:GetSmelterGridItems()
    return self.useGridTable
end

---背包放到熔炉
function this:BagToSmelterItem(oldIndex, newIndex, item)
    -- 检查道具是否符合要求
    local result, tips = self:CheckItem(item)
    tips = tips or "道具不符合要求"
    if not result then
        SL:TipMessage(tips, 1, NoticeType.NoticeMid)
        return
    end

    if self.bagItemIndex[item.id] == nil then
        self.bagItemIndex[item.id] = { index = oldIndex, count = item.count }
    end
    self.putItem = item
    self.newIndex = newIndex
    self:PutCountItem(1)
end

function this:BagToSmelterItem_Out(itemId, itemCfgId)
    -- SL:LogError("itemCfgId_Out", itemId,itemCfgId)
    local item = SL:GetPosItemInfo("bag", itemCfgId, itemId)
    local index = SL:GetBagIndex(itemId) - 10000
    local result, putIndex = self:CheckItemGridCanPut(itemCfgId)
    if result then
        SL:LogError("放置格子：", putIndex)
        self:BagToSmelterItem(index, putIndex, item)
    else
        SL:TipMessage("格子已满", 1, NoticeType.NoticeMid)
    end
end

---检查item占用格子是否能放入
function this:CheckItemGridCanPut(itemCfgId)
    -- SL:LogError("itemCfgId_Check", itemCfgId)
    local holdGrid = SL:GetConfig('cfg_item', itemCfgId).holdGrid
    local holdHor = holdGrid[1]
    local holdVet = holdGrid[2]
    for hor = 1, ELoopTaskBagSize.H do
        for vet = 1, ELoopTaskBagSize.V do
            local startVet = vet - (holdHor - 1) // 2
            local startHor = hor - (holdVet - 1) // 2
            -- 超出边界
            if startHor <= 0 or startHor + holdVet - 1 > ELoopTaskBagSize.H or startVet <= 0 or startVet + holdHor - 1 > ELoopTaskBagSize.V then
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
function this:SmelterToBagItem(oldIndex, newIndex, item)
    self.smelterItems[item.id] = nil
    self:SmelterItemChange({ { index = oldIndex } })
    -- 更新背包道具数量
    self.bagUI.bagTileScrollView:RefreshItemCountByIndex(self.bagItemIndex[item.id].index)

    self.bagItemIndex[item.id] = nil
end

---熔炉放到背包
function this:SmelterToBagItem_Out(itemId)
    local itemIndex = self.smelterItems[itemId].index
    self.smelterItems[itemId] = nil
    self:SmelterItemChange({ { index = itemIndex } })
    -- 更新背包道具数量
    self.bagUI.bagTileScrollView:RefreshItemCountByIndex(self.bagItemIndex[itemId].index)

    self.bagItemIndex[itemId] = nil
end

---检查道具是否符合要求
function this:CheckItem(item)
    local itemTable = SL:GetConfig('cfg_item', item.cfgId) or {}
    if itemTable.type ~= 2 then
        return false
    end

    if next(self.taskInfo.itemId) then
        if not GUIUtil.ItemEquals(item.cfgId, InfoManager.taskLoopInfo.currentCfgId) then
            return false
        end
    end

    if next(self.taskInfo.strPart) then
        local fuhe = false
        for _, value in pairs(itemTable.strPart) do
            if table.contains(self.taskInfo.strPart, value) then
                fuhe = true
                break
            end
        end
        if not fuhe then
            return false
        end
    end

    if self.taskInfo.qianghua > 0 then
        if EquipFunc.GetEquipStrengthLevel(item) < self.taskInfo.qianghua then
            return false
        end
    end
    if self.taskInfo.zhuijia > 0 then
        if EquipFunc.GetEquipAppendLevel(item) < self.taskInfo.zhuijia then
            return false
        end
    end
    if self.taskInfo.zuoyue > 0 then
        local entryAttr = SL:GetEquipEntrys(item)
        local count = entryAttr and table.count(entryAttr) or 0
        if count < self.taskInfo.zuoyue then
            return false
        end
    end
    if self.taskInfo.xingyun > 0 then
        local entryAttr = EquipFunc.GetEquipLuckyAttr(item)
        if table.isNullOrEmpty(entryAttr) then
            return false
        end
    end
    return true
end

---清空熔炉
function this:ClearSmelter()
    if table.count(self.smelterItems) == 0 then
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
    for i, v in pairs(bagIndexs) do
        self.bagUI.bagTileScrollView:RefreshItemCountByIndex(v)
    end
    self:SmelterItemChange(itemInfo, true)
end

---移动道具
function this:MoveItem(oldIndex, newIndex, item)
    if oldIndex == newIndex then
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
    GUI:setVisible(self.view.desc3, table.count(self.smelterItems) == 0)
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
        if item.id == 10010002 then -- 绑金
            return 2, 2
        end
        return 1, 1
    end

    return item.holdGrid[1], item.holdGrid[2]
end

---拖拽结束
function this:DragEnd(eventData)
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
    if bagHor <= bagMaxHor and bagHor > 0 and bagVet <= bagMaxVet and bagVet > 0 then
        -- 放回背包
        local newIndex = self.bagTileScrollView.GetIntWithHorAndVet(bagHor, bagVet)
        self:SmelterToBagItem(oldIndex, newIndex, dragItem.item)
    else
        --local maxHor, maxVet = RoleManager.meData.storeHouseInfo:GetMaxHorAndVet()
        local maxHor = ELoopTaskBagSize.H
        local maxVet = ELoopTaskBagSize.V
        if synthesisSmelterHor and synthesisSmelterHor <= maxHor and synthesisSmelterHor > 0 and synthesisSmelterVet <= maxVet and synthesisSmelterVet > 0 then
            local newIndex = self.bagTileScrollView.GetIntWithHorAndVet(synthesisSmelterHor, synthesisSmelterVet)
            --移动了位置
            self:MoveItem(oldIndex, newIndex, dragItem.item)
        end
    end
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
    -- SL:LogError("putCount", putCount)
    -- 更新背包道具数量
    self.bagUI.bagTileScrollView:RefreshItemCountByIndex(self.bagItemIndex[self.putItem.id].index)
    self:SmelterItemChange({ curItemInfo })
end

function this:ItemClick(_, item)
    -- SL:LogError("item", item.cfgId, item.id)
    SL:OpenTips("looptask", item.cfgId, item.id)
end

function this:Item2GetClick()
    if self.item2CfgId then
        SL:CommonItemGetPath(nil, self.item2CfgId, nil, nil, self)
    end
end

return this

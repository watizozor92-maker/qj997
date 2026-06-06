---@class KLEquipOverlayPanel:UIKmlLuaPanelBase
---@field view KLEquipOverlayPanelView
---@field mainItem @主装备
---@field assistantItem @副装备
---@field mainEntry @主装备词条信息
---@field assistantEntry @副装备词条信息
---@field showEntryList @已经展示的词条信息列表，用于展示后设置
---@field lockNum @已锁定词条数量
---@field bagItems
---@field equipItems
---@field specialCost @消耗的特殊道具
---@field Cost @普通消耗
---@field showItemList @显示在背包中的道具
---@field excludeItemid number @需要排除的id
local KLEquipOverlayPanel = class(UIKmlLuaPanelBase)
local this = KLEquipOverlayPanel
---创建时调用一次
function this:Init()
    self.bagItems = {}
    self.equipItems = {}
    self.specialCost = {}
    self.Cost = {}
    self.costList = {}
    self.excludeItemid = 0
    GUI:UIPanel_Open("dev/outui/Bag/Panel/KLOverlayBag/KLOverlayBagPanel", nil, nil,
        {
            itemList = self:GetOverlayItem(),
            x = -482,
            y = 0,
            selectList = {},
            itemClick = self.ItemClick,
            callBackUI =
                self
        }, false, function(bagUI)
            self.bagUI = bagUI
        end)
    GUI:DataListInitData(self.view.cost_list, function()
        return table.count(self.costList)
    end, function(realIndex) end, function(realIndex, kmlcontrol) end, function(realIndex, kmlcontrol)
        return self:DataListCostUpdateFunc(realIndex, kmlcontrol)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.mainItem = {}
    self.assistantItem = {}
    self.showEntryList = {}
    GUI:setVisible(self.view.Add_CostItem_panel, false)
    self.lockNum = 0
    GUI:DataListInitData(self.view.entry_list, function()
        return table.count(self.mainEntry) + table.count(self.assistantEntry)
    end, function(realIndex)

    end, function(realIndex, kmlcontrol)

    end, function(realIndex, kmlcontrol)
        return self:DataListEntryUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closePanel, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.zhu_click, self, self.ClickMainItem)
    GUI:AddOnClickEvent(self.view.fu_click, self, self.ClickAssistantItem)
    GUI:AddOnClickEvent(self.view.LuckyClick, self, self.OpenCostItemPanel)
    GUI:AddOnClickEvent(self.view.rate_sure_btn, self, self.RateSure)
    GUI:AddOnClickEvent(self.view.CostItem_mask, self, self.RateSure)
    GUI:Slider_addOnEvent(self.view.rate_item_slider, self, self.SliderChange)
    GUI:AddOnClickEvent(self.view.rate_item_add, self, function()
        self:SliderBtn(1)
    end)
    GUI:AddOnClickEvent(self.view.rate_item_sub, self, function()
        self:SliderBtn(-1)
    end)

    -- GUI:AddOnClickEvent(self.view.cost_btn, self, self.COSTBTN)
    GUI:AddOnClickEvent(self.view.helptip, self, self.HelpTip)
    GUI:AddOnClickEvent(self.view.Overlay_btn, self, self.Overlay)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_OVERLAY, self.RES_EQUIP_OVERLAY, self)
    --SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    --SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.SetCostItem, self)
    SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.ClosePanel, self)
end

function this:LUA_EVENT_BAG_CHANGE_AFTER(_, message)
    if table.count(self.mainItem) > 0 then
        self:GetAssistantOverlayItem(self:GetOverlayItem())
    else
        self.bagUI:RefreshItem(self:GetOverlayItem())
    end
    self:SetCostItem()
end

function this:GetOverlayItem()
    local data = {}
    self.bagItems = {}
    self.equipItems = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]

    if bagItemTabl then
        for _, v in pairs(bagItemTabl) do
            if SL:HasConfig("cfg_equip_overlay", v.cfgId, "id") then
                --data[SL:GetBagIndex(v.id) - 10000] = v
                table.insert(data, v)
                table.insert(self.bagItems, v.id)
            end
        end
    end

    bagItemTabl = SL:GetTotalWearEquips()[1]
    if bagItemTabl then
        for _, v in pairs(bagItemTabl) do
            if SL:HasConfig("cfg_equip_overlay", v.cfgId, "id") then
                table.insert(data, v)

                table.insert(self.equipItems, v.id)
            end
        end
    end
    data = self:SortItemList(data)
    self.showItemList = data

    return data
end

function this:GetAssistantOverlayItem(itemlist)
    local showdata = {}
    --更改背包中的物品
    for i, v in pairs(itemlist) do
        if v.cfgId == self.mainItem.cfgid and v.id ~= self.mainItem.id and self.excludeItemid ~= v.id then
            for _, k in pairs(v.itemExtInfo.equipExtInfo.entryAttr) do
                local isAdd = true
                for _, l in pairs(self.mainEntry) do
                    if l.entryId == k.entryId then
                        isAdd = false
                        break
                    end
                end
                if isAdd then
                    table.insert(showdata, v)
                    break
                end
            end
        end
    end
    self.showItemList = self:SortItemList(showdata)
    self.bagUI:RefreshItem(self.showItemList)
end

---@param itemList CommonProtos.Item[]
---@return CommonProtos.Item[]
function this:SortItemList(itemList)
    local bag_str = SL:GetConfig("cfg_global", 6).value
    local bag_tbl = string.split(bag_str, '#')
    local bag_hor = tonumber(bag_tbl[1])
    local bag_vet = tonumber(bag_tbl[2])
    local use_cell_dict = {}
    local sortItemList = {}
    local cfg_id, now_hor, now_vet, is_put, hold_vet, hole_hor, item, now_hold_hor, now_judge_hor, now_hold_vet, now_judge_vet, now_cell_index
    local max_hor = bag_hor + 20
    for _, v in pairs(itemList) do
        cfg_id = v.cfgId
        now_hor = 1
        while now_hor <= max_hor do
            now_vet = 1
            while now_vet <= bag_vet do
                is_put = true
                ---@type cfg_item_column
                item = SL:GetConfig("cfg_item", cfg_id)
                hold_vet = item.holdGrid[1]
                hole_hor = item.holdGrid[2]
                now_hold_hor = 0
                while now_hold_hor < hole_hor do
                    now_judge_hor = now_hor + now_hold_hor
                    now_hold_vet = 0
                    while now_hold_vet < hold_vet do
                        now_judge_vet = now_vet + now_hold_vet
                        now_cell_index = now_judge_hor * 100 + now_judge_vet
                        if use_cell_dict[now_cell_index] or now_judge_vet > bag_vet then
                            is_put = false
                            break
                        end
                        now_hold_vet = now_hold_vet + 1
                    end
                    if not is_put then
                        break
                    end
                    now_hold_hor = now_hold_hor + 1
                end
                if is_put then
                    break
                end
                now_vet = now_vet + 1
            end
            if is_put then
                break
            end
            now_hor = now_hor + 1
        end

        local now_index = now_hor * 100 + now_vet
        sortItemList[now_index] = v

        now_hold_hor = 0
        while now_hold_hor < hole_hor do
            now_hold_vet = 0
            local now_hold_judge_hor = now_hor + now_hold_hor
            while now_hold_vet < hold_vet do
                local now_hold_judge_vet = now_vet + now_hold_vet
                now_cell_index = now_hold_judge_hor * 100 + now_hold_judge_vet
                use_cell_dict[now_cell_index] = true
                now_hold_vet = now_hold_vet + 1
            end
            now_hold_hor = now_hold_hor + 1
        end
    end
    return sortItemList
end

function this:ItemClick(itemControl, itemData)
    local pos = self:GetPos(itemData.id)
    SL:OpenTips(pos, itemData.cfgId, itemData.id)
end

function this:GetPos(itemId)
    for _, v in pairs(self.bagItems) do
        if v == itemId then
            return "bag"
        end
    end
    return "equip"
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipOverlay/KLEquipOverlayPanel")
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
end

function this:Close()
    if self.timeID then
        SL:UnSchedule(self.timeID)
    end
    if GUI:GetUI("dev/outui/Bag/Panel/KLOverlayBag/KLOverlayBagPanel") then
        GUI:UIPanel_Close("dev/outui/Bag/Panel/KLOverlayBag/KLOverlayBagPanel")
    end
    --GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
end

function this:SelectItem(equip_pos, cfgid, id)
    -- 选择主装备
    if not self.mainItem or table.count(self.mainItem) == 0 then
        local tbl = SL:GetConfig("cfg_equip_overlay", cfgid, "id")
        self.mainItem = { equip_pos = equip_pos, cfgid = cfgid, id = id, lockEntry = {}, tbl = tbl }
        GUI:Item_setItemId(self.view.zhu_item, cfgid)
        local liuGuangId = EquipFunc.GetEquipLiuGuangId(SL:GetPosItemInfo(equip_pos, cfgid, id))
        if liuGuangId then
            GUI:SetStreamAttr(self.view.zhu_item, liuGuangId)
        else
            GUI:ResetStreamAttr(self.view.zhu_item)
        end
        GUI:setVisible(self.view.zhu_item, true)
        GUI:setVisible(self.view.zhu_add, false)
        GUI:setVisible(self.view.zhu_bg_overlay_select, false)
        GUI:setVisible(self.view.fu_bg_overlay_select, true)
        self:LoadItemInfo()
    else
        -- 选择副装备
        if id ~= self.mainItem.id then
            self.assistantItem = { equip_pos = equip_pos, cfgid = cfgid, id = id }
            GUI:Item_setItemId(self.view.fu_item, cfgid)
            local liuGuangId = EquipFunc.GetEquipLiuGuangId(SL:GetPosItemInfo(equip_pos, cfgid, id))
            if liuGuangId then
                GUI:SetStreamAttr(self.view.fu_item, liuGuangId)
            else
                GUI:ResetStreamAttr(self.view.fu_item)
            end
            GUI:setVisible(self.view.fu_item, true)
            GUI:setVisible(self.view.fu_add, false)
            GUI:setVisible(self.view.fu_bg_overlay_select, false)
            self:LoadOverlayInfo()
        end
    end
    if GUI:GetUI("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel") then
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    end
end

--加载主装备
function this:LoadItemInfo(Entry)
    if Entry then
        self.mainEntry = Entry
    else
        self.mainEntry = SL:GetPosItemInfo(self.mainItem.equip_pos, self.mainItem.cfgid, self.mainItem.id).itemExtInfo
            .equipExtInfo.entryAttr
    end
    --local liuGuangId = EquipFunc.GetEquipLiuGuangId(equipInfo)
    --if liuGuangId then
    --    GUI:SetStreamAttr(self.view.item_model, liuGuangId)
    --else
    --    GUI:ResetStreamAttr(self.view.item_model)
    --end
    self:RateSure()
    GUI:setVisible(self.view.item_attr_panel, true)
    local costItem = self.mainItem.tbl.costItem[1]
    self.mainItem["rate"] = 0
    self.specialCost = {}
    if costItem then
        GUI:setVisible(self.view.Luckystone, true)
        --GUI:setVisible(self.view.LuckystoneName, true)
        GUI:setVisible(self.view.success_rate2, true)
        GUI:Item_setItemId(self.view.Luckystone, costItem[1])
        self.specialCost = { itemId = costItem[1], count = 0, rate = costItem[2] }
        --GUI:Text_setString(self.view.LuckystoneName, SL:GetConfig("cfg_item", costItem[1], "id").name)
        GUI:Text_setString(self.view.success_rate1, tostring(math.floor(self.mainItem.tbl.minRate / 100)) .. "%")
        GUI:Text_setString(self.view.success_rate2, "+" .. tostring(math.floor(self.mainItem.rate)) .. "%")
    else
        GUI:setVisible(self.view.Luckystone, false)
        --GUI:setVisible(self.view.LuckystoneName, false)
        GUI:setVisible(self.view.success_rate2, false)
        GUI:Text_setString(self.view.success_rate1, tostring(math.floor(self.mainItem.tbl.minRate / 100)) .. "%")
    end

    self.isHaveAssistant = false
    GUI:DataListUpdateData(self.view.entry_list)
    self:SetCostItem()
    self:GetAssistantOverlayItem(self:GetOverlayItem())
end

--副装备放入,加载信息框
function this:LoadOverlayInfo()
    self.assistantEntry = {}
    local data = SL:GetPosItemInfo(self.assistantItem.equip_pos, self.assistantItem.cfgid, self.assistantItem.id)
        .itemExtInfo.equipExtInfo.entryAttr
    for _, v in pairs(data) do
        local isAdd = true
        for _, k in pairs(self.mainEntry) do
            if v.entryId == k.entryId then
                isAdd = false
                break
            end
        end
        if isAdd then
            table.insert(self.assistantEntry, v)
        end
    end
    self.isHaveAssistant = true
    GUI:DataListUpdateData(self.view.entry_list)
    local itemData = {}
    for i, v in pairs(self.showItemList) do
        if self.assistantItem.id ~= v.id then
            table.insert(itemData, v)
        end
    end
    self.bagUI:RefreshItem(self:SortItemList(itemData))
end

function this:DataListEntryUpdateFunc(realIndex, kmlcontrol)
    local isMain = realIndex < table.count(self.mainEntry)
    local data
    if isMain then
        data = self.mainEntry[realIndex + 1]
        if not data then
            data = self.mainEntry[tostring(realIndex + 1)]
        end
    else
        data = self.assistantEntry[realIndex - table.count(self.mainEntry) + 1]
    end
    local tbl = SL:GetConfig("cfg_att_info", data.type, "id")

    local infoStr = tbl.name
    if tbl.attShow ~= 0 then
        infoStr = infoStr .. "+"
        if tbl.remarks == 1 then
            infoStr = infoStr .. data.num
        else
            infoStr = infoStr .. tostring(data.num / 100) .. "%"
        end
    end

    --local name = self.view.entry_list:GetChildControl(realIndex, "name")
    local name = GUI:GetChildControl(self.view.entry_list, realIndex, "name")
    GUI:Text_setString(name, infoStr)
    --local lock = self.view.entry_list:GetChildControl(realIndex, "lock")
    local lock = GUI:GetChildControl(self.view.entry_list, realIndex, "lock")
    --local replace = self.view.entry_list:GetChildControl(realIndex, "replace")
    local replace = GUI:GetChildControl(self.view.entry_list, realIndex, "replace")
    --local get = self.view.entry_list:GetChildControl(realIndex, "get")
    local get = GUI:GetChildControl(self.view.entry_list, realIndex, "get")
    --local reserve_btn = self.view.entry_list:GetChildControl(realIndex, "reserve_btn")
    local reserve_btn = GUI:GetChildControl(self.view.entry_list, realIndex, "reserve_btn")
    --local RE_reserve_btn = self.view.entry_list:GetChildControl(realIndex, "RE_reserve_btn")
    local RE_reserve_btn = GUI:GetChildControl(self.view.entry_list, realIndex, "RE_reserve_btn")

    GUI:setVisible(lock, false)
    if self.isHaveAssistant and isMain then
        if table.count(self.mainEntry) <= 1 then
            GUI:setVisible(reserve_btn, false)
        else
            GUI:setVisible(reserve_btn, true)
        end
        GUI:setVisible(replace, true)
        GUI:setVisible(get, false)

        local ControlData = { lock = lock, replace = replace, RE_reserve_btn = RE_reserve_btn, reserve_btn = reserve_btn }
        GUI:AddOnClickEvent(reserve_btn, self, function()
            self:Lock(ControlData, data.entryId)
        end)
    elseif self.isHaveAssistant and not isMain then
        GUI:setVisible(get, true)
        GUI:setVisible(replace, false)
        GUI:setVisible(reserve_btn, false)
        GUI:setVisible(RE_reserve_btn, false)
    else
        GUI:setVisible(replace, false)
        GUI:setVisible(get, false)
        GUI:setVisible(reserve_btn, false)
        GUI:setVisible(RE_reserve_btn, false)
    end
end

--单击主装备取消选择装备
function this:ClickMainItem()
    if self.mainItem and table.count(self.mainItem) > 0 then
        self.specialCost = {}
        self.showItemList = {}
        self.Cost = {}

        self.mainItem = {}
        self.mainEntry = {}
        GUI:setVisible(self.view.item_attr_panel, false)
        GUI:setVisible(self.view.zhu_item, false)
        GUI:setVisible(self.view.zhu_add, true)
        GUI:setVisible(self.view.zhu_bg_overlay_select, true)
        GUI:setVisible(self.view.fu_bg_overlay_select, false)
        self.lockNum = 0
        self.costList = {}
        GUI:DataListUpdateData(self.view.cost_list)
        self.assistantItem = {}
        self.assistantEntry = {}
        GUI:setVisible(self.view.fu_add, true)
        GUI:setVisible(self.view.fu_item, false)
        self:GetOverlayItem()
        self.bagUI:RefreshItem(self.showItemList)
    end
end

--单击副装备取消选择副装备
function this:ClickAssistantItem()
    if table.count(self.assistantItem) == 0 then
        return
    end
    self.assistantItem = {}
    self.assistantEntry = {}
    self.lockNum = 0
    GUI:setVisible(self.view.fu_add, true)
    GUI:setVisible(self.view.fu_item, false)
    GUI:setVisible(self.view.fu_bg_overlay_select, true)
    self.isHaveAssistant = false
    GUI:DataListUpdateData(self.view.entry_list)
    self:SetCostItem()
    self:GetAssistantOverlayItem(self:GetOverlayItem())
end

--词条锁定
function this:Lock(ControlData, entryId)
    GUI:setVisible(ControlData.replace, false)
    GUI:setVisible(ControlData.lock, true)
    GUI:setVisible(ControlData.reserve_btn, false)
    GUI:setVisible(ControlData.RE_reserve_btn, true)
    GUI:AddOnClickEvent(ControlData.RE_reserve_btn, self, function()
        self:ReLock(ControlData, entryId)
    end)
    table.insert(self.mainItem.lockEntry, entryId)
    self.lockNum = self.lockNum + 1
    local tblLockNum = table.count(self.mainItem.tbl.lockCost)
    local mainEntryNum = table.count(self.mainEntry)
    local maxLockNum = tblLockNum > mainEntryNum - 1 and mainEntryNum - 1 or tblLockNum
    if self.lockNum == maxLockNum then
        for i = 0, maxLockNum do
            --local reserve_btn = self.view.entry_list:GetChildControl(i, "reserve_btn")
            local reserve_btn = GUI:GetChildControl(self.view.entry_list, i, "reserve_btn")
            GUI:setVisible(reserve_btn, false)
        end
    end
    self:SetCostItem()
end

--词条解锁
function this:ReLock(ControlData, entryId)
    GUI:setVisible(ControlData.replace, true)
    GUI:setVisible(ControlData.lock, false)
    GUI:setVisible(ControlData.reserve_btn, true)
    GUI:setVisible(ControlData.RE_reserve_btn, false)
    GUI:AddOnClickEvent(ControlData.RE_reserve_btn, self, function()
        self:Lock(ControlData, entryId)
    end)
    for i, v in pairs(self.mainItem.lockEntry) do
        if v == entryId then
            table.remove(self.mainItem.lockEntry, i)
            break
        end
    end
    local mainEntryNum = table.count(self.mainEntry)
    if self.lockNum == mainEntryNum - 1 then
        self.lockNum = self.lockNum - 1
        for i = 0, mainEntryNum - 1 do
            --local RE_reserve_btn = self.view.entry_list:GetChildControl(i, "RE_reserve_btn")
            local RE_reserve_btn = GUI:GetChildControl(self.view.entry_list, i, "RE_reserve_btn")
            if not GUI:getVisible(RE_reserve_btn) then
                --local reserve_btn = self.view.entry_list:GetChildControl(i, "reserve_btn")
                local reserve_btn = GUI:GetChildControl(self.view.entry_list, i, "reserve_btn")
                GUI:setVisible(reserve_btn, true)
            end
        end
    else
        self.lockNum = self.lockNum - 1
    end
    self:SetCostItem()
end

function this:CalculateCost()
    local data = {}

    if self.mainItem.tbl.costItem[1] and self.specialCost.count > 0 then
        table.insert(data, { itemCfgId = self.specialCost.itemId, count = self.specialCost.count })
    end
    return data
end

function this:DataListCostUpdateFunc(realIndex, kmlcontrol)
    local data = self.costList[realIndex + 1]
    local itemControl = GUI:GetChildControl(self.view.cost_list, realIndex, 'cost_item')
    local nameControl = GUI:GetChildControl(self.view.cost_list, realIndex, 'cost_name')
    local numControl = GUI:GetChildControl(self.view.cost_list, realIndex, 'cost_num')
    local costAddBtn = GUI:GetChildControl(self.view.cost_list, realIndex, 'costAddBtn')
    GUI:Item_setItemId(itemControl, data[1])
        
    local name = SL:GetConfig('cfg_item', data[1]).name
    GUI:Text_setString(nameControl, name)
    local haveCount = SL:GetBagItemCount(data[1])
    local needCount = data[2]
    local CountText = SL:GetSimpleNumber(needCount, 2)
    local myCountText = SL:GetSimpleNumber(haveCount, 2)
    if haveCount < needCount then
        GUI:Text_setString(numControl, string.format('<color="#9b1818">%s</color>/%s', myCountText, CountText))
    else
        GUI:Text_setString(numControl, string.format('<color="#00ff00">%s</color>/%s', myCountText, CountText))
    end

    GUI:AddOnClickEvent(costAddBtn, self, function()
        SL:CommonItemGetPath(nil, data[1])
    end)
end

function this:SetCostItem()
    if table.count(self.mainItem) == 0 then
        return
    end
    self.costList = {}
    for k, v in pairs(self.mainItem.tbl.cost) do
        table.insert(self.costList, v)
    end
    
    if self.lockNum > 0 then
        table.insert(self.costList, self.mainItem.tbl.lockCost[self.lockNum])
    end
    GUI:DataListUpdateData(self.view.cost_list)
end

function this:OpenCostItemPanel()
    GUI:setVisible(self.view.Add_CostItem_panel, true)

    GUI:Slider_setMaxPercent(self.view.rate_item_slider,
        (self.mainItem.tbl.maxRate - self.mainItem.tbl.minRate) / self.specialCost.rate)
    GUI:Slider_setPercent(self.view.rate_item_slider, self.specialCost.count and self.specialCost.count or 0)
    self.bagCount = SL:GetBagItemCount(self.specialCost.itemId)
    GUI:Item_setItemId(self.view.rate_CostItem, self.specialCost.itemId)
    local itemName = SL:GetConfig("cfg_item", self.specialCost.itemId, "id").name

    GUI:Text_setString(self.view.rate_text1, tostring(math.floor(self.mainItem.tbl.minRate / 100)) .. "%")
    GUI:Text_setString(self.view.rate_text2, "+" .. tostring(math.floor(self.mainItem.rate)) .. "%")

    GUI:Text_setString(self.view.costItem_name, itemName)
    GUI:Text_setString(self.view.total_CostItem, "总数：<color='#00ff00'>" .. tostring(self.bagCount) .. "</color>")
    if self.specialCost.count > 0 then
        GUI:Text_setString(self.view.use_costItem,
            "消耗：<color='#00ff00'>" .. tostring(self.specialCost.count) .. "</color>")
    else
        GUI:Text_setString(self.view.use_costItem,
            "消耗：<color='#ff2323'>" .. tostring(self.specialCost.count) .. "</color>")
    end

    GUI:Text_setString(self.view.max_success_rate,
        "成功率最高上限" .. tostring(math.floor(self.mainItem.tbl.maxRate / 100)) .. "%")
end

function this:RateSure()
    GUI:setVisible(self.view.Add_CostItem_panel, false)
    if table.count(self.specialCost) > 0 and self.specialCost.count > 0 then
        GUI:setVisible(self.view.Luckystonenull, false)
    else
        GUI:setVisible(self.view.Luckystonenull, true)
    end
end

function this:SliderBtn(index)
    local value = GUI:Slider_getPercent(self.view.rate_item_slider)
    if index then
        value = value + index
        GUI:Slider_setPercent(self.view.rate_item_slider, value)

        self:SliderChange(_, value)
    end
end

function this:SliderChange(_, value)
    if not value then
        value = GUI:Slider_getPercent(self.view.rate_item_slider)
    end
    if value < 0 then
        value = 0
    elseif value > self.bagCount then
        value = self.bagCount
        GUI:Slider_setPercent(self.view.rate_item_slider, value)
        --    打开提示框
        SL:CommonItemGetPath(nil, self.specialCost.itemId)
    elseif value > (self.mainItem.tbl.maxRate - self.mainItem.tbl.minRate) / self.specialCost.rate then
        value = (self.mainItem.tbl.maxRate - self.mainItem.tbl.minRate) / self.specialCost.rate
        SL:MessageTip({ id = 31001 })
    end

    self.specialCost.count = math.floor(value)
    self.mainItem.rate = value * self.specialCost.rate / 100
    GUI:Text_setString(self.view.rate_text1, tostring(math.floor(self.mainItem.tbl.minRate / 100)) .. "%")
    GUI:Text_setString(self.view.rate_text2, "+" .. tostring(math.floor(self.mainItem.rate)) .. "%")
    GUI:Text_setString(self.view.success_rate1, tostring(math.floor(self.mainItem.tbl.minRate / 100)) .. "%")
    GUI:Text_setString(self.view.success_rate2, "+" .. tostring(math.floor(self.mainItem.rate)) .. "%")
    if self.specialCost.count > 0 then
        GUI:Text_setString(self.view.use_costItem,
            "消耗：<color='#00ff00'>" .. tostring(self.specialCost.count) .. "</color>")
    else
        GUI:Text_setString(self.view.use_costItem,
            "消耗：<color='#ff2323'>" .. tostring(self.specialCost.count) .. "</color>")
    end
end

function this:Overlay()
    if table.count(self.mainItem) == 0 or table.count(self.assistantItem) == 0 then
        SL:TipMessage(SL:GetConfig('cfg_string', 265).text, 1, 1) --"请选择一件装备",
        return
    end
    local assistantItemInfo = SL:GetPosItemInfo(self.assistantItem.equip_pos, self.assistantItem.cfgid,
        self.assistantItem.id)
    if EquipFunc.GetEquipAppendLevel(assistantItemInfo) > 0 or EquipFunc.GetEquipStrengthLevel(assistantItemInfo) > 0 then
        SL:CommonTipsMessage({ showTips = "当前副装备有强化/追加等级，是否继续叠加？", ui = self, callback = self.SureOverlay })
    else
        local data = {
            firstItemId = self.mainItem.id,
            secondItemId = self.assistantItem.id,
            costItem = self
                :CalculateCost(),
            lockEntryIds = self.mainItem.lockEntry
        }
        self.excludeItemid = self.assistantItem.id
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_OVERLAY, data)
    end
end

function this.SureOverlay(info)
    local ui = info.ui
    local data = {
        firstItemId = ui.mainItem.id,
        secondItemId = ui.assistantItem.id,
        costItem = ui:CalculateCost(),
        lockEntryIds =
            ui.mainItem.lockEntry
    }
    ui.excludeItemid = ui.assistantItem.id
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_OVERLAY, data)
end

function this:RES_EQUIP_OVERLAY(_, message)
    self.mainItem.lockEntry = {}
    if self.timeID then
        SL:UnSchedule(self.timeID)
    end

    if message.result == 1 then
        GUI:setVisible(self.view.result_success_img, true)
        GUI:setVisible(self.view.result_fail_img, false)
    else
        GUI:setVisible(self.view.result_success_img, false)
        GUI:setVisible(self.view.result_fail_img, true)
    end
    self.timeID = SL:ScheduleOnce(1, function()
        GUI:setVisible(self.view.result_success_img, false)
        GUI:setVisible(self.view.result_fail_img, false)
    end)

    self:ClickAssistantItem()
    if message.result == 1 then
        self:LoadItemInfo(message.firstEntries)
    else
        self:LoadItemInfo()
    end

    --logError(table.count(message.firstEntries))
end

function this:COSTBTN()
    if table.count(self.mainItem) == 0 or table.count(self.assistantItem) == 0 then
        SL:TipMessage(SL:GetConfig('cfg_string', 265).text, 1, 1) --"请选择一件装备",
        return
    end
    if self.lockNum > 0 then
        SL:CommonItemGetPath(nil, self.mainItem.tbl.lockCost[self.lockNum][1])
    else
        SL:CommonItemGetPath(nil, self.mainItem.tbl.cost[1][1])
    end
end

function this:HelpTip()
    local helpCfg = SL:GetConfig("cfg_rule_text", 10, "id")
    if helpCfg then
        SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
    end
end

return this

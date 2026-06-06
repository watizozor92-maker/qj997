---@class BoxItemData
---@field itemId number
---@field show boolean @是否可显示

---@class ExBoxTipsInfo @注释
ExBoxTipsInfo = class()
local this = ExBoxTipsInfo

local PATCH_USEBOX_COUNT = 20

---@type BoxItemData[] @普通提示框
local normalItems = {}

---装备提示框
---@type table<number,table<number,BagProtos.BagItem[]>> <wearBarID(cfg_wearing_bar id),<equipIndex,BagProtos.BagItem[]>>
local equipList = {}

function this:ctor()
    self:Reset()
end

function this:Init()
    normalItems = {}
    equipList = {}
    self.quickPopUpItemIdList = {}
    self:RegistEvents()
end

function this:Reset()
    normalItems = {}
    equipList = {}
    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end
end

-----------------------------------------------------------------------------------------------------------
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.UpdateBoxItem, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_BEFORE, self.RemoveItem, self)
    SL:RegisterLUAEvent(LUA_EVENT_ME_CREATE_SUCCESS, self.UpdateUseTipPanel, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, self.OnRoleAttrChange, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_UI_VISIBLE, self.UpdateUseTipPanel, self)
    SL:RegisterLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, this.ResPutOnTheEquipMessage, self)
    SL:RegisterTrigger(LUA_TRIGGER_EQUIP_GET_PUT_SLOT, self.LUA_TRIGGER_EQUIP_GET_PUT_SLOT, self)
end

---@param eventData BagProtos.BagItem[]   删除装备刷新快捷提示UI
function this:RemoveItem(_, eventData)
    for _, v in pairs(eventData) do
        if not v.item then
            ---@type CommonProtos.Item
            local delItem = SL:GetMetaValue(EMetaVarGetKey.ITEM_DATA, v.index)
            if delItem then
                local fIndex = table.findByCondi(normalItems, function(a)
                    return a.itemId == delItem.cfgId
                end)
                if fIndex then
                    table.remove(normalItems, fIndex)
                end

                self:ReMoveItemByID(delItem.id, delItem.cfgId)
            end
        end
    end

end

function this:OnRoleAttrChange()
    
    ---@type table<number, CommonProtos.Item>
    local itemList = SL:GetMetaValue(EMetaVarGetKey.BAG_DATA)[1]
    if not itemList then
        return
    end

    for _, bagItem in pairs(itemList) do
--[[        if SL:CheckEquipWear(bagItem) == 1 then
       
        end]]
        self:TryAddNewEquip(nil, bagItem)
    end

    if GUI:GetUI("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel") then
        return
    end

    self:UpdateUseTipPanel()
end

---是否普通提示框
---@param boxItem BagProtos.BagItem
function this:IsNormalBox(boxItem)
    if not SL:HasConfig("cfg_item", boxItem.item.cfgId) then
        return false
    end
    local itemcfg = SL:GetConfig("cfg_item", boxItem.item.cfgId)
    local isBox = false
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    --其它
    if (itemcfg.type ~= 2 and itemcfg.bayWindow ~= 0) or self.quickPopUpItemIdList[boxItem.item.cfgId] then
        --判断能否使用
        if string.isNullOrEmpty(itemcfg.useLevelLimit) then
            isBox = true
        elseif level >= tonumber(itemcfg.useLevelLimit) then
            isBox = true
        else
            isBox = false
        end
    end
    return isBox
end

---添加普通提示框
---@param boxItem BagProtos.BagItem
function this:AddBoxItem(boxItem)
    if not SL:HasConfig("cfg_item", boxItem.item.cfgId) then
       return 
    end
    ---@type cfg_item_column
    local itemcfg = SL:GetConfig("cfg_item", boxItem.item.cfgId)
    if itemcfg then
        if itemcfg.bayWindow == 0 then
           return 
        end
        if itemcfg.type == E_ItemType.TriggerItem and itemcfg.subType == 3 then
            --技能书
            local canLearn = false
            ---@type cfg_career_column
            local career = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)
            if not career then
                return
            end
            for _, v in pairs(itemcfg.job) do
                if v[1] == career.baseCareer and v[2] == career.careerRank then
                    canLearn = true
                    break
                end
            end
            if not canLearn then
                return
            end
        end
    end
    
    local fIndex, boxItemData = table.findByCondi(normalItems, function(a)
        return a.itemId == boxItem.item.cfgId
    end)

    if fIndex then
        boxItemData.show = true
    else
        table.insert(normalItems, { itemId = boxItem.item.cfgId, show = true })
    end
end

---@param eventData BagProtos.BagItem[]  背包变化，刷新快捷提示UI
function this:UpdateBoxItem(_, eventData)
    for _, bagItem in pairs(eventData) do
        if bagItem.item then
            if self:IsNormalBox(bagItem) then
                self:AddBoxItem(bagItem)
            end
--[[            if SL:CheckEquipWear(bagItem.item) == 1 then
           
            end]]
            self:TryAddNewEquip(bagItem)
        end
    end

    if GUI:GetUI("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel") then
        return
    end

    self:UpdateUseTipPanel()
end

---获取可显示的一个普通提示框
---@return BoxItemData
function this:GetShowBoxItem()
    if table.count(normalItems) == 0 then
        return nil
    end
    for _, boxItemData in ipairs(normalItems) do
        if boxItemData.show then
            return boxItemData
        end
    end
    return nil
end

---刷新快捷提示UI: KLBagTipsPanel
function this:UpdateUseTipPanel()
    if self.delayUpdt then
        SL:UnSchedule(self.delayUpdt)
        self.delayUpdt = nil
    end

    self.delayUpdt = SL:ScheduleOnce(0.2, self.DelayUpdate, self)

end
function this:DelayUpdate()
    if not self:GetShowBoxItem() and not self:GetNewEquip() then
        GUI:UIPanel_Close("dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel")
        return
    end

    -- if DataManager.activityInfo.IsArenaMap then
    --     GUI:UIPanel_Close("dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel")
    --     return
    -- end

    if not SL:GetIsShowMainUI() then
        GUI:UIPanel_Close("dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel")
        return
    end

    ---@type KLBagTipsPanel
    local panel = GUI:GetUI("dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel")
    if panel and not panel.isLoading then
        panel:UpdataPanel()
        return
    end
    ---@param win KLBagTipsPanel
    GUI:UIPanel_Open("dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel", nil, nil, nil, nil, function(win)
        if GUI:IsWebGLAsync() then
            win:UpdataPanel()
        end
    end)
end
-------------------------------------------------装备相关----------------------------------------------------------------
function this:CareeritemjobCheck(job)
    if not job or table.count(job) == 0 then
        return true
    end
    ---@type cfg_career_column
    local career = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)
    if not career then
        return false
    end
    for _, v in pairs(job) do
        if v[1] == career.baseCareer and v[2] == career.careerRank then
            return true
        end
    end
    return false
end

local wearBarList = {}
---添加符合条件的新装备  装备/职业/评分
---@param bagItem BagProtos.BagItem
---@param item CommonProtos.Item
function this:TryAddNewEquip(bagItem, item)

    
    item = item or bagItem.item

--[[    if item.gmExtInfo.name == "女神之靴" then
        log("21222")
    end]]
    if item.endTime ~= 0 and item.endTime * 1000 <= Time.GetServerTime() then
        return
    end
    
    local itemCfg = SL:GetConfig("cfg_item",item.cfgId)
    if itemCfg.type == EItemType.Equip then
        if not self:IsAttrMeet(item) then
            return
        end
    end
    local modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg.shape[1])
    if modelCfg.part == 114 or modelCfg.part == 115 then -- 弓箭手单独处理, 箭袋不能单独穿
        self:ReMoveItemByID(item.id, item.cfgId)---有箭袋 先删除再判断是否能穿戴
    end
    
    if self:RemoveEquipRepeat(item.id) then
        return
    end


    if itemCfg.type ~= EItemType.Equip or not self:CareeritemjobCheck(itemCfg.job) or self.quickPopUpItemIdList[item.cfgId] then
        return
    end
    if itemCfg.bayWindow == 0 then
       return 
    end

    table.clear(wearBarList)
    if table.count(itemCfg.wearBarID) > 1 then
        local wearBars = SL:GetMetaValue("GET_OPEN_WEARBARS")
        if wearBars then
            for i, wearBarId in pairs(itemCfg.wearBarID) do
                if table.contains(wearBars, wearBarId) then
                    table.insert(wearBarList, wearBarId)
                end
            end
        else
            table.insert(wearBarList, itemCfg.wearBarID[1])
        end
    else
        table.insert(wearBarList, itemCfg.wearBarID[1])
    end
    

    for _, wearId in pairs(wearBarList) do
        local show = EquipFunc.CheckBagEquipIsBetter(item)
        if show then
            local pos = self:GetPutSlot(item, wearId)
            if equipList[wearId] == nil then
                equipList[wearId] = {}
            end
            local indexOfEquip = wearId << 16 | pos
            if not equipList[wearId][indexOfEquip] then
                equipList[wearId][indexOfEquip] = {}
            end
            if table.isNullOrEmpty(equipList[wearId][indexOfEquip]) then
                bagItem = bagItem or { item = item }
                table.insert(equipList[wearId][indexOfEquip], bagItem)
                break
            else
                ---穿戴部位唯一
                if table.count(itemCfg.strPart) == 1 then
                    if equipList[wearId][indexOfEquip][1].item == nil or EquipFunc.CompareItemGradeAndEntrys(equipList[wearId][indexOfEquip][1].item, item) then
                        equipList[wearId][indexOfEquip] = {}
                        bagItem = bagItem or { item = item }
                        table.insert(equipList[wearId][indexOfEquip], bagItem)
                    end
                elseif table.count(itemCfg.strPart) == 2 then
                    bagItem = bagItem or { item = item }
                    self:ReplaceLowEquip(equipList[wearId][indexOfEquip], bagItem)
                end

            end
        end

    end
    
end
function this:IsAttrMeet(item)
    if SL:MeData_Check() then
        --- 属性判断
        local needAttrs = EquipFunc.CheckAttrsCanEquip(item)
        local needPoint = 0
        if table.count(needAttrs) > 0 then
            for _, v in pairs(needAttrs) do
                needPoint = needPoint + v.subValue
            end
            local ownPoint = SL:GetMetaValue("REMAIN_ATTR_POINT")
            if ownPoint >= needPoint then
                return true
            else
                return false
            end
        end
        return true
    end
    return false
end

---替换已存在推荐列表的低评分装备
function this:ReplaceLowEquip(list, bagItem)
    ---没有装备，直接放入
    if table.isNullOrEmpty(list) then
        table.insert(list, bagItem)
    elseif table.count(list) == 1 then
        ---有一个装备，比较评分，评分高的置前
        if list[1] ~= nil and (list[1].item == nil or EquipFunc.CompareItemGradeAndEntrys(list[1].item, bagItem.item)) then
            table.insert(list, 1, bagItem)
        else
            table.insert(list, bagItem)
        end
    elseif table.count(list) == 2 then
        local pos = 0
        ---有两个装备装备，比较评分，评分高的置前
        for _, v in pairs(list) do
            if pos == 0 and EquipFunc.CompareItemGradeAndEntrys(v.item, bagItem.item) then
                pos = 1
            end
        end
        if pos ~= 0 then
            table.insert(list, pos, bagItem)
            table.remove(list, 3)
        end
    end
end

function this:GetNewEquip()
    for _, v in pairs(equipList) do
        if not table.isNullOrEmpty(v) then
            return true
        end
    end
end

--- 查找装备中的重复
function this:RemoveEquipRepeat(itemId)
    for _, v in pairs(equipList) do
        if not table.isNullOrEmpty(v) then
            --65537.65538
            for _, itemList in pairs(v) do
                if not table.isNullOrEmpty(itemList) then
                    --index,item
                    for _, bagItem in pairs(itemList) do
                        if bagItem then
                            if bagItem.item.id == itemId then
                                return true
                            end

                        end
                    end
                end
            end
        end
    end
    return false
end

---获取当前可穿戴装备
---@return BagProtos.BagItem,number
function this:GetShowEquip()
    for wearId, v in pairs(equipList) do
        if not table.isNullOrEmpty(v) then
            --65537.65538
            for equipIndex, itemList in pairs(v) do
                if not table.isNullOrEmpty(itemList) then
                    --index,item
                    for _, bagItem in pairs(itemList) do
                        ---返回装备,几转，装备穿戴部位
                        return bagItem, wearId, equipIndex
                    end
                end
            end
        end
    end
    return nil
end

---穿戴装备
function this:WearEquip()
    local bagItem, barID, indexEquip = self:GetShowEquip()
    if bagItem then
        SL:TryPutOnEquip(bagItem.item, bagItem.index, barID, indexEquip)
    end
end

---玩家有穿戴新装备时，刷新待穿戴列表，删除重复id以及低评分
---@param message EquipProto.PutOnTheEquipRes
function this:ResPutOnTheEquipMessage(_, message)
    local cfgId = message.equip.cfgId
    self:ReMoveItemByID(message.equip.id, cfgId)
    if not SL:HasConfig("cfg_item",cfgId) then
        return
    end
    local isUpdate = false
    local cfgItem = SL:GetConfig("cfg_item",cfgId)
    for i, wearId in pairs(cfgItem.wearBarID) do
        if equipList[wearId] and equipList[wearId][message.index] then
            equipList[wearId][message.index] = nil
            isUpdate = true
        end
    end
    if isUpdate then
        self:UpdateUseTipPanel()
    end
end

---删除当前可穿戴装备
function this:ReMoveNowItem()
    local temp = self:GetShowEquip()
    if temp then
        self:ReMoveItemByID(temp.item.id, temp.item.cfgId)
    end
end

---根据id查找并删除装备
function this:ReMoveItemByID(id, cfgId)
    for wearId, v in pairs(equipList) do
        if table.count(v) == 0 then
            equipList[wearId] = nil
        else
            for equipIndex, itemList in pairs(v) do
                if table.count(itemList) == 0 then
                    equipList[wearId][equipIndex] = nil
                else
                    for idx, bagItem in pairs(itemList) do
                        if bagItem.item.id == id or (bagItem.item.cfgId == cfgId and SL:GetConfig("cfg_item", cfgId).type ~= EItemType.Equip) then
                            equipList[wearId][equipIndex][idx] = nil
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

--批量使用宝箱
function this:UseBoxItem()
    local boxItems = self:GetShowBoxItem()
    if boxItems == nil then
        return
    end

    local useitems = {}
    local totalCount = 0
    local retList = {}
    local bagItems = SL:GetMetaValue(EMetaVarGetKey.BAG_DATA)[1]
    for _, indexAndItemTable in pairs(bagItems) do
        for index, item in pairs(indexAndItemTable) do
            if item.cfgId == boxItems.itemId then
                table.insert(retList, { index = 10000 + index, item = item })
            end
        end
    end
    for _, v in pairs(retList) do
        local useItem = {}
        useItem.index = v.index
        local canUseCount = (v.item.count + totalCount >= PATCH_USEBOX_COUNT) and (PATCH_USEBOX_COUNT - totalCount) or v.item.count
        useItem.count = canUseCount
        table.insert(useitems, useItem)
        totalCount = totalCount + canUseCount
        if totalCount >= PATCH_USEBOX_COUNT then
            break
        end
    end
    ---@param v BagProtos.UseItem
    for _, v in pairs(useitems) do
        SL:ReqUseItemMessage(v.index, tonumber(v.count))
    end
end

---提示框是否重复
function this:IsExistBoxItem(itemcfgId)
    if table.count(normalItems) == 0 then
        return false
    end
    for index, v in ipairs(normalItems) do
        if v.itemId == itemcfgId then
            return true, index
        end
    end
    return false
end

---删除对应的普通提示框
function this:DeleteBoxItem(itemcfgId)
    local exist, index = self:IsExistBoxItem(itemcfgId)
    if exist then
        table.remove(normalItems, index)
    else
        return
    end
end

function this:DelAllEquip()
    equipList = {}
    normalItems = {}
    self:UpdateUseTipPanel()
end

---隐藏全部的普通提示框
function this:HideBoxItem()
    if table.count(normalItems) == 0 then
        return
    end
    for _, v in ipairs(normalItems) do
        ---@type BoxItemData
        local boxItemData = v
        if boxItemData.show then
            boxItemData.show = false
            return
        end
    end
end


-- 返回穿戴位置
-- 该方法要重写
---@param item CommonProtos.Item
---@return EEquipSlotType
function this:GetPutSlot(item, wearBarId)
    local cfgId = item.cfgId
    local tbl = SL:GetConfig("cfg_item",cfgId)
    local strPart = tbl.strPart[1]

    -- 双手武器直接返回， 不进行判断
    if tbl.twoHanded == 1 then
        return EEquipSlotType.TwoHandWeapon
    end

    local allEquips = SL:GetTotalWearEquips() or {}
    if allEquips[wearBarId] and #tbl.strPart > 1 then
        local equips = allEquips[wearBarId]
        local canWears = {}
        for _, v in pairs(tbl.strPart) do
            canWears[v] = EquipFunc.CheckEquipWearLimit(item, v)
            if not equips[v] and canWears[v] then
                return v
            end
        end
        local equip1 = canWears[tbl.strPart[1]] and equips[tbl.strPart[1]] or nil
        local equip2 = canWears[tbl.strPart[2]] and equips[tbl.strPart[2]] or nil
        local pos
        --[[if equip1 and equip2 then
            pos = EquipFunc.CompareItemGradeAndEntrys(equip1, equip2) and tbl.strPart[1] or tbl.strPart[2]
        else]]if equip1 then
            pos = tbl.strPart[1]
        else
            pos = tbl.strPart[2]
        end
        return pos
    end

    -- 通常情况
    return strPart
end

function this:CompareItemGradeAndEntrys(oldItem, newItem)
    return EquipFunc.CompareItemGradeAndEntrys(oldItem, newItem)
end

---响应装备获取或放入槽位
function this:LUA_TRIGGER_EQUIP_GET_PUT_SLOT(item, wearBarId, allEquips)
    return self:GetPutSlot(item, wearBarId)
end

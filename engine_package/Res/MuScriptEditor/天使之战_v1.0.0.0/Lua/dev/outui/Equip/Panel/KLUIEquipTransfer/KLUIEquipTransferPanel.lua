---@class KLUIEquipTransferPanel:UIKmlLuaPanelBase
---@field view KLUIEquipTransferPanelView
local KLUIEquipTransferPanel = class(UIKmlLuaPanelBase)
local this = KLUIEquipTransferPanel
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.strengthenState = "0"
    self.appendState = "0"
    self.rebornState = "0"
    self.sourceId = nil
    self.targetId = nil
    GUI:UIPanel_Open("dev/outui/Bag/Panel/KLEquipBag/KLEquipBagPanel",
        nil, nil,
        {
            itemList = self:SortItemList(self:GetCanTransferItemList()),
            x = -482,
            bagType = EBagShowType.EquipTransfer,
            itemClickCallBack = self.ClickItemCallBack,
            callBackUI = self
        }, nil, function(panel)
        ---@type KLEquipBagPanel
        self.bagUI = panel
    end)
    local args = { type = "common", item = nil, default = { width = 133, height = 234 } }
    ---@type KLBagItemItem
    GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.panel_equip_source_item, self, args, true, function(item)
        self.sourceEquip = item
    end)
    ---@type KLBagItemItem
    GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.panel_equip_target_item, self, args, true, function(item)
        self.targetEquip = item
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.btn_transfer, self, self.Transfer)
    GUI:AddOnClickEvent(self.view.btn_equip_source_takeoff, self, self.SourceEquipTakeOff, { isTips = true })
    GUI:AddOnClickEvent(self.view.btn_equip_target_takeoff, self, self.TargetEquipTakeOff, { isTips = true })
    --GUI:SetToggleOnValueChange(self.view.toggle_transfer_reborn, self, self.ToggleRebornChange)
    GUI:SetToggleOnValueChange(self.view.toggle_transfer_append, self, self.ToggleAppendChange)
    GUI:SetToggleOnValueChange(self.view.toggle_transfer_strengthen, self, self.ToggleStrengthenChange)
    SL:RegisterLUAEvent(LUA_EVENT_TRANSFER_SUCCESS, self.RES_TRANSFER_EQUIP, self)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRANSFER_EQUIP, self.RES_TRANSFER_EQUIP, self)
    SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.CloseSelf, self)
end

function this:Transfer()
    if self.strengthenState == "1" or self.appendState == "1" or self.rebornState == "1" then
        if self.sourceId and self.targetId then
            if self.canTransfer then
                local overMax = false
                if self.strengthenState == "1" then
                    ---@type cfg_equip_strengthen_column
                    local tbl = SL:GetConfig("cfg_equip_strengthen", self.targetItem.cfgId)
                    if tbl.maxLevel < EquipFunc.GetEquipStrengthLevel(self.sourceItem) then
                        overMax = true
                    end
                end
                if self.appendState == "1" then
                    ---@type cfg_equip_appends_column
                    local tbl = SL:GetConfig("cfg_equip_appends", self.targetItem.cfgId)
                    if tbl.maxLevel < EquipFunc.GetEquipAppendLevel(self.sourceItem) then
                        overMax = true
                    end
                end
                if overMax then
                    SL:CommonTipsMessage({ stringTblID=213,ui = self, callback = function()
                        local message = {
                            firstItem = self.sourceItem.id,
                            secondItem = self.targetItem.id,
                            transferStrength = self.strengthenState == "1",
                            transferAppend  = self.appendState == "1",
                            transferRegeneration = self.rebornState == "1",
                        }
                        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRANSFER_EQUIP, message)
                    end })
                else
                    local message = {
                        firstItem = self.sourceItem.id,
                        secondItem = self.targetItem.id,
                        transferStrength = self.strengthenState == "1",
                        transferAppend  = self.appendState == "1",
                        transferRegeneration = self.rebornState == "1",
                    }
                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRANSFER_EQUIP, message)
                end
            else
                SL:TipMessage(SL:GetConfig('cfg_string',269).text, 1, NoticeType.NoticeMid )--"货币不足", 
            end
        else
            SL:TipMessage( SL:GetConfig('cfg_string',395).text, 1, NoticeType.NoticeMid )--"请选择转移项",
        end
    else
        SL:TipMessage( SL:GetConfig('cfg_string',270).text, 1, NoticeType.NoticeMid )--"请选择转移道具",
    end
    --GUI:UIPanel_Open("dev/outui/Equip/Panel/KLUIEquipQuickTransfer/KLUIEquipQuickTransferPanel", nil, nil, { sourceItem = self.sourceItem, targetItem = self.targetItem })
end

function this:SourceEquipTakeOff(_, eventData)
    if eventData and eventData.isTips then
        SL:CommonTipsMessage({ stringTblID=214, ui = self, callback = function()
            self.sourceId = nil
            self:TargetEquipTakeOff()
            self:RefreshEquipItemInfo(1)
        end })
    else
        if self.sourceId then
            self.sourceId = nil
            self:TargetEquipTakeOff()
            self:RefreshEquipItemInfo(1)
        end
    end
end

function this:TargetEquipTakeOff(_, eventData)
    if eventData and eventData.isTips then
        SL:CommonTipsMessage({stringTblID=214,ui = self, callback = function()
            self.targetId = nil
            self:RefreshEquipItemInfo(2)
        end })
    else
        if self.targetId then
            self.targetId = nil
            self:RefreshEquipItemInfo(2)
        end
    end
end

---@param control UIKmlLuaControl
function this:ToggleRebornChange(control)
    self.rebornState = GUI:Toggle_getIsOn(control)
    self:SourceEquipTakeOff()
    self.bagUI:RefreshBagItemShow(self:SortItemList(self:GetCanTransferItemList()))
    GUI:setVisible(self.view.text_reborn_tips, self.rebornState == "1")
end

---@param control UIKmlLuaControl
function this:ToggleAppendChange(control)
    self.appendState = GUI:Toggle_getIsOn(control)
    self:SourceEquipTakeOff()
    self.bagUI:RefreshBagItemShow(self:SortItemList(self:GetCanTransferItemList()))
end

---@param control UIKmlLuaControl
function this:ToggleStrengthenChange(control)
    self.strengthenState = GUI:Toggle_getIsOn(control)
    self:SourceEquipTakeOff()
    self.bagUI:RefreshBagItemShow(self:SortItemList(self:GetCanTransferItemList()))
end

---点击背包item回调
---@param itemControl KLBagItemItemView
---@param itemData CommonProtos.Item
function this:ClickItemCallBack(itemControl, itemData)
    if self.sourceId then
        if not self.targetId then
            self.targetId = itemData.id
            self.targetItem = itemData
            self:RefreshEquipItemInfo(2)
        end
    else
        if self.appendState ~= "1" and self.strengthenState ~= "1" and self.rebornState ~= "1" then
            SL:TipMessage( SL:GetConfig('cfg_string',270).text, 1, NoticeType.NoticeMid ) --"请选择转移项",
        else
            self.sourceId = itemData.id
            self.sourceItem = itemData
            self:RefreshEquipItemInfo(1)
            --self:GetCanInheritItemList(self.sourceItem.cfgId)
        end
    end
end

function this:RES_TRANSFER_EQUIP()
    --GUI:setVisible(self.view.success_anim, true)
    --if self.resultCoro ~= nil then
    --    Coroutine.Stop(self.resultCoro)
    --end
    --self.resultCoro = Coroutine.Start(
    --    function()
    --        Coroutine.Wait(1.5)
    --        GUI:setVisible(self.view.success_anim, false)
    --    end
    --)
    self:SourceEquipTakeOff()
end

function this:RefreshEquipItemInfo(itemType)
    if itemType == 1 then
        ---转移装备
        if self.sourceId then
            ---刷新转移栏
            self.sourceEquip:SetItem(self.sourceItem)
            GUI:SetActive(self.view.panel_equip_source_item, true)
            GUI:SetActive(self.view.img_equip_source_select, false)
            GUI:SetActive(self.view.img_equip_target_select, true)
            GUI:SetActive(self.view.btn_equip_source_takeoff, true)
            
            local costInfo = EquipFunc.GetTransferCost(self.sourceItem, self.strengthenState, self.appendState, self.rebornState)
            if costInfo.id ~= 0 then
                ---@type cfg_item_column
                local item = SL:GetConfig("cfg_item", costInfo.id)
                local bag_num = SL:GetBagItemCount(costInfo.id)
                GUI:Text_setString(self.view.text_cost_item_name, item.name)
                GUI:Item_setItemId(self.view.item_cost, item.id)
                GUI:setVisible(self.view.cost_panel, true)
                if bag_num >= costInfo.num then
                    self.canTransfer = true
                    bag_num = SL:GetSimpleNumber(bag_num, 2)
                    GUI:Text_setString(self.view.text_item_bag_count, "<color=#00ff00>" .. bag_num .. "</color> / " .. costInfo.num)
                else
                    self.canTransfer = false
                    bag_num = SL:GetSimpleNumber(bag_num, 2)
                    GUI:Text_setString(self.view.text_item_bag_count, "<color=#FF2323>" .. bag_num .. "</color> / " .. costInfo.num)
                end
            end
            
            self.bagUI:RefreshBagItemShow(self:SortItemList(self:GetCanInheritItemList(self.sourceItem.cfgId)))
        else
            ---清空转移栏
            GUI:SetActive(self.view.panel_equip_source_item, false)
            GUI:SetActive(self.view.img_equip_source_select, true)
            GUI:SetActive(self.view.img_equip_target_select, false)
            GUI:SetActive(self.view.btn_equip_source_takeoff, false)
            GUI:setVisible(self.view.cost_panel, false)
            self.bagUI:RefreshBagItemShow(self:SortItemList(self:GetCanTransferItemList()))
        end
    else
        ---继承装备
        if self.targetId then
            ---刷新继承栏
            self.targetEquip:SetItem(self.targetItem)
            GUI:Button_loadTextureNormal(self.view.btn_transfer, "button_interface_window37", "Atlas/TS_Common.spriteatlas")
            GUI:SetActive(self.view.panel_equip_target_item, true)
            GUI:SetActive(self.view.img_equip_target_select_text, false)
            GUI:SetActive(self.view.img_equip_target_select, false)
            GUI:SetActive(self.view.btn_equip_target_takeoff, true)
        else
            ---清空继承栏
            GUI:Button_loadTextureNormal(self.view.btn_transfer, "button_interface_window37_gery", "Atlas/TS_Common.spriteatlas")
            GUI:SetActive(self.view.panel_equip_target_item, false)
            GUI:SetActive(self.view.img_equip_target_select_text, true)
            GUI:SetActive(self.view.img_equip_target_select, true)
            GUI:SetActive(self.view.btn_equip_target_takeoff, false)
        end
    end
end

---获取可转移装备
function this:GetCanTransferItemList()
    local canItemList = {}
    local itemList = self:GetAllEquipInTransfer()
    for i, v in ipairs(itemList) do
        local canSet = true
        local strength = EquipFunc.GetEquipStrengthLevel(v)
        local append = EquipFunc.GetEquipAppendLevel(v)
        local rebornItem = EquipFunc.GetEquipRegenerate(v)
        local reborn = false
        if rebornItem and next(rebornItem) then
            reborn = true
        end
        ---@type cfg_equip_transfer_column
        local sourceItem = SL:GetConfig("cfg_equip_transfer", v.cfgId)
        if self.strengthenState == "1" then
            if sourceItem.transfer[1] == 1 then
                if strength == 0 then
                    canSet = false
                end
            else
                canSet = false
            end
        end

        if self.appendState == "1" then
            if sourceItem.transfer[2] == 1 then
                if append == 0 then
                    canSet = false
                end
            else
                canSet = false
            end
        end

        if self.rebornState == "1" then
            if sourceItem.transfer[3] == 1 then
                if not reborn then
                    canSet = false
                end
            else
                canSet = false
            end
        else
            if self.strengthenState == "1" and reborn then
                canSet = false
            end
        end
        
        if append == 0 and strength == 0 and not reborn then
            canSet = false
        end

        if canSet then
            canItemList[#canItemList + 1] = v
        end
    end
    return canItemList
end

---获取可继承装备
function this:GetCanInheritItemList(cfg_id)
    local canItemList = {}
    ---@type CommonProtos.Item[]
    local itemList = self:GetAllEquipInTransfer()
    ---@type cfg_equip_transfer_column
    local sourceItem = SL:GetConfig("cfg_equip_transfer", cfg_id)
    local sourceGroup = sourceItem.transferGroup
    local sourceReborn = sourceItem.regenerationGroup
    for _, v in pairs(itemList) do
        local canTransfer = true
        if v.id ~= self.sourceId then
            ---@type cfg_equip_transfer_column
            local targetItem = SL:GetConfig("cfg_equip_transfer", v.cfgId)
            if self.strengthenState == "1" then
                if targetItem.transferGroup and targetItem.transferGroup == sourceGroup then
                    if EquipFunc.GetEquipStrengthLevel(v) ~= 0 then
                        canTransfer = false
                    end
                else
                    canTransfer = false
                end
            end

            if canTransfer and self.appendState == "1" then
                if targetItem.transferGroup and targetItem.transferGroup == sourceGroup then
                    if EquipFunc.GetEquipAppendLevel(v) ~= 0 then
                        canTransfer = false
                    end
                else
                    canTransfer = false
                end
            end

            if canTransfer and self.rebornState == "1" then
                if targetItem.regenerationGroup and targetItem.regenerationGroup == sourceReborn then
                    local rebornItem = EquipFunc.GetEquipRegenerate(v)
                    local reborn = false
                    if rebornItem and next(rebornItem) then
                        reborn = true
                    end
                    if reborn then
                        canTransfer = false
                    end
                    if canTransfer and self.strengthenState == "0" then
                        ---@type cfg_equip_regeneration_column
                        local regeneration = SL:GetConfig("cfg_equip_regeneration", v.cfgId)
                        if not regeneration or regeneration.condition > EquipFunc.GetEquipStrengthLevel(v) then
                            canTransfer = false
                        end
                    end
                else
                    canTransfer = false
                end
            end

            if canTransfer then
                canItemList[#canItemList + 1] = v
            end
        end
    end
    return canItemList
end

---@return CommonProtos.Item[]
function this:GetAllEquipInTransfer()
    ---@type CommonProtos.Item[]
    local bagData = SL:GetMetaValue(EMetaVarGetKey.BAG_DATA)
    ---@type CommonProtos.Item[]
    local equipData = SL:GetMetaValue(EMetaVarGetKey.EQUIP_DATA)
    local equip_list = {}
    if equipData[1] then
        for _, v in pairs(equipData[1]) do
            local hasCfg = SL:HasConfig("cfg_equip_transfer", v.cfgId, "id")
            if hasCfg then
                local item = SL:GetConfig("cfg_equip_transfer", v.cfgId)
                if item then
                    equip_list[#equip_list + 1] = v
                end
            end
        end
    end
    if bagData[1] then
        for _, v in pairs(bagData[1]) do
            local hasCfg = SL:HasConfig("cfg_equip_transfer", v.cfgId, "id")
            if hasCfg then
                local item = SL:GetConfig("cfg_equip_transfer", v.cfgId)
                if item then
                    equip_list[#equip_list + 1] = v
                end
            end
        end
    end
    return equip_list
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

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLEquipBag/KLEquipBagPanel")
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLUIEquipTransfer/KLUIEquipTransferPanel")
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
end

function this:Close()
end

return this

---@class KLNewNewSynthesisCostItem:UIKmlLuaPanelBase
---@field view KLNewNewSynthesisCostItemView
local KLNewNewSynthesisCostItem = class(UIKmlLuaPanelBase)
local this =KLNewNewSynthesisCostItem

---创建时调用一次
function this:Init()
    self.bindCount = 0
    self.unBindCount = 0
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Add, self, self.OnClick_Btn_Add)
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

---@param costType number 材料类型, 1：主要材料，2：次要材料，3：辅助材料
---@param costData NewNewSynthesisCostInfo
function this:UpdateData(index, costType, costData, resetCostCount)
    self.index = index
    self.costType = costType
    self.data = costData
    self.itemCfgId = self:GetItemCfgId(costData) 
    GUI:Item_setItemId(self.view.item, self.itemCfgId)
    self:UpdateItemData(costData and costData.item or nil)
    self:RefreshCount(costData)
    self.openPanelType = nil
    if costData == nil or resetCostCount then
        self.bindCount = 0
        self.unBindCount = 0
    end
    if costType == 1 then
        GUI:setVisible(self.view.Img_Add, costData == nil or costData.item == nil)
        GUI:setVisible(self.view.Img_Unknown, false)
        self.openPanelType = ESynthesisOpenPanelType.ItemSelect
        if costData and costData.item ~= nil then
            GUI:setVisible(self.view.Img_Bind, EquipFunc.GetItemIsBind(_, costData.item))
        else
            GUI:setVisible(self.view.Img_Bind, false)
        end
    else
        GUI:setVisible(self.view.Img_Unknown, costData == nil)
        if costData == nil then
            GUI:setVisible(self.view.Img_Add, false)
            GUI:setVisible(self.view.Img_Bind, false)
            return
        end
        if costData.bindCount == nil then costData.bindCount = 0 end
        local itemCfg = SL:HasConfig("cfg_item", self.itemCfgId) and SL:GetConfig("cfg_item", self.itemCfgId) or nil
        if costData.consumeItem[1] == 3 then
            self.openPanelType = ESynthesisOpenPanelType.ItemSelect
            GUI:setVisible(self.view.Img_Bind, EquipFunc.GetItemIsBind(_, costData.item))
        elseif itemCfg then
            if itemCfg.type == E_ItemType.Equip then
                self.openPanelType = ESynthesisOpenPanelType.ItemSelect
                GUI:setVisible(self.view.Img_Bind, EquipFunc.GetItemIsBind(_, costData.item))
            else
                self.openPanelType = ESynthesisOpenPanelType.BindSelect
                GUI:setVisible(self.view.Img_Bind, costData.bindCount > 0)
            end
        end
        GUI:setVisible(self.view.Img_Add, (itemCfg == nil or itemCfg.type ~= E_ItemType.Equip) and costData.item == nil)
    end
end

function this:UpdateItemData(item)
    if item == nil then
        GUI:setVisible(self.view.equipInfo, false)
        return
    end
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", item.cfgId)
    GUI:setVisible(self.view.equipInfo, itemCfg.type == E_ItemType.Equip)
    if itemCfg.type ~= E_ItemType.Equip then
        GUI:setPosition(self.view.Img_Bind, 0, 0)
        return
    end
    GUI:setPosition(self.view.Img_Bind, 38, -35)
    ---是否显示幸运图标
    if not table.isNullOrEmpty(EquipFunc.GetEquipLuckyAttr(item)) then
        GUI:setVisible(self.view.xinyun, true)
    end

    --强化等级
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(item)
    GUI:setVisible(self.view.strengthLevel, true)
    GUI:Text_setString(self.view.strengthLevel, strengthLevel ~= 0 and ("+" .. strengthLevel) or "")
    --追加等级
    local appendLv = EquipFunc.GetEquipAppendLevel(item)
    GUI:setVisible(self.view.appendLevel, true)
    GUI:Text_setString(self.view.appendLevel, appendLv ~= 0 and EquipFunc.GetEquipAppendLevelStr(appendLv) or "")

    --装备品阶及卓越词条数量
    local entryCount = 0
    local pos = itemCfg.strPart[1]
    if pos and pos >= EEquipSlotType.Weapon and pos <= EEquipSlotType.Boot then
        local entryAttr = SL:GetEquipEntrys(item)
        entryCount = table.count(entryAttr)
    end
    GUI:setVisible(self.view.quality, true)
    if not self.qualityItem then
        ---@param win KLEquipQualityEntryItem
        GUI:UIPanel_Open("dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem",
                         self.view.quality, self, {}, nil, function(win)
             self.qualityItem = win
             self.qualityItem:SetData(item.cfgId, entryCount)
             GUI:setScale(self.qualityItem.view.root, 0.7)
         end)
    else
        self.qualityItem:SetData(item.cfgId, entryCount)
        GUI:setScale(self.qualityItem.view.root, 0.7)
    end
end

---刷新数量
function this:RefreshCount(costData)
    GUI:setVisible(self.view.Count, costData ~= nil)
    if costData == nil then
        return
    end
    local needCount = costData.needCount
    local count = costData.item and costData.item.count or 0
    count = count + (costData.bindCount or 0)
    self:SetCountText(count,needCount)
end

function this:SetCount(cfgId, count)
    if EquipFunc.GetItemIsBind(cfgId) then
        self.bindCount = count
    else
        self.unBindCount = count
    end 
    self:SetCountText(self.bindCount + self.unBindCount, self.data.needCount)
end

function this:SetCountText(totalCount, needCount)
    if needCount < 0 then
        GUI:Text_setText(self.view.Text_Count, string.format("<color=%s>%d</color>", totalCount > 0 and "#00FF00" or "#FF2323", totalCount))
    else
        GUI:Text_setText(self.view.Text_Count, string.format("<color=%s>%d</color>/%d", totalCount >= needCount and "#00FF00" or "#FF2323", totalCount, needCount))
    end
end

function this:ConfirmCount()
    GUI:setVisible(self.view.Img_Bind, self.bindCount > 0)
    self.data.bindCount = self.bindCount
    self.data.item.count = self.unBindCount
end

function this:ResetCount()
    self.bindCount = self.data.bindCount
    self.unBindCount = self.data.item.count
    GUI:setVisible(self.view.Img_Bind, self.bindCount > 0)
    self:SetCountText(self.bindCount + self.unBindCount, self.data.needCount)
end

function this:GetItemCfgId(costData)
    if costData == nil then
        return 0
    end
    if costData.item then
        return costData.item.cfgId
    end
    if costData.consumeItem[1] == 1 then
        return costData.consumeItem[2]
    elseif costData.consumeItem[1] == 2 then
        return costData.consumeItem[6]
    end
    return 0
end

---点击添加按钮
function this:OnClick_Btn_Add()
    if self.openPanelType == nil then
        return
    end
    SL:onLUAEvent(LUA_EVENT_SYNTHESIS_COST_OPEN_PANEL, self.costType, self.index, self.openPanelType)
    --[[if self.hasClickEvent then
        SL:onLUAEvent(LUA_EVENT_SYNTHESIS_COST_OPEN_PANEL, self.costType, self.index, self.openSelectCount)
        return
    end
    if self.openTips then
        SL:OpenTips("bag", self.itemCfgId, nil, nil, nil, { hideBtn = true })
    end]]
end

return this

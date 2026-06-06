---@class KLNewNewSynthesisCostSelectItem:UIKmlLuaPanelBase
---@field view KLNewNewSynthesisCostSelectItemView
local KLNewNewSynthesisCostSelectItem = class(UIKmlLuaPanelBase)
local this =KLNewNewSynthesisCostSelectItem

---创建时调用一次
function this:Init()
    GUI:setScale(self.view.strengthLevel, 0.85)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.item_click, self, self.OnClick)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
end

---@param data NewNewSynthesisCostInfo
function this:UpdateData(data, index, isSelect)
    self.data = data
    self.index = index
    self:UpdateItemData(data.item)
    GUI:setVisible(self.view.select, isSelect)
end

function this:UpdateItemData(item)
    GUI:Item_setItemId(self.view.item, item.cfgId)
    GUI:Item_setItemCount(self.view.item, item.count > 1 and tostring(item.count) or "")
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", item.cfgId)
    GUI:setVisible(self.view.equipInfo, itemCfg.type == E_ItemType.Equip)
    GUI:setVisible(self.view.Img_Bind, EquipFunc.GetItemIsBind(_, item))
    if itemCfg.type ~= E_ItemType.Equip then
        GUI:setPosition(self.view.Img_Bind, 0, 0)
        return
    end
    GUI:setPosition(self.view.Img_Bind, 43, -39)
    GUI:Item_setItemCount(self.view.item, "")
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

function this:OnClick()
    self.baseUI:SelectItem(self.data, self.index)
end

function this:SetSelect(isSelect)
    GUI:setVisible(self.view.select, isSelect)
end

return this

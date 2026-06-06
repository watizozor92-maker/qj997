---@class KLTaskLoopSelectItem:UIKmlLuaPanelBase
---@field view KLTaskLoopSelectItemView
local KLTaskLoopSelectItem = class(UIKmlLuaPanelBase)
local this = KLTaskLoopSelectItem

---创建时调用一次
function this:Init()
    GUI:setScale(self.view.strengthLevel, 0.85)
    GUI:SetZIndex(self.view.equipInfo, 5)
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

---@param data CommonProtos.Item
function this:UpdateData(data, isSelect)
    local a = data
    self.data = data
    GUI:Item_setItemId(self.view.item, data.cfgId)
    GUI:setVisible(self.view.select, isSelect)
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
end

function this:OnClick()
    self.baseUI:SelectItem(self.data)
end

function this:SetSelect(isSelect)
    GUI:setVisible(self.view.select, isSelect)
end

function this:Hide()
end

function this:Close()
end

return this

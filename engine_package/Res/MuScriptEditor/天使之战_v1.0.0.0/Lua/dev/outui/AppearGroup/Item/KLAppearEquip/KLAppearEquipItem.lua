---@class KLAppearEquipItem:UIKmlLuaPanelBase
---@field view KLAppearEquipItemView
---@field baseUI KLAppearPartItem
local KLAppearEquipItem = class(UIKmlLuaPanelBase)
local this = KLAppearEquipItem
---创建时调用一次
function this:Init()
    self.equipAttItems = {}
    self.lastClick = 0
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param item CommonProtos.Item
function this:UpdateUI(item, isSelect)
    self.waitUpdt = SL:Schedule(self.waitUpdt, 0, Time.deltaTime, -1, function()
        if self.isLoading then
            return
        end
        SL:UnSchedule(self.waitUpdt)
        self.cfgId = item.cfgId or tonumber(item.itemId)
        GUI:Item_setItemId(self.view.EquipItem, tostring(self.cfgId))
        GUI:setVisible(self.view.img_quality, false)
        GUI:setVisible(self.view.strengthLevel, false)
        GUI:setVisible(self.view.appendLevel, false)
        if item.cfgId then
            --装备品阶
            if SL:HasConfig('cfg_equip_entryLib', self.cfgId) then
                ---@type cfg_equip_entryLib_column
                local entryLib = SL:GetConfig('cfg_equip_entryLib', self.cfgId)
                local qualityTbl = SL:GetConfigTable("cfg_equip_quality")
                ---@param v cfg_equip_quality_column
                for _, v in pairs(qualityTbl) do
                    if not string.isNullOrEmpty(v.logo) and entryLib.initialRating >= v.stage[1] and entryLib.initialRating <= v.stage[2] then
                        GUI:setVisible(self.view.img_quality, true)
                        GUI:Image_loadTexture(self.view.img_quality, v.logo, "Atlas/AppearGroup.spriteatlas")
                        break
                    end
                end
            end

            ---@type cfg_item_column
            local itemCfg = SL:GetConfig("cfg_item", self.cfgId)
            --卓越词条数量
            local pos = itemCfg.strPart[1]
            if pos and pos >= EEquipSlotType.Weapon and pos <= EEquipSlotType.Boot then
                local entryAttr = SL:GetEquipEntrys(item)
                local count = entryAttr and table.count(entryAttr) or 0
                self:ClearEquipAttrItems()
                for i = 1, count do
                    local attItem = GUI:UIPanel_Open("dev/ui/Equip/Item/KLCommonImage/KLCommonImageItem", self.view.img_quality, self, {
                        sprite = "img_equipAtt", altas = "Atlas/UIBagPanel.spriteatlas"
                    }, true)
                    table.insert(self.equipAttItems, attItem)
                    attItem:SetSize(20, 20)
                    attItem:SetPosition(-2, -18 - (i - 1) * 8)
                end
            end

--[[            --强化等级
            local strengthLevel = EquipFunc.GetEquipStrengthLevel(item)
            GUI:setVisible(self.view.strengthLevel, true)
            GUI:Text_setString(self.view.strengthLevel, strengthLevel ~= 0 and ("+" .. strengthLevel) or "")
            --追加等级
            local appendLv = EquipFunc.GetEquipAppendLevel(item)
            GUI:setVisible(self.view.appendLevel, true)
            GUI:Text_setString(self.view.appendLevel, appendLv ~= 0 and ("+" .. appendLv) or "")]]

        end

        if isSelect then
            self:BtnEquipOnSelect()
        else
            self:SetState(false)
        end
        
    end)

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnEquip, self, self.BtnEquipOnSelect)

    SL:RegisterLUAEvent(APPEAR_SELECT_ITEM, self.OnCheckItemSelect, self)
end

---@param cfgId number
function this:OnCheckItemSelect(_, cfgId)
    if not cfgId or cfgId ~= self.cfgId then return end
    self:BtnEquipOnSelect()
end

function this:BtnEquipOnSelect()
    if Time.frameCount - self.lastClick < 3 then
        return
    end

    self.lastClick = Time.frameCount
    return self.baseUI:BtnEquipOnSelect(self, self.cfgId)
end

function this:SetState(isSelect)
    return GUI:SetActive(self.view.SpState, isSelect)
end

function this:Close()
    if self.waitUpdt then
        SL:UnSchedule(self.waitUpdt)
        self.waitUpdt = nil
    end
end

function this:ClearEquipAttrItems()
    for _, v in pairs(self.equipAttItems) do
        GUI:UIPanel_Close("dev/ui/Equip/Item/KLCommonImage/KLCommonImageItem", v)
    end
    table.clear(self.equipAttItems)
end

return this

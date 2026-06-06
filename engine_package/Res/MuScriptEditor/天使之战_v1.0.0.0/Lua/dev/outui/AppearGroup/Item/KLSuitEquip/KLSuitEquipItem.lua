---@class KLSuitEquipItem:UIKmlLuaPanelBase
---@field view KLSuitEquipItemView
---@field baseUI KLSuitItem
---@field
local KLSuitEquipItem = class(UIKmlLuaPanelBase)
local this = KLSuitEquipItem
---创建时调用一次
function this:Init()
    self.lastClick = 0
end

function this:UpdateUI(suitIndex, luaIndex, cfgId, isSelect, isUnlocked)
    self.suitIndex = suitIndex
    self.luaIndex = luaIndex
    self.isUnlocked = isUnlocked
    GUI:Item_setItemId(self.view.EquipItem, cfgId)
    GUI:setVisible(self.view.img_quality, false)
    --装备品阶
    if SL:HasConfig('cfg_equip_entryLib', cfgId) then
        ---@type cfg_equip_entryLib_column
        local entryLib = SL:GetConfig('cfg_equip_entryLib', cfgId)
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
    
    if isSelect then
        self:BtnEquipOnSelect()
    else
        self:SetState(false)
    end

    
    GUI:SetActive(self.view.SpMask, not isUnlocked)
    GUI:SetActive(self.view.SpLock, not isUnlocked)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnEquip, self, self.BtnEquipOnSelect)
end

function this:BtnEquipOnSelect()
    if not self.lastClick then
        self.lastClick = 0
    end
    if Time.frameCount - self.lastClick < 3 then
        return
    end

    self.lastClick = Time.frameCount
    return self.baseUI.baseUI:OnEquipItemSelect(self, self.suitIndex, self.luaIndex, self.isUnlocked)
end

function this:SetState(isSelect)
    return GUI:SetActive(self.view.SpState, isSelect)
end

function this:Close()
end

return this

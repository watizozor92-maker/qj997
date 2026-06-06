---@class KLTransferRingItem:UIKmlLuaPanelBase
---@field view KLTransferRingItemView
---@field baseUI KLTransferRingPanel
---@field ringId number
local KLTransferRingItem = class(UIKmlLuaPanelBase)
local this = KLTransferRingItem
---创建时调用一次
function this:Init()
    self.lastClick = 0
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param dt RingData
function this:UpdateUI(dt, isSelect)
    self.ringId = dt.itemId
    GUI:Item_setItemId(self.view.Item, dt.itemId)

    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", dt.itemId)

    GUI:Text_setString(self.view.TxtName, itemTbl.name)

    if dt.time == -1 then
        GUI:SetActive(self.view.TxtTime, true)
        GUI:SetActive(self.view.TimeDown, false)
        GUI:Text_setString(self.view.TxtTime, "永久生效")

    else
        GUI:SetActive(self.view.TimeDown, true)
        GUI:SetActive(self.view.TxtTime, false)

        local svTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local countdown = dt.time - svTime / 1000
        countdown = math.floor(countdown)

        GUI:SetControl_time(self.view.TimeDown, countdown)
    end

    if isSelect then
        self:RingItemOnClick()
    else
        self:SetIsSelect(false)
    end

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Bg, self, self.RingItemOnClick)
    GUI:AddOnClickEvent(self.view.Item, self, self.OnItemClick)
    SL:RegisterLUAEvent(TRANSFER_RING_SELECT_ITEM, self.OnCheckItemSelect, self)
end

function this:OnItemClick()
    return SL:OpenTips(nil, self.ringId)
end

---@param cfgId number
function this:OnCheckItemSelect(_, cfgId)
    if not cfgId or cfgId ~= self.ringId then return end
    self:RingItemOnClick()
end

function this:RingItemOnClick()
    if Time.frameCount - self.lastClick < 3 then
        return
    end

    self.lastClick = Time.frameCount
    return self.baseUI:RingItemOnClick(self, self.ringId)
end

function this:SetIsSelect(isSelect)
    local spName = isSelect and "tab_title_selected" or "tab_title_unselect"
    GUI:Image_loadTexture(self.view.SpState, spName, "Atlas/AppearGroup.spriteatlas")
end

function this:Close()
end

return this

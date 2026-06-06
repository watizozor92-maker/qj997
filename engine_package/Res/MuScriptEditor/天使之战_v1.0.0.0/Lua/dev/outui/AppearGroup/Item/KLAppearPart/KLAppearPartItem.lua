---@class KLAppearPartItem:UIKmlLuaPanelBase
---@field view KLAppearPartItemView
---@field baseUI KLAppearPanel
---@field curEquipItem KLAppearEquipItem
---@field curCfgId number
local KLAppearPartItem = class(UIKmlLuaPanelBase)
local this = KLAppearPartItem
---创建时调用一次
function this:Init()

    GUI:DataListInitData(self.view.datalist11,
            function()
                return self:ItemCountFunc()
            end,
            function(realIndex)
                return self:ItemGetFunc(realIndex)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemInitFunc(realIndex, kmlCtrl)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemUpdateFunc(realIndex, kmlCtrl)
            end)

    ---@type table<KingML.KmlControl,KLAppearEquipItem>
    self.equipItems = {}

end

function this:ItemCountFunc()
    return #self.equips
end

function this:ItemGetFunc()
    ---@type KLAppearEquipItem
    local item = GUI:UIPanel_Open("dev/outui/AppearGroup/Item/KLAppearEquip/KLAppearEquipItem", self.view.datalist11, self, nil, true)
    
    local kmlCtrl = item.view.root
    self.equipItems[kmlCtrl] = item
    return kmlCtrl
end

function this:ItemInitFunc(realIndex, kmlCtrl)
end

---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local item = self.equipItems[kmlCtrl]
    local luaIndex = realIndex + 1
    local dt = self.equips[luaIndex]

    local cfgId
    if self.slot == E_AppearEquipType.Guard and not dt.cfgId then
        cfgId = tonumber(dt.itemId)
    else
        cfgId = dt.cfgId
    end

    local tmpCfgId

    for _, part in pairs(E_AppearType2StrPart[self.slot]) do
        if self.appearCfgIds[part] then
            tmpCfgId = self.appearCfgIds[part]
            break
        end
    end
    local isSelect = tmpCfgId and tmpCfgId == cfgId
    item:UpdateUI(dt, isSelect)
end

---@param equipItem KLAppearEquipItem
function this:BtnEquipOnSelect(equipItem, cfgId)
    if self.curEquipItem then
        self.curEquipItem:SetState(false)
    end
    local oldId = self.curCfgId
    if self.curEquipItem and self.curCfgId == cfgId then
        self.curCfgId = nil
        self.curEquipItem = nil
    else
        self.curEquipItem = equipItem
        self.curCfgId = cfgId
        equipItem:SetState(true)
    end

    return self.baseUI:OnEquipItemSelect(oldId, cfgId, self.slot)

end

---@param appearCfgIds table<EEquipSlotType,number>
---@param equips CommonProtos.Item[]
function this:UpdateUI(appearCfgIds, equips, slot, itemY, luaIndex)
    self.waitUpdt = SL:Schedule(self.waitUpdt, 0, Time.deltaTime, -1, function()
        if self.isLoading then
            return
        end
        SL:UnSchedule(self.waitUpdt)
        
        self.appearCfgIds = appearCfgIds
        self.equips = equips
        self.slot = slot
        self.title = E_AppearTypeStr[slot]
        self.itemY = itemY
        self.luaIndex = luaIndex
        self.curCfgId = nil
        GUI:Text_setString(self.view.Title, self.title)
        local w = GUI:GetWidth(self.view.root)
        GUI:setContentSize(self.view.root, w, self.itemY)
        GUI:DataListUpdateData(self.view.datalist11)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
    if self.waitUpdt then
        SL:UnSchedule(self.waitUpdt)
        self.waitUpdt = nil
    end
end

return this

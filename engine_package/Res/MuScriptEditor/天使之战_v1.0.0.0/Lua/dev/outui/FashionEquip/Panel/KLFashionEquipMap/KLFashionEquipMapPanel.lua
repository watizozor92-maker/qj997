---@class KLFashionEquipMapPanel:UIKmlLuaPanelBase
---@field view KLFashionEquipMapPanelView
---@field fashionMapList KLFashionEquipMapItem[]
local KLFashionEquipMapPanel = class(UIKmlLuaPanelBase)
local this =KLFashionEquipMapPanel

local suitList = {
    280001, 280002, 280003
}

local suitToString = {
    [280001] = 38003,
    [280002] = 38002,
    [280003] = 38001
}

local activeRelationShip = {
    [280001] = 2,
    [280002] = 3,
    [280003] = 4
}

---创建时调用一次
function this:Init()
    self.MapCfgDatas = EquipFunc.GetMeFashionEquipCfgs()
    
    self.fashionMapList = {}
    GUI:DataListInitData(self.view.DataList_Attr, function()
        return table.count(suitList)
    end, function(realIndex)
        local item = GUI:UIPanel_Open("dev/outui/FashionEquip/Item/KLFashionEquipMap/KLFashionEquipMapItem", self.view.DataList_Attr,
                self, nil, true, function(mapItem)
                    local globalId = suitList[realIndex + 1]
                    local stringId = suitToString[globalId]
                    mapItem:RefreshMapCfg(globalId, stringId, self.activeCount >= activeRelationShip[globalId])
                end)
        self.fashionMapList[item.view.root] = item
        return item.view.root
    end, function()
        
    end, function(realIndex, kmlControl)
        if self.fashionMapList[kmlControl] then
            local globalId = suitList[realIndex + 1]
            local stringId = suitToString[globalId]
            self.fashionMapList[kmlControl]:RefreshMapCfg(globalId, stringId, self.activeCount >= activeRelationShip[globalId])
        end
    end)

end

function this:GetActiveCount()
    local activeCount = 0
    for _, v in pairs(self.MapCfgDatas) do
        local active = true
        for _, cfgId in pairs(v.fashionId) do
            local itemCfg = SL:GetConfig("cfg_item", cfgId)
            local item = SL:MeData_GetEquipByPosAndWearBar(itemCfg.strPart[1], v.wearing)
            if not item then
                active = false
                break
            end
        end
        if active then
            activeCount = activeCount + 1
        end
    end
    return activeCount
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseSelf)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, self.LUA_EVENT_PLAYER_EQUIP_CHANGE, self)
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
end

function this:LUA_EVENT_PLAYER_EQUIP_CHANGE() 
    local activeCount = self:GetActiveCount()
    if not self.activeCount then
        self.activeCount = activeCount
    end
    if activeCount ~= self.activeCount then
        self.activeCount = activeCount
        GUI:DataListUpdateData(self.view.DataList_Attr)
    end
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.activeCount = self:GetActiveCount()
    GUI:DataListUpdateData(self.view.DataList_Attr)
end

function this:Hide()
end

function this:Close()
end

return this

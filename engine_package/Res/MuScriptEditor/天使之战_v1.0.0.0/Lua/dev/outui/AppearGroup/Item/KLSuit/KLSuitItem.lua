---@class KLSuitItem:UIKmlLuaPanelBase
---@field view KLSuitItemView
---@field baseUI KLSuitPanel
---@field equips cfg_fashion_column[]
local KLSuitItem = class(UIKmlLuaPanelBase)
local this = KLSuitItem
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

    ---@type table<KingML.KmlControl,KLSuitEquipItem>
    self.equipItems = {}
end

function this:ItemCountFunc()
    return #self.equips
end

function this:ItemGetFunc()
    ---@type KLSuitEquipItem
    local item = GUI:UIPanel_Open("dev/outui/AppearGroup/Item/KLSuitEquip/KLSuitEquipItem", self.view.datalist11, self, nil, true)

    
    
    local kmlCtrl = item.view.root
    self.equipItems[kmlCtrl] = item
    return kmlCtrl
end

function this:ItemInitFunc()
end

---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local item = self.equipItems[kmlCtrl]
    local luaIndex = realIndex + 1

    local dt = self.equips[luaIndex]
    local isSelect = table.contains(self.appearCfgIds, dt.id)
    local isUnlocked = table.contains(self.stateCfgIds, dt.id)
    
    if not isUnlocked then
        isSelect = false
    end
    
    item:UpdateUI(self.suitIndex,luaIndex,dt.id, isSelect,isUnlocked)
end

---@param appearCfgIds table<EEquipSlotType,number>
---@param equips cfg_fashion_column[]
function this:UpdateUI(appearCfgIds, stateCfgIds, equips, titleStr, itemY, suitIndex)
    ---@type table<EEquipSlotType,number>
    self.appearCfgIds = appearCfgIds
    self.stateCfgIds = stateCfgIds
    self.equips = equips
    self.title = titleStr
    self.itemY = itemY
    self.suitIndex = suitIndex

    GUI:Text_setString(self.view.Title, self.title)
    local w = GUI:GetWidth(self.view.root)
    GUI:setContentSize(self.view.root, w, self.itemY)
    SL:ScheduleOnce(0.1, function()
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
end

return this

---@class KLRenderItem:UIKmlLuaPanelBase
---@field view KLRenderItemView
---@field baseUI KLRenderPanel
local KLRenderItem = class(UIKmlLuaPanelBase)
local this = KLRenderItem
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

    self.equipIdx = {}
    self.equipItems = {}
end

function this:ItemCountFunc()
    return #self.equips
end

function this:ItemGetFunc()
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

    local isSelect = self.curSelectIndex == luaIndex
    item:UpdateUI(self.equips[luaIndex].id, luaIndex, isSelect)
end

---@param equipItem KLSuitEquipItem
function this:BtnEquipOnSelect(equipItem)
    if self.curEquipItem then
        self.curEquipItem:SetState(false)
    end
    self.curEquipItem = equipItem
    equipItem:SetState(true)

end

---@param equips
function this:SetArgs(equips, titleStr, itemY, luaIndex)
    self.equips = equips
    self.title = titleStr
    self.itemY = itemY
    self.luaIndex = luaIndex
end

function this:UpdateUI()
    GUI:Text_setString(self.view.Title, self.title)
    local w = GUI:GetWidth(self.view.root)
    GUI:setContentSize(self.view.root, w, self.itemY)
    GUI:DataListUpdateData(self.view.datalist11)
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


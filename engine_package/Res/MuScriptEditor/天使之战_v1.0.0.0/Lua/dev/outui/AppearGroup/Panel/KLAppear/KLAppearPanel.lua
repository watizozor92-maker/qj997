---@class KLAppearPanel:UIKmlLuaPanelBase
---@field view KLAppearPanelView
local KLAppearPanel = class(UIKmlLuaPanelBase)
local this = KLAppearPanel

---@type  number[]
local partData = {}

---@type table<E_AppearEquipType,CommonProtos.Item>
local slot2Equips = {}

---@type table<EEquipSlotType,number> <EEquipSlotType,cfgId>
local appearCfgIds = {}
---@type table<EEquipSlotType,number> <EEquipSlotType,cfgId>
local serverCfgIds = {}

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.loopscrollviewData,
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
            end,
            function(realIndex)
                return self:ItemSizeGetFunc(realIndex)
            end
    )

    self.Part_ITEM_H = 72

    self.Page_Width = GUI:GetWidth(self.view.loopscrollview)
    self.PAGE_EXT_H = 40
    ---@type table<KingML.KmlControl,KLAppearPartItem>
    self.partItems = {}
end

function this:ItemCountFunc()
    return #partData
end

function this:ItemGetFunc()
    ---@type KLAppearPartItem
    local item = GUI:UIPanel_Open("dev/outui/AppearGroup/Item/KLAppearPart/KLAppearPartItem", self.view.loopscrollviewData, self, nil, true)

    local kmlCtrl = item.view.root
    self.partItems[kmlCtrl] = item
    return kmlCtrl
end

function this:ItemInitFunc()

end

---@param realIndex number
---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local item = self.partItems[kmlCtrl]
    local luaIndex = realIndex + 1
    local slot = partData[luaIndex]

    item:UpdateUI(appearCfgIds, slot2Equips[slot], slot, self.itemY, luaIndex)


end

---@param realIndex number
function this:ItemSizeGetFunc(realIndex)
    local luaIndex = realIndex + 1
    local slot = partData[luaIndex]
    local equipCount = #slot2Equips[slot]

    local line = math.ceil(equipCount / 4)
    self.itemY = line * self.Part_ITEM_H + (line - 1) * 4 + self.PAGE_EXT_H

    return Vector2(self.Page_Width, self.itemY)
end

---创建或者刷新界面数据时调用
function this:Refresh()

    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_EQUIP_APPEAR)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.BtnCancel, self, self.BtnCancelOnClick)
    GUI:AddOnClickEvent(self.view.BtnSure, self, self.BtnSureOnClick)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_EQUIP_APPEAR, self.GET_EQUIP_APPEAR, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GUARD_APPEAR, self.RES_GUARD_APPEAR, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SETTING_EQUIP_APPEAR, self.RES_SETTING_EQUIP_APPEAR, self)
end

--保存设置成功
---@param message {slot:EEquipSlotType,cfgId:number}[]
function this:RES_SETTING_EQUIP_APPEAR(_, message)
    table.clear(appearCfgIds)
    table.clear(serverCfgIds)
    for slot, cfgId in pairs(message) do
        slot = tonumber(slot)
        appearCfgIds[slot] = cfgId
        serverCfgIds[slot] = cfgId
    end
end

---@param message {itemId:number,getTime:number,time:number}[]
function this:RES_GUARD_APPEAR(_, message)
    self:AnalysisEquipData()

    if table.count(message) > 0 then
        if not slot2Equips[E_AppearEquipType.Guard] then
            slot2Equips[E_AppearEquipType.Guard] = {}
            table.insert(partData, E_AppearEquipType.Guard)
        end

        for _, v in pairs(message) do
            table.insert(slot2Equips[E_AppearEquipType.Guard], v)
        end
    end

    GUI:DataListUpdateData(self.view.loopscrollviewData)
    SL:onLUAEvent(APPEAR_PREVIEW_SELECT_CHANGE, appearCfgIds)
end

function this:AnalysisEquipData()
    table.clear(partData)
    table.clear(slot2Equips)

    for tp, strParts in pairs(E_AppearType2StrPart) do
        ---@type CommonProtos.Item[]
        local equipList = {}
        for _, slot in pairs(strParts) do
            ---@type CommonProtos.Item[]
            local equips = SL:GetMetaValue("EQUIP_DATA_LIST", slot)
            table.concatTable(equipList, equips)
        end

        if #equipList > 0 then
            slot2Equips[tp] = equipList
            table.insert(partData, tp)
        end

    end


end

--返回外观
---@param message {slot:number,cfgId:number}[]
function this:GET_EQUIP_APPEAR(_, message)
    if not message then
        return
    end

    table.clear(appearCfgIds)
    table.clear(serverCfgIds)
    for _, kp in pairs(message) do
        local slot = tonumber(kp.slot)
        appearCfgIds[slot] = kp.cfgId
        serverCfgIds[slot] = kp.cfgId
    end

    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_GUARD_APPEAR)
end

function this:BtnSureOnClick()
    SL:CommonTipsMessage({
        stringTblID = 209, -- = "保存设置",
        title = "提示",
        titlePos = {x= 0,y=-26},
        callback = function()
            ---@type {slot:number,cfgId:number}[]
            local dt = {}

            for slot, cfgId in pairs(appearCfgIds) do
                table.insert(dt, { slot = slot, cfgId = cfgId })
            end

            SL:SendLuaNetMsg(LuaMessageIdToSever.SETTING_EQUIP_APPEAR, { equipindex = dt, isUpdateView = true })
            self:BtnCloseOnClick()
        end
    })

end

function this:BtnCancelOnClick()
    return self:BtnCloseOnClick()
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppear/KLAppearPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
end

function this:Close()
    table.clear(appearCfgIds)
    SL:onLUAEvent(APPEAR_PREVIEW_SELECT_CHANGE, serverCfgIds)
end

function this:OnEquipItemSelect(oldId, cfgId, slot)
    if oldId then
        for _, part in pairs(E_AppearType2StrPart[slot]) do
            if appearCfgIds[part] and appearCfgIds[part] == oldId then
                appearCfgIds[part] = nil
                break
            end
        end
    end

    if oldId ~= cfgId then
        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", cfgId)
        if table.contains(E_AppearSuitSlot,slot) then
            --修改保存修改数据
            for _, part in pairs(E_AppearType2StrPart[E_AppearEquipType.SuitBody]) do
                appearCfgIds[part] = nil
            end

            --勾选状态
            for _, partItem in pairs(self.partItems) do
                if partItem.view and partItem.slot == E_AppearEquipType.SuitBody and partItem.curEquipItem then
                    partItem.curEquipItem:SetState(false)
                    partItem.curCfgId = nil
                    break
                end
            end
        end
        for _, part in pairs(E_AppearType2StrPart[slot]) do
            if itemTbl.subType == E_ItemSubType_Equip.SuitBody then
                for _, appearType in pairs(E_AppearSuitSlot) do
                    --勾选状态
                    for _, partItem in pairs(self.partItems) do
                        if partItem.view and partItem.slot == appearType and partItem.curEquipItem then
                            partItem.curEquipItem:SetState(false)
                            partItem.curCfgId = nil
                            break
                        end
                    end

                    --修改保存修改数据
                    for _, part in pairs(E_AppearType2StrPart[appearType]) do
                        appearCfgIds[part] = nil
                    end
                end
            end

            for _, v in pairs(itemTbl.strPart) do
                if v == part then
                    appearCfgIds[part] = cfgId
                    break
                end
            end

        end
    end

    SL:onLUAEvent(APPEAR_PREVIEW_SELECT_CHANGE, appearCfgIds)
end

return this

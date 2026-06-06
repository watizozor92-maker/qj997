---@class KLUIEquipQuickTransferPanel:UIKmlLuaPanelBase
---@field view KLUIEquipQuickTransferPanelView
local KLUIEquipQuickTransferPanel = class(UIKmlLuaPanelBase)
local this =KLUIEquipQuickTransferPanel
---创建时调用一次
function this:Init()
    ---@type CommonProtos.Item
    self.sourceItem = self.args.source
    ---@type CommonProtos.Item
    self.targetItem = self.args.target
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.transferStrength = false
    self.transferAppend = false
    ---@type cfg_equip_transfer_column
    local sourceTbl = SL:GetConfig("cfg_equip_transfer", self.sourceItem.cfgId)
    ---@type cfg_equip_transfer_column
    local targetTbl = SL:GetConfig("cfg_equip_transfer", self.targetItem.cfgId)
    local strengthen = EquipFunc.GetEquipStrengthLevel(self.sourceItem)
    local append = EquipFunc.GetEquipAppendLevel(self.sourceItem)
    local reborn = EquipFunc.GetEquipRegenerate(self.sourceItem)
    if targetTbl.transferGroup == sourceTbl.transferGroup then
        ---转移强化等级
        if strengthen > 0 then
            GUI:SetActive(self.view.tips1, true)
            self.transferStrength = true
            GUI:Text_setString(self.view.tips1, "强化等级：" .. strengthen)
        else
            GUI:SetActive(self.view.tips1, false)
        end
        ---转移追加等级
        if append > 0 then
            GUI:SetActive(self.view.tips2, true)
            self.transferAppend = true
            GUI:Text_setString(self.view.tips2, "追加等级：" .. append)
        else
            GUI:SetActive(self.view.tips2, false)
        end
    else
        GUI:SetActive(self.view.tips1, false)
        GUI:SetActive(self.view.tips2, false)
    end

    if false and targetTbl.regenerationGroup == sourceTbl.regenerationGroup then
        ---转移再生词条
        if reborn and next(reborn) then
            GUI:SetActive(self.view.tips3, true)
            local num = 0
            for i, v in pairs(reborn) do
                num = num + 1
            end
            GUI:Text_setString(self.view.tips3, "再生词条：" .. num)
        else
            GUI:SetActive(self.view.tips3, false)
        end
    else
        GUI:SetActive(self.view.tips3, false)
    end
    
    GUI:Text_setString(self.view.tipContent, "当前装备可以继承[" .. sourceTbl.name .. "]")
    local costInfo = EquipFunc.GetTransferCost(self.sourceItem, "1", "1", "0")
    if costInfo.id then
        ---@type cfg_item_column
        local item = SL:GetConfig("cfg_item", costInfo.id)
        local bag_num = SL:GetBagItemCount(costInfo.id)
        GUI:Text_setString(self.view.text_transfer_cost_name, "消耗" .. item.name)
        GUI:Item_setItemId(self.view.item_cost, item.id)
        if bag_num >= costInfo.num then
            self.canTransfer = true
            bag_num = SL:GetSimpleNumber(bag_num, 2)
            GUI:Text_setString(self.view.text_transfer_cost, "<color=#00ff00>" .. bag_num .. "</color> / " .. costInfo.num)
        else
            self.canTransfer = false
            bag_num = SL:GetSimpleNumber(bag_num, 2)
            GUI:Text_setString(self.view.text_transfer_cost, "<color=#FF2323>" .. bag_num .. "</color> / " .. costInfo.num)
        end
    end
    
    local args = { type = "common", item = nil, default = { width = 60, height = 60, mfixSizeX = 60, mfixSizeY = 60, strengthX = 0 } }
    args.item = self.sourceItem
    ---@type KLBagItemItem
    self.sourceEquip = GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.panel_equip_source, self, args, true)
    args.item = self.targetItem
    ---@type KLBagItemItem
    self.sourceEquip = GUI:UIPanel_Open("dev/ui/Common/Item/KLBagItem/KLBagItemItem", self.view.panel_equip_target, self, args, true)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.btn_source_item, self, self.ShowSourceTips)
    GUI:AddOnClickEvent(self.view.btn_target_item, self, self.ShowTargetTips)
    GUI:AddOnClickEvent(self.view.btn_transfer, self, self.CheckOverMax)
    GUI:AddOnClickEvent(self.view.btn_cancel, self, self.CloseSelf)
end

function this:ShowSourceTips()
    SL:OpenTips("bag", self.sourceItem.cfgId, self.sourceItem.id)
end

function this:ShowTargetTips()
    SL:OpenTips("equip", self.targetItem.cfgId, self.targetItem.id)
end

function this:CheckOverMax()
    local overMax = false
    if self.transferStrength then
        ---@type cfg_equip_strengthen_column
        local tbl = SL:GetConfig("cfg_equip_strengthen", self.targetItem.cfgId)
        if tbl.maxLevel < EquipFunc.GetEquipStrengthLevel(self.sourceItem) then
            overMax = true
        end
    end
    if self.transferAppend then
        ---@type cfg_equip_appends_column
        local tbl = SL:GetConfig("cfg_equip_appends", self.targetItem.cfgId)
        if tbl.maxLevel < EquipFunc.GetEquipAppendLevel(self.sourceItem) then
            overMax = true
        end
    end

    if overMax then
        SL:CommonTipsMessage({  stringTblID=213,ui = self, callback = self.Transfer })
    else
        self:Transfer()
    end
end

function this.Transfer(data)
    local ui = nil
    if data.ui then
        ui = data.ui
    else
        ui = data
    end
    if ui.canTransfer then
        local message = {
            firstItem = ui.sourceItem.id,
            secondItem = ui.targetItem.id,
            transferStrength = true,
            transferAppend  = true,
            transferRegeneration = true,
        }
        if EquipFunc.GetEquipStrengthLevel(ui.sourceItem) <= 0 then
            message.transferStrength = false
        end
        if EquipFunc.GetEquipAppendLevel(ui.sourceItem) <= 0 then
            message.transferAppend = false
        end
        local regenerate = EquipFunc.GetEquipRegenerate(ui.sourceItem)
        if not regenerate or not next(regenerate) then
            message.transferRegeneration = false
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRANSFER_EQUIP, message)
        ui:CloseSelf()
    else
        SL:TipMessage(SL:GetConfig('cfg_string',269).text, 1, NoticeType.NoticeMid )--"货币不足", 
    end
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLUIEquipQuickTransfer/KLUIEquipQuickTransferPanel")
end


function this:Close()
end

return this

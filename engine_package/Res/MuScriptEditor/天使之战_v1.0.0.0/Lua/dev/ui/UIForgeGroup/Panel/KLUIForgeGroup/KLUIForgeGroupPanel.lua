---@class KLUIForgeGroupPanel:UIKmlLuaPanelBase
---@field view KLUIForgeGroupPanelView
local KLUIForgeGroupPanel = class(UIKmlLuaPanelBase)
local this = KLUIForgeGroupPanel
---创建时调用一次
function this:Init()
    self.togTypeList = 
    {
        [EForgeGroupType.Strength] = self.view.strengthToggle,
        [EForgeGroupType.Add] = self.view.appendToggle,
        [EForgeGroupType.Decompose] = self.view.decomposeToggle,
        [EForgeGroupType.Trans] = self.view.transferToggle,
        [EForgeGroupType.Jewelry] = self.view.JewelryToggle,
        [EForgeGroupType.Regenerate] = self.view.RegenerateToggle,
        [EForgeGroupType.Overlay380] = self.view.overlayToggle,
        [EForgeGroupType.Gem] = self.view.InlayToggle,
        [EForgeGroupType.Lucky] = self.view.luckyToggle,
        [EForgeGroupType.StarMaster] = self.view.refineToggle,
        
    }
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.forgeGroupType = EForgeGroupType.Strength
    self.equipSlot = nil
    if self.args and self.args.forgeGroupType then
        self.forgeGroupType = self.args.forgeGroupType
        self.equipSlot = self.args.equipSlot
    end
    GUI:SetTogDefaultThis(self.togTypeList[self.forgeGroupType])
    --打开界面的时候刷新下红点
    SL:RefreshPanelALLRedPoint("KLUIForgeGroupPanel")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.decomposeToggle, self, self.DecomposeToggleChange)
    GUI:SetToggleOnValueChange(self.view.strengthToggle, self, self.strengthToggle)
    GUI:SetToggleOnValueChange(self.view.appendToggle, self, self.appendToggle)
    GUI:SetToggleOnValueChange(self.view.overlayToggle, self, self.OverlayToggle)
    GUI:SetToggleOnValueChange(self.view.transferToggle, self, self.TransferToggle)
    GUI:SetToggleOnValueChange(self.view.JewelryToggle, self, self.JewelryToggle)
    GUI:SetToggleOnValueChange(self.view.RegenerateToggle, self, self.RegenerateToggle)
    GUI:SetToggleOnValueChange(self.view.InlayToggle, self, self.InlayToggleChanged)
    GUI:SetToggleOnValueChange(self.view.luckyToggle, self, self.luckyToggle)
    GUI:SetToggleOnValueChange(self.view.refineToggle, self, self.refineToggle)
    
    GUI:AddOnClickEvent(self.view.MaskCloseButton,self,self.OnClickCloseButton)
end

---点击空白处关闭锻造界面以及打开的界面
function this:OnClickCloseButton()
    SL:onLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE)
end

function this:JewelryToggle(control, customData, eventData)
    if eventData then
        if eventData[1] then
            GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipJewelry/KLEquipJewelryPanel")
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipJewelry/KLEquipJewelryPanel")
        GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    end
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    SL.ShowMainPanel()
end

function this:appendToggle(control, customData, eventData)
    if eventData then
        if eventData[1] then
            GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipAppendUI/KLEquipAppendUIPanel")
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipAppendUI/KLEquipAppendUIPanel")
        GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
        GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    end
end

function this:DecomposeToggleChange(control, customData, eventData)
    if eventData then
        if eventData[1] then
            SL:OpenEquipDecomposeUI()
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipDecomposeUI/KLEquipDecomposeUIPanel")
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel")
    end
end

function this:strengthToggle(control, customData, eventData)
    if eventData then
        if eventData[1] then
            local showLight
            if self.args then
                showLight = self.args.showLight
                self.args.showLight = nil
            end
            GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipStrengthUI/KLEquipStrengthUIPanel",nil,nil,{equipSlot = self.equipSlot, showLight = showLight})
            self.equipSlot = nil
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipStrengthUI/KLEquipStrengthUIPanel")
        GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
        GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    end
end

function this:luckyToggle(control, customData, eventData)
    if eventData then
        if eventData[1] then
            GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipLucky/KLEquipLuckyPanel",nil,nil,{equipSlot = self.equipSlot})
            self.equipSlot = nil
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipLucky/KLEquipLuckyPanel")
        GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
        GUI:UIPanel_Close("dev/outui/Bag/Panel/KLLuckyBag/KLLuckyBagPanel")
    end
end

function this:refineToggle(control, customData, eventData)
    if eventData then
        if eventData[1] then
            GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipRefine/KLEquipRefinePanel")
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipRefine/KLEquipRefinePanel")
        GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
        GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    end
end

function this:OverlayToggle(control, customData, eventData)
    if eventData then
        if eventData[1] then
            GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipOverlay/KLEquipOverlayPanel")
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipOverlay/KLEquipOverlayPanel")
    end
end

function this:TransferToggle(control,customData,eventData)
    if eventData then
        if eventData[1] then
            GUI:UIPanel_Open("dev/outui/Equip/Panel/KLUIEquipTransfer/KLUIEquipTransferPanel")
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/outui/Bag/Panel/KLEquipBag/KLEquipBagPanel")
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLUIEquipTransfer/KLUIEquipTransferPanel")
    end
end

function this:RegenerateToggle(control,customData,eventData)
    if eventData then
        if eventData[1] then
            GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipRegenerateUI/KLEquipRegenerateUIPanel")
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLEquipRegenerateUI/KLEquipRegenerateUIPanel")
        GUI:UIPanel_Close("dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel")
        GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    end
end

function this:InlayToggleChanged(control,customData,eventData)
    if eventData then
        if eventData[1] then
            GUI:UIPanel_Open("dev/outui/Equip/Panel/KLGemInlay/KLGemInlayPanel")
            self:OnClickBlock()
            return
        end
        GUI:UIPanel_Close("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemEquipUI/KLGemEquipUIPanel")
        GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemInlay/KLGemInlayPanel")
    end
end

function this:OnClickBlock()
    --[[GUI:setVisible(self.view.img_block, true)
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = SL:ScheduleOnce(0.5, function()
        GUI:setVisible(self.view.img_block, false)
    end)]]
end

return this

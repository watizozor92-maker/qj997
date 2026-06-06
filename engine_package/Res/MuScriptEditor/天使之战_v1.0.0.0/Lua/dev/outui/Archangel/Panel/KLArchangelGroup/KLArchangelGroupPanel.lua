---@class KLArchangelGroupPanel:UIKmlLuaPanelBase
---@field view KLArchangelGroupPanelView
local KLArchangelGroupPanel = class(UIKmlLuaPanelBase)
local this = KLArchangelGroupPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    self.masterRed = {}
    InfoManager.archangeEquipInfo:CheckEquipRed()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.archangelGroupType = E_ArchangelGroupType.Breakthrough
    self.equipSlot = nil
    if self.args and self.args.archangelGroupType then
        self.archangelGroupType = tonumber(self.args.archangelGroupType)
        self.equipSlot = self.args.equipSlot
    end

    if self.archangelGroupType == E_ArchangelGroupType.Breakthrough then
        GUI:Toggle_setIsOn(self.view.breakthroughToggle,true)
    elseif self.archangelGroupType == E_ArchangelGroupType.Grail then
        GUI:Toggle_setIsOn(self.view.grailToggle,true)
    elseif self.archangelGroupType == E_ArchangelGroupType.Decompose then
        GUI:Toggle_setIsOn(self.view.decomposeToggle,true)
    end
    --打开界面的时候刷新下红点
    --SL:RefreshPanelALLRedPoint("KLArchangelGroupPanel")
    --红点系统无法刷新该界面，暂不明原因
    self:RefreshRed()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.breakthroughToggle, self, self.BreakthroughToggle)
    --GUI:AddOnClickEvent(self.view.MaskCloseButton, self, self.OnClickCloseButton)
    GUI:SetToggleOnValueChange(self.view.grailToggle, self, self.GrailToggle)
    GUI:SetToggleOnValueChange(self.view.decomposeToggle,self,self.DecomposeToggle)
end

---点击空白处关闭锻造界面以及打开的界面
function this:OnClickCloseButton()

end

function this:BreakthroughToggle(control, customData, eventData)
    if eventData then
        if eventData[1] then
            GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLArchangelBreakthrough/KLArchangelBreakthroughPanel", nil, nil, self.args)
            SL.HideMainPanel()
            return
        end
        GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelBreakthrough/KLArchangelBreakthroughPanel")
    end
end

function this:GrailToggle(control, customData, eventData)
    if eventData then
        if eventData[1] then
            if not GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanel") then
                GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanel")
                SL.HideMainPanel()
            end
            return
        end
        GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanel")
    end
end

function this:DecomposeToggle(control, customData, eventData)
    if eventData then
        if eventData[1] then
            if not GUI:GetUI("dev/outui/Archangel/Panel/KLArchangelDecompose/KLArchangelDecomposePanel") then
                GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLArchangelDecompose/KLArchangelDecomposePanel")
                SL.HideMainPanel()
            end
            return  
        end
        GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelDecompose/KLArchangelDecomposePanel")
    end
end

function this:RefreshRed()
    if table.count(InfoManager.archangeEquipInfo.canBreakthrough) > 0 then
        if not self.masterRed[E_ArchangelGroupType.Breakthrough] then
            self.masterRed[E_ArchangelGroupType.Breakthrough] = GUI:Image_Create(self.view.breakthroughToggle, {
                atlas = "Atlas/Common.spriteatlas",
                src = "bg_gemred",
                width = "20",
                height = "20",
                a = "21",
                x = "0",
                y = "8",
                z = "-500",
            })
        else
            GUI:setVisible(self.masterRed[E_ArchangelGroupType.Breakthrough], true)
        end
    elseif self.masterRed[E_ArchangelGroupType.Breakthrough] then
        GUI:setVisible(self.masterRed[E_ArchangelGroupType.Breakthrough], false)
    end
    local isStrength = true
    if table.count(InfoManager.archangeEquipInfo.canGrailStrength) > 0 then
        if not self.masterRed[E_ArchangelGroupType.Grail] then
            self.masterRed[E_ArchangelGroupType.Grail] = GUI:Image_Create(self.view.grailToggle, {
                atlas = "Atlas/Common.spriteatlas",
                src = "bg_gemred",
                width = "20",
                height = "20",
                a = "21",
                x = "0",
                y = "8",
                z = "-500",
            })
        else
            GUI:setVisible(self.masterRed[E_ArchangelGroupType.Grail], true)
        end
    else
        isStrength = false
    end

    if table.count(InfoManager.archangeEquipInfo.equipRed) > 0 then
        if not self.masterRed[E_ArchangelGroupType.Grail] then
            self.masterRed[E_ArchangelGroupType.Grail] = GUI:Image_Create(self.view.grailToggle, {
                atlas = "Atlas/Common.spriteatlas",
                src = "bg_gemred",
                width = "20",
                height = "20",
                a = "21",
                x = "0",
                y = "8",
                z = "-500",
            })
        else
            GUI:setVisible(self.masterRed[E_ArchangelGroupType.Grail], true)
        end
    elseif not isStrength and self.masterRed[E_ArchangelGroupType.Grail] then
        GUI:setVisible(self.masterRed[E_ArchangelGroupType.Grail], false)
    end

end

function this:Close()
    SL.ShowMainPanel()
end

return this

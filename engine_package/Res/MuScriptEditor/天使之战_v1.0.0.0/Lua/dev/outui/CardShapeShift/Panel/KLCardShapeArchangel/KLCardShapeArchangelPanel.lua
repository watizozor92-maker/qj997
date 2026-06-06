---@class KLCardShapeArchangelPanel:UIKmlLuaPanelBase
---@field view KLCardShapeArchangelPanelView
local KLCardShapeArchangelPanel = class(UIKmlLuaPanelBase)
local this =KLCardShapeArchangelPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_go, self, self.btn_go)
    GUI:AddOnClickEvent(self.view.btn_close, self, self.btn_close)

    GUI:SetToggleOnValueChange(self.view.today_show_toggle,self,self.today_show_toggle_value_change)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    if self.args then
        self.uiId = self.args
        ---@type cfg_system_foreshow_column
        self.ui_cfg = SL:GetConfig("cfg_system_foreshow", self.uiId)
    end
    local job = SL:GetMetaValue(EMetaVarGetKey.JOB)
    if job == 1 then
        GUI:Model_setSrc(self.view.item_model, "Model/Charactor/Sword/Sword20")
        GUI:setPosition(self.view.item_model, -170, 140)
        GUI:setPositionZ(self.view.item_model, -200)
        GUI:setRotation(self.view.item_model, 0)
        GUI:setRotationSkewX(self.view.item_model, 65)
        GUI:setRotationSkewY(self.view.item_model, -90)
    elseif job == 2 then
        GUI:Model_setSrc(self.view.item_model, "Model/Charactor/Staff/Staff11")
        GUI:setPosition(self.view.item_model, -220, 75)
        GUI:setPositionZ(self.view.item_model, -200)
        GUI:setRotation(self.view.item_model, 0)
        GUI:setRotationSkewX(self.view.item_model, 115)
        GUI:setRotationSkewY(self.view.item_model, -90)
    elseif job == 3 then
        GUI:Model_setSrc(self.view.item_model, "Model/Charactor/CrossBow/CrossBow19")
        GUI:setPosition(self.view.item_model, -260, -50)
        GUI:setPositionZ(self.view.item_model, -200)
        GUI:setRotation(self.view.item_model, 140)
        GUI:setRotationSkewX(self.view.item_model, 0)
        GUI:setRotationSkewY(self.view.item_model, 0)
    end
end

function this:btn_go()
    GUI:UIPanel_Close("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel")
    self:btn_close(_, true)
    local instruction = InfoManager.cardShapeShiftInfo:DeepCopy(self.ui_cfg.btnSkip[1])
    table.remove(instruction, 1)
    SL:ShortcutDO(instruction)
end

function this:btn_close(_, stop)
    GUI:UIPanel_Close("dev/outui/CardShapeShift/Panel/KLCardShapeArchangel/KLCardShapeArchangelPanel")
    if not stop then
        InfoManager.cardShapeShiftInfo:REFRESH_NEXT_CARD_SHAPE_UI()
    end
end

function this:today_show_toggle_value_change(_, _, data)
    self.isToggle = data[1]
end

function this:Hide()
end

function this:Close()
    if self.isToggle then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CANCEL_FSPREVIEW, self.uiId)
    end
    if not GUI:GetUI("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel") then
        SL.ShowMainPanel()
    end
end

return this

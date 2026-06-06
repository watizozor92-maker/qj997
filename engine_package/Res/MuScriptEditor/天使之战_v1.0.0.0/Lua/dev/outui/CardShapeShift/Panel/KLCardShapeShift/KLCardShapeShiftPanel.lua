---@class KLCardShapeShiftPanel:UIKmlLuaPanelBase
---@field view KLCardShapeShiftPanelView
local KLCardShapeShiftPanel = class(UIKmlLuaPanelBase)
local this =KLCardShapeShiftPanel
function this:AsyncLoadUI()
        end
---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.btn_close)
    GUI:AddOnClickEvent(self.view.img_close, self, self.btn_close)
    GUI:AddOnClickEvent(self.view.btn_left, self, self.btn_left)
    GUI:AddOnClickEvent(self.view.btn_right, self, self.btn_right)

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
        if self.uiId == 101 then
            GUI:Image_loadTexture(self.view.img_bg, "Texture/card_shape_cjlj.png")
        elseif self.uiId == 102 then
            GUI:Image_loadTexture(self.view.img_bg, "Texture/card_shape_ttwz.png")
        end
        ---@type cfg_system_foreshow_column
        self.ui_cfg = SL:GetConfig("cfg_system_foreshow", self.uiId)
        local btnShow = {}
        local open_server_day = InfoManager.cardShapeShiftInfo.open_server_day
        local level = SL:GetMetaValue("LEVEL")
        if #self.ui_cfg.btnNeedLevel > 0 then
            for i, v in ipairs(self.ui_cfg.btnNeedLevel) do
                if v[2] ~= 0 and v[2] <= level then
                    btnShow[i] = true
                end
            end
        end
        
        if #self.ui_cfg.btnNeedDay > 0 then
            for i, v in ipairs(self.ui_cfg.btnNeedDay) do
                if v[2] ~= 0 and v[2] <= open_server_day then
                else
                    if btnShow[i] then
                        btnShow[i] = false
                    end
                end
            end
        end

        if btnShow[1] then
            GUI:setVisible(self.view.btn_left, true)
            GUI:setVisible(self.view.btn_left_tips, false)
        else
            GUI:setVisible(self.view.btn_left, false)
            GUI:setVisible(self.view.btn_left_tips, true)
            if #self.ui_cfg.btnText > 0 then
                for i, v in ipairs(self.ui_cfg.btnText) do
                    if v[1] == "1" then
                        GUI:Text_setString(self.view.btn_left_tips, v[2])
                    end
                end
            end
        end

        if btnShow[2] then
            GUI:setVisible(self.view.btn_right, true)
            GUI:setVisible(self.view.btn_right_tips, false)
        else
            GUI:setVisible(self.view.btn_right, false)
            GUI:setVisible(self.view.btn_right_tips, true)
            if #self.ui_cfg.btnText > 0 then
                for i, v in ipairs(self.ui_cfg.btnText) do
                    if v[1] == "2" then
                        GUI:Text_setString(self.view.btn_right_tips, v[2])
                    end
                end
            end
        end
    end
end

function this:btn_close(_, stop)
    GUI:UIPanel_Close("dev/outui/CardShapeShift/Panel/KLCardShapeShift/KLCardShapeShiftPanel")
    if not stop then
        InfoManager.cardShapeShiftInfo:REFRESH_NEXT_CARD_SHAPE_UI()
    end
end

function this:btn_left()
    if #self.ui_cfg.btnSkip > 0 then
        for i, v in ipairs(self.ui_cfg.btnSkip) do
            if v[1] == "1" then
                GUI:UIPanel_Close("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel")
                self:btn_close(_, true)
                local instruction = InfoManager.cardShapeShiftInfo:DeepCopy(v)
                table.remove(instruction, 1)
                SL:ShortcutDO(instruction)
            end
        end
    end
end

function this:btn_right()
    if #self.ui_cfg.btnSkip > 0 then
        for i, v in ipairs(self.ui_cfg.btnSkip) do
            if v[1] == "2" then
                GUI:UIPanel_Close("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel")
                self:btn_close(_, true)
                local instruction = InfoManager.cardShapeShiftInfo:DeepCopy(v)
                table.remove(instruction, 1)
                SL:ShortcutDO(instruction)
            end
        end
    end
end

function this:today_show_toggle_value_change(_, _, data)
    self.isToggle = data[1]
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

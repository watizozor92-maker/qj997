---@class KLEquipForgeEffectPanel:UIKmlLuaPanelBase
---@field view KLEquipForgeEffectPanelView
local KLEquipForgeEffectPanel = class(UIKmlLuaPanelBase)
local this =KLEquipForgeEffectPanel

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Hide()
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

function this:UpdateData( message ,type)
    GUI:SetActive(self.view.strength_ok, false)
    GUI:SetActive(self.view.strength_fail, false)
    GUI:SetActive(self.view.xilian_ok, false)
    GUI:SetActive(self.view.xilian_fail, false)
    GUI:SetActive(self.view.huanyuan, false)
    GUI:SetActive(self.view.zaisheng_ok, false)
    GUI:SetActive(self.view.zaisheng_fail, false)
    GUI:SetActive(self.view.jinhua_ok, false)
    GUI:SetActive(self.view.jinhua_fail, false)
    --强化追加
    if type == 1 then
        if message.issuccess then
            GUI:SetActive(self.view.strength_ok, true)
        else
            GUI:SetActive(self.view.strength_fail, true)
        end
    --洗练
    elseif type == 2 then
        if message.issuccess then
            GUI:SetActive(self.view.xilian_ok, true)
        else
            GUI:SetActive(self.view.xilian_fail, true)
        end
    --还原
    elseif type == 3 then
        GUI:SetActive(self.view.huanyuan, true)
    --再生
    elseif type == 4 then
        if message.issuccess then
            GUI:SetActive(self.view.zaisheng_ok, true)
        else
            GUI:SetActive(self.view.zaisheng_fail, true)
        end
    --高级进化
    elseif type == 5 then
        if message.issuccess then
            GUI:SetActive(self.view.jinhua_ok, true)
        else
            GUI:SetActive(self.view.jinhua_fail, true)
        end
    end
    self.timer = SL:ScheduleOnce(5, function()
        GUI:UIPanel_Close("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel")
    end)
end

return this

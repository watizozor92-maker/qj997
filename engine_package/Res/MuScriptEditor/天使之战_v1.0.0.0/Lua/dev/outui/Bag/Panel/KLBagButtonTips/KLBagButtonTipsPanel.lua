---@class KLBagButtonTipsPanel:UIKmlLuaPanelBase
---@field view KLBagButtonTipsPanelView
local KLBagButtonTipsPanel = class(UIKmlLuaPanelBase)
local this =KLBagButtonTipsPanel

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.leftDataBtn, self, self.leftDataBtnOnClick)
    GUI:AddOnClickEvent(self.view.GoRecycleBtn, self, self.GoRecycleBtnOnClick)
    GUI:AddOnClickEvent(self.view.GoAutoRecycleBtn, self, self.GoAutoRecycleBtnOnClick)
end
function this:GoRecycleBtnOnClick()
    local cfg = SL:GetConfig("cfg_global", 710001)
    if cfg then
        --GUI:UIPanel_Open(cfg.value)
        GUI:UIPanel_Open("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
        --dev/ui/Recover/Panel/KLRecover/KLRecoverPanel
        --GUI:UIPanel_Close("dev/outui/Bag/Panel/KLBagButtonTips/KLBagButtonTipsPanel")
    end
end
function this:GoAutoRecycleBtnOnClick()
    local cfg = SL:GetConfig("cfg_global", 710002)
    if cfg then
        --GUI:UIPanel_Open(cfg.value)
        GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel")
        --dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel
    end
end
function this:leftDataBtnOnClick()
    if not InfoManager.uiHookInfo.IsShowBagTips then
        GUI:SetActive(self.view.leftDataBtnSelectImg,true)
        InfoManager.uiHookInfo.IsShowBagTips = true
    else
        InfoManager.uiHookInfo.IsShowBagTips = false
        GUI:SetActive(self.view.leftDataBtnSelectImg,false)
    end
end
---界面显示时调用一次
function this:Show()
    GUI:SetActive(self.view.leftDataBtnSelectImg,InfoManager.uiHookInfo.IsShowBagTips )
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Hide()
end

function this:Close()
end

return this

---@class KLUIPrivilegeBonusDetailPanel:UIKmlLuaPanelBase
---@field view KLUIPrivilegeBonusDetailPanelView
local KLUIPrivilegeBonusDetailPanel = class(UIKmlLuaPanelBase)
local this =KLUIPrivilegeBonusDetailPanel
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.img_drop_gold, self, self.OpenPrivilegePanel)
    GUI:AddOnClickEvent(self.view.img_drop_diamond, self, self.OpenPrivilegePanel)
    GUI:AddOnClickEvent(self.view.img_exp_gold, self, self.OpenPrivilegePanel)
    GUI:AddOnClickEvent(self.view.img_exp_diamond, self, self.OpenPrivilegePanel)
    GUI:AddOnClickEvent(self.view.img_drop_month_card, self, self.OpenPrivilegePanel)
    GUI:AddOnClickEvent(self.view.img_exp_month_card, self, self.OpenPrivilegePanel)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
end

function this:OpenPrivilegePanel()
    if InfoManager.monthCardInfo:IsHaveMonthCardRights("privilege") then
        GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel", nil, nil, { type = "privilege" })
    else
        GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_privilege_column
    local goldCfg = SL:GetConfig("cfg_privilege", 1)
    ---@type cfg_privilege_column
    local diamondCfg = SL:GetConfig("cfg_privilege", 2)
    local totalDrop = 0
    local totalExp = 0
    if PrivilegeCardManager.goldPrivilege then
        local dropsUp = math.floor(goldCfg.DropsUp[2] / 100)
        GUI:Text_setString(self.view.text_drop_gold, "黄金特权加成" .. dropsUp .. "%")
        GUI:Text_setString(self.view.text_exp_gold, "黄金特权加成" .. goldCfg.ExperienceUp .. "%")
        GUI:setVisible(self.view.img_drop_gold, false)
        GUI:setVisible(self.view.img_exp_gold, false)
        totalDrop = totalDrop + dropsUp
        totalExp = goldCfg.ExperienceUp
    else
        GUI:Text_setString(self.view.text_drop_gold, "黄金特权加成0%")
        GUI:Text_setString(self.view.text_exp_gold, "黄金特权加成0%")
        GUI:setVisible(self.view.img_drop_gold, true)
        GUI:setVisible(self.view.img_exp_gold, true)
    end

    if PrivilegeCardManager.diamondPrivilege then
        local dropsUp = math.floor(diamondCfg.DropsUp[2] / 100)
        GUI:Text_setString(self.view.text_drop_diamond, "钻石特权加成" .. dropsUp .. "%")
        GUI:Text_setString(self.view.text_exp_diamond, "钻石特权加成" .. diamondCfg.ExperienceUp .. "%")
        GUI:setVisible(self.view.img_drop_diamond, false)
        GUI:setVisible(self.view.img_exp_diamond, false)
        totalDrop = totalDrop + dropsUp
        totalExp = diamondCfg.ExperienceUp
    else
        GUI:Text_setString(self.view.text_drop_diamond, "钻石特权加成0%")
        GUI:Text_setString(self.view.text_exp_diamond, "钻石特权加成0%")
        GUI:setVisible(self.view.img_drop_diamond, true)
        GUI:setVisible(self.view.img_exp_diamond, true)
    end

    if PrivilegeCardManager.tripleEarningsInfo then
        if PrivilegeCardManager.tripleEarningsInfo.effectSec > 0 then
            GUI:Text_setString(self.view.text_drop_month_card, "月卡三倍收益加成300%")
            GUI:Text_setString(self.view.text_exp_month_card, "月卡三倍收益加成300%")
            GUI:setVisible(self.view.img_exp_month_card, false)
            GUI:setVisible(self.view.img_drop_month_card, false)
            totalExp = (100 + totalExp) * 3 - 100
            totalDrop = (100 + totalDrop) * 3 - 100
        else
            GUI:Text_setString(self.view.text_drop_month_card, "月卡三倍收益加成0%")
            GUI:Text_setString(self.view.text_exp_month_card, "月卡三倍收益加成0%")
            GUI:setVisible(self.view.img_exp_month_card, true)
            GUI:setVisible(self.view.img_drop_month_card, true)
        end
    else
        GUI:Text_setString(self.view.text_drop_month_card, "月卡三倍收益加成0%")
        GUI:Text_setString(self.view.text_exp_month_card, "月卡三倍收益加成0%")
        GUI:setVisible(self.view.img_exp_month_card, true)
        GUI:setVisible(self.view.img_drop_month_card, true)
    end
    
    GUI:Text_setString(self.view.text_drop_total, "获得" .. totalDrop .. "%掉落加成")
    GUI:Text_setString(self.view.text_exp_total, "获得" .. totalExp .. "%经验加成")
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/Privilege/Panel/KLUIPrivilegeBonusDetail/KLUIPrivilegeBonusDetailPanel")
end

function this:Close()
end

return this

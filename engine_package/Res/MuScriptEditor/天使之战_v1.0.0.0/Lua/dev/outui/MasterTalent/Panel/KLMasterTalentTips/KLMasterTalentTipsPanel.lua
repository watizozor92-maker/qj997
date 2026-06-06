---@class KLMasterTalentTipsPanel:UIKmlLuaPanelBase
---@field view KLMasterTalentTipsPanelView
local KLMasterTalentTipsPanel = class(UIKmlLuaPanelBase)
local this = KLMasterTalentTipsPanel

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.UpButton, self, self.UpButtonClick)
    GUI:AddOnClickEvent(self.view.mask, self, self.ClosePanel)

    SL:RegisterLUAEvent(LUA_EVENT_MASTER_DATA_CHANGE, self.Refresh, self)
    SL:RegisterLUAEvent(LUA_EVENT_MASTER_SKILL_DATA_CHANGE, self.Refresh, self)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.isMax = false
    self.cfg = self.args.cfg
    self.level = InfoManager.masterTalentInfo:GetNewMasterLevel(self.cfg.series, self.cfg.id)
    local masterInfo
    if self.level > 0 then
        masterInfo = SL:GetConfigTwoKeys("cfg_master_info", self.cfg.id, self.level, "talentId", "level")
    end
    local nextMasterInfo
    if SL:HasConfigTwoKeys("cfg_master_info", self.cfg.id, self.level + 1, "talentId", "level") then
        nextMasterInfo = SL:GetConfigTwoKeys("cfg_master_info", self.cfg.id, self.level + 1, "talentId", "level")
    end

    if masterInfo then
        GUI:Text_setString(self.view.currentInfo, masterInfo.description)
    else
        GUI:Text_setString(self.view.currentInfo, "天赋未激活")
    end

    if nextMasterInfo then
        GUI:Text_setString(self.view.nextInfo, nextMasterInfo.description)
        GUI:setVisible(self.view.UpButton, true)
        GUI:setVisible(self.view.nexttitle, true)
        GUI:setVisible(self.view.nextInfo, true)
    else
        GUI:Text_setString(self.view.nextInfo, "天赋已满级")
        self.isMax = true
        GUI:setVisible(self.view.UpButton, false)
        GUI:setVisible(self.view.nexttitle, false)
        GUI:setVisible(self.view.nextInfo, false)
    end
    GUI:Text_setString(self.view.name, self.cfg.name)
    GUI:Text_setString(self.view.level, self.level .. "/" .. self.cfg.minMaxLevel[2])
end

function this:UpButtonClick()
    if self.isMax then
        -- 满级
        return
    end
    if not InfoManager.masterTalentInfo:IsUnLockseries(self.cfg.series, self.cfg.tier) then
        -- 未解锁
        return
    end
    if InfoManager.masterTalentInfo:GetNewMasterPoint() <= 0 then
        -- 没有天赋点
        SL:MessageTip({ id = 482 })
        return
    end
    local cfgId = self.args.cfg.id
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UPGRADE_MASTER_TALENT, { cfgId = cfgId })
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/MasterTalent/Panel/KLMasterTalentTips/KLMasterTalentTipsPanel")
end

function this:Hide()
end

function this:Close()
end

return this

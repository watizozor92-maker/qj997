---@class KLMasterTalentIconItem:UIKmlLuaPanelBase
---@field view KLMasterTalentIconItemView
local KLMasterTalentIconItem = class(UIKmlLuaPanelBase)
local this = KLMasterTalentIconItem

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.click, self, self.Click)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Click()
    if not self.unLock then
        SL:MessageTip({id=79001})
        return
    end
    GUI:UIPanel_Open("dev/outui/MasterTalent/Panel/KLMasterTalentTips/KLMasterTalentTipsPanel", nil, nil,
        { cfg = self.cfg, info = self.info })
end

function this:UpdateData(data)
    GUI:Image_loadTexture(self.view.icon, data.cfg.icon, "Atlas/UIOutSkillIcon.spriteatlas")
    self.cfg = data.cfg
    self.info = data.info
    self.level = InfoManager.masterTalentInfo:GetNewMasterLevel(data.cfg.series, data.cfg.id)
    local isUnlocked = InfoManager.masterTalentInfo:IsUnLockseries(self.cfg.series, self.cfg.tier)
    self.unLock = isUnlocked
    local lvl = self.level or 0
    if not isUnlocked then
        GUI:Text_setString(self.view.info, "0/" .. self.cfg.minMaxLevel[2])
        GUI:setVisible(self.view.mask, true)
        GUI:setVisible(self.view.lock, true)
    elseif lvl > 0 then
        GUI:Text_setString(self.view.info, lvl .. "/" .. self.cfg.minMaxLevel[2])
        GUI:setVisible(self.view.mask, false)
        GUI:setVisible(self.view.lock, false)
    else
        GUI:Text_setString(self.view.info, "0/" .. self.cfg.minMaxLevel[2])
        GUI:setVisible(self.view.mask, true)
        GUI:setVisible(self.view.lock, false)
    end
end

function this:Hide()
end

function this:Close()
end

return this

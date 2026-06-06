---@class KLTalentTipPanel:UIKmlLuaPanelBase
---@field view KLTalentTipPanelView
---@field curlvInfo cfg_equip_angelTalentLv_column
---@field nextlvInfo cfg_equip_angelTalentLv_column
---@field angelTalent cfg_equip_angelTalent_column
local KLTalentTipPanel = class(UIKmlLuaPanelBase)
local this = KLTalentTipPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.angelTalent = self.args.tbl
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.mask, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.UpButton, self, self.UPTalent)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_TALENT_INFO, self.RES_ANGEL_TALENT_INFO, self)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.curlvPoint = nil
    if self.args.currentLv > 0 then
        self.curlvInfo = SL:GetConfigTwoKeys("cfg_equip_angelTalentLv", self.angelTalent.id, self.args.currentLv, "talentId", "level")
    else
        self.curlvInfo = nil
        local tbl = SL:GetConfigTwoKeys("cfg_equip_angelTalentLv", self.angelTalent.id, self.args.currentLv + 1, "talentId", "level")
        self.curlvPoint = tostring(tbl.consumPoint)
    end
    if self.args.currentLv < self.angelTalent.talentMaxLv then
        self.nextlvInfo = SL:GetConfigTwoKeys("cfg_equip_angelTalentLv", self.angelTalent.id, self.args.currentLv + 1, "talentId", "level")
        GUI:setVisible(self.view.UpButton, true)
        self.curlvPoint = tostring(self.nextlvInfo.consumPoint)
    else
        self.nextlvInfo = nil
        GUI:setVisible(self.view.UpButton, false)
        self.curlvPoint = "Max"
    end

    GUI:Image_loadTexture(self.view.icon, self.angelTalent.talentIcon, "Atlas/UIOutSkillIcon.spriteatlas")
    GUI:Text_setString(self.view.name, self.angelTalent.talentName)
    GUI:Text_setString(self.view.level, tostring(self.args.currentLv) .. "/" .. tostring(self.angelTalent.talentMaxLv))
    GUI:Text_setString(self.view.dian, tostring(self.angelTalent.talentRequest))
 
    GUI:Text_setString(self.view.talentpoint, self.curlvPoint)
    local curtext = "天赋未激活"
    if self.curlvInfo then
        curtext = self.curlvInfo.description
    end
    GUI:Text_setString(self.view.currenttext, curtext)
    local nexttext = "当前已满级"
    if self.nextlvInfo then
        nexttext = self.nextlvInfo.description
    end
    GUI:Text_setString(self.view.nexttext, nexttext)
end

function this:UPTalent()
    if InfoManager.archangeEquipInfo.talentPoint > 0 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ADD_ANGEL_TALENT_POINT, { talentGroup = self.angelTalent.talentGroup, talentId = self.angelTalent.id })
    else
        SL:MessageTip({ id = 242 })
    end
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLTalentTip/KLTalentTipPanel")
end

function this:RES_ANGEL_TALENT_INFO(_, message)
    if message.talentInfo and message.talentInfo[tostring(self.angelTalent.talentGroup)] and message.talentInfo[tostring(self.angelTalent.talentGroup)][tostring(self.angelTalent.id)] then
        self.args.currentLv = message.talentInfo[tostring(self.angelTalent.talentGroup)][tostring(self.angelTalent.id)]
        self:Refresh()
    end
end

function this:Close()

end

return this

---@class KLDragonSoulComboPanel:UIKmlLuaPanelBase
---@field view KLDragonSoulComboPanelView
local KLDragonSoulComboPanel = class(UIKmlLuaPanelBase)
local this =KLDragonSoulComboPanel
function this:AsyncLoadUI()
        end
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.datalist_cost, function()
        return #self.itemCostList
    end, function()
        
    end, function()
        
    end, function(realIndex)
        local item_cost = GUI:GetChildControl(self.view.datalist_cost,realIndex,'item_cost')
        local text_cost = GUI:GetChildControl(self.view.datalist_cost,realIndex,'text_cost')
        local text_name = GUI:GetChildControl(self.view.datalist_cost,realIndex,'text_name')
        local btn_add = GUI:GetChildControl(self.view.datalist_cost,realIndex,'btn_add')
        local info = self.itemCostList[realIndex + 1]
        GUI:Item_setItemId(item_cost, info.id)
        local count = SL:GetBagItemCount(info.id)
        if count < info.cost then
            count = SL:GetSimpleNumber(count, 2)
            GUI:Text_setString(text_cost, "<color=#FF2323>" .. count .. "</color>/" .. info.cost)
            self.canUpgrade = false
        else
            count = SL:GetSimpleNumber(count, 2)
            GUI:Text_setString(text_cost, "<color=#00ff00>" .. count .. "</color>/" .. info.cost)
        end
        ---@type cfg_item_column
        local item = SL:GetConfig("cfg_item", info.id)
        GUI:Text_setString(text_name, item.name)
        
        GUI:AddOnClickEvent(item_cost, self, self.ItemCostTipsClick, info.id)
        GUI:AddOnClickEvent(btn_add, self, self.ItemCostGetClick, info.id)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.btn_upgrade, self, self.UpgradeSkill)
    GUI:AddOnClickEvent(self.view.btn_max,self,self.ShowMaxEffect)
    GUI:AddOnClickEvent(self.view.btn_back,self,self.ShowNowEffect)
    
    SL:RegisterLuaNetMsg(MessageDef.ResComboSkillInfoMessage, self.ResComboSkillInfoMessage, self)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    self.job = SL:GetMetaValue(EMetaVarGetKey.JOB)
    self.comboInfo = SL:GetMetaValue(EMetaVarGetKey.GET_COMBO_SKILL)
    self.comboTbl = {}
    ---@type cfg_skill_info_column[]
    local cfg_skill_info = SL:GetConfigTable("cfg_skill_info")
    local skill_str = SL:GetConfig("cfg_global", 1501).value
    local skillTbl = string.split(skill_str, '|')  --1#1030001#1#0|2#1030002#1#0|3#1030003#1#0
    for i, v in pairs(skillTbl) do
        local tbl = string.split(v, '#')
        if tonumber(tbl[1]) == self.job then
            self.comboSkillCfgId = tonumber(tbl[2])
            break
        end
    end
    self.maxLevel = 0
    for _, v in pairs(cfg_skill_info) do
        if v.skillID == self.comboSkillCfgId then
            self.comboTbl[v.skillLevel] = v
            if v.skillLevel > self.maxLevel then
                self.maxLevel = v.skillLevel
            end
        end
    end
    self:RefreshUI()
end

function this:RefreshUI()
    ---刷新界面角色素模
    local modelTbl = SL:GetConfig("cfg_model_default", self.job)
    local role_param = { "body", "head", "armor", "hand", "pants", "boot" }
    local modelStr
    for _, v in pairs(role_param) do
        if modelStr then
            modelStr = modelStr .. "#" .. modelTbl[v]
        else
            modelStr = modelTbl[v]
        end
    end
    local info, info_next
    if next(self.comboInfo) then
        ---激活
        ---@type cfg_skill_info_column
        info = self.comboTbl[self.comboInfo.skillLv]
        ---@type cfg_skill_info_column
        info_next = self.comboTbl[self.comboInfo.skillLv + 1]
    else
        ---未激活
        info_next = self.comboTbl[1]
    end
    
    if not info_next then
        ---当前满级
        GUI:setVisible(self.view.panel_upgrade, false)
        GUI:setVisible(self.view.panel_max, true)
        GUI:Text_setString(self.view.text_max_detail, info.tips)

        GUI:SetPlayerRoleInfo(self.view.role_max, modelStr)
        GUI:Effect_setEffectId(self.view.role_effect_max, info.haloEffect)
    else
        if not info then
            ---当前未激活
            GUI:setVisible(self.view.img_left_active, false)
            GUI:setVisible(self.view.img_left_unActive, true)
            local text = SL:GetConfig("cfg_rule_text", 14).location
            GUI:Text_setString(self.view.text_left_detail, text)
            GUI:Button_setTitleText(self.view.btn_upgrade, "激活")
        else
            ---当前未满级
            GUI:setVisible(self.view.img_left_active, true)
            GUI:setVisible(self.view.img_left_unActive, false)
            GUI:Text_setString(self.view.text_left_lv, tostring(info.skillLevel))
            GUI:Text_setString(self.view.text_left_detail, info.tips)
            GUI:Button_setTitleText(self.view.btn_upgrade, "升级")
        end
        GUI:setVisible(self.view.panel_upgrade, true)
        GUI:setVisible(self.view.panel_max, false)
        GUI:Text_setString(self.view.text_right_lv, tostring(info_next.skillLevel))
        GUI:Text_setString(self.view.text_right_detail, info_next.tips)
        ---刷新消耗
        self.canUpgrade = true
        self.itemCostList = {}
        ---刷新升级材料
        for i, v in ipairs(info_next.skillLevelUpItemID) do
            self.itemCostList[#self.itemCostList + 1] = { ["id"] = v[1], ["cost"] = v[2] }
        end
        GUI:DataListUpdateData(self.view.datalist_cost)

        GUI:SetPlayerRoleInfo(self.view.role, modelStr)
        if info then
            GUI:Effect_setEffectId(self.view.role_effect, info.haloEffect)
        end
        GUI:setVisible(self.view.btn_max, true)
        GUI:setVisible(self.view.btn_back, false)
    end
end

function this:UpgradeSkill()
    if self.canUpgrade then
        if not self.delayUpgrade then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_COMBO_SKILL_UP)
            self.delayUpgrade = true
            SL:ScheduleOnce(1, function()
                self.delayUpgrade = false
            end)
        end
    else
        SL:TipMessage( SL:GetConfig('cfg_string', 463).text, 1, NoticeType.NoticeMid ) --道具不足，请补充道具！
    end
end

function this:ItemCostTipsClick(_, eventData)
    SL:OpenTips(nil, eventData)
end

function this:ItemCostGetClick(_, eventData)
    SL:CommonItemGetPath(nil, eventData, nil, nil, self)
end

function this:ShowMaxEffect()
    GUI:setVisible(self.view.btn_max, false)
    GUI:setVisible(self.view.btn_back, true)
    GUI:Effect_setEffectId(self.view.role_effect, self.comboTbl[self.maxLevel].haloEffect)
    
end

function this:ShowNowEffect()
    GUI:setVisible(self.view.btn_max, true)
    GUI:setVisible(self.view.btn_back, false)
    if self.comboInfo.skillLv then
        GUI:Effect_setEffectId(self.view.role_effect, self.comboTbl[self.comboInfo.skillLv].haloEffect)
    else
        GUI:Effect_setEffectId(self.view.role_effect, 0)
    end
end

---连击技能升级返回
function this:ResComboSkillInfoMessage(_, message)
    self.comboInfo = message
    self:RefreshUI()
    SL:SetMetaValue(EMetaVarSetKey.COMBOSKILL_CHANGE, self.comboInfo.skillCfgId, self.comboInfo.skillLv)
    GUI:SetActive(self.view.strength_ok, false)
    GUI:SetActive(self.view.strength_ok, true)
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/DragonSoulCombo/Panel/KLDragonSoulCombo/KLDragonSoulComboPanel")
    --GUI:UIPanel_Open("dev/outui/DragonSoulCombo/Panel/KLDragonSoulCombo/KLDragonSoulComboPanel")
end

function this:Close()
    self.delayUpgrade = false
    SL.ShowMainPanel()
end

return this

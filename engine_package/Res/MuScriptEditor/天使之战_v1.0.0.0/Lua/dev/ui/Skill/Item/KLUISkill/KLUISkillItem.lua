---@class KLUISkillItem:UIKmlLuaPanelBase
---@field view KLUISkillItemView
---@field skillId number @技能Id
---@field baseUI KLUISkillPageItem
local KLUISkillItem = class(UIKmlLuaPanelBase)
local this = KLUISkillItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param skillId number
function this:UpdateUI(skillId, luaIndex)
    self.skillId = skillId
    self.luaIndex = luaIndex

    ---@type Skill
    local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, self.skillId)
    local skillLv = skill and skill.level or 1

    local skillType = E_SkillShowType.Normal
    ---变身技能走另一套逻辑
    local cacheSkill = InfoManager.shapeShiftCardInfo:GetTransferSkillInfoBySkillId(self.skillId)
    if cacheSkill then
        if cacheSkill.unLock then
            GUI:Text_setString(self.view.Level,"Lv." .. cacheSkill.level)
            GUI:SetActive(self.view.Lock,false)            
        else           
            GUI:Text_setString(self.view.Level,"")
            GUI:SetActive(self.view.Lock,true)
        end
        skillType = E_SkillShowType.Transfer
    else
        if skill and SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_IS_UNLOCK, self.skillId) then
            GUI:Text_setString(self.view.Level,"Lv." .. skillLv)
            GUI:SetActive(self.view.Lock,false)
        else
            GUI:Text_setString(self.view.Level,"")
            GUI:SetActive(self.view.Lock,true)
        end
    end
    GUI:SetActive(self.view.Level,false)
    ---@type cfg_skill_info_column
    local tbl = SL:GetConfigMultiKeys('cfg_skill_info', self.skillId, skillLv, 'skillID', 'skillLevel')
    
    GUI:Text_setString(self.view.SkillName,tbl.name)
    local  spriteName = string.isNullOrEmpty(tbl.icon) and "" or tbl.icon
    if cfg_equip_angelTalentLv_post.IsAngelTalentSkill(self.skillId) then
        GUI:SetActive(self.view.SpRed,false)
    else
        if skillType == E_SkillShowType.Normal then
            local ret = SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_RED_DOT, self.skillId, skillLv)
            GUI:SetActive(self.view.SpRed,ret)
        elseif skillType == E_SkillShowType.Transfer then
            GUI:SetActive(self.view.SpRed, false)
        end
    end
    GUI:Image_loadTexture(self.view.SkillIcon,spriteName,"Atlas/UIOutSkillIcon.spriteatlas")
    if self.baseUI.baseUI.curSelectId == self.skillId then
        self.baseUI.baseUI.curSelectIndex = 0
        if this.co_Select then
            SL:UnSchedule(this.co_Select)
        end

        this.co_Select = SL:ScheduleOnce(0.2, function()
            if not self.baseUI.baseUI.isOpenSetting then
                GUI:SetTogDefaultThis(self.view.skillTog)
            end
        end)

    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.skillTog, self, self.SkillTogOnChange)
    SL:RegisterLUAEvent(Event.SkillChange, self.ResSkillChangeMessage, self)
end

---@param eventData SkillProtos.SkillChangeRes
function this:ResSkillChangeMessage(_, eventData)
    if not eventData or not eventData.skillInfo then
        return
    end

    for _, skillInfo in pairs(eventData.skillInfo) do
        if skillInfo.skillId == self.skillId then
            self:UpdateUI(self.skillId, self.luaIndex)
        end
    end
end

function this:SkillTogOnChange(_, _, args)
    if args[1] then
        SL:onLUAEvent(LUA_EVENT_SELECT_SKILL_UI, self)
    end
end

function this:SetIsOnWithoutNotify(isOn)
    return GUI:SetIsOnWithoutNotify(self.view.skillTog, isOn)
end

function this:SetTogDefaultThis()
    return GUI:SetTogDefaultThis(self.view.skillTog)
end

function this:SetTogIsOn(bl)
    return GUI:Toggle_setIsOn(self.view.skillTog, bl)
end

function this:Close()
    self.skillId = nil
    if this.co_Select then
        SL:UnSchedule(this.co_Select)
        this.co_Select = nil
    end
end

return this

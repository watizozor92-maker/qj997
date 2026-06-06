---@class KLSkillSelectItem:UIKmlLuaPanelBase
---@field view KLSkillSelectItemView
local KLSkillSelectItem = class(UIKmlLuaPanelBase)
local this =KLSkillSelectItem

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnTouchEvent(self.view.button1, self, function(ui, control, eventType, systemData)
        if eventType == EUIEventName.OnPointerDown then
            if systemData.button ~= InputButton.Left then
                return
            end
            self:OnClick()
        end
        if  eventType == EUIEventName.OnPointerEnter then
            PCSkillInfoMgr.nowKeyId=self.skillId
            GUI:setVisible(self.view.img1, true)
            GUI:UIPanel_Open("dev/outui/Skill/Panel/KLSkillFloatInfo/KLSkillFloatInfoPanel",nil,nil,{skillId=self.skillId})
        end
        if  eventType == EUIEventName.OnPointerExit then
            GUI:setVisible(self.view.img1, false)
            PCSkillInfoMgr.nowKeyId=0 
            GUI:UI_Close("dev/outui/Skill/Panel/KLSkillFloatInfo/KLSkillFloatInfoPanel")
        end
    end)
    --GUI:AddOnTouchEvent(self.view.button1, self, self.OnTouchEvent)
    --GUI:AddOnClickEvent(self.view.button1,self,)
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
end

function this:UpdateUI(skillId,luaIndex)
   
    self.skillId = skillId
    self:ChangeSelectSkill()
    self.luaIndex = luaIndex
    local  spriteName=""
    ---@type Skill
    local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, self.skillId)

    --log(skill.skillId)
    local skillLv = skill and skill.level or 1
    if skill.skillId > 0 then
        ---@type Skill
        --local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, self.skillId)
        --local skillLv = skill and skill.level or 1
        ---@type cfg_skill_info_column
        local tbl = SL:GetConfigMultiKeys('cfg_skill_info', skill.skillId, skillLv, 'skillID', 'skillLevel')
        spriteName = string.isNullOrEmpty(tbl.icon) and "" or tbl.icon
        self.view.img2:SetAtlasSprite("Atlas/UIOutSkillIcon.spriteatlas", spriteName)
        self.view.img2:SetActive(true)
    end
end

function this:OnTouchEvent(kmlCtrl, eventType, args)
    return self.baseUI:OnTouchEvent(kmlCtrl, eventType, args,self.skillId)
end

function this:OnClick()
    if LoginManager.selectSkillId.value==self.skillId then
        return
    end
    ---点击之后将右键技能设置为该技能
    LoginManager.selectSkillId:Set(self.skillId)
    --self.baseUI:ChangeSelectSkill()
    --self.view.img3:SetActive(true)
   --self.baseUI.lastSelect=self
    ---抛出技能改变事件，用于刷新
    SL:onLUAEvent(LUA_EVENT_SelectSkill_Change)
end

function this:ChangeSelectSkill()
    self.view.img3:SetActive(false)
    if LoginManager.selectSkillId and LoginManager.selectSkillId.value~=0 then
        if LoginManager.selectSkillId.value==self.skillId then
           log("当前右键技能id"..LoginManager.selectSkillId.value)  
            --self.baseUI.lastSelect=self
            self.view.img3:SetActive(true)
        end
    end
end

return this

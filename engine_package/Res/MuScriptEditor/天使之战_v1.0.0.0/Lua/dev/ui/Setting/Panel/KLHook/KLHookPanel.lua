---@class KLHookPanel:UIKmlLuaPanelBase
---@field view KLHookPanelView
local KLHookPanel = class(UIKmlLuaPanelBase)
local this =KLHookPanel
---创建时调用一次
function this:Init()
    self.hookSkillTemplateList = {}
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local range = SL:GetMetaValue(EMetaVarGetKey.GET_KILL_RANGE)
    local hp = SL:GetMetaValue(EMetaVarGetKey.GET_EAT_HP_PILL_PERCENTAGE)
    local mp = SL:GetMetaValue(EMetaVarGetKey.GET_EAT_MP_PILL_PERCENTAGE)
    local isReAttack = SL:GetMetaValue(EMetaVarGetKey.GET_IS_COUNTERATTACK)
    local isComebackHookPoint = SL:GetMetaValue(EMetaVarGetKey.GET_IS_COMEBACK_HOOKPOINT)
    local comebackTime = SL:GetMetaValue(EMetaVarGetKey.GET_COMEBACK_HOOKPOINT_WAIT_TIEM)
    local career = SL:GetMetaValue(EMetaVarGetKey.JOB)
    local callSkillId = SL:GetMetaValue(EMetaVarGetKey.GET_CALL_SKILL)
    local plan = SL:GetMetaValue(EMetaVarGetKey.GET_HOOK_ATUO_RELEASE_SKILL_PLAN)
    
    GUI:SetIsOnWithoutNotify(self.view["ScopeOfMonster"..range],true)
    GUI:Slider_setPercent(self.view.hpSlider,math.ceil(hp*100))
    GUI:Slider_setPercent(self.view.mpSlider,math.ceil(mp*100))
    GUI:Text_setString(self.view.hpTxt,"生命低于"..math.ceil(hp*100) .."%使用")
    GUI:Text_setString(self.view.mpTxt,"魔法低于"..math.ceil(mp*100) .."%使用")
    GUI:SetIsOnWithoutNotify(self.view.combackAtk,isReAttack)
    GUI:SetIsOnWithoutNotify(self.view.combackHookPoint,isComebackHookPoint)
    GUI:Text_setString(self.view.comebackTime,tostring(comebackTime))
    GUI:setVisible(self.view.callSkill,career == ECareer.Dao)
    if career == ECareer.Dao and callSkillId~= 0 then
        local skillLevel = SL:GetMetaValue(EMetaVarGetKey.SKILL_LEVEL,callSkillId)
        ---@type cfg_skill_info_column
        local skillInfoTbl = SL:GetConfigMultiKeys('cfg_skill_info', callSkillId, skillLevel, 'skillID', 'skillLevel')
        GUI:Image_loadTexture(self.view.skillIcon,skillInfoTbl.icon,"Atlas/UIOutSkillIcon.spriteatlas")
        GUI:Text_setString(self.view.skillName,skillInfoTbl.name)
        GUI:setVisible(self.view.skillIcon,true)
        GUI:Text_setString(self.view.skillLevel,"LV " ..skillLevel)
    else
        GUI:setVisible(self.view.skillIcon,false)
        GUI:Text_setString(self.view.skillName,"")
        GUI:Text_setString(self.view.skillLevel,"")
    end
    GUI:SetIsOnWithoutNotify(self.view["planToggle"..plan],true)
    self:ShowHookSkill()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.ScopeOfMonster1,self,self.SelectKillRangeOnToggleValueChange,1)
    GUI:SetToggleOnValueChange(self.view.ScopeOfMonster2,self,self.SelectKillRangeOnToggleValueChange,2)
    GUI:SetToggleOnValueChange(self.view.ScopeOfMonster3,self,self.SelectKillRangeOnToggleValueChange,3)
    GUI:SetToggleOnValueChange(self.view.ScopeOfMonster4,self,self.SelectKillRangeOnToggleValueChange,4)
    GUI:SetToggleOnValueChange(self.view.ScopeOfMonster5,self,self.SelectKillRangeOnToggleValueChange,5)
    GUI:SetToggleOnValueChange(self.view.ScopeOfMonster6,self,self.SelectKillRangeOnToggleValueChange,6)
    GUI:SetToggleOnValueChange(self.view.ScopeOfMonster7,self,self.SelectKillRangeOnToggleValueChange,7)
    GUI:SetToggleOnValueChange(self.view.ScopeOfMonster8,self,self.SelectKillRangeOnToggleValueChange,8)
    GUI:Slider_addOnEvent(self.view.hpSlider,self,self.HpSliderOnValueChange)
    GUI:Slider_addOnEvent(self.view.mpSlider,self,self.MpSliderOnValueChange)
    GUI:SetToggleOnValueChange(self.view.combackAtk,self,self.CombackAtkOnToggleValueChange)
    GUI:SetToggleOnValueChange(self.view.combackHookPoint,self,self.CombackHookPointOnToggleValueChange)
    GUI:Input_SetOnValueChange(self.view.comebackTime,self,self.ComebackTimeOnInputValueChange)
    GUI:AddOnClickEvent(self.view.CallSkillBtn,self,self.CallSkillOnClick)
    GUI:SetToggleOnValueChange(self.view.planToggle1,self,self.PlanToggleOnToggleValueChange,1)
    GUI:SetToggleOnValueChange(self.view.planToggle2,self,self.PlanToggleOnToggleValueChange,2)

    SL:RegisterLUAEvent(LUA_SELECT_CALL_SKILL,self.SelectCallSkillFunc,self)
end

function this:SelectKillRangeOnToggleValueChange(control,data,eventData)
    local range = data
    SL:SetMetaValue(EMetaVarSetKey.SET_KILL_RANGE,range)
end

function this:HpSliderOnValueChange(control,_,data)
    local value = math.ceil(data[1])/100
    SL:SetMetaValue(EMetaVarSetKey.SET_EAT_HP_PILL_PERCENTAGE,value)
    GUI:Text_setString(self.view.hpTxt,"生命低于".. math.ceil(value*100) .."%使用")
end

function this:MpSliderOnValueChange(control,_,data)
    local value = math.ceil(data[1])/100
    SL:SetMetaValue(EMetaVarSetKey.SET_EAT_MP_PILL_PERCENTAGE,value)
    GUI:Text_setString(self.view.mpTxt,"魔法低于".. math.ceil(value*100) .."%使用")
end

function this:CombackAtkOnToggleValueChange(control,_,data)
    local isToggle = data[1]
    SL:SetMetaValue(EMetaVarSetKey.SET_IS_COUNTERATTACK,isToggle)
end

function this:CombackHookPointOnToggleValueChange(control,_,data)
    local isToggle = data[1]
    SL:SetMetaValue(EMetaVarSetKey.SET_IS_COMEBACK_HOOKPOINT,isToggle)
end

function this:ComebackTimeOnInputValueChange(control,_,data)
    local value = data[1]
    SL:SetMetaValue(EMetaVarSetKey.SET_COMEBACK_HOOKPOINT_WAIT_TIEM,tonumber(value))
end

function this:CallSkillOnClick()
    GUI:UIPanel_Open("dev/ui/Setting/Panel/KLCallSkill/KLCallSkillPanel")
end

function this:PlanToggleOnToggleValueChange(control,data,eventData)
    SL:SetMetaValue(EMetaVarSetKey.SET_HOOK_ATUO_RELEASE_SKILL_PLAN,data)
    self:ShowHookSkill()
end

function this:SelectCallSkillFunc(_,skillId)
    if skillId ~= 0 then
        local skillLevel = SL:GetMetaValue(EMetaVarGetKey.SKILL_LEVEL,skillId)
        ---@type cfg_skill_info_column
        local skillInfoTbl = SL:GetConfigMultiKeys('cfg_skill_info', skillId, skillLevel, 'skillID', 'skillLevel')
        GUI:Image_loadTexture(self.view.skillIcon,skillInfoTbl.icon,"Atlas/UIOutSkillIcon.spriteatlas")
        GUI:Text_setString(self.view.skillName,skillInfoTbl.name)
        GUI:setVisible(self.view.skillIcon,true)
        GUI:Text_setString(self.view.skillLevel,"LV " ..skillLevel)
    else
        GUI:setVisible(self.view.skillIcon,false)
        GUI:Text_setString(self.view.skillLevel,"")
        GUI:Text_setString(self.view.skillName,"")
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_CALL_SKILL,skillId)
end


function this:ShowHookSkill()
    local hookSkills = SL:GetMetaValue(EMetaVarGetKey.GET_HOOK_ATUO_RELEASE_SKILL)
    local skills = SL:GetMetaValue(EMetaVarGetKey.GET_ME_ALL_SKILL)
    if skills then
        local tempSkills = {}
        ---@param v Skill
        for i, v in pairs(skills) do
            ---@type cfg_skill_column
            local skillTbl = SL:GetConfig('cfg_skill', v.skillId)
            local commonSkillId = SL:GetMetaValue(EMetaVarGetKey.SKILL_GET_COMMON_ID)
            if skillTbl and skillTbl.set ~= 1 and v.skillId ~= commonSkillId and skillTbl.group ~= ESkillGroup.call then
                local data = {skillId = v.skillId,isHookSkill = hookSkills[v.skillId]~=nil}
                table.insert(tempSkills,data)
            end
        end

        self.transferSkill = InfoManager.shapeShiftCardInfo.onHookTransferSkill
        for i, v in pairs(InfoManager.shapeShiftCardInfo.shiftSkill) do
            local data = { skillId = i, isHookSkill = self.transferSkill[i] or 1, isTransfer = true }
            table.insert(tempSkills, data)
        end

        local count = table.count(tempSkills)
        local n1 = count%3
        local n2 = math.floor(count/3)
        if n1 ~= 0 then
            n2 = n2 + 1
        end
        local career = SL:GetMetaValue(EMetaVarGetKey.JOB)
        local h = career == ECareer.Dao and (650 + n2*156) or (644 + (n2-1)*156)
        GUI:setContentSize(self.view.ContainerContent,374,h)
        GUI:setContentSize(self.view.HookSkillContainer,384,n2*156)

        for i, data in pairs(tempSkills) do
            ---@type KLHookSkillItem
            local hookSkillTemplate = self.hookSkillTemplateList[data.skillId]
            if not hookSkillTemplate then
                hookSkillTemplate = GUI:UIPanel_Open("dev/ui/Setting/Item/KLHookSkill/KLHookSkillItem",self.view.HookSkillContainer,self,data,true)
            else
                hookSkillTemplate.args = data
                hookSkillTemplate:Refresh()
            end
            self.hookSkillTemplateList[data.skillId] = hookSkillTemplate
        end
    end
end

function this:SetTransferSkillInfo(group, isRelease)
    if not self.transferSkill then
        self.transferSkill = {}
    end
    self.isChange = true
    self.transferSkill[group] = isRelease and 1 or 0
end

function this:Close()
    if self.isChange then
        local info = {}
        for i, v in pairs(self.transferSkill) do
            info[tostring(i)] = v
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRANSFER_CARD_HANG_UP_SETTING, info)
    end
    self.transferSkill = {}
    self.hookSkillTemplateList = {}
    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLCallSkill/KLCallSkillPanel")
end

return this

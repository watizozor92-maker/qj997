---@class KLKillMonsterSettingPanel:UIKmlLuaPanelBase
---@field view KLKillMonsterSettingPanelView
local KLKillMonsterSettingPanel = class(UIKmlLuaPanelBase)
local this =KLKillMonsterSettingPanel
isNotAttackPoint = true
---创建时调用一次
function this:Init() 
    self.isFirst = true
    self.isClickSave = false
    self.plan = nil
    self.hookSkillTemplateList = {}
    self.isComebackHookPoint = SL:GetMetaValue(EMetaVarGetKey.GET_IS_COMEBACK_HOOKPOINT)
    
    GUI:Button_loadTextures(self.view.combackHookBtn,self.isComebackHookPoint and "btn_fatener_ok" or "btn_fatener_no",nil,nil,"Atlas/KLHookHepler.spriteatlas")
    GUI:Button_loadTextures(self.view.noAttackBtn,isNotAttackPoint and "btn_fatener_no" or "btn_fatener_ok",nil,nil,"Atlas/KLHookHepler.spriteatlas")
    
--[[    local hpSlider = GUI:GetRectTransform(self.view.sliderHP)
    local handle_attach = hpSlider.transform:Find("handleSlideArea_attach&isAttach&KmlPanel").transform:Find("handle_attach&isAttach&KmlImage")
    handle_attach.sizeDelta = {x=31,y=18}]]--[[
    local mpSlider = GUI:GetRectTransform(self.view.sliderMP)
    local handle_attachMP = mpSlider.transform:Find("handleSlideArea_attach&isAttach&KmlPanel").transform:Find("handle_attach&isAttach&KmlImage")
    handle_attachMP.sizeDelta = {x=31,y=18}]]
    self:SetSlider(self.view.sliderMP)
    self:SetSlider(self.view.sliderHP)
end

function this:SetSlider(slider)
    local bg_attach = GUI:GetAttachRectTransform(slider,"bg_attach"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    local fillArea_attach = GUI:GetAttachRectTransform(slider,"fillArea_attach"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    local fill_attach = GUI:GetAttachRectTransform(slider,"fill_attach"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    local handleSlideArea_attach = GUI:GetAttachRectTransform(slider,"handleSlideArea_attach"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    local fill_attach_image = GUI:GetAttachRectTransform(slider,"fill_attach"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    local handle_attach = GUI:GetAttachRectTransform(slider,"handle_attach"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    self:SetRectTrans(bg_attach, Vector2.New(0, 0), Vector2.New(1, 1), Vector2.New(4, 0))
    self:SetRectTrans(fillArea_attach, Vector2.New(0, 0), Vector2.New(1, 1), Vector2.New(-2, 0))
    self:SetRectTrans(fill_attach, Vector2.New(0, 0), Vector2.New(1, 1), Vector2.New(8, 0))
    self:SetRectTrans(handleSlideArea_attach, Vector2.New(0, 0), Vector2.New(1, 1), Vector2.New(-8, 0))
    self:SetRectTrans(handle_attach, Vector2.New(0.5, 0.5), Vector2.New(0.5, 0.5), Vector2.New(31, 7))
    --GUI:Image_setType(fill_attach,EImageType.Filled,EImageFillMethod.Horizontal)
    fill_attach_image.type = EImageType.Filled
    fill_attach_image.fillMethod  = EImageFillMethod.Horizontal
end

function this:SetRectTrans(rectTrans, anchorMin, anchorMax, sizeDelta)
    rectTrans.anchoredPosition = Vector3.New(0, 0, 0)
    rectTrans.anchorMin = anchorMin
    rectTrans.anchorMax = anchorMax
    rectTrans.sizeDelta = sizeDelta
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.toggle_pos_1,self,self.SelectKillRangeOnToggleValueChange,1)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_2,self,self.SelectKillRangeOnToggleValueChange,2)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_3,self,self.SelectKillRangeOnToggleValueChange,3)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_4,self,self.SelectKillRangeOnToggleValueChange,4)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_5,self,self.SelectKillRangeOnToggleValueChange,5)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_6,self,self.SelectKillRangeOnToggleValueChange,6)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_7,self,self.SelectKillRangeOnToggleValueChange,7)
    GUI:SetToggleOnValueChange(self.view.toggle_pos_8,self,self.SelectKillRangeOnToggleValueChange,8)

    
    GUI:SetToggleOnValueChange(self.view.planToggle1,self,self.PlanToggleOnToggleValueChange,1)
    GUI:SetToggleOnValueChange(self.view.planToggle2,self,self.PlanToggleOnToggleValueChange,2)
    
    GUI:Input_SetOnEndEdit(self.view.input_time, self, self.InputFieldOnEndEdit)
    GUI:Input_SetOnValueChange(self.view.input_time, self, self.ComebackTimeOnInputValueChange)
    GUI:AddOnClickEvent(self.view.combackHookBtn,self,self.CombackHookOnClick)
    GUI:AddOnClickEvent(self.view.noAttackBtn,self,self.NoAttackOnClick)

    GUI:SetSliderOnValueChange(self.view.sliderHP, self, self.sliderHPOnValueChange)
    GUI:SetSliderOnValueChange(self.view.sliderMP, self, self.sliderMPOnValueChange)
end
function this:sliderHPOnValueChange(control, _, data)
    local value = Mathf.Ceil(data[1])
    GUI:Text_setText(self.view.sliderHPText,(Mathf.Ceil(value)) .."%")
    self.hp = value/100
    --SL:SetMetaValue(EMetaVarSetKey.SET_EAT_HP_PILL_PERCENTAGE,value)
end
function this:sliderMPOnValueChange(control, _, data)
    local value =Mathf.Ceil(data[1])
    GUI:Text_setText(self.view.sliderMPText,(Mathf.Ceil(value)) .."%")
    --SL:SetMetaValue(EMetaVarSetKey.SET_EAT_MP_PILL_PERCENTAGE,value)
    self.mp = value/100
end
function this:ComebackTimeOnInputValueChange(control,_,data)
    local value = tonumber(data[1])
    if type(value) == "number" then
        if value > 999 then
            value = 999
        end
        if value <= 0  then
            value =  0
        end
    else
        value = 10
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_COMEBACK_HOOKPOINT_WAIT_TIEM,tonumber(value))
end

function this:InputFieldOnEndEdit(_, _, eventData)
    local value = tonumber(eventData[1])
    if type(value) == "number" then
        if value > 999 then
            value = 999
        end
        if value <= 0  then
            value =  0
        end
    else
        value = 10
    end

    GUI:SetInputText(self.view.input_time,tostring(value))
end

function this:CombackHookOnClick()
    self.isComebackHookPoint = not self.isComebackHookPoint
    GUI:Button_loadTextures(self.view.combackHookBtn,self.isComebackHookPoint and "btn_fatener_ok" or "btn_fatener_no",nil,nil,"Atlas/KLHookHepler.spriteatlas")
end

function this:NoAttackOnClick()
    isNotAttackPoint = not isNotAttackPoint
    GUI:Button_loadTextures(self.view.noAttackBtn,isNotAttackPoint and "btn_fatener_no" or "btn_fatener_ok",nil,nil,"Atlas/KLHookHepler.spriteatlas")
end

function this:SelectKillRangeOnToggleValueChange(control,data,eventData)
    local isOn = eventData[1]
    if isOn then
        self.range = data
    end
end

function this:HpOnToggleValueChange(control,data,eventData)
    --self.hp = data
end

function this:MpOnToggleValueChange(control,data,eventData)
    --self.mp = data
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    local comebackTime = SL:GetMetaValue(EMetaVarGetKey.GET_COMEBACK_HOOKPOINT_WAIT_TIEM) or 10
    GUI:SetInputText(self.view.input_time,tostring(comebackTime))
    self.mp = 0
    self.hp = 0
    local autoUseDrugList = string.split(InfoManager.mainUIInfo.autoUseDrug,'#')
    local hp = tonumber(autoUseDrugList[1]) --SL:GetMetaValue(EMetaVarGetKey.GET_EAT_HP_PILL_PERCENTAGE)
    local mp = tonumber(autoUseDrugList[2])
    self.hp = hp
    self.mp = mp
--[[    if hp == 0.7 then
        hp = 0.8
        SL:SetMetaValue(EMetaVarSetKey.SET_EAT_HP_PILL_PERCENTAGE,hp)
    end]]

--[[    local hpControl = self.view["toggleHp_" .. math.floor(100 * hp)]
    GUI:SetTogDefaultThis(hpControl)]]

    --local mp = SL:GetMetaValue(EMetaVarGetKey.GET_EAT_MP_PILL_PERCENTAGE)

--[[    if mp == 0.7 then
        mp = 0.8
        SL:SetMetaValue(EMetaVarSetKey.SET_EAT_MP_PILL_PERCENTAGE,mp)
    end]]
    GUI:Slider_setPercent(self.view.sliderHP, hp*100)
    GUI:Text_setText(self.view.sliderHPText,(Mathf.Ceil(hp*100)) .."%")
    GUI:Slider_setPercent(self.view.sliderMP, mp*100)
    GUI:Text_setText(self.view.sliderMPText,(Mathf.Ceil(mp*100)) .."%")
--[[    local mpControl = self.view["toggleMp_" .. math.floor(100 * mp)]
    if  not mpControl then
        mpControl =self.view.toggleMp_80
    end]]
    local range = SL:GetMetaValue(EMetaVarGetKey.GET_KILL_RANGE)
    range = range ~= 0 and range or 1
    self.startPlan = SL:GetMetaValue(EMetaVarGetKey.GET_HOOK_ATUO_RELEASE_SKILL_PLAN) or 1
    
--[[    GUI:SetTogDefaultThis(hpControl)
    GUI:SetTogDefaultThis(mpControl)]]
    GUI:SetTogDefaultThis(self.view["toggle_pos_" .. range])
    GUI:SetTogDefaultThis(self.view["planToggle"..self.startPlan])
    
end
function this:Save()
    
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UPDATE_ROLE_SETTING, { ["type"] = ERoleSettingType_Out.autoUseDrug, ["value"] = self.hp.."#"..self.mp })
    InfoManager.mainUIInfo.autoUseDrug = self.hp.."#"..self.mp
--[[    SL:SetMetaValue(EMetaVarSetKey.SET_EAT_MP_PILL_PERCENTAGE,self.mp)
    SL:SetMetaValue(EMetaVarSetKey.SET_EAT_HP_PILL_PERCENTAGE,self.hp)]]
    SL:SetMetaValue(EMetaVarSetKey.SET_KILL_RANGE,self.range)
    if self.plan then
        SL:SetMetaValue(EMetaVarSetKey.SET_HOOK_ATUO_RELEASE_SKILL_PLAN,self.plan)
        InfoManager.LianJiInfo:SetSkillByGroup()
    end
    self.isClickSave = true
    SL:SetMetaValue(EMetaVarSetKey.SET_IS_COMEBACK_HOOKPOINT,self.isComebackHookPoint)
    ---召唤兽技能走通用释放逻辑
    SL:SetMetaValue(EMetaVarSetKey.SET_CALL_SKILL,0)
end

function this:PlanToggleOnToggleValueChange(control,data,eventData)
    SL:SetMetaValue(EMetaVarSetKey.SET_HOOK_ATUO_RELEASE_SKILL_PLAN,data)
    self.plan = data
    if eventData[1] then
        self:ShowHookSkill()
    end
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
            if skillTbl and skillTbl.set ~= 1 and v.skillId ~= commonSkillId then
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
        
        
        for i, data in pairs(tempSkills) do
            ---@type KLHookSkillItem
            local hookSkillTemplate = self.hookSkillTemplateList[data.skillId]
            if not hookSkillTemplate then
                hookSkillTemplate = GUI:UIPanel_Open("dev/ui/Setting/Item/KLHookSkill/KLHookSkillItem",self.view.gridview7,self,data,true)
            else
                hookSkillTemplate.args = data
                hookSkillTemplate:Refresh()
            end
            self.hookSkillTemplateList[data.skillId] = hookSkillTemplate
        end
        --GUI:ForceRebuildLayoutImmediate(self.view.HookSkillContainer)
        --local hight = GUI:GetHeight(self.view.HookSkillContainer)
        --if count == 0 then
        --    GUI:setVisible(self.view.skillNode,false)
        --else
        --    GUI:setContentSize(self.view.skillNode,469,hight+22)
        --    if self.isFirst then
        --        GUI:setPositionY(self.view.skillNode,-804)
        --    end
        --end
        self.isFirst =false
    end
end


function this:Hide()
end

function this:Close()
    if not self.isClickSave then
        SL:SetMetaValue(EMetaVarSetKey.SET_HOOK_ATUO_RELEASE_SKILL_PLAN,self.startPlan)
    end
    self:Save()
end

return this

---@class KLMainAttackPanel:UIKmlLuaPanelBase
---@field view KLMainAttackPanelView
---@field switchFormSkillItem KLSkillBtnItem @切换形态技能
local KLMainAttackPanel = class(UIKmlLuaPanelBase)
local this = KLMainAttackPanel

---@type table<ESkillType,number[]>>
local centerPos = {
    [ESkillType.All] = { 0, 0 },
    --[ESkillType.Turn] = { 175, -200 },
    [ESkillType.Turn] = { 0, 0 },
}

---@type table<ESkillType,table<number[][]>>
local itemPos = {
    [ESkillType.All] = {
        [1] = { 126, 27 },
        [2] = { 47, 30 },
        [3] = { -22, -8 },
        [4] = { -61, -76 },
        [5] = { -59, -155 },
        --[[[6] = { -67, 41 },
        [7] = { -136, -61 },]]
    },
    [ESkillType.Turn] = {
        --[[[1] = { -52.67 , 264.81 },
        [2] = { -150.00 , 224.50 },
        [3] = { -224.50 , 150.00 },
        [4] = { -264.81 , 52.67 },
        [5] = { -264.81 , -52.67 },]]
        [1] = { 126, 27 },
        [2] = { 47, 30 },
        [3] = { -22, -8 },
        [4] = { -61, -76 },
        [5] = { -59, -155 },
        [6] = { -224.50 , -150.00 },
        [7] = { -150.00 , -224.50 },
        [8] = { -52.67 , -264.81 },
    },

}

---切换形态技能
local switchFormSkill = {
    [1] = 1016006,
    [2] = 1016013,
}

---@type KLSkillBtnItem[]
local skillBtns = {}

local skillFormData;

---创建时调用一次
function this:Init()
    self.isClick = true
end

---创建或者刷新界面数据时调用
function this:Refresh()
    -- 是否是召唤师职业
    self.isSummoner = SL:MeData_GetCareer().baseCareer == 6
    if self.isSummoner then
        self:UpdateFormSkillUnlockState()
    else
        if self.switchFormSkillItem then
            GUI:UIPanel_Close(nil, self.switchFormSkillItem)
            self.switchFormSkillItem = nil
        end
    end
    
    self:UpdateUI()
    self:LUA_MOUNT_SHOW_CHANGE()
end

function this:UpdateUI()
    self.curShowType = SL:GetMetaValue(EMetaVarGetKey.SKILL_SETTING_SHOW_TYPE) or ESkillType.All
    local cPos = centerPos[self.curShowType]
    GUI:setPosition(self.view.SkillStruct, cPos[1], cPos[2])
    --local maxCount = 8
    local maxCount = 5
    if self.curShowType == ESkillType.All then
        if skillBtns[8] then
            GUI:UIPanel_Close(nil, skillBtns[8])
            skillBtns[8] = nil
        end
        --maxCount = 7
    end

    GUI:SetLocalEulerAngles(self.view.SkillStruct, 0, 0, 0)
    ---变身走另一套逻辑
    if InfoManager.shapeShiftCardInfo:isShiftMonster() then
        local shiftMonsterGroup = InfoManager.shapeShiftCardInfo.shiftMonsterGroup
        local shiftSkill = InfoManager.shapeShiftCardInfo.shiftSkill
        ---@type number[]
        local skills = shiftSkill[shiftMonsterGroup].unlockSkill
        local lockSkills = shiftSkill[shiftMonsterGroup].lockSkill
        local showSkills = {}
        local showSkillsLevel = {}
        for i, v in pairs(skills) do
            ---@type cfg_skill_column
            local skill = SL:GetConfig("cfg_skill", i)
            if skill.type == ECfgSkillType.Normal and skill.group == ESkillGroup.normal then
                showSkills[#showSkills + 1] = i
                showSkillsLevel[#showSkillsLevel + 1] = false
            elseif skill.type == ECfgSkillType.Normal and skill.group == ESkillGroup.ordinaryAttack then
                self.ordinaryAttackId = i
                self.ordinaryAttackLevel = v
                ---@type cfg_skill_info_column
                local skill_info = SL:GetConfigMultiKeys('cfg_skill_info', self.ordinaryAttackId, self.ordinaryAttackLevel, 'skillID', 'skillLevel')
                GUI:Image_loadTexture(self.view.sword, skill_info.icon, "Atlas/UIOutSkillIcon.spriteatlas")
            end
        end
        for i, v in pairs(lockSkills) do
            ---@type cfg_skill_column
            local skill = SL:GetConfig("cfg_skill", i)
            if skill.type == ECfgSkillType.Normal and skill.group == ESkillGroup.normal then
                local isHave = false
                for ii, vv in ipairs(showSkills) do
                    if i == vv then
                        isHave = true
                        break
                    end
                end
                if not isHave then
                    showSkills[#showSkills + 1] = i
                    showSkillsLevel[#showSkillsLevel + 1] = true
                end
            end
        end
        local pos = itemPos[self.curShowType]
        for i = 1, maxCount do
            ---@type KLSkillBtnItem
            local item = skillBtns[i]
            if not item then
                item = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLSkillBtn/KLSkillBtnItem", self.view.SkillStruct, self, nil, true)
                skillBtns[i] = item
            end
            GUI:setPosition(item.view.root, pos[i][1], pos[i][2])
            GUI:SetEulerAngles(item.view.root, 0, 0, 0)
            item:UpdateUI(showSkills[i],showSkillsLevel[i])
        end
        return
    end

    ---@type number[]
    local showSkills = SL:GetMetaValue(EMetaVarGetKey.SKILL_SHOW_LIST)
    local pos = itemPos[self.curShowType]
    for i = 1, maxCount do
        ---@type KLSkillBtnItem
        local item = skillBtns[i]
        if not item then
            item = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLSkillBtn/KLSkillBtnItem", self.view.SkillStruct, self, nil, true)
            skillBtns[i] = item
        end
        GUI:setPosition(item.view.root, pos[i][1], pos[i][2])
        GUI:SetEulerAngles(item.view.root, 0, 0, 0)
        item:UpdateUI(showSkills[i])
        if self.isSummoner then item:SwitchForm(self.skillForm) end
    end
    
    GUI:Image_loadTexture(self.view.sword, "img_interface_main039", "Atlas/UIMainAttackPanel.spriteatlas")
    GUI:SetCirclebar_time(self.view.Img_cdTime, 0)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(Event.Skill_CDing, self.OnSkillCDing, self)
    SL:RegisterLUAEvent(LUA_EVENT_REFRESH_ATTACK_SKILL, self.UpdateUI, self)
    GUI:AddOnClickEvent(self.view.AttackButton, self, self.OnAttackClick)
    GUI:AddOnTouchEvent(self.view.AttackButton, self, self.OnAttackTouch)

    GUI:AddOnClickEvent(self.view.BtnKillMonster, self, self.KillMonsterOnClick)
    GUI:AddOnClickEvent(self.view.BtnKillPerson, self, self.KillPersonOnClick)
    GUI:AddOnClickEvent(self.view.BtnMount, self, self.BtnMountOnClick)

    SL:RegisterLUAEvent(Event.UpdateSkillSetting, self.UpdateUI, self)
    SL:RegisterLUAEvent(LUA_EVENT_ME_RELEASE_SKILL, self.LUA_EVENT_ME_RELEASE_SKILL, self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE, self)
    SL:RegisterLUAEvent(Event.SkillChange, self.ResSkillChangeMessage, self)
    SL:RegisterLUAEvent(LUA_MOUNT_SHOW_CHANGE, self.LUA_MOUNT_SHOW_CHANGE, self)
    
end

function this:LUA_MOUNT_SHOW_CHANGE()
    if EquipFunc.GetDefaultMountId() ~= 0 then
        GUI:setVisible(self.view.BtnMount,true)
    else
        GUI:setVisible(self.view.BtnMount,false)
    end
end

function this:KillPersonOnClick()
    GUI:SetActive(self.view.killPerson, true)

    if self.co_eff_person then
        SL:UnSchedule(self.co_eff_person)
    end
    self.co_eff_person = SL:ScheduleOnce(0.5, function()
        GUI:SetActive(self.view.killPerson, false)
    end)
    ---@type CheckIsCanSkillDataType
    local skillDat = {
        skillId = SL:GetMetaValue(EMetaVarGetKey.SKILL_GET_COMMON_ID) or 0,
        selectAttachType = ERoleType.Player,
        common = true
    }
    SL:FGReleaseSkill(skillDat)
end

function this:KillMonsterOnClick()
    GUI:SetActive(self.view.killMonster, true)

    if self.co_eff_monster then
        SL:UnSchedule(self.co_eff_monster)
    end
    self.co_eff_monster = SL:ScheduleOnce(0.5, function()
        GUI:SetActive(self.view.killMonster, false)
    end)
    ---@type CheckIsCanSkillDataType
    local skillDat = {
        skillId = SL:GetMetaValue(EMetaVarGetKey.SKILL_GET_COMMON_ID) or 0,
        selectAttachType = ERoleType.Monster,
        common = true
    }
    SL:FGReleaseSkill(skillDat)
end

function this:BtnMountOnClick()
    if InfoManager.shapeShiftCardInfo:isShiftMonster() then
        SL:TipMessage( SL:GetConfig('cfg_string',487).text,1, NoticeType.NoticeMid )
        return
    end
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    if not SL:IsSkillAnimPlaying(tonumber(rid)) then
        local isFight,num_time = InfoManager.mountInfo:CheckIsFightTime()
        if isFight then
            local str = string.format( "战斗中无法骑乘，剩余%s秒", num_time)
            SL:TipMessage(str, 1, NoticeType.NoticeMid)
            return
        end
        if EquipFunc.GetMountIsShow() then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,0)
        else
            local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
            if not isSafe then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,1)
            else
                SL:TipMessage( SL:GetConfig('cfg_string',487).text,1, NoticeType.NoticeMid )
                return
            end
        end
    end
end

function this:OnAttackClick()
    if not self.isClick then
        return
    end
    self:ResetAttackControl()
    GUI:SetActive(self.view.clickEffect, true)

    local skillDat
    if InfoManager.shapeShiftCardInfo:isShiftMonster() then

        ---@type Skill
        local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, self.ordinaryAttackId)

        if not skill or not skill:IsCDEnough() then
            return
        end
        
        ---@type CheckIsCanSkillDataType
        skillDat = {
            skillId = self.ordinaryAttackId or 0,
            common = true
        }
    else
        ---@type CheckIsCanSkillDataType
        skillDat = {
            skillId = SL:GetMetaValue(EMetaVarGetKey.SKILL_GET_COMMON_ID) or 0,
            common = true
        }
    end
    SL:FGReleaseSkill(skillDat)
end

---@param kmlCtrl UIKmlLuaControl
---@param eventType EUIEventName
function this:OnAttackTouch(kmlCtrl, eventType, args)
    if not self.isClick then
        return
    end
    if eventType == EUIEventName.OnBeginDrag then
        self.pointDownPos = args.position

    elseif eventType == EUIEventName.OnDrag then
        if args.position.y > self.pointDownPos.y then
            GUI:SetActive(self.view.killPerson, true)
            GUI:SetActive(self.view.killMonster, false)
        else
            GUI:SetActive(self.view.killPerson, false)
            GUI:SetActive(self.view.killMonster, true)
        end

    elseif eventType == EUIEventName.OnEndDrag then
        --玩家
        if args.position.y > self.pointDownPos.y then
            if args.position.y - self.pointDownPos.y > 5 then
                self:KillPersonOnClick()
            end
        else
            --怪物
            if self.pointDownPos.y - args.position.y > 5 then
                self:KillMonsterOnClick()
            end
        end
        self:ResetAttackControl()
    elseif eventType == EUIEventName.OnPointerUp then
        self:ResetAttackControl()
    end
end

function this:ResetAttackControl()
    GUI:SetActive(self.view.killPerson, false)
    GUI:SetActive(self.view.killMonster, false)
end

---@param skill Skill
function this:OnSkillCDing(_, skill)
    local commonSkillId
    if InfoManager.shapeShiftCardInfo:isShiftMonster() then
        commonSkillId = self.ordinaryAttackId
    else
        commonSkillId = SL:GetMetaValue(EMetaVarGetKey.SKILL_GET_COMMON_ID) or 0
    end
    if commonSkillId ~= skill.skillId then return end
    self.remainCdTime = skill:LeftCDTime()

    if skill.curCDTime / 1000 ~= self.cdTime then
        self.cdTime = skill.curCDTime / 1000
    end

    if not self.cdTime then return end

    if self.remainCdTime / self.cdTime <= 0.05 then
        GUI:SetCirclebar_startper(self.view.Img_cdTime, 0)
        self.isClick = true
    else
        self.isClick = false
        local startper = self.remainCdTime / self.cdTime * 100
        startper = math.floor(startper)
        GUI:SetCirclebar_startper(self.view.Img_cdTime, startper)
        GUI:SetCirclebar_time(self.view.Img_cdTime, self.remainCdTime)
    end
end

---@param kmlCtrl UIKmlLuaControl
---@param eventType EUIEventName
function this:OnTouchEvent(kmlCtrl, eventType, args)
    if self.curShowType == ESkillType.All then return end

    if eventType == EUIEventName.OnDrag then
        local angleX, angleY, angleZ = GUI:GetLocalEulerAngles(self.view.SkillStruct)

        --if (angleZ ~= 0 and angleZ < 200) or angleZ > 360 then return end
        if angleZ > 0 and angleZ < 270 then
            angleZ = 270
            --return
        end
        logError("1-----------------"..angleZ)
        local nor = args.delta.y
        if Mathf.Abs(args.delta.x) > Mathf.Abs(args.delta.y) then
            nor = args.delta.x
        end

        local mag = Vector2.Magnitude(args.delta)
        if nor < 0 then
            angleZ = angleZ + mag * 0.4
        else
            angleZ = angleZ - mag * 0.4
        end
        if (angleZ > 0 and angleZ < 100) or angleZ > 360 then angleZ = 0 end
        if angleZ > 100 and angleZ < 200 then angleZ = 200 end

        logError(angleZ)
        GUI:SetLocalEulerAngles(self.view.SkillStruct, angleX, angleY, angleZ)

        for _, v in pairs(skillBtns) do
            GUI:SetEulerAngles(v.view.root, 0, 0, 0)
        end
    elseif eventType == EUIEventName.OnEndDrag then
        local angleX, angleY, angleZ = GUI:GetLocalEulerAngles(self.view.SkillStruct)
        local angle = 22.5
        local delta = 0
        local tmp1, tmp2 = math.modf(angleZ / angle)
        if tmp2 < 0.5 then
            angleZ = (tmp1) * angle - delta
        else
            angleZ = (tmp1 + 1) * angle - delta
        end

        if (angleZ > 0 and angleZ < 100) or angleZ > 360 then angleZ = 0 end
        if angleZ > 100 and angleZ <= 200 then angleZ = 216 end
        angleZ = angleZ % 360
        if angleZ < 0 then
            angleZ = angleZ + 360
        end
        if angleZ < 270 and angleZ >0 then
            angleZ = 270
        end 
        GUI:SetLocalEulerAngles(self.view.SkillStruct, angleX, angleY, angleZ)

        for _, v in pairs(skillBtns) do
            GUI:SetEulerAngles(v.view.root, 0, 0, 0)
        end
    end
end

---获取技能形态数据
function this:GetSkillFormDataForm()
    skillFormData = {}
    local skillFormStr = PlayerPrefs.GetString("SkillForm", "")
    if not string.isNullOrEmpty(skillFormStr) then
        local split = string.split(skillFormStr, "|")
        for i, v in pairs(split) do
            local split2 = string.split(v, "#")
            skillFormData[tonumber(split2[1])] = tonumber(split2[2])
        end
    end
    
    local id = SL:MeData_GetId()
    if skillFormData[id] then
        self.skillForm = skillFormData[id]
    else
        self.skillForm = 1
        skillFormData[id] = 1
    end
end

---保存技能形态数据
function this:SaveSkillFormData()
    local id = SL:MeData_GetId()
    -- 如果没有变化，则不保存
    if skillFormData[id] and skillFormData[id] == self.skillForm then
        return
    end
    skillFormData[id] = self.skillForm
    local strList = {}
    local str1 = "|"
    local str2 = "#"
    for k, v in pairs(skillFormData) do
        table.insert(strList, k)
        table.insert(strList, str2)
        table.insert(strList, v)
        table.insert(strList, str1)
    end
    local str = table.concat(strList)
    PlayerPrefs.SetString("SkillForm", str)
    PlayerPrefs.Save()
end

---保存技能形态数据
function this:OnSkillFormSave()
    self.skillFormTimer = self.skillFormTimer + 1
    if self.skillFormTimer > 3 then -- 3秒保存一次
        self:SaveSkillFormData()
        SL:UnSchedule(self.skillFormSaveTimerId)
        self.skillFormSaveTimerId = nil
    end
end

---更新形态技能解锁状态
function this:UpdateFormSkillUnlockState()
    if table.isNullOrEmpty(self.formSkillUnlock) then
        self.formSkillUnlock = {}
    end
    self.unlockFormSkillNum = 0
    -- 检查形态技能是否解锁
    for i, v in pairs(switchFormSkill) do
        local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, v)
        if skill and SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_IS_UNLOCK, v) then
            self.formSkillUnlock[v] = true
            self.unlockFormSkillNum = self.unlockFormSkillNum + 1
        else
            self.formSkillUnlock[v] = nil
        end
        --[[---@type cfg_skill_info_column
        local cfg = SL:GetConfig("cfg_skill_info", v, "skillID")
        if level >= cfg.needLevel[1] then
            
        end]]
    end

    if self.unlockFormSkillNum == nil or self.unlockFormSkillNum == 0 then
        if self.switchFormSkillItem then
            GUI:UIPanel_Close(nil, self.switchFormSkillItem)
            self.switchFormSkillItem = nil
        end
    else
        if self.unlockFormSkillNum == 1 then
            -- 如果只解锁了一个，强制改变形态
            for i, v in pairs(switchFormSkill) do
                if self.formSkillUnlock[v] then
                    self.skillForm = i == 1 and 2 or 1
                    break
                end
            end
            --SL:LogError("形态技能只解锁了一个，检查解锁等级")
        end
        self:UpdateFormSkill()
    end
end

---更新形态技能
function this:UpdateFormSkill()
    self:GetSkillFormDataForm()
    if self.switchFormSkillItem == nil then
        self.switchFormSkillItem = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLSkillBtn/KLSkillBtnItem", self.view.move_root, self, nil, true,
                                                    function(uiPanel)
                                                        GUI:setAnchorPoint(uiPanel.view.root, 2, 2)
                                                        GUI:SetAnchoredPosition(uiPanel.view.root, Vector2(-282, 245))
                                                        GUI:setContentSize(uiPanel.view.root, 60, 60)
                                                        GUI:setScale(uiPanel.view.root, 0.8)
                                                        uiPanel:UpdateUI(switchFormSkill[self.skillForm])
                                                        uiPanel:SetBtnCanClick(self.unlockFormSkillNum == 2)
                                                    end)
    else
        self.switchFormSkillItem:UpdateUI(switchFormSkill[self.skillForm])
        self.switchFormSkillItem:SetBtnCanClick(self.unlockFormSkillNum == 2)
    end
end

---等级改变事件
function this:LUA_EVENT_LEVELCHANGE(_, message)
    if not self.isSummoner or self.unlockFormSkillNum == 2 then
        return
    end
    self:UpdateFormSkillUnlockState()
end

---@param eventData SkillProtos.SkillChangeRes
function this:ResSkillChangeMessage(_, message)
    if not self.isSummoner or self.unlockFormSkillNum == 2 then
        return
    end
    self:UpdateFormSkillUnlockState()
end

---释放形态技能
function this:LUA_EVENT_ME_RELEASE_SKILL(_,message)
    local hasSkill
    -- 匹配形态
    for i, v in pairs(switchFormSkill) do
        if v == message then
            self.skillForm = i == 1 and 2 or 1
            hasSkill = true
            break
        end
    end
    
    -- 没有匹配到形态技能
    if not hasSkill then
        return
    end

    -- 更新新形态UI
    self.switchFormSkillItem:UpdateUI(switchFormSkill[self.skillForm])
    ---@param v KLSkillBtnItem
    for i, v in pairs(skillBtns) do
        v:SwitchForm(self.skillForm)
    end
    
    -- 自动保存
    self.skillFormTimer = 0
    if self.skillFormSaveTimerId == nil then
        self.skillFormSaveTimerId = SL:Schedule(self.skillFormSaveTimerId,0,1,-1, function()
            self:OnSkillFormSave()
        end)
    end
end

function this:Close()
    for _, v in pairs(skillBtns) do
        GUI:UIPanel_Close("dev/ui/MainUI/Item/KLSkillBtn/KLSkillBtnItem", v)
    end

    table.clear(skillBtns)

    self.cdTime = 0
    self.remainCdTime = 0

    if self.co_eff_monster then
        SL:UnSchedule(self.co_eff_monster)
        self.co_eff_monster = nil
    end

    if self.co_eff_person then
        SL:UnSchedule(self.co_eff_person)
        self.co_eff_person = nil
    end
    
    if self.skillFormSaveTimerId then
        SL:UnSchedule(self.skillFormSaveTimerId)
        self.skillFormSaveTimerId = nil
    end
end

return this

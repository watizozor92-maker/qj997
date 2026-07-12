---@class KLSkillBtnItem:UIKmlLuaPanelBase
---@field view KLSkillBtnItemView
---@field baseUI KLMainAttackPanel
local KLSkillBtnItem = class(UIKmlLuaPanelBase)
local this = KLSkillBtnItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.cdTime, "")
end

function this:UpdateUI(skillId, isLock)

    GUI:SetActive(self.view.selectBg, false)
    self.skillId = skillId or 0
    local spriteName = ""

    GUI:setVisible(self.view.lockImg, false)
    GUI:setVisible(self.view.lockText, false)
    GUI:setVisible(self.view.img_add, self.skillId == 0)

    if self.skillId > 0 then
        ---@type Skill
        local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, self.skillId)
        if skill then
            local skillLv = skill and skill.level or 1

            ---@type cfg_skill_info_column
            local tbl = SL:GetConfigMultiKeys('cfg_skill_info', self.skillId, skillLv, 'skillID', 'skillLevel')
            spriteName = string.isNullOrEmpty(tbl.icon) and "" or tbl.icon

            if InfoManager.shapeShiftCardInfo:isShiftMonster() then
                local lockSkill = InfoManager.shapeShiftCardInfo:GetLockShiftSkill()
                if isLock then
                    GUI:setVisible(self.view.lockImg, true)
                    GUI:setVisible(self.view.lockText, true)
                    GUI:Text_setString(self.view.lockText, "Lv." .. lockSkill[skillId] .. "解锁")
                end
            end
        else
            self.skillId = 0
        end
    end

    GUI:SetCirclebar_startper(self.view.Img_cdTime, 0)
    GUI:Text_setString(self.view.cdTime, "")
    GUI:Image_loadTexture(self.view.SkillIcon, spriteName, "Atlas/UIOutSkillIcon.spriteatlas")
    self.formCorrect = true
    GUI:setColor(self.view.SkillIcon, "#FFFFFF")
end

---切换形态
---@param form number 形态( 0 = 魔力形态，1 = 诅咒形态 )
function this:SwitchForm(form)
    if self.skillId < 1 then
        return
    end
    self.form = form
    ---@type cfg_skill_column
    local cfg = SL:GetConfig("cfg_skill", self.skillId)
    -- 按照策划的要求，cfg.assistType = 1 是魔力形态，cfg.assistType = 2和4 是诅咒形态
    self.formCorrect = true
    for i, v in pairs(cfg.assistType) do
        if form == 1 then
            if v == 1 then
                --self.formCorrect = false
                break
            end
        else
            if v == 2 or v == 4 then
                --self.formCorrect = false
                break
            end
        end
    end
    --特殊处理恶魔召唤技能
    local isNoRelease = false 
    if form == 2 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CLOSE_DEMON_HERMIT_SKILL)
        isNoRelease = true
    end
    SL:SetHookNoReleaseSkill(1016012,isNoRelease)
    InfoManager.skillInfo:SetForm(form)
    -- 这里设置技能按钮的状态
    GUI:setColor(self.view.SkillIcon, self.formCorrect and "#FFFFFF" or "#808080")
end

---设置按钮是否可点击
function this:SetBtnCanClick(canClick)
    self.canClick = canClick
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnTouchEvent(self.view.BtnSkill, self, self.OnTouchEvent)
    GUI:AddOnClickEvent(self.view.BtnSkill, self, self.BtnSkillOnClick)
    
    SL:RegisterLUAEvent(Event.Skill_CDing, self.OnSkillCDing, self)

    SL:RegisterLUAEvent(LUA_EVENT_REFRESH_SKILL_BTN_STATE, self.LUA_EVENT_REFRESH_SKILL_BTN_STATE, self)
end

---@param skill Skill
function this:OnSkillCDing(_, skill)
    if self.skillId ~= skill.skillId then
        return
    end

    self.remainCdTime = skill:LeftCDTime()

    if skill.curCDTime / 1000 ~= self.cdTime then
        self.cdTime = skill.curCDTime / 1000
    end

    if not self.cdTime then
        return
    end

    if self.remainCdTime / self.cdTime <= 0.05 then
        GUI:SetCirclebar_startper(self.view.Img_cdTime, 0)
        GUI:Text_setString(self.view.cdTime, "")
    else
        local startper = self.remainCdTime / self.cdTime * 100
        startper = math.floor(startper)
        GUI:SetCirclebar_startper(self.view.Img_cdTime, startper)
        GUI:SetCirclebar_time(self.view.Img_cdTime, self.remainCdTime)
        GUI:Text_setString(self.view.cdTime, string.format("%0.1f", self.remainCdTime))
    end
end

function this:LUA_EVENT_REFRESH_SKILL_BTN_STATE(id,data)
    if data.skillId == self.skillId then
        if self.form == 1 then
            self:SetBtnCanClick(data.isClick)
            -- 这里设置技能按钮的状态
            GUI:setColor(self.view.SkillIcon,data.isClick and "#FFFFFF" or "#808080")
        else
            self:SetBtnCanClick(true)
        end
    end
end

function this:BtnSkillOnClick()
  
    if self.canClick ~= nil and not self.canClick then
        return
    end
    
    if self.skillId == 0 then
        return GUI:UIPanel_Open("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel", nil, nil, ESkillUIShowPage.Setting)
    end

    -- 技能形态不正确
    if not self.formCorrect then
        SL:TipMessage("切换形态可以使用", 1, NoticeType.NoticeLeftBottom)
        return
    end

    ---@type Skill
    local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, self.skillId)

    if not skill or not skill:IsCDEnough() then
        return
    end
    if skill.skillTbl.releaseType == ESkillReleaseType.NeedNoTarget then
        GUI:SetActive(self.view.selectBg, true)

        --SceneTouch.selectSkill = self.skillId
        SL.Scene:SetSelectSkill(self.skillId)
        --RoleManager.me:SelectAttackModel(skill.skillInfoTbl.releaseRange[1])
        SL:SelectAttackModel(skill.skillInfoTbl.releaseRange[1])
    else

        ---@type CheckIsCanSkillDataType
        local skillDat = {
            skillId = self.skillId,
        }
        local meId = SL:GetMetaValue(EMetaVarGetKey.USER_ID)
        if SL.Skill:IsQuickMoving(tonumber(meId)) then
            SL:TipMessage("等待技能释放中", 1, NoticeType.NoticeMid)
            return
        end
        SL:FGReleaseSkill(skillDat)
    end
end
function this:OnTouchEventOnClick()

    if self.canClick ~= nil and not self.canClick then
        return
    end

    if self.skillId == 0 then
        return GUI:UIPanel_Open("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel", nil, nil, ESkillUIShowPage.Setting)
    end

    -- 技能形态不正确
    if not self.formCorrect then
        SL:TipMessage("切换形态可以使用", 1, NoticeType.NoticeLeftBottom)
        return
    end

    ---@type Skill
    local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, self.skillId)

    if not skill or not skill:IsCDEnough() then
        return
    end
    if skill.skillTbl.releaseType == ESkillReleaseType.NeedNoTarget then
        GUI:SetActive(self.view.selectBg, true)

        --SceneTouch.selectSkill = self.skillId
        SL.Scene:SetSelectSkill(self.skillId)
        --RoleManager.me:SelectAttackModel(skill.skillInfoTbl.releaseRange[1])
        SL:SelectAttackModel(skill.skillInfoTbl.releaseRange[1])
    else

        ---@type CheckIsCanSkillDataType
        local skillDat = {
            skillId = self.skillId,
        }
        SL:FGReleaseSkill(skillDat)
    end
end
---@param kmlCtrl UIKmlLuaControl   
---@param eventType EUIEventName
function this:OnTouchEvent(kmlCtrl, eventType, args)
    if eventType == EUIEventName.OnPointerDown then
        if self.schedule then
            SL:UnSchedule(self.schedule)
        end
        if self.skillId > 0 then
            self.schedule = SL:Schedule(self.schedule, 0, 0.2, -1, function()
                return self:OnTouchEventOnClick()
            end)
        end
    end
    if eventType == EUIEventName.OnPointerUp then
        --SL:LogError("技能按钮抬起")
        if self.schedule then
            SL:UnSchedule(self.schedule)
        end
    end
    return self.baseUI:OnTouchEvent(kmlCtrl, eventType, args)
end

function this:Close()
    if self.schedule then
        SL:UnSchedule(self.schedule)
    end
end

return this

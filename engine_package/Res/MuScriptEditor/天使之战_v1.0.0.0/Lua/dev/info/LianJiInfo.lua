---@class LianJiInfo
LianJiInfo = class()
local DataManager = SL:Get_G()['DataManager']
local SkillUseNode = SL:Get_G()['SkillUseNode']
local AutoFightUseSkill = SL:Get_G()['AutoFightUseSkill']
local AutoFightControl = SL:Get_G()['AutoFightControl']
local sagittariusWeaponDurabilityTips
local this = LianJiInfo
local NomalAttackTBL = {
    1004000,
    1304001,
    1304002,
    1020063,
    1014000,
    1011000,
    1012000,
    1015000,
    1016000,
}
function this:ctor()
    
end
function this:Reset()
    self.data = nil;
    self.conf = nil;
    self.auto_state = false
    self.rate_count = 0;
    self.sd_count = 0;
    self.red_state = false;
    self.init = true
    self.jieduan = 1;
    self.next_skill_id = 0
    Global.LianJiOpenState = false
    if self.checkSagittariusWeaponDurabilityTimer then
        SL:UnSchedule(self.checkSagittariusWeaponDurabilityTimer)
        self.checkSagittariusWeaponDurabilityTimer = nil
    end
    SL:SetIsClickReleaseSkillStartAutoHook(false)
end
function this:Init()
    self:Reset()
    self.redCheckStr = "LianJiRedDot"
    self:RegistMessages()
end
function this:RegistMessages()
    SL:AddRedDotConditionFunc(self.redCheckStr, function()
        return self.red_state
    end)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.LianJi_MsgID, self.MsgExchange, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    SL:RegisterLUAEvent(LUA_EVENT_ME_RELEASE_SKILL, self.LUA_EVENT_ME_RELEASE_SKILL, self)
    SL:RegisterLUAEvent(LUA_EVENT_ME_CREATE_SUCCESS, self.SetDataInfo, self)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD, self.SetDataInfo, self)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL, self.SetDataInfo, self)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_UPDATE, self.SetDataInfo, self)
    SL:RegisterTrigger(LUA_TRIGGER_RELEASE_HOOK_SKILL, self.LUA_TRIGGER_RELEASE_HOOK_SKILL, self)
    SL:RegisterTrigger(LUA_TRIGGER_ME_CUSTOM_RELEASESKILL, self.LUA_TRIGGER_ME_CUSTOM_RELEASESKILL, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_ENTER_MAP, self.LUA_EVENT_PLAYER_ENTER_MAP, self)
    SL:RegisterTrigger(LUA_TRIGGER_MODIFY_AUTO_FIGHT_ATTACK_RANGE, self.LUA_TRIGGER_MODIFY_AUTO_FIGHT_ATTACK_RANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_DROP_ITEM_REMOVE, self.LUA_EVENT_DROP_ITEM_REMOVE, self)
    SL:RegisterTrigger(LUA_TRIGGER_CLICK_GROUND_MOVE_ARRIVE_CALLBACK, self.LUA_TRIGGER_CLICK_GROUND_MOVE_ARRIVE_CALLBACK, self)
    SL:RegisterTrigger(LUA_TRIGGER_PAUSE_HOOK, function(_, isImmediateRecoverOnHook)
        if not isImmediateRecoverOnHook then
            if this.startOnHookTimer then
                SL:UnSchedule(this.startOnHookTimer)
            end
            local rid = SL:GetMeData().id
            local isMoving_ = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_MOVE, rid)
            this.waitTime = Time.time
            if not isMoving_ then
                this.waitTime = Time.time + 1
            end
            this.startOnHookTimer = nil
            this.startOnHookTimer = SL:Schedule(this.startOnHookTimer, 0, 0.4, -1, function()
                local state = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
                if state == EAutoOnHookStatus.PauseOnHook and SL:GetMeData() then
                    local rid = SL:GetMeData().id
                    local isMoving = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_MOVE, rid)
                    if not isMoving and this.waitTime < Time.time then
                        SL:StartOnHook(true)
                        if this.startOnHookTimer then
                            SL:UnSchedule(this.startOnHookTimer)
                        end
                        this.startOnHookTimer = nil
                    end
                end
            end)
        else
            SL:StartOnHook(true)
        end
        return true
    end)
end
--【自动战斗】自动战斗中点击地板移动，自动战斗不停止，以玩家点击的坐标为新的自动战斗圆心
function this:ArriveCallBack()
    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    if onHookState == EAutoOnHookStatus.StopOnHook then
        return
    end
    local playerCoord = SL:MeData_GetCoord()
    if not playerCoord then
        return
    end
    SL.AutoFight:SetHookPoint(playerCoord.x,playerCoord.z)
    SL:Log(string.format("自动战斗圆心已更新为: x=%d, z=%d", playerCoord.x, playerCoord.z))
end
function this:LUA_TRIGGER_CLICK_GROUND_MOVE_ARRIVE_CALLBACK()
    return this.ArriveCallBack
end
function this:LUA_TRIGGER_ME_CUSTOM_RELEASESKILL(data)
    local skillinfoTbl = SL:GetConfig("cfg_skill_info", data.skillId, "skillID")
    if Global.CurAG then
        if skillinfoTbl.newConsumeAG > Global.CurAG then
            return false, "技能值不足"
        end
    end
    local role = SL:GetRoleById(data.targetId)
    if (role and role.RoleType == ERoleType.Player) and InfoManager.redNameInfo:IsLimitAttack() then
        return false, "pk值较高，无法攻击"
    end
    local IsCanAttack, tips = self:NaiJiuCondition()
    if not IsCanAttack then
        return IsCanAttack, tips
    end
    return true, ""
end
function this:NaiJiuCondition()
    local equips = SL:GetTotalWearEquips() or {}
    local SecWeaponDurabilityNum = nil
    local canAttack = {}
    local IsCanAttack = true
    local tips = ""
    local careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)
    if careerId == 3 then
        for warId, WarEquips in pairs(equips) do
            canAttack[warId] = true
            if WarEquips[E_ItemSubType_Equip.MainWeapon] or WarEquips[E_ItemSubType_Equip.MainSecWeapon] then
                local itemInfo = nil
                if WarEquips[E_ItemSubType_Equip.MainWeapon] then
                    itemInfo = SL:GetConfig("cfg_item", WarEquips[E_ItemSubType_Equip.MainWeapon].cfgId)
                elseif  WarEquips[E_ItemSubType_Equip.MainSecWeapon] then
                    itemInfo = SL:GetConfig("cfg_item", WarEquips[E_ItemSubType_Equip.MainSecWeapon].cfgId)
                end
                if itemInfo and itemInfo.shape then
                    local modelTbl = SL:GetConfig("cfg_model_charactor", itemInfo.shape[1])
                    if modelTbl.part == 6 or modelTbl.part == 7 then
                        IsCanAttack = false
                        if not WarEquips[E_ItemSubType_Equip.SecWeapon] then
                            canAttack[warId] = false
                            tips = "未穿戴箭袋"
                        else
                            SecWeaponDurabilityNum = EquipFunc.GetDurability(WarEquips[E_ItemSubType_Equip.SecWeapon])
                            local maxDurability = EquipFunc.GetMaxDurability(WarEquips[E_ItemSubType_Equip.SecWeapon])
                            if SecWeaponDurabilityNum <= 0 and maxDurability > 0 then
                                itemInfo = SL:GetConfig("cfg_item", WarEquips[E_ItemSubType_Equip.SecWeapon].cfgId)
                                modelTbl = SL:GetConfig("cfg_model_charactor", itemInfo.shape[1])
                                if modelTbl.part == 114 or modelTbl.part == 115 then
                                    canAttack[warId] = false
                                    tips = "箭袋耐久度不足"
                                else
                                    canAttack[warId] = false
                                    tips = "未穿戴箭袋"
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    for _, v in pairs(canAttack) do
        if v == true then
            IsCanAttack = true
        end
    end
    return IsCanAttack, tips
end
---玩家进入地图
function this:LUA_EVENT_PLAYER_ENTER_MAP()
    local careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)
    if careerId == 3 and SL:HasConfig("cfg_global", 780001) then
        local globalData = string.split(SL:GetConfig("cfg_global", 780001).value, "#")
        local checkInterval = tonumber(globalData[1])
        sagittariusWeaponDurabilityTips = globalData[2]
        self.checkSagittariusWeaponDurabilityTimer = SL:Schedule(self.checkSagittariusWeaponDurabilityTimer, checkInterval, checkInterval, 
                                                                 -1, self.CheckSagittariusWeaponDurability, self)
    end
end
---检查射手武器耐久
function this:CheckSagittariusWeaponDurability()
    local equips = SL:GetTotalWearEquips() or {}
    for warId, WarEquips in pairs(equips) do
        if WarEquips[E_ItemSubType_Equip.MainWeapon] or WarEquips[E_ItemSubType_Equip.MainSecWeapon] then
            local itemInfo = nil
            if WarEquips[E_ItemSubType_Equip.MainWeapon] then
                itemInfo = SL:GetConfig("cfg_item", WarEquips[E_ItemSubType_Equip.MainWeapon].cfgId)
            elseif  WarEquips[E_ItemSubType_Equip.MainSecWeapon] then
                itemInfo = SL:GetConfig("cfg_item", WarEquips[E_ItemSubType_Equip.MainSecWeapon].cfgId)
            end
            if itemInfo and itemInfo.shape then
                local modelTbl = SL:GetConfig("cfg_model_charactor", itemInfo.shape[1])
                if modelTbl.part == 6 or modelTbl.part == 7 then
                    if WarEquips[E_ItemSubType_Equip.SecWeapon] then
                        local durability = EquipFunc.GetDurability(WarEquips[E_ItemSubType_Equip.SecWeapon])
                        local maxDurability = EquipFunc.GetMaxDurability(WarEquips[E_ItemSubType_Equip.SecWeapon])
                        if durability <= 0 and maxDurability > 0 then
                            itemInfo = SL:GetConfig("cfg_item", WarEquips[E_ItemSubType_Equip.SecWeapon].cfgId)
                            modelTbl = SL:GetConfig("cfg_model_charactor", itemInfo.shape[1])
                            if modelTbl.part == 114 or modelTbl.part == 115 then
                                SL:TipMessage(sagittariusWeaponDurabilityTips, 1, NoticeType.NoticeMid)
                            end
                        end
                    end
                end
            end
        end
    end
end
function this:GetSkillRangeCountAndId(skillId,atkRange)
    local skillRange = self:GetSkillRange(skillId)
    local range = skillRange + SL:GetMetaValue(EMetaVarGetKey.GET_KILL_RANGE)
    local startingPoint = AutoFightUseSkill:GetStartingPoint()
    local coord = SL:MeData_GetCoord()
    local list = SL:GetMetaValue(EMetaVarGetKey.GET_ROLE_BY_CONDITION,startingPoint.x,startingPoint.z,range,-1,nil,ERoleType.Monster)
    local id
    local minDistance = math.maxinteger
    local isHaveTaskMonster = false
    if list then
        id = list[1]
        local selectId = SL:GetMetaValue(EMetaVarGetKey.GET_CUR_SELECT_TARGET_ID)
        local role = SL:GetRoleById(selectId)
        if role and not role:IsDie() and role.RoleType == ERoleType.Player then
            return 1,selectId
        end
        if role and not role:IsDie() and table.contains(list,selectId) then
            local isCanGo = SL.Map:CommonMapFindPathIsArrive(role.data.OldCoord)
            if isCanGo then
                return table.count(list),selectId
            else
                local distance = self:PointDistance(coord,role.data.OldCoord)
                if distance <= skillRange then
                    return table.count(list),selectId
                end
            end
        end
        for i, monsterId in pairs(list) do
            if InfoManager.taskOutInfo:IsTaskMonsterById(monsterId) then
                isHaveTaskMonster = true
                if not InfoManager.taskOutInfo:IsTaskMonsterById(id) then
                    minDistance = math.maxinteger
                end
                local monster = SL:GetRoleById(monsterId)
                local distance = self:PointDistance(coord,monster.data.OldCoord)
                if minDistance > distance then
                    id = monsterId
                    minDistance = distance
                end
            else
                if not isHaveTaskMonster then
                    local monster = SL:GetRoleById(monsterId)
                    local distance = self:PointDistance(coord,monster.data.OldCoord)
                    if minDistance > distance then
                        id = monsterId
                        minDistance = distance
                    end
                end
            end
        end
    end
    return table.count(list),id
end
---获取技能释放范围
function this:GetSkillRange(skillId)
    local skillInfoTbl = SL:GetConfig("cfg_skill_info",skillId,"skillID")
    local targetRange = skillInfoTbl.targetRange[1] 
    local moveRange = (skillInfoTbl.changePoint and skillInfoTbl.changePoint[2]) and skillInfoTbl.changePoint[2] or 0
    local range = math.max((skillInfoTbl.releaseRange[1] - moveRange),targetRange)
    return range
end
---物品拾取事件
function this:LUA_EVENT_DROP_ITEM_REMOVE(_,item)
    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    if onHookState ~= EAutoOnHookStatus.OnHooking then
        return
    end
    local data = SL:GetMetaValue(EMetaVarGetKey.GET_MONSTER_DROP_ITEM_LIST)
    local startPoint = AutoFightUseSkill:GetStartingPoint()
    local scope =  SL:GetMetaValue(EMetaVarGetKey.GET_KILL_RANGE)
    local mePos = SL:MeData_GetCoord()
    if self:PointDistance(startPoint,mePos) < scope then
        return 
    end
    for index, drop in pairs(data) do
        if self:PointDistance(startPoint,{x = drop.serverData.x ,z = drop.serverData.y}) > scope then
            return
        end
    end
    if item.serverData.x == mePos.x and item.serverData.y == mePos.z  then
        SL:PathMoveTo(startPoint, nil, nil, nil, nil, false, nil, nil, false)
    end
end
function this:LUA_TRIGGER_MODIFY_AUTO_FIGHT_ATTACK_RANGE()
    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    if onHookState == EAutoOnHookStatus.OnHooking then
        local skillList = DataManager.settingData.skillPriorityList
        local range = SL:GetMetaValue(EMetaVarGetKey.GET_KILL_RANGE)
        for i = 1, #skillList do
            range = math.max(range,self:GetSkillRange(skillList[i]))
        end
        return range
    end
end
function this:MonsterIsInHookRange(monsterId,skillId)
    if monsterId then
        local monster = SL:GetRoleById(monsterId)
        local scope =  SL:GetMetaValue(EMetaVarGetKey.GET_KILL_RANGE) + self:GetSkillRange(skillId)
        local startPoint = AutoFightUseSkill:GetStartingPoint()
        if monster.data.OldCoord == nil or self:PointDistance(startPoint,monster.data.OldCoord) > scope then
            return false
        else
            return true
        end
    end
end
function this:PointDistance(a,b)
    return Mathf.Max( math.abs(a.x - b.x), math.abs(a.z - b.z))
end
---设置释放的连击技数据
function this:SetDataInfo()
    self.data = {}
    local allSkillCopyList = {}
    local allSkillList = SL:GetMetaValue(EMetaVarGetKey.GET_ME_ALL_SKILL)
    if allSkillList then
        for i, v in pairs(allSkillList) do
            if v.skillTbl.group ~= 4 and v.skillTbl.comboType and table.count(v.skillTbl.comboType) > 0 then
                table.insert(allSkillCopyList,v)
            end
        end
        table.sort(allSkillCopyList,function(a, b)
            return a.skillTbl.priorityLevel > b.skillTbl.priorityLevel
        end)
        local index = 0
        for i, v in ipairs(allSkillCopyList) do
            table.insert(self.data,v.skillTbl.id)
            index = index + 1
            if index >= 3 then
                break
            end
        end
        Global.LianJiData = self.data
    end
end
local skillTriggerData = {isReplace=true,skillId = 0,isCanRelease = false}
--释放技能
function this:LUA_TRIGGER_RELEASE_HOOK_SKILL(rid,range,canAtkTargets)
    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    if onHookState == 1 then
        local skill_id
        if self.data then
            if Global.LianJiAutoState == 1 then
                for i = self.jieduan, 3 do
                    if self.data and self.data[i] then
                        local skill_id_ = tonumber(self.data[i])
                        local can_use =  SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_CAN_USE, skill_id_,rid)
                        if can_use then
                            self.next_skill_id_ = skill_id_
                            skill_id = skill_id_
                            break
                        end
                    end
                end
                if skill_id == nil then
                    for i = 1, 3 do
                        if self.data and self.data[i] then
                            local skill_id_ = tonumber(self.data[i])
                            local can_use = SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_CAN_USE, skill_id_,rid)
                            if can_use then
                                self.next_skill_id_ = skill_id_
                                skill_id = skill_id_
                                break
                            end
                        end
                    end
                end
                self.next_skill_id = skill_id
            end
        end
        if skill_id then
            return {isReplace=true,skillId=tonumber(skill_id),isCanRelease=true};
        else
            local SkillData = self:GetAutoReleaseSkill(rid,true,false)
           return SkillData
        end
    end
end
---@param isAutoSetTarget  boolean 是否自动设置目标
function this:GetAutoReleaseSkill(rid,isAutoSetTarget,NoUseHookRangeAttack)
    local isCanRelease = false
    local range = AutoFightUseSkill:GetAttackRange()
    local skillList = DataManager.settingData.skillPriorityList
    local commonSkillId = SL:GetMetaValue(EMetaVarGetKey.SKILL_GET_COMMON_ID)
    local maxpriorityLevelId = -1
    local maxpriority = -1
    local groupSave = DataManager.settingData.groupSave
    local monsterId
    local isOnlyGroupSkill = self:IsOnlyGroupSkill(skillList,commonSkillId)
    local IshasBuffSkill = self:IsCanReleaseBuffSkill()
    local IshasSummonSkill = self:IsCanReleaseSummonSkill()
    if not IshasBuffSkill and not IshasSummonSkill then
        for i = 1, #groupSave do
            local skillId = groupSave[i]
            local atkCount,temMonsterId = self:GetSkillRangeCountAndId(skillId,range)
            temMonsterId = temMonsterId or rid
            local _releaseSkill = SL:GetMetaValue(EMetaVarGetKey.LEARNED_SKILLS)[skillId]
            if _releaseSkill and (isOnlyGroupSkill or atkCount > 1 ) and commonSkillId ~= skillId then
                if _releaseSkill.skillTbl.assistType[1] == SkillAssistTypeEx.Group then
                    local isCanUse,error = SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_CAN_USE, skillId, temMonsterId)
                    if isCanUse then
                        if maxpriority <= _releaseSkill.skillTbl.priorityLevel then
                            AutoFightControl.releaseSkillError = ESkillReleaseError.None
                            maxpriority = _releaseSkill.skillTbl.priorityLevel
                            maxpriorityLevelId = skillId
                            isCanRelease = true
                            monsterId = temMonsterId
                        end
                    else
                        if error and error == ESkillReleaseError.SkillRangeNotEnough and isStatAutoPoint and (self:MonsterIsInHookRange(temMonsterId,skillId) or NoUseHookRangeAttack) then
                            if maxpriority <= _releaseSkill.skillTbl.priorityLevel then
                                maxpriority = _releaseSkill.skillTbl.priorityLevel
                                maxpriorityLevelId = skillId
                                isCanRelease = false
                                AutoFightControl.releaseSkillError = error
                                monsterId = temMonsterId
                            end
                        end
                    end
                end
            end
        end
    end
    if maxpriorityLevelId ~= -1 then
        if isAutoSetTarget then
            self:SetSelectTargetId(monsterId)
        end
        return { isReplace = true, skillId = maxpriorityLevelId, isCanRelease = isCanRelease }
    end
    ---除群攻技能之外的技能
    for i = 1, #skillList do
        local skillId = skillList[i]
        local _releaseSkill = SL:GetMetaValue(EMetaVarGetKey.LEARNED_SKILLS)[skillId]
        local atkCount,temMonsterId = self:GetSkillRangeCountAndId(skillId,range)
        temMonsterId = temMonsterId or rid
        if _releaseSkill and (commonSkillId ~= skillId)  then
            -- 召唤技能
            if _releaseSkill.skillTbl.assistType[1] == SkillAssistTypeEx.Common and _releaseSkill.skillTbl.assistType[2] == SubSkillAssistTypeEx.Summon then
                if SL:IsCanUseSummonSkill(skillId) then
                    local useTarget = rid
                    local isCanUse,_ = SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_CAN_USE, skillId, useTarget)
                    if isCanUse and maxpriority <= _releaseSkill.skillTbl.priorityLevel then
                        maxpriority = _releaseSkill.skillTbl.priorityLevel
                        maxpriorityLevelId = skillId
                        isCanRelease = true
                        monsterId = nil
                        --【关键修复：释放召唤前清空选中怪物目标】
                        SL:SetSelectTargetId(0)
                        AutoFightUseSkill.TargetId = 0
                    end
                else
                    isCanRelease = false
                    maxpriorityLevelId = -1
                end
            -- Buff增益技能
            elseif _releaseSkill.skillTbl.assistType[1] == SkillAssistTypeEx.Common and _releaseSkill.skillTbl.assistType[2] == SubSkillAssistTypeEx.Buff then
                if SL:IsCanUseBuffSkill(skillId) then
                    local useTarget = rid
                    local isCanUse,_ = SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_CAN_USE, skillId, useTarget)
                    if isCanUse and maxpriority <= _releaseSkill.skillTbl.priorityLevel then
                        maxpriority = _releaseSkill.skillTbl.priorityLevel
                        maxpriorityLevelId = skillId
                        isCanRelease = true
                        monsterId = nil
                        --【关键修复：释放Buff前清空选中怪物目标】
                        SL:SetSelectTargetId(0)
                        AutoFightUseSkill.TargetId = 0
                    end
                else
                    isCanRelease = false
                    maxpriorityLevelId = -1
                end
            else
                if _releaseSkill.skillTbl.assistType[1] ~= SkillAssistTypeEx.Group  then
                    local isCanUse,error = SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_CAN_USE, skillId,temMonsterId)
                    if isCanUse then
                        if skillId == 1300005 then
                            local teamlist = SL:GetMetaValue(EMetaVarGetKey.TEAM_MEMBER_LIST)
                            if teamlist~=nil then
                                local teamhp = 1.0
                                local teammaxHp = 1.0
                                local teamprecent = 1.0
                                local isCanUse1300005 = false
                                for i=1,#teamlist do
                                    teamhp = teamlist[i].hp
                                    teammaxHp = teamlist[i].maxHp
                                    teamprecent = teamhp / teammaxHp
                                    if teamprecent <= 0.9 then
                                        isCanUse1300005 = true
                                    end
                                end
                                if isCanUse1300005 then
                                    if maxpriority <= _releaseSkill.skillTbl.priorityLevel then
                                        maxpriority = _releaseSkill.skillTbl.priorityLevel
                                        maxpriorityLevelId = skillId
                                        isCanRelease = true
                                        monsterId = nil
                                        --【关键修复：治疗技能释放前清空目标】
                                        SL:SetSelectTargetId(0)
                                        AutoFightUseSkill.TargetId = 0
                                    end
                                end
                            else
                                local hp = SL:GetMetaValue("HP")
                                local maxHp = SL:GetMetaValue("MAXHP")
                                local precent = hp / maxHp
                                if precent <= 0.9 then
                                    if maxpriority <= _releaseSkill.skillTbl.priorityLevel then
                                        maxpriority = _releaseSkill.skillTbl.priorityLevel
                                        maxpriorityLevelId = skillId
                                        isCanRelease = true
                                        monsterId = nil
                                        --【关键修复：治疗技能释放前清空目标】
                                        SL:SetSelectTargetId(0)
                                        AutoFightUseSkill.TargetId = 0
                                    end
                                end
                            end
                        else
                            if maxpriority <= _releaseSkill.skillTbl.priorityLevel then
                                AutoFightControl.releaseSkillError = ESkillReleaseError.None
                                maxpriority = _releaseSkill.skillTbl.priorityLevel
                                maxpriorityLevelId = skillId
                                isCanRelease = true
                                monsterId = temMonsterId
                            end
                        end
                    else
                        if error and error == ESkillReleaseError.SkillRangeNotEnough and isStatAutoPoint and (self:MonsterIsInHookRange(temMonsterId,skillId) or NoUseHookRangeAttack) then
                            if maxpriority <=  _releaseSkill.skillTbl.priorityLevel then
                                AutoFightControl.releaseSkillError = error
                                maxpriority = _releaseSkill.skillTbl.priorityLevel
                                maxpriorityLevelId = skillId
                                isCanRelease = false
                                monsterId = temMonsterId
                            end
                        end
                    end
                end
            end
        end
    end
    -- 辅助技能monsterId=nil，永远跳过设置怪物目标，杜绝寻路
    if maxpriorityLevelId ~= -1 then
        if isAutoSetTarget and monsterId ~= nil then
            self:SetSelectTargetId(monsterId)
        end
        return { isReplace = true, skillId = maxpriorityLevelId, isCanRelease = isCanRelease }
    else
        ---最后检查普攻技能
        local skillId = commonSkillId
        local _releaseSkill = SL:GetMetaValue(EMetaVarGetKey.LEARNED_SKILLS)[skillId]
        local atkCount,temMonsterId = self:GetSkillRangeCountAndId(skillId,range)
        temMonsterId = temMonsterId or rid
        local isCanUse,error = SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_CAN_USE, skillId,temMonsterId)
        local setIsCanUseCommonSkill = not isNotAttackPoint
        if isCanUse and setIsCanUseCommonSkill then
            if maxpriority <= _releaseSkill.skillTbl.priorityLevel then
                AutoFightControl.releaseSkillError = ESkillReleaseError.None
                maxpriority = _releaseSkill.skillTbl.priorityLevel
                maxpriorityLevelId = skillId
                isCanRelease = true
                monsterId = temMonsterId
            end
        else
            if not setIsCanUseCommonSkill then
                skillId = -1
            end
            if error and error == ESkillReleaseError.SkillRangeNotEnough and isStatAutoPoint and (self:MonsterIsInHookRange(temMonsterId,skillId) or NoUseHookRangeAttack) then
                if maxpriority <=  _releaseSkill.skillTbl.priorityLevel then
                    AutoFightControl.releaseSkillError = error
                    maxpriority = _releaseSkill.skillTbl.priorityLevel
                    maxpriorityLevelId = skillId
                    isCanRelease = false
                    monsterId = temMonsterId
                end
            end
        end
        if maxpriorityLevelId ~= -1 then
            if isAutoSetTarget and monsterId ~= nil then
                self:SetSelectTargetId(monsterId)
            end
            return { isReplace = true, skillId = maxpriorityLevelId, isCanRelease = isCanRelease }
        end
    end
    return skillTriggerData
end
---没有单体技能则判定为只有群体技能
function this:IsOnlyGroupSkill(skillList,commonSkillId)
    for i = 1, #skillList do
        local skillId = skillList[i]
        local _releaseSkill = SL:GetMetaValue(EMetaVarGetKey.LEARNED_SKILLS)[skillId]
        if _releaseSkill and skillId ~= commonSkillId then
            if  _releaseSkill.skillTbl.assistType[1] == SkillAssistTypeEx.Single then
                return false
            end
        end
    end
    return true
end
function this:IsCanReleaseBuffSkill()
    local skillList = DataManager.settingData.buffSave
    for i = 1, #skillList do
        local skillId = skillList[i]
        if SL:IsCanUseBuffSkill(skillId) then
            return true
        end
    end
    return false
end
function this:IsCanReleaseSummonSkill()
    local skillList = DataManager.settingData.summonSave
    for i = 1, #skillList do
        local skillId = skillList[i]
        if SL:IsCanUseSummonSkill(skillId) then
            return true
        end
    end
    return false
end
function this:SetSelectTargetId(id)
    if id == AutoFightUseSkill.TargetId then
        return
    end
    SL:SetSelectTargetId(id)
    AutoFightUseSkill.TargetId = id
end
function this:SetSkillByGroup()
    return DataManager.settingData:SetSkillByGroup()
end
function this:LUA_EVENT_ME_RELEASE_SKILL(id, skillId)
    if self.next_skill_id == skillId then
        self.jieduan = self.jieduan + 1
        if self.jieduan > 3 then
            self.jieduan = 1
        end
    else
        self.jieduan = 1
    end
end
function this:LUA_EVENT_BAG_CHANGE_AFTER(_, itemList)
    if itemList and not self.init then
        self:RefreshRed()
    end
end
function this:MsgExchange(_, msg_data)
    local _data = GUIUtil.tblkeytonumber(msg_data)
    if _data == nil or _data[1] == nil then
        return
    end
    if _data[1] == -1 then
        self.conf = (_data[2] or self.conf)
    elseif _data[1] == 0 then
        self.init = false
        self.conf = (_data[2] or self.conf)
        self.rate_count = _data.rate_count;
        self.sd_count = _data.sd_count;
        self.auto_state = _data.auto_state
        Global.LianJiOpenState = true
        Global.LianJiAutoState = self.auto_state
        SL:onLUAEvent(LUA_EVENT_LIANJI_AUTO_DATACHANGE)
        SL:onLUAEvent(LUA_EVENT_LIANJI_DATACHANGE2)
    elseif _data[1] == 1 then
        SL:onLUAEvent(LUA_EVENT_LIANJI_DATACHANGE2)
    elseif _data[1] == 2 then
        self.auto_state = _data[2]
        Global.LianJiAutoState = self.auto_state
        SL:onLUAEvent(LUA_EVENT_LIANJI_AUTO_DATACHANGE)
    elseif _data[1] == 3 then
        self.rate_count = _data[2]
    elseif _data[1] == 4 then
        self.sd_count = _data[2]
    elseif _data[1] == 5 then
        return
    elseif _data[1] == 6 then
        Global.LianJiOpenState = false
        SL:onLUAEvent(LUA_EVENT_LIANJI_AUTO_DATACHANGE)
    end
    self:RefreshRed()
    SL:onLUAEvent(LUA_EVENT_LIANJI_DATACHANGE)
    SL:onLUAEvent(LUA_EVENT_LIANJI_OPEN)
end
function this:RefreshRed()
    if self.conf == nil or self.data == nil then
        return
    end
    local red_state = self:getRed()
    if self.red_state ~= red_state then
        self.red_state = red_state
        SL:RefreshPanelALLRedStateKmlByCondition(self.redCheckStr)
    end
end
function this:getRed()
    if self.conf == nil then
        return false
    end
    if GUIUtil.CheckItem({ { self.conf.addLianJi.itemName, 1 } }) and self.rate_count < self.conf.addLianJi.max_count then
        return true
    end
    if GUIUtil.CheckItem({ { self.conf.addSD.itemName, 1 } }) and self.sd_count < self.conf.addSD.max_count then
        return true
    end
    return false;
end
function this:GetRedState()
    return self.red_state;
end
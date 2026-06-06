---@class SkillInfo
SkillInfo = class()
local this = SkillInfo

function this:ctor()

end


function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.hideHeadPlayerList = {}
    if SL:HasConfigTwoKeys("cfg_skill_info",1016016,1,"skillID","skillLevel") then
        ---@type cfg_skill_info_column
        local tbl = SL:GetConfigMultiKeys("cfg_skill_info",1016016,1,"skillID","skillLevel")
        self.effectId = 60000019
        self.buffId = tbl.targetBuffID[1] and tbl.targetBuffID[1][1] or nil
    end
    if SL:HasConfigTwoKeys("cfg_skill_info",1016012,1,"skillID","skillLevel") then
        ---@type cfg_skill_info_column
        local tbl = SL:GetConfigMultiKeys("cfg_skill_info",1016012,1,"skillID","skillLevel")
        self.costMp = tbl.costMp
    end
    
    if SL:HasConfig("cfg_global",550002) then
        self.piliSkillParm = ToolFunc.AnalysisStr(SL:GetConfig("cfg_global",550002).value)
    end
    
    self.showSkillPetModelList = {}
    self.playerReleaseSkill = {}
    self.form = 1
    self.InitBuffList = {}

    self.atkSpeedList = {}
    self.magicAtkSpeedList = {}

    self.maxAtkSpeed = 0.125    --一秒8刀
    self.skillIdToName = {}
    local behaviour = SL:GetConfigTable("cfg_behaviour")
    ---@param v cfg_behaviour_column
    for _, v in pairs(behaviour) do
        if v.skill[1] and v.anim[1] then
            local split = string.split(v.anim[1], "@")
            if split[2] then
                self.skillIdToName[v.skill[1]] = split[2]
            else
                self.skillIdToName[v.skill[1]] = v.anim[1]
            end
        end
    end
    self.skillAnimTime = {}
    SL:SetGlobalAutoFightTimeInterval(0.1)
end



function this:RegistMessages()
    SL:RegisterLUAEvent(LUA_EVENT_CREATE_PLAYER_SUCCESS, self.LUA_EVENT_CREATE_PLAYER_SUCCESS,self)
    SL:RegisterLUAEvent(LUA_EVENT_BUFFUPDATE, self.LUA_EVENT_BUFFUPDATE,self)
    SL:RegisterLUAEvent(LUA_EVENT_BUFFCHANHE, self.LUA_EVENT_BUFFCHANHE,self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_RECYCLE, self.LUA_EVENT_ROLE_RECYCLE,self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_ACTION_CHANGE, self.LUA_EVENT_ROLE_ACTION_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_MPCHANGE, self.LUA_EVENT_MPCHANGE, self)--主角蓝量改变事件
    SL:RegisterLUAEvent(LUA_EVENT_ME_RELEASE_SKILL, self.LUA_EVENT_ME_RELEASE_SKILL, self)
    SL:RegisterLUAEvent(LUA_EVENT_FIGHT_RESULT, self.LUA_EVENT_FIGHT_RESULT, self)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE, self.LUA_EVENT_PLAYER_MAPPOS_CHANGE, self)
    if LUA_EVENT_MODIFY_SKILLEFFECT_BINDWEAPON_DATA then
        SL:RegisterLUAEvent(LUA_EVENT_MODIFY_SKILLEFFECT_BINDWEAPON_DATA, self.LUA_EVENT_MODIFY_SKILLEFFECT_BINDWEAPON_DATA, self)
    end



    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BUFFER_MOVE_TEAMER,self.RES_BUFFER_MOVE_TEAMER,self)
    
    
    SL:RegisterTrigger(LUA_EVENT_TRADE_HP_IS_SHOW, this.LUA_EVENT_TRADE_HP_IS_SHOW,self)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PLAYER_ENTER_VIEW_INFO, self.RES_PLAYER_ENTER_VIEW_INFO, self)

    SL:RegisterTrigger(LUA_TRIGGER_SKILL_CUSTOM_PLAYER_ANI_PLAY_TIME, self.LUA_TRIGGER_SKILL_CUSTOM_PLAYER_ANI_PLAY_TIME, self)
    SL:RegisterTrigger(LUA_TRIGGER_SKILL_CUSTOM_PLAYER_ANI_CROSS_FADE_TIME, self.LUA_TRIGGER_SKILL_CUSTOM_PLAYER_ANI_CROSS_FADE_TIME, self)
    SL:RegisterTrigger(LUA_TRIGGER_MODIFY_SKILL_EFFECT_PLAY_TIME, self.LUA_TRIGGER_MODIFY_SKILL_EFFECT_PLAY_TIME, self)
    SL:RegisterTrigger(LUA_TRIGGER_IS_ADD_HOOKSKILL, self.LUA_TRIGGER_IS_ADD_HOOKSKILL, self)
    SL:RegisterTrigger(LUA_TRIGGER_CHECK_AUTO_FIGHT_ROLE_IS_BE_ATTACK, self.LUA_TRIGGER_CHECK_AUTO_FIGHT_ROLE_IS_BE_ATTACK, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ATK_SPEED_ATTR, self.RES_ATK_SPEED_ATTR, self)
end

function this:LUA_TRIGGER_CHECK_AUTO_FIGHT_ROLE_IS_BE_ATTACK(roleData,skillId)
    if skillId and skillId == 1200018 then--小挪移可以在和平模式下放，相当于是给目标放buff，不算攻击
        return true
    end
end

function this:RES_BUFFER_MOVE_TEAMER(id,message)
    if not message then
        return
    end
    if not message.rid then
        return
    end
    local role = SL:GetRoleById(tonumber(message.rid))
    if role then
        ---@type cfg_buff_column
        local buffCfg = SL:GetConfig("cfg_buff",tonumber(message.buffId))
        if #buffCfg.buffValue>=1 then
            role:StopMove(true, true)
            role.isQuickMoving = true
            role:ShowGameObject(false,false)
            SL:ScheduleOnce(buffCfg.buffValue[1][1],function()
                role.isQuickMoving = false
                role:ShowGameObject(false,false)
            end)
        end
    end
end

---角色创建成功事件
function this:LUA_TRIGGER_IS_ADD_HOOKSKILL(skillId)
    if SL:GetConfig("cfg_skill",skillId) then
        ---@type cfg_skill_column
        local skill = SL:GetConfig("cfg_skill",skillId)
        if skill.set and skill.set ~= 0 then
            return false
        end 
    end
    return true
end

---角色创建成功事件
function this:LUA_EVENT_CREATE_PLAYER_SUCCESS(id,rid)
    local role = SL:GetRoleById(rid)
    if role and (role.RoleType == ERoleType.Player or role.RoleType == ERoleType.Me) then
        local isHide = self.hideHeadPlayerList[role.data.id] and true or false
        SL:ShowOrHideHeadHp(rid,not isHide)
        SL:SetRoleModelIsShow(rid,not isHide)
        SL:SetIsRoleModelShowSettingControl(rid,not isHide)
    end
end

---血条显示
function this:LUA_EVENT_TRADE_HP_IS_SHOW(rid,isShow)
    InfoManager.roleOtherInfo:LUA_EVENT_TRADE_HP_IS_SHOW(rid, isShow)
    if self.buffId then
        local isHave = SL:GetMetaValue(EMetaVarGetKey.ACTOR_HAS_ONE_BUFF_BY_CFG_ID,rid,self.buffId)
        return isHave and false or isShow
    end
    return isShow
end 

---添加或更新buff
function this:LUA_EVENT_BUFFUPDATE(id,message)
    if self.buffId and message.updateType ~= 1 and message.buff.cfgId == self.buffId and self.effectId then
        self.hideHeadPlayerList[message.roleId] = message.roleId
        SL:SetMetaValue(EMetaVarSetKey.SET_EFFECT_ON_ROLE, message.roleId, tonumber(self.effectId), nil, true, EPlayEffectOverType.Loop)
        SL:ShowOrHideHeadHp(message.roleId,false)
        SL:SetRoleModelIsShow(message.roleId,false)
        SL:SetIsRoleModelShowSettingControl(message.roleId,false)
    end
end

---移除buff
function this:LUA_EVENT_BUFFCHANHE(id,message)
    -----由于playerInfo界面初始化时比较慢 先保存一下初始数据
    if  message.updateType == 0 or  message.updateType == 2 then
        self.InitBuffList[message.buff.cfgId] = table.copy(message)
    else
        self.InitBuffList[message.buff.cfgId] = nil
    end
    if self.buffId and message.updateType == 1 and message.buff.cfgId == self.buffId and self.effectId then
        self.hideHeadPlayerList[message.roleId] = nil
        SL:SetMetaValue(EMetaVarSetKey.RECYCLE_EFFECT_ON_ROLE,message.roleId, tonumber(self.effectId))
        SL:SetRoleModelIsShow(message.roleId,true)
        SL:ShowOrHideHeadHp(message.roleId,true)
        SL:SetIsRoleModelShowSettingControl(message.roleId,true)
    end
end 

---移除玩家
function this:LUA_EVENT_ROLE_RECYCLE(id,rid)
    if self.showSkillPetModelList and self.showSkillPetModelList[rid] then
        SL:RecycleCreateMonster(self.showSkillPetModelList[rid])
        self.showSkillPetModelList[rid] = nil
        local rid_ = SL:GetMetaValue("MAIN_ACTOR_ID")
        if rid_ == rid then
            self:SetHookNoReleaseSkill(1016012,false)
        end
    end
end

---@param role Role
function this:LUA_EVENT_ROLE_ACTION_CHANGE(id,role)
    if self.showSkillPetModelList[role.data.id] then
        if (role.data.action == EAction.Attack or role.data.action == EAction.Attack2 or role.data.action == EAction.AttackTrack) then
            SL:SetSelectRoleSkillId(self.showSkillPetModelList[role.data.id],self.playerReleaseSkill[role.data.id])
            SL:SetCreateRoleAction(self.showSkillPetModelList[role.data.id],1,5,1)
            self.curReleaseSkillId = nil
        else
            SL:SetCreateRoleAction(self.showSkillPetModelList[role.data.id],0,1,1)
            SL:SetSelectRoleSkillId(self.showSkillPetModelList[role.data.id],0)
        end
    end
end

function this:RES_PLAYER_ENTER_VIEW_INFO(_id, message)
    if not message.demonHermitSkill then
        return
    end
    local rid = tonumber(message.rid)
    local num = tonumber(message.demonHermitSkill)
    if not message.demonHermitSkill or num == 0 then
        if self.showSkillPetModelList and self.showSkillPetModelList[rid] then
            SL:RecycleCreateMonster(self.showSkillPetModelList[rid])
            self.showSkillPetModelList[rid] = nil
            local rid_ = SL:GetMetaValue("MAIN_ACTOR_ID")
            if tonumber(rid_) == rid then
                self:SetHookNoReleaseSkill(1016012,false)
            end
        end
    elseif self.showSkillPetModelList and not self.showSkillPetModelList[rid] then
        local monsterid = rid.."model"
        SL:CreateMonster(monsterid,60000601)
        SL:SetRoleBindToRoleModeNode(rid,monsterid,0,5,0,0,250,0)
        SL:ShowOrHideHead(monsterid, false)
        self.showSkillPetModelList[rid] = monsterid
        local rid_ = SL:GetMetaValue("MAIN_ACTOR_ID")
        if tonumber(rid_) == rid then
            self:SetHookNoReleaseSkill(1016012,true)
        end
    end
end

function this:LUA_EVENT_MPCHANGE()
    local mp = SL:GetMetaValue("MP")
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    if self.costMp and self.costMp > mp then
        if self.showSkillPetModelList and self.showSkillPetModelList[rid] and SL:MeData_GetCareer().baseCareer == 6  then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CLOSE_DEMON_HERMIT_SKILL)
            self:SetHookNoReleaseSkill(1016012,false)
        end
    end
end

function this:LUA_EVENT_ME_RELEASE_SKILL(id,skillId)
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    self.playerReleaseSkill[tonumber(rid)] = skillId
end

function this:IsHaveSkillPetModel()
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    return self.showSkillPetModelList[tonumber(rid)] and true or false
end

function this:SetHookNoReleaseSkill(skillId,isNoRelease)
    if self.form == 1 then
        SL:SetHookNoReleaseSkill(skillId,isNoRelease)
    end
    SL:onLUAEvent(LUA_EVENT_REFRESH_SKILL_BTN_STATE,{isClick = not isNoRelease,skillId = skillId})
end

function this:LUA_EVENT_FIGHT_RESULT(id,message)
    if message then
        self.playerReleaseSkill[message.attackerId] = message.skillId   

        local meId = tonumber(SL:GetMetaValue(EMetaVarGetKey.USER_ID))
        for _, item in pairs(message.target) do
            if item.targetId == meId then
                if item.hp <= 0 then
                    local attackRole = SL:GetRoleById(message.attackerId)
                    if attackRole and attackRole:IsMonster() then
                        self.killMeMonsterId = attackRole.data.monsterTbl.id
                    end
                end
            end
        end
    end
end

function this:LUA_EVENT_CHANGESCENE(id,message)
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    rid = tonumber(rid)
    if self.showSkillPetModelList and self.showSkillPetModelList[rid] then
        SL:RecycleCreateMonster(self.showSkillPetModelList[rid])
        self.showSkillPetModelList[rid] = nil
        self:SetHookNoReleaseSkill(1016012,false)
    end
end

function this:LUA_EVENT_PLAYER_MAPPOS_CHANGE(id)
    local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
    if isSafe and SL:MeData_GetCareer().baseCareer == 6  then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CLOSE_DEMON_HERMIT_SKILL)
    end
end

function this:LUA_EVENT_MODIFY_SKILLEFFECT_BINDWEAPON_DATA(id,component)
    if self.piliSkillParm and component then
        component.radius = self.piliSkillParm[1][1]
        component.center = Vector3.New(self.piliSkillParm[2][1],self.piliSkillParm[2][2],self.piliSkillParm[2][3])
        component.RotateOnceInAngle = self.piliSkillParm[3][1]
        component.startRevolutionPos = self.piliSkillParm[4][1]
        component.startSelfRotation = self.piliSkillParm[5][1]
        component.duration = self.piliSkillParm[6][1]
        component.revolutionSpeed = self.piliSkillParm[7][1]
        component.framePerUpdate = self.piliSkillParm[8][1]
    end
   
end

function this:SetForm(form)
    self.form = form
end

function this:Reset()
    self.InitBuffList = {}
    for i, rid in pairs(self.showSkillPetModelList) do
        SL:RecycleCreateMonster(rid)
    end
    table.clear(self.showSkillPetModelList)
    self:SetHookNoReleaseSkill(1016012,false)
    table.clear(self.hideHeadPlayerList)
    table.clear(self.playerReleaseSkill)
    self.killMeMonsterId = nil
end 

function this:ResetKillMeMonsterId()
    self.killMeMonsterId = nil
end

function this:LUA_TRIGGER_SKILL_CUSTOM_PLAYER_ANI_PLAY_TIME(role, skill)
    if role:IsMe() then
        ---@type cfg_skill_info_column
        local skillInfo = skill.skillInfoTbl
        local cd = skillInfo.skillCd
        local atkSpeed = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, 500126)
        local magicAtkSpeed = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, 500125)
        local result = 1 + atkSpeed * skillInfo.speedSkillCd * 0.0001 + magicAtkSpeed * skillInfo.magicSpeedSkillCd * 0.0001
        local realCd = (cd / 1000) / result
        if self.skillIdToName[skillInfo.skillID] then
            local animLength, speed, time = SL:GetAnimatorStateLength(role.data.id, self.skillIdToName[skillInfo.skillID])
            local animTime
            local checkTime = time ~= 0 and time or animLength
            if realCd < checkTime then
                if realCd < self.maxAtkSpeed then
                    animTime =  self.maxAtkSpeed
                else
                    animTime =  realCd
                end
            end
            -- logError("初始CD: ".. cd .."  比例: "..result)
            --log(tostring(self.skillIdToName[skillInfo.skillID]).." 技能播放 CD: ".. realCd .. "  Lengthen: ".. animLength .."  Time: "..time.."   "..tostring(animTime))
            if animTime then
                if not self.skillAnimTime[role.data.id] then
                    self.skillAnimTime[role.data.id] = {}
                end
                self.skillAnimTime[role.data.id][skillInfo.skillID] = animTime
            end
            return animTime, nil, self.skillIdToName[skillInfo.skillID]
        end
    elseif role:IsPlayer() then
        ---@type cfg_skill_info_column
        local skillInfo = skill.skillInfoTbl
        local cd = skillInfo.skillCd
        local atkSpeed, magicAtkSpeed = self:GetAtkSpeed(role.data.id)
        if atkSpeed and magicAtkSpeed then
            local result = 1 + atkSpeed * skillInfo.speedSkillCd * 0.0001 + magicAtkSpeed * skillInfo.magicSpeedSkillCd * 0.0001
            local realCd = (cd / 1000) / result
            if self.skillIdToName[skillInfo.skillID] then
                local animLength, speed, time = SL:GetAnimatorStateLength(role.data.id, self.skillIdToName[skillInfo.skillID])
                local animTime
                local checkTime = time ~= 0 and time or animLength
                if realCd < checkTime then
                    if realCd < self.maxAtkSpeed then
                        animTime =  self.maxAtkSpeed
                    else
                        animTime =  realCd
                    end
                end
                if animTime then
                    if not self.skillAnimTime[role.data.id] then
                        self.skillAnimTime[role.data.id] = {}
                    end
                    self.skillAnimTime[role.data.id][skillInfo.skillID] = animTime
                end
                return animTime,  nil, self.skillIdToName[skillInfo.skillID]
            end
        end
    end
end

function this:LUA_TRIGGER_SKILL_CUSTOM_PLAYER_ANI_CROSS_FADE_TIME(role, anim, skill)
    if skill and role and self.skillAnimTime[role.data.id] and self.skillAnimTime[role.data.id][skill.skillInfoTbl.skillID] then
        return self.skillAnimTime[role.data.id][skill.skillInfoTbl.skillID] >= 0.2 and 0.2 or self.skillAnimTime[role.data.id][skill.skillInfoTbl.skillID]
    end
end

function this:LUA_TRIGGER_MODIFY_SKILL_EFFECT_PLAY_TIME(skillEffect)
    local cfgId = skillEffect.skillcontainer.cfgId
    local skillCfg = SL:GetConfig("cfg_skill_info", cfgId, "skillID")
    if skillCfg.CanUseSkillEffectPlayTime and skillCfg.CanUseSkillEffectPlayTime == 1 then
        return skillEffect.playTime
    end
end

--响应玩家攻速属性
function this:RES_ATK_SPEED_ATTR(_, message)
    self.atkSpeedList[message.rid] = message.attr["500126"]
    self.magicAtkSpeedList[message.rid] = message.attr["500125"]
end

function this:GetAtkSpeed(rid)
    local playerId = tostring(rid)
    return self.atkSpeedList[playerId], self.magicAtkSpeedList[playerId]
end

-- 计算buff值
function this:GetBuffValue(buffId,layers)
    
    
    local config = SL:GetConfig("cfg_buff_Calculation", buffId)
    if table.isNullOrEmpty(config) then
        return 0
    end
    
    local mylevel = SL:GetMetaValue("LEVEL")
    local level = config.level
    local num = level * mylevel
    local way = config.att
    local baseValue = 0
    for _, v in pairs(way) do
        local data = 0
        if v[2] then
            data = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", tonumber(v[1])) * tonumber(v[2]) / 10000
        else
            baseValue = v[1]
        end
        baseValue = baseValue + data
    end
    baseValue = baseValue + num
    way = config.time
    local timeValue = 0
    for _, v in pairs(way) do
        local data = 0
        if v[2] then
            data = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", tonumber(v[1])) * tonumber(v[2]) / 10000
        else
            timeValue = v[1]
        end
        timeValue = timeValue + data
    end
    timeValue = timeValue + num
    local _value = baseValue * (layers or 1)
    local maxValue = self:GetBuffMaxValue(buffId)
    
    if self:IsMMBuff(buffId) then
        local attrId = self:GetBuffAttId(buffId)
        local attrValue = InfoManager.roleOtherInfo:GetBuffAttValue(buffId,attrId)
        if attrValue then
            _value = attrValue
        end
    end
    
    if maxValue and _value >= maxValue then
        _value = maxValue
    end
    
    return math.floor(_value) , timeValue
end

function this:ReplaceBuffId(buffId)
    if not SL:HasConfig("cfg_buff_Calculation",buffId) then
        return nil
    end
    local buff_Calculation = SL:GetConfig("cfg_buff_Calculation",buffId)
    
    
    local type = buff_Calculation.type

    if type == 1 then
        type = 2
    else
        type = 1
    end
    local group = buff_Calculation.group
    local reBuff = SL:GetConfigMultiKeys("cfg_buff_Calculation",type,group,'type','group')
    return reBuff.id
end

local ELITEMM_MAX_VALUE = 350001 -- 最大buff值配置
function this:GetBuffMaxValue(buffId)
    ---@type cfg_buff_column
    local buffCfg =  SL:GetConfig("cfg_buff",buffId)
    local value = SL:GetConfig("cfg_global",ELITEMM_MAX_VALUE).value
    local data = ToolFunc.AnalysisStr(value,nil)
    local map = {}
    for i, v in pairs(data) do
        map[v[1]] = v[2]
    end
    for i, oneBuffata in pairs(buffCfg.buffParam) do
        if map[oneBuffata[1]] then
            return map[oneBuffata[1]]
        end
    end
    return nil
end

function this:GetBuffAttId(buffId)
    ---@type cfg_buff_column
    local buffCfg =  SL:GetConfig("cfg_buff",buffId)

    for i, oneBuffata in pairs(buffCfg.buffParam) do
        return oneBuffata[1]
    end
    return nil
end

function this:IsMMBuff(buffId)
    if SL:HasConfig("cfg_buff_Calculation",buffId) then
        local cfg = SL:GetConfig("cfg_buff_Calculation", buffId)
        if cfg.type == 2 then
            return true
        end
    end
    return false
end


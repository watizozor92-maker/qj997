---@class SkillEffect_AngleLeftRightOut @注释
SkillEffect_AngleLeftRightOut = class()
local this = SkillEffect_AngleLeftRightOut
E_SkillEffect_AngleLeftRightOut = {
    stepSeed = 0.75, ---步进速度
    stepMaxCount = 140, ---步进最大次数
    range = 1.2, ---检测范围
    angle = tonumber(SL:GetConfig("cfg_global", 660001).value),
}

function this:ctor()

end

function this:Init(skillEffect)
    --self.skillEffect = skillEffect

    skillEffect.outData = {
        forward = Vector3.zero,
        forwardStep = Vector3.zero,
        newTargetPos = Vector3.zero,
        curSkillEffectPos = Vector3.zero,
        beginPos = Vector3.zero,
        beginPosOffset = Vector3.zero,
        tempRotation = Quaternion.identity
    }
    self:GetForward(skillEffect)
    local tempRotation = Quaternion.identity
    local upTemp = Vector3.zero
    --upTemp在LookRotationNonAlloc内部有修改
    upTemp:Set(0, 1, 0)
    tempRotation:LookRotationNonAlloc(skillEffect.outData.forward, upTemp)
    skillEffect.outData.tempRotation = tempRotation
    --local rotation = Quaternion.LookRotation(self.forward,Vector3.up)
    skillEffect.transform:SetLocalRotation(tempRotation.x, tempRotation.y, tempRotation.z, tempRotation.w)
end

function this:Update(skillEffect)
    if skillEffect.skillPlayState ~= ESkillPlayState.Playing then
        return
    end
    if not Vector3.IsZero(skillEffect.targetPos) then
        --logError("targetPosX=" .. skillEffect.targetPos.x .. "targetPosZ=" .. skillEffect.targetPos.z)
        if skillEffect:GetRealMoveSpeed() ~= 0 then
            if skillEffect:IsDelayTimeOver() then
                if Time.time < skillEffect:GetDelayTime() + skillEffect:GetRealPlayTime() then
                    skillEffect.outData.forwardStep:CopyFrom(skillEffect.outData.forward)
                    local speed = Time.deltaTime * skillEffect:GetRealMoveSpeed()
                    skillEffect.outData.forwardStep:Mul(speed)
                    --logError("speed="..speed)
                    --skillEffect.outData.beginPos = { x = skillEffect.transform.position.x + skillEffect.outData.forwardStep.x * Time.deltaTime * skillEffect:GetRealMoveSpeed(), y = skillEffect.transform.position.y + skillEffect.outData.forwardStep.y * Time.deltaTime * skillEffect:GetRealMoveSpeed(), z = skillEffect.transform.position.z + skillEffect.outData.forwardStep.z * Time.deltaTime * skillEffect:GetRealMoveSpeed() }
                    --skillEffect.transform:SetLocalPosition(skillEffect.outData.beginPos.x,skillEffect.outData.beginPos.y,skillEffect.outData.beginPos.z)
                    skillEffect.transform:AddLocalPosition(skillEffect.outData.forwardStep.x, skillEffect.outData.forwardStep.y, skillEffect.outData.forwardStep.z)

                    skillEffect.outData.beginPosOffset = skillEffect.transform.position
                            + skillEffect.outData.tempRotation * Vector3.Scale(skillEffect.skillEffectCfgData.beginOffset, skillEffect.transform.localScale);
                    local monsterList = SL:GetMetaValue(EMetaVarGetKey.GET_MONSTER_DATA_LIST)
                    local playerDataList = SL:GetMetaValue(EMetaVarGetKey.GET_PLAYER_DATA_LIST)
                    if monsterList and not table.isNullOrEmpty(monsterList) then
                        for _, role in pairs(monsterList) do
                            local RelationshipType = SL:GetERelationshipType(role.data.id)
                            local dist = self:DistanceXZ(skillEffect.outData.beginPosOffset, role.transform.position)
                            --logError("dist=" .. dist)
                            if role.data.hp > 0 and RelationshipType == ERelationshipType.Enemy and (dist < E_SkillEffect_AngleLeftRightOut.range or dist < E_SkillEffect_AngleLeftRightOut.range * speed / E_SkillEffect_AngleLeftRightOut.stepSeed) then
                                skillEffect.skillPlayState = ESkillPlayState.PlayEnd
                            end
                        end
                    end
                    if playerDataList and not table.isNullOrEmpty(playerDataList) then
                        for _, role in pairs(playerDataList) do
                            if role.data.id ~= InfoManager.guardPetInfo.MM_ID then
                                local RelationshipType = SL:GetERelationshipType(role.data.id)
                                local dist = self:DistanceXZ(skillEffect.outData.beginPosOffset, role.transform.position)
                                if role.data.hp > 0 and RelationshipType == ERelationshipType.Enemy and (dist < E_SkillEffect_AngleLeftRightOut.range or dist < E_SkillEffect_AngleLeftRightOut.range * speed / E_SkillEffect_AngleLeftRightOut.stepSeed) then
                                    skillEffect.skillPlayState = ESkillPlayState.PlayEnd
                                end
                            end
                        end
                    end

                else
                    skillEffect.skillPlayState = ESkillPlayState.PlayEnd
                end
            end
        end
    end
end
function this:DistanceXZ(va, vb)
    return math.sqrt((va.x - vb.x) ^ 2 + (va.z - vb.z) ^ 2)
end
function this:GetForward(skillEffect)
    --logError("前端特效初始位置=|" .. skillEffect.beginPos.x.."|"..skillEffect.beginPos.y.."|"..skillEffect.beginPos.z)
    --logError("前端特效目标位置=|" .. skillEffect.targetPos.x.."|"..skillEffect.targetPos.y.."|"..skillEffect.targetPos.z)
    SpecialSkillEffectOut.GetTargetPos_LeftRightAngle(skillEffect.outData.newTargetPos, skillEffect.beginPos, skillEffect.targetPos, E_SkillEffect_AngleLeftRightOut.angle, skillEffect.effectIndex)
    skillEffect.outData.forward:CopyFromSub(skillEffect.outData.newTargetPos, skillEffect.beginPos)
    if skillEffect.outData.forward == Vector3.zero then
        skillEffect.outData.forward:Set(skillEffect.role.transform:GetForward())
    end
    local mag = skillEffect.outData.forward.magnitude
    --目标点和当前点不重合
    if skillEffect.outData.newTargetPos ~= Vector3.zero and mag > 1e-6 then
        skillEffect.outData.forward:SetNormalize()
    else
        --目标点和当前点重合时使用角色的朝向作为方向
        local dot = EDirectionToDot2[skillEffect.role.data.Dir]
        local x, z = Dot2.GetNormalizeXZ(dot)
        skillEffect.outData.forward:Set(x, 0, z)
        skillEffect.outData.forward:SetNormalize()
    end
end

function this:ModelObjectLoaded()

end

function this:Stop(skillEffect)

end

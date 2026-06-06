---@class SkillEffect_RadianOut @贝塞尔曲线弧度飞行
SkillEffect_RadianOut = class()
local this = SkillEffect_RadianOut

E_SkillEffect_RadianOut = {
    arcHeight = 2.0, ---弧度高度
    extraDistance = 0.0, ---到达目标点后继续飞行的距离
    startOffset = 0.0, ---起点的偏移距离（沿着方向延伸人物和怪物的距离）
    startHeightOffset = 0.0, ---起始高度偏移（向上偏移）
    minGroundHeight = 0.1, ---最小地面高度（防止低于地面）
    glideAngle = 15.0, ---滑行角度（度），起点和终点附近使用的固定倾斜角度
}

function this:ctor()

end

function this:Init(skillEffect)
    self.addDistance = skillEffect.skillEffectCfgData.skillEffectTbl.flyDelayDistance
    E_SkillEffect_RadianOut.extraDistance = 0
    if self.addDistance > 0 then
        E_SkillEffect_RadianOut.extraDistance = self.addDistance
    end
    skillEffect.outData = {
        forward = Vector3.zero,
        newTargetPos = Vector3.zero,
        beginPos = Vector3.zero,
        beginPosOffset = Vector3.zero,
        tempRotation = Quaternion.identity,
        bezierP0 = Vector3.zero,
        bezierP1 = Vector3.zero,
        bezierP2 = Vector3.zero,
        bezierP3 = Vector3.zero,
        elapsedTime = 0,
        totalDistance = 0
    }
    self:GetForward(skillEffect)

    local forward = skillEffect.outData.forward

    local upTemp = Vector3.zero
    upTemp:Set(0, 1, 0)

    local tempRotation = Quaternion.identity
    tempRotation:LookRotationNonAlloc(forward, upTemp)
    skillEffect.outData.tempRotation = tempRotation
    skillEffect.transform:SetLocalRotation(tempRotation.x, tempRotation.y, tempRotation.z, tempRotation.w)

    -- 设置贝塞尔曲线控制点
    -- 起点延伸一段距离（startOffset）并向上偏移（startHeightOffset）
    skillEffect.outData.bezierP0.x = skillEffect.beginPos.x + skillEffect.outData.forward.x * (E_SkillEffect_RadianOut.startOffset)
    skillEffect.outData.bezierP0.y = skillEffect.beginPos.y + E_SkillEffect_RadianOut.startHeightOffset
    skillEffect.outData.bezierP0.z = skillEffect.beginPos.z + skillEffect.outData.forward.z * (E_SkillEffect_RadianOut.startOffset)

    -- 终点延伸一段距离（extraDistance），高度与起点保持一致
    skillEffect.outData.bezierP3.x = skillEffect.targetPos.x + skillEffect.outData.forward.x * (E_SkillEffect_RadianOut.extraDistance )
    skillEffect.outData.bezierP3.y = skillEffect.beginPos.y + E_SkillEffect_RadianOut.startHeightOffset
    skillEffect.outData.bezierP3.z = skillEffect.targetPos.z + skillEffect.outData.forward.z * (E_SkillEffect_RadianOut.extraDistance)

    -- 确保起点和终点不低于地面最小高度
    if skillEffect.outData.bezierP0.y < E_SkillEffect_RadianOut.minGroundHeight then
        skillEffect.outData.bezierP0.y = E_SkillEffect_RadianOut.minGroundHeight
    end
    if skillEffect.outData.bezierP3.y < E_SkillEffect_RadianOut.minGroundHeight then
        skillEffect.outData.bezierP3.y = E_SkillEffect_RadianOut.minGroundHeight
    end

    -- 计算中点
    local midX = (skillEffect.outData.bezierP0.x + skillEffect.outData.bezierP3.x) * 0.5
    local midZ = (skillEffect.outData.bezierP0.z + skillEffect.outData.bezierP3.z) * 0.5
    local baseY = (skillEffect.outData.bezierP0.y + skillEffect.outData.bezierP3.y) * 0.5

    -- 设置控制点 P1 和 P2，实现先水平滑行，在末端向上弯曲的效果
    -- P1 设置在靠近起点的位置（约20%处），保持水平高度
    skillEffect.outData.bezierP1.x = skillEffect.outData.bezierP0.x + (skillEffect.outData.bezierP3.x - skillEffect.outData.bezierP0.x) * 0.2
    skillEffect.outData.bezierP1.y = skillEffect.outData.bezierP0.y
    skillEffect.outData.bezierP1.z = skillEffect.outData.bezierP0.z + (skillEffect.outData.bezierP3.z - skillEffect.outData.bezierP0.z) * 0.2

    -- P2 设置在靠近终点的位置（约70%处），高度提升，实现末端向上弯曲
    skillEffect.outData.bezierP2.x = skillEffect.outData.bezierP0.x + (skillEffect.outData.bezierP3.x - skillEffect.outData.bezierP0.x) * 0.7
    skillEffect.outData.bezierP2.y = baseY + E_SkillEffect_RadianOut.arcHeight
    skillEffect.outData.bezierP2.z = skillEffect.outData.bezierP0.z + (skillEffect.outData.bezierP3.z - skillEffect.outData.bezierP0.z) * 0.7

    -- 计算总距离
    local dx = skillEffect.outData.bezierP3.x - skillEffect.outData.bezierP0.x
    local dy = skillEffect.outData.bezierP3.y - skillEffect.outData.bezierP0.y
    local dz = skillEffect.outData.bezierP3.z - skillEffect.outData.bezierP0.z
    skillEffect.outData.totalDistance = math.sqrt(dx * dx + dy * dy + dz * dz)

    -- 设置特效初始位置为贝塞尔曲线起点，确保高度一致
    skillEffect.transform:SetLocalPosition(skillEffect.outData.bezierP0.x,
                                          skillEffect.outData.bezierP0.y,
                                          skillEffect.outData.bezierP0.z)
end

function this:Update(skillEffect)
    if skillEffect.skillPlayState ~= ESkillPlayState.Playing then
        return
    end
    if not Vector3.IsZero(skillEffect.targetPos) then
        if skillEffect:GetRealMoveSpeed() ~= 0 then
            if skillEffect:IsDelayTimeOver() then
                if Time.time < skillEffect:GetDelayTime() + skillEffect:GetRealPlayTime() then
                    skillEffect.outData.elapsedTime = skillEffect.outData.elapsedTime + Time.deltaTime

                    local distance = skillEffect.outData.elapsedTime * skillEffect:GetRealMoveSpeed()
                    local progress = distance / (skillEffect.outData.totalDistance + self.addDistance)

                    if progress > 1 then
                        progress = 1
                    end

                    local pos = self:CalculateBezierPosition(skillEffect.outData.bezierP0, skillEffect.outData.bezierP1,
                        skillEffect.outData.bezierP2, skillEffect.outData.bezierP3, progress)

                    -- 确保不低于地面最小高度
                    if pos.y < E_SkillEffect_RadianOut.minGroundHeight then
                        pos.y = E_SkillEffect_RadianOut.minGroundHeight
                    end

                    -- 起点和终点保持水平角度不变，飞行过程中角度跟随弧度变化，平滑过渡
                    local tangent = self:CalculateBezierTangent(skillEffect.outData.bezierP0, skillEffect.outData.bezierP1,
                        skillEffect.outData.bezierP2, skillEffect.outData.bezierP3, progress)

                    -- 计算平滑过渡权重：在起点附近（progress<0.1）和终点附近（progress>0.9）使用水平角度
                    local horizontalWeight = 0
                    local arcWeight = 1

                    if progress < 0.1 then
                        -- 起点附近：从水平角度逐渐过渡到弧度角度
                        horizontalWeight = 1 - (progress / 0.1)
                        arcWeight = 1 - horizontalWeight
                    elseif progress > 0.9 then
                        -- 终点附近：从弧度角度逐渐过渡回水平角度
                        horizontalWeight = (progress - 0.9) / 0.1
                        arcWeight = 1 - horizontalWeight
                    end

                    if horizontalWeight > 0 or arcWeight > 0 then
                        local targetRotation = Quaternion.identity
                        local upTemp = Vector3.zero
                        upTemp:Set(0, 1, 0)

                        if arcWeight > 0 and (tangent.x ~= 0 or tangent.y ~= 0 or tangent.z ~= 0) then
                            -- 计算弧度角度
                            targetRotation:LookRotationNonAlloc(tangent, upTemp)

                            if horizontalWeight > 0.001 then
                                -- 混合水平角度和弧度角度
                                local resultRotation = Quaternion.Slerp(skillEffect.outData.tempRotation,
                                                                       targetRotation,
                                                                       arcWeight)
                                skillEffect.transform:SetLocalRotation(resultRotation.x,
                                                                       resultRotation.y,
                                                                       resultRotation.z,
                                                                       resultRotation.w)
                            else
                                -- 完全使用弧度角度
                                skillEffect.transform:SetLocalRotation(targetRotation.x,
                                                                       targetRotation.y,
                                                                       targetRotation.z,
                                                                       targetRotation.w)
                            end
                        elseif horizontalWeight > 0.001 then
                            -- 完全使用水平角度
                            skillEffect.transform:SetLocalRotation(skillEffect.outData.tempRotation.x,
                                                                   skillEffect.outData.tempRotation.y,
                                                                   skillEffect.outData.tempRotation.z,
                                                                   skillEffect.outData.tempRotation.w)
                        end
                    end

                    skillEffect.transform:SetLocalPosition(pos.x, pos.y, pos.z)

                    skillEffect.outData.beginPosOffset = skillEffect.transform.position
                            + skillEffect.outData.tempRotation * Vector3.Scale(skillEffect.skillEffectCfgData.beginOffset, skillEffect.transform.localScale)

                    local monsterList = SL:GetMetaValue(EMetaVarGetKey.GET_MONSTER_DATA_LIST)
                    local playerDataList = SL:GetMetaValue(EMetaVarGetKey.GET_PLAYER_DATA_LIST)
                    if monsterList and not table.isNullOrEmpty(monsterList) then
                        for _, role in pairs(monsterList) do
                            local RelationshipType = SL:GetERelationshipType(role.data.id)
                            local dist = self:DistanceXZ(skillEffect.outData.beginPosOffset, role.transform.position)
                            if role.data.hp > 0 and RelationshipType == ERelationshipType.Enemy and dist < 0 then
                                skillEffect.skillPlayState = ESkillPlayState.PlayEnd
                            end
                        end
                    end
                    if playerDataList and not table.isNullOrEmpty(playerDataList) then
                        for _, role in pairs(playerDataList) do
                            if role.data.id ~= InfoManager.guardPetInfo.MM_ID then
                                local RelationshipType = SL:GetERelationshipType(role.data.id)
                                local dist = self:DistanceXZ(skillEffect.outData.beginPosOffset, role.transform.position)
                                if role.data.hp > 0 and RelationshipType == ERelationshipType.Enemy and dist < 0 then
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

function this:ModelObjectLoaded()

end

function this:Stop(skillEffect)

end

function this:CalculateBezierPosition(p0, p1, p2, p3, t)
    local oneMinusT = 1 - t
    local t2 = t * t
    local t3 = t2 * t
    local oneMinusT2 = oneMinusT * oneMinusT
    local oneMinusT3 = oneMinusT2 * oneMinusT

    local x = oneMinusT3 * p0.x +
            3 * oneMinusT2 * t * p1.x +
            3 * oneMinusT * t2 * p2.x +
            t3 * p3.x

    local y = oneMinusT3 * p0.y +
            3 * oneMinusT2 * t * p1.y +
            3 * oneMinusT * t2 * p2.y +
            t3 * p3.y

    local z = oneMinusT3 * p0.z +
            3 * oneMinusT2 * t * p1.z +
            3 * oneMinusT * t2 * p2.z +
            t3 * p3.z

    local result = {x = x, y = y, z = z}
    return result
end

function this:CalculateBezierTangent(p0, p1, p2, p3, t)
    -- 计算贝塞尔曲线在参数 t 处的切线（导数）
    local oneMinusT = 1 - t
    local oneMinusT2 = oneMinusT * oneMinusT

    local tx = 3 * oneMinusT2 * (p1.x - p0.x) +
               6 * oneMinusT * t * (p2.x - p1.x) +
               3 * t * t * (p3.x - p2.x)

    local ty = 3 * oneMinusT2 * (p1.y - p0.y) +
               6 * oneMinusT * t * (p2.y - p1.y) +
               3 * t * t * (p3.y - p2.y)

    local tz = 3 * oneMinusT2 * (p1.z - p0.z) +
               6 * oneMinusT * t * (p2.z - p1.z) +
               3 * t * t * (p3.z - p2.z)

    -- 归一化切线方向
    local mag = math.sqrt(tx * tx + ty * ty + tz * tz)
    if mag > 1e-6 then
        tx = tx / mag
        ty = ty / mag
        tz = tz / mag
    end

    local result = Vector3.zero
    result.x = tx
    result.y = ty
    result.z = tz
    return result
end

function this:DistanceXZ(va, vb)
    return math.sqrt((va.x - vb.x) ^ 2 + (va.z - vb.z) ^ 2)
end

function this:GetForward(skillEffect)
    skillEffect.outData.newTargetPos.x = skillEffect.targetPos.x
    skillEffect.outData.newTargetPos.y = skillEffect.targetPos.y
    skillEffect.outData.newTargetPos.z = skillEffect.targetPos.z

    skillEffect.outData.forward.x = skillEffect.outData.newTargetPos.x - skillEffect.beginPos.x
    skillEffect.outData.forward.y = skillEffect.outData.newTargetPos.y - skillEffect.beginPos.y
    skillEffect.outData.forward.z = skillEffect.outData.newTargetPos.z - skillEffect.beginPos.z

    if skillEffect.outData.forward.x == 0 and skillEffect.outData.forward.y == 0 and skillEffect.outData.forward.z == 0 then
        local fwd = skillEffect.role.transform:GetForward()
        skillEffect.outData.forward.x = fwd.x
        skillEffect.outData.forward.y = fwd.y
        skillEffect.outData.forward.z = fwd.z
    end

    local mag = math.sqrt(skillEffect.outData.forward.x * skillEffect.outData.forward.x +
                        skillEffect.outData.forward.y * skillEffect.outData.forward.y +
                        skillEffect.outData.forward.z * skillEffect.outData.forward.z)

    if mag > 1e-6 then
        skillEffect.outData.forward.x = skillEffect.outData.forward.x / mag
        skillEffect.outData.forward.y = skillEffect.outData.forward.y / mag
        skillEffect.outData.forward.z = skillEffect.outData.forward.z / mag
    else
        local dot = EDirectionToDot2[skillEffect.role.data.Dir]
        local x, z = Dot2.GetNormalizeXZ(dot)
        skillEffect.outData.forward.x = x
        skillEffect.outData.forward.y = 0
        skillEffect.outData.forward.z = z
    end
end

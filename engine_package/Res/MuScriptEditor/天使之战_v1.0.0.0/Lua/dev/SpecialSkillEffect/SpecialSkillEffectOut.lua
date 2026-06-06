---@class SpecialSkillEffectOut @多个特效之间的计算逻辑，比如多个方向的技能特效的方向计算
SpecialSkillEffectOut = class()
local this = SpecialSkillEffectOut
---@param srcPos Vector3
---@param targetPos Vector3
---@return Vector3 @多个方向的技能特效，根据索引左右旋转一定角度
---@param newTargetPos Vector3
function this.GetTargetPos_LeftRightAngle(newTargetPos,srcPos,targetPos,angle,index)
    if index == 1 then
        angle = 0
    else
        local count = 1
        if Mathf.Floor(index /2) == 0 then
            count = 1
        else
            count = Mathf.Floor(index /2)
        end
        angle = angle*(index%2==1 and 1 or -1) * count
    end
    --logError("angle="..angle)
    newTargetPos:RotateRoundNonAlloc(targetPos,srcPos,Vector3.upNonAlloc,angle)
end

---@return string @天地十字剑 根据攻击次数播放不同的动作
function this.GetTianDiShiZiJianAnimName(skillId, stepIndex, animName)
    if ESkillSpecialId.TianDiShiZiJian ~= skillId then
        return animName
    end
    if not this.tianDiShiZiJianAnim then
        this.tianDiShiZiJianAnim = {'tiandishizijian01','TSword_attack03'}
    end
    stepIndex = stepIndex%2+1
    return this.tianDiShiZiJianAnim[stepIndex]
end

function this.IsHasNoAction(skillId)
    if ESkillSpecialId.ShunYi == skillId then
        return true
    end
    local skillTbl = ConfigManager.Get_cfg_skill(skillId)
    if skillTbl and skillTbl.type == ECfgSkillType.Passive then
        return true
    end
    return false
end

--坐骑需要有动作，人物不需要
function this.IsRoleHasNoAction(skillId)
    if ESkillSpecialId.Mount == skillId then
        return true
    end
    return false
end
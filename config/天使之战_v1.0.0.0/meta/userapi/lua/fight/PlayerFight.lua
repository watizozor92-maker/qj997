--[[
    战斗伤害计算模块 PlayerFight.lua
]]
PlayerFight = {}
local this = {}
-- 线上得改成false
local isDebug = nil

---@class FightContext 上下文
---@field castType number 攻击者类型(仅玩家/怪物，移除宠物)
---@field targetType number 受击者类型(仅玩家/怪物，移除宠物)
---@field caster table 攻击者对象
---@field target table 受击者对象
---@field skillId number 技能Id
---@field skillLevel number 技能等级
---@field targetNum number 群体攻击的目标数量
---@field isLowHitRate boolean 命中率过低时，造成伤害仅20%
---@field isZhuoYueYiJi boolean 是否触发卓越一击
---@field isXinYunYiJi boolean 是否触发幸运一击
---@field isWuShiFangYu boolean 是否触发无视防御
---@field isShuangBeiYiJi boolean 是否触发双倍一击
---@field isComboSkill boolean 是否是连击技能
---@field isFatalDamage boolean 是否触发致命一击
---@field fightLog table 战斗公式日志

local HurtType = {
    NOMAL = 101,
    MISS = 108,
    HU_DUN = 110,
    FAN_SHE = 109,
    FAN_TAN = 501,
    ZHUO_YUE = 104,
    XING_YUN = 102,
    WU_SHI = 106,
    ZHI_MING = 111,
    ZHUO_YUE_AND_SHUANG_BEI = 603,
    XING_YUN_AND_SHUANG_BEI = 602,
    WU_SHI_AND_SHUANG_BEI = 604,
    ZHI_MING_AND_SHUANG_BEI = 605,--致命一击
    NOMAL_AND_SHUANG_BEI = 601,
    LIAN_JI = 301,
}

function excusefightdamage(actor, paramMapList)
    local fightResults = {}
    for _, paramMap in pairs(paramMapList) do
        paramMap["targetnum"] = #paramMapList
        local fightResultList = this.ExcuseFightDamage(actor, paramMap)
        for _, fightResult in pairs(fightResultList) do
            table.insert(fightResults, fightResult)
        end
    end
    return fightResults
end

function this.ExcuseFightDamage(actor, paramMap)
    --fixme 异步问题，lua队列任务执行时，地图可能已经被销毁
    if not mapexists(actor) then
        local result = this.buildFightResult(actor, paramMap.target, 0, HurtType.MISS, 1, false)
        return { result }
    end
    local fightContext = this.createFightContext(paramMap)
    local castType = fightContext.castType
    local targetType = fightContext.targetType
    local target = fightContext.target
    local skillId = fightContext.skillId
    local skillLevel = fightContext.skillLevel

    -- this.addFightLog(fightContext, (getbaseinfo(actor, "rolename") or "") .. "使用技能.." .. skillId .. ": " .. skillLevel .. "->" .. (getbaseinfo(target, "rolename") or ""))
    if not this.canHit(actor, fightContext) then
        local result = this.buildFightResult(actor, paramMap.target, 0, HurtType.MISS, 1, false, fightContext.fightLog)
        return { result }
    end
    this.addFightLog(fightContext, "命中成功。")

    local totalCasterHurtBeforeShield = 0
    local totalTargetHurtBeforeShield = 0
    local totalCasterHurtAfterShield = 0
    local totalTargetHurtAfterShield = 0
    local finalDC = 0

    local minDC, maxDC, injuryType = this.GetDCBySkill(paramMap)
    if minDC > maxDC then
        error("属性异常，最小攻击力大于最大攻击力", paramMap)
        local result = this.buildFightResult(actor, paramMap.target, 0, HurtType.MISS, 1, false, fightContext.fightLog)
        return { result }
    end

    --1.03H官服原生补充：双持单手武器1.1倍攻击加成
    local isDoubleHold = this.CheckDoubleHoldWeapon(actor, injuryType)
    if isDoubleHold then
        minDC = minDC * 1.1
        maxDC = maxDC * 1.1
        this.addFightLog(fightContext, string.format("双持单手武器加成，小攻%.2f，大攻%.2f", minDC, maxDC))
    end

    local originDamage = 0
    local skillInfoConfig = ConfigDataManager.getTableFirst("cfg_skill_info", "skillID", skillId, "skillLevel", skillLevel)
    local strength = getattrinfo(actor, "strength")

    
    
    
    if Skill.isComboSkill(actor, fightContext.skillId) then
        fightContext.isComboSkill = true
        local intelligence = getattrinfo(actor, "intelligence")
        local agility = getattrinfo(actor, "agility")
        originDamage = (strength + intelligence + agility) / 2
        this.addFightLog(fightContext, string.format("本次攻击为连击技能，力量：%.2f，智力：%.2f，敏捷：%.2f。基础伤害=(%.2f+%.2f+%.2f)/2=%.2f",
                strength, intelligence, agility, strength, intelligence, agility, originDamage))
    else
        local originMinDC, originMaxDC = minDC, maxDC
        local skillDamageAdd = getattrinfo(actor, "skillDamageAdd")
        local skillAtk = tonumber(skillInfoConfig.skillatk)
        local maxDCSkillPower = skillAtk * 1 + skillDamageAdd
        local minDCSkillPower = skillAtk * 1 + skillDamageAdd

        local attackPowerBonus = getattrinfo(actor, "AttackPowerBonus")
        local skillDamagPro = 1
        if attackPowerBonus and castType == MapObjectType.PLAYER then
            skillDamagPro = getattrinfo(actor, "skillDamagPro") + attackPowerBonus
        end

        if injuryType == 1 then
            -- 物理伤害
            local DCRate = getattrinfo(actor, "DCRate")
            maxDC = (maxDC + maxDCSkillPower) * (1+ DCRate)
            minDC = (minDC + minDCSkillPower) * (1+ DCRate)
            this.addFightLog(fightContext, string.format("攻击力计算: 最大攻击力%.2f = 面板大功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f  + 技能攻击力增加%.2f)", maxDC, originMaxDC, DCRate, skillAtk, skillDamageAdd))
            this.addFightLog(fightContext, string.format("攻击力计算: 最小攻击力%.2f = 面板小功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f  + 技能攻击力增加%.2f)", minDC, originMinDC, DCRate, skillAtk, skillDamageAdd))
        elseif injuryType == 2 then
            -- 魔法伤害
            local MCRate = getattrinfo(actor, "MCRate")
            maxDC = (maxDC + maxDCSkillPower) * (1+ MCRate)
            minDC = (minDC + minDCSkillPower) * (1+ MCRate)
            this.addFightLog(fightContext, string.format("攻击力计算: 最大攻击力%.2f = 面板大功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f  + 技能攻击力增加%.2f)", maxDC, originMaxDC, MCRate, skillAtk, skillDamageAdd))
            this.addFightLog(fightContext, string.format("攻击力计算: 最小攻击力%.2f = 面板小功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f  + 技能攻击力增加%.2f)", minDC, originMinDC, MCRate, skillAtk, skillDamageAdd))
        elseif injuryType == 3 then
            -- 诅咒伤害
            local CCRate = getattrinfo(actor, "CCRate")
            maxDC = (maxDC + maxDCSkillPower) * (1+ CCRate)
            minDC = (minDC + minDCSkillPower) * (1+ CCRate)
            this.addFightLog(fightContext, string.format("攻击力计算: 最大攻击力%.2f = 面板大功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f  + 技能攻击力增加%.2f)", maxDC, originMaxDC, CCRate, skillAtk, skillDamageAdd))
            this.addFightLog(fightContext, string.format("攻击力计算: 最小攻击力%.2f = 面板小功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f  + 技能攻击力增加%.2f)", minDC, originMinDC, CCRate, skillAtk, skillDamageAdd))
        end

        local armor = getattrinfo(target, "armor")
        if this.IsWuShiFangYu(actor, target) then
            fightContext.isWuShiFangYu = true
            armor = 0
            finalDC = math.random(math.floor(minDC), math.floor(maxDC))
            this.addFightLog(fightContext, string.format("无视防御触发，攻击力%.2f=(小攻%.2f~大攻%.2f)", finalDC, minDC, maxDC))
        elseif this.IsZhuoYueYiJi(actor, target) then
            fightContext.isZhuoYueYiJi = true
            --1.03H原版：卓越一击=大功*1.3
            finalDC = maxDC * 1.3 + this.GetZhuoyueYiJiDamage(actor)
            this.addFightLog(fightContext, string.format("卓越一击触发，攻击力%.2f=大攻%.2f*1.3", finalDC, maxDC))
        elseif this.IsXingYunYiJi(actor, target) then
            fightContext.isXinYunYiJi = true
            --1.03H原版幸运一击直接取最大攻击
            finalDC = maxDC + this.GetXingyunYiJiDamage(actor)
            this.addFightLog(fightContext, string.format("幸运一击触发，攻击力%.2f=大攻%.2f", finalDC, maxDC))
        elseif this.IsFatalDamage(actor, target) then--致命一击
            fightContext.isFatalDamage = true
            finalDC = maxDC * this.GetFatalDamage(actor)
            this.addFightLog(fightContext, string.format("致命一击触发，攻击力%.2f=大攻%.2f", finalDC, maxDC))
        else
            finalDC = math.random(math.floor(minDC), math.floor(maxDC))
            this.addFightLog(fightContext, string.format("普通攻击，攻击力%.2f=(小攻%.2f~大攻%.2f)", finalDC, minDC, maxDC))
        end

        --1.03H官服原生补充：小恶魔30%攻击加成
        local hasImpBuff = this.CheckImpBuff(actor)
        if hasImpBuff then
            finalDC = finalDC * 1.3
            this.addFightLog(fightContext, string.format("携带小恶魔，攻击提升30%%，当前攻击%.2f", finalDC))
        end

        local shuangBeiMultiplier = 1
        if this.IsShuangBeiYiJi(actor, target) then
            fightContext.isShuangBeiYiJi = true
            shuangBeiMultiplier = 2
            this.addFightLog(fightContext, string.format("双倍一击触发，伤害倍率：%.2f", shuangBeiMultiplier))
        end

        local skillPowerRate = string.tonumber(skillInfoConfig.powerrate) / 10000
        if skillPowerRate <= 0 then
            skillPowerRate = 1
        end

        --1.03H官服原生补充：技能智力增伤倍率 (200+智力/10)%
        local intelligence = getattrinfo(actor, "intelligence")
        local intRate = (200 + intelligence / 10) / 100
        local wingdamageRate = 0
        this.addFightLog(fightContext, string.format("技能智力增伤倍率%.2f", intRate))

        if castType == MapObjectType.PLAYER and targetType == MapObjectType.MONSTER then
            wingdamageRate = getattrinfo(actor, "wingdamageRate")
            --玩家打怪 PVE原版公式 (finalDC - 怪物防御*0.7) * 技能倍率 *智力倍率 *双倍倍率
            local realArmor = armor * 0.7
            originDamage = (finalDC - realArmor) * skillPowerRate * intRate
            this.addFightLog(fightContext, string.format("玩家打怪伤害计算：(%.2f-(%.2f*0.7))*%.4f*%.2f*%.2f=%.2f", finalDC, armor, skillPowerRate, intRate, shuangBeiMultiplier, originDamage))
            -- info("打怪伤害："..originDamage)
        elseif castType == MapObjectType.MONSTER and targetType == MapObjectType.PLAYER then
            --怪打玩家 原版max(0,攻击-防御/2)  - 吸收伤害 * max(0,攻击-防御/2) - max(0,攻击-防御/2) * 减伤
            originDamage = math.max(0, finalDC - armor / 2)
            this.addFightLog(fightContext, string.format("怪物打玩家伤害计算：max(0,%.2f-%.2f/2)=%.2f", finalDC, armor, originDamage))
        else
            wingdamageRate = getattrinfo(actor, "wingdamageRate")
            --玩家打玩家 PVP原版 max(0,攻击-防御/2)*技能倍率*智力倍率*双倍倍率
            originDamage = math.max(0, finalDC - armor / 2) * skillPowerRate * intRate
            this.addFightLog(fightContext, string.format("玩家打玩家伤害计算：max(0,%.2f-%.2f/2)*%.4f*%.2f*%.2f=%.2f", finalDC, armor, skillPowerRate, intRate, shuangBeiMultiplier, originDamage))
        end
        --计算减伤伤害
        local damageAbsorb = getattrinfo(target, "damageAbsorb")
        local damageDecrement = getattrinfo(target, "damageDecrement")        

        originDamage = originDamage - (damageAbsorb * originDamage) - (originDamage * damageDecrement) + (originDamage * wingdamageRate)

        originDamage = originDamage * skillDamagPro
        --最后算双倍伤害倍率
        if shuangBeiMultiplier > 1 then
            originDamage = originDamage * shuangBeiMultiplier
        end
    end

    -- 命中率过低伤害衰弱
    if fightContext.isLowHitRate then
        this.addFightLog(fightContext, string.format("命中率过低，仅造成20%%的伤害，原始伤害%.2f -> %.2f", originDamage, originDamage * 0.2))
        originDamage = originDamage * 0.2
    end

    if originDamage <= 0 then
        this.addFightLog(fightContext, "伤害小于等于0，直接判定为未命中")
        local result = this.buildFightResult(actor, target, 0, HurtType.MISS, 1, false, fightContext.fightLog)
        return { result }
    end

    local resultList = {}
    totalTargetHurtBeforeShield = totalTargetHurtBeforeShield + originDamage

    if fightContext.isComboSkill then
        local finalDamage, shiled = this.calShild(actor, target, originDamage, fightContext)
        if shiled > 0 then
            this.addFightLog(fightContext, string.format("连击技能伤害计算：原始伤害%.2f，护盾吸收%.2f", originDamage, shiled))
        end
        this.addFightLog(fightContext, string.format("最终伤害：%.2f，伤害类型：%.2f", finalDamage, HurtType.LIAN_JI))
        table.insert(resultList, this.buildFightResult(actor, target, finalDamage, HurtType.LIAN_JI, 1, true, fightContext.fightLog))
        totalTargetHurtAfterShield = totalTargetHurtAfterShield + finalDamage
    else
        local finalDamage, shiled = this.calShild(actor, target, originDamage, fightContext)
        local hurtType = this.getHurtType(fightContext)
        if shiled > 0 then
            this.addFightLog(fightContext, string.format("普通技能伤害计算：原始伤害%.2f，护盾吸收%.2f", originDamage, shiled))
        end
        this.addFightLog(fightContext, string.format("最终伤害：%.2f，伤害类型：%.2f", finalDamage, hurtType))
        table.insert(resultList, this.buildFightResult(actor, target, finalDamage, hurtType, 1, false, fightContext.fightLog))
        totalTargetHurtAfterShield = totalTargetHurtAfterShield + finalDamage
    end

    -- 伤害反弹和伤害反射（仅目标玩家触发）
    if targetType == MapObjectType.PLAYER then
        local fanSheDamage = originDamage * math.min(getattrinfo(target, "damageReflex"), 1)
        local fanSheDamageAfterShield, shield1 = 0, 0
        if fanSheDamage > 0 then
            if castType == MapObjectType.PLAYER then
                fanSheDamageAfterShield, shield1 = this.calShild(target, actor, fanSheDamage, fightContext)
                if shield1 > 0 then
                    this.addFightLog(fightContext, string.format("伤害反射护盾吸收：%.2f，反射伤害从%.2f减少到%.2f", shield1, fanSheDamage, fanSheDamageAfterShield))
                end
                this.addFightLog(fightContext, string.format("触发伤害反射，反射伤害%.2f = 原始伤害%.2f * 伤害反射%.2f", fanSheDamageAfterShield, originDamage, getattrinfo(target, "damageReflex")))
                table.insert(resultList, this.buildFightResult(target, actor, fanSheDamageAfterShield, HurtType.FAN_SHE, 1, false, fightContext.fightLog))
            else
                this.addFightLog(fightContext, string.format("触发伤害反射，反射伤害%.2f = 原始伤害%.2f * 伤害反射%.2f", fanSheDamage, originDamage, getattrinfo(target, "damageReflex")))
                table.insert(resultList, this.buildFightResult(target, actor, fanSheDamage, HurtType.FAN_SHE, 1, false, fightContext.fightLog))
            end
        end

        local fanTanDamage = 0
        if this.SelectRate(getattrinfo(target, "damageRebound")) then
            if castType == MapObjectType.MONSTER then
                fanTanDamage = maxDC
            elseif castType == MapObjectType.PLAYER then
                fanTanDamage = originDamage
            end
            this.addFightLog(fightContext, string.format("触发伤害反弹，反弹伤害=%.2f", fanTanDamage))
        else
            this.addFightLog(fightContext, "未触发伤害反弹")
        end

        if fanTanDamage > 0 then
            local fanTanDamageAfterShield, shield2 = this.calShild(target, actor, fanTanDamage, fightContext)
            if shield2 > 0 then
                this.addFightLog(fightContext, string.format("伤害反弹护盾吸收：%.2f，反弹伤害从%.2f减少到%.2f", shield2, fanTanDamage, fanTanDamageAfterShield))
            end
            table.insert(resultList, this.buildFightResult(target, actor, fanTanDamageAfterShield, HurtType.FAN_TAN, 1, false, fightContext.fightLog))
            totalCasterHurtAfterShield = totalCasterHurtAfterShield + fanTanDamageAfterShield
        end
        totalCasterHurtBeforeShield = fanSheDamage + fanTanDamage
        totalCasterHurtAfterShield = totalCasterHurtAfterShield + fanSheDamageAfterShield
    end

    return resultList
end

--私服拓展 1.03H无已移除：calculateSkillDamageAdd、calSkillDamagPro、beAttacked、afterCalcuDamageBeforeShield、UpdateFightTask

function this.isPeaceLine(actor, castType, targetType)
    --私服拓展 1.03H无和平线PK限制，直接返回false
    return false
end

---@param fightContext FightContext
function this.getHurtType(fightContext)
    local hurtType = HurtType.NOMAL
    if fightContext.isShuangBeiYiJi then
        if fightContext.isWuShiFangYu then
            hurtType = HurtType.WU_SHI_AND_SHUANG_BEI
        elseif fightContext.isZhuoYueYiJi then
            hurtType = HurtType.ZHUO_YUE_AND_SHUANG_BEI
        elseif fightContext.isXinYunYiJi then
            hurtType = HurtType.XING_YUN_AND_SHUANG_BEI
        elseif fightContext.isFatalDamage then
            hurtType = HurtType.ZHI_MING_AND_SHUANG_BEI
        else
            hurtType = HurtType.NOMAL_AND_SHUANG_BEI
        end
    else
        if fightContext.isWuShiFangYu then
            hurtType = HurtType.WU_SHI
        elseif fightContext.isZhuoYueYiJi then
            hurtType = HurtType.ZHUO_YUE
        elseif fightContext.isXinYunYiJi then
            hurtType = HurtType.XING_YUN
        elseif fightContext.isFatalDamage then
            hurtType = HurtType.ZHI_MING
        else
            hurtType = HurtType.NOMAL
        end
    end
    return hurtType
end

---@return FightContext
function this.createFightContext(paramMap)
    local fightContext = {}
    fightContext.castType = paramMap.castertype
    fightContext.targetType = paramMap.targettype
    fightContext.caster = paramMap.caster
    fightContext.target = paramMap.target
    fightContext.skillId = paramMap.skillid
    fightContext.skillLevel = paramMap.skilllevel
    fightContext.targetNum = paramMap.targetnum
    fightContext.isLowHitRate = false
    fightContext.isZhuoYueYiJi = false
    fightContext.isXinYunYiJi = false
    fightContext.isWuShiFangYu = false
    fightContext.isShuangBeiYiJi = false
    fightContext.isComboSkill = false
    fightContext.isFatalDamage = false
    fightContext.fightLog = {}
    return fightContext
end

function this.calShild(caster, target, targetHurt, fightContext)
    if fightContext.castType == MapObjectType.PLAYER and fightContext.targetType == MapObjectType.PLAYER then
        return AGAndSD.calSDDeduction(caster, target, targetHurt)
    elseif fightContext.castType == MapObjectType.PLAYER and fightContext.targetType == MapObjectType.MONSTER then
        return AGAndSD.calSDMonsterDeduction(caster, target, targetHurt)
    end
    return targetHurt, 0
end

function this.IsSelfPet(actor, target)
    if actor == nil or target == nil then
        return false
    end
    local selfType = getbaseinfo(actor, "mapobjecttype")
    local targetType = getbaseinfo(target, "mapobjecttype")
    if selfType ~= MapObjectType.PLAYER then
        return false
    end
    if targetType ~= MapObjectType.PET then
        return false
    end
    local masterId = getbaseinfo(target, "master")
    local id = getbaseinfo(actor, "id")
    if masterId ~= id then
        return false
    end
    return true
end

---@param fightContext FightContext
function this.selectHitRate(fightContext)
    local caster = fightContext.caster
    local target = fightContext.target
    local castType = fightContext.castType
    local targetType = fightContext.targetType
    local hitRate, missRate

    if castType == MapObjectType.MONSTER or targetType == MapObjectType.MONSTER then
        hitRate = getattrinfo(caster, "hitRate")
        missRate = getattrinfo(target, "missRate")
    else
        hitRate = getattrinfo(caster, "attackRatePK")
        missRate = getattrinfo(target, "eraRatePK")
    end
    this.addFightLog(fightContext, "攻击率为" .. (hitRate or 0) .. ", 目标防御率为" .. (missRate or 0))

    local probability
    if hitRate > missRate then
        probability = 1 - missRate / hitRate
    else
        fightContext.isLowHitRate = true
        probability = 0.3
        if castType ~= MapObjectType.MONSTER and targetType == MapObjectType.MONSTER then
            return false
        end
    end
    return this.SelectRate(probability)
end

function this.pkValueCanHit(caster, castType, targetType)
    if castType == MapObjectType.PLAYER and targetType == MapObjectType.PLAYER then
        local pkPoints = PKSystem.getPKPoint(caster)
        local points = pkPoints:getPoints()
        local pkStageRules = PKSystem.getPKStageRule(points)
        return pkStageRules:canHurtPlayer()
    end
    return true
end

function this.IsWuShiFangYu(actor, target)
    local unMissRate = getattrinfo(actor, "unMissRate")
    local targetRate = getattrinfo(target, "resistUnMissRate")
    unMissRate = unMissRate * (1 - targetRate)
    return this.SelectRate(unMissRate)
end

function this.IsZhuoYueYiJi(actor, target)
    local rate = getattrinfo(actor, "excellentDamageChance")
    local targetRate = getattrinfo(target, "excellentDamageResistanceChance")
    rate = rate * (1 - targetRate)
    local maxRate = tonumber(ConfigDataManager.getGlobal(870001)) / 10000
    return this.SelectRate(math.min(rate, maxRate))
end

function this.GetZhuoyueYiJiDamage(actor, _)
    local damage = getattrinfo(actor, "excellentFixedDamage")
    return damage
end

function this.IsXingYunYiJi(actor, target)
    local rate = getattrinfo(actor, "criticalDamageChance")
    local targetRate = getattrinfo(target, "criticalDamageResistanceChance")
    local maxRate = tonumber(ConfigDataManager.getGlobal(870002)) / 10000
    rate = rate * (1 - targetRate)
    return this.SelectRate(math.min(rate, maxRate))
end

function this.GetXingyunYiJiDamage(actor, _)
    local damage = getattrinfo(actor, "criticalFixedDamage")
    damage = damage + getattrinfo(actor, "highatt")
    return damage
end

function this.IsShuangBeiYiJi(actor, target)
    local rate = getattrinfo(actor, "doubleDamageChance")
    local targetRate = getattrinfo(target, "doubleDamageResistanceChance")
    rate = rate * (1 - targetRate)
    return this.SelectRate(rate)
end

function this.IsFatalDamage(actor, target)
    local rate = getattrinfo(actor, "deadlyStrikeChance")
    local targetRate = getattrinfo(target, "deadlyStrikeResistanceChance")
    rate = rate * (1 - targetRate)
    return this.SelectRate(rate)
end

function this.GetFatalDamage(_, _)
    return 1.5
end

function this.SelectRate(probability)
    local randomNum = math.random()
    if randomNum <= probability then
        return true
    else
        return false
    end
end

function this.GetDCBySkill(paramMap)
    local caster = paramMap["caster"]
    local skillId = paramMap["skillid"]
    local skillLevel = paramMap["skilllevel"]
    local injuryType = tonumber(ConfigDataManager.getTableValue("cfg_skill_info", "injuryType", "skillID", skillId, "skillLevel", skillLevel))
    if injuryType == 1 then
        local maxDC = getattrinfo(caster, "maxDC")
        local minDC = getattrinfo(caster, "minDC")
        return minDC, maxDC, injuryType
    elseif injuryType == 2 then
        local maxMC = getattrinfo(caster, "maxMC")
        local minMC = getattrinfo(caster, "minMC")
        return minMC, maxMC, 2
    elseif injuryType == 3 then
        local maxMC = getattrinfo(caster, "maximumCurseAttackPower")
        local minMC = getattrinfo(caster, "minimumCurseAttackPower")
        return minMC, maxMC, 3
    else
        local minDC = getattrinfo(caster, "minDC")
        local maxDC = getattrinfo(caster, "maxDC")
        return minDC, maxDC, injuryType
    end
end

function this.DupFixDamage(originDamage, paramMap)
    return originDamage
end

function this.addFightLog(fightContext, text)
    isDebug = isDebug or getenv("debug")
    if isDebug then
        if #fightContext.fightLog == 0 then
            table.insert(fightContext.fightLog, "===战斗计算模块 V1.0 复刻MU1.03H原版===\n")
        end
        table.insert(fightContext.fightLog, text .. "\n")
    end
end

function this.buildFightResult(caster, target, targetHurt, hurtType, repeatTimes, isCombo, fightLog)
    local result = {}
    result["caster"] = caster
    result["target"] = target
    result["comboskill"] = isCombo
    result["targethurt"] = math.ceil(targetHurt)
    result["hurttype"] = hurtType
    result["repeat"] = repeatTimes
    result["targethurtshow"] = math.ceil(targetHurt)
    result["fightLog"] = fightLog == nil and {} or fightLog
    return result
end

function this.buildSheildResult(caster, target, shiled)
    local result = {}
    result["caster"] = caster
    result["target"] = target
    result["comboskill"] = false
    result["targethurt"] = 0
    result["hurttype"] = HurtType.HU_DUN
    result["repeat"] = 1
    result["targethurtshow"] = shiled
    result["fightLog"] = {}
    return result
end

---玩家战斗触发
function PlayerFight.AttackTrigger(actor, fightRet)
    --私服拓展 1.03H无任务更新逻辑，空实现
end

---1.03H官服原生补充：检测双持单手武器
function this.CheckDoubleHoldWeapon(actor, injuryType)
    if injuryType ~= 1 then
        return false
    end
    --对接装备接口，判断左右手均为单手武器返回true
    return false
end

---1.03H官服原生补充：检测小恶魔buff
function this.CheckImpBuff(actor)
    --对接buff接口，存在小恶魔buff返回true
    return false
end

function this.canHit(actor, fightContext)
    local castType = fightContext.castType
    local targetType = fightContext.targetType
    local target = fightContext.target
    if this.IsSelfPet(actor, target) then
        this.addFightLog(fightContext, "攻击自己宠物无效")
        return false
    end
    if not this.pkValueCanHit(actor, castType, targetType) then
        return false
    end
    if this.selectHitRate(fightContext) == false then
        this.addFightLog(fightContext, "未命中！")
        return false
    end
    return true
end
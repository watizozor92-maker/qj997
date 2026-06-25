PlayerFight = {}
local this = {}

-- 线上得改成false
local isDebug = nil


---@class FightContext 上下文
---@field castType number 攻击者类型
---@field targetType number 受击者类型
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
    ZHUO_YUE_AND_SHUANG_BEI = 603,
    XING_YUN_AND_SHUANG_BEI = 602,
    WU_SHI_AND_SHUANG_BEI = 604,
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

    this.addFightLog(fightContext, getbaseinfo(actor, "rolename") .. "使用技能.." .. skillId .. ": " .. skillLevel .. "->" .. getbaseinfo(target, "rolename"))

    if not this.canHit(actor, fightContext) then
        local result = this.buildFightResult(actor, paramMap.target, 0, HurtType.MISS, 1, false, fightContext.fightLog)
        return { result }
    end

    this.addFightLog(fightContext, "命中成功。")
    -- 这两个伤害是扣减护盾前的原始伤害
    local totalCasterHurtBeforeShield = 0
    local totalTargetHurtBeforeShield = 0

    local totalCasterHurtAfterShield = 0
    local totalTargetHurtAfterShield = 0


    -- 攻击力
    local finalDC = 0
    -- 技能所用的面板攻击力
    local minDC, maxDC, injuryType = this.GetDCBySkill(paramMap)
    if minDC > maxDC then
        error("属性异常，最小攻击力大于最大攻击力", paramMap)
        local result = this.buildFightResult(actor, paramMap.target, 0, HurtType.MISS, 1, false, fightContext.fightLog)
        return { result }
    end
    local originDamage = 0
    local skillInfoConfig = ConfigDataManager.getTableFirst("cfg_skill_info", "skillID", skillId, "skillLevel", skillLevel)
    local strength = getattrinfo(actor, "strength")
    local attackPowerBonus = getattrinfo(actor, "AttackPowerBonus")
    -- 连击技能直接走真伤
    if Skill.isComboSkill(actor, fightContext.skillId) then
        fightContext.isComboSkill = true
        -- 连击伤害 = 力敏智点数总和除以2
        local intelligence = getattrinfo(actor, "intelligence")
        local agility = getattrinfo(actor, "agility")
        originDamage = (strength + intelligence + agility) / 2
        this.addFightLog(fightContext, string.format("本次攻击为连击技能，力量：%.2f，智力：%.2f，敏捷：%.2f。基础伤害=(%.2f+%.2f+%.2f)/2=%.2f",
                strength, intelligence, agility, strength, intelligence, agility, originDamage))
    else
        local originMinDC, originMaxDC = minDC, maxDC
        local skillDamageAdd = getattrinfo(actor, "skillDamageAdd")
        local skillAtk = tonumber(skillInfoConfig.skillatk)

        local maxDCSkillPower = skillAtk * 1.5 + skillDamageAdd
        local minDCSkillPower = skillAtk * 1 + skillDamageAdd

        if injuryType == 1 then
            -- 物理伤害
            local DCRate = getattrinfo(actor, "DCRate")
            local career = 0
            local killerType = getbaseinfo(actor, "mapobjecttype")
            if tonumber(killerType) == MapObjectType.PLAYER then
                career = getbaseinfo(actor, "getbasecareer")
            end
            if career == 1 or career == 4 then
                -- 剑士
                maxDC = maxDC * (1 + DCRate + 0.6 * attackPowerBonus)
                minDC = minDC * (1 + DCRate + 0.6 * attackPowerBonus)
                this.addFightLog(fightContext, string.format("攻击力计算: 最大攻击力%.2f = 面板大功%.2f * (1 + 攻击百分比%.2f + 0.6 * 战斗威力加成%.2f)", maxDC, originMaxDC, DCRate, attackPowerBonus))
                this.addFightLog(fightContext, string.format("攻击力计算: 最小攻击力%.2f = 面板小功%.2f * (1 + 攻击百分比%.2f + 0.6 * 战斗威力加成%.2f)", minDC, originMinDC, DCRate, attackPowerBonus))
            else
                maxDC = maxDC * (1 + DCRate) + maxDCSkillPower
                minDC = minDC * (1 + DCRate) + minDCSkillPower
                this.addFightLog(fightContext, string.format("攻击力计算: 最大攻击力%.2f = 面板大功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f * 1.5 + 技能攻击力增加%.2f)", maxDC, originMaxDC, DCRate, skillAtk, skillDamageAdd))
                this.addFightLog(fightContext, string.format("攻击力计算: 最小攻击力%.2f = 面板小功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f * 1.5 + 技能攻击力增加%.2f)", minDC, originMinDC, DCRate, skillAtk, skillDamageAdd))
            end
        elseif injuryType == 2 then
            -- 魔法伤害
            local MCRate = getattrinfo(actor, "MCRate")
            local wandMagicAttackPowerBonus = getattrinfo(actor, "wandMagicAttackPowerBonus")
            maxDC = (maxDC * (1 + MCRate) + maxDCSkillPower) * (1 + wandMagicAttackPowerBonus)
            minDC = (minDC * (1 + MCRate) + minDCSkillPower) * (1 + wandMagicAttackPowerBonus)
            this.addFightLog(fightContext, string.format("攻击力计算: 最大攻击力%.2f = (面板大功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f * 1.5 + 技能攻击力增加%.2f)) * (1 + 魔力提高%.2f)", maxDC, originMaxDC, MCRate, skillAtk, skillDamageAdd, wandMagicAttackPowerBonus))
            this.addFightLog(fightContext, string.format("攻击力计算: 最小攻击力%.2f = (面板小功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f * 1.5 + 技能攻击力增加%.2f)) * (1 + 魔力提高%.2f)", minDC, originMinDC, MCRate, skillAtk, skillDamageAdd, wandMagicAttackPowerBonus))
        elseif injuryType == 3 then
            -- 诅咒伤害
            local CCRate = getattrinfo(actor, "CCRate")
            local cursepowerratio = getattrinfo(actor, "cursepowerratio")
            maxDC = (maxDC * (1 + CCRate) + maxDCSkillPower) * (1 + cursepowerratio)
            minDC = (minDC * (1 + CCRate) + minDCSkillPower) * (1 + cursepowerratio)
            this.addFightLog(fightContext, string.format("攻击力计算: 最大攻击力%.2f = (面板大功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f * 1.5 + 技能攻击力增加%.2f)) * (1 + 诅咒提高%.2f)", maxDC, originMaxDC, CCRate, skillAtk, skillDamageAdd, cursepowerratio))
            this.addFightLog(fightContext, string.format("攻击力计算: 最小攻击力%.2f = (面板小功%.2f * (1 + 攻击百分比%.2f) + (技能攻击力%.2f * 1.5 + 技能攻击力增加%.2f)) * (1 + 诅咒提高%.2f)", minDC, originMinDC, CCRate, skillAtk, skillDamageAdd, cursepowerratio))
        end

        local armor = getattrinfo(target, "armor")

        -- 判断无视防御、卓越一击、幸运一击是否触发
        if this.IsWuShiFangYu(actor, target) then
            fightContext.isWuShiFangYu = true
            armor = 0
            finalDC = math.random(math.floor(minDC), math.floor(maxDC))
            this.addFightLog(fightContext, string.format("无视防御触发，攻击力%.2f=(小攻%.2f~大攻%.2f)", finalDC, minDC, maxDC))
        elseif this.IsZhuoYueYiJi(actor, target) then
            fightContext.isZhuoYueYiJi = true
            -- 大攻 *1.2 + 卓越一击伤害
            finalDC = maxDC * 1.2 + getattrinfo(actor, "excellentFixedDamage")
            this.addFightLog(fightContext, string.format("卓越一击触发，攻击力%.2f=大攻%.2f*1.2 + 卓越一击伤害%.2f", finalDC, maxDC, getattrinfo(actor, "excellentFixedDamage")))
        elseif this.IsXingYunYiJi(actor, target) then
            -- 当次攻击力 = 大攻  + 幸运一击伤害 + 伤害提高
            fightContext.isXinYunYiJi = true
            finalDC = maxDC + getattrinfo(actor, "criticalFixedDamage") + getattrinfo(actor, "highatt")
            this.addFightLog(fightContext, string.format("幸运一击触发，攻击力%.2f=大攻%.2f + 幸运一击伤害%.2f + 伤害提高%.2f", finalDC, maxDC, getattrinfo(actor, "criticalFixedDamage"), getattrinfo(actor, "highatt")))
        else
            -- 当次攻击力 = 小攻~大攻之间随机一个值
            finalDC = math.random(math.floor(minDC), math.floor(maxDC))
            this.addFightLog(fightContext, string.format("普通攻击，攻击力%.2f=(小攻%.2f~大攻%.2f)", finalDC, minDC, maxDC))
        end

        -- 双倍一击及倍率
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

        if castType == MapObjectType.PLAYER and targetType == MapObjectType.MONSTER then
            --玩家打怪
            --伤害=（攻击-怪物防御）*职业的技能攻击力提升比例*（1+翅膀的"伤害提高"）*双倍一击的倍率
            local skillDamagPro = this.calSkillDamagPro(actor, attackPowerBonus, injuryType)
            local wingdamageRate = getattrinfo(actor, "wingdamageRate")
            local casterignoreMonsterDefenseRate = getattrinfo(actor, "ignoreMonsterDefenseRate")
            local ignoreMonsterDefenseNum = casterignoreMonsterDefenseRate * armor
            local roleLevel = getbaseinfo(target, "level")
            originDamage = ((roleLevel / 10) + finalDC - (armor - ignoreMonsterDefenseNum)) * skillDamagPro * skillPowerRate * (1 + wingdamageRate) * shuangBeiMultiplier
            this.addFightLog(fightContext, string.format("玩家打怪伤害计算：(%.2f-(%.2f-%.2f))*%.2f*%.4f*(1+%.2f)*%.2f=%.2f", finalDC, armor, ignoreMonsterDefenseNum, skillDamagPro, skillPowerRate, wingdamageRate, shuangBeiMultiplier, originDamage))
        elseif castType == MapObjectType.MONSTER and targetType == MapObjectType.PLAYER then
            --怪打玩家
            --伤害=（怪物攻击- 防御/2）*（1-总的“伤害吸收”）*（1-总的“伤害减少”）
            local damageAbsorb = getattrinfo(target, "damageAbsorb")
            local damageDecrement = getattrinfo(target, "damageDecrement")
            local roleLevel = getbaseinfo(target, "level")
            originDamage = ((roleLevel / 10) + finalDC - armor / 2) * (1 - damageAbsorb) * (1 - damageDecrement)
            this.addFightLog(fightContext, string.format("怪物打玩家伤害计算：(%.2f-%.2f/2)*(1-%.2f)*(1-%.2f)=%.2f", finalDC, armor, damageAbsorb, damageDecrement, originDamage))
        elseif castType == MapObjectType.PET and targetType == MapObjectType.PLAYER then
            originDamage = math.max(0, finalDC - armor / 2)
        elseif castType == MapObjectType.PET and targetType == MapObjectType.MONSTER then
            originDamage = math.max(0, finalDC - armor)
        else
            --玩家打玩家
            --伤害=（攻击-受击方的防御/2）*职业的技能攻击力提升比例*（1+翅膀的"伤害提高"）*（1-受击方总的"伤害吸收"）*（1-受击方总的"伤害减少"）*双倍一击的倍率
            local skillDamagPro = this.calSkillDamagPro(actor, attackPowerBonus, injuryType)
            local wingdamageRate = getattrinfo(actor, "wingdamageRate")
            local damageAbsorb = getattrinfo(target, "damageAbsorb")
            local damageDecrement = getattrinfo(target, "damageDecrement")
            local roleLevel = getbaseinfo(target, "level")
            originDamage = ((roleLevel / 10) + finalDC - armor / 2) * skillDamagPro * (1 + wingdamageRate) * (1 - damageAbsorb) * (1 - damageDecrement) * shuangBeiMultiplier
            this.addFightLog(fightContext, string.format("玩家打玩家伤害计算：(%.2f-%.2f/2)*%.2f*(1+%.2f)*(1-%.2f)*(1-%.2f)*%.2f=%.2f", finalDC, armor, skillDamagPro, wingdamageRate, damageAbsorb, damageDecrement, shuangBeiMultiplier, originDamage))
        end
        -- 指定技能伤害额外增加
        originDamage = this.calculateSkillDamageAdd(actor, fightContext, originDamage)
    end

    -- 命中率过低伤害衰弱
    if fightContext.isLowHitRate then
        this.addFightLog(fightContext, string.format("命中率过低，仅造成20%%的伤害，原始伤害%.2f -> %.2f", originDamage, originDamage * 0.2))
        originDamage = originDamage * 0.2
    end

    if originDamage <= 0 then
        --伤害小于等于0直接飘miss
        this.addFightLog(fightContext, "伤害小于等于0，直接判定为未命中")
        local result = this.buildFightResult(actor, target, 0, HurtType.MISS, 1, false, fightContext.fightLog)
        return { result }
    end

    -- 副本修正伤害
    originDamage = this.DupFixDamage(originDamage, paramMap)

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



    -- 伤害反弹和伤害反射
    if targetType == MapObjectType.PLAYER then
        -- 伤害反射百分百触发
        --A受到的伤害反射伤害 = A打B的伤害 * B的"伤害反射"
        local fanSheDamage = originDamage * math.min(getattrinfo(target, "damageReflex"), 0.7)
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
                this.addFightLog(fightContext, string.format("触发伤害反射，反射伤害%.2f = 原始伤害%.2f * 伤害反射%.2f", fanSheDamageAfterShield, originDamage, getattrinfo(target, "damageReflex")))
                table.insert(resultList, this.buildFightResult(target, actor, fanSheDamage, HurtType.FAN_SHE, 1, false, fightContext.fightLog))
            end
        end
        --伤害反弹几率触发
        local fanTanDamage = 0
        if this.SelectRate(getattrinfo(target, "damageRebound")) then
            if castType == MapObjectType.MONSTER then
                --反弹伤害=怪物最大攻击力
                fanTanDamage = maxDC
            elseif castType == MapObjectType.PLAYER then
                --反弹伤害=受击方受到的伤害
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

    -- 后处理原始伤害
    this.afterCalcuDamageBeforeShield(actor, target, castType, targetType, totalTargetHurtBeforeShield)
    this.afterCalcuDamageBeforeShield(target, actor, targetType, castType, totalCasterHurtBeforeShield)

    -- 被攻击(不含反射反弹)处理
    this.beAttacked(target, actor, targetType, castType)

    return resultList
end

function this.canHit(actor, fightContext)
    local castType = fightContext.castType
    local targetType = fightContext.targetType
    local target = fightContext.target

    -- 检查是否攻击自己的宠物
    if this.IsSelfPet(actor, target) then
        this.addFightLog(fightContext, "攻击自己宠物无效")
        return false
    end

    -- 检查PK值是否可以攻击
    if not this.pkValueCanHit(actor, castType, targetType) then
        return false
    end

    -- 检查是否在和平线
    if this.isPeaceLine(actor, castType, targetType) then
        return false
    end


    -- 检查攻城战是否可以攻击
    if not RolandSeige.CanAttackRolandWall(actor, target, castType, targetType) then
        return false
    end

    -- 检查命中率
    if this.selectHitRate(fightContext) == false then
        this.addFightLog(fightContext, "未命中！")
        return false
    end

    -- 所有验证通过
    return true
end

function this.calculateSkillDamageAdd(actor, fightContext, originDamage)
    local killerType = getbaseinfo(actor, "mapobjecttype")
    if tonumber(killerType) ~= MapObjectType.PLAYER then
        return originDamage
    end
    local skillExtraDamageAdd = string.tonumber(getattrinfo(actor, "skillExtraDamageAdd"))
    if skillExtraDamageAdd < 1 then
        return originDamage
    end
    -- 从global获取技能蓝量消耗配置 "技能id#扣除蓝量|技能id#扣除蓝量"
    local configStr = ConfigDataManager.getGlobal(920002)
    
    local skillMpCostMap = string.toIntIntMap(configStr, "#", "|")
    if table.isEmpty(skillMpCostMap) then
        return originDamage
    end

    local skillId = string.tonumber(fightContext.skillId)
    local mpCost = skillMpCostMap[skillId]
    if mpCost == nil or mpCost < 1 then
        return originDamage
    end
    local currentMp = getbaseinfo(actor, "mp")
    if currentMp < mpCost then
        return originDamage
    end

    -- 扣除蓝量
    local newMp = currentMp - mpCost
    setmp(actor, newMp)

    -- 应用伤害加成
    originDamage = originDamage + skillExtraDamageAdd
    this.addFightLog(fightContext, string.format("总伤害%.2f=%.2f + %.2f", originDamage, originDamage - skillExtraDamageAdd, skillExtraDamageAdd))
end

function this.calSkillDamagPro(actor, powerIncrese, injuryType)
    local skillDamagPro = getattrinfo(actor, "skillDamagPro")
    -- 职业技能攻击力提升比例 = 属性转化(职业技能攻击力提升比例) + 40% * 战斗威力加成	
    return skillDamagPro + 0.4 * powerIncrese
end

function this.isPeaceLine(actor, castType, targetType)
    if castType == MapObjectType.PLAYER and targetType == MapObjectType.PLAYER then
        local dupInfo = getduplicate(getbaseinfo("unimapid"))
        if dupInfo == nil then
            -- 获取当前地图ID和线路
            local mapId = getbaseinfo(actor, "mapid")
            local line = getbaseinfo(actor, "line")

            -- 检查当前地图线路是否为和平线路
            local peaceLines = ConfigDataManager.getTableValue("cfg_map_line", "peaceline", "id", mapId)

            if not string.isNullOrEmpty(peaceLines) then
                local peaceLineList = string.split(peaceLines, "#")
                for _, peaceLine in pairs(peaceLineList) do
                    if tonumber(line) == tonumber(peaceLine) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

function this.beAttacked(selfActor, caster, selfType, castType)
    if selfType == MapObjectType.PLAYER then
        local nowSec = getbaseinfo(selfActor, "nowsec")
        local rate = getattrinfo(selfActor, "shengminghuifuRate")
        if this.SelectRate(rate) then
            local oldEndTime = getplaydef(selfActor, "@be_attacked_recover_hp_cd") or 0
            if nowSec >= oldEndTime then
                -- 被攻击回满血
                local maxHP = getattrinfo(selfActor, "maxhp")
                local cd = ConfigDataManager.getTableValue("cfg_global", "value", "id", "510001")
                setplaydef(selfActor, "@be_attacked_recover_hp_cd", nowSec + tonumber(cd))
                sethp(selfActor, maxHP)
            end
        end

        if this.SelectRate(getattrinfo(selfActor, "probabilityOfBeingAttackedAndFullyRestoringMagicPoints")) then
            local oldEndTime = getplaydef(selfActor, "@be_attacked_recover_mp_cd") or 0
            if nowSec >= oldEndTime then
                -- 被攻击回满蓝
                local maxHP = getattrinfo(selfActor, "maxmp")
                local cd = ConfigDataManager.getTableValue("cfg_global", "value", "id", "510002")
                setplaydef(selfActor, "@be_attacked_recover_mp_cd", nowSec + tonumber(cd))
                setmp(selfActor, maxHP)
            end
        end
    end
end

function this.afterCalcuDamageBeforeShield(caster, target, castType, targetType, targetHurtBeforeShield)
    if castType == MapObjectType.PLAYER and targetType == MapObjectType.MONSTER then
        local monsterId = getbaseinfo(target, "configid")
        -- 保存战盟boos造成伤害的玩家
        WarAlliance.savePlayerInvloveInfo(caster, target, targetHurtBeforeShield, monsterId)
    end
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

    -- 根据攻击者和受击者类型确定使用的属性
    if castType == MapObjectType.MONSTER or targetType == MapObjectType.MONSTER then
        -- PvE战斗使用hitRate和missRate属性
        hitRate = getattrinfo(caster, "hitRate")
        missRate = getattrinfo(target, "missRate")
    else
        -- PvP战斗使用pvpattackRate和eraRate属性
        hitRate = getattrinfo(caster, "attackRatePK")
        missRate = getattrinfo(target, "eraRatePK")
    end
    this.addFightLog(fightContext, "攻击率为" .. hitRate .. ", 目标防御率为" .. missRate)
    -- 计算命中概率
    local probability
    if hitRate > missRate then
        probability = 1 - missRate / hitRate
    else
        -- 命中率过低时设置标记，并使用固定30%概率
        fightContext.isLowHitRate = true
        probability = 0.3
        -- 对于人打怪且命中率过低的情况，直接判定为未命中
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

function this.IsXingYunYiJi(actor, target)
    local rate = getattrinfo(actor, "criticalDamageChance")
    local targetRate = getattrinfo(target, "criticalDamageResistanceChance")
    local maxRate = tonumber(ConfigDataManager.getGlobal(870002)) / 10000
    rate = rate * (1 - targetRate)
    return this.SelectRate(math.min(rate, maxRate))
end

function this.IsShuangBeiYiJi(actor, target)
    local rate = getattrinfo(actor, "doubleDamageChance")
    local targetRate = getattrinfo(target, "doubleDamageResistanceChance")
    rate = rate * (1 - targetRate)
    return this.SelectRate(rate)
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
        local maxDC = getattrinfo(caster, "maxDC")
        local maxMC = getattrinfo(caster, "maxMC")
        local maxCurDC = getattrinfo(caster, "maximumCurseAttackPower")
        if maxDC >= maxMC and maxDC >= maxCurDC then
            local minDC = getattrinfo(caster, "minDC")
            return minDC, maxDC, injuryType
        elseif maxMC >= maxDC and maxMC >= maxCurDC then
            local minMC = getattrinfo(caster, "minMC")
            return minMC, maxMC, injuryType
        elseif maxCurDC >= maxDC and maxCurDC >= maxMC then
            local minCurDC = getattrinfo(caster, "minimumCurseAttackPower")
            return minCurDC, maxCurDC, injuryType
        end
        return 0, 0, injuryType
    end
end

function this.DupFixDamage(originDamage, paramMap)
    local caster = paramMap.caster
    local targetType = paramMap.targettype
    if targetType == MapObjectType.MONSTER then
        if RolandSeige.IsPlayerInRoland(caster) then
            return 1
        end
    end
    return originDamage
end

function this.addFightLog(fightContext, text)
    isDebug = isDebug or getenv("debug")
    if isDebug then
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
    result["targethurtshow"] = math.ceil(targetHurt) --飘字体用的伤害
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
    result["targethurtshow"] = shiled --飘字体用的伤害
    result["fightLog"] = {}
    return result
end

---玩家战斗触发
function PlayerFight.AttackTrigger(actor, fightRet)
    this.UpdateFightTask(actor, fightRet)
end

---更新战斗相关任务
function this.UpdateFightTask(actor, fightRet)
    local taskCfgList = ConfigDataManager.getTable("cfg_task_target", "taskgoaltype", TaskTargetType.HURT_MAP_MONSTER)
    if table.isNullOrEmpty(taskCfgList) then
        return
    end
    local targetHurt = tonumber(fightRet["targethurt"])
    local mapCfgId = tonumber(fightRet["mapcfgid"])
    local targetCfgId = tonumber(fightRet["targetcfgid"])
    local flush = false
    for _, taskCfg in pairs(taskCfgList) do
        local monsterLimit = tonumber(taskCfg["taskgoalparam"])
        local mapLimit = tonumber(taskCfg["taskgoalparam2"])
        if targetCfgId == monsterLimit and mapCfgId == mapLimit then
            flush = true
            break
        end
    end
    -- 触发刷新任务
    if flush then
        local taskParam = {
            monsterid = targetCfgId,
            mapid = mapCfgId,
            hurt = targetHurt
        }
        -- 触发任务目标
        TaskHandler.TriggerTaskGoal(actor, TaskTargetType.HURT_MAP_MONSTER, taskParam)
    end
end

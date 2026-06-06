Skill = {}
local this = {}

-- 计算连击值
function Skill.calculationComboValue(actor, skillCfgId, skillLevel, skill)
    local growthFactor = ConfigDataManager.getTableValue("cfg_skill_info", "growthFactor", "skillID", skillCfgId, "skillLevel", skillLevel)
    local comboValue = ConfigDataManager.getTableValue("cfg_skill", "comboValue", "id", skill)
    if string.isNullOrEmpty(comboValue) or string.isNullOrEmpty(growthFactor) then
        return 0
    end
    local add = math.ceil(tonumber(comboValue) * tonumber(growthFactor) / 10000)
    return add
end

-- 添加连击技能
function Skill.ComboSkillUp(actor)
    local comboSkill = getrolefield(actor, "role.roleskill.comboskill")
    local skillLv = comboSkill.skillLv
    local skillCfgId = comboSkill.skillCfgId
    if skillCfgId == 0 then
        local comboSkillInfo = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.COMBO_SKILL_INFO)
        -- error(comboSkillInfo)
        local baseCareer = getbaseinfo(actor, "getbasecareer")
        local comboSkillTable = string.split(comboSkillInfo, "|")
        for index, careerComboSkill in pairs(comboSkillTable) do
            local careerComboSkillInfo = string.split(careerComboSkill, "#")
            if tonumber(careerComboSkillInfo[1]) == tonumber(baseCareer) then
                skillCfgId = tonumber(careerComboSkillInfo[2])
            end
        end
        skillLv = 0
    end
    skillLv = skillLv + 1
    local skillInfo = ConfigDataManager.getTable("cfg_skill_info", "skillID", skillCfgId, "skillLevel", skillLv)
    if table.isEmpty(skillInfo) then
        -- error("没有找到连击技能的配置信息")
        return
    end
    local skill = skillInfo[1]
    local skillLevelUpItemID = skill.skilllevelupitemid
    if not string.isNullOrEmpty(skillLevelUpItemID) then
        local skillLevelUpItemTable = string.split(skillLevelUpItemID, "|")
        local cost = {}
        for index, skillLevelUpItem in pairs(skillLevelUpItemTable) do
            local itemInfo = string.split(skillLevelUpItem, "#")
            local itemCfgId = tonumber(itemInfo[1])
            local count = tonumber(itemInfo[2])
            local have = getbagitemcountbyid(actor, itemCfgId)
            if have < count then
                tipinfo(actor, "连击技能已经提升到最高等级，无法再升级了")
                -- noticeTip.noticeinfo(actor, StringIdConst.TEXT346)
                return
            end
            cost[tostring(itemCfgId)] = count
        end
        for index, costCount in pairs(cost) do
            removeitemfrombag(actor, index, costCount, 0, 9999, '连击技能')
        end
    end

    local nextSkillLevel = skillLv
    addcomboskill(actor, skillCfgId, nextSkillLevel)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.ACTIVATE_COMBO_SKILL)
    local rid = getbaseinfo(actor, "rid")
    sendrefluamsg(actor, LuaMessageIdToClient.RES_COMBO_SKILL_MODEL_VIEW, { tostring(rid), tostring(skillCfgId), tostring(skillLv) })
end

-- 玩家进入是也发送连击技能视野包
function Skill.playerequipview(actor, targetPlayer)
    local comboSkill = getrolefield(targetPlayer, "role.roleskill.comboskill")
    local skillLv = comboSkill.skillLv
    local skillCfgId = comboSkill.skillCfgId
    if skillCfgId == 0 then
        return
    end
    local rid = getbaseinfo(targetPlayer, "rid")
    sendluamsg(actor, LuaMessageIdToClient.RES_COMBO_SKILL_MODEL_VIEW, { tostring(rid), tostring(skillCfgId), tostring(skillLv) })
end

-- 判断是不是连击技能
function Skill.isComboSkill(actor, skillId)
    local comboSkillInfo = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.COMBO_SKILL_INFO)
    local comboSkillTable = string.split(comboSkillInfo, "|")
    for index, careerComboSkill in pairs(comboSkillTable) do
        local careerComboSkillInfo = string.split(careerComboSkill, "#")
        if tonumber(careerComboSkillInfo[2]) == skillId then
            return true
        end
    end
    return false
end

--- 学习或升级技能
function Skill.levelUp(actor, skillInfo)
    if skillInfo == SkillConfigId.DEMON_HERMIT_SKILL_ID then
        levelupskill(actor, SkillConfigId.DEMON_HERMIT_COMMON_ONE_SKILL_ID, 1, 0)
        levelupskill(actor, SkillConfigId.DEMON_HERMIT_COMMON_TWO_SKILL_ID, 1, 0)
        levelupskill(actor, SkillConfigId.DEMON_HERMIT_COMMON_THREE_SKILL_ID, 1, 0)
    end
end

function skilltest(actor)
    Skill.releaseSkill(actor, SkillConfigId.DEMON_HERMIT_SKILL_ID)
end

--- 技能生效前触发
function Skill.releaseSkill(actor, skillid)
    if skillid == SkillConfigId.DEMON_HERMIT_SKILL_ID then
        setplaydef(actor, PlayerDefKey.skill.DEMON_HERMIT_SKILL, 1)
        local skillTable = { SkillConfigId.DEMON_HERMIT_COMMON_ONE_SKILL_ID, SkillConfigId.DEMON_HERMIT_COMMON_TWO_SKILL_ID, SkillConfigId.DEMON_HERMIT_COMMON_THREE_SKILL_ID }
        setskillopen(actor, skillTable, 1)
        --setskillopen(actor,SkillConfigId.DEMON_HERMIT_COMMON_ONE_SKILL_ID,1)
        --setskillopen(actor,SkillConfigId.DEMON_HERMIT_COMMON_TWO_SKILL_ID,1)
        --setskillopen(actor,SkillConfigId.DEMON_HERMIT_COMMON_THREE_SKILL_ID,1)
        SceneMap.sendEnterViewInfoByType(actor, SceneMap.viewKey.DEMON_HERMIT_SKILL, 1)
    end
end

--- 关闭恶灵召唤技能
function Skill.closeDemonHermitSkill(actor)
    local skill = getplaydef(actor, PlayerDefKey.skill.DEMON_HERMIT_SKILL)
    if skill and skill == 1 then
        local skillTable = { SkillConfigId.DEMON_HERMIT_COMMON_ONE_SKILL_ID, SkillConfigId.DEMON_HERMIT_COMMON_TWO_SKILL_ID, SkillConfigId.DEMON_HERMIT_COMMON_THREE_SKILL_ID }
        setskillopen(actor, skillTable, 0)
        --setskillopen(actor,SkillConfigId.DEMON_HERMIT_COMMON_TWO_SKILL_ID,0)
        --setskillopen(actor,SkillConfigId.DEMON_HERMIT_COMMON_THREE_SKILL_ID,0)
        SceneMap.sendEnterViewInfoByType(actor, SceneMap.viewKey.DEMON_HERMIT_SKILL, 0)
        setplaydef(actor, PlayerDefKey.skill.DEMON_HERMIT_SKILL, 0)
        info("关闭召唤恶灵")
    end
end
function Skill.addSkillCD(actor, skillId, skillLevel)
    -- 自定义公式加CD
    local skillInfoConfig = ConfigDataManager.getTableFirst("cfg_skill_info", "skillID", skillId, "skillLevel", skillLevel)
    if string.tonumber(skillInfoConfig.cdtype) == 1 then
        local skillCdMap = {}
        
        -- 获取基础CD值
        local baseCd = string.tonumber(skillInfoConfig.skillcd)
        
        -- 获取攻击速度相关参数
        local anispeed = getattrinfo(actor, "AniattackSpeed")
        
        -- 获取魔法攻击速度相关参数
        local aniSpeedMagic = getattrinfo(actor, "AniSpeedMagic")
        
        -- 获取速度对技能CD的影响系数
        local speedSkillCdFactor = string.toDouble(skillInfoConfig.speedskillcd)
        
        -- 获取魔法速度对技能CD的影响系数
        local magicSpeedSkillCdFactor = string.toDouble(skillInfoConfig.magicspeedskillcd)
        
        -- 计算速度对CD的影响
        local speedCdReduction = anispeed * speedSkillCdFactor / 10000
        
        -- 计算魔法速度对CD的影响
        local magicSpeedCdReduction = aniSpeedMagic * magicSpeedSkillCdFactor / 10000
        
        -- 计算总的速度修正系数
        local totalSpeedFactor = 1 + speedCdReduction + magicSpeedCdReduction
        
        -- 计算最终CD
        local cd = baseCd / totalSpeedFactor
        
        -- 向上取整
        cd = math.ceil(cd)
        
        local nowMillis = getbaseinfo("now")
        table.insert(skillCdMap, { skillid = skillId, endtime = nowMillis + cd })

        local commonCd = string.tonumber(skillInfoConfig.commoncdout)
        if commonCd > 0 then
            local allSkill = getplayskilllist(actor, -1, 1)
            for _, skillInfo in pairs(allSkill) do
                if skillInfo.id ~= skillId then
                    -- 对公共CD也应用相同的公式
                    local commonCdReduction = anispeed * speedSkillCdFactor / 10000 + aniSpeedMagic * magicSpeedSkillCdFactor / 10000
                    local adjustedCommonCd = commonCd / (1 + commonCdReduction)
                    adjustedCommonCd = math.ceil(adjustedCommonCd)
                    table.insert(skillCdMap, { skillid = skillInfo.id, endtime = nowMillis + adjustedCommonCd })
                end
            end
        end
        addcdbyskilllist(actor, skillCdMap)
    end
end





function Skill.playerEnterView(actor, targetActor)
    -- 获取攻击速度
    local anispeed = getattrinfo(actor, "AniattackSpeed")
    -- 获取魔法攻击速度
    local aniSpeedMagic = getattrinfo(actor, "AniSpeedMagic")
    local attr = {}
    local id1 = attrname2id("AniattackSpeed")
    local id2 = attrname2id("AniSpeedMagic")
    attr[id1] = anispeed
    attr[id2] = aniSpeedMagic
    sendluamsg(actor, LuaMessageIdToClient.RES_ATK_SPEED_ATTR, { rid = targetActor:toString(), attr = attr })
end


function Skill.attrUpdated(actor)
    -- 获取攻击速度
    local anispeed = getattrinfo(actor, "AniattackSpeed")
    -- 获取魔法攻击速度
    local aniSpeedMagic = getattrinfo(actor, "AniSpeedMagic")
    local lastAttr = getplaydef(actor, "T$_last_atk_speed_attr") or { 0, 0 }
    local lastAnispeed = lastAttr[1]
    local lastAniSpeedMagic = lastAttr[2]
    if lastAnispeed ~= anispeed or lastAniSpeedMagic ~= aniSpeedMagic then
        local attr = {}
        local id1 = attrname2id("AniattackSpeed")
        local id2 = attrname2id("AniSpeedMagic")
        attr[id1] = anispeed
        attr[id2] = aniSpeedMagic
        setplaydef(actor, "T$_last_atk_speed_attr", { anispeed, aniSpeedMagic })
        sendrefluamsg(actor, LuaMessageIdToClient.RES_ATK_SPEED_ATTR, { rid = actor:toString(), attr = attr })
    end
end

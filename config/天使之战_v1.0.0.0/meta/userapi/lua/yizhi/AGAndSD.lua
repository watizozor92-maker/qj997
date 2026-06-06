--todo 洗点需要重置


AGAndSD = {}
local this = AGAndSD;
local filename = "AGAndSD";
this.msgId = 90001034               --data [1]类型 0数据通知 l当前sd变化
local curSDVar = VarCfg.ZC_CurSDVar --当前SD值
local MaxSDVar = VarCfg.ZC_MaxSDVar --最大SD值
local CurAGVar = VarCfg.ZC_CurAGVar --当前AG值
local MaxAGVar = VarCfg.ZC_MaxAGVar --最大AG值

-- SD职业加成倍率
local SDCareerRate = {
    [1] = 1, -- 剑士
    [2] = 1, -- 法师
    [3] = 1, -- 弓箭
    [4] = 1, -- 魔剑士
    [5] = 1, -- 圣导师
    [6] = 1, -- 召唤术师
    [7] = 1, -- 光明法师
}

-- AG职业加成倍率
-- [1]=力量系数, [2]=敏捷系数, [3]=体力系数, [4]=智力系数, [5]=统率系数, [6]=除法标记
-- 当[6]=true时，对应系数表示除法分母，否则为乘法系数
local AGCareerRate = {
    [1] = {[1] = 0.15, [2] = 0.2, [3] = 0.3, [4] = 1.0},                                      -- 剑士: 力量×0.15 + 敏捷×0.2 + 体力×0.3 + 智力×1.0
    [2] = {[1] = 0.2, [2] = 0.4, [3] = 0.3, [4] = 0.2},                                       -- 法师: 力量×0.2 + 敏捷×0.4 + 体力×0.3 + 智力×0.2
    [3] = {[1] = 0.3, [2] = 0.2, [3] = 0.3, [4] = 0.2},                                       -- 弓箭: 力量×0.3 + 敏捷×0.2 + 体力×0.3 + 智力×0.2
    [4] = {[1] = 0.2, [2] = 0.25, [3] = 0.3, [4] = 0.15},                                     -- 魔剑士: 力量×0.2 + 敏捷×0.25 + 体力×0.3 + 智力×0.15
    [5] = {[1] = 3, [2] = 5, [3] = 10, [4] = 0.15, [5] = 3, [6] = true},                      -- 圣导师: 力量/3 + 敏捷/5 + 体力/10 + 智力×0.15 + 统率/3
    [6] = {[1] = 0.2, [2] = 3, [3] = 3, [4] = 0.15, [6] = true},                              -- 召唤术师: 力量×0.2 + 敏捷/3 + 体力/3 + 智力×0.15
    [7] = {[1] = 0.2, [2] = 0.4, [3] = 3, [4] = 0.2, [6] = true},                             -- 光明法师: 力量×0.2 + 敏捷×0.4 + 体力/3 + 智力×0.2
}

--ag和sd配置
AGAngSDConfig = {
    sdbilv_base = 9000,     --护盾基础比率配置 万分比
    sd_huifu_time = 5,      --sd恢复时间间隔
    ag_huifu_time = 3,      --ag恢复时间间隔
    podun_buff = 250001014, --破盾buff添加
};

---@return number,number 血量伤害，护盾扣减
function AGAndSD.calSDDeduction(caster, target, targetHurt)
    local curSD = API.GetInt(target, curSDVar);
    this.jprint(string.format("SD计算 --> 初始SD值 %.2f", curSD))
    if curSD <= 0 then
        return targetHurt, 0
    end
    local c_SDwushiRate = getattrinfo(caster, "SDwushiRate")     --攻击者sd的无视概率
    local t_dikangwushiSd = getattrinfo(target, "dikangwushiSd") --受击者的抵抗无视概率
    --判定是否可无视
    if c_SDwushiRate > t_dikangwushiSd then
        --无视成功
        if RandomUtil.isAttRateHit(c_SDwushiRate - t_dikangwushiSd) then
            return targetHurt, 0
        end
    end
    local adbilvRate = getattrinfo(target, "adbilvRate")                      --受击者SD比率
    local SDsubRate = getattrinfo(caster, "SDsubRate")                        --攻击者SD减少率
    local bilv = (AGAngSDConfig.sdbilv_base / 10000 + adbilvRate - SDsubRate) --最终比率
    local sd_hurt = targetHurt * bilv                                         --减少伤害
    local oldSdHurt = sd_hurt
    this.jprint(string.format("SD计算 --> 原始sd_hurt%.2f = 受到的伤害：%.2f * (9000 / 10000 + adbilvRate%.2f - SDsubRate%.2f)", oldSdHurt, targetHurt, adbilvRate, SDsubRate))
    if sd_hurt > targetHurt then
        sd_hurt = targetHurt;
    end
    --破盾
    if sd_hurt >= curSD then
        -- API.SendCenterMsg(target,"破盾了")
        sd_hurt = curSD
        curSD = 0;
        addbuff(target, AGAngSDConfig.podun_buff)
        this.jprint(string.format("SD计算 --> 破盾了 sd_hurt=curSD, sd_hurt%.2f，curSD %.2f", sd_hurt, curSD))
    else
        sd_hurt = math.floor(sd_hurt)
        curSD = curSD - sd_hurt;
        this.jprint(string.format("SD计算 --> 未破盾 curSd=curSd-sd_hurt, sd_hurt%.2f，curSD %.2f", sd_hurt, curSD))
    end
    targetHurt = targetHurt - sd_hurt
    API.SetInt(target, curSDVar, curSD)
    sendrefluamsg(target, this.msgId, { target:toString(), 1, curSD })
    this.jprint(string.format("SD计算 --> 最终伤害：%.2f，最终SD值%.2f", targetHurt, curSD))
    return targetHurt, sd_hurt
end

function AGAndSD.calSDMonsterDeduction(caster, target, targetHurt)
    local maxSD = API.GetInt(caster, MaxSDVar);
    local hudunValue = getattrinfo(target, "hudunValue")
    if hudunValue < 1 or maxSD < hudunValue then
        return targetHurt, 0
    end
    
    local baseCareer = getbaseinfo(actor, "getbasecareer")

    local maxDC = 0
    if baseCareer == 1 or baseCareer == 3 then
        maxDC = getattrinfo(actor, "maxDC")
    else
        maxDC = getattrinfo(actor, "maxMC")
    end
    -- SD额外伤害 = (角色攻击力 × 0.3) + (最终SD值 - 怪物SD防御值) × 5
    targetHurt = targetHurt + (maxDC * 0.3) + (maxSD - hudunValue) * 5
    return targetHurt, 0
end

--伤害
GameEvent.add(EventCfg.onAttackAGAndSD, function(paramMap, fightResult, extra_result)
    local actor = paramMap.caster                 --—— 攻击对象
    local target = paramMap.target                --—— 受击对象
    local casthurt = fightResult.casthurt         --攻击者伤害
    local targethurt = fightResult.targethurt     --受击者伤害
    local castershield = fightResult.castershield --攻击者者扣除护盾
    local targetshield = fightResult.targetshield --受击者扣除护盾
    local castertype = getbaseinfo(actor, "mapobjecttype")
    local targettype = getbaseinfo(target, "mapobjecttype")
    -- info("onAttackAGAndSD",castertype,targettype)
    if castertype ~= MapObjectType.PLAYER or targettype ~= MapObjectType.PLAYER then
        --非PVP情况 不计算SD
        return
    end
    local curSD = API.GetInt(target, curSDVar);
    if curSD <= 0 then
        return
    end
    -- info("原伤害",targethurt,casthurt)
    local c_SDwushiRate = getattrinfo(actor, "SDwushiRate")     --攻击者sd的无视概率
    local t_dikangwushiSd = getattrinfo(actor, "dikangwushiSd") --受击者的抵抗无视概率
    --判定是否可无视
    if c_SDwushiRate > t_dikangwushiSd then
        local randomValue = math.random(10000);
        --无视成功
        if randomValue < c_SDwushiRate - t_dikangwushiSd then
            return
        end
    end
    local c_SDwushiRate = getattrinfo(actor, "adbilvRate")                             --攻击者SD减少率
    local t_dikangwushiSd = getattrinfo(actor, "SDsubRate")                            --受击者SD比率
    local bilv = (AGAngSDConfig.sdbilv_base / 10000 + c_SDwushiRate - t_dikangwushiSd) --最终比率
    local sd_hurt = targethurt * bilv                                                  --减少伤害
    if sd_hurt > targethurt then
        sd_hurt = targethurt;
    end
    --破盾
    if sd_hurt >= curSD then
        -- API.SendCenterMsg(target,"破盾了")
        sd_hurt = curSD
        curSD = 0;
        addbuff(target, AGAngSDConfig.podun_buff)
    else
        sd_hurt = math.floor(sd_hurt)
        curSD = curSD - sd_hurt;
    end
    fightResult.targethurt     = targethurt - sd_hurt
    -- fightResult.targetshield = targetshield + sd_hurt

    local extar_fight          = table.copy(fightResult)
    extar_fight.hurttype       = 203
    extar_fight.targethurt     = 0;
    extar_fight.targethurtshow = sd_hurt;
    extar_fight.fightLog       = { "SD护盾显示飘字" .. extar_fight.targethurtshow }
    -- info(extar_fight)
    table.insert(extra_result, extar_fight)
    API.SetInt(target, curSDVar, curSD)
    sendrefluamsg(target, this.msgId, { target:toString(), 1, curSD })
end, filename)

--每秒心跳
GameEvent.add(EventCfg.onRoleseCond, function(actor)
    --sd
    local maxSD = API.GetInt(actor, MaxSDVar)
    local curSD = API.GetInt(actor, curSDVar)
    local baseCareer = getbaseinfo(actor, "getbasecareer")

    local hudunValue = getattrinfo(actor, "hudunValue")
    local sdMaxLimit = getPlayerMaxSDValue()
    hudunValue = math.min(hudunValue, sdMaxLimit)
    local buffRate = getattrinfo(actor, "buffRate")
    buffRate = math.max(buffRate, 1)
    local sdCareerRate = SDCareerRate[baseCareer] or 1

    -- 最终生效SD值 = 角色基础SD值 × 职业倍率 × 状态加成倍率（如BUFF、药水）最终生效SD值的上限为200
    local finalHudunValue = hudunValue * buffRate * sdCareerRate

    local is_change = false;
    if finalHudunValue ~= maxSD then
        curSD = math.min(curSD + finalHudunValue - maxSD, finalHudunValue)
        maxSD = finalHudunValue;
        is_change = true;
    end

    local SDyewaihuivValue = getattrinfo(actor, "SDyewaihuivValue")
    local SDyewaihuivRate = getattrinfo(actor, "SDyewaihuivRate")
    if curSD < maxSD and (SDyewaihuivValue > 0 or SDyewaihuivRate > 0) then
        local nowsec = getbaseinfo(actor, "nowsec")
        local last_huifu_time = API.GetInt(actor, VarCfg.ZC_SDTime, 1)
        if last_huifu_time + AGAngSDConfig.sd_huifu_time <= nowsec then
            API.SetInt(actor, VarCfg.ZC_SDTime, nowsec, 1)
            local huifu_count = SDyewaihuivValue + math.ceil(maxSD * SDyewaihuivRate)
            curSD = math.min(curSD + huifu_count, maxSD)
            is_change = true
        end
    end

    --AG
    local curAG = API.GetInt(actor, CurAGVar);
    local maxAG = API.GetInt(actor, MaxAGVar);
    
    -- 如果为空 默认使用法师数据
    local agCareerRate = AGCareerRate[baseCareer] or AGCareerRate[2]

    local strength = getattrinfo(actor, "strength")
    local agility = getattrinfo(actor, "agility")
    local constitution = getattrinfo(actor, "stamina")
    local intelligence = getattrinfo(actor, "intelligence")
    local leadership = getattrinfo(actor, "command") -- 统率，圣导师专用

    -- 计算各属性对AG的贡献
    local function calcAttrContribution(value, rate, isDivision)
        if isDivision then
            return rate > 0 and (value / rate) or 0
        else
            return value * rate
        end
    end

    local isDivision = agCareerRate[6] or false
    local agFromStrength = calcAttrContribution(strength, agCareerRate[1], isDivision)
    local agFromAgility = calcAttrContribution(agility, agCareerRate[2], isDivision)
    local agFromConstitution = calcAttrContribution(constitution, agCareerRate[3], isDivision)
    local agFromIntelligence = calcAttrContribution(intelligence, agCareerRate[4], false)  -- 智力始终是乘法

    -- 圣导师有统率加成
    local agFromLeadership = 0
    if agCareerRate[5] then
        agFromLeadership = calcAttrContribution(leadership, agCareerRate[5], isDivision)
    end

    -- 最终生效AG值 = 属性计算值 + agValue属性
    local agValue = getattrinfo(actor, "agValue")
    agValue = agFromStrength + agFromAgility + agFromConstitution + agFromIntelligence + agFromLeadership + agValue
    if agValue ~= maxAG then
        maxAG = agValue;
        curAG = math.min(curAG + agValue - maxAG, agValue)
        is_change = true;
    end

    local agAutomaticReply = getattrinfo(actor, "agAutomaticReply")
    local agValueIncrease = getattrinfo(actor, "agValueIncrease")
    local agValueIncreaserate = getattrinfo(actor, "agValueIncreaserate")

    if curAG < maxAG then
        local nowsec = getbaseinfo(actor, "nowsec")
        local last_huifu_time = API.GetInt(actor, VarCfg.ZC_AGTime, 1)
        if last_huifu_time + AGAngSDConfig.ag_huifu_time <= nowsec then
            API.SetInt(actor, VarCfg.ZC_AGTime, nowsec, 1)
            -- 每秒 AG 恢复（向下取整） = 职业基础值 × (1 + 装备加成 % + 技能加成 %) × (1 + 加点增益 % + 大师技能增益 %)
            local huifu_count = math.ceil(agAutomaticReply * (1 + agValueIncrease) * (1 + agValueIncreaserate))
            this.jprint(string.format("SD恢复 --> AG恢复(向下取整) %.2f = %.2f职业基础值 x (1+ %.2f加成 ) x (1+ %.2f加点增益)", huifu_count, agAutomaticReply, agValueIncrease, agValueIncreaserate))
            curAG = math.min(curAG + huifu_count, maxAG)
            is_change = true
        end
    end

    if is_change then
        API.SetInt(actor, MaxSDVar, maxSD)
        API.SetInt(actor, curSDVar, curSD)
        API.SetInt(actor, CurAGVar, curAG)
        API.SetInt(actor, MaxAGVar, maxAG)
        sendrefluamsg(actor, this.msgId, { actor:toString(), 0, curSD, maxSD, curAG, maxAG })
    end
end, filename)

--玩家登录
GameEvent.add(EventCfg.onLoginEnd, function(actor)
    local curSD = API.GetInt(actor, curSDVar);
    local maxSD = API.GetInt(actor, MaxSDVar);
    local curAG = API.GetInt(actor, CurAGVar);
    local maxAG = API.GetInt(actor, MaxAGVar);
    sendrefluamsg(actor, this.msgId, { actor:toString(), 0, curSD, maxSD, curAG, maxAG })
end, filename)

--复活回复满SD和AG
GameEvent.add(EventCfg.onRevival, function(actor)
    AGAndSD.SetCurSD(actor, API.GetInt(actor, MaxSDVar))
    AGAndSD.SetCurAG(actor, API.GetInt(actor, MaxAGVar))
end, filename)

--怪物死亡
GameEvent.add(EventCfg.onKillMon, function(actor, monsterId, monsterCfgId, monsterName, pointX, pointY, activityId, monsterLevel, mongenCfgId)
    local shaguaihuiSDValue = getattrinfo(actor, "shaguaihuiSDValue")
    local shaguaihuiSDRate = getattrinfo(actor, "shaguaihuiSDRate")
    if shaguaihuiSDValue > 0 or shaguaihuiSDRate > 0 then
        local maxSD = API.GetInt(actor, MaxSDVar)
        local curSD = API.GetInt(actor, curSDVar)
        if curSD < maxSD then
            local huifu_count = shaguaihuiSDValue + math.ceil(maxSD * shaguaihuiSDRate)
            curSD = curSD + huifu_count
            AGAndSD.SetCurSD(actor, curSD)
        end
    end

    local shaguaihuiAGValue = getattrinfo(actor, "shaguaihuiAGValue")
    if shaguaihuiAGValue > 0 then
        local maxAG = API.GetInt(actor, MaxAGVar)
        local curAG = API.GetInt(actor, CurAGVar)
        if curAG < maxAG then
            local finalAG = math.min(maxAG, curAG + shaguaihuiAGValue)
            AGAndSD.SetCurAG(actor, finalAG)
        end
    end
end, filename)

--切换加点后
function AGAndSD.setSDAndAGAfterJiaidan(actor)
    local agValue = getattrinfo(actor, "agValue")
    local hudunValue = getattrinfo(actor, "hudunValue")
    API.SetInt(actor, MaxSDVar, hudunValue)
    API.SetInt(actor, curSDVar, hudunValue)
    API.SetInt(actor, CurAGVar, agValue)
    API.SetInt(actor, MaxAGVar, agValue)
    sendrefluamsg(actor, this.msgId, { actor:toString(), 0, hudunValue, hudunValue, agValue, agValue })
end

--设置当前sd 并同步客户端
function AGAndSD.SetCurSD(actor, SD)
    local maxSD = API.GetInt(actor, MaxSDVar)
    if SD > maxSD then
        SD = maxSD
    end
    API.SetInt(actor, curSDVar, SD)
    -- info("数据同步")
    sendrefluamsg(actor, this.msgId, { actor:toString(), 1, SD })
end

--获取当前sd以及最大sd
function AGAndSD.GetSD(actor)
    return API.GetInt(actor, curSDVar), API.GetInt(actor, MaxSDVar)
end

--设置当前AG 并同步客户端
function AGAndSD.SetCurAG(actor, AG)
    local maxSD = API.GetInt(actor, MaxAGVar)
    if AG > maxSD then
        AG = maxSD
    end
    API.SetInt(actor, CurAGVar, AG)
    -- info("数据同步",AG)
    sendrefluamsg(actor, this.msgId, { actor:toString(), 2, AG })
end

--获取当前AG以及最大AG
function AGAndSD.GetAG(actor)
    return API.GetInt(actor, CurAGVar), API.GetInt(actor, MaxAGVar)
end

function AGAndSD.CanRelease(actor, skillid, skilllevel)
    local curAG = API.GetInt(actor, CurAGVar);
    local consumeAG = ConfigDataManager.getTableValue("cfg_skill_info", "newConsumeAG", "skillID", skillid, "skillLevel", skilllevel)
    -- info("consumeAG1",type(consumeAG),consumeAG)
    consumeAG = tonumber(consumeAG)
    -- info("consumeAG",type(consumeAG),consumeAG)
    if consumeAG then
        local agConsumeJianShao = getattrinfo(actor, "agConsumeJianShao")
        local agConsumeJianShaoBiLi = getattrinfo(actor, "agConsumeJianShaoBiLi")
        if agConsumeJianShao > 0 or agConsumeJianShaoBiLi > 0 then
            -- info("ag减少",agConsumeJianShao - consumeAG*agConsumeJianShaoBiLi)
            consumeAG = consumeAG - agConsumeJianShao - math.floor(consumeAG * agConsumeJianShaoBiLi)
        end
        if consumeAG > 0 then
            if consumeAG > curAG then
                API.SendCenterMsg(actor, "AG值不足")
                return false
            else
                AGAndSD.SetCurAG(actor, curAG - consumeAG)
            end
        end
    end
    return true
end

function AGAndSD.CanReleaseNoDeduction(actor, skillid, skilllevel)
    local curAG = API.GetInt(actor, CurAGVar);
    local consumeAG = ConfigDataManager.getTableValue("cfg_skill_info", "newConsumeAG", "skillID", skillid, "skillLevel", skilllevel)
    consumeAG = tonumber(consumeAG)
    if consumeAG then
        local agConsumeJianShao = getattrinfo(actor, "agConsumeJianShao")
        local agConsumeJianShaoBiLi = getattrinfo(actor, "agConsumeJianShaoBiLi")
        if agConsumeJianShao > 0 or agConsumeJianShaoBiLi > 0 then
            consumeAG = consumeAG - agConsumeJianShao - math.floor(consumeAG * agConsumeJianShaoBiLi)
        end
        if consumeAG > 0 then
            return curAG - consumeAG >= 0
        end
    end
    return true
end

-- 增加SD
function AGAndSD.addSDRate(actor, rate)
    local currentSD, currentMaxSD = AGAndSD.GetSD(actor)
    AGAndSD.SetCurSD(actor, currentSD + currentMaxSD * rate)
end

-- 增加AG
function AGAndSD.addAGRate(actor, rate)
    local currentAG, currentMaxAG = AGAndSD.GetAG(actor)
    AGAndSD.SetCurAG(actor, currentAG + currentMaxAG * rate)
end

-- 发送SD和AG
function AGAndSD.sendSDAndAG(actor)
    local curSD = API.GetInt(actor, curSDVar);
    local maxSD = API.GetInt(actor, MaxSDVar);
    local curAG = API.GetInt(actor, CurAGVar);
    local maxAG = API.GetInt(actor, MaxAGVar);
    sendrefluamsg(actor, this.msgId, { actor:toString(), 0, curSD, maxSD, curAG, maxAG })
end

function getPlayerMaxSDValue()
    local value = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.PLAYER_MAX_SD_VALUE)
    return string.tonumber(value)
end

this.log_open = false
this.log_name = "[AGAndSD]"

function this.jprint(...)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(this.log_name, ...)
end
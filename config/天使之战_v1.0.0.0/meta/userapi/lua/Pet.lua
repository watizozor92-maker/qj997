Pet = {}

local this = {}

function Pet.onCall(actor, petCfgId, petId)
    local attributeRole = ConfigDataManager.getTableValue("cfg_pet","attributerole","id", petCfgId)
    if string.isNullOrEmpty(attributeRole) then
        return
    end
    local mapId = getbaseinfo(actor, "unimapid")
    local petActor = getactor(petId, mapId)
    local attMap = string.toStringStringMap(attributeRole, "#", "|")
    for id, percent  in pairs(attMap) do
        local attrName = attrid2name(actor, id)
        local attrValue = getattrinfo(actor, attrName)
        local scale = tonumber(percent) / 10000
        local addValue = math.round( attrValue * scale)
 
        updateattrgroup(petActor, "master", attrName, addValue)
    end
    


    this.addPetBuff(petActor, petCfgId)
end

function this.addPetBuff(petActor, petCfgId)
    local buffId = ConfigDataManager.getTableValue("cfg_pet","buffid","id", petCfgId)
    if string.isNullOrEmpty(buffId) then
        return
    end
    local strBuffs = string.split(buffId, "|")
    local buffIds = {}
    --jprint("配置字段：", buffId, "竖线分隔结果：", strBuffs)
    for _, values in pairs(strBuffs) do
        local weights = string.toStringStringMap(values,"#","&")
        local buffCfgId = this.randomByWeight(weights)
        --jprint("weights：", weights, "随机结果：", buffCfgId)
        table.insert(buffIds, buffCfgId)
    end

    for _, buffCfgId in pairs(buffIds) do
        addbuff(petActor, buffCfgId, 1)
    end
    --jprint("召唤兽信息：",petActor,"添加召唤兽的buff成功：", buffId, "随机到的buff信息：", buffIds)
end

function this.randomByWeight(weights)
    local totalWeight = 0
    for _, weight in pairs(weights) do
        weight = tonumber(weight)
        totalWeight = totalWeight + weight
    end

    local randomValue = math.random(1, totalWeight)

    -- 遍历权重数组，找到对应的下标
    local accumulatedWeight = 0
    for i, weight in pairs(weights) do
        accumulatedWeight = accumulatedWeight + weight
        if randomValue <= accumulatedWeight then
            return i
        end
    end
end

function Pet.ClearPet(actor)
    local pets =  getpets(actor)
    if pets == nil then
        return
    end
    for _, petActor in pairs(pets) do
        local petInfo = getmonsterinfo(petActor)
        local petConfigId = petInfo["cfgid"]
        info("宠物配置信息",petConfigId)
        -- if tonumber(petConfigId) ~= tonumber(PetConstant.Tian_Ying) then
            removepet(petActor)
        -- end
    end
end

function Pet.PetDie(actor,monsterCfgId)
    local ai = ConfigDataManager.getTableValue("cfg_monster", "ai", "id", monsterCfgId)
    if ai == nil then
        error("updateMonsterReliveTime cfg_monster表ai字段为空 monsterCfgId：" .. monsterCfgId)
        return
    end
    local aiConfig = ConfigDataManager.getById("cfg_monster_ai", ai)
    if aiConfig == nil then
        error("updateMonsterReliveTime cfg_monster_ai为nil id：" .. ai)
        return
    end
    local deadDisappear = tonumber(aiConfig['deaddisappear'])
    if not string.isNullOrEmpty(deadDisappear) then
        local mills = tonumber(deadDisappear)
        local sec = mills / 1000
        if sec > 0 then
            info(sec .. "秒后移除召唤兽", actor)
            setontimer(actor, 3, sec)
        else
            sec = 1
            info(sec .. "秒后移除召唤兽", actor)
            setontimer(actor, 3, sec)
        end
    end
end

function ontimer3(actor)
    removepet(actor)
    info("移除召唤兽", actor)
end

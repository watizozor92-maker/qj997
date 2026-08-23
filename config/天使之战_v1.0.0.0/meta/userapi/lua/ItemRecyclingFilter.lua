ItemRecyclingFilter = {}
local this = {}
local filterType = {
    career = 3,
    strengthLevel = 5,
    appendLevel = 6,
    skill = 7,
    lucky = 8,
    gem = 9,
    equipReplace = 11,
}

local groups = {
    baiZhuang = '101',
    baoShi    = '102',
    zuoYue    = '103',
    jiNeng    = '104',
    suitEquip = '198',
}

function ItemRecyclingFilter.getCanRecycleIndexs(actor, itemRecoveryType, groupIds)
    local bagIndex = {}
    if table.isNullOrEmpty(itemRecoveryType) then
        return
    end

    local allItemInfo = getallbagiteminfo(actor)
    if table.isEmpty(allItemInfo) then
        return
    end

    local currentNum = API.GetInt(actor, VarCfg.ZC_TaskLoopNum) or 0
    local taskInfo = ConfigDataManager.getById("cfg_taskline", currentNum + 1)
    local currentCfgId = API.GetInt(actor, VarCfg.ZC_TaskLoopNeedCfgId)

    local handler = {
        [groups.baiZhuang] = this.checkBaiZhuang,
        [groups.baoShi] = this.checkBaoShi,
        [groups.zuoYue] = this.checkZuoYue,
        [groups.jiNeng] = this.checkJiNeng,
        [groups.suitEquip] = this.checkSuitEquip,
    }

    -- 遍历所有背包物品
    for _, itemInfo in pairs(allItemInfo) do
        local itemCfgId = itemInfo.cfgid
        if itemCfgId == 20750711 then
            info("物品ID:", itemCfgId)
        end
        if not this.medicineCanRecycling(actor, itemCfgId) then
            goto continue
        end
        local itemRecoveryGroup = ConfigDataManager.getTableValue("cfg_item", "recoverygroup", "id", itemCfgId)
        if not string.isNullOrEmpty(itemRecoveryGroup) and table.contains(groupIds, tostring(itemRecoveryGroup)) then
            local checker = handler[itemRecoveryGroup]
            if not checker then
                goto continue
            end
            local conditionIds = itemRecoveryType[tostring(itemRecoveryGroup)]
            local result = checker(actor, itemInfo, conditionIds)
            if result then
                if not table.isEmpty(taskInfo) then
                    -- 检查是否在循环任务中
                    local inTask = this.checkInTaskLoop(actor, taskInfo, itemInfo, currentCfgId)
                    if not inTask then
                        table.insert(bagIndex, itemInfo.bagindex)
                    end
                end
            end
        end
        ::continue::
    end
    lg("回收物品索引:", bagIndex)
    if table.isEmpty(bagIndex) then
        return
    end
    return bagIndex
end

function this.commonCheck(actor, itemInfo, conditionIds)
    local itemRecoveryGroup = ConfigDataManager.getTableValue("cfg_item", "recoverygroup", "id", itemInfo.cfgid)
    local recoveryTable = ConfigDataManager.getTable("cfg_recovery", "id", itemRecoveryGroup)
    if not recoveryTable or table.isEmpty(recoveryTable) then
        -- error(actor,"回收类型配置错误")
        return this.checkEquip(actor, itemInfo, conditionIds)
    end
    local equipext = EquipAndAppear.getItemExtData(actor, tonumber(itemInfo.id))
    if not table.isNullOrEmpty(equipext) then
        EquipAndAppear.SetItemExtData(actor, tonumber(itemInfo.id), {})
    end

    local recoveryInfo = recoveryTable[1]
    local materialString = recoveryInfo.material
    materialString = string.split(materialString, "|")
    for _, materialStr in pairs(materialString) do
        local material = string.splitInt(materialStr, "#")
        local len = table.count(material)
        if len == 3 then
            return true
        elseif len == 4 then
            local bind = material[1]
            local lockItem = ConfigDataManager.getTableValue("cfg_item", "lockitem", "id", itemInfo.cfgid)
            if bind == string.tonumber(lockItem) then
                return true
            end
        end
    end
end

function this.checkBaiZhuang(actor, itemInfo, conditionIds)
    -- if this.commonCheck(actor, itemInfo, conditionIds) then
    --     return true
    -- end
    return this.checkEquip(actor, itemInfo, conditionIds)
end

function this.checkEquip(actor, itemInfo, conditionIds)
    local itemCfgId = itemInfo.cfgid
    local types = this.getCheckTypes(conditionIds)

    if not types[filterType.equipReplace] then
        local putonEquips = getputonequipinfo(actor)
        local canUpgrade = this.CheckBagEquipIsBetter(actor, itemInfo, putonEquips)
        -- 如果装备可以提升，则不回收
        if canUpgrade then
            -- lg("装备可以提升", itemInfo.cfgid)
            return false
        end
    end

    if not types[filterType.skill] then
        local skillStr = this.GetEquipSkillShow(actor, itemInfo)
        if not string.isNullOrEmpty(skillStr) then
            -- lg("技能筛选不满足", itemInfo.cfgid, skillStr)
            return false
        end
    end

    if not types[filterType.lucky] then
        local lucky = this.GetEquipLuckyAttr(itemInfo)
        if table.count(lucky) > 0 then
            -- lg("幸运筛选不满足", itemInfo.cfgid, lucky)
            return false
        end
    end

    if types[filterType.career] then
        local screenCfgs = types[filterType.career]
        local job = ConfigDataManager.getTableValue("cfg_item", "job", "id", itemCfgId)
        -- if string.isNullOrEmpty(job) then
        --     lg("该道具没有职业", itemInfo.cfgid, job)
        --     return false
        -- end
        -- 遍历所有screenCfg，必须全部满足
        local allConditions = {}
        for i, screenCfg in ipairs(screenCfgs) do
            if not string.isNullOrEmpty(screenCfg.career) then
                local needJobs = string.split(screenCfg.career, "|")
                for _, needJob in ipairs(needJobs) do
                    local reqBaseCareer = string.splitInt(needJob, "#")[1]
                    local reqCareerRank = string.splitInt(needJob, "#")[2]
                    table.insert(allConditions, { reqBaseCareer, reqCareerRank })
                end
            end
        end
        if not table.isEmpty(allConditions) then
            local itemJobs = string.split(job, "|")
            local jobCount = table.count(itemJobs)
            for i, itemJob in ipairs(itemJobs) do
                local baseCareer = string.splitInt(itemJob, "#")[1]
                local careerRank = string.splitInt(itemJob, "#")[2]
                for _, condition in ipairs(allConditions) do
                    if condition[1] == baseCareer and condition[2] == careerRank then
                        jobCount = jobCount - 1
                        break
                    end
                end
                if jobCount <= 0 then
                    break
                end
            end
            if jobCount > 0 then
                -- lg("职业筛选不满足", itemCfgId, job, table.count(allConditions))
                return false
            end
        end
    else
        return false
    end

    if types[filterType.strengthLevel] then
        local screenCfg = types[filterType.strengthLevel]
        local strengthlevel = this.getEquipStrengthLevel(itemInfo)
        if strengthlevel > (string.tonumber(screenCfg.strengthlevel) or 0) then
            -- lg("强化等级筛选不满足", itemInfo.cfgid, strengthlevel, screenCfg.strengthlevel)
            return false
        end
    else
        local strengthlevel = this.getEquipStrengthLevel(itemInfo)
        if strengthlevel > 0 then
            -- lg("强化等级筛选不满足", itemInfo.cfgid, strengthlevel, screenCfg.strengthlevel)
            return false
        end
    end

    if types[filterType.appendLevel] then
        local screenCfg = types[filterType.appendLevel]
        local appendlevel = this.getEquipAppendLevel(itemInfo)
        if appendlevel > (string.tonumber(screenCfg.appendlevel) or 0) then
            -- lg("追加等级筛选不满足", itemInfo.cfgid, appendlevel, screenCfg.appendlevel)
            return false
        end
    else
        local appendlevel = this.getEquipAppendLevel(itemInfo)
        if appendlevel > 0 then
            -- lg("追加等级筛选不满足", itemInfo.cfgid, appendlevel, screenCfg.appendlevel)
            return false
        end
    end

    return true
end

function this.getCheckTypes(conditionIds)
    local types = {}
    for _, id in pairs(conditionIds) do
        local cfg = ConfigDataManager.getById("cfg_recovery_screen", id)
        local type = tonumber(cfg.type)
        if type ~= filterType.career then
            if types[type] then
                if tonumber(id) > tonumber(types[type].id) then
                    types[type] = cfg
                end
            else
                types[type] = cfg
            end
        else
            local arr = types[type] or {}
            table.insert(arr, cfg)
            types[type] = arr
        end
    end
    return types
end

function this.checkBaoShi(actor, itemInfo, conditionIds)
    local itemCfgId = itemInfo.cfgid
    if table.isEmpty(conditionIds) then
        return false
    end
    for _, id in pairs(conditionIds) do
        local gem = ConfigDataManager.getTableValue("cfg_recovery_screen", "gem", "id", id)
        gem = tonumber(gem)
        if itemCfgId == gem then
            return true
        end
    end
    return false
end

function this.checkZuoYue(actor, itemInfo, conditionIds)
    -- if this.commonCheck(actor, itemInfo, conditionIds) then
    --     return true
    -- end
    return this.checkEquip(actor, itemInfo, conditionIds)
end

function this.checkJiNeng(actor, itemInfo, conditionIds)
    return true
end

--套装
function this.checkSuitEquip(actor, itemInfo, conditionIds)
    -- if this.commonCheck(actor, itemInfo, conditionIds) then
    --     return true
    -- end
    return this.checkEquip(actor, itemInfo, conditionIds)
end

function this.checkInTaskLoop(actor, taskInfo, itemInfo, currentCfgId)
    local checkItemId = taskInfo.itemid
    local strpart = taskInfo.strpart
    local itemCfgId = itemInfo.cfgid

    if not string.isNullOrEmpty(checkItemId) then
        if currentCfgId > 0 and currentCfgId ~= itemCfgId then
            return false
        end
    elseif not string.isNullOrEmpty(strpart) then
        local strPart = ConfigDataManager.getTableValue("cfg_item", "strpart", "id", itemCfgId)
        if string.isNullOrEmpty(strPart) then
            return false
        end
        local match = false
        for _, value in pairs(string.split(strPart, "#")) do
            if string.contains(strpart, value) then
                match = true
                break
            end
        end
        if not match then
            return false
        end
    end
    local strengthlevel = taskInfo.qianghua
    local appendlevel = taskInfo.zhuijia
    local lucky = taskInfo.xingyun
    local excellent = taskInfo.zuoyue

    local itemAppendlevel = this.getEquipAppendLevel(itemInfo)
    local ItemStrengthlevel = this.getEquipStrengthLevel(itemInfo)
    local itemLucky = this.GetEquipLuckyAttr(itemInfo)
    local itemExcellentCount = this.GetEquipExcellentCount(itemInfo)

    local checkAppendLevel = itemAppendlevel >= tonumber(appendlevel)
    local checkStrengthLevel = ItemStrengthlevel >= tonumber(strengthlevel)
    local checkLucky = table.count(itemLucky) >= tonumber(lucky)
    local checkExcellentCount = itemExcellentCount >= tonumber(excellent)
    local check = checkAppendLevel and checkStrengthLevel and checkLucky and checkExcellentCount
    return check
end

-- 获取装备强化等级
function this.getEquipStrengthLevel(itemInfo)
    if itemInfo and itemInfo.luaextdata and itemInfo.luaextdata.strengthlv then
        return itemInfo.luaextdata.strengthlv or 0
    end
    return 0
end

-- 获取装备追加等级
function this.getEquipAppendLevel(itemInfo)
    if itemInfo and itemInfo.luaextdata and itemInfo.luaextdata.appendlv then
        return itemInfo.luaextdata.appendlv or 0
    end
    return 0
end

-- 获取装备幸运属性
function this.GetEquipLuckyAttr(itemInfo)
    if itemInfo and itemInfo.luaextdata and itemInfo.luaextdata.luckAttr then
        return itemInfo.luaextdata.luckAttr
    end
    return {}
end

-- 获取装备卓越词条数
function this.GetEquipExcellentCount(itemInfo)
    if itemInfo.entries then
        return table.count(itemInfo.entries)
    end
    return 0
end

-- 获取装备技能
function this.GetEquipSkillShow(actor, itemInfo)
    local skillName = API.GetItemData(actor, itemInfo.id, "skillName")
    if not string.isNullOrEmpty(skillName) then
        return skillName
    end
    return ""
end

-- true则不回收，false则回收
function this.CheckBagEquipIsBetter(actor, equip, putonEquips)
    -- 从装备信息中获取必要的数据
    local itemCfgId = equip.cfgid
    local itemCfg = ConfigDataManager.getById("cfg_item", itemCfgId)
    if table.isEmpty(itemCfg) then
        return false
    end

    local itemType = itemCfg.type
    if tonumber(itemType) ~= ItemType.EQUIP then
        return false
    end

    -- 检查装备职业限制
    if not this.CheckEquipBaseCareer(actor, itemCfg) then
        return false
    end

    -- 获取装备的评分信息
    local rating = this.GetEquipReplaceRating(actor, equip)
    if table.isEmpty(rating) then
        return false
    end

    -- 如果没有对应部位的装备，则当前装备可能是更好的
    if not putonEquips or table.isEmpty(putonEquips) then
        return true -- 没有已装备的物品，直接不回收
    end

    if not this.CheckEquipWearLimit(actor, equip, itemCfg) then
        return false
    end
    local has = {}
    local cfgWearBar = itemCfg.wearbarid
    local cfgPart = itemCfg.strpart
    if string.isNullOrEmpty(cfgWearBar) or string.isNullOrEmpty(cfgPart) then
        return false
    end

    if tonumber(cfgWearBar) ~= 1 then
        return true
    end

    local partSplit = string.splitInt(cfgPart,"#")
    local numPart = partSplit[1]
    if table.contains({ 1, 2, 3 }, numPart) then
        --是武器
        if numPart == 3  then
            local twoHandPuton = this.getEquip(putonEquips, gameequip.index(1, 3))
            if twoHandPuton ~= nil then
                -- 比较
                return this.CompareItemGradeAndEntrys(actor, twoHandPuton, equip)
            else
                local mainHandPuton = this.getEquip(putonEquips, gameequip.index(1, 1))
                if mainHandPuton ~= nil then
                    -- 比较
                    return this.CompareItemGradeAndEntrys(actor, mainHandPuton, equip)
                else
                    return true
                end
            end
        end

        if #partSplit > 1 then
            -- 主副手均可
            local twoHandPuton = this.getEquip(putonEquips, gameequip.index(1, 3))
            if twoHandPuton ~= nil then
                -- 比较
                return this.CompareItemGradeAndEntrys(actor, twoHandPuton, equip)
            else
                local mainHandPuton = this.getEquip(putonEquips, gameequip.index(1, 1))
                local offHandWeapon = this.getEquip(putonEquips, gameequip.index(1, 2))
                if mainHandPuton == nil and offHandWeapon == nil then
                    return true
                end

                if mainHandPuton ~= nil then
                    -- 比较
                    if this.CompareItemGradeAndEntrys(actor, mainHandPuton, equip) then
                        return true
                    end
                end

                if offHandWeapon == nil then
                    return true
                end

                return false
            end
        else
            -- 弓箭手如果是箭袋的情况下，要先判断有没有穿弓箭。没有穿弓箭的情况下不回收，穿了弓箭再比较已经穿的箭袋
            local twoHandPuton = this.getEquip(putonEquips, gameequip.index(1, 3))
            if twoHandPuton ~= nil then
                local putonEquipCfg = ConfigDataManager.getById("cfg_item", twoHandPuton.cfgid)
                local shapeSplit = string.split(putonEquipCfg.shape, "#")
                local putonModelPart = ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", shapeSplit[1])
                putonModelPart = tonumber(putonModelPart)
                if putonModelPart == 6 or putonModelPart == 7 then
                    local selfShapeSplit = string.split(itemCfg.shape, "#")
                    local selfModelPart = ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", selfShapeSplit[1])
                    selfModelPart = tonumber(selfModelPart)
                    if selfModelPart == 114 or selfModelPart == 115 then
                        local putonEquip = this.getEquip(putonEquips, gameequip.index(1, numPart))
                        return this.CompareItemGradeAndEntrys(actor, putonEquip, equip)
                    else
                        return false
                    end
                else
                    return this.CompareItemGradeAndEntrys(actor, twoHandPuton, equip)
                end
            else
                local selfShapeSplit = string.split(itemCfg.shape, "#")
                local selfModelPart = ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", selfShapeSplit[1])
                selfModelPart = tonumber(selfModelPart)
                if selfModelPart == 114 or selfModelPart == 115 then
                    return false
                end

                -- 直接判断部位有没有装备
                local putonEquip = this.getEquip(putonEquips, gameequip.index(1, numPart))

                if putonEquip == nil then
                    return true
                else
                    -- 比较
                    return this.CompareItemGradeAndEntrys(actor, putonEquip, equip)
                end
            end
        end
    else
        --非武器
        local equipIndex = gameequip.index(1, numPart)
        local putOn = this.getEquip(putonEquips, equipIndex)
        if putOn == nil then
            return true
        end
        -- 比较是否比穿的更好
         return this.CompareItemGradeAndEntrys(actor, putOn, equip)
    end
    return false
end


function this.CompareItemGradeAndEntrys(actor, oldItem, newItem)
    --先比较类型 然后比较评分
    --评分相同则比较词条数量
    local old = this.GetCfgReplaceRating(oldItem)
    local new = this.GetCfgReplaceRating(newItem)
    if old and new and old[1] == new[1] then
        local oldGrade = old[2] or 0
        local newGrade = new[2] or 0
        oldGrade = oldGrade + this.GetEquipCostScore(actor, oldItem)
        newGrade = newGrade + this.GetEquipCostScore(actor, newItem)
        if newGrade > oldGrade then
            return true
            --[[elseif newGrade == oldGrade then
                local oldEntrys = SL:GetEquipEntrys(oldItem)
                local newEntrys = SL:GetEquipEntrys(newItem)
                return table.count(newEntrys) > table.count(oldEntrys)]]
        end
    end
    return false
end

---获取装备替换评分
function this.GetCfgReplaceRating(item)
    local itemCfgId = item.cfgid
    --配置的初始评分
    local replaceRating = ConfigDataManager.getTableValue("cfg_equip_entrylib", "replaceRating", "id", itemCfgId)
    if string.isNullOrEmpty(replaceRating) then
        return nil
    end
    return string.splitInt(replaceRating)
end

function this.GetEquipCostScore(actor, item)
    local itemId = item.id
    -- 2.物理攻击固定值x2，防御固定值x1，攻速x0.5，魔力%x300
    local itemExtData = EquipAndAppear.getItemExtData(actor, itemId)

    local allAttr = {}
    local baseAtt = itemExtData.baseAttr or {}
    table.mergeAdd(allAttr, baseAtt)
    local strengthenAtt = itemExtData.strengthattr or {}
    table.mergeAdd(allAttr, strengthenAtt)
    local appendAtt = itemExtData.appendattr or {}
    table.mergeAdd(allAttr, appendAtt)
    local score = 0
    local function GetAttScore(att)
        local tempScore = 0
        for attrId, value in pairs(att) do
            -- 最大攻击力 固定值x2
            if attrId == 201011 or attrId == 202011 or attrId == 200021 or attrId == 205021 then -- 201011（物理），202011（魔法攻击力），200021（物理+魔法），205021（诅咒攻击力）
                tempScore = tempScore + value * 2
            elseif attrId == 206011 then -- 防御固定值x1
                tempScore = tempScore + value * 1
            elseif attrId == 213021 then -- 攻速x0.5
                tempScore = tempScore + value * 0.5
            elseif attrId == 202042 then -- 魔力百分比x300
                tempScore = tempScore + value / 10000 * 300
            end
        end
        return tempScore
    end
    score = GetAttScore(allAttr)
    -- 3.卓越词条每条20
    score = score + table.count(item.entries) * 20
    -- 4.幸运+10
    local luckAtt = this.GetEquipLuckyAttr(itemExtData)
    score = score + (table.isNullOrEmpty(luckAtt) and 0 or 10)
    -- 5.弓手和剑士的武器技能都+200
    local skillName = itemExtData.skillName
    if not string.isNullOrEmpty(skillName) then
        local skillId = itemExtData.skillId
        if skillId and skillId > 0 then
            local needCareer = string.toIntIntMap(ConfigDataManager.getTableValue("cfg_skill_info", "needCareer", "skillID", skillId, "skillLevel", itemExtData.skillLevel))
            if table.notEmpty(needCareer) then
                local baseCareer = tonumber(getbaseinfo(actor, "getbasecareer"))
                for cfgBaseCareer, cfgCareerRank in pairs(needCareer) do
                    if baseCareer == cfgBaseCareer then
                        score = score + 200
                        break
                    end
                end
            end
        end
    end

    return score
end



function this.getEquip(putonEquips, equipIndex)
    for _, v in pairs(putonEquips) do
        if tonumber(v.equipindex) == tonumber(equipIndex) then
            return v
        end
    end
    return nil
end

function this.shouldCheckEquip(wearBar, cfgWearBar, part, cfgPart)
    if tonumber(wearBar) ~= tonumber(cfgWearBar) then
        return false
    end

    -- 检查部件匹配
    if string.contains(cfgPart, tostring(part)) then
        return true
    end

    -- 特殊处理：wearBar为3时检查1或2
    if part == 3 then
        if string.contains(cfgPart, tostring(1)) or string.contains(cfgPart, tostring(2)) then
            return true
        end
    end


    return false
end

-- 检查装备基础职业限制
function this.CheckEquipBaseCareer(actor, itemCfg)
    local career = getbaseinfo(actor, "getbasecareer")
    local jobs = itemCfg.job
    local itemJobs = string.split(jobs, "|")
    for _, itemJob in pairs(itemJobs) do
        local careerReq = string.splitInt(itemJob, "#")[1]
        if careerReq == career then
            return true
        end
    end
    return false
end

-- 获取装备替换评分
function this.GetEquipReplaceRating(actor, equip)
    if equip and equip.replacerating then
        return equip.replacerating
    end
    return {}
end

-- 获取装备词条
function this.GetEquipEntrys(actor, item)
    local entries = item.entries or {}
    return entries
end

-- 检查装备穿戴限制
function this.CheckEquipWearLimit(actor, equip, itemCfg)
    -- 检查副手装备限制
    if string.contains(itemCfg.strpart, "2") then
        local entryLibCfg = ConfigDataManager.getById("cfg_equip_entryLib", itemCfg.id)
        if not table.isEmpty(entryLibCfg) then
            local assistantJobs = entryLibCfg.assistantjob
            if not string.isNullOrEmpty(assistantJobs) then
                local canEquip = false
                local baseCareer = getbaseinfo(actor, "getbasecareer")
                local careerRank = getbaseinfo(actor, "getcareerrank")
                for _, jobInfo in ipairs(string.split(assistantJobs, "|")) do
                    local reqBaseCareer = string.splitInt(jobInfo, "#")[1]
                    local reqCareerRank = string.splitInt(jobInfo, "#")[2]
                    if baseCareer == reqBaseCareer and careerRank >= reqCareerRank then
                        canEquip = true
                        break
                    end
                end
                return canEquip
            end
        end
    end
    return true
end

--- 判断道具是否合乎药水回收要求
function this.medicineCanRecycling(actor, itemCfgId)
    local option = AutoBuyPotionScript.getOption(actor)
    if not table.isEmpty(option) then
        for i, id in ipairs(option) do
            local itemid = ConfigDataManager.getTableValue("cfg_Portableshop", "itemid", "id", id)
            if string.isNullOrEmpty(itemid) then
                return true
            end
            return tonumber(itemid) ~= tonumber(itemCfgId)
        end
    end
    return true
end

-- ====================================测试========================================
function testitemrecyclingfilter(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        ItemRecyclingFilter.getCanRecycleIndexs(actor, args[2])
    end
end

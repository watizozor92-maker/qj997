---
--- Created by zhouzhipeng.
--- DateTime: 2024/8/26 上午11:13
--- Desc：大师之路
---

Master = {}
local this = {}

--- 大师变量
MasterVariable = {
    MASTER_TALENT_DATA = "T$大师天赋数据",
    JOB_TALENT_ATT = "jobTalentAttr", -- 职业天赋属性
    SKILL_TALENT_ATT = "skillTalentAttr", -- 技能天赋属性（兼容保留）
    COMMON_TALENT_ATT = "commonTalentAttr", -- 通用天赋属性（兼容保留）
    MASTER_CACHE = "G$master_cache", -- 大师之路系列缓存
}

--- 大师天赋类型（兼容保留三种类型）
MasterTalentType = {
    JOB_TALENT = 1, -- 职业天赋
}
-- COMMON_TALENT = 2, -- 通用天赋（兼容保留）
-- SKILL_TALENT = 3, -- 技能天赋（兼容保留）

--- 职业天赋类型
JobTalentType = {
    TALENT = 1, -- 天赋（属性类）
    SKILL_TALENT = 2, -- 技能天赋（技能类）
}

--- 大师天赋效果类型
MasterTalentEffectType = {
    ATT_TYPE = 1, -- 属性类型
    ONE_SPECIAL_ITEM = 2, --每穿戴一件指定类型装备增加属性
    SPECIAL_ITEM = 3, --穿戴指定类型装备增加属性
}

---------------------------------------------------------------------------------------
-- 核心配置映射表（便于扩展其他类型）
---------------------------------------------------------------------------------------

--- 天赋类型配置映射
local TALENT_CONFIG_MAP = {
    [MasterTalentType.JOB_TALENT] = "cfg_master_protalent",
}
-- [MasterTalentType.SKILL_TALENT] = "cfg_master_skilltalent",
--[MasterTalentType.COMMON_TALENT] = "cfg_master_commontalent",

--[[
--- 等级配置映射
local LEVEL_CONFIG_MAP = {
    [MasterTalentType.JOB_TALENT] = "cfg_master_proLevel",
    [MasterTalentType.SKILL_TALENT] = "cfg_master_skillLevel",
}
]]

--- 属性变量映射
local ATT_VAR_MAP = {
    [MasterTalentType.JOB_TALENT] = MasterVariable.JOB_TALENT_ATT,
}
--[MasterTalentType.SKILL_TALENT] = MasterVariable.SKILL_TALENT_ATT,
--[MasterTalentType.COMMON_TALENT] = MasterVariable.COMMON_TALENT_ATT,

---------------------------------------------------------------------------------------
-- 初始化与缓存
---------------------------------------------------------------------------------------

--- 缓存大师之路数据
function Master.cacheMasterData()
    local cacheTable = {}

    -- 遍历所有类型进行缓存（兼容未来扩展）
    for type, _ in pairs(TALENT_CONFIG_MAP) do
        local configName = TALENT_CONFIG_MAP[type]
        local talentList = ConfigDataManager.getList(configName)

        if not table.isNullOrEmpty(talentList) then
            local seriesList = {}
            for _, cfg in pairs(talentList) do
                if not table.contains(seriesList, cfg.series) then
                    table.insert(seriesList, cfg.series)
                end
            end
            cacheTable[type] = seriesList
        else
            cacheTable[type] = {}
        end
    end

    setsysvar(MasterVariable.MASTER_CACHE, cacheTable)
    info("Master.cacheMasterData 启动缓存大师之路数据成功")
    Master.print("cacheMasterData 缓存大师之路数据：\n", cacheTable)
    return cacheTable
end

--- 登录发送红点信息
function Master.login(actor)
    local masterAllInfo = {}

    -- 遍历所有类型发送红点信息
    for _, type in pairs(MasterTalentType) do
        local masterInfo = this.buildMasterRedDotInfo(actor, type)
        table.insert(masterAllInfo, masterInfo)
    end

    sendluamsg(actor, LuaMessageIdToClient.RES_MASTER_RED_DOT_INFO, masterAllInfo)
    Master.print("Master login actor:" .. actor:toString() .. ", 登录发送大师信息", masterAllInfo)
end

--- 请求大师信息
function Master.reqMasterInfo(actor, msgData)
    local type = MasterTalentType.JOB_TALENT
    local masterTalentData = this.getMasterTalentData(actor, type)
    local masterTalent = masterTalentData[type]
    local talentInfo = this.buildTalentInfo(actor, type, masterTalent)

    sendluamsg(actor, LuaMessageIdToClient.RES_MASTER_INFO, talentInfo)
    Master.print("reqMasterInfo actor:" .. actor:toString() .. ", 请求大师信息，返回数据：", talentInfo)
end

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

--- 请求升级大师天赋
function Master.reqUpgradeMasterTalent(actor, msgData)
    Master.print("reqUpgradeMasterTalent actor:" .. actor:toString() .. ", 请求升级大师天赋，msgData:", msgData)
    local talentType = MasterTalentType.JOB_TALENT
    local cfgId = tonumber(msgData.cfgId)

    -- 获取天赋数据
    local masterTalentData = this.getMasterTalentData(actor, talentType)
    local masterTalent = masterTalentData[talentType]
    local talent = masterTalent.talent

    -- 获取配置（公共方法）
    local talentCfg, masterInfoCfg, talentInfo = this.getTalentConfigAndInfo(actor, talentType, cfgId, talent)
    if not talentCfg or not masterInfoCfg then
        return
    end
    local tier = tonumber(talentCfg.tier)
    -- 校验前置点数
    local totalPoints = this.getRequiredFrontPoints(talentType, talent, tier, "小于等于")
    local totalNum = masterInfoCfg.frontnum
    if totalPoints < string.tonumber(totalNum) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT79001)
        return
    end
    local tierNeedPoint = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.MASTER_TALENT_TIER_NEED_POINT)
    tierNeedPoint = string.splitInt(tierNeedPoint, "#")

    local needTierPoint = tierNeedPoint[tier]
    local maxTier = tier - 1
    local phasePoint = this.getRequiredFrontPoints(talentType, talent, maxTier)
    if tier ~= 1 and phasePoint <= needTierPoint then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT79001)
        return
    end

    -- 校验并扣除系列点数
    local consumpoint = tonumber(masterInfoCfg.consumpoint)
    local points = masterTalent.points
    if points < consumpoint then
        tipinfo(actor, "点数不足")
        return
    end

    -- 扣除点数并升级
    masterTalent.points = points - consumpoint
    talentInfo.level = talentInfo.level + 1
    --- 实际增加属性的方法
    this.applyTalentEffect(actor, talentCfg, masterInfoCfg, talentInfo.level, masterTalent)

    setplaydef(actor, MasterVariable.MASTER_TALENT_DATA, masterTalentData)

    local resTalent = {}
    table.insert(resTalent, talentInfo)
    local resInfo = {
        type = talentType,
        points = masterTalent.points,
        talent = resTalent,
    }

    sendluamsg(actor, LuaMessageIdToClient.RES_MASTER_CHANGE_INFO, resInfo)
    Master.print("reqUpgradeMasterTalent actor:" .. actor:toString() .. ", 请求升级大师天赋，结束:", masterTalentData)
end

--- 角色升级赠送天赋点（替代经验兑换）
function Master.levelup(actor, level, oldLevel)
    Master.print("Master levelup actor:" .. actor:toString() .. ", 角色升级触发获取天赋点，开始:" .. ",oldLevel:" .. oldLevel .. ",level:" .. level)

    -- 从 global 配置获取起始和结束等级
    local cfgLevel = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.COMMON_TALENT_LEVEL_POINT)
    if not cfgLevel then
        Master.print("未找到 COMMON_TALENT_MAX_LEVEL 配置")
        return
    end

    local maxLevel = tonumber(cfgLevel)

    if level <= oldLevel then
        return
    end

    if level <= maxLevel then
        return
    end

    local num = level - math.max(oldLevel, maxLevel)

    if num <= 0 then
        return
    end

    local addPoints = num

    -- 增加天赋点数（所有类型共享点数池）
    for _, type in pairs(MasterTalentType) do
        local masterTalentData = this.getMasterTalentData(actor, type)
        local masterTalent = masterTalentData[type]
        masterTalent.points = masterTalent.points + addPoints

        setplaydef(actor, MasterVariable.MASTER_TALENT_DATA, masterTalentData)

        -- 发送通知
        local resInfo = {
            type = type,
            points = masterTalent.points,
        }
        sendluamsg(actor, LuaMessageIdToClient.RES_EXCHANGE_MASTER_EXP, resInfo)
    end

    Master.print("Master levelup actor:" .. actor:toString() .. ", 角色升级触发获取天赋点，结束:" .. ",oldLevel:" .. oldLevel .. ",level:" .. level .. ", 获得点数:" .. addPoints)
end

--- 使用道具后洗点
function Master.useItem(actor, itemConfigId, count)
    local itemConfig = ConfigDataManager.getById("cfg_item", itemConfigId)
    if tonumber(itemConfig.type) ~= 3 or tonumber(itemConfig.subtype) ~= 102 then
        return
    end

    Master.print("Master.useItem actor:" .. actor:toString() .. ", 使用道具洗点，itemConfigId:" .. itemConfigId .. ",count:" .. count)

    local masterType = MasterTalentType.JOB_TALENT

    -- 获取天赋数据
    local masterTalentData = this.getMasterTalentData(actor, masterType)
    local masterTalent = masterTalentData[masterType]
    local talent = masterTalent.talent

    if table.isNullOrEmpty(talent) then
        tipinfo(actor, "没有已加点的天赋")
        return
    end

    -- 计算应返还的点数
    local addPoint = 0
    local masterSeriesPoint = {}

    for id, value in pairs(talent) do
        local add = 0

        for i = 1, value.level do
            local masterList = ConfigDataManager.getTable("cfg_master_info", "talentId", id, "level", i)
            if table.isNullOrEmpty(masterList) then
                tipinfo(actor, "未找到该天赋配置 cfg_master_info")
                return
            end
            local masterInfoCfg = masterList[1]
            add = add + masterInfoCfg.consumpoint
        end
        addPoint = addPoint + add
    end

    -- 移除所有效果
    local attr_map = {}
    local removesSkills = {}

    for _, value in pairs(talent) do
        local cfgId = value.cfgId
        local level = value.level

        local talentList = ConfigDataManager.getTable("cfg_master_protalent", "id", cfgId)
        local masterList = ConfigDataManager.getTable("cfg_master_info", "talentId", cfgId, "level", level)

        if not table.isNullOrEmpty(talentList) and not table.isNullOrEmpty(masterList) then
            local talentCfg = talentList[1]
            local talentType = tonumber(talentCfg.type)

            -- 移除技能效果
            if talentType == JobTalentType.SKILL_TALENT then
                local skillId = talentCfg.skillid
                table.insert(removesSkills, skillId)
            end
        end
    end

    -- 清空属性
    addrolekmlattributes(actor, MasterVariable.JOB_TALENT_ATT, attr_map)
    if table.notNullOrEmpty(removesSkills) then
        removeskill(actor, removesSkills)
    end
    -- 还原点数到系列点数池
    local oldPoint = masterTalent.points
    Master.print("Master.useItem actor:" .. actor:toString() .. ", 已加的点数:", masterSeriesPoint, "，旧的点数", oldPoint)

    masterTalent.points = oldPoint + addPoint
    masterTalent.talent = {}
    masterTalent.allAttrMap = {}

    setplaydef(actor, MasterVariable.MASTER_TALENT_DATA, masterTalentData)

    -- 扣除道具
    removeitemfrombag(actor, itemConfigId, count, 0, 9999, '大师之路洗点')

    -- 返回重置后的天赋信息
    local talentInfo = this.buildTalentInfo(actor, masterType, masterTalent)
    sendluamsg(actor, LuaMessageIdToClient.RES_MASTER_INFO, talentInfo)

    Master.print("Master.useItem actor:" .. actor:toString() .. ", 道具洗点结束，返还点数:" .. addPoint, talentInfo)
    tipinfo(actor, string.format("洗点成功，返还%s点天赋点数", addPoint))
end
---------------------------------------------------------------------------------------
-- 公共辅助方法
---------------------------------------------------------------------------------------


--- 应用天赋效果（只收集数据，不真正加属性）
function this.applyTalentEffect(actor, talentCfg, masterInfoCfg, level, masterTalent)
    local cfgType = tonumber(talentCfg.type)
    local cfgId = talentCfg.id
    local parameter = masterInfoCfg.parameter

    if cfgType == JobTalentType.TALENT then
        local masterType = tonumber(masterInfoCfg.type)

        -- type=1: 直接添加属性
        if masterType == MasterTalentEffectType.ATT_TYPE then
            if parameter ~= "" then
                local attr_map = this.getSplitAttr(parameter)
                masterTalent.typeOneAttrMap[cfgId] = attr_map
            end

            -- type=2: 每穿戴一件指定类型装备增加属性（记录条件和属性）
        elseif masterType == MasterTalentEffectType.ONE_SPECIAL_ITEM then
            local param = string.splitByAll(parameter, "|")
            local paramTable = {
                itemType = tonumber(param[1]),
                pz = tonumber(param[2]),
                strengthLv = tonumber(param[3]),
            }
            local attr_map = this.getSplitAttr(param[4])

            -- 记录属性和条件
            masterTalent.typeTwoAttrMap[cfgId] = attr_map
            masterTalent.typeTwoConditions[cfgId] = paramTable

            -- type=3: 穿戴指定类型装备增加属性（记录条件和属性）
        elseif masterType == MasterTalentEffectType.SPECIAL_ITEM then
            local param = string.splitByAll(parameter, "|")
            local paramTable = {
                itemType = tonumber(param[1]),
                pz = tonumber(param[2]),
                strengthLv = tonumber(param[3]),
            }
            local attr_map = this.getSplitAttr(param[4])

            -- 记录属性和条件
            masterTalent.typeThreeAttrMap[cfgId] = attr_map
            masterTalent.typeThreeConditions[cfgId] = paramTable
        end
        local allAttrMap = this.calculateCurrentAttrMap(masterTalent, actor)
        addrolekmlattributes(actor, MasterVariable.JOB_TALENT_ATT, allAttrMap)
    elseif cfgType == JobTalentType.SKILL_TALENT then
        -- 学习或升级技能
        local skillId = talentCfg.skillid
        levelupskill(actor, skillId, level)
    end
end

--- 计算当前所有符合的属性（考虑装备状态）
function this.calculateCurrentAttrMap(masterTalent, actor)
    local allAttrMap = {}

    local typeOneTotal = this.calculateAttr(masterTalent.typeOneAttrMap or {})
    table.mergeAdd(allAttrMap, typeOneTotal)

    if table.isNullOrEmpty(masterTalent.typeTwoAttrMap) and table.isNullOrEmpty(masterTalent.typeThreeAttrMap) then
        return allAttrMap
    end

    local typeTwoEquipCount = {}
    local typeThreeHasEquip = {}
    local allEquip = getputonequipinfo(actor)
    -- 遍历所有装备，检查每个装备符合哪些天赋条件
    for _, equipInfo in pairs(allEquip) do
        local itemId = equipInfo.id
        local cfgId = equipInfo.cfgid

        -- 检查 type2 条件
        if table.notNullOrEmpty(masterTalent.typeTwoConditions) then
            for talentCfgId, condition in pairs(masterTalent.typeTwoConditions) do
                if this.checkTalentType(actor, itemId, cfgId, condition) then
                    typeTwoEquipCount[talentCfgId] = (typeTwoEquipCount[talentCfgId] or 0) + 1
                end
            end
        end

        -- 检查 type3 条件
        if table.notNullOrEmpty(masterTalent.typeThreeConditions) then
            for talentCfgId, condition in pairs(masterTalent.typeThreeConditions) do
                if this.checkTalentType(actor, itemId, cfgId, condition) then
                    typeThreeHasEquip[talentCfgId] = true
                end
            end
        end
    end

    --  计算 type2 属性（乘以装备数量）
    if table.notNullOrEmpty(masterTalent.typeTwoAttrMap) then
        for cfgId, attr_map in pairs(masterTalent.typeTwoAttrMap) do
            local equipCount = typeTwoEquipCount[cfgId] or 0
            if equipCount > 0 then
                local multipliedAttr = table.multiply(attr_map, equipCount)
                table.mergeAdd(allAttrMap, multipliedAttr)
            end
        end
    end

    -- 计算 type3 属性（只加一次）
    if table.notNullOrEmpty(masterTalent.typeThreeAttrMap) then
        for cfgId, attr_map in pairs(masterTalent.typeThreeAttrMap) do
            if typeThreeHasEquip[cfgId] then
                table.mergeAdd(allAttrMap, attr_map)
            end
        end
    end

    return allAttrMap
end

--- 刷新大师天赋属性（穿脱装备、强化时调用）
-- 重新计算并应用所有属性
function Master.refreshMasterTalentAttr(actor)
    local masterTalentData = getplaydef(actor, MasterVariable.MASTER_TALENT_DATA)
    if not masterTalentData then
        return
    end

    --[[    -- 遍历所有天赋类型
        for type, masterTalent in pairs(masterTalentData) do
            if not table.isNullOrEmpty(masterTalent) then
                -- 重新计算当前属性
                local allAttrMap = this.calculateCurrentAttrMap(masterTalent, actor)

                -- 应用属性
                addrolekmlattributes(actor, MasterVariable.JOB_TALENT_ATT, allAttrMap)
            end
        end]]
    --- 应该是没有其它类型了
    local masterTalent = masterTalentData[MasterTalentType.JOB_TALENT]
    if table.isNullOrEmpty(masterTalent) then
        return
    end
    --- 如果二类型和三类型都是空的就没有校验的必要
    if table.isNullOrEmpty(masterTalent.typeTwoAttrMap) and table.isNullOrEmpty(masterTalent.typeThreeAttrMap) then
        return
    end
    local allAttrMap = this.calculateCurrentAttrMap(masterTalent, actor)
    -- 应用属性
    addrolekmlattributes(actor, MasterVariable.JOB_TALENT_ATT, allAttrMap)
    Master.print("刷新属性", masterTalent, allAttrMap)
end

--- 检测是否符合类型要求
function this.checkTalentType(actor, itemId, cfgId, params)
    local itemExtData = EquipAndAppear.getItemExtData(actor, itemId)

    local needPz = params.pz or 0
    local needStrengthLv = params.strengthLv or 0
    local needItemType = params.itemType or 0

    -- 检查品质
    if needPz > 0 and needPz ~= 99 then
        local outstanding = ConfigDataManager.getTableValue("cfg_item", "Outstanding", "id", cfgId)
        outstanding = tonumber(outstanding) or 0
        if needPz ~= outstanding then
            return false
        end
    end

    -- 检查强化等级
    local actualStrengthLv = itemExtData.strengthlv or 0
    if needStrengthLv > 0 and actualStrengthLv < needStrengthLv then
        return false
    end

    -- 检查类别需求
    if needItemType ~= 0 then
        if needItemType == 5 then
            -- 首饰
            local subType = ConfigDataManager.getTableValue("cfg_item", "subType", "id", cfgId)
            subType = tonumber(subType) or 0
            local selectType = ConfigDataManager.getTableValue("cfg_item", "type", "id", cfgId)
            selectType = tonumber(selectType) or 0
            if selectType ~= ItemType.EQUIP or (subType ~= 10 and subType ~= 11 and subType ~= 12) then
                return false
            end
        else
            local mixtype = ConfigDataManager.getTableValue("cfg_item", "Mixtype", "id", cfgId)
            mixtype = tonumber(mixtype) or 0
            if needItemType ~= mixtype then
                return false
            end
        end
    end
    return true
end

--- 获取天赋配置和信息
function this.getTalentConfigAndInfo(actor, talentType, cfgId, talent)
    -- 获取配置表名
    local configName = TALENT_CONFIG_MAP[talentType]
    if not configName then
        tipinfo(actor, "未找到该天赋类型配置")
        return nil, nil, nil
    end

    -- 获取天赋配置
    local talentList = ConfigDataManager.getTable(configName, "id", cfgId)
    if table.isNullOrEmpty(talentList) then
        tipinfo(actor, "未找到该天赋配置：" .. configName)
        return nil, nil, nil
    end
    local talentCfg = talentList[1]

    -- 获取或初始化天赋信息
    local talentInfo = this.getTalent(talent, talentCfg)
    local level = tonumber(talentInfo.level)

    -- 检查等级上限
    local str = talentCfg.minmaxlevel
    local minMaxLevel = string.split(str, "#")
    if level >= tonumber(minMaxLevel[2]) then
        tipinfo(actor, "天赋已点满")
        return nil, nil, nil
    end

    -- 获取下一级配置
    local masterList = ConfigDataManager.getTable("cfg_master_info", "talentId", cfgId, "level", level + 1)
    if table.isNullOrEmpty(masterList) then
        tipinfo(actor, "未找到该天赋配置 cfg_master_info")
        return nil, nil, nil
    end
    local masterInfoCfg = masterList[1]

    return talentCfg, masterInfoCfg, talentInfo
end

--- 获取前置点数需求
function this.getRequiredFrontPoints(talentType, talent, maxTier, comparison)
    comparison = comparison or "eq"  -- 默认为相等比较
    local totalPoints = 0
    if talentType == MasterTalentType.JOB_TALENT then
        -- 职业天赋：根据 tier 计算
        totalPoints = this.getJobTalentPoints(talent, maxTier, comparison)
    end

    return totalPoints
end

--- 获取职业天赋已加点的天赋点数
function this.getJobTalentPoints(talent, maxTier, comparison)
    local totalPoints = 0
    for cfgId, info in pairs(talent) do
        local tier = ConfigDataManager.getTableValue("cfg_master_protalent", "tier", "id", cfgId)
        if tier then
            local shouldInclude = false
            if comparison == "小于等于" then
                shouldInclude = tonumber(tier) <= maxTier
            else
                -- 默认使用相等比较
                shouldInclude = tonumber(tier) == maxTier
            end

            if shouldInclude then
                for i = 1, info.level do
                    local consumPoint = ConfigDataManager.getTableValue("cfg_master_info", "consumpoint", "talentId", cfgId, "level", i)
                    Master.print("getJobTalentPoints 获取已加点 cfgId:" .. cfgId .. ",level:" .. i .. ",consumPoint:" .. tostring(consumPoint), talent, maxTier)
                    if consumPoint then
                        totalPoints = totalPoints + tonumber(consumPoint)
                    end
                end
            end
        end
    end
    return totalPoints
end

--- 初始化单个天赋
function this.initTalentInfo(talentCfg)
    local talentInfo = {}
    talentInfo.cfgId = tonumber(talentCfg.id)
    talentInfo.level = 0
    talentInfo.series = tonumber(talentCfg.series)
    return talentInfo
end

--- 获取大师天赋数据
function this.getMasterTalentData(actor, type)
    local masterTalentData = getplaydef(actor, MasterVariable.MASTER_TALENT_DATA) or {}
    local masterTalent = masterTalentData[type]

    if table.isNullOrEmpty(masterTalent) then
        masterTalent = this.initSingleTalentData()
        masterTalentData[type] = masterTalent
        setplaydef(actor, MasterVariable.MASTER_TALENT_DATA, masterTalentData)
    end

    return masterTalentData
end

--- 构建天赋信息
function this.buildTalentInfo(actor, type, talent)
    local talentInfo = {}
    talentInfo.type = type
    talentInfo.points = talent.points
    talentInfo.talent = talent.talent
    return talentInfo
end

function this.getTalent(talent, talentCfg)
    local cfgId = tonumber(talentCfg.id)
    local talentInfo = talent[cfgId]
    if table.isNullOrEmpty(talentInfo) then
        talentInfo = this.initTalentInfo(talentCfg)
        talent[cfgId] = talentInfo
    end
    return talentInfo
end

function this.getSplitAttr(parameter)
    local attr_map = {}
    local parameterStr = string.split(parameter, "&")
    for _, value in pairs(parameterStr) do
        local str = string.split(value, "#")
        local attrId = str[1]
        local oldValue = attr_map[attrId]
        if oldValue == nil or oldValue == 0 then
            attr_map[attrId] = str[2]
        else
            attr_map[attrId] = oldValue + tonumber(str[2])
        end
    end
    return attr_map
end

function this.calculateAttr(allAttrMap)
    local addAttrMap = {}
    for _, attr_map in pairs(allAttrMap) do
        for attrId, value in pairs(attr_map) do
            local oldValue = addAttrMap[attrId] or 0
            addAttrMap[attrId] = oldValue + tonumber(value)
        end
    end
    return addAttrMap
end

--- 初始化天赋数据
function this.initSingleTalentData()
    return {
        points = 0, -- 天赋点数
        talent = {}, -- 天赋   索引天赋 id  内容：{id, level, series 系列 ,}
        typeOneAttrMap = {}, -- 天赋配置 对应 获得的属性
        typeTwoAttrMap = {},
        typeThreeAttrMap = {},
        typeTwoConditions = {}, -- type2 的条件映射
        typeThreeConditions = {}, -- type3 的条件映射
    }
end

--- 构建红点信息
function this.buildMasterRedDotInfo(actor, type)
    local masterTalentData = this.getMasterTalentData(actor, type)
    local masterTalent = masterTalentData[type]

    local masterInfo = {}
    masterInfo.type = type
    masterInfo.points = masterTalent.points or 0
    return masterInfo
end

---------------------------------------------------------------------------------------
-- 测试方法
---------------------------------------------------------------------------------------

--- 打印日志
function Master.print(...)
    local isPrintLog = true
    if isPrintLog then
        return
    end
    jprint(...)
end


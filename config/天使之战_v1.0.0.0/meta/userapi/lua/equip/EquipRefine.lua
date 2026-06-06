---
--- Created by zhouzhipeng.
--- DateTime: 2025/12/10 上午10:52
--- Desc：装备洗练
---

EquipRefine = {}
local this = {}

function EquipRefine.reqEquipRefine(actor, msgData)
    local firstItemId = msgData.firstItemId
    local secondItemId = msgData.secondItemId
    --info(actor, "玩家", actor, "洗练成功 ","firstItemId", firstItemId, "secondItemId", secondItemId)
    if firstItemId == secondItemId then
        tipinfo(actor, "主副装备是同一件")
        return
    end
    local firstEquip = getequipinfo(actor, firstItemId, 1)
    if table.isNullOrEmpty(firstEquip) then
        tipinfo(actor, "主装备不存在")
        return
    end

    local secondEquip = getequipinfo(actor, secondItemId, 1)
    if table.isNullOrEmpty(secondEquip) then
        tipinfo(actor, "副装备不存在")
        return
    end
    if secondEquip.bagindex == 0 then
        tipinfo(actor, "副装备不存在0")
        return
    end
    local firstItemCfgId = firstEquip.cfgid
    local secondItemCfgId = secondEquip.cfgid
    local config_list = ConfigDataManager.getTable("cfg_equip_refine", "id", firstItemCfgId)

    if table.isEmpty(config_list) then
        local bindEqualItem = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "bindequalitem", "id", firstItemCfgId))
        config_list = ConfigDataManager.getTable("cfg_equip_refine", "id", bindEqualItem)
        if table.isEmpty(config_list) then
            tipinfo(actor, "不可洗练")
            error(actor, "玩家", actor, "洗练 不可洗练cfg_equip_refine配置不存在 id:", firstItemCfgId)
            return
        end
    end
    if not this.checkJob0(actor, firstItemCfgId) then
        tipinfo(actor, "主装备职业不满足")
        return
    end

    local cfg_equip_refine
    for _, cfg in pairs(config_list) do
        local consumption = string.split(cfg.consumption, "#")
        local isOne = consumption[1] == "1"
        if isOne then
            if this.checkCondition1(secondItemCfgId, consumption) then
                cfg_equip_refine = cfg
                break
            end
        else
            if this.checkCondition2(secondItemCfgId, consumption) then
                cfg_equip_refine = cfg
                break
            end
        end
    end

    if not cfg_equip_refine then
        tipinfo(actor, "条件不满足")
        return
    end

    --local consumption = string.split(cfg_equip_refine.consumption, "#")
    --local isOne = consumption[1] == "1"

    local cost = string.toIntIntMap(cfg_equip_refine.cost)
    --if not isOne then
    --    local itemCfgId = tonumber(consumption[2])
    --    local oldCount = cost[itemCfgId] or 0
    --    cost[itemCfgId] = oldCount + 1
    --end

    if not Bag.checkCostMap(actor, cost) then
        tipinfo(actor, "消耗不足")
        return
    end
    local entrys = this.randomEntry(actor, firstItemCfgId, cfg_equip_refine)
    if not entrys then
        return
    end

    Bag.costMap(actor, cost, "洗练消耗")
    removeitembyidxlist(actor, { secondEquip.bagindex }, 9999, '洗练消耗副装备')

    resetequipentry(actor, firstEquip.id, entrys)
    sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_REFINE_RESULT, {})
    if not firstEquip.isbind and EquipAndAppear.isBindCost({ [secondItemCfgId] = 1 }) then
        EquipAndAppear.updateBindState(actor, firstEquip.id, firstItemCfgId)
    end
    --info(actor, "玩家", actor, "洗练成功 词条", entrys, "旧词条", firstEquip.entries, "洗练id", cfg_equip_refine.id)
    info(actor, "玩家", actor, "洗练成功 词条", entrys, "旧词条", firstEquip.entries, "洗练id", cfg_equip_refine.id,"firstItemId", firstItemId, "secondItemId", secondItemId)
end

function this.randomEntry(actor, itemCfgId, cfg_equip_refine)
    local attCountWeight = cfg_equip_refine.attcountweight
    local count = RandomUtil.weightKeyToInt(attCountWeight, "#", "|")
    if count < 1 then
        tipinfo(actor, "词条数量错误")
        error(actor, "玩家", actor, "洗练 词条数量错误 装备id:", itemCfgId, "attCountWeight", attCountWeight)
        return nil
    end
    --gameDebug.assertTrue(count > 0, "装备词条数量错误，cfg_equip_refine表attCountWeight", itemCfgId, attCountWeight)

    local att = cfg_equip_refine.att
    local groups = string.split(att, "|")
    if count > #groups then
        tipinfo(actor, "词条组错误")
        error(actor, "玩家", actor, "洗练 cfg_equip_refine表att数量与attCountWeight数量不匹配 装备id:", itemCfgId, "attCountWeight", attCountWeight, "att", att)
        return nil
    end
    --gameDebug.assertTrue(count <= table.count(groups), "装备词条 cfg_equip_refine表att数量与attCountWeight数量不匹配", itemCfgId, attCountWeight, att)

    local isSameAtt = ConfigDataManager.getTableValue("cfg_equip_entryLib", "isSameAtt", "id", itemCfgId)
    local entryList = {}
    for i = 1, count do
        local groupStr = groups[i]
        -- 词条权重
        local weightMap = {}
        if string.contains(groupStr, "#") then
            local groupTable = string.split2Number(groupStr,"#")
            for _, group in pairs(groupTable) do
                local attList = ConfigDataManager.getTable("cfg_equip_att", "group", group)
                for _, cfg in pairs(attList) do
                    local attTab = string.split(cfg.att, "#")
                    table.insert(weightMap, {id = tonumber(cfg.id), qz = tonumber(attTab[4])})
                end
            end
        else
            local attList = ConfigDataManager.getTable("cfg_equip_att", "group", groupStr)
            for _, cfg in pairs(attList) do
                local attTab = string.split(cfg.att, "#")
                table.insert(weightMap, {id = tonumber(cfg.id), qz = tonumber(attTab[4])})
            end
        end
        if string.tonumber(isSameAtt) == 1 then
            -- 允许同词条出现
            local idx = API.GetQZ(weightMap)
            gameDebug.assertTrue(idx > 0, "洗练 权重错误", itemCfgId, idx)
            local entryId = weightMap[idx].id
            table.insert(entryList, entryId)
        else
            -- 不允许同词条出现
            local entryId = RandomUtil.GetQZWithout(weightMap, entryList)
            gameDebug.assertTrue(entryId > 0, "洗练 权重错误0", itemCfgId, attCountWeight)
            table.insert(entryList, entryId)
        end
        --info(actor, "玩家", actor,"装备id:", itemCfgId, "已随机到的词条", entryList, "权重的词条", weightMap)
    end


    local entryInfos  = {}
    for idx, id in pairs(entryList) do
        local cfg = ConfigDataManager.getById("cfg_equip_att", id)
        if table.isEmpty(cfg) then
            return
        end
        local atttab = string.split(cfg.att, "#")
        local value = math.random(tonumber(atttab[2]), tonumber(atttab[3]))
        local entryInfo = {}
        entryInfo.attrid = tonumber(atttab[1])
        entryInfo.value = value
        entryInfo.entryid = id
        table.insert(entryInfos, entryInfo)
    end
    return entryInfos
end

--- 校验辅助消耗，是否满足职业要求
function this.checkJob(job, consumption)
    local jobTab = string.split(job, "|")
    for _, careerStr in pairs(jobTab) do
        local careerTab = string.split(careerStr, "#")
        if careerTab[1] == consumption[5] and careerTab[2] >= consumption[6] then
            return true
        end
    end
    return false
end

--- 校验主装备该职业能否穿戴
function this.checkJob0(actor, firstItemCfgId)
    local baseCareer = tostring(getbaseinfo(actor, "getbasecareer"))
    local careerRank = tostring(getbaseinfo(actor, "getcareerrank"))
    local job1 = ConfigDataManager.getTableValue("cfg_item", "job", "id", firstItemCfgId)
    if job1 == "" or job1 == "0" then
        return true
    else
        local jobTab = string.split(job1, "|")
        for _, careerStr in pairs(jobTab) do
            local careerTab = string.split(careerStr, "#")
            if baseCareer == careerTab[1] and careerRank >= careerTab[2] then
                return true
            end
        end
    end
    return false
end

function this.checkCondition1(secondItemCfgId, consumption)
    local cfg_item2 = ConfigDataManager.getById("cfg_item", secondItemCfgId)
    if consumption[2] ~= cfg_item2.outstanding then
        --tipinfo(actor, "副装备品质不满足")
        return false
    end
    if cfg_item2.rank < consumption[3] or cfg_item2.rank > consumption[4] then
        --tipinfo(actor, "副装备品阶不满足")
        return false
    end

    if consumption[5] ~= "0" and consumption[6] ~= "0" then
        local job = cfg_item2.job
        if job == "" or job == "0" then
            --tipinfo(actor, "副装备职业不满足0")
            return false
        else
            if not this.checkJob(cfg_item2.job, consumption) then
                --tipinfo(actor, "副装备职业不满足")
                return false
            end
        end
    end
    return true
end

function this.checkCondition2(secondItemCfgId, consumption)
    -- 判断道具id
    local itemCfgId = tonumber(consumption[2])
    local bindEqualItem = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "bindequalitem", "id", secondItemCfgId))
    if secondItemCfgId ~= itemCfgId and bindEqualItem ~= itemCfgId then
        --tipinfo(actor, "副装备不满足条件")
        return false
    end
    return true
end


MessageRouter:register(LuaMessageIdToSever.REQ_EQUIP_REFINE, EquipRefine.reqEquipRefine)

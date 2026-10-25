Equip_JiNeng = {}
local this = Equip_JiNeng
local filename = "Equip_JiNeng"
--this.msgID = LuaNetMsg.Equip_JiNeng_MsgID

function this.getData(actor)
    local tab = {}
    local data = this.tData

    return tab
end

function this.RefreshLevel(actor)
    local data = {
        sendType = 10,
    }
    sendluamsg(actor,this.msgID,data)  
    
    --推送红点
    sendluamsg(actor,LuaNetMsg.Equip_DuanZao_MsgID,{})  
end

function this.Click(actor,msgData)
    local mainPage = msgData.mainPage
    local subPage = msgData.subPage
    local par = msgData.par
    if mainPage == 1 then
        this.JiNeng(actor,msgData)
    elseif mainPage == 2  then

    end

end


function this.JiNeng(actor,msgData)
    local itemId = msgData.itemId
    local cfgId = msgData.cfgId

    local skillName = API.GetItemData(actor,itemId,"skillName") or nil

    local skillzidai = ConfigDataManager.getTableValue("cfg_item", "skillzidai", "id", cfgId)
    if skillzidai == "" then
        messagebox(actor,"没有可激活的技能！")
        return
    end
    

    if skillName and skillName~="" then
        messagebox(actor,"已激活技能！")
        return
    end


    --消耗
    local tCost = {{"技能宝石",1},    gailv=100,}
    if not API.CheckItem(actor,tCost) then
        messagebox(actor,"材料不足！")
        return
    end

    if not API.takeItem(actor,tCost) then
        messagebox(actor,"材料不足！")
        return
    end


    --概率
    local gailv = tCost.gailv 
    if math.random(1,100) > gailv then
        -- messagebox(actor,"激活技能失败！")  
         local data = {
        sendType = 9,
    }
    sendluamsg(actor,this.msgID,data)  
        return 
    end

    if this.setZhuangBeiSkill(actor, itemId, cfgId, 10000) then
        --通知客户端更新
        this.RefreshLevel(actor)

        --刷新激活技能
        if msgData.equipPos ~= 0 then
            this.sendAttr(actor, itemId, cfgId)
        end
    end
end

-- 随机装备技能
function this.setZhuangBeiSkill(actor, itemId, cfgId, qz)
    local skillzidai = ConfigDataManager.getTableValue("cfg_item", "skillzidai", "id", cfgId)
    local result, skillInfo = this.radomSkill(skillzidai, qz)
    if result then
        API.SetItemData(actor,itemId,"skillName",skillInfo[1])
        API.SetItemData(actor,itemId,"skillId", skillInfo[2])
        API.SetItemData(actor,itemId,"skillLevel", skillInfo[3])
        API.SetItemData(actor,itemId,"IsSetSkill", 1)
        return true
    end
    return false
end

-- 表字段字符串，格式需一致
function this.radomSkill(configStr, qz)
    if string.isNullOrEmpty(configStr) then
        return false
    end

    local tSkillInfo = string.split(configStr,"#")
    local skillId = tonumber(tSkillInfo[1])
    local skillLevel = tonumber(tSkillInfo[2])
    qz = qz or tonumber(tSkillInfo[3])

    local randomNum = math.random(10000)
    if randomNum > qz then
        return false
    end

    local skillName = ConfigDataManager.getTableValue("cfg_skill", "name", "id", skillId)

    local costHp = ConfigDataManager.getTableValue("cfg_skill_info", "costHp", "skillID", skillId) or 0
    costHp = tonumber(costHp) or 0
   
    local costMp = ConfigDataManager.getTableValue("cfg_skill_info", "costMp", "skillID", skillId) or 0
    costMp = tonumber(costMp) or 0
  
    local costMpRatio = ConfigDataManager.getTableValue("cfg_skill_info", "costMpRatio", "skillID", skillId) or 0
    costMpRatio = tonumber(costMpRatio) or 0
    if costMpRatio > 0 then
        skillName = skillName .. string.format("(MP:%.0f%%)", costMpRatio / 100)
    elseif costMp > 0 then
        skillName = skillName .. string.format("(MP:%d)", costMp)
    elseif costHp > 0 then
        skillName = skillName .. string.format("(HP:%d)", costHp)
    end

    return true, { skillName, skillId, skillLevel }
end

function Equip_JiNeng.updateSkill(actor)
    local equipSkillData = this.getEquipSkillData(actor)
    local ownSkill = {}
    
    -- 收集当前装备的技能
    for i = 1, 3 do
        local equipIndex = gameequip.index(1, i)
        local equipInfo = getequipinfo(actor, equipIndex, 0) or {}
        if table.notEmpty(equipInfo) then
            local itemExtData = EquipAndAppear.getItemExtData(actor, equipInfo.id)
            if itemExtData.skillName then
                local skillId = itemExtData.skillId
                local skillLevel = itemExtData.skillLevel
                if skillId and skillLevel then
                    ownSkill[skillId] = skillLevel
                end
            end
        end
    end

    -- 计算需要添加和移除的技能
    local addSkill = {}
    local removeSkill = {}
    
    -- 确定需要移除的技能（之前有但现在没有的）
    for prevSkillId, _ in pairs(equipSkillData) do
        if not ownSkill[prevSkillId] then
            table.insert(removeSkill, prevSkillId)
        end
    end
    
    -- 确定需要添加的技能（现在有但之前没有的，并且满足职业要求）
    for currSkillId, skillLevel in pairs(ownSkill) do
        if not equipSkillData[currSkillId] and this.canLeveLuSkill(actor, currSkillId, skillLevel) then
            addSkill[currSkillId] = skillLevel
        end
    end

    -- 执行移除操作
    if #removeSkill > 0 then
        removeskill(actor, removeSkill)
    end
    
    -- 执行添加操作
    for skillCfgId, skillLv in pairs(addSkill) do
        levelupskill(actor, skillCfgId, skillLv)
    end

    -- 保存当前装备的技能数据
    this.setEquipSkillData(actor, ownSkill)
end

function this.canLeveLuSkill(actor, skillCfgId, skillLv)
    local needCareer = string.toIntIntMap(ConfigDataManager.getTableValue("cfg_skill_info", "needCareer", "skillID", skillCfgId, "skillLevel", skillLv))
    if table.isEmpty(needCareer) then
        return true
    end
    local baseCareer = tonumber(getbaseinfo(actor, "getbasecareer"))
    local careerRank = tonumber(getbaseinfo(actor, "getcareerrank"))
    for cfgBaseCareer, cfgCareerRank in pairs(needCareer) do
        if baseCareer == cfgBaseCareer and careerRank >= cfgCareerRank then
            return true
        end
    end
    return false
end

function this.getEquipSkillData(actor)
    return getplaydef(actor, "T$equipSkillData") or {}
end

function this.setEquipSkillData(actor, allData)
    setplaydef(actor, "T$equipSkillData", allData)
end

--刷新技能装备属性
function this.sendAttr(actor, itemId, cfgId, forget)
    local skillName = API.GetItemData(actor,itemId,"skillName") or nil
    if not skillName then
        return
    end

    local skillzidai = ConfigDataManager.getTableValue("cfg_item", "skillzidai", "id", cfgId)
    if string.isNullOrEmpty(skillzidai) then
        return false
    end

    forget = forget or false

    local tSkillInfo = string.split(skillzidai,"#")
    local skillId = tonumber(tSkillInfo[1])
    local skillLevel = tonumber(tSkillInfo[2])

    local skillList = {}
    for i = 1, 3 do
        local equipInfo = getequipinfo(actor, gameequip.index(1, i), 0) or {}
        local oldSkillName = nil
        if next(equipInfo) then
            oldSkillName = API.GetItemData(actor,equipInfo.id,"skillName") or nil
        end
        if next(equipInfo) and equipInfo.id ~= itemId and (oldSkillName ~= nil) then
            local skillzidai = ConfigDataManager.getTableValue("cfg_item", "skillzidai", "id", equipInfo.cfgid)
            if not string.isNullOrEmpty(skillzidai) then
                local info = string.split(skillzidai,"#")
                table.insert(skillList, tonumber(info[1]))
            end
        end
    end

    if forget then
        if not table.contains(skillList, skillId) then
            --遗忘技能 由于武器技能不和角色学习技能重叠，直接删除技能即可
            removeskill(actor, {skillId})
        end
    else
        if not table.contains(skillList, skillId) then
            --学习技能
            levelupskill(actor, skillId, skillLevel)
        end
    end
end

GameEvent.add(EventCfg.onHandlereQuest,
    function(actor, msgID,msgData)
        -- messagebox(actor,"msgID111="..this.msgID)
        -- messagebox(actor,"msgData.sendType="..msgData.sendType)
        -- messagebox(actor,"msgData.sendType="..type(msgData.sendType))
        if this.msgID ~= msgID then
            return 
        end 
        if msgData.sendType == 1 then
            this.main(actor)
        elseif msgData.sendType == 2 then
            this.SendData(actor)
        elseif msgData.sendType == 3 then
            this.Click(actor,msgData)
        end
        return true
    end
, filename)

function this.isJiNengEquip(actor, itemId)
    local skillName = API.GetItemData(actor,itemId,"skillName") or nil
    return not string.isNullOrEmpty(skillName)
end

function this.getJiNengTag(actor, itemId)
    local skillTag = API.GetItemData(actor,itemId,"skillTag") or nil
    return skillTag
end

--物品进入背包后
GameEvent.add(EventCfg.addbag,function(actor, itemId, itemCfgId, index)
    local skillCfgstr = ConfigDataManager.getTableValue("cfg_equip_entryLib", "skillGemProbability", "id", itemCfgId) or ""    
    if string.isNullOrEmpty(skillCfgstr) then
        return
    end
    local skillCfgMap = string.toAllIntIntMap(skillCfgstr)
    if not skillCfgMap then
        return
    end
    if this.getJiNengTag(actor, itemId) or this.isJiNengEquip(actor, itemId) then
        return
    end
    -- local info = getbagiteminfo(actor, itemId, 1)
    -- jprint("打印物品信息-技能", itemId, info.skill)
    for _,v in pairs(skillCfgMap) do
        if v[3] and math.random(1,10000) <= v[3] then
            setequipskillbyid(actor, itemId, v[1], v[2])
        end
    end
    API.SetItemData(actor, itemId, "skillTag", os.time())
end,filename)
--玩家进入视野
-- GameEvent.add(EventCfg.onPlayerEnterView,function(actor,targetPlayer)

-- end,this.filename)
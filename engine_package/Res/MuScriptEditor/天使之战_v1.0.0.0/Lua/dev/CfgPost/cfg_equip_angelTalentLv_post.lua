---@class cfg_equip_angelTalentLv_post
cfg_equip_angelTalentLv_post = class()
local this = cfg_equip_angelTalentLv_post

---@type table<number,table<number,cfg_equip_angelTalentLv_column>>
local skillId2TalentLvTbl = {}

local function Init()
    ---@type cfg_equip_angelTalentLv_column[]
    local cfgTbls = SL:GetConfigTable('cfg_equip_angelTalentLv')
    local skillId = 0
    local skillLv = 0
    for i, v in pairs(cfgTbls) do
        ---@type cfg_equip_angelTalent_column
        local talentTbl = SL:GetConfig("cfg_equip_angelTalent", v.talentId)
        if talentTbl.talentType == 2 then
            if v.parameter[1] then
                skillId = v.parameter[1][1]
                skillLv = v.parameter[1][2]
            else
                logError("cfg_equip_angelTalentLv  parameter==nil  ,  id = " .. v.id)
                skillId = 0
                skillLv = 0
            end

            if skillId > 0 and skillLv > 0 then
                if not skillId2TalentLvTbl[skillId] then
                    skillId2TalentLvTbl[skillId] = {}
                end
                skillId2TalentLvTbl[skillId][skillLv] = v
            end
        end
    end

end

Init()

---@return cfg_equip_angelTalentLv_column
this.GetAngleTalentLvTbl = function(skillId, skillLv)
    return skillId2TalentLvTbl[skillId] and skillId2TalentLvTbl[skillId][skillLv]
end

this.IsAngelTalentSkill = function(skillId)
    ---@type cfg_skill_column
    local skillTbl = SL:GetConfig('cfg_skill', skillId)
    return skillTbl.group == 5
end



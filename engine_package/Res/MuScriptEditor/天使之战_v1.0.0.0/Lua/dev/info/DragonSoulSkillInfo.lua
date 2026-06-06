---@class DragonSoulSkillInfo @注释
DragonSoulSkillInfo = class()
local this = DragonSoulSkillInfo

function this:ctor()

end

function this:Reset()
    self.gameStart = false
    self.comboSkillCfgId = nil
    self.comboSkillLevel = nil
    self.lateSkillEffectId = nil
    self.dragonSoulSkillCheck = nil
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.gameStart = false
    self.dragonSoulSkillCheck = false
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ROLE_SETTINGS, self.RES_ROLE_SETTINGS, self)
    --SL:RegisterLuaNetMsg(MessageDef.ResComboSkillInfoMessage, self.ResComboSkillInfoMessage, self)
    --SL:RegisterLUAEvent(LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE, self.LUA_EVENT_ENTER_MAP, self)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_COMBO_SKILL_MODEL_VIEW, self.RES_COMBO_SKILL_MODEL_VIEW, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
end

function this:SetRoleDragonSkillSetting(message)
    if message and message.type == ERoleSettingType_Out.DragonSoulSkillShow then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UPDATE_ROLE_SETTING, message)
    end
end

function this:RES_ROLE_SETTINGS(_, message)
    if message then
        local isCheck = false
        for i, v in pairs(message) do
            if tonumber(i) == ERoleSettingType_Out.DragonSoulSkillShow then
                isCheck = true
                self.dragonSoulSkillCheck = v
                SL:SetPlayerComboSkillEffectType(not self.dragonSoulSkillCheck)
                break
            end
        end
        if not isCheck then
            self.dragonSoulSkillCheck = false
            SL:SetPlayerComboSkillEffectType(not self.dragonSoulSkillCheck)
        end
    end
end

---连击级发生变化，刷新玩家身上特效
function this:ResComboSkillInfoMessage(_, message)
    if self.comboSkillCfgId ~= message.skillCfgId or self.comboSkillLevel ~= message.skillLv then
        if self.comboSkillCfgId then
            SL:SetMetaValue(EMetaVarSetKey.RECYCLE_EFFECT_ON_ROLE, self.skillInfo.haloEffect)
        end
        self.comboSkillCfgId = message.skillCfgId
        self.comboSkillLevel = message.skillLv
        ---@type cfg_skill_info_column
        self.skillInfo = SL:GetConfigMultiKeys('cfg_skill_info', self.comboSkillCfgId, self.comboSkillLevel, 'skillID', 'skillLevel')
        if self.gameStart then
            SL:SetMetaValue(EMetaVarSetKey.SET_EFFECT_ON_ROLE, SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID), self.skillInfo.haloEffect, nil, true, EPlayEffectOverType.Loop)
        end
    end
    SL:RefreshPanelALLRedStateKmlByCondition("checkComboSkillUpgrade")
end

function this:RES_COMBO_SKILL_MODEL_VIEW(_, message)
    if message["1"] then
        ---@type cfg_skill_info_column
        local skillInfo = SL:GetConfigMultiKeys('cfg_skill_info', tonumber(message["2"]), tonumber(message["3"]), 'skillID', 'skillLevel')
        if skillInfo and skillInfo.haloEffect > 0 then
            if self.lateSkillEffectId then
                SL:SetMetaValue(EMetaVarSetKey.RECYCLE_EFFECT_ON_ROLE, tonumber(message["1"]), self.lateSkillEffectId)
            end
            SL:SetMetaValue(EMetaVarSetKey.SET_EFFECT_ON_ROLE, tonumber(message["1"]), skillInfo.haloEffect, nil, true, EPlayEffectOverType.Loop)
            self.lateSkillEffectId = skillInfo.haloEffect
        end
    end
end

function this:LUA_EVENT_BAG_CHANGE_AFTER()
    SL:RefreshPanelALLRedStateKmlByCondition("checkComboSkillUpgrade")
end

function this:LUA_EVENT_ENTER_MAP()
    self.gameStart = true
    if self.comboSkillCfgId then
        SL:SetMetaValue(EMetaVarSetKey.SET_EFFECT_ON_ROLE, SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID), self.skillInfo.haloEffect, nil, true, EPlayEffectOverType.Loop)
    end
end

function this:GetRedPointShowStateInMainPanel()
    local comboSkillCfgId
    local comboSkillLevel
    if self.comboSkillCfgId and self.comboSkillCfgId > 0 then
        ---激活
        comboSkillCfgId = self.comboSkillCfgId
        comboSkillLevel = self.comboSkillLevel
    else
        ---未激活
        local job = SL:GetMetaValue(EMetaVarGetKey.JOB)
        local skill_str = SL:GetConfig("cfg_global", 1501).value
        local skillTbl = string.split(skill_str, '|')  --1#1030001#1#0|2#1030002#1#0|3#1030003#1#0
        for i, v in pairs(skillTbl) do
            local tbl = string.split(v, '#')
            if tonumber(tbl[1]) == job then
                comboSkillCfgId = tonumber(tbl[2])
                comboSkillLevel = 0
                break
            end
        end
    end
    if not comboSkillCfgId then return end
    ---@type cfg_skill_info_column
    local skillInfo = SL:GetConfigMultiKeys('cfg_skill_info', comboSkillCfgId, comboSkillLevel + 1, 'skillID', 'skillLevel')
    if skillInfo then
        for i, v in pairs(skillInfo.skillLevelUpItemID) do
            if SL:GetBagItemCount(v[1]) < v[2] then
                return false
            end
        end
    else
        return false
    end
    return true
end
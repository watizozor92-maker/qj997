---@class RedDotInfo
RedDotInfo = class()
local this = RedDotInfo

function this:ctor()

end

function this:Reset()
    self.commonRedPointInfo = {}
end
local conditionEnum = {
    Test = "test",
    checkFinishTask = "checkFinishTask",
    checkFruitItem = "checkFruitItem",
    checkJewelryUpgraded = "checkJewelryUpgraded",
    checkJewelryActive = "checkJewelryActive",
    checkBossOfferReward = "checkBossOfferReward",
    checkMasterTalent = "checkMasterTalent",
    checkGodDescentMonster = "checkGodDescentMonster",
    checkEquipStrength = "checkEquipStrength",
    checkEquipAppend = "checkEquipAppend",
    checkEquipLucky = "checkEquipLucky",
    checkMainRechargeRed = "checkMainRechargeRed",
    checkMainActivityRed = "checkMainActivityRed",
    checkEfficiencyNewRed = "checkEfficiencyNewRed",
    checkVIPRedDot = "checkVIPRedDot",
    checkRechargeLinkRedDot = "checkRechargeLinkRedDot",
    checkShapeShiftCardRedDot = "checkShapeShiftCardRedDot",
    checkOpenServerAthleticsDot = "checkOpenServerAthleticsDot",
    checkMail = "checkMail",
    checkComboSkillUpgrade = "checkComboSkillUpgrade",
    checkArchangelBreakthrough = "checkArchangelBreakthrough",
    checkArchangelTalentPoint = "checkArchangelTalentPoint",
    checkActionArchangelTalent = "checkActionArchangelTalent",
    checkGrailCanStrength = "checkGrailCanStrength",
    serverControl = "serverControl",
    checkLuckyTurnTable = "checkLuckyTurnTable",
    checkMainOperateActivityRed = "checkMainOperateActivityRed",
    checkReceiveAddFriend = "checkReceiveAddFriend",
    checkMainOperateActivitySecondRed = "checkMainOperateActivitySecondRed",
    checkGameGuide = "checkGameGuide",
    checkGamePlay = "checkGamePlay",
    checkBagOwnTypeItem = "checkBagOwnTypeItem",
    checkSkillCanLearn = "checkSkillCanLearn",
    checkUnionReq = "checkUnionReq",
    checkUnionTask = "checkUnionTask"
}

function this:Init()
    SL:AddRedDotConditionFunc(conditionEnum.Test, function()
        return true
    end)
    SL:AddRedDotConditionFunc(conditionEnum.checkFinishTask, function(condition)
        return self:checkFinishTask(condition)
    end)
    SL:AddRedDotConditionFunc(conditionEnum.checkFruitItem, self.checkFruitItem)
    SL:AddRedDotConditionFunc(conditionEnum.checkJewelryUpgraded, self.checkJewelryUpgraded)
    SL:AddRedDotConditionFunc(conditionEnum.checkJewelryActive, self.checkJewelryActive)
    SL:AddRedDotConditionFunc(conditionEnum.checkBossOfferReward, self.checkBossOfferReward)
    SL:AddRedDotConditionFunc(conditionEnum.checkMasterTalent, self.checkMasterTalent)
    SL:AddRedDotConditionFunc(conditionEnum.checkGodDescentMonster, self.checkGodDescentMonster)
    SL:AddRedDotConditionFunc(conditionEnum.checkEquipStrength, self.checkEquipStrength)
    SL:AddRedDotConditionFunc(conditionEnum.checkEquipAppend, self.checkEquipAppend)
    SL:AddRedDotConditionFunc(conditionEnum.checkEquipLucky, self.checkEquipLucky)
    SL:AddRedDotConditionFunc(conditionEnum.checkMainRechargeRed, self.checkMainRechargeRedFuc)
    SL:AddRedDotConditionFunc(conditionEnum.checkMainActivityRed, self.checkMainActivityRedFuc)
    SL:AddRedDotConditionFunc(conditionEnum.checkEfficiencyNewRed, self.checkEfficiencyNewRed)
    SL:AddRedDotConditionFunc(conditionEnum.checkVIPRedDot, self.checkVIPNewRed)
    SL:AddRedDotConditionFunc(conditionEnum.checkRechargeLinkRedDot, self.checkRechargeLinkRedDot)
    SL:AddRedDotConditionFunc(conditionEnum.checkShapeShiftCardRedDot, self.checkShapeShiftCardRedDot)
    SL:AddRedDotConditionFunc(conditionEnum.checkOpenServerAthleticsDot, self.checkOpenServerAthleticsDot)
    SL:AddRedDotConditionFunc(conditionEnum.checkMail, self.checkMail)
    SL:AddRedDotConditionFunc(conditionEnum.checkComboSkillUpgrade, self.checkComboSkillUpgrade)
    SL:AddRedDotConditionFunc(conditionEnum.checkArchangelBreakthrough, self.checkArchangelBreakthrough)
    SL:AddRedDotConditionFunc(conditionEnum.checkArchangelTalentPoint, self.checkArchangelTalentPoint)
    SL:AddRedDotConditionFunc(conditionEnum.checkActionArchangelTalent, self.checkActionArchangelTalent)
    SL:AddRedDotConditionFunc(conditionEnum.checkGrailCanStrength, self.checkGrailCanStrength)
    SL:AddRedDotConditionFunc(conditionEnum.checkLuckyTurnTable, self.checkLuckyTurnTable)
    SL:AddRedDotConditionFunc(conditionEnum.checkMainOperateActivityRed, self.checkMainOperateActivityRedFuc)
    SL:AddRedDotConditionFunc(conditionEnum.checkMainOperateActivitySecondRed, self.checkMainOperateActivitySecondRedFuc)
    SL:AddRedDotConditionFunc(conditionEnum.checkGameGuide, self.checkGameGuideRedFuc)
    SL:AddRedDotConditionFunc(conditionEnum.checkGamePlay, self.checkGamePlayRedFuc)
    SL:AddRedDotConditionFunc(conditionEnum.serverControl, function(condition)
        return self.ServerControl(self, condition)
    end)
    SL:AddRedDotConditionFunc(conditionEnum.checkReceiveAddFriend, self.checkReceiveAddFriend)
    SL:AddRedDotConditionFunc(conditionEnum.checkBagOwnTypeItem, function(condition)
        return self:checkBagOwnTypeItem(condition)
    end)
    SL:AddRedDotConditionFunc(conditionEnum.checkSkillCanLearn, self.checkSkillCanLearn)
    SL:AddRedDotConditionFunc(conditionEnum.checkUnionReq, self.checkUnionReq)
    SL:AddRedDotConditionFunc(conditionEnum.checkUnionTask, self.checkUnionTask)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_COMMON_RED_POINT_MESSAGE, self.CommonRedPointMessage, self)
    ---通用红点使用，1.服务器通知红点信息 RES_COMMON_RED_POINT_MESSAGE 2.策划配置condition为serverControl=红点id
    ---@type table<number,boolean>
    self.commonRedPointInfo = {} -- 通用红点信息，key为红点ID，value为是否显示（新增，并不包含所有红点信息）
    
    
    SL:SetReplaceEngineFunc(EReplaceEngineFunc.CheckSkillRedDotExt,function(skillId,skillLv)
        skillLv = skillLv or 1

        ---@type cfg_skill_info_column
        local skillInfoTbl = SL:GetConfigMultiKeys('cfg_skill_info', skillId, skillLv, 'skillID', 'skillLevel')

        if not skillInfoTbl then
            return false
        end

        if skillInfoTbl.needAtt then
            for _, v in pairs(skillInfoTbl.needAtt) do
                local attrId = v[1]
                local attrVal = v[2]
                local haveAttr = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, attrId)
                if attrVal > haveAttr then
                    return false
                else
                    return true
                end
            end
        end
        return true
        
    end)
end

function this:checkFinishTask(condition)
    if not condition or condition == "" then
        return false
    end
    local taskId = tonumber(string.match(condition, "%[(%d+)%]")) or tonumber(string.match(condition, "=(%d+)$")) or tonumber(condition)
    if not taskId then
        return false
    end
    local finished = SL:GetMetaValue("ALL_FINISH_TASK")
    if type(finished) ~= "table" or #finished == 0 then
        return false
    end
    for _, v in pairs(finished) do
        if tonumber(v) == taskId then
            return true
        end
    end
    return false
end

function this:CommonRedPointMessage(_, message)
    local refreshPanel = {}
    for k, v in pairs(message) do
        local redPointId = tonumber(k)
        ---@type cfg_redDot_new_column
        local redDotTbl = SL:GetConfig("cfg_redDot_new", redPointId)
        if redDotTbl then
            self.commonRedPointInfo[redPointId] = v
            if #redDotTbl.windowsWidgetID > 0 then
                local panelName = redDotTbl.windowsWidgetID[#redDotTbl.windowsWidgetID][1]
                refreshPanel[panelName] = true
            end
        end
    end
    for panelName, _ in pairs(refreshPanel) do
        SL:RefreshPanelALLRedPoint(panelName)
    end
end
---是否有果实
function this:checkRechargeLinkRedDot()
    return InfoManager.rechargeLinkInfo:IsShowRed()
end

---是否有果实
function this:checkFruitItem()
    return InfoManager.fruitInfo:IsFruitCanUse()
end

---是否能够升级首饰
function this:checkJewelryUpgraded()
    ---@type cfg_system_switch_column
    local systemCfg = SL:GetConfig("cfg_system_switch", 10407)
    local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, systemCfg.systemName)
    if not isMeet then
        return false
    end
    return InfoManager.equipJewelryInfo:IsShowLevelRedDot()
end
---是否能够激活首饰卓越词条
function this:checkJewelryActive()
    ---@type cfg_system_switch_column
    local systemCfg = SL:GetConfig("cfg_system_switch", 10407)
    local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, systemCfg.systemName)
    if not isMeet then
        return false
    end
    return InfoManager.equipJewelryInfo:IsShowActiveRedDot()
end

---是否有可领取的奖励
function this:checkBossOfferReward()
    return InfoManager.bossOfferRewardInfo:IsHasBossOfferReward()
end

---是否可兑换经验（职业天赋 技能天赋）或者有加点的（通用天赋）
function this:checkMasterTalent()
    return InfoManager.masterTalentInfo:GetIsMainRed()
end

function this:checkGodDescentMonster()
    return InfoManager.godsDescendInfo.GetRedState()
end

---装备是否可强化
function this:checkEquipStrength()
    ---@type cfg_system_switch_column
    local systemCfg = SL:GetConfig("cfg_system_switch", 10401)
    local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, systemCfg.systemName)
    if not isMeet then
        return false
    end
    for index = 1, 15 do
        local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
        if equip and EquipFunc.EquipIsCanStrength(equip) then
            return true
        end
    end
    return false
end

---装备是否可追加
function this:checkEquipAppend()
    ---@type cfg_system_switch_column
    local systemCfg = SL:GetConfig("cfg_system_switch", 10402)
    local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, systemCfg.systemName)
    if not isMeet then
        return false
    end
    for index = 1, 15 do
        local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
        if equip and EquipFunc.EquipIsCanAppend(equip) then
            return true
        end
    end
    return false
end
---装备是否可追加
function this:checkEquipLucky()
    -----@type cfg_system_switch_column
    local systemCfg = SL:GetConfig("cfg_system_switch", 237)
    local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, systemCfg.systemName)
    if not isMeet then
        return false
    end
    
    for index = 1, 15 do
        local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", 1, index)
        if equip and EquipFunc.EquipIsCanLucky(equip) then
            return true
        end
    end
    return false
end



-- 大天使装备是否可以突破
function this:checkArchangelBreakthrough()
    return table.count(InfoManager.archangeEquipInfo.canBreakthrough) > 0
end

-- 是否有可点大天使装备天赋点
function this:checkArchangelTalentPoint()
    return InfoManager.archangeEquipInfo.isTalent
end

-- 是否有可激活的大天使大师天赋
function this:checkActionArchangelTalent()
    return InfoManager.archangeEquipInfo.isMasterRed
end

function this:checkGrailCanStrength()
    return table.count(InfoManager.archangeEquipInfo.canGrailStrength) > 0
end

--主界面福利按钮红点逻辑：子页签有红点则亮红点
function this:checkMainRechargeRedFuc()
    for k, v in pairs(InfoManager.mainRechargeInfo.mainRechargeRedsTbl) do
        if v then
            local cfgData = SL:GetConfigMultiKeys("sub_mainRecharge", k, "togName")
            if not table.isNullOrEmpty(cfgData) then
                if cfgData.showCondition == "" or ConditionManager.Check4D(cfgData.showCondition) then
                    return true
                end
            end
        end
    end
    return false
end

--主界面活动按钮红点逻辑：子页签有红点则亮红点
function this:checkMainActivityRedFuc()
    for k, v in pairs(InfoManager.mainActivityInfo.mainActivityRedsTbl) do
        if v then
            local cfgData = SL:GetConfigMultiKeys("sub_mainActivity", k, "togName")
            if not table.isNullOrEmpty(cfgData) then
                if cfgData.showCondition == "" or ConditionManager.Check4D(cfgData.showCondition) then
                    return true
                end
            end
        end
    end
    return false
end

--主界面运营活动按钮红点逻辑：子页签有红点则亮红点
function this:checkMainOperateActivityRedFuc()
    if InfoManager.mainOperateActivityInfo.isOperateActivityMainBtnShow then
        if not table.isNullOrEmpty(InfoManager.mainOperateActivityInfo.operateMainActivityRedsTbl) then
            for k, v in pairs(InfoManager.mainOperateActivityInfo.operateMainActivityRedsTbl) do
                if v then
                    local cfgData = SL:GetConfigMultiKeys("cfg_sub_OperateActivity", k, "togName")
                    if not table.isNullOrEmpty(cfgData) then
                        if InfoManager.mainOperateActivityInfo:JudgeThisSubtypeActivityIsOpen(cfgData.subType) then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end
--主界面运营活动2按钮红点逻辑：子页签有红点则亮红点
function this:checkMainOperateActivitySecondRedFuc()
    if InfoManager.mainOperateActivitySecondInfo.isOperateActivityMainBtnShow then
        if not table.isNullOrEmpty(InfoManager.mainOperateActivitySecondInfo.operateMainActivityRedsTbl) then
            for k, v in pairs(InfoManager.mainOperateActivitySecondInfo.operateMainActivityRedsTbl) do
                if v then
                    local cfgData = SL:GetConfigMultiKeys("cfg_sub_OperateActivity", k, "togName")
                    if not table.isNullOrEmpty(cfgData) then
                        if InfoManager.mainOperateActivitySecondInfo:JudgeThisSubtypeActivityIsOpen(cfgData.subType) then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

---游戏攻略红点
function this:checkGameGuideRedFuc()
    local result = InfoManager.qjAcademyInfo:GetGuideRedDot()
    return result
end

---玩法红点
function this:checkGamePlayRedFuc()
    return InfoManager.qjAcademyInfo:GetGamePlayRedDot()
end

---效率红点
function this:checkEfficiencyNewRed()
    return InfoManager.uiEfficiencyNewInfo:GetAllIsEfficiencyRedDot()
end

function this:checkVIPNewRed()
    local isShow = false
    for key, value in pairs(InfoManager.newVipInfo.allVIPRedPoint) do
        if value then
            isShow = true
            break
        end
    end
    return isShow
end

function this:checkShapeShiftCardRedDot()
    return InfoManager.shapeShiftCardInfo:RefreshMainIconRedPoint()
end
---是否有果实
function this:checkOpenServerAthleticsDot()
    return InfoManager.openServerAthleticsInfo:IsShowRed()
end

function this:checkMail()
    local no_read_mails = SL:GetMetaValue(EMetaVarGetKey.GET_MAIL_UNREAD)
    local no_receive_mails = SL:GetMetaValue(EMetaVarGetKey.GET_MAIL_ITEMS)
    if (no_read_mails and table.count(no_read_mails) > 0) or (no_receive_mails and table.count(no_receive_mails) > 0) then
        return true
    end
    return false
end
--连击技能是否能升级
function this:checkComboSkillUpgrade()
    return InfoManager.dragonSoulSkillInfo:GetRedPointShowStateInMainPanel()
end

function this:ServerControl(condition)
    local conditionValue = string.split(condition, "=")[2]
    return self.commonRedPointInfo[tonumber(conditionValue)]
end

function this:checkLuckyTurnTable()
    return InfoManager.luckyTurnTableInfo:IsRedDot()
end

--检查是否接收到好友申请
function this:checkReceiveAddFriend()
    local friendApplyList = SL:GetFriendData(EFriendRelation.ApplyList)
    if friendApplyList and table.count(friendApplyList) > 0 then
        return true
     end
    return false
end

--检查背包拥有某个类型子类型的道具
function this:checkBagOwnTypeItem(condition)
    local bagItems = SL:GetMetaValue(EMetaVarGetKey.BAG_DATA)
    if not bagItems then
        return false
    end
    local conditionValue = string.split(condition, "=")[2]
    local split = string.split(conditionValue, "#")
    local itemtype = tonumber(split[1])
    local subType = tonumber(split[2])
    local checkCareer = tonumber(split[3]) == 1
    local baseCareer = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN).baseCareer
    for _, items in pairs(bagItems) do
        for _, item in pairs(items) do
            ---@type cfg_item_column
            local itemTbl = SL:GetConfig("cfg_item", item.cfgId)
            if itemTbl.type == itemtype and itemTbl.subType == subType then
                if checkCareer then
                    for _, v in pairs(itemTbl.job) do
                        if v[1] == baseCareer then
                           return true 
                        end
                    end
                else
                    return true 
                end
            end
        end 
    end
    return false
end

function this:checkSkillCanLearn()
    local skillList = SL:GetMetaValue(EMetaVarGetKey.SKILL_ID_LIST_DATA)
    local meLv = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    for _, v in pairs(skillList) do
        ---@type Skill
        local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, v)
        if not skill and SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_IS_UNLOCK, v) then
            local skillLv = skill and skill.level or 1
            ---@type cfg_skill_info_column
            local skillInfoTbl = SL:GetConfigMultiKeys('cfg_skill_info', v, skillLv, 'skillID', 'skillLevel')
            -- --职业
            -- local careerIsMeet = false
            -- ---@type cfg_career_column
            -- local careerTbl = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)
            -- for _, v in pairs(skillInfoTbl.needCareer) do
            --     if v[1] == careerTbl.baseCareer then
            --         if v[2] <= careerTbl.careerRank then
            --             careerIsMeet = true
            --             break
            --         end
            --     end
            -- end
            -- --等级
            -- local isMeetLv
            -- local needLv1 = skillInfoTbl.needLevel[1] or 0
            -- local needLv2 = skillInfoTbl.needLevel[2]
            -- if needLv2 then
            --     isMeetLv = meLv >= needLv1 and meLv <= needLv2
            -- else
            --     isMeetLv = meLv >= needLv1
            -- end
            -- if careerIsMeet and isMeetLv then
            --     if #skillInfoTbl.skillLevelUpItemID > 0 then
            --         local costId = skillInfoTbl.skillLevelUpItemID[1][1]
            --         local costCount = skillInfoTbl.skillLevelUpItemID[1][2]
            --         local bagCount = SL:GetBagItemCount(costId)
            --         if bagCount >= costCount then
            --            return true 
            --         end
            --     end
            -- end
            if #skillInfoTbl.skillLevelUpItemID > 0 then
                local costId = skillInfoTbl.skillLevelUpItemID[1][1]
                local costCount = skillInfoTbl.skillLevelUpItemID[1][2]
                local bagCount = SL:GetBagItemCount(costId)
                if bagCount >= costCount then
                    return true 
                end
            end
        end
    end
    return false
end

function this:checkUnionReq()
    return InfoManager.unionBossInfo:checkUnionReq()
end

function this:checkUnionTask()
    return InfoManager.unionElectionInfo:IsHasTaskRedDot()
end

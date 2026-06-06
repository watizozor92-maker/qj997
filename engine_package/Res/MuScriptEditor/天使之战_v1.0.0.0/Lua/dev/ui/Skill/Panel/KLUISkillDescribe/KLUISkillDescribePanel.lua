---@class KLUISkillDescribePanel:UIKmlLuaPanelBase
---@field view KLUISkillDescribePanelView
local KLUISkillDescribePanel = class(UIKmlLuaPanelBase)
local this = KLUISkillDescribePanel
---创建时调用一次
function this:Init()
    self.needAtt = {}
    self.needAttrCtrls = {}
    GUI:SetZIndex(self.view.bgAttr,201)
    GUI:DataListInitData(self.view.attrData,
            function()
                return #self.needAtt
            end,
            nil,
            nil,
            function(realIndex)
                local txtCtrl = GUI:GetChildControl(self.view.attrData, realIndex, 'attrStr')
                local luaIndex = realIndex + 1
                local attrId = self.needAtt[luaIndex][1]
                local attrVal = self.needAtt[luaIndex][2]
                local haveAttr = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, attrId)

                ---@type cfg_att_info_column
                local attrTbl = SL:GetConfig("cfg_att_info", attrId)

                GUI:Text_setString(txtCtrl, attrTbl.name .. "  " .. attrVal)
                if attrVal > haveAttr then
                    GUI:Text_setTextColor(txtCtrl, "#ff2323")
                else
                    GUI:Text_setTextColor(txtCtrl, "#00ff00")
                end
            end
    )
end

---创建或者刷新界面数据时调用
function this:Refresh()

    if self.args and self.args.skillId then
        self.skillId = self.args.skillId
        self:RefreshSkillInfo(self.skillId)
    elseif self.args and self.args.baseUI then
        if self.args.baseUI.curSelectId then
            self.skillId = self.args.baseUI.curSelectId
            self:RefreshSkillInfo(self.skillId)
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CostTips, self, self.AddCostOnClick)
    GUI:AddOnClickEvent(self.view.BtnLearn, self, self.BtnLearnOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_SELECT_SKILL_UI, self.SelectSkill, self)

    SL:RegisterLUAEvent(Event.SkillChange, self.ResSkillChangeMessage, self)

    SL:RegisterLUAEvent(Event.BagInfo_Change, self.BagInfo_Change, self)
    GUI:AddOnClickEvent(self.view.costItem, self, self.OnCostItemOnClick)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.closeBtnOnClick)
end
function this:closeBtnOnClick()
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel")
    SL.ShowMainPanel()
end
function this:OnCostItemOnClick()
    SL:OpenTips(nil, self.costId)
end

function this:BagInfo_Change()
    self:RefreshSkillInfo(self.skillId)
end

---@param eventData SkillProtos.SkillChangeRes
function this:ResSkillChangeMessage(_, eventData)
    if not eventData or not eventData.skillInfo then
        return
    end
    for _, skillInfo in pairs(eventData.skillInfo) do
        if skillInfo.skillId == self.skillId then
            self:RefreshSkillInfo(self.skillId)
        end
    end
end

function this:AddCostOnClick()
    return SL:CommonItemGetPath(nil, self.costId)
end

function this:BtnLearnOnClick()
    --点击学习技能或者升级技能
    if not self.skillId then
        return
    end

    if not self.canUp then
        SL:CommonItemGetPath(nil, self.costId)
        SL:TipMessage(SL:GetConfig('cfg_string', 253).text, 1, NoticeType.NoticeMid)--"道具数量不足", 
        return
    end
    if not self.isLearned and not self.isOpen then
        SL:TipMessage(SL:GetConfig('cfg_string', 300).text, 1, NoticeType.NoticeMid)--"学习技能，未达到条件
        return
    end
    SL:ReqUpSkillMessage(self.skillId)

end

---@param skillItem KLUISkillItem
function this:SelectSkill(_, skillItem)
    return self:RefreshSkillInfo(skillItem.skillId)
end

---@param skillId number
function this:RefreshSkillInfo(skillId)
    self.skillId = skillId

    if not self.skillUI then
        ---@type KLUISkillInfoPanel
        self.skillUI = GUI:GetUI("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel")
    end
    ---@type Skill
    local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, self.skillId)
    local skillLv = skill and skill.level or 1
    if self.skillUI.skillShowType == E_SkillShowType.Transfer then
        self.isLearned = true
        local transferSkill = InfoManager.shapeShiftCardInfo:GetTransferSkillInfoBySkillId(self.skillId)
        skillLv = transferSkill.level
    else
        self.isLearned = skill ~= nil
    end

    ---@type cfg_skill_info_column
    local skillInfoTbl = SL:GetConfigMultiKeys('cfg_skill_info', self.skillId, skillLv, 'skillID', 'skillLevel')

    local spriteName = string.isNullOrEmpty(skillInfoTbl.icon) and "" or skillInfoTbl.icon
    GUI:Image_loadTexture(self.view.skillIcon, spriteName, "Atlas/UIOutSkillIcon.spriteatlas")

    self.isOpen = self:UpdateOpenConds(skillInfoTbl)

    local nextLv = self.isLearned and skillLv + 1 or 1
    ---@type cfg_skill_info_column
    local nextSkillInfoTbl = SL:GetConfigMultiKeys('cfg_skill_info', self.skillId, nextLv, 'skillID', 'skillLevel')

    self.canUp = false

    if self.isLearned then
        --学习过技能
        GUI:SetActive(self.view.Unlearned, false)
        GUI:SetActive(self.view.desc1, true)
        GUI:SetActive(self.view.SpTag5, true)
        GUI:SetActive(self.view.skillDes1,true)
        --技能等级
        GUI:Text_setString(self.view.levelTxt1, "该技能已学习")
        
        if cfg_equip_angelTalentLv_post.IsAngelTalentSkill(self.skillId) then
            local angelTalentLvTbl = cfg_equip_angelTalentLv_post.GetAngleTalentLvTbl(self.skillId, skillLv)
            --技能描述
            if angelTalentLvTbl then
                GUI:Text_setString(self.view.skillDes1, angelTalentLvTbl.description)
                
                GUI:Text_setString(self.view.newDesc, angelTalentLvTbl.description)
            else
                GUI:Text_setString(self.view.skillDes1, "")
                GUI:Text_setString(self.view.newDesc, "")
            end
        else
            --技能描述
            GUI:Text_setString(self.view.skillDes1, skillInfoTbl.tips)
            GUI:Text_setString(self.view.newDesc, skillInfoTbl.tips)
        end

        GUI:Text_setString(self.view.SkillName, skillInfoTbl.name)--.. " <color=#e6e600>" .. skillLv .. "级</color>")
        GUI:setVisible(self.view.nextLevel, false)
        GUI:SetActive(self.view.SpTag6, false)
        GUI:SetActive(self.view.skillDes2,false)
        GUI:SetActive(self.view.maxLevelTips, false)
        GUI:SetActive(self.view.CostShow, false)
        GUI:SetActive(self.view.BtnLearn, false)
        GUI:setContentSize(self.view.tips,354, 260)
        GUI:setContentSize(self.view.scrollview2,334,196)
    else
        GUI:setContentSize(self.view.scrollview2,334,127)
        GUI:setContentSize(self.view.tips,354,146)
        GUI:setVisible(self.view.nextLevel, true)
        GUI:SetActive(self.view.Unlearned, true)
        --GUI:SetActive(self.view.desc1, false)
        GUI:SetActive(self.view.SpTag5, false)
        GUI:SetActive(self.view.skillDes1,false)
        GUI:SetActive(self.view.desc2, true)
        GUI:SetActive(self.view.SpTag6, true)
        GUI:SetActive(self.view.skillDes2,true)
        --技能等级
        GUI:Text_setString(self.view.levelTxt2, "下一等级 " .. nextLv .. "级")
        if cfg_equip_angelTalentLv_post.IsAngelTalentSkill(self.skillId) then
            local angelTalentLvTbl = cfg_equip_angelTalentLv_post.GetAngleTalentLvTbl(self.skillId, nextLv)
            --技能描述
            if angelTalentLvTbl then
                GUI:Text_setString(self.view.skillDes2, angelTalentLvTbl.description)
                GUI:Text_setString(self.view.newDesc, angelTalentLvTbl.description)
            else
                GUI:Text_setString(self.view.skillDes2, "")
                GUI:Text_setString(self.view.newDesc, "")
            end
        else
            --技能描述
            GUI:Text_setString(self.view.skillDes2, nextSkillInfoTbl.tips)
            GUI:Text_setString(self.view.newDesc, nextSkillInfoTbl.tips)
        end

        
        GUI:Text_setString(self.view.SkillName, skillInfoTbl.name)
        if #skillInfoTbl.skillLevelUpItemID > 0 then
            GUI:SetActive(self.view.CostShow, true)

            self.costId = skillInfoTbl.skillLevelUpItemID[1][1]
            local costCount = skillInfoTbl.skillLevelUpItemID[1][2]
            GUI:Item_setItemId(self.view.costItem, self.costId)

            local ownCount = SL:GetMetaValue(EMetaVarGetKey.MONEY, self.costId)
            local costStr = string.format("(%s/%s)", ownCount, costCount)
            GUI:Text_setString(self.view.costCount, costStr)

            if ownCount >= costCount then
                self.canUp = true
                GUI:Text_setTextColor(self.view.costCount, "#00ff00")
            else
                GUI:Text_setTextColor(self.view.costCount, "#ff2323")
            end
            GUI:Button_setTitleText(self.view.BtnLearn, "学习")
            GUI:SetActive(self.view.BtnLearn, true)
        else
            GUI:SetActive(self.view.CostShow, false)
            GUI:SetActive(self.view.BtnLearn, false)
        end

        GUI:SetActive(self.view.maxLevelTips, false)
    end
    
    GUI:SetActive(self.view.scrollview1,false)
    self:UpdateSkillNumValue(skillInfoTbl)
--[[    if skillInfoTbl.targetBuffID and skillInfoTbl.targetBuffID[1] then
        local baseValue,timeValue = self:getSkillValue(skillInfoTbl.targetBuffID[1][1])
        logError(baseValue..timeValue)
    end]]
end
-- 计算技能buff值
function this:getSkillValue(buffId)
    local config = SL:GetConfig("cfg_buff_Calculation", buffId)
    if table.isNullOrEmpty(config) then
        return 0
    end
    local mylevel = SL:GetMetaValue("LEVEL")
    local level =config.level
    local num = level * mylevel
    local way = config.att
    local baseValue = 0
    for _, v in pairs(way) do
        local data = 0
        if v[2] then
            data = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID",tonumber(v[1])) * tonumber(v[2]) / 10000
        else
            baseValue = v[1]
        end
        baseValue = baseValue + data
    end
    baseValue = baseValue + num
    way = config.time
    local timeValue = 0
    for _, v in pairs(way) do
        local data = 0
        if v[2] then
            data = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID",tonumber(v[1])) * tonumber(v[2]) / 10000
        else
            timeValue = v[1]
        end
        timeValue = timeValue + data
    end
    timeValue = timeValue + num
    return baseValue,timeValue
end
---@param skillInfoTbl cfg_skill_info_column
function this:UpdateOpenConds(skillInfoTbl)
    --职业
    local isMeet = false
    ---@type cfg_career_column
    local careerTbl = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)
    for _, v in pairs(skillInfoTbl.needCareer) do
        if v[1] == careerTbl.baseCareer then
            if v[2] <= careerTbl.careerRank then
                careerTbl = SL:GetConfigMultiKeys("cfg_career", v[1], v[2], "baseCareer", "careerRank")
                GUI:Text_setString(self.view.Condition_1, careerTbl.name)
                isMeet = true
                break
            else
                careerTbl = SL:GetConfigMultiKeys("cfg_career", v[1], v[2], "baseCareer", "careerRank")
                GUI:Text_setString(self.view.Condition_1, careerTbl.name)
            end
        end
    end

    if isMeet then
        GUI:Text_setTextColor(self.view.Condition_1, "#00ff00")
        GUI:SetActive(self.view.bingo1, true)
    else
        GUI:Text_setTextColor(self.view.Condition_1, "#ff0000")
        GUI:SetActive(self.view.bingo1, false)
    end

    --等级

    local needLv1 = skillInfoTbl.needLevel[1] or 0
    if needLv1 > 1 then
        local needLv2 = skillInfoTbl.needLevel[2]

        local meLv = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        local isMeetLv = false
        if needLv2 then
            isMeetLv = meLv >= needLv1 and meLv <= needLv2
        else
            isMeetLv = meLv >= needLv1
        end

        GUI:Text_setString(self.view.Condition_2, "角色 " .. needLv1 .. "级")
        if isMeetLv then
            GUI:Text_setTextColor(self.view.Condition_2, "#00ff00")
            GUI:SetActive(self.view.bingo2, true)
        else
            isMeet = false
            GUI:Text_setTextColor(self.view.Condition_2, "#ff0000")
            GUI:SetActive(self.view.bingo2, false)
        end
    end
    GUI:setVisible(self.view.ConditionLayout_2, needLv1 > 1)

    --武器限制
    GUI:Text_setString(self.view.Condition_3, "武器技能")
    if SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_EQUIP, skillInfoTbl.skillID, skillInfoTbl.skillLevel) then
        GUI:Text_setTextColor(self.view.Condition_3, "#00ff00")
        GUI:SetActive(self.view.bingo3, true)
    else
        isMeet = false
        GUI:Text_setTextColor(self.view.Condition_3, "#ff0000")
        GUI:SetActive(self.view.bingo3, false)
    end
    if table.isNullOrEmpty(skillInfoTbl.needWeapon) then
        GUI:SetActive(self.view.ConditionLayout_3,false)
    else
        GUI:SetActive(self.view.ConditionLayout_3,true)
    end
    --属性
    if skillInfoTbl.needAtt and #skillInfoTbl.needAtt > 0 then
        local isMeetAttr = true
        GUI:SetActive(self.view.ConditionLayout_4, true)
        for _, v in pairs(skillInfoTbl.needAtt) do
            local attrId = v[1]
            local attrVal = v[2]
            local haveAttr = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, attrId)
            if attrVal > haveAttr then
                isMeet = false
                isMeetAttr = false
                break
            end
        end

        --GUI:Text_setString(self.view.Condition_4, "属性")
        if isMeetAttr then
            GUI:Text_setTextColor(self.view.Condition_4, "#00ff00")
            GUI:SetActive(self.view.bingo4, true)
        else
            isMeet = false
            GUI:Text_setTextColor(self.view.Condition_4, "#ff0000")
            GUI:SetActive(self.view.bingo4, false)
        end
        local h = #skillInfoTbl.needAtt * 25
        GUI:setContentSize(self.view.bgAttr, 150, h)
        self.needAtt = skillInfoTbl.needAtt
        local attInfo = self.needAtt[1]
        GUI:Text_setString(self.view.Condition_4, SL:GetConfig("cfg_att_info", attInfo[1]).name.. "  ".. tostring(attInfo[2]))
        --GUI:AddOnClickEvent(self.view.btnArrow, self, self.OnDropClick)
        --self.isShowAttr = false
        --GUI:Image_loadTexture(self.view.btnArrow, "ty_down", "Atlas/TS_Common.spriteatlas")
        --GUI:SetActive(self.view.bgAttr, false)
    else
        GUI:SetActive(self.view.ConditionLayout_4, false)
        self.needAtt = { }
    end

    return isMeet
end

---@param skillInfoTbl cfg_skill_info_column
function this:UpdateSkillNumValue(skillInfoTbl)
    GUI:Text_setText(self.view.Text_SkillAtk, tostring(skillInfoTbl.skillatk))
    GUI:Text_setText(self.view.Text_RangeValue, tostring(skillInfoTbl.releaseRange[1]))
    if skillInfoTbl.costMp > 0 then
        GUI:Text_setText(self.view.Text_MpValue, tostring(skillInfoTbl.costMp))
    else
        GUI:Text_setText(self.view.Text_MpValue, ToolFunc.NumberToStringRemoveZero(skillInfoTbl.costMp / 100).."%")
    end
    
    GUI:Text_setText(self.view.Text_AGValue, tostring(skillInfoTbl.newConsumeAG))
end

function this:OnDropClick()
    if self.isShowAttr then
        GUI:SetActive(self.view.bgAttr, false)
        self.isShowAttr = false
        GUI:Image_loadTexture(self.view.btnArrow, "ty_down", "Atlas/TS_Common.spriteatlas")
        return
    end
    GUI:Image_loadTexture(self.view.btnArrow, "ty_up", "Atlas/TS_Common.spriteatlas")
    self.isShowAttr = true
    GUI:SetActive(self.view.bgAttr, true)
    GUI:DataListUpdateData(self.view.attrData)

end

function this:Close()
    self.skillUI = nil
end

return this

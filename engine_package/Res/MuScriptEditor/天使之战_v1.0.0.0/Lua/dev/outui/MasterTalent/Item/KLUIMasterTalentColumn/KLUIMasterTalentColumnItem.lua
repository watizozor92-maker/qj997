---@class KLUIMasterTalentColumnItem:UIKmlLuaPanelBase
---@field view KLUIMasterTalentColumnItemView
local KLUIMasterTalentColumnItem = class(UIKmlLuaPanelBase)
local this =KLUIMasterTalentColumnItem
---创建时调用一次
function this:Init()
    
    self.SkillDataList = {}
    self.type = EMasterTalentType.CAREER
    
    GUI:DataListInitData(self.view.SkillDataList,function()
        return self:SkillDataListItemCountFunc()
    end,function(realIndex)
        return self:SkillDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:SkillDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SkillDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

--------------------------------技能-------------------------------------------------------
function this:SkillDataListItemCountFunc()
    return #self.SkillDataList
end

function this:SkillDataListItemGetFunc(realIndex)
end

function this:SkillDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:SkillDataListItemUpdateFunc(realIndex, kmlcontrol)
    local _skillBG = GUI:GetChildControl(self.view.SkillDataList,realIndex,'SkillBG')
    local _skillIcon = GUI:GetChildControl(self.view.SkillDataList,realIndex,'SkillIcon')
    local _skillMask = GUI:GetChildControl(self.view.SkillDataList,realIndex,'SkillMask')
    local _skillLv = GUI:GetChildControl(self.view.SkillDataList,realIndex,'SkillLv')
    local _skillButton = GUI:GetChildControl(self.view.SkillDataList,realIndex,'SkillButton')
    local _skillSign = GUI:GetChildControl(self.view.SkillDataList,realIndex,'SkillSign')
    local _skillLight = GUI:GetChildControl(self.view.SkillDataList,realIndex,'SkillBG_Light')
    
    local skillLv = 0
    GUI:Text_setString(_skillLv,"")
    GUI:SetActive(_skillSign,false)
    GUI:SetActive(_skillLight,false)
    --职业天赋
    if self.type == EMasterTalentType.CAREER then
        ---@type cfg_master_protalent_column
        local data = self.SkillDataList[realIndex + 1]
        if data.type == 1 then--1天赋；2技能
            self:SetSkillBG(_skillBG,1)
        elseif data.type == 2 then
            self:SetSkillBG(_skillBG,3)
        end
        GUI:Image_loadTexture(_skillIcon,data.icon,"Atlas/UIOutSkillIcon.spriteatlas")

        skillLv = InfoManager.masterTalentInfo:GetMasterLevel(self.type,data.series,data.id)

        GUI:Text_setString(_skillLv,skillLv.."/"..data.minMaxLevel[2])
        ---点数够就不遮罩
        GUI:SetActive(_skillMask,not InfoManager.masterTalentInfo:IsCanUpLevel(data.id,data.series,nil,self.type))
        GUI:AddOnClickEvent(_skillButton,self,self.OnClickCareerTalent,{data})
        self:ShowUpLevelIconEff(data.id,_skillLight)
    elseif self.type == EMasterTalentType.SKILL then--技能天赋
        ---@type cfg_master_skilltalent_column
        local data = self.SkillDataList[realIndex + 1]
        if data.steps == 0 then
            GUI:Image_loadTexture(_skillMask,"Knob_1","Atlas/Common.spriteatlas")
            GUI:SetActive(_skillMask,false)
            self:SetSkillBG(_skillBG,4)
        else
            skillLv = InfoManager.masterTalentInfo:GetMasterLevel(self.type,data.series,data.id)

            GUI:Text_setString(_skillLv,skillLv.."/"..data.minMaxLevel[2])
            GUI:SetActive(_skillMask,false)
            GUI:SetActive(_skillMask,not InfoManager.masterTalentInfo:IsCanUpLevel(data.id,data.series,data.steps,self.type))

            self:SetSkillBG(_skillBG,data.steps)
            GUI:Image_loadTexture(_skillMask,"bg_tips","Atlas/Common.spriteatlas")
            GUI:SetActive(_skillSign,true)
            GUI:Image_loadTexture(_skillSign,"icon-"..data.steps,"Atlas/UIMasterTalent.spriteatlas")
        end
        GUI:Image_loadTexture(_skillIcon,data.icon,"Atlas/UIOutSkillIcon.spriteatlas")
        GUI:AddOnClickEvent(_skillButton,self,self.OnClickSkillTalent,{data})
        self:ShowUpLevelIconEff(data.id,_skillLight)
    elseif self.type == EMasterTalentType.COMMON then--通用天赋
        ---@type cfg_master_commontalent_column
        local data = self.SkillDataList[realIndex + 1]
        if not data.id then--无数据
            GUI:SetActive(_skillBG,false)
            GUI:SetActive(_skillIcon,false)
            GUI:SetActive(_skillMask,false)
            GUI:SetActive(_skillLv,false)
            GUI:SetActive(_skillButton,false)
        else
            self:SetSkillBG(_skillBG,2)

            skillLv = InfoManager.masterTalentInfo:GetMasterLevel(self.type,nil,data.id)
            
            GUI:Text_setString(_skillLv,skillLv.."/"..data.minMaxLevel[2])
            ---点数够就不遮罩
            GUI:SetActive(_skillMask,not InfoManager.masterTalentInfo:IsCanUpLevel(data.id,data.series,data.steps,self.type))
            GUI:AddOnClickEvent(_skillButton,self,self.OnClickCommonTalent,{data})
            GUI:Image_loadTexture(_skillIcon,data.icon,"Atlas/UIOutSkillIcon.spriteatlas")
            self:ShowUpLevelIconEff(data.id,_skillLight)
        end
    end
end

---显示升级技能效果
function this:ShowUpLevelIconEff(id,Control)
    if self.upLevelCfgId == id then
        self.upLevelCfgId = 0
        GUI:SetImageAlpha(Control, 1, 1, 1, 1)
        GUI:SetActive(Control,true)
        local index = 1
        self.timer = SL:Schedule(  self.timer,0, 0.1, -1, function()
            ---渐隐
            if index <= 0.2 then
                if self.timer then
                    SL:UnSchedule(self.timer)
                    self.timer = nil
                end
                GUI:SetActive(Control,false)
                return
            end
            index = index - 0.15
            GUI:SetImageAlpha(Control, 1, 1, 1, index)
        end)
    end
end

---设置技能背景和坐标偏移
function this:SetSkillBG(Control,index)
    if index > 3 then
        GUI:Image_loadTexture(Control,"img_skill_Strengthened","Atlas/UIMasterTalent.spriteatlas")
        GUI:setPositionY(Control,-5)
        GUI:setContentSize(Control,102,105)
        return
    end
    GUI:Image_loadTexture(Control,"img_skill_bg"..index,"Atlas/UIMasterTalent.spriteatlas")

    if index == 1 then
        GUI:setPositionY(Control,0)
        GUI:setContentSize(Control,75,75)
    elseif index == 2 then
        GUI:setPositionY(Control,0)
        GUI:setContentSize(Control,85,85)
    elseif index == 3 then
        GUI:setPositionY(Control,0)
        GUI:setContentSize(Control,100,100)
    end
end

---点击职业天赋
---@param data cfg_master_protalent_column
function this:OnClickCareerTalent(control,data)
    GUI:UIPanel_Open("dev/outui/SkillTips/Panel/KLUISkillUpTips/KLUISkillUpTipsPanel",_,_,
            {masterID = data[1].id,
             type = EMasterTalentType.CAREER,
             callBack= function()--升级
                 self:UpLevel(data[1].id,data[1].series)
             end})
end

---点击技能天赋
---@param data cfg_master_skilltalent_column
function this:OnClickSkillTalent(control,data)
    if data[1].steps == 0 then
        local skillId = data[1].proTalentId
        local lv = InfoManager.masterTalentInfo:GetMasterLevel(EMasterTalentType.CAREER,data[1].series,skillId)
        if data[1].type == 3 and SL:MeData_GetSkill(skillId) then
            lv = SL:MeData_GetSkill(skillId).level
        end
        GUI:UIPanel_Open("dev/outui/SkillTips/Panel/KLUISkillTips/KLUISkillTipsPanel",_,_,
                {skillID = skillId,skillLevel = lv,tipsType = data[1].type,icon = data[1].icon})
        return
    end
    GUI:UIPanel_Open("dev/outui/SkillTips/Panel/KLUISkillUpTips2/KLUISkillUpTips2Panel",_,_,
            {masterID = data[1].id,type = self.type,
             callBack= function()--升级
                 self:UpLevel(data[1].id,data[1].series,data[1].steps)
             end})
end

---点击通用天赋
---@param data cfg_master_commontalent_column
function this:OnClickCommonTalent(control,data)
    local x,y = nil,nil
    local skillLv = InfoManager.masterTalentInfo:GetMasterLevel(self.type,data[1].series,data[1].id)

    if skillLv < data[1].minMaxLevel[2] then
        x,y = -220,0
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel",nil,nil,
                {
                    maxNum = InfoManager.masterTalentInfo:GetMaxPoint(data[1].id,skillLv,data[1].minMaxLevel[2],self.type,data[1].series),
                    ins = self,
                    isClosePanel = 0,
                    x = 248,
                    y = 90,
                    callback = function(_,addValue)--升级
                        self:UpLevel(data[1].id,nil,nil,addValue)
                    end,
                    intro = "增加点数"
                })
    end
    GUI:UIPanel_Open("dev/outui/SkillTips/Panel/KLUISkillUpTips/KLUISkillUpTipsPanel",_,_,
            {masterID = data[1].id,
             type = EMasterTalentType.COMMON,
             x = x,
             y = y,
             callBack = function() --升级
                 self:UpLevel(data[1].id)
             end
            })
    
end

---升级
function this:UpLevel(id,series,step,upLv)
    local isCan = InfoManager.masterTalentInfo:IsCanUpLevel(id,series,step,self.type,true)
    if not isCan then
        return
    end
    if upLv and upLv == 0 then
        --SL:TipMessage({ "升级次数不能为0", 1, NoticeType.NoticeMid })
        return
    end
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    self.upLevelCfgId = id
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UPGRADE_MASTER_TALENT,
            {type = self.type,cfgId = id,addLv = upLv or 1})
end

------------------------------------------------------------------------------------------------

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:SetSkillData(skillData,type)
    self.SkillDataList = skillData
    self.type = type
    GUI:DataListUpdateData(self.view.SkillDataList)
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

return this

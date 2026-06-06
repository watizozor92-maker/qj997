---@class KLUISkillUpTipsPanel:UIKmlLuaPanelBase
---@field view KLUISkillUpTipsPanelView
local KLUISkillUpTipsPanel = class(UIKmlLuaPanelBase)
local this =KLUISkillUpTipsPanel
---创建时调用一次
function this:Init()
    --天赋
    if self.args and self.args.masterID and self.args.type then
        self.masterID = self.args.masterID
        self.type = self.args.type
        self:ShowMasterInfo()
    end
    self.x = self.args["x"]
    self.y = self.args["y"]
    if self.x then
        GUI:setPositionX(self.view.root,self.x)
    end
    if self.y then
        GUI:setPositionY(self.view.root,self.y)
    end
end

---显示天赋信息
function this:ShowMasterInfo(isRefreshCalc)
    ---是否是技能，技能需要读cfg_skill_info
    local isSkill = false
    ---@type cfg_master_protalent_column
    local _cfg = nil
    if self.type == EMasterTalentType.COMMON then
        _cfg = SL:GetConfig('cfg_master_commontalent',self.masterID)
    elseif self.type == EMasterTalentType.CAREER then
        _cfg = SL:GetConfig('cfg_master_protalent',self.masterID)
        if _cfg.type == 2 then
            isSkill = true
        end
    elseif self.type == EMasterTalentType.SKILL then
        _cfg = SL:GetConfig('cfg_master_skilltalent',self.masterID)
    end
    self.masterLevel = InfoManager.masterTalentInfo:GetMasterLevel(self.type,_cfg.series,_cfg.id)
    ---@type cfg_master_info_column
    local masterNowCfg = InfoManager.masterTalentInfo:GetMasterCfg(self.masterID,self.masterLevel)
    ---@type cfg_master_info_column
    local masterNextCfg = InfoManager.masterTalentInfo:GetMasterCfg(self.masterID,self.masterLevel + 1)
    if isSkill then
        ---@type cfg_skill_info_column
        local nowSkillInfo = nil
        ---@type cfg_skill_info_column
        local nextSkillInfo = nil
        if SL:HasConfigTwoKeys('cfg_skill_info',_cfg.skillId,self.masterLevel,'skillID','skillLevel') then
            nowSkillInfo = SL:GetConfigTwoKeys('cfg_skill_info',_cfg.skillId,self.masterLevel,'skillID','skillLevel')
        end
        if SL:HasConfigTwoKeys('cfg_skill_info',_cfg.skillId,self.masterLevel + 1,'skillID','skillLevel') then
            nextSkillInfo = SL:GetConfigTwoKeys('cfg_skill_info',_cfg.skillId,self.masterLevel + 1,'skillID','skillLevel')
        end
        GUI:Text_setString(self.view.NowSkillInfo,nowSkillInfo and nowSkillInfo.tips or "")
        GUI:Text_setString(self.view.NextSkillInfo,nextSkillInfo and nextSkillInfo.tips or "")
    else
        GUI:Text_setString(self.view.NowSkillInfo,masterNowCfg and masterNowCfg.description or "")
        GUI:Text_setString(self.view.NextSkillInfo,masterNextCfg and masterNextCfg.description or "")
    end
    if self.masterLevel == 0 then
        GUI:Text_setString(self.view.NowSkillInfo,"天赋未激活")
    end
    GUI:Text_setString(self.view.SkillLv,self.masterLevel.."/".._cfg.minMaxLevel[2])
    GUI:Image_loadTexture(self.view.SkillIcon,_cfg.icon,"Atlas/UIOutSkillIcon.spriteatlas")
    GUI:Text_setString(self.view.SkillName,_cfg.name)
    local frontNum = 0
    if masterNextCfg then
        frontNum = masterNextCfg.frontNum
    end
    --前置点数不足显示红色
    if not InfoManager.masterTalentInfo:IsCanUpLevel(_cfg.id,_cfg.series,_cfg.steps,self.type) then
        --"#00ff00" or "#ff2323"
        GUI:Text_setString(self.view.NeedPoint,"<color=#ff2323>"..frontNum.."</color>")
    else
        GUI:Text_setString(self.view.NeedPoint,tostring(frontNum))
    end
    local isMaxLevel = self.masterLevel >= _cfg.minMaxLevel[2]
    GUI:SetActive(self.view.UpButton,not isMaxLevel)
    GUI:SetActive(self.view.NeedPoint,not isMaxLevel)
    if isMaxLevel then
        GUI:Text_setString(self.view.NextSkillInfo,"天赋已点满")
    end
    if isRefreshCalc then
        self:RefreshCalcPanel(_cfg,isMaxLevel)    
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.UpButton,self,self.OnClickUpButton)
    GUI:AddOnClickEvent(self.view.MaskCloseButton,self,self.OnClickCloseButton)

    SL:RegisterLUAEvent(LUA_EVENT_MASTER_SKILL_DATA_CHANGE, self.LUA_EVENT_MASTER_SKILL_DATA_CHANGE, self)
end

---响应：大师变化信息
function this:LUA_EVENT_MASTER_SKILL_DATA_CHANGE(id,message)
    if message and message["type"] then
        local type = tonumber(message["type"])
        if type == self.type then
            self:ShowMasterInfo(true)
        end
    end
end

---刷新输入框
---@param _cfg cfg_master_protalent_column
function this:RefreshCalcPanel(_cfg,isMaxLevel)
    if isMaxLevel then
        GUI:UIPanel_Close("dev/ui/Common/Panel/KLCalc/KLCalcPanel")
        GUI:setPositionX(self.view.root,0)
        GUI:setPositionY(self.view.root,0)
        return
    end
    ---@type KLCalcPanel
    local panel = GUI:GetUI("dev/ui/Common/Panel/KLCalc/KLCalcPanel")
    if panel then
        panel.maxNum = InfoManager.masterTalentInfo:GetMaxPoint(self.masterID,self.masterLevel,_cfg.minMaxLevel[2],self.type,_cfg.series)
        panel:Refresh()
    end
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/outui/SkillTips/Panel/KLUISkillUpTips/KLUISkillUpTipsPanel")
    GUI:UIPanel_Close("dev/ui/Common/Panel/KLCalc/KLCalcPanel")
end

function this:OnClickUpButton()
    if self.args and self.args.callBack then
        self.args.callBack()
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
end

return this

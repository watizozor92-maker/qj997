---@class KLUISkillTipsPanel:UIKmlLuaPanelBase
---@field view KLUISkillTipsPanelView
---@field tipsType number @tips类型： 2.天赋 3.技能
local KLUISkillTipsPanel = class(UIKmlLuaPanelBase)
local this =KLUISkillTipsPanel
---创建时调用一次
function this:Init()
    self.tipsType = 3
    if self.args and self.args.tipsType then
        self.tipsType = self.args.tipsType
    end
    if self.args and self.args.skillID and self.args.skillLevel then
        local level = self.args.skillLevel
        if level == 0 then
            level = 1
        end
        if self.tipsType == 3 then
            if SL:HasConfigTwoKeys('cfg_skill_info',self.args.skillID,level,'skillID','skillLevel') then
                ---@type cfg_skill_info_column
                local skillInfo = SL:GetConfigMultiKeys('cfg_skill_info',self.args.skillID,level,'skillID','skillLevel')
                GUI:Image_loadTexture(self.view.SkillIcon,skillInfo.icon,"Atlas/UIOutSkillIcon.spriteatlas")
                GUI:Text_setString(self.view.SkillName,skillInfo.name)
                if self.args.skillLevel == 0 then
                    GUI:Text_setString(self.view.SkillInfo,"未习得该技能")
                else
                    GUI:Text_setString(self.view.SkillInfo,skillInfo.tips)
                end
                GUI:Text_setString(self.view.SkillLv,tostring(self.args.skillLevel))
                return
            end
        elseif self.tipsType == 2 then
            local cfg = InfoManager.masterTalentInfo:GetMasterCfg(self.args.skillID,level)
            if cfg then
                GUI:Image_loadTexture(self.view.SkillIcon,self.args.icon,"Atlas/UIOutSkillIcon.spriteatlas")
                GUI:Text_setString(self.view.SkillName,cfg.name)

                if self.args.skillLevel == 0 then
                    GUI:Text_setString(self.view.SkillInfo,"未习得该技能")
                else
                    GUI:Text_setString(self.view.SkillInfo,cfg.description)
                end
                GUI:Text_setString(self.view.SkillLv,tostring(self.args.skillLevel))
                return
            end
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton,self,self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.MaskCloseButton,self,self.OnClickCloseButton)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/outui/SkillTips/Panel/KLUISkillTips/KLUISkillTipsPanel")
end

function this:Close()
end

return this

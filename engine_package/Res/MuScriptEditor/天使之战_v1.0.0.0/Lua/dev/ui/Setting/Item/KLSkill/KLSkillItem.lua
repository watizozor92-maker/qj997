---@class KLSkillItem:UIKmlLuaPanelBase
---@field view KLSkillItemView
local KLSkillItem = class(UIKmlLuaPanelBase)
local this =KLSkillItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:RefreshItem(args)
end

---创建或者刷新界面数据时调用
function this:RefreshItem(skillId)
    self.skillId = skillId
    if skillId ~= 0 then
        local skillLevel = SL:GetMetaValue(EMetaVarGetKey.SKILL_LEVEL,skillId)
        ---@type cfg_skill_info_column
        local skillInfoTbl = SL:GetConfigMultiKeys('cfg_skill_info', skillId, skillLevel, 'skillID', 'skillLevel')
        if skillInfoTbl then
            GUI:Image_loadTexture(self.view.SkillIcon,skillInfoTbl.icon,"Atlas/UIOutSkillIcon.spriteatlas")
            GUI:Text_setString(self.view.skillDes,skillInfoTbl.tips)
        end
    else
        GUI:Text_setString(self.view.skillDes,"无")
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.selectSkillBtn,self,self.SelectSkillBtnOnClick)
end

function this:SelectSkillBtnOnClick()
    SL:onLUAEvent(LUA_SELECT_CALL_SKILL,self.skillId)
    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLCallSkill/KLCallSkillPanel")
end


function this:Close()
end

return this

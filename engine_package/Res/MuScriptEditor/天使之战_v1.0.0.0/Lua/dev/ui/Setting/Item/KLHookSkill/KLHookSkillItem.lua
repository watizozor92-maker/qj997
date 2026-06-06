---@class KLHookSkillItem:UIKmlLuaPanelBase
---@field view KLHookSkillItemView
---@field args table
local KLHookSkillItem = class(UIKmlLuaPanelBase)
local this =KLHookSkillItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:SetOnPrefabControlLoaded(self.view.hookSkill_item,function()
        GUI:SetZIndex(self.view.selectToggle_new,2000)
        if self.args.isTransfer then
            local skillId = self.args.skillId
            local isHookSkill = self.args.isHookSkill
            local skillLevel = ""
            local icon, name = InfoManager.shapeShiftCardInfo:GetMonsterIcon(skillId)
            GUI:Image_loadTexture(self.view.skillIcon, icon, "Atlas/UIbianshentb.spriteatlas")
            GUI:Text_setString(self.view.skillName, name .. "变身")
            GUI:Text_setString(self.view.skillLevel, skillLevel)
            GUI:SetIsOnWithoutNotify(self.view.selectToggle_new, isHookSkill == 1)
        else
            local skillId = self.args.skillId
            local isHookSkill = self.args.isHookSkill
            local skillLevel = SL:GetMetaValue(EMetaVarGetKey.SKILL_LEVEL,skillId)
            ---@type cfg_skill_info_column
            local skillInfoTbl = SL:GetConfigMultiKeys('cfg_skill_info', skillId, skillLevel, 'skillID', 'skillLevel')
            if skillInfoTbl then
                GUI:Image_loadTexture(self.view.skillIcon,skillInfoTbl.icon,"Atlas/UIOutSkillIcon.spriteatlas")
                GUI:Text_setString(self.view.skillName,skillInfoTbl.name)
                GUI:Text_setString(self.view.skillLevel,"LV "..skillLevel)
                GUI:SetIsOnWithoutNotify(self.view.selectToggle_new,isHookSkill)
            end
        end
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.selectToggle_new,self,self.SelectHookSkill)
end

function this:SelectHookSkill(control,_,data)
    local isToggle = data[1]
    if self.args.isTransfer then
        self.baseUI:SetTransferSkillInfo(self.args.skillId, isToggle)
    else
        if isToggle then
            SL:SetMetaValue(EMetaVarSetKey.SET_HOOK_ATUO_RELEASE_SKILL,self.args.skillId,self.args.skillId)
        else
            SL:SetMetaValue(EMetaVarSetKey.SET_HOOK_ATUO_RELEASE_SKILL,self.args.skillId,nil)
        end
        local commonSkillId = SL:GetMetaValue(EMetaVarGetKey.SKILL_GET_COMMON_ID)
        if self.args.skillId == commonSkillId then
            local DataManager = SL:Get_G()['DataManager']
            DataManager.hookSkillData = DataManager.hookSkillData or {}
            DataManager.hookSkillData.isCommonSkillHook = isToggle
        end
    end
end

function this:Close()
end

return this

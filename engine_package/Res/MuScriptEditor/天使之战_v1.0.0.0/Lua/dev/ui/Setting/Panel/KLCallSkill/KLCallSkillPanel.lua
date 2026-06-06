---@class KLCallSkillPanel:UIKmlLuaPanelBase
---@field view KLCallSkillPanelView
local KLCallSkillPanel = class(UIKmlLuaPanelBase)
local this =KLCallSkillPanel
---创建时调用一次
function this:Init()
    self.skillData_all_item = {}
    self.skillData = {}
    local skills = SL:GetMetaValue(EMetaVarGetKey.GET_ME_ALL_SKILL)
    if skills then
        ---@param v Skill
        for i, v in pairs(skills) do
            if v.skillTbl.group == ESkillGroup.call then
                table.insert(self.skillData,v.skillId)
            end
        end
    end
    table.insert(self.skillData,0)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:DataListInitData(self.view.callSkillList,function()
        return self:SkillDataListItemCountFunc()
    end,function(realIndex)
        return self:SkillDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:SkillDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SkillDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.callSkillList)
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.CloseBtnOnClick)
end

function this:CloseBtnOnClick()
    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLCallSkill/KLCallSkillPanel")
end

function this:SkillDataListItemCountFunc()
    return #self.skillData
end
function this:SkillDataListItemGetFunc(realIndex)
    local skillId = self.skillData[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/ui/Setting/Item/KLSkill/KLSkillItem",self.view.callSkillList,self,skillId,true)
    self.skillData_all_item[item.view.root] = item
    return item.view.root
end

function this:SkillDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:SkillDataListItemUpdateFunc(realIndex, kmlcontrol)
    local skillId = self.skillData[realIndex + 1]
    self.skillData_all_item[kmlcontrol]:RefreshItem(skillId)
end

function this:Close()
end

return this

---@class KLCareerChangePanel:UIKmlLuaPanelBase
---@field view KLCareerChangePanelView
local KLCareerChangePanel = class(UIKmlLuaPanelBase)
local this = KLCareerChangePanel
---创建时调用一次
function KLCareerChangePanel:Init()
    
end

---创建或者刷新界面数据时调用
function KLCareerChangePanel:Refresh()
    self.currentCareer = self.args.currentCareer
    self.originalCareer = self.args.originalCareer

    --从配置表获取解锁的技能
    ---@type cfg_career_column
    self.config = SL:GetConfig("cfg_career",self.currentCareer)

    GUI:setPosition(self.view.AttUp,0,-20)
    GUI:setPosition(self.view.SkillUnlock,0,-68)
    GUI:setPosition(self.view.EquipUnlock,0,-190)
    GUI:SetActive(self.view.SkillUnlock,true)
    GUI:SetActive(self.view.EquipUnlock,true)
    if #self.config.unlockskill <= 0 and  #self.config.unlockItem <= 0 then
        GUI:SetActive(self.view.SkillUnlock,false)
        GUI:SetActive(self.view.EquipUnlock,false)
        GUI:setPosition(self.view.AttUp,0,-125)
    elseif #self.config.unlockskill <= 0 or #self.config.unlockItem <= 0 then
        if #self.config.unlockskill <= 0 then
            GUI:setPosition(self.view.AttUp,0,-65)
            GUI:setPosition(self.view.EquipUnlock,0,-117)
            GUI:SetActive(self.view.SkillUnlock,false)
        end
        if #self.config.unlockItem <= 0 then
            GUI:setPosition(self.view.AttUp,0,-65)
            GUI:setPosition(self.view.SkillUnlock,0,-117)
            GUI:SetActive(self.view.EquipUnlock,false)
        end

    end
    
    GUI:OSAScrollView_Initialized(self.view.SkillRollRect,nil,self.OSASkillItemUpdateFun,self)
    GUI:OSAScrollView_RefreshList(self.view.SkillRollRect,#self.config.unlockskill)
    --[[for _, skillId in pairs(config.unlockskill) do
        ---@type KLSkillInfoItem
        local skillTemplate = GUI:UIPanel_Open("dev/ui/Career/Item/KLSkillInfoItem/KLSkillInfoItem",self.view.SkillContent,self,nil,true)
        skillTemplate:InitData(skillId,1)
    end
    --从配置表获取解锁的装备
    for _, itemId in pairs(config.unlockItem) do
        GUI:Item_Create(self.view.EquipContent,{
            width = "80",
            height = "80",
            itemid = itemId[1],
            tips = "1",
            noclip = "1",
            mfixsize = "80,80"
        })
    end]]
    GUI:OSAScrollView_Initialized(self.view.EquipRollRect,nil,self.EquipItemUpdateFun,self)
    GUI:OSAScrollView_RefreshList(self.view.EquipRollRect,#self.config.unlockItem)
    --奖励文字描述
    GUI:Text_setString(self.view.TextAttAward,self.config.rewardText)
    --职业名
    ---@type cfg_career_column
    local currentCareer = SL:GetConfig("cfg_career",self.currentCareer)
    GUI:Text_setString(self.view.TextPresentProfession,currentCareer.name)
    local originalCareer = SL:GetConfig("cfg_career",self.originalCareer)
    GUI:Text_setString(self.view.TextOriginalProfession,originalCareer.name)
end

---@param item UIKmlLuaControl
function this:EquipItemUpdateFun(item,index)
    local itemInfo = self.config.unlockItem[index + 1]
    local itemControl = GUI:GetChildById(item,"item")
    GUI:Item_setItemId(itemControl,itemInfo)
    local btnTip = GUI:GetChildById(item,"btn_item_tip")
    GUI:AddOnClickEvent(btnTip,self,self.BtnTipOnClick,itemInfo)
end

function this:BtnTipOnClick(_,itemId)
    SL:OpenTips(nil,itemId)
end

function this:OSASkillItemGetFun(index)
    ---@type KLSkillInfoItem
    local skillTemplate = GUI:UIPanel_Open("dev/outui/Career/Item/KLSkillInfoItem/KLSkillInfoItem",nil,self,nil,true)
    return skillTemplate
end

function this:OSASkillItemUpdateFun(item,index)
    local skillId = self.config.unlockskill[index + 1]
    local skillIcon = GUI:GetChildById(item,"ImageSkillIcon")
    local skillName = GUI:GetChildById(item,"TextSkillName")
    ---@type cfg_skill_info_column
    local skillInfo = SL:GetConfigMultiKeys('cfg_skill_info', skillId, 1, 'skillID', 'skillLevel')
    GUI:Image_loadTexture(skillIcon, skillInfo.icon, "Atlas/UIOutSkillIcon.spriteatlas")
    GUI:Text_setString(skillName, skillInfo.name)
    --item:InitData(skillId, 1)
end

---注册UI事件和服务器消息
function KLCareerChangePanel:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnOk,self,self.BtnOkOnClick)
end

function this:BtnOkOnClick()
    GUI:UIPanel_Close('dev/outui/Career/Panel/KLCareerChangePanel/KLCareerChangePanel')
    
end

function KLCareerChangePanel:Close()
end

return KLCareerChangePanel

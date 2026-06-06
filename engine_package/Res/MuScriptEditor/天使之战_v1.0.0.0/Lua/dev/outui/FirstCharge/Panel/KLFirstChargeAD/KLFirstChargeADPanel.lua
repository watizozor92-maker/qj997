---@class KLFirstChargeADPanel:UIKmlLuaPanelBase
---@field view KLFirstChargeADPanelView
local KLFirstChargeADPanel = class(UIKmlLuaPanelBase)
local this = KLFirstChargeADPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()


end
function this:SetPos()
    local PlayerPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUISystemTop/KLUISystemTopPanel")
    if PlayerPanel and PlayerPanel.systemTemplateList then
        local IsShow = false
        for i, systemItem in pairs(PlayerPanel.systemTemplateList) do
            if systemItem.args.id == 203 then
                IsShow =true
                self.FirstBtn = systemItem
            end
        end
        if IsShow then
            local worldPositionX, worldPositionY = GUI:GetWorldPosition(self.FirstBtn.view.root)
            GUI:SetWorldPosition(self.view.root, worldPositionX-0.6, worldPositionY+0.5, 100)
            GUI:SetActive(self.view.bg,true)
        else
            GUI:SetActive(self.view.bg,false)
        end
    end
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseBtn, self, self.CloseBtnOnClick)
end
function this:CloseBtnOnClick()
    self:SaveComplete()
    SL:HideMainPanel()
    GUI:UIPanel_Open("dev/outui/FirstCharge/Panel/KLFirstCharge/KLFirstChargePanel")
    GUI:UIPanel_Close("dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanel")
    
end
---界面显示时调用一次
function this:Show()
    GUI:SetActive(self.view.root,false)
    if self.args and self.args.count then
        local count = self.args.count + 1
        self.showTimer = self.args.count
        local RoleId = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
        local careerID = SL:GetMetaValue(EMetaVarGetKey.ACTOR_JOB_ID)
        for _,v in pairs(self.args.popUpsPicture) do
            if v[1] and tonumber(v[1]) == careerID then
                PlayerPrefs.SetString("FirstChargeAdPopUpsPictureCareerID" ..RoleId,  v[1])
                PlayerPrefs.SetString("FirstChargeAdPopUpsPictureIcon" ..RoleId,  v[2])
                GUI:Image_loadTexture(self.view.model_icon, v[2], "Atlas/QJ5_UIRechargeMainPanel.spriteatlas")
            end
        end
  
        PlayerPrefs.SetString("FirstChargeAdComplete" ..RoleId, "false")
        PlayerPrefs.Save()
        --[[    local RoleId = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
            self.SaveFirstChargeAd = "FirstChargeAdTime" .. RoleId
            local savePre = PlayerPrefs.GetInt(self.SaveFirstChargeAd)
            local complete = PlayerPrefs.GetString("FirstChargeAdComplete" ..RoleId,"false")
            if complete == "true" then
                GUI:UIPanel_Close("dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanel")
                return
            end
            if savePre > 0 then
                self.showTimer = savePre
                count = self.showTimer + 1
            else
                self.showTimer = 120
                count = self.showTimer + 1
            end]]
        self.timer = SL:Schedule(self.timer, 1, 1, count, function()
            self:SetPos()
     
            self.showTimer = self.showTimer - 1
            local minute = math.floor(self.showTimer / 60)
            local time = string.format("%02d分%02d秒", minute, (self.showTimer - minute * 60))
            GUI:Text_setString(self.view.DevilText, time)
            PlayerPrefs.SetString("FirstChargeAdTime" ..RoleId,  self.showTimer)
            PlayerPrefs.Save()
            GUI:SetActive(self.view.root,true)
            if  self.showTimer <= 0 then
                self:SaveComplete()
                GUI:UIPanel_Close("dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanel")
            end
        end)
    end
end
---创建或者刷新界面数据时调用
function this:Refresh()

end     
function this:SaveComplete()
    local RoleId = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    PlayerPrefs.SetString("FirstChargeAdComplete" ..RoleId, "true")
    PlayerPrefs.Save()
end
function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = nil
    local RoleId = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    if RoleId then
        PlayerPrefs.SetString("FirstChargeAdTime" ..RoleId,  self.showTimer)
        PlayerPrefs.Save()
    end

end

function this:OnHide()
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = nil
end

return this

---@class KLUIExperienceItem:UIKmlLuaPanelBase
---@field view KLUIExperienceItemView
local KLUIExperienceItem = class(UIKmlLuaPanelBase)
---创建时调用一次
function KLUIExperienceItem:Init()
    
end

---创建或者刷新界面数据时调用
function KLUIExperienceItem:Refresh()
    GUI:Image_loadTexture(self.view.experience_item_bg1,self.args.icon,"Atlas/TS_Common.spriteatlas")
    GUI:Text_setString(self.view.experienceName,self.args.name.." "..self.args.exp.."%")
    local leftTime = self.args.endTime - Time.GetServerTime()
    leftTime = math.floor(leftTime / 1000)
    if leftTime > 0 then
        GUI:SetControl_time(self.view.time,leftTime) 
    end
    --GUI:setVisible(self.view.time,leftTime>0)
    --GUI:setVisible(self.view.addBtn,leftTime<=0)
end

---注册UI事件和服务器消息
function KLUIExperienceItem:RegistEvents()
    GUI:AddOnClickEvent(self.view.experience_item_bg1,self,self.OnClickaddBtn)
end

function KLUIExperienceItem:OnClickaddBtn()
    if not string.isNullOrEmpty(self.args.command) then
        GUI:UIPanel_Open(self.args.command,nil,nil,self.args.args)
        SL.HideMainPanel()
    end
end

function KLUIExperienceItem:Close()
end

return KLUIExperienceItem

---@class KLAttPointSuitChoicePanel:UIKmlLuaPanelBase
---@field view KLAttPointSuitChoicePanelView
local KLAttPointSuitChoicePanel = class(UIKmlLuaPanelBase)
local this =KLAttPointSuitChoicePanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local curCareer = self.args.curCareer
    ---@type cfg_career_column
    local careerConfig = SL:GetConfig("cfg_career",curCareer)
    local pics = string.split(careerConfig.recPicture,"|")
    local texts = string.split(careerConfig.recText,"|")
    for i = 1, #pics do
        GUI:UIPanel_Open("dev/outui/Role/Item/KLAttPointSuit/KLAttPointSuitItem",self.view.AttPointSuit,self,{pic=pics[i],text=texts[i],index=i-1},true)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BgClick,self,self.BgClick)
end

function this:BgClick()
    GUI:UIPanel_Close("dev/outui/Role/Panel/KLAttPointSuitChoice/KLAttPointSuitChoicePanel")
end

function this:Close()
end

return this

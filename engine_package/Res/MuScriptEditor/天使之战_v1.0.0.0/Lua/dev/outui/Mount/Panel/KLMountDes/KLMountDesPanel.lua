---@class KLMountDesPanel:UIKmlLuaPanelBase
---@field view KLMountDesPanelView
local KLMountDesPanel = class(UIKmlLuaPanelBase)
local this =KLMountDesPanel
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.bgMask,self,self.OnClickCloseBtn)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnClickCloseBtn)
end

function this:OnClickCloseBtn()
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountDes/KLMountDesPanel")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if SL:GetIsWebGL() then
        GUI:setPositionX(self.view.closeBtn,-290)
    end
    ---@type  cfg_rule_text_column
    local tbl = SL:GetConfig("cfg_rule_text",6,"id")
    GUI:Button_setTitleText(self.view.title,tbl.menutxt)
    GUI:Button_setTitleText(self.view.ContentTxt,tbl.location)
end

function this:Close()
end

return this

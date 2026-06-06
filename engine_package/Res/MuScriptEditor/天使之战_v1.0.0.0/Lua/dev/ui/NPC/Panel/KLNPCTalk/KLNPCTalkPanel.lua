---@class KLNPCTalkPanel:UIKmlLuaPanelBase
---@field view KLNPCTalkPanelView
local KLNPCTalkPanel = class(UIKmlLuaPanelBase)
local this =KLNPCTalkPanel
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

function this:SetContent(content)
    GUI:Text_setString(self.view.ContentTxt, content)   
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.cancelBtn,self,self.ClosePanel)
    GUI:AddOnClickEvent(self.view.bg1,self,self.ClosePanel)
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/ui/NPC/Panel/KLNPCTalk/KLNPCTalkPanel")
end

function this:Close()
    SL.ShowMainPanel()
    if self.args and self.args.cfgId then
       local npcCfgId = tostring(self.args.cfgId) 
       SL:ReqNpcTalk(0, npcCfgId, true, true)
    end
end

return this

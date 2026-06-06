---@class KLQuintonInvasionJoinPanel:UIKmlLuaPanelBase
---@field view KLQuintonInvasionJoinPanelView
local KLQuintonInvasionJoinPanel = class(UIKmlLuaPanelBase)
local this =KLQuintonInvasionJoinPanel
function this:AsyncLoadUI()
        end
---创建时调用一次
function this:Init() 
end

---注册UI事件和服务器消息
function this:RegistEvents()
        GUI:AddOnClickEvent(self.view.btnEnter,self,self.OnCliCkEnterBtn)
        GUI:AddOnClickEvent(self.view.btnClose,self,self.OnCliCkCloseBtn)
end

function this:OnCliCkEnterBtn()
local cond, message = InfoManager.godsDescendInfo.CheckActivityConditionMapId(23001)
    if cond then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_KUNDUN_ENTER)
    else
        SL:TipMessage(message, 1, NoticeType.NoticeMid)
    end
end

function this:OnCliCkCloseBtn()
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLQuintonInvasionJoin/KLQuintonInvasionJoinPanel")
        SL:ShowMainPanel()
end


---界面显示时调用一次
function this:Show()
        
end
---创建或者刷新界面数据时调用
function this:Refresh()

end



function this:Close()
end

return this

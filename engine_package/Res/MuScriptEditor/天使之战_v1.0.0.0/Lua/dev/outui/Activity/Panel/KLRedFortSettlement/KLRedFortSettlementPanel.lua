---@class KLRedFortSettlementPanel:UIKmlLuaPanelBase
---@field view KLRedFortSettlementPanelView
local KLRedFortSettlementPanel = class(UIKmlLuaPanelBase)
local this =KLRedFortSettlementPanel
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLRedFortSettlementPanel",true)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnOK, self, self.BtnCloseOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_Open_MainButtonList, self.LUA_EVENT_Open_MainButtonList, self)
end

function this:LUA_EVENT_Open_MainButtonList()
    SL:HideMainPanel()
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLRedFortSettlement/KLRedFortSettlementPanel")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:HideMainPanel()
    if self.args then
        GUI:Text_setString(self.view.textKillScore,tostring(self.args["1"]))
        GUI:Text_setString(self.view.textRank,tostring(self.args["2"]))
    end
end

function this:Close()
    SL:KeepOpenPanel("KLRedFortSettlementPanel",false)
    SL:ShowMainPanel()
end

return this

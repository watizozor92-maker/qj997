---@class KLTalkBtnPanel:UIKmlLuaPanelBase
---@field view KLTalkBtnPanelView
local KLTalkBtnPanel = class(UIKmlLuaPanelBase)
local this = KLTalkBtnPanel
---创建时调用一次
function this:Init()
    GUI:SetActive(self.view.TalkPanel,false)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:RegisterLUAEvent(LUA_EVENT_NPC_ARRIVE_NEAR,this.LUA_EVENT_NPC_ARRIVE_NEAR,self)
    SL:RegisterLUAEvent(LUA_EVENT_NPC_LEAVE_NEAR,this.LUA_EVENT_NPC_LEAVE_NEAR,self)
    SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE,this.LUA_EVENT_NPC_LEAVE_NEAR,self) 
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.TalkBtn, self, function()
        SL:TalkToNpc(self.args.cfgid)
    end)
end
function this.CloseBtn()
end

function this:Close()
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_ARRIVE_NEAR,this.LUA_EVENT_NPC_ARRIVE_NEAR)
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_LEAVE_NEAR,this.LUA_EVENT_NPC_LEAVE_NEAR)
end

function this:LUA_EVENT_NPC_ARRIVE_NEAR(_,message)
    GUI:SetActive(self.view.TalkPanel,true)
    self.args=message
end
function this:LUA_EVENT_NPC_LEAVE_NEAR()
    GUI:SetActive(self.view.TalkPanel,false)
end


return this

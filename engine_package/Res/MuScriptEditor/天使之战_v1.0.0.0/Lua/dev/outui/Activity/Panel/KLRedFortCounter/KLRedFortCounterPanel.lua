---@class KLRedFortCounterPanel:UIKmlLuaPanelBase
---@field view KLRedFortCounterPanelView
---@field killCount number
---@field dieCount number
---@field hideTime number
local KLRedFortCounterPanel = class(UIKmlLuaPanelBase)
local this = KLRedFortCounterPanel
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLRedFortCounterPanelKml",true)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RED_FORTRESS_KILL_RELIVE, self.RES_RED_FORTRESS_KILL_RELIVE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE, self.RES_QUIT_DUPLICATE, self)
end

----{}
function this:RES_RED_FORTRESS_KILL_RELIVE(_, message)
    self.hideTime = 5
    local type = message["1"]
    local count = tostring(message["2"])
    if type == 1 then
        GUI:SetActive(self.view.dieCount, false)
        GUI:SetActive(self.view.killCount, true)
        GUI:Text_setString(self.view.textKillCount, count)
    elseif type == 2 then
        GUI:SetActive(self.view.dieCount, true)
        GUI:SetActive(self.view.killCount, false)
        GUI:Text_setString(self.view.textDieCount, count)
    end
    if not self.timer then
        self.timer = SL:StartLoopForever(1, self.RefreshText, self) ---Timer.StartLoopForever(1, self.RefreshText, self)
    end
    self:RefreshText()
end

function this:RefreshText()
    if self.hideTime <= 0 then
        GUI:SetActive(self.view.dieCount, false)
        GUI:SetActive(self.view.killCount, false)
        if self.timer then
            ---Timer.Stop(self.timer)
            SL:UnSchedule(self.timer)
            self.timer = nil
        end
        return
    end
    self.hideTime = self.hideTime - 1
end

function this:RES_QUIT_DUPLICATE()
    GUI:UI_Close("dev/outui/Activity/Panel/KLRedFortCounter/KLRedFortCounterPanel")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.killCount = 0
    self.dieCount = 0
    self.hideTime = 5
end

function this:Close()
    if self.timer then
        ---Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

return this

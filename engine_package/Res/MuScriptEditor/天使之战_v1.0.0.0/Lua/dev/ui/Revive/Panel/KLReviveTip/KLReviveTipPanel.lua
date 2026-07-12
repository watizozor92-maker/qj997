---@class KLReviveTipPanel:UIKmlLuaPanelBase
---@field view KLReviveTipPanelView
local KLReviveTipPanel = class(UIKmlLuaPanelBase)
local this = KLReviveTipPanel
---创建时调用一次
function this:Init()
    self.leftcfg = {}
    self.rightcfg = {}

end

---创建或者刷新界面数据时调用
function this:Refresh()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    if self.args then
        GUI:Text_setString(self.view.informationText, "您在<color=#3AB8F1>" .. self.args.place .. "</color>被" .. "<color=#FF0000>" .. self.args.killer .. "</color>" .. "击杀，请选择复活方式。")
        if SL:HasConfig("cfg_map_info", self.args.mapId) then

            ---@type cfg_map_info_column
            local mapcfg = SL:GetConfig("cfg_map_info", self.args.mapId)

            ---@type cfg_revive_column
            self.leftcfg = SL:GetConfig("cfg_revive", mapcfg.rebirthType[1])

            ---@type cfg_revive_column
            self.rightcfg = SL:GetConfig("cfg_revive", mapcfg.rebirthType[2])
            
            GUI:Button_setTitleText(self.view.RightBtn,self.rightcfg.name)
            self.countDownTimer = tonumber(SL:GetConfig("cfg_global", 116).value)

            if self.countDown then
                SL:UnSchedule(self.countDown)
                self.countDown = nil
            end
            self.countDown = SL:Schedule(self.countDown,0,1,self.countDownTimer + 1,function()
                self:CountDownText()
            end)
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.LeftBtn, self, self.OnClickLeftBtn)
    GUI:AddOnClickEvent(self.view.RightBtn, self, self.OnClickRightBtn)
    SL:RegisterLUAEvent(LUA_EVENT_ME_RELIVE, self.ResReliveMessage, self)
end

--[[--倒计时
this.countDownTimer = 60
function this.CountDownText()
    if this.countDownTimer <= 0 then return end
    this.countDownTimer = this.countDownTimer - 1
    this.obj_text_reviveCountDown:SetText(string.format("回到重生点(%02d)", this.countDownTimer))
    if this.countDownTimer <= 0 then
        --this:Revive(1)
        if this.countDown then
            this.registInBaseUI:Stop_Timer(this.countDown)
        end
        this:HideMe()
    end
end]]

--倒计时

function this:CountDownText()
    if self.countDownTimer <= 0 then
        return
    end
    self.countDownTimer = self.countDownTimer - 1
    GUI:Button_setTitleText(self.view.LeftBtn,string.format("免费复活(%02d)", self.countDownTimer))
    --GUI:Text_setString(self.view.LeftBtnText, string.format("免费复活(%02d)", self.countDownTimer))
    --self.obj_text_reviveCountDown:SetText(string.format("免费复活(%02d)", self.countDownTimer))
    --GUI:setSwallowTouches(self.view.LeftBtn,true)
    if self.countDownTimer <= 0 then
        --self:Revive(1)
        --GUI:setSwallowTouches(self.view.LeftBtn,false)0000
        GUI:Button_setTitleText(self.view.LeftBtn,"免费复活")
        self:ReviveType(self.leftcfg.id, self.leftcfg.type)
        self:OnCloseButton()
        if self.countDown then
            SL:UnSchedule(self.countDown)
            self.countDown = nil
        end
    end
end

---通知复活
---@param message MapProtos.ReliveRes
function this:ResReliveMessage(_, message)
    if message.id ~= SL:GetMetaValue(EMetaVarGetKey.UID) then
        return
    end
    SL.AudioMgr.ReviveGame()
    self:OnCloseButton()
end

function this:OnCloseButton()
    GUI:UIPanel_Close("dev/ui/Revive/Panel/KLReviveTip/KLReviveTipPanel")
end

function this:OnClickLeftBtn()
    if self.leftcfg then
        self:ReviveType(self.leftcfg.id, self.leftcfg.type)
        --self:OnCloseButton()
    end
end

function this:OnClickRightBtn()
    if self.rightcfg then
        self:ReviveType(self.rightcfg.id, self.rightcfg.type)
    end
end

function this:ReviveType(id, type)
    SL:ReqPlayerReliveMessage(id, type)
    --self:OnCloseButton()
end

function this:OnClose()
    if self.countDown then
        SL:UnSchedule(self.countDown)
        self.countDown = nil
    end
    SL.ShowMainPanel()
end

return this

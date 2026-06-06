---@class KLUIHurtExpPanel:UIKmlLuaPanelBase
---@field view KLUIHurtExpPanelView
local KLUIHurtExpPanel = class(UIKmlLuaPanelBase)
local this = KLUIHurtExpPanel
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLUIHurtExpPanel", true)
    self.end_time = SL:GetConfig("cfg_global",24001).value
    self.end_time = tonumber(self.end_time)
    self.last_time = Time.GetServerTime()
    self.timeIndex = 0
--[[   self.updateID = SL:Schedule(self.updateID,0,5,-1,function()
        self:RefreshUI()
    end)]]
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local updateNow = self.args and self.args.updateNow or false
    self:ResetText()
    self:SetIsShow(true, updateNow)
end

function this:ResetText()
    GUI:Text_setString(self.view.hurt,"<color=#00ff00>0</color>")
    GUI:Text_setString(self.view.time, "<color=#00ff00>00:00:00</color>")
    GUI:Text_setString(self.view.perKill, "<color=#00ff00>0</color>")
    GUI:Text_setString(self.view.totalKill, "<color=#00ff00>0</color>")
    GUI:Text_setString(self.view.exp, "<color=#00ff00>0</color>")
end

function this:SetIsShow(show, updateNow)
    self.isShow = show
    GUI:setVisible(self.view.infos, show)
    GUI:setRotation(self.view.img_arrow, show and -90 or 90)
    if show then
        self.timeIndex = 0
        if updateNow then
            self:RefreshUI()
            self:CheckSafe()
        end
        self.update2ID = SL:Schedule(self.update2ID,1,1,-1,function()
            self:CheckSafe()
        end)
    end
end

function this:CheckSafe()
    self.timeIndex = self.timeIndex + 1
    if self.timeIndex >= 1 then
        self:RefreshUI()
        self.timeIndex = 0
    end
    local time = SL:GetMetaValue("SERVER_TIME")
    local deltaTime = time - InfoManager.mainUIInfo.autoFightTime
    local seconds = deltaTime // 1000
    local text = Time.FormatTimeDHMSFormColon(seconds)
    GUI:Text_setString(self.view.time, text)
    local perKill = 0
    local zero = 0
    if seconds > 0 then
        perKill = math.floor(InfoManager.mainUIInfo.killMonster / seconds * 100 ) / 100
        zero = math.floor(InfoManager.mainUIInfo.killMonster / seconds * 100 ) % 100
    end
    GUI:Text_setString(self.view.totalKill, tostring(InfoManager.mainUIInfo.killMonster))
    if zero == 0 then
        GUI:Text_setString(self.view.perKill, tostring(math.floor(perKill)))
    else
        GUI:Text_setString(self.view.perKill, tostring(perKill))
    end
    local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
    if isSafe then
        GUI:UIPanel_Close(self.filePath)
    end
end


---注册UI事件和服务器消息
function this:RegistEvents()
    --SL:RegisterLUAEvent(LUA_EVENT_NET_PLAYER_DIE, self.PlayerDie, self)  --玩家死亡
    GUI:AddOnClickEvent(self.view.button, self, self.ShowOrHideInfos)
end

function this:ShowOrHideInfos()
    if not self.isShow then
        local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
        if isSafe then
            local tbl = SL:GetConfig("cfg_string", 41001)
            SL:TipMessage(tbl.text, 1, NoticeType.NoticeMid)
            return
        end
        self.fromAuto = false
    end
    self:SetIsShow(not self.isShow)    
end

function this:RefreshTime()
    self.last_time = Time.GetServerTime()
end

function this:RefreshUI()
    local current_time = Time.GetServerTime()
    if self.last_time < current_time - 1000 * self.end_time -100 or not self.isShow then
        return
    end
    self:ShowHurt()
    self:ShowExp()
end

function this:ShowHurt()
    local hurt_num = InfoManager.mainUIInfo:GetHurtNum()
    local str = string.format("<color=#00ff00>%s</color>",hurt_num)
    GUI:Text_setString(self.view.hurt,str)
end

function this:ShowExp()
    local exp_num = InfoManager.mainUIInfo:GetExpNum()
    if InfoManager.mainUIInfo:CheckIsStartMinute() then 
        -- 获取当前服务器时间
        local nowTime = SL:GetMetaValue("SERVER_TIME")
        --local all = exp_num
        -- 计算战斗持续时间（毫秒）
        local fightDuration = (nowTime - InfoManager.mainUIInfo.autoFightTime) // 1000
        exp_num = math.floor(exp_num/fightDuration)
        exp_num = SL:GetSimpleNumber(exp_num,0)
        --SL:LogWarning(string.format("总经验:%d,持续时间:%d秒,每秒:%s",all or 0,fightDuration or 0,exp_num))
    else
        exp_num = math.floor(exp_num/60)
        exp_num = SL:GetSimpleNumber(exp_num,0)
    end
    
    local str = string.format("<color=#00ff00>%s</color>",exp_num)
    GUI:Text_setString(self.view.exp,str)
end


function this:Close()
    if self.updateID then
        SL:UnSchedule(self.updateID)
        self.updateID = nil
    end
    if self.update2ID then
        SL:UnSchedule(self.update2ID)
        self.update2ID = nil
    end
end



return this

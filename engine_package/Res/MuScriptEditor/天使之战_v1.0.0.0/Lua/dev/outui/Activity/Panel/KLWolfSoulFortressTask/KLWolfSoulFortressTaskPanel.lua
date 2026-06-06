---@class KLWolfSoulFortressTaskPanel:UIKmlLuaPanelBase
---@field view KLWolfSoulFortressTaskPanelView
---@field nextStateTime number @阶段时间
---@field nextStateTime_2 number @战斗阶段要变成退出按钮上的时间
---@field summonCount number @召唤了几个守护
---@field state number @哪个阶段
---@field lastHp number @上一次的血量
local KLWolfSoulFortressTaskPanel = class(UIKmlLuaPanelBase)
local this = KLWolfSoulFortressTaskPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.position = 0
    --3秒延迟发消息
    self.nextPopTextTime = 0
    SL:KeepOpenPanel("KLWolfSoulFortressTaskPanelKml",true)
end

function this:InitData(message)
    self.nextStateTime = 0
    self.nextStateTime_2 = 0
    --self.summonCount = message["1"]  
    self:RES_WOLF_SOUL_STATE(_, message)
    guardians = InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.guardians
    GUI:Text_setString(self.view.textSummonCount, string.format("%s/%s", InfoManager.wolfSoulFortressInfo.summonCount, guardians))
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, EPKMode.Union)
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,true)
    SL:onLUAEvent(LUA_EVENT_CROSS_SERVER_PK_MODE,EPKMode.Union)
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnExit, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.btnSummon, self, self.BtnSummonOnClick)
    GUI:AddOnClickEvent(self.view.btnHelp, self, self.BtnHelpOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WOLF_SOUL_STATE, self.RES_WOLF_SOUL_STATE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WOLF_SOUL_FIGHT_PANEL, self.RES_WOLF_SOUL_FIGHT_PANEL, self)

    SL:RegisterLuaNetMsg(MessageDef.ResViewUnionMessage, this.ResViewUnionMessage, self)

    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE, self.LUA_EVENT_PLAYER_MAPPOS_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_WOLFSOULFORTRESS_UPDATE_SUMMON_INFO, self.LUA_EVENT_WOLFSOULFORTRESS_UPDATE_SUMMON_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
end
function this:LUA_EVENT_CHANGESCENE()
    if not SL:Out_IsInCopy() then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLWolfSoulFortressTask/KLWolfSoulFortressTaskPanel")
    end
end

---离雕像距离小于等于2格时打开召唤
function this:LUA_EVENT_PLAYER_MAPPOS_CHANGE()
    if self.state == 1 and InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg and (self.position == 1 or self.position == 2) then
        local platformPosition = SL:GetNewDot(InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[1], InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[2]) 
        --Dot2(InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[1], InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[2])
        local mePos = SL:GetNewDot(SL:MeData_GetCoord().x, SL:MeData_GetCoord().z)--Dot2(SL:MeData_GetCoord().x, SL:MeData_GetCoord().z)
        if --[[Dot2.Distance(platformPosition, mePos)--]]  SL:GetPointDistance(platformPosition, mePos) <= 2 then
            if not GUI:GetUI("dev/outui/Activity/Panel/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonPanel") then
                GUI:UIPanel_Open("dev/outui/Activity/Panel/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonPanel")
            end
        end
    end
end

---@param message UnionProto.ViewUnionRes
function this:ResViewUnionMessage(_, message)
    self.position = 0
    for k, v in pairs(message.unionInfo.unionMemberInfo) do
        if v.memberId == SL:GetMetaValue(EMetaVarGetKey.UID) then
            self.position = v.position
            break
        end
    end
    if self.position > 0 then
        if self.position <= 2 then
            GUI:SetActive(self.view.btnSummon, true)
        else
            GUI:SetActive(self.view.btnSummon, false)
        end
    end
end

-- 更新召唤次数信息
function this:LUA_EVENT_WOLFSOULFORTRESS_UPDATE_SUMMON_INFO(_, message)
    guardians = InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.guardians
    GUI:Text_setString(self.view.textSummonCount, string.format("%s/%s", InfoManager.wolfSoulFortressInfo.summonCount, guardians))
end

-- 狼魂要塞战斗阶段面板信息
---@param message {hp:number, score:number,rank:number,left:number,nextGenTime:string,killCount:number,repMonsterId:number}
function this:RES_WOLF_SOUL_FIGHT_PANEL(_, message)
    ---雕像血量
    local wolfHp = message.hp
    if self.lastHp > wolfHp and self.nextPopTextTime < Time.GetServerTime()  then
        local str = SL:GetConfig('cfg_string', 432).text
        SL:onLUAEvent(LUA_EVENT_CHAT_RECEIVE_NOTICE, {
            message = str,
            channel = EChatChannelType.SYSTEM,
        })
        SL:TipMessage( str, 1, NoticeType.NoticeMid )
        self.nextPopTextTime = Time.GetServerTime() + 3000
    end
    ---@type cfg_repMonster_column
    self.repMonsterCfg = SL:GetConfig("cfg_repMonster",tonumber(message.repMonsterId))
    self.lastHp = message.hp
    wolfHp = wolfHp / 10000 * 100 ---万分比
    GUI:Text_setString(self.view.textWolfHp, wolfHp .. "%")
    local score = message.score
    GUI:Text_setString(self.view.textScore, tostring(score))
    local rank = message.rank
    GUI:Text_setString(self.view.textRank, tostring(rank))
    local fightCount = message.left
    GUI:Text_setString(self.view.textFightCount, tostring(fightCount))
    self.nextStateTime = message.nextGenTime
    if self.repMonsterCfg.kill > 0 then
        self.nextStateTime = 0
        if not message.killCount then
            GUI:Text_setString(self.view.timeText, tostring(self.repMonsterCfg.kill))
        else
            GUI:Text_setString(self.view.timeText, tostring(self.repMonsterCfg.kill - tonumber(message.killCount)))
        end
        GUI:Text_setString(self.view.timerTitle, "下一波需击杀")
    else
        local nextTime = self.nextStateTime - Time.GetServerTime()
        GUI:Text_setString(self.view.timeText, Time.FormatTimeHMS(math.floor(nextTime)))
        GUI:Text_setString(self.view.timerTitle, "下一波倒计时")
    end
    if fightCount == 0 then
        GUI:Text_setString(self.view.timerTitle, "副本结束倒计时")
    end

    if not self.timer_2 then
        ---self.timer_2 = Timer.StartLoopForever(1, self.RefreshTimeText_2, self)
        self.timer_2 = SL:StartLoopForever(1, self.RefreshTimeText_2, self)
    end
end

-- 狼魂要塞阶段信息
---@param message {"1":副本id, "2":哪个阶段,"3":下个阶段的时间}
function this:RES_WOLF_SOUL_STATE(_, message)
    self.state = tonumber(message["2"])
    if self.state == 1 then
        SL:TipMessage( SL:GetConfig('cfg_string', 434).text, 1, NoticeType.NoticeMid )
        self.nextStateTime = tonumber(message["3"])
    elseif self.state == 2 then
        self.nextStateTime_2 = tonumber(message["3"])
    else
        GUI:UIPanel_Open("dev/outui/Activity/Panel/KLWolfSoulFortress/KLWolfSoulFortressPanel", nil, nil, tonumber(message["3"]))
    end
    self:RefreshTimeUI()
end

function this:RefreshTimeUI()
    if not self.timer then
        ---self.timer = Timer.StartLoopForever(1, self.RefreshTimeText, self)
        self.timer = SL:StartLoopForever(1, self.RefreshTimeText, self)
    end
    if not self.timer_2 then
        ---self.timer_2 = Timer.StartLoopForever(1, self.RefreshTimeText_2, self)
        self.timer_2 = SL:StartLoopForever(1, self.RefreshTimeText_2, self)
    end
    self:RefreshTimeText()
    self:RefreshTimeText_2()
    if self.state == 1 then
        GUI:Text_setString(self.view.timerTitle, "准备倒计时")
        GUI:SetActive(self.view.textRoot, true)
        GUI:SetActive(self.view.textRoot_2, false)
        GUI:SetActive(self.view.timeText_2, false)
    else
        GUI:SetActive(self.view.textRoot, false)
        GUI:SetActive(self.view.textRoot_2, true)
        GUI:SetActive(self.view.timeText_2, true)
    end
end

---界面显示时调用一次
function this:Show()

end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.lastHp = 0
    SL:ReqViewUnionMessage()
    GUI:SetActive(self.view.textRoot, true)
    GUI:SetActive(self.view.textRoot_2, false)
    if InfoManager.wolfSoulFortressInfo.summonCount then

    end
    self.nextStateTime = 0
    self.nextStateTime_2 = 0
    if InfoManager.wolfSoulFortressInfo.state then
        self.nextStateTime = InfoManager.wolfSoulFortressInfo.nextStateTime
        self.nextStateTime_2 = InfoManager.wolfSoulFortressInfo.nextStateTime_2
        self.state = InfoManager.wolfSoulFortressInfo.state
        self:RefreshTimeUI()
    end

end

function this:RefreshTimeText()
    local nextTime = self.nextStateTime - Time.GetServerTime()
    if nextTime > 0 then
        GUI:Text_setString(self.view.timeText, Time.FormatTimeHMS(math.floor(nextTime)))
    end
end

--退出按钮上的时间
function this:RefreshTimeText_2()
    local nextTime = self.nextStateTime_2 - Time.GetServerTime()
    if nextTime > 0 then
        GUI:Text_setString(self.view.timeText_2, Time.FormatTimeHMS(math.floor(nextTime)))
    end
end

function this:BtnHelpOnClick()
    local helpCfg = SL:GetConfig("cfg_rule_text", 15001)
    if helpCfg then
        SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
    end
end

---寻路到雕像
function this:BtnSummonOnClick()
    ---召唤次数有限制
    if InfoManager.wolfSoulFortressInfo.summonCount == InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.guardians then
        SL:TipMessage( SL:GetConfig('cfg_string', 332).text, 1, NoticeType.NoticeMid )--"召唤次数已满！",
        return
    end
    if not InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg then
        return
    end
    local platformPosition =SL:GetNewDot(InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[1], InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[2])
    --Dot2(InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[1], InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[2])
    local mePos = SL:GetNewDot(SL:MeData_GetCoord().x, SL:MeData_GetCoord().z)--Dot2(SL:MeData_GetCoord().x, SL:MeData_GetCoord().z)
    if --[[Dot2.Distance(platformPosition, mePos)--]] SL:GetPointDistance(platformPosition, mePos) <= 2 then
        GUI:UIPanel_Open("dev/outui/Activity/Panel/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonPanel")
    end

    local x = InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[1]
    local y = InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.platformPosition[2]
    --RoleManager.me:PathMoveTo(Dot2.New(x, y), nil, 2, arriveFunc, true, nil, nil, 1)
    SL:PathMoveTo( --[[Dot2.New(x, y)--]] SL:GetNewDot(x,y), nil, 2, nil, true, nil, nil, 1)
end

function this:BtnCloseOnClick()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
end

function this:Close()
    if self.timer then
        ---Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    if self.timer_2 then
        ---Timer.Stop(self.timer_2)
        SL:UnSchedule(self.timer_2)
        self.timer_2 = nil
    end
    InfoManager.copActivityInfo.hideTask = false
    ---@type KLUILeftUpPanel
    local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
    if panel then
        panel:OnClickTaskToggle(nil, nil, { true })
        panel:SetTeamToogleEnabled(true)
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE, false)
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLWolfSoulFortress/KLWolfSoulFortressPanel")
    
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, EPKMode.Peace)
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,false)
    SL:onLUAEvent(LUA_EVENT_CROSS_SERVER_PK_MODE,EPKMode.Peace)
end

return this

---@class KLDevilCopyTaskProgressPanel:UIKmlLuaPanelBase
---@field view KLDevilCopyTaskProgressPanelView
---@field expItem KLItemItem
local KLDevilCopyTaskProgressPanel = class(UIKmlLuaPanelBase)
local this =KLDevilCopyTaskProgressPanel
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLDevilCopyTaskProgressPanel",true)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:onLUAEvent(LUA_EVENT_SWITCH_PKMODE,1)
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel")
    self:RefreshPrepareStage(nil,self.args)
    if InfoManager.copActivityInfo:GetDevilWaveMessage() then
        local data = InfoManager.copActivityInfo:GetDevilWaveMessage()
        self:RefreshFightStage(_, data)
        InfoManager.copActivityInfo:ClearDevilWaveMessage()
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,true)
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE,EPKMode.Peace)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.DEVIL_SQUARE_STATE,self.RefreshPrepareStage,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DEVIL_SQUARE_TASK,self.RefreshFightStage,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE,self.RES_QUIT_SUCCESS,self)
    --SL:RegisterLUAEvent(LUA_EVENT_MAIN_UI_VISIBLE, self.UpdateUseTipPanel, self)
    
    GUI:AddOnClickEvent(self.view.openActivityBtn,self,self.OnCliCkOpenActivityBtn)
    GUI:AddOnClickEvent(self.view.desBtn,self,self.OnCliCkDesBtn)
    GUI:AddOnClickEvent(self.view.exitBtn,self,self.OnCliCkExitBtn)


    SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE, self.LUA_EVENT_CHANGESCENE, self)
end
function this:LUA_EVENT_CHANGESCENE()
    if not SL:Out_IsInCopy() then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLDevilCopyTaskProgress/KLDevilCopyTaskProgressPanel")
        InfoManager.copActivityInfo:ClearCopyData()
    end
end
function this:RefreshPrepareStage(id,message)
    self.stage = message["1"]
    local countdown = tonumber(message["2"])
    local cfgId = tonumber(message["3"])
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep",cfgId,"id")
    GUI:Text_setString(self.view.title,"恶魔广场第".. tbl.repLevel .."层")
    countdown = countdown-SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    self.countdown = math.floor(countdown/1000)
    self.countdown = self.countdown + 1
    GUI:setVisible(self.view.prepareRoot,self.stage == 1)
    GUI:setVisible(self.view.endTime,self.stage == 2)
    if self.stage == 1 then
        ---@type cfg_repGlobal_column
        local tbl = SL:GetConfig("cfg_repGlobal",10001002,"id")
        local waitTime = tonumber(tbl.value)
        local isChange = false

        if waitTime < self.countdown then
            GUI:Text_setString(self.view.openDes,"当前处于准备阶段")
            GUI:setVisible(self.view.openActivityBtn,false)
        else
            GUI:Text_setString(self.view.openDes,"战斗即将开始做好准备")
            GUI:setVisible(self.view.openActivityBtn,false)
        end
        local str = ""
        self.timer = SL:Schedule(self.timer,0,1,self.countdown,function()
            self.countdown = self.countdown - 1
            if waitTime < self.countdown then
                if not isChange then
                    str = "后开启"
                    GUI:Text_setString(self.view.openDes,"当前处于准备阶段")
                    GUI:setVisible(self.view.openActivityBtn,false)
                    isChange = true
                end
            elseif waitTime == self.countdown then
                str = "秒后开启副本"
                GUI:Text_setString(self.view.openDes,"战斗即将开始做好准备")
                GUI:setVisible(self.view.openActivityBtn,false)
            end
            GUI:Text_setString(self.view.openTime,GUIUtil.FormatTimeMS(self.countdown)..GUIUtil.GetColorText(str,"#00ff00"))
            if self.countdown <=0 then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_STATE,EDuplicateType.StartCopy)
            end
        end)
    elseif self.stage == 2 then
        self.countdown = self.countdown + 1
        self.timer = SL:Schedule(self.timer,0,1,self.countdown,function()
            self.countdown = self.countdown - 1
            local endText = GUIUtil.FormatTimeMS(self.countdown)
            GUI:Text_setString(self.view.endTime, endText)
            if self.countdown <= 0 and self.timer then
                SL:UnSchedule(self.timer)
            end
            if self.countdown <=0 then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
            end
        end)
    end
end

function this:FormatTimeMS(time)
    time = math.modf(time)
    local minute = math.modf(time / 60)
    local second = time % 60

    local function padZero(num)
        if num < 10 then
            return "0" .. tostring(num)
        else
            return tostring(num)
        end
    end

    local fmtTime = padZero(minute) .. ":" .. padZero(second)
    return fmtTime
end

function this:RefreshFightStage(id,message)
    GUI:setVisible(self.view.fightRoot,self.stage == 2)
    if self.stage == 2 then
        self:RefreshReward(message.rewardCount)
        GUI:Text_setString(self.view.waveNumber,"第"..message.wave.."波")
        -- GUI:Text_setString(self.view.taskCount,"<color=#ff2323>"..message.nowCount .. "</color>/"..message.totalCount)
        local last_time = 0
        local nextWaveTime = message.nextWaveTime
        local server_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local s_time = math.floor(server_time/1000)
        if s_time < nextWaveTime then
            last_time = nextWaveTime - s_time
        end
        GUI:SetControl_time(self.view.countdown_copy, last_time)
        GUI:Text_setString(self.view.score,tostring(GUIUtil.FormatNumber(message.score,true)))
    end
end

function this:RES_QUIT_SUCCESS(id,message)
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep",message,"id")
    if tbl.type == EActivityType.DevilSquare then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLDevilCopyTaskProgress/KLDevilCopyTaskProgressPanel")
        InfoManager.copActivityInfo:ClearCopyData()
    end
end

function this:RefreshReward(count)
    if count < 10000 then
        count = math.floor(count)
    end
    if self.expItem then
        --self.expItem:RefreshItem(10080001,count)
    else
        --self.expItem = GUI:UIPanel_Open("dev/outui/Activity/Item/KLItem/KLItemItem",self.view.rewardModel,self,{cfgId = 10080001,count = count,width = 50,height=50},true)
    end
end

function this:OnCliCkOpenActivityBtn()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_STATE,EDuplicateType.StartCopy)
end

function this:OnCliCkDesBtn()
    local ruleCfg = SL:GetConfig("cfg_rule_text", 32001)
    if ruleCfg then
        SL:CommonStrTipsMessage({title =ruleCfg.menutxt,str=ruleCfg.location})
    end
end

function this:OnCliCkExitBtn()
    local data = {content="离开副本将丢失进度，是否退出",okFunc=function()
        --请求退出副本
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
    end}
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLSure/KLSurePanel",nil,nil,data)
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    InfoManager.copActivityInfo.hideTask = false
    ---@type KLUILeftUpPanel
    local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
    if panel then
        panel:OnClickTaskToggle(nil,nil,{true})
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,false)
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE,EPKMode.Peace)
end

return this

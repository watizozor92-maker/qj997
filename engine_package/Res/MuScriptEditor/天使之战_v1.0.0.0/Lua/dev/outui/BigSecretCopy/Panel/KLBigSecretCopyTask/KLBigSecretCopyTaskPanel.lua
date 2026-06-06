---@class KLBigSecretCopyTaskPanel:UIKmlLuaPanelBase
---@field view KLBigSecretCopyTaskPanelView
local KLBigSecretCopyTaskPanel = class(UIKmlLuaPanelBase)
local this = KLBigSecretCopyTaskPanel
---创建时调用一次
function this:Init()
    self.is_open = false
--GUI:UIPanel_Open("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel")
    self.updateID = SL:Schedule(self.updateID,1,1,-1,function()
        self:Update()
    end)
end

function this:InitBegin(data)
    --SL:LogTable(data,true)
    GUI:setVisible(self.view.task_root,false)
    GUI:setVisible(self.view.begin_root,true)
    this.configId = tonumber(data)
    local name_str = SL:GetConfig("cfg_rep",this.configId).name[1]
    GUI:Text_setString(self.view.ActivityName,name_str)
    self.prepareTime = SL:GetConfig("cfg_rep",this.configId).prepareTime
    local str = self.prepareTime .. "秒后开启副本"
    GUI:Text_setString(self.view.openDesTxt,str)
    self.is_begin_time = true
end

function this:InitData(data)
    GUI:setVisible(self.view.task_root,true)
    GUI:setVisible(self.view.begin_root,false)
    --SL:LogTable(data,true)
    this.configId = data.configId
    local monster = SL:GetConfig("cfg_repMonster",tonumber(data.taskId)).monster[1]
    self.monster_data = monster
    local monster_cfgId = monster[1]
    local monster_name = SL:GetConfig('cfg_monster', monster_cfgId).name
    GUI:Text_setString(self.view.name,"击杀" .. monster_name)
    local num_sre = data.nowCount .. "/" .. data.totalCount
    GUI:Text_setString(self.view.num,num_sre)
    local nextStateStartTime = tonumber(data.nextStateStartTime)
    local server_time =  SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    local e_time = nextStateStartTime - server_time
    if e_time  < 0 then
        e_time = 0
    end
    self.endTime = math.floor(e_time/1000)
    --GUI:SetControl_time(self.view.end_time,e_time)
    GUI:setVisible(self.view.end_time,true)
    local continuous = SL:GetConfig("cfg_rep",this.configId).continuous
    local st_time = continuous *1000 - e_time
    if st_time  < 0 then
        st_time = 0
    end
    self.startTime = math.floor(st_time/1000)
    --GUI:SetControl_time(self.view.start_time,st_time)
    GUI:setVisible(self.view.start_time,true)

    local name_str = SL:GetConfig("cfg_rep",this.configId).name[1]
    GUI:Text_setString(self.view.ActivityName,name_str)
    local taskId = tonumber(data.taskId)
    local task_name_str = SL:GetConfig("cfg_repTask",taskId).name
    GUI:Text_setString(self.view.info,task_name_str)
    -- SL:LogError("startTime---")
    -- SL:LogError(self.startTime)
    -- SL:LogError("endTime---")
    -- SL:LogError(self.endTime)
    self.score_data = SL:GetConfig("cfg_bigUncharted",this.configId)
    self.is_open = true
end

function this:Update()
    if self.is_open then
        local start_str = self:GetTime(self.startTime)
        GUI:Text_setString(self.view.start_time, start_str)
        local end_str = self:GetTime(self.endTime)
        GUI:Text_setString(self.view.end_time, end_str)
        self.startTime = self.startTime + 1
        self.endTime = self.endTime - 1
        if self.endTime < 0 then
            self.endTime = 0
        end
        -- SL:LogError(start_str)
        -- SL:LogError(end_str)
        local cur_score = ""
        if self.score_data and self.score_data.time then
            for i, minute in ipairs(self.score_data.time) do
                if self.startTime <= minute *60 then
                    cur_score = self.score_data.score[i]
                    break
                end
            end
        end
        GUI:Text_setString(self.view.pingfen, cur_score)
    end
    if self.is_begin_time then
        if self.prepareTime < 0 then
            self.prepareTime = 0
        end
        local str = self.prepareTime .. "秒后开启副本"
        GUI:Text_setString(self.view.openDesTxt,str)
        self.prepareTime = self.prepareTime - 1
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    -- GUI:SetToggleOnValueChange(self.view.boss_1_toggle, self, self.Boss1Click)
    -- GUI:SetToggleOnValueChange(self.view.boss_2_toggle, self, self.Boss2Click)
    -- GUI:SetToggleOnValueChange(self.view.boss_3_toggle, self, self.Boss3Click)
    GUI:AddOnClickEvent(self.view.exitBtn,self,self.Exit)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE, self.MonsterDie, self)   --怪物死亡
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE,self.RES_QUIT_SUCCESS,self)
    GUI:AddOnClickEvent(self.view.walkBtn,self,self.walkOnClick)
    GUI:AddOnClickEvent(self.view.HelpButton, self, self.OnClickHelpButton)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO,self.RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO,self)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_MAP, self.LUA_EVENT_LOGIN_MAP, self)  --登录进入地图
end

function this:UnRegistEvents()
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO,self.RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO,self)
    SL:UnRegisterLUAEvent(LUA_EVENT_LOGIN_MAP, self.LUA_EVENT_LOGIN_MAP, self)  
end

function this:Exit()
    SL:CommonTipsMessage({ stringTblID=211, ui = self, sureBtnText = "确定", cancelBtnText = "取消",
    callback = self.ExitSure})
end

function this:ExitSure()
    InfoManager.copActivityInfo.hideTask = false
    SL:onLUAEvent(LUA_EVENT_SHOW_TASK)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE,this.configId)
    GUI:UIPanel_Close("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel")
end

function this:DelayExitSure()
    self.timer = SL:ScheduleOnce(3, function()
        self:ExitSure()
    end)
end

function this:StopTime1()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel")
    SL.ShowMainPanel()
end


function this:MonsterDie(_id,message)

end

function this:DieEnd(isDie,time)
    
end



function this:Close()
    self:StopTime1()
    self:UnRegistEvents()
    self.is_close = true
    if self.updateID then
        SL:UnSchedule(self.updateID)
        self.updateID = nil
    end
    self.is_open = false
end

function this:RES_QUIT_SUCCESS(id,message)
     ---@type cfg_rep_column
     local tbl = SL:GetConfig("cfg_rep",message,"id")
     if tbl.type == EActivityType.PrivilegeBoss then
        self.is_close = true
        InfoManager.copActivityInfo.hideTask = false
        self:CloseOnclick()
     end
end

function this:walkOnClick()
    if not self.monster_data then
        return
    end
    this.pos_monster_id = self.monster_data[1]
    local x = self.monster_data[3]
    local y = self.monster_data[4]
    this.map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    this.map_line = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    SL:Pathfinding(this.map_id,  this.map_line, x, y,this.MonserPosEnd,this.pos_monster_id)
end

function this:MonserPosEnd(pos)
    --SL:StartOnHook(true,true)
    if pos and pos.x and pos.z then
        this.scheduleId = SL:ScheduleOnce(0.1, function()
            SL:Pathfinding( this.map_id,  this.map_line, pos.x, pos.z,this.BossPointOnHook)
        end)
    else
        SL:StartOnHook(true,true,this.pos_monster_id)
    end
end


function this:BossPointOnHook()
    SL:StartOnHook(true,true,this.pos_monster_id)
end

function this:RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO(_id,message)
    --SL:LogTable(message,true)
    GUI:UIPanel_Open("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyReward/KLBigSecretCopyRewardPanel",nil,nil,message)
end

function this:GetTime(tims_n)
    local time_tab = SL:SecondToHMS(tims_n)
    local time_str = ""
    if time_tab.d and time_tab.d >0 then
        time_str = time_str ..time_tab.d .. "天 "
    end
    if time_tab.h and time_tab.h >0 then
        local hour = ""
        if time_tab.h < 10 then
            hour = "0"..time_tab.h
        else
            hour = tostring(time_tab.h)
        end
        time_str = time_str ..hour .. ":"
    end
    if time_tab.m and time_tab.m >0 then
        local hour = ""
        if time_tab.m < 10 then
            hour = "0"..time_tab.m
        else
            hour = tostring(time_tab.m)
        end
        time_str = time_str..hour .. ":"
    else
        time_str = time_str.."00:"
    end
    local s = ""
    if time_tab.s <10 then
        s= "0" .. time_tab.s
    else
        s= tostring(time_tab.s)
    end
    time_str = time_str ..s
    return time_str
end

--帮助页面
function this:OnClickHelpButton()
    local helpCfg=SL:GetConfig("cfg_rule_text",19002)
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
end


function this:LUA_EVENT_LOGIN_MAP()
    local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local is_has = SL:HasConfigTwoKeys("cfg_rep",19001,map_id,"type","mapId")
    if not is_has then
        self:ExitSure()
    end
end

return this

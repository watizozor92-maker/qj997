---@class KLLoranSiegeCopyTaskPanel:UIKmlLuaPanelBase
---@field view KLLoranSiegeCopyTaskPanelView
local KLLoranSiegeCopyTaskPanel = class(UIKmlLuaPanelBase)
local this =KLLoranSiegeCopyTaskPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    InfoManager.loranSiegeInfo.isInCopy = true
    SL:KeepOpenPanel("KLLoranSiegeCopyTaskPanel",true)
    self.nowCount = nil
    self.loadingCount = nil
    self.nowUnion = nil
end

function this:UnScheduleTimer()
    if self.countDown then
        SL:UnSchedule(self.countDown)
    end
    self.countDown = nil
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.exitBtn,self,self.Exit)
    GUI:AddOnClickEvent(self.view.TaskButton,self,self.TaskButtonOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE,self.RES_QUIT_SUCCESS,self)
    GUI:AddOnClickEvent(self.view.HelpButton, self, self.OnClickHelpButton)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_MAP, self.LUA_EVENT_LOGIN_MAP, self)  --登录进入地图
    SL:RegisterLUAEvent(LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE, self.LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE , self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLAND_SIEGE_TASK_INFO_CHANGE, self.LUA_EVENT_ROLAND_SIEGE_TASK_INFO_CHANGE , self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLAND_SIEGE_ROLAND_PROGRESS_INFO_CHANGE, self.LUA_EVENT_ROLAND_SIEGE_ROLAND_PROGRESS_INFO_CHANGE , self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLAND_SIEGE_ROLAND_MONSTER_LIST_CHANGE, self.LUA_EVENT_ROLAND_SIEGE_ROLAND_MONSTER_LIST_CHANGE , self)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
end
function this:LUA_EVENT_CHANGESCENE()
    if not InfoManager.loranSiegeInfo:IsMap() then
        InfoManager.copActivityInfo.hideTask = false
        SL:onLUAEvent(LUA_EVENT_SHOW_TASK)
        GUI:UIPanel_Close("dev/outui/LoranSiege/Panel/KLLoranSiegeCopyTask/KLLoranSiegeCopyTaskPanel")
    end
end

---任务按钮点击寻路
function this:TaskButtonOnClick()
    if self.repTaskConfig then
        this.pos_monster_id = self.repTaskConfig.param[1]
        local x = self.repTaskConfig.moveTo[1]
        local y = self.repTaskConfig.moveTo[2]
        this.map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
        this.map_line = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
        SL:Pathfinding(this.map_id,  this.map_line, x, y,this.MonserPosEnd,this.pos_monster_id)
    end
end

function this:MonserPosEnd(pos)
    if pos and pos.x and pos.z then
        this.scheduleId = SL:ScheduleOnce(0.1, function()
            SL:Pathfinding(this.map_id,  this.map_line, pos.x, pos.z,this.BossPointOnHook)
        end)
    else
        SL:StartOnHook(true,true,this.pos_monster_id)
    end
end

function this:BossPointOnHook()
    SL:StartOnHook(true,true,this.pos_monster_id)
end

function this:Exit()
    SL:CommonTipsMessage({ stringTblID=211, ui = self, sureBtnText = "确定", cancelBtnText = "取消",
                           callback = self.ExitSure})
end

function this:ExitSure()
    InfoManager.copActivityInfo.hideTask = false
    SL:onLUAEvent(LUA_EVENT_SHOW_TASK)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE,self.configId)
    GUI:UIPanel_Close("dev/outui/LoranSiege/Panel/KLLoranSiegeCopyTask/KLLoranSiegeCopyTaskPanel")
end

function this:RES_QUIT_SUCCESS(id,message)
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep",message,"id")
    if tbl.type == self.configId then
        InfoManager.copActivityInfo.hideTask = false
        GUI:UIPanel_Close("dev/outui/LoranSiege/Panel/KLLoranSiegeCopyTask/KLLoranSiegeCopyTaskPanel")
        SL.ShowMainPanel()
    end
end

--帮助页面
function this:OnClickHelpButton()
    local helpCfg=SL:GetConfig("cfg_rule_text",16005)
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
end

function this:LUA_EVENT_LOGIN_MAP()
    local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local is_has = SL:HasConfigTwoKeys("cfg_rep",map_id,"type","mapId")
    if not is_has then
        self:ExitSure()
    end
end

---罗兰攻城战副本状态改变
function this:LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE()
    local stateInfo = InfoManager.loranSiegeInfo.siegeStateInfo
    if not stateInfo then
       return 
    end
    local state = stateInfo["2"]
    ---是否是准备阶段
    local ifPrepare = state == EDuplicateState.PREPARE
    if ifPrepare then
        GUI:Text_setString(self.view.openDesTxt,"")
    else
        GUI:Text_setString(self.view.end_time,"")
    end
    GUI:setVisible(self.view.task_root,not ifPrepare)
    GUI:setVisible(self.view.begin_root,ifPrepare)
    GUI:setVisible(self.view.text_countdown_tips, state == EDuplicateState.FINISH)

    self.configId = tonumber(stateInfo["1"])
    local name_str = SL:GetConfig("cfg_rep",self.configId).name[1]
    GUI:Text_setString(self.view.ActivityName,name_str)
    self:UnScheduleTimer()
    if state ~= EDuplicateState.CLOSED then
        local time = tonumber(stateInfo["3"])
        local count = (time - tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))) * 0.001 + 1
        local func = function()
            local now = tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))
            local deltaTime = time - now
            if state == EDuplicateState.PREPARE then
                GUI:Text_setString(self.view.openDesTxt,Time.ShowFormatTimeMS(deltaTime).."后开启副本")
            elseif state == EDuplicateState.FINISH then
                GUI:Text_setString(self.view.text_countdown_tips_text,Time.ShowFormatTimeMS(deltaTime).."秒")
            else
                GUI:Text_setString(self.view.end_time,Time.ShowFormatTimeMS(deltaTime))
            end
            if deltaTime <= 0 then
                if state == EDuplicateState.PREPARE then
                    GUI:Text_setString(self.view.openDesTxt,"")
                elseif state == EDuplicateState.FINISH then
                    GUI:setVisible(self.view.text_countdown_tips, false)
                else
                    GUI:Text_setString(self.view.end_time,"")
                end
                self:UnScheduleTimer()
            end
        end
        func()
        self.countDown = SL:Schedule(self.countDown, 0, 1, count, func)
    end
end

---罗兰攻城战任务信息改变
function this:LUA_EVENT_ROLAND_SIEGE_TASK_INFO_CHANGE()
    GUI:setVisible(self.view.loading,false)
    local taskInfo = InfoManager.loranSiegeInfo.siegeTaskInfo
    if not taskInfo or not taskInfo.taskId then
        return
    end
    local iconStr = taskInfo.camp == 1 and "icon_attack" or "icon_guard"
    local color = taskInfo.nowCount >= taskInfo.totalCount and "#00ff00" or "#ff2323"
    local title = "(血量<color="..color..">"..tostring(taskInfo.nowCount).."</color>/"..tostring(taskInfo.totalCount)..")"
    ---@type cfg_repTask_column
    self.repTaskConfig = SL:GetConfig("cfg_repTask",taskInfo.taskId)
    --最后一阶段
    if not self.repTaskConfig.nextID or self.repTaskConfig.nextID == 0 then
        self:LUA_EVENT_ROLAND_SIEGE_ROLAND_PROGRESS_INFO_CHANGE()
        title = "(<color="..color..">"..tostring(taskInfo.nowCount).."</color>/"..tostring(taskInfo.totalCount)..")"
        --防守方最后一阶段任务不显示进度
        if taskInfo.camp == 2 then
            title = ""
        end
    else
        --守方提示
        if taskInfo.camp == 2 and not self.timer1 then
            if not self.nowCount then
                self.nowCount = taskInfo.nowCount
            end
            --血量变化了
            if taskInfo.nowCount < taskInfo.totalCount then
                if self.nowCount ~= taskInfo.nowCount then
                    self.nowCount = taskInfo.nowCount
                    ---@type cfg_monster_column
                    local monsterCfg = SL:GetConfig("cfg_monster",self.repTaskConfig.param[1])
                    ---@type cfg_string_column
                    local tbl = SL:GetConfig("cfg_string", 16010, "id")
                    local HorseRaceLampData = {
                        id = 16010,
                        content = string.format(tbl.text,monsterCfg.name),
                    }
                    SL:MessageTip(HorseRaceLampData)
                    self.timer1 = SL:Schedule(self.timer1,10,10,-1,function()
                        if self.timer1 then
                            SL:UnSchedule(self.timer1)
                        end
                        self.timer1 = nil
                    end)
                end
            end
        end
    end
    
    local unionName = "无"
    local unionRank = "0"
    local selfRank = "0"
    local selfScore = "0"
    if taskInfo.unionName then
        unionName = taskInfo.unionName
    end
    if taskInfo.unionRank then
        unionRank = taskInfo.unionRank
    end
    if taskInfo.selfRank then
        selfRank = taskInfo.selfRank
    end
    if taskInfo.selfScore then
        selfScore = taskInfo.selfScore
    end
    GUI:Text_setString(self.view.nowOccupyingPartyName,tostring(unionName))
    GUI:Text_setString(self.view.unionRankText,tostring(unionRank))
    GUI:Text_setString(self.view.myRankText,tostring(selfRank))
    GUI:Text_setString(self.view.myPointsText,tostring(selfScore))
    GUI:Image_loadTexture(self.view.taskIcon,iconStr,"Atlas/KLSiegePanel.spriteatlas")

    GUI:Text_setString(self.view.stateName,tostring(self.repTaskConfig.name))
    GUI:Text_setString(self.view.taskName,tostring(self.repTaskConfig.UItext))
    GUI:Text_setString(self.view.taskProgress,title)
end

---攻城战进度信息变动
function this:LUA_EVENT_ROLAND_SIEGE_ROLAND_PROGRESS_INFO_CHANGE()
    GUI:setVisible(self.view.loading,false)
    local info = InfoManager.loranSiegeInfo.rolandProgressInfo
    local unionName = ""
    local loadNum = 0
    local now = 0
    local max = 0
    if info and info.unionName then
        unionName = "<color=#1ADE1FFF>"..info.unionName.."</color>占领中"
    end
    if unionName ~= "" then
        GUI:setVisible(self.view.loading,true)
        self.loadingCount = info.now
        if self.nowUnion ~= info.unionId and self.loadingCount == info.max and not self.timer2 then
            self.nowUnion = info.unionId
            local id = 16011
            local content = ""
            if info.unionId == SL:MeData_GetUnionId() then
                ---@type cfg_string_column
                local tbl = SL:GetConfig("cfg_string", 16011, "id")
                content = string.format(tbl.text,info.unionName)
            else
                id = 16012
                ---@type cfg_string_column
                local tbl = SL:GetConfig("cfg_string", 16012, "id")
                content = string.format(tbl.text,info.unionName)
            end
            local HorseRaceLampData = {
                id = id,
                content = content,
            }
            SL:MessageTip(HorseRaceLampData)
            self.timer2 = SL:Schedule(self.timer2,10,10,-1,function()
                if self.timer2 then
                    SL:UnSchedule(self.timer2)
                end
                self.timer2 = nil
            end)
        end
    else
        return
    end
    if info and info.now then
        now = info.now
    end
    if info and info.max then
        max = info.max
    end
    loadNum = Mathf.Ceil(now/max*100)

    GUI:Text_setString(self.view.loadingText,unionName)
    GUI:SetLoadingbar_startper(self.view.loading,loadNum)
    GUI:Text_setString(self.view.loadingNumText,now.."/"..max)
end

---攻城战怪物信息变动
function this:LUA_EVENT_ROLAND_SIEGE_ROLAND_MONSTER_LIST_CHANGE()
    self:SetResistancePoint()
end

---设置阻挡点
function this:SetResistancePoint()
    local taskInfo = InfoManager.loranSiegeInfo.siegeTaskInfo

    if taskInfo.camp == 1 then
        ---@type cfg_repGlobal_column
        local tbl = SL:GetConfig("cfg_repGlobal",16001009,"id")
        local strList = string.split(tbl.value,"|")
        for i, v in pairs(strList) do
            local strs = string.split(v,"#")
            local index = 1
            local isAdd = self:IsMonsterLive(strs[1],strs[2])
            for z = 1, table.count(strs) / 2 do
                if strs[index] then
                    SL:SetResistancePoint(tonumber(strs[index]),tonumber(strs[index+1]),isAdd)
                end
                index = index + 2
            end
        end  
    end
end

---怪物是否存活
function this:IsMonsterLive(x,y)
    local monsterInfo = InfoManager.loranSiegeInfo.monsterList

    for i, v in pairs(monsterInfo) do
        if v.x == tonumber(x) and v.y == tonumber(y) then
            return true
        end
    end
    return false
end

---取消所有阻挡点
function this:CancelAllResistancePoint()
    ---@type cfg_repGlobal_column
    local tbl = SL:GetConfig("cfg_repGlobal",16001009,"id")
    local strList = string.split(tbl.value,"|")
    for i, v in pairs(strList) do
        local strs = string.split(v,"#")
        local index = 1
        for z = 1, table.count(strs) / 2 do
            if strs[index] then
                SL:SetResistancePoint(tonumber(strs[index]),tonumber(strs[index+1]),false)
            end
            index = index + 2
        end
    end
end

function this:CreateModel()
    ---@type cfg_repGlobal_column
    local cfg = SL:GetConfig("cfg_repGlobal",16001011)
    local strList = string.split(cfg.value,'|')
    local pos = string.split(strList[2],'#')
    SL:CreateSceneItemModel(strList[1],function(res)
        if self.Model then
            SL:RecycleSceneItemModel(self.Model)
            self.Model = nil
        end
        self.Model = res
        if not IsNil(res) then
            res:SetLocalEulerAngles(0, 0, 0)
            res.localScale = Vector3 (tonumber(pos[4]),tonumber(pos[4]),tonumber(pos[4]))
            res:SetLocalPosition(tonumber(pos[1]),tonumber(pos[2]),tonumber(pos[3]))
        end
    end)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE()
    self:LUA_EVENT_ROLAND_SIEGE_TASK_INFO_CHANGE()
    self:CreateModel()
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

function this:Hide()
end

function this:Close()
    self:UnScheduleTimer()
    if this.scheduleId then
        SL:UnSchedule(this.scheduleId)
    end
    this.scheduleId = nil
    
    if self.timer1 then
        SL:UnSchedule(self.timer1)
    end
    self.timer1 = nil
    
    if self.timer2 then
        SL:UnSchedule(self.timer2)
    end
    self.timer2 = nil
    
    if SL:MeData_Check() then
        InfoManager.loranSiegeInfo:SetRoleHeadIcon(SL:MeData_GetId(),nil,SL:MeData_GetRoleExtInfo().roleInfoExtData.position)
    end
    if self.Model then
        SL:RecycleSceneItemModel(self.Model)
    end
    self.Model = nil
    self:CancelAllResistancePoint()
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,false)
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE,EPKMode.Union)
    InfoManager.loranSiegeInfo.isInCopy = false
end

return this

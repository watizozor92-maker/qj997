---@class KLTaskPanel:UIKmlLuaPanelBase
---@field view KLTaskPanelView
local KLTaskPanel = class(UIKmlLuaPanelBase)
local this =KLTaskPanel
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLTaskPanel",true)
    GUI:DataListInitData( self.view.left_top_task_list,function()
        return self:DataListItemCountFunc()
    end,function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:SetScrollViewRectMaskData(self.view.info_view, 173, 0,623,188)
    
    self.taskItemPanel = {}
    self.loadingTaskItemList = {}
    self.current_refresh_num = 1

    --GUI:setContentSize(self.view.RawImage, clm.highlightScale[1], clm.highlightScale[2])
    --GUI:setPosition(self.view.RawImage, clm.highlightPosition[1], clm.highlightPosition[2])
    

    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:RefreshTaskList()
end

function this:DataListItemCountFunc(realIndex)
    local count = table.count(SL:TaskInfo_GetAllTasks())
    return count
    --return 2
end

function this:DataListItemGetFunc(realIndex)
    
end

function this:DataListItemInitFunc(parent_realIndex, control)
end

local clickTimer = {}
function this:TaskOnClick(control, eventData)
    local realIndex = eventData.realIndex
    
    -- 特效展示一下然后隐藏
    local click_eff = GUI:GetChildControl(self.view.left_top_task_list,realIndex,'Plane_')
    GUI:SetActive(click_eff, true)
    if clickTimer[realIndex] == nil then
        clickTimer[realIndex] = SL:ScheduleOnce(1, function()
            GUI:SetActive(click_eff, false)
            clickTimer[realIndex] = nil
        end)
    end

    --local taskId = SL:TaskInfo_GetAllIds()[realIndex+1]
    local taskId = self.allTask[realIndex+1].id
    local taskInfo = SL:TaskInfo_GetAllTasks()[taskId]
    
    -- 完成任务
    if taskInfo.state == TaskState.Completed then
        ---@type cfg_task_column
        local tbl = SL:GetConfig("cfg_task", taskId)
        if tbl.npcDone and tbl.npcDone ~= 0 then
            ---@type cfg_npclist_column
            local npcTbl = SL:GetConfig("cfg_npclist", tbl.npcDone)
            local line = SL:GetMetaValue("MAP_LINE")
            local sceneId
            for _, mapMoveInfo in pairs(SL:GetConfigTable('cfg_mapMove')) do
                if mapMoveInfo.mapID == npcTbl.mapId then
                    sceneId = mapMoveInfo.id
                    break
                end
            end
            if sceneId then
                local pos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
                local newPos = SL.Scene:GetFindNearNpcAvilPoint(Dot2(npcTbl.x, npcTbl.y), 5, false)
                if pos and newPos then
                    local arriveFunc = function()
                        GUI:CloseAllUIWithoutMainUI()
                        GUI:UIPanel_Open("dev/ui/Task/Panel/KLTaskFinish/KLTaskFinishPanel",nil, nil, {taskId = taskId})
                        SL.HideMainPanel()
                    end
                    --已在目标点就不需要再寻路了
                    local maxDistance = Dot2.MaxDistance(pos,newPos)
                    if maxDistance == 0 then
                        arriveFunc()
                    else
                        --RoleManager.me:MapMove(npcTbl.x, npcTbl.y, _, sceneId, arriveFunc, false, true, true, line, tbl.npcDone)
                        SL:MapMove(npcTbl.x, npcTbl.y, sceneId, arriveFunc, false, true, true, line, tbl.npcDone)
                    end
                end
            end
        else
            GUI:UIPanel_Open("dev/ui/Task/Panel/KLTaskFinish/KLTaskFinishPanel",nil, nil, {taskId = taskId})
            SL.HideMainPanel()
        end
    else
        if self.taskItemPanel[taskId] then
            self.taskItemPanel[taskId]:OnClick()
        end
    end
    --local extraControlNum = SL:GetConfig('cfg_task', taskId).extraControlNum
    --if extraControlNum == 0 then
    --    return
    --end
    --
    --
    ---- 直接执行
    --if extraControlNum == 1 then
    --    local instruction = SL:GetConfig('cfg_task_target', taskId).instruction[1]
    --    --local autoFight = 
    --    local moveToArriveCallBack
    --    if self.args.cfgInfo.autoFight == EAutoFight.AutoFight and string.contains(instruction[1],"transfer") then
    --        AutoFightManager.isStartTaskAutoFight = true
    --    elseif self.args.cfgInfo.autoFight == EAutoFight.AutoFight and string.contains(instruction[1],"moveTo") then
    --        AutoFightManager.Stop()
    --        moveToArriveCallBack = function()
    --            AutoFightManager.StartAutoFightNoNeedHookTime()
    --        end
    --    end
    --    if self.args.cfgInfo.autoTask == EAutoTalk.AutoTalk  and string.contains(instruction[1],"moveToNPC") then
    --        AutoFightManager.Stop()
    --        moveToArriveCallBack = function()
    --            SceneTouch.ClickNpc(tonumber(instruction[2]))
    --        end
    --    end
    --    ShortcutMgr.Do(instruction,nil,nil,moveToArriveCallBack)
    --end
    
    KLGuideManager.SetTaskOnClickStatus(taskId)
end

local taskIdToRealIndex = {}
function this:DataListItemUpdateFunc(realIndex, control)
    --local taskId = SL:TaskInfo_GetAllIds()[realIndex+1]
    if self.allTask[realIndex+1] then
        local taskId = self.allTask[realIndex+1].id
        local task_layout = GUI:GetChildControl(self.view.left_top_task_list,realIndex,'task_layout')
        local curr_num = self.current_refresh_num

        self.loadingTaskItemList[taskId] = GUI:UIPanel_Open("dev/ui/Task/Item/KLTask/KLTaskItem", task_layout, self, {taskId = taskId}, true,
                function(Item)
                    self.loadingTaskItemList[taskId] = nil
                    if curr_num == self.current_refresh_num then
                        self.taskItemPanel[taskId] = Item
                    else
                        GUI:UIPanel_Close(nil, Item)
                    end
                end)

        taskIdToRealIndex[taskId] = realIndex
        self:SetTaskIcon(realIndex)

        local task_btn = GUI:GetChildControl(self.view.left_top_task_list,realIndex,'task_bg_')
        GUI:SetID(task_btn, 'task_bg_' .. taskId)
        GUI:AddOnClickEvent(task_btn,self,self.TaskOnClick, {realIndex=realIndex})

        self:SetFinishState(realIndex)
        if self.newTaskIdList and table.contains(self.newTaskIdList, taskId) then
            local start = GUI:GetChildControl(self.view.left_top_task_list,realIndex,'Start_')
            GUI:setVisible(start, true)
        end
    end
end

function this:SetFinishState(realIndex)
    --local taskId = SL:TaskInfo_GetAllIds()[realIndex+1]
    local taskId = self.allTask[realIndex+1].id
    local taskInfo = SL:TaskInfo_GetAllTasks()[taskId]
    local comp_text = GUI:GetChildControl(self.view.left_top_task_list,realIndex,'Complete_Text')
    local comp_prefab = GUI:GetChildControl(self.view.left_top_task_list,realIndex,'Complete_')
    GUI:SetActive(comp_text, false)
    GUI:SetActive(comp_prefab, false)
    if taskInfo.state == TaskState.Completed then
        GUI:SetActive(comp_text, true)  
        GUI:SetActive(comp_prefab, true)
    else
        GUI:SetActive(comp_text, false)
        GUI:SetActive(comp_prefab, false)
    end
end

function this:SetTaskIcon(realIndex)

    --local taskId = SL:TaskInfo_GetAllIds()[realIndex+1]
    local taskId = self.allTask[realIndex+1].id
    --local task_icon = GUI:GetChildControl(self.view.left_top_task_list,realIndex,'task_icon')
    local task_title = GUI:GetChildControl(self.view.left_top_task_list,realIndex,'task_title')
    local uititletype = SL:GetConfig('cfg_task', taskId).uiTitleType
    local title = ""
    if uititletype == 1 then
        --GUI:Image_loadTexture(task_icon, "img_taskmain", "Atlas/FG_UITask.spriteatlas")
        title = "主"
    elseif uititletype == 2 then
        --GUI:Image_loadTexture(task_icon, "img_taskBranch", "Atlas/FG_UITask.spriteatlas")
        title = "支"
    elseif uititletype == 3 then
        --GUI:Image_loadTexture(task_icon, "img_taskOther", "Atlas/UITask.spriteatlas")
        title = "日常"
    elseif uititletype == 4 then
        --GUI:Image_loadTexture(task_icon, "zhuanzhi", "Atlas/UITask.spriteatlas")
        title = "转"
    else
        --GUI:Image_loadTexture(task_icon, "img_taskmain", "Atlas/FG_UITask.spriteatlas")
        title = "主"
    end
    --GUI:Text_setText(task_title, string.format("[%s]", title))
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_NPC_CREATE,this.LUA_EVENT_NPC_CREATE, self)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_NEW,this.LUA_EVENT_TASK_NEW, self)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_FINISH,this.LUA_EVENT_TASK_FINISH,self)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_SUBMIT,this.LUA_EVENT_TASK_SUBMIT,self)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_CHANGE,this.LUA_EVENT_TASK_CHANGE,self)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_UI_VISIBLE,self.ShowMonsterList,self)
end
function this:LUA_EVENT_TASK_CHANGE(_, changeIdList)
    for _, taskId in pairs(changeIdList) do
        local panel = self.taskItemPanel[taskId]
        if panel then
            panel:Change()
        end
    end
end

function this:LUA_EVENT_TASK_FINISH(_, finishId)
    ---@type cfg_task_column
    local taskTbl = SL:GetConfig('cfg_task', finishId)
    for _, v in pairs(taskTbl.taskTargetId) do
        ---@type cfg_task_target_column
        local cfg = SL:GetConfig("cfg_task_target", v)
        if cfg.taskGoalType == 4 then
            --对话任务
            local npcDone = taskTbl.npcDone
            if npcDone then
                local npc = SL:GetRoleBaseNpcId(npcDone)
                if npc then
                    self:RefreshNpcIcon(npcDone)
                end
                -- GUI:CloseAllUIWithoutMainUI()
                -- GUI:UIPanel_Open("dev/ui/Task/Panel/KLTaskFinish/KLTaskFinishPanel",nil, nil, {taskId = finishId})
                -- SL.HideMainPanel()
            end
            break
        end
    end
    
--[[    local globalTbl = SL:GetConfig("cfg_global",800001).value
    local taskList = string.split(globalTbl,"#")
    for _,globalTaskId in pairs(taskList) do
        if finishId==tonumber(globalTaskId) then
            InfoManager.roleOtherInfo:newPlayerBuffActive()
        end
    end]]
    
    --local taskItem = taskItemPanel[finishId]
    --if taskItem then
    --    taskItem:Finish()
    --end
    --local realIndex = taskIdToRealIndex[finishId]
    --if realIndex then
    --    self:SetFinishState(realIndex)
    --end

    SL:ScheduleOnce(0.1,function()
        self:RefreshTaskList()
    end)
end

function this:LUA_EVENT_TASK_NEW(_, newTaskIdList)
    for _, newTaskId in pairs(newTaskIdList) do
        local npcDone = SL:GetConfig('cfg_task', newTaskId).npcDone
        if npcDone then
            --local npc = RoleManager.GetRoleBaseNpcId(npcDone)
            local npc = SL:GetRoleBaseNpcId(npcDone)
            if npc then
                self:RefreshNpcIcon(npcDone)
            end
        end
    end
    SL:ScheduleOnce(0.1,function()
        self.newTaskIdList = newTaskIdList
        self:RefreshTaskList()
    end)
end

function this:LUA_EVENT_TASK_SUBMIT(_, taskId)
    self:RefreshTaskList()
    ---@type cfg_task_column
    local task = SL:GetConfig("cfg_task", taskId)
    if task.npcDone and task.npcDone ~= 0 then
        SL:SetNpcIcon(task.npcDone, "")
    end
end

function this:RefreshTaskList()
    if self.taskItemPanel then
        for _, taskItem in pairs(self.taskItemPanel) do
            GUI:UIPanel_Close(nil, taskItem)
        end
    end
    self.taskItemPanel = {}
    taskIdToRealIndex = {}
    
    if self.view == nil then
        return
    end
    self.current_refresh_num = self.current_refresh_num + 1
    if self.current_refresh_num > 100 then
        self.current_refresh_num = 1
    end
    
    --关闭正在加载中的Item
    for i, v in pairs(self.loadingTaskItemList) do
        GUI:UIPanel_Close(nil, v)
    end
    self.loadingTaskItemList = {}

    self.allTask = {}
    local tempTask = SL:TaskInfo_GetAllIds()
    for i, v in pairs(tempTask) do
        local cfg = SL:GetConfig("cfg_task", v)
        table.insert(self.allTask, cfg)
    end
    table.sort(self.allTask, function(a, b)
        return a.uiTitleType < b.uiTitleType
    end )
    GUI:DataListUpdateData(self.view.left_top_task_list)
end

function this:ShowMonsterList(_,message)
    if message and message.vis == true then
        if self.monsterMapPointTimer then
            SL:UnSchedule(self.monsterMapPointTimer)
        end
        self.monsterMapPointTimer = SL:ScheduleOnce(1, function()
            if InfoManager.goldChallengeTaskInfo.IsMapMonsterData() and (self:IsShowMonsterList() or InfoManager.goldChallengeTaskInfo:IsShowMonsterList(InfoManager.goldChallengeTaskInfo.taskInfo))  then
                GUI:UIPanel_Open("dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanel")
            else
                GUI:UIPanel_Close("dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanel")
            end
            self.monsterMapPointTimer = nil
        end)
    else
        if self.monsterMapPointTimer then
            SL:UnSchedule(self.monsterMapPointTimer)
        end
    end
end

function this:IsShowMonsterList()
    local taskList=SL:TaskInfo_GetAllIds()
    for _,v in pairs(taskList) do
        local monsterList=SL:GetConfig("cfg_task",v).monsterlist
        if monsterList and monsterList == 1 then
            return true
        end
    end
    return false
end

function this:LUA_EVENT_NPC_CREATE(_, data)
    self:RefreshNpcIcon(data.npcId)
    --print(data.npcId)
end

function this:RefreshNpcIcon(npcId)
    local taskState = SL:GetInNpcTaskState(npcId)
    if taskState == 0 then
        SL:SetNpcIcon(npcId, "task_progress")
    elseif taskState == 1 then
        SL:SetNpcIcon(npcId, "task_finish")
    end
end

function this:Close()
    if self.taskItemPanel then
        for _, taskItem in pairs(self.taskItemPanel) do
            GUI:UIPanel_Close(nil, taskItem)
        end
    end
    self.taskItemPanel = {}
end

return this

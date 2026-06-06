---@class KLKingOfRoadPanel:UIKmlLuaPanelBase
---@field view KLKingOfRoadPanelView
local KLKingOfRoadPanel = class(UIKmlLuaPanelBase)
local this =KLKingOfRoadPanel
---创建时调用一次
function this:Init()
    
    self:InitData()
    
    GUI:DataListInitData(self.view.taskDataList, function()
        return table.count(self.chapterTaskInfo[tostring(self.clickIndex)].task_info_list)
    end,function()

    end,function()

    end,function(realIndex)
        local taskInfo = self.chapterTaskInfo[tostring(self.clickIndex)].task_info_list[realIndex+1]
        local info = SL:GetConfig('cfg_king_road_task', taskInfo.task_id)
        local name = info['text']
        local rewardItem = info['rewardItem']
        local taskTargetId = info['taskTargetId']
        

        local TaskName = GUI:GetChildControl(self.view.taskDataList,realIndex,'TaskName')
        local item6 = GUI:GetChildControl(self.view.taskDataList,realIndex,'item6')
        local TaskCount = GUI:GetChildControl(self.view.taskDataList,realIndex,'TaskCount')
        local BtnGet = GUI:GetChildControl(self.view.taskDataList,realIndex,'BtnGet')
        local highLight = GUI:GetChildControl(self.view.taskDataList,realIndex,'highLight')
        local Img_Received = GUI:GetChildControl(self.view.taskDataList,realIndex,'Img_Received')

        GUI:Text_setString(TaskName, name)
        GUI:Item_UpdataData(item6, {
            ["itemid"] = rewardItem[1],
            ["itemcount"] = rewardItem[2],
        })
        GUI:AddOnClickEvent(item6, self, function()
            SL:OpenTips(nil, rewardItem[1])
        end)

        if taskInfo == nil then
            return
        end
        
        if taskInfo.goal_count < taskInfo.max_count then
            GUI:Text_setString(TaskCount, string.format('<color="#9b1818">%d</color>/%d',  taskInfo.goal_count, taskInfo.max_count))
        else
            GUI:Text_setString(TaskCount, string.format('<color="#2a8430">%d</color>/%d',  taskInfo.goal_count, taskInfo.max_count))
        end

        if taskInfo.state == 1 then
            GUI:setVisible(BtnGet, true)
            GUI:setVisible(Img_Received, false)
            GUI:Text_setString(BtnGet, "前往")
            GUI:setVisible(highLight, false)
            local inst = SL:GetConfig('cfg_task_target', taskTargetId).instruction
            GUI:AddOnClickEvent(BtnGet, self, function()
                self:ClosePanel()
                SL:ShortcutDO(inst[1])
            end )
        elseif taskInfo.state == 2 then
            GUI:setVisible(BtnGet, true)
            GUI:setVisible(Img_Received, false)
            GUI:Text_setString(BtnGet, "领取")
            GUI:setVisible(highLight, true)
            GUI:AddOnClickEvent(BtnGet, self, function()
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SUBMIT_KING_ROAD_TASK,info.id)
            end )
        else
            GUI:setVisible(BtnGet, false)
            GUI:setVisible(Img_Received, true)

        end
    end)

    GUI:DataListInitData(self.view.groupDataList, function()
        local tbl = SL:GetConfigTable('cfg_king_road')
        return table.count(tbl)
    end,function()

    end,function()

    end,function(realIndex)
        local tbl = SL:GetConfig('cfg_king_road', realIndex+1 )
        local icon = tbl.icon
        local rewardItem = tbl['rewardItem']

        local chapteraName = GUI:GetChildControl(self.view.groupDataList,realIndex,'chapteraName')
        local AwardObj = GUI:GetChildControl(self.view.groupDataList,realIndex,'AwardObj')
        local Lock = GUI:GetChildControl(self.view.groupDataList,realIndex,'Lock')
        local selectBg = GUI:GetChildControl(self.view.groupDataList,realIndex,'selectBg')
        local selectToggle = GUI:GetChildControl(self.view.groupDataList,realIndex,'selectToggle')
        
        GUI:Image_loadTexture(chapteraName, icon,"Atlas/KLKingOfRoad.spriteatlas")
        GUI:Item_setItemId(AwardObj, rewardItem[1])

        if self:GetIsLock(realIndex+1) then
            GUI:setVisible(Lock, true)
        else
            GUI:setVisible(Lock, false)
        end
        
        if realIndex + 1 == self.clickIndex then
            GUI:setVisible(selectBg, true)
        else
            GUI:setVisible(selectBg, false)
        end
        
        GUI:AddOnClickEvent(selectToggle, self, self.selectToggle, {clickIndex=realIndex+1})
    end)
end

function this:selectToggle(control, eventData)
    local clickIndex = eventData.clickIndex
    if self:GetIsLock(clickIndex) then
        return
    end
    
    self.clickIndex = clickIndex
    
    GUI:DataListUpdateData(self.view.taskDataList)
    GUI:DataListUpdateData(self.view.groupDataList)
    self:SetRewardData()
end

function this:InitData()
    self.curChapterToTask = {}
    local tbl = SL:GetConfigTable('cfg_king_road_task')
    for _, info in pairs(tbl) do
        local chapter = info.group
        if self.curChapterToTask[chapter] == nil then
            self.curChapterToTask[chapter] = {}
        end
        
        table.insert(self.curChapterToTask[chapter], info)
    end
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.BtnGet1, self, self.BtnGet1)
    GUI:AddOnClickEvent(self.view.ObjPos, self, self.ObjPosOnclick)
    
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_KING_ROAD_TASK_INFO, self.ResKingRoadTaskInfo, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_KING_ROAD_TASK_CHANGE, self.RES_KING_ROAD_TASK_CHANGE, self)
end

function this:BtnGet1()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECEIVE_KING_ROAD_CHAPTER_AWARD,self.clickIndex)
end

function this:ObjPosOnclick()
    if not self.item_cfgid then
        return
    end
    SL:OpenTips(nil, self.item_cfgid)
end

function this:RES_KING_ROAD_TASK_CHANGE(_, message)
    local curChapter = message.now_chapter
    local state = message.chapter_state
    local changeTask = message.change_task
    
    self.curChapter = curChapter
    self.chapterTaskInfo[tostring(self.curChapter)].state = state
    
    for taskId, taskInfo in pairs(changeTask) do
        if self.chapterTaskInfo[tostring(self.curChapter)].task_info[taskId] ~= nil then
            self.chapterTaskInfo[tostring(self.curChapter)].task_info[taskId] = taskInfo
        end

        for index, listInfo in pairs(self.chapterTaskInfo[tostring(self.curChapter)].task_info_list) do
            if listInfo.task_id == tonumber(taskId) then
                self.chapterTaskInfo[tostring(self.curChapter)].task_info_list[index] = taskInfo
            end
        end
    end

    table.sort(self.chapterTaskInfo[tostring(self.curChapter)].task_info_list, function(a, b)
        -- 如果 a 和 b 的 state 都不等于 2，则直接比较它们的 state  
        if a.state ~= 2 and b.state ~= 2 then
            return a.state < b.state
            -- 如果 a 的 state 是 2，则 a 应该排在 b 前面  
        elseif a.state == 2 then
            if b.state == 2 then
                return false
            end
            return true
            -- 如果 b 的 state 是 2，则 a 不应该排在 b 前面（即 b 应该排在 a 前面）  
        else
            return false
        end
    end)
    

    GUI:DataListUpdateData(self.view.taskDataList)
    GUI:DataListUpdateData(self.view.groupDataList)

    self:SetRewardData()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.clickIndex = 1
    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_KING_ROAD_TASK_INFO)
end

function this:Close()
    SL.ShowMainPanel()
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Task/Panel/KLKingOfRoad/KLKingOfRoadPanel")
end

function this:ResKingRoadTaskInfo(eventId, eventData)
    if eventData.now_chapter == -1 then
        self.curChapter = self.clickIndex
    else
        self.curChapter = eventData.now_chapter
    end
    self.chapterTaskInfo = eventData.chapter_task_info
    self.clickIndex = self.curChapter
    
    for index, chapterInfo in pairs(self.chapterTaskInfo) do
        chapterInfo.task_info_list = {}
        for taskId, taskInfo in pairs(chapterInfo.task_info) do
            table.insert(chapterInfo.task_info_list, taskInfo)
        end
        
        table.sort(chapterInfo.task_info_list, function(a, b)
            -- 如果 a 和 b 的 state 都不等于 2，则直接比较它们的 state  
            if a.state ~= 2 and b.state ~= 2 then
                
                return a.state < b.state    
                -- 如果 a 的 state 是 2，则 a 应该排在 b 前面  
            elseif a.state == 2 then
                if b.state == 2 then
                    return false
                end
                
                return true
                -- 如果 b 的 state 是 2，则 a 不应该排在 b 前面（即 b 应该排在 a 前面）  
            else
                return false
            end
        end)
    end
    
    GUI:DataListUpdateData(self.view.taskDataList)
    GUI:DataListUpdateData(self.view.groupDataList)
    
    self:SetRewardData()
    
end

--function this:GetSelectTaskInfo(targetTaskId)
--    if self.chapterTaskInfo[tostring(self.clickIndex)] == nil then
--        return
--    end
--    
--    for _, taskInfo in pairs(self.chapterTaskInfo[tostring(self.clickIndex)].task_info) do
--        if taskInfo.target_id == targetTaskId then
--            return taskInfo
--        end
--
--    end
--end

function this:GetIsLock(selectIndex)
    if self.curChapter < selectIndex then
        return true
    end
    
    return false
end

function this:SetRewardData()
    local tbl = SL:GetConfig('cfg_king_road', self.clickIndex)
    local rewardItem = tbl['rewardItem']
    self.item_cfgid = rewardItem[1]
    GUI:Item_setItemId(self.view.ObjPos, rewardItem[1])
    GUI:Item_Scale(self.view.ObjPos, 150)
    local info = self.chapterTaskInfo[tostring(self.clickIndex)]
    if info == nil then
        GUI:setVisible(self.view.BtnGet1, false)
        GUI:setVisible(self.view.Img_Received_1, false)
        return
    end
    
    if info.state == 1 then
        GUI:setVisible(self.view.BtnGet1, false)
        GUI:setVisible(self.view.Img_Received_1, false)
    elseif info.state == 2 then
        GUI:setVisible(self.view.BtnGet1, true)
        GUI:setVisible(self.view.Img_Received_1, false)
    else
        GUI:setVisible(self.view.BtnGet1, false)
        GUI:setVisible(self.view.Img_Received_1, true)
    end
    
end

return this

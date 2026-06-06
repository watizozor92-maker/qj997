---@class KLTaskItem:UIKmlLuaPanelBase
---@field view KLTaskItemView
local KLTaskItem = class(UIKmlLuaPanelBase)
local this = KLTaskItem
---创建时调用一次
function this:Init()
    self.taskId = self.args.taskId
    local taskInfo = SL:TaskInfo_GetAllTasks()[self.taskId]
    self.uititletype = SL:GetConfig('cfg_task', self.taskId).uiTitleType

    GUI:DataListInitData(self.view.task_goad_, function(realIndex)
        return table.count(taskInfo.taskGoalRecord)
    end, function(realIndex)

    end, function(realIndex, kmlcontrol)
        local task_title = SL:GetConfig('cfg_task_target', taskInfo.taskGoalRecord[realIndex + 1].goalId).mainuiName
        local title_text = GUI:GetChildControl(self.view.task_goad_, realIndex, 'title_text')
        local taskType = GUI:GetChildById(self.view.task_goad_, "taskType")
        GUI:Text_setString(title_text, task_title)
    end, function(realIndex, kmlcontrol)
        self:SetTaskState(realIndex)
    end, function()

    end)

    GUI:setContentSize(self.view.layout_1047, 230, 20)
    GUI:setPosition(self.view.layout_1047, 26, 0)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.uititletype ~= 5 then
        GUI:setVisible(self.view.layout_1047, true)
        GUI:DataListUpdateData(self.view.task_goad_)
    end

    self:UpdateEquipName()

    if SL:TaskInfo_GetAllTasks()[self.taskId].state == TaskState.Completed then
        GUI:SetActive(self.view.GuideBG, true)
        local ax, ay = GUI:getPosition(self.view.GuidePanel)
        self.moveX = GUI:DOAnchorPosX(self.view.GuidePanel, ax - 5, 0.6)
        GUI:TweenSetLoops(self.moveX, -1)
        GUI:TweenSetEase(self.moveX, ELeanTweenType.pingPong)
    end
    local taskType = self:GetTaskType(self.uititletype)
    GUI:Image_loadTexture(self.view.taskType,taskType,"Atlas/NewMainPanel.spriteatlas")
end

function this:GetTaskType(uititletype)
    local title = ""
    if uititletype == 1 then
        title = "icon_zhuxian"--"主"
    elseif uititletype == 2 then
        title = "icon_zhixian"--"支"
    elseif uititletype == 3 then
        title = "icon_richang"--"日常"
    elseif uititletype == 4 then
        title = "icon_zhuanzhi" -- "转"
    elseif uititletype == 5 then
        title = "icon_zhixian"--"循环"
    else
        title ="icon_zhuxian"--"主"
    end
    return title
end

function this:SetTaskState(realIndex)
    local taskInfo = SL:TaskInfo_GetAllTasks()[self.taskId]
    local taskGoalInfo = taskInfo.taskGoalRecord[realIndex + 1]
    local progress_control = GUI:GetChildControl(self.view.task_goad_, realIndex, 'title_progress__')
    local nowCount = taskGoalInfo.count
    local maxCount = taskGoalInfo.maxCount
    local taskCfg = SL:GetConfig("cfg_task", taskInfo.taskId)
    if taskInfo.state == TaskState.Completed then
        GUI:SetActive(progress_control, false)
    else
        GUI:SetActive(progress_control, true)
        if nowCount >= maxCount then
            GUI:Text_setString(progress_control, string.format("<color=green>%d/%d</color>", nowCount, maxCount))
        else
            GUI:Text_setString(progress_control, string.format("%d/%d", nowCount, maxCount))
        end

        if taskGoalInfo.isChange and nowCount < maxCount then
            self.co = Coroutine.Start(function()
                GUI:Text_setString(progress_control, string.format("<color=red>%d</color>/%d", nowCount, maxCount))
                Coroutine.Wait(0.1)
                GUI:Text_setString(progress_control, string.format("%d/%d", nowCount, maxCount))
                Coroutine.Wait(0.1)
                GUI:Text_setString(progress_control, string.format("<color=red>%d</color>/%d", nowCount, maxCount))
                Coroutine.Wait(0.1)
                GUI:Text_setString(progress_control, string.format("%d/%d", nowCount, maxCount))
                Coroutine.Wait(0.1)
                GUI:Text_setString(progress_control, string.format("<color=red>%d</color>/%d", nowCount, maxCount))
                Coroutine.Wait(0.1)
                GUI:Text_setString(progress_control, string.format("%d/%d", nowCount, maxCount))
            end
            )
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_LOOP_TASK_INFO_CHANGE, self.LUA_EVENT_LOOP_TASK_INFO_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_STRENGTH_OK, self.LUA_EVENT_STRENGTH_OK, self)
    SL:RegisterLUAEvent(LUA_EVENT_APPEND_OK, self.LUA_EVENT_APPEND_OK, self)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_LUCKY_OK, self.LUA_EVENT_EQUIP_LUCKY_OK, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
end

function this:Close()
    if self.moveX then
        GUI:DOKill(self.moveX)
        self.moveX = nil
    end

    if self.co ~= nil then
        Coroutine.Stop(self.co)
        self.co = nil
    end
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

function this:Finish()
end

function this:OnClick()
    local taskInfo = SL:TaskInfo_GetAllTasks()[self.taskId]
    for _, goal in pairs(taskInfo.taskGoalRecord) do
        -- 这个子任务没完成
        if goal.count < goal.maxCount then
            local targetId = goal.goalId
            local extraControlNum = SL:GetConfig('cfg_task_target', targetId).extraControlNum
            local instruction = SL:GetConfig('cfg_task_target', targetId).instruction
            if extraControlNum == 0 then
                break
            elseif extraControlNum == 1 then
                instruction = instruction[1]
                if instruction ~= nil and #instruction > 1 then
                    local autoFight = SL:GetConfig('cfg_task_target', targetId).autoFight
                    local autoTask = SL:GetConfig('cfg_task_target', targetId).autoTask
                    local autoDialogue = SL:GetConfig('cfg_task_target', targetId).autoDialogue
                    local cacheData
                    local moveToArriveCallBack
                    if autoFight == EAutoFight.AutoFight and string.contains(instruction[1], "transfer") then
                        if not SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                            SL:SetBattleState(true)
                        end
                    elseif autoFight == EAutoFight.AutoFight and string.contains(instruction[1], "moveTo") then
                        SL:SetBattleState(false)
                        moveToArriveCallBack = function()
                            if SL:CanTaskMovingAutoKillMonster() and SL.SetTaskKillMonsterRangeOnMoving then
                                SL:SetTaskKillMonsterRangeOnMoving()
                            end
                            if not SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                                SL:SetBattleState(true)
                            end
                        end
                        ---@type cfg_task_target_column
                        local taskTbl = SL:GetConfig('cfg_task_target', targetId)
                        if SL:CanTaskMovingAutoKillMonster() and SL.SetTaskKillMonsterRangeOnMoving then
                            SL:SetTaskKillMonsterRangeOnMoving(5, moveToArriveCallBack, taskTbl.taskGoalParam,
                                instruction, 100, goal)
                        end
                    end
                    if instruction[1] == "openUIPanel" and instruction[2] == "dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel" then
                        ---@type cfg_task_target_column
                        local taskTbl = SL:GetConfig('cfg_task_target', targetId)
                        cacheData = {5, moveToArriveCallBack, taskTbl.taskGoalParam, instruction, 100, goal}
                    end
                    if autoTask == EAutoTalk.AutoTalk and string.contains(instruction[1], "moveToNPC") then
                        SL:SetBattleState(false)
                        ---判断是否已经在目标点
                        if SL:GetTalkBtnVisByNpcId(tonumber(instruction[2])) then
                            SL:TalkToNpc(tonumber(instruction[2]), true)
                        else
                            moveToArriveCallBack = function()
                                SL:RangeClickNpc(tonumber(instruction[2]), true)
                            end
                        end
                    end
                    ---寻路npc终点，触发点击npc操作
                    if autoDialogue == EAutoTalk.AutoTalk and string.contains(instruction[1], "moveToNPC") then
                        SL:SetBattleState(false)
                        ---判断是否已经在目标点
                        if SL:GetTalkBtnVisByNpcId(tonumber(instruction[2])) then
                            SL:TalkToNpc(tonumber(instruction[2]))
                        else
                            moveToArriveCallBack = function()
                                SL:RangeClickNpc(tonumber(instruction[2]))
                            end
                        end
                    end
                    local cfg_task_target = SL:GetConfig('cfg_task_target', targetId)
                    if cfg_task_target.taskGoalType == 50 and table.count(cfg_task_target.taskGoalParam2) >= 1 and cfg_task_target.taskGoalParam2[1] == 1 then
                        return
                    end
                    InfoManager.taskOutInfo:SetTaskTempCacheData(cacheData)
                    SL:ShortcutDO(instruction, nil, nil, moveToArriveCallBack)
                end
            else
                local worldPositionX, worldPositionY, worldPositionZ = GUI:GetWorldPosition(self.view.TaskGuidePoint)

                GUI:UIPanel_Open("dev/ui/Task/Panel/KLTaskGuide/KLTaskGuidePanel", nil, nil,
                    { goalId = goal.goalId, position = { x = worldPositionX, y = worldPositionY, z = worldPositionZ } })
            end

            break
        end
    end
end

function this:Change()
    -- GUI:DataListUpdateData(self.view.task_goad_)
    self:UpdateEquipName()
    GUI:DataListUpdateData(self.view.task_goad_)
end

function this:UpdateEquipName()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    if self.uititletype == 5 then
        GUI:setVisible(self.view.layout_1047, false)
        local currentLoopNum = InfoManager.taskLoopInfo.currentLoopNum + 1
        local taskinfo = SL:GetConfig('cfg_taskline', currentLoopNum)
        self.taskInfo = taskinfo
        local equip_name_str = ""
        --皮铠+强1+Z4+幸运+1条卓越词条
        local text = '需求:'

        if taskinfo.itemId and SL:HasConfig('cfg_item', InfoManager.taskLoopInfo.currentCfgId) then
            local itemInfo = SL:GetConfig('cfg_item', InfoManager.taskLoopInfo.currentCfgId)
            local color = SL:GetConfig("cfg_color",itemInfo.color).color
            text = text .. "<color="..color..">"..itemInfo.name.."</color>"
        end
        text = text
        if taskinfo.qianghua > 0 then
            text = text .. '+<color=#e6e600>' .. taskinfo.qianghua.."</color>"
        end

        if taskinfo.zhuijia > 0 then
            text = text .. '+<color=#e6e600>z' .. (tonumber(taskinfo.zhuijia) * 4).."</color>"
        end
        --幸运待定
        if taskinfo.xingyun > 0 then
            text = text .. '+<color=#e6e600>幸运</color>'
        end
        --if taskinfo.jineng > 0 then
        --    text = text .. '<color=#4BA7E8>附加“武器技能”</color>'
        --end
        if taskinfo.zuoyue > 0 then
            text = text .. '+<color=#e6e600>' .. taskinfo.zuoyue .. '卓越</color>'
        end
        if taskinfo.strPart and #taskinfo.strPart > 0 then
            text = text.."<color=#e6e600>的"
            if #taskinfo.strPart == 8 then
                text = text .. '装备'
            else
                for key, part in ipairs(taskinfo.strPart) do
                    if part == 1 then
                        text = text .. '主手武器'
                    elseif part == 2 then
                        text = text .. '副手武器'
                    elseif part == 3 then
                        text = text .. '双手武器'
                    elseif part == 4 then
                        text = text .. '头盔'
                    elseif part == 5 then
                        text = text .. '铠甲'
                    elseif part == 6 then
                        text = text .. '护手'
                    elseif part == 7 then
                        text = text .. '护腿'
                    elseif part == 8 then
                        text = text .. '鞋子'
                    end
                    if key < #taskinfo.strPart then
                        text = text .. "/"
                    end
                end
            end
            text = text .. "</color>"
        end


        -- SL:LogTable(taskinfo.itemId,true)
        -- SL:LogError(InfoManager.taskLoopInfo.currentCfgId)

        local items = SL:GetMetaValue("BAG_DATA")[1]
        local have_one = false
        for _, v in pairs(items) do
            if self:CheckItem(v) then
                have_one = true
                break
            end
        end
        local rewardNum = 0
        for _, v in pairs(taskinfo.jiangli) do
           if v[1] == 10070001 then
            rewardNum = rewardNum + v[2]
            end
        end
        text = text .. "\n奖励:属性点x"..rewardNum

        GUI:Text_setString(self.view.equip_name, text)
        if have_one then
            GUI:Text_setString(self.view.equip_num, "1/1")
            GUI:setColor(self.view.equip_name, "#00ff00")
            GUI:setColor(self.view.equip_num, "#00ff00")
        else
            GUI:Text_setString(self.view.equip_num, "0/1")
            GUI:setColor(self.view.equip_name, "#FFFFFF")
            GUI:setColor(self.view.equip_num, "#FFFFFF")
        end
        -- self.timer = SL:ScheduleOnce(Time.deltaTime, function()
        --     local hight = GUI:GetHeight(self.view.equip_name)
        --     if hight > 20 then
        --         GUI:setPositionY(self.view.layout_1047, 25)
        --         GUI:setPositionY(self.view.equip_name, 25)
        --     else
        --         GUI:setPositionY(self.view.layout_1047, 10)
        --         GUI:setPositionY(self.view.equip_name, -10)
        --     end
        -- end)
    else
        GUI:Text_setString(self.view.equip_name, "")
        GUI:Text_setString(self.view.equip_num, "")
        -- GUI:setPositionY(self.view.layout_1047, 10)
    end
end

---检查道具是否符合要求
function this:CheckItem(item)
    local itemTable = SL:GetConfig('cfg_item', item.cfgId) or {}
    if itemTable.type ~= 2 then
        return false
    end

    if next(self.taskInfo.itemId) then
        if not GUIUtil.ItemEquals(item.cfgId, InfoManager.taskLoopInfo.currentCfgId) then
            return false
        end
    end

    if next(self.taskInfo.strPart) then
        local fuhe = false
        for _, value in pairs(itemTable.strPart) do
            if table.contains(self.taskInfo.strPart, value) then
                fuhe = true
                break
            end
        end
        if not fuhe then
            return false
        end
    end

    if self.taskInfo.qianghua > 0 then
        if EquipFunc.GetEquipStrengthLevel(item) < self.taskInfo.qianghua then
            return false
        end
    end
    if self.taskInfo.zhuijia > 0 then
        if EquipFunc.GetEquipAppendLevel(item) < self.taskInfo.zhuijia then
            return false
        end
    end
    if self.taskInfo.zuoyue > 0 then
        local entryAttr = SL:GetEquipEntrys(item)
        local count = entryAttr and table.count(entryAttr) or 0
        if count < self.taskInfo.zuoyue then
            return false
        end
    end
    if self.taskInfo.xingyun > 0 then
        local entryAttr = EquipFunc.GetEquipLuckyAttr(item)
        if table.isNullOrEmpty(entryAttr) then
            return false
        end
    end
    return true
end

function this:CheckLoopTask()
    if not self.taskId then
        return
    end
    if self.uititletype == 5 then
        self:Change()
    end
end

function this:LUA_EVENT_LOOP_TASK_INFO_CHANGE()
    self:CheckLoopTask()
end

---装备强化成功
function this:LUA_EVENT_STRENGTH_OK()
    self:CheckLoopTask()
end

function this:LUA_EVENT_APPEND_OK()
    self:CheckLoopTask()
end

function this:LUA_EVENT_EQUIP_LUCKY_OK()
    self:CheckLoopTask()
end

function this:LUA_EVENT_BAG_CHANGE_AFTER()
    self:CheckLoopTask()
end

return this

---@class KLActivityComboProgressPanel:UIKmlLuaPanelBase
---@field view KLActivityComboProgressPanelView
local KLActivityComboProgressPanel = class(UIKmlLuaPanelBase)
local this =KLActivityComboProgressPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLActivityComboProgressPanel",true)
    self.trialsType = 25001
    ---@type cfg_rep_column
    self.trialsTbl = SL:GetConfig("cfg_rep", self.args["3"])
    self.trialsState = self.args["1"]

    GUI:DataListInitData( self.view.rewardItem_List,function()
        return self:ListItemCountFunc()
    end, function(realIndex)
        return self:ListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:ListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData( self.view.rewardItem_finish_List,function()
        return self:ListItemCountFunc()
    end, function(realIndex)
        return self:ListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:ListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:FinishListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

function this:ListItemCountFunc()
    return #self.trialsTbl.reward
end

function this:ListItemGetFunc(realIndex)

end

function this:ListItemInitFunc(realIndex, kmlcontrol)

end

function this:ListItemUpdateFunc(realIndex, kmlcontrol)
    local item = GUI:GetChildControl(self.view.rewardItem_List, realIndex, "control_item")
    local count = GUI:GetChildControl(self.view.rewardItem_List, realIndex, "countTxt")
    local info = self.trialsTbl.reward[realIndex + 1]
    GUI:Item_setItemId(item, info[1])
    GUI:Text_setString(count, tostring(info[2]))
    GUI:AddOnClickEvent(item, self, self.ShowItemTips, info[1])
end

function this:FinishListItemUpdateFunc(realIndex, kmlcontrol)
    local item = GUI:GetChildControl(self.view.rewardItem_finish_List, realIndex, "control_finish_item")
    local count = GUI:GetChildControl(self.view.rewardItem_finish_List, realIndex, "countFinishTxt")
    local info = self.trialsTbl.reward[realIndex + 1]
    GUI:Item_setItemId(item, info[1])
    GUI:Text_setString(count, tostring(info[2]))
    GUI:AddOnClickEvent(item, self, self.ShowItemTips, info[1])
end

function this:ShowItemTips(_, id)
    SL:OpenTips(nil, id)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_reward, self, self.RewardOnClick)
    GUI:AddOnClickEvent(self.view.exitBtn_task, self, self.ExitBtnOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE, self.RES_QUIT_DUPLICATE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_CALIMA_TEMP_TASK_UPDATE, self.RES_COMBO_TES_TASK_UPDATE, self)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.txt_countDown, "")
    GUI:setVisible(self.view.exitBtn_task, true)
    GUI:Text_setString(self.view.title_task, self.trialsTbl.name[1])
    ---@type cfg_repTask_column
    local task = SL:GetConfig("cfg_repTask", tonumber(self.trialsTbl.repTarget))
    GUI:Text_setString(self.view.taskName_task, task.UItext)
    GUI:setVisible(self.view.panel_finish, false)
    GUI:setVisible(self.view.countDown_in_copy, false)
    --self.taskNum = task.param[2]
    GUI:Text_setString(self.view.taskProgress_task, "0/" .. task.param[2])
    --GUI:setPosition(self.view.rewardItem_layout, -27, -60)
    GUI:setVisible(self.view.rewardItem_layout, true)
    GUI:setVisible(self.view.rewardItem_finish_layout, false)
    GUI:DataListUpdateData(self.view.rewardItem_List)
    GUI:setVisible(self.view.panel_start, true)
    self:RefreshComboState(self.args)
end

function this:RefreshComboState(message)
    self.trialsState = message["1"]
    self.trialsNextStateTime = message["2"]
    self.trialsId = message["3"]
    if self.trialsState == 1 then
        ---准备阶段
    elseif self.trialsState == 2 then
        ---战斗阶段
        local time = (self.trialsNextStateTime - Time.GetServerTime()) / 1000
        GUI:SetControl_time(self.view.countDown_in_copy, math.floor(time))
        GUI:setVisible(self.view.countDown_in_copy, true)
    elseif self.trialsState == 3 then
        ---完成阶段
        self:RefreshFinishPanel()
--[[        if message["4"] then
            self:RefreshFinishPanel()
        else
            --self:ExitBtnOnClick()
        end]]
    end
end

function this:RefreshFinishPanel()
    GUI:setVisible(self.view.exitBtn_task, true)
    GUI:setVisible(self.view.panel_start, false)
    GUI:setVisible(self.view.countDown_in_copy, false)
    GUI:setVisible(self.view.rewardItem_layout, false)
    GUI:setVisible(self.view.rewardItem_finish_layout, true)
    GUI:DataListUpdateData(self.view.rewardItem_finish_List)
    GUI:setVisible(self.view.panel_finish, true)
    GUI:setVisible(self.view.btn_reward, false)
    local time1 = tonumber(SL:GetMetaValue("SERVER_TIME"))
    local endTime = time1 + self.trialsTbl.save * 1000
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    self.timer = SL:Schedule(self.timer,0,1, -1,function()
        local time = tonumber(SL:GetMetaValue("SERVER_TIME"))
        local deltaTime = (endTime - time) // 1000
        if deltaTime < 0 then
            deltaTime = 0
        end
        GUI:Text_setString(self.view.txt_countDown, string.format("副本将在%d秒后结束\n请尽快拾取战利品", deltaTime))
        if deltaTime <= 0 then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE, 22001)
            SL:UnSchedule(self.timer)
            self.timer = nil
        end
    end)
end

function this:RewardOnClick()
    SL:SendLuaNetMsg(LuaMessageIdToSever.COMBO_TEST_REWARD, self.trialsTbl.id)
end

function this:ExitBtnOnClick()
    if self.trialsState == 3 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE, self.trialsTbl.id)
    else
        SL:CommonTipsMessage({ stringTblID = 210, callback = function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE, self.trialsTbl.id)
        end })
    end
end

function this:RES_COMBO_TES_TASK_UPDATE(_, message)
--[[    if tonumber(message.phase) == tonumber(self.trialsTbl.repTarget) then
        GUI:Text_setString(self.view.taskProgress_task, message.nowCount .. "/" .. message.totalCount)
    end]]
    GUI:Text_setString(self.view.taskProgress_task, message.nowCount .. "/" .. message.totalCount)
end

function this:RES_QUIT_DUPLICATE()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLActivityComboProgress/KLActivityComboProgressPanel")
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

function this:Hide()
end

function this:Close()
    InfoManager.copActivityInfo.hideTask = false
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

return this

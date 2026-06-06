---@class KLBraveTrialsWindowPanel:UIKmlLuaPanelBase
---@field view KLBraveTrialsWindowPanelView
local KLBraveTrialsWindowPanel = class(UIKmlLuaPanelBase)
local this =KLBraveTrialsWindowPanel
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLBraveTrialsWindowPanel",true)
    self.braveType = 12001
    ---@type cfg_rep_column
    self.trialsTbl = SL:GetConfig("cfg_rep", self.args["3"])
    self.trialsState = self.args["1"]
    --self.trialsNextStateTime = self.args[2]
    GUI:DataListInitData( self.view.rewardItem_List,function()
        return self:ListItemCountFunc()
    end,function(realIndex)
        return self:ListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData( self.view.rewardItem_finish_List,function()
        return self:ListItemCountFunc()
    end,function(realIndex)
        return self:ListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:FinishListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

function this:ListItemCountFunc()
    return #self.trialsTbl.reward
end

function this:ListItemGetFunc(realIndex)
    --GUI:UIPanel_Open("dev/outui/BraveTrials/Panel/KLBraveTrialsWindow/KLBraveTrialsWindowPanel")
end

function this:ListItemInitFunc(realIndex, kmlcontrol)

end

function this:ListItemUpdateFunc(realIndex, kmlcontrol)
    local item = GUI:GetChildControl(self.view.rewardItem_List, realIndex, "control_item")
    local count = GUI:GetChildControl(self.view.rewardItem_List, realIndex, "countTxt")
    local info = self.trialsTbl.reward[realIndex + 1]
    GUI:Item_setItemId(item, info[1])
    GUI:Text_setString(count, info[2])
end

function this:FinishListItemUpdateFunc(realIndex, kmlcontrol)
    local item = GUI:GetChildControl(self.view.rewardItem_finish_List, realIndex, "control_finish_item")
    local count = GUI:GetChildControl(self.view.rewardItem_finish_List, realIndex, "countFinishTxt")
    local info = self.trialsTbl.reward[realIndex + 1]
    GUI:Item_setItemId(item, info[1])
    GUI:Text_setString(count, info[2])
end

---创建或者刷新界面数据时调用
function this:Refresh(message)
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
    self:RefreshBraveState(message or self.args)
end

function this:RefreshBraveState(message)
    if self.trialsTbl.id == message["3"] then
        self.trialsState = message["1"]
        self.trialsNextStateTime = message["2"]
        if self.trialsState == 1 then
            ---准备阶段
            GUI:Text_setString(self.view.text_countdown_tips, "副本开始倒计时：")
            GUI:SetControl_time(self.view.countdown_out_copy, self.trialsTbl.prepareTime)
            GUI:setVisible(self.view.text_countdown_tips, true)
        elseif self.trialsState == 2 then
            ---战斗阶段
            GUI:setVisible(self.view.text_countdown_tips, false)
            local time = (self.trialsNextStateTime - Time.GetServerTime()) / 1000
            GUI:SetControl_time(self.view.countDown_in_copy, math.floor(time))
            GUI:setVisible(self.view.countDown_in_copy, true)
        elseif self.trialsState == 3 then
            ---完成阶段
            if message["4"] then
                GUI:setVisible(self.view.exitBtn_task, false)
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_ACTIVITY_COUNT, self.braveType)
            else
                self:ExitBtnOnClick()
            end
        end
    else
        ---前往下一层，刷新副本UI
        self.trialsTbl = SL:GetConfig("cfg_rep", message["3"])
        self.trialsState = message["1"]
        self:Refresh(message)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.exitBtn_task, self, self.ExitBtnOnClick)
    GUI:AddOnClickEvent(self.view.btn_reward, self, self.RewardBtnOnClick)
    GUI:AddOnClickEvent(self.view.btn_next, self, self.NextBtnOnClick)
    --SL:RegisterLUAEvent(LUA_EVENT_HPCHANGE, self.RefreshPlayerHp, self)--主角血量改变事件
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.BRAVE_TEST_REWARD, self.BRAVE_TEST_REWARD, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE, self.RES_QUIT_DUPLICATE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_ACTIVITY_COUNT, self.RES_GET_ACTIVITY_COUNT, self)
end

function this:ExitBtnOnClick()
    self.goNextLevel = false
    if self.trialsState == 3 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
    else
        SL:CommonTipsMessage({ stringTblID=210, callback = function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
        end })
    end
end

function this:RewardBtnOnClick()
    SL:SendLuaNetMsg(LuaMessageIdToSever.BRAVE_TEST_REWARD)
    self:ExitBtnOnClick()
end

---前往下一层不关闭副本UI
function this:NextBtnOnClick()
    self.goNextLevel = true
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, self.trialsTbl.id + 1)
end

function this:RefreshPlayerHp()
    local hp = SL:GetMetaValue("HP")
    if hp <= 0 and not self.isDead then
        self.isDead = true
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
    end
end

function this:BRAVE_TEST_REWARD(_, message)
    local reward = {}
    for i, v in pairs(message) do
        reward[tonumber(i)] = tonumber(v)
    end
    ---延时调用，要不会被地图切换关闭所有界面关掉
    SL:ScheduleOnce(0.1, function()
        SL:OpenRewardTips(reward,0)
    end)
end

function this:RES_QUIT_DUPLICATE()
    if not self.goNextLevel then
        GUI:UIPanel_Close("dev/outui/BraveTrials/Panel/KLBraveTrialsWindow/KLBraveTrialsWindowPanel")
    end
    self.goNextLevel = false
    self.isDead = false
end

function this:RES_GET_ACTIVITY_COUNT(_, message)
    if message["1"] == self.braveType then
        GUI:setVisible(self.view.panel_start, false)
        GUI:setVisible(self.view.text_countdown_tips, true)
        GUI:setVisible(self.view.countDown_in_copy, false)
        GUI:Text_setString(self.view.text_countdown_tips, "副本结束倒计时：")
        GUI:SetControl_time(self.view.countdown_out_copy, self.trialsTbl.save)
        GUI:setVisible(self.view.rewardItem_layout, false)
        GUI:setVisible(self.view.rewardItem_finish_layout, true)
        GUI:DataListUpdateData(self.view.rewardItem_finish_List)
        GUI:setVisible(self.view.panel_finish, true)
        ---领奖才会刷新次数，此时次数未减少，用1判断
        local goNext = false
        if message["2"] > 1 then
            goNext = self:CanGoToNextLevel()
        end
        
        if goNext then
            GUI:setVisible(self.view.btn_next, true)
            GUI:setPositionX(self.view.btn_reward, -50)
        else
            GUI:setVisible(self.view.btn_next, false)
            GUI:setPositionX(self.view.btn_reward, 0)
        end
    end
end

---判断开服天数等级是否可以前往下一层
function this:CanGoToNextLevel()
    local levelInfo = SL:GetConfig("cfg_rep", self.trialsTbl.id + 1)
    if levelInfo then
        local open_server_day = 0
        if SL:GetEnterRoleRes() and  SL:GetEnterRoleRes().openServerTime then
            local defTime = os.time() - SL:GetEnterRoleRes().openServerTime / 1000
            if defTime > 0 then
                open_server_day = math.ceil(defTime / 86400)
            end
        end
        if open_server_day >= levelInfo.startDay then
            local player_level = SL:GetMetaValue("LEVEL")
            if player_level >= levelInfo.level[1] and player_level <= levelInfo.level[2] then
                return true
            end
        end
    end
    return false
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

function this:Close()
    InfoManager.copActivityInfo.hideTask = false
end

return this

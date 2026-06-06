---@class KLGoldChallengeItem:UIKmlLuaPanelBase
---@field view KLGoldChallengeItemView
---@field data {k:number,v:number}
---@field monsterCfg cfg_monster_column
---@field taskCfg cfg_task_gold_column
---@field glodBossRewarditem KLGoldChallengeRewardItem[]
local KLGoldChallengeItem = class(UIKmlLuaPanelBase)
local this = KLGoldChallengeItem
---创建时调用一次
function this:Init()
    self.starList = {}
    self.itemList = {}
    self.itemRewards = {}
    GUI:DataListInitData(self.view.itemRoot, function()
        return self:GoldBossDataListItemCountFunc()
    end, function(realIndex)
        return self:GoldBossDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:GoldBossDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GoldBossDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.glodBossRewarditem = {}
end

function this:InitData(index, data)
    self.index = index
    self.data = data
end

---创建或者刷新界面数据时调用
function this:Refresh()

end
function this:RefreshUI()
    if self.timer then
        ---Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    GUI:SetImageAlpha(self.view.btnEffect, 1, 1, 1, 1)
    if self.data then
        self.taskCfg = SL:GetConfig("cfg_task_gold", tonumber(self.data.k))
        if self.data.v == 1 then
            self.itemRewards = self.taskCfg.rewardItem1
        elseif self.data.v == 2 then
            self.itemRewards = self.taskCfg.rewardItem2
        elseif self.data.v == 3 then
            self.itemRewards = self.taskCfg.rewardItem3
        end
        self.monsterCfg = SL:GetConfig("cfg_monster", self.taskCfg.monsterId)
        GUI:Text_setString(self.view.textName, self.monsterCfg.name .. string.format("<size=16> %s级</size>", self.monsterCfg.level))
        GUI:Text_setString(self.view.textMap, "所在地图：" .. self.taskCfg.mapName)
        local str = ""
        str = string.format("<color=%s>%s/%s</color>", EColor[EGradColor.red], 0, self.taskCfg.taskGoalNum[self.data.v])
        GUI:Text_setString(self.view.textTask, string.format("任务数量：%s", str))
        GUI:setPositionZ(self.view.textRoot, -300)
        GUI:setPositionZ(self.view.starGrid, -300)
        GUI:Button_setGrey(self.view.btnGetTask, false)
        if InfoManager.goldChallengeTaskInfo.taskInfo.nowtask then
            ---当前任务
            if InfoManager.goldChallengeTaskInfo.taskInfo.nowtask.taskid == self.data.k then
                ---@type GoldChallengeTaskEnum
                local status = InfoManager.goldChallengeTaskInfo.taskInfo.nowtask.status
                if status == GoldChallengeTaskEnum.Accept then
                    GUI:setVisible(self.view.getTaskBtnRoot, true)
                    GUI:setVisible(self.view.btnSubmit, false)
                    local str = ""
                    if InfoManager.goldChallengeTaskInfo.taskInfo.nowtask.progress >= self.taskCfg.taskGoalNum[self.data.v] then
                        str = string.format("<color=%s>%s/%s</color>", EColor[EGradColor.green], InfoManager.goldChallengeTaskInfo.taskInfo.nowtask.progress, self.taskCfg.taskGoalNum[self.data.v])
                    else
                        str = string.format("<color=%s>%s/%s</color>", EColor[EGradColor.red], InfoManager.goldChallengeTaskInfo.taskInfo.nowtask.progress, self.taskCfg.taskGoalNum[self.data.v])
                    end
                    GUI:Text_setString(self.view.textTask, string.format("任务数量：%s", str))
                elseif status == GoldChallengeTaskEnum.Finish then
                    GUI:setVisible(self.view.getTaskBtnRoot, false)
                    GUI:setVisible(self.view.btnSubmit, true)
                    local str = string.format("<color=%s>%s/%s</color>", EColor[EGradColor.green], self.taskCfg.taskGoalNum[self.data.v], self.taskCfg.taskGoalNum[self.data.v])
                    GUI:Text_setString(self.view.textTask, string.format("任务数量：%s", str))
                    ---开启一个计时器用于闪烁
                    if not self.timer then
                        self.timer = SL:StartLoopForever(0.5, self.RefreshBtn, self) ---Timer.StartLoopForever(0.5, self.RefreshBtn, self)
                    end
                    self.nowAlpha = 1
                elseif status == GoldChallengeTaskEnum.submit then

                end
                GUI:setVisible(self.view.btnGetTask, false)
            else --不是当前任务要置灰
                GUI:setVisible(self.view.btnSubmit, false)
                GUI:setVisible(self.view.getTaskBtnRoot, false)
                GUI:setVisible(self.view.btnGetTask, true)
                GUI:Button_setGrey(self.view.btnGetTask, true)
            end
        else
            GUI:setVisible(self.view.btnSubmit, false)
            GUI:setVisible(self.view.getTaskBtnRoot, false)
            GUI:setVisible(self.view.btnGetTask, true)
        end
        GUI:setVisible(self.view.frame_2, false)
        GUI:setVisible(self.view.frame_3, false)
        if self.data.v == 2 then
            GUI:setVisible(self.view.frame_2, true)
        elseif self.data.v == 3 then
            GUI:setVisible(self.view.frame_3, true)
        end

        self:InitModel()
        --self:InitRewards()
        GUI:DataListUpdateData(self.view.itemRoot)
        self:InitStar()
    end
end

function this:InitModel()
    --SL:CrateMonsterModel(self.view.model.rectTransform,10001,{1,1,1})
    local appr = self.monsterCfg.appr
    local path = SL:GetConfigMultiKeys('cfg_model_monster', appr, 'id').path
    local pos = nil
    if not table.isNullOrEmpty(self.monsterCfg.uipos)  then
        pos = string.format("%d,%d,%d",self.monsterCfg.uipos[1],self.monsterCfg.uipos[2],self.monsterCfg.uipos[3])
    end
    
    if pos then
        GUI:setVisible(self.view.model1,false)
        GUI:setVisible(self.view.model2,true)
        GUI:Model_setSrc(self.view.model2,path,nil,nil,pos)
    else
        GUI:setVisible(self.view.model1,true)
        GUI:setVisible(self.view.model2,false)
        GUI:Model_setSrc(self.view.model1, path)
    end
end

function this:GoldBossDataListItemCountFunc()
    return #self.itemRewards
end

function this:GoldBossDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLGoldChallengeReward/KLGoldChallengeRewardItem", self.view.itemRoot, self, {}, true)
    
    self.glodBossRewarditem[item.view.root] = item
    return item.view.root
end

function this:GoldBossDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:GoldBossDataListItemUpdateFunc(realIndex, kmlcontrol)
    self.glodBossRewarditem[kmlcontrol]:RefreshItem(self.itemRewards[realIndex + 1])
end

function this:InitRewards(realIndex)
    local itemRewards = {}
    if self.data.v == 1 then
        itemRewards = self.taskCfg.rewardItem1
    elseif self.data.v == 2 then
        itemRewards = self.taskCfg.rewardItem2
    elseif self.data.v == 3 then
        itemRewards = self.taskCfg.rewardItem3
    end
    if #self.itemList >= #itemRewards then
        for i = 1, #self.itemList do
            if i <= #itemRewards then
                GUI:setVisible(self.itemList[i], true)
            else
                GUI:setVisible(self.itemList[i], false)
            end
        end
    else
        for i = #self.itemList + 1, #itemRewards do
            local itemId = itemRewards[i][1]
            local item = GUI:Item_Create(self.view.itemRoot, {
                width = "50",
                height = "50",
                itemid = itemId,
                mfixsize = "80,80",
                tips = "1",
                itemcustomcount = itemRewards[i][2]
            })
            GUI:AddOnClickEvent(item, self, function()
                SL:OpenTips(nil, itemId)
            end)
            table.insert(self.itemList, item)
        end
        for i = 1, #self.itemList do
            if i <= #itemRewards then
                GUI:setVisible(self.itemList[i], true)
            else
                GUI:setVisible(self.itemList[i], false)
            end
        end
    end
end

function this:InitStar()
    if self.starList and #self.starList > 0 then
        for i = 1, 3 do
            if i <= self.data.v then
                GUI:setVisible(self.starList[i], true)
            else
                GUI:setVisible(self.starList[i], false)
            end
        end
    else
        self.starList = {}
        for i = 1, 3 do
            local star = GUI:Image_Create(self.view.starGrid, {
                id = "star" .. i,
                atlas = "Atlas/UIGoldChallenge.spriteatlas",
                src = "star",
                width = "35",
                height = "35",
            })
            table.insert(self.starList, star)
        end
        for i = 1, 3 do
            if i <= self.data.v then
                GUI:setVisible(self.starList[i], true)
            else
                GUI:setVisible(self.starList[i], false)
            end
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnGo, self, self.OnClickGoTask)
    GUI:AddOnClickEvent(self.view.btnAbandon, self, self.OnClickAbandonTask)
    GUI:AddOnClickEvent(self.view.btnGetTask, self, self.OnClickGetTask)
    GUI:AddOnClickEvent(self.view.btnSubmit, self, self.OnClickSubmitTask)
end

---前往任务
function this:OnClickGoTask()
    --SL:ShortcutDO(self.taskCfg.instruction[1], nil, nil, function()
    --    --AutoFightManager.StartAutoFight()
    --end)
    local type = SL:GetConfigMultiKeys('cfg_BOSS_challenge', self.monsterCfg.id, 'monsterid').monsterType
    GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel",nil,
            nil,{monsterId =  self.monsterCfg.id,monsterType =  type })
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLGoldChallenge/KLGoldChallengePanel")

end

---放弃任务
function this:OnClickAbandonTask()
--[[    local message = {
        title = "提示",
        showTips = "当前任务进度将会被清空，是否确认放弃",
        callback = function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.GIVE_UP_GOLD_TASK, self.data.k)
        end
    }]]
    SL:CommonTipsMessage({ title = "提示", stringTblID=208,
        callback = function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.GIVE_UP_GOLD_TASK, self.data.k)
        end
    })
end

---领取任务
function this:OnClickGetTask()
    SL:SendLuaNetMsg(LuaMessageIdToSever.ACCEPT_GOLD_TASK, self.data.k)
end
---提交任务
function this:OnClickSubmitTask()
    SL:SendLuaNetMsg(LuaMessageIdToSever.SUBMIT_GOLD_TASK, self.data.k)
end

function this:RefreshBtn()
    if self.nowAlpha == 1 then
        self.nowAlpha = 0.8
    else
        self.nowAlpha = 1
    end
    GUI:SetImageAlpha(self.view.btnEffect, 1, 1, 1, self.nowAlpha)
end

function this:Close()
    self.starList = {}
    if self.timer then
        ---Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

return this

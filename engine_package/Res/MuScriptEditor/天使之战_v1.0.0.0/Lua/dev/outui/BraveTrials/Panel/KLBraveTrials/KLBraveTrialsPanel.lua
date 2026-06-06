---@class KLBraveTrialsPanel:UIKmlLuaPanelBase
---@field view KLBraveTrialsPanelView
local KLBraveTrialsPanel = class(UIKmlLuaPanelBase)
local this =KLBraveTrialsPanel
---创建时调用一次
function this:Init()
    self.braveType = 12001
    ---@type cfg_global_column
    local global = SL:GetConfig("cfg_repGlobal", 12001001)
    if global then
        local trialsInfo = global.value
        local trialsTbl = string.split(trialsInfo, '#')
        self.firstLevel = tonumber(trialsTbl[1])
        self.finalLevel = tonumber(trialsTbl[2])
        self.totalLevel = self.finalLevel - self.firstLevel + 1
    end

    GUI:OSAScrollView_Initialized(self.view.osascroll_bravetrials,self.ItemGetFun,self.ItemUpdateFun,self)
    GUI:OSAScrollView_SetItemSizeGetFun(self.view.osascroll_bravetrials,self.ItemSizeGetFun,self)

    GUI:DataListInitData( self.view.list_pass_reward,function()
        return self:ListItemCountFunc2()
    end,function(realIndex)
        return self:ListItemGetFunc2(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ListItemInitFunc2(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ListItemUpdateFunc2(realIndex, kmlcontrol)
    end)
end

function this:ItemGetFun()
    local item = GUI:UIPanel_Open("dev/outui/BraveTrials/Item/KLBraveTrials/KLBraveTrialsItem", self.view.list_brave_trials, self, { firstLevel = self.firstLevel, finalLevel = self.finalLevel }, true)
    return item
end

---@param item KLBraveTrialsItem
function this:ItemUpdateFun(item, index)
    ---@type cfg_rep_column
    local data = self.braveTrialsShowTbl[index + 1]
    if data.id == self.player_challenge_select then
        item:RefreshUI(data, true)
        self.select_item = item
    else
        item:RefreshUI(data)
    end
end

function this:ItemSizeGetFun(index)
    if index == 0 then
        return 443
    elseif index == self.finalLevel - self.firstLevel then
        return 280
    else
        return 125
    end
end

function this:ListItemCountFunc2()
    return #self.passReward
end

function this:ListItemGetFunc2(realIndex)

end

function this:ListItemInitFunc2(realIndex, kmlcontrol)

end

function this:ListItemUpdateFunc2(realIndex, kmlcontrol)
    local reward = self.passReward[realIndex + 1]
    local pass_reward = GUI:GetChildControl(self.view.list_pass_reward,realIndex,'pass_reward')
    local img_pass_reward_click = GUI:GetChildControl(self.view.list_pass_reward,realIndex,'img_pass_reward_click')
    GUI:Item_setItemId(pass_reward, reward[1])
    GUI:Item_UpdataData(pass_reward, { itemcount = reward[2] })
    GUI:AddOnClickEvent(img_pass_reward_click, self, self.ShowItemTips, { id = reward[1] })
end

function this:ShowItemTips(_, eventData)
    SL:OpenTips(nil, eventData.id)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_start_challenge, self, self.StartChallenge)
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.img_reward_click, self, self.ReceiveFinalReward)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.BRAVE_TEST_PANEL_INFO, self.BRAVE_TEST_PANEL_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_ACTIVITY_COUNT, self.RES_GET_ACTIVITY_COUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.BRAVE_TEST_STAGE_REWARD, self.BRAVE_TEST_STAGE_REWARD, self)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:HideMainPanel()
    ---@type cfg_rep_column[]
    local tbl = SL:GetConfigTable("cfg_rep")
    ---@type cfg_rep_column[]
    self.braveTrialsTbl = {}
    self.braveTrialsShowTbl = {}
    for i, v in ipairs(tbl) do
        if v.type == self.braveType then
            self.braveTrialsTbl[#self.braveTrialsTbl + 1] = v
        end
    end
    table.sort(self.braveTrialsTbl, function(a, b)
        return a.id > b.id
    end)

    self.select_control = nil
    SL:SendLuaNetMsg(LuaMessageIdToSever.BRAVE_TEST_PANEL_INFO)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_ACTIVITY_COUNT, self.braveType)
end

function this:RefreshLevelMainInfo(levelId, item)
    ---点击正好点到复用的item时，不隐藏点击背景
    if self.select_item and self.select_item ~= item then
        self.select_item:HideChoseBG()
    end
    self.select_item = item
    ---@type cfg_rep_column
    local levelInfo = SL:GetConfig("cfg_rep", levelId)
    self.player_challenge_select = levelInfo.id
    ---@type cfg_monster_column
    local monster = SL:GetConfig("cfg_monster", levelInfo.monsterUI)
    ---@type cfg_model_monster_column
    local monster_model = SL:GetConfig("cfg_model_monster", monster.appr)
    GUI:Model_setSrc(self.view.model_show_monster, monster_model.path)
    
    self.passReward = levelInfo.reward
    GUI:DataListUpdateData(self.view.list_pass_reward)    
    GUI:Text_setString(self.view.text_current_level, levelInfo.name[1])
    
    GUI:SetActive(self.view.btn_start_challenge, true)
    local open_server_day = 0
    if SL:GetEnterRoleRes() and  SL:GetEnterRoleRes().openServerTime then
        local defTime = os.time() - SL:GetEnterRoleRes().openServerTime / 1000
        if defTime > 0 then
            open_server_day = math.ceil(defTime / 86400)
        end
    end

    local player_level = SL:GetMetaValue("LEVEL")
    if open_server_day >= levelInfo.startDay then
        if player_level >= levelInfo.level[1] and player_level <= levelInfo.level[2] then
            GUI:Text_setString(self.view.text_challenge_tips, " ")
            GUI:Button_setGrey(self.view.btn_start_challenge, false)
            GUI:Button_setBright(self.view.btn_start_challenge, true)
        else
            GUI:Text_setString(self.view.text_challenge_tips, "开启等级：" .. levelInfo.level[1])
            GUI:Button_setGrey(self.view.btn_start_challenge, true)
            GUI:Button_setBright(self.view.btn_start_challenge, false)
        end
    else
        GUI:Text_setString(self.view.text_challenge_tips, "开服第" .. levelInfo.startDay .. "天开启")
        GUI:Button_setGrey(self.view.btn_start_challenge, true)
        GUI:Button_setBright(self.view.btn_start_challenge, false)
    end
    
    if self.player_challenge_level ~= levelInfo.id or self.passLevel then
        GUI:SetActive(self.view.btn_start_challenge, false)
    end
    
    self:RefreshChallengeTime()
end

function this:RefreshChallengeTime()
    if self.player_challenge_time then
        if self.player_challenge_time > 0 then
            GUI:Text_setString(self.view.text_pass_times, "剩余通关次数：<color=#00ff00>" .. self.player_challenge_time .. "</color>")
        else
            GUI:Text_setString(self.view.text_pass_times, "剩余通关次数：<color=#FF2323>" .. self.player_challenge_time .. "</color>")
            GUI:Button_setGrey(self.view.btn_start_challenge, true)
            GUI:Button_setBright(self.view.btn_start_challenge, false)
        end
    end
end

function this:RefreshFinalReward()
    ---@type cfg_global_column
    local global = SL:GetConfig("cfg_repGlobal", 12001002)
    if global then
        local src = string.split(global.value, '#')
        self.finalReward = tonumber(src[2])
        self.stageLevel = src[1]
        GUI:Item_setItemId(self.view.item_stage_reward, self.finalReward)
        ---@type cfg_global_column
        local img = SL:GetConfig("cfg_repGlobal", 12001003)
        if img then
            GUI:Image_loadTexture(self.view.img_stage_reward, string.split(img.value, '#')[2], "Atlas/KLBraveTrialsUI.spriteatlas")
        end
    end
end

function this:StartChallenge()
    local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local mapTab = SL:GetConfig("cfg_map_info",map_id)
    if mapTab.nopositionmove and mapTab.nopositionmove == 1 then
        SL:MessageTip({ id = 116 })--"副本中无法传送", 
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, self.player_challenge_level)
    self:CloseSelf()
end

function this:BRAVE_TEST_PANEL_INFO(_, message)
    local info
    if SL:HasConfigTwoKeys("cfg_rep", self.braveType, message.level, "type", "repLevel") then
        ---@type cfg_rep_column
        info = SL:GetConfigTwoKeys("cfg_rep", self.braveType, message.level, "type", "repLevel")
    end
    if not info then
        info = SL:GetConfig("cfg_rep", self.finalLevel)
        self.passLevel = true
    else
        self.passLevel = false
    end
    self.getStageReward = message.stageReward
    if self.getStageReward then
        GUI:setVisible(self.view.text_receive_reward, true)
        GUI:Image_setAlpha(self.view.img_reward_click, 1)
    else
        GUI:setVisible(self.view.text_receive_reward, false)
        GUI:Image_setAlpha(self.view.img_reward_click, 0)
    end
    self.player_challenge_level = info.id
    self:RefreshLevelMainInfo(self.player_challenge_level)
    self:RefreshFinalReward()
    self.braveTrialsShowTbl = {}
    for i, v in ipairs(self.braveTrialsTbl) do
        if v.id >= self.player_challenge_level then
            self.braveTrialsShowTbl[#self.braveTrialsShowTbl + 1] = v
        end
    end
    GUI:OSAScrollView_RefreshList(self.view.osascroll_bravetrials, #self.braveTrialsShowTbl)
    local index = self.totalLevel - message.level
    if index < 0 then
        index = 0
    end
    GUI:OSAScrollView_ScrollTo(self.view.osascroll_bravetrials, #self.braveTrialsShowTbl - 1)
end

function this:RES_GET_ACTIVITY_COUNT(_, message)
    if message["1"] == self.braveType then
        self.player_challenge_time = message["2"]
        self:RefreshChallengeTime()
    end
end

function this:ReceiveFinalReward()
    if self.passLevel and not self.getStageReward then
        SL:SendLuaNetMsg(LuaMessageIdToSever.BRAVE_TEST_STAGE_REWARD)
    elseif not self.passLevel then
        SL:OpenTips(nil, self.finalReward)
    end
end

function this:BRAVE_TEST_STAGE_REWARD(_,message)
    local reward = {}
    for i, v in pairs(message) do
        reward[tonumber(i)] = tonumber(v)
    end
    SL:OpenRewardTips(reward,0)
    GUI:setVisible(self.view.text_receive_reward, true)
    GUI:Image_setAlpha(self.view.img_reward_click, 1)
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/BraveTrials/Panel/KLBraveTrials/KLBraveTrialsPanel")
end

function this:Close()
    self.trialsItemList = {}
    SL.ShowMainPanel()
end

return this

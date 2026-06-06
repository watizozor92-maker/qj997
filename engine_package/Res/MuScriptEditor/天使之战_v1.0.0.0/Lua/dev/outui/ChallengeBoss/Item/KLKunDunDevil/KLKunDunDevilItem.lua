---@class KLKunDunDevilItem:UIKmlLuaPanelBase
---@field view KLKunDunDevilItemView
local KLKunDunDevilItem = class(UIKmlLuaPanelBase)
local this = KLKunDunDevilItem

---创建时调用一次
function this:Init()
    GUI:SetZIndex(self.view.recommend_panel, 210)
    GUI:DataListInitData(self.view.outdoor_boss_level_data_list, function()
        return self:OutdoorBossBtnDataListItemCountFunc()
    end, function(realIndex)
        return self:OutdoorBossBtnDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:OutdoorBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:OutdoorBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.outdoor_boss_level_btn_all_item = {}

    GUI:DataListInitData(self.view.outdoor_boss_line_data_list, function()
        return self:OutdoorBossLineDataListItemCountFunc()
    end, function(realIndex)
        return self:OutdoorBossLineDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:OutdoorBossLineDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:OutdoorBossLineDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.outdoor_boss_line_data_list_all_item = {}

    GUI:DataListInitData(self.view.outdoor_boss_reward_data_list, function()
        return self:OutdoorRewardDataListItemCountFunc()
    end, function(realIndex)
        return self:OutdoorRewardDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:OutdoorRewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:OutdoorRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.outdoor_reward_level_all_item = {}

    self.refreshTimes = {}
    GUI:DataListInitData(self.view.DataList_RefreshTime, function()
        return #self.refreshTimes
    end, nil, nil, function(realIndex, kmlcontrol)
        local text_time = GUI:GetChildControl(self.view.DataList_RefreshTime, realIndex, "Text_Time")
        local text_state = GUI:GetChildControl(self.view.DataList_RefreshTime, realIndex, "Text_State")
        local refreshTime = self.refreshTimes[realIndex + 1]
        local serverTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local time = tonumber(serverTime) * 0.001 + 1
        if time < refreshTime[1] then -- 还未开始
            GUI:Text_setText(text_state, "未开始")
            GUI:Text_setTextColor(text_state, "#FF8A00")
        elseif time >= refreshTime[1] and time <= refreshTime[2] then -- 进行中
            GUI:Text_setText(text_state, "进行中")
            GUI:Text_setTextColor(text_state, "#00ff00")
        else
            GUI:Text_setText(text_state, "已结束")
            GUI:Text_setTextColor(text_state, "#FF2323")
        end
        GUI:Text_setText(text_time, refreshTime[3])
    end)

    --[[if SL:HasConfig("cfg_string", 47001) then
        GUI:Text_setText(self.view.Text_Tips, SL:GetConfig("cfg_string", 47001).text)
    end]]
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_ACTIVITYPREVIEW_CHANGE, self.LUA_EVENT_ACTIVITYPREVIEW_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_COUNT_CHANGE, self.LUA_EVENT_MONSTER_COUNT_CHANGE, self)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:LUA_EVENT_ACTIVITYPREVIEW_CHANGE()
end

function this:Hide()
end

function this:Close()
end

--野外boss
function this:SelectBossType(_monsterId)
    self.monsterId = _monsterId
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    -- if self.monsterId then
    --     playerLevel = SL:GetConfig("cfg_BOSS_challenge",self.monsterId,"monsterid").level
    -- end
    if not self.allOutdoorLevel then
        self.allOutdoorLevel = {}
        --local allBoss = SL:GetConfigMultiKeys('cfg_BOSS_challenge', 1, 'monsterType')
        local tempCfgs = SL:FindConfigs("cfg_BOSS_challenge", "monsterType", EBossChallengeType.KunDunDevil)
        self.select_outdoor_level = nil
        self.select_outdoor_index = 1
        local index = 0
        ---@param data cfg_monster_attack_column
        for i, data in ipairs(tempCfgs) do
            if SL:MeData_GetLevel() >= data.showLevel then
                table.insert(self.allOutdoorLevel, data)
                data.index = i
                local level = data.level
                if self.monsterId then
                    if data.monsterid == self.monsterId then
                        self.select_outdoor_level = level
                        self.select_outdoor_index = i
                        index = i
                    end
                else
                    if not self.select_outdoor_level then
                        self.select_outdoor_level = level
                        self.select_outdoor_index = i
                        index = i
                    else
                        if level <= playerLevel and level > self.select_outdoor_level then
                            self.select_outdoor_level = level
                            self.select_outdoor_index = i
                            index = i
                        end
                    end
                end
            end
        end
        local percentage = index / #self.allOutdoorLevel
        percentage = percentage - percentage % 0.00001
        GUI:DataListUpdateData(self.view.outdoor_boss_level_data_list, false, nil, index - 1)
        GUI:SetScrollView_scrollpos(self.view.outdoor_boss_select, index - 1)
    end

    self:RefreshOutdoorBoss()
end

function this:RefreshOutdoorBoss()
    ---@type cfg_BOSS_challenge_column
    self.current_outdoor_data = nil
    local current_data
    for i, data in ipairs(self.allOutdoorLevel) do
        local level = data.level
        if data.index == self.select_outdoor_index then
            self.current_outdoor_data = data
            break
        end
    end

    self.OutdoorAllRwward = {}
    local monsterid = nil
    if self.current_outdoor_data then
        monsterid = self.current_outdoor_data.monsterid

        local tab = SL:GetConfigMultiKeys('cfg_monster', monsterid, 'id')
        if tab.RecommendedDef  and tab.RecommendedAtk and tab.RecommendedDef > 0 and tab.RecommendedAtk  > 0 then
            local definse = SL:GetHookRealDefense(monsterid)
            local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
            local maxAttack = 0
            if baseCareer == 1 or baseCareer == 3 or baseCareer == 5 then
                maxAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxDC)
            else
                maxAttack = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxMC)
            end
            --local num = (minAttack + maxAttack)/2
            ---策划需求改成最大攻击力
            local num = maxAttack
            num = Mathf.Floor(num)
            local defenseStr = ""
            local atkStr = ""
            if definse >= tab.RecommendedDef then
                defenseStr = "<color=#00ff00>" .. tab.RecommendedDef .. "</color>"
            else
                defenseStr = "<color=#ff2323>" .. tab.RecommendedDef .. "</color>"
            end
            if maxAttack >= tab.RecommendedAtk  then
                atkStr = "<color=#00ff00>" .. tab.RecommendedAtk  .. "</color>"
            else
                atkStr = "<color=#ff2323>" .. tab.RecommendedAtk  .. "</color>"
            end
            GUI:setVisible(self.view.recommend_panel, true)
            GUI:Text_setString(self.view.recommend_atk, "推荐攻:" .. atkStr)
            GUI:Text_setString(self.view.recommend_def, "推荐防:" .. defenseStr)
        else
            GUI:setVisible(self.view.recommend_panel, false)
        end


        local name = tab.name
        local icon = tab.icon
        local appr = tab.appr
        local path = SL:GetConfigMultiKeys('cfg_model_monster', appr, 'id').path
        GUI:Text_setString(self.view.outdoor_boss_name, name)
        local mscale = ""
        if self.current_outdoor_data.size then
            local scale = math.ceil(self.current_outdoor_data.size / 100)
            mscale = scale .. "," .. scale .. "," .. scale
        end
        GUI:Model_setSrc(self.view.outdoor_boss_path, path, mscale)
        if self.current_outdoor_data.offset and #self.current_outdoor_data.offset >= 2 then
            GUI:setPosition(self.view.outdoor_boss_path, self.current_outdoor_data.offset[1],
                self.current_outdoor_data.offset[2])
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_COUNT_BY_ID,
            { { id = self.current_outdoor_data.id, state = 1 } })
        --[[GUI:DataListUpdateData(self.view.outdoor_boss_line_data_list,true,function()
            SL:ScheduleOnce(Time.deltaTime, function()
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_COUNT_BY_ID, { { id = self.current_outdoor_data.id, state = 1 } })
            end)
        end)]]
        if self.current_outdoor_data then
            local Rwward = self.current_outdoor_data.monsterDrop
            local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
            for i, one_reward in ipairs(Rwward) do
                if one_reward[1] == baseCareer then
                    table.insert(self.OutdoorAllRwward, one_reward[2])
                end
            end
        end

        -- 3 是昆顿魔王
        local cfgs = SL:FindConfigs("cfg_monster_attack", "type", 3)
        if cfgs and not table.isNullOrEmpty(cfgs) then
            self.activityId = cfgs[1].ruleId
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ACTIVITY_INFO, self.activityId)
            --- 刷新今日场次
            ---@type cfg_activity_rule_column
            local activityCfg = SL:GetConfig("cfg_activity_rule", self.activityId)
            self.refreshTimes = ToolFunc.ParseCronExpressionWithTimestamp(activityCfg.time, activityCfg.duration)
            GUI:DataListUpdateData(self.view.DataList_RefreshTime, false)
            GUI:SetScrollView_scrollpos(self.view.scrollview7, self:GetRefreshTimeIndex())
        end

        GUI:DataListUpdateData(self.view.outdoor_boss_reward_data_list, false, nil, 0)
    else
        GUI:setVisible(self.view.recommend_panel, false)
    end
    InfoManager.uiHuntingDemonsInfo:SetIntegralInControl(self.view.outdoor_boss_Integral_BG,
        self.view.outdoor_boss_Integral_Text, monsterid)
    self.monsterId = nil
end

---获取今日场次索引
function this:GetRefreshTimeIndex()
    local serverTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    local time = tonumber(serverTime) * 0.001 + 1
    local index = 1
    for i, refreshTime in pairs(self.refreshTimes) do
        if time < refreshTime[1] then
            index = i
        elseif time >= refreshTime[1] and time <= refreshTime[2] then
            index = i
            break
        end
    end
    return index
end

function this:OutdoorBossBtnDataListItemCountFunc()
    return #self.allOutdoorLevel
end

function this:OutdoorBossBtnDataListItemGetFunc(realIndex)
    local data = self.allOutdoorLevel[realIndex + 1]
    local item = GUI:UIPanel_Open(
    "dev/outui/ChallengeBoss/Item/KLUIChallengeBossSelectBtnItem/KLUIChallengeBossSelectBtnItem",
        self.view.outdoor_boss_level_data_list, self, {}, true)

    self.outdoor_boss_level_btn_all_item[item.view.root] = item
    return item.view.root
end

function this:OutdoorBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:OutdoorBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.allOutdoorLevel[realIndex + 1]
    self.outdoor_boss_level_btn_all_item[kmlcontrol]:RefreshItem(data, self.select_outdoor_index, self, 2)
    if data.index == self.select_outdoor_index then
        self.OutdoorBossLevelBtn = self.outdoor_boss_level_btn_all_item[kmlcontrol]
    end
end

function this:HideSelectLevelOutdoor()
    if self.OutdoorBossLevelBtn then
        self.OutdoorBossLevelBtn:HideItem()
    end
end

function this:SelectLevelOutdoor(level, Btn)
    self.OutdoorBossLevelBtn = Btn
    self.select_outdoor_index = level
    self:RefreshOutdoorBoss()
end

function this:OutdoorBossLineDataListItemCountFunc()
    return #self.current_outdoor_data.mapId
end

function this:OutdoorBossLineDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open(
    "dev/outui/ChallengeBoss/Item/KLUINewChallengeBossLineItem/KLUINewChallengeBossLineItem",
        self.view.outdoor_boss_line_data_list, self, {}, true)

    self.outdoor_boss_line_data_list_all_item[item.view.root] = item
    return item.view.root
end

function this:OutdoorBossLineDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:OutdoorBossLineDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.current_outdoor_data.mapId[realIndex + 1]
    local move = self.current_outdoor_data.mapMoveId[realIndex + 1]
    local monsterid = self.current_outdoor_data.monsterid
    local cfg_BOSS_challenge = SL:GetConfigMultiKeys("cfg_BOSS_challenge", self.current_outdoor_data.id, "id")
    self.outdoor_boss_line_data_list_all_item[kmlcontrol]:RefreshItem(monsterid, data, move, self, 210,
        cfg_BOSS_challenge, realIndex + 1, self.activityId)
end

function this:OutdoorRewardDataListItemCountFunc()
    return #self.OutdoorAllRwward
end

function this:OutdoorRewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem",
        self.view.outdoor_boss_reward_data_list, self, {}, true)

    self.outdoor_reward_level_all_item[item.view.root] = item
    return item.view.root
end

function this:OutdoorRewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:OutdoorRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.OutdoorAllRwward[realIndex + 1]
    self.outdoor_reward_level_all_item[kmlcontrol]:RefreshItem({ cfgId = data }, self.select_gold_level, self)
end

---活动改变
function this:LUA_EVENT_ACTIVITYPREVIEW_CHANGE()
    if self.activityId == nil then
        return
    end
    local info = InfoManager.activityPreviewInfo:GetActivityInfo(self.activityId)
    if info == nil then
        return
    end

    GUI:DataListUpdateData(self.view.DataList_RefreshTime)
    GUI:DataListUpdateData(self.view.outdoor_boss_line_data_list, false, nil, 0)
end

function this:LUA_EVENT_MONSTER_COUNT_CHANGE()
    GUI:DataListUpdateData(self.view.outdoor_boss_line_data_list, false, nil, 0)
    self:CheckMonsterIsKill()
end

function this:CheckMonsterIsKill()
    GUI:SetActive(self.view.isKill_Img, false)
    if self.activityId == nil then
        return
    end
    local info = InfoManager.activityPreviewInfo:GetActivityInfo(self.activityId)
    if info == nil or not info.open then
        return
    end
    local tempData = nil
    if self.current_outdoor_data then
        local monsterid = self.current_outdoor_data.monsterid
        local data = self.current_outdoor_data.mapId[1]
        local cfg_BOSS_challenge = SL:GetConfigMultiKeys("cfg_BOSS_challenge", self.current_outdoor_data.id, "id")
        for k, v in pairs(InfoManager.challengeBossInfo.count_data) do
            for k2, v2 in pairs(v) do
                if v2.monsterCfgId == monsterid and v2.mapCfgId == data[1] and v2.monsterCount > 0 then
                    tempData = v2
                    break
                end
            end
            if tempData then
                break
            end
        end
        local monsterCount = tempData and tempData.monsterCount or 0
        GUI:SetActive(self.view.isKill_Img, monsterCount <= 0)
    end
end

return this

---@class KLUIOutdoorBossItem:UIKmlLuaPanelBase
---@field view KLUIOutdoorBossItemView
local KLUIOutdoorBossItem = class(UIKmlLuaPanelBase)
local this = KLUIOutdoorBossItem
---创建时调用一次
function this:Init()
    GUI:SetZIndex(self.view.recommend_panel,210)
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
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_COUNT_CHANGE, self.LUA_EVENT_MONSTER_COUNT_CHANGE, self)
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
        local tempCfgs = SL:FindConfigs("cfg_BOSS_challenge", "monsterType", 2)
        self.select_outdoor_level = nil
        self.select_outdoor_index = 1
        local index = 0
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
        GUI:DataListUpdateData(self.view.outdoor_boss_level_data_list,false,nil,index-1)
        GUI:SetScrollView_scrollpos(self.view.outdoor_boss_select, index-1)
    end

    self:RefreshOutdoorBoss()
end

function this:RefreshOutdoorBoss()
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
        if tab.RecommendedDef  and tab.RecommendedAtk  and tab.RecommendedDef  > 0 and tab.RecommendedAtk  > 0  then
            
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
            if definse >= tab.RecommendedDef  then
                defenseStr = "<color=#00ff00>"..tab.RecommendedDef .."</color>"
            else
                defenseStr = "<color=#ff2323>"..tab.RecommendedDef .."</color>"
            end
            if maxAttack >= tab.RecommendedAtk  then
                atkStr = "<color=#00ff00>"..tab.RecommendedAtk .."</color>"
            else
                atkStr = "<color=#ff2323>"..tab.RecommendedAtk .."</color>"
            end
            GUI:setVisible(self.view.recommend_panel, true)
            GUI:Text_setString(self.view.recommend_atk,"推荐攻:"..atkStr)
            GUI:Text_setString(self.view.recommend_def,"推荐防:"..defenseStr)
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
            GUI:setPosition(self.view.outdoor_boss_path, self.current_outdoor_data.offset[1], self.current_outdoor_data.offset[2])
        end
        local reliveDelay = SL:GetConfig("cfg_monster_ai",monsterid).reliveDelay
        local hour_num = reliveDelay/3600000
        -- hour_num = string.format("%g", hour_num)
        -- hour_num = math.floor(hour_num * 100 + 0.5) / 100
        -- 判断是否为整数
        if math.floor(hour_num) == hour_num then
            hour_num = string.format("%.0f", hour_num)
        else
            -- 判断是否只有一位小数
            local multiplied = hour_num * 10
            if math.floor(multiplied) == multiplied then
                hour_num = string.format("%.1f", hour_num)
            else
                -- 两位或以上小数
                hour_num = string.format("%.2f", hour_num)
            end
        end
        local time_str = SL:GetConfig("cfg_string",64001).text
        hour_num = string.format(time_str,hour_num)
        GUI:Text_setString(self.view.die_time, hour_num)
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_COUNT_BY_ID, { { id = self.current_outdoor_data.id, state = 1 } })
        if self.current_outdoor_data then
            local Rwward = self.current_outdoor_data.monsterDrop
            local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
            for i, one_reward in ipairs(Rwward) do
                if one_reward[1] == baseCareer then
                    table.insert(self.OutdoorAllRwward, one_reward[2])
                end
            end
        end

        GUI:DataListUpdateData(self.view.outdoor_boss_reward_data_list,false,nil,6)
    else
        GUI:setVisible(self.view.recommend_panel, false)
    end
    InfoManager.uiHuntingDemonsInfo:SetIntegralInControl(self.view.outdoor_boss_Integral_BG,self.view.outdoor_boss_Integral_Text,monsterid)
    self.monsterId = nil
end


function this:OutdoorBossBtnDataListItemCountFunc()
    return #self.allOutdoorLevel
end

function this:OutdoorBossBtnDataListItemGetFunc(realIndex)
    local data = self.allOutdoorLevel[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossSelectBtnItem/KLUIChallengeBossSelectBtnItem", self.view.outdoor_boss_level_data_list, self, {}, true)
    
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
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossLineItem/KLUIChallengeBossLineItem", self.view.outdoor_boss_line_data_list, self, {}, true)
    
    self.outdoor_boss_line_data_list_all_item[item.view.root] = item
    return item.view.root
end

function this:OutdoorBossLineDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:OutdoorBossLineDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.current_outdoor_data.mapId[realIndex + 1]
    local move = self.current_outdoor_data.mapMoveId[realIndex + 1]
    local monsterid = self.current_outdoor_data.monsterid
    local cfg_BOSS_challenge = SL:GetConfigMultiKeys("cfg_BOSS_challenge",self.current_outdoor_data.id,"id")
    self.outdoor_boss_line_data_list_all_item[kmlcontrol]:RefreshItem(monsterid, data, move, self, 210,cfg_BOSS_challenge,realIndex + 1)

end

function this:OutdoorRewardDataListItemCountFunc()
    return #self.OutdoorAllRwward
end

function this:OutdoorRewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem", self.view.outdoor_boss_reward_data_list, self, {}, true)
    
    self.outdoor_reward_level_all_item[item.view.root] = item
    return item.view.root
end

function this:OutdoorRewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:OutdoorRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.OutdoorAllRwward[realIndex + 1]
    self.outdoor_reward_level_all_item[kmlcontrol]:RefreshItem({ cfgId = data }, self.select_gold_level, self)
end

function this:LUA_EVENT_MONSTER_COUNT_CHANGE()
    GUI:DataListUpdateData(self.view.outdoor_boss_line_data_list,false,nil,0)
end

return this

---@class KLUISanctuaryBossItem:UIKmlLuaPanelBase
---@field view KLUISanctuaryBossItemView
local KLUISanctuaryBossItem = class(UIKmlLuaPanelBase)
local this = KLUISanctuaryBossItem
---创建时调用一次
function this:Init()
    --圣域BOSS
    GUI:DataListInitData(self.view.sanctuary_boss_level_data_list, function()
        return self:SanctuaryBossBtnDataListItemCountFunc()
    end, function(realIndex)
        return self:SanctuaryBossBtnDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:SanctuaryBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SanctuaryBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.sanctuary_boss_level_btn_all_item = {}

    GUI:DataListInitData(self.view.sanctuary_boss_line_data_list, function()
        return self:SanctuaryBossLineDataListItemCountFunc()
    end, function(realIndex)
        return self:SanctuaryBossLineDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:SanctuaryBossLineDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SanctuaryBossLineDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    ---@type KLUIChallengeBossLineItem[]
    self.sanctuary_boss_line_data_list_all_item = {}

    GUI:DataListInitData(self.view.sanctuary_reward_data_list, function()
        return self:SanctuaryRewardDataListItemCountFunc()
    end, function(realIndex)
        return self:SanctuaryRewardDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:SanctuaryRewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SanctuaryRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.sanctuary_reward_level_all_item = {}

    GUI:DataListInitData(self.view.sanctuary_reward_box_data_list, function()
        return self:SanctuaryRewardBoxDataListItemCountFunc()
    end, function(realIndex)
        return self:SanctuaryRewardBoxDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:SanctuaryRewardBoxDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SanctuaryRewardBoxDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.sanctuary_reward_box_level_all_item = {}
    self.secretBossLineLoadEnd = nil
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    
end



function this:Close()
   
end




--圣域boss
function this:SelectBossType(_monsterId)
    self.monsterId = _monsterId
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if self.monsterId then
        playerLevel = SL:GetConfig("cfg_BOSS_challenge", self.monsterId, "monsterid").level
    end
    if not self.allSanctuaryLevel or table.count(self.allSanctuaryLevel) == 0 then
        self.allSanctuaryLevel = {}
        self.allSanctuaryLevel = SL:FindConfigs("cfg_BOSS_challenge", "monsterType", EBossChallengeType.Sanctuary)
        self.select_Sanctuary_level = nil
        local index = 0
        for i, data in ipairs(self.allSanctuaryLevel) do
            local level = data.level
            if not self.select_Sanctuary_level then
                self.select_Sanctuary_level = level
                index = i
            else
                if level <= playerLevel and level > self.select_Sanctuary_level then
                    self.select_Sanctuary_level = level
                    index = i
                end
            end
        end
        local percentage = index / #self.allSanctuaryLevel
        percentage = percentage - percentage % 0.00001
        GUI:DataListUpdateData(self.view.sanctuary_boss_level_data_list)
        GUI:SetScrollView_scrollpos(self.view.sanctuary_boss_level_select, index-1)
    end

    self:RefreshSanctuaryBoss()
end

function this:RefreshSanctuaryBoss()
    self.current_Sanctuary_data = nil
    local current_data
    for i, data in ipairs(self.allSanctuaryLevel) do
        local level = data.level
        if level == self.select_Sanctuary_level then
            self.current_Sanctuary_data = data
            break
        end
    end
    self.sanctuaryAllRwward = {}
    self.sanctuaryAllBoxRwward = {}
    self.sanctuaryAllLine = {}
    self.repId = 0
    local monsterid = nil
    if self.current_Sanctuary_data then
        monsterid = self.current_Sanctuary_data.monsterid

        local tab = SL:GetConfigMultiKeys('cfg_monster', monsterid, 'id')
        local name = tab.name
        local icon = tab.icon
        local appr = tab.appr
        local mapData = self.current_Sanctuary_data.mapId[1]
        local path = SL:GetConfigMultiKeys('cfg_model_monster', appr, 'id').path
        GUI:Text_setString(self.view.sanctuary_boss_name, name)
        local mscale = ""
        if self.current_Sanctuary_data.size then
            local scale = math.ceil(self.current_Sanctuary_data.size / 100)
            mscale = scale .. "," .. scale .. "," .. scale
        end
        GUI:Model_setSrc(self.view.sanctuary_boss_path, path, mscale)
        if self.current_Sanctuary_data.offset and #self.current_Sanctuary_data.offset >= 2 then
            GUI:setPosition(self.view.sanctuary_boss_path, self.current_Sanctuary_data.offset[1], self.current_Sanctuary_data.offset[2])
        end
        --SL:LogError(#self.current_Sanctuary_data.mapId)
        if self.current_Sanctuary_data then
            local Rwward = self.current_Sanctuary_data.monsterDrop
            local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
            for i, one_reward in ipairs(Rwward) do
                if one_reward[1] == baseCareer then
                    table.insert(self.sanctuaryAllRwward, one_reward[2])
                end
            end
            local box = self.current_Sanctuary_data.boxDrop
            if box and #box > 0 then
                table.insert(self.sanctuaryAllBoxRwward, box[1])
            end
        end
        self.sanctuaryAllLine = self.current_Sanctuary_data.mapId
        self.repId = mapData[1]
        GUI:DataListUpdateData(self.view.sanctuary_boss_line_data_list)
        GUI:DataListUpdateData(self.view.sanctuary_reward_box_data_list)
        GUI:DataListUpdateData(self.view.sanctuary_reward_data_list)
        GUI:DataListUpdateData(self.view.sanctuary_boss_line_data_list,true,function()
            SL:ScheduleOnce(Time.deltaTime, function()
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_COUNT_BY_ID, { { id = self.current_Sanctuary_data.id, state = 1 } })
            end)
        end)
    end
    GUI:Text_setString(self.view.last_num, "")
    InfoManager.uiHuntingDemonsInfo:SetIntegralInControl(self.view.sanctuary_boss_Integral_BG,self.view.sanctuary_boss_Integral_Text,monsterid)

    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_SECRET_REALM_COUNT, {})
    self.monsterId = nil
end

function this:SanctuaryCount(id, message)
    --SL:LogTable(message,true)
    self.last_num = message.count
    GUI:Text_setString(self.view.last_num, tostring(message.count))
end



---圣域BOSS
function this:SanctuaryBossBtnDataListItemCountFunc()
    return #self.allSanctuaryLevel
end

function this:SanctuaryBossBtnDataListItemGetFunc(realIndex)
    local data = self.allSanctuaryLevel[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossSelectBtnItem/KLUIChallengeBossSelectBtnItem", self.view.sanctuary_boss_level_data_list, self, {}, true)
    
    self.sanctuary_boss_level_btn_all_item[item.view.root] = item
    return item.view.root
end

function this:SanctuaryBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:SanctuaryBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.allSanctuaryLevel[realIndex + 1]
    self.sanctuary_boss_level_btn_all_item[kmlcontrol]:RefreshItem(data, self.select_Sanctuary_level, self, EBossChallengeType.Sanctuary)
    if data.level == self.select_Sanctuary_level then
        self.sanctuaryBossLevelBtn = self.sanctuary_boss_level_btn_all_item[kmlcontrol]
    end
end

function this:SanctuaryBossLineDataListItemCountFunc()
    return #self.sanctuaryAllLine
end

function this:SanctuaryBossLineDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossLineItem/KLUIChallengeBossLineItem", self.view.sanctuary_boss_line_data_list, self, { is_copy = 1 }, true)
    
    self.sanctuary_boss_line_data_list_all_item[item.view.root] = item
    return item.view.root
end

function this:SanctuaryBossLineDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:SanctuaryBossLineDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.allSanctuaryLevel[realIndex + 1]
    local mapMoveId = self.current_Sanctuary_data.mapMoveId[1][1]
    self.sanctuary_boss_line_data_list_all_item[kmlcontrol]:RefreshItem(self.repId, data, mapMoveId, self, 210, self.current_Sanctuary_data)
end

function this:SanctuaryRewardDataListItemCountFunc()
    return #self.sanctuaryAllRwward
end

function this:SanctuaryRewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem", self.view.sanctuary_reward_data_list, self, {}, true)
    
    self.sanctuary_reward_level_all_item[item.view.root] = item
    return item.view.root
end

function this:SanctuaryRewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:SanctuaryRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.sanctuaryAllRwward[realIndex + 1]
    self.sanctuary_reward_level_all_item[kmlcontrol]:RefreshItem({ cfgId = data }, self.select_Sanctuary_level, self)
end

function this:SanctuaryRewardBoxDataListItemCountFunc()
    return #self.sanctuaryAllBoxRwward
end

function this:SanctuaryRewardBoxDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem", self.view.sanctuary_reward_box_data_list, self, {}, true)
    
    self.sanctuary_reward_box_level_all_item[item.view.root] = item
    return item.view.root
end

function this:SanctuaryRewardBoxDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:SanctuaryRewardBoxDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.sanctuaryAllBoxRwward[realIndex + 1]
    self.sanctuary_reward_box_level_all_item[kmlcontrol]:RefreshItem({ cfgId = data }, self.select_Sanctuary_level, self)
end

function this:HideSanctuaryLevelSecret()
    if self.sanctuaryBossLevelBtn then
        self.sanctuaryBossLevelBtn:HideItem()
    end
end

function this:SelectSanctuarySecret(level, Btn)
    self.sanctuaryBossLevelBtn = Btn
    self.select_Sanctuary_level = level
    self:RefreshSanctuaryBoss()
end

return this

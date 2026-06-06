---@class KLUIGoldBossItem:UIKmlLuaPanelBase
---@field view KLUIGoldBossItemView
local KLUIGoldBossItem = class(UIKmlLuaPanelBase)
local this = KLUIGoldBossItem
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.gold_boss_level, function()
        return self:GoldBossBtnDataListItemCountFunc()
    end, function(realIndex)
        return self:GoldBossBtnDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:GoldBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GoldBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.glod_boss_level_btn_all_item = {}

    GUI:DataListInitData(self.view.gold_boss_data_list, function()
        return self:GoldBossDataListItemCountFunc()
    end, function(realIndex)
        return self:GoldBossDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:GoldBossDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GoldBossDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.glod_boss_level_all_item = {}

    GUI:DataListInitData(self.view.gold_boss_reward, function()
        return self:GoldRewardDataListItemCountFunc()
    end, function(realIndex)
        return self:GoldRewardDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:GoldRewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GoldRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.glod_reward_level_all_item = {}
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    
end



function this:Close()
   
end



--黄金boss
function this:SelectBossType(_monsterId)
    self.monsterId = _monsterId
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)

    if self.monsterId then
        playerLevel = SL:GetConfig("cfg_BOSS_challenge", self.monsterId, "monsterid").level
    end
    if not self.allGoldLevel then
        self.allGoldLevel = {}
        --local allBoss = SL:GetConfigMultiKeys('cfg_BOSS_challenge', 1, 'monsterType')
        local allBoss = SL:FindConfigs("cfg_BOSS_challenge", "monsterType", 1)
        for i, boss in ipairs(allBoss) do
            local level = boss.level
            if not table.contains(self.allGoldLevel, level) then
                table.insert(self.allGoldLevel, level)
            end
        end
        self.select_gold_level = nil
        local index = 0
        for i, level in ipairs(self.allGoldLevel) do
            if not self.select_gold_level then
                self.select_gold_level = level
                index = i
            else
                if level <= playerLevel and level > self.select_gold_level then
                    self.select_gold_level = level
                    index = i
                end
            end
        end
        local percentage = index / #self.allGoldLevel
        percentage = percentage - percentage % 0.00001
        GUI:DataListUpdateData(self.view.gold_boss_level,true)
        GUI:SetScrollView_scrollpos(self.view.gold_boss_select, index-1)
    end

    self:RefreshGoldBoss()
end

function this:RefreshGoldBoss()
    self.GoldOneLevel = {}
    local index = 0
    if self.monsterId then
        local tab = SL:FindConfigs("cfg_BOSS_challenge", "monsterType", 1)
        local isFind = false
        for i, v in ipairs(tab) do
            if v.level == self.select_gold_level then
                table.insert(self.GoldOneLevel, v)
                if v.monsterid == self.monsterId then
                    isFind = true
                end
                if not isFind then
                    index = index + 1
                end
            end
        end
    else
        local tab = SL:FindConfigs("cfg_BOSS_challenge", "monsterType", 1)
        for i, v in ipairs(tab) do
            if v.level == self.select_gold_level then
                table.insert(self.GoldOneLevel, v)
            end
        end
    end
    self.GoldAllRwward = {}
    if #self.GoldOneLevel > 0 then
        local Rwward = self.GoldOneLevel[1].monsterDrop
        local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
        for i, one_reward in ipairs(Rwward) do
            if one_reward[1] == baseCareer then
                table.insert(self.GoldAllRwward, one_reward[2])
            end
        end
    end
    GUI:DataListUpdateData(self.view.gold_boss_reward)
    local message = {}
    for i, v in ipairs(self.GoldOneLevel) do
        table.insert(message, { id = v.id, state = 1 })
    end
    GUI:DataListUpdateData(self.view.gold_boss_data_list,false,function()
        SL:ScheduleOnce(0.1, function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_COUNT_BY_ID, message)
            GUI:SetScrollView_scrollpos(self.view.gold_boss_view, index)
        end)
    end)
   
end

function this:GoldBossBtnDataListItemCountFunc()
    return #self.allGoldLevel
end

function this:GoldBossBtnDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossBtnItem/KLUIChallengeBossBtnItem", self.view.gold_boss_level, self, {}, true)
    self.glod_boss_level_btn_all_item[item.view.root] = item
    return item.view.root
end

function this:GoldBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:GoldBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.allGoldLevel[realIndex + 1]
    self.glod_boss_level_btn_all_item[kmlcontrol]:RefreshItem(data, self.select_gold_level, self)
    if data == self.select_gold_level then
        self.GoldBossLevelBtn = self.glod_boss_level_btn_all_item[kmlcontrol]
    end
end

function this:GoldBossDataListItemCountFunc()
    return #self.GoldOneLevel
end

function this:GoldBossDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossItem/KLUIChallengeBossItem", self.view.gold_boss_data_list, self, {}, true,
            function(_item)
                self.glod_boss_level_all_item[_item.view.root] = _item
                self:GoldBossDataListItemUpdateFunc(realIndex,_item.view.root)
            end)
    
    return item.view.root
end

function this:GoldBossDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:GoldBossDataListItemUpdateFunc(realIndex, kmlcontrol)
    if self.glod_boss_level_all_item[kmlcontrol] then
        local data = self.GoldOneLevel[realIndex + 1]
        self.glod_boss_level_all_item[kmlcontrol]:RefreshItem(data, self.select_gold_level, self)
        if self.monsterId == data.monsterid then
            self.glod_boss_level_all_item[kmlcontrol]:ShowSelectImg()
        end
    end
end

function this:HideSelectLevel()
    if self.GoldBossLevelBtn then
        self.GoldBossLevelBtn:HideItem()
    end
end

function this:SelectLevel(level, Btn)
    self.monsterId = nil
    self.GoldBossLevelBtn = Btn
    self.select_gold_level = level
    self:RefreshGoldBoss()
end

function this:GoldRewardDataListItemCountFunc()
    return #self.GoldAllRwward
end

function this:GoldRewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem", self.view.gold_boss_reward, self, {}, true)
    
    self.glod_reward_level_all_item[item.view.root] = item
    return item.view.root
end

function this:GoldRewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:GoldRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.GoldAllRwward[realIndex + 1]
    self.glod_reward_level_all_item[kmlcontrol]:RefreshItem({ cfgId = data }, self.select_gold_level, self)
end


return this

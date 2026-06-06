---@class KLKuaFuBossInfoItem:UIKmlLuaPanelBase
---@field view KLKuaFuBossInfoItemView
---@field nowSelectMonster KLUIChallengeBossSelectBtnItem
local KLKuaFuBossInfoItem = class(UIKmlLuaPanelBase)
local this =KLKuaFuBossInfoItem

---创建时调用一次
function this:Init()
    self.allBossData = {}
    self.activityId = 23001
    self.recommendIndex = nil
    local recommendLv = nil
    local index = 0
    local tbl = SL:GetConfigTable("cfg_BOSS_challenge")
    local lv = tonumber(SL:GetMetaValue(EMetaVarGetKey.LEVEL))
    local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
    ---@param cfg cfg_BOSS_challenge_column
    for _, cfg in pairs(tbl) do
        if cfg.monsterType == 4 then
            --跨服boss
            index = index + 1
            local rewards = {}
            -- for _, v in pairs(cfg.monsterDrop) do
            --     for _, data in pairs(v) do
            --         table.insert(rewards, data)
            --     end
            -- end
            local Rwward = cfg.monsterDrop
            for i, one_reward in ipairs(Rwward) do
                if one_reward[1] == baseCareer then
                    table.insert(rewards,one_reward[2])
                end
            end

            table.insert(self.allBossData,  {level=cfg.level, monsterid=cfg.monsterid, index=index, uiReward = rewards, mapId = cfg.mapId, cfgId = cfg.id, size = cfg.size, offset = cfg.offset})
            if not recommendLv or (lv >= cfg.level and cfg.level > recommendLv) then
                recommendLv = cfg.level
                self.recommendIndex = index
            end
        end
    end
    --怪物列表
    GUI:DataListInitData(self.view.privilege_boss_level_data_list,function()
        return self:PrivilegeBossBtnDataListItemCountFunc()
    end,function(realIndex)
        return self:PrivilegeBossBtnDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:PrivilegeBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:PrivilegeBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.privilege_boss_level_btn_all_item = {}
    
    --奖励列表
    self.PrivilegeAllRwward = {}
    GUI:DataListInitData(self.view.privilege_boss_reward_data_list,function()
        return self:PrivilegeRewardDataListItemCountFunc()
    end,function(realIndex)
        return self:PrivilegeRewardDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:PrivilegeRewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:PrivilegeRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.privilege_reward_level_all_item = {}
    
    --立即刷新怪物列表
    self.nowSelectMonster = nil
    GUI:DataListUpdateData(self.view.privilege_boss_level_data_list)
    
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GODS_DESCENDED_DATA)
end

function this:PrivilegeBossBtnDataListItemCountFunc()
    return #self.allBossData
end

function this:PrivilegeBossBtnDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossSelectBtnItem/KLUIChallengeBossSelectBtnItem",self.view.privilege_boss_level_data_list,self,{},true)
    
    self.privilege_boss_level_btn_all_item[item.view.root]=item
    return item.view.root
end

function this:PrivilegeBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:PrivilegeBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    self.privilege_boss_level_btn_all_item[kmlcontrol]:RefreshItem(self.allBossData[realIndex + 1],self.recommendIndex,self,4)
    if realIndex + 1 == self.recommendIndex and self.nowSelectMonster == nil then
        self:SelectLevelPrivilege(realIndex + 1, self.privilege_boss_level_btn_all_item[kmlcontrol])
    end
end

function this:PrivilegeRewardDataListItemCountFunc()
    return #self.PrivilegeAllRwward
end

function this:PrivilegeRewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem",self.view.privilege_boss_reward_data_list,self,{},true)
    
    self.privilege_reward_level_all_item[item.view.root] = item
    return item.view.root
end

function this:PrivilegeRewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:PrivilegeRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.PrivilegeAllRwward[realIndex + 1]
    self.privilege_reward_level_all_item[kmlcontrol]:RefreshItem({cfgId=data},self.select_Secret_level,self)
end

--取消上一个选中
function this:HideSelectLevelPrivilege()
    if self.nowSelectMonster then
        self.nowSelectMonster:HideItem()
    end
    self.nowSelectMonster = nil
end
--选中后显示怪物信息
function this:SelectLevelPrivilege(index, item)
    self.nowSelectMonster = item
    local data = self.allBossData[index]
    local monsterid = data.monsterid
    InfoManager.uiHuntingDemonsInfo:SetIntegralInControl(self.view.Integral_BG,self.view.Integral_Text,monsterid)
    self.cfgId = monsterid
    local tab = SL:GetConfigMultiKeys('cfg_monster', monsterid, 'id')
    local name = tab.name
    local appr = tab.appr
    local path = SL:GetConfigMultiKeys('cfg_model_monster', appr, 'id').path
    GUI:Text_setString(self.view.privilege_boss_name,name)
    local mscale
    if data.size then
        local scale = math.ceil(data.size/100)
        mscale = scale .. "," .. scale .. "," .. scale
    end
    GUI:Model_setSrc(self.view.privilege_boss_path,path, mscale)
    if data.offset and #data.offset >= 2 then
        GUI:setPosition(self.view.privilege_boss_path,data.offset[1],data.offset[2])
    end
    --活动信息
    self:UpdateActivityInfo()
    --奖励
    self.PrivilegeAllRwward = data.uiReward
    GUI:DataListUpdateData(self.view.privilege_boss_reward_data_list)
end

function this:UpdateActivityInfo()
    local monsterid = self.cfgId
    ---@type {id:number, cfgid:number, name:string, state:number, ownerid:number, ownername:string}[]
    local datas = InfoManager.godsDescendInfo.GetMonsterInfosByCfgId(monsterid)
    local showCountDown = false
    if table.count(datas) == 0 then
        showCountDown = true    --未刷新
    else
        local allKilled = true
        for _, v in pairs(datas) do
            if v.state ~= 2 then
                --已死亡
                allKilled = false
                break
            end
        end
        if allKilled then
            showCountDown = true
        end
    end
    self:UnScheduleTimer()
    local activityInfo = InfoManager.activityPreviewInfo:GetActivityInfo(self.activityId)
    if (activityInfo and activityInfo.open == false) or showCountDown then
        GUI:setVisible(self.view.reviveText, true)
        local serverTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local count = (activityInfo.leftTime - tonumber(serverTime)) * 0.001 + 1
        local func = function()
            local now = tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))
            local deltaTime = activityInfo.leftTime - now
            GUI:Text_setString(self.view.txt_countDown, self:FormatTimeHMS(deltaTime))
            if deltaTime <= 0 then
                self:ResetInfo()
                self:UnScheduleTimer()
            end
        end
        self.countDown = SL:Schedule(self.countDown, 0, 1, count, func)
        --GUI:Text_setString(self.view.btn_goNow, "")
        GUI:setVisible(self.view.btn_goNow, false)
        GUI:setVisible(self.view.img_tip, true)
        func()
    else
        self:ResetInfo()
    end
end

function this:ResetInfo()
    GUI:setVisible(self.view.reviveText, false)
    GUI:Text_setString(self.view.txt_countDown, "")
    GUI:setVisible(self.view.btn_goNow, true)
    GUI:setVisible(self.view.img_tip, false)
end

--单位毫秒
function this:FormatTimeHMS(time)
    time = time // 1000
    local s = time % 60
    local m = time // 60 % 60
    local h = time // 3600 % 24
    return string.format("%02s:%02s:%02s", h, m, s);
end

function this:UnScheduleTimer()
    if self.countDown then
        SL:UnSchedule(self.countDown)
    end
    self.countDown = nil
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_goNow, self, self.Go)
    SL:RegisterLUAEvent(LUA_EVENT_GODSDESCEND_DATA_CHANGE, self.LUA_EVENT_GODSDESCEND_DATA_CHANGE, self)
end

function this:Go()
    if self.nowSelectMonster then
        --奖励列表
        local cond, message = InfoManager.godsDescendInfo.CheckActivityConditionMapId(self.activityId)
        if cond then
--[[            ---@type cfg_activity_rule_column
            local tbl = SL:GetConfig("cfg_activity_rule", self.activityId)
            SL:ShortcutDO(tbl.panel)]]
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GOTO_CROSS_MAP,{})
        else
            SL:TipMessage(message, 1, NoticeType.NoticeMid)
        end
    end
end

function this:LUA_EVENT_GODSDESCEND_DATA_CHANGE(_, data)
    if  not data then
        self:UpdateActivityInfo()
    else
        for _, v in pairs(data) do
            if tonumber(data.cfgid) == self.cfgId then
                self:UpdateActivityInfo()
                break
            end
        end
    end
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
    self:UnScheduleTimer()
end

return this

---@class KLUIPrivilegeBossItem:UIKmlLuaPanelBase
---@field view KLUIPrivilegeBossItemView
local KLUIPrivilegeBossItem = class(UIKmlLuaPanelBase)
local this = KLUIPrivilegeBossItem
---创建时调用一次
function this:Init()
    
    GUI:DataListInitData(self.view.privilege_boss_level_data_list, function()
        return self:PrivilegeBossBtnDataListItemCountFunc()
    end, function(realIndex)
        return self:PrivilegeBossBtnDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:PrivilegeBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:PrivilegeBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.privilege_boss_level_btn_all_item = {}

    GUI:DataListInitData(self.view.privilege_boss_reward_data_list, function()
        return self:PrivilegeRewardDataListItemCountFunc()
    end, function(realIndex)
        return self:PrivilegeRewardDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:PrivilegeRewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:PrivilegeRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.privilege_reward_level_all_item = {}
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PRIVILEGE_BOSS_PANEL, self.RES_PRIVILEGE_BOSS_PANEL, self)
    GUI:AddOnClickEvent(self.view.privilege_boss_join_btn, self, self.privilege_boss_join)
end



function this:Close()
   
end



---选择特权boss
function this:SelectBossType(_monsterId)
    self.monsterId = _monsterId
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)

    if self.monsterId then
        playerLevel = SL:GetConfig("cfg_BOSS_challenge", self.monsterId, "monsterid").level
    end

    if not self.allPrivilegeLevel then
        self.allPrivilegeLevel = {}
        --local allBoss = SL:GetConfigMultiKeys('cfg_BOSS_challenge', 1, 'monsterType')
        local allBoss = SL:FindConfigs("cfg_rep", "type", 18001)
        for i, boss in ipairs(allBoss) do
            boss.index = i
            table.insert(self.allPrivilegeLevel, boss)
        end
        self.select_privilege_level = nil
        self.select_privilege_index = nil
        local index = 0
        for i, boss in ipairs(self.allPrivilegeLevel) do
            local level = boss.level[1]
            if not self.select_privilege_level then
                self.select_privilege_level = level
                self.select_privilege_index = i
                index = i
            else
                if level <= playerLevel and level > self.select_privilege_level then
                    self.select_privilege_level = level
                    self.select_privilege_index = i
                    index = i
                end
            end
        end
        local percentage = index / #self.allPrivilegeLevel
        percentage = percentage - percentage % 0.00001
        GUI:DataListUpdateData(self.view.privilege_boss_level_data_list)
        GUI:SetScrollView_scrollpos(self.view.privilege_boss_select, index-1)
    end

    self:RefreshPrivilegeBoss()
end

function this:RefreshPrivilegeBoss()
    self.current_Privilege_data = self.allPrivilegeLevel[self.select_privilege_index]
    --SL:LogTable(self.current_Privilege_data,true)
    self.PrivilegeAllRwward = {}
    self.repId = 0
    local monsterid = nil
    if self.current_Privilege_data then
        monsterid = self.current_Privilege_data.monsterUI

        local tab = SL:GetConfigMultiKeys('cfg_monster', monsterid, 'id')
        local name = tab.name
        local icon = tab.icon
        local appr = tab.appr
        local path = SL:GetConfigMultiKeys('cfg_model_monster', appr, 'id').path
        GUI:Text_setString(self.view.privilege_boss_name, name)
        local mscale = ""
        if self.current_Privilege_data.size then
            local scale = math.ceil(self.current_Privilege_data.size / 100)
            mscale = scale .. "," .. scale .. "," .. scale
        end
        GUI:Model_setSrc(self.view.privilege_boss_path, path, mscale)
        if self.current_Privilege_data.offset and #self.current_Privilege_data.offset >= 2 then
            GUI:setPosition(self.view.privilege_boss_path, self.current_Privilege_data.offset[1], self.current_Privilege_data.offset[2])
        end
        local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
        for i, one_reward in ipairs(self.current_Privilege_data.UIJobReward) do
            if one_reward[1] == baseCareer then
                table.insert(self.PrivilegeAllRwward, one_reward[2])
            end
        end
        GUI:DataListUpdateData(self.view.privilege_boss_reward_data_list)
    end

    GUI:Text_setString(self.view.privilege_boss_last_num, "")
    self.privilege_num = 0
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PRIVILEGE_BOSS_PANEL, { configId = self.current_Privilege_data.id })
    InfoManager.uiHuntingDemonsInfo:SetIntegralInControl(self.view.tequan_boss_Integral_BG,self.view.tequan_boss_Integral_Text,monsterid)
    self.monsterId = nil
end

function this:PrivilegeBossBtnDataListItemCountFunc()
    return #self.allPrivilegeLevel
end

function this:PrivilegeBossBtnDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossSelectBtnItem/KLUIChallengeBossSelectBtnItem", self.view.privilege_boss_level_data_list, self, {}, true)
    
    self.privilege_boss_level_btn_all_item[item.view.root] = item
    return item.view.root
end

function this:PrivilegeBossBtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:PrivilegeBossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local _level = self.allPrivilegeLevel[realIndex + 1].level[1]
    local monsterUI = self.allPrivilegeLevel[realIndex + 1].monsterUI
    local data = { level = _level, monsterid = monsterUI, index = self.allPrivilegeLevel[realIndex + 1].index }
    self.privilege_boss_level_btn_all_item[kmlcontrol]:RefreshItem(data, self.select_privilege_index, self, 4)
    if self.allPrivilegeLevel[realIndex + 1].index == self.select_privilege_index then
        self.PrivilegeBossLevelBtn = self.privilege_boss_level_btn_all_item[kmlcontrol]
    end
end

function this:HideSelectLevelPrivilege()
    self.PrivilegeBossLevelBtn:HideItem()
end

function this:SelectLevelPrivilege(level, Btn)
    self.PrivilegeBossLevelBtn = Btn
    self.select_privilege_index = level
    self:RefreshPrivilegeBoss()
end

function this:PrivilegeRewardDataListItemCountFunc()
    return #self.PrivilegeAllRwward
end

function this:PrivilegeRewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem", self.view.privilege_boss_reward_data_list, self, {}, true)
    
    self.privilege_reward_level_all_item[item.view.root] = item
    return item.view.root
end

function this:PrivilegeRewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:PrivilegeRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.PrivilegeAllRwward[realIndex + 1]
    self.privilege_reward_level_all_item[kmlcontrol]:RefreshItem({ cfgId = data }, self.select_Secret_level, self)
end



function this:RES_PRIVILEGE_BOSS_PANEL(id, message)
    local leftCount = message.leftCount
    local numStr = tostring(leftCount)
    -- if not self:IsHavePrivilege() or leftCount == 0 then
    --     numStr = "<color=#ff2323>0</color>"
    -- end
    if leftCount == 0 then
        numStr = "<color=#ff2323>0</color>"
    end
    self.privilege_num = leftCount
    GUI:Text_setString(self.view.privilege_boss_last_num, numStr)
end

function this:privilege_boss_join()
    local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local mapTab = SL:GetConfig("cfg_map_info", map_id)
    if mapTab.nopositionmove and mapTab.nopositionmove == 1 then
        SL:MessageTip({ id = 116 })--"副本中无法传送",
        return
    end
    -- if self:IsHavePrivilege() then
    -- else
    --     --无特权
    --     GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel")
    --     GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
    --     return
    -- end
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if self.current_Privilege_data.level[1] > playerLevel then
        SL:TipMessage(SL:GetConfig('cfg_string', 263).text, 1, NoticeType.NoticeMid)--"当前等级不足",
        return
    end
    if self.privilege_num <= 0 then
        SL:TipMessage(SL:GetConfig('cfg_string', 264).text, 1, NoticeType.NoticeMid)--"挑战次数不足", 
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, self.current_Privilege_data.id)
end

function this:IsHavePrivilege()
    if InfoManager.monthCardInfo.IsGetMonthCard or InfoManager.monthCardInfo.IsGetDailyCard then
        --有月卡或是日卡
        return true
    elseif PrivilegeCardManager.goldPrivilege or PrivilegeCardManager.diamondPrivilege then
        --有黄金或者钻石特权
        return true
    else
        --无特权
    end
    return false
end

return this

---@class KLGodDescentItem:UIKmlLuaPanelBase
---@field view KLGodDescentItemView
local KLGodDescentItem = class(UIKmlLuaPanelBase)
local this =KLGodDescentItem

---创建时调用一次
function this:Init()
    --奖励列表
    ---@type cfg_activity_rule_column
    local tbl = SL:GetConfig("cfg_activity_rule", 23001)
    self.allReward = tbl.uiReward
    GUI:Text_setString(self.view.TextDesc, tbl.uiTextRule)
    GUI:DataListInitData(self.view.dateList_reward,function()
        return table.count(self.allReward)
    end,function(realIndex)
        return self:RewardDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:RewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.allRewardItem = {}
    GUI:DataListUpdateData(self.view.dateList_reward)
    
    self.monsterItems = {}
    local cfg = SL:GetConfigTable("cfg_BOSS_challenge")
    ---@param v cfg_BOSS_challenge_column
    for _, v in pairs(cfg) do
        if v.monsterType == 4 then
            self.monsterItems[v.monsterid] = GUI:UIPanel_Open("dev/outui/CrossServer/Item/KLGodDescentMonster/KLGodDescentMonsterItem", self.view.layout2,
                self, {id = v.monsterid, pic = v.picture, cfgId = v.id}, true)
        end
    end
end

function this:RewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem",self.view.dateList_reward,self,{},true)
    local index = realIndex + 1
    self.allRewardItem[index] = item
    local data = self.allReward[realIndex + 1]
    self.allRewardItem[index]:RefreshItem({cfgId=data})
    return item.view.root
end

function this:RewardDataListItemInitFunc(realIndex, kmlcontrol)
    
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex + 1
    local data = self.allReward[realIndex + 1]
    self.allRewardItem[index]:RefreshItem({cfgId=data})
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_Go, self, self.GoOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_GODSDESCEND_DATA_CHANGE, self.LUA_EVENT_GODSDESCEND_DATA_CHANGE, self)
end

function this:GoOnClick()
    --奖励列表
    local cond, message = InfoManager.godsDescendInfo.CheckActivityConditionMapId(23001)
    if cond then
        ---@type cfg_activity_rule_column
        local tbl = SL:GetConfig("cfg_activity_rule", 23001)
        --SL:ShortcutDO(tbl.panel)
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GOTO_CROSS_MAP,{})
    else
        SL:TipMessage(message, 1, NoticeType.NoticeMid)
    end
end

function this:LUA_EVENT_GODSDESCEND_DATA_CHANGE(id, message)
    if not message then
        for _, v in pairs(self.monsterItems) do
            v:UpdateMonsterData()
        end
    else
        for _, v in pairs(message) do
            if self.monsterItems[tonumber(v.cfgid)] then
                self.monsterItems[tonumber(v.cfgid)]:UpdateMonsterData()
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
    GUI:UIPanel_Close("dev/outui/CrossServer/Item/KLGodDescentMonster/KLGodDescentMonsterItem")
end

return this

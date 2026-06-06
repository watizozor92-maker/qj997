---@class KLRankItem:UIKmlLuaPanelBase
---@field view KLRankItemView
local KLRankItem = class(UIKmlLuaPanelBase)
local this = KLRankItem
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.reward_data_list, function()
        return self:RewardDataListItemCountFunc()
    end, function(realIndex)
        return self:RewardDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:RewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.all_item = {}
    self.all_reward_data = {}
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:RefreshItem(data,select_gold_level,rank_panel,mainOperateActivityInfo)
    self.data = data
    local currentGroup = mainOperateActivityInfo.NowOperateActivityMainGroup
    if not currentGroup or currentGroup <= 0 then
        currentGroup = 1
    end
    local tab = SL:GetConfigTwoKeys("cfg_Activity_costRank",self.data.rank,currentGroup,"ranking","mainGroup")

    self.all_reward_data = {}
    self.select_gold_level = select_gold_level
    self.rank_panel = rank_panel
    local rankValue = self.data.rank
    local rank_str = "第"..rankValue .. "名"
    local name_str = nil
    if string.isNullOrEmpty(self.data.name) then
        name_str = tab.text
    else
        name_str = self.data.name
    end
    GUI:Text_setString(self.view.PlayerItem_Name,name_str)
    GUI:Text_setString(self.view.PlayerItem_RankText,rank_str)
    
    local all_gift = tab.gift
    local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
    for i, gift in ipairs(all_gift) do
        local cfg_id = gift[1]
        local _count = 0
        local job_id = nil
        if #gift > 1 then
            _count = gift[2]
        end
        if #gift > 2 then
            job_id = gift[3]
        end
        if job_id then
            if job_id == baseCareer then
                table.insert(self.all_reward_data,{cfgId =cfg_id,count= _count})
            end
        else
            table.insert(self.all_reward_data,{cfgId =cfg_id,count= _count})
        end
    end
    
    --SL:LogTable(tab,true)
    GUI:DataListUpdateData(self.view.reward_data_list)
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.PlayerItem_Button,self,self.OnClickPlayer)
    -- SL:RegisterLuaNetMsg(LuaMessageIdToClient.MONSTER_COUNT_RESULT_BY_ID,self.MonserCount,self)
end


function this:OnClickPlayer()
    if not self.data or string.isNullOrEmpty(self.data.rid)  then
        return
    end
    self.rank_panel:OnClickPlayer(self.data)
end

function this:RewardDataListItemCountFunc()
    return #self.all_reward_data
end

function this:RewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem", self.view.reward_data_list, self, {}, true)
    
    self.all_item[realIndex+1] = item
    return item.view.root
end

function this:RewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_reward_data[realIndex + 1]
    self.all_item[realIndex+1]:RefreshItem(data)
end


function this:Close()
end


return this

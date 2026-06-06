---@class KLHuntingDemonsRewardItem:UIKmlLuaPanelBase
---@field view KLHuntingDemonsRewardItemView
local KLHuntingDemonsRewardItem = class(UIKmlLuaPanelBase)
local this =KLHuntingDemonsRewardItem

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.Reward_ItemDataList,function()
        return self:GetRewardDataListItemCountFunc()
    end,function(realIndex)
        return self:GetRewardDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GetRewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GetRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Hide()
end

function this:Close()
end

-------------------奖励预览---------------------------

function this:GetRewardDataListItemCountFunc()
    return #self.RewardDataList
end

function this:GetRewardDataListItemGetFunc(realIndex)
end

function this:GetRewardDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:GetRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.RewardDataList[realIndex + 1]

    local item = GUI:GetChildControl(self.view.Reward_ItemDataList,realIndex,'Reward_Item')
    local countStr = ""
    if data.count and data.count ~= "" then
        countStr = SL:GetSimpleNumber(data.count,1)
    end
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", data.id,"id")
    ---@type cfg_model_charactor_column
    local model_tbl = SL:GetConfig("cfg_model_charactor",itemTbl.shape[1],"id")
    GUI:Item_UpdataData(item, {
        itemid = data.id,
        itemcustomcount = countStr,
        mscale = model_tbl.inscale..","..model_tbl.inscale..","..model_tbl.inscale,
    })
    GUI:AddOnClickEvent(item, self, function()
        SL:OpenTips(nil, data.id)
    end)
end
--------------------------------------------

---设置排名文本和奖励信息
---@param data {rank:number,rewardList:table<number,{id:number,count:number}>}
function this:SetRankTextAndReward(data)
    GUI:Text_setString(self.view.Reward_Item_RankText,data.rank)
    self.RewardDataList = data.rewardList
    GUI:DataListUpdateData(self.view.Reward_ItemDataList)
end

return this

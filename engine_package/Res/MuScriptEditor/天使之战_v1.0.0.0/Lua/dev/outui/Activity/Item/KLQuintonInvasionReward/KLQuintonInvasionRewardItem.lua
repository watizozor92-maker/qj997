---@class KLQuintonInvasionRewardItem:UIKmlLuaPanelBase
---@field view KLQuintonInvasionRewardItemView
local KLQuintonInvasionRewardItem = class(UIKmlLuaPanelBase)
local this =KLQuintonInvasionRewardItem

---创建时调用一次
function this:Init()
    self.reward_all_item = {}
    GUI:DataListInitData(self.view.rewardList,function()
        return self:RewardDataListItemCountFunc()
    end,function(realIndex)
        return self:RewardDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:RewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
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
    self:RefreshItem(self.args)
end

function  this:RefreshItem(data)
    GUI:Text_setString(self.view.number,data.numberTxt)
    self.rewardData = data.rewardList
    GUI:DataListUpdateData(self.view.rewardList)
end

function this:RewardDataListItemCountFunc()
    return #self.rewardData
end

function this:RewardDataListItemGetFunc(realIndex)
    local data = self.rewardData[realIndex + 1]
    local message = {cfgId = tonumber(data[1]),count=tostring(data[2]),width = 50,height=50}
    local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLItem/KLItemItem",self.view.rewardList,self,message,true)
    self.reward_all_item[item.view.root] = item
    return item.view.root
end

function this:RewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.rewardData[realIndex + 1]
    self.reward_all_item[kmlcontrol]:RefreshItem(data[1],data[2])
end

function this:Close()
end

return this

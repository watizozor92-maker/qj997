---@class KLQuintonInvasionRewardPanel:UIKmlLuaPanelBase
---@field view KLQuintonInvasionRewardPanelView
local KLQuintonInvasionRewardPanel = class(UIKmlLuaPanelBase)
local this =KLQuintonInvasionRewardPanel
function this:AsyncLoadUI()
        end
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
        GUI:AddOnClickEvent(self.view.model,self,self.OnClickTip)
        GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnClickCloseBtn)
end

function this:OnClickTip()
        ---@type cfg_repGlobal_column
        local tbl = SL:GetConfig("cfg_repGlobal",21001005,"id")
        GUI:UIPanel_Open("dev/outui/Mount/Panel/KLMountTip/KLMountTipPanel",nil,nil,{cfgId=tonumber(tbl.value),type =  EMountTipType.OtherUIOpen})
end

function this:OnClickCloseBtn()
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLQuintonInvasionReward/KLQuintonInvasionRewardPanel")
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
        ---@type cfg_repGlobal_column
        local tbl = SL:GetConfig("cfg_repGlobal",21001005,"id")
        GUI:Item_setItemId(self.view.model_item,tbl.value)
        self:RefreshReward()
end

function  this:RefreshReward()
        ---@type cfg_repGlobal_column
        local tbl = SL:GetConfig("cfg_repGlobal",21001003,"id")
        self.rewardData = {}
        self.numberRewardData = {}
        
        local m = string.split(tbl.value,"|")
        for i, v in pairs(m) do
                local n = string.split(v,"#")
                table.insert(self.rewardData,n)
                local f = {}
                local itemId = 0
                for j, v1 in pairs(n) do
                        if j > 2 then
                                if j%2 == 0 then
                                        table.insert(f,{itemId,v1})
                                else
                                        itemId = tonumber(v1) 
                                end
                        end
                end
                self.numberRewardData[i] = f
        end
        
        GUI:DataListUpdateData(self.view.rewardList)
end

function this:RewardDataListItemCountFunc()
        return #self.rewardData
end

function this:RewardDataListItemGetFunc(realIndex)
        local index = realIndex + 1
        local data = self.rewardData[index]
        local numberTxt = data[1]
        if data[1]~=data[2] then
                numberTxt = data[1] .. "~" ..data[2]
        end
        local message = {rewardList = self.numberRewardData[index],numberTxt = "第"..numberTxt.."名"}
        local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLQuintonInvasionReward/KLQuintonInvasionRewardItem",self.view.rewardList,self,message,true)
        self.reward_all_item[item.view.root] = item
        return item.view.root
end

function this:RewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
        local index = realIndex + 1
        local data = self.rewardData[index]
        local numberTxt = data[1]
        if data[1]~=data[2] then
                numberTxt = data[1] .. "~" ..data[2]
        end
        local message = {rewardList = self.numberRewardData[index],numberTxt = "第"..numberTxt.."名"}
        self.reward_all_item[kmlcontrol]:RefreshItem(message)
end

function this:Close()
end

return this

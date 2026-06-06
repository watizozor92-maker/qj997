---@class KLGoldChallengeRewardItem:UIKmlLuaPanelBase
---@field view KLGoldChallengeRewardItemView
local KLGoldChallengeRewardItem = class(UIKmlLuaPanelBase)
local this =KLGoldChallengeRewardItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:RefreshItem(args)
    self.args = args
    GUI:Item_setItemId(self.view.RewardItem,tostring(self.args[1]))
    GUI:Item_setItemCount(self.view.RewardItem,tostring(SL:GetSimpleNumber(self.args[2],0)))
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnTips,self,self.BtnClick)
end

function this:BtnClick()
    if self.args then
        SL:OpenTips("", self.args[1])
    end
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
end

return this

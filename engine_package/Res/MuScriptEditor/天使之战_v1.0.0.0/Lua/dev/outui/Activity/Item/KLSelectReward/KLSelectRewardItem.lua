---@class KLSelectRewardItem:UIKmlLuaPanelBase
---@field view KLSelectRewardItemView
---@field baseUI KLSettlementPanel
local KLSelectRewardItem = class(UIKmlLuaPanelBase)
local this =KLSelectRewardItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:SetIsOnWithoutNotify(self.view.select_toggle,self.baseUI.curSelectReward==self.args.index)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.select_toggle,self,self.OnToggleValue)
end

function this:OnToggleValue(_,_,data)
    local isToggle = data[1]
    if isToggle then
        SL:onLUAEvent(SELECT_REWARD_TYPE,self.args)
    end
end

function this:RefreshItem(data)
    self.args = data
    GUI:SetIsOnWithoutNotify(self.view.select_toggle,self.baseUI.curSelectReward==self.args.index)
    if self.args.index == 1 then
        GUI:Text_setString(self.view.selectName,"正常领取")
    else
        GUI:Text_setString(self.view.selectName, GUIUtil.ToNumberString(self.args.index).."倍领取")
    end
end

function this:Close()
end

return this

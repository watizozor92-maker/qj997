---@class KLHuntingDemonsMainPanel:UIKmlLuaPanelBase
---@field view KLHuntingDemonsMainPanelView
local KLHuntingDemonsMainPanel = class(UIKmlLuaPanelBase)
local this =KLHuntingDemonsMainPanel

---创建时调用一次
function this:Init()
    ---已经打开的子界面
    self.openPanelPath = nil
    ---选择的toggle
    self.selectToggleIndex = nil
    ---所有toggle
    self.toggleList = 
    {
        [1] = self.view.toggle_HallOfFame,
        [2] = self.view.toggle_Reward,
    }
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.toggle_HallOfFame, self, self.OnToggleClick,1)
    GUI:SetToggleOnValueChange(self.view.toggle_Reward, self, self.OnToggleClick,2)
    GUI:AddOnClickEvent(self.view.button_close, self, self.OnClickClose)
    GUI:AddOnClickEvent(self.view.MaskButton, self, self.OnClickClose)
end

---点击关闭
function this:OnClickClose()
    if self.openPanelPath then
        GUI:UIPanel_Close(self.openPanelPath)
    end
    GUI:UIPanel_Close("dev/outui/HuntingDemons/Panel/KLHuntingDemonsMain/KLHuntingDemonsMainPanel")
end

---点击选择页签
function this:OnToggleClick(kmlCtrl, eventData, args)
    if args[1] and self.selectToggleIndex ~= eventData then
        if self.openPanelPath then
            GUI:UIPanel_Close(self.openPanelPath)
        end
        self.selectToggleIndex = eventData
        if eventData == 1 then
            self.openPanelPath = "dev/outui/HuntingDemons/Panel/KLHuntingDemonsHallOfFame/KLHuntingDemonsHallOfFamePanel"
        elseif eventData == 2 then
            self.openPanelPath = "dev/outui/HuntingDemons/Panel/KLHuntingDemonsReward/KLHuntingDemonsRewardPanel"
        end
        GUI:UIPanel_Open(self.openPanelPath,_,_,{mainPanel = self})
    end
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    InfoManager.uiHuntingDemonsInfo:SetIsStartReqRankData(true)
    local toggleIndex = 1
    if self.args and self.args.toggleIndex then
        toggleIndex = self.args.toggleIndex
    end
    self:SelectTogglePanel(toggleIndex)
end

---设置哪个页签选中
function this:SelectTogglePanel(index)
    GUI:Toggle_setIsOn(self.toggleList[index],true)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_HUNT_RANK)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_HUNT_INFO)
end

function this:Hide()
end

function this:Close()
    InfoManager.uiHuntingDemonsInfo:SetIsStartReqRankData(false)
end

return this

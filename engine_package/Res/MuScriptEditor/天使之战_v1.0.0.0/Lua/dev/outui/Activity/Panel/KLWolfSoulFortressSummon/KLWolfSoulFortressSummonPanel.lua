---@class KLWolfSoulFortressSummonPanel:UIKmlLuaPanelBase
---@field view KLWolfSoulFortressSummonPanelView
---@field all_item KLWolfSoulFortressSummonItem[]
---@field nextStateTime number
local KLWolfSoulFortressSummonPanel = class(UIKmlLuaPanelBase)
local this = KLWolfSoulFortressSummonPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    SL:ReqViewUnionMessage()
    self.all_item = {}
    GUI:DataListInitData(self.view.summonDataList, function()
        return self:BtnDataListItemCountFunc()
    end, function(realIndex)
        return self:BtnDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息waa
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnClose, self, self.CloseOnclick)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WOLF_SOUL_PREPARE_PANEL, self.RES_WOLF_SOUL_PREPARE_PANEL, self)
    
    SL:RegisterLuaNetMsg(MessageDef.ResBagChangeMessage, this.ResBagChangeMessage, self)
end
---背包变化
---@param message BagProtos.BagChangeRes
function this:ResBagChangeMessage(_, message)
    if #message.coinList > 0 then
        for k, v in pairs(message.coinList) do
            if v.itemId == self.summonNeedItemId then
                GUI:Text_setString(self.view.textGuildMoney, tostring(v.count))
                break
            end
        end
    end
end
---@param message {"1":召唤数量}
function this:RES_WOLF_SOUL_PREPARE_PANEL(_, message)
    InfoManager.wolfSoulFortressInfo.summonCount = message["1"]
    self.guardians = InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.guardians
    GUI:Text_setString(self.view.textSummonCount, string.format("%s/%s", InfoManager.wolfSoulFortressInfo.summonCount, self.guardians))
end

function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonPanel")
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    InfoManager.wolfSoulFortressInfo:GetCfgByOpenServerDay()
    SL.HideMainPanel()
    GUI:DataListUpdateData(self.view.summonDataList)
    if InfoManager.wolfSoulFortressInfo.state == 1 then
        self.nextStateTime = InfoManager.wolfSoulFortressInfo.nextStateTime
        self:RefreshTimeText()
        if not self.timer then
            self.timer = SL:StartLoopForever(1, self.RefreshTimeText, self) ---Timer.StartLoopForever(1, self.RefreshTimeText, self)
        end
    else
        GUI:Text_setString(self.view.textTime, SL.Time.FormatTimeHMS(math.floor(0))) --Time.FormatTimeHMS(math.floor(0)))
    end

    ---多个消耗道具都一样用第一个就行
    self.summonNeedItemId = InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.guardiansType[1][2]
    self.guardians = InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.guardians
    GUI:Text_setString(self.view.textGuildMoney, tostring(SL:GetBagItemCount(self.summonNeedItemId)))
    GUI:Text_setString(self.view.textSummonCount, string.format("%s/%s", InfoManager.wolfSoulFortressInfo.summonCount, self.guardians))
end

function this:RefreshTimeText()
    if not self.nextStateTime then
        return
    end
    local nextTime = self.nextStateTime - SL.Time:GetServerTime()---Time.GetServerTime()
    if nextTime < 0 then
        if self.timer then
            ---Timer.Stop(self.timer)
            SL:UnSchedule(self.timer)
            self.timer = nil
        end
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonPanel")
    end
    GUI:Text_setString(self.view.textTime,  SL.Time:FormatTimeHMS(math.floor(nextTime))) ---Time.FormatTimeHMS(math.floor(nextTime)))
end

function this:BtnDataListItemCountFunc()
    local count = #InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.guardiansType
    if not count then
        count = 0
    end
    return count
end

function this:BtnDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonItem", self.view.summonDataList, self, nil, true)
    
    self.all_item[item.view.root] = item
    return item.view.root
end

function this:BtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local tempData = {
        index = realIndex + 1,
        data = InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.guardiansType[realIndex + 1]
    }
    self.all_item[kmlcontrol]:RefreshItem(tempData)
end

function this:Close()
    SL.ShowMainPanel()
    if self.timer then
        ---Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

return this

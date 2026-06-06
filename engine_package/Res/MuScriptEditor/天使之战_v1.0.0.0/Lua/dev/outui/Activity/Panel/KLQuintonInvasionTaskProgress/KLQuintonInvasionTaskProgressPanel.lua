---@class KLQuintonInvasionTaskProgressPanel:UIKmlLuaPanelBase
---@field view KLQuintonInvasionTaskProgressPanelView
local KLQuintonInvasionTaskProgressPanel = class(UIKmlLuaPanelBase)
local this = KLQuintonInvasionTaskProgressPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLQuintonInvasionTaskProgressPanelKml", true)
    self.reward_all_item = {}
    self.rewardData = {}
    GUI:DataListInitData(
        self.view.rewardList,
        function()
            return self:RewardDataListItemCountFunc()
        end,
        function(realIndex)
            return self:RewardDataListItemGetFunc(realIndex)
        end,
        function(realIndex, kmlcontrol)
            return self:RewardDataListItemInitFunc(realIndex, kmlcontrol)
        end,
        function(realIndex, kmlcontrol)
            return self:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
        end
    )
    self.countdown = nil
    self.timer =
        SL:Schedule(
        self.timer,
        0,
        1,
        -1,
        function()
            if not self.countdown then
                return
            end
            local str = self:timeStr(self.countdown)
            GUI:Text_setString(self.view.countDownTime, str)
            -- if t <= 0 then
            --     SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_STATE, EDuplicateType.StartCopy)
            -- end
        end
    )
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.desBtn, self, self.OnCliCkDesBtn)
    GUI:AddOnClickEvent(self.view.exitBtn, self, self.OnCliCkExitBtn)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE, self.RES_QUIT_SUCCESS, self)
end

function this:SetData(message)
    if not message.taskStage then
        return
    end
    self.data = message
    self.taskStage = self.data.taskStage
    self.countdown = self.data.nextStateStartTime
    local tbl = SL:GetConfig("cfg_rep", 21001, "id")
    ---@type cfg_repTask_column
    local tbl1 = SL:GetConfig("cfg_repTask", tonumber(tbl.repTarget), "id")
    GUI:Text_setString(self.view.taskCount, self.taskStage.."/" .. tbl1.param[2])
end

function this:OnCliCkDesBtn()
    local data = {
        content = "1、昆顿入侵可通过跨服入口-神之国度-昆顿入侵入口进入地图。\n2.活动开启后玩家进入活动后会被分为猎鹰阵营、巨龙阵营、苍狼阵营3个阵营。\n3、活动开启后每对昆顿造成一定伤害获得1点积分,获得1点积分所需的伤害会随着开服天数提升而提升。\n4、击杀其他玩家可以获得被击杀者20%的积分。\n5.活动结束后阵营积分第一的阵营可获得拍卖分红。\n6、活动结束后根据积分排名发放奖励。\n7、玩家每日只能获得一次积分奖励,获得每日活动排名奖励后再次参加活动将不能获得积分O\n8、排名奖励需积分大于30分才能领取。\n9、昆顿被击杀后还有概率在跨服拍卖行上架稀有坐骑,阵营积分第一阵营中的玩家个人积分超过30可获得拍卖分红。",
        title = "昆顿入侵规则说明"
    }
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLDescribeDetail/KLDescribeDetailPanel", nil, nil, data)
end

function this:OnCliCkExitBtn()
    SL:CommonTipsMessage({ stringTblID=211, ui = self, sureBtnText = "确定", cancelBtnText = "取消",
                           callback = self.ExitSure})
end
function this:ExitSure()
    InfoManager.copActivityInfo.hideTask = false
    InfoManager.copActivityInfo.hideTeam = false
    SL:onLUAEvent(LUA_EVENT_SHOW_TASK)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
end

function this:RES_QUIT_SUCCESS(id, message)
    InfoManager.copActivityInfo.hideTask = false
    InfoManager.copActivityInfo.hideTeam = false
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", message, "id")
    if tbl.type == EActivityType.QuintonInvasion then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLQuintonInvasionTaskProgress/KLQuintonInvasionTaskProgressPanel")
    end
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", 21001, "id")
    ---@type cfg_repTask_column
    local tbl1 = SL:GetConfig("cfg_repTask", tonumber(tbl.repTarget), "id")
    GUI:Text_setString(self.view.taskName, tbl1.name)
    --GUI:Text_setString(self.view.taskCount, "0/" .. tbl1.param[2])
    --self.countdown = Time.GetServerTime() + tbl.continuous
    
    self:RefreshReward()
end

function this:timeStr(time)
    local t = time - Time.GetServerTime()
    t = math.modf(t/1000)
    local time_tab = SL:SecondToHMS(t)
    local str = ""
    local is_add = false
    if time_tab.d and time_tab.d > 0 then
        str = str .. time_tab.d
        is_add = true
    end
    if time_tab.h and time_tab.h > 0 or is_add then
        if not is_add then
            str = str .. time_tab.h
        else
            str = str ..":" .. time_tab.h
        end
        is_add = true
    end
    if time_tab.h and time_tab.h > 0 or is_add then
        if not is_add then
            str = str .. time_tab.h
        else
            str = str ..":" .. time_tab.h
        end
        is_add = true
    end
    if time_tab.m and time_tab.m > 0 or is_add then
        if not is_add then
            str = str .. time_tab.m
        else
            str = str ..":" .. time_tab.m
        end
        is_add = true
    end
    if time_tab.s then
        if not is_add then
            str = str .. time_tab.s
        else
            str = str ..":" .. time_tab.s
        end
        is_add = true
    end
    return str
end

function this:s()
    GUI:Text_setString(self.view.taskName, "")
    GUI:Text_setString(self.view.taskCount, "0/1")
end

function this:RefreshReward()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", 21001, "id")
    self.rewardData = tbl.UIreward
    GUI:DataListUpdateData(self.view.rewardList)
end

function this:RewardDataListItemCountFunc()
    return #self.rewardData
end

function this:RewardDataListItemGetFunc(realIndex)
    local data = self.rewardData[realIndex + 1]
    local message = {cfgId = data[1], count = "", width = 70, height = 70}
    local item =
        GUI:UIPanel_Open("dev/outui/Activity/Item/KLItem/KLItemItem", self.view.rewardList, self, message, true)
    self.reward_all_item[item.view.root] = item
    return item.view.root
end

function this:RewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.rewardData[realIndex + 1]
    self.reward_all_item[kmlcontrol]:RefreshItem(data[1], "")
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.fightRoot, isVisible)
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = nil
    InfoManager.copActivityInfo.hideTask = false
end

return this

---@class KLCopyTeamPanel:UIKmlLuaPanelBase
---@field view KLCopyTeamPanelView
local KLCopyTeamPanel = class(UIKmlLuaPanelBase)
local this = KLCopyTeamPanel
---创建时调用一次
function this:Init()
    self.team_all_item = {}
    self.teamData = {}
    GUI:DataListInitData(self.view.teamList, function()
        return self:TeamDataListItemCountFunc()
    end, function(realIndex)
        return self:TeamDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:TeamDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:TeamDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel")
    SL.HideMainPanel()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", self.args.configId, "id")
    GUI:Text_setString(self.view.title, tbl.cehua .. "第" .. tbl.repLevel .. "层")
    self.teamData = {}
    ---@type cfg_global_column
    --local tbl = SL:GetConfig("cfg_global",220,"id")
    --tonumber(tbl.value)
    self:StartCountDown(30)
    self:RefreshCostItem()
    self:RefreshTeamInfoList(self.args)

    if tbl.type == EActivityType.DevilSquare then
        GUI:setPositionY(self.view.ticketModel, -150)
    else
        GUI:setPositionY(self.view.ticketModel, -167)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DUPLICATE_TEAM_INFO, self.RES_DUPLICATE_TEAM_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BREAK_DUPLICATE_TEAM, self.RES_BREAK_DUPLICATE_TEAM, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER,self.LUA_EVENT_BAG_CHANGE_AFTER,self)
    
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.OnClickClose)
    GUI:AddOnClickEvent(self.view.Btcanel, self, self.OnClickBtcanel)
    GUI:AddOnClickEvent(self.view.BtnDissolve, self, self.OnClickBtnDissolve)
    GUI:AddOnClickEvent(self.view.Btnok, self, self.OnClickBtnok)
    GUI:AddOnClickEvent(self.view.ticketBtn, self, self.OnCliCkTicketBtn)
    GUI:AddOnClickEvent(self.view.addBtn, self, self.OnCliCkAddCountBtn)
end

function this:OnClickClose()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_TEAM_STATE, DupTeamChangeState.REFUSE)
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel")
end
---拒绝
function this:OnClickBtcanel()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_TEAM_STATE, DupTeamChangeState.REFUSE)
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel")
end
---解散
function this:OnClickBtnDissolve()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_TEAM_STATE, DupTeamChangeState.BREAK)
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel")
end
---准备
function this:OnClickBtnok()
    if self.meEnterCopyState == EnterLimitResultConst.REFUSE then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_TEAM_STATE, DupTeamChangeState.READY)
    elseif self.meEnterCopyState ~= EnterLimitResultConst.ALLOW then
        local state = self:CheckCondition(self.meEnterCopyState)
        SL:TipMessage(state, 1, NoticeType.NoticeMid)
    end
end

function this:OnCliCkTicketBtn()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", self.args.configId, "id")
    SL:OpenTips(nil, tbl.itemId[1])
end

function this:OnCliCkAddCountBtn()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", self.args.configId, "id")
    SL:CommonItemGetPath(nil, tbl.itemId[1])
end

function this:RefreshCostItem()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", self.args.configId, "id")
    local ownerTicket = SL:GetBagItemCount(tbl.itemId[1])
    isMeet = tbl.itemId[2] <= ownerTicket
    GUI:setVisible(self.view.addBtn, not isMeet)
    color = isMeet and "#28E529" or "#ff2323"
    GUI:Text_setString(self.view.ticketCount, GUIUtil.GetColorText(ownerTicket .. "/" .. tbl.itemId[2], color))
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", tbl.itemId[1], "id")
    ---@type cfg_model_charactor_column
    local modelTbl = SL:GetConfig("cfg_model_charactor", itemTbl.shape[1], "id")
    GUI:Model_setSrc(self.view.ticketModel, modelTbl.path)
end

function this:TeamDataListItemCountFunc()
    return #self.teamData
end

function this:TeamDataListItemGetFunc(realIndex)
    local data = self.teamData[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLTeamInfo/KLTeamInfoItem", self.view.teamList, self, data, true)
    self.team_all_item[item.view.root] = item
    return item.view.root
end

function this:TeamDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:TeamDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.teamData[realIndex + 1]
    self.team_all_item[kmlcontrol]:RefreshItem(data)
end

function this:CheckCondition(state)
    if state == EnterLimitResultConst.LEVEL then
        return "等级不足"
    end

    if state == EnterLimitResultConst.ITEM then
        return "道具不足"
    end

    if state == EnterLimitResultConst.COUNT then
        return "次数不足"
    end

    if state == EnterLimitResultConst.REFUSE then
        return "拒绝进入"
    end
    return
end

function this:RefreshTeamInfoList(data)
    self.args = data
    self.isEnterMap = true
    self.meEnterCopyState = EnterLimitResultConst.ALLOW
    table.clear(self.teamData)
    local rid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    rid = tonumber(rid)
    for i, v in pairs(data.members) do
        local teamInfo = {}
        local state = self:CheckCondition(v.state)
        teamInfo.select = not state
        if not state then
            state = "<color=#28E529>已准备</color>"
        end
        teamInfo.state = state
        teamInfo.isLeader = data.leaderid == v.rid
        teamInfo.name = v.name
        teamInfo.career = tonumber(v.career)
        table.insert(self.teamData, teamInfo)
        if v.state ~= EnterLimitResultConst.ALLOW then
            self.isEnterMap = false
        end
        if rid == v.rid then
            self.meEnterCopyState = v.state
        end
    end

    if self.isEnterMap then
        self:StartCountDown(5)
    end

    local isMeet = data.leaderid == rid
    GUI:setVisible(self.view.Btcanel, not isMeet)
    GUI:setVisible(self.view.BtnDissolve, isMeet)
    GUI:setVisible(self.view.Btnok, not isMeet)

    GUI:DataListUpdateData(self.view.teamList)
end

function this:StartCountDown(countdown)
    ---@type cfg_global_column
    --local tbl = SL:GetConfig("cfg_global",220,"id")
    self.countdown = countdown--tonumber(tbl.value)
    self.timer = SL:Schedule(self.timer, 0, 1, self.countdown, function()
        self.countdown = self.countdown - 1
        GUI:Text_setString(self.view.countDown, GUIUtil.FormatTimeMS(self.countdown))
        if self.countdown <= 0 then
            if self.timer then
                SL:UnSchedule(self.timer)
                self.timer = nil
            end
            local rid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
            if self.args.leaderid == tonumber(rid) then
                if not self.isEnterMap then
                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_TEAM_STATE, DupTeamChangeState.BREAK)
                else
                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_DUPLICATE_TEAM_ENTER)
                end
            end
            GUI:UIPanel_Close("dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel")
        end
    end)
end

function this:RES_DUPLICATE_TEAM_INFO(id, message)
    self:RefreshTeamInfoList(message)
end

function this:RES_BREAK_DUPLICATE_TEAM(id, message)
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel")
end

function this:LUA_EVENT_BAG_CHANGE_AFTER(id, message)
    self:RefreshCostItem()
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    self.countdown = 0
    SL.ShowMainPanel()
end

return this

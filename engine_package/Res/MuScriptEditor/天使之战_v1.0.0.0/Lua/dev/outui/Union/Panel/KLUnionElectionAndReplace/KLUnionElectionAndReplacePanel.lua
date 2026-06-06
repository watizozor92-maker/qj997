---@class KLUnionElectionAndReplacePanel:UIKmlLuaPanelBase
---@field view KLUnionElectionAndReplacePanelView
local KLUnionElectionAndReplacePanel = class(UIKmlLuaPanelBase)
local this = KLUnionElectionAndReplacePanel
---创建时调用一次
function this:Init()
    self.type = self.args.type
    GUI:Image_loadTexture(self.view.TitleImage, self.type == EUnionLeaderOperateType.Election and "title_election" or "title_replace",
            "Atlas/TS_UnionElection.spriteatlas")
    self.level = nil
    self.unionData = nil
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_INFO)
    if self.type == EUnionLeaderOperateType.Election then
        GUI:setVisible(self.view.levelList, true)
        GUI:setVisible(self.view.ticketList, true)
        GUI:setVisible(self.view.replaceLevel, false)
    elseif self.type == EUnionLeaderOperateType.Replace then
        GUI:setVisible(self.view.levelList, false)
        GUI:setVisible(self.view.ticketList, false)
        GUI:setVisible(self.view.replaceLevel, true)
    end
    --[[    GUI:DataListInitData(self.view.datalist,
                function()
                    local data = InfoManager.unionElectionInfo:GetElectionDataList()
                    return table.count(data)
                end,
                function(realIndex)
                    return self:ItemGetFunc(realIndex)
                end,
                function(realIndex, kmlCtrl)
                    return self:ItemInitFunc(realIndex, kmlCtrl)
                end,
                function(realIndex, kmlCtrl)
                    return self:ItemUpdateFunc(realIndex, kmlCtrl)
                end)]]

end

---创建或者刷新界面数据时调用
function this:Refresh()

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnJoin, self, self.JoinOnCLick)
    GUI:AddOnClickEvent(self.view.btnAdd, self, self.AddOnCLick)
    GUI:AddOnClickEvent(self.view.btnClose, self, self.CloseSelf)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_UNION_INFO, self.RES_GET_UNION_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_ELECTION_DATA_CHANGE, self.On_DataChange, self)
end

function this:On_DataChange(_, isReplace)
    if isReplace and self.type == EUnionLeaderOperateType.Replace then
        self:ItemUpdateFunc()
    elseif not isReplace and self.type == EUnionLeaderOperateType.Election then
        self:ItemUpdateFunc()
    end
end

--刷新竞选数据
function this:ItemUpdateFunc()
    if not self.unionData then
        return
    end
    local myId = SL:GetMetaValue("MAIN_ACTOR_ID")
    local hasMe = false
    self:UnSchedule()
    local endTime
    if self.type == EUnionLeaderOperateType.Election then
        --竞选
        local data = InfoManager.unionElectionInfo:GetElectionDataList()
        local filePath = "dev/outui/Union/Item/KLUnionElectionReplace/KLUnionElectionReplaceItem"
        GUI:UIPanel_Close(filePath)
        if data then
            for k, v in pairs(data) do
                if self.unionData.memberinfos[k] then
                    GUI:UIPanel_Open(filePath, self.view.layout4, self, {
                        id = k, data = v, memberInfo = self.unionData.memberinfos[k], level = self.level
                    }, true)
                    if k == myId then
                        hasMe = true
                    end
                end
            end
        end
        --竞选倒计时
        endTime = InfoManager.unionElectionInfo:GetElectionEndTime()
        --[[        if endTime then
                    --local delta = endTime - SL:server
                    local nowTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
                    local deltaTime = endTime - nowTime
                    if deltaTime > 0 then
                        self.schedule = SL:Schedule(0, 1, deltaTime // 1000 + 1,  function()
                            local nowTime_ = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
                            local deltaTime_ = endTime - nowTime_
                            if deltaTime_ <= 0 then
                                deltaTime_ = 0
                                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_RUN_FOR_LEADER_DATA)
                                SL:onLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, "infoToggle")
                                GUI:UIPanel_Close(self.filePath)
                                return
                            end
                            GUI:Text_setString(self.view.txtCountDown, "竞选结束倒计时"..self:FormatTimeStr(deltaTime_))
                        end)
                    end
                end]]
    elseif self.type == EUnionLeaderOperateType.Replace then
        local data = InfoManager.unionElectionInfo:GetReplaceDataList()
        local filePath = "dev/outui/Union/Item/KLUnionReplace/KLUnionReplaceItem"
        GUI:UIPanel_Close(filePath)
        if data then
            for k, v in pairs(data) do
                GUI:UIPanel_Open(filePath, self.view.layout4, self, {
                    memberInfo = self.unionData.memberinfos[k]
                }, true)
                if k == myId then
                    hasMe = true
                end
            end
        end
        endTime = InfoManager.unionElectionInfo:GetReplaceEndTime()
    end
    if endTime then
        endTime = tonumber(endTime)
        --local delta = endTime - SL:server
        local nowTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local deltaTime = endTime - tonumber(nowTime)
        local preStr = self.type == EUnionLeaderOperateType.Election and "竞选结束倒计时" or "取代结束倒计时"
        if deltaTime > 0 then
            local takeABreak = false
            self.schedule = SL:Schedule(self.schedule, 0, 1, deltaTime // 1000 + 2, function()
                local nowTime_ = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
                local deltaTime_ = endTime - tonumber(nowTime_)
                if deltaTime_ <= 0 then
                    deltaTime_ = 0
                    if takeABreak == false then
                        takeABreak = true
                    else
                        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_RUN_FOR_LEADER_DATA)
                        SL:onLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, "infoToggle")
                        GUI:UIPanel_Close(self.filePath)
                        return
                    end
                end
                GUI:Text_setString(self.view.txtCountDown, preStr .. InfoManager.unionElectionInfo.FormatTimeStr(deltaTime_))
            end)
        else
            deltaTime = 0
            GUI:Text_setString(self.view.txtCountDown, preStr .. InfoManager.unionElectionInfo.FormatTimeStr(deltaTime))
        end
    end
    GUI:Text_setString(self.view.btnJoin, hasMe and "已参与" or "参与")
    GUI:Button_loadTextureNormal(self.view.btnJoin, hasMe and "btn_common_1" or "btn_common_1_select", "Atlas/FG_Common.spriteatlas")
    --GUI:Image_loadTexture(self.view.btnJoin, hasMe and "btn_hasParticipated" or "btn_participation", "Atlas/FG_Common.spriteatlas")
    GUI:setTouchEnabled(self.view.btnJoin, not hasMe)
end

function this:RES_GET_UNION_INFO(id, message)
    self.unionData = message
    self.level = tonumber(message.unionlevel)
    local costTbl = self:GetCostTbl()
    if costTbl then
        GUI:setVisible(self.view.CostBg, true)
        local own = SL:GetBagItemCount(costTbl[1])
        GUI:Text_setString(self.view.txtCost, string.format("<color=%s>%s</color>",
                own >= costTbl[2] and "#1BE419" or "#9b1818", costTbl[2]))
        GUI:Item_UpdataData(self.view.item, {
            ["itemid"] = costTbl[1],
        })
    else
        GUI:setVisible(self.view.CostBg, false)
    end
    self:ItemUpdateFunc()
end

function this:GetCostTbl()
    ---@type cfg_unionLevel_column
    local cfg = SL:GetConfig("cfg_unionLevel", self.level, "unionLevel")
    local costTbl
    local condTbl
    if cfg then
        if self.type == EUnionLeaderOperateType.Election then
            costTbl = cfg.cast
            condTbl = cfg.electionConditions
        elseif self.type == EUnionLeaderOperateType.Campaign then
            costTbl = cfg.campaignCast
            condTbl = cfg.campaignCondition
        elseif self.type == EUnionLeaderOperateType.Replace then
            costTbl = cfg.replaceCast
            condTbl = cfg.replaceConditions
        end
    end
    return costTbl, condTbl
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    GUI:UIPanel_Close(self.filePath)
    SL.ShowMainPanel()
end

function this:JoinOnCLick()
    if not self.level then return end
    GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionLeaderOperate/KLUnionLeaderOperatePanel",
            _, _, { type = self.type, unionLevel = self.level })
end

function this:AddOnCLick()
    local costTbl = self:GetCostTbl()
    if costTbl then
        SL:CommonItemGetPath(nil, costTbl[1])
    end
end

function this:Close()
    self:UnSchedule()
    GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionElectionVote/KLUnionElectionVotePanel")
    if self.type == EUnionLeaderOperateType.Election then
        local filePath = "dev/outui/Union/Item/KLUnionElectionReplace/KLUnionElectionReplaceItem"
        GUI:UIPanel_Close(filePath)
    elseif self.type == EUnionLeaderOperateType.Replace then
        local filePath = "dev/outui/Union/Item/KLUnionReplace/KLUnionReplaceItem"
        GUI:UIPanel_Close(filePath)
    end
end

function this:UnSchedule()
    if self.schedule then
        SL:UnSchedule(self.schedule)
    end
    self.schedule = nil
end

return this

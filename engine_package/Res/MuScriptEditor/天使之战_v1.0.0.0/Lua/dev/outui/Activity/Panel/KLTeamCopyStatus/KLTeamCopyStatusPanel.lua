---@class KLTeamCopyStatusPanel:UIKmlLuaPanelBase
---@field view KLTeamCopyStatusPanelView
---@field args KLUICommonTipsData
local KLTeamCopyStatusPanel = class(UIKmlLuaPanelBase)
local this = KLTeamCopyStatusPanel



---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLTeamCopyStatusPanel",true)
    SL:HideAllKmlPanel()
    self.team_all_item = {}
    self.teamData = {}
    GUI:DataListInitData(self.view.all_player_dl, function()
            return table.count(self.teamData)
        end, function()
        end, function()
        end, function(realIndex)
            local data = self.teamData[realIndex + 1]
            local name = GUI:GetChildControl(self.view.all_player_dl, realIndex, 'name')
            local status = GUI:GetChildControl(self.view.all_player_dl, realIndex, 'status')
            local leaderIcon = GUI:GetChildControl(self.view.all_player_dl, realIndex, 'leaderIcon')
            GUI:Text_setString(status,data.state)
            if data.isLeader or data.status == EnterLimitResultConst.ALLOW then
                GUI:setColor(status, "#1ADD1F")
            elseif data.status == EnterLimitResultConst.REFUSE or data.status == EnterLimitResultConst.CLOSED or data.status == EnterLimitResultConst.BREAK then
                GUI:setColor(status, "#FF2323")
            else
                GUI:setColor(status, "#FFFFFF")
            end
            GUI:setVisible(leaderIcon,data.isLeader)
            GUI:Text_setString(name,data.name)

        end)
    self.updateID = SL:Schedule(self.updateID, 0.1, 1, -1, function()
        self:Update()
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel")
    SL.HideMainPanel()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", self.args.configId, "id")
    if tbl.type == 10001 then
        GUI:Text_setString(self.view.title, tbl.cehua .. " 第" .. tbl.repLevel .. "广场")
    elseif tbl.type == 11001 then
        GUI:Text_setString(self.view.title, tbl.cehua .. " 第" .. tbl.repLevel .. "城堡")
    end
    self.teamData = {}
    ---@type cfg_global_column
    --local tbl = SL:GetConfig("cfg_global",220,"id")
    --tonumber(tbl.value)
    -- self:StartCountDown(30)
    self:RefreshTeamInfoList(self.args)
    self:UpdateBtn()
    
    self:RefreshCostItem()
    

    if tbl.type == EActivityType.DevilSquare then
        GUI:setPositionY(self.view.ticketModel, 0)
    else
        GUI:setPositionY(self.view.ticketModel, 0)
    end
end


---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DUPLICATE_TEAM_INFO, self.RES_DUPLICATE_TEAM_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BREAK_DUPLICATE_TEAM, self.RES_BREAK_DUPLICATE_TEAM, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER,self.LUA_EVENT_BAG_CHANGE_AFTER,self)

    GUI:AddOnClickEvent(self.view.btn_sure, self, self.OnClickSureButton)
    GUI:AddOnClickEvent(self.view.btn_Join, self, self.btn_Join)
    GUI:AddOnClickEvent(self.view.btn_cancel, self, self.OnClickCancel)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.addCountBtn2, self, self.OnCliCkAddCountBtn2)
    GUI:AddOnClickEvent(self.view.addCountBtn, self, self.OnCliCkaddCountBtn)
end

function this:OnClickCancel()
    local isLeader = false
    local rid = SL:GetMetaValue(EMetaVarGetKey.UID)
    if self.args.leaderid == rid then
        isLeader = true
    end
    if isLeader then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_TEAM_STATE, DupTeamChangeState.BREAK)
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_TEAM_STATE, DupTeamChangeState.REFUSE)
    end
    self:CloseSelf()
end

function this:CloseSelf()
    GUI:UIPanel_Close('dev/outui/Activity/Panel/KLTeamCopyStatus/KLTeamCopyStatusPanel')
    SL.ShowMainPanel()
end

function this:OnClickSureButton()
    if self.meEnterCopyState == EnterLimitResultConst.NONE then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_TEAM_STATE, DupTeamChangeState.READY)
    elseif self.meEnterCopyState ~= EnterLimitResultConst.ALLOW then
        local state = self:CheckCondition(self.meEnterCopyState)
        SL:TipMessage(state, 1, NoticeType.NoticeMid)
    end
end

function this:btn_Join()
    local isLeader = false
    local rid = SL:GetMetaValue(EMetaVarGetKey.UID)
    if self.args.leaderid == rid then
        isLeader = true
    end
    if not isLeader then
        return
    end
    if self.join_time then
        self.join_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME) -1
        GUI:SetActive(self.view.btn_sure,false)
        GUI:SetActive(self.view.btn_Join,false)
        GUI:SetActive(self.view.tip_text,true)
        GUI:SetActive(self.view.btn_cancel,false)
    end
end

function this:OnCliCkaddCountBtn()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", self.args.configId, "id")
    local cfgId , needCount = self:GetCfgIdAndNeed()
    --local need = tbl.otherItemId[2]
    --local cfgId = self:GetCfgIdAndNeed()
    SL:CommonItemGetPath(nil, cfgId)
end

function this:OnCliCkAddCountBtn2()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", self.args.configId, "id")
    local cfgId = tbl.otherItemId[1]
    SL:CommonItemGetPath(nil, cfgId)
end

function this:Close()
    if self.updateID then
        SL:UnSchedule(self.updateID)
        self.updateID = nil
    end
end


function this:Update()
    local isLeader = false
    local rid = SL:GetMetaValue(EMetaVarGetKey.UID)
    if self.args.leaderid == rid then
        isLeader = true
    end
    if self.last_time then
        local server_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local _time = self:round( (self.last_time - server_time)/ 1000)
        if _time < 0 then
            _time = 0
        end
        local str = "立即加入"
        if isLeader then
            str = "准备中"
        end
        GUI:Text_setString(self.view.btn_sure,str.."(".._time..")")
        if isLeader then
            GUI:SetActive(self.view.btn_sure,true)
            GUI:SetActive(self.view.btn_Join,false)
            GUI:SetActive(self.view.tip_text,false)
            GUI:SetActive(self.view.btn_cancel,true)
        else
            if self.meEnterCopyState == EnterLimitResultConst.ALLOW then
                GUI:SetActive(self.view.btn_sure,false)
                GUI:SetActive(self.view.btn_Join,false)
                GUI:SetActive(self.view.tip_text,true)
                GUI:SetActive(self.view.btn_cancel,false)
            else
                GUI:SetActive(self.view.btn_sure,true)
                GUI:SetActive(self.view.btn_Join,false)
                GUI:SetActive(self.view.tip_text,false)
                GUI:SetActive(self.view.btn_cancel,true)
            end
        end
        if self.last_time and _time == 0 then
            self.last_time = nil
            if not isLeader and str == "立即加入" then---立即加入未准备时间过后关闭界面
                self:CloseSelf()
            end
        end
    end
    
    if self.join_time then
        local server_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        local _time = self:round( (self.join_time - server_time)/ 1000)
        if _time < 0 then
            _time = 0
        end
        
        if isLeader then
            GUI:SetActive(self.view.btn_sure,false)
            GUI:SetActive(self.view.btn_Join,_time>=3)
            GUI:SetActive(self.view.tip_text,_time<3)
            GUI:SetActive(self.view.btn_cancel,_time>=3)
        else
            GUI:SetActive(self.view.btn_sure,false)
            GUI:SetActive(self.view.btn_Join,false)
            GUI:SetActive(self.view.tip_text,true)
            GUI:SetActive(self.view.btn_cancel,false)
        end
        GUI:Text_setString(self.view.btn_Join,"进入("..(_time-3)..")")
        if self.join_time and _time ==0 then
            self.join_time = nil
        end
    end
end

function this:round(x)
    if x >= 0 then
        return math.floor(x + 0.5)
    else
        return math.ceil(x - 0.5)
    end
end

function this:RefreshCostItem()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", self.args.configId, "id")
    local cfgId , needCount = self:GetCfgIdAndNeed()
    local ownerTicket = SL:GetBagItemCount(cfgId)
    local isMeet = needCount <= ownerTicket
    local color = isMeet and "#28E529" or "#ff2323"
    GUI:Text_setString(self.view.ticketCount,"("..GUIUtil.GetColorText(ownerTicket,color).."/"..needCount..")")
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item",cfgId,"id")
    ---@type cfg_model_charactor_column
    local modelTbl = SL:GetConfig("cfg_model_charactor",itemTbl.shape[1],"id") 
    GUI:Model_setSrc(self.view.ticketModel,modelTbl.path)


    local cfgId2 = tbl.otherItemId[1]
    local needCount2 = tbl.otherItemId[2]
    local ownerTicket2 = SL:GetBagItemCount(cfgId2)
    local isMeet2 = needCount2 <= ownerTicket2
    local color2 = isMeet2 and "#28E529" or "#ff2323"
    -- local itemTbl2 = SL:GetConfig("cfg_item",cfgId2,"id")
    -- local modelTbl2 = SL:GetConfig("cfg_model_charactor",itemTbl2.shape[1],"id")
    -- GUI:Model_setSrc(self.view.ticketModel3,modelTbl2.path)
    GUI:Item_setItemId(self.view.ticketItem, cfgId2)
    GUI:Text_setString(self.view.ticketCount3,"("..GUIUtil.GetColorText(ownerTicket2,color2).."/"..needCount2..")")
end

function this:GetCfgIdAndNeed()
    ---@type cfg_rep_column
   local tbl = SL:GetConfig("cfg_rep", self.args.configId, "id")
    local cfgId
    local need
    cfgId = tbl.itemId[1]
    need = tbl.itemId[2]
    
--[[    if not self.isOtherId then
        cfgId = tbl.itemId[1]
        need = tbl.itemId[2]
    else
        cfgId = tbl.otherItemId[1]
        need = tbl.otherItemId[2]
    end]]
    return cfgId, need
end


function this:RES_DUPLICATE_TEAM_INFO(id, message)
    self:RefreshTeamInfoList(message)
end

function this:RES_BREAK_DUPLICATE_TEAM(id, message)
    self:CloseSelf()
end

function this:LUA_EVENT_BAG_CHANGE_AFTER(id, message)
    self:RefreshCostItem()
end


function this:RefreshTeamInfoList(data)
    data = ToolFunc:tblkeytonumber(data)
    self.args = data
    self.isEnterMap = true
    self.meEnterCopyState = EnterLimitResultConst.NONE
    table.clear(self.teamData)
    local rid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    rid = tonumber(rid)
    local temp = {}
    for i, v in pairs(data.members) do
        table.insert(temp,v)
    end
    for i, v in pairs(data.members) do
        local teamInfo = {}
        teamInfo.status = v.state
        teamInfo.isLeader = data.leaderid == v.rid
        local state = self:CheckCondition(v.state,teamInfo.isLeader)
        teamInfo.select = not state
        if not state then
            state = "<color=#28E529>准备就绪</color>"
        end
        teamInfo.state = state
        teamInfo.name = v.name
        teamInfo.career = tonumber(v.career)
        table.insert(self.teamData, teamInfo)
        if rid == v.rid then
            self.meEnterCopyState = v.state
        end
    end

    -- if self.isEnterMap then
    --     self.last_time = 30
    --     self.join_time = 5
    -- end
    local server_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    local time = math.floor( server_time/ 1000)

    local isMeet = data.leaderid == rid
    -- GUI:setVisible(self.view.Btcanel, not isMeet)
    -- GUI:setVisible(self.view.BtnDissolve, isMeet)
    -- GUI:setVisible(self.view.Btnok, not isMeet)
    self:UpdateBtn()
    GUI:DataListUpdateData(self.view.all_player_dl)
end

function this:UpdateBtn()
    if self.args.state == 1 then
        local server_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        -- self.last_time = math.floor( (self.args.endtime - server_time)/ 1000)
        self.last_time = self.args.endtime
        self.join_time = nil
    else
        local server_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        -- self.join_time = math.floor( (self.args.endtime - server_time)/ 1000)
        self.join_time = self.args.endtime
        self.last_time = nil
    end
    local isLeader = false
    local rid = SL:GetMetaValue(EMetaVarGetKey.UID)
    if self.args.leaderid == rid then
        isLeader = true
    end
    if isLeader then
        GUI:SetActive(self.view.scrollview_playerlist,true)
        GUI:SetActive(self.view.cost_1,false)
        GUI:SetActive(self.view.cost_2,false)
    else
        GUI:SetActive(self.view.scrollview_playerlist,false)
        GUI:SetActive(self.view.cost_1,true)
        GUI:SetActive(self.view.cost_2,true)
    end
end

function this:CheckCondition(state,isLeader)
    if isLeader then
        return "准备就绪"
    end
--[[     if state == EnterLimitResultConst.LEVEL then
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
    end]]
    if state == EnterLimitResultConst.NONE then
        return "未准备"
    end
    if state == EnterLimitResultConst.ALLOW then
        return "准备就绪"
    end
    if state == EnterLimitResultConst.REFUSE or state == EnterLimitResultConst.CLOSED or state == EnterLimitResultConst.BREAK then
        return "拒绝"
    end
    return
end

return this

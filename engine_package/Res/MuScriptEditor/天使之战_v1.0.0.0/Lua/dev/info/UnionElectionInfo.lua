---@class UnionElectionInfo
UnionElectionInfo = class()
local this = UnionElectionInfo

---@class UnionProto.UnionInfo
---@field unionId number @行会id
---@field unionName string @行会名字
---@field unionLevel number @行会等级
---@field unionExp number @行会经验
---@field unionCapital number @ 行会资金
---@field grade string @战盟评分
---@field announcement string @招募公告
---@field unionArmband number @行会臂章
---@field leaderOnTime number @盟主上位时间
---@field unionMemberInfo UnionProto.UnionMemberInfo[] @成员信息

---@class UnionProto.UnionMemberInfo
---@field name string @名称
---@field memberId number @成员id
---@field level number @等级
---@field position number @1表示盟主，2表示副盟主，3表示战斗队长，4表示精英，5表示成员
---@field onlineState number @1表示在线，0表示不在线
---@field time number @离线时间
---@field fightValue number @ 战力
---@field devote number @  贡献值
---@field career number @需要职业  战士1 法师2 弓箭手3

---@class UnionProto.ViewUnionRes
---@field unionInfo UnionProto.UnionInfo

function this:ctor()
end

function this:Reset()
    self.electionData = nil
    self.replaceData = nil
    self.campaignData = nil
    self.activityOpenMap = nil
    self.taskrecord = nil
    self.unionFinishList = nil
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
    --竞选与取代
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_RUN_FOR_LEADER_DATA , self.RES_UNION_RUN_FOR_LEADER_DATA , self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PLAYER_RUN_FOR_LEADER_VOTE, self.RES_PLAYER_RUN_FOR_LEADER_VOTE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PLAYER_RUN_FOR_LEADER, self.RES_PLAYER_RUN_FOR_LEADER, self)
    --弹劾
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SEND_UNION_IMPEACH_INFO, self.RES_SEND_UNION_IMPEACH_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_IMPEACH_LEADER, self.RES_UNION_IMPEACH_LEADER, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_IMPEACH_VOTE, self.RES_UNION_IMPEACH_VOTE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_UNION_INFO, self.RES_GET_UNION_INFO, self)
    --活动
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_DAILY_ACTIVITY_ACTIVITY_LIST, self.GET_DAILY_ACTIVITY_ACTIVITY_LIST, self)
    --战盟任务
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_TASK_DATA,self.ResUnionTaskData, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_TASK_CHANGE,self.RES_UNION_TASK_CHANGE, self)
    
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SUBMIT_UNION_TASK,self.RES_SUBMIT_UNION_TASK, self)
    
    SL:RegisterLUAEvent(LUA_EVENT_ENTER_MAP, self.LUA_EVENT_ENTER_MAP, self) 

end

function this:RES_UNION_TASK_CHANGE(_,message)
    self.taskrecord = self.taskrecord or {}
    self.unionFinishList = self.unionFinishList or {}
    for index, unionTaskInfo in pairs(message) do
        self.taskrecord[index] = unionTaskInfo
    end
    SL:RefreshPanelALLRedStateKmlByCondition("checkUnionTask")
end

function this:LUA_EVENT_ENTER_MAP()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_TASK_DATA)
end

function this:RES_SUBMIT_UNION_TASK()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_TASK_DATA)
end

function this:ResUnionTaskData(_, message)
    self.taskrecord = message.taskrecord
    self.unionFinishList = message.memberrecord
    SL:RefreshPanelALLRedStateKmlByCondition("checkUnionTask")
end

function this:IsHasTaskRedDot()
    self.taskrecord = self.taskrecord or {}
    self.unionFinishList = self.unionFinishList or {}
    for _, unionTaskInfo in pairs(self.taskrecord) do
        if not table.contains(self.unionFinishList, unionTaskInfo.taskid) then
            local taskCfg = SL:GetConfig('cfg_gard_task', unionTaskInfo.taskid)
            if taskCfg.taskContent[#taskCfg.taskContent] == unionTaskInfo.taskcount then
                return true
            end
        end
        
    end
    return false
end

---@param data DailyActivityActivity[]
function this:GET_DAILY_ACTIVITY_ACTIVITY_LIST(_,data)
    ---@type table<number,boolean>
    self.activityOpenMap = self.activityOpenMap or {}
    for _, v in pairs(data) do
        self.activityOpenMap[v.activityid] = v.open
    end
end

function this:RES_GET_UNION_INFO(_, message)
    self.MyUnionInfo = message
end

--更新竞选数据
function this:RES_UNION_RUN_FOR_LEADER_DATA(id, data)
    if data.isreplace == nil then
        self.electionData = nil
        self.replaceData = nil
    else
        if data.isreplace == false then
            self.electionData = data
        else
            self.replaceData = data
        end
    end
    SL:onLUAEvent(LUA_EVENT_ELECTION_DATA_CHANGE, data.isreplace)
end
--更新投票数据
function this:RES_PLAYER_RUN_FOR_LEADER_VOTE(id, data)
    local rid = tostring(data["1"])
    local ticket = data["2"]
    local dataList = self:GetElectionDataList()
    if dataList then
        if dataList[rid] then
            dataList[rid].count = dataList[rid].count + ticket
        else
            dataList[rid] = {}
            dataList[rid].count = ticket
        end
        SL:onLUAEvent(LUA_EVENT_ELECTION_DATA_CHANGE, false)
    end
end
--发起竞选/取代成功后跳转对应功能
function this:RES_PLAYER_RUN_FOR_LEADER(id, message)
    if message == 2 or message == "2" then
        SL:onLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, "replaceToggle")
    else
        SL:onLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, "electionToggle")
    end
end

--更新战盟弹劾数据
function this:RES_SEND_UNION_IMPEACH_INFO(id, message)
    self.campaignData = message
    SL:onLUAEvent(LUA_EVENT_UNION_CAMPAIGN_DATA)
end
--发起弹劾盟主成功后跳转弹劾页面
function this:RES_UNION_IMPEACH_LEADER(id, message)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_IMPEACH_INFO)
    SL:onLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, "campaignToggle")
end
--弹劾盟主投票数据变化
function this:RES_UNION_IMPEACH_VOTE(id, message)
    if self.campaignData then
        if tonumber(message) == 1 then
            if not self.campaignData.agreelist then
                self.campaignData.agreelist = {}
            end
            table.insert(self.campaignData.agreelist, 1)
        else
            if not self.campaignData.disagreelist then
                self.campaignData.disagreelist = {}
            end
            table.insert(self.campaignData.disagreelist, 1)
        end
    end
    SL:onLUAEvent(LUA_EVENT_UNION_CAMPAIGN_VOTE_CHANGE)
end

--竞选人列表
function this:GetElectionDataList()
    if self.electionData and self.electionData.ridlist and next(self.electionData.ridlist) then
        if self.MyUnionInfo and self.MyUnionInfo.memberinfos then
            local list = {}
            for i, v in pairs(self.electionData.ridlist) do
                if self.MyUnionInfo.memberinfos[i] then
                    list[i] = v
                end
            end
            return list
        end
        return nil
    else
        return nil
    end
end
--竞选结束时间
function this:GetElectionEndTime()
    return self.electionData and self.electionData.endtime or nil
end
--取代人列表
function this:GetReplaceDataList()
    if self.replaceData and self.replaceData.ridlist and next(self.replaceData.ridlist) then
        if self.MyUnionInfo and self.MyUnionInfo.memberinfos then
            local list = {}
            for i, v in pairs(self.replaceData.ridlist) do
                if self.MyUnionInfo.memberinfos[i] then
                    list[i] = v
                end
            end
            return list
        end
        return nil
    else
        return nil
    end
end
--取代结束时间
function this:GetReplaceEndTime()
    return self.replaceData and self.replaceData.endtime or nil
end
--获取弹劾数据
function this:GetCampaignData()
    return self.campaignData
end
--获取弹劾赞成的票数
function this:GetCampaignAgreeNum()
    return self.campaignData and table.count(self.campaignData.agreelist) or 0
end
--获取弹劾反对的票数
function this:GetCampaignOpposeNum()
    return self.campaignData and table.count(self.campaignData.disagreelist) or 0
end
--取代结束时间
function this:GetCampaignEndTime()
    return self.campaignData and self.campaignData.endtime or nil
end

--获取加入战盟的时间(分钟)
function this:GetJoinUnionTime()
    if table.isNullOrEmpty(self.MyUnionInfo) then
        return 0
    end
    for id, info in pairs(self.MyUnionInfo.memberinfos) do
        if id == tostring(SL:MeData_GetId()) then
            local time = (Time.GetServerTime() - tonumber(info.jointime)) // 1000
            return time//60
        end
    end
    return 0
end

--单位毫秒
function this.FormatTimeStr(time)
    time = time // 1000
    local s = time % 60
    local m = time // 60 % 60
    local h = time // 3600 % 24
    return string.format("%d时%d分%d秒", h, m, s);
end

--当前战盟BOSS,攻城战，狼魂要塞是否开启
function this:UnionActivityIsOpen()
    for i, id in pairs(E_UnionActivty) do
        if self.activityOpenMap[id] then
            return true
        end
    end
    return false
end

--获取当前职位的权限信息
---@return cfg_unionmember_column
function this:GetSelfPermissionCfg()
    if self.MyUnionInfo then
        for id, info in pairs(self.MyUnionInfo.memberinfos) do
            if id == tostring(SL:MeData_GetId()) then
                if SL:HasConfig("cfg_unionmember",tonumber(info.position)) then
                    ---@type cfg_unionmember_column
                    return SL:GetConfig("cfg_unionmember",tonumber(info.position))
                else
                    return nil
                end
            end
        end
    end
    return nil
end

--通过成员信息获取职位的权限信息
---@return cfg_unionmember_column
function this:GetPermissionCfgByInfo(info)
    if self.MyUnionInfo then
        ---@type cfg_unionmember_column
        return SL:GetConfig("cfg_unionmember",info.position)
    end
    return nil
end 
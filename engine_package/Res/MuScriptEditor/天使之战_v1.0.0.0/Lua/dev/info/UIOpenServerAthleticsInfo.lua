---@class UIOpenServerAthleticsInfo @注释
---@field openSerCompetitionTbl cfg_openSerCompetition_column[]
UIOpenServerAthleticsInfo = class()
local this = UIOpenServerAthleticsInfo

function this:ctor()

end

function this:Init()
    self.openSerCompetitionTbl = SL:GetConfigTable("cfg_openSerCompetition")
    table.sort(self.openSerCompetitionTbl,function(a, b) 
        return a.order < b.order
    end)
    self.openSerCompetitionTypeTbl={}
    for _,v in pairs(self.openSerCompetitionTbl) do
        self.openSerCompetitionTypeTbl[v.type] = v
    end
    self.openSerCompetitionRankTbl = SL:GetConfigTable("cfg_openSerCompetition_rank")
    self.openSerCompetitionChallengeTbl = SL:GetConfigTable("cfg_openSerCompetition_challenge")
    self.openSerCompetitionGiftTbl = SL:GetConfigTable("cfg_openSerCompetition_gift")
    ---@type cfg_openSerCompetition_rank_column
    self.openSerCompetitionRankTblGroup = {}
    for _, v in pairs(self.openSerCompetitionRankTbl) do
        if not self.openSerCompetitionRankTblGroup[v.rankGroup] then
            self.openSerCompetitionRankTblGroup[v.rankGroup] = {}
        end
        if not self.openSerCompetitionRankTblGroup[v.rankGroup][v.rank] then
            self.openSerCompetitionRankTblGroup[v.rankGroup][v.rank] = {}
        end
        self.openSerCompetitionRankTblGroup[v.rankGroup][v.rank] = v
    end
    ----------------------------------------------------------------------
    ---@type cfg_openSerCompetition_challenge_column
    self.openSerCompetitionChallengeTblGroup = {}
    for _, v in pairs(self.openSerCompetitionChallengeTbl) do
        if not self.openSerCompetitionChallengeTblGroup[v.challengeGroup] then
            self.openSerCompetitionChallengeTblGroup[v.challengeGroup] = {}
        end
        table.insert(self.openSerCompetitionChallengeTblGroup[v.challengeGroup],v)
    end
    --------------------------------------------------------------------
    self.openSerCompetitionGiftTblGroup = {}
    self:Reset()
    self:InitData()
    self:RegistMessages()
end

function this:Reset()
    self.RankDataList = {} ---排行
    self.PersonDataList = {} --个人积分
end
function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_COMPETITION_RANK_INFO, self.RES_COMPETITION_RANK_INFO, self)-- 响应开服竞技排行信息
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SINGLE_CHALLENGE_INFO, self.RES_SINGLE_CHALLENGE_INFO, self)-- 响应开服竞技个人挑战领取信息
    --SL:RegisterLUAEvent(LUA_OPEN_SERVER_GIFT_COUNT_CHANGE, self.LUA_OPEN_SERVER_GIFT_COUNT_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE, self.InitGiftTblData, self)
    SL:RegisterLUAEvent(LUA_EVENT_CAREER_CHANGED, self.InitGiftTblData, self)
end
function this:InitGiftTblData()
    local careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)
    self.openSerCompetitionGiftTblGroup = {}
    if not careerId then return false end
    local index = 1
    if self.openSerCompetitionTbl then
        for _, Tbl in pairs(self.openSerCompetitionTbl) do
            for _,gift in pairs(Tbl.gift) do
                if gift[1] == careerId or gift[1] == 0 then
                    for i, id in pairs(gift) do
                        if i ~= 1 then
                            local data = SL:GetConfig("cfg_openSerCompetition_gift", id)
                            if not self.openSerCompetitionGiftTblGroup[Tbl.type] then
                                self.openSerCompetitionGiftTblGroup[Tbl.type] = {}
                            end
                            self.openSerCompetitionGiftTblGroup[Tbl.type][index] = data
                            index = index + 1
                        end
                    end
                end
            end
        end
    end
end
function this:RES_COMPETITION_RANK_INFO(_, message)
    if message then
        self.RankDataList[message.type] = message
        SL:onLUAEvent(LUA_EVENT_COMPETITION_RANK_CHANGE, message.type)
    end
end
function this:RES_SINGLE_CHALLENGE_INFO(_, message)
    if message then
        self.PersonDataList[message.type] = message
        SL:onLUAEvent(LUA_EVENT_SINGLE_CHALLENGE_CHANGE, message.type)
        SL:RefreshPanelALLRedStateKmlByCondition("KLUISystemTopPanel")
    end
end
function this:GetOpenSerCompetitionTblDataByType(type)
    for _, v in pairs(self.openSerCompetitionTbl)do
        if v.type == type then
            return v
        end
    end
    return nil
end

function this:FindRankTblByType(type)
    local rankGroup = 1
    for _, v in pairs(self.openSerCompetitionTbl) do
        if v.type == type then
            rankGroup = v.rankGroup
        end
    end
    return rankGroup
end
function this:FindChallengeTblByType(type)
    local challengeGroup = 1
    for _, v in pairs(self.openSerCompetitionTbl) do
        if v.type == type then
            challengeGroup = v.challengeGroup
        end
    end
    return challengeGroup
end
function this:ShowBtnCondition()
    local ShowTypeList= {}
    for i,v in pairs(self.openSerCompetitionTbl) do
        local showCondition = v.showCondition
        local activityCondition = v.activityCondition
        local nextShowCondition = "false"
        if self.openSerCompetitionTbl[i + 1] then
            nextShowCondition = self.openSerCompetitionTbl[i + 1].showCondition
        end
        if showCondition == "" or ConditionManager.Check4D(showCondition) then
            if activityCondition == "" or ConditionManager.Check4D(activityCondition) then
                table.insert(ShowTypeList,v)
            end
        end
    end
    return ShowTypeList
end
function this:IsShowPersonAwardRed()
    local IsShow =false
    if table.isNullOrEmpty(self.PersonDataList) then return IsShow end
    local ShowTypeList = self:ShowBtnCondition()
    for _,Btn in pairs(ShowTypeList) do
        for _,v in pairs(self.PersonDataList) do
            if tonumber(v.type) == tonumber(Btn.type) then
                for _,ChallengeTbl in pairs(self.openSerCompetitionChallengeTblGroup[tonumber(v.type)]) do
                    if v.num >= ChallengeTbl.typeDemandValue then
                        IsShow= true
                        for key, item in pairs(v.challengeAwardInfo) do
                            if ChallengeTbl.id == tonumber(key) then
                                IsShow= false
                            end
                        end
                        if IsShow == true then
                            return IsShow
                        end
                    end
                end
            end
        end
    end
    return IsShow
end
function this:IsShowGiftRed()
    local IsShow =false
    local ShowTypeList = self:ShowBtnCondition()
    for _,Btn in pairs(ShowTypeList) do
        if not table.isNullOrEmpty(self.openSerCompetitionGiftTblGroup) then
            for _, Tbl in pairs(self.openSerCompetitionGiftTblGroup[Btn.type]) do
                local buycount, totalcount = InfoManager.countInfo:GetLimitAndTotalCountByKey(Tbl.count)
                if buycount > 0 then
                    if Tbl.buyConsume[2] == 0 then
                        IsShow= true
                        return IsShow
                    end
                end
            end
        end
    end
    return IsShow
end

function this:IsShowPersonAwardRedBtn(index)
    local IsShow =false
    if table.isNullOrEmpty(self.PersonDataList) then return IsShow end
    local ShowTypeList = self:ShowBtnCondition()
    for _,Btn in pairs(ShowTypeList) do
        for _,v in pairs(self.PersonDataList) do
            if tonumber(v.type) == Btn.type then
                if tonumber(v.type) == index then
                    for _,ChallengeTbl in pairs(self.openSerCompetitionChallengeTblGroup[index]) do
                        if v.num >= ChallengeTbl.typeDemandValue then
                            IsShow= true
                            for key, item in pairs(v.challengeAwardInfo) do
                                if ChallengeTbl.id == tonumber(key) then
                                    IsShow= false
                                end
                            end
                            if IsShow == true then
                                return IsShow
                            end
                        end
                    end
                end
            end
        end
    end
    return IsShow
end
function this:IsShowGiftRedBtn(index)
    local IsShow =false
    local ShowTypeList = self:ShowBtnCondition()
    for _,Btn in pairs(ShowTypeList) do
        if Btn.type == index then
            if not table.isNullOrEmpty(self.openSerCompetitionGiftTblGroup) then
                for _, Tbl in pairs(self.openSerCompetitionGiftTblGroup[Btn.type]) do
                    local buycount, totalcount = InfoManager.countInfo:GetLimitAndTotalCountByKey(Tbl.count)
                    if buycount > 0 then
                        if Tbl.buyConsume[2] == 0 then
                            IsShow= true
                            return IsShow
                        end
                    end
                end
            end
        end
    end
    return IsShow
end
function this:IsShowRed()
    if self:IsShowPersonAwardRed() or self:IsShowGiftRed() then
        return  true
    end
    return  false
end








---@class UIOpenServerInfo
UIOpenServerInfo = class()
local this = UIOpenServerInfo

function this:ctor()

end

function this:Reset()
    --self.isFirst=false
    --self.purchasedIds={}
end

function this:Init()
    --self.multiplierInfo={}  --经验倍率信息
    --self.vipCfg = nil
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.OPEN_SERVER_ACT_REWARD_CHANGE, self.ResUpdateRankingInfo)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.OPEN_SERVER_ACT_TYPE_RANK_INFO, self.ResUpdateOPENRankInfo)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.OPEN_SERVER_ACT_RANK_CHANGE, self.ResUpdatePersonalRankInfo)

    --self.messageContainer:Regist(MessageDef.ResEfficiencyMagnificationMessage, self.ResEfficiencyMagnificationMessage, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OPEN_SERVER_FIRST_KILL_INFO, self.ResFirstkillInfo)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GLOBAL_FIRST_KILL_CHANGE, self.ResBosskillChange)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PERSONAL_FIRST_KILL_CHANGE, self.ResPalerBosskillInfo)
end

---追加强化排行榜
function this.ResUpdateOPENRankInfo(id,data)
    this.rankInfo = data
end
--排行奖励
function this.ResUpdateRankingInfo(id,data)
    local myrid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    if this.rankInfo and data.rankType == this.rankInfo.rank_type then
        local changedata = data.awardData
        local rankinfo = nil
        if changedata.award_type == 0 then
            this:ResUpdateRankingAndPersonalInfo(data)
        else
            if changedata.award_type == 1 and this.rankInfo.rank_list and this.rankInfo.rank_list.award_rank then
                rankinfo = this.rankInfo.rank_list.award_rank
            end
            if changedata.award_type == 2 and this.rankInfo.rank_list and this.rankInfo.rank_list.personal_rank then
                rankinfo = this.rankInfo.rank_list.personal_rank
            end
            if changedata and table.count(changedata) > 0 and rankinfo and table.count(rankinfo) > 0 then
                if table.getValue(rankinfo,tostring(data.goalValue)) then
                    local taskTypeData = table.getValue(rankinfo,tostring(data.goalValue))
                    if changedata.data and changedata.data.status then
                        if taskTypeData and table.count(taskTypeData) > 0 then
                            if changedata.award_type == 1 then
                                for k, j in pairs(taskTypeData) do
                                    if j.rank_no == changedata.data.rank_no then
                                        j.status = changedata.data.status
                                    end
                                end
                            end
                            if changedata.award_type == 2 then
                                if taskTypeData.my_info.rank == changedata.data.rank then
                                    taskTypeData.my_info.status = changedata.data.status
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

---竞技领取排行和个人，刷新数据
function this:ResUpdateRankingAndPersonalInfo(data)
    local changedata = data.awardData
    local rankinfo = nil
    local Personalinfo = nil
    if this.rankInfo.rank_list and this.rankInfo.rank_list.award_rank then
        rankinfo = this.rankInfo.rank_list.award_rank
    end
    if this.rankInfo.rank_list and this.rankInfo.rank_list.personal_rank then
        Personalinfo = this.rankInfo.rank_list.personal_rank
    end
    if changedata and table.count(changedata) > 0 and rankinfo and table.count(rankinfo) > 0 then
        if table.getValue(rankinfo,tostring(data.goalValue)) then
            local taskTypeData = table.getValue(rankinfo,tostring(data.goalValue))
            local updatedata = nil
            if changedata.data and changedata.data.rank then
                updatedata = changedata.data.rank
            end
            if updatedata and updatedata.status then
                if taskTypeData and table.count(taskTypeData) > 0 then
                    for k, j in pairs(taskTypeData) do
                        if j.rank_no == updatedata.rank_no then
                            j.status = updatedata.status
                        end
                    end
                end
            end
        end
    end
    if changedata and table.count(changedata) > 0 and Personalinfo and table.count(Personalinfo) > 0 then
        if table.getValue(Personalinfo,tostring(data.goalValue)) then
            local taskTypeData = table.getValue(Personalinfo,tostring(data.goalValue))
            local updatedata = nil
            if changedata.data and changedata.data.personal then
                updatedata = changedata.data.personal
            end
            if updatedata and updatedata.status then
                if taskTypeData and table.count(taskTypeData) > 0 then
                    if taskTypeData.my_info.rank == updatedata.rank then
                        taskTypeData.my_info.status = updatedata.status
                    end
                end
            end
        end
    end
end




--个人奖励
function this.ResUpdatePersonalRankInfo(id,data)
    local rankinfo = nil
    local myrid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    --if this.rankInfo and data.rankType == this.rankInfo.rank_type then
    --    local changedata = data.goalChange.personal_rank_record
    --    if this.rankInfo.rank_list and this.rankInfo.rank_list.personal_rank then
    --        rankinfo = this.rankInfo.rank_list.personal_rank
    --    end
    --    if changedata and table.count(changedata) > 0 and rankinfo and table.count(rankinfo) > 0 then
    --        for k, v in pairs(rankinfo) do
    --            local personalData = table.getValue(changedata,tostring(k))
    --            if personalData then
    --                v.my_info = personalData.goal_info
    --                v.rank_size = personalData.rank_size
    --            end
    --
    --        end
    --    end
    --end
end

---------------------------------------装备首曝-----------------------------------------------
---获取对应的状态和数量
function this:GetRankAndNumByType(taskType,allnum)
    local myrid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    local dataLv = nil
    local my_rank = 0
    local my_state = 0  ---个人奖励状态
    local usecount = 0  ---使用数量
    if this.rankInfo and this.rankInfo.rank_list and this.rankInfo.rank_list.personal_rank then
        local ranklist = this.rankInfo.rank_list.personal_rank
        if ranklist and taskType then
            dataLv = table.getValue(ranklist,tostring(taskType))
        end
        --local name,serstate,rid = this:GetRankNameBySort(taskType,1)
        if dataLv and table.count(dataLv) > 0 then
            usecount = dataLv.rank_size
            if dataLv.my_info then
                my_state = dataLv.my_info.status
                my_rank = dataLv.my_info.rank
                --if myrid == tostring(rid) then
                --    my_state = dataLv.my_info.status
                --    my_rank = dataLv.my_info.rank
                --else
                --    if dataLv.my_info.status >= 1 then
                --        my_state = 2
                --    end
                --    my_rank = dataLv.my_info.rank
                --end
            else
                if usecount >= allnum then
                    my_state = 2
                end
            end
        end
    end
    return my_state,usecount,my_rank

end


--------------------------------------竞技排行----------------------------------------------------------
---等级竞技排行获取对应排行名称和状态
--类型1 只获取自己的状态
function this:GetRankNameBySort(taskType,sort,type)
    local myrid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    local rankinfo = nil
    local name = "无"
    local state = 0
    local rid = nil
    if this.rankInfo and this.rankInfo.rank_list and this.rankInfo.rank_list.award_rank then
        local award_rank = this.rankInfo.rank_list.award_rank
        if award_rank and taskType then
            rankinfo = table.getValue(award_rank,tostring(taskType))
        end
        if rankinfo and table.count(rankinfo) > 0 then
            for i, v in pairs(rankinfo) do
                if v.rank_no == sort then
                    name = v.name
                    rid = v.rid
                    if type == 1 then
                        if myrid == tostring(v.rid) then
                            state = v.status
                        end
                    else
                        if myrid == tostring(v.rid) then
                            state = v.status
                        else
                            if v.status >= 1 then
                                state = 2
                            end
                        end
                    end
                end
            end
        end
    end
    return name,state,rid
end

---竞技叠加数据根据taskType 获取最新排名数据
--function this:GetAthleticsUnGetMinSortData(data_list,data_type,minTasktype)
--    local curnextType = nil
--    local retdata = {} ---对应类型 ,排序
--    ---初始默认排序数据
--    if data_list and table.count(data_list) > 0 then
--        for i, v in pairs(data_list) do
--            if i == minTasktype then
--                for k, j in pairs(v) do
--                    table.insert(retdata,{tasktype = i,sort = j.sort })
--                end
--            end
--        end
--    end
--    ---最新未领取排序
--    if retdata and table.count(retdata) > 0 then
--        for i, v in pairs(retdata) do
--            for k, j in pairs(data_type) do
--                local curnextType = this:GetNextTaskType(data_type,v.tasktype)
--                if curnextType then
--                    local nextType = this:GetMinNextType(v.tasktype,v.sort,curnextType)
--                    v.tasktype = nextType
--                end
--            end
--
--        end
--    end
--    return retdata
--end
---获取表里下一类型
--function this:GetNextTaskType(data_type,curtaskType)
--    local curnextType = nil
--    if data_type and table.count(data_type) > 0 then
--        local maxtype = data_type[#data_type].taskType
--        for i, v in pairs(data_type) do
--            if v.taskType > curtaskType and v.taskType - curtaskType < maxtype then
--                maxtype = v.taskType - curtaskType
--                curnextType = v.taskType
--            end
--        end
--    end
--    return curnextType
--end
---获取后端未领取下一类型
--function this:GetMinNextType(tasktype,sort,curnextType)
--    local nextType = tasktype
--    local ranklist = {}
--    if this.rankInfo and this.rankInfo.rank_list and this.rankInfo.rank_list.award_rank then
--        ranklist = this.rankInfo.rank_list.award_rank
--    end
--    if ranklist and table.count(ranklist) > 0 then
--        local datatype = table.getValue(ranklist,tostring(tasktype))
--        if datatype and table.count(datatype) > 0 then
--            if table.getValue(datatype,tostring(sort)) then
--                local sortdata = table.getValue(datatype,tostring(sort))
--                if sortdata.status == 2 then
--                    ---已领取，获取下一等级
--                    nextType = curnextType
--                end
--            end
--        end
--    end
--    return nextType
--end


---个人奖励未领取且有次数的最小taskType
function this:GetUnGetMinlimiteLv(maxlimiteLv,mixlimiteLv,personal_list)
    local limiteLv = maxlimiteLv
    local sortrank = 0  --排行
    local mystatus = 0  --状态
    local usecount = 0  --使用次数
    local Arr = {}
    if personal_list and table.count(personal_list) > 0 then
        for i, v in pairs(personal_list) do
            local Lvtype = v.taskType[1]
            local allnum = v.taskType[2]
            local ranklist = this.rankInfo.rank_list.personal_rank
            local my_state = 0
            local my_rank = 0
            local isExtrank_list = true
            if table.getValue(ranklist,tostring(Lvtype)) then
                local dataLv = table.getValue(ranklist,tostring(Lvtype))
                if dataLv then
                    usecount = dataLv.rank_size
                    if dataLv.my_info then
                        my_state = dataLv.my_info.status
                        my_rank = dataLv.my_info.rank
                    else
                        if usecount >= allnum then
                            my_state = 2
                        end
                    end

                end
                if my_state == 2 then
                    isExtrank_list = false   ---不可领取 或已领取
                end
            end
            table.insert(Arr,{typeLv = Lvtype,isExt = isExtrank_list,state = my_state,rank = my_rank,count = usecount })
        end
    end

    if Arr and table.count(Arr) > 0 then
        table.sort(Arr, function(a, b)
            return a.typeLv < b.typeLv
        end)
        local iscanget = true
        for i, v in pairs(Arr) do
            if v.isExt and v.typeLv <= limiteLv then
                limiteLv = v.typeLv
                usecount = v.count
                mystatus = v.state
                sortrank = v.rank
                iscanget = false
            elseif not v.isExt and v.typeLv == maxlimiteLv and iscanget then
                limiteLv = maxlimiteLv
                usecount = v.count
                mystatus = v.state
                sortrank = v.rank
            end
        end
    end
    return limiteLv,mystatus,sortrank,usecount
end


------------------------------------------------追加强化------------------------------------------------------------------------
---根据任务类型获取前三名称和状态 type:1 名称  2 状态
function this:GetRankNameBytaskType(taskType,type)
    local rankinfo = nil
    local myrid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    local fist_name = "无"
    local second_name = "无"
    local third_name = "无"
    local fist_state = 0
    local second_state = 0
    local third_state = 0
    if this.rankInfo and this.rankInfo.rank_list and this.rankInfo.rank_list.award_rank then
        local award_rank = this.rankInfo.rank_list.award_rank
        if award_rank and taskType then
            rankinfo = table.getValue(award_rank,tostring(taskType))
        end
        if rankinfo and table.count(rankinfo) > 0 then
            ---前三排行
            for i, v in pairs(rankinfo) do
                if v.rank_no == 1 then
                    fist_name = v.name
                    if myrid == tostring(v.rid) then
                        fist_state = v.status
                    elseif myrid ~= tostring(v.rid) and v.status >= 1 then
                        fist_state = 2
                    end
                elseif v.rank_no == 2 then
                    second_name = v.name
                    if myrid == tostring(v.rid) then
                        second_state = v.status
                    elseif myrid ~= tostring(v.rid) and v.status >= 1 then
                        second_state = 2
                    end
                elseif v.rank_no == 3 then
                    third_name = v.name
                    if myrid == tostring(v.rid) then
                        third_state = v.status
                    elseif myrid ~= tostring(v.rid) and v.status >= 1 then
                        third_state = 2
                    end
                end
            end
        end
    end
    if type==1 then
        return fist_name,second_name,third_name
    elseif type==2 then
        return fist_state,second_state,third_state
    end
end

---获取总次数
function this:GetAllCountlimite(ranking_id,limiteLv)
    local cfg = SL:FindConfigs("cfg_newarea_ranking","id",ranking_id)
    local reward_list = SL:FindConfigs("cfg_newarea_personalreward","group",cfg[1].subtype)
    local allnum = 0
    local data = nil
    for i, v in pairs(reward_list) do
        if v.taskType[1] == limiteLv then
            allnum = v.taskType[2]
            data = v
        end
    end
    return allnum,data
end

-----------------------------------------------------------------------------------------
---全服和个人首杀信息
function this.ResFirstkillInfo(id,data)
    this.firstkillinfo = data
end

---全服首杀变化
function this.ResBosskillChange(id,data)
    local killids = {}
    if data and table.count(data) > 0 then
        if this.firstkillinfo and data.group then
            killids = table.getValue(this.firstkillinfo.global,tostring(data.group))
        end
    end
    if killids and data.monsterCfgId and table.getValue(killids,tostring(data.monsterCfgId)) then
        killids[tostring(data.monsterCfgId)] = data.killInfo
    end
end

---个人首杀变化
function this.ResPalerBosskillInfo(id,data)
    local killids = {}
    if data and table.count(data) > 0 then
        if this.firstkillinfo and data.group then
            killids = table.getValue(this.firstkillinfo.personal,tostring(data.group))
        end
    end
    if killids and data.monsterCfgId and table.getValue(killids,tostring(data.monsterCfgId)) then
        killids[tostring(data.monsterCfgId)] = data.status
    end
end

---根据组和id 获取个人领取状态
function this:GetNomStateByBossInfo(boss_group,boss_id)
    local state = 0  ---奖励领取状态：0 正常 1 可领取 2 已领取
    local killids = nil  ---同组id
    local firstkillinfo = this.firstkillinfo
    if firstkillinfo and boss_group then
        killids = table.getValue(firstkillinfo.personal,tostring(boss_group))
    end
    if killids and boss_id and table.getValue(killids,tostring(boss_id)) then
        state = table.getValue(killids,tostring(boss_id))  --1 可领取  2 已领取
    end
    return state
end

---根据组和id 获取全服首杀领取状态
---type=1 or nil 状态  type=2 name  type=3 使用数量
function this:GetSerStateOrNameByBossInfo(boss_group,boss_id,type)
    local myrid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    local personal_count = 0  ---使用次数
    local hurt_name = "无"
    local kill_name = "无"
    local hurt_state = 0  ---奖励领取状态：0 正常 1 可领取 2 已领取
    local kill_state = 0  ---奖励领取状态：0 正常 1 可领取 2 已领取
    local killids = nil  ---同组id
    local firstkillinfo = this.firstkillinfo
    if firstkillinfo and boss_group then
        killids = table.getValue(firstkillinfo.global,tostring(boss_group))
    end
    if killids and boss_id and table.getValue(killids,tostring(boss_id)) then
        local data = table.getValue(killids,tostring(boss_id))  ---伤害信息
        personal_count = data.personal_count
        for i, v in pairs(data) do
            if i == "hurt" then
                hurt_name = v.name
                if myrid == tostring(v.rid) then
                    hurt_state = v.status
                else
                    if v.status >= 1 then
                        hurt_state = 2
                    end
                end
            elseif i == "kill" then
                kill_name = v.name
                if myrid == tostring(v.rid) then
                    kill_state = v.status
                else
                    if v.status >= 1 then
                        kill_state = 2
                    end
                end
            end
        end
    end
    if type and type == 2 then
        return hurt_name,kill_name
    elseif type and type == 3 then
        return personal_count
    else
        return hurt_state,kill_state
    end
end


-------------------------------------------------------------------
---活动结束倒计时
function this:GetLeftTimeByRankingId(ranking_id)
    local lefttime = 0
    local serverTime = Time.GetServerTime()
    local openServerTime = SL:GetEnterRoleRes().openServerTime  ---开服时间
    local ONE_DAY_MILLISECOND = 86400000  ---一天毫秒数
    local cfg = SL:FindConfigs("cfg_newarea_ranking","id",ranking_id)
    local endTime = (cfg[1].endTime[1] - 1) * ONE_DAY_MILLISECOND + openServerTime
    lefttime = endTime - serverTime
    return lefttime
end

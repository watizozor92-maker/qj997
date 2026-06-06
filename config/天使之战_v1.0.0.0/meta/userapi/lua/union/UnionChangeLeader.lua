UnionChangeLeader = {}
local this = {}

-- 延迟任务类型
this.DelayType = {
    RunForLeader = 1, -- 竞选/取代
    Impeach = 2       -- 弹劾
}

this.EMAIL_IDS = {
    START_RUN_FOR_LEADER = 207006,           -- 发起竞选
    RUN_FOR_LEADER_FAIL = 207005,            -- 竞选失败
    RUN_FOR_LEADER_SUCCESS = 207001,         -- 竞选成功
    START_RUN_FOR_LEADER_REPLACE = 207008,   -- 发起取代
    RUN_FOR_LEADER_REPLACE_FAIL = 207009,    -- 取代失败
    RUN_FOR_LEADER_REPLACE_SUCCESS = 207010, -- 取代成功
    START_IMPEACH = 207007,                  -- 发起弹劾
    IMPEACH_FAIL = 207003,                   -- 弹劾失败
    IMPEACH_SUCCESS = 207002,                -- 弹劾成功
}

function UnionChangeLeader.sendUnionInfo(actor)
    this.sendUnionInfo(actor)
end

function UnionChangeLeader.startInitUnionDelayTask()
    local success, result = xpcall(function()
        this.initUnionChangeLeaderData()
        this.initRunForLeaderTask()
        this.initGlobalImpeachData()
        this.initImpeachTask()
    end, debug.traceback)
    gameDebug.assertPrint(success, "竞选初始化失败", result)
end

function UnionChangeLeader.clearRunForLeaderMember(actor)
    -- 事件触发有问题，由客户端屏蔽退出的玩家
    -- this.runForLeaderMemberQuit(actor)
end

----------------------------------------------------

function this.sendUnionInfo(actor)
    local union_data = getunioninfo(actor)
    if table.isEmpty(union_data) then
        this.debug(actor, "获取战盟信息异常")
        return
    end
    union_data = table.valueConvertToString(union_data)
    sendluamsg(actor, LuaMessageIdToClient.RES_GET_UNION_INFO, union_data)
end

function this.initUnionChangeLeaderData()
    local global_data = {}
    local summary_list = getallunionsummary()
    if table.isEmpty(summary_list) then
        return
    end

    for _, summary in pairs(summary_list) do
        local union_id = summary.unionid
        local data = this.getRunForLeaderData(union_id)
        if not table.isEmpty(data) and not table.isEmpty(data.ridlist) then
            global_data[union_id] = data
        end
    end
    this.setAllRunForLeaderData(global_data)
end

---------------------------------------------------------------------------------

---------------------------------- ↓战盟竞选逻辑开始↓ -------------------------------

---@class UnionChangeLeader.UnionRunForLeaderData
---@field ridlist table 竞选者列表
---@field endtime string 竞选结束时间
---@field unionid number 竞选战盟id
---@field isreplace boolean 是否有盟主[有盟主为取代, 无盟主为竞选]

UnionChangeLeader.RunForLeader = {}


UnionChangeLeader.runForLeaderGlobalKey = "G$_UNION_RUN_FOR_LEADER_GLOBAL_DATA"
UnionChangeLeader.runForLeaderKey = "U$_UNION_RUN_FOR_LEADER_DATA"

function UnionChangeLeader.RunForLeader.getRunForLeaderData(actor)
    this.sendRunForLeaderData(actor)
end

function UnionChangeLeader.RunForLeader.actorRunForLeader(actor)
    this.actorRunForLeader(actor)
end

function UnionChangeLeader.RunForLeader.actorVoteRunForLeader(actor, vote_data)
    this.actorVoteRunForLeader(actor, vote_data)
end

function UnionChangeLeader.RunForLeader.finishRunforLeaderActor()
    this.finishRunforLeaderActor()
end

-----------------------------------------------
function this.sendRunForLeaderData(actor)
    local union_id = getbaseinfo(actor, "unionid")
    local data = this.getRunForLeaderData(union_id)
    if table.isEmpty(data) then
        data = {}
    end
    this.debug("---- panel data ----", data)
    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_RUN_FOR_LEADER_DATA, data)
end

function this.getAllRunForLeaderData()
    return getsysvar(UnionChangeLeader.runForLeaderGlobalKey)
end

function this.setAllRunForLeaderData(data)
    setsysvar(UnionChangeLeader.runForLeaderGlobalKey, data)
end

function this.getRunForLeaderData(union_id)
    local union_actor = getguild(union_id)
    return getguilddef(union_actor, UnionChangeLeader.runForLeaderKey)
end

function this.setRunForLeaderData(union_id, data)
    local union_actor = getguild(union_id)
    setguilddef(union_actor, UnionChangeLeader.runForLeaderKey, data)

    -- 同步全服数据
    local all_data = this.getAllRunForLeaderData()
    if not all_data then
        all_data = {}
    end
    all_data[union_id] = data
    this.setAllRunForLeaderData(all_data)
end

function this.actorRunForLeader(actor)
    local union_data = getunioninfo(actor)
    if table.isEmpty(union_data) then
        this.debug(actor, "获取战盟信息异常")
        return
    end

    local rid_str = getbaseinfo(actor, "id")
    local rid = tostring(rid_str)

    local level = union_data.unionlevel
    local union_id = union_data.unionid
    local leader_id = tostring(union_data.leaderid)

    if tonumber(rid) == tonumber(leader_id) then
        this.info(actor, "盟主不能参与竞选/取代")
        return
    end

    local now = getbaseinfo(actor, "now")
    local is_replace = tonumber(leader_id) > 0
    if is_replace then
        local online_state = getbaseinfo(actor, "onlinestate")
        if tonumber(online_state) == 0 then
            local leader_info = union_data.memberinfos[union_data.leaderid]
            local quit_line_mil = (now - leader_info.quitlinetime) / 60 / 1000

            local offlinetime = ConfigDataManager.getTableValue("cfg_unionlevel", "continuousofflinetime", "unionLevel",
                level)
            if quit_line_mil < tonumber(offlinetime) then
                this.info(actor, "盟主离线时不长满足取代条件，不能被取代。 quit_line_mil " .. tostring(quit_line_mil))
                return
            end
        end

        local on_second = (now - union_data.leaderontime) / 60 / 1000
        local abdicationtime = ConfigDataManager.getTableValue("cfg_unionlevel", "abdicationtime", "unionLevel", level)

        if on_second < tonumber(abdicationtime) then
            this.info(actor, "盟主在位小于" .. abdicationtime .. "分钟。 on_second " .. tostring(on_second))
            return
        end
    end

    local condition = ""
    local cost_str = ""
    local campaign = 0

    if not is_replace then
        condition = ConfigDataManager.getTableValue("cfg_unionlevel", "electionConditions", "unionLevel", level)
        cost_str = ConfigDataManager.getTableValue("cfg_unionlevel", "cast", "unionLevel", level)
        campaign = ConfigDataManager.getTableValue("cfg_unionlevel", "campaign", "unionLevel", level)
    else
        condition = ConfigDataManager.getTableValue("cfg_unionlevel", "replaceConditions", "unionLevel", level)
        cost_str = ConfigDataManager.getTableValue("cfg_unionlevel", "replaceCast", "unionLevel", level)
        campaign = ConfigDataManager.getTableValue("cfg_unionlevel", "replaceTime", "unionLevel", level)
    end
    local delay_second = campaign * 60
    -- delay_second = 60 * 60 * 24

    -- 判断玩家是否可以发起竞选
    if condition then
        local isPass = ConditionManager.Check(actor, condition)
        if not isPass then
            this.info(actor, "不满足竞选/取代条件")
            return
        end
    end

    -- 参与竞选
    local start_delay = false
    local all_data = this.getAllRunForLeaderData()
    this.debug("------ all_data is empty", all_data, table.isEmpty(all_data))
    if table.isEmpty(all_data) then
        this.debug(actor, "---- 发起新的定时任务 ----")
        start_delay = true
    end

    -- 初始化竞选玩家数据
    local member_data = { count = 0, cost_item = cost_str }

    local data = this.getRunForLeaderData(union_id)
    if table.isEmpty(data) or table.isEmpty(data.ridlist) then
        -- 第一个竞选者
        local end_mills = now + (delay_second * 1000)
        local leader_map = {
            [rid] = member_data
        }
        ---@type UnionChangeLeader.UnionRunForLeaderData
        data = {
            ridlist = leader_map,
            endtime = tostring(end_mills),
            unionid = union_id,
            isreplace = is_replace
        }
    else
        if data.ridlist[rid] then
            tipinfo(actor,"您已经参与过, 请勿重复参与！")
            return
        end
        -- 添加竞选者
        data.ridlist[rid] = member_data
    end

    -- 扣除竞选费用
    local cost_ret = this.unionCostItem(actor, cost_str, 1)
    if not cost_ret then
        this.info(actor, "消耗道具失败！无法参与竞选/取代！")
        this.debug(actor, "cost_str" .. tostring(cost_str))
        return
    end

    this.setRunForLeaderData(union_id, data)
    -- 调试数据
    -- start_delay = 1 == 1

    if start_delay then
        this.delaycallFunRunerforLeader(delay_second)

        -- 首次发起 -- 发送邮件给所有成员
        if is_replace then
            local leader_name = union_data.memberinfos[tonumber(leader_id)].name
            this.sendAllMemberMails(union_data, this.EMAIL_IDS.START_RUN_FOR_LEADER_REPLACE, leader_name)
        else
            this.sendAllMemberMails(union_data, this.EMAIL_IDS.START_RUN_FOR_LEADER, "")
        end
    end
    local result = is_replace and 2 or 1
    sendluamsg(actor, LuaMessageIdToClient.RES_PLAYER_RUN_FOR_LEADER, result)
    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_RUN_FOR_LEADER_DATA, data)
end

function this.delaycallFunRunerforLeader(delay_second)
    this.debug("------ " .. delay_second .. "秒后结算竞选 -------")
    GlobalTimer.setontimerex(TimerIds.UNION_RUN_FOR_LEADER, delay_second)
end

function this.finishRunforLeaderActor()
    this.debug("---------- finishRunforLeaderActor ----------")
    local all_data = this.getAllRunForLeaderData()
    local uids = this.sortAllData(all_data)
    if table.isEmpty(uids) then
        return
    end

    local union_id = uids[1]
    local success, msg = xpcall(this.doFinishRunForLeader, debug.traceback, all_data, union_id)
    if not success then
        this.debug("------- 结算竞选异常！ -------", union_id, msg)
    end

    table.remove(uids, 1)
    this.setRunForLeaderData(union_id, nil)

    local has_next, left_second = this.initNextUnionDelayTask(all_data, uids)
    if has_next then
        this.delaycallFunRunerforLeader(left_second)
    end
end

function this.doFinishRunForLeader(all_data, union_id)
    local data = all_data[union_id]

    local union_data = getunioninfo(union_id)
    local member_infos = union_data.memberinfos

    local leaderid_list = {}
    local max_count = 0

    local rid_list = data.ridlist
    if table.notEmpty(rid_list) then
        for rid, rid_data in pairs(rid_list) do
            local count = rid_data["count"]
            if max_count < count then
                leaderid_list = { rid }
                max_count = count
            elseif max_count == count then
                if member_infos[tonumber(rid)] ~= nil then
                    table.insert(leaderid_list, rid)
                end
            end
        end

        if table.notEmpty(leaderid_list) then
            local leader_id = this.getRandomElement(leaderid_list)
            local union_data = getunioninfo(union_id)
            -- 邮件信息
            local new_leader_name = union_data.memberinfos[tonumber(leader_id)].name

            local fail_mail_id = 0
            local success_mail_id = 0
            local fail_mail_param = ""
            local success_mail_param = ""
            if tonumber(union_data.leaderid) > 0 then
                fail_mail_id = this.EMAIL_IDS.RUN_FOR_LEADER_REPLACE_FAIL
                success_mail_id = this.EMAIL_IDS.RUN_FOR_LEADER_REPLACE_SUCCESS

                local old_leader_name = union_data.memberinfos[tonumber(union_data.leaderid)].name
                fail_mail_param = new_leader_name .. "#" .. old_leader_name
                success_mail_param = old_leader_name
            else
                fail_mail_id = this.EMAIL_IDS.RUN_FOR_LEADER_FAIL
                success_mail_id = this.EMAIL_IDS.RUN_FOR_LEADER_SUCCESS
                success_mail_param = union_data.unionname
            end

            -- 设置盟主
            setunionleader(union_id, leader_id)
            this.sendMemberMails(leader_id, success_mail_id, {}, success_mail_param)
            this.debug("【" .. union_data.unionname .. "】 " .. "竞选/取代 设置盟主成功")

            for member_id, data_member in pairs(rid_list) do
                if member_id == leader_id then
                    goto continue
                end
                -- 返还其他竞选者的竞选费用
                local item_arr = string.split(data_member.cost_item, "#")
                if table.isEmpty(item_arr) or #item_arr < 2 then
                    goto continue
                end
                -- 发送返还邮件
                local item = { [tonumber(item_arr[1])] = tonumber(item_arr[2]) }
                this.sendMemberMails(member_id, fail_mail_id, item, fail_mail_param)
                :: continue ::
            end
        end
    end
end

function this.initRunForLeaderTask()
    local all_data = this.getAllRunForLeaderData()
    this.startInitUnionDelayTask(all_data, this.DelayType.RunForLeader)
end

function this.getRandomElement(tbl)
    local count = #tbl
    if count == 0 then
        return nil
    end
    local index = math.random(1, count)
    return tbl[index]
end

function this.actorVoteRunForLeader(actor, vote_data)
    if #vote_data < 1 then
        this.debug("没有获取到投票数据!")
        return
    end
    local member_id = vote_data[1]
    local count = tonumber(vote_data[2])

    if tonumber(member_id) < 1 or count < 1 then
        this.debug("没有获取到玩家ID 或 票数!")
        return
    end

    local union_id = getbaseinfo(actor, "unionid")
    --- @type UnionChangeLeader.UnionRunForLeaderData
    local data = this.getRunForLeaderData(tostring(union_id))
    if table.isEmpty(data) then
        this.debug("没有获取到竞选/取代信息!")
        return
    end

    local union_data = getunioninfo(actor)
    if tonumber(union_data.leaderid) > 0 then
        this.info(actor, "取代盟主 不能投票.")
        return
    end

    local rid_list = data.ridlist
    local member_data = rid_list[tostring(member_id)]
    if table.isEmpty(member_data) then
        this.debug("没有获取到该玩家信息!")
        return
    end

    if table.isEmpty(union_data) then
        this.debug(actor, "获取战盟信息异常")
        return
    end

    local level = union_data.unionlevel
    local votecast = ConfigDataManager.getTableValue("cfg_unionlevel", "votecast", "unionLevel", level)
    local cost_ret = this.unionCostItem(actor, votecast, count)
    if not cost_ret then
        this.info(actor, "消耗道具失败！无法参与竞选投票.")
        this.debug("cost_str" .. tostring(votecast))
        return
    end

    member_data.count = member_data.count + count
    this.setRunForLeaderData(union_id, data)

    sendluamsg(actor, LuaMessageIdToClient.RES_PLAYER_RUN_FOR_LEADER_VOTE, vote_data)
end

function this.runForLeaderMemberQuit(actor)
    local rid = actor:toString()
    local union_id = getbaseinfo(actor, "unionid")

    --- @type UnionChangeLeader.UnionRunForLeaderData
    local data = this.getRunForLeaderData(union_id)
    if table.isEmpty(data) then
        return
    end

    local member_data = data.ridlist[rid]
    if member_data == nil then
        return
    end
    data.ridlist[rid] = nil
    this.setRunForLeaderData(union_id, data)
    this.sendRunForLeaderData(actor)
end

--------------------------------- ↑战盟竞选逻辑结束↑ ----------------------------------

---------------------------------------------------------------------------------------

----------------------------------- ↓战盟弹劾逻辑↓ -------------------------------------

UnionChangeLeader.Impeach = {}

this.ImpeachDatKey = "U$_UNION_IMPEACH_DATA"
this.ImpeachGlobalDataKey = "G$_UNION_IMPEACH_GLOBAL_DATA_KEY"

---@class UnionChangeLeader.ImpeachData
---@field endtime string
---@field initiator number
---@field agreelist number[]
---@field disagreelist number[]

function UnionChangeLeader.Impeach.sendImpeachInfo(actor)
    this.sendImpeachInfo(actor)
end

function UnionChangeLeader.Impeach.actorImpeach(actor)
    this.actorImpeach(actor)
end

function UnionChangeLeader.Impeach.finishImpeachData()
    this.finishImpeachData()
end

function UnionChangeLeader.Impeach.actorVoteImpeach(actor, vote)
    this.actorVoteImpeach(actor, vote)
end

-----------------------------------------------

function this.initGlobalImpeachData()
    local global_data = {}
    local summary_list = getallunionsummary()
    if table.isEmpty(summary_list) then
        return
    end

    for _, summary in pairs(summary_list) do
        local union_id = summary.unionid
        local data = this.getImpeachData(union_id)
        if not table.isEmpty(data) and not table.isEmpty(data.ridlist) then
            global_data[union_id] = data
        end
    end

    this.setAllImpeachData(global_data)
end

function this.getAllImpeachData()
    return getsysvar(this.ImpeachGlobalDataKey)
end

function this.setAllImpeachData(data)
    setsysvar(this.ImpeachGlobalDataKey, data)
end

function this.getImpeachData(union_id)
    local union_actor = getguild(union_id)
    return getguilddef(union_actor, this.ImpeachDatKey)
end

function this.setImpeachData(union_id, data)
    local union_actor = getguild(union_id)
    setguilddef(union_actor, this.ImpeachDatKey, data)

    -- 同步全服数据
    local all_data = this.getAllImpeachData()
    if not all_data then
        all_data = {}
    end
    all_data[union_id] = data
    this.setAllImpeachData(all_data)
end

function this.sendImpeachInfo(actor)
    local union_id = getbaseinfo(actor, "unionid")
    local data = this.getImpeachData(union_id)
    sendluamsg(actor, LuaMessageIdToClient.RES_SEND_UNION_IMPEACH_INFO, data)
end

function this.actorImpeach(actor)
    local union_data = getunioninfo(actor)
    if table.isEmpty(union_data) then
        this.debug( "获取战盟信息异常")
        return
    end

    local leader_id = tostring(union_data.leaderid)
    if tonumber(leader_id) < 1 then
        this.info(actor, "战盟中没有盟主, 无法弹劾")
        return
    end

    local rid = tostring(getbaseinfo(actor, "id"))
    if tonumber(rid) == tonumber(leader_id) then
        this.info(actor, "盟主不能弹劾自己")
        return
    end

    local now = getbaseinfo("now")

    local level = union_data.unionlevel
    local abdicationtime = ConfigDataManager.getTableValue("cfg_unionlevel", "abdicationtime", "unionLevel", level)
    local on_second = (now - union_data.leaderontime) / 60 / 1000
    if on_second < tonumber(abdicationtime) then
        this.info(actor, "盟主在位时间不足。 on_second " .. tostring(on_second))
        return
    end

    local impeach_data = this.getImpeachData(union_data.unionid)
    if not table.isEmpty(impeach_data) then
        this.info(actor, "该盟主正在被弹劾")
        return
    end

    local condition = ConfigDataManager.getTableValue("cfg_unionlevel", "campaignCondition", "unionLevel", level)
    if condition and condition ~= "" then
        local isPass = ConditionManager.Check(actor, condition)
        if not isPass then
            this.info(actor, "不满弹劾条件")
            return
        end
    end

    -- 消耗道具
    local cast_str = ConfigDataManager.getTableValue("cfg_unionlevel", "campaignCast", "unionLevel", level)
    if cast_str and cast_str ~= "" then
        local cost_item = string.split(cast_str, "#")
        local cost_ret = removeitemfrombag(actor, cost_item[1], cost_item[2], 0, 9999, '战盟-盟主竞选')
        if not cost_ret then
            this.info(actor, "消耗道具失败！无法参与竞选/取代！")
            this.debug("cost_str" .. tostring(cast_str))
            return
        end
    end

    -- 发起弹劾
    local impeachment = ConfigDataManager.getTableValue("cfg_unionlevel", "impeachment", "unionLevel", level)
    local delay_second = impeachment * 60
    -- delay_second = 60
    local end_time = now + (delay_second * 1000)
    ---@type UnionChangeLeader.ImpeachData
    impeach_data = {
        endtime = tostring(end_time),
        initiator = rid,
        agreelist = {},
        disagreelist = {},
    }

    this.setImpeachData(union_data.unionid, impeach_data)
    this.delaycallFunImpeach(delay_second)
    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_IMPEACH_LEADER, union_data)

    -- 弹劾邮件
    local leader_name = union_data.memberinfos[tonumber(leader_id)].name
    this.sendAllMemberMails(union_data, this.EMAIL_IDS.START_IMPEACH, leader_name)
end

function this.delaycallFunImpeach(delay_second)
    this.debug(delay_second .. "秒后执行弹劾")
    GlobalTimer.setontimerex(TimerIds.UNION_IMPEACH, delay_second)
end

function this.finishImpeachData()
    local data = this.getAllImpeachData()
    local uids = this.sortAllData(data)
    if table.isEmpty(uids) then
        return
    end

    local union_id = uids[1]
    local success, msg = xpcall(this.doFinishImpeachData, debug.traceback, data, union_id)
    if not success then
        this.debug("------- 结算弹劾异常！ -------", union_id, msg)
    end

    table.remove(uids, 1)
    local has_next, left_second = this.initNextUnionDelayTask(data, uids)
    if has_next then
        this.delaycallFunImpeach(left_second)
    end
end

function this.doFinishImpeachData(data, union_id)
    local impeach_data = data[union_id]
    local mail_id = 0
    local union_data = getunioninfo(union_id)
    local leader_name = union_data.memberinfos[tonumber(union_data.leaderid)].name

    -- 计算弹劾结果
    local success = #impeach_data.agreelist > #impeach_data.disagreelist
    if success then
        this.debug("-- 弹劾完成，盟主退位 --")
        setunionleader(union_id, 0)
        mail_id = this.EMAIL_IDS.IMPEACH_SUCCESS
    else
        mail_id = this.EMAIL_IDS.IMPEACH_FAIL
    end
    this.setImpeachData(union_id, nil)

    -- 发送弹劾完成邮件
    this.sendAllMemberMails(union_data, mail_id, leader_name)
end

function this.initImpeachTask()
    local all_data = this.getAllImpeachData()
    this.startInitUnionDelayTask(all_data, this.DelayType.Impeach)
end

function this.actorVoteImpeach(actor, is_aggree)
    local union_id = getbaseinfo(actor, "unionid")
    ---@type UnionChangeLeader.ImpeachData
    local data = this.getImpeachData(union_id)
    if table.isEmpty(data) then
        this.debug("没有获取到弹劾信息!")
        return
    end

    if is_aggree ~= 1 and is_aggree ~= 0 then
        this.info(actor, "无效票")
        return
    end

    local union_data = getunioninfo(actor)
    local leader_id = tostring(union_data.leaderid)

    local rid = tostring(getbaseinfo(actor, "id"))
    if tonumber(rid) == tonumber(leader_id) then
        this.info(actor,  "盟主不能投票")
        return
    end
    if tonumber(rid) == tonumber(data.initiator) then
        this.info(actor,  "发起人不能投票")
        return
    end

    if table.contains(data.agreelist, rid) then
        this.info(actor, "玩家已经投赞成票")
        return
    end
    if table.contains(data.disagreelist, rid) then
        this.info(actor, "玩家已经投反对票")
        return
    end

    local level = union_data.unionlevel
    local cost_str = ConfigDataManager.getTableValue("cfg_unionlevel", "campaignVoteCast", "unionLevel", level)
    if cost_str and cost_str ~= "" then
        local cost_item = string.split(cost_str, "#")
        local cost_ret = removeitemfrombag(actor, cost_item[1], cost_item[2], 0, 9999, '战盟-盟主竞选')
        if not cost_ret then
            this.info(actor, "消耗道具失败！无法参与竞选/取代！")
            this.debug("cost_str" .. tostring(cost_str))
            return
        end
    end

    if is_aggree == 1 then
        table.insert(data.agreelist, rid)
    elseif is_aggree == 0 then
        table.insert(data.disagreelist, rid)
    end
    this.setImpeachData(union_id, data)
    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_IMPEACH_VOTE, is_aggree)
end

----------------------------------- ↑战盟弹劾逻辑↑ -----------------------------------

------------------------------------------ 通用函数 ----------------------------------------
function this.sortAllData(all_data)
    local uids = {}
    if table.isEmpty(all_data) then
        return uids
    end

    for uid in pairs(all_data) do
        table.insert(uids, uid)
    end

    function this.sortUidsByEndTimeDesc(a, b)
        return tonumber(all_data[a].endtime) < tonumber(all_data[b].endtime)
    end

    -- 排序函数
    table.sort(uids, this.sortUidsByEndTimeDesc)
    return uids
end

function this.startInitUnionDelayTask(data, type)
    local uids = this.sortAllData(data)
    if table.isEmpty(uids) then
        return
    end

    local has_next, left_second = this.initNextUnionDelayTask(data, uids)
    if not has_next then
        return
    end

    if type == this.DelayType.RunForLeader then
        this.delaycallFunRunerforLeader(left_second)
    elseif type == this.DelayType.Impeach then
        this.delaycallFunImpeach(left_second)
    end
end

function this.initNextUnionDelayTask(data, uids)
    if #uids < 1 then
        return false
    end

    local next_union_id = uids[1]
    local next_data = data[next_union_id]
    local now = tonumber(getbaseinfo("now"))

    local next_end_time = tonumber(next_data.endtime)
    if not next_end_time then
        this.debug("结束时间无效, 请检查next_data.endtime")
        return false
    end

    local left_second = (next_end_time - now) / 1000
    if left_second < 10 then
        left_second = 10
    end
    return true, left_second
end

function this.unionCostItem(actor, cost_str, rate)
    rate = rate or 1
    if not cost_str or cost_str == "" then
        return true
    end
    local cost_item = string.split(cost_str, "#")
    local item_id = cost_item[1]
    local item_count = cost_item[2]

    item_count = math.floor(item_count * rate)

    local cost_ret = removeitemfrombag(actor, item_id, item_count, 0, 9999, '战盟-盟主竞选')
    if not cost_ret then
        return false
    end
    return true
end

function this.sendAllMemberMails(union_data, mail_id, param)
    for id, _ in pairs(union_data.memberinfos) do
        this.sendMemberMails(id, mail_id, nil, param)
    end
end

function this.sendMemberMails(rid, mail_id, item, param)
    sendconfigmailbyrid(rid, mail_id, item, param)
end

---------------------------- 日志打印 -----------------------------
this.log_open = false
this.log_name = "[union_change_leader]"

function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(this.log_name, ...)
end

function this.info(actor, ...)
    if this.log_open then
        jprint(this.log_name, ...)
    end
    tipinfo(actor, ...)
end

-- ====================================测试========================================
function testunionchangeleader(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        this.actorRunForLeader(actor)
    end
end
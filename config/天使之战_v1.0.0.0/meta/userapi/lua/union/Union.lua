Union = {}

local this = {}

---@class UnionData
---@field createtime number 创建时间
---@field memberinfos table<number, UnionMemberInfos> 成员列表
---@field leaderid number 盟主id
---@field unionid number 战盟id
---@field leaderontime number 盟主上位时间
---@field unionname string 战盟名称
---@field unionlevel number 战盟等级
---@field totaldevote number 战盟总贡献
---@field unionarmband number 战盟臂章ID
---@field ischangename number 是否改名 0 未改名 1 已改名
---@field unionexp number 战盟经验
---@field num number 当前人数
---@field maxnum number 最大人数
---@field enemyunionids table<number> 敌对战盟
---@field announcement string 战盟公告
---@field unioncapital number 战盟资金
---@field unioncachet number 战盟声望

---@class UnionMemberInfos
---@field rid number 角色id
---@field name string 角色名字
---@field level number 角色等级
---@field career number 职业
---@field position number 职位
---@field devote number 贡献值
---@field isonline number 是否在线 0 离线 1 在线
---@field jointime number 加入时间
---@field curweekactivetimes number 当前周活跃度
---@field quitlinetime number 下线时间

---@class UnionDetails
---@field unionId number 行会id
---@field unionName string 行会名字
---@field unionLevel number 行会等级
---@field memberNum number 行会人数
---@field masterName string 会长名字
---@field unionArmband number 行会臂章
---@field announcement string 招募公告
---@field maxMemberNum number 行会最大人数
---@field needLevel number 申请等级限制




function Union.reqGetUnionDetail(actor, unionId)
    local unionInfo = getunioninfo(actor, unionId)
    ---@class UnionDetails
    local res = {}
    res.unionId = unionInfo.unionid
    res.unionName = unionInfo.unionname
    res.unionLevel = unionInfo.unionlevel
    res.memberNum = table.count(unionInfo.memberinfos)
    if unionInfo.leaderid > 0 then
        local leaderActor = getactor(actor, unionInfo.leaderid)
        res.masterName = getbaseinfo(leaderActor, "rolename")
    end
    res.unionArmband = unionInfo.unionarmband
    res.announcement = unionInfo.announcement
    res.maxMemberNum = unionInfo.maxnum
    res.needLevel = unionInfo.needlevel
    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_DETAILS_INFO, res)
end



function Union.sendLeaderOnlineStateMsg(actor)
    this.sendLeaderOnlineStateMsg(actor)
end

function this.sendLeaderOnlineStateMsg(actor)
    local union_id = tostring(getbaseinfo(actor, "unionid"))
    if string.tonumber(union_id) < 1 then
        return
    end

    local union_data = getunioninfo(actor)
    if table.isEmpty(union_data) then
        this.jprint(" ---- 发送盟主状态时 获取战盟数据失败！----")
        return
    end
    local rid = tostring(getbaseinfo(actor, "id"))
    local leader_id = tostring(union_data.leaderid)

    if tonumber(rid) ~= tonumber(leader_id) then
        return
    end

    local online_state = getbaseinfo(actor, "onlinestate")
    if online_state == "" or tonumber(online_state) == 0 then
        online_state = 0
    else
        online_state = 1
    end

    for _, member in pairs(union_data.memberinfos) do
        local member_actor = getactor(member.rid)
        sendluamsg(member_actor, LuaMessageIdToClient.RES_UNION_LEADER_ON_LINE_STATE, union_data)
    end
    this.jprint("------- 发送盟主在线状态 ------")
end

------------------------------------ ↓战盟活动↓ ----------------------------------

Union.UnionActivity = {}

---@class Union.UnionActivity
---@field activityid number 活动id
---@field open string 是否开启

-- 获取战盟活动列表
function Union.UnionActivity.getUnionActivity(actor)
    local data = this.getUnionActivity(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_ACTIVITY_DATA, data)
end

function this.getUnionActivity(actor)
    local data = getallactivities(actor)
    if table.isEmpty(data) then
        this.jprint("获取活动列表失败")
        return
    end
    local union_active = {}
    for _, value in pairs(data) do
        local type = ConfigDataManager.getTableValue("cfg_activity_rule", "initType", "id", value.activityid)
        if tonumber(type) == UnionConst.UNION_ACTIVITY_INITTYPE then
            ---@type Union.UnionActivity
            local activity = {
                activityid = value.activityid,
                open = value.open
            }
            table.insert(union_active, activity)
        end
    end
    return union_active
end

------------------------------------- ↑战盟活动↑ -----------------------------------

Union.DefaultUnion = {}

--- 服务器启动后创建默认战盟 全局数据
this.GLOBAL_DEFAULT_UNION_CREATE_DATA_KEY = PlayerDefKey.UNION.GLOBAL_DEFAULT_UNION_CREATE_DATA_KEY

this.DEFAULT_UNION_GLOBAL_ID = 1601

function Union.DefaultUnion.initDefaultUnion(is_gm)
    local serverType = getbaseinfo("servertype")
    if serverType == 2 then
        -- 跨服服务器不执行
        return
    end

    local summary_list = getallunionsummary()
    local is_create = getsysvar(this.GLOBAL_DEFAULT_UNION_CREATE_DATA_KEY)
    this.debug("is_create", is_create, table.notEmpty(summary_list), is_create or table.notEmpty(summary_list))
    if (is_create or table.notEmpty(summary_list)) and not is_gm then
        return
    end

    local value_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", this.DEFAULT_UNION_GLOBAL_ID)
    if string.isNullOrEmpty(value_str) then
        return
    end
    local list = ConfigDataManager.getList("cfg_unionname")
    if table.isEmpty(list) then
        return
    end

    local create_info = string.split(value_str, "#")
    local union_count = tonumber(create_info[1])
    local curr_count = 0

    local usedIndexes = {}
    for idx, level in pairs(create_info) do
        if idx ~= 1 and curr_count < union_count then
            -- 随机一个战盟名称和战盟臂章
            local log = math.random(1, 5)
            local randomIndex
            repeat
                randomIndex = math.random(1, #list)
            until not usedIndexes[randomIndex]

            --创建战盟
            local config = list[randomIndex]
            local union_id = systemcreateunion(config.name, log, level)
            local union = getunioninfo(union_id)

            -- 标记已使用的索引
            usedIndexes[randomIndex] = true
            this.debug("创建默认战盟:", union, union_id, log)
        end
    end
    setsysvar(this.GLOBAL_DEFAULT_UNION_CREATE_DATA_KEY, true)
end

function Union.combineglobalvar(varName)
    setsysvar(varName, true)
end

---------------------------- 日志打印 -----------------------------
this.log_open = false
function this.jprint(param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(param)
end

function this.loginfo(actor, param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 日志输出内容为空. nil"
    end
    jprint(param)
    info(actor, param)
end

function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(...)
end

--- 修改战盟名称
---@param actor table 玩家对象
---@param msgData table 战盟名称
function Union.changeUnionName(actor, msgData)
    local unionName = msgData["unionName"]
    ---@type UnionData
    local unionInfo = getunioninfo(actor)
    ---@type UnionMemberInfos
    local member = unionInfo.memberinfos[tonumber(actor:toString())]
    if member.position ~= 1 and member.position ~= 2 then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT454)
        return
    end

    -- 检查战盟名称
    if not this.checkIsAllCN(unionName) then
        jprint("战盟名称不合法或重复 actor:" .. actor:toString() .. "unionName:" .. unionName)
        return
    end
    if not checkunionname(actor, unionName) then
        jprint("战盟名称不合法或重复 actor:" .. actor:toString() .. "unionName:" .. unionName)
        return
    end

    -- 如果首次更改战盟名称不消耗道具
    if unionInfo.ischangename and unionInfo.ischangename == 1 then
        -- 如果背包中有战盟改名卡，则先消耗战盟改名卡
        local costItemId, costCount
        local item, count = this.checkItem(actor)
        if not item then
            local equalId, equalCount = this.checkEqualItem(actor)
            if not equalId then
                local replaceItemId, replaceItemCount = this.checkNoItemReplace(actor)
                if not replaceItemId then
                    noticeTip.noticeinfo(actor, StringIdConst.TEXT346)
                    return
                else
                    costItemId, costCount = replaceItemId, replaceItemCount
                end
            else
                costItemId, costCount = equalId, equalCount
            end
        else
            costItemId, costCount = item, count
        end
        if not checkunionname(actor, unionName) then
            jprint("战盟名称不合法或重复 actor:" .. actor:toString() .. "unionName:" .. unionName)
            return
        end
        -- 从背包中移除指定数量的道具
        removeitemfrombag(actor, costItemId, costCount, 0, 9999, '战盟改名')
    else
        if not checkunionname(actor, unionName) then
            jprint("战盟名称不合法或重复 actor:" .. actor:toString() .. "unionName:" .. unionName)
            return
        end
    end
    -- 修改战盟名称
    changeunionname(actor, unionName)
end

function this.checkItem(actor)
    local cfgCost = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.CHANGE_NAME_CARD_COST)
    local split = string.split(cfgCost, "|")
    local tmps = string.split(split[1], "#")
    local costItemId = tmps[1]
    local costCount = tmps[2]
    if not Bag.checkItem(actor, costItemId, costCount) then
        return nil, nil
    end
    return costItemId, costCount
end

function this.checkEqualItem(actor)
    local cfgCost = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.CHANGE_NAME_CARD_COST)
    local split = string.split(cfgCost, "|")
    local tmps = string.split(split[1], "#")
    local cfgId = tmps[1]
    local count = tmps[2]
    local config = ConfigDataManager.getById("cfg_item", cfgId)
    local equalId = config.bindequalitem
    if string.isNullOrEmpty(equalId) then
        return nil, nil
    end
    if not Bag.checkItem(actor, equalId, count) then
        return nil, nil
    end
    return equalId, count
end

function this.checkNoItemReplace(actor)
    local value = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.CHANGE_NAME_COST_WITHOUT_CARD)
    local split2 = string.split(value, "|")
    if string.isNullOrEmpty(split2[1]) then
        return nil, nil
    end
    local tmp2 = string.split(split2[1], "#")
    local costItemId = tmp2[1]
    local costCount = tmp2[2]
    if not Bag.checkItem(actor, costItemId, costCount) then
        return nil, nil
    end
    return costItemId, costCount
end

-- 校验字符串是否全为中文且不超过7个字
function this.checkIsAllCN(str)
    if type(str) ~= "string" then return false end

    local count = 0
    for uchar in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        local byte = uchar:byte()
        -- 检查三字节中文范围 (0xE4-0xE9 开头)
        if #uchar ~= 3 or byte < 0xE4 or byte > 0xE9 then
            return false
        end
        count = count + 1
        if count > 7 then return false end
    end
    return count > 0
end

this.gm_open = true
function l_default_create_system_union(_, is_gm)
    if not this.gm_open then
        return
    end
    Union.DefaultUnion.initDefaultUnion(is_gm)
end

MessageRouter:register(LuaMessageIdToSever.REQ_GET_UNION_DETAILS, Union.reqGetUnionDetail)

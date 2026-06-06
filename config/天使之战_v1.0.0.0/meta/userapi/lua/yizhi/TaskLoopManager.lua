TaskLoopManager = {}
local this = TaskLoopManager
local filename = "TaskLoopManager"
this.msgID = LuaMessageIdToSever.TaskLoopMessage
local __taskLoopFlushTime = "playerTaskLoopFlushTime"
function this.sendDataToClient(actor)
    local currentNum = API.GetInt(actor, VarCfg.ZC_TaskLoopNum) + 1
    local taskInfo  = ConfigDataManager.getById("cfg_taskline", currentNum)
    local currentCfgId = API.GetInt(actor, VarCfg.ZC_TaskLoopNeedCfgId)
    if taskInfo ~= nil and not string.isNullOrEmpty(taskInfo.itemid) and currentCfgId == 0 then
        local allCfgIds = string.split(taskInfo.itemid, "#", true)
        currentCfgId = allCfgIds[math.random(1, #allCfgIds)]
        API.SetInt(actor, VarCfg.ZC_TaskLoopNeedCfgId, tonumber(currentCfgId))
    end

    sendluamsg(actor, this.msgID, { type = 1, currentLoopNum = currentNum - 1, currentCfgId = currentCfgId })
end

--重载配置
GameEvent.add(EventCfg.onReloadScript,function(actor)
    this.sendDataToClient(actor)
end,filename)

--登录
GameEvent.add(EventCfg.onLoginEnd,function(actor)
    this.sendDataToClient(actor)
end,filename)
--跨天
GameEvent.add(EventCfg.onNewDay,function(actor)
    -- info( "跨天重置跑环任务")
    -- local value = ConfigDataManager.getTableValue("cfg_global", "value", "id", 29003)
    -- if not string.isNullOrEmpty(value) then
    --     local pass = ConditionManager.Check(actor, value)
    --     if not pass then
    --         return
    --     end
    -- end
    this.sendDataToClient(actor)
    -- API.SetInt(actor, __taskLoopFlushTime, getbaseinfo("nowsec"))
end,filename)

function this.checkFlush(actor, type)
    type = tonumber(type)
    local now = getbaseinfo("nowsec")
    local updateTime = API.GetInt(actor, __taskLoopFlushTime)
    if type == 1 then
        return (not TimeUtil.isSameDay(updateTime, now))
    elseif type == 2 then
        return (not TimeUtil.isSameWeek(updateTime, now))
    elseif type == 3 then
        return updateTime == 0
    end
    return false
end

function this.onHandlereQuest(actor, msgData)
    local type = tonumber(msgData.type)
    if type == 2 then
        -- 提交任务
        this.commitLoopTask(actor, msgData.itemId, msgData.useJuanZhou)
    end
end

-- GameEvent.add(EventCfg.onHandlereQuest,
--     function(actor, msgID,msgData)
--         if this.msgID ~= msgID then
--             return 
--         end 
--         local type = tonumber(msgData.type)
--         if type == 2 then
--             -- 提交任务
--             this.commitLoopTask(actor, msgData.itemId, msgData.useJuanZhou)
--         end
--         return true
--     end
-- , filename)

function this.commitLoopTask(actor, itemId, useJuanzhou)
    useJuanzhou = useJuanzhou == nil and false or useJuanzhou
    
    local currentNum = API.GetInt(actor, VarCfg.ZC_TaskLoopNum)
    -- if currentNum >= this.maxLoopCount then
    --     API.messageBox(actor, "您已完成了所有的跑环任务")
    --     return
    -- end
    currentNum = currentNum + 1
    local taskInfo  = ConfigDataManager.getById("cfg_taskline", currentNum)
    if taskInfo == nil then
        API.messageBox(actor, "您已完成了所有的跑环任务")
        return
    end
    
    if useJuanzhou then
        local wuzi = string.split(taskInfo.wuzi, "#", true)
        local have_count = getbagitemcountbyid(actor, tonumber(wuzi[1])) or 0
        local bind_count = 0
        local bindEqualItem = tonumber(ConfigDataManager.getTableValue("cfg_item", "bindEqualItem", "id", tonumber(wuzi[1])))
        if bindEqualItem then
            bind_count = (getbagitemcountbyid(actor, bindEqualItem) or 0)
        end
        if have_count + bind_count < tonumber(wuzi[2]) then
            local itemName = ConfigDataManager.getTable("cfg_item", "id", wuzi[1])[1].name
            API.messageBox(actor, string.format("%s数量不足!", itemName))
            return
        end
        local cost_count = math.min(have_count, tonumber(wuzi[2]))
        local cost_map = {}
        cost_map[tonumber(wuzi[1])] = cost_count
        if cost_count < tonumber(wuzi[2]) then
            cost_map[bindEqualItem] = tonumber(wuzi[2]) - cost_count
        end
        Bag.costMap(actor, cost_map, "扣除跑环第" .. currentNum .. "环跳环物品消耗")
    else
        if itemId == nil then
            API.messageBox(actor, "请提交任务要求的装备")
            return
        end
        local itemInfo = getbagiteminfo(actor, itemId, 1) or {}
        if not next(itemInfo) then
            API.messageBox(actor, "装备信息未找到")
            return
        end
        if itemInfo.bagindex == nil then
            API.messageBox(actor, "装备信息未找到")
            return
        end
        -- 检查道具要求
        if not string.isNullOrEmpty(taskInfo.itemid) then
            local currentCfgId = API.GetInt(actor, VarCfg.ZC_TaskLoopNeedCfgId)
            if not API.ItemEqulas(currentCfgId, itemInfo.cfgid) then
                API.messageBox(actor, "请提交任务要求的指定装备")
                return
            end
        elseif not string.isNullOrEmpty(taskInfo.strpart) then
            local strPart = ConfigDataManager.getTableValue("cfg_item", "strPart", "id", itemInfo.cfgid) or ""
            local fuhe = false
            for _, value in pairs(string.split(strPart, "#")) do
                if string.contains(taskInfo.strpart, value) then
                    fuhe = true
                    break
                end
            end
            if not fuhe then
                API.messageBox(actor, "请提交任务要求的装备类型")
                return
            end
        end
        -- local allLuaItemExtData = EquipAndAppear.getLuaItemExtData(actor)
        local itemExtData = getitemextdata(actor, itemId) or {}
        -- 检查强化
        if not string.isNullOrEmpty(taskInfo.qianghua) then
            -- local lv = Equip_QiangHua.QiangHuaLV(actor, itemId)
            local lv = itemExtData.strengthlv or 0
            if lv < tonumber(taskInfo.qianghua) then
                API.messageBox(actor, "装备强化等级不符合要求")
                return
            end
        end
        -- 检查追加
        if not string.isNullOrEmpty(taskInfo.zhuijia) then
            local lv = itemExtData.appendlv or 0
            if lv < tonumber(taskInfo.zhuijia) then
                API.messageBox(actor, "装备追加等级不符合要求")
                return
            end
        end
        -- 检查幸运 待定
        -- if not string.isNullOrEmpty(taskInfo.xingyun) and taskInfo.xingyun ~= "0" then
        --     local lv = itemExtData.IsLuck or 0
        --     -- if not Equip_XingYun.isXingYunEquip(actor, itemId) then
        --     if lv <= 0 then
        --         API.messageBox(actor, "装备没有幸运属性")
        --         return
        --     end
        -- end
        -- -- 检查技能 这个版本没有技能
        -- if not string.isNullOrEmpty(taskInfo.jineng) and taskInfo.jineng ~= "0" then
        --     -- if not Equip_JiNeng.isJiNengEquip(actor, itemId) then
        --     local skillName = itemExtData.skillName
        --     if string.isNullOrEmpty(skillName) then
        --         API.messageBox(actor, "装备没有技能属性")
        --         return
        --     end
        -- end
        -- 检查卓越词条数
        if not string.isNullOrEmpty(taskInfo.zuoyue) then
            -- local count = Equip_ZhuoYue.ZhuoYueAttCount(actor, itemId)
            local itemInfo = getbagiteminfo(actor, itemId, 1)
            local count = table.count(itemInfo.entries)
            if count < tonumber(taskInfo.zuoyue) then
                API.messageBox(actor, "装备卓越词条数量不符合要求")
                return
            end
        end

        if not string.isNullOrEmpty(taskInfo.jinbi) then
            local xiaohao = string.putIntIntMap({}, taskInfo.jinbi, "#", "|")
            local jingyan = 0
            for cfgId, needCount in pairs(xiaohao) do
                if cfgId == 10080001 then
                    local result = getbaseinfo(actor,"exp")
                    if result < needCount then
                        API.messageBox(actor, string.format("角色经验不足%d!", needCount))
                        return
                    end
                    jingyan = needCount
                elseif not Bag.checkItem(actor, cfgId, needCount) then
                    local itemName = ConfigDataManager.getTable("cfg_item", "id", cfgId)[1].name
                    API.messageBox(actor, string.format("%s不足%d!", itemName, needCount))
                    return
                end
            end
            if jingyan > 0 then
                -- 暂时没有扣除经验的功能
                -- gmexecute(actor, string.format("@addexp %d", -jingyan))
            end
            Bag.costMap(actor, xiaohao, "扣除跑环第" .. currentNum .. "环物品消耗")
        end

        destroyitemafter(actor, itemInfo.bagindex,"扣除跑环第" .. currentNum .. "环装备消耗")
    end

    -- 发放奖励
    Bag.sendRewards4String(actor, taskInfo.jiangli, "跑环第" .. currentNum .. "环奖励")
    -- 记录环数
    API.SetInt(actor, VarCfg.ZC_TaskLoopNum, currentNum)
    API.SetInt(actor, VarCfg.ZC_TaskLoopNeedCfgId, 0)
    -- 通知客户端
    this.sendDataToClient(actor)
    onlyupdatetaskgoal(actor, 1,LoopTaskConfig.task_id, LoopTaskConfig.task_target_id, currentNum)
    if ConfigDataManager.getById("cfg_taskline", currentNum+1) == nil then
        -- info(actor, "完成所有跑环任务")
        submittask(actor, LoopTaskConfig.task_id)
    end
    -- 隐藏奖励
    local table_name = taskInfo.jiangli2
    if not string.isNullOrEmpty(table_name) then
        local item = culdroptablebyname(actor, table_name, 1, 1)
        local award = {}
        if table.count(item) > 0 then
            local itemid,item_count = next(item)
            local itemName = ConfigDataManager.getTable("cfg_item", "id", itemid)[1].name
            Bag.sendRewardsByBind(actor, award, 1, "跑环第" .. currentNum .. "环隐藏奖励")
            noticeTip.noticeinfo(actor, 35019, getbaseinfo(actor, "rolename"), itemName)
        end
    end
end


function TaskLoopManager.clear(actor, taskid)
    if tonumber(taskid) == 80001 then
        API.SetInt(actor, VarCfg.ZC_TaskLoopNum, 0)
        API.SetInt(actor, VarCfg.ZC_TaskLoopNeedCfgId, 0)
        this.sendDataToClient(actor)
    end
end
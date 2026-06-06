CommonTaskGoal = {}

--- 检查道具ID和道具类型是否符合条件
--- （适用于target2配置道具ID target配置道具类型的校验）
function CommonTaskGoal.CheckItemIdsAndTypeByGoodsId(goal_id, goal_count, goods_id)
    if string.isNullOrEmpty(goods_id) or tonumber(goods_id) < 1 then
        return goal_count
    end

    local config = ConfigDataManager.getById("cfg_task_target", goal_id)
    local goal_id_str = config.taskgoalparam2
    if not string.isNullOrEmpty(goal_id_str) then
        local id_list = string.split(goal_id_str, "#")
        local needArr = {}
        for i = 1, #id_list do
            local itemCfgId = id_list[i]
            table.insert(needArr, itemCfgId)
            local bindId = ConfigDataManager.getTableValue("cfg_item", "bindequalitem", "id", itemCfgId)
            if not string.isNullOrEmpty(bindId) then
                table.insert(needArr, bindId)
            end
        end
        if not table.contains(needArr, tostring(goods_id)) then
            return goal_count
        end
    end

    local goods_type_str = ConfigDataManager.getTableValue("cfg_item", "type", "id", goods_id)
    local goods_type = string.isNullOrEmpty(goods_type_str) and 0 or tonumber(goods_type_str)
    local goal_type = config.taskgoalparam

    if not string.isNullOrEmpty(goal_type) then
        if tonumber(goal_type) ~= goods_type then
            return goal_count
        end
    end
    return goal_count + 1
end

--- 触发以后就直接增加一次任务进度
--- is_add 触发刷新的时候传递，（领取任务后立即执行的一次刷新，增加一个is_add来区别是否主动触发）
function CommonTaskGoal.OnlyAddCountWhenTrigger(goal_count, is_add)
    return goal_count + (is_add and 1 or 0)
end

function CommonTaskGoal.EquipAppendAndStrengthen(actor, goal_id, goal_count, args_name)
    local goal_part_str = ConfigDataManager.getTableValue("cfg_task_target", "taskgoalparam", "id", goal_id)
    local goal_lv_str = ConfigDataManager.getTableValue("cfg_task_target", "taskgoalparam2", "id", goal_id)

    local goal_part = string.isNullOrEmpty(goal_part_str) and 0 or tonumber(goal_part_str)
    local goal_lv = string.isNullOrEmpty(goal_lv_str) and 0 or tonumber(goal_lv_str)

    local all_equip = getputonequipinfo(actor)
    if table.isEmpty(all_equip) then
        return 0
    end

    local max_count = 0
    for _, equip in pairs(all_equip) do
        local equip_data = EquipAndAppear.getItemExtData(actor, equip.id)

        if table.isEmpty(equip_data) then
            goto continue
        end
        local args_lv = equip_data[args_name] or 0
        if args_lv < goal_lv then
            goto continue
        end

        if goal_part > 0 then
            local part = gameequip.pos(equip.equipindex)
            if tonumber(part) ~= goal_part then
                goto continue
            end
        end

        max_count = max_count + 1
        :: continue ::
    end
    return max_count
end

function CommonTaskGoal.FlushLoopTaskCount(actor, _, goal_id, goal_count, param)
    -- info("环任务数量", goal_count,goal_id,param)
    return API.GetInt(actor, VarCfg.ZC_TaskLoopNum, 0)
end

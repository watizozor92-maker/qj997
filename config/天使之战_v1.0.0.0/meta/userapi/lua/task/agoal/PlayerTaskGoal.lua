PlayerTaskGoal = {}

---@see 开启三倍收益
-- function PlayerTaskGoal.FlushTripleIncome(actor, _, _, goal_count, _)
--     local is_open = TripleIncome.IsEffect(actor)
--     if not is_open then
--         return goal_count
--     end
--     return goal_count + 1
-- end

---@see 加点
function PlayerTaskGoal.FlushDeployAttrPoint(_, _, _, goal_count, param)
    return CommonTaskGoal.OnlyAddCountWhenTrigger(goal_count, param)
end

---@see 激活连击技能
function PlayerTaskGoal.FlushActivateComboSkill(actor, _, goal_id, goal_count, _)
    local config = ConfigDataManager.getById("cfg_task_target", goal_id)
    local skill_id = string.tonumber(config.taskgoalparam)
    local skill_lv = string.tonumber(config.taskgoalparam2)

    local comboSkill = getrolefield(actor,"role.roleskill.comboskill")
    local skillLv =  comboSkill.skillLv
    local skillCfgId =  comboSkill.skillCfgId

    if skill_id ~= skillCfgId then
        return goal_count
    end
    if skill_lv > 0 and skill_lv > skillLv then
         return goal_count
    end
    return goal_count + 1
end

---@see 激活白银特权
function PlayerTaskGoal.ActivateSilverPrivilege(actor, _, goal_id, goal_count, param)
    local active = PrivilegeMonth.hasSilverPrivilege(actor)
    if active == true then
        return goal_count + 1
    end
    return goal_count
end

---@see 使用果实
function PlayerTaskGoal.UseFruitItem(actor, _, goal_id, goal_count, param)
    local totalCount = FruitScript.GetUseFruitCount(actor)
    local needCount = tonumber(ConfigDataManager.getTableValue("cfg_task_target", "goalcount", "id", goal_id))
    local finalCount = math.min(totalCount, needCount)
    return finalCount
end

---@see 进入地图分线
function PlayerTaskGoal.EnterMapLine(actor, _, goal_id, goal_count, _)
    local config = ConfigDataManager.getById("cfg_task_target", goal_id)
    local target_1 = string.tonumber(config.taskgoalparam)

    local map_id = getbaseinfo(actor, "mapid")
    if target_1 > 0 and target_1 ~= string.tonumber(map_id) then
        return goal_count
    end

    local line = getbaseinfo(actor, "line")
    local target_2 = config.taskgoalparam2
    if not string.isNullOrEmpty(target_2) then
        local arr = string.split(target_2, "#")
        if not table.contains(arr, tostring(line)) then
            return goal_count
        end
    end
    return goal_count + 1
end
TaskGoal = {}

local this = {}

---@alias TaskTargetType  任务目标类型
TaskTargetType = {
    ------ 内置任务类型 ------
    COLLECTION                    = 1, -- 收集
    KILL_MONSTER                  = 2, -- 杀怪
    MAP_MOVE                      = 3, -- 地图移动
    FIND_NPC                      = 4, -- 寻找NPC
    LEVEL_REACH                   = 5, -- 等级达到
    USE_ITEM                      = 6, -- 使用物品
    SUBMIT_ITEM                   = 7, -- 提交物品
    WEAR_ITEM                     = 8, -- 穿戴物品
    HAS_UNION                     = 9, -- 加入公会
    GET_SKILL                     = 10, -- 获得技能
    WEAR_DESIGNATED_EQUIP         = 11, -- 穿戴指定装备

    ------ 外置任务类型 ------
    ---@alias 通关副本次数
    FINISH_DUPLICATE              = 12,
    ---@alias 通关指定副本次数
    FINISH_GOAL_DUP               = 13,
    ---@alias 合成次数
    SYNTHESIS                     = 14,
    ---@alias 回收次数
    RECOVERY                      = 15,
    ---@alias 指定部位强化到达指定等级
    PARTS_STRENGTHEN_LV           = 16,
    ---@alias 完成勇士任务
    FINISH_GOLD_TASK              = 17,
    ---@alias 在指定地图对怪造成伤害
    HURT_MAP_MONSTER              = 18,
    ---@alias 首饰升级
    JEWELRY_LV_UP                 = 19,
    ---@alias 通关秘境副本
    FINISH_SECRET_REALM_DUPLICATE = 20,
    ---@alias 开启三倍收益
    -- OPEN_TRIPLE_INCOME            = 21,
    ---@alias 指定部位追加到达指定等级
    EQUIP_APPEND                  = 22,
    ---@alias 击杀指定类型怪物
    KILL_TYPE_MONSTER             = 23,

    ---@alias 交易行上架商品
    TRADE_LINE_UP_GOODS           = 24,
    ---@alias 商城购买商品
    MALL_BUY_GOODS                = 25,
    ---@alias 装备叠加
    EQUIP_SUPERPOSITION           = 26,
    ---@alias 卓越词条
    EXCELLENCE_ATTR               = 27,
    ---@alias 镶嵌萤石
    INLAID_GEMSTONES              = 28,
    ---@alias 装备卓越词条数量
    EQUIP_EXCELLENCE_ATTR_COUNT   = 29,
    ---@alias 加点
    DEPLOY_ATTR_POINT             = 30,
    ---@alias 重新获取一个指定道具
    RE_GET_ITEM                   = 31,
    ---@alias 从NPC商店购买指定道具
    NPC_MALL_BUY_GOODS            = 32,
    ---@alias 回收获得指定道具
    RECOVERY_GET_APPOINT_ITEM     = 33,
    ---@alias 完成一次BOSS悬赏
    BOSS_BOUNTY                   = 34,
    ---@alias 激活连击技能
    ACTIVATE_COMBO_SKILL          = 35,
    ---@alias 激活白银特权
    ACTIVATE_SILVER_PRIVILEGE     = 36,
    ---@alias 完成第X章首饰任务
    JEWELRY_TASK_CHAPTER          = 37,
    ---@alias 穿戴装备累计强化x次数
    EQUIP_STRENGTHEN_TIMES        = 38,
    ---@alias 击杀x次指定等级以上怪物
    KILL_LEVEL_MONSTER            = 39,
    ---@alias 使用果实
    USE_FRUIT_ITEM                = 40,
    ---@alias 穿戴装备的总追加达到x级
    EQUIP_APPEND_TOTAL_LV         = 41,
    ---@alias 穿戴指定装备
    SPECIFIC_STAGE_EQUIP          = 42,
    ---@alias 尾刀击杀怪物
    LAST_KILL_MONSTER             = 43,
    ---@alias 镶嵌卡牌
    INLAID_TRANSFORMATION_CARD    = 44,
    ---@alias 完成勇气试炼X层
    FLUSH_BRAVE_TEST_LV           = 45,
    ---@alias 进入地图分线
    ENTER_MAP_LINE                = 46,
    ---@alias 首刀击杀怪物
    FIRST_ATTACK_MONSTER          = 47,
    ---@alias 合成卡牌
    SYNTHESIS_CARD                = 48,
    ---@alias 环任务数量
    LOOP_TASK_COUNT               = 49,
    ---@alias 查看客户端界面
    VIEW_CLIENT_PANEL             = 50,
    ---@alias 杀怪计数,只要对怪造成过伤害，怪物死亡后都计数
    KILL_MONSTER_COUNT            = 51,
    ---@alias 强化装备
    EQUIP_STRENGTHEN              = 52,
}

-- 内置任务类型
TaskGoal.GlobalType = {
    [1]  = true,
    [2]  = true,
    [3]  = true,
    [4]  = true,
    [5]  = true,
    [6]  = true,
    [7]  = true,
    [8]  = true,
    [9]  = true,
    [10] = true,
    [11] = true,
}

------------------------------------------------------------------
---内置任务类型
function this.isGlobalType(type)
    return TaskGoal.GlobalType[type] == true
end

---外置任务类型
function TaskGoal.isLuaGoalType(taskType)
    return TaskGoalHandler[taskType] ~= nil
end

---是否为已定义任务类型
function TaskGoal.IsTaskTargetType(taskTargetType)
    return this.isGlobalType(taskTargetType) or TaskGoal.isLuaGoalType(taskTargetType)
end

---刷新外置任务
function this.FlushLuaTaskGoalCount(actor, taskType, goal_id, goal_count, param)
    local goalHandler = TaskGoalHandler[taskType]
    if goalHandler then
        return goalHandler(actor, taskType, goal_id, goal_count, param)
    end
    error("Invalid task type: " .. tostring(taskType))
    return goal_count
end

function this.flushTaskCount(actor, type, goal_id, goal_count, param)
    local isGlobal = this.isGlobalType(type)
    if isGlobal then
        return flushtaskgoalcount(actor, type, goal_id, goal_count, param)
    elseif TaskGoal.isLuaGoalType(type) then
        return this.FlushLuaTaskGoalCount(actor, type, goal_id, goal_count, param)
    end
    return goal_count
end

---刷新任务目标数量
function TaskGoal.FlushTaskCount(actor, taskType, goal_id, goal_count, param)
    local success, result = xpcall(this.flushTaskCount, debug.traceback, actor, taskType, goal_id, goal_count, param)
    if not success then
        gameDebug.assertPrint(success, "更新任务目标数值异常:", result, "参数", actor, taskType, goal_id, goal_count, param)
        return goal_count
    end
    if string.isNullOrEmpty(result) then
        return goal_count
    end
    return tonumber(result)
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


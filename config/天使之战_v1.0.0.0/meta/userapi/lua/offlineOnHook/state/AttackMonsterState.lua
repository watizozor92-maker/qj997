-- 离线挂机攻击怪物状态模块
AttackMonsterState = {}
local this = {}
local LAST_ATTACK_TARGET_ID = "@_ON_HOOK_LAST_ATTACK_MONSTER_ID"
-- 处理攻击怪物状态
function AttackMonsterState.handle(actor, sx, sy, immutableCache)
    local mapId = immutableCache.mapId
    local open = immutableCache.autoPick
    local radius = immutableCache.radius
    -- 优先检查是否有道具需要拾取(拾取优先于打怪)
    -- 但如果处于拾取阻止期，则继续打怪

    local items = AutoPickupItem.getPickItems(actor, mapId, sx, sy, radius) -- 手动拾取才进入拾取状态, 自动拾取跟随所有状态进行
    if not table.isEmpty(items) and not open then
        StateManager.transformState(actor, StateManager.STATE_PICKUP_ITEM)
        return
    end
    local hungupSkillCount = immutableCache.hungupSkillCount
    local commAttackSkill = immutableCache.commAttackSkill
    if hungupSkillCount == 0 then
        -- 没有技能
        StateManager.transformState(actor, StateManager.STATE_NONE)
        return
    elseif hungupSkillCount == 1 then
        -- 只有普攻
        local monsters = getmapobjects(actor, mapId, sx, sy, radius, 2)
        if table.isEmpty(monsters) then
            StateManager.transformState(actor, StateManager.STATE_WAIT_MONSTER_REFRESH)
            return
        end
        --优先攻击上次攻击的对象
        local closestMonster = HookCommonUtils.findClosestMonster(actor, monsters, sx, sy, mapId)
        if not closestMonster then
            StateManager.transformState(actor, StateManager.STATE_WAIT_MONSTER_REFRESH)
            return
        end
        local targetId = getbaseinfo(closestMonster, "id")
        local lastAttackTargetId = this.getLastAttackMonsterId(actor)
        if lastAttackTargetId ~= nil then
            --是否存活
            local lastTargetActor = getactor(actor, lastAttackTargetId)
            if not isdead(lastTargetActor) then
                if isskillavailable(actor, commAttackSkill[1], commAttackSkill[2], lastAttackTargetId) then
                    targetId = lastAttackTargetId
                end
            end
        end
        -- local closestMonster = this.getClosestMonster(actor, sx, sy, radius, mapId)
        -- if not closestMonster then
        --     StateManager.transformState(actor, StateManager.STATE_WAIT_MONSTER_REFRESH)
        --     return
        -- end
        StateManager.resetNoMonsterTimer(actor)

        
        -- local ok = isskillavailable(actor, commAttackSkill[1], commAttackSkill[2], targetId)
        -- if not ok then
        --     this.afterRealseSkillFail(actor, sx, sy, closestMonster, immutableCache)
        --     return
        -- end
        local skillOk = skill(actor, commAttackSkill[1], commAttackSkill[2], targetId) --释放技能攻击
        -- 释放技能失败，可能是距离太远，尝试走向怪物
        if not skillOk then
            this.afterRealseSkillFail(actor, sx, sy, closestMonster, immutableCache)
            this.setLastAttackMonsterId(actor, nil)
        else
            this.setLastAttackMonsterId(actor, targetId)
        end
    else
        local monsters = getmapobjects(actor, mapId, sx, sy, radius, 2)
        if table.isEmpty(monsters) then
            StateManager.transformState(actor, StateManager.STATE_WAIT_MONSTER_REFRESH)
            return
        end
        StateManager.resetNoMonsterTimer(actor)

        local monsterCount = table.count(monsters)
        local effectedSkills = {}
        if monsterCount > 1 then
            effectedSkills = immutableCache.multiFilteredSkills
        else
            effectedSkills = immutableCache.singleFilteredSkills
        end
        local attackTargetId = nil
        if not table.isEmpty(effectedSkills) then
            local skillInfo = HookCommonUtils.selectSkill(actor, effectedSkills)
            local skillOk = false
            if skillInfo ~= nil then
                if skillInfo.calcArea > 0 then
                    local param = radius .. "#1" -- 90度范围
                    local areaTargets = getareaobjectlist(actor, 5, param, 2, 0, skillInfo.calcArea, 1)
                    if not table.isEmpty(areaTargets) then
                        this.overlayHurt(skillInfo.calcArea, areaTargets)
                        local targetId = areaTargets[1]

                        local lastAttackTargetId = this.getLastAttackMonsterId(actor)
                        if lastAttackTargetId ~= nil then
                            -- 移除areaTargets中的lastAttackTargetId
                            for i = #areaTargets, 1, -1 do
                                if tostring(areaTargets[i]) == tostring(lastAttackTargetId) then
                                    if #areaTargets == skillInfo.calcArea then
                                        table.remove(areaTargets, i)
                                    end
                                    targetId = lastAttackTargetId
                                    break
                                end
                            end
                        else
                            if #areaTargets == skillInfo.calcArea then
                                table.remove(areaTargets, 1)
                            end
                        end
                        attackTargetId = targetId
                        skillOk = skill(actor, skillInfo.id, skillInfo.level, targetId, areaTargets, 1, 0, 1)
                    else
                        skillOk, attackTargetId = this.attackClosestMonster(actor, sx, sy, monsters, mapId, skillInfo)
                    end
                else
                    skillOk, attackTargetId = this.attackClosestMonster(actor, sx, sy, monsters, mapId, skillInfo)
                end
            else
                -- 技能全都不可用, 使用普攻保底
                -- 技能筛选时判断过普攻是否可用, 这里重复判断, 会释放失败
                -- skillOk, attackTargetId = this.attackClosestMonster(actor, sx, sy, monsters, mapId, { id = commAttackSkill[1], commAttackSkill[1] })
                return 250
            end
            -- 释放技能失败，可能是距离太远，尝试走向怪物
            if not skillOk then
                this.setLastAttackMonsterId(actor, nil)
                local closestMonster = HookCommonUtils.findClosestMonster(actor, monsters, sx, sy, mapId)
                if not closestMonster then
                    -- 没有怪物, 等待刷新
                    return
                end
                this.afterRealseSkillFail(actor, sx, sy, closestMonster, immutableCache)
            else
                this.setLastAttackMonsterId(actor, attackTargetId)
            end
            return 250
        end
    end
end

function this.setLastAttackMonsterId(actor, monsterId)
    setplaydef(actor, LAST_ATTACK_TARGET_ID, monsterId)
end

function this.getLastAttackMonsterId(actor)
    return getplaydef(actor, LAST_ATTACK_TARGET_ID)
end

function this.getClosestMonster(actor, sx, sy, radius, mapId)
    local monsters = getmapobjects(actor, mapId, sx, sy, radius, 2)
    if table.isEmpty(monsters) then
        return nil
    end
    local closestMonster = HookCommonUtils.findClosestMonster(actor, monsters, sx, sy, mapId)
    return closestMonster
end

function this.attackClosestMonster(actor, sx, sy, monsters, mapId, skillInfo)
    local closestMonster = HookCommonUtils.findClosestMonster(actor, monsters, sx, sy, mapId)
    if not closestMonster then
        return false
    end
    local targetId = getbaseinfo(closestMonster, "id")
    local lastAttackTargetId = this.getLastAttackMonsterId(actor)
    if lastAttackTargetId ~= nil then
        --是否存活
        local lastTargetActor = getactor(actor, lastAttackTargetId)
        if not isdead(lastTargetActor) then
            targetId = lastAttackTargetId
        end
    end
    if isskillavailable(actor, skillInfo.id, skillInfo.level, targetId) then
        return skill(actor, skillInfo.id, skillInfo.level, targetId), targetId
    end
    return false
end

function this.overlayHurt(num, monsters)
    if #monsters < num then
        local diff = num - #monsters - 1
        for i = 1, diff do
            local id = monsters[math.random(#monsters)]
            table.insert(monsters, id)
        end
    end
end

-- 攻击失败后，尝试走向怪物
function this.afterRealseSkillFail(actor, sx, sy, closestMonster, immutableCache)
    local mx = closestMonster.x or getbaseinfo(closestMonster, "x")
    local my = closestMonster.y or getbaseinfo(closestMonster, "y")
    if not mx or type(mx) ~= "number" or mx <= 0 then
        local failCount = StateManager.getMoveFailCount(actor) + 1
        StateManager.setMoveFailCount(actor, failCount)

        -- 连续失败2次
        if failCount >= 2 then
            StateManager.setMoveFailCount(actor, 0)
            local toOrigin = HookCommonUtils.goToOrigin(actor, sx, sy, immutableCache)
            if not toOrigin then
                StateManager.transferAfterMoveFail(actor, immutableCache)
            end
        end
        return
    end
    local dis = HookCommonUtils.distance(sx, sy, mx, my)
    if dis > 1 then
        -- 不要直接移动到怪物坐标，而是移动到怪物附近的相邻点
        local targetX, targetY = HookCommonUtils.getAdjacentPoint(sx, sy, mx, my)
        if targetX and targetY then
            local moveOk = movetopoint(actor, targetX, targetY)

            if not moveOk then
                -- 移动失败，增加失败计数
                local failCount = StateManager.getMoveFailCount(actor) + 1
                StateManager.setMoveFailCount(actor, failCount)

                -- 连续失败2次
                if failCount >= 2 then
                    StateManager.setMoveFailCount(actor, 0)
                    local toOrigin = HookCommonUtils.goToOrigin(actor, sx, sy, immutableCache)
                    if not toOrigin then
                        StateManager.transferAfterMoveFail(actor, immutableCache)
                    end
                end
            else
                -- 移动成功，重置失败计数
                StateManager.setMoveFailCount(actor, 0)
            end
        else
            -- 无法计算相邻点，移动到原点
            local toOrigin = HookCommonUtils.goToOrigin(actor, sx, sy, immutableCache)
            if not toOrigin then
                StateManager.transferAfterMoveFail(actor, immutableCache)
            end
        end
    end
end

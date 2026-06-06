-- 离线挂机通用工具函数模块
HookCommonUtils = {}

-- 计算两点间距离
function HookCommonUtils.distance(x1, y1, x2, y2)
    -- 比切比雪夫距离公式计算的更长, 确保与目标点的距离更近
    local dx = math.abs(x1 - x2)
    local dy = math.abs(y1 - y2)
    return math.sqrt(dx * dx + dy * dy)
end

-- 寻找最近的怪物
function HookCommonUtils.findClosestMonster(actor, monsters, sx, sy, mapId)
    sx = sx or getbaseinfo(actor, "x")
    sy = sy or getbaseinfo(actor, "y")
    mapId = mapId or getbaseinfo(actor, "mapid")

    local closestMonster = nil --距离最近的怪物
    local minDis = 99999
    for _, monster in pairs(monsters) do
        local id = monster.id
        local mactor = getactor(actor, id, mapId)
        -- 先检查mactor是否为nil,避免空指针
        if mactor ~= nil and not isdead(mactor) then
            local mx = monster.x or getbaseinfo(mactor, "x")
            local my = monster.y or getbaseinfo(mactor, "y")
            local dis = HookCommonUtils.distance(sx, sy, mx, my)
            if dis < minDis then
                minDis = dis
                closestMonster = mactor
            end
        end
    end
    return closestMonster
end

-- 寻找最近的道具
function HookCommonUtils.findClosestItem(actor, items, sx, sy)
    sx = sx or getbaseinfo(actor, "x")
    sy = sy or getbaseinfo(actor, "y")

    local closestItem = nil
    local minDis = 99999
    for _, item in pairs(items) do
        if item.x ~= nil and item.y ~= nil then
            local dis = HookCommonUtils.distance(sx, sy, item.x, item.y)
            if dis < minDis then
                minDis = dis
                closestItem = item
            end
        end
    end
    return closestItem, minDis
end

-- 选择可用技能
function HookCommonUtils.selectSkill(actor, skillList, targetId)
    for _, skill in ipairs(skillList) do
        -- local ok = isskillavailable(actor, skill.id, skill.level, targetId)
        local ok = isskillavailable(actor, skill.id, skill.level)
        local canRelease = AGAndSD.CanReleaseNoDeduction(actor, skill.id, skill.level)
        if ok and canRelease then
            return skill
        end
    end
    return nil
end

-- 获取挂机的拾取范围设置
function HookCommonUtils.getPlayerHookPickRang(actor)
    local extPickUpSetting = getinnerusedextdata(actor, "extPickUpSetting") or {}
    local value = ConfigDataManager.getTableValue("cfg_global", "value", "id", 230)
    value = string.tonumber(value)
    local autoPickRange = extPickUpSetting.playerPickRange or value
    return autoPickRange
end

-- 获取挂机的杀怪范围,回到原点时间设置
function HookCommonUtils.getPlayerHookSetting(actor)
    local hungupSetting = getplayersetting(actor).hangupsetting
    local killMonsterRange = hungupSetting.killmonsterrange or 8
    local returntime = hungupSetting.returntime or 10
    local lessthan = hungupSetting.lessthan or "0,0"
    local skillscheme = hungupSetting.skillscheme or ""
    local schemeid = hungupSetting.schemeid or ""
    lessthan = string.split(lessthan, ",")
    local lessthanSetting = { hp = tonumber(lessthan[1]), mp = tonumber(lessthan[2]) }
    local skills = {}
    local schemes = string.split(skillscheme, "&")
    for _, scheme in ipairs(schemes) do
        local skillsetting = string.split(scheme, "|")
        if tonumber(schemeid) == tonumber(skillsetting[1]) then
            skills = string.splitInt(skillsetting[2], "#")
        end
    end
    return killMonsterRange, returntime, lessthanSetting, skills
end

-- 计算从当前位置朝目标方向移动一格的相邻点坐标
-- 用于避免直接移动到怪物所在格子，而是移动到怪物附近
function HookCommonUtils.getAdjacentPoint(sx, sy, mx, my)
    local dx = mx - sx
    local dy = my - sy
    if math.abs(dx) <= 1 and math.abs(dy) <= 1 then
        return sx, sy
    end

    -- 标准化方向（取-1, 0, 1）
    if dx > 0 then
        dx = 1
    elseif dx < 0 then
        dx = -1
    end

    if dy > 0 then
        dy = 1
    elseif dy < 0 then
        dy = -1
    end

    -- 返回朝怪物方向移动一格的坐标
    return sx + dx, sy + dy
end

-- 向初始位置移动一格
function HookCommonUtils.goToOrigin(actor, sx, sy, immutableCache)
    sx = sx or getbaseinfo(actor, "x")
    sy = sy or getbaseinfo(actor, "y")
    local originX, originY = immutableCache.originx, immutableCache.originy
    if originX == nil or originY == nil then
        return
    end
    local x, y = HookCommonUtils.getAdjacentPoint(sx, sy, originX, originY)
    return movetopoint(actor, x, y)
end

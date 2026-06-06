function math.calcRotateAngle(angle1, angle2)
    local d = (angle2 - angle1) % 360
    if d > 180 then
        d = d - 360
    end
    return angle1 + d
end

function math.floatEquals(a, b)
    return math.abs(a - b) < Mathf.Epsilon
end

function math.sign(a)
    if a > 0 then
        return 1
    elseif a < 0 then
        return -1
    end
    return 0
end

function math.round(a)
    return math.floor(a + 0.5)
end

function math.randomFloat(min, max, multiple)
    if min > max then
        min, max = max, min
    end
    if multiple == nil then
        multiple = 10000
    end
    local int_min = math.floor(min * multiple)
    local int_max = math.ceil(max * multiple)
    local random_int = math.random(int_min, int_max)
    return random_int / multiple
end

function math.selectRate(probability)
    local randomNum = math.random()
    return randomNum <= probability
end

function math.shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

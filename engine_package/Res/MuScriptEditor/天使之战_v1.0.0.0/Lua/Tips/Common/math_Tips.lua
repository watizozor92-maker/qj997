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
    if a>0 then
        return 1
    elseif a<0 then
        return -1
    end
    return 0
end 

function math.round(a)
    return math.floor(a+0.5)
end 
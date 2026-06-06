---@class array
array = {}

function array.clear(t)
    local count = #t
    for i = 1, count do
        table.remove(t)
    end
end

function array.length(t)
    return t and #t or 0
end

function array.contains(t, item)
    return array.indexOf(t, item) ~= nil
end

function array.indexOf(t, item)
    for k, v in ipairs(t) do
        if v == item then
            return k
        end
    end
    return nil
end

function array.random(t)
    math.randomseed(os.time())
    for i = 1, #t do
        local j = math.random(i)
        table[i], table[j] = table[j], table[i]
    end
end


function array.deepCopy(tableToCopy)
    local copy = {}

    for key, value in pairs(tableToCopy) do
        if type(value) == 'table' then
            copy[key] = array.deepCopy(value)
        else
            copy[key] = value
        end
    end

    return copy
end

-- 去重
function array.removeDup(arr)
    local seen = {}
    local result = {}
    for _, v in ipairs(arr) do
        if not seen[v] then
            seen[v] = true
            table.insert(result, v)
        end
    end
    return result
end

-- 忽略string,number类型的比较
function array.simpleContains(t, item)
    local itemStr = tostring(item)
    for _, v in ipairs(t) do
        local vStr = tostring(v)
        if vStr == itemStr then
            return true
        end
    end
    return false
end


function t_other(actor)
    lg(getbagdata(actor))
    lg(getallbagiteminfo(actor))
end

function t_other2(actor, itemId)
    setitemextdata(actor, itemId, { baseAttr= {},isInit= true})
end

-- =============================打印调试========================================
local debug = require 'debug'
local openlog = true
function lg(...)
    if not openlog then
        return
    end
    local args = table.pack(...)
    local message = FormatArgs(args)
    local info = debug.getinfo(2, 'nSlu')
    local count = 0
    while not info do
        if count > 10 then
            error("打印栈的深度过深")
            print("打印栈的深度过深")
            return
        end
        count = count + 1
        info = debug.getinfo(2 + count, 'nSlu')
    end
    -- local begin = info.linedefined
    -- local over = info.lastlinedefined
    local currLine = info.currentline
    -- local name = info.name
    -- local short_src = info.short_src
    -- local result = short_src:match("[^\\]+%.lua$")
    local callerInfo = string.format(" ===> %s%d%s",
        -- result,
        -- name,
        -- begin,
        -- over,
        "★",
        currLine,
        "★")
    local msg = callerInfo .. " " .. message
    -- error(msg)
    print(msg)
    return msg
end

-- 格式化参数
function FormatArgs(args)
    local formattedMessage = ""
    for i = 1, args.n do
        if type(args[i]) == "table" then
            formattedMessage = formattedMessage .. TableToString(args[i]) .. " "
        elseif type(args[i]) == "userdata" then
            formattedMessage = formattedMessage .. UserDataToString(args[i]) .. " "
        else
            formattedMessage = formattedMessage .. tostring(args[i]) .. "(" .. GetLogTip(args[i]) .. ") "
        end
    end
    return formattedMessage
end

function UserDataToString(userdata)
    return userdata:toString() .. " (U)"
end

function TableToString(t, indent)
    indent = indent or 0
    local str = "{\n"
    local isFirst = true

    if table.isArray(t) then
        -- 处理数组类型的表
        for k, v in ipairs(t) do
            if isFirst then
                isFirst = false
            else
                str = str .. ",\n"
            end
            str = str .. string.rep("  ", indent + 1) .. k .. ": "
            if type(v) == "table" then
                str = str .. TableToString(v, indent + 1)
            elseif type(v) == "userdata" then
                str = str .. UserDataToString(v)
            else
                str = str .. tostring(v) .. "(" .. GetLogTip(v) .. ") "
            end
        end
    else
        -- 处理哈希表
        for k, v in pairs(t) do
            if isFirst then
                isFirst = false
            else
                str = str .. ",\n"
            end
            str = str .. string.rep("  ", indent + 1) .. tostring(k) .. ": "
            if type(v) == "table" then
                str = str .. TableToString(v, indent + 1)
            elseif type(v) == "userdata" then
                str = str .. UserDataToString(v)
            else
                str = str .. tostring(v) .. "(" .. GetLogTip(v) .. ") "
            end
        end
    end
    str = str .. "\n" .. string.rep("  ", indent) .. "}"
    return str
end

function GetLogTip(v)
    if type(v) == "string" then
        if string.trim(v) == "" then
            return "空"
        end
        return "S"
    elseif type(v) == "boolean" then
        return "B"
    elseif type(v) == "number" then
        return "N"
    elseif type(v) == "nil" then
        return "×"
    end
end

local msgId = 112233
function toclient(actor, msg)
    if not openlog then
        return
    end
    msg = string.gsub(msg, "\n", "")
    sendluamsg(actor, msgId, "日志信息:" .. msg)
end

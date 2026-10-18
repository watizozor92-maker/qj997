--日志开启规则
--Editor or 非Editor:
--1 默认日志关闭,GM面板打开或者关闭，走PlayerPref
--2 GM面板上面的日志，默认关闭，不走PlayerPref
--3 ResourceManager 下载失败SetLogError，编辑器下始终打开，移动端和LogEnable一致
local Debug = CS.UnityEngine.Debug
isDebugBuild = Debug.isDebugBuild
local logEnable = isDebugBuild
local logErrorEnable = true
local isLuaByteMode = CS.Main.IsEditorLuaByteMode()
local tracebacks = {}
local TRACEBACK_SPACE = '             '

--- 获取 Unity Console 可点击堆栈使用的 Lua 文件路径
---@param shortSrc string debug.getinfo 返回的 short_src
---@param isMobile boolean 是否移动端平台
---@return string path Lua 文件相对路径
local function getTracebackPath(shortSrc, isMobile)
    local path = shortSrc
    if not isMobile then
        path = string.replace(path, "[string \"", "")
        path = string.replace(path, "\"]", "")
    end
    return string.endsWith(path, '.lua') and ('Assets/Lua/'..path) or ('Assets/Lua/'..path..'.lua')
end

--- 追加 Unity Console 可点击堆栈链接
---@param list table 堆栈字符串片段列表
---@param path string Lua 文件相对路径
---@param line number 行号
local function appendTracebackLink(list, path, line)
    list[#list+1] = '<a href="'
    list[#list+1] = path
    list[#list+1] = '" line="'
    list[#list+1] = line
    list[#list+1] = '">'
    list[#list+1] = path
    list[#list+1] = ':'
    list[#list+1] = line
    list[#list+1] = '</a>'
end
function enableLog(b)
    logEnable = b
    KmlManager.LogEnable(b)
    UtilityLua.OpenResourceLog(b)
end

local function concat(...)
    local args = spack(...)
    for i = 1, args.n do
        args[i] = tostring(args[i])
    end
    return table.concat(args, "\t")
end

local function hasLuaTraceback(content)
    return type(content) == "string" and string.find(content, "stack traceback:", 1, true) ~= nil
end

local function logPrint(content,logType)
    content = '(frameCount='..tostring(Time.frameCount)..') '..content
    if logType==ELogType.Log or logType==ELogType.Message  then
        Debug.Log(content);
    elseif logType==ELogType.Warning then
        Debug.LogWarning(content);
    elseif logType==ELogType.Error then
        Debug.LogError(content);        
    end
    EventManager.Dispatch(Event.Show_LogType,logType,content)
    --Debug.Log()
end

function log(...)  
    if logEnable then
        --Debug.Log(concat(...) .. "\n" ..redirectStaceback())
        logPrint(concat(...) .. "\n" ..redirectStaceback(),ELogType.Log)
        --redirectStaceback()
    end
end

---@return void @不会被AnyAssetPostProcessor自动加上DebugFlag.LogEnable。比如连接服务器或者其他重要的日志，希望一直开着日志
function logNoFlag(...)
    --Debug.Log(concat(...) .. "\n" ..redirectStaceback())
    logPrint(concat(...) .. "\n" ..redirectStaceback(),ELogType.Log)
    --redirectStaceback()
end

function logNoFlagToUnityObject(info,unityObj)
    --Debug.Log(concat(...) .. "\n" ..redirectStaceback())
    local content = '(frameCount='..tostring(Time.frameCount)..') '..info .. "\n" ..redirectStaceback()
    Debug.Log(content,unityObj);
    --redirectStaceback()
end

function logNoFlagNoEnable(...)
    logPrint(concat(...) .. "\n" ..redirectStaceback(),ELogType.Log)
end

function logWarning(...)
    if logEnable then
        logPrint(concat(...) .. "\n" ..redirectStaceback(),ELogType.Warning)
        --Debug.LogWarning(concat(...) .. "\n" .. redirectStaceback())
    end
end

function logError(...)
    if logErrorEnable then
        local content = concat(...)
        if hasLuaTraceback(content) then
            Debug.LogError('(frameCount='..tostring(Time.frameCount)..') '.. content)
        else
            Debug.LogError('(frameCount='..tostring(Time.frameCount)..') '.. content .. "\n" .. redirectStaceback())
        end
        --logPrint('(frameCount='..tostring(Time.frameCount)..') '.. concat(...) .. "\n" .. redirectStaceback(),ELogType.Error)
    end
end

function logColorError(...)
    if logEnable then
        Debug.Log('<color=red>logColorError(frameCount='..tostring(Time.frameCount)..') '.. concat(...) .. "</color>\n" .. redirectStaceback())
        --logPrint('(frameCount='..tostring(Time.frameCount)..') '.. concat(...) .. "\n" .. redirectStaceback(),ELogType.Error)
    end
end

---@return void @为了同样的打印能够显示在一行
function logNoFrameCount(...)
    if logEnable then
        Debug.Log( concat(...) .. "\n" .. redirectStaceback())
        --logPrint('(frameCount='..tostring(Time.frameCount)..') '.. concat(...) .. "\n" .. redirectStaceback(),ELogType.Error)
    end
end

---@return void @为了同样的打印能够显示在一行
function logErrorNoFrameCount(...)
    if logErrorEnable then
        Debug.LogError( concat(...) .. "\n" .. redirectStaceback())
        --logPrint('(frameCount='..tostring(Time.frameCount)..') '.. concat(...) .. "\n" .. redirectStaceback(),ELogType.Error)
    end
end

function logOnEditor(...)
    if Main and  (Main.isEditor or Main.isXtra) then
        if logEnable then
            Debug.LogError('(仅编辑器或者启动器)(frameCount='..tostring(Time.frameCount)..') '.. concat(...) .. "\n" .. redirectStaceback())
            --logPrint('(frameCount='..tostring(Time.frameCount)..') '.. concat(...) .. "\n" .. redirectStaceback(),ELogType.Error)
        end
    end
end

function logErrorOnEditor(...)
    if Main and (Main.isEditor or Main.isXtra) then
        if logErrorEnable then
            Debug.LogError('(仅编辑器或者启动器)(frameCount='..tostring(Time.frameCount)..') '.. concat(...) .. "\n" .. redirectStaceback())
            --logPrint('(frameCount='..tostring(Time.frameCount)..') '.. concat(...) .. "\n" .. redirectStaceback(),ELogType.Error)
        end
    end
end


--#ff8400
function logColor(...)
    if logEnable then
        local args = spack(...)
        local color = table.remove(args,1)
        args.n =  args.n-1
        for i = 1, args.n do
            args[i] = tostring(args[i])
        end
        Debug.Log(string.format("<color=%s>%s</color>%s",color,table.concat(args, "\t"),"\n" .. redirectStaceback()))
    end
end

function logNetColor(...)
    if logEnable then
        local args = spack(...)
        local color = table.remove(args,1)
        local first = table.remove(args,1)
        args.n = args.n-2
        for i = 1, args.n do
            args[i] = tostring(args[i])
        end
        --Debug.Log(string.format("<color=%s>%s</color>%s%s",color,first,table.concat(args, "\t"),"\n" .. redirectStaceback()))
        logPrint(string.format("<color=%s>%s</color>%s%s",color,first,table.concat(args, "\t"),"\n" .. redirectStaceback()),ELogType.Message)
    end
end

function logNetColorSend(...)
    if logEnable then
        local args = spack(...)
        local color = table.remove(args,1)
        local first = table.remove(args,1)
        args.n = args.n-2
        for i = 1, args.n do
            args[i] = tostring(args[i])
        end
        --Debug.Log(string.format("<color=%s>%s</color>%s%s",color,first,table.concat(args, "\t"),"\n" .. redirectStaceback()))
        logPrint(string.format("<color=%s>%s</color>%s",color,first,table.concat(args, "\t")),ELogType.Message)
    end
end

function redirectStaceback()
    if (Main and not Main.isEditor) or isLuaByteMode then
        --debug.traceback消耗巨大,导致使用二进制或者移动端打印一个堆栈较深的日志都巨卡
        --return debug.traceback()
        table.clear(tracebacks)
        tracebacks[#tracebacks+1] = 'stack traceback:\n'
        for level=3,math.huge do
            ---@type DebugInfo
            local fInfo = debug.getinfo(level, 'nSl')
            if not fInfo then
                break
            end
            tracebacks[#tracebacks+1] = TRACEBACK_SPACE
            tracebacks[#tracebacks+1] = fInfo.short_src
            tracebacks[#tracebacks+1] = '.lua:'
            tracebacks[#tracebacks+1] = fInfo.currentline
            if fInfo.name then
                tracebacks[#tracebacks+1] = ':'
                tracebacks[#tracebacks+1] = fInfo.name
            end
            tracebacks[#tracebacks+1] = '\n'
        end
        return table.concat(tracebacks)
    else
        --<a href=\"Assets/Scripts/MovablePlatform.cs\" line=\"7\">Assets/Scripts/MovablePlatform.cs:7</a>
        table.clear(tracebacks)
        tracebacks[#tracebacks+1] = 'stack traceback:\n'
        local isMobile = CS.TCFramework.Platform.isMobile
        for level=3,math.huge do
            ---@type DebugInfo
            local fInfo = debug.getinfo(level, 'nSl')
            if not fInfo then
                break
            end
            tracebacks[#tracebacks+1] = TRACEBACK_SPACE
            tracebacks[#tracebacks+1] = fInfo.short_src
            tracebacks[#tracebacks+1] = ':'
            tracebacks[#tracebacks+1] = fInfo.currentline
            local p0 = getTracebackPath(fInfo.short_src, isMobile)
            local p1 = fInfo.currentline
            if fInfo.name then
                --local clickPath ='(in '..fInfo.namewhat..' \''..fInfo.name..'\') (at Assets/Lua/'..path..'.lua:'..fInfo.currentline..')'
                tracebacks[#tracebacks+1] = '(in '
                tracebacks[#tracebacks+1] = fInfo.namewhat
                tracebacks[#tracebacks+1] = ' \''
                tracebacks[#tracebacks+1] = fInfo.name
                tracebacks[#tracebacks+1] = '\') (at '
                appendTracebackLink(tracebacks, p0, p1)
                tracebacks[#tracebacks+1] = ')\n'
            else
                tracebacks[#tracebacks+1] = '\') (at '
                appendTracebackLink(tracebacks, p0, p1)
                tracebacks[#tracebacks+1] = ')\n'
            end

        end
        return table.concat(tracebacks)
    end
end
local infoPatten = '([^:]+):'
function redirectInfo(content)
    if not Main.isEditor or isLuaByteMode then
        return content
    end
    local lines = string.split(content,'\n')
    content = ''
    local info = {}
    for k, v in pairs(lines) do
        local line = v..':'
        local index = 1
        for k2, v2 in string.gmatch(line,infoPatten) do
            info[index] = k2
            index = index+1
        end
        if index - 1 == 3 then
            line = line..') (at Assets/Lua/'..string.trimLeft(info[1],'\t')..'.lua:'..info[2]..')'
        end
        content = content..line..'\n'
    end
    --CS.UnityEngine.Debug.LogError(content)
    return content
end

---@return string @调试用的
function getTableName(table)
    if not Main.isEditor then
        return string.empty
    end
    if type(table) ~= 'table' then
        logError('传入的参数不是table类型')
        return
    end
    for k, v in pairs(_G) do
        if k == 'Body' then
            local s= ''
        end
        if IsSubTypeOfTryCatch(table,v) then
           return k
        end
    end
end

---@return any @仅支持全局table或者基类是全局表的table
function logTableName(table)
    log(getTableName(table))
end

function logErrorTableName(table)
    logError(getTableName(table))
end




print = log

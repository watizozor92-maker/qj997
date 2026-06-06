local function call(t, ...)
    local o = {}
    --不支持子类中有自定义的get或者set,这里的t相当于c。比如PlayerData，减少__index函数的调用
    t.__getterse = t.__getterse
    t.__setterse = t.__setterse
    setmetatable(o, t)
    if o.ctor then
        o:ctor(...)
    end
    return o
end
function class(...)
    local c = {}
    local m = {}

    -- 构造函数
    --m.__call = call
    m.__call = function(t, ...)
        --if t.ctorCall then
        --    return t.ctorCall(t,...)
        --else
        --    local o = {}
        --    --不支持子类中有自定义的get或者set,这里的t相当于c。比如PlayerData，减少__index函数的调用
        --    t.__getterse = t.__getterse
        --    t.__setterse = t.__setterse
        --    setmetatable(o, t)
        --    if o.ctor then
        --        o:ctor(...)
        --    end
        --    return o
        --end
        local o = {}
        --不支持子类中有自定义的get或者set,这里的t相当于c。比如PlayerData，减少__index函数的调用
        t.__getterse = t.__getterse
        t.__setterse = t.__setterse
        setmetatable(o, t)
        if o.ctor then
            o:ctor(...)
        end
        return o
    end

    -- 多重继承
    local isMutilBases = false
    c.__bases = {...}
    if #c.__bases>=3 then
        if type(c.__bases[#c.__bases]) == 'boolean' and type(c.__bases[#c.__bases-1]) == 'boolean' and
                type(c.__bases[#c.__bases-2]) == 'boolean' then
            isMutilBases = c.__bases[#c.__bases] == true
            c.__bases[#c.__bases] = nil
            c.isClassInternalSet = c.__bases[#c.__bases] == true
            c.__bases[#c.__bases] = nil
            c.isClassInternalGet = c.__bases[#c.__bases] == true
            c.__bases[#c.__bases] = nil
        end
    end
    if isMutilBases then
        if #c.__bases>0 then
            m.__index = function(t, k)
                for _, base in ipairs(t.__bases) do
                    local v = base[k]
                    if v then
                        return v
                    end
                end
            end
        end
    else
        if #c.__bases > 0 then
            m.__index = c.__bases[1]
        end
    end
    setmetatable(c, m)
    if not c.isClassInternalGet and not c.isClassInternalSet then
        c.__index = c
    else
        if c.isClassInternalGet then
            -- 查找访问器
            --c.__gettere = function (t, k)
            --    local getters = rawget(t, "__getterse")
            --    local v = getters and getters[k]
            --    if v then
            --        return v
            --    end
            --    
            --    for _, base in ipairs(t.__bases) do
            --        v = base.__gettere and base:__gettere(k)
            --        if v then
            --            --rawset(t,"__getterse",base.__getterse)
            --            return v
            --        end
            --    end
            --end
            c.__index = function (t, k)
                local v = c[k]
                if v then
                    return v
                end
                v = c['__getterse']
                local gettere = v[k]
                if gettere then
                    return gettere(t)
                end
                --gettere =c.__gettere and c:__gettere(k)
                --if gettere then
                --    return gettere(t)
                --end
            end
        else
            c.__index = c
        end

        if c.isClassInternalSet then
            -- 查找设置器
            --c.__settere  = function (t, k)
            --    local setters = rawget(t, "__setterse")
            --    local v = setters and setters[k]
            --    if v then
            --        return v
            --    end
            --
            --    for _, base in ipairs(t.__bases) do
            --        v = base.__settere and base:__settere(k)
            --        if v then
            --            --rawset(t,"__setterse",base.__setterse)
            --            return v
            --        end
            --    end
            --end

            c.__newindex = function (t, k, v)
                local s = c['__setterse']
                local settere =  s[k]
                if settere then
                    settere(t,v)
                    return
                end
                rawset(t, k, v)
                --settere = c.__settere and c:__settere(k)
                --if settere then
                --    settere(t, v)
                --else
                --    rawset(t, k, v)
                --end
            end
        else

        end

    end


    return c
end

local GetSetParam = { isClassInternalGet = false, isClassInternalSet = false,initCacheCount = 0}

function FillGetSetParam(isClassInternalGet,isClassInternalSet,isMutilBases)
    --GetSetParam.isClassInternalGet = isClassInternalGet
    --GetSetParam.isClassInternalSet = isClassInternalSet
    --GetSetParam.initCacheCount = initCacheCount
    --return GetSetParam
    if isMutilBases == nil then
        isMutilBases = false
    end
    return isClassInternalGet,isClassInternalSet,isMutilBases
end
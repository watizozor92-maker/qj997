local beginDefineGlobalCount = 0

function DisableGlobal()
    setmetatable(_G, {
        __newindex = function(_, name, value)
            if beginDefineGlobalCount > 0 then
                rawset(_G, name, value)
            else
                error(string.format('Use "DefineGlobal("%s", value)" to define a global variable\n%s', name, debug.traceback("", 2)), 0)
            end
        end
    })
end

function DefineGlobal(name, value)
    rawset(_G, name, value)
end

function BeginDefineGlobal()
    beginDefineGlobalCount = beginDefineGlobalCount + 1
end

function EndDefineGlobal()
    beginDefineGlobalCount = beginDefineGlobalCount - 1
end
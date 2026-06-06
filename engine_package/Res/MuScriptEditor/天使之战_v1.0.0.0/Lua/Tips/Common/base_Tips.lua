pack = pack or table.pack
unpack = unpack or table.unpack

-- 解决原生pack的nil截断问题，spack与sunpack要成对使用
function spack(...)
    local params = {...}
    params.n = select('#', ...)
    return params
end

function sunpack(params)
    return unpack(params, 1, params.n)
end

function trequire(path)
    local ok, error = pcall(require, path)
    if not ok then
        logError(error)
    end
    return ok and error
end

function rrequire(path)
    package.loaded[path] = nil
    --需要添加一个模板名称
    local tbl = require(path)
    tbl.chunkName = string.match(path, "[^%/]+%w$")
    return tbl
end

function rtrequire(path)
    package.loaded[path] = nil
    return trequire(path)
end


function scall(func, ...)
    if not func then
        return
    end

    local args = spack(...)
    if #args == 0 then
        return xpcall(func, logError)
    else
        return xpcall(function ()
            return func(sunpack(args))
        end, logError)
    end
end

local enumId = 0
function enum(n)
    enumId = n or enumId + 1
	return enumId
end

function bind(self, callback)
    return callback and function (...)
        return callback(self, ...)
    end
end
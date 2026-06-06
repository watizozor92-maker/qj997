---@class StringPool
StringPool = {}
---@class str2id
local str2id = {}

function StringPool.ToID(str)
    local id = str2id[str]
    if not id then
        id = CS.TCFramework.StringPool.Add(str)
        str2id[str] = id
    end
    return id
end
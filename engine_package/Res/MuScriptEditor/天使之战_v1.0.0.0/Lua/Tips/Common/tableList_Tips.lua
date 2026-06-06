---@class tableList @注释 用来减少table的不停创建.
---注意self.list里面的元素不能重复，不然操作引用会引起问题
tableList = class()
local this = tableList
function this:ctor()
    self.n = 0
    self.list = {}
end

function this:Add(data)
    self.n = self.n+1
    self.list[self.n] = data 
end

function this:RemoveAt(pos)
    --超过当前数量，跳过删除逻辑
    if pos >self.n then
        return
    end
    table.remove(self.list, pos)
    self.n = self.n - 1
end

function this:Insert(pos,data)
    if pos>self.n then
        return
    end
    table.insert(self.list,pos,data)
    self.n = self.n+1
end
---@return any @其他地方不能直接持有引用，不然外部其他地方的引用和self.list里面的引用重复，处理数据会导致异常
function this:Get(pos)
    if pos > self.n then
        return nil
    end
    return self.list[pos]
end

function this:GetLast()
    return self.list[self.n]
end

---@return any @GetCache返回的值要再使用的话，要通过Add或者其他地方不能直接持有引用，不然外部其他地方的引用和self.list里面的引用重复，处理数据会导致异常
function this:GetCache()
    return self.list[self.n+1]
end

function this:Count()
    return self.n
end

function this:Clear()
    self.n = 0
end

function this:Release()
    self.list = {}
    self.n = 0
end


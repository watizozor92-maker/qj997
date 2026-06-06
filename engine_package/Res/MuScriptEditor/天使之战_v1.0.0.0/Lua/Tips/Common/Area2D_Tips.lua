---@class Area2D @二维坐标分块，适用于静态坐标数据的遍历
---@field blockDatas table<number,any[]>
Area2D = class()
local this = Area2D
local dir9 = 
{
    {0,0},
    {-1,1},
    {0,1},
    {1,1},
    {-1,0},
    {1,0},
    {-1,-1},
    {0,-1},
    {1,-1},
}
---左下角为起始点
function this:ctor(orginX,orginZ, cellX,cellZ)
    self.orginX = orginX
    self.orginZ = orginZ
    self.cellX = cellX
    self.cellZ = cellZ
    self.blockDatas = {}
    self.checkKey = -1
    self.isOpenCheck = true
    self.lastNearlyEightDatas = {}
    self.nearlyEightDatas = {}
    self.returnData = {}
end
---@param obj any
---@return void @不要重复添加，内部没有判断重复
function this:Add(x,z,obj)
    local key = self:GetKey(x,z)
    if not self.blockDatas[key] then
        self.blockDatas[key] = {}
        self.blockDatas[key].key = key
        self.blockDatas[key].datas = {}
    end
    --for k, v in pairs(self.blockDatas[key].datas) do
    --    if v == obj then
    --        logError('samle = '.. table.toStringJsonFormat(obj))
    --    end
    --end
    table.insert(self.blockDatas[key].datas,obj)
end

function this:GetKey(x,z)
    local indexX = Mathf.Floor((x - self.orginX)/self.cellX)
    local indexZ = Mathf.Floor((z - self.orginZ)/self.cellZ)
    return indexX*10000+indexZ
end

function this:GetKeyByAreaIndex(areaIndexX,areaIndexZ)
    return areaIndexX*10000+areaIndexZ
end

function this:SplitKey(key)
    local indexX = Mathf.Floor(key/10000)
    local indexZ = Mathf.Floor(key%10000)
    return indexX,indexZ
end

---@return any[]
function this:GetData(x,z)
    local key = self:GetKey(x,z)
    return self.blockDatas[key]
end

function this:IsExist(key)
    return self.blockDatas[key]~=nil
end

---@return any[]
function this:GetDataByKey(key)
    return self.blockDatas[key]
end

function this:SetOpenCheck(b)
    self.isOpenCheck = b
end

function this:GetNearlyDatas(blockx, blockz, func, funcData)
    local index = 1
    for k, v in pairs(dir9) do
        local nx = blockx+v[1]
        local nz = blockz+v[2]
        local key = self:GetKeyByAreaIndex(nx,nz)
        self.nearlyEightDatas[index] = self:GetDataByKey(key)
        index = index+1
    end
    return self.nearlyEightDatas
end

function this:GetNearlyDatasByKey(key)
    local blockx,blockz = self:SplitKey(key)
    return self:GetNearlyDatas(blockx,blockz)
end

function this:CheckBlack(x,z,func,funcData)
    if not self.isOpenCheck then
        return
    end
    local checkKey = self:GetKey(x,z)
    if self.checkKey == checkKey then
        return
    end
    self.checkKey = checkKey
    --if not self:IsExist(checkKey) then
    --    table.clear(lastNearlyEightDatas)
    --    table.copyFrom(lastNearlyEightDatas,nearlyEightDatas)
    --    table.clear(nearlyEightDatas)
    --    if table.count(lastNearlyEightDatas)~=0 then
    --        local removeDatas = {}
    --        table.copyFrom(removeDatas,lastNearlyEightDatas)
    --        returnData[1] = checkKey
    --        returnData[2] = removeDatas --移除的块
    --        returnData[3] = nil --新增的块
    --        if func then
    --            func(funcData,returnData)
    --        end
    --    end
    --    return
    --end
    table.clear(self.lastNearlyEightDatas)
    table.copyFrom(self.lastNearlyEightDatas,self.nearlyEightDatas)
    self.nearlyEightDatas = self:GetNearlyDatasByKey(checkKey)
    local removeDatas = nil
    local addDatas = nil
    for k, v in pairs(self.lastNearlyEightDatas) do
        local isFind = false
        for k2, v2 in pairs(self.nearlyEightDatas) do
            if v.key == v2.key then
                isFind = true
                break
            end
        end
        if not isFind then
            if not removeDatas then
                removeDatas = {}
            end
            table.insert(removeDatas,v)
        end
    end

    for k, v in pairs(self.nearlyEightDatas) do
        local isFind = false
        for k2, v2 in pairs(self.lastNearlyEightDatas) do
            if v.key == v2.key then
                isFind = true
                break
            end
        end
        if not isFind then
            if not addDatas then
                addDatas = {}
            end
            table.insert(addDatas,v)
        end
    end
    
    self.returnData[1] = checkKey
    self.returnData[2] = removeDatas --移除的块
    self.returnData[3] = addDatas --新增的块
    
    if func then
        func(funcData,self.returnData)
    end
end

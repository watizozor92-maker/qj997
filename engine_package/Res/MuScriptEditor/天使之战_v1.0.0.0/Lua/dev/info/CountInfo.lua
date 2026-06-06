---@class CountInfo
CountInfo = class()
local this = CountInfo

function this:ctor()
end

function this:Reset()
    this.TotalRefreshTbl = {}
    -- this.KeyGroupEventTbl = {}
end

--总countKey数据表
this.TotalRefreshTbl = {}
--group表 刷新事件
this.KeyGroupEventTbl = {}

--数据刷新类型
this.TypeEnum =
{
    --eg:Recharge = count表内group,
    DAILY_PACK_RECHARGE_CHANGE = 2,
    WEEK_PACK_RECHARGE_CHANGE = 8,
    NOOB_PACK_RECHARGE_CHANGE = 10,
    LifetimeGift = 6,
    OpenServerAthleticsGift = 13,
    MOUNT_PRE_COUNT_RECHARGE = 7,
    DAILY_DIAMOND_RECHARGE_CHANGE = 12,
    OPERATE_ADD_RECHARGE_CHANGE = 16,
    RUNACTIVE_DIRECT_COUNT_CHANGE = 15,
}

---@class CountTbl
---@field key number @Count_count表id
---@field count number @已使用次数
---@field total number @总次数

function this:Init()
    self:InitData()
    self:RegistMessages()

    -- this.KeyGroupEventTbl[this.TypeEnum.Recharge] = OutEvent 新增事件
    this.KeyGroupEventTbl[this.TypeEnum.DAILY_PACK_RECHARGE_CHANGE] = LUA_EVENT_DAILYPACK_RECHARGE_COUNT_CHANGE
    this.KeyGroupEventTbl[this.TypeEnum.WEEK_PACK_RECHARGE_CHANGE] = LUA_EVENT_WEEKPACK_RECHARGE_COUNT_CHANGE
    this.KeyGroupEventTbl[this.TypeEnum.LifetimeGift] = LUA_EVENT_LIFETIME_GIFT_COUNT_RECHARGE_CHANGE
    this.KeyGroupEventTbl[this.TypeEnum.NOOB_PACK_RECHARGE_CHANGE] = LUA_EVENT_NOOBPACK_RECHARGE_COUNT_CHANGE
    this.KeyGroupEventTbl[this.TypeEnum.OpenServerAthleticsGift] = LUA_OPEN_SERVER_GIFT_COUNT_CHANGE
    this.KeyGroupEventTbl[this.TypeEnum.MOUNT_PRE_COUNT_RECHARGE] = LUA_EVENT_MOUNT_PRE_COUNT_RECHARGE_CHANGE
    this.KeyGroupEventTbl[this.TypeEnum.DAILY_DIAMOND_RECHARGE_CHANGE] = LUA_EVENT_DAILY_DIAMOND_RECHARGE_COUNT_CHANGE
    this.KeyGroupEventTbl[this.TypeEnum.OPERATE_ADD_RECHARGE_CHANGE] = LUA_EVENT_OPERATE_ADD_RECHARGE_CHANGE
    this.KeyGroupEventTbl[this.TypeEnum.RUNACTIVE_DIRECT_COUNT_CHANGE] = LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ALL_COUNT_INFO,self.OnResCounts,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UPDATE_COUNT_INFO,self.OnResCount,self)
end

---@param refresh CountTbl
function this:AddCountKeyTbl(refresh)
    this.TotalRefreshTbl[refresh.key] = refresh
end
function this:RemoveCountKeyByKey(key)
    this.TotalRefreshTbl[key] = nil
end
function this:GetEventTblByKey(group)
    return this.KeyGroupEventTbl[group]
end
---派发
function this:TypeDispatchByKey(counKeyTbl)
    for _, countKey in pairs(counKeyTbl) do
        local countTbl = SL:GetConfig("Count_count",countKey)
        if(countTbl == nil) then
            SL:LogError("刷新数据前后端不一致"..countKey)
        else
            local eventId = this:GetEventTblByKey(countTbl.group)
            if eventId then
                SL:onLUAEvent(eventId,countKey)
            end
        end
    end
end

---@param refresh CountTbl
function this:AddTypeDispatch(refresh)
    local parseTbl = SL:GetConfig("Count_count",refresh.key)
    if(parseTbl == nil) then
        logError('刷新数据前后端不一致',refresh.key)
        return
    end
--[[    local limitCount = refresh.total - refresh.count --剩余次数
    if limitCount >= 0 and parseTbl.type == 1 then --终身限购完成
        this:RemoveCountKeyByKey(refresh.key)
    else
        this:TypeDispatchByKey({refresh.key})
    end]]
    this:TypeDispatchByKey({refresh.key})
end
function this:AddTypeDispatchTbl()
    for _, refresh in pairs(this.TotalRefreshTbl) do
        this:AddTypeDispatch(refresh)
    end
end


---@param msg  table<number,CountTbl>
function this:OnResCounts(_,msg)
    if not table.isNullOrEmpty(msg) then
        local data = msg
        for _, refresh in pairs(data) do
            this:AddCountKeyTbl(refresh)
        end
        this:AddTypeDispatchTbl()
    end
end

---@param msg CountTbl
function this:OnResCount(_,msg)
    if msg then
        local data = msg
        this:AddCountKeyTbl(data)
        this:AddTypeDispatch(data)
    end
end

function this:GetRefreshByKey(key)
    return this.TotalRefreshTbl[key]
end
---获取剩余次数和总次数
function this:GetLimitAndTotalCountByKey(id)
    --注意：type为0不应该进入此方法 代表无限购
    local countData = this:GetRefreshByKey(id)
    if not countData then
        countData = {count = 0}
    end
    local countTbl = SL:GetConfig("Count_count",id)
    if table.isNullOrEmpty(countTbl) then
        SL:LogError("Count_count表内未配置相关内容id"..id)
        return 0,0
    end
    local totalCount = countTbl.total
    --countData.count 已购买次数
    --totalCount-countData.count 剩余购买次数
    return totalCount-countData.count,totalCount
end
---获取剩余次数和总次数 通过rechargeID
function this:GetLimitAndTotalCountByRechargeId(rechargeId)
    if rechargeId then
        local rechargeTbl =SL:GetConfig("cfg_recharge",rechargeId)
        if rechargeTbl then
            --注意：type为0不应该进入此方法 代表无限购
            local countData = this:GetRefreshByKey(rechargeTbl.Countkey)
            if not countData then
                countData = {count = 0}
            end
            local countTbl = SL:GetConfig("Count_count",rechargeTbl.Countkey)
            if table.isNullOrEmpty(countTbl) then
                SL:LogError("Count_count表内未配置相关内容id"..rechargeTbl.Countkey)
                return 0,0
            end
            local totalCount = countTbl.total
            return totalCount-countData.count,totalCount
        end
    end
    return 0,0
end

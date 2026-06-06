---@class KLDailyActivityPanel:UIKmlLuaPanelBase
---@field view KLDailyActivityPanelView
local KLDailyActivityPanel = class(UIKmlLuaPanelBase)
local this =KLDailyActivityPanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.datalist_activity, function() return self:ItemCountGetFun() end,
            function(realIndex) return self:ItemGetFun(realIndex) end,
            nil,
            function(realIndex,kmlControl) self:ItemUpdateFun(realIndex,kmlControl) end,
            nil)
    ---@type cfg_activity_rule_column[]
    self.activityRuleTblList = {}
    local list = SL:GetConfigTable("cfg_activity_rule")
    for k, v in pairs(list) do
        if v.targetOpen == 1 then
            table.insert(self.activityRuleTblList,v)
        end
    end
    --table.sort(self.activityRuleTblList, self.ActivitySortCompare)
    self.activityItems = {}
end

---@param a cfg_activity_rule_column
---@param b cfg_activity_rule_column
function this.ActivitySortCompare(a,b)
    local rankA = a.rank
    local rankB = b.rank
    if this.activityOpenMap then
        if not this.activityOpenMap[a.id] then
            rankA = rankA + 1000
        end
        if not this.activityOpenMap[b.id] then
            rankB = rankB + 1000
        end
    end
    return rankA < rankB
end

function this:ItemCountGetFun()
    return #self.activityRuleTblList
end

function this:ItemGetFun(realIndex)
    local data = self.activityRuleTblList[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/DailyGoal/Item/KLDailyActivity/KLDailyActivityItem",self.view.datalist_activity,self,this.activityOpenMap[data.id],true)
    
    self.activityItems[item.view.root] = item
    return item.view.root
end

function this:ItemUpdateFun(realIndex,kmlControl)
    ---@type KLDailyActivityItem
    local item = self.activityItems[kmlControl]
    item:UpdateData(self.activityRuleTblList[realIndex + 1])
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_DAILY_ACTIVITY_ACTIVITY_LIST)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_DAILY_ACTIVITY_ACTIVITY_LIST,self.ResDailyActivityList,self)
end

---@param data DailyActivityActivity[]
function this:ResDailyActivityList(_,data)
    ---@type table<number,boolean>
    this.activityOpenMap = this.activityOpenMap or {}
    for _, v in pairs(data) do
        this.activityOpenMap[v.activityid] = v.open
    end
    table.sort(self.activityRuleTblList, self.ActivitySortCompare)
    GUI:DataListUpdateData(self.view.datalist_activity, false, function()
        SL:RefreshPanelALLRedPoint("KLDailyActivityPanel")
    end)
end

function this:Close()
end

return this

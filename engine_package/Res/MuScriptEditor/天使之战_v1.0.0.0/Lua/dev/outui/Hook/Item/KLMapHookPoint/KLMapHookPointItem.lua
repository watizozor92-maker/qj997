---@class KLMapHookPointItem:UIKmlLuaPanelBase
---@field view KLMapHookPointItemView
local KLMapHookPointItem = class(UIKmlLuaPanelBase)
local this = KLMapHookPointItem
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLMapHookPointItemKml", true)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnPos, self, self.GoOnClick)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local index = self.args.index
    GUI:Text_setString(self.view.txtIndex, index)
    local pos = self.args.pos
    --GUI:Text_setString(self.view.txtPos, string.format("[%s,%s]", pos[1], pos[2]))
    GUI:Text_setText(self.view.text2, pos.count.."只")
end

function this:GoOnClick()
    local levelCondition = false
    local CostCondition = false
    local map_info = SL:GetConfig("cfg_map_info", self.args.mapId)
    local mapMove_info = SL:GetConfigMultiKeys("cfg_mapMove", self.args.mapId, "mapID")
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    levelCondition = mapMove_info.level <= SL:MeData_GetLevel()
    self.cost = map_info.transferCost
    if self.cost and self.cost[1] and self.cost[1][2] then
        CostCondition = self.cost[1][2] * InfoManager.redNameInfo:GetMapTransmissionCost() <=
        SL:GetBagItemCount(self.cost[1][1])
        if mapId == self.args.mapId then
            CostCondition = true
        end
    end
    if levelCondition and CostCondition then
        local line = SL:GetMetaValue("MAP_LINE")
        line = self:FindLine(line, self.args.mapId)
        SL:StopOnHook(false)
        local x = self.args.pos.coordinates[1]
        local y=  self.args.pos.coordinates[2]
        local mapId = self.args.mapId
        local monsterId = self.args.monsterId
        local function func()
            SL:StopOnHook(false)
            SL:Pathfinding(mapId, line, x, y, function()
                SL:SetTaskKillMonsterRangeOnMoving()
                SL:StartOnHook(true, true)
            end)
            if InfoManager.taskOutInfo:CheckMonsterIdIsInCacheData(monsterId) then
                local data = InfoManager.taskOutInfo:GetTaskTempCacheData()
                SL:SetTaskKillMonsterRangeOnMoving(data[1], data[2], data[3], data[4], data[5], data[6], func)
            end
        end
        SL:Pathfinding(self.args.mapId, line, x, y, function()
            SL:SetTaskKillMonsterRangeOnMoving()
            SL:StartOnHook(true, true)
        end)
        if InfoManager.taskOutInfo:CheckMonsterIdIsInCacheData(self.args.monsterId) then
            local data = InfoManager.taskOutInfo:GetTaskTempCacheData()
            --local list = table.unpack(data)
            SL:SetTaskKillMonsterRangeOnMoving(data[1], data[2], data[3], data[4], data[5], data[6], func)
        end
        GUI:UIPanel_Close("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel")
        GUI:UIPanel_Close("dev/outui/Hook/Panel/KLMapHookPoints/KLMapHookPointsPanel")
        SL.ShowMainPanel()
        --[[        if mapId == self.args.mapId then
            local line = SL:GetMetaValue("MAP_LINE")
            SL:Pathfinding(self.args.mapId, line, self.args.pos[1], self.args.pos[2], function()
                SL:StartOnHook(true,true)
            end)
            GUI:UIPanel_Close("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel")
            GUI:UIPanel_Close("dev/outui/Hook/Panel/KLMapHookPoints/KLMapHookPointsPanel")
            SL.ShowMainPanel()
        else
            SL:CommonTipsMessage({ stringTblID = 35005,
                                   ui = self,
                                   sureBtnText = "确定",
                                   cancelBtnText = "取消",
                                   callback = function()
                                       local line = SL:GetMetaValue("MAP_LINE")
                                       SL:Pathfinding(self.args.mapId, line, self.args.pos[1], self.args.pos[2], function()
                                           SL:StartOnHook(true,true)
                                       end)
                                       GUI:UIPanel_Close("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel")
                                       GUI:UIPanel_Close("dev/outui/Hook/Panel/KLMapHookPoints/KLMapHookPointsPanel")
                                       SL.ShowMainPanel()
                                       --return SendTransferToNpcMessage_originFunc(this,npcListId,show)
                                   end })
        end]]
    else
        if not levelCondition then
            SL:TipMessage(string.format("等级不满足，%s等级后可传送", mapMove_info.level), 1, NoticeType.NoticeMid)
            return
        end
        if not CostCondition then
            SL:CommonItemGetPath(nil, self.cost[1][1],nil,nil,nil,function ()
                GUI:UIPanel_Close("dev/outui/Hook/Panel/KLMapHookPoints/KLMapHookPointsPanel")
                GUI:UIPanel_Close("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel")
            end)
            SL:TipMessage("消耗金币不满足，无法传送", 1, NoticeType.NoticeMid)
            return
        end
    end
end

---如果传入的线路有该地图则直接返回该线路，否则返回有的第一个线路(为解决由于某些线路无该地图导致无法传送问题)
function this:FindLine(line, mapId)
    local trueLine
    local defaultLine
    local cfgMapLine = SL:GetConfig("cfg_map_line", mapId)
    if cfgMapLine then
        for k, v in pairs(cfgMapLine.mapLine) do
            local vLine
            if type(v) == "table" and v[2] then
                vLine = tonumber(v[2])
            end
            if vLine then
                if not defaultLine then
                    defaultLine = vLine
                end
                if vLine == line then
                    trueLine = line
                end
            end
        end
    end
    if not trueLine then
        trueLine = defaultLine or 1
    end
    return trueLine
end

function this:Close()
    SL:KeepOpenPanel("KLMapHookPointItemKml", false)
end

return this

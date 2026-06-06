---@class KLBingFengBaoPanel:UIKmlLuaPanelBase
---@field view KLBingFengBaoPanelView
local KLBingFengBaoPanel = class(UIKmlLuaPanelBase)
local this =KLBingFengBaoPanel
--传送的mapMoveID
local MAPMOVEID = 4003

---创建时调用一次
function this:Init()
    self.tData = self.args

    GUI:DataListInitData(self.view.itemDataList,function()
        return self:ItemDataListItemCountFunc()
    end,function(realIndex)
        return self:ItemDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:ItemDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ItemDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    self.activityInfo =  InfoManager.activityPreviewInfo:GetActivityInfo(EActivityType.BingFengBao)
    local allActivity = SL:GetAllActivityData()
    for i, v in pairs(allActivity) do
        if v.cfgId == EActivityType.BingFengBao  then
            self.data = v
        end
    end
    self.showItem = ToolFunc.AnalysisStr(SL:GetConfig("cfg_global",670009).value)
    self.timer = SL:Schedule(self.timer,0,1,-1,self.RefreshTimeData,self)
end



-----奖励预览
function this:ItemDataListItemCountFunc()
    return #self.showItem
end
function this:ItemDataListItemGetFunc()
end
function this:ItemDataListItemInitFunc()
end
function this:ItemDataListItemUpdateFunc(realIndex, kmlcontrol)
    local luaIndex = realIndex + 1
    local itemId = self.showItem[luaIndex][1]
    GUI:Item_setItemId(kmlcontrol,itemId)
    GUI:Item_setItemCount(kmlcontrol,self.showItem[luaIndex][2])
    GUI:AddOnClickEvent(kmlcontrol,self,function ()
        SL:OpenTips(nil,itemId)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_des,self,function()
        local ruleCfg = SL:GetConfig("cfg_rule_text", 30001) 
        if ruleCfg then
            SL:CommonStrTipsMessage({title =ruleCfg.menutxt,str=ruleCfg.location})
        end
    end)
    GUI:AddOnClickEvent(self.view.button38,self,function()
        if not self.data.status == 1 then
            SL:TipMessage("活动未开启",1, NoticeType.NoticeMid)
            return
        end
        local config = InfoManager.bingFengBaoInfo.config
        if MAPMOVEID then
            local mapMoveTbl = SL:GetConfig("cfg_mapMove", MAPMOVEID)
            local map_info = SL:GetConfig("cfg_map_info", mapMoveTbl.mapID)
            local cost = map_info.transferCost
            local conditionCheck2
            if cost and cost[1] and cost[1][2] then
                local transmissionCost = InfoManager.redNameInfo:GetMapTransmissionCost()
                conditionCheck2 = cost[1][2] * transmissionCost <= SL:GetBagItemCount(cost[1][1])
            else
                conditionCheck2 = true
            end
            if not conditionCheck2 and not table.isNullOrEmpty(cost) then
                SL:CommonItemGetPath(nil, cost[1][1])
                SL:TipMessage("消耗金币不满足，无法传送", 1, NoticeType.NoticeMid)
                return
            end
        end
        SL:ReqTransfer(nil, config[4], MAPMOVEID, {type = 1,isUseCommonConditionLimit = true})
        --[[SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CUSTOM_TRANSFER,
            {
                mapCfgId = config[1],
                line=config[4],
                x=config[2], 
                y=config[3]
            })--]]
        --SL:ReqTransfer(nil, config[4], MAPMOVEID, { type = 1, isUseCommonConditionLimit = true })
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLBingFengBao/KLBingFengBaoPanel")
        SL.ShowMainPanel()
    end)
    GUI:AddOnClickEvent(self.view.closeBtn,self,function()
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLBingFengBao/KLBingFengBaoPanel")
        SL.ShowMainPanel()
    end)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    

    GUI:DataListUpdateData(self.view.itemDataList)

    --上次获胜战盟
    local MasterUnionName = "暂无"
    if InfoManager.bingFengBaoInfo.data.MasterUnionName then
        MasterUnionName = InfoManager.bingFengBaoInfo.data.MasterUnionName
    end
    GUI:Text_setString(self.view.text5,MasterUnionName)

    self:RefreshTimeData()
end

function this:RefreshTimeData()
    local hasTime =  math.floor((self.activityInfo.leftTime - Time.GetServerTime())/1000)
    local hasTimeStr = 0
    if hasTime > 0 then
        hasTimeStr = Time.FormatTimeDHMS(hasTime)
    end
    if self.data.status == 1 then
        GUI:Text_setString(self.view.text3,string.format("进行中(%s)",hasTimeStr))
    else
        GUI:Text_setString(self.view.text3,"<color=#FF2323>未开启</color>")
    end
    
    --GUI:Text_setString(self.view.text4,hasTimeStr)
    GUI:setVisible(self.view.text4,false)
end
function this:GetHour(time)
    return os.date("%H", math.floor(time))
end
function this:GetMinute(time)
    return os.date("%M", math.floor(time ))
end

function this:Hide()
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end




return this

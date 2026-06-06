---@class KLActivityTipPanel:UIKmlLuaPanelBase
---@field view KLActivityTipPanelView
local KLActivityTipPanel = class(UIKmlLuaPanelBase)
local this =KLActivityTipPanel
---创建时调用一次
function this:Init()
    self.id2ActInfos = {}
    self.activityInfos = {}   ---所有已开启的活动提示

    GUI:DataListInitData( self.view.ActivitiesDataList,function()
        return self:DataListItemCountFunc()
    end,function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end,nil, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end, function(realIndex)
        return self:DataListItemSizeGetFunc(realIndex)
    end)
    
end

function this:DataListItemCountFunc()
    return #self.activityInfos
end

function this:DataListItemGetFunc()
    ---@type KLUISkillPageItem
    local item = GUI:UIPanel_Open("dev/ui/Preview/Item/KLActivityTip/KLActivityTipItem", self.view.ActivitiesDataList, self, nil, true)
    if not self.activityItems then
        self.activityItems = {}
    end
    local kmlCtrl = item.view.root
    self.activityItems[kmlCtrl] = item
    return kmlCtrl
end

function this:DataListItemUpdateFunc(realIndex, kmlcontrol)
    local item = self.activityItems[kmlcontrol]
    local luaIndex = realIndex + 1
    local info = self.activityInfos[luaIndex]
    item:UpdateUI(info)
end

---@return Vector2
function this:DataListItemSizeGetFunc()
    local x = 262
    local y = 75
    return Vector2(x, y)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end


--刷新面板icon
function this:RefreshUI()
    GUI:DataListUpdateData(self.view.ActivitiesDataList)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.CloseBtnClick)
    GUI:AddOnClickEvent(self.view.ViewAllActivities,self,self.ShowAllActivePanel)
    GUI:AddOnClickEvent(self.view.ExpandArrow,self,self.ExpandArrowClick)
    GUI:AddOnClickEvent(self.view.ContractArrow,self,self.ContractArrowClick)
    ---服务器事件，活动数据改变
    SL:RegisterLUAEvent(Event.ActivityListChange,self.ActivityListChange,self)
    SL:RegisterLUAEvent(Event.AnnounceListChange,self.AnnounceListChange,self)
    ---外部开启关闭活动提示
    SL:RegisterLUAEvent(LUA_EVENT_ACTIVITYTIMETIPS_ADD,self.OutOpenActivityTimeTip,self)
    SL:RegisterLUAEvent(LUA_EVENT_ACTIVITYTIMETIPS_DEL,self.CloseActivityTimeTip,self)
    SL:RegisterLUAEvent(LUA_EVENT_ACTIVITYTIMETIPS_DELTYPE,self.CloseActivityTimeTipByType,self)
    SL:RegisterLUAEvent(LUA_EVENT_ACTIVITYTIMETIPS_DELALL,self.CloseActivityTimeTipAll,self)
end

function this:ActivityListChange()
    self:RefreshByMessage()
    if not self:TryRefreshActivityList() then
        --self:CloseBtnClick()
        return
    end
end
function this:AnnounceListChange()
    self:RefreshByAnnounceMessage()
    if not self:TryRefreshActivityList() then
        --self:CloseBtnClick()
        return
    end
end

-- 根据服务器消息刷新预告
function this:RefreshByAnnounceMessage()
    local allAct = SL:GetAllActivityAnnounceData()
    if not RoleManager.meData or not allAct then
        return
    end
    
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if not level then return end

    self.hasAnnounceShow = false
    self:DeleteByType(EListDataType.AnnounceList)
    
    --有需要显示的预告活动
    for _, v in pairs(allAct) do
        local t = {}
        t.activityId = v.activityId
        --local brief = SL:GetConfig("cfg_activity_rule",v.activityId)
        if brief and brief.open ~= EActivityRuleIsShowPop.NotShowInPop and brief.uiTextLevel <= level then
            t.activityIcon = brief.uiIcon
            t.activityName = "活动"..v.activityId --brief.titleIcon
            t.activityType = EListDataType.AnnounceList --预告
            t.activityEndTime = v.time

            local activityTime = t.activityEndTime - Time.GetServerTime();
            if brief.specialOpen and brief.specialOpen > 0 then
                t.specialOpen = brief.specialOpen --预告秒
                local specialOpenTime = brief.specialOpen * 1000
                if activityTime > 0 and activityTime <= specialOpenTime then
                    if not self.id2ActInfos[t.activityId] then
                        table.insert(self.activityInfos, t)
                        self.id2ActInfos[t.activityId] = t
                    end
                    self.hasAnnounceShow = true
                end
            end
        end
    end
end

-- 根据服务器消息刷新活动
function this:RefreshByMessage()  
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if not level or not SL:GetAllActivityData()  then
        return
    end

    self.hasActivityToShow = false
    self:DeleteByType(EListDataType.ActivityList)
end


function this:TryRefreshActivityList()
    if #self.activityInfos == 0 then
        return false
    end
    table.sort(self.activityInfos, function(a, b)
        if a.activityType == b.activityType then
            return a.activityEndTime > b.activityEndTime
        else
            return a.activityType > b.activityType
        end
    end)
    return true
end

---展开活动预告
function this:ExpandArrowClick()
    GUI:setContentSize(self.view.background,257,330)
    GUI:setVisible(self.view.ViewAllActivities)
    GUI:setVisible(self.view.ExpandArrow,false)
    GUI:setVisible(self.view.ContractArrow,true)
    GUI:setContentSize(self.view.ActivitiesView,242,220)
    GUI:DataListUpdateData(self.view.ActivitiesDataList)
end
---收缩活动预告
function this:ContractArrowClick()
    GUI:setContentSize(self.view.background,257,130)
    GUI:setVisible(self.view.ViewAllActivities,false)
    GUI:setVisible(self.view.ExpandArrow)
    GUI:setVisible(self.view.ContractArrow,false)
    GUI:setContentSize(self.view.ActivitiesView,242,78)
    GUI:DataListUpdateData(self.view.ActivitiesDataList)
end

---查看全天活动
function this:ShowAllActivePanel()
    SL:Log('查看全天活动')
    ---GUI:UIPanel_Open("dev/ui/Preview/Panel/KLActivityTip/KLActivityTipPanel")
end

---关闭活动预告
function this:CloseBtnClick()
    GUI:UIPanel_Close("dev/ui/Preview/Panel/KLActivityTip/KLActivityTipPanel")
end

-------------------------外部添加删除提示--------------------------------------
function this:OutOpenActivityTimeTip(_,data)
    if not RoleManager.meData then
        return
    end
    --local brief = SL:GetConfig("cfg_activity_rule",data.activityId)
    --开启条件不满足
    if not brief then return end
    if brief.open == EActivityRuleIsShowPop.NotShowInPop or brief.uiTextLevel > RoleManager.meData.Level then
        return
    end
    --进行活动需加战盟后才显示战盟boss，攻城战
    if (data.activityId == 32 or data.activityId == 33) and RoleManager.meData.roleExtInfo.unionId == 0 and data.activityType == EListDataType.ActivityList then
        return
    end
    --重复开启活动
    if self.id2ActInfos[data.activityId] then
        return
    end
    --倒计时是否满足
    local checktime = data.activityEndTime > 0 --self:CheckEndtime(data.activityType,data.activityEndTime,brief,data)
    if checktime then
        if not self.id2ActInfos[data.activityId] then
            table.insert(self.activityInfos, data)
            self.id2ActInfos[data.activityId] = data
            self:RefreshUI()
        end
    end
end
function this:CloseActivityTimeTipByType(_,type)
    self:DeleteByType(type)
    self:RefreshUI()
end
function this:CloseActivityTimeTip(_,id)
    self:DeleteByActiveId(id)
    self:RefreshUI()
end
function this:CloseActivityTimeTipAll()
    self:DeleteAllActive()
    self:RefreshUI()
    self:CloseBtnClick()
end

---根据预告还是活动类型删除
function this:DeleteByType(tp)
    for i = #self.activityInfos, 1, -1 do
        local v = self.activityInfos[i]
        if v.activityType == tp then
            if self.id2ActInfos[v.activityId] then
                self.id2ActInfos[v.activityId] = nil
            end
            table.remove(self.activityInfos, i)
        end
    end
end
---根据活动id删除
function this:DeleteByActiveId(id)
    for i = #self.activityInfos, 1, -1 do
        local v = self.activityInfos[i]
        if v.activityId == id then
            if self.id2ActInfos[v.activityId] then
                self.id2ActInfos[v.activityId] = nil
            end
            table.remove(self.activityInfos, i)
        end
    end
end
---删除所有活动
function this:DeleteAllActive()
    for i = #self.activityInfos, 1, -1 do
        local v = self.activityInfos[i]
        if self.id2ActInfos[v.activityId] then
            self.id2ActInfos[v.activityId] = nil
        end
        table.remove(self.activityInfos, i)
    end
end
function this:SetUIMapPoint(IsHave)
    if IsHave then
        self:SetPositionX(243)
    else
        self:SetPositionX(410)
    end
end
function this:SetPositionX(x)
    GUI:setPositionX(self.view.root,x)
end
function this:Close()
end

return this

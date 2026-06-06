---@class KLDailyActivePanel:UIKmlLuaPanelBase
---@field view KLDailyActivePanelView
local KLDailyActivePanel = class(UIKmlLuaPanelBase)
local this =KLDailyActivePanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.datalist_active, function() return self:ItemCountGetFun() end,
            function(realIndex) return self:ItemGetFun(realIndex) end,
            nil,
            function(realIndex,kmlControl) self:ItemUpdateFun(realIndex,kmlControl) end,
            nil)
--[[    ---@type cfg_daily_activity_column[]
    self.dailyActivityTblList = SL:GetConfigTable("cfg_daily_activity")]]
    ---@type table<KingML.KmlControl,KLDailyActiveItem>
    self.activeItems = {}
end

function this:ItemCountGetFun()
    return #self.dailyActiveDataList
end

function this:ItemGetFun(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/DailyGoal/Item/KLDailyActiveItem/KLDailyActiveItem",self.view.datalist_active,self,nil,true)
    
    self.activeItems[item.view.root] = item
    return item.view.root
end

function this:ItemUpdateFun(realIndex,kmlControl)
    ---@type KLDailyActiveItem
    local item = self.activeItems[kmlControl]
    item:UpdateData(self.dailyActiveDataList[realIndex + 1])
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_DAILY_ACTIVITY_INFO)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_DAILY_ACTIVITY_INFO,self.ResDailyActivityInfo,self)
end

function this.ActiveTblSortFun(a,b)
    return a.rank < b.rank
end

---@param data DailyActivity
function this:ResDailyActivityInfo(_,data)
    --data.activity_value = "60"    --测试数据
    local list = {}
    for _, v in pairs(data.daily_task) do
        ---@type cfg_daily_activity_column
        local config = SL:GetConfig("cfg_daily_activity",tonumber(v.task_id))
        if config then
            if SL:CheckCondition(config.showConditions) then
                v.rank = config.rank
                table.insert(list,v)
            end
        end
    end
    table.sort(list,this.ActiveTblSortFun)
    self.dailyActiveDataList = list
    GUI:DataListUpdateData(self.view.datalist_active,true)
    
    GUI:Text_setString(self.view.txt_cur_active_num,tostring(data.activity_value))
    GUI:Slider_setPercent(self.view.slider_active_num,tonumber(data.activity_value))
    local haveBoxCanGet = false
    for _, v in pairs(data.daily_box) do
        local index = math.tointeger(v.ax_num // 20)
        GUI:SetActive(self.view["icon_get_" .. index],v.state == 1)
        local canGet = tonumber(v.ax_num) <= tonumber(data.activity_value) and v.state ~= 1
        haveBoxCanGet = haveBoxCanGet or canGet
        GUI:SetActive(self.view["effect_box_" .. index],canGet)
        GUI:Image_loadTexture(self.view["icon_box_" .. index],(canGet and "icon_box_light_" or "icon_box_dark_") .. index,"Atlas/DailyGoal.spriteatlas")
        GUI:AddOnClickEvent(self.view["icon_box_" .. index],self,self.OnClickBoxIcon,tonumber(v.box_id))
        self.boxCanGet = self.boxCanGet or {}
        self.boxCanGet[v.box_id] = canGet
    end
    InfoManager.redDotInfo.commonRedPointInfo[96] = haveBoxCanGet
    SL:RefreshPanelALLRedPoint("KLDailyGoalMainPanel")
end

function this:OnClickBoxIcon(_,boxId)
    ---@type cfg_activeness_reward_column
    local config = SL:GetConfig("cfg_activeness_reward",boxId)
    local list = {}
    for _, v in pairs(config.caxItem) do
        table.insert(list,{["id"]=tonumber(v[1]),["count"]=tonumber(v[2])})
    end
    for _, v in pairs(config.randomReward) do
        table.insert(list,{["id"]=tonumber(v[1]),["count"]=-1})
    end
    GUI:UIPanel_Open("dev/outui/DailyGoal/Panel/KLDailyBoxReward/KLDailyBoxRewardPanel",nil,nil,{["config"]=config,["rewardList"]=list,["showBtnGet"]=self.boxCanGet[tostring(boxId)]})
end

function this:Close()
end

return this

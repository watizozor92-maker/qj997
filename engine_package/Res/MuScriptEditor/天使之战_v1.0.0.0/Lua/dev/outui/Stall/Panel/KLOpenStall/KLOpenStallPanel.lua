---@class KLOpenStallPanel:UIKmlLuaPanelBase
---@field view KLOpenStallPanelView
local KLOpenStallPanel = class(UIKmlLuaPanelBase)
local this =KLOpenStallPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.notice_data_list,function()
        return self:NoticeDataListItemCountFunc()
    end,function(realIndex)
        return self:NoticeDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:NoticeDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:NoticeDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.notice_all_item = {}
    self.max_notive = SL:GetConfig("cfg_global",13002).value
    self.max_notive = tonumber(self.max_notive)
    local notice = SL:GetConfig("cfg_global",13001).value
    self.all_notice = SL:Split(notice, '#')
    self.notice_select = {}

    GUI:DataListInitData(self.view.city_data_list,function()
        return self:CityDataListItemCountFunc()
    end,function(realIndex)
        return self:CityDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:CityeDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:CityDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.city_all_item = {}
    self.all_city = {}
    local allcity = SL:GetConfigTable("cfg_spot")
    local myLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    local serverDay = SL:GetOpenServerDay()
    for i=1,#allcity,1 do
        if allcity[i].level <= myLevel and allcity[i].serverday <= serverDay then
            table.insert(self.all_city,allcity[i])
        end
    end
    self.select_city = 0

    GUI:DataListInitData(self.view.time_data_list,function()
        return self:timeDataListItemCountFunc()
    end,function(realIndex)
        return self:timeDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:timeeDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:timeDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.time_all_item = {}
    self.all_time = {}
    self.select_time = 0
    self.pos_data = nil
    GUI:Text_setString(self.view.shuoming,"说明：摆摊后将在主城出现分身进行摆摊，摊位和交易行中同步出售上架道具")
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.open1, self, self.OpenNotice)
    GUI:AddOnClickEvent(self.view.close1, self, self.CloseNotice)  
    GUI:AddOnClickEvent(self.view.open2, self, self.OpenCity)
    GUI:AddOnClickEvent(self.view.close2, self, self.CloseCity)  
    GUI:AddOnClickEvent(self.view.open4, self, self.Opentime)
    GUI:AddOnClickEvent(self.view.close4, self, self.Closetime)  
    GUI:AddOnClickEvent(self.view.add_btn, self, self.costAddBtn) 
    GUI:AddOnClickEvent(self.view.btn_start, self, self.StartStall) 

    
    GUI:AddOnClickEvent(self.view.select_view_1_btn, self, self.CloseNotice)
    GUI:AddOnClickEvent(self.view.select_view_2_btn, self, self.CloseCity)
    GUI:AddOnClickEvent(self.view.select_view_4_btn, self, self.Closetime)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_STALL_POSITION,self.RES_STALL_POSITION,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_START_STALL,self.RES_START_STALL,self)
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Stall/Panel/KLOpenStall/KLOpenStallPanel")
end

----摆摊公告
function this:OpenNotice()
    GUI:setVisible(self.view.open1,false)
    GUI:setVisible(self.view.close1,true)
    GUI:setVisible(self.view.select_view_1,true)
    GUI:DataListUpdateData(self.view.notice_data_list)
    self:UpdateNotice()
end

function this:CloseNotice()
    GUI:setVisible(self.view.open1,true)
    GUI:setVisible(self.view.close1,false)
    GUI:setVisible(self.view.select_view_1,false)
end


function this:NoticeDataListItemCountFunc()
    return #self.all_notice
end

function this:NoticeDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Stall/Item/KLStallNoticeSelectItem/KLStallNoticeSelectItem",self.view.notice_data_list,self,{},true)
    self.notice_all_item[realIndex+1] = item
    return item.view.root
end

function this:NoticeDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:NoticeDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_notice[realIndex + 1]
    self.notice_all_item[realIndex+1]:RefreshItem({index=realIndex+1,value=data},self.notice_select,self)
end

function this:AddSelectNotict(select_index)
    local is_have = false
    for i=1,#self.notice_select,1 do
        if self.notice_select[i] == select_index then
            is_have = true
            break
        end
    end
    if is_have then
        return
    end
    if self.max_notive <= #self.notice_select then
        --SL:TipMessage({ "关键词数量已达上限",1, NoticeType.NoticeMid})
        SL:TipMessage( SL:GetConfig('cfg_string', 330).text, 1, NoticeType.NoticeMid )
        return
    end
    table.insert(self.notice_select,select_index)
    self:RefreshNotice()
end

function this:CancelSelectNotict(select_index)
    local is_have = false
    for i=1,#self.notice_select,1 do
        if self.notice_select[i] == select_index then
            is_have = true
            break
        end
    end
    if not is_have then
        return
    end
    table.removeByValue(self.notice_select,select_index)
    self:RefreshNotice()
end

function this:RefreshNotice()
    for i=1,#self.notice_all_item,1 do
        self.notice_all_item[i]:CheckShow()
    end
    self:UpdateNotice()
end

function this:UpdateNotice()
    local str = ""
    for i=1,#self.notice_select,1 do
        local ind = self.notice_select[i]
        str = str .. self.all_notice[ind] .. " "
    end
    GUI:Text_setString(self.view.notice_text_1,str)
end

----摆摊城市
function this:OpenCity()
    GUI:setVisible(self.view.open2,false)
    GUI:setVisible(self.view.close2,true)
    GUI:setVisible(self.view.select_view_2,true)
    GUI:DataListUpdateData(self.view.city_data_list)
    self:UpdateCity()
end

function this:CloseCity()
    GUI:setVisible(self.view.open2,true)
    GUI:setVisible(self.view.close2,false)
    GUI:setVisible(self.view.select_view_2,false)
end

function this:SelectCity(id)
    self.select_city = id
    self:UpdateCity()
    self:CloseCity()
    self:Checktime()
    self:Updatetime()
    local _id = self.all_city[self.select_city].id
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_STALL_POSITION, { id = _id })
end

function this:UpdateCity()
    if not self.select_city or self.select_city == 0 then
        GUI:Text_setString(self.view.notice_text_2,"")
        return
    end
    local map_id = self.all_city[self.select_city].map
    local mapname = SL:GetConfig("cfg_map_info",map_id,"id").mapname
    GUI:Text_setString(self.view.notice_text_2,mapname)
end

function this:CityDataListItemCountFunc()
    return #self.all_city
end

function this:CityDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Stall/Item/KLStallCitySelectItem/KLStallCitySelectItem",self.view.city_data_list,self,{},true)
    self.city_all_item[realIndex+1] = item
    return item.view.root
end

function this:CityeDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:CityDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_city[realIndex + 1]
    self.city_all_item[realIndex+1]:RefreshItem({index=realIndex+1,message=data},self.select_city,self)
end

----摆摊时间
function this:Opentime()
    GUI:setVisible(self.view.open4,false)
    GUI:setVisible(self.view.close4,true)
    GUI:setVisible(self.view.select_view_4,true)
    self:Updatetime()
    GUI:DataListUpdateData(self.view.time_data_list)
end

function this:Closetime()
    GUI:setVisible(self.view.open4,true)
    GUI:setVisible(self.view.close4,false)
    GUI:setVisible(self.view.select_view_4,false)
end


function this:SelectTime(id)
    self.select_time = id
    --self:Checktime()
    self:Updatetime()
    self:Closetime()
end

function this:Updatetime()
    if not self.select_city or self.select_city == 0 then
        GUI:Text_setString(self.view.notice_text_3,"")
        return
    end
    if not self.select_time or self.select_time == 0 then
        GUI:Text_setString(self.view.notice_text_3,"")
        return
    end
    local time = self.all_time[self.select_time].time
    GUI:Text_setString(self.view.notice_text_4,time.."小时")
    self:UpdateCost()
end

function this:Checktime()
    if self.select_city or self.select_city == 0 then
        local tab = self.all_city[self.select_city]
        self.all_time = {}
        for i=1,#tab.cost,1 do
            local one_tab = tab.cost[i]
            table.insert(self.all_time,{id=i,time = one_tab[1],cfg_id = one_tab[2],num=one_tab[3]})
        end
        self.select_time = 1
    else
        self.all_time = {}
        self.select_time = 0
    end
end

function this:timeDataListItemCountFunc()
    return #self.all_time
end

function this:timeDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Stall/Item/KLStallTimeSelectItem/KLStallTimeSelectItem",self.view.time_data_list,self,{},true)
    self.time_all_item[realIndex+1] = item
    return item.view.root
end

function this:timeeDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:timeDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_time[realIndex + 1]
    local item = self.time_all_item[realIndex+1]
    GUI:SetZIndex(item.view.root,401)
    self.time_all_item[realIndex+1]:RefreshItem({index=realIndex+1,message=data},self.select_time,self)
end

function this:RES_STALL_POSITION(id,message)
    if not message then
        return
    end
    if not self.select_city or self.select_city == 0 then
        GUI:Text_setString(self.view.notice_text_2,"")
        return
    end
    local map_id = self.all_city[self.select_city].map
    local maxSpot = self.all_city[self.select_city].maxSpot
    local mapname = SL:GetConfig("cfg_map_info",map_id,"id").mapname
    local str = mapname..": "..message.pointx .. "," .. message.pointy
    GUI:Text_setString(self.view.notice_text_3,str)
    local shengyu = maxSpot - message.count
    local shengyu_str = "(空余摊位".. shengyu .."/" .. maxSpot ..")"
    if shengyu <= 0 then
        shengyu_str = "<color=#ff2323>" .. shengyu_str .. "</color>"
    end
    self.pos_data = message
    GUI:Text_setString(self.view.last_num,shengyu_str)
end

function this:UpdateCost()

    local cfg_id = self.all_time[self.select_time].cfg_id
    local name = SL:GetConfig("cfg_item",cfg_id,"id").name
    GUI:Text_setString(self.view.notice_text_5,name)
    local needCount = self.all_time[self.select_time].num
    local haveCount = SL:GetBagItemCount(cfg_id)
    if haveCount < needCount then
        self.isCanCost = false
        GUI:Text_setString(self.view.cost_num, string.format('<color="#9b1818">%d</color>/%d', haveCount, needCount))
    else
        self.isCanCost = true
        GUI:Text_setString(self.view.cost_num, string.format('<color="#00ff00">%d</color>/%d', haveCount, needCount))
    end
    GUI:Item_setItemId(self.view.cost_item, cfg_id)
end

function this:costAddBtn()
    if not self.select_city or self.select_city == 0 then
        return
    end
    if not self.select_time or self.select_time == 0 then
        return
    end
    local cfg_id = self.all_time[self.select_time].cfg_id
    SL:CommonItemGetPath(nil, cfg_id)
end

function this:StartStall()
--[[    if not self.notice_select or #self.notice_select < 1 then
        SL:TipMessage("请选择摆摊公告",1, NoticeType.NoticeMid)
        return
    end]]
    if not self.select_city or self.select_city == 0 then
        SL:TipMessage("请选择摆摊城市",1, NoticeType.NoticeMid)
        return
    end
    if not self.pos_data  then
        SL:TipMessage("请选择摆摊位置",1, NoticeType.NoticeMid)
        return
    end
    if not self.select_time or self.select_time == 0 then
        SL:TipMessage("请选择摆时长",1, NoticeType.NoticeMid)
        return
    end
    local _id = self.all_city[self.select_city].id
    local notice = tostring(_id)
    if #self.notice_select > 0 then
        notice = notice  .. "#"
    end
    for i=1,#self.notice_select,1 do
        local ind = self.notice_select[i]
        notice = notice .. self.all_notice[ind]
        if i < #self.notice_select then
            notice = notice .. " "
        end
    end
    local maxSpot = self.all_city[self.select_city].maxSpot
    if self.pos_data.count >= maxSpot then
        SL:TipMessage("摊位数量不足",1, NoticeType.NoticeMid)
        return
    end
    -- local map_id = self.all_city[self.select_city].map
    -- local serverType = SL:GetConfig("cfg_map_info",map_id,"id").serverType
    -- if serverType == 2 then
    --     if not self:CrossServerStall() then
    --         return
    --     end
    -- end
    if not self.isCanCost then
        SL:CommonItemGetPath(nil,self.all_time[self.select_time].cfg_id)
        SL:TipMessage("消耗道具不足", 1, NoticeType.NoticeMid)
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_START_STALL, { id = _id,title=notice, cost=self.select_time,pointX=self.pos_data.pointx,pointY=self.pos_data.pointy})
end

function this:RES_START_STALL(id,message)
    if message then
        self:ClosePanel()
    else

    end
end

function this:CrossServerStall()
    local mapid = SL:GetConfig("cfg_activity_rule",20001).mapid[1]
    local tab = SL:GetConfig("cfg_map_info",mapid)
    local message = ""
    self.level_lock = false
    self.strength_lock = false
    self.append_lock = false
    self.open_level = 0
    if tab.condition and #tab.condition > 0 then
        local condition = tab.condition
        local level = condition[1]
        local strength_level = condition[2]
        local append_level = condition[3]
        local player_level = SL:GetMetaValue("LEVEL")
        local all_strength_level = EquipFunc.GetAllStrengthLevel()
        local all_append_level = EquipFunc.GetAllAppendLevel()
        if player_level < level then
            message = message .. "等级" .. level .. "级"
            self.level_lock = true
            self.open_level = level
        end
        if all_strength_level < strength_level then
            if not string.isNullOrEmpty(message) then
                message = message .. "，"
            end
            message = message .. "强化总等级" .. strength_level
            self.strength_lock = true

        end
        if all_append_level < append_level then
            if not string.isNullOrEmpty(message) then
                message = message .. "，"
            end
            message = message .. "追加总等级" .. append_level
            self.append_lock = true
        end
        if not string.isNullOrEmpty(message) then
            message = message .. "可进入"
        end
    end
    if self.level_lock then
        SL:TipMessage( self.open_level.."级开启，无法进入", 1, NoticeType.NoticeMid )
        return
    end
    if self.strength_lock then
        SL:TipMessage( SL:GetConfig('cfg_string',257).text,1, NoticeType.NoticeMid )--"全身强化等级不足，无法进入", 
        return
    end
    if self.append_lock then
        SL:TipMessage(SL:GetConfig('cfg_string',257).text,  1, NoticeType.NoticeMid )--"全身追加等级不足，无法进入",
        return
    end
    -- if not self:IsHavePrivilege() then
    --     SL:TipMessage({ SL:GetConfig('cfg_string',258).text, 1, NoticeType.NoticeLeftBottom })--"<color=#426ECC>月卡时间不足，无法使用地图传送功能</color>",
    --     return
    -- end

    return true
end

function this:IsHavePrivilege()
    if InfoManager.monthCardInfo.IsGetMonthCard or InfoManager.monthCardInfo.IsGetDailyCard then
        --有月卡或是日卡
        return true
    end
    return false
end

return this

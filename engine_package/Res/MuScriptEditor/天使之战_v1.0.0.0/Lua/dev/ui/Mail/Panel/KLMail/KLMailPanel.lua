---@class KLMailPanel:UIKmlLuaPanelBase
---@field view KLMailPanelView
---@field selectBtn KLMailItemItem[]
local KLMailPanel = class(UIKmlLuaPanelBase)
local this = KLMailPanel
---创建时调用一次
function this:Init()
    self.isRefresh = true
    SL:HideMainPanel()
    self.selectBtn = {}
    GUI:OSAScrollView_Initialized(self.view.scrollview_373, self.DataListMailGetFunc, self.DataListMailUpdateFunc, self)
    GUI:OSAScrollView_SetItemSizeGetFun(self.view.scrollview_373, self.ItemSizeGetFun, self)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.isRefresh then
        return
    end
    self.info = self:LoadData()
    if table.count(self.info) == 0 then
        GUI:SetActive(self.view.null_bg, true)
        GUI:SetActive(self.view.left_panel, false)
        GUI:SetActive(self.view.mail_content_rt, false)
    else
        self.selectid = 0
        self.mailId = 0
        self:RefreshUI()
    end
end

function this:RefreshUI()
    GUI:SetActive(self.view.null_bg, false)
    GUI:SetActive(self.view.left_panel, true)
    GUI:SetActive(self.view.mail_content_rt, true)



    self.mailCount = table.count(self.info)
    GUI:OSAScrollView_RefreshList(self.view.scrollview_373, self.mailCount)
    -- GUI:OSAScrollView_ScrollTo(self.view.scrollview_373, 1)
    if self.schedule then
        SL:UnSchedule(self.schedule)
    end
    if table.count(self.info) < 30 then
        self.schedule = SL:ScheduleOnce(0.2, function()
            self:SelectMail(1, self.info[1].mailId)
        end)
    else
        self.schedule = SL:ScheduleOnce(0.5, function()
            self:SelectMail(1, self.info[1].mailId)
        end)
    end

    -- self:SelectMail(1, self.info[1].mailId)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(MessageDef.ResGetMailItemMessage, self.ResGetMailItemMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAIL_STATE_CHANGE, self.CheckState, self)
    SL:RegisterLUAEvent(LUA_EVENT_RECEIVE_EMAIL, self.Refresh, self)

    GUI:AddOnClickEvent(self.view.get_all_btn, self, self.AllReceive)
    GUI:AddOnClickEvent(self.view.del_all_btn, self, self.AllDelMail)
    GUI:AddOnClickEvent(self.view.del_btn, self, self.DelMail)
    GUI:AddOnClickEvent(self.view.detail_btn, self, function()
        self.isRefresh = false
        SL:GetMailItems(self.mailId)
    end)

    GUI:AddOnClickEvent(self.view.des_btn, self, function()
        local helpCfg = SL:GetConfig("cfg_rule_text", 15, "id")
        if helpCfg then
            SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
        end
    end)
    GUI:AddOnClickEvent(self.view.closeBtn, self, function()
        GUI:UIPanel_Close("dev/ui/Mail/Panel/KLMail/KLMailPanel")
    end)
end

---@param message MailProto.MailIdMsg
function this:ResGetMailItemMessage(_, message)
    local items = {}
    if table.count(message.mailIds) == 0 then
        return
    end
    local mails = SL.Mail:GetAllMail()
    local grailInfo = {}
    for i, v in pairs(message.mailIds) do
        local info = mails[v]

        for _, k in pairs(info.items) do
            local type = SL:GetMetaValue(EMetaVarGetKey.ITEMTYPE, k.cfgId)
            local subType = SL:GetMetaValue(EMetaVarGetKey.ITEMSUBTYPE, k.cfgId)
            if type == 9 and subType == 1 and k.count == 1 then
                table.insert(grailInfo, { cfgId = k.cfgId, count = 1, id = k.id })
            else
                if items[k.cfgId] then
                    items[k.cfgId].count = items[k.cfgId].count + k.count
                else
                    items[k.cfgId] = {}
                    items[k.cfgId].count = k.count
                    items[k.cfgId].id = k.id
                end
            end
        end
    end
    local reward = {}
    for i, v in pairs(items) do
        table.insert(reward, { cfgId = i, count = v.count, id = v.id })
    end
    for k, v in pairs(grailInfo) do
        table.insert(reward, v)
    end
    SL:OpenRewardTips(reward, 0)
    GUI:SetActive(self.view.del_btn, true)
    GUI:SetActive(self.view.detail_btn, false)
    self:SelectMail(nil, message.mailIds[1])
    if self.isRefresh then
        self:Refresh()
    end
end

function this:DataListMailCountFunc()
    return table.count(SL.Mail:GetAllMail())
end

function this:DataListMailGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/Mail/Item/KLMailItem/KLMailItemItem", self.view.mail_data_list, self, nil, true)
    self.selectBtn[item] = item

    return item
end

function this:DataListMailInitFunc(realIndex, kmlcontrol)

end

function this:DataListMailUpdateFunc(kmlcontrol, realIndex)
    local luaind = realIndex + 1

    local data = self.info[luaind]
    local title = kmlcontrol.view.mail_title_
    GUI:Text_setString(title, data.title)

    local atlas = "Atlas/FG_EmailPanel.spriteatlas"
    if data.state == 0 then
        if data.item then
            GUI:Image_loadTexture(kmlcontrol.view.mail_icon_, "icon_haveitem", atlas)
        else
            GUI:Image_loadTexture(kmlcontrol.view.mail_icon_, "icon_unread", atlas)
        end
    elseif data.state == 1 then
        GUI:Image_loadTexture(kmlcontrol.view.mail_icon_, "icon_unclaimed", atlas)
    else
        if data.item then
            GUI:Image_loadTexture(kmlcontrol.view.mail_icon_, "icon_received", atlas)
        else
            GUI:Image_loadTexture(kmlcontrol.view.mail_icon_, "icon_read", atlas)
        end
    end
    local timestr = Time.FormatTimeYMDHMS(data.time)
    local time = kmlcontrol.view.mail_time_
    GUI:Text_setString(time, timestr)
    kmlcontrol.index = luaind
    kmlcontrol.callback = self.SelectMail
    kmlcontrol.ui = self
    kmlcontrol.mailId = data.mailId
    GUI:setVisible(kmlcontrol.view.redpoint, data.state == 0 or (data.item and data.state ~= 2))
    kmlcontrol:Selected(self.selectid == luaind)
end

function this:ItemSizeGetFun(index)
    return 79
end

function this:LoadData()
    local data = {}
    local mails = SL.Mail:GetAllMail()
    for i, v in pairs(mails) do
        local time = v.overdueTime - Time.GetServerTime() / 1000
        if time > 0 then
            local info = {
                mailId = v.mailId,
                title = v.title,
                time = v.sendTime,
                state = v.state,
                item = table.count(v
                    .items) ~= 0,
                hasItems = v.state ~= 2 and v.items and #v.items > 0
            }
            table.insert(data, info)
        end
    end
    table.sort(data, function(a, b)
        local timeCompare = a.time > b.time
        local wa = timeCompare and 1 or 0
        local wb = timeCompare and 0 or 1
        if a.state == 0 then
            wa = wa + 10
        end
        if b.state == 0 then
            wb = wb + 10
        end
        if a.hasItems then
            wa = wa + 100
        end
        if b.hasItems then
            wb = wb + 100
        end
        return wa > wb
    end)
    return data
end

function this:SelectMail(index, mailId)
    if index == nil then
        index = self.selectid
    else
        self.selectid = index
    end
    local mails = SL.Mail:GetAllMail()
    for i, v in pairs(self.selectBtn) do
        --v.SelectMail(v,)
        if v.index == index then
            v.Selected(v, true)
            local icon = v.view.mail_icon_
            if table.count(mails[mailId].items) > 0 and mails[mailId].state ~= 2 then
                self.info[index].state = 1
                GUI:Image_loadTexture(icon, "icon_unclaimed", "Atlas/FG_EmailPanel.spriteatlas")
            elseif table.count(mails[mailId].items) > 0 then
                self.info[index].state = 2
                GUI:Image_loadTexture(icon, "icon_received", "Atlas/FG_EmailPanel.spriteatlas")
            else
                self.info[index].state = 2
                GUI:Image_loadTexture(icon, "icon_read", "Atlas/FG_EmailPanel.spriteatlas")
            end
            GUI:setVisible(v.view.redpoint, self.info[index].state ~= 2)
        else
            v.Selected(v, false)
        end
    end
    if mails[mailId].state == 0 then
        self.isRefresh = false
        SL:RequestReadMail({ mailId })
    end
    self:LoadPanel(mailId)
end

--- 页面加载
function this:LoadPanel(mailId)
    self.mailId = mailId
    local data = SL.Mail:GetAllMail()[mailId]
    --标题
    GUI:Text_setString(self.view.content_title, data.title)
    --    时间
    local time = data.overdueTime - Time.GetServerTime() / 1000
    local timeText = ""
    if time <= 0 then
        timeText = "已过期"
    else
        timeText = "有效期：" .. Time.FormatTimeDH(time)
    end

    GUI:Text_setString(self.view.content_time, timeText)
    --    内容
    GUI:Text_setString(self.view.content_text, data.content)

    --  状态
    if table.count(data.items) > 0 and data.state ~= 2 and time > 0 then
        GUI:SetActive(self.view.del_btn, false)
        GUI:SetActive(self.view.detail_btn, true)
        --GUI:AddOnClickEvent(self.view.detail_btn, self, function()
        --    SL:GetMailItems(data.mailId)
        --end)
    else
        GUI:SetActive(self.view.del_btn, true)
        GUI:SetActive(self.view.detail_btn, false)
    end

    --    附件
    if table.count(data.items) == 0 then
        GUI:SetActive(self.view.received_attachment, false)
    else
        GUI:SetActive(self.view.received_attachment, true)
    end
    GUI:DataListInitData(self.view.items_list, function()
        return table.count(data.items)
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol, data)
    end)
    GUI:DataListUpdateData(self.view.items_list)
end

function this:DataListItemGetFunc(realIndex)

end

function this:DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:DataListItemUpdateFunc(realIndex, kmlcontrol, data)
    local itemTbl = data.items[realIndex + 1]
    --local item2 = self.view.items_list:GetChildControl(realIndex, "item2")
    local item2 = GUI:GetChildControl(self.view.items_list, realIndex, "item2")
    GUI:Item_UpdataData(item2, {
        itemid = itemTbl.cfgId,
        --itemcount = itemTbl.count,
    })
    --local itemcount = self.view.items_list:GetChildControl(realIndex, "itemcount")
    local itemcount = GUI:GetChildControl(self.view.items_list, realIndex, "itemcount")
    local count = SL:GetSimpleNumber(itemTbl.count, 1)
    GUI:Text_setString(itemcount, tostring(count))
    GUI:Text_setFontSize(itemcount, 12)
    --local click_item = self.view.items_list:GetChildControl(realIndex, "click_item")
    local click_item = GUI:GetChildControl(self.view.items_list, realIndex, "click_item")
    --local item_received = self.view.items_list:GetChildControl(realIndex, "item_received")
    local item_received = GUI:GetChildControl(self.view.items_list, realIndex, "item_received")

    GUI:AddOnClickEvent(click_item, self, function()
        local type = SL:GetMetaValue(EMetaVarGetKey.ITEMTYPE, itemTbl.cfgId)
        local subType = SL:GetMetaValue(EMetaVarGetKey.ITEMSUBTYPE, itemTbl.cfgId)
        if type == 9 and subType == 1 then
            SL:OpenTips("mail", itemTbl.cfgId, itemTbl.id, nil, itemTbl,{hideBtn =true})
        else
            SL:OpenTips("mail", itemTbl.cfgId, itemTbl.id, itemTbl.count,nil,{hideBtn =true})
        end
    end)

    if data.state ~= 2 then
        GUI:SetActive(item_received, false)
    else
        --GUI:AddOnClickEvent(click_item, self, function()
        --    SL:OpenTips("mail", itemTbl.cfgId, itemTbl.id,itemTbl.count)
        --end)
        GUI:SetActive(item_received, true)
    end
end

function this:DelMail()
    SL.Mail:ReqDeleteMail({ self.mailId })
    -- SL.Mail:GetAllMail()[self.mailId] = nil
    -- self:Refresh()
    self.isRefresh = true
end

function this:AllDelMail()
    local data = {}
    local mails = SL.Mail:GetAllMail()
    for i, v in pairs(mails) do
        if v.state == 2 then
            table.insert(data, i)
        end
    end
    self.isRefresh = true
    SL.Mail:ReqDeleteMail(data)

    --self:RefreshUI()
end

function this:AllReceive()
    self.isRefresh = true
    SL:GetAllMailItems()
end

function this:Close()
    if self.schedule then
        SL:UnSchedule(self.schedule)
    end
    SL:UnRegisterLuaNetMsg(MessageDef.ResGetMailItemMessage, self.ResGetMailItemMessage, self)
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIL_STATE_CHANGE, self.CheckState, self)
    SL:UnRegisterLUAEvent(LUA_EVENT_RECEIVE_EMAIL, self.Refresh, self)
    SL:ShowMainPanel()
end

function this:CheckState()
    self:Refresh()
end

return this

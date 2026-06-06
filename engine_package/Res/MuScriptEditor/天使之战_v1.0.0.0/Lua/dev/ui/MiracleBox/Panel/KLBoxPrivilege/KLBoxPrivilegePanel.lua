---@class KLBoxPrivilegePanel:UIKmlLuaPanelBase
---@field view KLBoxPrivilegePanelView
---@field cfgId
---@field currentTab
local KLBoxPrivilegePanel = class(UIKmlLuaPanelBase)
local this = KLBoxPrivilegePanel

BoxPrivilegeBtnType = {
    Activate = enum(),
    Receive = enum(),
    Gray = enum()
}

function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    self.tbl = self:LoadData()
    self.toggleList = {}
    --table.sort(self.tbl, function(a, b)
    --    return a.tab < b.tab
    --end)
    self.currentTab = EBoxPrivilege.Privilege
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.close, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.privilege_btn, self, self.PrivilegeBtn)
    GUI:AddOnClickEvent(self.view.DownLoad, self, self.DownLoadBtn)
    SL:RegisterLUAEvent(LUA_EVENT_MUBOX_INFO,self.ResMuBoxInfoMessage,self)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.dataList = {}

    self.btnType = BoxPrivilegeBtnType.Activate

    GUI:DataListInitData(self.view.toggle_list, function()
        return #self.tbl
    end, function(realIndex)
        return self:ItemGet(realIndex)
    end, function(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:ToggleListUpdateFunc(realIndex, kmlCtrl)
    end)

    GUI:DataListUpdateData(self.view.toggle_list)
    GUI:DataListInitData(self.view.att_list, function()
        return #self.dataList
    end, function(realIndex)
    end, function(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:AttListUpdateFunc(realIndex, kmlCtrl)
    end)

    GUI:DataListInitData(self.view.item_list, function()
        return #self.dataList
    end, function(realIndex)
    end, function(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:ItemListUpdateFunc(realIndex, kmlCtrl)
    end)

    GUI:DataListInitData(self.view.appellation_list, function()
        return #self.appellation
    end, function(realIndex)
    end, function(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:AppellationItem(realIndex, kmlCtrl)
    end)

    for _, v in pairs(self.toggleList) do
        v:InitUI(self.currentTab)
    end
end

function this:TogglePrivilegeOnValueChange(c, control)
    if c[1] then
        self.dataList = {}
        local tbls = self.tbl[EBoxPrivilege.Privilege]
        --local tbl = tbls[1]
        self.cfgId = tbls[1].id
        self.currentTab = EBoxPrivilege.Privilege
        GUI:Text_setString(self.view.tip, tbls[1].text)
        for i, tbl in pairs(tbls) do
            if tbl.type == 1 then
                for _, v in pairs(tbl.param) do
                    for _, k in pairs(v) do
                        local buffName = SL:GetConfig("cfg_buff", k, "id").buffName
                        buffName = string.split(buffName, "+")
                        buffName = buffName[1] .. "<color='#24FF00'>+" .. buffName[2] .. "</color>"
                        table.insert(self.dataList, buffName)
                    end
                end
            elseif tbl.type == 3 then
                self.appellation = tbl.param
                GUI:DataListUpdateData(self.view.appellation_list)
            end
        end
        --for _, v in pairs(tbl.param) do
        --    for _, k in pairs(v) do
        --        local buffName = SL:GetConfig("cfg_buff", k, "id").buffName
        --        buffName = string.split(buffName, "+")
        --        buffName = buffName[1] .. "<color='#24FF00'>+" .. buffName[2] .. "</color>"
        --        table.insert(self.dataList, buffName)
        --    end
        --end
        if not SL:GetMetaValue(EMetaVarGetKey.GET_BOX_PRIVILEGE) then
            GUI:setVisible(self.view.privilege_btn)
            GUI:Button_setGrey(self.view.privilege_btn, false)
            GUI:Button_setTitleText(self.view.privilege_btn, "获取特权")
            self.btnType = BoxPrivilegeBtnType.Activate
            GUI:Text_setString(self.view.activate_text, "<color=#FF0000>未激活</color>")
        else
            GUI:setVisible(self.view.privilege_btn, false)
            GUI:Text_setString(self.view.activate_text, "<color=#00FF00>已激活</color>")
        end
        GUI:DataListUpdateData(self.view.att_list)
    end
    GUI:setVisible(control, c[1])
    GUI:setVisible(self.view.panel_1, c[1])
end

function this:ToggleItemsOnValueChange(c, control)
    if c[1] then
        self.dataList = {}
        local tbl = self.tbl[EBoxPrivilege.DayGift][1]
        self.currentTab = EBoxPrivilege.DayGift
        self.cfgId = tbl.id
        GUI:Text_setString(self.view.tip, tbl.text)
        for i, v in pairs(tbl.param) do
            table.insert(self.dataList, v)
        end
        if not SL:GetMetaValue(EMetaVarGetKey.GET_BOX_PRIVILEGE) then
            GUI:setVisible(self.view.privilege_btn)
            GUI:Button_setGrey(self.view.privilege_btn, false)
            GUI:Button_setTitleText(self.view.privilege_btn, "获取特权")
            self.btnType = BoxPrivilegeBtnType.Activate
        elseif SL:GetMetaValue(EMetaVarGetKey.GET_BOX_DAILY_GIFT) then
            GUI:setVisible(self.view.privilege_btn, true)
            GUI:Button_setTitleText(self.view.privilege_btn, "已领取")
            GUI:Button_setGrey(self.view.privilege_btn, true)
            self.btnType = BoxPrivilegeBtnType.Gray
        else
            GUI:setVisible(self.view.privilege_btn, true)
            GUI:Button_setGrey(self.view.privilege_btn, false)
            GUI:Button_setTitleText(self.view.privilege_btn, "领取奖励")
            self.btnType = BoxPrivilegeBtnType.Receive
        end
        GUI:DataListUpdateData(self.view.item_list)
    end
    GUI:setVisible(control, c[1])
    GUI:setVisible(self.view.panel_2, c[1])
end

function this:AttListUpdateFunc(realIndex, kmlCtrl)
    --local att_text = self.view.att_list:GetChildControl(realIndex, "att_text")
    local att_text = GUI:GetChildControl(self.view.att_list,realIndex, "att_text")
    GUI:Text_setString(att_text, self.dataList[realIndex + 1])
end

function this:ItemListUpdateFunc(realIndex, kmlCtrl)
    --local item_show = self.view.item_list:GetChildControl(realIndex, "item_show")
    local item_show = GUI:GetChildControl(self.view.item_list,realIndex, "item_show")
    GUI:Item_UpdataData(item_show, {
        itemid = self.dataList[realIndex + 1][1],
        itemcount = self.dataList[realIndex + 1][2]
    })
    GUI:AddOnClickEvent(item_show, self, function()
        SL:OpenTips(_, self.dataList[realIndex + 1][1])
    end)
end

function this:ItemGet(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/MiracleBox/Item/KLBoxPrivilege/KLBoxPrivilegeItem", self.view.toggle_list, self, { tbl = self.tbl[realIndex + 1], toggle_group = self.view.toggle_group })
    table.insert(self.toggleList, item)
end

function this:ToggleListUpdateFunc(realIndex, kmlCtrl)
    --local toggle = self.view.toggle_list:GetChildControl(realIndex, "toggle_privilege")
    local toggle = GUI:GetChildControl(self.view.toggle_list,realIndex, "toggle_privilege")
    GUI:SetToggleGroup(toggle, self.view.toggle_group)
end

function this:AppellationItem(realIndex, kmlCtrl)
    local data = self.appellation[realIndex + 1]
    --local img = self.view.appellation_list:GetChildControl(realIndex, "appellation_item")
    local img = GUI:GetChildControl(self.view.appellation_list,realIndex, "appellation_item")
    local itemTbl = SL:GetConfig("cfg_item", data[1],"id")
    local modelTbl = SL:GetConfig('cfg_model_charactor', itemTbl.shape[1])
    GUI:Image_loadTexture(img, modelTbl.path ..".png")
end

function this:PrivilegeBtn()
    if self.btnType == BoxPrivilegeBtnType.Activate then
        self:DownLoadBtn()
    elseif self.btnType == BoxPrivilegeBtnType.Receive then
        SL:ReqReceivePrivilegeGiftMessage(self.cfgId)
    end
end

function this:ResMuBoxInfoMessage()
    self:Refresh()
end

--[[ "eventCode": "promotion_click",
"accountId":3,//用户ID选传
"deviceId": "64b95elc-1fb8-448d-9753-00e9f42f3c1c"
"appVersion": "3.0",
"channelCode": "CHL16312522075640003",
channelName":
"deviceType":"
"华为",
"eventTime": 1729667795000,
"moduleId": "download_app_button",
"moduleName":"游戏中下载app按钮",
"eventAttribute": {
"deviceVersion": "17406"
]]--
function this:DownLoadBtn()
    local appId = 3
    if SL:GetMetaValue(EMetaVarGetKey.PLATFORM_ANDROID) then
        appId = 1
    elseif SL:GetMetaValue(EMetaVarGetKey.PLATFORM_IOS) then
        appId = 2
    end
    local channelCode = SL:GetMetaValue(EMetaVarGetKey.GAME_ID)
    if string.isNullOrEmpty(channelCode) then
        channelCode = "TEST712712712712TEST"
    end
    local verData = SL:GetMetaValue("CS_MAIN_VERSION_DATA")
    local data = {
        eventCode = "promotion_click", -- 事件ID，固定写死
        accountId = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID), -- 用户ID 可为空
        deviceId = SL:GetMetaValue(EMetaVarGetKey.DEVICE_ID), -- 设备标识/设备唯一编号
        appVersion = tostring(verData and verData.clientVersion or "1"), --版本名称 PACKAGE_NAME
        appId = appId,
        channelCode = channelCode, -- 游戏ID 
        channelName = "玄武奇迹", --渠道名/游戏名称
        deviceType = SL:GetMetaValue(EMetaVarGetKey.DEVICE_TYPE), --设备类型 如：SM_G9730
        eventTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME) / 1000, --时间戳
        deviceVersion = SL:GetMetaValue(EMetaVarGetKey.DEVICE_VERSION), --设备版本 SystemInfo.operatingSystem
        moduleId = "download_app_button", --游戏中下载按钮id 固定写死
        moduleName = "游戏中下载app按钮"--游戏中下载按钮名称 固定写死
    }
    local json = SL:JsonEncode(data, false)
    local head = SL:CreateCSDictionary()
    head:Add("Content-Type", "application/json")
    SL:HTTPRequestPost("http://api712.hzpt712.chenjwl.com/api/analyticApp/appApi/event/single/event/report", function(_, message)
        if message then
            if SL:GetMetaValue(EMetaVarGetKey.PLATFORM_ANDROID) then
                SL:OpenURL(SL:GetConfig("cfg_global", 900, "id").value)
            elseif SL:GetMetaValue(EMetaVarGetKey.PLATFORM_IOS) then
                SL:OpenURL(SL:GetConfig("cfg_global", 901, "id").value)
            else
                SL:OpenURL(SL:GetConfig("cfg_global", 900, "id").value)
            end
        end
    end, json, head)

end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/ui/MiracleBox/Panel/KLBoxPrivilege/KLBoxPrivilegePanel")
end

function this:Close()
    SL.ShowMainPanel()
end

function this:LoadData()
    local info = {}
    local data = SL:GetConfigTable("cfg_box")
    for i, v in pairs(data) do
        if not info[v.tab] then
            info[v.tab] = {}
        end
        table.insert(info[v.tab], v)
    end
    return info
end

return this

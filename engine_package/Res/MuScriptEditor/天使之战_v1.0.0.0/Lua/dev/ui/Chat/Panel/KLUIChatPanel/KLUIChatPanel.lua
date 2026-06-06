---@class KLUIChatPanel:UIKmlLuaPanelBase
---@field view KLUIChatPanelView
local KLUIChatPanel = class(UIKmlLuaPanelBase)
local this = KLUIChatPanel
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    self:GetSendNameList()
    if self.args.type and self.args.type.channel then
        self.args.channel = self.args.type.channel
    end
    if not self.args.channel then
        self.args.channel = EChatChannelType.ALL
    end
    self.isHideMainPanel = self.args and self.args.type and self.args.type.isHide
    self.allType = EChatChannelType.WORLD
    self:ZongSelectType(self.allType)
    self.allTypeIsShow = false
    self.message = ""
    self.chatView = nil
    GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatView/KLUIChatView", self.view.panel_root, self,
        { width = 387, height = 528, x = 0, y = -70 }, false,
        function(item)
            self.chatView = item
        end)
    self.all_type_info = {}
    ---@type cfg_system_switch_column
    local systemCfg = SL:GetConfig("cfg_system_switch", 229)
    --跨服满足条件才添加
    local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, systemCfg.systemName)
    if isMeet then
        table.insert(self.all_type_info, 101)
    end
    table.insertArray(self.all_type_info, { 2, 6, 4, 7 })
    self.all_emoji_info = {}
    for i = 61, 87 do
        table.insert(self.all_emoji_info, i .. "000")
    end
    GUI:Text_sethorwrap(self.view.text_input, "1")
    GUI:Text_setmline(self.view.text_input, "0")
    GUI:DataListInitData(self.view.zong_data_list, function()
        return self:TypeDataListItemCountFunc()
    end, function(realIndex)
        return self:TypeDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:TypeDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:TypeDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.btn_all_item = {}
    self.emoji_is_show = false
    GUI:DataListInitData(self.view.emoji_data_list, function()
        return self:EmojiDataListItemCountFunc()
    end, function(realIndex)
        return self:EmojiDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:EmojiDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EmojiDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.btn_emoji_item = {}
    self.item_is_show = false
    self.ChatItem = {}
    self.item_select_type = 1
    self:ItemBtnShow()
    self:SelectChatType()
    GUI:DataListUpdateData(self.view.zong_data_list)
    GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatItem/KLUIChatItem", self.view.root, self, {}, true, function(item)
        self.calculationUI = item
        GUI:setPositionX(self.calculationUI.view.root, 2000)
        GUI:setPositionY(self.calculationUI.view.root, 2000)
    end)
    self.maxHeight = 320
    self.isClose = false
    self.submitName = ""
    self.submitId = 0
    self:ClosePrivateSelect()

    GUI:DataListInitData(self.view.all_name_data_list, function()
        return self:NameDataListItemCountFunc()
    end, function(realIndex)
        return self:NameDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:NameDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:NameDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.btn_name_item = {}
    if self.args.channel == 8 then
        GUI:Toggle_setIsOn(self.view.siliao_toggle, self, true)
        if self.args.type and self.args.type.rid and self.args.type.name then
            self.submitName = self.args.type.name
            self.submitId = self.args.type.rid
        end
        GUI:SetInputText(self.view.private_input, self.submitName)
        GUI:setVisible(self.view.private_input_place, false)
        self:AddChatName(self.submitId)
    end
    self.updateID = SL:Schedule(self.updateID, 0, Time.deltaTime, -1, function()
        self:Update()
    end)
    self.limitChannel = {}
    if SL:HasConfig("cfg_global", 720001) then
        local limitChannel = string.split(SL:GetConfig("cfg_global", 720001).value, '#')
        for i, v in pairs(limitChannel) do
            self.limitChannel[tonumber(v)] = true
        end
    end
end

function this:Update()
    if not self.nextDoRevTime then
        return
    end
    if Time.time > self.nextDoRevTime then
        local is_success = self:UpdateChanInfo()
        if is_success then
            self.nextDoRevTime = nil
        end
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

function this:SelectChatType()
    if self.args.channel == EChatChannelType.ALL then --综合
        GUI:setVisible(self.view.di_panel, true)
        GUI:setVisible(self.view.all_type_panel, true)
        GUI:Image_loadTexture(self.view.text_input, "texebg_input_s", "Atlas/UIChatPanelOut.spriteatlas")
        GUI:SetImageNativeSize(self.view.text_input)
        -- GUI:setContentSize(self.view.text_input, 250, 38)
        GUI:setVisible(self.view.no_union_panel, false)
        GUI:setVisible(self.view.no_team_panel, false)
        GUI:setVisible(self.view.system_panel, false)
        GUI:setVisible(self.view.private_panel, false)
    elseif self.args.channel == EChatChannelType.SYSTEM then --系统
        GUI:setVisible(self.view.di_panel, false)
        GUI:setVisible(self.view.all_type_panel, false)
        GUI:setVisible(self.view.no_union_panel, false)
        GUI:setVisible(self.view.no_team_panel, false)
        GUI:setVisible(self.view.system_panel, true)
        GUI:setVisible(self.view.private_panel, false)
    elseif self.args.channel == 101 then --跨服
        GUI:setVisible(self.view.di_panel, true)
        GUI:setVisible(self.view.all_type_panel, false)
        -- GUI:setContentSize(self.view.text_input, 370, 38)
        GUI:Image_loadTexture(self.view.text_input, "texebg_input_b", "Atlas/UIChatPanelOut.spriteatlas")
        GUI:SetImageNativeSize(self.view.text_input)
        GUI:setVisible(self.view.no_union_panel, false)
        GUI:setVisible(self.view.no_team_panel, false)
        GUI:setVisible(self.view.system_panel, false)
        GUI:setVisible(self.view.private_panel, false)
    elseif self.args.channel == EChatChannelType.WORLD then --世界
        GUI:setVisible(self.view.di_panel, true)
        GUI:setVisible(self.view.all_type_panel, false)
        -- GUI:setContentSize(self.view.text_input, 370, 38)
        GUI:Image_loadTexture(self.view.text_input, "texebg_input_b", "Atlas/UIChatPanelOut.spriteatlas")
        GUI:SetImageNativeSize(self.view.text_input)
        GUI:setVisible(self.view.no_union_panel, false)
        GUI:setVisible(self.view.no_team_panel, false)
        GUI:setVisible(self.view.system_panel, false)
        GUI:setVisible(self.view.private_panel, false)
    elseif self.args.channel == EChatChannelType.NEARBY then --附近
        GUI:setVisible(self.view.di_panel, true)
        GUI:setVisible(self.view.all_type_panel, false)
        -- GUI:setContentSize(self.view.text_input, 370, 38)
        GUI:Image_loadTexture(self.view.text_input, "texebg_input_b", "Atlas/UIChatPanelOut.spriteatlas")
        GUI:SetImageNativeSize(self.view.text_input)
        GUI:setVisible(self.view.no_union_panel, false)
        GUI:setVisible(self.view.no_team_panel, false)
        GUI:setVisible(self.view.system_panel, false)
        GUI:setVisible(self.view.private_panel, false)
    elseif self.args.channel == EChatChannelType.UNION then --战盟
        GUI:setVisible(self.view.all_type_panel, false)
        -- GUI:setContentSize(self.view.text_input, 370, 38)
        GUI:Image_loadTexture(self.view.text_input, "texebg_input_b", "Atlas/UIChatPanelOut.spriteatlas")
        GUI:SetImageNativeSize(self.view.text_input)
        GUI:setVisible(self.view.no_team_panel, false)
        GUI:setVisible(self.view.system_panel, false)
        if not SL:MeData_Check() or not SL:MeData_GetRoleExtInfo() or SL:MeData_GetRoleExtInfo().unionId == 0 then
            GUI:setVisible(self.view.di_panel, false)
            GUI:setVisible(self.view.no_union_panel, true)
        else
            GUI:setVisible(self.view.no_union_panel, false)
            GUI:setVisible(self.view.di_panel, true)
        end
        GUI:setVisible(self.view.private_panel, false)
    elseif self.args.channel == EChatChannelType.TEAM then --队伍
        GUI:setVisible(self.view.all_type_panel, false)
        -- GUI:setContentSize(self.view.text_input, 370, 38)
        GUI:Image_loadTexture(self.view.text_input, "texebg_input_b", "Atlas/UIChatPanelOut.spriteatlas")
        GUI:SetImageNativeSize(self.view.text_input)
        GUI:setVisible(self.view.no_union_panel, false)
        GUI:setVisible(self.view.system_panel, false)
        if SL:TeamInfo_IsInTeam() then
            GUI:setVisible(self.view.no_team_panel, false)
            GUI:setVisible(self.view.di_panel, true)
        else
            GUI:setVisible(self.view.no_team_panel, true)
            GUI:setVisible(self.view.di_panel, false)
        end
        GUI:setVisible(self.view.private_panel, false)
    elseif self.args.channel == EChatChannelType.RECRUIT then --招募
        GUI:setVisible(self.view.di_panel, false)
        GUI:setVisible(self.view.all_type_panel, false)
        GUI:setVisible(self.view.no_union_panel, false)
        GUI:setVisible(self.view.no_team_panel, false)
        GUI:setVisible(self.view.system_panel, false)
        GUI:setVisible(self.view.private_panel, false)
    elseif self.args.channel == EChatChannelType.PERSONAL then --私聊
        GUI:setVisible(self.view.di_panel, true)
        GUI:setVisible(self.view.all_type_panel, false)
        -- GUI:setContentSize(self.view.text_input, 205, 38)
        GUI:Image_loadTexture(self.view.text_input, "texebg_input_s", "Atlas/UIChatPanelOut.spriteatlas")
        GUI:SetImageNativeSize(self.view.text_input)
        GUI:setVisible(self.view.no_union_panel, false)
        GUI:setVisible(self.view.no_team_panel, false)
        GUI:setVisible(self.view.system_panel, false)
        GUI:setVisible(self.view.private_panel, true)
    end
    if self.args.channel == EChatChannelType.NEARBY or self.args.channel == EChatChannelType.WORLD then
        GUI:setPosition(self.view.text_input, -22,98)
        GUI:setContentSize(self.view.text_input, 373, 32)
    else
        GUI:setPosition(self.view.text_input, -20,98)
    end
    self:ClosePrivateSelect()
    self.message = ""
    GUI:Text_setString(self.view.text_input, "")
    GUI:setVisible(self.view.text_input_place, true)
    self.ChatItem = {}
    self.nextDoRevTime = Time.time + Time.deltaTime
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.background_close, self, self.ClosePanel)
    --GUI:AddOnClickEvent(self.view.left_btn, self, self.BtnLeftOnClick)
    --GUI:AddOnClickEvent(self.view.right_btn, self, self.BtnRightOnClick)
    --GUI:AddOnClickEvent(self.view.tuoxiabtn, self, self.TakeOffEquip)
    GUI:AddOnClickEvent(self.view.btn_close, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.selectTyptbtn, self, self.SelectTypeAllShow)
    GUI:AddOnClickEvent(self.view.zong_panel_close, self, self.CloseAllShow)
    GUI:SetToggleOnValueChange(self.view.zonghe_toggle, self, self.zonghe_toggle_onclick)
    GUI:SetToggleOnValueChange(self.view.corss_server_chat_toggle, self, self.corss_server_chat_toggle_onclick)
    GUI:SetToggleOnValueChange(self.view.shijie_toggle, self, self.shijie_toggle_onclick)
    GUI:SetToggleOnValueChange(self.view.fujin_toggle, self, self.fujin_toggle_onclick)
    GUI:SetToggleOnValueChange(self.view.zhanmeng_toggle, self, self.zhanmeng_toggle_onclick)
    GUI:SetToggleOnValueChange(self.view.duiwu_toggle, self, self.duiwu_toggle_onclick)
    --GUI:SetToggleOnValueChange(self.view.zhaomu_toggle, self, self.zhaomu_toggle_onclick)
    GUI:SetToggleOnValueChange(self.view.siliao_toggle, self, self.siliao_toggle_onclick)
    GUI:SetToggleOnValueChange(self.view.xitong_toggle, self, self.xitong_toggle_onclick)
    GUI:AddOnClickEvent(self.view.fasong, self, self.SendChat)
    GUI:AddOnClickEvent(self.view.pos_btn, self, self.AddPos)
    GUI:AddOnClickEvent(self.view.biaoqing_btn, self, self.OnlickEmoji)
    GUI:AddOnClickEvent(self.view.emoji_mask, self, self.HideEmoji)
    GUI:AddOnClickEvent(self.view.bag_btn, self, self.OnlickItem)
    GUI:AddOnClickEvent(self.view.item_mask, self, self.HideItem)
    GUI:Input_SetOnValueChange(self.view.text_input, self, self.TextChange)
    GUI:AddOnClickEvent(self.view.btn_bag, self, self.btn_bag_onclick)
    GUI:AddOnClickEvent(self.view.btn_equip, self, self.btn_equip_onclick)
    GUI:AddOnClickEvent(self.view.btn_datianshi, self, self.btn_datianshi_onclick)
    GUI:AddOnClickEvent(self.view.create_union_btn, self, self.JoinUnion)
    GUI:AddOnClickEvent(self.view.join_union_btn, self, self.JoinUnion)
    GUI:AddOnClickEvent(self.view.create_team_btn, self, self.CreateTeam)
    GUI:AddOnClickEvent(self.view.join_team_btn, self, self.JoinTeam)
    GUI:Input_SetOnEndEdit(self.view.private_input, self, self.NameChangeEnd)
    GUI:Input_SetOnValueChange(self.view.private_input, self, self.NameChange)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_RECEIVE, self.ChatReceive, self)
    GUI:AddOnClickEvent(self.view.private_panel_btn, self, self.OpenPrivateSelect)
    GUI:AddOnClickEvent(self.view.private_panel_close_btn, self, self.ClosePrivateSelect)
    SL:RegisterLuaNetMsg(MessageDef.ResFindIdByNameMessage, self.ResNameMessage, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.PLAYER_IS_ON_LINE_RES, self.PlayerIsOnLine, self)
end

function this:zonghe_toggle_onclick()
    self.args.channel = EChatChannelType.ALL
    self:SelectChatType()
end

function this:corss_server_chat_toggle_onclick()
    self.args.channel = 101
    self:SelectChatType()
end

function this:shijie_toggle_onclick()
    self.args.channel = EChatChannelType.WORLD
    self:SelectChatType()
end

function this:fujin_toggle_onclick()
    self.args.channel = EChatChannelType.NEARBY
    self:SelectChatType()
end

function this:zhanmeng_toggle_onclick()
    self.args.channel = EChatChannelType.UNION
    self:SelectChatType()
end

function this:duiwu_toggle_onclick()
    self.args.channel = EChatChannelType.TEAM
    self:SelectChatType()
end

function this:zhaomu_toggle_onclick()
    self.args.channel = EChatChannelType.RECRUIT
    self:SelectChatType()
end

function this:siliao_toggle_onclick()
    self.args.channel = EChatChannelType.PERSONAL
    self:SelectChatType()
end

function this:xitong_toggle_onclick()
    self.args.channel = EChatChannelType.SYSTEM
    self:SelectChatType()
end

function this:ClosePanel()
    self:saveData()
    SL:CloseChatUI()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    if not self.isHideMainPanel then
        SL.ShowMainPanel()
    end
    if self.updateID then
        SL:UnSchedule(self.updateID)
        self.updateID = nil
    end
end

function this:saveData()
    if SL.chatPrivatePlayerList then
        local allList = {}
        for id, onePlayer in pairs(SL.chatPrivatePlayerList) do
            local value = {}
            for id2, v2 in pairs(onePlayer) do
                table.insert(value, v2)
            end
            table.insert(allList, { k = id, v = value })
        end
        --SL:LogTable(SL.chatPrivatePlayerList,true)
        --SL:LogTable(allList,true)
        local str = SL:JsonEncode(allList)
        SL:SetLocalString("chat_ui_send_name_list", str)
    end
end

function this:GetSendNameList()
    SL.chatPrivatePlayerList = {}
    local str = SL:GetLocalString("chat_ui_send_name_list")
    if str and str ~= "" then
        local allList = SL:JsonDecode(str)
        for id, onePlayer in pairs(allList) do
            SL.chatPrivatePlayerList[onePlayer.k] = {}
            for j, oneName in pairs(onePlayer.v) do
                SL.chatPrivatePlayerList[onePlayer.k][oneName.rid] = oneName
            end
        end
        --SL:LogTable(SL.chatPrivatePlayerList,true)
    end
end

function this:Close()
    self.isClose = true
    SL.ShowMainPanel()
end

function this:UpdateChanInfo()
    if not self.chatView or not self.chatView:isLoadEnd() then
        return false
    end
    self.chat_list = {}
    if self.args.channel == EChatChannelType.FRIEND or self.args.channel == EChatChannelType.PERSONAL then
        local msgids = SL:ChatInfo_GetChaTargetInfo(self.submitId)
        for i, v in ipairs(msgids) do
            table.insert(self.chat_list, v)
        end
    else
        self.chat_list = SL:ChatInfo_GetChatInfo(self.args.channel)
    end
    self.chatView:RefreshData(self.chat_list)
    return true
end

function this:TextChange(a, b, eventData)
    if self.isClose then
        return
    end
    local messageStr = eventData[1]
    if string.isNullOrEmpty(messageStr) then
        self.message = messageStr
        self.ChatItem = {}
        GUI:setVisible(self.view.text_input_place, true)
    else
        GUI:setVisible(self.view.text_input_place, false)
        local str = self:CheckInputRichText(messageStr)
        if str ~= messageStr then
            messageStr = str
            GUI:Text_setString(self.view.text_input, messageStr)
        end
        local mess = { message = { channel = EChatChannelType.SYSTEM, message = messageStr } }
        self.calculationUI:RefreshItem(mess)
        local xx, yy = GUI:getSizeDelta(self.calculationUI.view.richT)
        if yy <= self.maxHeight then
            self.message = messageStr
        else
            GUI:Text_setString(self.view.text_input, self.message)
        end
    end
end

--去掉玩家输入的富文本
function this:CheckInputRichText(message)
    --<size=500>超大字体</size>
    --<color=red>红色</color>
    local str = string.gsub(message, "<[^>]+>", "")
    return str
end

function this:SendChat()
    --PrivilegeCardManager.ReqAutoBuyStatus()
    --PrivilegeCardManager.ClearPrivilegeCardAllInfo()
    --PrivilegeCardManager.SendMU()
    if string.isNullOrEmpty(self.message) then
        return
    end
    local IsNeedAndActiveMonthCard = InfoManager.monthCardInfo:IsHaveMonthCardRights("chat")
    if not IsNeedAndActiveMonthCard then
        SL:TipMessage(SL:GetConfig('cfg_string', 289).text, 1, NoticeType.NoticeMid) --"购买并使用月卡或日卡后解锁聊天系统",
        self:clearMessage()
        return
    end
    local chat_type = self.args.channel
    if chat_type == EChatChannelType.ALL then
        chat_type = self.allType
    end
    if chat_type == EChatChannelType.WORLD then
        local level = tonumber(SL:GetConfig("cfg_global", 125).value)
        local playLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        if level > playLevel then
            SL:TipMessage(level .. "级解锁世界发言", 1, NoticeType.NoticeMid)
            self:clearMessage()
            return
        end
    end

    if not PrivilegeCardManager.iswithWorld() and self.limitChannel[chat_type] then
        SL:OpenCommonTipPanelById(24)
        self:clearMessage()
        return
    end
    local num = tonumber(SL:GetConfig("cfg_global", 9).value)
    if string.len(self.message) > num * 3 then
        self.message = string.sub(self.message, 1, num * 3)
    end
    if chat_type == EChatChannelType.PERSONAL and self.submitId == 0 then
        SL:TipMessage(SL:GetConfig('cfg_string', 290).text, 1, NoticeType.NoticeMid) --请输入私聊对象
        self:clearMessage()
        return
    end
    local targetid = nil
    if chat_type == EChatChannelType.PERSONAL then
        targetid = self.submitId
    end
    local rid = SL:MeData_GetId()
    local pkValue = InfoManager.redNameInfo:GetPkValueById(rid) or 0
    --P会触发屏蔽词，换成RED
    self.message = self.message .. string.format("{ADDINFO:RED#%d}", pkValue)
    SL:SendChat(chat_type, self.message, targetid, self.ChatItem)
    self:clearMessage()
end
function this:clearMessage()
    self.ChatItem = {}
    self.message = ""
    GUI:Text_setString(self.view.text_input, "")
    GUI:setVisible(self.view.text_input_place, true)
end
function this:ChatReceive(_id, message)
    if self.args.channel == EChatChannelType.ALL then --综合
        self.nextDoRevTime = Time.time + Time.deltaTime
    else
        if self.args.channel == message.channel then
            self.nextDoRevTime = Time.time + Time.deltaTime
        end
    end
end

function this:SelectTypeAllShow()
    self.allTypeIsShow = not self.allTypeIsShow
    GUI:setVisible(self.view.zong_panel, self.allTypeIsShow)
end

function this:CloseAllShow()
    self.allTypeIsShow = false
    GUI:setVisible(self.view.zong_panel, self.allTypeIsShow)
end

function this:TypeDataListItemCountFunc()
    return #self.all_type_info
end

function this:TypeDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatSelectTypeItem/KLUIChatSelectTypeItem",
        self.view.zong_data_list, self, {}, true)

    self.btn_all_item[item.view.root] = item
    return item.view.root
end

function this:TypeDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:TypeDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_type_info[realIndex + 1]
    self.btn_all_item[kmlcontrol]:RefreshItem(data, self)
end

function this:ZongSelectType(channel)
    self:CloseAllShow()
    self.allType = channel
    if self.btn_all_item then
        for k, v in pairs(self.btn_all_item) do
            v:SelectBG(v.channel == channel)
        end
    end

    local typeStr = SL:ChatInfo_GetChatTypeStr(self.allType)

    GUI:Text_setString(self.view.zonghe_text, typeStr)
end

function this:AddPos()
    -- @pos@135,130,1001,1@
    local x = SL:MeData_GetCoord().x
    local y = SL:MeData_GetCoord().z
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local line = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    local tab = SL:HasConfig("cfg_map_line", mapId)
    if not tab then
        line = 0
    end
    local posStr = string.format("pos@%s,%s,%s,%s@", x, y, mapId, line)
    self.message = posStr
    --self.message = self.message .. posStr
    --GUI:Text_setString(self.view.text_input, self.message)
    --GUI:setVisible(self.view.text_input_place, false)
    self:SendChat()
end

function this:EmojiDataListItemCountFunc()
    return #self.all_emoji_info
end

function this:EmojiDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatEmojiItem/KLUIChatEmojiItem", self.view.emoji_data_list, self,
        {}, true)

    self.btn_emoji_item[item.view.root] = item
    return item.view.root
end

function this:EmojiDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:EmojiDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_emoji_info[realIndex + 1]
    self.btn_emoji_item[kmlcontrol]:RefreshItem(data, self)
end

function this:AddEmoji(emoji_id)
    self:HideEmoji()
    -- emoji@61000:1@
    local emojiStr = string.format("emoji@%s:1@", emoji_id)
    self.message = self.message .. emojiStr
    GUI:Text_setString(self.view.text_input, self.message)
    GUI:setVisible(self.view.text_input_place, false)
end

function this:OnlickEmoji()
    self.emoji_is_show = not self.emoji_is_show
    GUI:setVisible(self.view.emoji_panel, self.emoji_is_show)
    if self.emoji_is_show then
        GUI:DataListUpdateData(self.view.emoji_data_list)
    end
end

function this:HideEmoji()
    self.emoji_is_show = false
    GUI:setVisible(self.view.emoji_panel, self.emoji_is_show)
end

function this:OnlickItem()
    self.item_is_show = not self.item_is_show
    GUI:setVisible(self.view.item_panel, self.item_is_show)
    if self.item_is_show then
        self:ShowItem()
    else
        GUI:UIPanel_Close("dev/ui/Chat/Item/KLUIChatBagScrollView/KLUIChatBagScrollViewItem")
    end
end

function this:HideItem()
    self.item_is_show = false
    GUI:setVisible(self.view.item_panel, self.item_is_show)
end

function this:forbidClick()
end

function this:ClickItemCallBack(itemControl, itemData)
    local cfgId = itemData.cfgId
    local id = itemData.id
    local datiankshi_show_type = itemData.datiankshi_show_type
    -- @item@0:0@
    local index = #self.ChatItem + 1
    local select = self.item_select_type
    if select == 3 then
        select = 2
    end
    if select == 2 then
        if not datiankshi_show_type or datiankshi_show_type == 0 then
            select = 1
        end
    end
    table.insert(self.ChatItem, { lid = id, type = select })
    local emojiStr = string.format("item@%s:%s@", index, select)
    self.message = self.message .. emojiStr
    GUI:Text_setString(self.view.text_input, self.message)
    GUI:setVisible(self.view.text_input_place, false)
    self:HideItem()
end

function this:ItemBtnSelect()
    self.item_select_type = 1
end

function this:ItemBtnShow()
    if self.item_select_type == 1 then
        GUI:setVisible(self.view.btn_bag_select, true)
        GUI:setVisible(self.view.btn_equip_select, false)
        GUI:setVisible(self.view.btn_datianshi_select, false)
    elseif self.item_select_type == 2 then
        GUI:setVisible(self.view.btn_bag_select, false)
        GUI:setVisible(self.view.btn_equip_select, true)
        GUI:setVisible(self.view.btn_datianshi_select, false)
    else
        GUI:setVisible(self.view.btn_bag_select, false)
        GUI:setVisible(self.view.btn_equip_select, false)
        GUI:setVisible(self.view.btn_datianshi_select, true)
    end
end

function this:ShowItem()
    GUI:UIPanel_Close("dev/ui/Chat/Item/KLUIChatBagScrollView/KLUIChatBagScrollViewItem")
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    self.maxHor = tonumber(bag_info[1])
    self.maxVet = tonumber(bag_info[2])
    local itemList_ = {}
    local show_id = EBagTileScrollViewId.Bag
    if self.item_select_type == 1 then
        local itemList = SL:GetMetaValue("BAG_DATA")[1]
        --SL:LogTable(itemList,true)
        for k, v in pairs(itemList) do
            local cfg_id = v.cfgId
            local tab = SL:GetConfig("cfg_item", cfg_id)
            if tab.type == 2 and tab.strPart and table.count(tab.strPart) > 0 and tab.strPart[1] >= 71 and tab.strPart[1] <= 78 then
            elseif tab.type == 9 then
            else
                v.datiankshi_show_type = nil
                itemList_[k] = v
            end
        end
    elseif self.item_select_type == 2 then
        -- local itemList_1 = SL:GetMetaValue("EQUIP_DATA")[1]
        local itemList_1 = SL:GetWearBarsData(EEquipWearBarType.BaseEquip)
        if itemList_1 then
            for _, item in pairs(itemList_1) do
                item.datiankshi_show_type = 1
                table.insert(itemList_, item)
            end
        end
        itemList_ = SL.Bag:SortItemList(itemList_) ---BagCellUtil.SortItemList(itemList_)
        show_id = EBagTileScrollViewId.Recover
    else
        local itemList_1 = SL:GetWearBarsData(EEquipWearBarType.Archange)
        if itemList_1 then
            for _, item in pairs(itemList_1) do
                item.datiankshi_show_type = 1
                table.insert(itemList_, item)
            end
        end
        local itemList = SL:GetMetaValue("BAG_DATA")[1]
        for k, v in pairs(itemList) do
            local cfg_id = v.cfgId
            local tab = SL:GetConfig("cfg_item", cfg_id)
            if tab.type == 2 and tab.strPart and table.count(tab.strPart) > 0 and tab.strPart[1] >= 71 and tab.strPart[1] <= 78 then
            elseif tab.type == 9 then
                v.datiankshi_show_type = nil
                table.insert(itemList_, v)
            else
            end
        end

        itemList_ = SL.Bag:SortItemList(itemList_) ---BagCellUtil.SortItemList(itemList_)
        show_id = EBagTileScrollViewId.Recover
    end


    GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatBagScrollView/KLUIChatBagScrollViewItem", self.view.item_panel, self,
        {
            itemList = itemList_,
            id = show_id,
            --forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT"),
            hor = self.maxHor,
            vet = self.maxVet,
            canDrag = false,
            forbidClickCallback = self.forbidClick,
            itemClick = self.ClickItemCallBack,
            callBackUI = self
        })
end

function this:btn_bag_onclick()
    self.item_select_type = 1
    self:ItemBtnShow()
    self:ShowItem()
end

function this:btn_equip_onclick()
    self.item_select_type = 2
    self:ItemBtnShow()
    self:ShowItem()
end

function this:btn_datianshi_onclick()
    self.item_select_type = 3
    self:ItemBtnShow()
    self:ShowItem()
end

function this:JoinUnion()
    local needLevel = SL:GetConfig("cfg_system_switch", 105, "id").needLevel
    local myLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if needLevel > myLevel then
        SL:TipMessage(SL:GetConfig('cfg_string', 449).text, 1, NoticeType.NoticeMid)
        return
    end
    SL:CloseChatUI()
    SL:OpenUnion()
end

function this:CreateTeam()
    SL:CloseChatUI()
    GUI:UIPanel_Open("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel", nil, nil, { panelType = 1 })
end

function this:JoinTeam()
    SL:CloseChatUI()
    GUI:UIPanel_Open("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel", nil, nil, { panelType = 2 })
end

function this:NameChangeEnd(a, b, eventData)
    if self.isClose then
        return
    end
    local messageStr = eventData[1]
    self.submitName = messageStr
    if string.isNullOrEmpty(self.submitName) then
        self.submitId = 0
        GUI:setVisible(self.view.private_input_place, true)
        return
    end
    GUI:setVisible(self.view.private_input_place, false)
    SL:ReqFindRidByNameMessage(self.submitName)
end

function this:NameChange(a, b, eventData)
    if self.isClose then
        return
    end
    if string.isNullOrEmpty(eventData[1]) then
        return
    end
    GUI:setVisible(self.view.private_input_place, false)
end

function this:ResNameMessage(id, message)
    if message and message.rid then
        self.submitId = message.rid
        self:AddChatName(self.submitId)
    else
        self.submitName = ""
        self.submitId = 0
        GUI:Text_setString(self.view.private_input, "")
        GUI:setVisible(self.view.private_input_place, true)
    end
    self.nextDoRevTime = Time.time + Time.deltaTime
end

function this:AddChatName(_rid)
    if self.submitName then
        if not SL.chatPrivatePlayerList then
            SL.chatPrivatePlayerList = {}
        end
        local id = SL:GetMetaValue(EMetaVarGetKey.USER_ID)
        if not SL.chatPrivatePlayerList[id] then
            SL.chatPrivatePlayerList[id] = {}
        end
        if not table.getValue(SL.chatPrivatePlayerList[id], _rid) then
            --LogError(SL.chatPrivatePlayerList[id])
            SL.chatPrivatePlayerList[id][_rid] = { rid = _rid, submitName = self.submitName }
        end
        self:saveData()
    end
end

function this:OpenPrivateSelect()
    if not SL.chatPrivatePlayerList then
        SL.chatPrivatePlayerList = {}
    end
    local id = SL:GetMetaValue(EMetaVarGetKey.USER_ID)
    if not SL.chatPrivatePlayerList[id] then
        SL.chatPrivatePlayerList[id] = {}
    end
    self.all_name = {}
    local all_id = {}
    for k, v in pairs(SL.chatPrivatePlayerList[id]) do
        table.insert(self.all_name, v)
        table.insert(all_id, v.rid)
    end
    -- GUI:setVisible(self.view.private_select_panel,true)
    -- GUI:DataListUpdateData(self.view.all_name_data_list)

    SL:SendLuaNetMsg(LuaMessageIdToSever.PLAYER_IS_ON_LINE_REQ, all_id)
end

function this:PlayerIsOnLine(id, message)
    for i = 1, #self.all_name, 1 do
        for k, v in pairs(message) do
            if self.all_name[i].rid == v.rid then
                self.all_name[i].onLine = v.onLine
            end
        end
    end
    GUI:setVisible(self.view.private_select_panel, true)
    GUI:DataListUpdateData(self.view.all_name_data_list)
end

function this:ClosePrivateSelect()
    GUI:setVisible(self.view.private_select_panel, false)
end

function this:NameDataListItemCountFunc()
    return #self.all_name
end

function this:NameDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/Chat/Item/KLUIChatSelectTypeItem/KLUIChatSelectTypeItem",
        self.view.all_name_data_list, self, {}, true)

    self.btn_name_item[item.view.root] = item
    return item.view.root
end

function this:NameDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:NameDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_name[realIndex + 1]
    self.btn_name_item[kmlcontrol]:RefreshItem(2, self, data)
end

function this:SelectName(data)
    self.submitName = data.submitName
    self.submitId = data.rid
    if self.btn_name_item then
        for k, v in pairs(self.btn_name_item) do
            v:SelectBG(v.nameData.rid == self.submitId)
        end
    end
    GUI:SetInputText(self.view.private_input, self.submitName)
    GUI:setVisible(self.view.private_input_place, false)
    self:ClosePrivateSelect()
    self.nextDoRevTime = Time.time + Time.deltaTime
end

return this

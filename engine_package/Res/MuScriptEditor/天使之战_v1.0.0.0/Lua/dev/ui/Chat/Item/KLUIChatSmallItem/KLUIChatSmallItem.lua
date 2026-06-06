---@class KLUIChatSmallItem:UIKmlLuaPanelBase
---@field view KLUIChatSmallItemView
local KLUIChatSmallItem = class(UIKmlLuaPanelBase)
local this = KLUIChatSmallItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshItem(data)
    self.message = data.message
    self.itemIndex = data.itemIndex
    local is_me = false
    if self.message.senderId == SL:GetMetaValue(EMetaVarGetKey.UID) then
        is_me = true
    end
    local is_union_system = false
    if self.message.channel == EChatChannelType.UNION and (not self.message.senderId or self.message.senderId == 0) then
        is_union_system = true
    end
    if not self.message.career then
        self.message.career = 0
    end
    if not self.message.sendName then
        self.message.sendName = ""
    end
    local channel = self.message.channel
    if channel == EChatChannelType.PERSONAL then
        local isFriend = false
        if is_me then
            isFriend = SL:CheckIsFriend(self.message.receiverId)
        else
            isFriend = SL:CheckIsFriend(self.message.senderId)
        end
        if isFriend then
            channel = EChatChannelType.FRIEND
        end
    end
    local typeStr = SL:ChatInfo_GetChatTypeStr(channel)
    if not typeStr or string.isNullOrEmpty(typeStr) then
        typeStr = self:GetChatTypeStr(channel)
    end

    local typeTitleStr = self:GetTypeTitle(typeStr, channel)

    local sendName
    if channel == EChatChannelType.SYSTEM then
        sendName = ""
    elseif is_union_system then
        sendName = ""
    else
        sendName = self.message.sendName
    end
    local server_name = ""
    if channel == EChatChannelType_Out.CORSS_SERVER then
        local sid = self.message.senderServerId
        if sid then
            local server = SL:GetServerInfoByRole(sid)
            if server then
                local s_name = server.name
                s_name = s_name .. "."
                server_name = s_name
            end
        end
    end
    local textColor
    if channel == EChatChannelType_Out.PERSONAL then
        textColor = SL:GetConfig('cfg_global', 370004).value --"#E170E8"
    elseif self.message.senderId and self.message.senderId > 0 then -- 玩家发言
        textColor = SL:GetConfig('cfg_global', 370003).value
    else
        textColor = SL:GetConfig('cfg_global', 370001).value
    end
    local str = typeTitleStr .. server_name .. sendName .. ":" .. self.message.message
    if self.message.itemList and table.count(self.message.itemList) > 0 then
        local chatiteminfo = ""
        for i = 1, table.count(self.message.itemList) do
            local v = self.message.itemList[i]
            if v == nil then
                v = self.message.itemList[tostring(i)]
            end
            local item = SL:GetConfig("cfg_item", v.cfgId)
            local name_color = "#d2d2d2"
            local name = ""
            if item.type == EItemType.Equip then
                name, name_color = EquipFunc.GetEquipNameAndColor(v)
            else
                local colorid = SL:GetConfig('cfg_item', v.cfgId).color
                name_color = SL:GetConfig('cfg_color', colorid).color
            end
            local oneStr = ""
            if i ~= 1 then
                oneStr = "|"
            end
            if v.id == nil then
                -- 打开的道具没有id，用配置id代替
                v.id = v.cfgId
            end
            oneStr = oneStr .. v.id .. "*" .. v.cfgId .. "*" .. textColor .. "*" .. item.name .. name
            chatiteminfo = chatiteminfo .. oneStr
            SL:ChatInfo_AddChaItemInfo(v)
        end
        self.message.chatiteminfo = chatiteminfo
    end
    GUI:RichText_setchatiteminfo(self.view.richSmall, self.message.chatiteminfo)
    if not str then
        str = ""
    end

    if not string.contains(str, "color") then
        str = str
    else
        str = GUIUtil.Extract_All_Brackets(str)
    end
    local cleanStr = string.gsub(str, "{ADDINFO:(.-)}", "")
    GUI:Text_setString(self.view.richSmall, cleanStr)

    GUI:Text_setTextColor(self.view.richSmall, textColor)
    --[[    if self.message and self.message.itemSizeSmall then
            GUI:setContentSize(self.view.samll_one_bg, 360,self.message.itemSizeSmall.y+10)
        end]]

    --[[    if self.message.itemList and #self.message.itemList >0 then
            local currStr = ""
            for i, v in ipairs(self.message.itemList) do
                local item = SL:GetConfig("cfg_item", v.cfgId)
                local name_color = "#d2d2d2"
                local name = ""
                if item.type == EItemType.Equip then
                    name, name_color = EquipFunc.GetEquipNameAndColor(v)
                else
                    local colorid = SL:GetConfig('cfg_item', v.cfgId).color
                    name_color = SL:GetConfig('cfg_color', colorid).color
                end
                SL:ChatInfo_AddChaItemInfo(v)
                local id = v.id
                local cfgid = v.cfgId
                local color = SL:GetConfig('cfg_global', 370001).value--name_color
                local Name = item.name..name--strengthLevel..appendLv..skill..xingyun
                currStr = currStr..string.format("[<color=%s><l=LinkType=10$%s#%s>%s</l></color>]", color, id, cfgid, Name);
            end
            GUI:Text_setString(self.view.richSmall,  GUIUtil.Extract_All_Brackets(typeTitleStr ..server_name .. sendName ..":" ..currStr))
        end]]
    SL:ScheduleOnce(0.05, function()
        self:SetBg()
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnClickEvent(self.view.button_id,self,self.BtnOnClick)
    GUI:AddOnClickEvent(self.view.root, self, self.OpenChatPanel)
end

function this:OpenChatPanel()
    SL:OpenChatUI()
end

function this:Close()
end

function this:GetTypeTitle(typeStr, channel)
    if channel == EChatChannelType.SYSTEM then
        return "<color=#4cc5feff>[" .. typeStr .. "]</color>"
    elseif channel == EChatChannelType.WORLD then
        return "<color=#B3C5E3>[" .. typeStr .. "]</color>"
    elseif channel == EChatChannelType.NEARBY then
        return "<color=#00ff00ff>[" .. typeStr .. "]</color>"
    elseif channel == EChatChannelType.UNION then
        return "<color=#ffc000ff>[" .. typeStr .. "]</color>"
    elseif channel == EChatChannelType.TEAM then
        return "<color=#d916d9ff>[" .. typeStr .. "]</color>"
    elseif channel == EChatChannelType.FRIEND then
        return "<color=#4cc5feff>[" .. typeStr .. "]</color>"
    elseif channel == EChatChannelType.PERSONAL then
        return "<color=#28e529ff>[" .. typeStr .. "]</color>"
    elseif channel == EChatChannelType.RECRUIT then
        return "<color=#ffffff>[" .. typeStr .. "]</color>"
    elseif channel == EChatChannelType_Out.CORSS_SERVER then
        return "<color=#4169E1>[" .. typeStr .. "]</color>"
    end
    return "[" .. typeStr .. "]"
end

function this:GetChatTypeStr(channel)
    if channel == EChatChannelType_Out.CORSS_SERVER then
        return EChatChannelTypeStr_Out.CORSS_SERVER
    end
    return ""
end

function this:SetBg()
    local richText = GUI:GetRectTransform(self.view.richSmall):GetComponent(typeof(CS.KingML.RichTextEx))
    ---List<Vector4>
    local info = CS.TextHelper.GetWidthLastLine(richText)
    local lineCount = table.count(info)
    local vertexes = string.empty
    for k, v in pairs(info) do
        local lineInfo = v
        local lineSpace = k < lineCount - 1 and 0 or 2
        local root = Vector2.New(0, -1 * lineInfo.y * k)
        local leftTop = root + Vector2.New(0, -1 * lineInfo.y + lineSpace)
        local rightTop = root + Vector2.New(lineInfo.x, -1 * lineInfo.y * 1 + lineSpace)
        local rightBottom = root + Vector2.New(lineInfo.x, 0)

        if string.isNullOrEmpty(vertexes) then
            vertexes = root.x .. "," .. root.y
        else
            vertexes = vertexes .. "#" .. root.x .. "," .. root.y
        end
        vertexes = vertexes .. "#" .. leftTop.x .. "," .. leftTop.y
        vertexes = vertexes .. "#" .. rightTop.x .. "," .. rightTop.y
        vertexes = vertexes .. "#" .. rightBottom.x .. "," .. rightBottom.y
    end

    GUI:setContentSize(self.view.bgRoot, 500, GUI:GetHeight(self.view.richSmall))
    GUI:SetActive(self.view.bgRoot, true)
    GUI:Image_SwitchDrawRect(self.view.bgRoot, true)
    GUI:Image_SetVertexes2DrawRect(self.view.bgRoot, vertexes)
end

return this

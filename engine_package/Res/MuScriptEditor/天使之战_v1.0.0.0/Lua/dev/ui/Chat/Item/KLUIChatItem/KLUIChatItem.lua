---@class KLUIChatItem:UIKmlLuaPanelBase
---@field view KLUIChatItemView
local KLUIChatItem = class(UIKmlLuaPanelBase)
local this = KLUIChatItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshItem(data)
    if not SL:MeData_Check() then
        return
    end
    self.message = data.message
    self.itemIndex = data.itemIndex
    local addInfo,cleanStr = self:GetAddInfo(self.message.message)
    --self.data.sendName
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
    local is_me = false
    if self.message.senderId == SL:GetMetaValue(EMetaVarGetKey.UID) then
        is_me = true
    end
    local career = self.message.career
    local careerStr
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
    local str = typeTitleStr
    if channel ~= EChatChannelType.SYSTEM and not is_union_system then
        local career = self.message.career
        careerStr = "1" .. career
        careerimgstr = "1" .. career .. career
        local server_name = ""
        --跨服消息要在玩家名字前面显示服务器名字
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
        str = typeTitleStr .. server_name .. self.message.sendName
    end
    if addInfo and addInfo.RED then
        local pk = cfg_pk_count_post.GetPkInfoByPkValue(addInfo.RED)
        local label = pk and pk.label
        local pkColor = SL:GetConfig("cfg_color",pk.displayColor).color
        label = string.format("<color=%s>%s</color>", pkColor, label)
        if self.message.senderId and self.message.senderId == SL:MeData_GetId() then
            str = label ..str
        else
            str = str..label
        end
    end

    if is_me and channel ~= EChatChannelType.SYSTEM then
        GUI:setAnchorPoint(self.view.icon_root, 2, 1)
        GUI:setAnchorPoint(self.view.name, 2, 1)
        GUI:setAnchorPoint(self.view.qipao, 2, 1)
        GUI:setPositionX(self.view.name, -75)
        GUI:setPositionX(self.view.qipao, -70)
        GUI:Image_loadTexture(self.view.qipao, "img_chat_pao2", "Atlas/KLChatPanel.spriteatlas")
        GUI:setAnchorPoint(self.view.richT, 2, 0)
        GUI:setPositionX(self.view.richT, -13)
    else
        GUI:setAnchorPoint(self.view.icon_root, 1, 1)
        GUI:setAnchorPoint(self.view.name, 1, 1)
        GUI:setAnchorPoint(self.view.qipao, 1, 1)
        GUI:setPositionX(self.view.name, 75)
        GUI:setPositionX(self.view.qipao, 70)
        GUI:Image_loadTexture(self.view.qipao, "img_chat_pao", "Atlas/KLChatPanel.spriteatlas")
        GUI:setAnchorPoint(self.view.richT, 1, 0)
        GUI:setPositionX(self.view.richT, 13)
    end
    GUI:Text_setString(self.view.name, str)
    if channel == EChatChannelType.SYSTEM or is_union_system then
        GUI:setVisible(self.view.icon_root, false)
        GUI:setPositionX(self.view.name, 10)
        GUI:setPositionX(self.view.qipao, 12)
    else
       -- GUI:Image_loadTexture(self.view.icon, careerStr, "Atlas/MUIcon.spriteatlas")
        GUI:Image_loadTexture(self.view.icon, careerimgstr, "Atlas/FG_AttrPanel.spriteatlas")
        GUI:setVisible(self.view.icon_root, true)
    end
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
            if v.id == nil then -- 打开的道具没有id，用配置id代替
                v.id = v.cfgId
            end
            oneStr = oneStr .. v.id .. "*" .. v.cfgId .. "*" .. name_color .. "*" .. item.name .. name
            chatiteminfo = chatiteminfo .. oneStr
            SL:ChatInfo_AddChaItemInfo(v)
        end
        self.message.chatiteminfo = chatiteminfo
    end
    -- SL:LogError(self.message.message)
    -- SL:LogTable(self.message.chatiteminfo)
    
    GUI:RichText_setchatiteminfo(self.view.richT, self.message.chatiteminfo)
    GUI:Text_setString(self.view.richT, cleanStr)
    local playerid = ""
    if self.message.senderId and self.message.senderId ~= 0 then
        playerid = tostring(self.message.senderId)
    end
    GUI:RichText_setchatplayerid(self.view.richT, playerid)

    --[[    if self.message.itemList and #self.message.itemList > 0 then
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
            local color = name_color
            local Name = item.name .. name--strengthLevel..appendLv..skill..xingyun
            currStr = currStr .. string.format("[<color=%s><l=LinkType=10$%s#%s>%s</l></color>]", color, id, cfgid, Name);
        end
        GUI:Text_setString(self.view.richT, currStr)
    end]]
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.icon, self, self.OnclickIcon)
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
        return "[" .. typeStr .. "]"
    elseif channel == EChatChannelType_Out.CORSS_SERVER then
        return "<color=#4169E1>[" .. typeStr .. "]</color>"
    end
    return "[" .. typeStr .. "]"
end

function this:GetAddInfo(message)
    if not message then
        message = self.message.message
    end
    if not message then
        return {}
    end
    local addInfo = {}
    local addInfoStr = string.match(message, "{ADDINFO:(.-)}")
    local cleanStr = string.gsub(message, "{ADDINFO:(.-)}", "")

    if addInfoStr then
        local addInfoArr = string.split(addInfoStr, "|")
        for k, v in pairs(addInfoArr) do
            local kv = string.split(v, "#")
            local value = tonumber(kv[2])
            if value then
                addInfo[kv[1]] = value
            else
                addInfo[kv[1]] = kv[2]
            end
        end
    end
    return addInfo,cleanStr
end

function this:OnclickIcon()
    local id = self.message.senderId
    if id == SL:GetMetaValue(EMetaVarGetKey.UID) then
        return
    end
    local _x, _y, _z = GUI:GetWorldPosition(self.view.icon_root)
    _x = math.floor(_x * 100) / 100
    _y = math.floor(_y * 100) / 100
    _z = math.floor(_z * 100) / 100
    if _y < 359.1 then
        _y = 359.1
    end
    local show_type = nil
    if self.message.channel == EChatChannelType_Out.CORSS_SERVER then
        show_type = 3
    end
    GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendOperate/KLFriendOperatePanel", _, _,
        { rid = id, pos = { x = _x + 4.9, y = _y - 2.3, z = _z }, name = self.message.sendName, isHideMainUI = true, uiType =
        show_type })
end

function this:GetChatTypeStr(channel)
    if channel == EChatChannelType_Out.CORSS_SERVER then
        return EChatChannelTypeStr_Out.CORSS_SERVER
    end
    return ""
end

function this:Close()
end

return this

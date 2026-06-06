---@class NewVipInfo
---@field isHideVIPHeadShow boolean
NewVipInfo = class()
local this = NewVipInfo

this.vipLevel = 0
this.vipBoughtGifts = {}
this.allVIPRedPoint = {}
this.AllPlayerVip = {}


function this:Init()
    self:RegistMessages()
    self:Reset()
    self.isHideVIPHeadShow = true
end

function this:Reset()
end

function this:RegistMessages()
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_LOGIN, self.EnterGame, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_ACTION, self.RES_RECHARGE_ACTION, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PLAYER_ENTER_VIEW_INFO, self.RES_PLAYER_ENTER_VIEW_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_CREATE_PLAYER_SUCCESS, self.LUA_EVENT_CREATE_PLAYER_SUCCESS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ROLE_SETTINGS, self.RES_ROLE_SETTINGS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TARGET_VIP_LV, self.RES_TARGET_VIP_LV, self)
end

function this:SetRoleVIPHeadShowSetting(message)
    if message and message.type == ERoleSettingType_Out.VIPHeadShow then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UPDATE_ROLE_SETTING, message)
    end
end

function this:RES_ROLE_SETTINGS(_, message)
    if message then
        local isCheck = false
        for i, v in pairs(message) do
            if tonumber(i) == ERoleSettingType_Out.VIPHeadShow then
                isCheck = true
                self.isHideVIPHeadShow = v
                break
            end
        end
        if not isCheck then
            self.isHideVIPHeadShow = false
        end
        self:SetSettingIsShowVIPHead(self.isHideVIPHeadShow)
    end
end

function this:SetSettingIsShowVIPHead(isHide)
    local userid = SL:GetMetaValue("USER_ID")
    if not userid then
        return
    end
    local level_str = ""
    if not isHide and this.vipLevel > 0 then
        level_str = "v" .. tostring(this.vipLevel)
    end
    local data = {}
    local playerData = SL:GetMetaValue(EMetaVarGetKey.GET_PLAYER_DATA_LIST)
    self:SetPlayerHeadVipLevel(userid, level_str)
    if isHide then
        for k, v in pairs(playerData) do
            self:SetPlayerHeadVipLevel(k, "")
        end
        return
    end
    for k, v in pairs(playerData) do
        if tonumber(userid) ~= tonumber(k) and k ~= InfoManager.guardPetInfo.MM_ID then
            table.insert(data, k)
        end
    end
    if not table.isNullOrEmpty(data) then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TARGET_VIP_LV, data)
    end 
end

function this:RES_RECHARGE_ACTION(_, message)
    if message.type == "8" then
        this.vipLevel = message.data.lv or 0
        self:GetAllRedPoint()
        SL:onLUAEvent(LUA_EVENT_VIP_CHANGE)
        local userid = SL:GetMetaValue("USER_ID")
        if not userid then
            return
        end
        local level_str = ""
        if this.vipLevel > 0 then
            level_str = "v" .. tostring(this.vipLevel)
        end
        if self.isHideVIPHeadShow then
            return
        end
        self:SetPlayerHeadVipLevel(userid, level_str)
    end
end

function this:GetAllRedPoint()
    self.allVIPRedPoint = {}
    local allTable = SL:GetConfigTable("cfg_VIP");
    for key, value in pairs(allTable) do
        if value.grade <= self.vipLevel then
            local expackCfg = SL:GetConfig("cfg_VIP_Pack", value.expack)
            local count, totalCount = InfoManager.countInfo:GetLimitAndTotalCountByKey(expackCfg.Limitedid)
            self.allVIPRedPoint[value.grade] = count > 0
        end
    end
    SL:RefreshPanelALLRedStateKmlByCondition("checkVIPRedDot")
end

function this:EnterGame()
    -- SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FirstChargeGift_Info)
end

function this:LUA_EVENT_CREATE_PLAYER_SUCCESS(_id, message)
    local uid = tostring(message)
    local userid = SL:GetMetaValue("USER_ID")
    if uid == userid then
        local level_str = ""
        if this.vipLevel > 0 then
            level_str = "v" .. tostring(this.vipLevel)
        end
        if self.isHideVIPHeadShow then ---设置
            return
        end
        self:SetPlayerHeadVipLevel(uid, level_str)
    else
        if this.AllPlayerVip[uid] then
            self:SetPlayerHeadVipLevel(uid, this.AllPlayerVip[uid])
        end
    end
end

function this:RES_PLAYER_ENTER_VIEW_INFO(_id, message)
    if not message.vipLv then
        return
    end
    --SL:LogTable(message,true)
    local level_str = ""
    if message.vipLv > 0 then
        level_str = "v" .. tostring(message.vipLv)
    end
    local uid = tostring(message.rid)
    if self.isHideVIPHeadShow then ---设置
        return
    end
    self:SetPlayerHeadVipLevel(uid, level_str)
end

function this:RES_TARGET_VIP_LV(_, message)
    for k, v in pairs(message) do
        local level_str = ""
        if v > 0 then
            level_str = "v" .. tostring(v)
        end
        self:SetPlayerHeadVipLevel(k, level_str)
    end
end

function this:SetPlayerHeadVipLevel(id, level_str)
    local is_success = SL:SetHeadVipName(tonumber(id), "Font/Vip_Font", level_str, 0, 5, -7)
    if is_success then
        this.AllPlayerVip[id] = nil
    else
        this.AllPlayerVip[id] = level_str
    end
end

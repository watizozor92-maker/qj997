---@class EquipOrItemTipsInfo @注释
EquipOrItemTipsInfo = class()
local this = EquipOrItemTipsInfo

function this:ctor()

end

function this:Init()
    self:Reset()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_BIND_DATA_CHANGE,self.RES_EQUIP_BIND_DATA_CHANGE,self)
end

function this:Reset()
end

---响应装备bind数据变化
function this:RES_EQUIP_BIND_DATA_CHANGE(id,message)
    if message and message.itemId then
        local itemInfo = SL:GetPosItemInfo("bag",nil,tonumber(message.itemId))
        if itemInfo then
            itemInfo.bind = message.bindId
            return
        end
        itemInfo = SL:GetPosItemInfo("equip",nil,tonumber(message.itemId))
        if itemInfo then
            itemInfo.bind = message.bindId
            return
        end
    end
end

---是否可点击按钮（功能开启等级是否开放）
function this:IsCanOnClickButton(btnType,id)
    local systemID = id
    if btnType[1] == "4" then--强化
        systemID = 10401
    elseif btnType[1] == "5" then--上架
        systemID = 201
    elseif btnType[1] == "13" then--分解
        systemID = 10404
    elseif btnType[1] == "14" then--穿戴坐骑装备
        systemID = 106
    elseif btnType[1] == "15" then--萤石镶嵌
        systemID = 10403
    elseif btnType[1] == "99" then
        systemID = tonumber(btnType[3])
    end
    if not systemID then
        return true
    else
        if systemID == "" then
            return true
        end
        ---@type cfg_system_switch_column
        local systemCfg = SL:GetConfig("cfg_system_switch",systemID)
        local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION,systemCfg.systemName)
        if not isMeet then
            SL:TipMessage( SL:GetConfig('cfg_string',449).text,1, NoticeType.NoticeMid )--"等级不足", 
        end
        return isMeet
    end
end
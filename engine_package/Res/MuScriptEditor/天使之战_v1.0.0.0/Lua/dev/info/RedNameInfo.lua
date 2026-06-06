---@class RedNameInfo
RedNameInfo = class()
local this = RedNameInfo
local CharWith = 6 -- 每个字符的宽度
local OffsetX = 7.5 --X偏移
function this:ctor()

end
function this:Reset()
    SL:UnRegisterTrigger(LUA_TRIGGER_SET_ACTORNAMECOLOR)
end

function this:Init()
    self.redNameInfo={}
    self:RegistMessages()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.PK_VALUE_CHANGE,self.PK_VALUE_CHANGE,self)
    SL:RegisterTrigger(LUA_TRIGGER_SET_ACTORNAMECOLOR,self.LUA_TRIGGER_SET_ACTORNAMECOLOR,self)
    SL:RegisterLUAEvent(LUA_EVENT_CREATE_PLAYER_SUCCESS, self.LUA_EVENT_CREATE_PLAYER_SUCCESS, self)
    SL:SetReplaceEngineFunc(EReplaceEngineFunc.GetDropEquipExtraNameSuffix,function(item)
        return EquipFunc.GetEquipSuffix(item)
    end)
    
end

---创建玩家事件监听
function this:LUA_EVENT_CREATE_PLAYER_SUCCESS(_, id)
    local uid = tonumber(id)
    self:RefreshHead(uid)
end

function this:PK_VALUE_CHANGE(_,message)
    local role = SL:GetRoleById(message.rid.id)
    ---攻城战中不走红名机制
    if message.rid.id ~= SL:MeData_GetId() and role and SL:MeData_Check() and InfoManager.loranSiegeInfo:IsMap() then
        if not InfoManager.loranSiegeInfo:LUA_TRIGGER_CLICK_ROLE(message.rid.id) then
            SL:SetRedNameColorChange(role,SL:ConvertColorFromHexString("#ff0000"))
        else
            SL:SetRedNameColorChange(role,SL:ConvertColorFromHexString("#FFFFFF"))
        end
        return
    end
    self.redNameInfo[message.rid.id] = message.pkValue
    if role then
        local color = cfg_pk_count_post.GetPkValueRedNameColor(message.pkValue)
        if color then
            local nameChangeColor = cfg_pk_count_post.GetPkValueNameColor(message.pkValue)
            local data = cfg_pk_count_post.GetPkInfoByPkValue(message.pkValue)
            local label = data and data.label
            SL:SetRedNameColorChange(role,nameChangeColor)
            self:SetPkIcon(role,label,color,"SIMHEI",".TTF")
        else
            SL:SetActorNameColor(role)
            self:SetPkIcon(role,nil)
        end
    end
end

-- 设置PK图标
-- role: 角色对象
-- text: 图标文本
-- color: 颜色
-- fontName: 字体名称
-- extensionName: 扩展名
-- fontSize: 字体大小
function this:SetPkIcon(role,text, color, fontName,extensionName,fontSize)
    text = text and text or ""
    if role.Head and role.Head.lab_name then
        local lab_name = role.Head.lab_name
        local nameWidthHalf = lab_name:GetHalfWidth(lab_name.text)
        local redNameWidthHalf = self:GetRedNameWidthHalf(text)
        -- 计算红名标签的X坐标位置
        local redNameX = (nameWidthHalf + redNameWidthHalf) + OffsetX
        local name_pos = lab_name and lab_name.transform.localPosition or Vector3.zero
        lab_name:SetLocalPosition(-redNameWidthHalf, name_pos.y,name_pos.z)
        SL:SetPkIcon(role,text, color, fontName,extensionName,fontSize,redNameX,0,nil,true)
        InfoManager.roleOtherInfo:UpdateNameBg(role)
        return
    end
    SL:SetPkIcon(role,text, color, fontName,extensionName,fontSize,nil,0,nil,true)
end

function this:GetRedNameWidthHalf(text,id)
    if text then
        return (string.len(text)  * CharWith ) * 0.5
    end
    local pkValue = self.redNameInfo[id]
    if not pkValue then
        return 0
    end
    local data = cfg_pk_count_post.GetPkInfoByPkValue(pkValue)
    return (string.len(data.label) * CharWith ) * 0.5
end

function this:RefreshHead(id)
    local id = id or tonumber(SL:GetMetaValue("MAIN_ACTOR_ID"))
    local role = SL:GetRoleById(id)
    
    local pkValue = self.redNameInfo[id]
    if role and pkValue then
        local color = cfg_pk_count_post.GetPkValueRedNameColor(pkValue)
        if color then
            local nameChangeColor = cfg_pk_count_post.GetPkValueNameColor(pkValue)
            local data = cfg_pk_count_post.GetPkInfoByPkValue(pkValue)
            local label = data and data.label
            SL:SetRedNameColorChange(role,nameChangeColor)
            self:SetPkIcon(role,label,color,"SIMHEI",".TTF")
        else
            SL:SetActorNameColor(role)
            self:SetPkIcon(role,nil)
        end
    end
end


function this:IsRedName(id)
    local pkValue = self.redNameInfo[tonumber(id)]
    if pkValue == 0 or cfg_pk_count_post.GetInfoByRedNamePkValue(pkValue) then
        return true
    end
    return false
end

function this:GetPkValueById(id)
    return self.redNameInfo[tonumber(id)]
end

function this:IsLimitItemById(itemId)
    local pkValue =  self.redNameInfo[tonumber(SL:GetMetaValue("MAIN_ACTOR_ID"))]
    local data = cfg_pk_count_post.GetPkInfoByPkValue(pkValue) 
    local shopPurchase =  data and data.shopPurchase
    if not shopPurchase then
        return false
    end
    return table.contains(shopPurchase,itemId)
end

function this:IsLimitTransferById(id,mapInfoId,line)
    local pkValue = self.redNameInfo[tonumber(id)]
    local data = cfg_pk_count_post.GetPkInfoByPkValue(pkValue)
    local mapTransmission = data and data.mapTransmission
    if not mapTransmission or (mapTransmission == 0) then
        return nil
    end
    if mapTransmission == 1 then
        return SL:GetConfig('cfg_string', 262).text
    end
    if mapTransmission == 2 then
        local mapInfoId = mapInfoId or SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
        ---@type cfg_map_line_column
        local mapLine = SL:GetConfig("cfg_map_line", mapInfoId)
        local pkLine = ToolFunc.AnalysisStr(mapLine.pkline,nil,{"|"})
        if table.contains(mapLine.peaceline,line) then
            return SL:GetConfig('cfg_string', 58001).text,pkLine[1]
        end
    end
    return nil
end

function this:IsLimitAttack()
    local pkValue =  self.redNameInfo[tonumber(SL:GetMetaValue("MAIN_ACTOR_ID"))]
    local data = cfg_pk_count_post.GetPkInfoByPkValue(pkValue)
    if pkValue > tonumber(SL:GetConfig("cfg_global",680001).value) then
        return true
    end
    local pvpDamage =  data and data.tbl.pvpDamage
   
    return pvpDamage == 1
end

function this:IsLimitTrade()
    local pkValue =  self.redNameInfo[tonumber(SL:GetMetaValue("MAIN_ACTOR_ID"))]
    local data = cfg_pk_count_post.GetPkInfoByPkValue(pkValue)
    local tradeLimit =  data and data.tbl.tradeLimit
    if not tradeLimit or (tradeLimit == 0) then
        return false
    end
    return tradeLimit == 1
end

function this:GetMapTransmissionCost()
    local pkValue =  self.redNameInfo[tonumber(SL:GetMetaValue("MAIN_ACTOR_ID"))]
    local data = cfg_pk_count_post.GetPkInfoByPkValue(pkValue)
    local mapTransmissionCost =  data and data.tbl.mapTransmissionCost or 1
    if not mapTransmissionCost or (mapTransmissionCost == 0) then
        return false
    end
    return mapTransmissionCost
end


function this:LUA_TRIGGER_SET_ACTORNAMECOLOR(redNameChangeFunc,playerHead,rid)
    local role = SL:GetRoleById(rid)
    ---攻城战中不走红名机制
    if rid ~= SL:MeData_GetId() and role and SL:MeData_Check() and InfoManager.loranSiegeInfo:IsMap() then
        if not InfoManager.loranSiegeInfo:LUA_TRIGGER_CLICK_ROLE(rid) then
            SL:SetRedNameColorChange(role,SL:ConvertColorFromHexString("#ff0000"))
        else
            SL:SetRedNameColorChange(role,SL:ConvertColorFromHexString("#FFFFFF"))
        end
        return true
    end
    local pkValue = self.redNameInfo[tonumber(rid)]
    if role and pkValue then
        local color = cfg_pk_count_post.GetPkValueRedNameColor(pkValue)
        if color then
            local nameChangeColor = cfg_pk_count_post.GetPkValueNameColor(pkValue)
            local data = cfg_pk_count_post.GetPkInfoByPkValue(pkValue)
            local label = data and data.label
            redNameChangeFunc(playerHead,nameChangeColor)
            self:SetPkIcon(role,label,color,"SIMHEI",".TTF")
            return true
        else
            self:SetPkIcon(role,nil)
            return false
        end
        return false
    end
    return false
end


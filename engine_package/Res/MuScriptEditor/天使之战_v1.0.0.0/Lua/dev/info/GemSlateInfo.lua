---@class GemSlateInfo
GemSlateInfo = class()
local this = GemSlateInfo


function this:ctor()

end

function this:Reset()
    self:ResetData()
end

function this:Init()
    self:ResetData()
    self:InitData()
    self:RegistMessages()
end

---重置数据
function this:ResetData()
    self.curActiveScheme="1"
    self.OtherPlayerCurActiveScheme="1"
    self.curGemPosId="1"
    self.curEquipPosId="1"
    self.curOptEquip=nil
    self.AllSchemeData=nil
    self.OtherPlayerAllSchemeData=nil

    self.Group2AllLevel={}
    self.ActiveGemSuitCfgTbl={}
    self.AllGemSuitCfgTbl={}

    self.maxLevelActiveGroupSuitCfgLst={}
    
    local canInlayGemEquipPosTbl = SL:GetConfig("cfg_global", 12001)
    self.CanInlayGemEquipPosTbl = string.split(canInlayGemEquipPosTbl.value, "#")
    local canInlaySlateEquipPosTbl = SL:GetConfig("cfg_global", 12002)
    self.CanInlaySlateEquipPosTbl = string.split(canInlaySlateEquipPosTbl.value, "#")
end

function this:InitData()
end
function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GEM_SCHEME,self.DealWithAllSchemeInfoMsg,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GEM_CURRENT_SCHEME,self.DealWithCurSchemeInfoMsg,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GEM_RECOVERY_HP_INFO,self.RES_GEM_RECOVERY_HP_INFO,self)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_MAP, self.LUA_EVENT_LOGIN_MAP, self)  --登录进入地图 刷新萤石
end


function this:RES_GEM_RECOVERY_HP_INFO(_,message)
    if not message then
        return
    end
    SL:PlayHurt(message["text"],message["hurtType"],message["targetId"])
end

function this:DealWithAllSchemeInfoMsg(_,message)
    if not message then
        return
    end
    if message == "" then
        return
    end
    if not message.data then
        return
    end
    self.OtherPlayerAllSchemeData = nil
    --是否是其他玩家
    local my_rid = SL:GetMetaValue(EMetaVarGetKey.USER_ID)
    --local isOtherPlayer = message.rid and SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_NETPLAYER,message.rid)
    --if isOtherPlayer then
    local rid = nil 
    if message.rid then
        rid = tostring(message.rid)
    end
    if rid and my_rid ~= rid then
        self.OtherPlayerAllSchemeData = message.data
        self.OtherPlayerCurActiveScheme = tostring(message.cur)
        SL:onLUAEvent(LUA_EVENT_REFRESH_GEM_SLATE_INFO,message.rid)
        return
    end
    self.curActiveScheme=tostring(message.cur)
    self.AllSchemeData=message.data

    self:UpdateAllGemsSuitAttrInfo()
    SL:onLUAEvent(LUA_EVENT_REFRESH_GEM_SLATE_INFO,my_rid)
end

function this:DealWithCurSchemeInfoMsg(_,message)
    if not message then
        return
    end
    if message == "" then
        return
    end
    if not self.AllSchemeData then
        return
    end
    self.curActiveScheme=tostring(message.pos)
    self.AllSchemeData[tostring(message.pos)]=message

    self:UpdateAllGemsSuitAttrInfo()
    SL:onLUAEvent(LUA_EVENT_REFRESH_GEM_SLATE_INFO)
end


function this:ReqInlayGem(gemCfgId,gemId)
    local bagIndex=SL:GetBagIndex(gemId)
    if not self.curOptEquip or not gemId or not bagIndex then
        SL:TipMessage( SL:GetConfig("cfg_string",329).text ,3, NoticeType.NoticeLeftBottom )
        -- logError("当期操作的装备数据为空")
        return
    end
    
    local wearBarId, pos = SL:GetEquipWearBarIdPos(self.curOptEquip.id)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GEM_PUT_ON,{schemepos=self.curActiveScheme,idxOfBag=bagIndex,idxOfEquip=self:GetIdxOfEquip(pos, self.curGemPosId)})
end


function this:ReqUnloadGem()
    
    if not self.curOptEquip then
        SL:TipMessage( SL:GetConfig("cfg_string",329).text ,3, NoticeType.NoticeLeftBottom )
        -- logError("当期操作的装备数据为空")
        return
    end
    local wearBarId, pos = SL:GetEquipWearBarIdPos(self.curOptEquip.id)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GEM_TAKE_OFF,{schemepos=self.curActiveScheme,idxOfEquip=self:GetIdxOfEquip(pos, self.curGemPosId)})
end


function this:ChangeGemPosId(gemPosId)
    self.curGemPosId=gemPosId
end

function this:ChangeEquipPosId(equipPosId)
    self.curEquipPosId=tostring(equipPosId)
end

function this:GetIdxOfEquip(pos,gemWearCellId)
    if not gemWearCellId then
        return pos
    end
    return gemWearCellId << 16 | pos
end

function this:SetOptEquip(equip)
    self.curOptEquip=equip
end


function this:GetCurActiveSchemeGem(gemPos,isSlate)
    if not self.curEquipPosId then
        return
    end
    if not self.AllSchemeData then
        return
    end
    if not self.AllSchemeData[self.curActiveScheme] then
        return
    end

    if not self.AllSchemeData[self.curActiveScheme].scheme[self.curEquipPosId] then
        return
    end
    if not isSlate then
        if not self.AllSchemeData[self.curActiveScheme].scheme[self.curEquipPosId].gems or not self.AllSchemeData[self.curActiveScheme].scheme[self.curEquipPosId].gems[gemPos] then
            return
        end
    
        return self.AllSchemeData[self.curActiveScheme].scheme[self.curEquipPosId].gems[gemPos]
    else
        if not self.AllSchemeData[self.curActiveScheme].scheme[self.curEquipPosId].stone then
            return
        end
    
        return self.AllSchemeData[self.curActiveScheme].scheme[self.curEquipPosId].stone
    end
end

function this:GetCurActiveSchemeGemState()
    if not self.curEquipPosId then
        return
    end
    
    if not self.AllSchemeData then
        return
    end
    if not self.AllSchemeData[self.curActiveScheme] then
        return
    end

    if not self.AllSchemeData[self.curActiveScheme].scheme[self.curEquipPosId] then
        return
    end

    return self.AllSchemeData[self.curActiveScheme].scheme[self.curEquipPosId].active
end

function this:GetCurActiveSchemeGemByEquipPos(gemPos,equipPos,isSlate)
    if not self.AllSchemeData then
        return
    end
    if not self.AllSchemeData[self.curActiveScheme] then
        return
    end

    if not self.AllSchemeData[self.curActiveScheme].scheme[equipPos] then
        return
    end
    if not isSlate then
        if not self.AllSchemeData[self.curActiveScheme].scheme[equipPos].gems or not self.AllSchemeData[self.curActiveScheme].scheme[equipPos].gems[gemPos] then
            return
        end
    
        return self.AllSchemeData[self.curActiveScheme].scheme[equipPos].gems[gemPos]
    else
        if not self.AllSchemeData[self.curActiveScheme].scheme[equipPos].stone then
            return
        end
    
        return self.AllSchemeData[self.curActiveScheme].scheme[equipPos].stone
    end
end

function this:GetOtherPlayerCurActiveSchemeGemByEquipPos(gemPos,equipPos,isSlate)
    if not self.OtherPlayerAllSchemeData then
        return
    end
    if not self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme] then
        return
    end

    if not self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme].scheme[equipPos] then
        return
    end
    if not isSlate then
        if not self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme].scheme[equipPos].gems or not self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme].scheme[equipPos].gems[gemPos] then
            return
        end
    
        return self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme].scheme[equipPos].gems[gemPos]
    else
        if not self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme].scheme[equipPos].stone then
            return
        end
    
        return self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme].scheme[equipPos].stone
    end
end


function this:UpdateAllGemsSuitAttrInfo()


    self.Group2AllLevel={}
    self.AllGemSuitCfgTbl={}
    self.ActiveGemSuitCfgTbl={}
    if not self.AllSchemeData then
        return
    end
    for _, singleEquipPosData in pairs(self.AllSchemeData[self.curActiveScheme].scheme) do
        if singleEquipPosData.active and singleEquipPosData.gems then
            for k, gemId in pairs(singleEquipPosData.gems) do
                ---@type cfg_equip_gem_column
                local gemCfg=SL:GetConfig("cfg_equip_gem",gemId)
                if not self.Group2AllLevel[gemCfg.gemBelong[1]] then
                    self.Group2AllLevel[gemCfg.gemBelong[1]]=0
                end
                if gemCfg then
                    self.Group2AllLevel[gemCfg.gemBelong[1]]=self.Group2AllLevel[gemCfg.gemBelong[1]]+gemCfg.gemBelong[2]
                end
            end
        end
    end

    local cfgTbl= SL:GetConfigTable("cfg_equip_gemSuit")
    for k, v in pairs(cfgTbl) do
        v.sortId=v.id
        if self.Group2AllLevel[v.gemCondition[1]] and self.Group2AllLevel[v.gemCondition[1]]>=v.gemCondition[2] then
            v.sortId=v.sortId-100000
        end
        table.insert(self.AllGemSuitCfgTbl,v)
    end

    --组别写死1-4 策划说不扩了
    self.maxLevelActiveGroupSuitCfgLst={}
    for k, v in pairs(self.AllGemSuitCfgTbl) do
        if v.sortId<0 then
            if v.gemCondition[1]==1 then
                if not self.maxLevelActiveGroupSuitCfgLst[1] then
                    self.maxLevelActiveGroupSuitCfgLst[1]=v
                end
                if self.maxLevelActiveGroupSuitCfgLst[1].gemCondition[2]<v.gemCondition[2] then
                    self.maxLevelActiveGroupSuitCfgLst[1]=v
                end
            elseif v.gemCondition[1]==2 then
                if not self.maxLevelActiveGroupSuitCfgLst[2] then
                    self.maxLevelActiveGroupSuitCfgLst[2]=v
                end
                if self.maxLevelActiveGroupSuitCfgLst[2].gemCondition[2]<v.gemCondition[2] then
                    self.maxLevelActiveGroupSuitCfgLst[2]=v
                end
            elseif v.gemCondition[1]==3 then
                if not self.maxLevelActiveGroupSuitCfgLst[3] then
                    self.maxLevelActiveGroupSuitCfgLst[3]=v
                end
                if self.maxLevelActiveGroupSuitCfgLst[3].gemCondition[2]<v.gemCondition[2] then
                    self.maxLevelActiveGroupSuitCfgLst[3]=v
                end
            elseif v.gemCondition[1]==4 then
                if not self.maxLevelActiveGroupSuitCfgLst[4] then
                    self.maxLevelActiveGroupSuitCfgLst[4]=v
                end
                if self.maxLevelActiveGroupSuitCfgLst[4].gemCondition[2]<v.gemCondition[2] then
                    self.maxLevelActiveGroupSuitCfgLst[4]=v
                end
            end
        else
            table.insert(self.ActiveGemSuitCfgTbl,v)
        end
    end

    for k, v in pairs(self.maxLevelActiveGroupSuitCfgLst) do
        table.insert(self.ActiveGemSuitCfgTbl,v)
    end

    
    table.sort(self.ActiveGemSuitCfgTbl,function (a,b)
        return a.sortId<b.sortId
    end)

    table.sort(self.AllGemSuitCfgTbl,function (a,b)
        return a.sortId<b.sortId
    end)
end

-- {"cur":1,
--     "data":
--     {"1":
--         {"scheme":
--             {"2":
--                 {"gems":
--                     {"1":50031312},
--                  "active":true
--                 }
--             },
--         "pos":1,
--         "active":true
--         },
--     "2":
--         {"scheme":{},
--         "pos":2,
--         "active":false
--         }
--     }
-- }

function this:LUA_EVENT_LOGIN_MAP()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SCHEME_INFO)
end

function this:GetTargetEquipGem(pos)
    if self.AllSchemeData and self.AllSchemeData[self.curActiveScheme] and self.AllSchemeData[self.curActiveScheme].scheme then
        return self.AllSchemeData[self.curActiveScheme].scheme[tostring(pos)]
    end
end


function this:GetOtherPlayerTargetEquipGem(pos)
    if self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme] and self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme].scheme then
        return self.OtherPlayerAllSchemeData[self.OtherPlayerCurActiveScheme].scheme[tostring(pos)]
    end
    return
end
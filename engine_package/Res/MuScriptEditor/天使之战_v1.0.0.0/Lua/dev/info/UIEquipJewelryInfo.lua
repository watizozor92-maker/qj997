---@class UIEquipJewelryInfo
UIEquipJewelryInfo = class()
local this = UIEquipJewelryInfo

function this:ctor()
end

function this:Reset()
    --[[    if self.coHide1 ~= nil then
            Coroutine.Stop(self.coHide1)
        end
        if self.coHide2 ~= nil then
            Coroutine.Stop(self.coHide2)
        end]]
end

function this:Init()
    self:InitData()
    self:RegistMessages()

    self.OutEquipData = {}
    self.OrnamentsGroupList = {}
    local ornamentsTbl = SL:GetConfigTable('cfg_equip_ornaments')
    for _, v in pairs(ornamentsTbl) do
        if not self.OrnamentsGroupList[v.ornamentsGroup] then
            self.OrnamentsGroupList[v.ornamentsGroup] = {}
        end
        table.insert(self.OrnamentsGroupList[v.ornamentsGroup], v)
    end

end

function this:InitData()

end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UPDATE_EQUIP_ORNAMENTS, self.RES_UPDATE_EQUIP_ORNAMENTS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ACT_EQUIP_ORNAMENTS, self.RES_ACT_EQUIP_ORNAMENTS, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
end
function this:LUA_EVENT_BAG_CHANGE_AFTER(_, itemList)
    if itemList then
        SL:RefreshPanelALLRedPoint("KLEquipJewelryActivePanel")
        SL:RefreshPanelALLRedPoint("KLEquipJewelryPanel")
    end
end
---@param message RES_UPDATE_EQUIP_ORNAMENTS
function this:RES_ACT_EQUIP_ORNAMENTS(_, message)
    if message then
        SL:RefreshPanelALLRedPoint("KLEquipJewelryActivePanel")
    end
end
---@param message RES_UPDATE_EQUIP_ORNAMENTS
function this:RES_UPDATE_EQUIP_ORNAMENTS(_, message)
    if message then
        SL:RefreshPanelALLRedPoint("KLEquipJewelryPanel")
    end
end
function this:IsShowLevelRedDot()
    local equipAll = SL:GetMetaValue(EMetaVarGetKey.EQUIP_DATA)
    if not equipAll or not next(equipAll) or not equipAll[1] or not next(equipAll[1]) then
        return false
    end
    for i, v in pairs(equipAll[1]) do
        for _, j in pairs(E_JewelryEquipType) do
            if i == j then
                ---@type RES_UPDATE_EQUIP_ORNAMENTS
                self.OutEquipData = SL:JsonDecode(v.luaExtData,false)
                local preLevel = 0
                if self.OutEquipData ~= nil and self.OutEquipData.ssuplv then
                    preLevel = self.OutEquipData.ssuplv  --当前首饰等级
                end
                local PreOrnament_Tbl, NextOrnament_Tbl = self:GetJewelryTblInfoByLevel(v.cfgId, preLevel)
                if NextOrnament_Tbl then
                    --没升满  判断材料是否足够
                    if next(PreOrnament_Tbl.lvDeplete) then
                        for _, attrValue in pairs(PreOrnament_Tbl.lvDeplete) do
                            local haveCount = SL:GetBagItemCount(tonumber(attrValue[1]))
                            local needCount = tonumber(attrValue[2])
                            if haveCount >= needCount then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

---首饰是否可升级
function this:IsJewelryCanUpLevel(v)
    if not v then
        return false
    end
    ---@type RES_UPDATE_EQUIP_ORNAMENTS
    local outEquipData = SL:JsonDecode(v.luaExtData,false)
    local preLevel = 0
    if outEquipData and outEquipData.ssuplv then
        preLevel = outEquipData.ssuplv  --当前首饰等级
    end
    local PreOrnament_Tbl, NextOrnament_Tbl = self:GetJewelryTblInfoByLevel(v.cfgId, preLevel)
    if NextOrnament_Tbl then
        --没升满  判断材料是否足够
        if next(PreOrnament_Tbl.lvDeplete) then
            for _, attrValue in pairs(PreOrnament_Tbl.lvDeplete) do
                local haveCount = SL:GetBagItemCount(tonumber(attrValue[1]))
                local needCount = tonumber(attrValue[2])
                if haveCount >= needCount then
                    return true
                end
            end
        end
    end
    return false
end

---首饰是否可激活
function this:IsJewelryCanActive(v)
    if not v then
        return false
    end
    ---@type RES_UPDATE_EQUIP_ORNAMENTS
    local outEquipData = SL:JsonDecode(v.luaExtData,false)
    local OrnamentsGroup = self:GetOrnamentsGroup(v.cfgId)
    local maxActiveLv = 0 ---激活最大等级
    local preLevel = 0
    if outEquipData and outEquipData.ssuplv then
        preLevel = outEquipData.ssuplv  --当前首饰等级
    end
    if outEquipData ~= nil and outEquipData.ssactlv then
        for _, actlv in pairs(outEquipData.ssactlv) do
            if maxActiveLv < actlv then
                --已激活的
                maxActiveLv = actlv
            end
        end
    end
    ---@type cfg_equip_ornaments_column
    local NextActiveTbl = nil ---下一个激活信息
    if OrnamentsGroup then
        for i, Group in pairs(OrnamentsGroup) do
            if next(Group.excellenceAtt) then
                if Group.lv > maxActiveLv then
                    NextActiveTbl = Group
                    break
                end
            end
        end
    end
    
    if not NextActiveTbl then
        return false
    else
        if next(NextActiveTbl.unlockDeplete) and preLevel >= NextActiveTbl.lv then
            for _, unlockDeplete in pairs(NextActiveTbl.unlockDeplete) do
                local haveCount = SL:GetBagItemCount(tonumber(unlockDeplete[1]))
                local needCount = tonumber(unlockDeplete[2])
                if haveCount >= needCount then
                    return true
                else
                    return false
                end
            end
        end
    end
    return false
end

function this:IsShowActiveRedDot()
    local equipAll = SL:GetMetaValue(EMetaVarGetKey.EQUIP_DATA)
    if not equipAll or not next(equipAll) or not equipAll[1] or not next(equipAll[1]) then
        return false
    end
    for i, type in pairs(E_JewelryEquipType) do
        if equipAll[1][type] then
            local v = equipAll[1][type]
            ---@type RES_UPDATE_EQUIP_ORNAMENTS
            self.OutEquipData = SL:JsonDecode(v.luaExtData,false)
            local OrnamentsGroup = self:GetOrnamentsGroup(v.cfgId)
            local maxActiveLv = 0 ---激活最大等级
            local preLevel = 0
            if self.OutEquipData and self.OutEquipData.ssuplv then
                preLevel = self.OutEquipData.ssuplv  --当前首饰等级
            end
            if self.OutEquipData ~= nil and self.OutEquipData.ssactlv then
                for _, actlv in pairs(self.OutEquipData.ssactlv) do
                    if maxActiveLv < actlv then
                        --已激活的
                        maxActiveLv = actlv
                    end
                end
            end
            ---@type cfg_equip_ornaments_column
            local NextActiveTbl = nil ---下一个激活信息
            if OrnamentsGroup then
                for z, Group in pairs(OrnamentsGroup) do
                    if next(Group.excellenceAtt) then
                        if Group.lv > maxActiveLv then
                            NextActiveTbl = Group
                            break
                        end
                    end
                end
            end

            if NextActiveTbl and next(NextActiveTbl.unlockDeplete) and preLevel >= NextActiveTbl.lv then
                for _, unlockDeplete in pairs(NextActiveTbl.unlockDeplete) do
                    local haveCount = SL:GetBagItemCount(tonumber(unlockDeplete[1]))
                    local needCount = tonumber(unlockDeplete[2])
                    if haveCount >= needCount then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function this:GetOrnamentsGroup(cfgId)
    if not SL:HasConfig('cfg_equip_ornamentsMain', cfgId) then
        return
    end
    ---@type cfg_equip_ornamentsMain_column
    local ornament_tbl = SL:GetConfig('cfg_equip_ornamentsMain', cfgId)
    if ornament_tbl.ornamentsGroup and self.OrnamentsGroupList[ornament_tbl.ornamentsGroup] then
        return self.OrnamentsGroupList[ornament_tbl.ornamentsGroup]
    end
    return nil
end
---@return cfg_equip_ornaments_column
function this:GetJewelryTblInfoByLevel(cfgId, Level)
    local PreOrnament_Tbl = nil
    local NextOrnament_Tbl = nil
    if SL:HasConfig('cfg_equip_ornamentsMain', cfgId) then
        ---@type cfg_equip_ornamentsMain_column
        local ornament_tbl = SL:GetConfig('cfg_equip_ornamentsMain', cfgId)
        if ornament_tbl.ornamentsGroup and self.OrnamentsGroupList[ornament_tbl.ornamentsGroup] then
            for _, v in pairs(self.OrnamentsGroupList[ornament_tbl.ornamentsGroup]) do
                if v.lv == Level then
                    PreOrnament_Tbl = v
                end
                if v.lv == Level + 1 then
                    NextOrnament_Tbl = v
                end
            end
        end
    end
    
    return PreOrnament_Tbl, NextOrnament_Tbl
end
---获得当前首饰等级最大可强化等级
function this:GetCurLevelMaxStrength(equipInfo)
    local cfgId = equipInfo.cfgId
    if not next(equipInfo) then
        return false
    end
    local Level = 0
    self.OutEquipData = SL:JsonDecode(equipInfo.luaExtData,false)
    if self.OutEquipData ~= nil and self.OutEquipData.ssuplv then
        Level = tonumber(self.OutEquipData.ssuplv)  --当前首饰等级
    end
    local PreOrnament_Tbl,NextOrnament_Tbl = self:GetJewelryTblInfoByLevel(cfgId,Level)
    if PreOrnament_Tbl then
            return PreOrnament_Tbl.strengthenmaxLevel
    end
    return Level
end

---获得当前首饰等级最大可追加等级
function this:GetCurLevelMaxAppend(equipInfo)
    local cfgId = equipInfo.cfgId
    if not next(equipInfo) then
        return false
    end
    local Level = 0
    self.OutEquipData = SL:JsonDecode(equipInfo.luaExtData,false)
    if self.OutEquipData ~= nil and self.OutEquipData.ssuplv then
        Level = tonumber(self.OutEquipData.ssuplv)  --当前首饰等级
    end
    local PreOrnament_Tbl,NextOrnament_Tbl = self:GetJewelryTblInfoByLevel(cfgId,Level)
    if PreOrnament_Tbl then
        return PreOrnament_Tbl.appendsmaxLevel
    end
    return Level
end
ESpecialAttrID=
{
    minAtk=200011,
    maxAtk=200021
}
function this:IsSpecialAttrId(attrId)
    for _,v in pairs(ESpecialAttrID) do
        if v == attrId then
            return true
        end
    end
    return false
end
function this:GetAttrJewelSpecialTbl(minAttrId, MaxAttrId, PreOrnament_Tbl, NextOrnament_Tbl,name)
    local tbl=nil
    if NextOrnament_Tbl then
        tbl=self:GetAttrSpecial(minAttrId,MaxAttrId,PreOrnament_Tbl.basicAtt, NextOrnament_Tbl.basicAtt,name)
    else
        tbl=self:GetAttrSpecial(minAttrId,MaxAttrId,PreOrnament_Tbl.basicAtt, nil,name)
    end
    return tbl
end
function this:GetAttrSpecial(minAttrId, MaxAttrId, preAttrList, nextAttrList,name)
    local pre_attr_map = {}
    local next_attr_map = {}
    local arrowShow = false
    for _, nowAttr in pairs(preAttrList) do
        pre_attr_map[nowAttr[1]] = nowAttr[2]
    end
    if nextAttrList then
        for _, nowAttr in pairs(nextAttrList) do
            next_attr_map[nowAttr[1]] = nowAttr[2]
        end
        arrowShow = true
    else
        arrowShow = false
    end

    local tbl = nil
    local minAtk = pre_attr_map[minAttrId]
    local maxAtk = pre_attr_map[MaxAttrId]
    local nextValue = ""
    local name = name
    if arrowShow then
        local minAtkNext = next_attr_map[minAttrId]
        local maxAtkNext = next_attr_map[MaxAttrId]
        if minAtkNext and maxAtkNext then
            nextValue = minAtkNext .. '~' .. maxAtkNext
        end

    end
    if minAtk and maxAtk and nextValue then
        tbl = {
            attrName = name,
            preValue = minAtk .. '~' .. maxAtk,
            nextValue = nextValue,
            arrowShow = arrowShow
        }
    end
    return tbl
end
---@class MountInfo
---@field isHasOwnerMount boolean
---@field totalMounts Net_MountInfo[]
---@field bagItems table<number, Net_MountEquipItem> @<索引， item>
MountInfo = class()
local this = MountInfo

---@class Net_MountInfo
---@field skins number[]    @坐骑已解锁皮肤集合
---@field curSkin number    @坐骑当前使用皮肤
---@field mountId number    @坐骑id
---@field level number      @坐骑等级
---@field equips table<number, Net_MountEquipItem>      @坐骑装备

---@class EOut_BagType
EOut_BagType = {
    MountBag = 1,
    ElementBag = 3,
}

function this:ctor()

end

function this:Reset()
    self.firstMountIdList = {}
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.totalMounts = {}
    self.ride_mount_id = 0
    self.default_mount_id = 0
    self.fightTime = nil
    self.exit_fight_time = 20
    local num = SL:GetConfig("cfg_global",790001).value
    self.exit_fight_time = tonumber(num)
    
    local mountTbls = SL:GetConfigTable("cfg_mount")
    ---@param v cfg_mount_column
    for _, v in pairs(mountTbls) do
        self.effectId = v.ridingEffect
        break
    end
    
    self.mountSkins = {}
    --不知道啥配置，先复制写死
    self.subTypeToPos = {}
    local split = string.split("51#101|52#102|53#103|54#104", "|")
    for _, v in pairs(split) do
        local split1 = string.split(v, "#")
        self.subTypeToPos[tonumber(split1[1])] = tonumber(split1[2])
    end
    self.MountIdEquipList = {}
end

function this:RegistMessages()
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_CURRENT_RIDE_MOUNT,self.RES_CURRENT_RIDE_MOUNT,self)
    SL:RegisterLUAEvent(LUA_EVENT_MOUNT_ISON,self.LUA_EVENT_MOUNT_ISON,self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE,self.OnPlayerMapPosChange,self)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MOUNT_LOGO,self.RES_MOUNT_LOGO,self)
    SL:RegisterLUAEvent(LUA_EVENT_FIGHT_RESULT, self.LUA_EVENT_FIGHT_RESULT, self)
    SL:RegisterLUAEvent(LUA_EVENT_MOUNTID_CHANGE, self.LUA_EVENT_MOUNTID_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_ACTION_CHANGE, self.LUA_EVENT_ROLE_ACTION_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_CREATE_PLAYER_SUCCESS, self.LUA_EVENT_CREATE_PLAYER_SUCCESS, self)
    SL:RegisterLUAEvent(LUA_EVENT_ME_RELEASE_SKILL, self.LUA_EVENT_ME_RELEASE_SKILL, self)
    
    --坐骑
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_ALL_MOUNT,self.RES_GET_ALL_MOUNT,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ACTIVE_MOUNT, self.RES_ACTIVE_MOUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UP_LEVEL_MOUNT, self.RES_UP_LEVEL_MOUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SET_MOUNT, self.RES_SET_MOUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RIDE_OR_DOWN_MOUNT, self.RES_RIDE_OR_DOWN_MOUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ACTIVE_SKIN_MOUNT, self.RES_ACTIVE_SKIN_MOUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SET_SKIN_MOUNT, self.RES_SET_SKIN_MOUNT, self)
    --坐骑背包
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BagInfo_MOUNT, self.RES_BagInfo_MOUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BagChange_MOUNT, self.RES_BagChange_MOUNT, self)
    --坐骑装备
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIPS_MOUNT, self.RES_EQUIPS_MOUNT, self)
    SL:RegisterTrigger(LUA_TRIGGER_MOUNT_ID_CHANGE, self.LUA_TRIGGER_MOUNT_ID_CHANGE, self)----坐骑消息里
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PLAYER_ENTER_VIEW_INFO, self.RES_PLAYER_ENTER_VIEW_INFO, self)            -- 响应玩家进入视野
end
function this:RES_PLAYER_ENTER_VIEW_INFO(_,message)
    if message then
        local role = SL:GetRoleById(tonumber(message.rid))
        if role then
            if not self.MountIdEquipList[role.data.id] then
                self.MountIdEquipList[role.data.id] = {}
            end
            self.MountIdEquipList[role.data.id] = message.mount
            self:SetCurRoleMount(role)
        end

    end
end
function this:LUA_TRIGGER_MOUNT_ID_CHANGE(role,id)
    local mountId = nil
    --logError("穿戴坐骑---id"..id)
    if role and type(role) ~= "number" then
        local newId,entryAttCount = self:GetMountIdAndEntryAttCountByRoleEquip(role)
        if newId ~= 0 then
            local mountTbl = SL:GetConfig("cfg_mount",newId)
            local replaceMount = mountTbl.replaceMount
            --local entryAttCount = self:GetMountIdAndEntryAttCountByRoleEquip(role)
            local maxCount = 0
            for _,v in pairs(replaceMount) do
                if v[1] == entryAttCount then
                    --logError(role.data.name.."穿戴坐骑"..id.."-->"..v[2])
                    return v[2]
                end
                if v[1] > maxCount then
                    maxCount = v[1]
                    mountId = v[2]
                end
            end
        else
            return nil
        end
        --logError(role.data.name.."穿戴坐骑"..id.."-->"..mountId)
    end
    return mountId
end
----获取当前穿戴坐骑卓越词条
function this:GetCurMountExEquipAttrCount()
    local itemData = EquipFunc.GetMountData()
    if itemData then
        local entryAtt = SL:GetEquipEntrys(itemData)
        return table.count(entryAtt)
    end
    return 0
end
function this:RES_CURRENT_RIDE_MOUNT(id,mountId)
    self.ride_mount_id = mountId
end

function this:LUA_EVENT_MOUNT_ISON(id,stateInfo)
    local rid = tonumber(SL:GetMetaValue("MAIN_ACTOR_ID"))
    if stateInfo.role.data.id == rid then
        local isDie = SL:GetMetaValue(EMetaVarGetKey.USER_IS_DIE)
        if not isDie then
            local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
            if self.default_mount_id ~= 0 then
                if stateInfo.state then
                    self.ride_mount_id = 1
                else
                    self.ride_mount_id = 0    
                end
            end
        end
    end
    if self.effectId then
        if stateInfo.state then
            SL:SetMetaValue(EMetaVarSetKey.SET_EFFECT_ON_ROLE, stateInfo.role.data.id, tonumber(self.effectId), nil, true, EPlayEffectOverType.Loop)
        else
            SL:SetMetaValue(EMetaVarSetKey.RECYCLE_EFFECT_ON_ROLE,stateInfo.role.data.id, tonumber(self.effectId))
        end
    end

    --self:SetCurRoleMount(stateInfo.role)
    SL:onLUAEvent(LUA_EVENT_MOUNT_RIDE_STATE_REFRESH)
end
--设置角色坐骑
function this:SetCurRoleMount(role)
    local mountId,entryAttCount = self:GetMountIdAndEntryAttCountByRoleEquip(role)
    if role.data and mountId ~= 0 and entryAttCount ~= 0 then
        local curId = mountId
        local mountTbl = SL:GetConfig("cfg_mount",mountId)
        local replaceMount = mountTbl.replaceMount
        local maxCount = 0
        for _,v in pairs(replaceMount) do
            if v[1] == entryAttCount then
                curId = v[2]
                break
            end
            if v[1] > maxCount then
                maxCount = v[1]
                curId = v[2]
            end
        end
        --logError(role.data.name.."穿戴坐骑"..curId)
        SL:SetMetaValue(EMetaVarSetKey.SET_PLAYER_MOUNTID,role.data.id,curId)
    end
end
---获取角色坐骑id和坐骑道具卓越词条数量
function this:GetMountIdAndEntryAttCountByRoleEquip(role)
    if role and self.MountIdEquipList[role.data.id] then
        local mountItem = self.MountIdEquipList[role.data.id] --self:GetMountDataByRole(role)
        if not table.isNullOrEmpty(mountItem) then
            local entryAtt = mountItem.entries--SL:GetEquipEntrys(mountItem)
            local cfgs = SL:GetConfigTable("cfg_mount")
            ---@type cfg_item_column
            local cfg = SL:GetConfig("cfg_item", mountItem.cfgid)
            ---@param v cfg_mount_column
            for i, v in ipairs(cfgs) do
                if v.itemId == mountItem.cfgid or (cfg.bindEqualItem ~= 0 and v.itemId == cfg.bindEqualItem) then
                    return v.id,table.count(entryAtt)
                end
            end
        end
    end
    return 0,0
end


function this:GetMountDataByRole(role)
    local equips = role.data.equips  --SL:GetWearBarsData(1)
    for i, v in pairs(equips) do
        if v and v.cfgId then
            local cfg = SL:GetConfig("cfg_item", v.cfgId)
            if cfg and cfg.type == 2 and cfg.subType == 10001 then
                return v
            end
        end
    end
    return nil
end
function this:OnPlayerMapPosChange()
    local isDie = SL:GetMetaValue(EMetaVarGetKey.USER_IS_DIE)
    local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
    local checkMountData = EquipFunc.GetMountData()
    if not isDie and checkMountData then
        local default_mount_id = EquipFunc.GetDefaultMountId()
        ---@type cfg_mount_column
        local tbl = SL:GetConfig("cfg_mount", default_mount_id)
        if not isSafe and self.lastIsSafe and checkMountData ~= nil then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,1)
        elseif isSafe and not self.lastIsSafe then
            if checkMountData then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,0)
            end
            -- if tbl.area == 0  then
            --     if not EquipFunc.GetMountData() then
            --         SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,1)
            --     end
            -- else
            --     if EquipFunc.GetMountData() then
            --         SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,0)
            --     end    
            -- end
        end
    end

    self.lastIsSafe = isSafe
end

function this:LUA_EVENT_ME_RELEASE_SKILL()
    if EquipFunc.GetMountData() then
        local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
        local isOn = SL:GetMetaValue(EMetaVarGetKey.GET_PLAYER_IS_ON_MOUNTID,rid)
        if isOn and EquipFunc.GetMountIsShow() then
            --EquipFunc.SetMeLocalMountIsShow(false)
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,0)
        end
    end
end

function this:LUA_EVENT_FIGHT_RESULT(id,message)
    if EquipFunc.GetMountData() then
        local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
        rid = tonumber(rid)
        local isFight = message.targetId == rid or message.attackerId == rid
        if not isFight then
            for i, v in pairs(message.target) do
                if v.targetId == rid then
                    isFight = true
                    break
                end
            end
        end
        if isFight then
            local isOn = SL:GetMetaValue(EMetaVarGetKey.GET_PLAYER_IS_ON_MOUNTID,rid)
            local role = SL:GetRoleById(rid)
            if isOn and EquipFunc.GetMountIsShow() then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,0)
            end
            self.fightTime = Time.time
            if self.timer then
                SL:UnSchedule(self.timer)
                self.timer = nil
            end
            self.timer = SL:Schedule(self.timer,0,1,self.exit_fight_time,function()
                if Time.time -  self.fightTime >= self.exit_fight_time then--脱战
                    self.fightTime = nil
                    local isDie = SL:GetMetaValue(EMetaVarGetKey.USER_IS_DIE)
                    local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
                    if not isDie then
                        local default_mount_id = EquipFunc.GetDefaultMountId()
                        ---@type cfg_mount_column
                        local tbl = SL:GetConfig("cfg_mount", default_mount_id)
                        if isSafe then
                            if tbl.setarea == 0 then
                                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,1)
                            end
                        else
                            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT,1)
                        end
                        --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SET_MOUNT_IS_SHOW,1)
                    end
                end
            end)
        end 
    end
end

function this:CheckIsFightTime()
    if self.fightTime then
        if Time.time -  self.fightTime < self.exit_fight_time then--脱战
            local num = math.floor( self.exit_fight_time -(Time.time -  self.fightTime))
            return true,num
        end
    end
    return false
end

function this:LUA_EVENT_MOUNTID_CHANGE(id,data)
    if data.new and data.new ~= 0 then
        ---@type cfg_mount_column
        local tbl = SL:GetConfig("cfg_mount",data.new)
        if tbl then
            self.effectId = tbl.ridingEffect
            SL:SetMetaValue(EMetaVarSetKey.SET_EFFECT_ON_ROLE, data.role.data.id, tonumber(self.effectId), nil, true, EPlayEffectOverType.Loop)
        end
    elseif self.effectId then
        SL:SetMetaValue(EMetaVarSetKey.RECYCLE_EFFECT_ON_ROLE,data.role.data.id, tonumber(self.effectId))
    end
end
---@param role Role
function this:LUA_EVENT_ROLE_ACTION_CHANGE(id,role)
    local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
    if role.data.mountId and role.data.mountId ~= 0 then
        if role.data.action == EAction.Walk or role.data.action == EAction.Run then
            if not isSafe then
                ---@type cfg_mount_column
                local tbl = SL:GetConfig("cfg_mount",role.data.mountId)
                if tbl then
                    self.effectId = tbl.ridingEffect
                    SL:SetMetaValue(EMetaVarSetKey.SET_EFFECT_ON_ROLE, role.data.id, tonumber(self.effectId), nil, true, EPlayEffectOverType.Loop)
                end
            end
        elseif self.effectId then
            SL:SetMetaValue(EMetaVarSetKey.RECYCLE_EFFECT_ON_ROLE,role.data.id, tonumber(self.effectId))
        end
    end
end

---创建玩家事件监听
function this:LUA_EVENT_CREATE_PLAYER_SUCCESS(_, id)
    
end

--所有坐骑信息
function this:RES_GET_ALL_MOUNT(_, message)
    self.totalMounts = message.mounts
    self.isHasOwnerMount = table.count(message.mounts) > 0
    self.default_mount_id = EquipFunc.GetDefaultMountId()
    SL:onLUAEvent(LUA_EVENT_TOTAL_MOUNTS_INFO_INIT, message)
end

function this:CheckCurRideId()
    self.ride_mount_id = 0
    local isDie = SL:GetMetaValue(EMetaVarGetKey.USER_IS_DIE)
    local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
    if not isDie and self.default_mount_id ~= 0 then
        ---@type cfg_mount_column
        local tbl = SL:GetConfig("cfg_mount", self.default_mount_id)
        if isSafe then
            if tbl.setarea == 0 then
                self.ride_mount_id = 1
            end
        else
            self.ride_mount_id = 1
        end
    end
end

---激活坐骑响应
function this:RES_ACTIVE_MOUNT(_, message)
    self.totalMounts = message.mounts
    self.default_mount_id = message.curRideId
    self.isHasOwnerMount = table.count(message.mounts) > 0
    self:CheckCurRideId()
    SL:onLUAEvent(LUA_EVENT_TOTAL_MOUNTS_INFO_INIT, message)
    SL:RefreshPanelALLRedStateKmlByCondition("checkMountLevelUpOrEquip")
end
---坐骑升级响应
---@param message Net_MountInfo
function this:RES_UP_LEVEL_MOUNT(_, message)
    self.totalMounts[tostring(message.mountId)] = message
    SL:onLUAEvent(LUA_EVENT_MOUNT_LEVEL_CHANGE, message.mountId)
    SL:RefreshPanelALLRedStateKmlByCondition("checkMountLevelUpOrEquip")
end
---设置默认坐骑响应
function this:RES_SET_MOUNT(_, message)
    self.default_mount_id = tonumber(message)
    SL:onLUAEvent(LUA_EVENT_SET_DEFAULT_RIDE)
end
---上马/下马---别人坐骑和自己坐骑穿戴信息
function this:RES_RIDE_OR_DOWN_MOUNT(_, message)
    if message then
        local role = SL:GetRoleById(tonumber(message.rid))
        if role then
            if not self.MountIdEquipList[role.data.id] then
                self.MountIdEquipList[role.data.id] = {}
            end
            self.MountIdEquipList[role.data.id] = message.mount
            self:SetCurRoleMount(role)
        end
    end
--[[    if message.show then
        self.ride_mount_id = message.id
    else
        self.ride_mount_id = 0    
    end
    SL:onLUAEvent(LUA_EVENT_MOUNT_RIDE_STATE_REFRESH)]]
end
---坐骑激活皮肤响应
function this:RES_ACTIVE_SKIN_MOUNT(_, message)
    self.totalMounts[tostring(message.mountId)] = message
    SL:onLUAEvent(LUA_EVENT_MOUNT_BUY_SKIN_CHANGE, message.mountId)
end
---坐骑切换皮肤响应
---@param message Net_MountInfo
function this:RES_SET_SKIN_MOUNT(_, message)
    self.totalMounts[tostring(message.mountId)] = message
--[[    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    rid = tonumber(rid)
    if message.curSkin == 0 then
        ---@type cfg_mount_column
        local tbl = SL:GetConfig("cfg_mount", message.mountId)
        ---@type cfg_mount_model_column
        local modelTbl = SL:GetConfig("cfg_mount_model", tbl.mountId)
        SL:ModifyMountModelPath(rid, modelTbl.path)
    else
        ---@type cfg_mount_skin_column
        local skin = SL:GetConfigTwoKeys("cfg_mount_skin", message.mountId, message.curSkin, "id", "skinid")
        if skin then
            ---@type cfg_mount_model_column
            local modelTbl = SL:GetConfig("cfg_mount_model", skin.mountId)
            SL:ModifyMountModelPath(rid, modelTbl.path)
        end
    end]]
end
---获取拥有的所有坐骑
function this:GetTotalMounts()
    return self.totalMounts
end
---获取坐骑数据
function this:GetMountData(mountId)
    return self.totalMounts[tostring(mountId)]
end
---获取当前骑乘坐骑id
function this:GetCurRideId()
    return self.ride_mount_id
end
---获取当前默认骑乘坐骑
function this:GetDefaultMountId()
    return EquipFunc.GetDefaultMountId()
end
--region 坐骑背包

---@class Net_MountEquipItem
---@field id number
---@field cfgId number
---@field bind boolean
---@field entries table
---@field count number

---坐骑背包数据响应
function this:RES_BagInfo_MOUNT(_, message)
    if message.type == EOut_BagType.MountBag then
        self.bagItems = message.items
        SL:RefreshPanelALLRedStateKmlByCondition("checkMountLevelUpOrEquip")
    end
end
---坐骑背包变动响应
function this:RES_BagChange_MOUNT(_, message)
    if message.type == EOut_BagType.MountBag then
        for _, v in pairs(message.itemList) do
            self.bagItems[tostring(v.index)] = v.item
        end
        SL:onLUAEvent(LUA_EVENT_MOUNT_BAG_CHANGE)
        SL:RefreshPanelALLRedStateKmlByCondition("checkMountLevelUpOrEquip")
    end
end
---获取背包所有数据
function this:GetBagItems()
    return self.bagItems or {}
end
---获取背包item
function this:GetBagItem(index)
    return self.bagItems[tostring(index)]
end
---获取坐骑背包item的存储索引
function this:GetBagIndex(id)
    for k, v in pairs(self.bagItems) do
        if v.id == id then
            return tonumber(k)
        end
    end
end
--endRegion

--region 坐骑装备
---穿戴回包响应
function this:RES_EQUIPS_MOUNT(_, message)
    for id, v in pairs(message) do
        local mountData = self:GetMountData(id)
        if mountData then
            for pos, item in pairs(v) do
                if type(item) == "number" then
                    mountData.equips[pos] = nil     --脱下
                else
                    mountData.equips[pos] = item    --穿上
                end
            end
        end
        SL:onLUAEvent(LUA_EVENT_MOUNT_EQUIP_CHANGE, tonumber(id))
        SL:onLUAEvent(LUA_EVENT_MOUNT_BAG_CHANGE)
    end
    SL:RefreshPanelALLRedStateKmlByCondition("checkMountLevelUpOrEquip")
end
---获取坐骑指定位置上的装备
---@return Net_MountEquipItem
function this:GetMountEquipByPos(mountId, pos)
    local data = self:GetMountData(mountId)
    if data then
        return data.equips[tostring(pos)]
    end
end
--endRegion

function this:GetBlackStallionByTypeAndLevel(level)
    level = level ~= 0 and level or 1
   return SL:GetConfigTwoKeys("cfg_equip_priest",E_ItemSubType_Equip.PriestHorse,level,"type","hawkLv")
end

function this:GetBlackStallionAttr(level)
    local attrList = {}
    for i = 1, level do
        ---@type cfg_equip_priest_column
        local info = self:GetBlackStallionByTypeAndLevel(i)
        local isHave = false
        for i, v in ipairs(attrList) do
            for i, att in ipairs(info.hawkAtt) do
                if v[1] == att[1] then
                    v[2] = v[2] + att[2]
                    isHave = true
                    break
                end
            end
        end
    
        if not isHave then
            local hawkAtt = SL:CopyData(info.hawkAtt)
            for i, v in ipairs(hawkAtt) do
                table.insert(attrList,v)
            end
        end
    end
    return attrList
end

function this:Reset()
    self.lastIsSafe = false
    self.ride_mount_id = 0
    self.default_mount_id = 0
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    self.totalMounts = {}
    self.bagItems = {}
end 

--获取坐骑的皮肤
function this:GetMountSkins(mountId)
    return self.mountSkins[mountId]
end 
---判断该坐骑是否已经拥有此皮肤
function this:CheckRideOwnSkin(mountId, skinId)
    if mountId == skinId then
        --原皮
        return true
    end
    local mountData = self:GetMountData(mountId)
    if mountData and mountData.skins[tostring(skinId)] then
        return mountData.skins[tostring(skinId)] == 1
    end
    return false
end 
---获取坐骑当前皮肤
function this:GetMountNowSkin(mountId)
    local mountData = self:GetMountData(mountId)
    if mountData then
        return mountData.curSkin
    end
    return 0
end
---判断坐骑拥有臻藏系列
function this:CheckRideSuit(mountItemId)
    local equipSuitList = SL:GetMetaValue("GET_EQUIPSUIT_BY_ID", mountItemId)
    if table.isNullOrEmpty(equipSuitList) then
        return false
    end
    return true
end 
---获取位置跟subType的对应关系
function this:GetPosBySubType(subType)
    return self.subTypeToPos[subType]
end
---获取位置跟subType的对应关系
function this:GetSubtypeByPos(pos)
    return table.getKey(self.subTypeToPos, pos)
end 

function this:CheckEquipRed(mountId, pos, cfgId)
    local equip = InfoManager.mountInfo:GetMountEquipByPos(mountId, pos)
    if not equip then
        return true
    else
        local nowGrade = SL:GetConfig("cfg_equip_entryLib", equip.cfgId).initialRating
        for _, item in pairs(itemList[k]) do
            local grade = SL:GetConfig("cfg_equip_entryLib", item.cfgId).initialRating
            if grade > nowGrade then
                GUI:setVisible(v.red, true)
                break
            end
        end
    end
end 

function this:GetMountRedDot()
    local mounts = self.totalMounts
    if next(mounts) then
        local bagItems = self:GetBagItems()
        local supList = {}
        for _,v in pairs(bagItems) do
            local tbl = SL:GetConfig("cfg_item", v.cfgId)
            if not supList[tbl.subType] then
                supList[tbl.subType] = {}
            end
            ---@type cfg_equip_entryLib_column
            local entryLibColumn = SL:GetConfig("cfg_equip_entryLib", v.cfgId)
            supList[tbl.subType][v.cfgId] = entryLibColumn.initialRating
        end
        for _,v in pairs(mounts) do
            ---@type cfg_mount_column
            local tbl = SL:GetConfig("cfg_mount",  v.mountId)
            ---@type cfg_mount_levelUp_column
            local lvTbl = SL:GetConfigTwoKeys("cfg_mount_levelUp", tbl.type, v.level, "type", "level")
            if lvTbl and lvTbl.deplete[1] then
                if SL:GetBagItemCount(lvTbl.deplete[1]) >= lvTbl.deplete[2] then
                    return true
                end
            end
            for subType, _ in pairs(supList) do
                local pos = self:GetPosBySubType(subType)
                local equip = v.equips[tostring(pos)]
                if not equip then
                    return true
                end
                local item = SL:GetConfig("cfg_item", equip.cfgId)
                if supList[item.subType] then
                    local entryLibColumn = SL:GetConfig("cfg_equip_entryLib", equip.cfgId).initialRating
                    for _, rating in pairs(supList[item.subType]) do
                        if rating > entryLibColumn then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end 

--坐骑装备评分比较
function this:CanUpMountEquipFight(equip)

end
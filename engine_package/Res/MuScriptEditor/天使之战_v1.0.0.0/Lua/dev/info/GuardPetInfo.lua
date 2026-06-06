---@class GuardPetInfo
GuardPetInfo = class()
local this = GuardPetInfo

function this:ctor()
end

function this:Reset()
    --[[    if self.limiteTimer then
            SL:UnSchedule(self.limiteTimer)
        end
        self.limiteTimer = nil]]
    self:RecycleMM()
    self.IsOpenMM = false
    self.MM_ID = ""

    self.modelList = nil
    self.MM_endTime = 0
    self.MM_ShowTime = 0

end

function this:Init()
    self:Reset()
    self.guardPetInfoList = {}
    self:InitData()
    self:RegistMessages()
    self.TimeS = nil
    self.limiteTimer = nil
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.EQUIP_GUARD_ALL_RES, self.EquipGuardAllRes, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.EQUIP_GUARD_RES, self.EquipGuardRes, self)
    SL:RegisterLUAEvent(LUA_EVENT_GUARDPET_PUT, self.LUA_EVENT_GUARDPET_PUT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ELITE_MM, self.RES_ELITE_MM, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_ENTER_MAP, self.LUA_EVENT_MAPINFOCHANGE, self)
    --SL:RegisterLUAEvent(LUA_EVENT_LOGIN_MAP, self.LUA_EVENT_MAPINFOCHANGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_NPC_BUFF_CD, self.RES_NPC_BUFF_CD, self)
    --SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, self.EquipChange, self)
end
--[[---@param data table {MakeIndex = 唯一ID, Where = 装备位置, opera = 操作类型 ( 0:初始化 1:增加 2:删除 3:改变), ItemData = 装备数据, WearBar = 穿戴栏id}
function this:EquipChange(_, data)
    if not table.isNullOrEmpty(data) then
        self.equips = SL:GetWearBarsData(data.wearBar)
        local pos = data.Where
        if pos == EEquipSlotType.Guard and data.opera == 2 then
            local endTime = data.ItemData.endTime
            if endTime ~= 0 then
                local time = endTime - Time.GetServerTime() // 1000
                if time <= 0 then
                    ---守护过期清除外观
                    SL:SendLuaNetMsg(LuaMessageIdToSever.SETTING_EQUIP_APPEAR, { equipindex = {slot = 15 }, isUpdateView = true })
                end
            end
        end
    end
end]]
function this:RES_NPC_BUFF_CD(_, message)
    if message then
        self.MM_endTime = message.endTime
    end
end
function this:LUA_EVENT_MAPINFOCHANGE(_, message)
    if message then
        if self.IsOpenMM then
            self:CreatMM()
        else
            self:RecycleMM()
        end
    end
end
function this:RES_ELITE_MM(_, message)
    if message == 0 then
        self.IsOpenMM = false
        self:RecycleMM()
    else
        self.IsOpenMM = true
        self:CreatMM()
    end
    SL:onLUAEvent(LUA_NewPlayer_MM_BUFF_CHANGE)
end
function this:RecycleMM()
    if self.TimeS then
        SL:UnSchedule(self.TimeS)
    end
    self.TimeS = nil
    if self.Role_MM then
        SL:RecycleRole(self.MM_ID)
    end
    self.Role_MM = nil
end
function this:LUA_EVENT_GUARDPET_PUT(_, data)
    local _data = data._data
    local tbl = SL:GetConfig("cfg_equip_guard", data.cfgId)
    local data = { id = _data.id, cfgId = data.cfgId, x = _data.oldCoord.x, y = _data.oldCoord.z, isUI = _data.isUI, guardTbl = tbl }
    SL:CreateGuardPet(data)
end

function this:EquipGuardAllRes(_, message)
    if message == "" then
        return
    end
    for i, v in pairs(message) do
        self.guardPetInfoList[v.id] = v
    end
end

function this:EquipGuardRes(_, message)
    if message == "" then
        return
    end
    self.guardPetInfoList[message.id] = message
end

function this:GetGuardHp(id)
    if self.guardPetInfoList[id] then
        return self.guardPetInfoList[id].hp
    end
    SL:LogWarning("this guard id->hp is nil")
    return 0
end

function this:GetGuardBaseAttr(equip_pos, cfgId, id)
    local itemInfo = SL:GetPosItemInfo(equip_pos, cfgId, id)
    --玩家背包穿戴读不到就去读配置表
    local grade = SL:GetEquipValue(EMetaVarGetKey.EQUIP_GRADE, equip_pos, cfgId, id)
    local attribute = SL:GetConfig("cfg_equip_guard", cfgId).stage
    if attribute then
        local baseAttr = {}
        for i, v in pairs(attribute) do
            local oneAttr = {}
            oneAttr.type = v[1]
            oneAttr.num = v[2]
            table.insert(baseAttr, oneAttr)
        end
        return baseAttr
    end
end

function this:GetGuardSpecialShowData(cfgId)
    ---@type cfg_equip_guard_column
    local guardInfo = SL:GetConfig("cfg_equip_guard", cfgId)
    local attr = {}
    if guardInfo.ability == 1 then
        table.insert(attr, { title = "tips_attribute20" })
        table.insert(attr, { name = "自动拾取", value = "" })
        --elseif guardInfo.ability == 2 then
        --    table.insert(attr,{title = "tips_attribute20"})
        --    for i, skill_id in pairs(guardInfo.abilityParameter) do
        --        local skill_name = SL:GetConfig("cfg_skill",skill_id).name
        --        table.insert(attr, { name = skill_name, value = "" })
        --    end
    end
    return attr
end
function this:CreatMM()
    self:RecycleMM()
    --InfoManager.roleOtherInfo:reMoveNpcTips()
    if not SL:HasConfig("cfg_global", 390001) then
        return
    end
    local MMInfo = SL:GetConfig("cfg_global", 390001).value
    local animInfoList = string.split(SL:GetConfig("cfg_global", 560001).value, "#")
    local strList = string.split(MMInfo, "#")
    local name = strList[1]
    local callperTime = tonumber(strList[2])
    local fanwei = tonumber(strList[3])
    local gensuifanwei = tonumber(strList[4])
    local rid = tonumber(SL:GetMetaValue("USER_ID"))
    ---@type MapProtos.RoundPlayerEx
    local t = {}
    self.MM_ID = UtilityLua.UUID
    if tonumber(self.MM_ID) == tonumber(rid) then
        self.MM_ID = self.MM_ID .. 1
    end
    t.id = self.MM_ID--rid .. "_MM"
    t.career = { baseCareer = 3, careerNum = 1, careerRank = 1 }
    t.level = 1
    t.name = name
    t.hp = 1
    t.x = 0
    t.y = 0
    t.pkValue = 0
    t.equip = {
        [1] = {
            cfgId = 1003,
            durability = 0,
            gmExtInfo = { field = 0, luaExt = "", shape = 0, sweepLevel = 0 },
            id = 0,
            index = 65537,
            modelExtInfo = { feedLevel = 0, grade = 1, strengthLevel = 0 }
        }
    }
    --t.appearIdx =  { [1] = 65537 }
    --t.roleAppear = { cfgId = 1003, pos = 1 }
    t.shapeRing = 0
    t.mountId = 0
    local role_me = SL:GetRoleById(rid)
    self.modelPos = { role_me.data.oldCoord.x + 1, role_me.model.transform.position.y, role_me.data.oldCoord.z + 1 }
    t.isCreateRolePanel = true
    local role = SL:CreatePlayer(t, false, true) ---RoleManager.CreatePlayer(t, false, true)
    self.Role_MM = role
    role.data.isHasShadow = false
    role.data.isUI = false
    --self.role = role
    role:AsyncInit()
    role:ShowHead(true)
    ---@type Vector3
    local modelSize = Vector3.New(0.35, 0.35, 0.35)
    ---@type Vector3
    local modelRota = Vector3.New(0, 180, 0)
    local sizeList = string.split('0.35#0.35#0.35', '#')
    modelSize = Vector3.New(tonumber(sizeList[1]), tonumber(sizeList[2]), tonumber(sizeList[3]))
    --role.model:SetLocalScale(modelSize.x, modelSize.y, modelSize.z)
    --role.model:SetLocalRotation(modelRota.x, modelRota.y, modelRota.z)
    --role.model.transform.position = Vector3.New(self.modelPos[1], self.modelPos[2], self.modelPos[3])
    --role.model.transform.localPosition = Vector3.New(self.modelPos[1], self.modelPos[2], self.modelPos[3])
    --role:SetAnyActionStopTime(1)
    --role:SetActionForce()
    if self.MM_endTime * 1000 >= tonumber(animInfoList[3]) then
        self.MM_ShowTime = Time.GetServerTime() + tonumber(animInfoList[3])
    else
        self.MM_ShowTime = self.MM_endTime * 1000
    end

    local isPlayEffect = false
    local oldTime = Time.GetServerTime()
    self.TimeS = SL:Schedule(self.TimeS, 0, 0.02, -1, function()
        role_me = SL:GetRoleById(rid)
        if role_me then
            local curTime = Time.GetServerTime()
            if curTime - oldTime >= tonumber(animInfoList[3]) then
                self.MM_ShowTime = curTime + tonumber(animInfoList[3])
                isPlayEffect = true
                oldTime = curTime
                role:StopMove(true, true)
                role.data.serverCoord = role.data.OldCoord
                role:LookAtByCoord(role_me.data.OldCoord.x, role_me.data.OldCoord.z)
                role:SetAnyAction("idle")
                role:SetAnimatorName(animInfoList[1], 0)
                if not self.modelList then
                    SL:CreateSceneItemModel(animInfoList[2], function(res)
                        if not IsNil(res) then
                            if self.modelList then
                                SL:RecycleSceneItemModel(self.modelList)
                                self.modelList = nil
                            end
                            self.modelList = res

                            res:SetParent(role_me.transform)
                            res:SetLocalEulerAngles(0, 0, 0)
                            res:SetLocalPosition(0, 0, 0)
                        end
                    end)
                end
                --role:SetAnyActionStopTime(1)
            end

            if isPlayEffect then
                if curTime - oldTime >= 250 then
                    isPlayEffect = false
                    --logError("坐标:idle" )
                    role:SetAnimatorName("idle", 0.15)
                    role:ResetAnyAction()
                end
            end

            if curTime - oldTime >= 1000 then
                if self.modelList then
                    SL:RecycleSceneItemModel(self.modelList)
                    self.modelList = nil
                end
            end
            local targetPos = self:OBSTACLE_Map(role_me, gensuifanwei)
            if targetPos and not isPlayEffect then
                if Dot2.DistancePow2(targetPos, role.data.OldCoord) >= fanwei then
                    role:StopMove(true, true)
                    role.data.serverCoord = targetPos
                    --role:SetServerCoord(targetPos.x, targetPos.z)
                    role:SetPositionCoord(targetPos.x, targetPos.z)

                else
                    if not self:IsRangeTarget(role.data.serverCoord, role_me.data.OldCoord, Mathf.Ceil(gensuifanwei)) then
                        if not self.MMTime then
                            self.MMTime = 0
                        end
                        self.MMTime = self.MMTime + callperTime
                        if self.MMTime > 0.5 then
                            role.data.serverCoord = targetPos
                            --logError("坐标:" .. targetPos.x .. "," .. targetPos.z)
                            role:PathMoveTo(targetPos, nil, nil, nil, false, false, nil, nil, true)
                            self.MMTime = 0

                        end
                    end
                end
            end
        end

    end)
end
function this:OBSTACLE_Map(role_me, gensuifanwei)
    if role_me then
        local targetPos = this:RandomPos(role_me.data.OldCoord, Mathf.Ceil(gensuifanwei))
        if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, targetPos.x, targetPos.z) then
            return targetPos
        end
    end
    return nil
end
---@param playerPos @玩家位置
------@param range @范围
function this:RandomPos(playerPos, range)
    local xx = Mathf.Random(playerPos.x - range, playerPos.x + range)
    local zz = Mathf.Random(playerPos.z - range, playerPos.z + range)
    return Dot2.New(xx, zz)
end

function this:IsRangeTarget(playerPos, targetPos, range)
    if Mathf.Abs(playerPos.x - targetPos.x) <= range and Mathf.Abs(playerPos.z - targetPos.z) <= range then
        return true
    end
    return false
end 
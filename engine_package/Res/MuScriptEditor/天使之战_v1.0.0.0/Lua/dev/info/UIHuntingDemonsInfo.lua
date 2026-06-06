---@class UIHuntingDemonsInfo @注释
---@field AllRankDataList table<number,{roleInfo:{career:number, name:string, online:number, serverid:number},integral:number, rank:number, rid:number, medal:number}> @所有排行榜数据
---@field TheFirstThreeRankDataList table<number,UserProtos.OtherRoleInfoRes> @前三名玩家装备数据 key:名次 value:数据
---@field itemID number @猎魔勋章道具id（策划说写死）
---@field TheFirstThreeRidList table<number,number> @前三名玩家rid key:名次 value:rid
---@field reqOtherPlayerDataIndex number @请求其他玩家装备数据序列（前三名数据 一个个请求）
---@field startReqOtherPlayerData boolean @开始请求其他玩家数据
---@field AllPlayerIntegral number @所有玩家的积分
---@field AllItemCount number @所有勋章数量
---@field ConversionRateList table<number,{integral:number,value:number}> @转化率占比 integral:所处积分 value：占比
---@field RankWeightDataList table<number,{cfg:cfg_monsterHuntReward_column,itemCount:number}> @对应排名权重信息 cfg:表数据 itemCount：猎魔勋章数量
---@field isStartReqRankData boolean @开始请求排行榜数据（用于计时请求数据）
UIHuntingDemonsInfo = class()
local this = UIHuntingDemonsInfo

function this:ctor()

end

function this:Init()
    self:Reset()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.itemID = 10230001
    ---倒计时时间
    self.timeCount = tonumber(SL:GetConfig("cfg_global",27004).value)
    self:GetConversionRateRange()
    self:InitRankingIntervalWeightData()
    local globalCfg = SL:GetConfig("cfg_global",27006)
    local strList = string.split(globalCfg.value,'|')
    self.seasonTimeList = {}
    for i, v in ipairs(strList) do
        local stringList2 = string.split(v,'&')
        self.seasonTimeList[tonumber(stringList2[1])] = {
            openTime = stringList2[2],
            endTime =  stringList2[3]
        }
    end
    
end
function this:GetCurSeason()
    if self.seasonTimeList  then
        for i,v in pairs(self.seasonTimeList) do
            local stringListOpen = string.split(v.openTime,'#')
            local OpenServerTimeSamp = GUIUtil.DateToServerTime({year = tonumber(stringListOpen[1]), month = tonumber(stringListOpen[2]), day = tonumber(stringListOpen[3]), hour =  tonumber(stringListOpen[4]),min = 0, sec = 0})
            local stringListEnd = string.split(v.endTime,'#')
            local EndServerTimeSamp = GUIUtil.DateToServerTime({year = tonumber(stringListEnd[1]), month = tonumber(stringListEnd[2]), day = tonumber(stringListEnd[3]), hour = tonumber(stringListEnd[4]),min = 0, sec = 0})
            local serverTime = Time.GetServerTime()
            if serverTime >= OpenServerTimeSamp and serverTime <= EndServerTimeSamp then
               return i
            end
        end
    end
    return 0
end
function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MONSTER_HUNT_RANK,self.RES_MONSTER_HUNT_RANK,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MONSTER_HUNT_INFO,self.RES_MONSTER_HUNT_INFO,self)
    SL:RegisterLuaNetMsg(MessageDef.ResOtherRoleInfoMessage, self.ResOtherRoleInfoMessage, self)

end

---猎魔积分信息
---@param message {settleSec:number, resetSec:number}
function this:RES_MONSTER_HUNT_INFO(id,message)
    if message then
        self.settleSec = message.settleSec
        self.resetSec = message.resetSec
        SL:onLUAEvent(LUA_EVENT_HUNTING_DEMONS_INFO_CHANGE)
    end
end

---其他玩家数据
function this:ResOtherRoleInfoMessage(id,message)
    if message.type == 1 and self.startReqOtherPlayerData then
        self.TheFirstThreeRankDataList[self.reqOtherPlayerDataIndex] = message
        self.reqOtherPlayerDataIndex = self.reqOtherPlayerDataIndex + 1
        ---是否还有下一个玩家数据需要请求
        self:StartReqOtherPlayerData(true)
    end
end

---响应猎魔积分排行榜
---@param message table<number,{roleInfo:{career:number, name:string, online:number, serverid:number},integral:number, rank:number, rid:number, medal:number}>
function this:RES_MONSTER_HUNT_RANK(id,message)
    self.AllRankDataList = {}
    self.TheFirstThreeRankDataList = {}
    self.TheFirstThreeRidList = {}
    self.reqOtherPlayerDataIndex = 1
    self.AllPlayerIntegral = 0
    if message and next(message) then
        local count = table.count(message)
        local list = {}
        for i = 1, count do
            table.insert(list,message[tostring(i)])
        end
        table.sort(list,function(a, b) 
            return a.rank < b.rank
        end)
        for i = 1, count do
            local data = list[i]
            table.insert(self.AllRankDataList,data)
            if i <= 3 then
                self.TheFirstThreeRidList[i] = data.rid
            end
        end
        if not self.startReqOtherPlayerData then
            self:StartReqOtherPlayerData()
        end
    end
    self:RefreshJackpotData()
    SL:onLUAEvent(LUA_EVENT_HUNTING_DEMONS_RANK_DATA_CHANGE)
    if self.isStartReqRankData then
        self.timer = SL:Schedule(self.timer,self.timeCount,self.timeCount,-1,function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_HUNT_RANK)
        end)
    end
end

---刷新奖池相关数据
function this:RefreshJackpotData()
    ---所有玩家的权重
    local allWeight = 0
    for i, v in ipairs(self.AllRankDataList) do
        self.AllPlayerIntegral = self.AllPlayerIntegral + v.integral
        allWeight = allWeight + self:GetRankingIntervalWeight(i)
    end
    local rate = self:GetNowConversionRateRange()
    self.AllItemCount = self.AllPlayerIntegral * (rate / 10000)
    for i, v in ipairs(self.RankWeightDataList) do
        v.itemCount = 0
        if v.cfg.reward[1] > 0 and self.AllRankDataList[v.cfg.rank[1]] then
            v.itemCount = Mathf.Floor(self.AllItemCount * (v.cfg.reward[1] / allWeight))
        end
    end
end

---获取转化率区间
function this:GetConversionRateRange()
    self.ConversionRateList = {}
    ---@type cfg_global_column
    local globalCfg = SL:GetConfig("cfg_global",27001)
    local strList = string.split(globalCfg.value,'|')
    for i, v in ipairs(strList) do
        local stringList2 = string.split(v,'#')
        table.insert(self.ConversionRateList,{integral = tonumber(stringList2[1]),value = tonumber(stringList2[2])})
    end
end

---获取当前积分所处的转化率
function this:GetNowConversionRateRange()
    local rota = 10000
    for i, v in ipairs(self.ConversionRateList) do
        if self.AllPlayerIntegral >= v.integral then
            rota = v.value
        end
    end
    return rota
end

---获取下一阶段的积分所处的转化率和所差积分
function this:GetNextConversionRateRange()
    local index = 1
    ---下一阶段所差积分
    local nextDifferIntegral = nil
    for i, v in ipairs(self.ConversionRateList) do
        if self.AllPlayerIntegral >= v.integral then
            index = i + 1
        end
    end
    if self.ConversionRateList[index] then
        nextDifferIntegral = self.ConversionRateList[index].integral - self.AllPlayerIntegral
    end
    return self.ConversionRateList[index],nextDifferIntegral
end

---初始化对应排名的区间权重信息
function this:InitRankingIntervalWeightData()
    self.RankWeightDataList = {}
    local cfg = SL:GetConfigTable("cfg_monsterHuntReward")
    ---@param v cfg_monsterHuntReward_column
    for i, v in ipairs(cfg) do
        table.insert(self.RankWeightDataList,{cfg = v,itemCount = 0})
    end
end

---获取对应排名的区间权重
function this:GetRankingIntervalWeight(rank)
    for i, v in ipairs(self.RankWeightDataList) do
        if rank >= v.cfg.rank[1] and rank <= v.cfg.rank[2] then
            return v.cfg.reward[1]
        end
    end
    return 0
end

---获取对应排名的勋章数量
function this:GetRankingIntervalWeightItemCount(index)
    if not self.RankWeightDataList[index] then
        return 0
    end
    return self.RankWeightDataList[index].itemCount
end

---开始请求玩家装备数据
function this:StartReqOtherPlayerData(isEvent)
    if self.TheFirstThreeRidList[self.reqOtherPlayerDataIndex] then
        self.startReqOtherPlayerData = true
        ---自己的话不用请求
        if self.TheFirstThreeRidList[self.reqOtherPlayerDataIndex] == SL:GetMetaValue(EMetaVarGetKey.UID) then
            local equip = {}
            if SL:MeData_GetRoleExtInfo() and SL:MeData_GetRoleExtInfo().roleInfoExtData and SL:MeData_GetRoleExtInfo().roleInfoExtData.equip then
                equip = SL:MeData_GetRoleExtInfo().roleInfoExtData.equip
            end
            self.TheFirstThreeRankDataList[self.reqOtherPlayerDataIndex] = {role = {roleInfoExt = {equip=equip},career = SL:MeData_GetCareer()}}
            ---当第一个数据是自己的时候需要isEvent为true,因为第一个数据是自己的时候不会走ResOtherRoleInfoMessage协议,isEvent还是为空
            if self.reqOtherPlayerDataIndex == 1 then
                isEvent = true
            end
            self.reqOtherPlayerDataIndex = self.reqOtherPlayerDataIndex + 1
            self:StartReqOtherPlayerData(isEvent)
            return
        end
        SL.Friend:ReqOtherRoleInfoMessage(self.TheFirstThreeRidList[self.reqOtherPlayerDataIndex], 1)
    else
        self.startReqOtherPlayerData = false
        if isEvent then
            SL:onLUAEvent(LUA_EVENT_REQ_HUNTING_DEMONS_THREE_PLAYER_END)
        end
    end
end

---获得猎魔积分
---@param monsterID number @怪物id
function this:GetHuntingDemonsIntegral(monsterID)
    ---@type cfg_monster_column
    local monsterCfg = SL:GetConfig("cfg_monster",monsterID)
    if not SL:HasConfig("cfg_monsterHunt",monsterCfg.monsterHunt) then
        return nil
    end
    ---@type cfg_monsterHunt_column
    local monsterHuntCfg = SL:GetConfig("cfg_monsterHunt",monsterCfg.monsterHunt)
    local myLv = SL:MeData_GetLevel()
    for i, v in ipairs(monsterHuntCfg.level) do
        local minLv = v[1]
        local maxLv = v[2]
        if myLv >= minLv and myLv <= maxLv then
            return monsterHuntCfg.number[i]
        end
    end
    return nil
end

---设置每个界面上的猎魔积分
function this:SetIntegralInControl(bgControl,textControl,monsterID)
    if monsterID then
        local num = self:GetHuntingDemonsIntegral(monsterID)
        if num then
            GUI:setVisible(bgControl,true)
            GUI:Text_setString(textControl,tostring(num))
            return
        end
    end
    GUI:setVisible(bgControl,false)
end

---获取前三名的数据
---@param index number @名次
function this:GetTheFirstThreeRankData(index)
    return self.TheFirstThreeRankDataList[index]
end

---清除TheFirstThreeRankDataList数据
function this:ClearTheFirstThreeRankDataList()
    self.TheFirstThreeRankDataList = {}
end

---获取排行榜某个序列的数据
---@param index number @序列
function this:GetRankDataIndex(index)
    if self.AllRankDataList then
        return self.AllRankDataList[index]
    end
end

---设置是否开始请求排行榜服务器数据
function this:SetIsStartReqRankData(isStart)
    self.isStartReqRankData = isStart
    if not isStart then
        if self.timer then
            SL:UnSchedule(self.timer)
        end
    end
end

---@param data UserProtos.RoleInfo
function this:GetPlayerRoleInfo(data)
    local role_param = { "body", "head", "armor", "hand", "pants", "boot" }
    local wear_list_str = ""
    local model_list_str = ""
    local equipInfo = data.roleInfoExt.equip
    if equipInfo then
        local default_tbl = SL:GetConfig("cfg_model_default", data.career.baseCareer)
        local model_list = {}
        for _, v in pairs(role_param) do
            model_list[v] = default_tbl[v]
        end
        --修复背了两把短剑只显示一把
        local lastSub2Id = {}
        local isWeaponLspineParent = false
        for _, v in ipairs(equipInfo) do
            ---@type cfg_item_column
            local itemInfo = SL:GetConfig("cfg_item", v.cfgId)
            local wearBar, pos = SL:GetWearBarAndPosBaseEquipIndex(v.index)
            if itemInfo and itemInfo.type == E_ItemType.Equip then
                if itemInfo.subType == E_ItemSubType_Equip.MainWeapon then
                    if not lastSub2Id[itemInfo.subType] then
                        if wear_list_str == "" then
                            wear_list_str = "WeaponRspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponRspineParent#" .. itemInfo.field[1]
                        end
                        lastSub2Id[itemInfo.subType] = v.cfgId
                    end
                elseif itemInfo.subType == E_ItemSubType_Equip.SecWeapon then
                    if not lastSub2Id[itemInfo.subType] then
                        if wear_list_str == "" then
                            wear_list_str = "WeaponLspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponLspineParent#" .. itemInfo.field[1]
                        end
                        lastSub2Id[itemInfo.subType] = v.cfgId
                    end

                elseif itemInfo.subType == E_ItemSubType_Equip.MainSecWeapon then
                    if not lastSub2Id[itemInfo.subType] then
                        if wear_list_str == "" then
                            wear_list_str = "WeaponRspineParent#" .. itemInfo.field[1]
                        else
                            wear_list_str = wear_list_str .. ",WeaponRspineParent#" .. itemInfo.field[1]
                        end
                        lastSub2Id[itemInfo.subType] = v.cfgId
                    else
                        if not isWeaponLspineParent then
                            isWeaponLspineParent = true
                            if wear_list_str == "" then
                                wear_list_str = "WeaponLspineParent#" .. itemInfo.field[1]
                            else
                                wear_list_str = wear_list_str .. ",WeaponLspineParent#" .. itemInfo.field[1]
                            end
                        end
                    end
                elseif itemInfo.subType == 13 then
                    if wear_list_str == "" then
                        wear_list_str = "Wing#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",Wing#" .. itemInfo.field[1]
                    end
                elseif itemInfo.subType == 30 then
                    if wear_list_str == "" then
                        wear_list_str = "BuffspineParent#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",BuffspineParent#" .. itemInfo.field[1]
                    end
                else
                    local point = ""
                    ---@type cfg_model_charactor_column
                    local model_tbl = SL:GetConfig("cfg_model_charactor", itemInfo.field[1])
                    if model_tbl then
                        if model_tbl.part == 23 then
                            point = "body"
                        elseif model_tbl.part == 11 then
                            point = "head"
                        elseif model_tbl.part == 2 then
                            point = "armor"
                        elseif model_tbl.part == 9 then
                            point = "hand"
                        elseif model_tbl.part == 15 then
                            point = "pants"
                        elseif model_tbl.part == 5 then
                            point = "boot"
                        end
                        if point ~= "" then
                            model_list[point] = itemInfo.field[1]
                        end
                    end
                end
            end
        end
        for _, v in pairs(model_list) do
            if model_list_str == "" then
                model_list_str = v
            else
                model_list_str = model_list_str .. "#" .. v
            end
        end
    end
    return model_list_str, wear_list_str
end


function this:Reset()
    self.settleSec = 0
    self.resetSec = 0
    self.AllPlayerIntegral = 0
    self.AllItemCount = 0
    self.AllRankDataList = {}
    self.TheFirstThreeRankDataList = {}
    self.TheFirstThreeRidList = {}
    self.reqOtherPlayerDataIndex = 1
    self.startReqOtherPlayerData = false
    self:SetIsStartReqRankData(false)
end 
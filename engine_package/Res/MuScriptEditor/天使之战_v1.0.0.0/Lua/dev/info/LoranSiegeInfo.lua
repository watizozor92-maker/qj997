---@class LoranSiegeInfo @注释
---@field TheFirstThreeRankDataList table<number,UserProtos.OtherRoleInfoRes> @三个盟主和副盟主玩家装备数据 key:名次 value:数据
---@field TheFirstThreeRidList table<number,number> @三个盟主和副盟主玩家rid key:名次 value:rid
---@field reqOtherPlayerDataIndex number @请求其他玩家装备数据序列（三个盟主和副盟主数据 一个个请求）
---@field startReqOtherPlayerData boolean @开始请求其他玩家数据
---@field siegeMainPanelInfo {union:{id:number,name:string,learder:number,deputys:table<number,number>},open:boolean,nextTime:number} @攻城战主面板信息
---@field siegeStateInfo table<string,number> @攻城战阶段数据 1:repid 2:state 3:nextStateStartTime
---@field siegeTaskInfo {selfScore:number,nowCount:number,selfRank:number,unionName:string,totalCount:number,unionRank:number,taskId:number,camp:number} @攻城战任务数据
---@field rolandProgressInfo {now:number,max:number,unionId:number,unionName:string} @攻城战占领进度数据
---@field monsterList {id:number,cfg:number,x:number,y:string} @攻城战怪物数据
LoranSiegeInfo = class()
local this = LoranSiegeInfo

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
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ROLAND_SEIGE_MAIN_PANEL,self.RES_ROLAND_SEIGE_MAIN_PANEL,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ROLAND_SEIGE_STATE,self.RES_ROLAND_SEIGE_STATE,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ROLAND_SEIGE_TASK_PANEL,self.RES_ROLAND_SEIGE_TASK_PANEL,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ROLAND_PROGRESS_INFO,self.RES_ROLAND_PROGRESS_INFO,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ROLAND_MONSTER_LIST,self.RES_ROLAND_MONSTER_LIST,self)
    SL:RegisterLuaNetMsg(MessageDef.ResOtherRoleInfoMessage, self.ResOtherRoleInfoMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE, self.LUA_EVENT_PKMODE_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_CREATE_PLAYER_SUCCESS, self.LUA_EVENT_CREATE_PLAYER_SUCCESS,self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_SETTING_PK_MODE_CHANGE, self.LUA_EVENT_ROLE_SETTING_PK_MODE_CHANGE,self)
    SL:RegisterTrigger(LUA_TRIGGER_CLICK_ROLE, self.LUA_TRIGGER_CLICK_ROLE,self)

end

---是否在地图中
function this:IsMap()
    local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    if map_id == 16001 or map_id == 16002 then
        return true
    end
    return false
end

function this:LUA_TRIGGER_CLICK_ROLE(rid)
    if SL:MeData_Check() and self:IsMap() then
        local role = SL:GetRoleById(rid)
        if role then
            local pkValue = role.data.pkMode
            local unionID = role.data.unionId
            local myPkValue = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
            local myUnionID = SL:MeData_GetUnionId()
            if myPkValue == EPKMode.Attack or myPkValue == EPKMode.Defend or pkValue == EPKMode.Defend or pkValue == EPKMode.Attack then
                if myPkValue == EPKMode.Attack and pkValue == EPKMode.Attack then
                    return true
                end
                if myPkValue == EPKMode.Defend and pkValue == EPKMode.Defend then
                    return true
                end
                if myPkValue == EPKMode.Union then
                    return true
                end
                return false
            end
            if myPkValue == EPKMode.Union and pkValue == EPKMode.Union then
                if unionID == myUnionID then
                    return true
                end
            end
            
        end
    end
    return false
end

function this:LUA_EVENT_CREATE_PLAYER_SUCCESS(id,rid)
    if rid and self:IsMap() then
        local role = SL:GetRoleById(rid)
        local roleList = 
        {
            ERoleType.Me,
            ERoleType.Player,
        }
        if role and table.contains(roleList,role.RoleType) then
            InfoManager.loranSiegeInfo:SetRoleHeadIcon(role.data.id,role.data.pkMode,role.data.position)
        end
    end
end

function this:LUA_EVENT_ROLE_SETTING_PK_MODE_CHANGE(_, pkMode)
    if SL:MeData_Check() and self:IsMap() then
        SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,false)
        SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE,pkMode)
        if self.isInCopy then
            SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,true)
        end
    end
end

function this:LUA_EVENT_PKMODE_CHANGE(_, pkMode)
    if SL:MeData_Check() and self:IsMap() then
        InfoManager.loranSiegeInfo:SetRoleHeadIcon(SL:MeData_GetId(),pkMode,SL:MeData_GetRoleExtInfo().roleInfoExtData.position)
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

---罗兰攻城战主面板
---@param message {union:{id:number,name:string,learder:number,deputys:table<number,number>},open:boolean,nextTime:number}
function this:RES_ROLAND_SEIGE_MAIN_PANEL(id,message)
    self.TheFirstThreeRankDataList = {}
    self.TheFirstThreeRidList = {}
    self.reqOtherPlayerDataIndex = 1
    self.siegeMainPanelInfo = message
    if message then
        if message.union and message.union.leader then
            self.TheFirstThreeRidList[1] = message.union.leader
            for i = 1, table.count(message.union.deputys) do
                self.TheFirstThreeRidList[i + 1] = message.union.deputys[i]
            end
            self:StartReqOtherPlayerData()
        end
        SL:onLUAEvent(LUA_EVENT_ROLAND_SIEGE_MAIN_PANEL_CHANGE)
    end
end

---响应罗兰攻城战副本阶段
function this:RES_ROLAND_SEIGE_STATE(id,message)
    self.siegeStateInfo = nil
    if message then
        self.siegeStateInfo = message
        SL:onLUAEvent(LUA_EVENT_ROLAND_SIEGE_STATE_INFO_CHANGE)
    end
end

---响应罗兰攻城战任务面板信息
function this:RES_ROLAND_SEIGE_TASK_PANEL(id,message)
    if message then
        self.siegeTaskInfo = message
        SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,true)
        
        SL:onLUAEvent(LUA_EVENT_ROLAND_SIEGE_TASK_INFO_CHANGE)
    end
end

---响应罗兰攻城战占领进度
function this:RES_ROLAND_PROGRESS_INFO(id,message)
    self.rolandProgressInfo = nil
    if not message then
        return
    end
    self.rolandProgressInfo = message
    SL:onLUAEvent(LUA_EVENT_ROLAND_SIEGE_ROLAND_PROGRESS_INFO_CHANGE)
end

---响应罗兰攻城战地图怪物信息
function this:RES_ROLAND_MONSTER_LIST(id,message)
    self.monsterList = {}
    if not message then
        return
    end
    self.monsterList = message
    SL:onLUAEvent(LUA_EVENT_ROLAND_SIEGE_ROLAND_MONSTER_LIST_CHANGE)
end

---设置玩家头上标识
---@param id number @玩家id
---@param pkValue number @战斗模式
---@param position number @职位
function this:SetRoleHeadIcon(id,pkValue,position)
    if self:IsMap() then
        local tagStr = ""
        if pkValue == EPKMode.Attack then
            if position == EUnionPosition.Leader then
                tagStr = EHeadIconTag.siege_atkBig
            else
                tagStr = EHeadIconTag.siege_atk
            end
        elseif pkValue == EPKMode.Defend then
            if position == EUnionPosition.Leader then
                tagStr = EHeadIconTag.siege_defBig
            else
                tagStr = EHeadIconTag.siege_def
            end
        end
        SL:SetMetaValue(EMetaVarSetKey.SET_ROLE_HEAD_ICON,id,tagStr)
    end
end

---开始请求玩家装备数据
function this:StartReqOtherPlayerData(isEvent)
    if self.TheFirstThreeRidList[self.reqOtherPlayerDataIndex] then
        self.startReqOtherPlayerData = true
        ---自己的话不用请求
        if self.TheFirstThreeRidList[self.reqOtherPlayerDataIndex] == SL:GetMetaValue(EMetaVarGetKey.UID) then
            local equip = {}
            local meData = SL:MeData_GetRoleExtInfo()
            if meData and meData.roleInfoExtData and meData.roleInfoExtData.equip then
                equip = meData.roleInfoExtData.equip
            end
            self.TheFirstThreeRankDataList[self.reqOtherPlayerDataIndex] =
            {
                role = 
                {
                    name = SL:GetMetaValue(EMetaVarGetKey.USER_NAME), 
                    roleInfoExt = {equip=equip},
                    career = SL:MeData_GetCareer()
                }
            }
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
            SL:onLUAEvent(LUA_EVENT_REQ_SIEGE_UNION_PLAYER_END)
        end
    end
end

---获取盟主副盟主的数据
---@param index number @名次
function this:GetTheFirstThreeRankData(index)
    return self.TheFirstThreeRankDataList[index]
end

---获取占领战盟名字
function this:GetOccupyUnionName()
    if self.siegeMainPanelInfo.union and self.siegeMainPanelInfo.union.name then
        return self.siegeMainPanelInfo.union.name
    end
    return ""
end

---攻城战是否开启 判断加入战盟的条件
function this:GetIsOpen()
    local activityInfo = InfoManager.activityPreviewInfo:GetActivityInfo(16001)
    if not activityInfo then
        return false
    end
    
    local binFengActivity = InfoManager.activityPreviewInfo:GetInActivityInfo(28001)
    if binFengActivity and binFengActivity.status == 0 then
        return false
    end
    
    return activityInfo.open or binFengActivity.status == 1
end
---罗兰攻城战是否开启
function this:GetLoranIsOpen()
    local activityInfo = InfoManager.activityPreviewInfo:GetActivityInfo(16001)
    if not activityInfo then
        return false
    end
    return activityInfo.open 
end
---攻城战下次开启时间
function this:GetNextOpenTime()
    return self.siegeMainPanelInfo.nextTime
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
    self.isInCopy = false
    self.monsterList = {}
    self.siegeTaskInfo = nil
    self.rolandProgressInfo = nil
    self.siegeStateInfo = nil
    self.siegeMainPanelInfo = {}
    self.TheFirstThreeRankDataList = {}
    self.TheFirstThreeRidList = {}
    self.reqOtherPlayerDataIndex = 1
    self.startReqOtherPlayerData = false
end 
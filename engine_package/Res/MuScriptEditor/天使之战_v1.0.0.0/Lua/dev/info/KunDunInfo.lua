---@class KunDunInfo
KunDunInfo = class()
local this = KunDunInfo

function this:ctor()

end

function this:Reset()
    self.data = nil
    self.KunDunInfo={}
    self.kunDunFaction = {}
    self.team_rankList = {}
    self.team_message = {}
end

function this:Init()
    self.KunDunInfo={}
    self.kunDunFaction = {}
    self.team_rankList = {}
    self.team_message = {}
    self:RegistMessages()
end

function this:ResetFaction()
    self.kunDunFaction = {}
    self.team_rankList = {}
    self.team_message = {}
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_KUN_DUN_AUCTION_PANEL_INFO,self.RES_KUN_DUN_AUCTION_PANEL_INFO,self)      -- 响应昆顿竞拍面板信息
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PLAYER_ENTER_VIEW_INFO, self.RES_PLAYER_ENTER_VIEW_INFO, self)            -- 响应玩家进入视野
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_KUN_DUN_AUCTION_BUY_RESULT,self.RES_KUN_DUN_AUCTION_BUY_RESULT,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_KUN_DUN_PANEL_INFO, self.RES_KUN_DUN_PANEL_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE,self.RES_QUIT_SUCCESS, self)                                     -- 退出副本回包
    
    SL:RegisterLUAEvent(LUA_EVENT_CREATE_PLAYER_SUCCESS, self.Update_Player_Head , self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_SETTING_INFO ,self.LUA_EVENT_ROLE_SETTING_INFO, self)
end

-- 响应昆顿竞拍面板信息
function this:RES_KUN_DUN_AUCTION_PANEL_INFO(_,_data)
   if _data and _data.isOpen and _data.goods then
        local all_list = {}
        for k, v in pairs(_data.goods) do
           table.insert(all_list,v)
        end
        table.sort(all_list,function(a,b)
            return  tonumber(a.id) < tonumber(b.id)
        end)
        self.data = {goods=all_list,isOpen=_data.isOpen}
    else
        self.data = nil
    end
end

function this:RES_KUN_DUN_AUCTION_BUY_RESULT(_,message)
    if  message.goods then
        -- SL:LogError("RES_KUN_DUN_AUCTION_BUY_RESULT")
        -- SL:LogTable(message,true)
        self:UpdateOneInfo(message.goods)
    end
end

function this:UpdateOneInfo(one_data)
    if self.data and self.data.goods then
        for i = 1, #self.data.goods, 1 do
            if self.data.goods[i].id == one_data.id then
                self.data.goods[i] = one_data
                break
            end
        end
    end
end
local faction_list = {"巨龙阵营","猎鹰阵营","苍狼阵营"}
function this:RES_KUN_DUN_PANEL_INFO(_,message)
    SL:SetCampNameList(faction_list)
    SL:SetIsShowRoleTitle(true)
    -- --SL:LogError("SET_PKMODE--01--")
    -- SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, EPKMode_Out.Camp_out)
end

-- 响应玩家进入视野
function this:RES_PLAYER_ENTER_VIEW_INFO(_,message)
    --SL:LogTable(message,true)
    if message.kunDunFaction then
        self.kunDunFaction[message.rid] = message.kunDunFaction
        local rank = self:GetFactionRank(message.kunDunFaction)
        -- SL:LogError(message.rid)
        -- SL:LogError(message.kunDunFaction)
        -- SL:LogError(rank)
        SL:SetRoleActivityCamp(tonumber(message.rid),message.kunDunFaction,rank)
    end
end

function this:RES_QUIT_SUCCESS(_,message)
    --退出昆顿后去掉头顶阵营显示
    if message == EActivityType.QuintonInvasion then
        self:ResetFaction()
        SL:SetCampNameList({})
        SL:SetIsShowRoleTitle(false)
    end
end

function this:KunDunTrade_IsOpen()
    if self.data and self.data.isOpen then
        local server_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        if self.data.goods then
            for k, v in ipairs(self.data.goods) do
                if v.endTime > server_time then
                    return true
                end
            end
        end
    end
    return false
end

--- 筛选跨服拍卖物品 
function this:KunDunTrade_GetInfo(select_type,sub_type,sortType,careerType)

    local jinengshu = 3
    local select_list = {}
    if self.data and self.data.isOpen then
        local server_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        if self.data.goods then
            for k, v in ipairs(self.data.goods) do
                if v.endTime > server_time then
                    local is_add = false
                    if not select_type then
                        is_add = true
                    elseif select_type == jinengshu then
                        local item = SL:GetConfig("cfg_stall",v.cfgid)
                        if item.type == jinengshu then
                            is_add = true
                        end
                    else
                        local item = SL:GetConfig("cfg_stall",v.cfgid)
                        if item.type == select_type and item.subType == sub_type then
                            is_add = true
                        end
                    end
                    if is_add then
                        if careerType ~= 0 then 
                            local job = SL:GetConfig("cfg_stall",v.cfgid).job
                            if careerType ~= job then
                                is_add = false
                            end
                        end
                        if is_add then
                            table.insert(select_list,v)
                        end
                    end
                end
            end
            if sortType == 1 then
                table.sort( select_list, function (a,b)
                    return a.endTime < b.endTime
                end )
            elseif sortType == 2 then
                table.sort( select_list, function (a,b)
                    return a.endTime > b.endTime
                end )
            elseif sortType == 3 then
                table.sort( select_list, function (a,b)
                    return a.fixedPrice < b.fixedPrice
                end )
            elseif sortType == 4 then
                table.sort( select_list, function (a,b)
                    return a.fixedPrice > b.fixedPrice
                end )
            end
        end
    end
    return select_list
 end

 function this:SetRankList(message)
    if message.factionRank then
        local new_data = {}
        local is_change = false
        for i = 1, 3, 1 do
            local id = tostring(i)
            if message.factionRank[id] then
                new_data[message.factionRank[id].faction] = i
            else
                break
            end
        end
        for k, v in pairs(message.factionRank) do
            if not self.team_message[k] or v.faction ~= self.team_message[k].faction then
                is_change = true
                break
            end
        end
        self.team_message = message.factionRank
        self.team_rankList = new_data
        if is_change then
            local my_rid = SL:GetMetaValue(EMetaVarGetKey.UID)
            self:Update_Player_Head(nil,my_rid)
            local player_list = SL:GetMetaValue(EMetaVarGetKey.GET_PLAYER_DATA_LIST)
            if table.count(player_list) > 0 then
                for i, v in pairs(player_list) do
                    self:Update_Player_Head(nil,v.data.id)
                end
            end
        end
        
    else
        self.team_message = {}
        self.team_rankList = {}
    end
    
end

function this:GetFactionRank(faction)
    if not self.team_rankList or not self.team_rankList[faction] then
        return 0
    end
    return self.team_rankList[faction]
end

function this:Update_Player_Head(_,rid)
    local pk_mode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
    if pk_mode ~= EPKMode_Out.Camp_out then
        return
    end
    if not self.kunDunFaction[tostring(rid)] then
        return
    end
    local faction = self.kunDunFaction[tostring(rid)] 
    local rank = self:GetFactionRank(faction)
    SL:SetRoleActivityCamp(rid,faction,rank)
end


local empty_tab = {}
function this:LUA_EVENT_ROLE_SETTING_INFO(_,message)
    --SL:LogTable(message,true)
    if message.roleSetting then
        for i, v in ipairs(message.roleSetting) do
            if v.roleSettingType == UserProtos_RoleSettingType.FIGHT_MODE then
                if v.value == EPKMode_Out.Camp_out then
                    --打开头顶阵营
                    SL:SetCampNameList(faction_list)
                    SL:SetIsShowRoleTitle(true)
                else
                    --关闭头顶阵营
                    SL:SetCampNameList(empty_tab)
                    SL:SetIsShowRoleTitle(false)
                end
                break
            end
        end
    end
end

--检查排名变化
function this:CheckRank(message)
    
end


--判断当前模式玩家之间的关系
function this:CheckPlayerRelation(pk_mode,player1,player2)
    if pk_mode == EPKMode_Out.Camp_out then
        -- SL:LogError("玩家之间的关系")
        -- SL:LogError(pk_mode)
        -- SL:LogError(bb.id)
        -- SL:LogError(cc.id)
        local faction_1 = self.kunDunFaction[tostring(player1.id)] 
        local faction_2 = self.kunDunFaction[tostring(player2.id)] 
        -- SL:LogError(faction_1)
        -- SL:LogError(faction_2)
        if faction_1 == faction_2 then
            -- SL:LogError("Friend")
            return ERelationshipType.Friend
        else
            -- SL:LogError("Enemy")
            return ERelationshipType.Enemy
        end
    end
end

--判断当前模式玩家是否不能攻击
function this:CheckPlayerAttack(message)
    local pkMode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
    if pkMode == EPKMode_Out.Camp_out then
        local my_rid = SL:GetMetaValue(EMetaVarGetKey.USER_ID)
        local faction_1 = self.kunDunFaction[my_rid] 
        local faction_2 = self.kunDunFaction[tostring(message.id)] 
        --SL:LogError("是否能被攻击"..faction_1 .. " " .. faction_2)
        if faction_1 == faction_2 then
            --SL:LogError("不攻击")
            return true
        else
            --SL:LogError("攻击")
            return false
        end
    end
end
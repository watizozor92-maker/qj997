---@class KLChallengeBossPosPanel:UIKmlLuaPanelBase
---@field view KLChallengeBossPosPanelView
local KLChallengeBossPosPanel = class(UIKmlLuaPanelBase)
local this = KLChallengeBossPosPanel
---创建时调用一次
function this:Init()
    
    GUI:DataListInitData(self.view.boss_pos_dl,function()
        return self:GoldBossPosDataListItemCountFunc()
    end,function(realIndex)
        return self:GoldBossPosDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GoldBossPosDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GoldBossPosDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.boss_Pos_all_item = {}

    GUI:DataListInitData(self.view.hurt_root_dl,function()
        return self:GoldBossHurtDataListItemCountFunc()
    end,function(realIndex)
        return self:GoldBossHurtDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GoldBossHurtDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GoldBossHurtDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.boss_Hurt_all_item = {}
    
end

function this:InitData(data)
    --SL:LogTable(data,true)
    self.mapId = data.mapId
    self.time = data.time
    self.is_close = false
    -- self.monsterInfo = data.monsterInfo
    self.show_pos = true
    self.monster1 = {}
    self.hurtList = {}
--     for i=1,10000,1 do
--         if self.monsterInfo[tostring(i)] then
--             table.insert(self.monster1,self.monsterInfo[tostring(i)])
--         else
--             break
--         end
--     end
--    GUI:DataListUpdateData(self.view.boss_pos_dl)
    self:GetBossList()
    if self.time > 0 then
        self:CopyEnd(self.time)
    end
end

function this:GetBossList()
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_SECRET_REALM_MONSTER_LIST, {mapId=self.mapId})
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    -- GUI:SetToggleOnValueChange(self.view.boss_1_toggle, self, self.Boss1Click)
    -- GUI:SetToggleOnValueChange(self.view.boss_2_toggle, self, self.Boss2Click)
    -- GUI:SetToggleOnValueChange(self.view.boss_3_toggle, self, self.Boss3Click)
    GUI:AddOnClickEvent(self.view.exitBtn,self,self.Exit)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.SECRET_REALM_DAMAGE,self.HurtChange,self)   --伤害展示
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.SECRET_REALM_BOSS_LIST,self.ResBossList,self)  --怪物列表
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.SECRET_REALM_COUNT_ZEROED,self.RecretCount,self)  --挑战次数使用后
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_SECRET_REALM,self.RES_QUIT_SECRET_REALM,self)  --退出秘境返回
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE, self.MonsterDie, self)   --怪物死亡
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_CAHNGE, self.SelectAttackRole, self)  --玩家目标改变
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
    -- SL:RegisterLuaNetMsg(LuaMessageIdToClient.SECRET_REALM_COUNT,self.SecretCount,self)
end

function this:UnRegistEvents()
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.SECRET_REALM_DAMAGE,self.HurtChange,self)   --伤害展示
    --SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.SECRET_REALM_BOSS_LIST,self.ResBossList,self)  --怪物列表
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.SECRET_REALM_COUNT_ZEROED,self.RecretCount,self)  --挑战次数使用后
    --SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_SECRET_REALM,self.RES_QUIT_SECRET_REALM,self)  --退出秘境返回
    SL:UnRegisterLUAEvent(LUA_EVENT_MONSTER_DIE, self.MonsterDie, self)   --怪物死亡
    SL:UnRegisterLUAEvent(LUA_EVENT_TARGET_CAHNGE, self.SelectAttackRole, self)  --玩家目标改变
    SL:UnRegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)  --地图改变
end

function this:Exit()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EXIT_SECRET_REALM, {repId=self.mapId})
end

--[[function this:RES_QUIT_SECRET_REALM(_id,message)
    self.is_close = true
    InfoManager.copActivityInfo.hideTask = false
    self:CloseOnclick()
    SL:onLUAEvent(LUA_EVENT_SHOW_TASK)
end]]

function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLChallengeBossPos/KLChallengeBossPosPanel")
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLChallengeBossPos/KLChallengeBossEndPanel")
    SL.ShowMainPanel()
end

--[[function this:ResBossList(_id,message)
    -- if not self.show_pos then
    --     return
    -- end
    --SL:LogTable(message,true)
    self.monster1 = {}
    for i=1,10000,1 do
        if message[tostring(i)] then
            table.insert(self.monster1,message[tostring(i)])
        else
            break
        end
    end
   GUI:DataListUpdateData(self.view.boss_pos_dl)
end]]

function this:MonsterDie(_id,message)
    -- SL:LogError("MonsterDie---------")
    -- SL:LogTable(message,true)
    if self.hateId and self.hateId~=0 and message == self.hateId then
        self:ShowPosView()
    end
end

function this:SelectAttackRole(_id,selectId)
    if not self.hateId or self.hateId==0 then
        return
    end
    -- SL:LogError("SelectAttackRole---------")
    -- SL:LogTable(selectId,true)
    -- SL:LogError(self.hateId)
    if selectId == 0 or self.hateId ~= selectId then
        self:ShowPosView()
    end
    --SL:LogTable(message,true)
end

function this:RecretCount(_id,message)
    local secretRealmCount = message.secretRealmCount
    if secretRealmCount ~= 0 then
        return
    end
    local EndPanel = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBossEnd/KLChallengeBossEndPanel")
    EndPanel:InitData()
    self.timer1 = SL:ScheduleOnce(30.2,function ()
        if self.is_close then
            return
        end
        self:Exit()
    end)
end

function this:CopyEnd(last_time)
    local EndPanel = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBossEnd/KLChallengeBossEndPanel")
    EndPanel:InitData(last_time)
    self.timer2 =SL:ScheduleOnce(last_time,function ()
        if self.is_close then
            return
        end
        self:Exit()
    end)
end


function this:ShowPosView()
    -- SL:LogError("ShowPosView-------")
    self.show_pos = true
    GUI:setVisible(self.view.pos_root,true)
    GUI:setVisible(self.view.hurt_root,false)
    self:GetBossList()
end


function this:GoldBossPosDataListItemCountFunc()
    return #self.monster1
end

function this:GoldBossPosDataListItemGetFunc(realIndex)
    local data = self.monster1[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossPosItem/KLUIChallengeBossPosItem",self.view.boss_pos_dl,self,{},true)
    self.boss_Pos_all_item[item.view.root] = item
    return item.view.root
end

function this:GoldBossPosDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:GoldBossPosDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.monster1[realIndex + 1]
    self.boss_Pos_all_item[kmlcontrol]:RefreshItem(data,self.mapId,self)
    
end


function this:GoldBossHurtDataListItemCountFunc()
    return #self.hurtList
end

function this:GoldBossHurtDataListItemGetFunc(realIndex)
    local data = self.hurtList[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossHurtItem/KLUIChallengeBossHurtItem",self.view.hurt_root_dl,self,{},true)
    self.boss_Hurt_all_item[item.view.root] = item
    return item.view.root
end

function this:GoldBossHurtDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:GoldBossHurtDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.hurtList[realIndex + 1]
    self.boss_Hurt_all_item[kmlcontrol]:RefreshItem(data,self.mapId,realIndex + 1,self)
    
end

function this:HurtChange(_id,message)
    self.show_pos = false
    GUI:setVisible(self.view.pos_root,false)
    GUI:setVisible(self.view.hurt_root,true)
    local top3 = message.top3
    self.hateId = message.monsterId
    self.hurtList = {}
    for i=1,100,1 do
        if top3[tostring(i)] then
            table.insert(self.hurtList,top3[tostring(i)])
        else
            break
        end
    end
    GUI:DataListUpdateData(self.view.hurt_root_dl)
    local my = message.my
    if my and my.name then
        self.my_name = my.name
    else
        self.my_name = SL:GetMetaValue(USER_NAME)
    end
    if my and my.rank then
        self.my_rank = my.rank
    else
        self.my_rank = 0
    end
    if my and my.hurt then
        self.my_hurt = math.floor(my.hurt)
    else
        self.my_hurt = 0
    end
    self.hurtStr = self:GetSimpleNumber(self.my_hurt,"")
    self.rank_img = self:GetRankImg(self.my_rank)
    GUI:Text_setString(self.view.my_name,self.my_name)
    GUI:Text_setString(self.view.my_value,tostring(self.hurtStr))
    GUI:Text_setString(self.view.my_ranking,tostring(self.my_rank))
    if  self.my_rank >0 and self.my_rank < 4 then
        GUI:setVisible(self.view.my_ranking_img,true)
        GUI:setVisible(self.view.my_ranking,false)
        GUI:Image_loadTexture(self.view.my_ranking_img,self.rank_img,"Atlas/UIChallengeBoss.spriteatlas")
    else
        GUI:setVisible(self.view.my_ranking_img,false)
        GUI:setVisible(self.view.my_ranking,true)
    end
end

function this:GetRankImg(rank)
    if rank == 1 then
        return "challenge_1"
    elseif rank == 2 then
        return "challenge_2"
    elseif rank == 3 then
        return "challenge_3"
    end
end

function this:GetSimpleNumber(num, places)
    if num < 10000 then
        return num
    elseif num < 100000000 then
        return string.format("%.2" .. places .. "f万", num / 10000)
    else
        return string.format("%.2" .. places .. "f亿", num / 100000000)
    end
end

function this:Close()
    self.is_close = true
    self:UnRegistEvents()
    if self.timer1 then
        SL:UnSchedule(self.timer1)
        self.timer1 = nil
    end
    if self.timer2 then
        SL:UnSchedule(self.timer2)
        self.timer2 = nil
    end
end

function this:LUA_EVENT_CHANGESCENE(_id,message)
    local map_id = message.cfgId
    local is_has = SL:HasConfig("cfg_repfairyland",map_id,"mapId")
    if not is_has then
        self:RES_QUIT_SECRET_REALM()
    end
end


return this

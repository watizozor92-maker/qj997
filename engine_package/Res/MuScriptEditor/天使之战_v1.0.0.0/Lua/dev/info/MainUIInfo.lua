---@class MainUIInfo
MainUIInfo = class()
local this = MainUIInfo

function this:ctor()

end


function this:Init()
    self:InitData()
    self:InitExpHurtData()
    self:RegistMessages()
    ---地图切线保存一份数据延迟用
    self.mapLine = nil
    self.cfgLineInfo = nil
    self.guardId = 0
    self.autoFightRecordSaveTime = 5000
    self.killMonster = 0
    self.autoUseDrug = SL:GetConfig("cfg_global",610001).value
    local autoUseDrugList = string.split(self.autoUseDrug,'#')
    local hp = tonumber(autoUseDrugList[1])
    local mp = tonumber(autoUseDrugList[2])
    SL:SetMetaValue(EMetaVarSetKey.SET_EAT_MP_PILL_PERCENTAGE,mp)
    SL:SetMetaValue(EMetaVarSetKey.SET_EAT_HP_PILL_PERCENTAGE,hp)
end

function this:InitData()
    self.experienceAddInfoList = {}
    ---@type cfg_global_column
    local tbl = SL:GetConfig("cfg_global",601)
    if tbl then
        local strList = string.split(tbl.value,"|")
        for i, v in pairs(strList) do
            local strList1 = string.split(v,"#")
            local type = tonumber(strList1[1])
            local name = strList1[2]
            local command = strList1[3]
            local needLevel = tonumber(strList1[4])
            local args = tonumber(strList1[5])
            self.experienceAddInfoList[type] = {cfgId = 0,lastCfgId = 0,type = type, needLevel = needLevel,name = name,command=command,exp = 0,endTime = 0,icon = "experienceIcon",args=args}
        end
    end
    if SL:HasConfig("cfg_global",143) then
        tbl = SL:GetConfig("cfg_global",143)
        local data = string.split(tbl.value,"|")
        self.mpType = tonumber(data[1])
        self.mpSubType = tonumber(data[2])
        self.mpPillIdList = {}
        self.mpShowModeItemId = 30010022
        data = string.split(data[3],"#")
        for i = 1, #data do
            local id_ = tonumber(data[i])
            self.mpPillIdList[id_] = id_
            self.mpShowModeItemId = id_
        end
    end

    if SL:HasConfig("cfg_global",144) then  
        tbl = SL:GetConfig("cfg_global",144)
        local data = string.split(tbl.value,"|")
        self.hpType = tonumber(data[1])
        self.hpSubType = tonumber(data[2])
        self.hpPillIdList = {}
        self.hpShowModeItemId = 30010011
        data = string.split(data[3],"#")
        for i = 1, #data do
            local id_ = tonumber(data[i])
            self.hpPillIdList[id_] = id_
            self.hpShowModeItemId = id_
        end
    end

    if SL.Head.SetHeadPartFontSize then
        local strList = string.split(SL:GetConfig("cfg_global",420001).value,"#")
        SL.Head:SetHeadPartFontSize(EHeadPart.Union_Name_Part,tonumber(strList[1]))
        SL.Head:SetHeadPartScale(EHeadPart.Union_Name_Part,tonumber(strList[2]),tonumber(strList[2]),tonumber(strList[2]))
        SL.Head:SetHeadPartPosition(EHeadPart.Union_Name_Part,0,14,0)
    end
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EXP_BONUS_INFO, self.RES_EXP_BONUS_INFO, self)
    SL:RegisterLuaNetMsg(MessageDef.ResFightResultMessage, self.ResFightResultMessage, self)
    SL:RegisterLUAEvent(MESSAGE_ACCEPT, self.MESSAGE_ACCEPT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SHORTCUTS_INFO, self.RES_SHORTCUTS_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.HORSE_LAMP, self.HORSE_LAMP, self)
    SL:RegisterLUAEvent(LUA_EVENT_ONHOOK_STATE_CHANGE,self.LUA_EVENT_ONHOOK_STATE_CHANGE,self)
    SL:RegisterTrigger(LUA_TRIGGER_GAME_RECONNECT_UI_SHOW, self.LUA_TRIGGER_GAME_RECONNECT_UI_SHOW, self)
    SL:RegisterTrigger(LUA_TRIGGER_GAME_DISPLACE_USER_UI_SHOW , self.LUA_TRIGGER_GAME_DISPLACE_USER_UI_SHOW, self)
    if LUA_EVENT_CONTROL_UI_ONCLICK then
        SL:RegisterLUAEvent(LUA_EVENT_CONTROL_UI_ONCLICK, self.UI_OnClick, self)
    end
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, self.LUA_EVENT_PLAYER_EQUIP_CHANGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DURABILITY_CHANGE, self.RES_DURABILITY_CHANGE, self)
    --SL:RegisterLUAEvent(LUA_EVENT_ME_CREATE_SUCCESS, self.LUA_EVENT_ME_CREATE_SUCCESS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ROLE_SETTINGS, self.RES_ROLE_SETTINGS, self)
    SL:RegisterLUAEvent(LUA_EVENT_ME_RELIVE, self.ResReliveMessage, self)
end
function this:HORSE_LAMP(_, message)
    if not self.isFirst and message.cfgId == 37001 then
        self.chatInfo = message
        self.isFirst = true
    end
end
function this:RES_ROLE_SETTINGS(_, message)
    if message then
        for i, v in pairs(message) do
            if tonumber(i) == ERoleSettingType_Out.autoUseDrug then
                self.autoUseDrug = v
                local autoUseDrugList = string.split(self.autoUseDrug,'#')
                local hp = tonumber(autoUseDrugList[1]) --SL:GetMetaValue(EMetaVarGetKey.GET_EAT_HP_PILL_PERCENTAGE)
                local mp = tonumber(autoUseDrugList[2])
                SL:SetMetaValue(EMetaVarSetKey.SET_EAT_MP_PILL_PERCENTAGE,mp)
                SL:SetMetaValue(EMetaVarSetKey.SET_EAT_HP_PILL_PERCENTAGE,hp)
            end
        end

    end
end
function this:RES_EXP_BONUS_INFO(id,message)
    if self.experienceAddInfoList[message.bonusType] then
        local expireTime  = tonumber(message.expireTime)
        local exp = (message.value and (expireTime > Time.GetServerTime() or expireTime<=0)) and math.floor(tonumber(message.value) / 100) or 0
        self.experienceAddInfoList[message.bonusType].lastCfgId = self.experienceAddInfoList[message.bonusType].cfgId
        self.experienceAddInfoList[message.bonusType].cfgId = tonumber(message.buffId)
        self.experienceAddInfoList[message.bonusType].exp = exp
        self.experienceAddInfoList[message.bonusType].endTime = expireTime
    end
    SL:onLUAEvent(LUA_EVENT_EXPERIENCE_ADD_CHANGE)
end

function this:Reset()
    self.isFirst = false
    for i, v in pairs(self.experienceAddInfoList) do
        v.endTime = 0
        v.exp = 0
        v.cfgId=0
    end
    self:InitExpHurtData()
    self.guardId = 0
    self.autoFightTime = nil
    self.killMonster = 0
    self.clickControl = nil
    self.lastStopTime = nil
    self.autoFightTimeClick = false
    self.autoUseDrug = SL:GetConfig("cfg_global",610001).value
    local autoUseDrugList = string.split(self.autoUseDrug,'#')
    local hp = tonumber(autoUseDrugList[1])
    local mp = tonumber(autoUseDrugList[2])
    SL:SetMetaValue(EMetaVarSetKey.SET_EAT_MP_PILL_PERCENTAGE,mp)
    SL:SetMetaValue(EMetaVarSetKey.SET_EAT_HP_PILL_PERCENTAGE,hp)
    if self.equipChangeCheck then
        SL:UnSchedule(self.equipChangeCheck)
        self.equipChangeCheck = nil
    end
    self.reliveBuyItemId = nil
end 

function this:InitExpHurtData()
    self.exp_list = {}
    self.hurt_list = {}
end

function this:ResFightResultMessage(id,message)
    local rid = SL:GetMetaValue(EMetaVarGetKey.USER_ID)
    if tonumber(rid) == message.attackerId then
        local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUIHurtExp/KLUIHurtExpPanel")
        if not panel then
            
        else
            panel:RefreshTime()
        end
        -- 去除target中targetId相同的重复数据
        local target = {}
        local processedTargetIds = {}
        for _, v in ipairs(message.target) do
            if not processedTargetIds[v.targetId] then
                table.insert(target, v)
                processedTargetIds[v.targetId] = true
            end
        end
        
        local all_hpChange = 0
        for i, v in ipairs(target) do
            all_hpChange = all_hpChange + tonumber(v.hpChange)
            if v.hp <= 0 then
                self.killMonster = self.killMonster + 1
            end
        end
        local curr_time = Time.GetServerTime()
        --self.hurt_list[time] = all_hpChange
        table.insert(self.hurt_list,{time = curr_time,hp=all_hpChange})
        self:HurtRemoveOutTime()
    end
end



--伤害统计只存5秒的
function this:HurtRemoveOutTime()
    local time = Time.GetServerTime() - 5000
    for i, one_tab in pairs(self.hurt_list) do
        local index = i
        local one_time = one_tab.time
        if one_time < time then
            table.remove(self.hurt_list, index)
        end
    end
end

---查询1秒的伤害数据，实际是5秒的平均值
function this:GetHurtNum()
    local num = 0
    for i, v in ipairs(self.hurt_list) do
        num = num + v.hp
    end
    num = math.floor(num/5)
    return num
end

local exp_str = "经验"
function this:MESSAGE_ACCEPT(id,message)
    if message then
        if message.id == 32 then
            if message.params[1] == exp_str then
                local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
                if isSafe then
                    return
                end
                local curr_time = Time.GetServerTime()
                local curr_exp = tonumber(message.params[2])
                --self.exp_list[time] = tonumber(message.params[2])
                table.insert(self.exp_list,{time=curr_time,exp=curr_exp})
                self:ExpRemoveOutTime()
            end
        end
    end
end

--经验统计存1分钟内的
function this:ExpRemoveOutTime()
    local time = Time.GetServerTime() - 60000
    for i, one_tab in pairs(self.exp_list) do
        local index = i
        local one_time = one_tab.time
        if one_time < time then
            table.remove(self.exp_list, index)
        end
    end
end

---查询1分钟的经验数据
function this:GetExpNum()
    local num = 0
    for i, v in pairs(self.exp_list) do
        num = num + v.exp
    end
    return num
end

---检查战斗是否是开启不足一分钟
function this:CheckIsStartMinute()
    -- 检查是否处于战斗状态
    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    if onHookState ~= EAutoOnHookStatus.OnHooking then
        return false
    end
    
    -- 检查是否有战斗开始时间记录
    if not self.autoFightTime then
        return false
    end
    
    -- 获取当前服务器时间
    local nowTime = SL:GetMetaValue("SERVER_TIME")
    
    -- 计算战斗持续时间（毫秒）
    local fightDuration = nowTime - self.autoFightTime
    
    -- 检查是否不足一分钟（60000毫秒）
    return fightDuration < 60000
end


function this:RES_SHORTCUTS_INFO(_, message)
    self.guardId = message.guard and message.guard or 0
    SL:onLUAEvent(LUA_EVENT_GUARD_FAST_ITEM_CHANGE)
end

function this:LUA_EVENT_ONHOOK_STATE_CHANGE(_,onHookState)
    if onHookState == EAutoOnHookStatus.OnHooking then
        local nowTime =  SL:GetMetaValue("SERVER_TIME")
        self.autoFightTimeClick = true
        if self.lastStopTime and  self.autoFightTime and nowTime - self.lastStopTime <= self.autoFightRecordSaveTime then
            local deltaTime = nowTime - self.lastStopTime
            self.autoFightTime = self.autoFightTime + deltaTime
            for _, v in pairs(self.exp_list) do
                v.time = v.time + deltaTime
            end
            for _, v in pairs(self.hurt_list) do
                v.time = v.time + deltaTime
            end
            if GUI:GetUI("dev/ui/MainUI/Panel/KLUIBossHp/KLUIBossHpPanel") == nil then
                GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLUIHurtExp/KLUIHurtExpPanel",nil,nil,{updateNow = true},false,
                                 function (temp)
                                     temp:RefreshTime()
                                 end)
            end
        else
            self.autoFightTime = nowTime
            self.killMonster = 0
            self:InitExpHurtData()
            if GUI:GetUI("dev/ui/MainUI/Panel/KLUIBossHp/KLUIBossHpPanel") == nil then
                GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLUIHurtExp/KLUIHurtExpPanel",nil,nil, nil,false,
                                 function (temp)
                                     temp:RefreshTime()
                                 end)
            end
        end
    elseif onHookState == EAutoOnHookStatus.PauseOnHook then

    elseif onHookState == EAutoOnHookStatus.StopOnHook then
        if  self.autoFightTimeClick  then
            self.autoFightTimeClick = false
            self.lastStopTime = SL:GetMetaValue("SERVER_TIME")
        end
        GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIHurtExp/KLUIHurtExpPanel")
    end
end

function this:LUA_TRIGGER_GAME_RECONNECT_UI_SHOW(cancelFunc, okFunc)
    SL:CommonTipsMessage({
        showTips = "网络已断开，是否重新连接？",
        sureBtnText = "是",
        cancelBtnText = "否",
        cancelCallBack = cancelFunc,
        callback = okFunc,
        closeCallBack = cancelFunc,
        })
    return true
end
local exitLogin = false
local exitLoginFunc
function this:LUA_TRIGGER_GAME_DISPLACE_USER_UI_SHOW(cancelFunc, okFunc)
    exitLogin = false
    exitLoginFunc = okFunc
    SL:CommonTipsMessage({
        showTips = "账号在异地登录",
        sureBtnText = "确认",
        isShowCancelBtn = false,
        cancelBtnText = "取消",
        cancelCallBack = cancelFunc,
        callback = self.ExitLogin,
        closeCallBack = self.ExitLogin,
    })
    return true
end

function this.ExitLogin()
    if exitLogin then
        return
    end
    exitLogin = true
    exitLoginFunc()
end

---@param control UIKmlLuaControl
function this:UI_OnClick(_, data)
    self.clickControl = data.selfHandle
end

--背包变化
function this:LUA_EVENT_BAG_CHANGE_AFTER()
    SL:RefreshPanelALLRedPoint("KLUIPlayerInfoPanel")
    SL:RefreshPanelALLRedStateKmlByCondition("checkBagOwnTypeItem")
end

---装备穿戴变化
function this:LUA_EVENT_PLAYER_EQUIP_CHANGE()
    if self.equipChangeCheck then
        SL:UnSchedule(self.equipChangeCheck)
        self.equipChangeCheck = nil
    end
    SL:Schedule(self.equipChangeCheck, 0, 0.1, 1, function()
        if EquipFunc.CheckHaveEquip0Durability() then
            SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_ADD, {id = PopoverType.Tip_EquipFix})
        else
            SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_DEL, PopoverType.Tip_EquipFix)
        end
    end)
end

function this:RES_DURABILITY_CHANGE()
    if EquipFunc.CheckHaveEquip0Durability() then
       SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_ADD, {id = PopoverType.Tip_EquipFix})
    else
        SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_DEL, PopoverType.Tip_EquipFix)
    end
end

function this:LUA_EVENT_ME_CREATE_SUCCESS()
    if EquipFunc.CheckHaveEquip0Durability() then
       SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_ADD, {id = PopoverType.Tip_EquipFix})
    else
        SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_DEL, PopoverType.Tip_EquipFix)
    end
end

---通知复活
---@param message MapProtos.ReliveRes
function this:ResReliveMessage(_, message)
    if message.id ~= SL:GetMetaValue(EMetaVarGetKey.UID) then
        return
    end
    SL.AudioMgr.ReviveGame()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    if mapId == 1010 then --是在恶魔广场复活
        local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
        if onHookState == EAutoOnHookStatus.StopOnHook then
            if PrivilegeCardManager.onHookType == EOnHookType.Situ then
                if not SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                    SL:StartOnHook(true,true)
                end
            end
        end
    end
end

function this:SetReliveBuyItemId(itemId)
    self.reliveBuyItemId = itemId
end

return this
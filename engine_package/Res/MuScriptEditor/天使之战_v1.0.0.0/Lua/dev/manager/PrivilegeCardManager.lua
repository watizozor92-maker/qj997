---@class PrivilegeCardManager
PrivilegeCardManager = {}
local this = PrivilegeCardManager

function this.Init()
    this.RegistEvents()
    this.all_info = {}
    this.auto_buy_drug = 0
    local cfg = SL:GetConfigTable('cfg_free_buff')
    local one_num = 1
    if cfg then
        for k, v in pairs(cfg) do
            if v.autoPick then
                one_num = v.autoPick[1]
                break
            end
        end
    end
    SL:StartFastPickUp(3, 1, 50)
    -- ---@type cfg_privilege_column
    -- this.goldCfg = SL:GetConfig("cfg_privilege", 1)
    -- ---@type cfg_privilege_column
    -- this.diamondCfg = SL:GetConfig("cfg_privilege", 2)
    this.goldPrivilege = false
    this.diamondPrivilege = false
    this.all_pricilege_id = {}
    this.message = {}



    this.goldFGPrivilege = false
    this.goldFGServerInfo = nil
    this.diamondFGPrivilege = false
    this.diamondFGServerInfo = nil
    this.AutoRepair = false

    this.new_all_info = {}
    this.new_auto_buy_drug = {}
end

function this.RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_MAP, this.LoginReq)
    SL:RegisterLUAEvent(LUA_EVENT_ONHOOK_STATE_CHANGE, this.LUA_EVENT_ONHOOK_STATE_CHANGE)
    SL:RegisterLUAEvent(LUA_EVENT_DROPITEM_OUT_OF_VIEW, this.LUA_EVENT_DROPITEM_OUT_OF_VIEW)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_REVIVE, this.LUA_EVENT_MAIN_PLAYER_REVIVE)
    SL:RegisterLUAEvent(LUA_EVENT_PICK_UP_SETTING_CHANGE, this.LUA_EVENT_PICK_UP_SETTING_CHANGE)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.SET_AUTO_BUY_POTION_RESULT, this.ResSetAutoBuy)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.CURRENT_AUTO_BUY_POTION_RESULT, this.AutoBuyStatus)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PRIVILEGE_RESULT, this.ResAllPrivilegeCardInfo)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.PRIVILEGE_INFO_TIP, this.ResCardChange)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_MONTH_PRIVILEGE_DATA, this.RES_GET_MONTH_PRIVILEGE_DATA)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PRIVILEGE_CARD_ACTIVATION, this.RES_PRIVILEGE_CARD_ACTIVATION)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_ROLE_ATTR_POINT_PROGRAMME, this.RES_GET_ROLE_ATTR_POINT_PROGRAMME)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_CHANGE_ROLE_ATTR_POINT_PROGRAMME,
        this.RES_CHANGE_ROLE_ATTR_POINT_PROGRAMME)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MONTH_PRIVILEGE_TIME_OUT, this.RES_MONTH_PRIVILEGE_TIME_OUT)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.TRIPLE_INCOME_INFO, this.TRIPLE_INCOME_INFO)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PRIVILEGE_MONTH_BUBBLE_DATA, this.RES_PRIVILEGE_MONTH_BUBBLE_DATA)
    SL:RegisterLuaNetMsg(MessageDef.ResMonsterStatusChangeMessage, this.ResMonsterStatusChangeMessage)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_CUSTOME_TRANSFER, this.RES_CUSTOME_TRANSFER)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_NO_SPEC_PRIVILEGE, this.RES_NO_SPEC_PRIVILEGE)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_AUTO_REPAIR_STATE, this.RES_EQUIP_AUTO_REPAIR_STATE)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PLAYER_PRIVILEGES, this.RES_PLAYER_PRIVILEGES)               ---新版权益
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_AUTO_BUY_POTION_SETTINGS, this.RES_AUTO_BUY_POTION_SETTINGS) --new自动买药
end

function this:RES_AUTO_BUY_POTION_SETTINGS(message)
    if message then
        this.new_auto_buy_drug = message
    end
end

function this:RES_PLAYER_PRIVILEGES(message)
    if message then
        this.new_all_info = message
    end
    if not this.isautoPick() then
        local is_open = SL:GetPlayerAutoPickIsOpen()
        if is_open then
            --去掉勾选自动范围拾取
            SL:SetPlayerAutoPick(false)
            SL:SendPlayerAutoPickChange(false)
        end
    end

    if not this.isautoRecovery() then
        local is_open = SL:CheckPlayerCanOpenAutoRecover()
        if is_open then
            --去掉勾选自动回收
            SL:SendPlayerAutoRecoverChange(false)
        end
    end
    --SL:LogTable(this.all_pricilege_id,true)
    this.CheckPriviegeBoss()
    this.ReqAutoBuyStatus()
end

function this.IsOwnerPrivilege(id)
    if this.new_all_info[tostring(id)] then
        if this.new_all_info[tostring(id)].closeTime > Time.GetServerTime() or this.new_all_info[tostring(id)].closeTime == -1 then
            return true, this.new_all_info[tostring(id)].value
        end
    end
    return false
end

function this:RES_NO_SPEC_PRIVILEGE(message)
    if message then
        if tonumber(message) == 22 then --换线
            SL:OpenCommonTipPanelById(22)
        end
        if tonumber(message) == 23 then
            SL:OpenCommonTipPanelById(23)
        end
        if tonumber(message) == 24 then
            SL:OpenCommonTipPanelById(24)
        end
        if tonumber(message) == 18 then
            SL:OpenCommonTipPanelById(18)
        end
    end
end

function this.RES_EQUIP_AUTO_REPAIR_STATE(id, message)
    this.AutoRepair = message.state
    SL:onLUAEvent(LUA_EVENT_AUTO_PAIR_STATE_CHANGE)
end

function this.Update()
    ---特权巡逻挂机，击杀黄金boss后捡完装备，去下一家
    if this.checkHaveDrop then
        local data = SL:GetMetaValue(EMetaVarGetKey.GET_MONSTER_DROP_ITEM_LIST)
        if type(data) == "table" and next(data) then
            this.checkHaveDrop = false
            this.LUA_EVENT_DROPITEM_OUT_OF_VIEW()
        else
            this.checkHaveDrop = false
            this:GetThisMapGoldBossAttack()
        end
    end
    if this.is_wait_req then
        if this.check_req_time + 100 < Time.GetServerTime() then
            local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUIPlayerInfo/KLUIPlayerInfoPanel")
            if panel then
                this.is_wait_req = false
                this.REQ_GET_MONTH_PRIVILEGE_DATA()
            end
        end
    end
end

function this.UnRegistEvents()
    SL:UnRegisterLUAEvent(LUA_EVENT_LOGIN_MAP, this.LoginReq)
end

function this.Reset()
    if this.scheduleId then
        SL:UnSchedule(this.scheduleId)
        this.scheduleId = nil
    end
    this.UnRegistEvents()
    this.new_all_info = {}
end

function this:LoginReq()
    this.all_info = {}
    this.new_all_info = {}
    this.pickupType = {}
    this.hideDiamondPopover = false
    this.hideGoldPopover = false
    this.startFindWay = false
    this.finishFindWay = false
    this.onHookType = EOnHookType.Situ
    this.goldPrivilegeStopTime = nil
    this.diamondPrivilegeStopTime = nil
    this.AutoRepair = false
    --this.ReqPrivilegeCardAllInfo()
    local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUIPlayerInfo/KLUIPlayerInfoPanel")
    if panel then
        this.is_wait_req = false
        this.REQ_GET_MONTH_PRIVILEGE_DATA()
    else
        this.is_wait_req = true
        this.check_req_time = Time.GetServerTime()
    end
    --特权功能请求买药状态
    --this.ReqAutoBuyStatus()
end

function this:RES_CUSTOME_TRANSFER()
    this.onHookType = EOnHookType.Situ
    this.patrolOnHookState = false
    this.stopPatrol = true
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SET_PATROL, EOnHookType.Situ)
end

---请求设置自动吃药
function this.ReqAutoBuyDrug()
    SL:SendLuaNetMsg(LuaMessageIdToSever.OPEN_OR_CLOSE_AUTO_BUY_POTION, {})
end

---请求设置自动吃药回包
function this.ResSetAutoBuy(_id, message)
    --SL:LogError("ResSetAutoBuy")
    this.auto_buy_drug = message.isOn
    SL:onLUAEvent(LUA_EVENT_AUTO_BUY_POTION_RESULT, {})
end

--获得当前自动购买药水状态
function this.ReqAutoBuyStatus()
    --SL:SendLuaNetMsg(LuaMessageIdToSever.GET_CURRENT_AUTO_BUY_POTION, {})
end

--获得当前自动购买药水状态回包
function this.AutoBuyStatus(_id, message)
    --SL:LogError(message.isOn)
    this.auto_buy_drug = message.isOn
    if this.AutoBuyIsOpen() then
        if not this.isautoPotion() then
            this.ReqAutoBuyDrug()
        end
    end
end

function this.AutoBuyIsOpen()
    if this.auto_buy_drug and this.auto_buy_drug == 1 then
        return true
    end
    return false
end

---获取已有的特权信息
function this.ReqPrivilegeCardAllInfo()
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_PRIVILEGES, {})
end

function this.LUA_EVENT_MAIN_PLAYER_REVIVE()
    this.REQ_GET_MONTH_PRIVILEGE_DATA()
end

function this:LUA_EVENT_PICK_UP_SETTING_CHANGE()
    this.pickupType = SL:GetMetaValue(EMetaVarGetKey.GET_ATUO_PICKUP_ITEM)
end

---获取已有的特权信息
function this.REQ_GET_MONTH_PRIVILEGE_DATA()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_MONTH_PRIVILEGE_DATA, {})
end

---获取特权项结果
function this.ResAllPrivilegeCardInfo(_id, message)
    --SL:LogError(message)
    this.all_info = message
    this.ReqAutoBuyStatus()
    this.UpdateData()
end

function this.ResCardChange(_id, message)
    if message.withstore then
        this.all_info.withstore = "0"
    end
    if message.withwarehouse then
        this.all_info.withwarehouse = "0"
    end
    if message.autopotion then
        this.all_info.autopotion = "0"
    end
    if message.autorecovery then
        this.all_info.autorecovery = "0"
    end
    if message.autopick then
        this.all_info.autopick = "0"
    end
    this.ReqAutoBuyStatus()
    this.UpdateData()
end

--[[ ---@param message table<number,PrivilegeTypeData>
 ---@class PrivilegeTypeData
 ---@field id number
 ---@field start_time number
 ---@field durationtime number 持续时长 单位小时
 ---@field timerid number
function this.RES_GET_MONTH_PRIVILEGE_DATA(_, message)
     SL:LogTable(message,true)
     --判断激活特权特殊展示
     local showType = 0
     if message then
         for i, v in pairs(message) do
             if v.id == 1 and not this.goldPrivilege then
                 --新激活黄金特权开启自动买药
                 this.ReqAutoBuyDrug()
                 showType = 1
             end

             if v.id == 2 and not this.diamondPrivilege then
                 showType = 2
            end
        end
     end

     --刷新特权信息
     this.goldPrivilege = false
     this.goldServerInfo = nil
     this.diamondPrivilege = false
     this.diamondServerInfo = nil
     if message then
         for _, v in pairs(message) do
             if v.id == 1 then
                 local time = v.start_time + v.durationtime * 3600000
                 if time > Time.GetServerTime() then
                     this.goldPrivilege = true
                     this.goldServerInfo = v
                     this.goldServerInfo["stop_time"] = time
                 end
             end

             if v.id == 2 then
                 local time = v.start_time + v.durationtime * 3600000
                 if time > Time.GetServerTime() then
                     this.diamondPrivilege = true
                     this.diamondServerInfo = v
                     this.diamondServerInfo["stop_time"] = time
                 end
             end
         end
     end
     SL:onLUAEvent(LUA_EVENT_PRIVILEGE_INFO_CHANGE, showType)
     this.CheckPriviegeBoss()
 end]]

---@param message table<number,PrivilegeTypeData>
---@class PrivilegeTypeData
---@field id number
---@field start_time number
---@field durationtime number 持续时长 单位小时
---@field timerid number
function this.RES_GET_MONTH_PRIVILEGE_DATA(_, message)
    --SL:LogTable(message,true)
    --判断激活特权特殊展示
    local is_drug = false
    local is_pick_up = false
    local is_recovery = false


    --刷新特权信息
    this.goldPrivilege = false
    this.goldServerInfo = nil
    this.diamondPrivilege = false
    this.diamondServerInfo = nil

    this.goldFGPrivilege = false
    this.goldFGServerInfo = nil
    this.diamondFGOneDayServerInfo = nil
    this.diamondFGPrivilege = false
    this.diamondFGServerInfo = nil

    this.message = message
    this.all_pricilege_id = {}

    if message then
        local diamond = false
        local diamond_one = false
        for _, v in pairs(message) do
            local time = v.start_time + v.durationtime * 3600000
            local tab = SL:GetConfig("cfg_privilege", v.id)
            local myId = SL:GetMetaValue("MAIN_ACTOR_ID")
            local buff_id = tab.buff
            local _buffText = SL:GetConfig("cfg_buff", buff_id).buffText
            if time > Time.GetServerTime() or v.durationtime == -1 then
                
                local PrivilegelList = tab.privilege
                for ii, one_id in ipairs(PrivilegelList) do
                    if not table.contains(this.all_pricilege_id, one_id) then
                        table.insert(this.all_pricilege_id, one_id)
                    end
                end
               
                --local buffChangeData = {{cfgId = 30000001,endTime = time}}
                if v.durationtime == -1 then
                    time = v.durationtime
                end
                local fuffData = {
                    updateType = 0,
                    buff = { buffTbl = { showIcon = "aa" }, cfgId = buff_id, endTime = time, buffText = _buffText },
                    roleId =
                        myId
                }
                --SL:LogTable(fuffData,true)
                SL:onLUAEvent(LUA_EVENT_BUFFCHANHE, fuffData)
            end
            if v.id == 72 then
                this.goldFGServerInfo = v
            end
            if v.id == 73 then
                this.diamondFGOneDayServerInfo = v
            end
            if v.id == 74 then
                this.diamondFGServerInfo = v
            end
            if time >= Time.GetServerTime() then
                if v.id == 72 then
                    this.goldFGPrivilege = true
                end
                if v.id == 73 then
                    diamond_one = true
                    -- this.diamondFGPrivilege = true
                end
                if v.id == 74 then
                    diamond = true
                    -- this.diamondFGPrivilege = true
                end
            else
                if v.id == 72 then
                    this.goldFGPrivilege = false
                end
                if v.id == 73 then
                    diamond_one = false
                    -- this.diamondFGPrivilege = true
                end
                if v.id == 74 then
                    diamond = false
                    -- this.diamondFGPrivilege = true
                end
            end
        end
        if diamond_one or diamond then
            this.diamondFGPrivilege = true
        else
            this.diamondFGPrivilege = false
        end
    end
    -- if not this.isautoPick() then
    --     local is_open = SL:GetPlayerAutoPickIsOpen()
    --     if is_open then
    --         --去掉勾选自动范围拾取
    --         SL:SetPlayerAutoPick(false)
    --         SL:SendPlayerAutoPickChange(false)
    --     end
    -- end
    -- if not this.isautoRecovery() then
    --     --去掉勾选自动回收
    --     SL:SendPlayerAutoRecoverChange(false)
    -- end
    -- --SL:LogTable(this.all_pricilege_id,true)
    -- this.CheckPriviegeBoss()
    -- this.ReqAutoBuyStatus()

    SL:onLUAEvent(LUA_EVENT_PRIVILEGE_INFO_CHANGE)
end

function this.RES_PRIVILEGE_CARD_ACTIVATION(_, message)
    if message then
        local id = tonumber(message)
        local PrivilegelList = SL:GetConfig("cfg_privilege", id).privilege
        if table.contains(PrivilegelList, 6) and not not table.contains(this.all_pricilege_id, 6) then
            --新激特权开启自动买药
            if not this.AutoBuyIsOpen() then
                this.ReqAutoBuyDrug()
            end
        end
        if table.contains(PrivilegelList, 16) and not not table.contains(this.all_pricilege_id, 16) then
            --新激活特权开启自动范围拾取
            local is_open = SL:GetPlayerAutoPickIsOpen()
            if not is_open then
                ---设置一下数据
                SL:SetPlayerAutoPick(true)
                ---发给服务器
                SL:SendPlayerAutoPickChange(true)
            end
        end
        if table.contains(PrivilegelList, 17) and not not table.contains(this.all_pricilege_id, 17) then
            --新激活特权开启自动回收
            local is_open = SL:GetPlayerAutoRecoverIsOpen()
            if not is_open then
                ---发给服务器
                SL:SendPlayerAutoRecoverChange(true)
            end
        end
    end
end

function this.HavePriviege()
    if this.all_pricilege_id and #this.all_pricilege_id > 0 then
        return true
    end
    return false
end

---@class freeSwitchAttrPointData
---@field id number
---@field attr table
---@field name string

---@param message RoleAttrProgrammeData
---@class RoleAttrProgrammeData
---@field current number 当前方案
---@field FreeSwitchAttrPointData table<number,freeSwitchAttrPointData>
function this.RES_GET_ROLE_ATTR_POINT_PROGRAMME(_, message)
    if message then
        this.currentAttrType = message.current or 1
        this.freeFirstSwitchInfo = message.freeSwitchAttrPointData and message.freeSwitchAttrPointData["1"] or nil
        this.freeSecondSwitchInfo = message.freeSwitchAttrPointData and message.freeSwitchAttrPointData["2"] or nil
    else
        this.currentAttrType = 1
        this.freeFirstSwitchInfo = nil
        this.freeSecondSwitchInfo = nil
    end
end

function this.RES_CHANGE_ROLE_ATTR_POINT_PROGRAMME(_, message)
    this.currentAttrType = message
end

---特权到期
-- function this.RES_MONTH_PRIVILEGE_TIME_OUT(_, message)
--     if message then
--         if message == 1 then
--             this.goldPrivilege = false
--             this.goldServerInfo = nil
--         else
--             this.diamondPrivilege = false
--             this.diamondServerInfo = nil
--         end
--     end
--     SL:onLUAEvent(LUA_EVENT_PRIVILEGE_INFO_CHANGE)
-- end

function this.RES_MONTH_PRIVILEGE_TIME_OUT(_, message)
    if message then
        if not this.message[tostring(message)] then
            return
        end
        local data = this.message[tostring(message)]
        local tab = SL:GetConfig("cfg_privilege", data.id)
        local time = data.start_time + data.durationtime * 3600000
        local myId = SL:GetMetaValue("MAIN_ACTOR_ID")
        local buff_id = tab.buff
        local _buffText = SL:GetConfig("cfg_buff", buff_id).buffText
        local fuffData = {
            updateType = 1,
            buff = { buffTbl = { showIcon = "aa" }, cfgId = buff_id, endTime = time, buffText = _buffText },
            roleId =
                myId
        }
        SL:onLUAEvent(LUA_EVENT_BUFFCHANHE, fuffData)

        this.message[tostring(message)] = nil
        this.all_pricilege_id = {}
        if this.message then
            for _, v in pairs(this.message) do
                local time = v.start_time + v.durationtime * 3600000
                if time > Time.GetServerTime() then
                    local PrivilegelList = SL:GetConfig("cfg_privilege", v.id).privilege
                    for ii, one_id in ipairs(PrivilegelList) do
                        if not table.contains(this.all_pricilege_id, one_id) then
                            table.insert(this.all_pricilege_id, one_id)
                        end
                    end
                end
            end
        end
    end
    if not this.isautoPick() then
        local is_open = SL:GetPlayerAutoPickIsOpen()
        if is_open then
            --去掉勾选自动范围拾取
            SL:SetPlayerAutoPick(false)
            SL:SendPlayerAutoPickChange(false)
        end
    end
    if not this.isautoRecovery() then
        local is_open = SL:CheckPlayerCanOpenAutoRecover()
        if is_open then
            --去掉勾选自动回收
            SL:SendPlayerAutoRecoverChange(false)
        end
    end
    this.ReqAutoBuyStatus()
    SL:onLUAEvent(LUA_EVENT_PRIVILEGE_INFO_CHANGE)
end

function this.TRIPLE_INCOME_INFO(_, message)
    if this.scheduleId then
        SL:UnSchedule(this.scheduleId)
        this.scheduleId = nil
    end
    if message then
        this.tripleEarningsInfo = message
        -- if this.tripleEarningsInfo.effectSec > 0 then
        --     this.scheduleId = SL:ScheduleOnce(this.tripleEarningsInfo.effectSec, function()
        --         SL:SendLuaNetMsg(LuaMessageIdToSever.TRIPLE_INCOME_PANEL)
        --     end)
        -- end
    end
    SL:onLUAEvent(LUA_EVENT_PRIVILEGE_INFO_CHANGE)
end

function this.RES_PRIVILEGE_MONTH_BUBBLE_DATA(_, message)
    for i, v in pairs(message) do
        if i == "1" then
            this.goldPrivilegeStopTime = v
        elseif i == "2" then
            this.diamondPrivilegeStopTime = v
        end
    end
end

function this.SetHideGoldPopover(state)
    this.hideGoldPopover = state
end

function this.SetHideDiamondPopover(state)
    this.hideDiamondPopover = state
end

function this.GetGoldPrivilegePopoverState()
    if this.hideGoldPopover then
        return false
    end
    if this.goldPrivilege then
        local gold_stop_time = SL:GetConfig("cfg_global", 14001).value
        local remind_time = this.goldServerInfo.stop_time - Time.GetServerTime()
        if remind_time < gold_stop_time * 3600000 then
            return true
        end
    else
        local gold_stop_day = SL:GetConfig("cfg_global", 14002).value
        if this.goldPrivilegeStopTime then
            local gold_stop_time = Time.GetServerTime() - this.goldPrivilegeStopTime
            if gold_stop_time < gold_stop_day * 3600000 then
                return true
            end
        end
    end
    return false
end

function this.GetDiamondPrivilegePopoverState()
    if this.hideDiamondPopover then
        return false
    end
    if this.diamondPrivilege then
        local diamond_stop_time = SL:GetConfig("cfg_global", 14001).value
        local remind_time = this.diamondServerInfo.stop_time - Time.GetServerTime()
        if remind_time < diamond_stop_time * 3600000 then
            return true
        end
    else
        local diamond_stop_day = SL:GetConfig("cfg_global", 14002).value
        if this.diamondPrivilegeStopTime then
            local diamond_stop_time = Time.GetServerTime() - this.diamondPrivilegeStopTime
            if diamond_stop_time < diamond_stop_day * 3600000 then
                return true
            end
        end
    end
    return false
end

function this.GetCurrentAttrPointPlan()
    if this.currentAttrType == 1 then
        return this.freeFirstSwitchInfo and this.freeFirstSwitchInfo.attr or nil
    else
        return this.freeSecondSwitchInfo and this.freeSecondSwitchInfo.attr or nil
    end
end

---返回毫秒值
function this.GetPrivilegeFGRemainTime(type)
    if type == 1 then
        if this.goldFGPrivilege then
            local totalTime = this.goldFGServerInfo.start_time + this.goldFGServerInfo.durationtime * 3600000
            local now = Time.GetServerTime()
            return totalTime - now
        else
            return 0
        end
    elseif type == 2 then
        if this.diamondFGPrivilege then
            local totalTime = 0
            local now = Time.GetServerTime()
            if this.diamondFGOneDayServerInfo then
                local time = this.diamondFGOneDayServerInfo.start_time +
                    this.diamondFGOneDayServerInfo.durationtime * 3600000
                if time - now > 0 then
                    totalTime = time + totalTime
                end
            end
            if this.diamondFGServerInfo then
                local time = this.diamondFGServerInfo.start_time + this.diamondFGServerInfo.durationtime * 3600000
                if time - now > 0 then
                    totalTime = totalTime + time
                end
            end
            return totalTime - now
        else
            return 0
        end
    end
end

---返回毫秒值
function this.GetPrivilegeRemainTime(type)
    if type == 1 then
        if this.goldPrivilege then
            local totalTime = this.goldServerInfo.start_time + this.goldServerInfo.durationtime * 3600000
            local now = Time.GetServerTime()
            return totalTime - now
        else
            return 0
        end
    elseif type == 2 then
        if this.diamondPrivilege then
            local totalTime = this.diamondServerInfo.start_time + this.diamondServerInfo.durationtime * 3600000
            local now = Time.GetServerTime()
            return totalTime - now
        else
            return 0
        end
    end
end

function this.SendMessageSetFreeAttrInfo(id, attr, name)
    local info
    if not id then
        id = this.currentAttrType
    end
    if id == 1 then
        info = this.freeFirstSwitchInfo or {}
    else
        info = this.freeSecondSwitchInfo or {}
    end
    local message = {}
    message["id"] = id
    if attr then
        message["attr"] = attr
    else
        message["attr"] = info.attr or {}
    end
    if name then
        message["name"] = name
    else
        message["name"] = info.name
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SET_ROLE_ATTR_POINT_PROGRAMME, message)
end

function this.ClearPrivilegeCardAllInfo()
    this.all_info = {}
    this.auto_buy_drug = 0
end

---刷新特权的时候如果某个特权没了，要把勾选取消掉
function this.UpdateData()
    if not this.isautoPick() then
        --自动拾取勾选修改
        SL:SetPlayerAutoPick(false)
        SL:SendPlayerAutoPickChange(false)
    end
    if not this.isautoRecovery() then
        local is_open = SL:CheckPlayerCanOpenAutoRecover()
        if is_open then
            --去掉勾选自动回收
            SL:SendPlayerAutoRecoverChange(false)
        end
    end
    if this.isautoPick() then
        local strList = string.split(this.all_info.autopick, '#')
        local num = tonumber(strList[1])
        local speed = tonumber(strList[2])
        SL:StartFastPickUp(num, 1, 30 * speed)
    end
end

-- function this.SendMU()
--     SL:SendLuaNetMsg(LuaMessageIdToSever.RECRUIT_INFO_REQ, {id=10002})
-- end

---是否拥有开启随身商店特权
function this.iswithStore()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(2)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,2)]]
    return false
end

---是否拥有开启野外黄金线地图
function this.isGoldLine()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(26)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,26)]]

    return false
end

---是否拥有开启野外黄金线分线
function this.isGoldLine2()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(27)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
            return false
        end
        return table.contains(this.all_pricilege_id,26)]]

    return false
end

---是否拥有开启随身仓库特权
function this.iswithWarehouse()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(13)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,13)]]

    return false
end

---是否拥有开启世界对话
function this.iswithWorld()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(24)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,24)]]

    return false
end

---是否拥有开启切线
function this.iswithLine()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(22)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,22)]]

    return false
end

---是否拥有开启自动买药特权
function this.isautoPotion()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(6)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,6)]]

    return false
end

---是否拥有开启自动回收特权
function this.isautoRecovery()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(17)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,17)]]

    return false
end

---是否拥有开启自动拾取
function this.isautoPick()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(16)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,16)]]

    return false
end

---是否拥有交易行寄售特权
function this.isSalesAdd()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(19)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,19)]]

    return false
end

---是否拥有扫荡特权
function this.isSaoDangOpen()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(20)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,20)]]
    return false
end

---是否拥有自动修理特权
function this.isAutoRepairOpen()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(25)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,25)]]

    return false
end

---是否拥有离线挂机特权
function this.isOfflineHookOpen()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(23)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,23)]]

    return false
end

function this.FreeSwitchAttrPoint()
    return this.goldPrivilege
end

---获取激活特权需要展示的背包行数
function this.GetBagCanShowRow(row)
    -- row = row or 0
    -- local lockRow = this.GetLockGridRowWithoutPrivilege()
    -- local increaseRow, gridNum = this.GetBagIncreaseRowCount()
    -- if gridNum == this.goldCfg.backpackUp + this.diamondCfg.backpackUp then
    --     return increaseRow, 0
    -- else
    --     ---获取背包道具最大占用格子数
    --     local maxItemRow = 0
    --     local bagItemList = SL:GetMetaValue("BAG_DATA")[1]
    --     for i, v in pairs(bagItemList) do
    --         local holdGrid = SL:GetConfig("cfg_item", v.cfgId).holdGrid
    --         local itemRow = holdGrid[2] + math.modf(i / 100) - 1
    --         if itemRow > maxItemRow then
    --             maxItemRow = itemRow
    --         end
    --     end
    --     if maxItemRow > increaseRow + row - lockRow then
    --         return maxItemRow - row + lockRow, maxItemRow - increaseRow - row + lockRow
    --     else
    --         return increaseRow, 0
    --     end
    -- end
end

function this.GetLockGridRowWithoutPrivilege()
    local lockGrid = SL:GetMetaValue("BAG_FORBID_COUNT")
    local privilegeGrid = this.GetBagSiftLockGridNum()
    local num = (lockGrid - privilegeGrid) / 8
    if num > 0 then
        ---有非特权格子未解锁
        return math.floor(num)
    end
    ---非特权格子全解锁
    return 0
end

---返回未解锁特权需要隐藏的格子数
function this.GetBagSiftLockGridNum()
    --local num = 0
    --if not this.goldPrivilege then
    --    num = num + this.goldCfg.backpackUp
    --end
    --if not this.diamondPrivilege then
    --    num = num + this.diamondCfg.backpackUp
    --end
    --return num
    return 0
end

---返回未开启特权减少的背包行数
function this.GetBagIncreaseRowCount()
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    local maxVet = tonumber(bag_info[2])
    local num = 0
    local girdNum = 0
    if this.goldPrivilege then
        num = num + this.goldCfg.backpackUp / maxVet
        girdNum = girdNum + this.goldCfg.backpackUp
    end
    if this.diamondPrivilege then
        num = num + this.diamondCfg.backpackUp / maxVet
        girdNum = girdNum + this.diamondCfg.backpackUp
    end
    return math.floor(num), girdNum
end

---返回特权增加特权仓库页数
function this.GetDepotUp()
    local num = 0
    if this.goldPrivilege then
        num = num + #this.goldCfg.DepotUp
    end
    if this.diamondPrivilege then
        num = num + #this.diamondCfg.DepotUp
    end
    return num
end

---返回交易行增加数量
function this.GetTradingShelvesUp()
    local num = 0
    if this.goldPrivilege then
        num = num + this.goldCfg.TradingGhelvesUp
    end
    if this.diamondPrivilege then
        num = num + this.diamondCfg.TradingGhelvesUp
    end
    return num
end

---返回经验提升
function this.GetExperienceUp()
    local num = 0
    if this.goldPrivilege then
        num = this.goldCfg.ExperienceUp
    end
    if this.diamondPrivilege then
        num = this.diamondCfg.ExperienceUp
    end
    return num
end

---返回掉落提升
function this.GetDropsUp()
    local num = 0
    if this.goldPrivilege then
        num = num + (this.goldCfg.DropsUp[2] / 100)
    end
    if this.diamondPrivilege then
        num = num + (this.diamondCfg.DropsUp[2] / 100)
    end
    return num
end

---返回回收收益提升
function this.GetReclaimUp()
    local num = 0
    if this.goldPrivilege then
        num = num + this.goldCfg.reclaimUp
    end
    if this.diamondPrivilege then
        num = num + this.diamondCfg.reclaimUp
    end
    return num
end

function this.GetFreeSwitchAttrPoint()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(7)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end
    return table.contains(this.all_pricilege_id,7)]]

    return false
end

function this.CheckPriviegeBoss()
    if this.goldPrivilege then
        this.SendPriviegeBoss(1)
    end
    if this.diamondPrivilege then
        this.SendPriviegeBoss(2)
    end
end

---通知特权boss
---@param value 活动类型 1—黄金特权卡 2—钻石特权卡 3—月卡 4-日卡
function this.SendPriviegeBoss(value)
    SL:SendLuaNetMsg(LuaMessageIdToSever.PRIVILEGE_BOSS_COUNT_INIT, value)
end

function this.isAutoPatrolOnHook()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(12)
    if isOpen then
        return true
    end
    --[[    if not this.all_pricilege_id then
        return false
    end]]
    return false --table.contains(this.all_pricilege_id,12)
end

---@param state number @1.挂机中, 2.暂停挂机, 3.停止挂机
function this.LUA_EVENT_ONHOOK_STATE_CHANGE(_, state)
    if this.onHookType == EOnHookType.Patrol then
        if state == EAutoOnHookStatus.OnHooking then
            this.patrolOnHookState = true
        elseif state == EAutoOnHookStatus.PauseOnHook then
            if this.startFindWay then
                this.patrolOnHookState = false
                this.startFindWay = false
            end
            if this.finishFindWay then
                this.finishFindWay = false
                this.patrolOnHookState = false
            end
        elseif state == EAutoOnHookStatus.StopOnHook then
            if this.startFindWay then
                this.patrolOnHookState = false
                this.startFindWay = false
            end
            if this.finishFindWay then
                this.finishFindWay = false
                this.patrolOnHookState = false
            end
        end
    end
end

---道具是否捡完可以继续巡逻
function this.LUA_EVENT_DROPITEM_OUT_OF_VIEW()
    if this.patrolOnHookState then
        local bagFull = false
        local data = SL:GetMetaValue(EMetaVarGetKey.GET_MONSTER_DROP_ITEM_LIST)
        for i, v in pairs(data) do
            if v.isMeCanPickUp then
                ---勾选自动拾取组才进行判断
                if this.pickupType and this.pickupType[v.tbl.pickgroup[1]] then
                    if SL:CanPutToBag(v.tbl.id, 1) then
                        return false
                    else
                        bagFull = true
                    end
                end
            end
        end
        if bagFull then
            SL:TipMessage(SL:GetConfig('cfg_string', 30001).text, 1, NoticeType.NoticeMid)
            ---@type KLUISystemLeftPanel
            local ui = GUI:GetUI("dev/ui/MainUI/Panel/KLUISystemLeft/KLUISystemLeftPanel")
            if ui then
                ui:OnClickAutoHookIconContainerBtn_2()
            end
        else
            this:GetThisMapGoldBossAttack()
        end
    end
end

function this.ResMonsterStatusChangeMessage(_, message)
    if this.patrolOnHookState then
        if message.monsterId == this.attackGoldBossId and message.status == 0 then
            ---把掉落物刷新出来
            SL:ScheduleOnce(1, function()
                this.checkHaveDrop = true
            end)
        elseif this.readyFindMonster then
            if message.status == 1 and this.allGoldMonsterTbl[message.configId] then
                ---等待1秒让怪物数据后台更新
                SL:ScheduleOnce(1, function()
                    this:GetThisMapGoldBossAttack()
                end)
            end
        end
    end
end

function this:RefreshPatrolHookState(state)
    if state then
        this:GetThisMapGoldBossList()
    end
end

---缓存所有巡逻boss
function this:GetAllMapGoldBossList()
    this.allGoldMonsterTbl = {}
    ---@type cfg_global_column
    local typeTbl = SL:GetConfig("cfg_global", 220001)
    if typeTbl then
        local typeStr = string.split(typeTbl.value, '#')
        local typeList = {}
        for _, v in ipairs(typeStr) do
            typeList[tonumber(v)] = true
        end
        ---@type cfg_monster_column[]
        local cfg_monster = SL:GetConfigTable("cfg_monster")
        for _, v in pairs(cfg_monster) do
            if typeList[v.type] then
                this.allGoldMonsterTbl[v.id] = v
            end
        end
    else
        ---@type cfg_monster_column[]
        local cfg_monster = SL:GetConfigTable("cfg_monster")
        for i, v in pairs(cfg_monster) do
            if v.type == 2 then
                this.allGoldMonsterTbl[v.id] = v
            end
        end
    end
end

function this.IsCanOnHookCheck()
    if SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
        --SL:TipMessage(EAutoFightErrorTip.SafeArea, 1, NoticeType.NoticeMid)
        return false
    else
        return true
    end
end

---开始巡逻挂机
function this.StartPatrolOnHook()
    this.patrolOnHookState = false
    ---是否安全区等检测
    if this.IsCanOnHookCheck() then
        this.patrolOnHookState = true
        this.stopPatrol = false
    end
    this.pickupType = SL:GetMetaValue(EMetaVarGetKey.GET_ATUO_PICKUP_ITEM)
    return this.patrolOnHookState
end

function this.StopPatrolOnHook()
    this.patrolOnHookState = false
    --中途退出寻路标签，回调不自动打怪
    this.stopPatrol = true
    SL:Me_StopMove(true, true)
end

---获取当前地图存活黄金boss前往击杀
function this:GetThisMapGoldBossAttack()
    if not this.patrolOnHookState then
        return
    end
    this.readyFindMonster = false
    if not this.allGoldMonsterTbl or not next(this.allGoldMonsterTbl) then
        self:GetAllMapGoldBossList()
    end
    ---获取所有怪
    local mapGoldMonsterTbl = {}
    local allMonster = SL:GetMetaValue(EMetaVarGetKey.MAP_GET_MONSTERS)
    for i, v in pairs(allMonster) do
        if this.allGoldMonsterTbl[v.configId] and v.status == 1 then
            mapGoldMonsterTbl[#mapGoldMonsterTbl + 1] = v
        end
    end
    ---没有黄金怪
    if #mapGoldMonsterTbl == 0 then
        SL:TipMessage(SL:GetConfig("cfg_string", 443).text, 1, NoticeType.NoticeMid)
        ---地图没有黄金怪标识
        this.readyFindMonster = true
        return true
    end
    ---找直线距离最近的
    local playerPos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
    local attackGoldBossDistance = 99999
    local monsterId = 0
    local x, y
    for i, v in ipairs(mapGoldMonsterTbl) do
        local distance = math.abs(playerPos.x - v.pointX) + math.abs(playerPos.z - v.pointY)
        if distance < attackGoldBossDistance then
            attackGoldBossDistance = distance
            monsterId = v.configId
            x = v.pointX
            y = v.pointY
            this.attackGoldBossId = v.monsterId
        end
    end
    ---生成快捷指令
    ---@type cfg_mapMove_column[]
    local cfg_mapMove = SL:GetConfigTable("cfg_mapMove")
    local mapMoveId
    for i, v in pairs(cfg_mapMove) do
        if v.mapID == SL:GetMetaValue(EMetaVarGetKey.MAP_ID) then
            mapMoveId = v.id
            break
        end
    end
    local param = {}
    param[1] = "moveTo"
    param[2] = mapMoveId
    param[3] = x
    param[4] = y
    ---是否到达寻路终点，用于是否处于巡逻挂机判断
    this.finishFindWay = false
    local moveToArriveCallBack = function()
        if not this.stopPatrol then
            --AutoFightManager.StartAutoFight(false, true, monsterId)
            if not SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                SL:StartOnHook(false, true, monsterId)
            end
        end
        this.stopPatrol = false
        this.startFindWay = false
        this.finishFindWay = true
    end
    this.startFindWay = false
    SL:ShortcutDO(param, nil, nil, moveToArriveCallBack)
    ---是否开始寻路，用于是否处于巡逻挂机判断
    this.startFindWay = true
end

function this.haveSomeonePrivilege(key)
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(key)
    if isOpen then
        return true
    end
    return false
end

function this:GetTaxRate()
    local isOpen, value = PrivilegeCardManager.IsOwnerPrivilege(21)
    local taxRateStr = SL:GetConfig("cfg_global", 37).value
    local taxRate = string.split(taxRateStr, '#')
    if isOpen then
        return value
    end
    return tonumber(taxRate[1])
    --[[    if table.isNullOrEmpty(this.message) then
        return tonumber(taxRate[1])
    end
    local privilegeCard = {}
    for k, v in pairs(this.message) do
        local privilege = SL:GetConfig("cfg_privilege", v.id)
        if privilege then
            table.insert(privilegeCard, privilege.minType)
        end
    end

    if table.contains(privilegeCard, 3) then
        return tonumber(taxRate[4])
    elseif table.contains(privilegeCard, 2) then
        return tonumber(taxRate[3])
    elseif table.contains(privilegeCard, 1) then
        return tonumber(taxRate[2])
    end]]
end

return this

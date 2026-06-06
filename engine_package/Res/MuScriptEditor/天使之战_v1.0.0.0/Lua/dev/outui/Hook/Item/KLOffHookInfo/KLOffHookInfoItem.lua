---@class KLOffHookInfoItem:UIKmlLuaPanelBase
---@field view KLOffHookInfoItemView
local KLOffHookInfoItem = class(UIKmlLuaPanelBase)
local this =KLOffHookInfoItem
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLOffHookInfoItem",true)
    GUI:setVisible(self.view.Exp, false)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OFFLINE_ON_HOOK_INFO)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnHelp, self, self.ShowHookTips)
    GUI:AddOnClickEvent(self.view.receiveExpBtn, self, self.ReqReceiveExpBtnOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OFFLINE_ON_HOOK_INFO, self.RES_OFFLINE_ON_HOOK_INFO, self)
end

---duration——离线挂机时长（单位秒）
--fightDuration——打怪时长（单位秒）
--fightExp——打怪获得的经验
--freeDuration——泡点时长（单位秒）
--freeExp——泡点经验
--logInfo——离线挂机日志信息
--pickUpItems——离线挂机拾取的道具
function this:RES_OFFLINE_ON_HOOK_INFO(_, message)
    -- SL:LogTable(message,true)
    --挂机信息
    GUI:Text_setString(self.view.txtOffline, SL:SecondToHMS(message.duration,true))
    GUI:Text_setString(self.view.txtFightMonsterExp, tostring(message.fightExp))
    GUI:Text_setString(self.view.txtFightMonsterTime, SL:SecondToHMS(message.fightDuration,true))
    
    GUI:Text_setString(self.view.txtBubbleTime, SL:SecondToHMS(message.freeDuration,true))
    GUI:Text_setString(self.view.txtBubbleExp, tostring(message.freeExp))
    
    GUI:SetActive(self.view.bubbleExpTitleTxt,false)
    GUI:SetActive(self.view.txtBubbleTime,false)
    GUI:SetActive(self.view.bubbleTimeTitleTxt,false)
    GUI:SetActive(self.view.txtBubbleExp,false)
    
    GUI:Text_setString(self.view.totleExp, tostring(message.totalExp))
    GUI:setVisible(self.view.Exp, tonumber(message.totalExp) > 0 and message.receiveExp == false)
    --处理日志信息
    local logInfo = message.logInfo
    ---@type cfg_item_column[]
    local cfgs = {}
    local strList = {}
    local sortList = {}
    for k, v in pairs(logInfo.recoveredMoneyAmountMap) do
        for id, num in pairs(v) do
            if not cfgs[id] then
                cfgs[id] = SL:GetConfig("cfg_item", tonumber(id))
            end
            local time = tonumber(k)
            local str = string.format("%s 本次离线挂机自动回收获得%s*%s\n", self:FormatTime(time),cfgs[id].name, num)
            table.insert(strList, str)
            sortList[str] = time
        end
    end
    for k, v in pairs(message.pickUpItems) do
        for id, num in pairs(v) do
            if not cfgs[id] then
                cfgs[id] = SL:GetConfig("cfg_item", tonumber(id))
            end
            local time = tonumber(k)
            local str = string.format("%s 本次离线挂机拾取%s*%s\n", self:FormatTime(time),cfgs[id].name, num)
            table.insert(strList, str)
            sortList[str] = time
        end
    end
    for k, v in pairs(logInfo.pickupMoneyAmountMap) do
        for id, num in pairs(v) do
            if not cfgs[id] then
                cfgs[id] = SL:GetConfig("cfg_item", tonumber(id))
            end
            local time = tonumber(k)
            local str = string.format("%s 本次离线挂机拾取%s*%s\n", self:FormatTime(time),cfgs[id].name, num)
            table.insert(strList, str)
            sortList[str] = time
        end
    end
    for k, v in pairs(logInfo.killedInfoMap) do
        for id, name in pairs(v) do
            ---@type cfg_map_info_column
            local cfg = SL:GetConfig("cfg_map_info", tonumber(id))
            local time = tonumber(k)
            local str = string.format("%s 在%s被%s击杀\n", self:FormatTime(time), cfg.mapname, name)
            table.insert(strList, str)
            sortList[str] = time
        end
    end

    if not table.isNullOrEmpty(message.openBubbleMap) then
        for k, v in pairs(message.openBubbleMap) do
            ---@type cfg_map_info_column
            local cfg = SL:GetConfig("cfg_map_info", v)
            local time = tonumber(k)
            local str = string.format("%s <color=#FFFFFF>在%s开启泡点\n</color>", self:FormatTime(time), cfg.mapname)
            table.insert(strList, str)
            sortList[str] = time
        end
    end
    if message.timeout then
        ---@type cfg_global_column
        local global = SL:GetConfig("cfg_global", 6001)
        local hookTime = tonumber(global.value) // 60
        local time = tonumber(message.timeout)
        local str_ = string.format("%s <color=#FF2323>离线收益累计已达%s小时</color>，再次登录可重新获得离线收益\n", self:FormatTime(time), hookTime)
        table.insert(strList, str_)
        sortList[str_] = time
    end
    --按照时间排序
    table.sort(strList, function(a, b)
        if sortList[a] and sortList[b] then
            return sortList[a] > sortList[b]
        end
    end)
    local resStr = table.concat(strList) or ""
--[[    if resStr ~= "" then
        string.replace(resStr, " ", "\\u3000")
    end]]
    GUI:Text_setString(self.view.logInfoTxt, resStr)
end 

function this:ReqReceiveExpBtnOnClick()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECEIVE_OFFLINE_ON_HOOK_EXP)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OFFLINE_ON_HOOK_INFO)
end

function this:ShowHookTips()
    local tbl = SL:GetConfig("cfg_rule_text", 9)
    SL:CommonStrTipsMessage({str = tbl.location, title="提示"})
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
    SL:KeepOpenPanel("KLOffHookInfoItem",false)
end

function this:FormatTime(time)
    return os.date("<color=#BFAB9B>%m-%d %H:%M:%S</color>", math.floor(time / 1000))
end

return this

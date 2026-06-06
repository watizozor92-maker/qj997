---@class KLHorseRaceLampPanel:UIKmlLuaPanelBase
---@field view KLHorseRaceLampPanelView
---@field HorseRaceLamplist table 跑马灯队列
---@field damage string 伤害
---@field exp string 经验
---@field defaultPos
---@field StationaryStr string[]
local KLHorseRaceLampPanel = class(UIKmlLuaPanelBase)
local this = KLHorseRaceLampPanel
local MAXBGWidth = 860 --文本背景最大宽度
local grayColors = "#7F621A"
--local NpcPerId = 65001  ---特殊处理公告id
---创建时调用一次
function this:Init()
    self.scrollTimers = {}
    --self.NpcPerIdTimer = nil
    SL:KeepOpenPanel("KLHorseRaceLampPanel", true)
    self.isFirstTips = true
    self.isFirstTips_2 = true
    -- 盒子服务端过来的信息无法走表，策划要求写死配置(跑马灯)
    self.BoxHorse = {
        id = -1,
        description = "",
        name = "",
        messageType = { 1 },
        receiver = 3,
        textColor = "255",
        rollSpeed = 10000,
        text = "",
        subType = "系统",
        condition = { { 1, 1 } },
        backgroundColor = "0",
        transparencyB = 40,
        transparencyT = 0,
        textSize = 20,
        offsetX = 0,
        offsetY = 0,
        rollCount = 0,
        releaseEffect = {},
        ShowDuration = 0,
        order = 0
    }
    -- 盒子服务端过来的信息无法走表，策划要求写死配置(聊天框)
    self.BoxChat = {
        id = -2,
        description = "",
        name = "",
        messageType = { 7 },
        receiver = 3,
        textColor = "255",
        rollSpeed = 10000,
        text = "",
        subType = "系统",
        condition = { { 1, 1 } },
        backgroundColor = "0",
        transparencyB = 40,
        transparencyT = 0,
        textSize = 20,
        offsetX = 0,
        offsetY = 0,
        rollCount = 0,
        releaseEffect = {},
        ShowDuration = 0,
        order = 0
    }
    self.index = 0
    self.stationaryImgList = { self.view.stationary_img1, self.view.stationary_img2, self.view.stationary_img3, self
            .view.stationary_img4 }
    self.stationaryTextList = { self.view.stationary_text1, self.view.stationary_text2, self.view.stationary_text3, self
            .view.stationary_text4 }
    self.stationaryBtnList = { self.view.stationary_imgBtn1, self.view.stationary_imgBtn2, self.view.stationary_imgBtn3, self.view.stationary_imgBtn4 }
    self.scrollDo = {}

    if SL:HasConfig("cfg_global", 290004, "id") then
        grayColors = SL:GetConfig("cfg_global", 290004, "id").value
    end
end

function this:AddData(str)
    self.index = self.index + 1
    local pos = self.index
    if self.index > 4 then
        local pos = self.index % 4
        if pos == 0 then
            pos = 4
        end
        GUI:setLocalZOrder(self.stationaryImgList[pos], 4)
        self:StationaryDataUpdateFunc(pos - 1, str)
    else
        self:StationaryDataUpdateFunc(pos - 1, str)
    end
    return
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.StationaryStr = {}
    self.HorseRaceLamplist = {}
    self:ResetScrollStates()
    GUI:SetActive(self.view.HorseRaceLampBG, false)

    self:InitArchangelExp()
    if InfoManager.mainUIInfo.chatInfo then
        self:Message(nil,InfoManager.mainUIInfo.chatInfo)
        InfoManager.mainUIInfo.chatInfo = nil
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.HORSE_LAMP, self.Message, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.CHAT, self.CHAT_NOTICE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.OTHER_NOTICE, self.MessageType, self)
end

---@param message {id:number,contentFromServer:boolean ,content:string 缺省则读表, params:string[]
function this:Other(message, type)
    local tbl
    if message.id == -1 then
        tbl = self.BoxHorse
    elseif message.id == -2 then
        tbl = self.BoxChat
    else
        tbl = SL:GetConfig("cfg_string", message.id, "id")
    end
    if string.isNullOrEmpty(message.content) then
        message.content = tbl.text
    end
    if tbl.messageType[1] == 12 then
        self:DamageEXP(message.id, message.content)
        return
    elseif tbl.messageType[1] == 18 then
        self:Stationary(message.id, message.content)
        return
    end

    for key, value in pairs(OutHorseRaceType) do
        if tbl.messageType[1] == value then
            --self:AddHorseRaceLamplist(message)
            if message.isServer ~= nil then
                self:Stationary(message.id, message.content, message.isServer)
            else
                self:Stationary(message.id, message.content, true)
            end
            return
        end
    end
end

function this:CHAT_NOTICE(_, message)
    local content = message.content
    content = string.gsub(content, "\\n", "")
    content = string.gsub(content, "\n", "")
    SL:onLUAEvent(LUA_EVENT_CHAT_RECEIVE_NOTICE, {
        message = content,
        channel = message.channel,
        itemList = message.itemList,
    })
end

function this:Message(_, data)
    local HorseRaceLampData = {
        id = tonumber(data.cfgId or data.id),
        content = data.content,
        contentFromServer = true
    }
    local tbl
    if HorseRaceLampData.id == -1 then
        tbl = self.BoxHorse
    elseif HorseRaceLampData.id == -2 then
        tbl = self.BoxChat
    end
    SL:MessageTip(HorseRaceLampData)
end

--内置跑马灯无法满足策划要求，外置重做
function this:AddHorseRaceLamplist(data)
    GUI:setVisible(self.view.HorseRaceLampBG, true)
    GUI:SetZIndex(self.view.HorseRaceLampBG, 0)
    local userid = SL:GetMetaValue("USER_ID")
    local level = SL:GetMetaValue("ACTOR_LEVEL", userid)
    local tbl
    if data.id == -1 then
        tbl = self.BoxHorse
    elseif data.id == -2 then
        tbl = self.BoxChat
    else
        tbl = SL:GetConfig("cfg_string", data.id, "id")
    end
    if data.contentFromServer == false then
        data.content = tbl.text
    end
    if tbl then
        local Marquees = {
            data = data,
            tbl = tbl,
            time = SL:GetMetaValue("SERVER_TIME")

        }
        if table.count(tbl.messageType) == 1 then
            table.insert(self.HorseRaceLamplist, Marquees)
            table.sort(self.HorseRaceLamplist, function(a, b)
                return a.tbl.order > b.tbl.order
            end)
        end
    end
    if not self.HorseRaceLampCoroutine then
        self.HorseRaceLampCoroutine = Coroutine.Start(self.HorseRaceLampFunc, self)
    end
end

function this:HorseRaceLampFunc()
    local current
    while table.count(self.HorseRaceLamplist) > 0 do
        current = self.HorseRaceLamplist[1]
        local time = SL:GetMetaValue("SERVER_TIME")
        local timeColumn = time - current.time
        local doTime = 0
        timeColumn = timeColumn / 1000
        if timeColumn >= 30 then
            Coroutine.WaitForEndOfFrame()
        else
            GUI:SetActive(self.view.HorseRaceLampBG, true)
            GUI:setPosition(self.view.HorseRaceLampBG, 0, -230 + current.tbl.offsetY)
            local colorTbl = SL:GetConfig("cfg_color", tonumber(current.tbl.textColor), "id")
            if colorTbl then
                GUI:Text_setTextColor(self.view.HorseRaceLamp, colorTbl.color)
            else
                GUI:Text_setTextColor(self.view.HorseRaceLamp, "#000000")
            end

            local textsize = current.tbl.textSize
            if textsize then
                GUI:Text_setFontSize(self.view.HorseRaceLamp, tonumber(textsize))
            end
            GUI:Text_setString(self.view.HorseRaceLamp, current.data.content)
            local x, y = GUI:getSizeDelta(self.view.HorseRaceLamp)

            GUI:setContentSize(self.view.HorseRaceLampBG, x + 50, y + 10)
            GUI:setContentSize(self.view.scroll, x + 100, y + 20)
            GUI:setContentSize(self.view.HorseRaceLampLayout, x + 10, y + 10)
            GUI:setPosition(self.view.HorseRaceLamp, 0, 0)

            local ax, ay, az = GUI:GetWorldPosition(self.view.scroll)
            GUI:setContentSize(self.view.HorseRace, x + 120, y + 30)
            GUI:setPosition(self.view.HorseRace, 0, 0)

            local isMove = true
            if current.tbl.messageType[1] == 1 or current.tbl.messageType[1] == 17 then
                GUI:setPositionX(self.view.HorseRaceLampLayout, x + 100)
            elseif current.tbl.messageType[1] == 2 then
                GUI:setPositionX(self.view.HorseRaceLampLayout, -(x + 100))
            elseif current.tbl.messageType[1] == 3 then
                GUI:setPositionY(self.view.HorseRaceLampLayout, -(y + 100))
            elseif current.tbl.messageType[1] == 4 then
                GUI:setPositionY(self.view.HorseRaceLampLayout, y + 100)
            elseif current.tbl.messageType[1] == 5 then
                isMove = false
            end
            doTime = current.tbl.rollSpeed / 1000
            if isMove then
                --SL:EffectDoMove(self.view.HorseRaceLampLayout.rectTransform, Vector3.New(ax, ay, az), doTime)
                GUI:DOAnchorPos(self.view.HorseRaceLampLayout, Vector3.New(0, 0, 0), doTime)
            end

            Coroutine.Wait(1 + doTime)
        end

        GUI:SetActive(self.view.HorseRaceLampBG, false)
        table.removeByValue(self.HorseRaceLamplist, current)
    end
    GUI:setVisible(self.view.HorseRaceLampBG, false)
    self.HorseRaceLampCoroutine = nil
end

function this:MessageType(_, message)
    local tbl = SL:GetConfig("cfg_string", message.cfgId, "id")
    local data
    if tbl.messageType == 12 then
        self:DamageEXP(message.cfgId, message.content)
    elseif tbl.messageType == 18 then
        self:Stationary(message.cfgId, message.content)
    elseif tbl.messageType == 17 then
        data = {
            id = tonumber(message.cfgId),
            content = message.content,
            contentFromServer = true
        }
        self:AddHorseRaceLamplist(message)
    else
        data = {
            id = tonumber(message.cfgId),
            content = message.content,
            contentFromServer = true
        }
        SL:MessageTip(data)
    end
end

--伤害经验显示内置无法使用，外置重做
function this:DamageEXP(cfgId, content)
    local tbl = SL:GetConfig("cfg_string", 105, "id")
    if tonumber(cfgId) == 105 then
        --秒伤
        local colorTbl = SL:GetConfig("cfg_color", tonumber(tbl.textColor), "id")
        local color = colorTbl and colorTbl.color or "#FFFFFF"
        self.damage = "<color=" .. color .. "><size=" .. tbl.textSize .. " >" .. content .. "</size></color>"
        self:DamageTip()
    elseif tonumber(cfgId) == 106 then
        --分钟经验
        local colorTbl = SL:GetConfig("cfg_color", tonumber(tbl.textColor), "id")
        local color = colorTbl and colorTbl.color or "#FFFFFF"
        self.exp = "<color=" .. color .. "><size=" .. tbl.textSize .. " >" .. content .. "</size></color>"
        self:EXPTip()
    end
end

function this:DamageTip()
    local str = self.damage
    if self.expTimeID then
        str = self.exp .. "\n" .. str
    end
    if self.damageTimeID then
        SL:UnSchedule(self.damageTimeID)
    end
    self.damageTimeID = SL:ScheduleOnce(1, function()
        self:HideDamage()
    end)
    self:RefreshDamageEXP(str)
end

function this:EXPTip()
    local str = self.exp
    if self.damageTimeID then
        str = str .. "\n" .. self.damage
    end
    if self.expTimeID then
        SL:UnSchedule(self.expTimeID)
    end
    self.expTimeID = SL:ScheduleOnce(1, function()
        self:HideEXP()
    end)
    self:RefreshDamageEXP(str)
end

function this:RefreshDamageEXP(str)
    --刷新
    if not GUI:getVisible(self.view.DamageEXPBG) then
        --打开
        GUI:setVisible(self.view.DamageEXPBG, true)
    end
    -- 设置文字

    GUI:Text_setString(self.view.DamageEXPText, str)
    local x, y = GUI:getSizeDelta(self.view.DamageEXPText)
    GUI:setContentSize(self.view.DamageEXPBG, x + 150, y + 10)
    GUI:setPosition(self.view.DamageEXPText, 0, 0)
end

function this:HideDamage()
    self.damageTimeID = nil
    self.damage = nil
    if self.exp == nil then
        GUI:setVisible(self.view.DamageEXPBG, false)
    end
end

function this:HideEXP()
    self.expTimeID = nil
    self.exp = nil
    if self.damage == nil then
        GUI:setVisible(self.view.DamageEXPBG, false)
    end
end

function this:Stationary(cfgId, str, isServer)
    GUI:setVisible(self.view.stationary, true)
    GUI:SetZIndex(self.view.stationary, 1)
    GUI:setScale(self.view.stationary, 0.6)
    if cfgId ~= 37001 and ((self.isFirstTips_2 and self.isFirstTips) or self.isFirstTips == false) then
        
--[[
        if #self.StationaryStr >= 4 then
            table.remove(self.StationaryStr, 1)
]]
--[[            if #self.StationaryStr >= 4 then
                if cfgId ~= NpcPerId then
                    ----有65001元素时再来一个 保持不变
                    for i, v in pairs(self.StationaryStr) do
                        if self.StationaryStr[i].tbl.id ~= NpcPerId then
                            -- 移除第一个id非等于65001的元素
                            table.remove(self.StationaryStr, i)
                            break
                        end
                    end
                end
            end]]--[[

        end
]]

        self:AddStationary(cfgId, str, isServer)
    else
        if self.isFirstTips_2 == false then
            return
        end
        self.StationaryStrTbl = SL:GetConfig("cfg_string", cfgId, "id")
        local time = self.StationaryStrTbl.ShowDuration
        if not isServer then
            str = self.StationaryStrTbl.text
        end
        self.isFirstTips_2 = false
        local strs = string.split(str, "\n")
        
        for i = 1, #strs, 1 do
            table.insert(self.StationaryStr, { text = strs[i], tbl = self.StationaryStrTbl })
            self:StationaryDataUpdateFunc(i - 1)
        end
        
        
        self.firstTimer = SL:ScheduleOnce(time / 1000, function()
            -- 如果需要在其他地方使用这个状态，可以设置一个成员变量
            self.StationaryStr = {}
            self.isFirstTips = false
            self:StopAllScrollTimers()
            for i = 1, 4, 1 do
                if self.stationaryImgList and self.stationaryImgList[i] then
                    GUI:setVisible(self.stationaryImgList[i], false)
                end
            end
            if self.blink then
                for i, v in pairs(self.stationaryTextList) do
                    InfoManager.activityPreviewInfo:RemoveBlink(v)
                end
                self.blink = false
            end
        end)
    end
end

function this:AddStationary(cfgId, str, isServer)
    self.StationaryStrTbl = SL:GetConfig("cfg_string", cfgId, "id")
    local pattern = "\n"
    if not isServer then
        str = self.StationaryStrTbl.text
    else
        pattern = "\\n"
    end
    --local NpcStrList = {}
    local strs = string.split(str, pattern)
    if #self.StationaryStr >= 4 then
        for  pos = 1, 4, 1 do
            if pos <= #strs then
                table.remove(self.StationaryStr, 1)
            end
        end
    end
    for i, text in ipairs(strs) do
--[[        if cfgId == NpcPerId then
            ---顶置顶置65001类型
            if self.StationaryStr[i] then
                table.insert(NpcStrList, self.StationaryStr[i])
            end
            self.StationaryStr[i] = { text = text, tbl = table.copy(self.StationaryStrTbl) }
        else
            table.insert(self.StationaryStr, { text = text, tbl = table.copy(self.StationaryStrTbl) })
        end]]
        table.insert(self.StationaryStr, { text = text, tbl = table.copy(self.StationaryStrTbl) })
        --self:AddData(text)
    end
--[[    if not table.isNullOrEmpty(NpcStrList) then
        for _, v in pairs(NpcStrList) do
            if #self.StationaryStr < 4 then
                table.insert(self.StationaryStr, v)
            end
        end
    end]]
    for pos = 1, 4, 1 do
        self:StationaryDataUpdateFunc(pos - 1, nil)
    end
end

--永远闪烁
---@param spaceTime number 间隔时间
---@param times number 闪烁次数
function this:BlinkStationary(spaceTime, times)
    local grayColors = "#7F621A"
    if SL:HasConfig("cfg_global", 290004, "id") then
        grayColors = SL:GetConfig("cfg_global", 290004, "id").value
    end

    for i, v in ipairs(self.stationaryTextList) do
        InfoManager.activityPreviewInfo:AddBlink(v, self.staTextColor, grayColors, self.view["stationary_mask" .. i])
    end
    self.blink = true
end

function this:StationaryDataUpdateFunc(realIndex, str)

    local stationary_text = self.stationaryTextList[realIndex + 1]
    local img = self.stationaryImgList[realIndex + 1]
    --local Btn = self.stationaryBtnList[realIndex + 1]
    if self.StationaryStr[realIndex + 1] then
        local Str = str or self.StationaryStr[realIndex + 1].text
        GUI:setVisible(img, true)
        if SL:HasConfig("cfg_global", 290006, "id") then
            local textSize = SL:GetConfig("cfg_global", 290006, "id").value
            GUI:Text_setFontSize(stationary_text, tonumber(textSize))
        else
            GUI:Text_setFontSize(stationary_text, self.StationaryStrTbl.textSize)
        end

        local colorTbl = SL:GetConfig("cfg_color", tonumber(self.StationaryStrTbl.textColor), "id")
        if colorTbl then
            GUI:Text_setTextColor(stationary_text, colorTbl.color)
        else
            GUI:Text_setTextColor(stationary_text, "#000000")
        end

        self.staTextColor = colorTbl.color
        GUI:Text_setString(stationary_text, Str)
        local len = string.isNullOrEmpty(Str) and 0 or string.len(Str)
        -- 设置大小

        -- 检查文本是否已经滚动过

        local textX, textY = GUI:getSizeDelta(stationary_text)
        local stationaryX, stationaryY = GUI:getSizeDelta(self.view.stationary)
        GUI:setContentSize(self.view.stationary, stationaryX, stationaryY + textY + 30)

        if string.isNullOrEmpty(Str) then
            GUI:setContentSize(img, 0, 0)
        else
            GUI:setContentSize(img, textX, textY - 1.5)
            SL:ScheduleOnce(0.5, function()
                GUI:setContentSize(img, textX, textY - 1.5)
                GUI:ForceRebuildLayoutImmediate(img)
            end)
        end

        GUI:setPosition(stationary_text, 0, 0)
        --滚动
        local doTime = self.StationaryStrTbl.rollSpeed / 1000
        self:DOKillScroll(realIndex)
        GUI:setAnchorPoint(stationary_text, 0, 0)
        GUI:setPositionX(stationary_text, 0)

        if len >= 73 then
            --local rollCount = self.StationaryStrTbl.rollCount or -1 -- -1表示无限滚动
            --self:StartScrollAnimationWithTimer(stationary_text, img, doTime, rollCount, realIndex)
        else
            local timerId = realIndex
            if self.scrollTimers and self.scrollTimers[timerId] then
                SL:UnSchedule(self.scrollTimers[timerId])
                self.scrollTimers[timerId] = nil
            end
        end
        InfoManager.activityPreviewInfo:AddBlink(stationary_text, self.staTextColor, grayColors, self.view["stationary_mask" .. (realIndex + 1)])

--[[        GUI:AddOnClickEvent(Btn, self, self.stationaryBtn, self.StationaryStr[realIndex + 1].tbl)
        if self.StationaryStr[realIndex + 1].tbl.id == NpcPerId then
            if self.NpcPerIdTimer then
                SL:UnSchedule(self.NpcPerIdTimer)
                self.NpcPerIdTimer = nil
            end
            self.NpcPerIdTimer = SL:ScheduleOnce(self.StationaryStr[realIndex + 1].tbl.ShowDuration / 1000, function()
                for i = 4, 1, -1 do
                    if self.StationaryStr[i] and self.StationaryStr[i].tbl.id == NpcPerId then
                        table.remove(self.StationaryStr, i)
                    end
                end
                for i = 1, 4, 1 do
                    self:StationaryDataUpdateFunc(i - 1, nil)
                end
            end)
        end]]

    else
        GUI:setVisible(img, false)
    end
end
--[[function this:reMoveNpcTips()
    if self.NpcPerIdTimer then
        SL:UnSchedule(self.NpcPerIdTimer)
        self.NpcPerIdTimer = nil
    end
    
    if self.StationaryStr then
        for i = 4, 1, -1 do
            if self.StationaryStr[i] and self.StationaryStr[i].tbl.id == NpcPerId then
                table.remove(self.StationaryStr, i)
            end
        end
        for i = 1, 4, 1 do
            self:StationaryDataUpdateFunc(i - 1, nil)
        end
    end
end]]
--[[function this:stationaryBtn(_, data)
    if data then
        if data.id == NpcPerId then
            local MapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
            local mapNpcList = {}
            local globalTbl = SL:GetConfig("cfg_global", 800002).value
            local strList = string.split(globalTbl, "|")
            for _, v in pairs(strList) do
                local strListList = string.split(v, "#")
                if tonumber(strListList[1]) == MapId then
                    table.insert(mapNpcList, tonumber(strListList[2]))
                end
            end
            local disNpc = 0
            local disNpcId = 0
            for _, v in pairs(mapNpcList) do
                local npcInfo = SL:GetConfig("cfg_npclist", v)
                local myPos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
                local dis = self:Distance(myPos, { x = npcInfo.x, z = npcInfo.y })
                if disNpc == 0 then
                    disNpc = dis
                    disNpcId = npcInfo.id
                end
                if disNpc >= dis then
                    disNpc = dis
                    disNpcId = npcInfo.id
                end
            end
            if disNpcId ~= 0 then
                SL:SendTransferToNpcMessage(disNpcId, true)
            end
        end
    end
end]]
function this:Distance(a, b)
    return Mathf.Sqrt((a.x - b.x) ^ 2 + (a.z - b.z) ^ 2)
end
function this:DOKillScroll(realIndex)
    local doTime = self.StationaryStrTbl.rollSpeed / 1000
    if self.scrollDo[realIndex] then
        GUI:DOKill(self.scrollDo[realIndex])
        self.scrollDo[realIndex] = nil
    end
end

-- 使用定时器实现循环滚动
function this:StartScrollAnimationWithTimer(textControl, imgControl, duration, rollCount, realIndex)
    -- 清理之前的定时器
    local timerId = realIndex
    if self.scrollTimers and self.scrollTimers[timerId] then
        SL:UnSchedule(self.scrollTimers[timerId])
        self.scrollTimers[timerId] = nil
    end

    local currentCount = 0
    local textContent = GUI:TextAtlas_getString(textControl)
    local txtW = GUI:GetWidth(textControl) + 30
    local posx = GUI:getPositionX(textControl)
    -- 创建循环定时器
    self.scrollTimers[timerId] = SL:Schedule(self.scrollTimers[timerId], 0, duration + 1, rollCount, function()
        currentCount = currentCount + 1
        -- 记录该文本已经滚动过
        if textContent then
            self.hasScrolledTexts[textContent] = true
        end

        -- 如果是最后一次滚动，让文本保持在左侧
        if rollCount > 0 and currentCount > rollCount then
            self:DOKillScroll(realIndex)
            -- 最后一次滚动完成后保持左对齐
            local h = GUI:GetHeight(textControl)
            GUI:setContentSize(imgControl, MAXBGWidth, h)
            GUI:setAnchorPoint(textControl, 1, 0)
            GUI:setPositionX(textControl, 0)
            SL:UnSchedule(self.scrollTimers[timerId])
            self.scrollTimers[timerId] = nil
            if textContent then
                self.endScrolledTexts[textContent] = true
            end
        else
            GUI:setPositionX(textControl, txtW)
            -- 正常滚动
            self.scrollDo[realIndex] = GUI:DOAnchorPos(textControl, Vector3.New(-txtW, 0, 0), duration)
        end
    end)
end

-- 停止所有滚动定时器
function this:StopAllScrollTimers()
    if self.scrollTimers then
        for _, timer in pairs(self.scrollTimers) do
            SL:UnSchedule(timer)
        end
        self.scrollTimers = {}
    end
end

function this:InitArchangelExp()
    self.ArchangelExp = {}
    self.ArchangelExpSchedule = {}
    self.ArchangelExpList = {}
    self.ArchangelExpCount = 0
    for i = 1, 7 do
        local bgName = "archangelExpBG" .. tostring(i)
        self.ArchangelExp[i] = {}
        self.ArchangelExp[i].BG = GUI:GetChildControl(self.view.archangelLayout, i - 1, bgName)
        self.ArchangelExp[i].text = GUI:GetChildControl(self.ArchangelExp[i].BG, 0, "archangelExp")
    end
    for i, v in pairs(self.ArchangelExp) do
        GUI:setVisible(v.BG)
    end
end

function this:AddArchangelExp(level, name)
    self.ArchangelExpCount = self.ArchangelExpCount + 1
    if self.ArchangelExpCount > 7 then
        self.ArchangelExpCount = 1
    end
    local control = self.ArchangelExp[self.ArchangelExpCount]
    if self.ArchangelExpSchedule[self.ArchangelExpCount] then
        SL:UnSchedule(self.ArchangelExpSchedule[self.ArchangelExpCount])
        GUI:setVisible(control.BG, false)
    end

    ---@type cfg_string_column
    local strTbl = SL:GetConfig("cfg_string", 499, "id")
    local color = SL:GetConfig("cfg_color", tonumber(strTbl.textColor), "id").color
    GUI:Text_setTextColor(control.text, color)
    GUI:Text_setFontSize(control.text, strTbl.textSize)
    local text = strTbl.text
    text = string.gsub(text, "%%i", name)
    text = string.gsub(text, "%%d", tonumber(level))
    GUI:Text_setString(control.text, text)

    GUI:setLocalZOrder(control.BG, 3)
    GUI:setVisible(control.BG, true)
    local time = strTbl and strTbl.ShowDuration / 1000 or 2
    self.ArchangelExpSchedule[self.ArchangelExpCount] = SL:ScheduleOnce(time, function()
        GUI:setVisible(control.BG, false)
        self.ArchangelExpSchedule[self.ArchangelExpCount] = nil
    end)
end

function this:Check()

end

function this:Close()
    Coroutine.StopAll()
    self.HorseRaceLampCoroutine = nil
    if self.damageTimeID then
        SL:UnSchedule(self.damageTimeID)
    end
    if self.expTimeID then
        SL:UnSchedule(self.expTimeID)
    end
    if self.stationaryBlinkSchedule then
        SL:UnSchedule(self.stationaryBlinkSchedule)
        self.stationaryBlinkSchedule = nil
        GUI:setAlpha(self.view.stationary, 1)
    end
    if self.firstTimer then
        SL:UnSchedule(self.stationaryBlinkSchedule)
        self.firstTimer = nil
    end
    for i, v in pairs(self.stationaryTextList) do
        InfoManager.activityPreviewInfo:RemoveBlink(v)
    end
--[[    if self.NpcPerIdTimer then
        SL:UnSchedule(self.NpcPerIdTimer)
        self.NpcPerIdTimer = nil
    end]]
    self:CloseTimer()
    self:ResetScrollStates()
end

-- 在刷新数据时添加重置滚动状态的函数
function this:ResetScrollStates()
    -- 清空已滚动文本的记录
    self.hasScrolledTexts = {}
    self.endScrolledTexts = {}
    -- 清理所有滚动定时器
    self:StopAllScrollTimers()

    -- 清理滚动动画
    for i, v in pairs(self.scrollDo) do
        if v then
            GUI:DOKill(v)
        end
    end
    self.scrollDo = {}
end

function this:CloseTimer()
    self:StopAllScrollTimers()
end

return this

---@class KLMessageNoticePanel:UIKmlLuaPanelBase
---@field view KLMessageNoticePanelView
local KLMessageNoticePanel = class(UIKmlLuaPanelBase)
local this =KLMessageNoticePanel
local maxLdMessageCount = 6
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLMessageNoticePanel",true)
    self.ldMessageList = {}
    ---@type Queue
    self.ldItemQueue = SL.Queue:New()
    for i = 1,maxLdMessageCount do
        local control = self.view["item_ld" .. i]
        GUI:setAlpha(control,0)
        self.ldItemQueue:PushLast({control=control})
    end

    --self.ldMessageTimer = SL:Schedule(self.ldMessageTimer,0,0.2,-1,self.LDTick,self)
    -- 盒子服务端过来的信息无法走表，策划要求写死配置(跑马灯)
    self.BoxHorse = { id = -1, description = "", name = "", messageType = { 1 }, receiver = 3, textColor = "255", rollSpeed = 10000, text = "", subType = "系统", condition = { { 1, 1 } }, backgroundColor = "0", transparencyB = 40, transparencyT = 0, textSize = 20, offsetX = 0, offsetY = 0, rollCount = 0, releaseEffect = {}, ShowDuration = 0, order = 0 }
    -- 盒子服务端过来的信息无法走表，策划要求写死配置(聊天框)
    self.BoxChat = { id = -2, description = "", name = "", messageType = { 7 }, receiver = 3, textColor = "255", rollSpeed = 10000, text = "", subType = "系统", condition = { { 1, 1 } }, backgroundColor = "0", transparencyB = 40, transparencyT = 0, textSize = 20, offsetX = 0, offsetY = 0, rollCount = 0, releaseEffect = {}, ShowDuration = 0, order = 0 }
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_LEFT_OPEN_MESSAGE, self.HandleMDMessage, self)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Hide()
end

function this:Close()
    SL:KeepOpenPanel("KLMessageNoticePanel",false)
    while not self.ldItemQueue:IsEmpty() do
        local item = self.ldItemQueue:PopFirst()
        if item.fadeTimer then
            GUI:DOKill(item.fadeTimer)
        end
        SL:UnSchedule(item.showTimer)
    end
    self:ClearMDMessageTimer()

end

---@param message ChatProto.TextNoticeRes
---@param tbl cfg_string_column
function this:HandleLDMessage(message, tbl)
    ---@type cfg_string_column
    if not tbl and message then
        if message.id == -1 then
            tbl = self.BoxHorse
        elseif message.id == -2 then
            tbl = self.BoxChat
        else
            tbl = SL:GetConfig("cfg_string",message.id)
        end
    end
    if tbl.condition and tbl.condition[1][1] == 1 then
        local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        if level < tbl.condition[1][2] then
            return false
        end
    end
    if tbl.messageType[1] == 8 then
        local showText = self:GetMessageText(message,tbl)
        --logError(showText)
        table.insert(self.ldMessageList,{text = showText,showDuration = tbl.ShowDuration,hideFlag=false})
        if #self.ldMessageList > maxLdMessageCount then
            table.remove(self.ldMessageList,1)
        end
        --GUI:OSAScrollView_RefreshList(self.view.osa_ld_message,#self.ldMessageList)
        self:RefreshLDMessage()
        return true
    end
    return false
end

---@param message ChatProto.TextNoticeRes
---@param tbl cfg_string_column
function this:GetMessageText(message,tbl)
    -- contentFromServer标志位; false：表示客户端直接读取配置  true：表示从服务器获取内容
    local textString = message and message.contentFromServer and message.content or tbl.text
    if message and not table.isNullOrEmpty(message.params) then
        textString = string.format(textString, table.unpack(message.params))
    end

    if string.contains(textString, "<Text") then
        textString = Misc.TransSpecialText(textString)
    end
    ---@type cfg_color_column
    local colorTbl = SL:GetConfig("cfg_color",tonumber(tbl.textColor))
    local txt = string.format("<color=%s>%s</color>", colorTbl.color, textString)
    return txt
end

function this:RefreshLDMessage()
    local count = #self.ldMessageList
    for i = 1,count do
        local msg = self.ldMessageList[i]
        local item = self.ldItemQueue:PopFirst()
        if item.fadeTimer then
            GUI:DOKill(item.fadeTimer)
            item.fadeTimer = nil
        end
        SL:UnSchedule(item.showTimer)
        local control = item.control
        ---@type UnityEngine.RectTransform
        local rect = GUI:GetRectTransform(control)
        rect:SetAsFirstSibling()
        GUI:setAlpha(control,1)
        local text = GUI:GetChildById(control,"text_message")
        local str = msg.text
        local textColor = SL:GetConfig('cfg_global', 370002).value
        if not string.contains(str, "color") then
            str = str
        else
            str = GUIUtil.Extract_All_Brackets(str)
        end
        GUI:Text_setString(text,str)
        GUI:Text_setTextColor(text,textColor)
        item.showTimer = SL:ScheduleOnce(msg.showDuration/1000,self.PlayLdMessageHideAnim,self,item)
        self.ldItemQueue:PushLast(item)
    end
    table.clear(self.ldMessageList)
end

function this:PlayLdMessageHideAnim(item)
    item.fadeTimer = GUI:DOAlphaCanvasGroup(item.control,0,1)
end

---中间底部泡点信息
function this:HandleMDMessage(_, data)
    self:ClearMDMessageTimer()
    local msgControl = self.view.text_mid_message
    GUI:setAlpha(msgControl,1)
    GUI:Text_setString(msgControl,data.text)
    GUI:Text_setFontName(msgControl,data.fontName or "BubblePoint")
    self.mdMessageShowTimer = SL:ScheduleOnce(data.showTime,self.PlayMDMessageHideAnim,self)
end

function this:ClearMDMessageTimer()
    if self.mdMessageShowTimer then
        SL:UnSchedule(self.mdMessageShowTimer)
        self.mdMessageShowTimer = nil
    end
    GUI:setAlpha(self.view.text_mid_message,0)
    if self.mdMessageHideTimer then
        GUI:DOKill(self.mdMessageHideTimer)
        self.mdMessageHideTimer = nil
    end
end

function this:PlayMDMessageHideAnim()
    self.mdMessageHideTimer = GUI:DOAlphaCanvasGroup(self.view.text_mid_message,0,0.5)
end

return this

---@class KLNoticeTextPanel:UIKmlLuaPanelBase
---@field view KLNoticeTextPanelView
local KLNoticeTextPanel = class(UIKmlLuaPanelBase)
local this = KLNoticeTextPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.lastTip = nil
    self.tipTxtPool = TablePool()
    self.tipTxt = {}
    self.timer = 0
    self.maxCount = 3
    self.index = 0

    local anchorPos = GUI:GetAnchoredPosition(self.view.noticeMidBg)
    self.x = anchorPos.x
    self.y = anchorPos.y
    self.w, self.h = GUI:getSizeDelta(self.view.tipTxt)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
    self:StopUpdate()
    self.up = SL:StartLoopForever(0, self.Update, self)
end

function this:Hide()
    if self.tipTxt == nil then
        return
    end
    for i, control in pairs(self.tipTxt) do
        self.tipTxtPool:Push(control)
    end
    self.x, self.y = GUI:GetAnchoredPosition(self.view.noticeMidBg)
    self.tipTxt = {}
    self:StopUpdate()
end

function this:Close()
    self:StopUpdate()
end

function this:StopUpdate()
    if self.up then
        SL:UnSchedule(self.up)
        self.up = nil
    end
end

-- 每帧更新，需要使用时打开
function this:Update()
    if #self.tipTxt == 0 then
        self.timer = 0
        return
    end
    self.timer = self.timer + Time.deltaTime
    if self.timer > 0.5 then
        local count = #self.tipTxt
        if count > 0 then
            self.index = 0
            for i = count, 1, -1 do
                ---@type UIControl
                local control = self.tipTxt[i]
                if control then
                    control.time = control.time - self.timer
                    if control.time <= 0 then
                        GUI:SetAnchoredPosition(control, Vector2.New(0, 100000))
                        ---control:SetAnchoredPosition(0, 100000)
                        self.tipTxtPool:Push(control)
                        table.remove(self.tipTxt, i)
                    end
                end
            end
        end
        self.timer = 0
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        self:ShowText(table.unpack(self.args))
    end
end

---@param noticeType  NoticeType
function this:ShowText(text, showTime, noticeType)
    noticeType = noticeType or defaultNoticeType
    curNoticeType = noticeType
    if self.lastTip then
        self.lastTip:SetActive(false)
    end
    if noticeType == NoticeType.NoticeLeftBottom then
        GUI:SetActive(self.view.notice, true)
        GUI:Text_setText(self.view.notice, text or "")
        self.lastTip = self.view.notice
        GUI:setContentSize(self.view.notice, self.view.notice.text.preferredWidth, self.view.notice.text.preferredHeight)

        if self.hideCoroutine then
             SL:UnSchedule(self.hideCoroutine)---Coroutine.Stop(self.hideCoroutine)
            self.hideCoroutine = nil
        end
        self.hideCoroutine = SL:ScheduleOnce(showTime or 1,self.BeginHide,self) ---Coroutine.Start(self.BeginHide, self, showTime or 1)
    elseif noticeType == NoticeType.NoticeMid then
        if not self.tipTxt then
            return
        end
        if #self.tipTxt >= self.maxCount then
            ---@type UIControl
            local control1 = self.tipTxt[1]
            GUI:SetAnchoredPosition(control1, Vector2.New(0, 100000))
            ---  control1:SetAnchoredPosition(0, 100000)
            self.tipTxtPool:Push(control1)
            table.remove(self.tipTxt, 1)
        end

        local control = self.tipTxtPool:Pop()
        if not next(control) then
            control = GUI:CloneControl(GUI:GetID(self.view.root), GUI:GetID(self.view.noticeMidBg)) ----UIControl(self.view.noticeMidBg:Instantiate(self.view.tipMidContainer.transform).transform)
            GUI:SetActive(control, true) ---control:SetActive(true)
        end
        local txtControl = GUI:GetRectTransform(control):GetChild(0)  ---UIControl(control.transform, "tipTxt")
        ---@type UnityEngine.UI.Text
        local textCom = txtControl.transform:GetComponent(typeof(CS.UnityEngine.UI.Text))
        textCom.text = text or ""  ---txtControl:SetText(text or "")
        GUI:setContentSize(control, textCom.text.preferredWidth, self.h)
        --- control:SetSizeDelta(txtControl.text.preferredWidth, self.h)
        control.time = showTime
        ---control:SetName("chid-" .. #self.tipTxt)
        table.insert(self.tipTxt, control)
        local count = #self.tipTxt
        for i = count, 1, -1 do
            local control2 = self.tipTxt[i]
            ---control2:SetAnchoredPosition(self.x, self.y + (count - i + 1) * math.abs(self.y))
            GUI:SetAnchoredPosition(control2, Vector2.New(self.x, self.y + (count - i + 1) * math.abs(self.y)))
        end
    end
end

--开始隐藏
function this:BeginHide(showTime)
    ---Coroutine.Wait(showTime)
    if curNoticeType == NoticeType.NoticeLeftBottom then
        self.view.notice:SetActive(false)
    end
end

return this

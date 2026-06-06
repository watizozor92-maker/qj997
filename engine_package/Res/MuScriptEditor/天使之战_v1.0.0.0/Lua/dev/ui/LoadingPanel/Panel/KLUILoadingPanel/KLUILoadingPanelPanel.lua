---@class KLUILoadingPanelPanel:UIKmlLuaPanelBase
---@field view KLUILoadingPanelPanelView
local KLUILoadingPanelPanel = class(UIKmlLuaPanelBase)
local this = KLUILoadingPanelPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.Coroutine = nil
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
    self.ProgressType = ProgressType.NormalProgress
    if self.args and self.args.ProgressType then
        self.ProgressType = self.args.ProgressType
        -- if self.args.texure2DPath then
        --     local texure2DPath = string.format('Texture/%s.jpg', self.args.texure2DPath)
        --     GUI:Image_loadTexture(self.view.RawImage_Background, texure2DPath)
        -- end
    end
    self:LoadTrackerStop()
    self.loadTracker = SL:CtorResourceLoadTracker()
    self.progress = 0
    --local random = Mathf.Random(1, 2)
    GUI:setVisible(self.view.img1, true)
    GUI:setVisible(self.view.img2, false)
    --GUI:setVisible(self.view["img"..random], true)
    self:RegistEvents()
    self:Refresh()
    self:Update()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.ProgressType == ProgressType.NoProcess then
        GUI:Image_setFillAmount(self.view.Image_Progress, 1)
        GUI:Text_setString(self.view.Text_Message, '')
    else
        GUI:Image_setFillAmount(self.view.Image_Progress, self.progress)
        local progressInt = Mathf.Round(self.progress * 100)
        if self.progressInt ~= progressInt then
            self.progressInt = progressInt
            local str = ""
            if self.ProgressType == ProgressType.DownProgress then
                str = string.format("%s/%s", progressInt, "100MB")
            elseif self.ProgressType == ProgressType.NormalProgress or self.ProgressType == ProgressType.TryEnterMapMessage then
                str = string.format("正在加载场景 %d%%", progressInt)
            end
            GUI:Text_setString(self.view.Text_Message, str)
        end
    end
    ---@type UnityEngine.RectTransform
    local rect= GUI:GetRectTransform(self.view.root)
    SL:ScheduleOnce(0.05,function (rect)
        rect:SetAnchoredPosition(0,0)
    end,rect)
end

function this:Update()
    self:StopUpdate()
    self.Coroutine = SL:StartLoopForever(0.05,
            function()
                self:UpdateProgress()
            end)
end
function this:StopUpdate()
    if self.Coroutine then
        SL:UnSchedule(self.Coroutine)
        self.Coroutine = nil
    end
    if GUI:IsWebGLAsync() then
        self.webGLWaitTime = nil
        self.isSendLUA_EVENT_LOADING_PANEL_HIDE = nil
    end
end

function this:Hide()
    self:LoadTrackerStop()
    SL:onLUAEvent(LUA_EVENT_LOADING_PANEL_HIDE, self.ProgressType)
    self:StopUpdate()
end

function this:Close()

end

function this:LoadTrackerStop()
    if self.loadTracker then
        self.loadTracker:Dispose()
    end
    self.loadTracker = nil
end

local DAMPING = 3
function this:SetProgress(progress)
    local t = math.min(Time.deltaTime * DAMPING, 0.1)
    if self.progress < progress then
        self.progress = Mathf.Lerp(self.progress, progress, t)
    end
    if GUI:IsWebGLAsync() and self.ProgressType == ProgressType.TryEnterMapMessage then
        if self.progress > 0.9 and not self.webGLWaitTime then
            self.webGLWaitTime = Time.time + 1.5
        else
            if self.webGLWaitTime and not self.isSendLUA_EVENT_LOADING_PANEL_HIDE then
                SL:KeepOpenPanel("KLUILoadingPanelPanel",true)
                SL:onLUAEvent(LUA_EVENT_LOADING_PANEL_HIDE, self.ProgressType)
                self.isSendLUA_EVENT_LOADING_PANEL_HIDE = true
            end
            if self.webGLWaitTime and Time.time > self.webGLWaitTime then
                self.webGLWaitTime = nil
                GUI:UIPanel_Close("dev/ui/LoadingPanel/Panel/KLUILoadingPanel/KLUILoadingPanelPanel")
                SL:KeepOpenPanel("KLUILoadingPanelPanel",false)
                if SL:GetIsXtra() then
                    SL.SceneEditorManager:SetProgressState(self.ProgressType)
                end
            else
                self:Refresh()
            end
        end
    else
        if self.progress > 0.999 then
            GUI:UIPanel_Close("dev/ui/LoadingPanel/Panel/KLUILoadingPanel/KLUILoadingPanelPanel")
            if SL:GetIsXtra() then
                SL.SceneEditorManager:SetProgressState(self.ProgressType)
            end
        else
            self:Refresh()
        end 
    end
end

function this:UpdateProgress()
    local count = 0
    local progress = 1
    local totalProgress = 1
    if self.ProgressType == ProgressType.DownProgress then
        totalProgress = 1
        count = 1
        progress = count == 0 and 1 or totalProgress / count
    elseif self.ProgressType == ProgressType.NormalProgress then
        totalProgress = self.loadTracker.totalProgress
        count = self.loadTracker.count + SL:GetMetaValue("CS_STREAMING_SCENE_OBJ_SHOW_COUNT")
        progress = count == 0 and 1 or totalProgress / count
    end
    if self.ProgressType ~= ProgressType.NoProcess then
        self:SetProgress(progress)
    end
end

return this

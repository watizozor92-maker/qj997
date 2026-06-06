---@class KLPlayVideoPanel:UIKmlLuaPanelBase
---@field view KLPlayVideoPanelView
local KLPlayVideoPanel = class(UIKmlLuaPanelBase)
local this = KLPlayVideoPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Close, self, self.CloseOnClick)
    GUI:AddOnClickEvent(self.view.btn_open, self, self.btn_openOnClick)
end
function this:CloseOnClick()
    GUI:UIPanel_Close("dev/outui/Recharge/Panel/KLPlayVideo/KLPlayVideoPanel")
end
function this:btn_openOnClick()
    GUI:PlayVideo(self.videoKml)
    GUI:SetActive(self.view.btn_open,false)

    self.Timer = SL:Schedule(self.Timer, 1, 1, -1, function()
        if not GUI:IsVideoPlaying(self.videoKml) then
            GUI:SetActive(self.view.btn_open,true)
            return
        end
    end)

end
---界面显示时调用一次
function this:Show()
    if self.args and self.args.path then
        self.videoKml = GUI:UIVideo_Create(self.view.VideoPlayer,{})
        GUI:SetVideo( self.videoKml, self.args.path, 838, 446, "0", "0")
        GUI:SetImageNativeSize(self.videoKml)
        GUI:StopVideo(self.videoKml)
    end
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
    if self.Timer then
        SL:UnSchedule(self.Timer)
    end
    self.Timer= nil
end

return this

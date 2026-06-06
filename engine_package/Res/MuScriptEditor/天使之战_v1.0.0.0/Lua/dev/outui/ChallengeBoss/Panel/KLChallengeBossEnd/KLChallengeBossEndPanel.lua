---@class KLChallengeBossEndPanel:UIKmlLuaPanelBase
---@field view KLChallengeBossEndPanelView
local KLChallengeBossEndPanel = class(UIKmlLuaPanelBase)
local this = KLChallengeBossEndPanel
---创建时调用一次
function this:Init()
    
    
end

function this:InitData(l_time)
    local last_time = l_time or 30
    GUI:SetControl_time(self.view.end_time,last_time)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

---注册UI事件和服务器消息
function this:RegistEvents()
   
end



function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLChallengeBossPos/KLChallengeBossEndPanel")
    SL.ShowMainPanel()
end


function this:Close()
end

return this

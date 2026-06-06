---@class KLPrivilegeBossEndPanel:UIKmlLuaPanelBase
---@field view KLPrivilegeBossEndPanelView
local KLPrivilegeBossEndPanel = class(UIKmlLuaPanelBase)
local this = KLPrivilegeBossEndPanel
---创建时调用一次
function this:Init()
    
    
end

function this:InitData(time)
    GUI:SetControl_time(self.view.end_time,time)
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

function this:Exit()
    
end



function this:CloseOnclick()

end


function this:Close()
end

return this

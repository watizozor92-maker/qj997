---@class KLPrivilegeBossOpenPanel:UIKmlLuaPanelBase
---@field view KLPrivilegeBossOpenPanelView
local KLPrivilegeBossOpenPanel = class(UIKmlLuaPanelBase)
local this = KLPrivilegeBossOpenPanel
---创建时调用一次
function this:Init()
    GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel",nil,nil,{monsterType = 5 })
end

---创建或者刷新界面数据时调用
function this:Refresh()
   
end

---注册UI事件和服务器消息
function this:RegistEvents()
   
end

function this:CloseOnclick()
   
end


function this:Close()
    
end

return this

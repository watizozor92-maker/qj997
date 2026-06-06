---@class KLTeamInfoItem:UIKmlLuaPanelBase
---@field view KLTeamInfoItemView
local KLTeamInfoItem = class(UIKmlLuaPanelBase)
local this =KLTeamInfoItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:RefreshItem(data)
    GUI:Text_setString(self.view.state,data.state)
    local icon = "10"
    if data.career == 2 then
        icon = "12"
    elseif data.career == 3 then
        icon = "13"
    elseif data.career == 4 then
        icon = "14"
    elseif data.career == 5 then
        icon = "15"
    elseif data.career == 6 then
        icon = "16"
    end
    GUI:Image_loadTexture(self.view.icon,icon,"Atlas/MUIcon.spriteatlas")
    GUI:setVisible(self.view.select,data.select)
    GUI:setVisible(self.view.leaderIcon,data.isLeader)
    GUI:Text_setString(self.view.playerName,data.name)
end

function this:Close()
end

return this

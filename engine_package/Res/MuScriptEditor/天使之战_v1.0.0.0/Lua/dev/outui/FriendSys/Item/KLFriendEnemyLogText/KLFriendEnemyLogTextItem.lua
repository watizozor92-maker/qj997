---@class KLFriendEnemyLogTextItem:UIKmlLuaPanelBase
---@field view KLFriendEnemyLogTextItemView
local KLFriendEnemyLogTextItem = class(UIKmlLuaPanelBase)
local this =KLFriendEnemyLogTextItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.textContent, self.args and self.args.text or "")
end

---@param data FriendProto.FriendLog
function this:SetLog(data)
    local str = os.date("%Y-%m-%d %H:%M:%S", data.time//1000)
    ---@type cfg_map_info_column
    local mapName = SL:GetConfig("cfg_map_info", data.mapCfgId)
    local res = string.format("%s 被他在 %s <color=#ff2323>击杀</color> 仇恨度+10", str, mapName and mapName.mapname or "")
    GUI:Text_setString(self.view.textContent, res)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this

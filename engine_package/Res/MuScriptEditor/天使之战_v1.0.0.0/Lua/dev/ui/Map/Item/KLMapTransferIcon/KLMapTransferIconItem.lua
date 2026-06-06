---@class KLMapTransferIconItem:UIKmlLuaPanelBase
---@field view KLMapTransferIconItemView
local KLMapTransferIconItem = class(UIKmlLuaPanelBase)
local this =KLMapTransferIconItem
---创建时调用一次
function this:Init()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_transfer_point_column
    local data = self.args
    GUI:Text_setString(self.view.txt_name,data.name)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this

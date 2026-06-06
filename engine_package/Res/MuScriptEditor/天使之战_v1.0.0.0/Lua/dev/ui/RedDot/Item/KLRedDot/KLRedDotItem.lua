---@class KLRedDotItem:UIKmlLuaPanelBase
---@field view KLRedDotItemView
local KLRedDotItem = class(UIKmlLuaPanelBase)
local this =KLRedDotItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this

---@class KLUnionReplaceItem:UIKmlLuaPanelBase
---@field view KLUnionReplaceItemView
local KLUnionReplaceItem = class(UIKmlLuaPanelBase)
local this =KLUnionReplaceItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local memberInfo = self.args.memberInfo
    self.memberInfo = memberInfo
    GUI:Text_setString(self.view.txtName, memberInfo.name)
    GUI:Text_setString(self.view.txtLv, memberInfo.level)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this

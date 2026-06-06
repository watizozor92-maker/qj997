---@class KLBoxPrivilegeItem:UIKmlLuaPanelBase
---@field view KLBoxPrivilegeItemView
local KLBoxPrivilegeItem = class(UIKmlLuaPanelBase)
local this = KLBoxPrivilegeItem

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.toggle_privilege, self, self.ToggleOnValueChange)
end

function this:ToggleOnValueChange(_, _, c)
    if self.tab == EBoxPrivilege.Privilege then
        self.baseUI:TogglePrivilegeOnValueChange(c, self.view.select_toggle)
    elseif self.tab == EBoxPrivilege.DayGift then
        self.baseUI:ToggleItemsOnValueChange(c, self.view.select_toggle)
    end
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.tab = self.args.tbl[1].tab
    GUI:Text_setString(self.view.text_privilege, self.args.tbl[1].tabName)
    GUI:SetToggleGroup(self.view.toggle_privilege, self.args.toggle_group)
end

function this:InitUI(tab)
    if tab == nil then
        tab = EBoxPrivilege.Privilege
    end
    if self.tab == tab then
        GUI:Toggle_setIsOn(self.view.toggle_privilege, true)
        self:ToggleOnValueChange(_,_,{true})
    else
        self:ToggleOnValueChange(_,_,{false})
        --GUI:Toggle_setIsOn(self.view.toggle_privilege, false)
    end

end

function this:Close()
end

return this

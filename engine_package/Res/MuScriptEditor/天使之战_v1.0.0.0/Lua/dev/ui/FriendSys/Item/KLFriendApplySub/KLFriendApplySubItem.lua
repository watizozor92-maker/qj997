---@class KLFriendApplySubItem:UIKmlLuaPanelBase
---@field view KLFriendApplySubItemView
local KLFriendApplySubItem = class(UIKmlLuaPanelBase)
local this =KLFriendApplySubItem
---创建时调用一次
function this:Init()
    self.list = {}
    self:UpdateData()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_FRIEND_LIST_CHANGE, self.UpdateList, self)
end

function this:UpdateList(_, type)
    self:UpdateData()
end

function this:UpdateData()
    local filePath = "dev/ui/FriendSys/Item/KLFriendAddList/KLFriendAddListItem"
    for _, v in pairs(self.list) do
        GUI:UIPanel_Close(filePath, v)
    end
    table.clear(self.list)
    local friendApplyList = SL:GetFriendData(EFriendRelation.ApplyList)
    for _, v in pairs(friendApplyList) do
        table.insert(self.list, GUI:UIPanel_Open(filePath, self.view.ListContent, 
                self, {addFriend = false, data = v}, true))
    end
end

function this:Close()
end

return this

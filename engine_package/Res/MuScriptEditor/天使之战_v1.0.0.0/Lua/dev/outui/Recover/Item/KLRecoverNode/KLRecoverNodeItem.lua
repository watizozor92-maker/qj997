---@class KLRecoverNodeItem:UIKmlLuaPanelBase
---@field view KLRecoverNodeItemView
local KLRecoverNodeItem = class(UIKmlLuaPanelBase)
local this =KLRecoverNodeItem

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshData(type_id)
    if type_id == 9 then
        GUI:SetAttr(self.view.content, "constraintcount", "1")
    else
        GUI:SetAttr(self.view.content, "constraintcount", "3")
    end
    GUI:ForceRebuildLayoutImmediate(self.view.content)
    local contentW,contentH = GUI:getSizeDelta(self.view.content)
    GUI:setContentSize(self.view.bg_content,contentW,contentH)
    GUI:ForceRebuildLayoutImmediate(self.view.layout2)
    local w = GUI:GetWidth(self.view.root)
    local h = GUI:GetHeight(self.view.layout2)
    
    GUI:setContentSize(self.view.root, w, h)
end

function this:Hide()
end

function this:Close()
end

return this

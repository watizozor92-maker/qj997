---@class KLUnionArmbandItem:UIKmlLuaPanelBase
---@field view KLUnionArmbandItemView
local KLUnionArmbandItem = class(UIKmlLuaPanelBase)
local this =KLUnionArmbandItem
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:UpdateUI(data)
    GUI:SetActive(self.view.predes, table.count(data) == 3)
    GUI:SetActive(self.view.nextpreArr, table.count(data) == 3)
    GUI:SetActive(self.view.tag1, table.count(data) == 3)
    GUI:SetActive(self.view.tag2, table.count(data) == 3)
    if table.count(data) == 3 then
        GUI:Text_setString(self.view.predes, data.des)
        GUI:Text_setString(self.view.preArr, data.prenum)
        GUI:Text_setString(self.view.nextpreArr, data.nextnum)
    else
        GUI:Text_setString(self.view.preArr, data.des.."     "..data.prenum)
    end
end

function this:Close()
end

return this

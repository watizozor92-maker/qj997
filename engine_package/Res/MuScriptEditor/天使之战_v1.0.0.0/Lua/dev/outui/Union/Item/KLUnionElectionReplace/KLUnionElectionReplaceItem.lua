---@class KLUnionElectionReplaceItem:UIKmlLuaPanelBase
---@field view KLUnionElectionReplaceItemView
local KLUnionElectionReplaceItem = class(UIKmlLuaPanelBase)
local this =KLUnionElectionReplaceItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local data = self.args.data
    self.data = data 
    local memberInfo = self.args.memberInfo
    self.memberInfo = memberInfo
    self.id = self.args.id
    self.level = self.args.level
    GUI:Text_setString(self.view.txtSupports, tostring(data.count))
    GUI:Text_setString(self.view.txtName, memberInfo.name)
    GUI:Text_setString(self.view.txtLevel, memberInfo.level)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnBg, self, self.OpenVotePanel)
end

function this:OpenVotePanel()
    GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionElectionVote/KLUnionElectionVotePanel", _
        , _, {name = self.memberInfo.name, id = self.id, unionLevel = self.level})
end

function this:Close()
end

return this

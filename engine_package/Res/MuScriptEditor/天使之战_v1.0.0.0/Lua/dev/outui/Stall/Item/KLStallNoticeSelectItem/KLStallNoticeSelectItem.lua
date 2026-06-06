---@class KLStallNoticeSelectItem:UIKmlLuaPanelBase
---@field view KLStallNoticeSelectItemView
local KLStallNoticeSelectItem = class(UIKmlLuaPanelBase)
local this = KLStallNoticeSelectItem
---创建时调用一次
function this:Init()
   
end

---创建或者刷新界面数据时调用
function this:RefreshItem(data,notice_select,StallPanel)
    self.data = data
    self.StallPanel = StallPanel
    --SL:LogTable(data,true)
    GUI:Text_setString(self.view.one_notice,self.data.value)
    GUI:Text_setString(self.view.one_notice_select,self.data.value)
    self.notice_select = notice_select
    self:CheckShow()
end

function this:CheckShow()
    local is_have = false
    for i=1,#self.notice_select,1 do
        if self.notice_select[i] == self.data.index then
            is_have = true
            break
        end
    end
    GUI:setVisible(self.view.select, is_have)
    GUI:setVisible(self.view.no_select, not is_have)
    GUI:setVisible(self.view.toggle, is_have)
    GUI:setVisible(self.view.one_notice, is_have)
    GUI:setVisible(self.view.one_notice_select, not is_have)
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.no_select,self,self.AddSelect)
    GUI:AddOnClickEvent(self.view.select,self,self.CancelClick)
end

function this:BtnClick()
    SL:OpenTips("", self.args.cfgId)
end

function this:Close()
end

function this:AddSelect()
    for i=1,#self.notice_select,1 do
        if self.notice_select[i] == self.data.index then
            return
        end
    end
    self.StallPanel:AddSelectNotict(self.data.index)
end

function this:CancelClick()
    local is_have = false
    for i=1,#self.notice_select,1 do
        if self.notice_select[i] == self.data.index then
            is_have = true
            break
        end
    end
    if not is_have then
        return
    end
    self.StallPanel:CancelSelectNotict(self.data.index)
end


return this

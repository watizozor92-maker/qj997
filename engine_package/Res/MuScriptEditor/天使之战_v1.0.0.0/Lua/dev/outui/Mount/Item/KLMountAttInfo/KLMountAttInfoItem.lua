---@class KLMountAttInfoItem:UIKmlLuaPanelBase
---@field view KLMountAttInfoItemView
local KLMountAttInfoItem = class(UIKmlLuaPanelBase)
local this =KLMountAttInfoItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:setContentSize(self.view.bg,self.args.width,38)
    if self.args.attInfo then
        local strList = string.split(self.args.attInfo,"#")
        self:SetText(strList[1], "", strList[2], false)
    end
end

function this:SetText(name, preText, nextText, showArrow)
    GUI:Text_setString(self.view.name, name)
    GUI:Text_setString(self.view.num, nextText)
    GUI:Text_setString(self.view.preNum, preText)
    GUI:setVisible(self.view.arrow, showArrow)
    GUI:setVisible(self.view.preNum, showArrow)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this

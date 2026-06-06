---@class KLDepotsSelectItem:UIKmlLuaPanelBase
---@field view KLDepotsSelectItemView
local KLDepotsSelectItem = class(UIKmlLuaPanelBase)
local this =KLDepotsSelectItem
---创建时调用一次
function this:Init()
    GUI:SetActive(self.view.DotRed,false)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:SetImageAlpha(self.view.Button,0,0,0,0)
end
function this:SetClickDelegate(callBack,callbackData)
    self.callbackData=callbackData
    self.callback = callBack
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Button, self, self.ButtonOnclick)
end
function this:ButtonOnclick()
    if self.callback then
        self.callback(self.baseUI,self,self.callbackData)
    end
end
function this:Close()
end

return this

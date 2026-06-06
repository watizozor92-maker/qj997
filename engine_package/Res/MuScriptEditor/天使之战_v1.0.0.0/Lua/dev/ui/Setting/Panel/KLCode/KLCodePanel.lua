---@class KLCodePanel:UIKmlLuaPanelBase
---@field view KLCodePanelView
local KLCodePanel = class(UIKmlLuaPanelBase)
local this =KLCodePanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:Input_SetOnEndEdit(self.view.CodeInput,self,self.InputOnValueChange)
    GUI:AddOnClickEvent(self.view.exchangeBtn,self,self.ExchangeOnClick)
end

function this:InputOnValueChange(control,_,data)
    self.code = data[1]
end

function this:ExchangeOnClick()
    if not self.code and not string.isNullOrEmpty(self.code) then
        SL:MessageTip({"请输入兑换码",1,NoticeType.NoticeMid})
        return
    end
    local code = GUI:Text_getString(self.view.CodeInput)
    SL:ReqCdKeyMessage(code)
    SL:SetMetaValue(EMetaVarSetKey.SET_HOOK_ATUO_RELEASE_SKILL,1011001)
end

function this:Close()
    self.code = nil
end

return this

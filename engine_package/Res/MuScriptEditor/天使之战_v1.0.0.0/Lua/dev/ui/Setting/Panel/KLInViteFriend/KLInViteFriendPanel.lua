---@class KLInViteFriendPanel:UIKmlLuaPanelBase
---@field view KLInViteFriendPanelView
local KLInViteFriendPanel = class(UIKmlLuaPanelBase)
local this =KLInViteFriendPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local leftNum = SL:GetMetaValue(EMetaVarGetKey.GET_LEFT_GENERATE_INVITE_CODE_COUNT)
    GUI:Text_setString(self.view.Num,"可用数量:<color=#2A8430>".. leftNum .."</color>")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CopyBtn,self,self.CopyBtnOnClick)
    GUI:AddOnClickEvent(self.view.GenerateBtn,self,self.GenerateBtnOnClick)
    
    SL:RegisterLuaNetMsg(MessageDef.ResCreateInviteCodeMessage,self.ResCreateInviteCodeMessage,self)
end

function this:CopyBtnOnClick()
    if not self.code then
        SL:CopyInviteCode(self.code)
    end
end

function this:GenerateBtnOnClick()
    local leftNum = SL:GetMetaValue(EMetaVarGetKey.GET_LEFT_GENERATE_INVITE_CODE_COUNT)
    if leftNum > 0 then
        SL:ReqCreateInviteCodeMessage()
    else
        SL:MessageTip({"剩余次数不足",1,NoticeType.NoticeMid})
    end
end

---@param message UserProtos.InviteCodeRes
function this:ResCreateInviteCodeMessage(_, message)
    local leftNum = SL:GetMetaValue(EMetaVarGetKey.GET_LEFT_GENERATE_INVITE_CODE_COUNT)
    leftNum = leftNum - 1
    self.code = message.code
    SL:SetMetaValue(EMetaVarSetKey.GET_LEFT_GENERATE_INVITE_CODE_COUNT,leftNum)
    GUI:Text_setString(self.view.CodeTxt,message.code)
    GUI:Text_setString(self.view.Num,"可用数量:<color=#2A8430>".. leftNum .."</color>")
end

function this:Close()
    self.code = nil
end

return this

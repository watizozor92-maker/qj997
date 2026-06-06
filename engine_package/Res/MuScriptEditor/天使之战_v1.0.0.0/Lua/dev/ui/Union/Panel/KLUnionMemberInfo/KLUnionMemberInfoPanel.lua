---@class KLUnionMemberInfoPanel:UIKmlLuaPanelBase
---@field view KLUnionMemberInfoPanelView
---@field memberInfo UnionProto.UnionMemberInfo
local KLUnionMemberInfoPanel = class(UIKmlLuaPanelBase)
local this =KLUnionMemberInfoPanel
---创建时调用一次
function this:Init()
    self.memberInfo = self.args.memberInfo
    self.toggleSelect = 6
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.MemberNameText, self.memberInfo.name)
    GUI:Text_setString(self.view.MemberLevelText, tostring(self.memberInfo.level))
    GUI:Image_loadTexture(self.view.HeadPortrait,"1"..self.memberInfo.career,"Atlas/MUIcon.spriteatlas")
    if self.memberInfo.onlineState == 0 then
        GUI:setVisible(self.view.grey, true)
    else
        GUI:setVisible(self.view.grey, false)
    end
    
    GUI:setVisible(self.view.panel_manager, true)
    GUI:setVisible(self.view.tog_SetType1,false)
    GUI:setVisible(self.view.tog_SetType2,false)
    GUI:setVisible(self.view.tog_SetType3,false)
    GUI:setVisible(self.view.tog_SetType4,false)
    GUI:setVisible(self.view.tog_SetType5,false)
    GUI:setVisible(self.view.grey,false)
    GUI:SetParent(self.view.img1, GUI:GetRectTransform(self.view.Bg1))
    
    if SL:UnionInfo_IsBoos() then
        if self.memberInfo.position == EUnionPosition.LeaderHelper then
            GUI:setVisible(self.view.tog_SetType4,true) --设为成员
            GUI:setVisible(self.view.tog_SetType5,true) --禅让盟主
            GUI:setVisible(self.view.tog_SetType6,true) --踢出战盟
            GUI:SetTogDefaultThis(self.view.tog_SetType4)
        else
            GUI:setVisible(self.view.tog_SetType1,true) --设为副盟主
            GUI:setVisible(self.view.tog_SetType5,true)
            GUI:setVisible(self.view.tog_SetType6,true)
            GUI:SetTogDefaultThis(self.view.tog_SetType1)
        end
    elseif SL:UnionInfo_IsPowerMan() then --副盟主
        if self.memberInfo.position == EUnionPosition.Member then
            GUI:setVisible(self.view.tog_SetType6,true)
            GUI:SetTogDefaultThis(self.view.tog_SetType6)
            self.toggleSelect = 6
        else
            GUI:setVisible(self.view.panel_manager, false)
        end
    else
        GUI:setVisible(self.view.panel_manager, false)
    end
    
    if SL:CheckIsFriend(self.memberInfo.memberId) then
        GUI:setVisible(self.view.AddFriendBtn, false)
    else
        GUI:setVisible(self.view.AddFriendBtn, true)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_PanelClose, self, self.btn_PanelClose)
    GUI:AddOnClickEvent(self.view.AddFriendBtn, self, self.AddFriendBtn)
    GUI:AddOnClickEvent(self.view.PlayerDetailBtn, self, self.PlayerDetailBtn)
    GUI:AddOnClickEvent(self.view.ConfirmManageBtn, self, self.ConfirmManageBtn)
    GUI:AddOnClickEvent(self.view.CancelManageBtn, self, self.CancelManageBtn)
    GUI:SetToggleOnValueChange(self.view.tog_SetType1, self, self.tog_SetType,{index=2})
    GUI:SetToggleOnValueChange(self.view.tog_SetType2, self, self.tog_SetType,{index=3})
    GUI:SetToggleOnValueChange(self.view.tog_SetType3, self, self.tog_SetType,{index=4})
    GUI:SetToggleOnValueChange(self.view.tog_SetType4, self, self.tog_SetType,{index=5})
    GUI:SetToggleOnValueChange(self.view.tog_SetType5, self, self.tog_SetType,{index=1})
    GUI:SetToggleOnValueChange(self.view.tog_SetType6, self, self.tog_SetType,{index=6})
    GUI:AddOnClickEvent(self.view.PrivateChatBtn, self, self.PrivateChat)
end

function this:PrivateChat()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionInfo/KLUnionInfoPanel")
    GUI:UIPanel_Open("dev/ui/Chat/Panel/KLUIChatPanel/KLUIChatPanel", _, _, {
        type={
            channel = EChatChannelType.PERSONAL,
            rid = self.memberInfo.memberId,
            name = self.memberInfo.name
        }
    })
    self:btn_PanelClose()
end

function this:CancelManageBtn()
    self:btn_PanelClose()    
end

function this:tog_SetType(control,eventData,systemData)
    if systemData then
        self.toggleSelect = eventData.index
    end
    
end

function this:AddFriendBtn()
    SL:AddFriend(self.memberInfo.memberId)
    self:btn_PanelClose()
end

function this:PlayerDetailBtn()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionInfo/KLUnionInfoPanel")
    GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel", _, _, {
        isOther = true,
        rid = self.memberInfo.memberId,
        x = 0
    })
    self:btn_PanelClose()
end

function this:btn_PanelClose()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionMemberInfo/KLUnionMemberInfoPanel")
end

function this:ConfirmManageBtn()
    -- 1禅让盟主 2设为副盟主 3设为战斗队长 4设为精英 5设为成员
    if self.toggleSelect == 6 then
        if InfoManager.unionElectionInfo:UnionActivityIsOpen() then
            SL:TipMessage(SL:GetConfig("cfg_string",35002).text ,1, NoticeType.NoticeMid)
            return
        end
        SL:ReqKickOutUnionMemberMessage(self.memberInfo.memberId) -- 踢出战盟
    else
        if InfoManager.unionElectionInfo:UnionActivityIsOpen() then
            SL:TipMessage(SL:GetConfig("cfg_string",35002).text ,1, NoticeType.NoticeMid)
            return
        end
        SL:ReqChangePositionMessage(self.memberInfo.memberId, self.toggleSelect)
    end
    
    self:btn_PanelClose()
end

function this:Close()
end

return this

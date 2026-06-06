---@class KLBloodTipPanel:UIKmlLuaPanelBase
---@field view KLBloodTipPanelView
local KLBloodTipPanel = class(UIKmlLuaPanelBase)
local this =KLBloodTipPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if SL:HasConfig("cfg_npclist",tonumber(self.args),"id") then
        local rid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
        local isMeet = InfoManager.copActivityInfo.bloodTaskState ~= 0 and InfoManager.copActivityInfo.pickUpWeaponRid == tonumber(rid)
        if not isMeet then
            ---@type cfg_npclist_column
            local tbl = SL:GetConfig("cfg_npclist",tonumber(self.args),"id")
            GUI:Text_setString(self.view.ContentTxt1,tbl.content)
        else
           SL:CommonTipsMessage({
                showTips = "伟大的勇士，谢谢你帮我取回了武器! ",
                sureBtnText = "确定",
                cancelBtnText = "取消",
                ui = self,
                callback = self.OnClickOkBtn,
                cancelCallBack = self.OnClickCancelBtn,
                closeCallBack = self.OnClickCancelBtn,
            })
        end 
        GUI:setVisible(self.view.root2,not isMeet)
        -- GUI:setVisible(self.view.root1,isMeet)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    -- GUI:AddOnClickEvent(self.view.okBtn,self,self.OnClickOkBtn)
    -- GUI:AddOnClickEvent(self.view.cancelBtn,self,self.OnClickCancelBtn)
    GUI:AddOnClickEvent(self.view.cancelBtn1,self,self.OnClickCancelBtn)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnClickCancelBtn)
end

function this:OnClickOkBtn()
    if InfoManager.copActivityInfo.bloodTaskState == 1 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BLOODY_CASTLE_GIVE_NPC)
    end
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLBloodTip/KLBloodTipPanel")
end 

function this:OnClickCancelBtn()
   GUI:UIPanel_Close("dev/outui/Activity/Panel/KLBloodTip/KLBloodTipPanel") 
end

function this:Close()
    SL.ShowMainPanel()
end

return this

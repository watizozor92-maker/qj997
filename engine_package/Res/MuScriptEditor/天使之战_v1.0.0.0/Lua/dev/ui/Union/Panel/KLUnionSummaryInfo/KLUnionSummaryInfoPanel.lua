---@class KLUnionSummaryInfoPanel:UIKmlLuaPanelBase
---@field view KLUnionSummaryInfoPanelView
---@field unionInfo UnionProto.UnionDetailsInfo
local KLUnionSummaryInfoPanel = class(UIKmlLuaPanelBase)
local this =KLUnionSummaryInfoPanel
---创建时调用一次
function this:Init()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.unionId = self.args.unionId
    self.unionInfo = nil
    self.isSelfSend = true
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_DETAILS, self.unionId)
    --SL:ReqUnionDetailsMessage(self.unionId)
end

function this:RegistEvents()
    --SL:RegisterLUAEvent(LUA_EVENT_UNION_DETAIL, self.ResUnionDetailsMessage, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_DETAILS_INFO, self.ResUnionDetailsMessage, self)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
end

function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionJoin/KLUnionJoinPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionSummaryInfo/KLUnionSummaryInfoPanel")
end


---@param message UnionProto.UnionDetailsRes
function this:ResUnionDetailsMessage(id, message)
    --self.unionInfo = message.unionDetailsInfo
    if not self.isSelfSend then
        return
    end
    self.isSelfSend = false
    self.unionInfo = message
    
    GUI:Text_setString(self.view.name_text, self.unionInfo.unionName)
    GUI:Text_setString(self.view.exp_text_value, tostring(self.unionInfo.unionLevel))
    GUI:Text_setString(self.view.exp_num_value, string.format("%s/%s", self.unionInfo.memberNum, self.unionInfo.maxMemberNum or 100))
    GUI:Text_setString(self.view.exp_owner_value, self.unionInfo.masterName)
    GUI:Text_setString(self.view.union_content, self.unionInfo.announcement)
    GUI:Image_loadTexture(self.view.flag_img, string.format("Texture/log%s.png",self.unionInfo.unionArmband), "")
    GUI:Text_setText(self.view.Text_JoinCondition, self.unionInfo.needLevel > 1 and "申请等级限制："..self.unionInfo.needLevel or "")
    GUI:Text_setTextColor(self.view.Text_JoinCondition, SL:MeData_GetLevel() >= self.unionInfo.needLevel and "#00FF00" or "#FF0000")
end



function this:Close()
end

return this

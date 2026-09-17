---@class KLJoinInfoItem:UIKmlLuaPanelBase
---@field view KLJoinInfoItemView
---@field unionInfo UnionProto.UnionListInfo
---@field parent KLUnionJoinPanel
local KLJoinInfoItem = class(UIKmlLuaPanelBase)
local this =KLJoinInfoItem
---创建时调用一次
function this:Init()
    self.unionInfo = self.args.info
    self.parent = self.args.parent
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.union_name, self.unionInfo.unionName)
    GUI:Text_setString(self.view.union_level, tostring(self.unionInfo.unionLevel))
    GUI:Text_setString(self.view.union_num, string.format("%s/%s", self.unionInfo.unionNum, self.unionInfo.maxNum))
    self:RefreshStatus()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_DETAILS_INFO, self.RES_UNION_DETAILS_INFO, self)
    GUI:AddOnClickEvent(self.view.datalist_panel_btn_, self, self.datalist_panel_btn_)
    GUI:AddOnClickEvent(self.view.apply_to_join, self, self.apply_to_join)
end

function this:datalist_panel_btn_()
    if self.parent then
        self.parent:ChildOnClick(self)
    end
    self:SetChoiceBg(true)
    ---@type KLUnionSummaryInfoPanel
    local panel = GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionSummaryInfo/KLUnionSummaryInfoPanel", nil, nil, {unionId=self.unionInfo.unionId}, false)
end

function this:SetChoiceBg(val)
    GUI:SetActive(self.view.union_choice_bg_, val)
end

function this:apply_to_join()
    if InfoManager.loranSiegeInfo:GetIsOpen() then
        SL:TipMessage(SL:GetConfig("cfg_string",16005).text ,1, NoticeType.NoticeMid)
        return
    end
    self.isSelfSend = true
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_DETAILS, self.unionInfo.unionId)
    --SL.Union:ReqApplyJoinUnionMessage(self.unionInfo.unionId)
end

function this:SetStatus(status)
    self.unionInfo.state = status
    self:RefreshStatus()
end

function this:RefreshStatus()
    if self.unionInfo.state == 0 then
        --GUI:setVisible(self.view.btn_grey_bg, false)
        GUI:Text_setString(self.view.btn_text, "Apply")
       -- GUI:Text_setString(self.view.btn_text, "申请")
    elseif self.unionInfo.state == 1 then
        --GUI:setVisible(self.view.btn_grey_bg, true)
        GUI:Text_setString(self.view.btn_text, "Pending")
        --GUI:Text_setString(self.view.btn_text, "已申请")
    elseif self.unionInfo.state == 2 then
        --GUI:setVisible(self.view.btn_grey_bg, true)
        GUI:Text_setString(self.view.btn_text, "Full")
        --GUI:Text_setString(self.view.btn_text, "已满员")
    end
    GUI:Button_loadTextureNormal(self.view.apply_to_join, self.unionInfo.state == 0 and "btn_cebian2" or "btn_cebian1", "Atlas/FG_Common.spriteatlas")
end

function this:RES_UNION_DETAILS_INFO(_, message)
    if not self.isSelfSend then
        return
    end
    self.isSelfSend = false
    if SL:MeData_GetLevel() < message.needLevel then
        SL:TipMessage("不满足盟主设置的入盟条件", 1, NoticeType.NoticeMid)
        return
    end
    SL.Union:ReqApplyJoinUnionMessage(self.unionInfo.unionId)
end

function this:Close()
end

return this

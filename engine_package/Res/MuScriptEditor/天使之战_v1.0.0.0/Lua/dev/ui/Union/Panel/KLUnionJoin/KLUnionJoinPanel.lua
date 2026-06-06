---@class KLUnionJoinPanel:UIKmlLuaPanelBase
---@field view KLUnionJoinPanelView
---@field clickChild KLJoinInfoItem
local KLUnionJoinPanel = class(UIKmlLuaPanelBase)
local this =KLUnionJoinPanel
---创建时调用一次
function this:Init()
    self.unionList = {}
    self.unionPanel = {}
    self.clickChild = nil
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:ReqAllUnionMessage()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
    SL:RegisterLUAEvent(LUA_EVENT_UNION_ALL_INFO, self.ResAllUnionMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_ENTER_UNION, self.ResEnterUnionMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_APPLY_JOIN_UNION, self.ResApplyJoinUnionMessage, self)
    
    GUI:AddOnClickEvent(self.view.one_key_apply_to_join, self, self.one_key_apply_to_join)
end


function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionJoin/KLUnionJoinPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionSummaryInfo/KLUnionSummaryInfoPanel")
end

function this:one_key_apply_to_join()
    if InfoManager.loranSiegeInfo:GetIsOpen() then
        SL:TipMessage(SL:GetConfig("cfg_string",16005).text ,1, NoticeType.NoticeMid)
        return
    end
    SL:ReqAllApplyMessage()
end

---@param message UnionProto.AllUnionRes
function this:ResAllUnionMessage(id, message)
    if self.unionPanel then
        for unionId, panel in pairs(self.unionPanel) do
            GUI:UIPanel_Close(nil, panel)
        end    
    end
    self.unionPanel = {}
    
    self.unionList = message.unionListInfo
    for index, unionInfo in pairs(self.unionList) do
         GUI:UIPanel_Open("dev/ui/Union/Item/KLJoinInfo/KLJoinInfoItem", self.view.union_list_view, self, {info=unionInfo, parent=self}, true,
                function(_item)
                    if index == 1 then
                        _item:datalist_panel_btn_()
                    end
                    self.unionPanel[unionInfo.unionId] = _item
                end)
    end
end

---@param message UnionProto.ViewUnionRes
function this:ResEnterUnionMessage(_, message)
    self:closeBtn()
    GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel",nil,nil,{unionId = message.unionInfo.unionId})
end

function this:ChildOnClick(nowClickChild)
    if self.clickChild then
       self.clickChild:SetChoiceBg(false)
    end
    self.clickChild = nowClickChild
end

---@param message UnionProto.ApplyJoinUnionRes
function this:ResApplyJoinUnionMessage(id,message)
    local unionId = message.unionId
    local status = message.applyStatus
    ---@type KLJoinInfoItem
    local panel = self.unionPanel[unionId]
    if panel then
        panel:SetStatus(status)
    end
end

function this:Close()
end

return this

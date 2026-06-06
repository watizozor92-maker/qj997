---@class KLUnionElectionVotePanel:UIKmlLuaPanelBase
---@field view KLUnionElectionVotePanelView
---@field cfg cfg_unionLevel_column
local KLUnionElectionVotePanel = class(UIKmlLuaPanelBase)
local this =KLUnionElectionVotePanel
---创建时调用一次
function this:Init()
    self.level = self.args.unionLevel
    self.id = self.args.id
    self.cfg = SL:GetConfig("cfg_unionLevel", self.level, "unionLevel")
    self:SetNum(1)
    GUI:Text_setString(self.view.text2, string.format("为<color=#CFCF23>%s</color>投票", self.args.name))
    local own = SL:GetBagItemCount( self.cfg.voteCast[1])
    GUI:Text_setString(self.view.txtOwn, tostring(own))
    
    GUI:Item_UpdataData(self.view.itemCost, {
        ["itemid"] = self.cfg.voteCast[1]
    })
    GUI:Item_UpdataData(self.view.itemOwn, {
        ["itemid"] = self.cfg.voteCast[1]
    })
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnMinus, self, self.MinusOnClick)
    GUI:AddOnClickEvent(self.view.btnAdd, self, self.AddOnClick)
    GUI:AddOnClickEvent(self.view.btnCancel, self, self.BtnResetOnClick)
    GUI:AddOnClickEvent(self.view.btnConfirm, self, self.BtnConfirmOnClick)
    GUI:AddOnClickEvent(self.view.btnClose, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.btnMask, self, self.CloseSelf)
end

function this:MinusOnClick()
    self:SetNum(self.num - 1)
end

function this:AddOnClick()
    self:SetNum(self.num + 1)
end

function this:SetNum(num)
    if num < 1 then
        return
    end
    self.num = num
    local own = SL:GetBagItemCount( self.cfg.voteCast[1])
    GUI:Text_setString(self.view.txtNum, tostring(num))
    GUI:Text_setString(self.view.txtCost, string.format("<color=%s>%s</color>",
            own >= self.cfg.voteCast[2] and "#1BE419" or "#9b1818", num * self.cfg.voteCast[2]))
    
end

function this:BtnResetOnClick()
    self:SetNum(1)
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
end
    
function this:BtnConfirmOnClick()
    local own = SL:GetBagItemCount( self.cfg.voteCast[1])
    if own <  self.num * self.cfg.voteCast[2] then
        SL:CommonItemGetPath(nil, self.cfg.voteCast[1])
        SL:TipMessage(SL:GetConfig('cfg_string',269).text,1, NoticeType.NoticeMid)--"货币不足", 
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PLAYER_RUN_FOR_LEADER_VOTE, {
        self.id, self.num
    })
    self:CloseSelf()
end

function this:Close()
end

return this

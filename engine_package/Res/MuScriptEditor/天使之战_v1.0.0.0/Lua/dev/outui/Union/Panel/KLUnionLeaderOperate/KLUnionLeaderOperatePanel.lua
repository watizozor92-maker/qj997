---@class KLUnionLeaderOperatePanel:UIKmlLuaPanelBase
---@field view KLUnionLeaderOperatePanelView
local KLUnionLeaderOperatePanel = class(UIKmlLuaPanelBase)
local this =KLUnionLeaderOperatePanel

---创建时调用一次
function this:Init()
    self.typeStr = {
        [1] = "竞选",
        [2] = "弹劾",
        [3] = "取代",
    }
    self.type = self.args.type or 1
    self.isAgree = self.args.isAgree    --战盟弹劾 赞成票还是反对票
    local level = self.args.unionLevel --战盟等级
    --条件
    local tbl = SL:GetConfigTable("cfg_unionLevel")
    ---@type cfg_unionLevel_column
    local cfg = SL:GetConfig("cfg_unionLevel", level, "unionLevel")
    local condTbl
    local costTbl
    local checkCondTbl
    if self.type == EUnionLeaderOperateType.Election then
        condTbl = cfg.text
        costTbl = cfg.cast
        checkCondTbl = cfg.electionConditions
    elseif self.type == EUnionLeaderOperateType.Campaign then
        condTbl = cfg.campaignText
        costTbl = cfg.campaignCast
        checkCondTbl = cfg.campaignCondition
        if self.isAgree ~= nil then
            costTbl = cfg.campaignVoteCast
        end
    elseif self.type == EUnionLeaderOperateType.Replace then
        condTbl = cfg.replaceText
        costTbl = cfg.replaceCast
        checkCondTbl = cfg.replaceConditions
    end
    local green = "#00ff00"
    local red = "#9b1818"
    if condTbl and condTbl[1] then
        GUI:setVisible(self.view.txtCond1, true)
        local can = false
        if checkCondTbl then
            can = ConditionManager.Check(checkCondTbl)
        end
        GUI:Text_setString(self.view.txtCond1, string.format(condTbl[1], can and green or red))
    else
        GUI:setVisible(self.view.txtCond1, false)
    end
    if condTbl and condTbl[2] then
        GUI:setVisible(self.view.txtCond2, true)
        local can = false
        if checkCondTbl then
            can = ConditionManager.Check(checkCondTbl)
        end
        GUI:Text_setString(self.view.txtCond2, string.format(condTbl[2], can and green or red))
    else
        GUI:setVisible(self.view.txtCond2, false)
    end
    self.costTbl = costTbl
    self.checkCondTbl = checkCondTbl
    if costTbl and  costTbl[1] then
        GUI:setVisible(self.view.BgCost, true)
        local own = SL:GetBagItemCount(costTbl[1])
        GUI:Text_setString(self.view.textCost, string.format("<color=%s>%s</color>",
                own >= costTbl[2] and "#1BE419" or "#9b1818", costTbl[2]))
        GUI:Item_UpdataData(self.view.item17, {
            ["itemid"] = costTbl[1],
        })
    else
        GUI:setVisible(self.view.BgCost, false)
    end
    local str = self.typeStr[self.type]
    GUI:Text_setString(self.view.txtTitle, "盟主"..str)
    GUI:Text_setString(self.view.txtDesc, string.format("是否确定<color=#00ff00ff>%s</color>战盟盟主？", str))
    GUI:Text_setString(self.view.txtCondTitle, str.."条件：")
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnCancel, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.BtnMask, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.btnConfirm, self, self.ConfirmOnClick)
end

function this:ConfirmOnClick()
    --先判断消耗是否够
    local costTbl = self.costTbl
    local costEnough = true
    if costTbl and  costTbl[1] then
        local own = SL:GetBagItemCount(costTbl[1])
        costEnough = own >= costTbl[2]
    end
    if not costEnough then
        SL:CommonItemGetPath(nil, costTbl[1])
        SL:TipMessage(SL:GetConfig('cfg_string',269).text,1, NoticeType.NoticeMid)--"货币不足", 
        return
    end
    if self.checkCondTbl then
        if not ConditionManager.Check(self.checkCondTbl) then
            SL:TipMessage(SL:GetConfig('cfg_string',284).text,1, NoticeType.NoticeMid)--"条件不满足", 
            return
        end
    end
    if self.type == EUnionLeaderOperateType.Campaign then
        if self.isAgree == nil then
            --弹劾协议
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_IMPEACH_LEADER)
        else
            --弹劾投票协议
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_IMPEACH_VOTE, self.isAgree and 1 or 0)
        end
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PLAYER_RUN_FOR_LEADER)
    end
    self:CloseSelf()
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
end

function this:Close()
end

return this

---@class KLKaLiMaSweepPanel:UIKmlLuaPanelBase
---@field view KLKaLiMaSweepPanelView
local KLKaLiMaSweepPanel = class(UIKmlLuaPanelBase)
local this = KLKaLiMaSweepPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.reward_all_item = {}
    GUI:DataListInitData(self.view.rewardList, function()
        return self:RewardDataListItemCountFunc()
    end, function(realIndex)
        return self:RewardDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlCtrl)
        return self:RewardDataListItemInitFunc(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:RewardDataListItemUpdateFunc(realIndex, kmlCtrl)
    end)

end
function this:RewardDataListItemCountFunc()
    return #self.rewardData
end

function this:RewardDataListItemGetFunc(realIndex)

end

function this:RewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local reward = self.rewardData[realIndex + 1]
    local pass_reward = GUI:GetChildControl(self.view.rewardList, realIndex, 'item1')
    local img_pass_reward_click = GUI:GetChildControl(self.view.rewardList, realIndex, 'img_pass_reward_click')
    GUI:Item_setItemId(pass_reward, reward[1])
    GUI:Item_UpdataData(pass_reward, { itemcount = reward[2] })
    GUI:AddOnClickEvent(img_pass_reward_click, self, self.ShowItemTips, reward[1])
end
function this:ShowItemTips(_, id)
    SL:OpenTips(nil, id)
end

function this:ShowTicketTips()
    if self.args and self.args.deplete[1] then
        SL:OpenTips(nil, self.args.deplete[1])
    end
end

function this:ShowExtraTicketTips()
    if self.args and self.args.extra[1] then
        SL:OpenTips(nil, self.args.extra[1])
    end
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_sweepClose, self, self.OnClickCloseSweepBtn)
    GUI:AddOnClickEvent(self.view.btn_ticketGet, self, self.OnClickAddCountBtn)
    GUI:AddOnClickEvent(self.view.sweepBtn, self, self.OnClickSweepBtn)
    GUI:AddOnClickEvent(self.view.ticketItem, self, self.ShowTicketTips)
    GUI:AddOnClickEvent(self.view.img_extraSweepItemItem, self, self.ShowExtraTicketTips)
    SL:RegisterLuaNetMsg(MessageDef.ResBagChangeMessage, self.Refresh,self)
end
function this:OnClickCloseSweepBtn()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLKaLiMaSweep/KLKaLiMaSweepPanel")
end
function this:OnClickAddCountBtn()
    if self.args then
        SL:CommonItemGetPath(nil, self.args.extra[1])
    end
end
function this:OnClickSweepBtn()
    local isCurCrossServerMap = SL:GetConfig("cfg_map_info", SL:GetMetaValue(EMetaVarGetKey.MAP_ID)).serverType == 2
    if isCurCrossServerMap then
        SL:TipMessage("请返回本服参与副本活动", 1, NoticeType.NoticeMid)
        return
    end
    if self.args then
        if self.args.sweepTime <= 0 then
            SL:TipMessage( "剩余次数不足", 1, NoticeType.NoticeMid )
        else
            if self.IsCanSweep then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SWEEP_THROUGH_DUNGEONS, { self.args.nowSelectLevelId, 1 })
            else
                SL:TipMessage("门票不足", 1, NoticeType.NoticeMid)
            end
        end
    end
    -- GUI:UIPanel_Close("dev/outui/Activity/Panel/KLKaLiMaSweep/KLKaLiMaSweepPanel")
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        --[[        sweepTime = self.args.sweepTime
                level = self.args.level
                deplete = self.args.deplete
                extra = self.args.extra
                drop = self.args.drop]]

        self.rewardData = self.args.drop
        GUI:DataListUpdateData(self.view.rewardList)
        local cost = SL:GetBagItemCount(self.args.deplete[1])
        local text
        self.IsCanSweep = true
        if cost >= self.args.deplete[2] then
            text = "<color=#1ADD1F>" .. cost .. "</color>"
        else
            text = "<color=#FF2323>" .. cost .. "</color>"
            self.IsCanSweep = false
        end
        GUI:Text_setString(self.view.ticketCount, text .. "/" .. self.args.deplete[2])
        GUI:Item_setItemId(self.view.ticketItem, self.args.deplete[1])
        local cost2 = SL:GetBagItemCount(self.args.extra[1])
        local text2
        if cost2 >= self.args.extra[2] then
            text2 = "<color=#1ADD1F>" .. cost2 .. "</color>"
        else
            text2 = "<color=#FF2323>" .. cost2 .. "</color>"
            self.IsCanSweep = false
        end
        GUI:Text_setString(self.view.lab_sweepExtraAlready, text2 .. "/" .. self.args.extra[2])
        GUI:Item_setItemId(self.view.img_extraSweepItemItem, self.args.extra[1])
        GUI:Text_setString(self.view.countTxt, tostring(self.args.sweepTime))
        GUI:Text_setString(self.view.level, tostring(self.args.level))
    end
end

function this:Hide()
end

function this:Close()

end

return this

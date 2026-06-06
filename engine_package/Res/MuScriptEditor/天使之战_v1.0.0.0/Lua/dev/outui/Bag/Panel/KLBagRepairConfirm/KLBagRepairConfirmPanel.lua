---@class KLBagRepairConfirmPanel:UIKmlLuaPanelBase
---@field view KLBagRepairConfirmPanelView
local KLBagRepairConfirmPanel = class(UIKmlLuaPanelBase)
local this =KLBagRepairConfirmPanel

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CancelOnClick)
    GUI:AddOnClickEvent(self.view.btn_tog, self, self.ClickToggle)
    GUI:AddOnClickEvent(self.view.btn_sure, self, self.SureOnClick)
    GUI:AddOnClickEvent(self.view.btn_cancel, self, self.CancelOnClick)
    
    SL:RegisterLUAEvent(LUA_EVENT_AUTO_PAIR_STATE_CHANGE, self.LUA_EVENT_AUTO_PAIR_STATE_CHANGE, self)
end

function this:LUA_EVENT_AUTO_PAIR_STATE_CHANGE()
    GUI:SetActive(self.view.img_select, PrivilegeCardManager.AutoRepair)
end

function this:ClickToggle()
    if PrivilegeCardManager.isAutoRepairOpen() then
        self.autoRepair = not self.autoRepair
        GUI:SetActive(self.view.img_select, self.autoRepair)
    else
        SL:OpenCommonTipPanelById(25)
        GUI:UIPanel_Close(self.filePath)
    end
end

function this:SureOnClick()
    if self.autoRepair ~= PrivilegeCardManager.AutoRepair then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_AUTO_REPAIR)
    end
    local ownMoney = SL:GetBagItemCount(self.moneyId)
    if ownMoney < self.totalPrice then
        SL:CommonItemGetPath(nil, self.moneyId)
        SL:TipMessage("消耗不足", 1, NoticeType.NoticeMid)
        return
    end
    local list = self.list
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_REPAIR, {itemId = list})
    GUI:UIPanel_Close(self.filePath)
end

function this:CancelOnClick()
    GUI:UIPanel_Close(self.filePath)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    local id = tonumber(SL:GetConfig("cfg_global", 320009).value)
    self.moneyId = id
    local moneyCfg = SL:GetConfig("cfg_item", id)
    self.totalPrice = self.args.totalPrice
    local showTips = string.format("本次修理需要%s%s\n\n<color=#FF2323>装备耐久为0时将失效</color>", moneyCfg.name, self.totalPrice)
    GUI:Text_setString(self.view.tipsContent, showTips)
    self.list = self.args.list
    self.autoRepair = PrivilegeCardManager.AutoRepair
    GUI:SetActive(self.view.img_select, PrivilegeCardManager.AutoRepair)
end

function this:Hide()
end

function this:Close()
end

return this

---@class KLUIMasterTalentWashUpPanel:UIKmlLuaPanelBase
---@field view KLUIMasterTalentWashUpPanelView
local KLUIMasterTalentWashUpPanel = class(UIKmlLuaPanelBase)
local this =KLUIMasterTalentWashUpPanel
---创建时调用一次
function this:Init()
    GUI:SetImageNativeSize(self.view.title)

    if self.args and self.args.type then
        if self.args.type == EMasterTalentType.CAREER then
            GUI:Text_setString(self.view.Text,"将把全部职业天赋重置为0级。\n并重新获得已消耗的所有职业天赋点。\n职业天赋等级不受影响。")
            GUI:Text_setString(self.view.Text2,"职业天赋等级不受影响。")
            GUI:SetActive(self.view.img4,true)
            self:GetCoinInfo(4002)
        elseif self.args.type == EMasterTalentType.SKILL then
            GUI:Text_setString(self.view.Text,"将把全部强化天赋重置为0级。\n并重新获得已消耗的所有强化天赋点。")
            GUI:Text_setString(self.view.Text2,"")
            GUI:SetActive(self.view.img4,false)
            self:GetCoinInfo(4007)
        elseif self.args.type == EMasterTalentType.COMMON then
            GUI:Text_setString(self.view.Text,"将把全部通用天赋重置为0级。\n并重新获得已消耗的所有通用天赋点。")
            GUI:Text_setString(self.view.Text2,"")
            GUI:SetActive(self.view.img4,false)
            self:GetCoinInfo(4011)
        end
    end
end

---获取货币信息
function this:GetCoinInfo(id)
    local cfg = SL:GetConfig("cfg_global",id)
    local strArr = string.split(cfg.value,'#')
    self.costID = tonumber(strArr[1])
    GUI:Item_setItemId(self.view.CostItem,self.costID)
    self.costCount = tonumber(strArr[2])
    self:RefreshCoinText()
end

---刷新货币信息
function this:RefreshCoinText()
    local color = SL:GetBagItemCount(self.costID) >= self.costCount and "#00ff00" or "#ff2323"
    GUI:Text_setString(self.view.textCost,"<color="..color..">"..self.costCount.."</color>")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton,self,self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.MaskCloseButton,self,self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.CancelButton,self,self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.OkButton,self,self.OnClickOkButton)
    GUI:AddOnClickEvent(self.view.CostItem,self,self.OnClickItemShowTips)

    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.CoinInfo_Change,self)
end

function this:OnClickItemShowTips()
    if not self.costID then
        return
    end
    SL:OpenTips(nil,self.costID)
end

function this:CoinInfo_Change(_,message)
    self:RefreshCoinText()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/outui/MasterTalent/Panel/KLUIMasterTalentWashUp/KLUIMasterTalentWashUpPanel")
end

function this:OnClickOkButton()
    if SL:GetBagItemCount(self.costID) < self.costCount then
        SL:TipMessage( SL:GetConfig('cfg_string',269).text,1, NoticeType.NoticeMid )--"货币不足！", 
        return
    end
    if self.args.series then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RESET_MASTER,{type = self.args.type,series = self.args.series})
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RESET_MASTER,{type = self.args.type})
    end

    self:OnClickCloseButton()
end

function this:Close()
end

return this

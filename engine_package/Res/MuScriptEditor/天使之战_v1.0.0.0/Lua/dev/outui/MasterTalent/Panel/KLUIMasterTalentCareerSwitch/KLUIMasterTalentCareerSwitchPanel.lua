---@class KLUIMasterTalentCareerSwitchPanel:UIKmlLuaPanelBase
---@field view KLUIMasterTalentCareerSwitchPanelView
local KLUIMasterTalentCareerSwitchPanel = class(UIKmlLuaPanelBase)
local this =KLUIMasterTalentCareerSwitchPanel
---创建时调用一次
function this:Init()
    GUI:SetImageNativeSize(self.view.Title)
    GUI:SetImageNativeSize(self.view.img6)
    GUI:SetImageNativeSize(self.view.img7)
    GUI:SetActive(self.view.LeftConsume,not(self.args and self.args.isFirst))
    GUI:SetActive(self.view.LeftText,self.args and self.args.isFirst)
    self.series = self.args.series
    self.type = self.args.type
    self:GetCoinInfo()
    self:RefreshCoinText()
end

---获取货币信息
function this:GetCoinInfo()
    local cfg = SL:GetConfig("cfg_global",4001)
    local strArr = string.split(cfg.value,'#')
    self.costID = tonumber(strArr[1])
    GUI:Item_setItemId(self.view.ConsumeItem,self.costID)
    self.costCount = tonumber(strArr[2])
end

---刷新货币信息
function this:RefreshCoinText()
    local color = SL:GetBagItemCount(self.costID) >= self.costCount and "#00ff00" or "#ff2323"
    GUI:Text_setString(self.view.ConsumeText,"<color="..color..">"..self.costCount.."</color>")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton,self,self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.MaskCloseButton,self,self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.LeftButton,self,self.OnClickLeftButton)
    GUI:AddOnClickEvent(self.view.RightButton,self,self.OnClickRightButton)
    GUI:AddOnClickEvent(self.view.ConsumeItem,self,self.OnClickItemShowTips)
    
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

function this:OnClickLeftButton()
    if not self.args.isFirst and SL:GetBagItemCount(self.costID) < self.costCount then
        SL:TipMessage(SL:GetConfig('cfg_string',269).text,  1, NoticeType.NoticeMid )--"货币不足！",
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OPEN_MASTER_TYPE,{series = self.series,type = self.type})
    self:OnClickCloseButton()
end

function this:OnClickRightButton()
    --GUI:UIPanel_Close("dev/outui/MasterTalent/Panel/KLUIMasterTalentMain/KLUIMasterTalentMainPanel")
    --self:OnClickCloseButton()
    --GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/outui/MasterTalent/Panel/KLUIMasterTalentCareerSwitch/KLUIMasterTalentCareerSwitchPanel")
end

function this:Close()
end

return this

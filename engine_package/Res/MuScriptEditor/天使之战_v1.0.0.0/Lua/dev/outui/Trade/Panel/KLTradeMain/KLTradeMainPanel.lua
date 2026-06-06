---@class KLTradeMainPanel:UIKmlLuaPanelBase
---@field view KLTradeMainPanelView
local KLTradeMainPanel = class(UIKmlLuaPanelBase)
local this =KLTradeMainPanel
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.scoreBtn,self,self.ShowMoneyTips,10240001)
    GUI:AddOnClickEvent(self.view.btn_qj_tip,self,self.ShowMoneyTips,10010001)
    
    GUI:SetToggleOnValueChange(self.view.toggle_trade_home,self,self.ToggleTradeHomeOnValueChange)
    GUI:SetToggleOnValueChange(self.view.toggle_trade_record,self,self.ToggleTradeRecordOnValueChange)
    GUI:SetToggleOnValueChange(self.view.toggle_trade_union,self,self.ToggleTradeUnionOnValueChange)
    GUI:SetToggleOnValueChange(self.view.toggle_trade_my_up,self,self.ToggleTradeMyOnValueChange)
    GUI:SetToggleOnValueChange(self.view.toggle_month_card,self,self.ToggleTradeMonthCardValueChange)
    GUI:SetToggleOnValueChange(self.view.toggle_trade_CrossServer,self,self.ToggleTradeCrossServerValueChange)
    
   	SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE,self.RefreshMoneyCount,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WAR_ALLIANCE_SHOW_AUCTION_PANEL,self.RES_WAR_ALLIANCE_SHOW_AUCTION_PANEL,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_TRADE_INFO,self.OnGetRechargeTradeInfo,self)
end

---@param message recharge
function this:OnGetRechargeTradeInfo(_,message)
    if not message then
        return
    end
    --GUI:SetActive(self.view.img_cost_tips,true)
    local curCount = message.upperLimit - message.cost
    local color
    if curCount * 2 >= message.upperLimit then
        color = "#00ff00"
    else
        color = "#ff2323"
    end
    GUI:Text_setString(self.view.text_cost_tips,string.format("当日额度：<color=%s>%d</color>/%d",color,curCount,message.upperLimit))
end

function this:RES_WAR_ALLIANCE_SHOW_AUCTION_PANEL(_,message)
    GUI:setVisible(self.view.toggle_trade_union,message["1"])
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:RefreshMoneyCount()
    local jumpTab = self.args
    if jumpTab then
        GUI:setVisible(self.view[jumpTab],true)
        GUI:Toggle_setIsOn(self.view[jumpTab],true)
    else
        GUI:SetIsOnWithoutNotify(self.view.toggle_trade_home,true)
        self:ToggleTradeHomeOnValueChange(nil,nil,{true})
    end

    GUI:setVisible(self.view.toggle_trade_CrossServer,InfoManager.copActivityInfo.isShowCrossServerTrade)
    SL.HideMainPanel()
    
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WAR_ALLIANCE_HAS_QUALIFY)
    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_TRADE_INFO)

    if InfoManager.kundunInfo:KunDunTrade_IsOpen() then
        GUI:setVisible(self.view.toggle_trade_CrossServer,true)
    else
        GUI:setVisible(self.view.toggle_trade_CrossServer,false)
    end
end

function this:RefreshMoneyCount()
    local money_infoTbl = string.split(SL:GetConfig("cfg_global",270012).value,'|')
    local scoreCount = 0
    local qjCount = 0
    local icon1 = "jifen"
    local icon2 = "jifen"
    if money_infoTbl then
        local money_info1 = string.split(money_infoTbl[1],'#')
        if money_info1 then
            icon1 = SL:GetConfig("cfg_item", tonumber(money_info1[1])).looks
            self.ShowMoneyId1 = tonumber(money_info1[1])
            for i,v in pairs(money_info1) do
                scoreCount = scoreCount + SL:GetBagItemCount(tonumber(v), false)
            end
        end

        local money_info2 = string.split(money_infoTbl[2],'#')
        if money_info2 then
            for i,v in pairs(money_info2) do
                qjCount = qjCount + SL:GetBagItemCount(tonumber(v), false)
            end
            self.ShowMoneyId2 = tonumber(money_info2[1])
            icon2 = SL:GetConfig("cfg_item", tonumber(money_info2[1])).looks
        end
        
    end
    GUI:Image_loadTexture(self.view.img2, icon1,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    GUI:Image_loadTexture(self.view.img_53, icon2,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    GUI:Text_setString(self.view.scoreCount,tostring(scoreCount))
    GUI:Text_setString(self.view.txt_qj_count,tostring(qjCount))
end

function this:Close()
    SL:onLUAEvent(LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE)
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel")
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeRecord/KLTradeRecordPanel")
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeSales/KLTradeSalesPanel")
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeMonthCard/KLTradeMonthCardPanel")
    SL.ShowMainPanel()
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel")
end

function this:ShowMoneyTips(_,data)
    if data == 10240001  then
        SL:CommonItemGetPath(nil,self.ShowMoneyId1,nil,nil,self)
    end
    if data == 10010001  then
        -- SL:OpenTips(nil,self.ShowMoneyId2,nil,nil,nil)
        SL:CommonItemGetPath(nil,self.ShowMoneyId2,nil,nil,self)
    end
    
end

function this:ToggleTradeHomeOnValueChange(_,_,c)
    if c[1] then
        if not GUI:GetUI("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel") then
            GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel",nil,nil,1)
        end
    else
        GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel")
    end
    self.selectToggle = c
    GUI:SetActive(self.view.img_line,c[1])
end

function this:ToggleTradeRecordOnValueChange(_,_,c)
    if c[1] then
        if not GUI:GetUI("dev/outui/Trade/Panel/KLTradeRecord/KLTradeRecordPanel") then
            GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeRecord/KLTradeRecordPanel")
        end
    else
        GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeRecord/KLTradeRecordPanel")
    end
end

function this:ToggleTradeUnionOnValueChange(_,_,c)
    if c[1] then
        if not GUI:GetUI("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel") then
            GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel",nil,nil,2)
        end
    else
        GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel")
    end
end

function this:ToggleTradeMyOnValueChange(_,_,c)
    if c[1] then
        if not GUI:GetUI("dev/outui/Trade/Panel/KLTradeSales/KLTradeSalesPanel") then
            GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeSales/KLTradeSalesPanel")
        end
    else
        GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeSales/KLTradeSalesPanel")
    end
end

function this:ToggleTradeMonthCardValueChange(_,_,c)
    if c[1] then
        if not GUI:GetUI("dev/outui/Trade/Panel/KLTradeMonthCard/KLTradeMonthCardPanel") then
            GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeMonthCard/KLTradeMonthCardPanel")
        end
    else
        GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeMonthCard/KLTradeMonthCardPanel")
    end
end

function this:ToggleTradeCrossServerValueChange(_,_,c)
    if c[1] then
        if not GUI:GetUI("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel") then
            GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel",nil,nil,3)
        end
    else
        GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel")
    end
end

return this

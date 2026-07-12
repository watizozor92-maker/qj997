---@class KLShopMainPanel:UIKmlLuaPanelBase
---@field view KLShopMainPanelView
local KLShopMainPanel = class(UIKmlLuaPanelBase)
local this =KLShopMainPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    --print ("123")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.tog_shop, self, self.ShopToggle)
    GUI:SetToggleOnValueChange(self.view.tog_recharge, self, self.RechargeToggle)
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseBtnOnClick)
end
function this:ShopToggle(control,_)
    if GUI:Toggle_getIsOn(control) == "1" then
        local param 
        if self.lightItems then
            param = {[1] = self.Page, lightItems = self.lightItems}   
        else
            param = self.Page
        end
        GUI:UIPanel_Open("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel",_,_, param)
        if GUI:GetUI("dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel") then
            GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel")
        end
    end
end
function this:RechargeToggle(control,_)
    if GUI:Toggle_getIsOn(control) == "1" then
        self.Page = nil
        --GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel")
        GUI:UIPanel_Open("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel",_,_, 999)
        --[[GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel",_,_,nil,false,function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, {type=1, action="panel"})
        end)]]

        SL:HideMainPanel()
    end
end
function this:CloseBtnOnClick()
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel")
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        local togNum = 1
        local type = type(self.args)
        if type == 'number' then--只跳转到对应页签
            togNum = self.args
        else--跳转到对应页签下的子页签（比如商城下面的某个页签）
            togNum = tonumber(self.args[1])
            self.Page = tonumber(self.args[2])
            self.lightItems = self.args[3]
        end
        if togNum == 1 then
            GUI:Toggle_setIsOn(self.view.tog_shop,true)
        elseif togNum == 2 then
            GUI:SetTogDefaultThis(self.view.tog_recharge)
            --GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel")
            --[[GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel",nil,nil,nil,false,function()
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, {type=1, action="panel"})
            end)
            SL:HideMainPanel()]]
        else
            GUI:Toggle_setIsOn(self.view.tog_shop,true)
        end
        
    else
        GUI:Toggle_setIsOn(self.view.tog_shop,true)
    end
    
end

function this:CloseAllSubPanel()
    --GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel")
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLzhigou/KLzhigouPanel")
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel")
    GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel")
end

function this:Close()
    self:CloseAllSubPanel()
    SL:ShowMainPanel()
end

return this
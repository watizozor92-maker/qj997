---@class KLOnHookPanel:UIKmlLuaPanelBase
---@field view KLOnHookPanelView
local KLOnHookPanel = class(UIKmlLuaPanelBase)
local this =KLOnHookPanel
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLOnHookPanel",true)
    InfoManager.uiHookInfo:SetNewMapRedClicked()
    SL:RefreshPanelALLRedPoint("KLOnHookPanel")
    SL.HideMainPanel()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if SL:GetIsWebGL() then
        GUI:setPositionX(self.view.closeBtn,-495)
    end
    self.isShowSettlementPanel = false
    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLSettlement/KLSettlementPanel")
    if panel then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLSettlement/KLSettlementPanel")
        self.isShowSettlementPanel = true
    end
--[[    self.isShowSettleRedPanel = false
    if GUI:GetUI("dev/outui/Activity/Panel/KLRedFortSettlement/KLRedFortSettlementPanel") then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLRedFortSettlement/KLRedFortSettlementPanel")
        self.isShowSettleRedPanel = true
    end]]
    --[[local tbl = SL:GetConfig("cfg_global", 6002)
    --local needLv = tonumber(tbl.value)
    --local myLv = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    --GUI:setVisible(self.view.HookInfoToggle, tonumber(myLv) >= needLv)]]
    --默认跳转挂机点页签
    local default = "HookPointToggle"
    if self.args then
        local monsterId = self.args.monsterId
        if not monsterId then
            default = self.args
        end
    end
    if self.view[default] then
        --self.view[default]:SetTogDefaultThis()
        GUI:SetTogDefaultThis(self.view[default])
    else
        --self.view.HookPointToggle:SetTogDefaultThis()
        GUI:SetTogDefaultThis(self.view.HookPointToggle)
    end
    GUI:Text_setTextColor(self.view.txt_monthCard,PrivilegeCardManager.isOfflineHookOpen() and
            "#00ff00" or "#FF2323")
    GUI:Text_setString(self.view.txt_monthCard, PrivilegeCardManager.isOfflineHookOpen() and 
            "<color=#00ff00>已开通离线挂机特权</color>" or "<color=#FF2323>点我开启离线挂机特权</color>")
    
    GUI:setVisible(self.view.img_red, not PrivilegeCardManager.isOfflineHookOpen())
    GUI:setVisible(self.view.img_green, PrivilegeCardManager.isOfflineHookOpen())
    if self.args then
        local monsterId = self.args.monsterId
        if monsterId then
            self:SelectToShowMonster(monsterId)
        end
    end
end

function this:GuideToShowMonster(mapMoveId,MonsterId)
    GUI:SetTogDefaultThis(self.view.HookPointToggle)
    if self.hookPointsItem then
        self.hookPointsItem:GuideToShowMonster(mapMoveId,MonsterId)
    else
        SL:LogError("挂机item没打开")
    end
end

function this:SelectToShowMonster(monsterId)
    GUI:UIPanel_Open("dev/outui/Hook/Item/KLHookPoint/KLHookPointItem"
    , self.view.root_hookPoints, self, {monsterId=monsterId}, nil, function(item)
                self.hookPointsItem = item
            end)
end


---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:SetToggleOnValueChange(self.view.HookInfoToggle,self,self.HookInfoToggle)
    GUI:SetToggleOnValueChange(self.view.HookPointToggle,self,self.HookPointToggle)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnClickCloseBtn)
    GUI:AddOnClickEvent(self.view.btnSetting, self, self.OnClickBtnSetting)
    GUI:AddOnClickEvent(self.view.btn_monthCard, self, self.OnClickMonthCard)
end

function this:HookInfoToggle(control,_,data)
    local isToggle = data[1]
    GUI:setVisible(self.view.root_hookInfos, isToggle)
    if isToggle then
        GUI:setVisible(self.view.root_hookPoints, false)
        if self.hookInfoItem then
            return
        end
        GUI:UIPanel_Open("dev/outui/Hook/Item/KLOffHookInfo/KLOffHookInfoItem"
            ,self.view.root_hookInfos, self, nil, nil, function(item)
                    self.hookInfoItem = item
                end)
    else
        GUI:UIPanel_Close("dev/outui/Hook/Item/KLOffHookInfo/KLOffHookInfoItem")
        self.hookInfoItem = nil
    end
end

function this:HookPointToggle(control,_,data)
    local isToggle = data[1]
    GUI:setVisible(self.view.root_hookPoints, isToggle)
    if isToggle then
        GUI:setVisible(self.view.root_hookInfos, false)
        if self.hookPointsItem then
            return
        end
        GUI:UIPanel_Open("dev/outui/Hook/Item/KLHookPoint/KLHookPointItem"
            ,self.view.root_hookPoints, self, nil, nil, function(item)
                    self.hookPointsItem = item
                end)
    else
        GUI:UIPanel_Close("dev/outui/Hook/Item/KLHookPoint/KLHookPointItem")
        self.hookPointsItem = nil
    end
end

function this:OnClickCloseBtn()
    GUI:UIPanel_Close(self.filePath)
end

function this:OnClickBtnSetting()
    GUI:UIPanel_Close(self.filePath)
    --GUI:UIPanel_Open("dev/ui/Setting/Panel/KLSettingToggle/KLSettingTogglePanel", _, _, ESettingType.OnHookTog)
    GUI:UIPanel_Open("dev/outui/Hook/Panel/KLHookHelp/KLHookHelpPanel")
end

function this:OnClickMonthCard()
    GUI:UIPanel_Close(self.filePath)
    GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel")
end

function this:Close()
    if self.isShowSettlementPanel then
        GUI:UIPanel_Open("dev/outui/Activity/Panel/KLSettlement/KLSettlementPanel",nil,nil,InfoManager.copActivityInfo.ShowSettlementPanelArgs)
    end
--[[    if self.isShowSettleRedPanel then
        GUI:UIPanel_Open("dev/outui/Activity/Panel/KLRedFortSettlement/KLRedFortSettlementPanel")
    end]]
    SL:KeepOpenPanel("KLOnHookPanel",false)
    GUI:UIPanel_Close("dev/outui/Hook/Item/KLOffHookInfo/KLOffHookInfoItem")
    self.hookInfoItem = nil
    GUI:UIPanel_Close("dev/outui/Hook/Item/KLHookPoint/KLHookPointItem")
    self.hookPointsItem = nil
    SL:ShowMainPanel()
end

return this

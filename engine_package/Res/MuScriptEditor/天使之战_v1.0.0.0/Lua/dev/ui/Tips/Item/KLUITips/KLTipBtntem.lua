---@class KLTipBtntem:UIKmlLuaPanelBase
---@field view KLTipBtntemView
local KLTipBtntem = class(UIKmlLuaPanelBase)
local this = KLTipBtntem
---创建时调用一次
function this:Init()
    GUI:Button_setTitleText(self.view.button_id, self.args.nameStr)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.button_id, self, self.BtnOnClick)
end

function this:BtnOnClick()
    if not InfoManager.equipOrItemTipsInfo:IsCanOnClickButton(self.args.btnType) then
        return
    end
    if self.args.btnType[1] == "0" then
        self:CloseEquipTips()
    elseif self.args.btnType[1] == "1" then
        self:UseItem()
    elseif self.args.btnType[1] == "2" then
        self:RecycleItem()
    elseif self.args.btnType[1] == "3" then
        self:PutOneEquip()
    elseif self.args.btnType[1] == "4" then
        self:Strength()
    elseif self.args.btnType[1] == "5" then
        self:OpenTrade()
    elseif self.args.btnType[1] == "7" then
        self:SplitItem()
    elseif self.args.btnType[1] == "9" then
        local name = SL:GetEquipValue(EMetaVarGetKey.EQUIP_NAME, self.args.equip_pos, self.args.cfgId, self.args.id)
        SL:CommonTipsMessage({
            showTips = "是否摧毁" .. name,
            ui = self,
            sureBtnText = "确定",
            cancelBtnText = "取消",
            zindex = GUI:GetNearCanvasZindex(self.view.root) + 10,
            z = -6000,
            callback = self.DestroyItem
        })
    elseif self.args.btnType[1] == "10" then
        self:JieFeng()
    elseif self.args.btnType[1] == "11" then
        self:DiuQi()
    elseif self.args.btnType[1] == "13" then
        self:Decompose()
    elseif self.args.btnType[1] == "99" then
        self:OpenPanel()
    elseif self.args.btnType[1] == "100" then
        self:FixEquipClick()
    end
end

function this:FixEquipClick()
    local panel = GUI:GetUI("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    if panel then
        panel:FixEquipClick()
    end
    self:CloseEquipTips()
end

function this:RecycleItem()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    SL:HideAllKmlPanel()
    GUI:UIPanel_Open("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
    self:CloseEquipTips()
end

function this:CloseEquipTips()
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTipsComparsion/KLUIEquipTipsComparsionPanel")
end

function this:PutOneEquip()
    local ItemInfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    SL:PutOnEquip(ItemInfo)
    self:CloseEquipTips()
end

function this.DestroyItem(returnData)
    local ui = returnData.ui
    local index = SL:GetBagIndex(ui.args.id)
    SL:ReqDestroyItemMessage(index)
    ui:CloseEquipTips()
end

function this:JieFeng()
    self:CloseEquipTips()
end

function this:DiuQi()
    local index = SL:GetBagIndex(self.args.id)
    SL:ReqGiveUpItemMessage(index)
    self:CloseEquipTips()
end

function this:Decompose()
    self:CloseEquipTips()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    SL:HideAllKmlPanel()
    SL:OpenForgeGroupUI(EForgeGroupType.Decompose)
end

function this:Strength()
    self:CloseEquipTips()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    SL:HideAllKmlPanel()
    SL:OpenForgeGroupUI(EForgeGroupType.Strength)
end

function this:UseItem()
    SL:UseItem(self.args.cfgId, self.args.id, self.args.count)
    self:CloseItemTips()
end

function this:OpenPanel()
    if #self.args.btnType < 3 then
        return
    end
    self:CloseEquipTips()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    SL:HideAllKmlPanel()
    local panel = self.args.btnType[4]
    if #self.args.btnType == 4 then
        GUI:UIPanel_Open(panel)
    elseif #self.args.btnType == 5 then
        local num = self.args.btnType[5]
        if tonumber(num) then
            num = tonumber(num)
        end
        GUI:UIPanel_Open(panel, nil, nil, num)
    elseif #self.args.btnType >= 7 then
        local message = {}
        for i = 5, #self.args.btnType - 2, 3 do
            if self.args.btnType[i] and self.args.btnType[i + 1] and self.args.btnType[i + 2] then
                if self.args.btnType[i + 1] == "string" then
                    message[self.args.btnType[i]] = self.args.btnType[i + 2]
                else
                    message[self.args.btnType[i]] = tonumber(self.args.btnType[i + 2])
                end
            end
        end
        GUI:UIPanel_Open(panel, nil, nil, message)
    end
    SL.HideMainPanel()
end

function this:SplitItem()
    GUI:UIPanel_Open("dev/outui/Bag/Panel/KLItemSplit/KLItemSplitPanel", nil, nil,
        { cfgId = self.args.cfgId, id = self.args.id, count = self.args.count })
    self:CloseEquipTips()
end

---打开交易行
function this:OpenTrade()
    GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel")
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel")
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel", nil, nil, "toggle_trade_my_up")
    self:CloseEquipTips()
end

function this:Close()
end

return this
